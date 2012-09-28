Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2I1EeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:34:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:44723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2I1Eb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="227581576"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/31] perf, tools: Add perf stat --transaction
Date: Thu, 27 Sep 2012 21:31:30 -0700
Message-Id: <1348806696-31170-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support to perf stat to print the basic transactional execution statistics:
Total cycles, Cycles in Transaction, Cycles in aborted transsactions
using the intx and intx_checkpoint qualifiers.
Transaction Starts and Elision Starts, to compute the average transaction length.

This is a reasonable overview over the success of the transactions.

Enable with a new --transaction / -T option.

This requires measuring these events in a group, since they depend on each
other

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-stat.txt |    3 +
 tools/perf/builtin-stat.c              |  104 +++++++++++++++++++++++++++++---
 2 files changed, 99 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fa173b..6e55bd9 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -108,7 +108,10 @@ with it.  --append may be used here.  Examples:
      3>results  perf stat --log-fd 3          -- $cmd
      3>>results perf stat --log-fd 3 --append -- $cmd
 
+-T::
+--transaction::
 
+Print statistics of transactional execution.  Implies --group.
 
 EXAMPLES
 --------
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 861f0ae..2364605 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,6 +64,9 @@
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
 
+#define is_intx(e)		((e)->attr.intx && !(e)->attr.intx_checkpointed)
+#define is_intx_cp(e)		((e)->attr.intx && (e)->attr.intx_checkpointed)
+
 static struct perf_event_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
@@ -171,7 +174,21 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
 };
 
+/*
+ * Transactional memory stats (-T)
+ * Must run as a group.
+ */
+static struct perf_event_attr transaction_attrs[] = {
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
 
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES, .intx = 1	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES,
+    .intx = 1, .intx_checkpointed = 1 },
+  { .type = PERF_TYPE_HW_TRANSACTION, .config = PERF_COUNT_HW_TRANSACTION_START	},
+  { .type = PERF_TYPE_HW_TRANSACTION, .config = PERF_COUNT_HW_ELISION_START	},
+};
 
 static struct perf_evlist	*evsel_list;
 
@@ -187,6 +204,7 @@ static bool			no_aggr				= false;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
+static bool			transaction_run			=  false;
 static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
@@ -275,7 +293,11 @@ static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
 static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_intx_stats[MAX_NR_CPUS];
+static struct stats runtime_cycles_intxcp_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
+static struct stats runtime_transaction_stats[MAX_NR_CPUS];
+static struct stats runtime_elision_stats[MAX_NR_CPUS];
 
 static int create_perf_stat_counter(struct perf_evsel *evsel,
 				    struct perf_evsel *first)
@@ -350,10 +372,18 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 {
 	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 		update_stats(&runtime_nsecs_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-		update_stats(&runtime_cycles_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
-		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES)) {
+		if (is_intx(counter))
+			update_stats(&runtime_cycles_intx_stats[0], count[0]);
+		else if (is_intx_cp(counter))
+			update_stats(&runtime_cycles_intxcp_stats[0], count[0]);
+		else
+			update_stats(&runtime_cycles_stats[0], count[0]);
+	} else if (perf_evsel__match(counter, HW_TRANSACTION,
+				     HW_TRANSACTION_START))
+		update_stats(&runtime_transaction_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_TRANSACTION, HW_ELISION_START))
+		update_stats(&runtime_elision_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
 		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
@@ -774,7 +804,7 @@ static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, doub
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
-	double total, ratio = 0.0;
+	double total, ratio = 0.0, total2;
 	char cpustr[16] = { '\0', };
 	const char *fmt;
 
@@ -868,12 +898,50 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_BACKEND)) {
 		print_stalled_cycles_backend(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
-		total = avg_stats(&runtime_nsecs_stats[cpu]);
+		if (is_intx(evsel)) {
+			total = avg_stats(&runtime_cycles_stats[cpu]);
+			if (total)
+				fprintf(output,
+					" #   %5.2f%% transactional          ",
+					100.0 * (avg / total));
+		} else if (is_intx_cp(evsel)) {
+			total = avg_stats(&runtime_cycles_stats[cpu]);
+			total2 = avg_stats(&runtime_cycles_intx_stats[cpu]);
+			if (total)
+				fprintf(output,
+					" #   %5.2f%% aborted cycles         ",
+					100.0 * ((total2-avg) / total));
+		} else {
+			total = avg_stats(&runtime_nsecs_stats[cpu]);
+
+			if (total)
+				ratio = 1.0 * avg / total;
+
+			fprintf(output, " # %8.3f GHz                    ", 
+					ratio);
+		}
+	} else if (perf_evsel__match(evsel, HW_TRANSACTION,
+				     HW_TRANSACTION_START) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / transaction ", ratio);
+
+	} else if (perf_evsel__match(evsel, HW_TRANSACTION,
+				      HW_ELISION_START) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
 
 		if (total)
-			ratio = 1.0 * avg / total;
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / elision     ", ratio);
 
-		fprintf(output, " # %8.3f GHz                    ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		char unit = 'M';
 
@@ -1068,6 +1136,16 @@ static int stat__set_big_num(const struct option *opt __used,
 	return 0;
 }
 
+/* Must force groups for transactions */
+static int stat__parse_transaction(const struct option *opt __used,
+				   const char *str __used,
+				   int unset __used)
+{
+	transaction_run = true;
+	group = true;
+	return 0;
+}
+
 static bool append_file;
 
 static const struct option options[] = {
@@ -1115,6 +1193,9 @@ static const struct option options[] = {
 	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
 	OPT_INTEGER(0, "log-fd", &output_fd,
 		    "log output to fd, instead of stderr"),
+	OPT_CALLBACK_NOOPT('T', "transaction", NULL, NULL,
+		     "capture hardware transaction success",
+		     stat__parse_transaction),
 	OPT_END()
 };
 
@@ -1128,6 +1209,13 @@ static int add_default_attributes(void)
 	if (null_run)
 		return 0;
 
+	if (transaction_run) {
+		if (perf_evlist__add_attrs_array(evsel_list, 
+						 transaction_attrs) < 0)
+			return -1;
+		return 0;
+	}
+
 	if (!evsel_list->nr_entries) {
 		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
-- 
1.7.7.6

