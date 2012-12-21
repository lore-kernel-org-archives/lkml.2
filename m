Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab2LUIUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:20:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55170 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LUIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:20:40 -0500
X-AuditID: 9c930197-b7c5bae000000e31-b1-50d41bd6c180
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 1/6] perf ui/gtk: Factor out common browser routines
Date: Fri, 21 Dec 2012 17:20:13 +0900
Message-Id: <1356078018-31905-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out common codes for setting up a browser, and move
report/hist browser codes into hists.c.  The common codes can
be used for annotation browser.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile         |   1 +
 tools/perf/ui/gtk/browser.c | 227 +-------------------------------------------
 tools/perf/ui/gtk/gtk.h     |   9 +-
 tools/perf/ui/gtk/hists.c   | 226 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 240 insertions(+), 223 deletions(-)
 create mode 100644 tools/perf/ui/gtk/hists.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dbf1c35d3f16..103ed956ca80 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -688,6 +688,7 @@ ifndef NO_GTK2
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index e59ba337f494..c95012cdb438 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -8,15 +8,13 @@
 
 #include <signal.h>
 
-#define MAX_COLUMNS			32
-
-static void perf_gtk__signal(int sig)
+void perf_gtk__signal(int sig)
 {
 	perf_gtk__exit(false);
 	psignal(sig, "perf");
 }
 
-static void perf_gtk__resize_window(GtkWidget *window)
+void perf_gtk__resize_window(GtkWidget *window)
 {
 	GdkRectangle rect;
 	GdkScreen *screen;
@@ -36,7 +34,7 @@ static void perf_gtk__resize_window(GtkWidget *window)
 	gtk_window_resize(GTK_WINDOW(window), width, height);
 }
 
-static const char *perf_gtk__get_percent_color(double percent)
+const char *perf_gtk__get_percent_color(double percent)
 {
 	if (percent >= MIN_RED)
 		return "<span fgcolor='red'>";
@@ -45,147 +43,8 @@ static const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
-#define HPP__COLOR_FN(_name, _field)						\
-static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
-					 struct hist_entry *he)			\
-{										\
-	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
-	const char *markup;							\
-	int ret = 0;								\
-										\
-	markup = perf_gtk__get_percent_color(percent);				\
-	if (markup)								\
-		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
-	if (markup)								\
-		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
-										\
-	return ret;								\
-}
-
-HPP__COLOR_FN(overhead, period)
-HPP__COLOR_FN(overhead_sys, period_sys)
-HPP__COLOR_FN(overhead_us, period_us)
-HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
-HPP__COLOR_FN(overhead_guest_us, period_guest_us)
-
-#undef HPP__COLOR_FN
-
-void perf_gtk__init_hpp(void)
-{
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
-	perf_hpp__init();
-
-	perf_hpp__format[PERF_HPP__OVERHEAD].color =
-				perf_gtk__hpp_color_overhead;
-	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
-				perf_gtk__hpp_color_overhead_sys;
-	perf_hpp__format[PERF_HPP__OVERHEAD_US].color =
-				perf_gtk__hpp_color_overhead_us;
-	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_SYS].color =
-				perf_gtk__hpp_color_overhead_guest_sys;
-	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
-				perf_gtk__hpp_color_overhead_guest_us;
-}
-
-static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
-{
-	struct perf_hpp_fmt *fmt;
-	GType col_types[MAX_COLUMNS];
-	GtkCellRenderer *renderer;
-	struct sort_entry *se;
-	GtkListStore *store;
-	struct rb_node *nd;
-	GtkWidget *view;
-	int col_idx;
-	int nr_cols;
-	char s[512];
-
-	struct perf_hpp hpp = {
-		.buf		= s,
-		.size		= sizeof(s),
-	};
-
-	nr_cols = 0;
-
-	perf_hpp__for_each_format(fmt)
-		col_types[nr_cols++] = G_TYPE_STRING;
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
-	perf_hpp__for_each_format(fmt) {
-		fmt->header(&hpp);
-		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, s,
-							    renderer, "markup",
-							    col_idx++, NULL);
-	}
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
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		GtkTreeIter iter;
-
-		if (h->filtered)
-			continue;
-
-		gtk_list_store_append(store, &iter);
-
-		col_idx = 0;
-
-		perf_hpp__for_each_format(fmt) {
-			if (fmt->color)
-				fmt->color(&hpp, h);
-			else
-				fmt->entry(&hpp, h);
-
-			gtk_list_store_set(store, &iter, col_idx++, s, -1);
-		}
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
 #ifdef HAVE_GTK_INFO_BAR
-static GtkWidget *perf_gtk__setup_info_bar(void)
+GtkWidget *perf_gtk__setup_info_bar(void)
 {
 	GtkWidget *info_bar;
 	GtkWidget *label;
@@ -212,7 +71,7 @@ static GtkWidget *perf_gtk__setup_info_bar(void)
 }
 #endif
 
-static GtkWidget *perf_gtk__setup_statusbar(void)
+GtkWidget *perf_gtk__setup_statusbar(void)
 {
 	GtkWidget *stbar;
 	unsigned ctxid;
@@ -226,79 +85,3 @@ static GtkWidget *perf_gtk__setup_statusbar(void)
 
 	return stbar;
 }
-
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
-				  const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused)
-{
-	struct perf_evsel *pos;
-	GtkWidget *vbox;
-	GtkWidget *notebook;
-	GtkWidget *info_bar;
-	GtkWidget *statbar;
-	GtkWidget *window;
-
-	signal(SIGSEGV, perf_gtk__signal);
-	signal(SIGFPE,  perf_gtk__signal);
-	signal(SIGINT,  perf_gtk__signal);
-	signal(SIGQUIT, perf_gtk__signal);
-	signal(SIGTERM, perf_gtk__signal);
-
-	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
-
-	gtk_window_set_title(GTK_WINDOW(window), "perf report");
-
-	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
-
-	pgctx = perf_gtk__activate_context(window);
-	if (!pgctx)
-		return -1;
-
-	vbox = gtk_vbox_new(FALSE, 0);
-
-	notebook = gtk_notebook_new();
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		struct hists *hists = &pos->hists;
-		const char *evname = perf_evsel__name(pos);
-		GtkWidget *scrolled_window;
-		GtkWidget *tab_label;
-
-		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
-
-		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
-							GTK_POLICY_AUTOMATIC,
-							GTK_POLICY_AUTOMATIC);
-
-		perf_gtk__show_hists(scrolled_window, hists);
-
-		tab_label = gtk_label_new(evname);
-
-		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
-	}
-
-	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
-
-	info_bar = perf_gtk__setup_info_bar();
-	if (info_bar)
-		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
-
-	statbar = perf_gtk__setup_statusbar();
-	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
-
-	gtk_container_add(GTK_CONTAINER(window), vbox);
-
-	gtk_widget_show_all(window);
-
-	perf_gtk__resize_window(window);
-
-	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
-
-	ui_helpline__push(help);
-
-	gtk_main();
-
-	perf_gtk__deactivate_context(&pgctx);
-
-	return 0;
-}
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 856320e2cc05..5d3693754828 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -33,7 +33,14 @@ void perf_gtk__init_helpline(void);
 void perf_gtk__init_progress(void);
 void perf_gtk__init_hpp(void);
 
-#ifndef HAVE_GTK_INFO_BAR
+void perf_gtk__signal(int sig);
+void perf_gtk__resize_window(GtkWidget *window);
+const char *perf_gtk__get_percent_color(double percent);
+GtkWidget *perf_gtk__setup_statusbar(void);
+
+#ifdef HAVE_GTK_INFO_BAR
+GtkWidget *perf_gtk__setup_info_bar(void);
+#else
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
 {
 	return NULL;
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
new file mode 100644
index 000000000000..26912f86e032
--- /dev/null
+++ b/tools/perf/ui/gtk/hists.c
@@ -0,0 +1,226 @@
+#include "../evlist.h"
+#include "../cache.h"
+#include "../evsel.h"
+#include "../sort.h"
+#include "../hist.h"
+#include "../helpline.h"
+#include "gtk.h"
+
+#define MAX_COLUMNS			32
+
+#define HPP__COLOR_FN(_name, _field)						\
+static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
+					 struct hist_entry *he)			\
+{										\
+	struct hists *hists = he->hists;					\
+	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
+	const char *markup;							\
+	int ret = 0;								\
+										\
+	markup = perf_gtk__get_percent_color(percent);				\
+	if (markup)								\
+		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
+	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
+	if (markup)								\
+		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
+										\
+	return ret;								\
+}
+
+HPP__COLOR_FN(overhead, period)
+HPP__COLOR_FN(overhead_sys, period_sys)
+HPP__COLOR_FN(overhead_us, period_us)
+HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
+HPP__COLOR_FN(overhead_guest_us, period_guest_us)
+
+#undef HPP__COLOR_FN
+
+
+void perf_gtk__init_hpp(void)
+{
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+
+	perf_hpp__init();
+
+	perf_hpp__format[PERF_HPP__OVERHEAD].color =
+				perf_gtk__hpp_color_overhead;
+	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
+				perf_gtk__hpp_color_overhead_sys;
+	perf_hpp__format[PERF_HPP__OVERHEAD_US].color =
+				perf_gtk__hpp_color_overhead_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_SYS].color =
+				perf_gtk__hpp_color_overhead_guest_sys;
+	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
+				perf_gtk__hpp_color_overhead_guest_us;
+}
+
+static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
+{
+	struct perf_hpp_fmt *fmt;
+	GType col_types[MAX_COLUMNS];
+	GtkCellRenderer *renderer;
+	struct sort_entry *se;
+	GtkListStore *store;
+	struct rb_node *nd;
+	GtkWidget *view;
+	int col_idx;
+	int nr_cols;
+	char s[512];
+
+	struct perf_hpp hpp = {
+		.buf		= s,
+		.size		= sizeof(s),
+	};
+
+	nr_cols = 0;
+
+	perf_hpp__for_each_format(fmt)
+		col_types[nr_cols++] = G_TYPE_STRING;
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
+	perf_hpp__for_each_format(fmt) {
+		fmt->header(&hpp);
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, s,
+							    renderer, "markup",
+							    col_idx++, NULL);
+	}
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
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		GtkTreeIter iter;
+
+		if (h->filtered)
+			continue;
+
+		gtk_list_store_append(store, &iter);
+
+		col_idx = 0;
+
+		perf_hpp__for_each_format(fmt) {
+			if (fmt->color)
+				fmt->color(&hpp, h);
+			else
+				fmt->entry(&hpp, h);
+
+			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+		}
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
+				  const char *help,
+				  struct hist_browser_timer *hbt __maybe_unused)
+{
+	struct perf_evsel *pos;
+	GtkWidget *vbox;
+	GtkWidget *notebook;
+	GtkWidget *info_bar;
+	GtkWidget *statbar;
+	GtkWidget *window;
+
+	signal(SIGSEGV, perf_gtk__signal);
+	signal(SIGFPE,  perf_gtk__signal);
+	signal(SIGINT,  perf_gtk__signal);
+	signal(SIGQUIT, perf_gtk__signal);
+	signal(SIGTERM, perf_gtk__signal);
+
+	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+
+	gtk_window_set_title(GTK_WINDOW(window), "perf report");
+
+	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+	pgctx = perf_gtk__activate_context(window);
+	if (!pgctx)
+		return -1;
+
+	vbox = gtk_vbox_new(FALSE, 0);
+
+	notebook = gtk_notebook_new();
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+		const char *evname = perf_evsel__name(pos);
+		GtkWidget *scrolled_window;
+		GtkWidget *tab_label;
+
+		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
+
+		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
+							GTK_POLICY_AUTOMATIC,
+							GTK_POLICY_AUTOMATIC);
+
+		perf_gtk__show_hists(scrolled_window, hists);
+
+		tab_label = gtk_label_new(evname);
+
+		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
+	}
+
+	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+	info_bar = perf_gtk__setup_info_bar();
+	if (info_bar)
+		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
+
+	statbar = perf_gtk__setup_statusbar();
+	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+	gtk_container_add(GTK_CONTAINER(window), vbox);
+
+	gtk_widget_show_all(window);
+
+	perf_gtk__resize_window(window);
+
+	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
+
+	ui_helpline__push(help);
+
+	gtk_main();
+
+	perf_gtk__deactivate_context(&pgctx);
+
+	return 0;
+}
-- 
1.7.11.7

