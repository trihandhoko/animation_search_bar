library animation_search_bar;

import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope, StateProvider, Consumer;

final searchingProvider = StateProvider.autoDispose((ref) => false);

// ignore: must_be_immutable
class AnimationSearchBar extends StatelessWidget {
  AnimationSearchBar({
    Key? key,
    this.searchBarWidth,
    this.searchBarHeight,
    this.previousScreen,
    this.backIconColor,
    this.actionIconColor,
    this.closeIconColor,
    this.searchIconColor,
    this.pageTitlePosition,
    this.pageTitle,
    this.pageTitleStyle,
    this.searchFieldHeight,
    this.searchFieldDecoration,
    this.cursorColor,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.showSearchButton,
    this.showActionButton,
    required this.onChanged,
    required this.onSubmitted,
    required this.searchTextEditingController,
    this.horizontalPadding,
    this.onStateChange,
    this.onActionButtonClick,
    this.verticalPadding,
    this.isBackButtonVisible,
    this.backIcon,
    this.actionIcon,
    this.duration,
    this.iconBackSize,
    this.iconCloseSize,
    this.iconSearchSize,
    this.borderRadiusInput,
    this.widthHeightIcon,
    this.leftSpacingTextTitle,
  }) : super(key: key);

  ///
  final double? searchBarWidth;
  final double? searchBarHeight;
  final double? searchFieldHeight;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? previousScreen;
  final Color? backIconColor;
  final Color? actionIconColor;
  final Color? closeIconColor;
  final Color? searchIconColor;
  final Color? cursorColor;
  final String? pageTitlePosition;
  final String? pageTitle;
  final String? hintText;
  final bool? isBackButtonVisible;
  final bool? showSearchButton;
  final bool? showActionButton;
  final IconData? backIcon;
  final Widget? actionIcon;
  final TextStyle? pageTitleStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Decoration? searchFieldDecoration;
  late Duration? duration;
  final TextEditingController searchTextEditingController;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Function(bool)? onStateChange;
  final Function()? onActionButtonClick;
  final double? iconBackSize;
  final double? iconCloseSize;
  final double? iconSearchSize;
  final double? borderRadiusInput;
  final double? widthHeightIcon;
  final double? leftSpacingTextTitle;

  @override
  Widget build(BuildContext context) {
    final _duration = duration ?? const Duration(milliseconds: 500);
    final _searchFieldHeight = searchFieldHeight ?? 40;
    final _hPadding = horizontalPadding != null ? horizontalPadding! * 2 : 0;
    final _searchBarWidth = searchBarWidth ?? MediaQuery.of(context).size.width - _hPadding;
    final _isBackButtonVisible = isBackButtonVisible ?? false;
    final _showSearchButton = showSearchButton ?? false;
    final _showActionButton = showActionButton ?? false;
    final _iconBackSize = iconBackSize ?? 25;
    final _iconCloseSize = iconCloseSize ?? 25;
    final _iconSearchSize = iconSearchSize ?? 35;
    final _borderRadiusInput = borderRadiusInput ?? 15;
    final _widthHeightIcon = widthHeightIcon ?? 35;
    final _leftSpacingTextTitle = leftSpacingTextTitle ?? 15;

    return ProviderScope(
      child: Consumer(builder: (context, ref, __) {
        final _isSearching = ref.watch(searchingProvider);
        final _searchNotifier = ref.watch(searchingProvider.notifier);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 0),
          child: SizedBox(
            width: _searchBarWidth,
            height: searchBarHeight ?? 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// back Button
                _isBackButtonVisible //&& pageTitlePosition != "center"
                    ? AnimatedOpacity(
                        opacity: _isSearching ? 0 : 1,
                        duration: _duration,
                        child: AnimatedContainer(
                          curve: Curves.easeInOutCirc,
                          width: _isSearching ? 0 : _widthHeightIcon,
                          height: _isSearching ? 0 : _widthHeightIcon,
                          duration: _duration,
                          child: FittedBox(
                            child: KBackButton(icon: backIcon, iconSize: _iconBackSize, iconColor: backIconColor, previousScreen: previousScreen),
                          ),
                        ),
                      )
                    : AnimatedContainer(curve: Curves.easeInOutCirc, width: _isSearching ? 0 : 0, height: _isSearching ? 0 : 0, duration: _duration),

                /// text
                AnimatedOpacity(
                  opacity: _isSearching ? 0 : 1,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: _isSearching ? 0 : _searchBarWidth - (_widthHeightIcon * 2 + 15),
                    duration: _duration,
                    alignment: pageTitlePosition == 'center' ? Alignment.center : Alignment.centerLeft,
                    child: FittedBox(
                      child: Container(
                        margin: EdgeInsets.only(left: _isBackButtonVisible && pageTitlePosition != "center" ? _leftSpacingTextTitle : 0),
                        child: Text(
                          pageTitle ?? 'Title',
                          textAlign: TextAlign.center,
                          style: pageTitleStyle ??
                              const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// close search
                AnimatedOpacity(
                  opacity: _isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: _isSearching ? _widthHeightIcon : 0,
                    height: _isSearching ? _widthHeightIcon : 0,
                    duration: _duration,
                    child: FittedBox(
                      child: KCustomButton(
                        widget: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Icon(
                            Icons.close_rounded,
                            size: _iconCloseSize,
                            color: closeIconColor ?? Colors.black.withOpacity(.7),
                          ),
                        ),
                        onPressed: () {
                          _searchNotifier.state = false;
                          onStateChange!(false);
                          searchTextEditingController.clear();
                        },
                      ),
                    ),
                  ),
                ),

                /// input panel
                AnimatedOpacity(
                  opacity: _isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    duration: _duration,
                    width: _isSearching ? _searchBarWidth - (_widthHeightIcon + 20) - (horizontalPadding ?? 0 * 2) : 0,
                    height: _isSearching ? _searchFieldHeight : 20,
                    margin: EdgeInsets.only(left: _isSearching ? 5 : 0, right: _isSearching ? 10 : 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: searchFieldDecoration ??
                        BoxDecoration(
                          color: Colors.black.withOpacity(.05),
                          border: Border.all(color: Colors.black.withOpacity(.2), width: .5),
                          borderRadius: BorderRadius.circular(_borderRadiusInput),
                        ),
                    child: TextField(
                      controller: searchTextEditingController,
                      cursorColor: cursorColor ?? Colors.lightBlue,
                      style: textStyle ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: hintText ?? 'Search here...',
                        hintStyle: hintStyle ?? const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                        disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  ),
                ),

                ///  search button
                _showSearchButton
                    ? AnimatedOpacity(
                        opacity: _isSearching ? 0 : 1,
                        duration: _duration,
                        child: AnimatedContainer(
                          curve: Curves.easeInOutCirc,
                          duration: _duration,
                          width: _isSearching ? 0 : _widthHeightIcon,
                          height: _isSearching ? 0 : _widthHeightIcon,
                          child: FittedBox(
                            child: KCustomButton(
                              widget: Padding(padding: const EdgeInsets.all(5), child: Icon(Icons.search, size: _iconSearchSize, color: searchIconColor ?? Colors.black.withOpacity(.7))),
                              onPressed: () {
                                _searchNotifier.state = true;
                                onStateChange!(true);
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),

                ///  action button
                !_showSearchButton && _showActionButton
                    ? AnimatedOpacity(
                        opacity: _isSearching ? 0 : 1,
                        duration: _duration,
                        child: AnimatedContainer(
                          curve: Curves.easeInOutCirc,
                          duration: _duration,
                          width: _isSearching ? 0 : _widthHeightIcon,
                          height: _isSearching ? 0 : _widthHeightIcon,
                          child: FittedBox(
                            child: KCustomButton(
                              widget: Padding(padding: const EdgeInsets.all(5), child: actionIcon),
                              onPressed: () {
                                onActionButtonClick!();
                              },
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        );
      }),
    );
  }
}

class KCustomButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final double? radius;

  const KCustomButton({Key? key, required this.widget, required this.onPressed, this.radius, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 50),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? 50),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withOpacity(.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(.05),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0), child: widget),
          onTap: onPressed,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}

class KBackButton extends StatelessWidget {
  final Widget? previousScreen;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  const KBackButton({Key? key, required this.previousScreen, required this.iconColor, required this.icon, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withOpacity(.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(.05),
          onTap: () async {
            previousScreen == null ? Navigator.pop(context) : Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => previousScreen!));
          },
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                icon ?? Icons.arrow_back_ios_new,
                color: iconColor ?? Colors.black.withOpacity(.7),
                size: iconSize ?? 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
