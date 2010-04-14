Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0DNDog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:44:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63092 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0DNDoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:44:34 -0400
Message-ID: <4BC53A7A.5080502@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:46:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 5/6] menuconfig: add support to show hidden options which
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage:
  Press <Z> to show all config symbols which have prompts.

Quote Tim Bird:

| I've been bitten by this numerous times.  I most often
| use ftrace on ARM, but when I go back to x86, I almost
| always go through a sequence of searching for the
| function graph tracer in the menus, then realizing it's
| completely missing until I disable CC_OPTIMIZE_FOR_SIZE.
|
| Is there any way to have the menu item appear, but be
| unsettable unless the SIZE option is disabled?  I'm
| not a Kconfig guru...

I myself found this useful too. For example, I need to test
ftrace/tracing and want to be sure all the tracing features are
enabled, so I  enter the "Tracers" menu, and press <Z> to
see if there is any config hidden.

I also noticed gconfig and xconfig have a button "Show all options",
but that's a bit too much, and I think normally what we are not
interested in those configs which have no prompt thus can't be
changed by users.

Exmaple:

      --- Tracers
      -*-   Kernel Function Tracer
      - -     Kernel Function Graph Tracer
      [*]   Interrupts-off Latency Tracer
      - -   Preemption-off Latency Tracer
      [*]   Sysprof Tracer

Here you can see 2 tracers are not selectable, and then can find
out how to make them selectable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/lkc_proto.h        |    3 ++-
 scripts/kconfig/lxdialog/menubox.c |   22 +++++++++++-----------
 scripts/kconfig/mconf.c            |   22 ++++++++++++++++++----
 scripts/kconfig/menu.c             |   10 ++++++++++
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index ffeb532..15ab2b4 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -11,7 +11,8 @@ P(conf_set_changed_callback, void,(void (*fn)(void)));
 /* menu.c */
 P(rootmenu,struct menu,);
 
-P(menu_is_visible,bool,(struct menu *menu));
+P(menu_is_visible, bool, (struct menu *menu));
+P(menu_has_prompt, bool, (struct menu *menu));
 P(menu_get_prompt,const char *,(struct menu *menu));
 P(menu_get_root_menu,struct menu *,(struct menu *menu));
 P(menu_get_parent_menu,struct menu *,(struct menu *menu));
diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index fa9d633..1d60473 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -383,6 +383,10 @@ do_resize:
 		case 'n':
 		case 'm':
 		case '/':
+		case 'h':
+		case '?':
+		case 'z':
+		case '\n':
 			/* save scroll info */
 			*s_scroll = scroll;
 			delwin(menu);
@@ -390,8 +394,10 @@ do_resize:
 			item_set(scroll + choice);
 			item_set_selected(1);
 			switch (key) {
+			case 'h':
+			case '?':
+				return 2;
 			case 's':
-				return 3;
 			case 'y':
 				return 3;
 			case 'n':
@@ -402,18 +408,12 @@ do_resize:
 				return 6;
 			case '/':
 				return 7;
+			case 'z':
+				return 8;
+			case '\n':
+				return button;
 			}
 			return 0;
-		case 'h':
-		case '?':
-			button = 2;
-		case '\n':
-			*s_scroll = scroll;
-			delwin(menu);
-			delwin(dialog);
-			item_set(scroll + choice);
-			item_set_selected(1);
-			return button;
 		case 'e':
 		case 'x':
 			key = KEY_ESC;
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 8413cf3..33f31eb 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -67,13 +67,15 @@ static const char mconf_readme[] = N_(
 "             there is a delayed response which you may find annoying.\n"
 "\n"
 "   Also, the <TAB> and cursor keys will cycle between <Select>,\n"
-"   <Exit> and <Help>\n"
+"   <Exit> and <Help>.\n"
 "\n"
 "o  To get help with an item, use the cursor keys to highlight <Help>\n"
-"   and Press <ENTER>.\n"
+"   and press <ENTER>.\n"
 "\n"
 "   Shortcut: Press <H> or <?>.\n"
 "\n"
+"o  To show hidden options, press <Z>.\n"
+"\n"
 "\n"
 "Radiolists  (Choice lists)\n"
 "-----------\n"
@@ -272,6 +274,7 @@ static int indent;
 static struct menu *current_menu;
 static int child_count;
 static int single_menu_mode;
+static int show_all_options;
 
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
@@ -359,8 +362,16 @@ static void build_conf(struct menu *menu)
 	int type, tmp, doint = 2;
 	tristate val;
 	char ch;
-
-	if (!menu_is_visible(menu))
+	bool visible;
+
+	/*
+	 * note: menu_is_visible() has side effect that it will
+	 * recalc the value of the symbol.
+	 */
+	visible = menu_is_visible(menu);
+	if (show_all_options && !menu_has_prompt(menu))
+		return;
+	else if (!show_all_options && !visible)
 		return;
 
 	sym = menu->sym;
@@ -619,6 +630,9 @@ static void conf(struct menu *menu)
 		case 7:
 			search_conf();
 			break;
+		case 8:
+			show_all_options = !show_all_options;
+			break;
 		}
 	}
 }
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 6761055..e150176 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -390,6 +390,13 @@ void menu_finalize(struct menu *parent)
 	}
 }
 
+bool menu_has_prompt(struct menu *menu)
+{
+	if (!menu->prompt)
+		return false;
+	return true;
+}
+
 bool menu_is_visible(struct menu *menu)
 {
 	struct menu *child;
@@ -398,6 +405,7 @@ bool menu_is_visible(struct menu *menu)
 
 	if (!menu->prompt)
 		return false;
+
 	sym = menu->sym;
 	if (sym) {
 		sym_calc_value(sym);
@@ -407,12 +415,14 @@ bool menu_is_visible(struct menu *menu)
 
 	if (visible != no)
 		return true;
+
 	if (!sym || sym_get_tristate_value(menu->sym) == no)
 		return false;
 
 	for (child = menu->list; child; child = child->next)
 		if (menu_is_visible(child))
 			return true;
+
 	return false;
 }
 
-- 
1.6.3

