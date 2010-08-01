Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0HAHUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 03:20:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63872 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0HAHUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 03:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mstUHuhwV3J+cqvjn/OLlA9gFXskkzGRF9M4u8AIptqA2EZG9TNgL6L+1ob/QbuuxC
         NB7gcRvZibCGsaIChWZa0HCsqS90NW5JZrErew23GYdUAxAU4amCwONzsdcrdfuLD36u
         ZhAerlSMZyV6B0waen8vTBd41G+NrpYA30x3U=
From: nir.tzachar@gmail.com
To: mmarek@suse.cz, rdunlap@xenotime.net
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        nir.tzachar@gmail.com, sam@ravnborg.org, trapdoor6@gmail.com,
        justinmattock@gmail.com
Subject: [PATCH] nconfig: add search support
Date: Sun,  1 Aug 2010 10:20:33 +0300
Message-Id: <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nir Tzachar <nir.tzachar@gmail.com>

Remove the old hotkeys feature, and replace by a regular string search.
>From nconfig help:

Pressing '/' triggers search mode. nconfig does regular string match, case
insensitive, starting at the begining of each menu line.
Pressing Enter highlights the next match, Backspace removes one character from
the match string. Pressing either '/' again or ESC exits search mode.

Rebind the '/' key (which allowed to search for symbols) to F8

Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.c |  261 ++++++++++++++++++++++-------------------------
 scripts/kconfig/nconf.h |    3 +-
 2 files changed, 125 insertions(+), 139 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 762caf8..2a7cb37 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -41,9 +41,12 @@ static const char nconf_readme[] = N_(
 "   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
 "   Submenus are designated by \"--->\".\n"
 "\n"
-"   Shortcut: Press the option's highlighted letter (hotkey).\n"
-"             Pressing a hotkey more than once will sequence\n"
-"             through all visible items which use that hotkey.\n"
+"   Searching: pressing '/' triggers search mode. nconfig does a\n"
+"              regular string match, case insensitive, starting at\n"
+"              the begining of each menu line.\n"
+"              Pressing Enter highlights the next match, Backspace\n"
+"              removes one character from the match string.\n"
+"              Pressing either '/' again or ESC exits search mode.\n"
 "\n"
 "   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
 "   unseen options into view.\n"
@@ -252,7 +255,6 @@ struct mitem {
 	char str[256];
 	char tag;
 	void *usrptr;
-	int is_hot;
 	int is_visible;
 };
 
@@ -275,14 +277,6 @@ static int items_num;
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
@@ -292,6 +286,7 @@ static void conf_save(void);
 static void show_help(struct menu *menu);
 static int do_exit(void);
 static void setup_windows(void);
+static void search_conf(void);
 
 typedef void (*function_key_handler_t)(int *key, struct menu *menu);
 static void handle_f1(int *key, struct menu *current_item);
@@ -302,6 +297,7 @@ static void handle_f5(int *key, struct menu *current_item);
 static void handle_f6(int *key, struct menu *current_item);
 static void handle_f7(int *key, struct menu *current_item);
 static void handle_f8(int *key, struct menu *current_item);
+static void handle_f9(int *key, struct menu *current_item);
 
 struct function_keys {
 	const char *key_str;
@@ -310,7 +306,7 @@ struct function_keys {
 	function_key_handler_t handler;
 };
 
-static const int function_keys_num = 8;
+static const int function_keys_num = 9;
 struct function_keys function_keys[] = {
 	{
 		.key_str = "F1",
@@ -356,9 +352,15 @@ struct function_keys function_keys[] = {
 	},
 	{
 		.key_str = "F8",
+		.func = "search symbol",
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
 
@@ -444,9 +446,16 @@ static void handle_f7(int *key, struct menu *current_item)
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
@@ -479,110 +488,45 @@ static void clean_items(void)
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
+typedef enum {FIND_NEW_MATCH, FIND_NEXT_MATCH, FIND_NEXT_MATCH_INC} match_f;
 
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
+/* return the index of the matched item, or -1 if no such item exists */
+static int get_mext_match(const char *match_str, match_f flag)
 {
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
-
-/* find the first possible hot key, and mark it.
- * index is the index of the item in the menu
- * return 0 on success*/
-static int make_hot(char *dest, int len, const char *org, int index)
-{
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
+	static int last_match;
+
+	if (flag == FIND_NEW_MATCH)
+		last_match = 0;
+	else if (flag == FIND_NEXT_MATCH_INC)
+		++last_match;
+
+	int index;
+	for (index = last_match; index < items_num; ++index) {
+		char *non_space = k_menu_items[index].str;
+		/* skip the leading 4 bytes, as they are noise. */
+		non_space += 4;
+		/* and any white space from indentation */
+		while (*non_space != '\0' && isblank(*non_space))
+			++non_space;
+		if (strncasecmp(match_str, non_space, strlen(match_str)) == 0) {
+			last_match = index;
+			return index;
 		}
 	}
-	if (position == -1)
-		return 1;
 
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
+	if (flag == FIND_NEXT_MATCH || flag == FIND_NEXT_MATCH_INC)
+		return get_mext_match(match_str, FIND_NEW_MATCH);
+	else
+		return -1;
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
@@ -597,16 +541,13 @@ static void item_make(struct menu *menu, char tag, const char *fmt, ...)
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
@@ -638,11 +579,9 @@ static void item_add_str(const char *fmt, ...)
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
@@ -1108,6 +1047,7 @@ static void conf(struct menu *menu)
 	int res;
 	int current_index = 0;
 	int last_top_row = 0;
+	int in_search = 0;
 
 	bzero(pattern, sizeof(pattern));
 
@@ -1150,22 +1090,44 @@ static void conf(struct menu *menu)
 				show_help((struct menu *) item_data());
 				break;
 			}
-			if (res == 10 || res == 27 ||
+			if (res == '/' || (in_search && res == 27)) {
+				in_search = 1-in_search;
+				bzero(pattern, sizeof(pattern));
+				move(0, 0);
+				refresh();
+				clrtoeol();
+			} else if (in_search) {
+				char c = (char) res;
+				int tmp = -1;
+				if (isalnum(c)) {
+					pattern[strlen(pattern)] = c;
+					pattern[strlen(pattern)] = '\0';
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH);
+				} else if (res == 10)
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH_INC);
+				else if (res == KEY_BACKSPACE || res == 127) {
+					pattern[strlen(pattern)-1] = '\0';
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH_INC);
+				}
+				if (tmp != -1)
+					center_item(tmp, &last_top_row);
+			} else if (res == 10 || res == 27 ||
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
+			if (in_search) {
+				mvprintw(0, 0, "searching: %s", pattern);
+				clrtoeol();
 			}
 			refresh_all_windows(main_window);
 		}
 
 		refresh_all_windows(main_window);
-		/* if ESC  or left*/
+		/* if ESC or left*/
 		if (res == 27 || (menu != &rootmenu && res == KEY_LEFT))
 			break;
 
@@ -1233,9 +1195,6 @@ static void conf(struct menu *menu)
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, mod);
 			break;
-		case '/':
-			search_conf();
-			break;
 		}
 	}
 }
@@ -1260,12 +1219,14 @@ static void show_help(struct menu *menu)
 
 static void conf_choice(struct menu *menu)
 {
+	char pattern[256];
 	const char *prompt = _(menu_get_prompt(menu));
 	struct menu *child = 0;
 	struct symbol *active;
 	int selected_index = 0;
 	int last_top_row = 0;
 	int res, i = 0;
+	int in_search = 0;
 
 	active = sym_get_choice_value(menu->sym);
 	/* this is mostly duplicated from the conf() function. */
@@ -1321,14 +1282,37 @@ static void conf_choice(struct menu *menu)
 				show_help((struct menu *) item_data());
 				break;
 			}
-			if (res == 10 || res == 27 || res == ' ' ||
-				res == KEY_LEFT)
-				break;
-			else if (canbhot(res)) {
-				/* check for hot keys: */
-				int tmp = get_next_hot(res);
+			if (res == '/' || (in_search && res == 27)) {
+				in_search = 1-in_search;
+				bzero(pattern, sizeof(pattern));
+				move(0, 0);
+				refresh();
+				clrtoeol();
+			} else if (in_search) {
+				char c = (char) res;
+				int tmp = -1;
+				if (isalnum(c)) {
+					pattern[strlen(pattern)] = c;
+					pattern[strlen(pattern)] = '\0';
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH);
+				} else if (res == 10)
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH_INC);
+				else if (res == KEY_BACKSPACE || res == 127) {
+					pattern[strlen(pattern)-1] = '\0';
+					tmp = get_mext_match(pattern,
+							FIND_NEXT_MATCH_INC);
+				}
 				if (tmp != -1)
 					center_item(tmp, &last_top_row);
+			} else if (res == 10 || res == 27 || res == ' ' ||
+					res == KEY_LEFT){
+				break;
+			}
+			if (in_search) {
+				mvprintw(0, 0, "searching: %s", pattern);
+				clrtoeol();
 			}
 			refresh_all_windows(main_window);
 		}
@@ -1530,9 +1514,10 @@ int main(int ac, char **av)
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

