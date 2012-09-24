Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2IXCgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:36:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35661 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2IXCgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:36:23 -0400
Date: Mon, 24 Sep 2012 10:36:40 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        lacombar@gmail.com, dave@gnu.org
Subject: [PATCH]scripts:kconfig:meconf: Add Save button to save config at
 anytime
Message-ID: <20120924023640.GA16679@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	lacombar@gmail.com, dave@gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mconf make me annoying I have to make menuconfig && exit to save
the config when I am tuning .config time by time, it is even
worse I have to search down to my desire submenu time by time.
So I add "Save" button to save our time. With "Save" button,
I can use CRTL-Z after save config, and then use "%" or fg to
resume menuconfig and go on tuning.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c |  7 +++++--
 scripts/kconfig/mconf.c            | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 1d60473..a469f09 100644
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
@@ -372,9 +373,11 @@ do_resize:
 		case TAB:
 		case KEY_RIGHT:
 			button = ((key == KEY_LEFT ? --button : ++button) < 0)
-			    ? 2 : (button > 2 ? 0 : button);
+			    ? 3 : (button > 3 ? 0 : button);
 
 			print_buttons(dialog, height, width, button);
+			if (button == 3)
+				button = 9;
 			wrefresh(menu);
 			break;
 		case ' ':
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index f584a28..beb5ebf9 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -521,6 +521,7 @@ static void conf(struct menu *menu)
 	struct symbol *sym;
 	struct menu *active_menu = NULL;
 	int res;
+	int yesno;
 	int s_scroll = 0;
 
 	while (1) {
@@ -615,6 +616,36 @@ static void conf(struct menu *menu)
 		case 8:
 			show_all_options = !show_all_options;
 			break;
+		case 9:
+			if (!conf_get_changed()) {
+				show_helptext(_("Notice"),
+					_("\n\n"
+						"Your configuration have not been changed."
+						"\n\n"));
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
+					show_helptext(_("Notice"),
+						_("\n\n"
+							"Error while writing of the configuration.\n"
+							"Your configuration changes were NOT saved."
+							"\n\n"));
+				} else {
+					show_helptext(_("Notice"),
+						_("\n\n"
+							"Your configuration changes were saved."
+							"\n\n"));
+
+				}
+			}
+			break;
 		}
 	}
 }
@@ -879,4 +910,3 @@ int main(int ac, char **av)
 
 	return res;
 }
-
-- 
1.7.11.1.116.g8228a23

