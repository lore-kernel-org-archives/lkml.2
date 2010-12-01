Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0LARtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:49:33 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0LARtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=YTOEIkyyW2pS6TY0JJak/PckrMb/izECfpTymCIESWTe7FPJAHyGdZsTt2i4gzlPfV
         3YdglF9oj6QQ5VNdZoEA==
Message-ID: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 1 Dec 2010 18:49:05 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: add csv-style output to perf stat (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an option (-x/--field-separator) to print counts using
a CSV-style output. The user can pass a custom separator. This makes it
very easy to import counts directly into your favorite spreadsheet without
having to write scripts.

Example:
$ perf stat --field-separator=,  -a -- sleep 1
4009.961740,task-clock-msecs
13,context-switches
2,CPU-migrations
189,page-faults
9596385684,cycles
3493659441,instructions
872897069,branches
41562,branch-misses
22424,cache-references
1289,cache-misses

Works also in non-aggregated mode:

$ perf stat --x ,  -a -A -- sleep 1
CPU0,1002.526168,task-clock-msecs
CPU1,1002.528365,task-clock-msecs
CPU2,1002.523360,task-clock-msecs
CPU3,1002.519878,task-clock-msecs
CPU0,1,context-switches
CPU1,5,context-switches
CPU2,5,context-switches
CPU3,6,context-switches
CPU0,0,CPU-migrations
CPU1,1,CPU-migrations
CPU2,0,CPU-migrations
CPU3,1,CPU-migrations
CPU0,2,page-faults
CPU1,6,page-faults
CPU2,9,page-faults
CPU3,174,page-faults
CPU0,2399439771,cycles
CPU1,2380369063,cycles
CPU2,2399142710,cycles
CPU3,2373161192,cycles
CPU0,872900618,instructions
CPU1,873030960,instructions
CPU2,872714525,instructions
CPU3,874460580,instructions
CPU0,221556839,branches
CPU1,218134342,branches
CPU2,218161730,branches
CPU3,218284093,branches
CPU0,18556,branch-misses
CPU1,1449,branch-misses
CPU2,3447,branch-misses
CPU3,12714,branch-misses
CPU0,8330,cache-references
CPU1,313844,cache-references
CPU2,47993728,cache-references
CPU3,826481,cache-references
CPU0,272,cache-misses
CPU1,5360,cache-misses
CPU2,1342193,cache-misses
CPU3,13992,cache-misses

This second version adds the ability to name a separator and uses
field-separator as the long option to be consistent with perf report.

Signed-off-by: Stephane Eranian <eranian@google.com>
---


diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c405bca..2d31049 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -58,6 +58,11 @@ to activate system-wide monitoring. Default is to count on all CPUs.
 Do not aggregate counts across all monitored CPUs in system-wide mode (-a).
 This option is only valid in system-wide mode.
 
+-x SEP::
+--field-separator SEP::
+print counts using a CSV-style output to make it easy to import directly into
+spreadsheets. Columns are separated by the string specified in SEP.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 970a7f2..b1abe6a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -52,6 +52,8 @@
 #include <math.h>
 #include <locale.h>
 
+#define DEFAULT_SEPARATOR	" "
+
 static struct perf_event_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
@@ -84,6 +86,8 @@ static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  false;
 static const char		*cpu_list;
+static const char		*csv_sep			= NULL;
+static bool			csv_output			= false;
 
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -449,12 +453,18 @@ static void print_noise(int counter, double avg)
 static void nsec_printout(int cpu, int counter, double avg)
 {
 	double msecs = avg / 1e6;
+	char cpustr[16] = { '\0', };
+	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-24s";
 
 	if (no_aggr)
-		fprintf(stderr, "CPU%-4d %18.6f  %-24s",
-			cpumap[cpu], msecs, event_name(counter));
-	else
-		fprintf(stderr, " %18.6f  %-24s", msecs, event_name(counter));
+		sprintf(cpustr, "CPU%*d%s",
+			csv_output ? 0 : -4,
+			cpumap[cpu], csv_sep);
+
+	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(counter));
+
+	if (csv_output)
+		return;
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		fprintf(stderr, " # %10.3f CPUs ",
@@ -466,18 +476,26 @@ static void abs_printout(int cpu, int counter, double avg)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
+	const char *fmt;
+
+	if (csv_output)
+		fmt = "%s%.0f%s%s";
+	else if (big_num)
+		fmt = "%s%'18.0f%s%-24s";
+	else
+		fmt = "%s%18.0f%s%-24s";
 
 	if (no_aggr)
-		sprintf(cpustr, "CPU%-4d", cpumap[cpu]);
+		sprintf(cpustr, "CPU%*d%s",
+			csv_output ? 0 : -4,
+			cpumap[cpu], csv_sep);
 	else
 		cpu = 0;
 
-	if (big_num)
-		fprintf(stderr, "%s %'18.0f  %-24s",
-			cpustr, avg, event_name(counter));
-	else
-		fprintf(stderr, "%s %18.0f  %-24s",
-			cpustr, avg, event_name(counter));
+	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(counter));
+
+	if (csv_output)
+		return;
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
@@ -515,8 +533,9 @@ static void print_counter_aggr(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %18s  %-24s\n",
-			"<not counted>", event_name(counter));
+		fprintf(stderr, "%*s%s%-24s\n",
+			csv_output ? 0 : 18,
+			"<not counted>", csv_sep, event_name(counter));
 		return;
 	}
 
@@ -525,6 +544,11 @@ static void print_counter_aggr(int counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	if (csv_output) {
+		fputc('\n', stderr);
+		return;
+	}
+
 	print_noise(counter, avg);
 
 	if (scaled) {
@@ -554,8 +578,12 @@ static void print_counter(int counter)
 		ena = cpu_counts[cpu][counter].ena;
 		run = cpu_counts[cpu][counter].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%-4d %18s  %-24s", cpumap[cpu],
-					"<not counted>", event_name(counter));
+			fprintf(stderr, "CPU%*d%s%*s%s%-24s",
+				csv_output ? 0 : -4,
+				cpumap[cpu], csv_sep,
+				csv_output ? 0 : 18,
+				"<not counted>", csv_sep,
+				event_name(counter));
 
 			fprintf(stderr, "\n");
 			continue;
@@ -566,11 +594,13 @@ static void print_counter(int counter)
 		else
 			abs_printout(cpu, counter, val);
 
-		print_noise(counter, 1.0);
+		if (!csv_output) {
+			print_noise(counter, 1.0);
 
-		if (run != ena) {
-			fprintf(stderr, "  (scaled from %.2f%%)",
+			if (run != ena) {
+				fprintf(stderr, "  (scaled from %.2f%%)",
 					100.0 * run / ena);
+			}
 		}
 		fprintf(stderr, "\n");
 	}
@@ -582,21 +612,23 @@ static void print_stat(int argc, const char **argv)
 
 	fflush(stdout);
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, " Performance counter stats for ");
-	if(target_pid == -1 && target_tid == -1) {
-		fprintf(stderr, "\'%s", argv[0]);
-		for (i = 1; i < argc; i++)
-			fprintf(stderr, " %s", argv[i]);
-	} else if (target_pid != -1)
-		fprintf(stderr, "process id \'%d", target_pid);
-	else
-		fprintf(stderr, "thread id \'%d", target_tid);
+	if (!csv_output) {
+		fprintf(stderr, "\n");
+		fprintf(stderr, " Performance counter stats for ");
+		if(target_pid == -1 && target_tid == -1) {
+			fprintf(stderr, "\'%s", argv[0]);
+			for (i = 1; i < argc; i++)
+				fprintf(stderr, " %s", argv[i]);
+		} else if (target_pid != -1)
+			fprintf(stderr, "process id \'%d", target_pid);
+		else
+			fprintf(stderr, "thread id \'%d", target_tid);
 
-	fprintf(stderr, "\'");
-	if (run_count > 1)
-		fprintf(stderr, " (%d runs)", run_count);
-	fprintf(stderr, ":\n\n");
+		fprintf(stderr, "\'");
+		if (run_count > 1)
+			fprintf(stderr, " (%d runs)", run_count);
+		fprintf(stderr, ":\n\n");
+	}
 
 	if (no_aggr) {
 		for (counter = 0; counter < nr_counters; counter++)
@@ -606,15 +638,17 @@ static void print_stat(int argc, const char **argv)
 			print_counter_aggr(counter);
 	}
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, " %18.9f  seconds time elapsed",
-			avg_stats(&walltime_nsecs_stats)/1e9);
-	if (run_count > 1) {
-		fprintf(stderr, "   ( +- %7.3f%% )",
+	if (!csv_output) {
+		fprintf(stderr, "\n");
+		fprintf(stderr, " %18.9f  seconds time elapsed",
+				avg_stats(&walltime_nsecs_stats)/1e9);
+		if (run_count > 1) {
+			fprintf(stderr, "   ( +- %7.3f%% )",
 				100*stddev_stats(&walltime_nsecs_stats) /
 				avg_stats(&walltime_nsecs_stats));
+		}
+		fprintf(stderr, "\n\n");
 	}
-	fprintf(stderr, "\n\n");
 }
 
 static volatile int signr = -1;
@@ -670,6 +704,8 @@ static const struct option options[] = {
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
+	OPT_STRING('x', "field-separator", &csv_sep, "separator",
+		   "print counts with custom separator"),
 	OPT_END()
 };
 
@@ -682,6 +718,20 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (csv_sep)
+		csv_output = true;
+	else
+		csv_sep = DEFAULT_SEPARATOR;
+
+	/*
+	 * let the spreadsheet do the pretty-printing
+	 */
+	if (csv_output && big_num) {
+		fprintf(stderr, "-B option not supported with -x\n");
+		usage_with_options(stat_usage, options);
+	}
+
 	if (!argc && target_pid == -1 && target_tid == -1)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
