Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2I0LKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab2I0LK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/14] perf diff: Add ratio computation way to compare hist entries
Date: Thu, 27 Sep 2012 13:09:28 +0200
Message-Id: <1348744175-11115-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -c option to select computation method with the current
'Delta' computation as default. Current possible values are of
this option are: 'delta' and 'ratio'.

Adding 'ratio' as new computation way to compare hist entries.
If specified the 'Ratio' column is displayed with value 'r'
computed as:

  r = A->period / B->period

with:
  - A/B being matching hist entry from first/second file specified
    (or perf.data/perf.data.old) respectively.
  - period being the hist entry period value

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt | 33 ++++++++++++++++++++++
 tools/perf/builtin-diff.c              | 51 ++++++++++++++++++++++++++++++++--
 tools/perf/ui/hist.c                   | 28 +++++++++++++++++++
 tools/perf/util/hist.h                 |  1 +
 4 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 6ce9585..8fff061 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -76,6 +76,39 @@ OPTIONS
 --baseline-only::
         Show only items with match in baseline.
 
+-c::
+--compute::
+        Differential computation selection - delta,ratio (default is delta).
+        See COMPARISON METHODS section for more info.
+
+COMPARISON METHODS
+------------------
+delta
+~~~~~
+If specified the 'Delta' column is displayed with value 'd' computed as:
+
+  d = A->period_percent - B->period_percent
+
+with:
+  - A/B being matching hist entry from first/second file specified
+    (or perf.data/perf.data.old) respectively.
+
+  - period_percent being the % of the hist entry period value within
+    single data file
+
+ratio
+~~~~~
+If specified the 'Ratio' column is displayed with value 'r' computed as:
+
+  r = A->period / B->period
+
+with:
+  - A/B being matching hist entry from first/second file specified
+    (or perf.data/perf.data.old) respectively.
+
+  - period being the hist entry period value
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1063c31..b5c15f3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -26,6 +26,40 @@ static bool  force;
 static bool show_displacement;
 static bool show_baseline_only;
 
+enum {
+	COMPUTE_DELTA,
+	COMPUTE_RATIO,
+	COMPUTE_MAX,
+};
+
+const char *compute_names[COMPUTE_MAX] = {
+	[COMPUTE_DELTA] = "delta",
+	[COMPUTE_RATIO] = "ratio",
+};
+
+static int compute;
+
+static int setup_compute(const struct option *opt, const char *str,
+			 int unset __maybe_unused)
+{
+	int *cp = (int *) opt->value;
+	unsigned i;
+
+	if (!str) {
+		*cp = COMPUTE_DELTA;
+		return 0;
+	}
+
+	for (i = 0; i < COMPUTE_MAX; i++)
+		if (!strcmp(str, compute_names[i])) {
+			*cp = i;
+			return 0;
+		}
+
+	pr_err("Failed to find valid compute string\n");
+	return -EINVAL;
+}
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -262,6 +296,9 @@ static const struct option options[] = {
 		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
+	OPT_CALLBACK('c', "compute", &compute, "delta,ratio (default delta)",
+		     "Entries differential computation selection",
+		     setup_compute),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -290,9 +327,19 @@ static void ui_init(void)
 	/* No overhead column. */
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
 
-	/* Display baseline/delta/displacement columns. */
+	/* Display baseline/delta/ratio/displacement columns. */
 	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
-	perf_hpp__column_enable(PERF_HPP__DELTA, true);
+
+	switch (compute) {
+	case COMPUTE_DELTA:
+		perf_hpp__column_enable(PERF_HPP__DELTA, true);
+		break;
+	case COMPUTE_RATIO:
+		perf_hpp__column_enable(PERF_HPP__RATIO, true);
+		break;
+	default:
+		BUG_ON(1);
+	};
 
 	if (show_displacement)
 		perf_hpp__column_enable(PERF_HPP__DISPL, true);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 81bb03e..21aabc6 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -251,6 +251,33 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
+static int hpp__header_ratio(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
+}
+
+static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
+{
+	return 14;
+}
+
+static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	double new_period = he->period;
+	double old_period = pair ? pair->period : 0;
+	double ratio = pair ? new_period / old_period : 0;
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
+	char buf[32] = " ";
+
+	if (ratio > 0.0)
+		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
+
+	return scnprintf(hpp->buf, hpp->size, fmt, buf);
+}
+
 static int hpp__header_displ(struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Displ.");
@@ -296,6 +323,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__PRINT_FNS(samples) },
 	{ .cond = false, HPP__PRINT_FNS(period) },
 	{ .cond = false, HPP__PRINT_FNS(delta) },
+	{ .cond = false, HPP__PRINT_FNS(ratio) },
 	{ .cond = false, HPP__PRINT_FNS(displ) }
 };
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c99317f..2826531 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -142,6 +142,7 @@ enum {
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
 	PERF_HPP__DELTA,
+	PERF_HPP__RATIO,
 	PERF_HPP__DISPL,
 
 	PERF_HPP__MAX_INDEX
-- 
1.7.11.4

