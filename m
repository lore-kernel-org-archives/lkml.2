Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2JRXX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:23:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:4639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab2JRXT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="229462631"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 30/34] perf, tools: Add perf stat --transaction v2
Date: Thu, 18 Oct 2012 16:19:38 -0700
Message-Id: <1350602382-12771-31-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
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
other.

This is implemented by using TM sysfs events exported by the kernel

v2: Only print the extended statistics when the option is enabled.
This avoids negative output when the user specifies the -T events
in separate groups.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-stat.txt |    3 +
 tools/perf/builtin-stat.c              |  101 +++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.h                |    6 ++
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fa173b..653bdbd 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -108,7 +108,10 @@ with it.  --append may be used here.  Examples:
      3>results  perf stat --log-fd 3          -- $cmd
      3>>results perf stat --log-fd 3 --append -- $cmd
 
+-T::
+--transaction::
 
+Print statistics of transactional execution if supported.
 
 EXAMPLES
 --------
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 93b9011..a451490 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -64,6 +64,29 @@
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
 
+static const char *transaction_attrs[] = {
+	"task-clock",
+	"{"
+	"instructions,"
+	"cycles,"
+	"cpu/cycles-t/,"
+	"cpu/cycles-ct/,"
+	"cpu/tx-start/,"
+	"cpu/el-start/"
+	"}"
+};
+
+/* must match the transaction_attrs above */
+enum {
+	T_TASK_CLOCK,
+	T_INSTRUCTIONS,
+	T_CYCLES,
+	T_CYCLES_INTX,
+	T_CYCLES_INTX_CP,
+	T_TRANSACTION_START,
+	T_ELISION_START
+};
+
 static struct perf_evlist	*evsel_list;
 
 static struct perf_target	target = {
@@ -77,6 +100,7 @@ static bool			no_aggr				= false;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
+static bool			transaction_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
@@ -123,7 +147,11 @@ static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
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
@@ -183,6 +211,18 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 	return 0;
 }
 
+static struct perf_evsel *nth_evsel(int n)
+{
+	struct perf_evsel *ev;
+	int j;
+
+	j = 0;
+	list_for_each_entry (ev, &evsel_list->entries, node)
+		if (j++ == n)
+			return ev;
+	return NULL;
+}
+
 /*
  * Update various tracking values we maintain to print
  * more semantic information such as miss/hit ratios,
@@ -194,8 +234,14 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
-		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_INTX)))
+		update_stats(&runtime_cycles_intx_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_INTX_CP)))
+		update_stats(&runtime_cycles_intxcp_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_TRANSACTION_START)))
+		update_stats(&runtime_transaction_stats[0], count[0]);
+	else if (perf_evsel__cmp(counter, nth_evsel(T_ELISION_START)))
+		update_stats(&runtime_elision_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
 		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
@@ -633,7 +679,7 @@ static void print_ll_cache_misses(int cpu,
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
-	double total, ratio = 0.0;
+	double total, ratio = 0.0, total2;
 	char cpustr[16] = { '\0', };
 	const char *fmt;
 
@@ -733,6 +779,41 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 			ratio = 1.0 * avg / total;
 
 		fprintf(output, " # %8.3f GHz                    ", ratio);
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_INTX)) && 
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% transactional cycles   ",
+				100.0 * (avg / total));
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_INTX_CP)) &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+		total2 = avg_stats(&runtime_cycles_intx_stats[cpu]);
+		if (total)
+			fprintf(output,
+				" #   %5.2f%% aborted cycles         ",
+				100.0 * ((total2-avg) / total));
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0 &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / transaction ", ratio);
+	} else if (perf_evsel__cmp(evsel, nth_evsel(T_ELISION_START)) &&
+		   avg > 0 &&
+		   runtime_cycles_intx_stats[cpu].n != 0 &&
+		   transaction_run) {
+		total = avg_stats(&runtime_cycles_intx_stats[cpu]);
+
+		if (total)
+			ratio = total / avg;
+
+		fprintf(output, " # %8.0f cycles / elision     ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		char unit = 'M';
 
@@ -1039,6 +1120,18 @@ static int add_default_attributes(void)
 	if (null_run)
 		return 0;
 
+	if (transaction_run) {
+		unsigned i;
+
+		for (i = 0; i < ARRAY_SIZE(transaction_attrs); i++) {
+			if (parse_events(evsel_list, transaction_attrs[i], 0)) {
+				fprintf(stderr, "Cannot set up transaction events\n");
+				return -1;
+			}
+		}
+		return 0;
+	}
+
 	if (!evsel_list->nr_entries) {
 		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
 			return -1;
@@ -1114,6 +1207,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
 	OPT_INTEGER(0, "log-fd", &output_fd,
 		    "log output to fd, instead of stderr"),
+	OPT_BOOLEAN('T', "transaction", &transaction_run,
+		    "hardware transaction statistics"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6f94d6d..418405e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -158,6 +158,12 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
 	       (e1->attr.config == e2->attr.config);
 }
 
+#define perf_evsel__cmp(a, b)			\
+	((a) &&					\
+	 (b) &&					\
+	 (a)->attr.type == (b)->attr.type &&	\
+	 (a)->attr.config == (b)->attr.config)
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 
-- 
1.7.7.6

