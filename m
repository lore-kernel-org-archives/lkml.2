Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2I0LKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab2I0LK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/14] perf hists: Separate overhead and baseline columns
Date: Thu, 27 Sep 2012 13:09:24 +0200
Message-Id: <1348744175-11115-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the overhead and baseline columns are handled within
single function and the distinction is made by 'baseline hists'
pointer passed by 'struct perf_hpp::ptr'.

Since hists pointer is now part of each hist_entry, it's possible
to locate paired hists pointer directly from the passed struct
hist_entry pointer.

Also separating those 2 columns makes the code more obvious.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/hist.c       | 74 ++++++++++++++++++++++++++++++----------------
 tools/perf/ui/stdio/hist.c | 11 +++++--
 tools/perf/util/hist.h     |  1 +
 3 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 55b9ca8..920001d 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,9 +8,7 @@
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
-	const char *fmt = hpp->ptr ? "Baseline" : "Overhead";
-
-	return scnprintf(hpp->buf, hpp->size, fmt);
+	return scnprintf(hpp->buf, hpp->size, "Overhead");
 }
 
 static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
@@ -22,17 +20,6 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
 
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
-
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
@@ -41,17 +28,6 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->period / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	if (hpp->ptr) {
-		struct hists *old_hists = hpp->ptr;
-		u64 total_period = old_hists->stats.total_period;
-		u64 base_period = he->pair ? he->pair->period : 0;
-
-		if (total_period)
-			percent = 100.0 * base_period / total_period;
-		else
-			percent = 0.0;
-	}
-
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
@@ -159,6 +135,47 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
+static int hpp__header_baseline(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "Baseline");
+}
+
+static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
+{
+	return 8;
+}
+
+static double baseline_percent(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	struct hists *pair_hists = pair ? pair->hists : NULL;
+	double percent = 0.0;
+
+	if (pair) {
+		u64 total_period = pair_hists->stats.total_period;
+		u64 base_period  = pair->period;
+
+		percent = 100.0 * base_period / total_period;
+	}
+
+	return percent;
+}
+
+static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+
+	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+}
+
+static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = baseline_percent(he);
+	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+}
+
 static int hpp__header_samples(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
@@ -269,6 +286,7 @@ static int hpp__entry_displ(struct perf_hpp *hpp,
 	.entry	= hpp__entry_ ## _name
 
 struct perf_hpp_fmt perf_hpp__format[] = {
+	{ .cond = false, HPP__COLOR_PRINT_FNS(baseline) },
 	{ .cond = true,  HPP__COLOR_PRINT_FNS(overhead) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_sys) },
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_us) },
@@ -302,6 +320,8 @@ void perf_hpp__init(bool need_pair, bool show_displacement)
 		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
 
 	if (need_pair) {
+		perf_hpp__format[PERF_HPP__OVERHEAD].cond = false;
+		perf_hpp__format[PERF_HPP__BASELINE].cond = true;
 		perf_hpp__format[PERF_HPP__DELTA].cond = true;
 
 		if (show_displacement)
@@ -321,6 +341,7 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 	const char *sep = symbol_conf.field_sep;
 	char *start = hpp->buf;
 	int i, ret;
+	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
@@ -329,9 +350,10 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 		if (!perf_hpp__format[i].cond)
 			continue;
 
-		if (!sep || i > 0) {
+		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
+			first = false;
 		}
 
 		if (color && perf_hpp__format[i].color)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d7405f0..0aa6776 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -353,6 +353,7 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		.size	= sizeof(bf),
 		.ptr	= pair,
 	};
+	bool first = true;
 
 	init_rem_hits();
 
@@ -364,8 +365,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		perf_hpp__format[idx].header(&dummy_hpp);
 		fprintf(fp, "%s", bf);
@@ -400,6 +403,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	if (sep)
 		goto print_entries;
 
+	first = true;
+
 	fprintf(fp, "# ");
 	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
 		unsigned int i;
@@ -407,8 +412,10 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		if (!perf_hpp__format[idx].cond)
 			continue;
 
-		if (idx)
+		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
+		else
+			first = false;
 
 		width = perf_hpp__format[idx].width(&dummy_hpp);
 		for (i = 0; i < width; i++)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6d07f1a..4fd8ddb 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -133,6 +133,7 @@ struct perf_hpp_fmt {
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
+	PERF_HPP__BASELINE,
 	PERF_HPP__OVERHEAD,
 	PERF_HPP__OVERHEAD_SYS,
 	PERF_HPP__OVERHEAD_US,
-- 
1.7.11.4

