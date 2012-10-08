Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2JHCve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 22:51:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43195 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JHCvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 22:51:31 -0400
Date: Mon, 8 Oct 2012 10:50:26 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH v2]mconf: Add Save button
Message-ID: <20121008025025.GA10093@udknight>
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

mconf make me annoying I have to make menuconfig && exit to
save the config when I am tuning .config time by time, it
is even worse I have to search down to my desire submenu
time by time. So I add "Save" button to save our time. With
"Save" button, I can use CRTL-Z after save config, and then
use "%" or fg to resume menuconfig and go on tuning.

Changes v1-v2:
* Rewrite the most code to make it more correct

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c | 17 ++++++++--------
 scripts/kconfig/mconf.c            | 40 ++++++++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 1d60473..f71f112 100644
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
@@ -160,6 +160,7 @@ static void print_buttons(WINDOW * win, int height, int width, int selected)
 	print_button(win, gettext("Select"), y, x, selected == 0);
 	print_button(win, gettext(" Exit "), y, x + 12, selected == 1);
 	print_button(win, gettext(" Help "), y, x + 24, selected == 2);
+	print_button(win, gettext(" Save "), y, x + 36, selected == 3);
 
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
index f584a28..100b52a 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -521,6 +521,7 @@ static void conf(struct menu *menu)
 	struct symbol *sym;
 	struct menu *active_menu = NULL;
 	int res;
+	int yesno;
 	int s_scroll = 0;
 
 	while (1) {
@@ -588,6 +589,25 @@ static void conf(struct menu *menu)
 				show_helptext(_("README"), _(mconf_readme));
 			break;
 		case 3:
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
+				if (conf_write(filename)) {
+					show_textbox(NULL,
+						_("Error while writing of the configuration.\n"
+							"Your configuration changes were NOT saved."),
+						6,60);
+				}
+			}
+			break;
+		case 4:
 			if (item_is_tag('t')) {
 				if (sym_set_tristate_value(sym, yes))
 					break;
@@ -595,24 +615,24 @@ static void conf(struct menu *menu)
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
 				conf(submenu);
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
@@ -630,6 +650,14 @@ static void show_helptext(const char *title, const char *text)
 	show_textbox(title, text, 0, 0);
 }
 
+static void conf_message_callback(const char *fmt, va_list ap)
+{
+	char buf[1024];
+
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	show_textbox(NULL, buf, 6, 60);
+}
+
 static void show_help(struct menu *menu)
 {
 	struct gstr help = str_new();
@@ -872,6 +900,7 @@ int main(int ac, char **av)
 	}
 
 	set_config_filename(conf_get_configname());
+	conf_set_message_callback(conf_message_callback);
 	do {
 		conf(&rootmenu);
 		res = handle_exit();
@@ -879,4 +908,3 @@ int main(int ac, char **av)
 
 	return res;
 }
-
-- 
1.7.11.1.116.g8228a23
