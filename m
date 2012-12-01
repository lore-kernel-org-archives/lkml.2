Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2LAQNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:13:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61775 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2LAQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:13:21 -0500
Date: Sun, 2 Dec 2012 00:13:16 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH v4]menuconfig: Add Save button
Message-ID: <20121201161316.GA15246@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If menuconfig have a Save button like alternative
.config editors, xconfig, nconfig, etc.We will have
a obvious benefit when use menuconfig just like
when we use others, we can save our .config quickly
and conveniently.

This patch add the Save button for menuconfig.

V1-V2: Rewrite the most code to make it more correct
V2-V3: Fix the behavior of conf_message_callback when exit.
V3-V4:
1: Move Buttons a little left to make them look like symmetrical.
2: Exchange the position between Save button and Exit button.
3: Use conf_save instead of conf_write to make we can save
an alternate configuration file with Save button.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c | 21 +++++++++---------
 scripts/kconfig/mconf.c            | 45 ++++++++++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 1d60473..b445bda 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -26,7 +26,7 @@
  *
  *    *)  A bugfix for the Page-Down problem
  *
- *    *)  Formerly when I used Page Down and Page Up, the cursor would be set 
+ *    *)  Formerly when I used Page Down and Page Up, the cursor would be set
  *        to the first position in the menu box.  Now lxdialog is a bit
  *        smarter and works more like other menu systems (just have a look at
  *        it).
@@ -154,12 +154,13 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
  */
 static void print_buttons(WINDOW * win, int height, int width, int selected)
 {
-	int x = width / 2 - 16;
+	int x = width / 2 - 20;
 	int y = height - 2;
 
 	print_button(win, gettext("Select"), y, x, selected == 0);
-	print_button(win, gettext(" Exit "), y, x + 12, selected == 1);
+	print_button(win, gettext(" Save "), y, x + 12, selected == 1);
 	print_button(win, gettext(" Help "), y, x + 24, selected == 2);
+	print_button(win, gettext(" Exit "), y, x + 36, selected == 3);
 
 	wmove(win, y, x + 1 + 12 * selected);
 	wrefresh(win);
@@ -372,7 +373,7 @@ do_resize:
 		case TAB:
 		case KEY_RIGHT:
 			button = ((key == KEY_LEFT ? --button : ++button) < 0)
-			    ? 2 : (button > 2 ? 0 : button);
+			    ? 3 : (button > 3 ? 0 : button);
 
 			print_buttons(dialog, height, width, button);
 			wrefresh(menu);
@@ -399,17 +400,17 @@ do_resize:
 				return 2;
 			case 's':
 			case 'y':
-				return 3;
-			case 'n':
 				return 4;
-			case 'm':
+			case 'n':
 				return 5;
-			case ' ':
+			case 'm':
 				return 6;
-			case '/':
+			case ' ':
 				return 7;
-			case 'z':
+			case '/':
 				return 8;
+			case 'z':
+				return 9;
 			case '\n':
 				return button;
 			}
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 53975cf..a8a1947 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -280,6 +280,7 @@ static struct menu *current_menu;
 static int child_count;
 static int single_menu_mode;
 static int show_all_options;
+static int save_and_exit;
 
 static void conf(struct menu *menu, struct menu *active_menu);
 static void conf_choice(struct menu *menu);
@@ -584,6 +585,7 @@ static void conf(struct menu *menu, struct menu *active_menu)
 	const char *prompt = menu_get_prompt(menu);
 	struct symbol *sym;
 	int res;
+	int yesno;
 	int s_scroll = 0;
 
 	while (1) {
@@ -604,7 +606,7 @@ static void conf(struct menu *menu, struct menu *active_menu)
 		res = dialog_menu(prompt ? _(prompt) : _("Main Menu"),
 				  _(menu_instructions),
 				  active_menu, &s_scroll);
-		if (res == 1 || res == KEY_ESC || res == -ERRDISPLAYTOOSMALL)
+		if (res == 3 || res == KEY_ESC || res == -ERRDISPLAYTOOSMALL)
 			break;
 		if (!item_activate_selected())
 			continue;
@@ -644,13 +646,27 @@ static void conf(struct menu *menu, struct menu *active_menu)
 				break;
 			}
 			break;
+		case 1:
+			if (!conf_get_changed()) {
+				break;
+			}
+
+			yesno = dialog_yesno(NULL,
+					_("Do you wish to save your "
+						"new configuration?\n"
+						"<ESC><ESC> to continue."),
+					6, 60);
+			if (yesno == 0) {
+			    conf_save();
+			}
+			break;
 		case 2:
 			if (sym)
 				show_help(submenu);
 			else
 				show_helptext(_("README"), _(mconf_readme));
 			break;
-		case 3:
+		case 4:
 			if (item_is_tag('t')) {
 				if (sym_set_tristate_value(sym, yes))
 					break;
@@ -658,24 +674,24 @@ static void conf(struct menu *menu, struct menu *active_menu)
 					show_textbox(NULL, setmod_text, 6, 74);
 			}
 			break;
-		case 4:
+		case 5:
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, no);
 			break;
-		case 5:
+		case 6:
 			if (item_is_tag('t'))
 				sym_set_tristate_value(sym, mod);
 			break;
-		case 6:
+		case 7:
 			if (item_is_tag('t'))
 				sym_toggle_tristate_value(sym);
 			else if (item_is_tag('m'))
 				conf(submenu, NULL);
 			break;
-		case 7:
+		case 8:
 			search_conf();
 			break;
-		case 8:
+		case 9:
 			show_all_options = !show_all_options;
 			break;
 		}
@@ -702,6 +718,17 @@ static void show_helptext(const char *title, const char *text)
 	show_textbox(title, text, 0, 0);
 }
 
+static void conf_message_callback(const char *fmt, va_list ap)
+{
+	char buf[1024];
+
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	if (save_and_exit)
+		printf("%s", buf);
+	else
+		show_textbox(NULL, buf, 6, 60);
+}
+
 static void show_help(struct menu *menu)
 {
 	struct gstr help = str_new();
@@ -869,7 +896,7 @@ static void conf_save(void)
 static int handle_exit(void)
 {
 	int res;
-
+	save_and_exit = 1;
 	dialog_clear();
 	if (conf_get_changed())
 		res = dialog_yesno(NULL,
@@ -941,6 +968,7 @@ int main(int ac, char **av)
 	}
 
 	set_config_filename(conf_get_configname());
+	conf_set_message_callback(conf_message_callback);
 	do {
 		conf(&rootmenu, NULL);
 		res = handle_exit();
@@ -948,4 +976,3 @@ int main(int ac, char **av)
 
 	return res;
 }
-
-- 
1.7.11.1.116.g8228a23
