Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2I0LMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab2I0LKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/14] perf diff: Add -p option to display period values for hist entries
Date: Thu, 27 Sep 2012 13:09:32 +0200
Message-Id: <1348744175-11115-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -p option to show period values for both compared hist
entries. Showing hist column PERF_HPP__PERIOD and newly added
hist column PERF_HPP__PERIOD_BASELINE.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  4 ++++
 tools/perf/builtin-diff.c              | 10 +++++++++-
 tools/perf/ui/hist.c                   | 21 +++++++++++++++++++++
 tools/perf/util/hist.h                 |  1 +
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fa413ac..21cc2ef 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -83,6 +83,10 @@ OPTIONS
         on the computation results.
         See COMPARISON METHODS section for more info.
 
+-p::
+--period::
+        Show period values for both compared hist entries.
+
 COMPARISON METHODS
 ------------------
 delta
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b0a08aa..799f395 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -24,6 +24,7 @@ static char const *input_old = "perf.data.old",
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
+static bool show_period;
 static bool show_baseline_only;
 static bool sort_compute;
 
@@ -539,6 +540,8 @@ static const struct option options[] = {
 		     "delta,ratio,wdiff:w1,w2 (default delta)",
 		     "Entries differential computation selection",
 		     setup_compute),
+	OPT_BOOLEAN('p', "period", &show_period,
+		    "Show period values."),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -567,7 +570,7 @@ static void ui_init(void)
 	/* No overhead column. */
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD, false);
 
-	/* Display baseline/delta/ratio/displacement columns. */
+	/* Display baseline/delta/ratio/displacement/periods columns. */
 	perf_hpp__column_enable(PERF_HPP__BASELINE, true);
 
 	switch (compute) {
@@ -586,6 +589,11 @@ static void ui_init(void)
 
 	if (show_displacement)
 		perf_hpp__column_enable(PERF_HPP__DISPL, true);
+
+	if (show_period) {
+		perf_hpp__column_enable(PERF_HPP__PERIOD, true);
+		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE, true);
+	}
 }
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 5980ca5..f97c16e 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -228,6 +228,26 @@ static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, he->period);
 }
 
+static int hpp__header_period_baseline(struct perf_hpp *hpp)
+{
+	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
+}
+
+static int hpp__width_period_baseline(struct perf_hpp *hpp __maybe_unused)
+{
+	return 12;
+}
+
+static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	u64 period = pair ? pair->period : 0;
+	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
+
+	return scnprintf(hpp->buf, hpp->size, fmt, period);
+}
 static int hpp__header_delta(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
@@ -359,6 +379,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_us) },
 	{ .cond = false, HPP__PRINT_FNS(samples) },
 	{ .cond = false, HPP__PRINT_FNS(period) },
+	{ .cond = false, HPP__PRINT_FNS(period_baseline) },
 	{ .cond = false, HPP__PRINT_FNS(delta) },
 	{ .cond = false, HPP__PRINT_FNS(ratio) },
 	{ .cond = false, HPP__PRINT_FNS(wdiff) },
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 27866b5..ff307bf 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -140,6 +140,7 @@ enum {
 	PERF_HPP__OVERHEAD_GUEST_US,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
+	PERF_HPP__PERIOD_BASELINE,
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
 	PERF_HPP__WEIGHTED_DIFF,
-- 
1.7.11.4

