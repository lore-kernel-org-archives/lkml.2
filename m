Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2HVF4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:56:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49264 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2HVFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:55:30 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-34-5034744d70b5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 5/5] perf gtk/browser: Use perf_hpp__format functions
Date: Wed, 22 Aug 2012 14:48:37 +0900
Message-Id: <1345614517-5753-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
References: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now we can support color using pango markup with this change.

Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 101 +++++++++++++++++++++++++++++++++++++-------
 tools/perf/ui/gtk/gtk.h     |   1 +
 tools/perf/ui/gtk/setup.c   |   1 +
 3 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 26b5b652a8cd..3c16ab50e0f8 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -36,6 +36,57 @@ static void perf_gtk__resize_window(GtkWidget *window)
 	gtk_window_resize(GTK_WINDOW(window), width, height);
 }
 
+static const char *perf_gtk__get_percent_color(double percent)
+{
+	if (percent >= MIN_RED)
+		return "<span fgcolor='red'>";
+	if (percent >= MIN_GREEN)
+		return "<span fgcolor='dark green'>";
+	return NULL;
+}
+
+#define HPP__COLOR_FN(_name, _field)						\
+static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
+					 struct hist_entry *he)			\
+{										\
+	double percent = 100.0 * he->_field / hpp->total_period;		\
+	const char *markup;							\
+	int ret = 0;								\
+										\
+	markup = perf_gtk__get_percent_color(percent);				\
+	if (markup)								\
+		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
+	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%5.2f%%", percent); 	\
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
+void perf_gtk__init_hpp(void)
+{
+	perf_hpp__init(false, false);
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
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
 	GType col_types[MAX_COLUMNS];
@@ -43,15 +94,25 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct sort_entry *se;
 	GtkListStore *store;
 	struct rb_node *nd;
-	u64 total_period;
 	GtkWidget *view;
-	int col_idx;
+	int i, col_idx;
 	int nr_cols;
+	char s[512];
+
+	struct perf_hpp hpp = {
+		.buf		= s,
+		.size		= sizeof(s),
+		.total_period	= hists->stats.total_period,
+	};
 
 	nr_cols = 0;
 
-	/* The percentage column */
-	col_types[nr_cols++] = G_TYPE_STRING;
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!perf_hpp__format[i].cond)
+			continue;
+
+		col_types[nr_cols++] = G_TYPE_STRING;
+	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
@@ -68,11 +129,17 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 	col_idx = 0;
 
-	/* The percentage column */
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-						    -1, "Overhead (%)",
-						    renderer, "text",
-						    col_idx++, NULL);
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!perf_hpp__format[i].cond)
+			continue;
+
+		perf_hpp__format[i].header(&hpp);
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, s,
+							    renderer, "markup",
+							    col_idx++, NULL);
+	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
@@ -88,13 +155,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 	g_object_unref(GTK_TREE_MODEL(store));
 
-	total_period = hists->stats.total_period;
-
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		double percent;
-		char s[512];
 
 		if (h->filtered)
 			continue;
@@ -103,11 +166,17 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 		col_idx = 0;
 
-		percent = (h->period * 100.0) / total_period;
+		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+			if (!perf_hpp__format[i].cond)
+				continue;
 
-		snprintf(s, ARRAY_SIZE(s), "%.2f", percent);
+			if (perf_hpp__format[i].color)
+				perf_hpp__format[i].color(&hpp, h);
+			else
+				perf_hpp__format[i].entry(&hpp, h);
 
-		gtk_list_store_set(store, &iter, col_idx++, s, -1);
+			gtk_list_store_set(store, &iter, col_idx++, s, -1);
+		}
 
 		list_for_each_entry(se, &hist_entry__sort_list, list) {
 			if (se->elide)
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 793cb6116ddf..687af0bba187 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -30,6 +30,7 @@ struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
 int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
 
 void perf_gtk__init_helpline(void);
+void perf_gtk__init_hpp(void);
 
 #ifndef HAVE_GTK_INFO_BAR
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index ec1ee26b485a..26429437e19e 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -8,6 +8,7 @@ int perf_gtk__init(void)
 {
 	perf_error__register(&perf_gtk_eops);
 	perf_gtk__init_helpline();
+	perf_gtk__init_hpp();
 	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
-- 
1.7.11.4

