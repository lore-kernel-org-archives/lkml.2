Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2K1Nxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab2K1Nxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 01/14] perf tool: Introduce perf_hpp__list for period related columns
Date: Wed, 28 Nov 2012 14:52:36 +0100
Message-Id: <1354110769-2998-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_hpp__list list to register and contain all period
related columns the command is interested in.

This way we get rid of static array holding all possible
columns and enable commands to register their own columns.

It'll be handy for diff command in future to process and display
data for multiple files.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c      | 21 ++++-----
 tools/perf/builtin-report.c    |  1 +
 tools/perf/ui/browsers/hists.c | 18 +++++---
 tools/perf/ui/gtk/browser.c    | 28 +++++-------
 tools/perf/ui/hist.c           | 96 +++++++++++++++++++++++-------------------
 tools/perf/ui/setup.c          |  1 +
 tools/perf/ui/stdio/hist.c     | 17 +++-----
 tools/perf/util/hist.h         | 11 ++++-
 8 files changed, 99 insertions(+), 94 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 93b852f..9fbbc01 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -597,40 +597,35 @@ static const struct option options[] = {
 
 static void ui_init(void)
 {
-	perf_hpp__init();
-
-	/* No overhead column. */
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
-
 	/*
 	 * Display baseline/delta/ratio/displacement/
 	 * formula/periods columns.
 	 */
-	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
+	perf_hpp__column_enable(PERF_HPP__BASELINE);
 
 	switch (compute) {
 	case COMPUTE_DELTA:
-		perf_hpp__column_enable(PERF_HPP__DELTA, true);
+		perf_hpp__column_enable(PERF_HPP__DELTA);
 		break;
 	case COMPUTE_RATIO:
-		perf_hpp__column_enable(PERF_HPP__RATIO, true);
+		perf_hpp__column_enable(PERF_HPP__RATIO);
 		break;
 	case COMPUTE_WEIGHTED_DIFF:
-		perf_hpp__column_enable(PERF_HPP__WEIGHTED_DIFF, true);
+		perf_hpp__column_enable(PERF_HPP__WEIGHTED_DIFF);
 		break;
 	default:
 		BUG_ON(1);
 	};
 
 	if (show_displacement)
-		perf_hpp__column_enable(PERF_HPP__DISPL, true);
+		perf_hpp__column_enable(PERF_HPP__DISPL);
 
 	if (show_formula)
-		perf_hpp__column_enable(PERF_HPP__FORMULA, true);
+		perf_hpp__column_enable(PERF_HPP__FORMULA);
 
 	if (show_period) {
-		perf_hpp__column_enable(PERF_HPP__PERIOD, true);
-		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE, true);
+		perf_hpp__column_enable(PERF_HPP__PERIOD);
+		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE);
 	}
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc25100..5134acf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -692,6 +692,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		setup_browser(true);
 	else {
 		use_browser = 0;
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 	}
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ccc4bd1..96fdbc8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -587,6 +587,8 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
@@ -607,12 +609,13 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 {
 	char s[256];
 	double percent;
-	int i, printed = 0;
+	int printed = 0;
 	int width = browser->b.width;
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
 	bool first = true;
+	struct perf_hpp_fmt *fmt;
 
 	if (current_entry) {
 		browser->he_selection = entry;
@@ -629,12 +632,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.buf		= s,
 			.size		= sizeof(s),
 		};
+		int i = 0;
 
 		ui_browser__gotorc(&browser->b, row, 0);
 
-		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-			if (!perf_hpp__format[i].cond)
-				continue;
+		perf_hpp__for_each_format(fmt) {
 
 			if (!first) {
 				slsmg_printf("  ");
@@ -642,10 +644,10 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			}
 			first = false;
 
-			if (perf_hpp__format[i].color) {
+			if (fmt->color) {
 				hpp.ptr = &percent;
 				/* It will set percent for us. See HPP__COLOR_FN above. */
-				width -= perf_hpp__format[i].color(&hpp, entry);
+				width -= fmt->color(&hpp, entry);
 
 				ui_browser__set_percent_color(&browser->b, percent, current_entry);
 
@@ -659,9 +661,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 				if (!current_entry || !browser->b.navkeypressed)
 					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 			} else {
-				width -= perf_hpp__format[i].entry(&hpp, entry);
+				width -= fmt->entry(&hpp, entry);
 				slsmg_printf("%s", s);
 			}
+
+			i++;
 		}
 
 		/* The scroll bar isn't being used */
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 253b621..c4aac7b 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -74,6 +74,8 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
@@ -90,6 +92,7 @@ void perf_gtk__init_hpp(void)
 
 static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
+	struct perf_hpp_fmt *fmt;
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
 	struct sort_entry *se;
@@ -107,12 +110,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 	nr_cols = 0;
 
-	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		if (!perf_hpp__format[i].cond)
-			continue;
-
+	perf_hpp__for_each_format(fmt)
 		col_types[nr_cols++] = G_TYPE_STRING;
-	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
@@ -129,12 +128,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 	col_idx = 0;
 
-	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		if (!perf_hpp__format[i].cond)
-			continue;
-
-		perf_hpp__format[i].header(&hpp);
-
+	perf_hpp__for_each_format(fmt) {
+		fmt->header(&hpp);
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
 							    -1, s,
 							    renderer, "markup",
@@ -166,14 +161,11 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 		col_idx = 0;
 
-		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-			if (!perf_hpp__format[i].cond)
-				continue;
-
-			if (perf_hpp__format[i].color)
-				perf_hpp__format[i].color(&hpp, h);
+		perf_hpp__for_each_format(fmt) {
+			if (fmt->color)
+				fmt->color(&hpp, h);
 			else
-				perf_hpp__format[i].entry(&hpp, h);
+				fmt->entry(&hpp, h);
 
 			gtk_list_store_set(store, &iter, col_idx++, s, -1);
 		}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index aa84130..0a5281f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -386,60 +386,71 @@ static int hpp__entry_formula(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-#define HPP__COLOR_PRINT_FNS(_name)		\
-	.header	= hpp__header_ ## _name,		\
-	.width	= hpp__width_ ## _name,		\
-	.color	= hpp__color_ ## _name,		\
-	.entry	= hpp__entry_ ## _name
+#define HPP__COLOR_PRINT_FNS(_name)			\
+	{						\
+		.header	= hpp__header_ ## _name,	\
+		.width	= hpp__width_ ## _name,		\
+		.color	= hpp__color_ ## _name,		\
+		.entry	= hpp__entry_ ## _name		\
+	}
 
-#define HPP__PRINT_FNS(_name)			\
-	.header	= hpp__header_ ## _name,		\
-	.width	= hpp__width_ ## _name,		\
-	.entry	= hpp__entry_ ## _name
+#define HPP__PRINT_FNS(_name)				\
+	{						\
+		.header	= hpp__header_ ## _name,	\
+		.width	= hpp__width_ ## _name,		\
+		.entry	= hpp__entry_ ## _name		\
+	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
-	{ .cond = false, HPP__COLOR_PRINT_FNS(baseline) },
-	{ .cond = true,  HPP__COLOR_PRINT_FNS(overhead) },
-	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_sys) },
-	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_us) },
-	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_sys) },
-	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_us) },
-	{ .cond = false, HPP__PRINT_FNS(samples) },
-	{ .cond = false, HPP__PRINT_FNS(period) },
-	{ .cond = false, HPP__PRINT_FNS(period_baseline) },
-	{ .cond = false, HPP__PRINT_FNS(delta) },
-	{ .cond = false, HPP__PRINT_FNS(ratio) },
-	{ .cond = false, HPP__PRINT_FNS(wdiff) },
-	{ .cond = false, HPP__PRINT_FNS(displ) },
-	{ .cond = false, HPP__PRINT_FNS(formula) }
+	HPP__COLOR_PRINT_FNS(baseline),
+	HPP__COLOR_PRINT_FNS(overhead),
+	HPP__COLOR_PRINT_FNS(overhead_sys),
+	HPP__COLOR_PRINT_FNS(overhead_us),
+	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
+	HPP__COLOR_PRINT_FNS(overhead_guest_us),
+	HPP__PRINT_FNS(samples),
+	HPP__PRINT_FNS(period),
+	HPP__PRINT_FNS(period_baseline),
+	HPP__PRINT_FNS(delta),
+	HPP__PRINT_FNS(ratio),
+	HPP__PRINT_FNS(wdiff),
+	HPP__PRINT_FNS(displ),
+	HPP__PRINT_FNS(formula)
 };
 
+LIST_HEAD(perf_hpp__list);
+
 #undef HPP__COLOR_PRINT_FNS
 #undef HPP__PRINT_FNS
 
 void perf_hpp__init(void)
 {
 	if (symbol_conf.show_cpu_utilization) {
-		perf_hpp__format[PERF_HPP__OVERHEAD_SYS].cond = true;
-		perf_hpp__format[PERF_HPP__OVERHEAD_US].cond = true;
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD_SYS);
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD_US);
 
 		if (perf_guest) {
-			perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_SYS].cond = true;
-			perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].cond = true;
+			perf_hpp__column_enable(PERF_HPP__OVERHEAD_GUEST_SYS);
+			perf_hpp__column_enable(PERF_HPP__OVERHEAD_GUEST_US);
 		}
 	}
 
 	if (symbol_conf.show_nr_samples)
-		perf_hpp__format[PERF_HPP__SAMPLES].cond = true;
+		perf_hpp__column_enable(PERF_HPP__SAMPLES);
 
 	if (symbol_conf.show_total_period)
-		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
+		perf_hpp__column_enable(PERF_HPP__PERIOD);
 }
 
-void perf_hpp__column_enable(unsigned col, bool enable)
+void perf_hpp__column_register(struct perf_hpp_fmt *format)
+{
+	list_add_tail(&format->list, &perf_hpp__list);
+}
+
+void perf_hpp__column_enable(unsigned col)
 {
 	BUG_ON(col >= PERF_HPP__MAX_INDEX);
-	perf_hpp__format[col].cond = enable;
+	perf_hpp__column_register(&perf_hpp__format[col]);
 }
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
@@ -452,27 +463,25 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 				bool color)
 {
 	const char *sep = symbol_conf.field_sep;
+	struct perf_hpp_fmt *fmt;
 	char *start = hpp->buf;
-	int i, ret;
+	int ret;
 	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
 
-	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		if (!perf_hpp__format[i].cond)
-			continue;
-
+	perf_hpp__for_each_format(fmt) {
 		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
 			first = false;
 		}
 
-		if (color && perf_hpp__format[i].color)
-			ret = perf_hpp__format[i].color(hpp, he);
+		if (color && fmt->color)
+			ret = fmt->color(hpp, he);
 		else
-			ret = perf_hpp__format[i].entry(hpp, he);
+			ret = fmt->entry(hpp, he);
 
 		advance_hpp(hpp, ret);
 	}
@@ -504,16 +513,15 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
  */
 unsigned int hists__sort_list_width(struct hists *hists)
 {
+	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
-	int i, ret = 0;
+	int i = 0, ret = 0;
 
-	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		if (!perf_hpp__format[i].cond)
-			continue;
+	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += perf_hpp__format[i].width(NULL);
+		ret += fmt->width(NULL);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ebb4cc1..166f13d 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -30,6 +30,7 @@ void setup_browser(bool fallback_to_pager)
 		if (fallback_to_pager)
 			setup_pager();
 
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 		break;
 	}
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index f0ee204..0eae3b2 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -335,13 +335,14 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, FILE *fp)
 {
+	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
-	int idx, nr_rows = 0;
+	int nr_rows = 0;
 	char bf[96];
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
@@ -355,16 +356,14 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		goto print_entries;
 
 	fprintf(fp, "# ");
-	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
-		if (!perf_hpp__format[idx].cond)
-			continue;
 
+	perf_hpp__for_each_format(fmt) {
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
 			first = false;
 
-		perf_hpp__format[idx].header(&dummy_hpp);
+		fmt->header(&dummy_hpp);
 		fprintf(fp, "%s", bf);
 	}
 
@@ -400,18 +399,16 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	first = true;
 
 	fprintf(fp, "# ");
-	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
-		unsigned int i;
 
-		if (!perf_hpp__format[idx].cond)
-			continue;
+	perf_hpp__for_each_format(fmt) {
+		unsigned int i;
 
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
 			first = false;
 
-		width = perf_hpp__format[idx].width(&dummy_hpp);
+		width = fmt->width(&dummy_hpp);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a5..a935a60 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -126,13 +126,19 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	bool cond;
 	int (*header)(struct perf_hpp *hpp);
 	int (*width)(struct perf_hpp *hpp);
 	int (*color)(struct perf_hpp *hpp, struct hist_entry *he);
 	int (*entry)(struct perf_hpp *hpp, struct hist_entry *he);
+
+	struct list_head list;
 };
 
+extern struct list_head perf_hpp__list;
+
+#define perf_hpp__for_each_format(format) \
+	list_for_each_entry(format, &perf_hpp__list, list)
+
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
@@ -155,7 +161,8 @@ enum {
 };
 
 void perf_hpp__init(void);
-void perf_hpp__column_enable(unsigned col, bool enable);
+void perf_hpp__column_register(struct perf_hpp_fmt *format);
+void perf_hpp__column_enable(unsigned col);
 int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 				bool color);
 
-- 
1.7.11.7

