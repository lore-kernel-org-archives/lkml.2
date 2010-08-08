Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0HHNuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 09:50:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47444 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab0HHNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 09:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OXn7opuLy6kbUoo5O7aMZMYaVjpgBFlI6EyjpscBw/x/8i8fWcTAChCkmV6VFmtq4K
         shcQMSnetz4+9j8Kn9feCe6wuFYF59FwqLLv/IEXb3+rCB/ikagnhlicOa0Xgu0VST80
         Lbcev8Wuy9g+/+x5TfbKMtqFfgywfs1z7YYAE=
From: nir.tzachar@gmail.com
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        nir.tzachar@gmail.com, sam@ravnborg.org, randy.dunlap@oracle.com
Subject: [PATCH] nconfig: add search support
Date: Sun,  8 Aug 2010 16:50:06 +0300
Message-Id: <1281275406-27540-1-git-send-email-nir.tzachar@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nir Tzachar <nir.tzachar@gmail.com>

Remove the old hotkeys feature, and replace it by an interactive string
search.
>From nconfig help:

Searching: pressing '/' triggers interactive search mode.
           nconfig performs a case insensitive search for the string
           in the menu prompts (no regex support).
           Pressing the up/down keys highlights the previous/next
           matching item. Backspace removes one character from the
           match string. Pressing either '/' again or ESC exits
           search mode. All other keys behave normally.

Miscellaneous other changes (including Rundy's and Justin's input).

Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.c     |  365 +++++++++++++++++++++++--------------------
 scripts/kconfig/nconf.gui.c |   20 ++--
 scripts/kconfig/nconf.h     |    3 +-
 3 files changed, 208 insertions(+), 180 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 762caf8..c6feb41 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -5,9 +5,12 @@
  * Derived from menuconfig.
  *
  */
+#define _GNU_SOURCE
+#include <string.h>
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 #include "nconf.h"
+#include <ctype.h>
 
 static const char nconf_readme[] = N_(
 "Overview\n"
@@ -23,7 +26,7 @@ static const char nconf_readme[] = N_(
 "  < > can be built in, modularized or removed\n"
 "  { } can be built in or modularized (selected by other feature)\n"
 "  - - are selected by other feature,\n"
-"  XXX cannot be selected. use Symbol Info to find out why,\n"
+"  XXX cannot be selected. Use Symbol Info to find out why,\n"
 "while *, M or whitespace inside braces means to build in, build as\n"
 "a module or to exclude the feature respectively.\n"
 "\n"
@@ -41,9 +44,13 @@ static const char nconf_readme[] = N_(
 "   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
 "   Submenus are designated by \"--->\".\n"
 "\n"
-"   Shortcut: Press the option's highlighted letter (hotkey).\n"
-"             Pressing a hotkey more than once will sequence\n"
-"             through all visible items which use that hotkey.\n"
+"   Searching: pressing '/' triggers interactive search mode.\n"
+"              nconfig performs a case insensitive search for the string\n"
+"              in the menu prompts (no regex support).\n"
+"              Pressing the up/down keys highlights the previous/next\n"
+"              matching item. Backspace removes one character from the\n"
+"              match string. Pressing either '/' again or ESC exits\n"
+"              search mode. All other keys behave normally.\n"
 "\n"
 "   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
 "   unseen options into view.\n"
@@ -141,21 +148,21 @@ menu_no_f_instructions[] = N_(
 " <Enter> or <right-arrow> selects submenus --->.\n"
 " Capital Letters are hotkeys.\n"
 " Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
-" Pressing SpaceBar toggles between the above options\n"
-" Press <Esc> or <left-arrow> to go back one menu, \n"
+" Pressing SpaceBar toggles between the above options.\n"
+" Press <Esc> or <left-arrow> to go back one menu,\n"
 " <?> or <h> for Help, </> for Search.\n"
-" <1> is interchangable with <F1>, <2> with <F2>, etc.\n"
+" <1> is interchangeable with <F1>, <2> with <F2>, etc.\n"
 " Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
-" <Esc> always leaves the current window\n"),
+" <Esc> always leaves the current window.\n"),
 menu_instructions[] = N_(
 " Arrow keys navigate the menu.\n"
 " <Enter> or <right-arrow> selects submenus --->.\n"
 " Capital Letters are hotkeys.\n"
 " Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
 " Pressing SpaceBar toggles between the above options\n"
-" Press <Esc>, <F3> or <left-arrow> to go back one menu, \n"
+" Press <Esc>, <F5> or <left-arrow> to go back one menu,\n"
 " <?>, <F1> or <h> for Help, </> for Search.\n"
-" <1> is interchangable with <F1>, <2> with <F2>, etc.\n"
+" <1> is interchangeable with <F1>, <2> with <F2>, etc.\n"
 " Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
 " <Esc> always leaves the current window\n"),
 radiolist_instructions[] = N_(
@@ -252,7 +259,6 @@ struct mitem {
 	char str[256];
 	char tag;
 	void *usrptr;
-	int is_hot;
 	int is_visible;
 };
 
@@ -275,14 +281,6 @@ static int items_num;
 static int global_exit;
 /* the currently selected button */
 const char *current_instructions = menu_instructions;
-/* this array is used to implement hot keys. it is updated in item_make and
- * resetted in clean_items. It would be better to use a hash, but lets keep it
- * simple... */
-#define MAX_SAME_KEY MAX_MENU_ITEMS
-struct {
-	int count;
-	int ptrs[MAX_MENU_ITEMS];
-} hotkeys[1<<(sizeof(char)*8)];
 
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
@@ -292,6 +290,7 @@ static void conf_save(void);
 static void show_help(struct menu *menu);
 static int do_exit(void);
 static void setup_windows(void);
+static void search_conf(void);
 
 typedef void (*function_key_handler_t)(int *key, struct menu *menu);
 static void handle_f1(int *key, struct menu *current_item);
@@ -302,6 +301,7 @@ static void handle_f5(int *key, struct menu *current_item);
 static void handle_f6(int *key, struct menu *current_item);
 static void handle_f7(int *key, struct menu *current_item);
 static void handle_f8(int *key, struct menu *current_item);
+static void handle_f9(int *key, struct menu *current_item);
 
 struct function_keys {
 	const char *key_str;
@@ -310,7 +310,7 @@ struct function_keys {
 	function_key_handler_t handler;
 };
 
-static const int function_keys_num = 8;
+static const int function_keys_num = 9;
 struct function_keys function_keys[] = {
 	{
 		.key_str = "F1",
@@ -320,13 +320,13 @@ struct function_keys function_keys[] = {
 	},
 	{
 		.key_str = "F2",
-		.func = "Symbol Info",
+		.func = "Sym Info",
 		.key = F_SYMBOL,
 		.handler = handle_f2,
 	},
 	{
 		.key_str = "F3",
-		.func = "Instructions",
+		.func = "Insts",
 		.key = F_INSTS,
 		.handler = handle_f3,
 	},
@@ -356,9 +356,15 @@ struct function_keys function_keys[] = {
 	},
 	{
 		.key_str = "F8",
+		.func = "Sym Search",
+		.key = F_SEARCH,
+		.handler = handle_f8,
+	},
+	{
+		.key_str = "F9",
 		.func = "Exit",
 		.key = F_EXIT,
-		.handler = handle_f8,
+		.handler = handle_f9,
 	},
 };
 
@@ -444,9 +450,16 @@ static void handle_f7(int *key, struct menu *current_item)
 	return;
 }
 
-/* exit */
+/* search */
 static void handle_f8(int *key, struct menu *current_item)
 {
+	search_conf();
+	return;
+}
+
+/* exit */
+static void handle_f9(int *key, struct menu *current_item)
+{
 	do_exit();
 	return;
 }
@@ -479,110 +492,44 @@ static void clean_items(void)
 		free_item(curses_menu_items[i]);
 	bzero(curses_menu_items, sizeof(curses_menu_items));
 	bzero(k_menu_items, sizeof(k_menu_items));
-	bzero(hotkeys, sizeof(hotkeys));
 	items_num = 0;
 }
 
-/* return the index of the next hot item, or -1 if no such item exists */
-static int get_next_hot(int c)
-{
-	static int hot_index;
-	static int hot_char;
-
-	if (c < 0 || c > 255 || hotkeys[c].count <= 0)
-		return -1;
-
-	if (hot_char == c) {
-		hot_index = (hot_index+1)%hotkeys[c].count;
-		return hotkeys[c].ptrs[hot_index];
-	} else {
-		hot_char = c;
-		hot_index = 0;
-		return hotkeys[c].ptrs[0];
-	}
-}
-
-/* can the char c be a hot key? no, if c is a common shortcut used elsewhere */
-static int canbhot(char c)
-{
-	c = tolower(c);
-	return isalnum(c) && c != 'y' && c != 'm' && c != 'h' &&
-		c != 'n' && c != '?';
-}
-
-/* check if str already contains a hot key. */
-static int is_hot(int index)
-{
-	return k_menu_items[index].is_hot;
-}
+typedef enum {MATCH_TINKER_PATTERN_UP, MATCH_TINKER_PATTERN_DOWN,
+	FIND_NEXT_MATCH_DOWN, FIND_NEXT_MATCH_UP} match_f;
 
-/* find the first possible hot key, and mark it.
- * index is the index of the item in the menu
- * return 0 on success*/
-static int make_hot(char *dest, int len, const char *org, int index)
+/* return the index of the matched item, or -1 if no such item exists */
+static int get_mext_match(const char *match_str, match_f flag)
 {
-	int position = -1;
-	int i;
-	int tmp;
-	int c;
-	int org_len = strlen(org);
-
-	if (org == NULL || is_hot(index))
-		return 1;
-
-	/* make sure not to make hot keys out of markers.
-	 * find where to start looking for a hot key
-	 */
-	i = 0;
-	/* skip white space */
-	while (i < org_len && org[i] == ' ')
-		i++;
-	if (i == org_len)
-		return -1;
-	/* if encountering '(' or '<' or '[', find the match and look from there
-	 **/
-	if (org[i] == '[' || org[i] == '<' || org[i] == '(') {
-		i++;
-		for (; i < org_len; i++)
-			if (org[i] == ']' || org[i] == '>' || org[i] == ')')
-				break;
-	}
-	if (i == org_len)
-		return -1;
-	for (; i < org_len; i++) {
-		if (canbhot(org[i]) && org[i-1] != '<' && org[i-1] != '(') {
-			position = i;
-			break;
-		}
+	int match_start = item_index(current_item(curses_menu));
+	int index;
+
+	if (flag == FIND_NEXT_MATCH_DOWN)
+		++match_start;
+	else if (flag == FIND_NEXT_MATCH_UP)
+		--match_start;
+
+	index = match_start;
+	index = (index + items_num) % items_num;
+	while (true) {
+		char *str = k_menu_items[index].str;
+		if (strcasestr(str, match_str) != 0)
+			return index;
+		if (flag == FIND_NEXT_MATCH_UP ||
+		    flag == MATCH_TINKER_PATTERN_UP)
+			--index;
+		else
+			++index;
+		index = (index + items_num) % items_num;
+		if (index == match_start)
+			return -1;
 	}
-	if (position == -1)
-		return 1;
-
-	/* ok, char at org[position] should be a hot key to this item */
-	c = tolower(org[position]);
-	tmp = hotkeys[c].count;
-	hotkeys[c].ptrs[tmp] = index;
-	hotkeys[c].count++;
-	/*
-	   snprintf(dest, len, "%.*s(%c)%s", position, org, org[position],
-	   &org[position+1]);
-	   */
-	/* make org[position] uppercase, and all leading letter small case */
-	strncpy(dest, org, len);
-	for (i = 0; i < position; i++)
-		dest[i] = tolower(dest[i]);
-	dest[position] = toupper(dest[position]);
-	k_menu_items[index].is_hot = 1;
-	return 0;
 }
 
-/* Make a new item. Add a hotkey mark in the first possible letter.
- * As ncurses does not allow any attributes inside menue item, we mark the
- * hot key as the first capitalized letter in the string */
+/* Make a new item. */
 static void item_make(struct menu *menu, char tag, const char *fmt, ...)
 {
 	va_list ap;
-	char tmp_str[256];
 
 	if (items_num > MAX_MENU_ITEMS-1)
 		return;
@@ -597,16 +544,13 @@ static void item_make(struct menu *menu, char tag, const char *fmt, ...)
 		k_menu_items[items_num].is_visible = 1;
 
 	va_start(ap, fmt);
-	vsnprintf(tmp_str, sizeof(tmp_str), fmt, ap);
-	if (!k_menu_items[items_num].is_visible)
-		memcpy(tmp_str, "XXX", 3);
+	vsnprintf(k_menu_items[items_num].str,
+		  sizeof(k_menu_items[items_num].str),
+		  fmt, ap);
 	va_end(ap);
-	if (make_hot(
-		k_menu_items[items_num].str,
-		sizeof(k_menu_items[items_num].str), tmp_str, items_num) != 0)
-		strncpy(k_menu_items[items_num].str,
-			tmp_str,
-			sizeof(k_menu_items[items_num].str));
+
+	if (!k_menu_items[items_num].is_visible)
+		memcpy(k_menu_items[items_num].str, "XXX", 3);
 
 	curses_menu_items[items_num] = new_item(
 			k_menu_items[items_num].str,
@@ -638,11 +582,9 @@ static void item_add_str(const char *fmt, ...)
 	va_end(ap);
 	snprintf(tmp_str, sizeof(tmp_str), "%s%s",
 			k_menu_items[index].str, new_str);
-	if (make_hot(k_menu_items[index].str,
-			sizeof(k_menu_items[index].str), tmp_str, index) != 0)
-		strncpy(k_menu_items[index].str,
-			tmp_str,
-			sizeof(k_menu_items[index].str));
+	strncpy(k_menu_items[index].str,
+		tmp_str,
+		sizeof(k_menu_items[index].str));
 
 	free_item(curses_menu_items[index]);
 	curses_menu_items[index] = new_item(
@@ -1025,23 +967,18 @@ static void reset_menu(void)
 static void center_item(int selected_index, int *last_top_row)
 {
 	int toprow;
-	int maxy, maxx;
 
-	scale_menu(curses_menu, &maxy, &maxx);
 	set_top_row(curses_menu, *last_top_row);
 	toprow = top_row(curses_menu);
-	if (selected_index >= toprow && selected_index < toprow+maxy) {
-		/* we can only move the selected item. no need to scroll */
-		set_current_item(curses_menu,
-				curses_menu_items[selected_index]);
-	} else {
-		toprow = max(selected_index-maxy/2, 0);
-		if (toprow >= item_count(curses_menu)-maxy)
+	if (selected_index < toprow ||
+	    selected_index >= toprow+mwin_max_lines) {
+		toprow = max(selected_index-mwin_max_lines/2, 0);
+		if (toprow >= item_count(curses_menu)-mwin_max_lines)
 			toprow = item_count(curses_menu)-mwin_max_lines;
 		set_top_row(curses_menu, toprow);
-		set_current_item(curses_menu,
-				curses_menu_items[selected_index]);
 	}
+	set_current_item(curses_menu,
+			curses_menu_items[selected_index]);
 	*last_top_row = toprow;
 	post_menu(curses_menu);
 	refresh_all_windows(main_window);
@@ -1073,7 +1010,7 @@ static void show_menu(const char *prompt, const char *instructions,
 	/* position the menu at the middle of the screen */
 	scale_menu(curses_menu, &maxy, &maxx);
 	maxx = min(maxx, mwin_max_cols-2);
-	maxy = mwin_max_lines-2;
+	maxy = mwin_max_lines;
 	menu_window = derwin(main_window,
 			maxy,
 			maxx,
@@ -1097,10 +1034,77 @@ static void show_menu(const char *prompt, const char *instructions,
 	refresh_all_windows(main_window);
 }
 
+static void adj_match_dir(match_f *match_direction)
+{
+	if (*match_direction == FIND_NEXT_MATCH_DOWN)
+		*match_direction =
+			MATCH_TINKER_PATTERN_DOWN;
+	else if (*match_direction == FIND_NEXT_MATCH_UP)
+		*match_direction =
+			MATCH_TINKER_PATTERN_UP;
+	/* else, do no change.. */
+}
 
-static void conf(struct menu *menu)
+struct match_state
 {
+	int in_search;
+	match_f match_direction;
 	char pattern[256];
+};
+
+/* Return 0 means I have handled the key. In such a case, ans should hold the
+ * item to center, or -1 otherwise.
+ * Else return -1 .
+ */
+static int do_match(int key, struct match_state *state, int *ans)
+{
+	char c = (char) key;
+	int terminate_search = 0;
+	*ans = -1;
+	if (key == '/' || (state->in_search && key == 27)) {
+		move(0, 0);
+		refresh();
+		clrtoeol();
+		state->in_search = 1-state->in_search;
+		bzero(state->pattern, sizeof(state->pattern));
+		state->match_direction = MATCH_TINKER_PATTERN_DOWN;
+		return 0;
+	} else if (!state->in_search)
+		return 1;
+
+	if (isalnum(c) || isgraph(c) || c == ' ') {
+		state->pattern[strlen(state->pattern)] = c;
+		state->pattern[strlen(state->pattern)] = '\0';
+		adj_match_dir(&state->match_direction);
+		*ans = get_mext_match(state->pattern,
+				state->match_direction);
+	} else if (key == KEY_DOWN) {
+		state->match_direction = FIND_NEXT_MATCH_DOWN;
+		*ans = get_mext_match(state->pattern,
+				state->match_direction);
+	} else if (key == KEY_UP) {
+		state->match_direction = FIND_NEXT_MATCH_UP;
+		*ans = get_mext_match(state->pattern,
+				state->match_direction);
+	} else if (key == KEY_BACKSPACE || key == 127) {
+		state->pattern[strlen(state->pattern)-1] = '\0';
+		adj_match_dir(&state->match_direction);
+	} else
+		terminate_search = 1;
+
+	if (terminate_search) {
+		state->in_search = 0;
+		bzero(state->pattern, sizeof(state->pattern));
+		move(0, 0);
+		refresh();
+		clrtoeol();
+		return -1;
+	}
+	return 0;
+}
+
+static void conf(struct menu *menu)
+{
 	struct menu *submenu = 0;
 	const char *prompt = menu_get_prompt(menu);
 	struct symbol *sym;
@@ -1108,8 +1112,11 @@ static void conf(struct menu *menu)
 	int res;
 	int current_index = 0;
 	int last_top_row = 0;
-
-	bzero(pattern, sizeof(pattern));
+	struct match_state match_state = {
+		.in_search = 0,
+		.match_direction = MATCH_TINKER_PATTERN_DOWN,
+		.pattern = "",
+	};
 
 	while (!global_exit) {
 		reset_menu();
@@ -1122,7 +1129,22 @@ static void conf(struct menu *menu)
 				_(menu_instructions),
 				current_index, &last_top_row);
 		keypad((menu_win(curses_menu)), TRUE);
-		while (!global_exit && (res = wgetch(menu_win(curses_menu)))) {
+		while (!global_exit) {
+			if (match_state.in_search) {
+				mvprintw(0, 0,
+					"searching: %s", match_state.pattern);
+				clrtoeol();
+			}
+			refresh_all_windows(main_window);
+			res = wgetch(menu_win(curses_menu));
+			if (!res)
+				break;
+			if (do_match(res, &match_state, &current_index) == 0) {
+				if (current_index != -1)
+					center_item(current_index,
+						    &last_top_row);
+				continue;
+			}
 			if (process_special_keys(&res,
 						(struct menu *) item_data()))
 				break;
@@ -1153,19 +1175,13 @@ static void conf(struct menu *menu)
 			if (res == 10 || res == 27 ||
 				res == 32 || res == 'n' || res == 'y' ||
 				res == KEY_LEFT || res == KEY_RIGHT ||
-				res == 'm' || res == '/')
+				res == 'm')
 				break;
-			else if (canbhot(res)) {
-				/* check for hot keys: */
-				int tmp = get_next_hot(res);
-				if (tmp != -1)
-					center_item(tmp, &last_top_row);
-			}
 			refresh_all_windows(main_window);
 		}
 
 		refresh_all_windows(main_window);
-		/* if ESC  or left*/
+		/* if ESC or left*/
 		if (res == 27 || (menu != &rootmenu && res == KEY_LEFT))
 			break;
 
@@ -1233,9 +1249,6 @@ static void conf(struct menu *menu)
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, mod);
 			break;
-		case '/':
-			search_conf();
-			break;
 		}
 	}
 }
@@ -1266,6 +1279,11 @@ static void conf_choice(struct menu *menu)
 	int selected_index = 0;
 	int last_top_row = 0;
 	int res, i = 0;
+	struct match_state match_state = {
+		.in_search = 0,
+		.match_direction = MATCH_TINKER_PATTERN_DOWN,
+		.pattern = "",
+	};
 
 	active = sym_get_choice_value(menu->sym);
 	/* this is mostly duplicated from the conf() function. */
@@ -1292,7 +1310,22 @@ static void conf_choice(struct menu *menu)
 				_(radiolist_instructions),
 				selected_index,
 				&last_top_row);
-		while (!global_exit && (res = wgetch(menu_win(curses_menu)))) {
+		while (!global_exit) {
+			if (match_state.in_search) {
+				mvprintw(0, 0, "searching: %s",
+					 match_state.pattern);
+				clrtoeol();
+			}
+			refresh_all_windows(main_window);
+			res = wgetch(menu_win(curses_menu));
+			if (!res)
+				break;
+			if (do_match(res, &match_state, &selected_index) == 0) {
+				if (selected_index != -1)
+					center_item(selected_index,
+						    &last_top_row);
+				continue;
+			}
 			if (process_special_keys(
 						&res,
 						(struct menu *) item_data()))
@@ -1322,13 +1355,8 @@ static void conf_choice(struct menu *menu)
 				break;
 			}
 			if (res == 10 || res == 27 || res == ' ' ||
-				res == KEY_LEFT)
+					res == KEY_LEFT){
 				break;
-			else if (canbhot(res)) {
-				/* check for hot keys: */
-				int tmp = get_next_hot(res);
-				if (tmp != -1)
-					center_item(tmp, &last_top_row);
 			}
 			refresh_all_windows(main_window);
 		}
@@ -1483,7 +1511,7 @@ void setup_windows(void)
 	/* set up the menu and menu window */
 	main_window = newwin(LINES-2, COLS-2, 2, 1);
 	keypad(main_window, TRUE);
-	mwin_max_lines = LINES-6;
+	mwin_max_lines = LINES-7;
 	mwin_max_cols = COLS-6;
 
 	/* panels order is from bottom to top */
@@ -1530,9 +1558,10 @@ int main(int ac, char **av)
 	/* set btns menu */
 	curses_menu = new_menu(curses_menu_items);
 	menu_opts_off(curses_menu, O_SHOWDESC);
-	menu_opts_off(curses_menu, O_SHOWMATCH);
+	menu_opts_on(curses_menu, O_SHOWMATCH);
 	menu_opts_on(curses_menu, O_ONEVALUE);
 	menu_opts_on(curses_menu, O_NONCYCLIC);
+	menu_opts_on(curses_menu, O_IGNORECASE);
 	set_menu_mark(curses_menu, " ");
 	set_menu_fore(curses_menu, attributes[MAIN_MENU_FORE]);
 	set_menu_back(curses_menu, attributes[MAIN_MENU_BACK]);
@@ -1548,8 +1577,6 @@ int main(int ac, char **av)
 				_(menu_no_f_instructions));
 	}
 
-
-
 	/* do the work */
 	while (!global_exit) {
 		conf(&rootmenu);
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index a9d9344..d963071 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -167,7 +167,7 @@ void print_in_middle(WINDOW *win,
 	length = strlen(string);
 	temp = (width - length) / 2;
 	x = startx + (int)temp;
-	wattrset(win, color);
+	(void) wattrset(win, color);
 	mvwprintw(win, y, x, "%s", string);
 	refresh();
 }
@@ -297,11 +297,11 @@ int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...)
 	set_menu_fore(menu, attributes[DIALOG_MENU_FORE]);
 	set_menu_back(menu, attributes[DIALOG_MENU_BACK]);
 
-	wattrset(win, attributes[DIALOG_BOX]);
+	(void) wattrset(win, attributes[DIALOG_BOX]);
 	box(win, 0, 0);
 
 	/* print message */
-	wattrset(msg_win, attributes[DIALOG_TEXT]);
+	(void) wattrset(msg_win, attributes[DIALOG_TEXT]);
 	fill_window(msg_win, msg);
 
 	set_menu_win(menu, win);
@@ -392,16 +392,16 @@ int dialog_inputbox(WINDOW *main_window,
 	form_win = derwin(win, 1, prompt_width, prompt_lines+3, 2);
 	keypad(form_win, TRUE);
 
-	wattrset(form_win, attributes[INPUT_FIELD]);
+	(void) wattrset(form_win, attributes[INPUT_FIELD]);
 
-	wattrset(win, attributes[INPUT_BOX]);
+	(void) wattrset(win, attributes[INPUT_BOX]);
 	box(win, 0, 0);
-	wattrset(win, attributes[INPUT_HEADING]);
+	(void) wattrset(win, attributes[INPUT_HEADING]);
 	if (title)
 		mvwprintw(win, 0, 3, "%s", title);
 
 	/* print message */
-	wattrset(prompt_win, attributes[INPUT_TEXT]);
+	(void) wattrset(prompt_win, attributes[INPUT_TEXT]);
 	fill_window(prompt_win, prompt);
 
 	mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
@@ -531,7 +531,7 @@ void show_scroll_win(WINDOW *main_window,
 
 	/* create the pad */
 	pad = newpad(total_lines+10, total_cols+10);
-	wattrset(pad, attributes[SCROLLWIN_TEXT]);
+	(void) wattrset(pad, attributes[SCROLLWIN_TEXT]);
 	fill_window(pad, text);
 
 	win_lines = min(total_lines+4, LINES-2);
@@ -546,9 +546,9 @@ void show_scroll_win(WINDOW *main_window,
 	win = newwin(win_lines, win_cols, y, x);
 	keypad(win, TRUE);
 	/* show the help in the help window, and show the help panel */
-	wattrset(win, attributes[SCROLLWIN_BOX]);
+	(void) wattrset(win, attributes[SCROLLWIN_BOX]);
 	box(win, 0, 0);
-	wattrset(win, attributes[SCROLLWIN_HEADING]);
+	(void) wattrset(win, attributes[SCROLLWIN_HEADING]);
 	mvwprintw(win, 0, 3, " %s ", title);
 	panel = new_panel(win);
 
diff --git a/scripts/kconfig/nconf.h b/scripts/kconfig/nconf.h
index fb42966..58fbda8 100644
--- a/scripts/kconfig/nconf.h
+++ b/scripts/kconfig/nconf.h
@@ -69,7 +69,8 @@ typedef enum {
 	F_BACK = 5,
 	F_SAVE = 6,
 	F_LOAD = 7,
-	F_EXIT = 8
+	F_SEARCH = 8,
+	F_EXIT = 9,
 } function_key;
 
 void set_colors(void);
-- 
1.6.4.4

