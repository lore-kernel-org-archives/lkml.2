Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2JEOpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab2JEOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:45:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/8] perf diff: Add -F option to display formula for computation
Date: Fri,  5 Oct 2012 16:44:45 +0200
Message-Id: <1349448287-18919-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349448287-18919-1-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -F option to display the formula for specified computation.
This is mainly to facilitate debugging, but can be useful anyway.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  4 ++
 tools/perf/builtin-diff.c              | 67 +++++++++++++++++++++++++++++++++-
 tools/perf/ui/hist.c                   | 24 +++++++++++-
 tools/perf/ui/stdio/hist.c             |  2 +-
 tools/perf/util/hist.h                 |  2 +
 5 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 21cc2ef..194f37d 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -87,6 +87,10 @@ OPTIONS
 --period::
         Show period values for both compared hist entries.
 
+-F::
+--formula::
+        Show formula for given computation.
+
 COMPARISON METHODS
 ------------------
 delta
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2411dd1..dd9c064 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -25,6 +25,7 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 static bool show_period;
+static bool show_formula;
 static bool show_baseline_only;
 static bool sort_compute;
 
@@ -190,6 +191,62 @@ s64 perf_diff__compute_wdiff(struct hist_entry *he)
 	return he->diff.wdiff;
 }
 
+static int formula_delta(struct hist_entry *he, char *buf, size_t size)
+{
+	struct hist_entry *pair = he->pair;
+
+	if (!pair)
+		return -1;
+
+	return scnprintf(buf, size,
+			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
+			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
+			  he->stat.period, he->hists->stats.total_period,
+			  pair->stat.period, pair->hists->stats.total_period);
+}
+
+static int formula_ratio(struct hist_entry *he, char *buf, size_t size)
+{
+	struct hist_entry *pair = he->pair;
+	double new_period = he->stat.period;
+	double old_period = pair ? pair->stat.period : 0;
+
+	if (!pair)
+		return -1;
+
+	return scnprintf(buf, size, "%.0F / %.0F", new_period, old_period);
+}
+
+static int formula_wdiff(struct hist_entry *he, char *buf, size_t size)
+{
+	struct hist_entry *pair = he->pair;
+	u64 new_period = he->stat.period;
+	u64 old_period = pair ? pair->stat.period : 0;
+
+	if (!pair)
+		return -1;
+
+	return scnprintf(buf, size,
+		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
+		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
+}
+
+int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
+{
+	switch (compute) {
+	case COMPUTE_DELTA:
+		return formula_delta(he, buf, size);
+	case COMPUTE_RATIO:
+		return formula_ratio(he, buf, size);
+	case COMPUTE_WEIGHTED_DIFF:
+		return formula_wdiff(he, buf, size);
+	default:
+		BUG_ON(1);
+	}
+
+	return -1;
+}
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -543,6 +600,8 @@ static const struct option options[] = {
 		     setup_compute),
 	OPT_BOOLEAN('p', "period", &show_period,
 		    "Show period values."),
+	OPT_BOOLEAN('F', "formula", &show_formula,
+		    "Show formula."),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -571,7 +630,10 @@ static void ui_init(void)
 	/* No overhead column. */
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
 
-	/* Display baseline/delta/ratio/displacement/periods columns. */
+	/*
+	 * Display baseline/delta/ratio/displacement/
+	 * formula/periods columns.
+	 */
 	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
 
 	switch (compute) {
@@ -591,6 +653,9 @@ static void ui_init(void)
 	if (show_displacement)
 		perf_hpp__column_enable(PERF_HPP__DISPL, true);
 
+	if (show_formula)
+		perf_hpp__column_enable(PERF_HPP__FORMULA, true);
+
 	if (show_period) {
 		perf_hpp__column_enable(PERF_HPP__PERIOD, true);
 		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE, true);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 2fadaff..305eb79 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -359,6 +359,27 @@ static int hpp__entry_displ(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
+static int hpp__header_formula(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Formula");
+}
+
+static int hpp__width_formula(struct perf_hpp *hpp __maybe_unused)
+{
+	return 70;
+}
+
+static int hpp__entry_formula(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
+	char buf[96] = " ";
+
+	perf_diff__formula(buf, sizeof(buf), he);
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
+}
+
 #define HPP__COLOR_PRINT_FNS(_name)		\
 	.header	= hpp__header_ ## _name,		\
 	.width	= hpp__width_ ## _name,		\
@@ -383,7 +404,8 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__PRINT_FNS(delta) },
 	{ .cond = false, HPP__PRINT_FNS(ratio) },
 	{ .cond = false, HPP__PRINT_FNS(wdiff) },
-	{ .cond = false, HPP__PRINT_FNS(displ) }
+	{ .cond = false, HPP__PRINT_FNS(displ) },
+	{ .cond = false, HPP__PRINT_FNS(formula) }
 };
 
 #undef HPP__COLOR_PRINT_FNS
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index fbd4e32..f0ee204 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -342,7 +342,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
 	int idx, nr_rows = 0;
-	char bf[64];
+	char bf[96];
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5604791..c751624 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -145,6 +145,7 @@ enum {
 	PERF_HPP__RATIO,
 	PERF_HPP__WEIGHTED_DIFF,
 	PERF_HPP__DISPL,
+	PERF_HPP__FORMULA,
 
 	PERF_HPP__MAX_INDEX
 };
@@ -210,4 +211,5 @@ unsigned int hists__sort_list_width(struct hists *self);
 double perf_diff__compute_delta(struct hist_entry *he);
 double perf_diff__compute_ratio(struct hist_entry *he);
 s64 perf_diff__compute_wdiff(struct hist_entry *he);
+int perf_diff__formula(char *buf, size_t size, struct hist_entry *he);
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.4

