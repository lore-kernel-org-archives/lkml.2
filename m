Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2IFPsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758601Ab2IFPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/12] perf diff: Add -p option to display period values for hist entries
Date: Thu,  6 Sep 2012 17:47:04 +0200
Message-Id: <1346946426-13496-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -p option to show period values for both compared hist
entries - showing hist columns HISTC_TOTAL_PERIOD and new stdio
hist column HISTC_BASELINE_TOTAL_PERIOD.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  4 ++++
 tools/perf/builtin-diff.c              |  9 +++++++++
 tools/perf/ui/stdio/hist.c             | 18 ++++++++++++++++++
 tools/perf/util/hist.h                 |  1 +
 4 files changed, 32 insertions(+)

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
index 6d8aba8..1297a01 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -25,6 +25,7 @@ static char const *input_old = "perf.data.old",
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
+static bool show_period;
 static bool show_baseline_only;
 static bool sort_compute;
 
@@ -526,6 +527,8 @@ static const struct option options[] = {
 	OPT_STRING('c', "compute", &compute_str,
 		   "delta,ratio,wdiff:w1,w2 (default delta)",
 		   "Entries differential computation selection"),
+	OPT_BOOLEAN('p', "period", &show_period,
+		    "Show period values."),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
@@ -568,6 +571,12 @@ static void setup_ui_stdio(void)
 
 	if (show_displacement)
 		hists_stdio_column__register_idx(HISTC_DISPLACEMENT);
+
+	if (show_period) {
+		hists_stdio_column__register_idx(HISTC_BASELINE_TOTAL_PERIOD);
+		hists_stdio_column__register_idx(HISTC_TOTAL_PERIOD);
+	}
+
 }
 
 int cmd_diff(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index f580085..ab5f27a 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -93,6 +93,23 @@ hists_stdio_column__total_period_snprintf(struct hist_entry *he, char *bf,
 }
 
 static int
+hists_stdio_column__baseline_total_period_snprintf(struct hist_entry *he,
+						   char *bf, size_t size,
+						   unsigned int width __used)
+{
+	struct hist_entry *pair = he->pair;
+	u64 period = pair ? pair->period : 0;
+	int ret;
+
+	if (period)
+		ret = scnprintf(bf, size , "%15" PRIu64, period);
+	else
+		ret = scnprintf(bf, size, "%15s", " ");
+
+	return ret;
+}
+
+static int
 hists_stdio_column__cpu_sys_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width __used)
 {
@@ -153,6 +170,7 @@ DEF_COLUMN(cpu_guest_sys, HISTC_CPU_UTILIZATION_GUEST_SYS, 8, "guest sys")
 DEF_COLUMN(cpu_guest_us, HISTC_CPU_UTILIZATION_GUEST_US, 8, "guest us")
 DEF_COLUMN(nr_samples, HISTC_NR_SAMPLES, 12, "Samples")
 DEF_COLUMN(total_period, HISTC_TOTAL_PERIOD, 12, "Period")
+DEF_COLUMN(baseline_total_period, HISTC_BASELINE_TOTAL_PERIOD, 15, "Baseline Period")
 DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
 DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
 DEF_COLUMN(wdiff, HISTC_WEIGHTED_DIFF, 13, "Weighted diff")
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 745e0cc..81e6d20 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -45,6 +45,7 @@ enum hist_column {
 	HISTC_CPU_UTILIZATION_GUEST_US,
 	HISTC_NR_SAMPLES,
 	HISTC_TOTAL_PERIOD,
+	HISTC_BASELINE_TOTAL_PERIOD,
 	HISTC_DELTA,
 	HISTC_RATIO,
 	HISTC_WEIGHTED_DIFF,
-- 
1.7.11.4

