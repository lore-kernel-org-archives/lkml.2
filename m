Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149Ab0KPKGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:06:53 -0500
Received: from smtp-out.google.com ([74.125.121.35]:59647 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0KPKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=ukuB0e4z21/NAlxCdTEw2bTcaK9IgcszYV5S0WKrFmCGDFCC2JFFCE5ps9iE/sGzBc
         DS9uyS1DQTvTcZVUIBgQ==
Message-ID: <4ce257b5.1e07e30a.7b6b.3aa9@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 16 Nov 2010 11:05:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf: add no-aggregation mode to perf stat -a (v3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new -A option to perf stat. If specified then perf stat
does not aggregate counts across all monitored CPUs in system-wide mode, i.e.,
when using -a. This option is not supported in per-thread mode.

Being able to get a per-cpu breakdown is useful to detect imbalances between
CPUs when running a uniform workload than spans all monitored CPUs.

The second version corrects the missing cpumap[] support, so that it works
when the -C option is used.

The third version fixes a missing cpumap[] in print_counter() and removes
a stray patch in builtin-trace.c.

Examples on a 4-way system:

# perf stat -a   -e cycles,instructions -- sleep 1
 Performance counter stats for 'sleep 1':
         9592808135  cycles                  
         3490380006  instructions             #      0.364 IPC  
        1.001584632  seconds time elapsed


# perf stat -a -A -e cycles,instructions -- sleep 1
 Performance counter stats for 'sleep 1':
CPU0            2398163767  cycles                  
CPU1            2398180817  cycles                  
CPU2            2398217115  cycles                  
CPU3            2398247483  cycles                  
CPU0             872282046  instructions             #      0.364 IPC  
CPU1             873481776  instructions             #      0.364 IPC  
CPU2             872638127  instructions             #      0.364 IPC  
CPU3             872437789  instructions             #      0.364 IPC  
        1.001556052  seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4b3a2d4..c405bca 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -53,6 +53,11 @@ comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2
 In per-thread mode, this option is ignored. The -a option is still necessary
 to activate system-wide monitoring. Default is to count on all CPUs.
 
+-A::
+--no-aggr::
+Do not aggregate counts across all monitored CPUs in system-wide mode (-a).
+This option is only valid in system-wide mode.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..b3e568f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -75,6 +75,7 @@ static int			run_idx				=  0;
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
+static bool			no_aggr				= false;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			*all_tids			=  NULL;
@@ -89,6 +90,12 @@ static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			event_scaled[MAX_COUNTERS];
 
+static struct {
+	u64 val;
+	u64 ena;
+	u64 run;
+} cpu_counts[MAX_NR_CPUS][MAX_COUNTERS];
+
 static volatile int done = 0;
 
 struct stats
@@ -136,10 +143,10 @@ static double stddev_stats(struct stats *stats)
 }
 
 struct stats			event_res_stats[MAX_COUNTERS][3];
-struct stats			runtime_nsecs_stats;
+struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
+struct stats			runtime_cycles_stats[MAX_NR_CPUS];
+struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
-struct stats			runtime_cycles_stats;
-struct stats			runtime_branches_stats;
 
 #define MATCH_EVENT(t, c, counter)			\
 	(attrs[counter].type == PERF_TYPE_##t &&	\
@@ -205,8 +212,9 @@ static inline int nsec_counter(int counter)
 
 /*
  * Read out the results of a single counter:
+ * aggregate counts across CPUs in system-wide mode
  */
-static void read_counter(int counter)
+static void read_counter_aggr(int counter)
 {
 	u64 count[3], single_count[3];
 	int cpu;
@@ -264,11 +272,58 @@ static void read_counter(int counter)
 	 * Save the full runtime - to allow normalization during printout:
 	 */
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
-		update_stats(&runtime_nsecs_stats, count[0]);
+		update_stats(&runtime_nsecs_stats[0], count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
-		update_stats(&runtime_cycles_stats, count[0]);
+		update_stats(&runtime_cycles_stats[0], count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
-		update_stats(&runtime_branches_stats, count[0]);
+		update_stats(&runtime_branches_stats[0], count[0]);
+}
+
+/*
+ * Read out the results of a single counter:
+ * do not aggregate counts across CPUs in system-wide mode
+ */
+static void read_counter(int counter)
+{
+	u64 count[3];
+	int cpu;
+	size_t res, nv;
+
+	count[0] = count[1] = count[2] = 0;
+
+	nv = scale ? 3 : 1;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+
+		if (fd[cpu][counter][0] < 0)
+			continue;
+
+		res = read(fd[cpu][counter][0], count, nv * sizeof(u64));
+
+		assert(res == nv * sizeof(u64));
+
+		close(fd[cpu][counter][0]);
+		fd[cpu][counter][0] = -1;
+
+		if (scale) {
+			if (count[2] == 0) {
+				count[0] = 0;
+			} else if (count[2] < count[1]) {
+				count[0] = (unsigned long long)
+				((double)count[0] * count[1] / count[2] + 0.5);
+			}
+		}
+		cpu_counts[cpu][counter].val = count[0]; /* scaled count */
+		cpu_counts[cpu][counter].ena = count[1];
+		cpu_counts[cpu][counter].run = count[2];
+
+		if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+			update_stats(&runtime_nsecs_stats[cpu], count[0]);
+		if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
+			update_stats(&runtime_cycles_stats[cpu], count[0]);
+		if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
+			update_stats(&runtime_branches_stats[cpu], count[0]);
+	}
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -362,9 +417,13 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
-	for (counter = 0; counter < nr_counters; counter++)
-		read_counter(counter);
-
+	if (no_aggr) {
+		for (counter = 0; counter < nr_counters; counter++)
+			read_counter(counter);
+	} else {
+		for (counter = 0; counter < nr_counters; counter++)
+			read_counter_aggr(counter);
+	}
 	return WEXITSTATUS(status);
 }
 
@@ -377,11 +436,15 @@ static void print_noise(int counter, double avg)
 			100 * stddev_stats(&event_res_stats[counter][0]) / avg);
 }
 
-static void nsec_printout(int counter, double avg)
+static void nsec_printout(int cpu, int counter, double avg)
 {
 	double msecs = avg / 1e6;
 
-	fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));
+	if (no_aggr)
+		fprintf(stderr, "CPU%-4d %18.6f  %-24s",
+			cpumap[cpu], msecs, event_name(counter));
+	else
+		fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		fprintf(stderr, " # %10.3f CPUs ",
@@ -389,33 +452,41 @@ static void nsec_printout(int counter, double avg)
 	}
 }
 
-static void abs_printout(int counter, double avg)
+static void abs_printout(int cpu, int counter, double avg)
 {
 	double total, ratio = 0.0;
+	char cpustr[16] = { '\0', };
+
+	if (no_aggr)
+		sprintf(cpustr, "CPU%-4d", cpumap[cpu]);
+	else
+		cpu = 0;
 
 	if (big_num)
-		fprintf(stderr, " %'18.0f  %-24s", avg, event_name(counter));
+		fprintf(stderr, "%s %'18.0f  %-24s",
+			cpustr, avg, event_name(counter));
 	else
-		fprintf(stderr, " %18.0f  %-24s", avg, event_name(counter));
+		fprintf(stderr, "%s %18.0f  %-24s",
+			cpustr, avg, event_name(counter));
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
-		total = avg_stats(&runtime_cycles_stats);
+		total = avg_stats(&runtime_cycles_stats[cpu]);
 
 		if (total)
 			ratio = avg / total;
 
 		fprintf(stderr, " # %10.3f IPC  ", ratio);
 	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter) &&
-			runtime_branches_stats.n != 0) {
-		total = avg_stats(&runtime_branches_stats);
+			runtime_branches_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_branches_stats[cpu]);
 
 		if (total)
 			ratio = avg * 100 / total;
 
 		fprintf(stderr, " # %10.3f %%    ", ratio);
 
-	} else if (runtime_nsecs_stats.n != 0) {
-		total = avg_stats(&runtime_nsecs_stats);
+	} else if (runtime_nsecs_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
 			ratio = 1000.0 * avg / total;
@@ -426,8 +497,9 @@ static void abs_printout(int counter, double avg)
 
 /*
  * Print out the results of a single counter:
+ * aggregated counts in system-wide mode
  */
-static void print_counter(int counter)
+static void print_counter_aggr(int counter)
 {
 	double avg = avg_stats(&event_res_stats[counter][0]);
 	int scaled = event_scaled[counter];
@@ -439,9 +511,9 @@ static void print_counter(int counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(counter, avg);
+		nsec_printout(-1, counter, avg);
 	else
-		abs_printout(counter, avg);
+		abs_printout(-1, counter, avg);
 
 	print_noise(counter, avg);
 
@@ -458,6 +530,42 @@ static void print_counter(int counter)
 	fprintf(stderr, "\n");
 }
 
+/*
+ * Print out the results of a single counter:
+ * does not use aggregated count in system-wide
+ */
+static void print_counter(int counter)
+{
+	u64 ena, run, val;
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		val = cpu_counts[cpu][counter].val;
+		ena = cpu_counts[cpu][counter].ena;
+		run = cpu_counts[cpu][counter].run;
+		if (run == 0 || ena == 0) {
+			fprintf(stderr, "CPU%-4d %18s  %-24s", cpumap[cpu],
+					"<not counted>", event_name(counter));
+
+			fprintf(stderr, "\n");
+			continue;
+		}
+
+		if (nsec_counter(counter))
+			nsec_printout(cpu, counter, val);
+		else
+			abs_printout(cpu, counter, val);
+
+		print_noise(counter, 1.0);
+
+		if (run != ena) {
+			fprintf(stderr, "  (scaled from %.2f%%)",
+					100.0 * run / ena);
+		}
+		fprintf(stderr, "\n");
+	}
+}
+
 static void print_stat(int argc, const char **argv)
 {
 	int i, counter;
@@ -480,8 +588,13 @@ static void print_stat(int argc, const char **argv)
 		fprintf(stderr, " (%d runs)", run_count);
 	fprintf(stderr, ":\n\n");
 
-	for (counter = 0; counter < nr_counters; counter++)
-		print_counter(counter);
+	if (no_aggr) {
+		for (counter = 0; counter < nr_counters; counter++)
+			print_counter(counter);
+	} else {
+		for (counter = 0; counter < nr_counters; counter++)
+			print_counter_aggr(counter);
+	}
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %18.9f  seconds time elapsed",
@@ -545,6 +658,8 @@ static const struct option options[] = {
 		    "print large numbers with thousands\' separators"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
+	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
+		    "disable CPU count aggregation"),
 	OPT_END()
 };
 
@@ -562,6 +677,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
+	/* no_aggr is for system-wide only */
+	if (no_aggr && !system_wide)
+		usage_with_options(stat_usage, options);
+
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
