Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab2C2GhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:37:03 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2C2Ggu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:36:50 -0400
X-AuditID: 9c93016f-b7c86ae000005478-20-4f7402ffc8c6
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/7] perf tools: Move GTK+ bits to tools/perf/ui/gtk directory
Date: Thu, 29 Mar 2012 15:36:39 +0900
Message-Id: <1333003004-6391-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move those files to new directory in order to be prepared to
further UI work. Makefile and header file pathes are adjusted
accordingly. Also fix a build breakage if NO_GTK2=1 is given.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile           |    4 +-
 tools/perf/ui/gtk/browser.c   |  189 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/gtk.h       |    8 ++
 tools/perf/util/gtk/browser.c |  189 -----------------------------------------
 tools/perf/util/gtk/gtk.h     |    8 --
 5 files changed, 199 insertions(+), 199 deletions(-)
 create mode 100644 tools/perf/ui/gtk/browser.c
 create mode 100644 tools/perf/ui/gtk/gtk.h
 delete mode 100644 tools/perf/util/gtk/browser.c
 delete mode 100644 tools/perf/util/gtk/gtk.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 919d5149b392..c8e71f073c6f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -510,7 +510,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
@@ -519,7 +519,7 @@ else
 	else
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
-		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 	endif
 endif
 
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
new file mode 100644
index 000000000000..d48cef877c96
--- /dev/null
+++ b/tools/perf/ui/gtk/browser.c
@@ -0,0 +1,189 @@
+#include "../../util/evlist.h"
+#include "../../util/cache.h"
+#include "../../util/evsel.h"
+#include "../../util/sort.h"
+#include "../../util/hist.h"
+#include "gtk.h"
+
+#include <signal.h>
+
+#define MAX_COLUMNS			32
+
+void perf_gtk_setup_browser(int argc, const char *argv[],
+			    bool fallback_to_pager __used)
+{
+	gtk_init(&argc, (char ***)&argv);
+}
+
+void perf_gtk_exit_browser(bool wait_for_ok __used)
+{
+	gtk_main_quit();
+}
+
+static void perf_gtk_signal(int sig)
+{
+	psignal(sig, "perf");
+	gtk_main_quit();
+}
+
+static void perf_gtk_resize_window(GtkWidget *window)
+{
+	GdkRectangle rect;
+	GdkScreen *screen;
+	int monitor;
+	int height;
+	int width;
+
+	screen = gtk_widget_get_screen(window);
+
+	monitor = gdk_screen_get_monitor_at_window(screen, window->window);
+
+	gdk_screen_get_monitor_geometry(screen, monitor, &rect);
+
+	width	= rect.width * 3 / 4;
+	height	= rect.height * 3 / 4;
+
+	gtk_window_resize(GTK_WINDOW(window), width, height);
+}
+
+static void perf_gtk_show_hists(GtkWidget *window, struct hists *hists)
+{
+	GType col_types[MAX_COLUMNS];
+	GtkCellRenderer *renderer;
+	struct sort_entry *se;
+	GtkListStore *store;
+	struct rb_node *nd;
+	u64 total_period;
+	GtkWidget *view;
+	int col_idx;
+	int nr_cols;
+
+	nr_cols = 0;
+
+	/* The percentage column */
+	col_types[nr_cols++] = G_TYPE_STRING;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		col_types[nr_cols++] = G_TYPE_STRING;
+	}
+
+	store = gtk_list_store_newv(nr_cols, col_types);
+
+	view = gtk_tree_view_new();
+
+	renderer = gtk_cell_renderer_text_new();
+
+	col_idx = 0;
+
+	/* The percentage column */
+	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+						    -1, "Overhead (%)",
+						    renderer, "text",
+						    col_idx++, NULL);
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, se->se_header,
+							    renderer, "text",
+							    col_idx++, NULL);
+	}
+
+	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
+
+	g_object_unref(GTK_TREE_MODEL(store));
+
+	total_period = hists->stats.total_period;
+
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+		double percent;
+		char s[512];
+
+		if (h->filtered)
+			continue;
+
+		gtk_list_store_append(store, &iter);
+
+		col_idx = 0;
+
+		percent = (h->period * 100.0) / total_period;
+
+		snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
+
+		gtk_list_store_set(store, &iter, col_idx++, s, -1);
+
+		list_for_each_entry(se, &hist_entry__sort_list, list) {
+			if (se->elide)
+				continue;
+
+			se->se_snprintf(h, s, ARRAY_SIZE(s),
+					hists__col_len(hists, se->se_width_idx));
+
+			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+		}
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), view);
+}
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
+				  const char *help __used,
+				  void (*timer) (void *arg)__used,
+				  void *arg __used, int delay_secs __used)
+{
+	struct perf_evsel *pos;
+	GtkWidget *notebook;
+	GtkWidget *window;
+
+	signal(SIGSEGV, perf_gtk_signal);
+	signal(SIGFPE,  perf_gtk_signal);
+	signal(SIGINT,  perf_gtk_signal);
+	signal(SIGQUIT, perf_gtk_signal);
+	signal(SIGTERM, perf_gtk_signal);
+
+	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+
+	gtk_window_set_title(GTK_WINDOW(window), "perf report");
+
+	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+	notebook = gtk_notebook_new();
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		const char *evname = event_name(pos);
+		GtkWidget *scrolled_window;
+		GtkWidget *tab_label;
+
+		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
+
+		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
+							GTK_POLICY_AUTOMATIC,
+							GTK_POLICY_AUTOMATIC);
+
+		perf_gtk_show_hists(scrolled_window, hists);
+
+		tab_label = gtk_label_new(evname);
+
+		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), notebook);
+
+	gtk_widget_show_all(window);
+
+	perf_gtk_resize_window(window);
+
+	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
+
+	gtk_main();
+
+	return 0;
+}
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
new file mode 100644
index 000000000000..75177ee04032
--- /dev/null
+++ b/tools/perf/ui/gtk/gtk.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_GTK_H_
+#define _PERF_GTK_H_ 1
+
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+#endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
deleted file mode 100644
index 258352a2356c..000000000000
--- a/tools/perf/util/gtk/browser.c
+++ /dev/null
@@ -1,189 +0,0 @@
-#include "../evlist.h"
-#include "../cache.h"
-#include "../evsel.h"
-#include "../sort.h"
-#include "../hist.h"
-#include "gtk.h"
-
-#include <signal.h>
-
-#define MAX_COLUMNS			32
-
-void perf_gtk_setup_browser(int argc, const char *argv[],
-			    bool fallback_to_pager __used)
-{
-	gtk_init(&argc, (char ***)&argv);
-}
-
-void perf_gtk_exit_browser(bool wait_for_ok __used)
-{
-	gtk_main_quit();
-}
-
-static void perf_gtk_signal(int sig)
-{
-	psignal(sig, "perf");
-	gtk_main_quit();
-}
-
-static void perf_gtk_resize_window(GtkWidget *window)
-{
-	GdkRectangle rect;
-	GdkScreen *screen;
-	int monitor;
-	int height;
-	int width;
-
-	screen = gtk_widget_get_screen(window);
-
-	monitor = gdk_screen_get_monitor_at_window(screen, window->window);
-
-	gdk_screen_get_monitor_geometry(screen, monitor, &rect);
-
-	width	= rect.width * 3 / 4;
-	height	= rect.height * 3 / 4;
-
-	gtk_window_resize(GTK_WINDOW(window), width, height);
-}
-
-static void perf_gtk_show_hists(GtkWidget *window, struct hists *hists)
-{
-	GType col_types[MAX_COLUMNS];
-	GtkCellRenderer *renderer;
-	struct sort_entry *se;
-	GtkListStore *store;
-	struct rb_node *nd;
-	u64 total_period;
-	GtkWidget *view;
-	int col_idx;
-	int nr_cols;
-
-	nr_cols = 0;
-
-	/* The percentage column */
-	col_types[nr_cols++] = G_TYPE_STRING;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		col_types[nr_cols++] = G_TYPE_STRING;
-	}
-
-	store = gtk_list_store_newv(nr_cols, col_types);
-
-	view = gtk_tree_view_new();
-
-	renderer = gtk_cell_renderer_text_new();
-
-	col_idx = 0;
-
-	/* The percentage column */
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-						    -1, "Overhead (%)",
-						    renderer, "text",
-						    col_idx++, NULL);
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, se->se_header,
-							    renderer, "text",
-							    col_idx++, NULL);
-	}
-
-	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
-
-	g_object_unref(GTK_TREE_MODEL(store));
-
-	total_period = hists->stats.total_period;
-
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		GtkTreeIter iter;
-		double percent;
-		char s[512];
-
-		if (h->filtered)
-			continue;
-
-		gtk_list_store_append(store, &iter);
-
-		col_idx = 0;
-
-		percent = (h->period * 100.0) / total_period;
-
-		snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
-
-		gtk_list_store_set(store, &iter, col_idx++, s, -1);
-
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
-			if (se->elide)
-				continue;
-
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
-					hists__col_len(hists, se->se_width_idx));
-
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
-		}
-	}
-
-	gtk_container_add(GTK_CONTAINER(window), view);
-}
-
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
-				  const char *help __used,
-				  void (*timer) (void *arg)__used,
-				  void *arg __used, int delay_secs __used)
-{
-	struct perf_evsel *pos;
-	GtkWidget *notebook;
-	GtkWidget *window;
-
-	signal(SIGSEGV, perf_gtk_signal);
-	signal(SIGFPE,  perf_gtk_signal);
-	signal(SIGINT,  perf_gtk_signal);
-	signal(SIGQUIT, perf_gtk_signal);
-	signal(SIGTERM, perf_gtk_signal);
-
-	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
-
-	gtk_window_set_title(GTK_WINDOW(window), "perf report");
-
-	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
-
-	notebook = gtk_notebook_new();
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		struct hists *hists = &pos->hists;
-		const char *evname = event_name(pos);
-		GtkWidget *scrolled_window;
-		GtkWidget *tab_label;
-
-		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
-
-		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
-							GTK_POLICY_AUTOMATIC,
-							GTK_POLICY_AUTOMATIC);
-
-		perf_gtk_show_hists(scrolled_window, hists);
-
-		tab_label = gtk_label_new(evname);
-
-		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
-	}
-
-	gtk_container_add(GTK_CONTAINER(window), notebook);
-
-	gtk_widget_show_all(window);
-
-	perf_gtk_resize_window(window);
-
-	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
-
-	gtk_main();
-
-	return 0;
-}
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
deleted file mode 100644
index 75177ee04032..000000000000
--- a/tools/perf/util/gtk/gtk.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _PERF_GTK_H_
-#define _PERF_GTK_H_ 1
-
-#pragma GCC diagnostic ignored "-Wstrict-prototypes"
-#include <gtk/gtk.h>
-#pragma GCC diagnostic error "-Wstrict-prototypes"
-
-#endif /* _PERF_GTK_H_ */
-- 
1.7.7.6

