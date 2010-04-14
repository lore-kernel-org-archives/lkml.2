Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0DNDo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:44:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab0DNDo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:44:56 -0400
Message-ID: <4BC53A90.9020304@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:46:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 6/6] gconfig: add support to show hidden options that have
 prompts
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a button in gconfig to "Show all options", but I think
normally we are not interested in those configs which have no
prompt and thus can't be changed, so here I add a new button to
show hidden options which have prompts.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/gconf.c     |   47 ++++++++++++++++++++++++++++++++++--------
 scripts/kconfig/gconf.glade |   28 +++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index c6aa5a5..bef1041 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -30,12 +30,16 @@ enum {
 	SINGLE_VIEW, SPLIT_VIEW, FULL_VIEW
 };
 
+enum {
+	OPT_NORMAL, OPT_ALL, OPT_PROMPT
+};
+
 static gint view_mode = FULL_VIEW;
 static gboolean show_name = TRUE;
 static gboolean show_range = TRUE;
 static gboolean show_value = TRUE;
-static gboolean show_all = FALSE;
 static gboolean resizeable = FALSE;
+static int opt_mode = OPT_NORMAL;
 
 GtkWidget *main_wnd = NULL;
 GtkWidget *tree1_w = NULL;	// left  frame
@@ -637,12 +641,29 @@ void on_show_data1_activate(GtkMenuItem * menuitem, gpointer user_data)
 
 
 void
-on_show_all_options1_activate(GtkMenuItem * menuitem, gpointer user_data)
+on_set_option_mode1_activate(GtkMenuItem *menuitem, gpointer user_data)
+{
+	opt_mode = OPT_NORMAL;
+	gtk_tree_store_clear(tree2);
+	display_tree(&rootmenu);	/* instead of update_tree to speed-up */
+}
+
+
+void
+on_set_option_mode2_activate(GtkMenuItem *menuitem, gpointer user_data)
 {
-	show_all = GTK_CHECK_MENU_ITEM(menuitem)->active;
+	opt_mode = OPT_ALL;
+	gtk_tree_store_clear(tree2);
+	display_tree(&rootmenu);	/* instead of update_tree to speed-up */
+}
+
 
+void
+on_set_option_mode3_activate(GtkMenuItem *menuitem, gpointer user_data)
+{
+	opt_mode = OPT_PROMPT;
 	gtk_tree_store_clear(tree2);
-	display_tree(&rootmenu);	// instead of update_tree to speed-up
+	display_tree(&rootmenu);	/* instead of update_tree to speed-up */
 }
 
 
@@ -1095,7 +1116,10 @@ static gchar **fill_row(struct menu *menu)
 	    g_strdup_printf("%s %s", _(menu_get_prompt(menu)),
 			    sym && sym_has_value(sym) ? "(NEW)" : "");
 
-	if (show_all && !menu_is_visible(menu))
+	if (opt_mode == OPT_ALL && !menu_is_visible(menu))
+		row[COL_COLOR] = g_strdup("DarkGray");
+	else if (opt_mode == OPT_PROMPT &&
+			menu_has_prompt(menu) && !menu_is_visible(menu))
 		row[COL_COLOR] = g_strdup("DarkGray");
 	else
 		row[COL_COLOR] = g_strdup("Black");
@@ -1318,16 +1342,19 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
 		       menu2 ? menu_get_prompt(menu2) : "nil");
 #endif
 
-		if (!menu_is_visible(child1) && !show_all) {	// remove node
+		if ((opt_mode == OPT_NORMAL && !menu_is_visible(child1)) ||
+		    (opt_mode == OPT_PROMPT && !menu_has_prompt(child1))) {
+
+			/* remove node */
 			if (gtktree_iter_find_node(dst, menu1) != NULL) {
 				memcpy(&tmp, child2, sizeof(GtkTreeIter));
 				valid = gtk_tree_model_iter_next(model2,
 								 child2);
 				gtk_tree_store_remove(tree2, &tmp);
 				if (!valid)
-					return;	// next parent
+					return;		/* next parent */
 				else
-					goto reparse;	// next child
+					goto reparse;	/* next child */
 			} else
 				continue;
 		}
@@ -1396,7 +1423,9 @@ static void display_tree(struct menu *menu)
 		    && (tree == tree2))
 			continue;
 
-		if (menu_is_visible(child) || show_all)
+		if ((opt_mode == OPT_NORMAL && menu_is_visible(child)) ||
+		    (opt_mode == OPT_PROMPT && menu_has_prompt(child)) ||
+		    (opt_mode == OPT_ALL))
 			place_node(child, fill_row(child));
 #ifdef DEBUG
 		printf("%*c%s: ", indent, ' ', menu_get_prompt(child));
diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
index 909f5a4..d52b0a7 100644
--- a/scripts/kconfig/gconf.glade
+++ b/scripts/kconfig/gconf.glade
@@ -190,13 +190,37 @@
 		  </child>
 
 		  <child>
-		    <widget class="GtkCheckMenuItem" id="show_all_options1">
+		    <widget class="GtkRadioMenuItem" id="set_option_mode1">
+		      <property name="visible">True</property>
+		      <property name="tooltip" translatable="yes">Show normal options</property>
+		      <property name="label" translatable="yes">Show normal options</property>
+		      <property name="use_underline">True</property>
+		      <property name="active">True</property>
+		      <signal name="activate" handler="on_set_option_mode1_activate"/>
+		    </widget>
+		  </child>
+
+		  <child>
+		    <widget class="GtkRadioMenuItem" id="set_option_mode2">
 		      <property name="visible">True</property>
 		      <property name="tooltip" translatable="yes">Show all options</property>
 		      <property name="label" translatable="yes">Show all _options</property>
 		      <property name="use_underline">True</property>
 		      <property name="active">False</property>
-		      <signal name="activate" handler="on_show_all_options1_activate"/>
+		      <property name="group">set_option_mode1</property>
+		      <signal name="activate" handler="on_set_option_mode2_activate"/>
+		    </widget>
+		  </child>
+
+		  <child>
+		    <widget class="GtkRadioMenuItem" id="set_option_mode3">
+		      <property name="visible">True</property>
+		      <property name="tooltip" translatable="yes">Show all options with prompts</property>
+		      <property name="label" translatable="yes">Show all prompt options</property>
+		      <property name="use_underline">True</property>
+		      <property name="active">False</property>
+		      <property name="group">set_option_mode1</property>
+		      <signal name="activate" handler="on_set_option_mode3_activate"/>
 		    </widget>
 		  </child>
 
-- 
1.6.3

