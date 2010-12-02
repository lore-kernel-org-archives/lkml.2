Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0LBLsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:48:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:32814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab0LBLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:48:36 -0500
Date: Thu, 2 Dec 2010 11:48:04 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
References: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add csv-style output
Message-ID: <tip-d7470b6afca85ed4388fff57fc9d89f5a3be02ff@git.kernel.org>
Git-Commit-ID: d7470b6afca85ed4388fff57fc9d89f5a3be02ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:48:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7470b6afca85ed4388fff57fc9d89f5a3be02ff
Gitweb:     http://git.kernel.org/tip/d7470b6afca85ed4388fff57fc9d89f5a3be02ff
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 1 Dec 2010 18:49:05 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 19:47:41 -0200

perf stat: Add csv-style output

This patch adds an option (-x/--field-separator) to print counts using a
CSV-style output. The user can pass a custom separator. This makes it very easy
to import counts directly into your favorite spreadsheet without having to
write scripts.

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

$ perf stat -x ,  -a -A -- sleep 1
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

Commiter note: Since we enabled --big-num by default in 201e0b0 and -x can't be
used with it, we need to notice if the user explicitely enabled or disabled -B,
add code to disable big_num if the user didn't explicitely set --big_num when
-x is used.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederik Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: paulus@samba.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |    5 +
 tools/perf/builtin-stat.c              |  144 +++++++++++++++++++++++---------
 2 files changed, 109 insertions(+), 40 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c469ba5..b6da7af 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -78,6 +78,11 @@ This option is only valid in system-wide mode.
 --verbose::
         be more verbose (show counter open errors, etc)
 
+-x SEP::
+--field-separator SEP::
+print counts using a CSV-style output to make it easy to import directly into
+spreadsheets. Columns are separated by the string specified in SEP.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index acbf7cc..7ff746d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -52,6 +52,8 @@
 #include <math.h>
 #include <locale.h>
 
+#define DEFAULT_SEPARATOR	" "
+
 static struct perf_event_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
@@ -83,7 +85,10 @@ static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  true;
+static int			big_num_opt			=  -1;
 static const char		*cpu_list;
+static const char		*csv_sep			= NULL;
+static bool			csv_output			= false;
 
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -449,12 +454,18 @@ static void print_noise(int counter, double avg)
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
@@ -466,18 +477,26 @@ static void abs_printout(int cpu, int counter, double avg)
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
@@ -515,8 +534,9 @@ static void print_counter_aggr(int counter)
 	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %18s  %-24s\n",
-			"<not counted>", event_name(counter));
+		fprintf(stderr, "%*s%s%-24s\n",
+			csv_output ? 0 : 18,
+			"<not counted>", csv_sep, event_name(counter));
 		return;
 	}
 
@@ -525,6 +545,11 @@ static void print_counter_aggr(int counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	if (csv_output) {
+		fputc('\n', stderr);
+		return;
+	}
+
 	print_noise(counter, avg);
 
 	if (scaled) {
@@ -554,8 +579,12 @@ static void print_counter(int counter)
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
@@ -566,11 +595,13 @@ static void print_counter(int counter)
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
@@ -582,21 +613,23 @@ static void print_stat(int argc, const char **argv)
 
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
@@ -606,15 +639,17 @@ static void print_stat(int argc, const char **argv)
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
@@ -644,6 +679,13 @@ static const char * const stat_usage[] = {
 	NULL
 };
 
+static int stat__set_big_num(const struct option *opt __used,
+			     const char *s __used, int unset)
+{
+	big_num_opt = unset ? 0 : 1;
+	return 0;
+}
+
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
@@ -664,12 +706,15 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
-	OPT_BOOLEAN('B', "big-num", &big_num,
-		    "print large numbers with thousands\' separators"),
+	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
+			   "print large numbers with thousands\' separators",
+			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
+	OPT_STRING('x', "field-separator", &csv_sep, "separator",
+		   "print counts with custom separator"),
 	OPT_END()
 };
 
@@ -682,6 +727,25 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
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
+	if (csv_output) {
+		/* User explicitely passed -B? */
+		if (big_num_opt == 1) {
+			fprintf(stderr, "-B option not supported with -x\n");
+			usage_with_options(stat_usage, options);
+		} else /* Nope, so disable big number formatting */
+			big_num = false;
+	} else if (big_num_opt == 0) /* User passed --no-big-num */
+		big_num = false;
+
 	if (!argc && target_pid == -1 && target_tid == -1)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
