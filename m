Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0LAQCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:02:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0LAQCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=EyotKUouOF8MznC6oEmhz2uV+MbV3Hj5f2J3Y7j+6FFdb7mM2cmpdtkEBBtdwhCk7A
         tW+Mc3H7DYcYmGZPOZvQ==
Message-ID: <4cf67197.41e9d80a.7d37.08aa@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 1 Dec 2010 17:00:05 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: add csv-style output to perf stat
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an option (-x) to print counts using a CSV-style output.
This makes it very easy to import counts directly into your favorite
spreadsheet without having to write scripts.

Example:
$  perf stat -x -a -- sleep 1
4009.795961,task-clock-msecs
20,context-switches
2,CPU-migrations
190,page-faults
9595983335,cycles
3492776872,instructions
872718098,branches
29798,branch-misses
44646,cache-references
5026,cache-misses

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c405bca..717c11d 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -58,6 +58,11 @@ to activate system-wide monitoring. Default is to count on all CPUs.
 Do not aggregate counts across all monitored CPUs in system-wide mode (-a).
 This option is only valid in system-wide mode.
 
+-x::
+--csv::
+print counts using a CSV-style (comma separated) output to make it easy to
+import directly into spreadsheets.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 970a7f2..325608d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -76,6 +76,7 @@ static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static bool			no_aggr				= false;
+static bool			csv_output			=  false;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			*all_tids			=  NULL;
@@ -84,6 +85,7 @@ static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  false;
 static const char		*cpu_list;
+static const char		*sep;
 
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -449,12 +451,16 @@ static void print_noise(int counter, double avg)
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
+		sprintf(cpustr, "CPU%-4d%s", cpumap[cpu], sep);
+
+	fprintf(stderr, fmt, cpustr, msecs, sep, event_name(counter));
+
+	if (csv_output)
+		return;
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		fprintf(stderr, " # %10.3f CPUs ",
@@ -466,18 +472,24 @@ static void abs_printout(int cpu, int counter, double avg)
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
+		sprintf(cpustr, "CPU%-4d%s", cpumap[cpu], sep);
 	else
 		cpu = 0;
 
-	if (big_num)
-		fprintf(stderr, "%s %'18.0f  %-24s",
-			cpustr, avg, event_name(counter));
-	else
-		fprintf(stderr, "%s %18.0f  %-24s",
-			cpustr, avg, event_name(counter));
+	fprintf(stderr, fmt, cpustr, avg, sep, event_name(counter));
+
+	if (csv_output)
+		return;
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
@@ -515,8 +527,8 @@ static void print_counter_aggr(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %18s  %-24s\n",
-			"<not counted>", event_name(counter));
+		fprintf(stderr, "%18s%s%-24s\n",
+			"<not counted>", sep, event_name(counter));
 		return;
 	}
 
@@ -525,6 +537,11 @@ static void print_counter_aggr(int counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	if (csv_output) {
+		fputc('\n', stderr);
+		return;
+	}
+
 	print_noise(counter, avg);
 
 	if (scaled) {
@@ -554,8 +571,10 @@ static void print_counter(int counter)
 		ena = cpu_counts[cpu][counter].ena;
 		run = cpu_counts[cpu][counter].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%-4d %18s  %-24s", cpumap[cpu],
-					"<not counted>", event_name(counter));
+			fprintf(stderr, "CPU%-4d%s%18s%s%-24s",
+				cpumap[cpu], sep,
+				"<not counted>", sep,
+				event_name(counter));
 
 			fprintf(stderr, "\n");
 			continue;
@@ -566,11 +585,13 @@ static void print_counter(int counter)
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
@@ -582,21 +603,23 @@ static void print_stat(int argc, const char **argv)
 
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
@@ -606,15 +629,17 @@ static void print_stat(int argc, const char **argv)
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
@@ -670,6 +695,8 @@ static const struct option options[] = {
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
+	OPT_BOOLEAN('x', "csv", &csv_output,
+		    "print counts in CSV format"),
 	OPT_END()
 };
 
@@ -682,6 +709,17 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
+
+	sep = csv_output ? "," : " ";
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
