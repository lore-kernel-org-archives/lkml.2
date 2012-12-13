Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2LMNJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab2LMNJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:50 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 09/14] perf diff: Move diff related columns into diff command
Date: Thu, 13 Dec 2012 14:09:07 +0100
Message-Id: <1355404152-16523-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving diff related columns into diff command, because they
are not used by any other command.

Also moving the column entry functions under generic one
with baseline as an exception.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 306 +++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/ui/hist.c      | 209 +------------------------------
 tools/perf/util/hist.h    |   7 +-
 3 files changed, 292 insertions(+), 230 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 15a68fb..504b66e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -18,6 +18,27 @@
 #include "util/util.h"
 
 #include <stdlib.h>
+#include <math.h>
+
+/* Diff command specific HPP columns. */
+enum {
+	PERF_HPP_DIFF__BASELINE,
+	PERF_HPP_DIFF__PERIOD,
+	PERF_HPP_DIFF__PERIOD_BASELINE,
+	PERF_HPP_DIFF__DELTA,
+	PERF_HPP_DIFF__RATIO,
+	PERF_HPP_DIFF__WEIGHTED_DIFF,
+	PERF_HPP_DIFF__FORMULA,
+
+	PERF_HPP_DIFF__MAX_INDEX
+};
+
+struct diff_hpp_fmt {
+	struct perf_hpp_fmt	 fmt;
+	int			 idx;
+	char			*header;
+	int			 header_width;
+};
 
 struct data__file {
 	struct perf_session	*session;
@@ -60,6 +81,47 @@ const char *compute_names[COMPUTE_MAX] = {
 
 static int compute;
 
+static int compute_2_hpp[COMPUTE_MAX] = {
+	[COMPUTE_DELTA]		= PERF_HPP_DIFF__DELTA,
+	[COMPUTE_RATIO]		= PERF_HPP_DIFF__RATIO,
+	[COMPUTE_WEIGHTED_DIFF]	= PERF_HPP_DIFF__WEIGHTED_DIFF,
+};
+
+#define MAX_COL_WIDTH 100
+
+static struct header_column {
+	const char *name;
+	int width;
+} columns[PERF_HPP_DIFF__MAX_INDEX] = {
+	[PERF_HPP_DIFF__BASELINE] = {
+		.name  = "Baseline",
+	},
+	[PERF_HPP_DIFF__PERIOD] = {
+		.name  = "Period",
+		.width = 14,
+	},
+	[PERF_HPP_DIFF__PERIOD_BASELINE] = {
+		.name  = "Base period",
+		.width = 14,
+	},
+	[PERF_HPP_DIFF__DELTA] = {
+		.name  = "Delta",
+		.width = 7,
+	},
+	[PERF_HPP_DIFF__RATIO] = {
+		.name  = "Ratio",
+		.width = 14,
+	},
+	[PERF_HPP_DIFF__WEIGHTED_DIFF] = {
+		.name  = "Weighted diff",
+		.width = 14,
+	},
+	[PERF_HPP_DIFF__FORMULA] = {
+		.name  = "Formula",
+		.width = MAX_COL_WIDTH,
+	}
+};
+
 static int setup_compute_opt_wdiff(char *opt)
 {
 	char *w1_str = opt;
@@ -597,34 +659,246 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void ui_init(void)
+static double baseline_percent(struct hist_entry *he)
 {
-	/*
-	 * Display baseline/delta/ratio
-	 * formula/periods columns.
-	 */
-	perf_hpp__column_enable(PERF_HPP__BASELINE);
+	struct hists *hists = he->hists;
+	return 100.0 * he->stat.period / hists->stats.total_period;
+}
 
-	switch (compute) {
-	case COMPUTE_DELTA:
-		perf_hpp__column_enable(PERF_HPP__DELTA);
+static int hpp__color_baseline(struct perf_hpp_fmt *fmt,
+			       struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+	double percent = baseline_percent(he);
+	char pfmt[20] = " ";
+
+	if (!he->dummy) {
+		scnprintf(pfmt, 20, "%%%d.2f%%%%", dfmt->header_width - 1);
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					      pfmt, percent);
+	} else
+		return scnprintf(hpp->buf, hpp->size, "%*s",
+				 dfmt->header_width, pfmt);
+}
+
+static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
+{
+	double percent = baseline_percent(he);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
+	int ret = 0;
+
+	if (!he->dummy)
+		ret = scnprintf(buf, size, fmt, percent);
+
+	return ret;
+}
+
+static void
+hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
+{
+	switch (idx) {
+	case PERF_HPP_DIFF__PERIOD_BASELINE:
+		scnprintf(buf, size, "%" PRIu64, he->stat.period);
 		break;
-	case COMPUTE_RATIO:
-		perf_hpp__column_enable(PERF_HPP__RATIO);
+
+	default:
 		break;
-	case COMPUTE_WEIGHTED_DIFF:
-		perf_hpp__column_enable(PERF_HPP__WEIGHTED_DIFF);
+	}
+}
+
+static void
+hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
+		int idx, char *buf, size_t size)
+{
+	double diff;
+	double ratio;
+	s64 wdiff;
+
+	switch (idx) {
+	case PERF_HPP_DIFF__DELTA:
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio_delta;
+		else
+			diff = perf_diff__compute_delta(he, pair);
+
+		if (fabs(diff) >= 0.01)
+			scnprintf(buf, size, "%+4.2F%%", diff);
+		break;
+
+	case PERF_HPP_DIFF__RATIO:
+		/* No point for ratio number if we are dummy.. */
+		if (he->dummy)
+			break;
+
+		if (pair->diff.computed)
+			ratio = pair->diff.period_ratio;
+		else
+			ratio = perf_diff__compute_ratio(he, pair);
+
+		if (ratio > 0.0)
+			scnprintf(buf, size, "%14.6F", ratio);
+		break;
+
+	case PERF_HPP_DIFF__WEIGHTED_DIFF:
+		/* No point for wdiff number if we are dummy.. */
+		if (he->dummy)
+			break;
+
+		if (pair->diff.computed)
+			wdiff = pair->diff.wdiff;
+		else
+			wdiff = perf_diff__compute_wdiff(he, pair);
+
+		if (wdiff != 0)
+			scnprintf(buf, size, "%14ld", wdiff);
+		break;
+
+	case PERF_HPP_DIFF__FORMULA:
+		perf_diff__formula(he, pair, buf, size);
 		break;
+
+	case PERF_HPP_DIFF__PERIOD:
+		scnprintf(buf, size, "%" PRIu64, pair->stat.period);
+		break;
+
 	default:
 		BUG_ON(1);
 	};
+}
+
+static void
+__hpp__entry_global(struct hist_entry *he, int idx, char *buf, size_t size)
+{
+	struct hist_entry *pair = hist_entry__next_pair(he);
+
+	/* baseline is special */
+	if (idx == PERF_HPP_DIFF__BASELINE)
+		hpp__entry_baseline(he, buf, size);
+	else {
+		if (pair)
+			hpp__entry_pair(he, pair, idx, buf, size);
+		else
+			hpp__entry_unpair(he, idx, buf, size);
+	}
+}
+
+static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
+			     struct hist_entry *he)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(_fmt, struct diff_hpp_fmt, fmt);
+	char buf[MAX_COL_WIDTH] = " ";
+
+	__hpp__entry_global(he, dfmt->idx, buf, MAX_COL_WIDTH);
+
+	if (symbol_conf.field_sep)
+		return scnprintf(hpp->buf, hpp->size, "%s", buf);
+	else
+		return scnprintf(hpp->buf, hpp->size, "%*s",
+				 dfmt->header_width, buf);
+}
+
+static int hpp__header(struct perf_hpp_fmt *fmt,
+		       struct perf_hpp *hpp)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+
+	BUG_ON(!dfmt->header);
+	return scnprintf(hpp->buf, hpp->size, dfmt->header);
+}
+
+static int hpp__width(struct perf_hpp_fmt *fmt,
+		      struct perf_hpp *hpp __maybe_unused)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+
+	BUG_ON(dfmt->header_width <= 0);
+	return dfmt->header_width;
+}
+
+#define hpp__color_global hpp__entry_global
+
+#define FMT(_i, _entry, _color)					\
+	[_i] = {						\
+		.fmt = {					\
+			.header	= hpp__header,			\
+			.width	= hpp__width,			\
+			.entry	= hpp__entry_ ## _entry,	\
+			.color	= hpp__color_ ## _color,	\
+		},						\
+		.idx = _i,					\
+	}
+
+#define FMT_GLOBAL(_i)	 FMT(_i, global, global)
+#define FMT_BASELINE(_i) FMT(_i, global, baseline)
+
+static struct diff_hpp_fmt diff_fmt[] = {
+	FMT_BASELINE(PERF_HPP_DIFF__BASELINE),
+	FMT_GLOBAL(PERF_HPP_DIFF__PERIOD),
+	FMT_GLOBAL(PERF_HPP_DIFF__PERIOD_BASELINE),
+	FMT_GLOBAL(PERF_HPP_DIFF__DELTA),
+	FMT_GLOBAL(PERF_HPP_DIFF__RATIO),
+	FMT_GLOBAL(PERF_HPP_DIFF__WEIGHTED_DIFF),
+	FMT_GLOBAL(PERF_HPP_DIFF__FORMULA),
+};
+
+static void init_header(struct diff_hpp_fmt *dfmt)
+{
+#define MAX_HEADER_NAME 100
+	char buf_indent[MAX_HEADER_NAME];
+	char buf[MAX_HEADER_NAME];
+	const char *header = NULL;
+	int width = 0;
+
+	BUG_ON(dfmt->idx >= PERF_HPP_DIFF__MAX_INDEX);
+	header = columns[dfmt->idx].name;
+	width  = columns[dfmt->idx].width;
+
+	/* Only our defined HPP fmts should appear here. */
+	BUG_ON(!header);
+
+#define NAME (data__files_cnt > 2 ? buf : header)
+	dfmt->header_width = width;
+	width = (int) strlen(NAME);
+	if (dfmt->header_width < width)
+		dfmt->header_width = width;
+
+	scnprintf(buf_indent, MAX_HEADER_NAME, "%*s",
+		  dfmt->header_width, NAME);
+
+	dfmt->header = strdup(buf_indent);
+#undef MAX_HEADER_NAME
+#undef NAME
+}
+
+static void column_enable(unsigned col)
+{
+	struct diff_hpp_fmt *dfmt;
+
+	BUG_ON(col >= PERF_HPP_DIFF__MAX_INDEX);
+	dfmt = &diff_fmt[col];
+	init_header(dfmt);
+	perf_hpp__column_register(&dfmt->fmt);
+}
+
+static void ui_init(void)
+{
+	/*
+	 * Display baseline/delta/ratio/
+	 * formula/periods columns.
+	 */
+	column_enable(PERF_HPP_DIFF__BASELINE);
+	column_enable(compute_2_hpp[compute]);
 
 	if (show_formula)
-		perf_hpp__column_enable(PERF_HPP__FORMULA);
+		column_enable(PERF_HPP_DIFF__FORMULA);
 
 	if (show_period) {
-		perf_hpp__column_enable(PERF_HPP__PERIOD);
-		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE);
+		column_enable(PERF_HPP_DIFF__PERIOD);
+		column_enable(PERF_HPP_DIFF__PERIOD_BASELINE);
 	}
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 7da98ac..0db3b44 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -177,48 +177,6 @@ hpp__entry_overhead_guest_us(struct perf_hpp_fmt *_fmt __maybe_unused,
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
-				struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Baseline");
-}
-
-static int hpp__width_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
-			       struct perf_hpp *hpp __maybe_unused)
-{
-	return 8;
-}
-
-static double baseline_percent(struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	return 100.0 * he->stat.period / hists->stats.total_period;
-}
-
-static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
-			       struct perf_hpp *hpp, struct hist_entry *he)
-{
-	double percent = baseline_percent(he);
-
-	if (!he->dummy)
-		return percent_color_snprintf(hpp->buf, hpp->size,
-					      " %6.2f%%", percent);
-	else
-		return scnprintf(hpp->buf, hpp->size, "        ");
-}
-
-static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
-			       struct perf_hpp *hpp, struct hist_entry *he)
-{
-	double percent = baseline_percent(he);
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
-
-	if (!he->dummy)
-		return scnprintf(hpp->buf, hpp->size, fmt, percent);
-	else
-		return scnprintf(hpp->buf, hpp->size, "            ");
-}
-
 static int hpp__header_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
 			       struct perf_hpp *hpp)
 {
@@ -263,165 +221,6 @@ static int hpp__entry_period(struct perf_hpp_fmt *_fmt __maybe_unused,
 	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
 }
 
-static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
-				       struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
-}
-
-static int hpp__width_period_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
-				      struct perf_hpp *hpp __maybe_unused)
-{
-	return 12;
-}
-
-static int hpp__entry_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
-				      struct perf_hpp *hpp,
-				      struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	u64 period = pair ? pair->stat.period : 0;
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
-
-	return scnprintf(hpp->buf, hpp->size, fmt, period);
-}
-
-static int hpp__header_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
-			     struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Delta");
-}
-
-static int hpp__width_delta(struct perf_hpp_fmt *fmt __maybe_unused,
-			    struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
-
-static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
-			    struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
-	char buf[32] = " ";
-	double diff = 0.0;
-
-	if (pair) {
-		if (he->diff.computed)
-			diff = he->diff.period_ratio_delta;
-		else
-			diff = perf_diff__compute_delta(he, pair);
-	}
-
-	if (fabs(diff) >= 0.01)
-		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
-static int hpp__header_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
-			     struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
-}
-
-static int hpp__width_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
-			    struct perf_hpp *hpp __maybe_unused)
-{
-	return 14;
-}
-
-static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
-			    struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
-	char buf[32] = " ";
-	double ratio = 0.0;
-
-	/* No point for ratio number if we are dummy.. */
-	if (!he->dummy && pair) {
-		if (he->diff.computed)
-			ratio = he->diff.period_ratio;
-		else
-			ratio = perf_diff__compute_ratio(he, pair);
-	}
-
-	if (ratio > 0.0)
-		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
-static int hpp__header_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
-			     struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Weighted diff");
-}
-
-static int hpp__width_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
-			    struct perf_hpp *hpp __maybe_unused)
-{
-	return 14;
-}
-
-static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
-			    struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
-	char buf[32] = " ";
-	s64 wdiff = 0;
-
-	/* No point for wdiff number if we are dummy.. */
-	if (!he->dummy && pair) {
-		if (he->diff.computed)
-			wdiff = he->diff.wdiff;
-		else
-			wdiff = perf_diff__compute_wdiff(he, pair);
-	}
-
-	if (wdiff != 0)
-		scnprintf(buf, sizeof(buf), "%14ld", wdiff);
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
-static int hpp__header_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
-			       struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Formula");
-}
-
-static int hpp__width_formula(struct perf_hpp_fmt *fmt __maybe_unused,
-			      struct perf_hpp *hpp __maybe_unused)
-{
-	return 70;
-}
-
-static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
-			      struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
-	char buf[96] = " ";
-
-	if (pair)
-		perf_diff__formula(he, pair, buf, sizeof(buf));
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
 		.header	= hpp__header_ ## _name,	\
@@ -438,19 +237,13 @@ static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
 	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
-	HPP__COLOR_PRINT_FNS(baseline),
 	HPP__COLOR_PRINT_FNS(overhead),
 	HPP__COLOR_PRINT_FNS(overhead_sys),
 	HPP__COLOR_PRINT_FNS(overhead_us),
 	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
 	HPP__COLOR_PRINT_FNS(overhead_guest_us),
 	HPP__PRINT_FNS(samples),
-	HPP__PRINT_FNS(period),
-	HPP__PRINT_FNS(period_baseline),
-	HPP__PRINT_FNS(delta),
-	HPP__PRINT_FNS(ratio),
-	HPP__PRINT_FNS(wdiff),
-	HPP__PRINT_FNS(formula)
+	HPP__PRINT_FNS(period)
 };
 
 LIST_HEAD(perf_hpp__list);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ae6754d..c60dbe7 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -145,7 +145,7 @@ extern struct list_head perf_hpp__list;
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
-	PERF_HPP__BASELINE,
+	/* Matches perf_hpp__format array. */
 	PERF_HPP__OVERHEAD,
 	PERF_HPP__OVERHEAD_SYS,
 	PERF_HPP__OVERHEAD_US,
@@ -153,11 +153,6 @@ enum {
 	PERF_HPP__OVERHEAD_GUEST_US,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
-	PERF_HPP__PERIOD_BASELINE,
-	PERF_HPP__DELTA,
-	PERF_HPP__RATIO,
-	PERF_HPP__WEIGHTED_DIFF,
-	PERF_HPP__FORMULA,
 
 	PERF_HPP__MAX_INDEX
 };
-- 
1.7.11.7

