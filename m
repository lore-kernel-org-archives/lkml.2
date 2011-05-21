Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1EUI5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:57:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52373 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1EUI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HXlRc/alA2wDsKmOWXKuXQBlU1kN86H8Ij7oUPfv+6AGth137id8HKP0rn38+SceIl
         MGH/EPjTO659R6j4hhTbNqVDFKV5Kdy0cHyqT2tqd7JYaNOmhhyNzAT2MoqaljjZ6f9V
         sY6iKQQNXKku8JW79C+98i96QGW6YYhoNSLKc=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr elsewhere
Date: Sat, 21 May 2011 02:56:42 -0600
Message-Id: <1305968203-14240-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This perf stat option emulates valgrind's --log-fd option, allowing the
user to send perf results elsewhere, and leaving stderr for use by the
program under test.

  3>results perf stat -l 3 -- <cmd>

The perl distro's make test.valgrind target uses valgrinds --log-fd
option, I've adapted it to invoke perf also, and tested this patch there.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |   85 +++++++++++++++++++++++++-------------------
 1 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 03f0e45..3858573 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -92,6 +92,9 @@ static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 
+static int logfd = 2;	/* stderr by default, override with -l */
+static FILE *logfp;	/* = fdopen(logfd,"w") */
+
 static volatile int done = 0;
 
 struct stats
@@ -210,7 +213,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 		update_stats(&ps->res_stats[i], count[i]);
 
 	if (verbose) {
-		fprintf(stderr, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
+		fprintf(logfp, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
 			event_name(counter), count[0], count[1], count[2]);
 	}
 
@@ -380,7 +383,7 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 		return;
 
 	ps = evsel->priv;
-	fprintf(stderr, "   ( +- %7.3f%% )",
+	fprintf(logfp, "   ( +- %7.3f%% )",
 			100 * stddev_stats(&ps->res_stats[0]) / avg);
 }
 
@@ -395,16 +398,16 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 			csv_output ? 0 : -4,
 			evsel_list->cpus->map[cpu], csv_sep);
 
-	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	fprintf(logfp, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
 	if (evsel->cgrp)
-		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
 
 	if (csv_output)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(stderr, " # %10.3f CPUs ",
+		fprintf(logfp, " # %10.3f CPUs ",
 				avg / avg_stats(&walltime_nsecs_stats));
 }
 
@@ -428,10 +431,10 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
+	fprintf(logfp, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
 	if (evsel->cgrp)
-		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
+		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
 
 	if (csv_output)
 		return;
@@ -442,7 +445,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " # %10.3f IPC  ", ratio);
+		fprintf(logfp, " # %10.3f IPC  ", ratio);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_branches_stats[cpu]);
@@ -450,7 +453,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%    ", ratio);
+		fprintf(logfp, " # %10.3f %%    ", ratio);
 
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
@@ -458,7 +461,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = 1000.0 * avg / total;
 
-		fprintf(stderr, " # %10.3f M/sec", ratio);
+		fprintf(logfp, " # %10.3f M/sec", ratio);
 	}
 }
 
@@ -473,7 +476,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	int scaled = counter->counts->scaled;
 
 	if (scaled == -1) {
-		fprintf(stderr, "%*s%s%*s",
+		fprintf(logfp, "%*s%s%*s",
 			csv_output ? 0 : 18,
 			"<not counted>",
 			csv_sep,
@@ -481,9 +484,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
 			event_name(counter));
 
 		if (counter->cgrp)
-			fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+			fprintf(logfp, "%s%s", csv_sep, counter->cgrp->name);
 
-		fputc('\n', stderr);
+		fputc('\n', logfp);
 		return;
 	}
 
@@ -493,7 +496,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		abs_printout(-1, counter, avg);
 
 	if (csv_output) {
-		fputc('\n', stderr);
+		fputc('\n', logfp);
 		return;
 	}
 
@@ -505,10 +508,10 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(stderr, "  (scaled from %.2f%%)",
+		fprintf(logfp, "  (scaled from %.2f%%)",
 				100 * avg_running / avg_enabled);
 	}
-	fprintf(stderr, "\n");
+	fprintf(logfp, "\n");
 }
 
 /*
@@ -525,7 +528,7 @@ static void print_counter(struct perf_evsel *counter)
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
 		if (run == 0 || ena == 0) {
-			fprintf(stderr, "CPU%*d%s%*s%s%*s",
+			fprintf(logfp, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
@@ -534,9 +537,9 @@ static void print_counter(struct perf_evsel *counter)
 				event_name(counter));
 
 			if (counter->cgrp)
-				fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
+				fprintf(logfp, "%s%s", csv_sep, counter->cgrp->name);
 
-			fputc('\n', stderr);
+			fputc('\n', logfp);
 			continue;
 		}
 
@@ -549,11 +552,11 @@ static void print_counter(struct perf_evsel *counter)
 			print_noise(counter, 1.0);
 
 			if (run != ena) {
-				fprintf(stderr, "  (scaled from %.2f%%)",
+				fprintf(logfp, "  (scaled from %.2f%%)",
 					100.0 * run / ena);
 			}
 		}
-		fputc('\n', stderr);
+		fputc('\n', logfp);
 	}
 }
 
@@ -565,21 +568,21 @@ static void print_stat(int argc, const char **argv)
 	fflush(stdout);
 
 	if (!csv_output) {
-		fprintf(stderr, "\n");
-		fprintf(stderr, " Performance counter stats for ");
+		fprintf(logfp, "\n");
+		fprintf(logfp, " Performance counter stats for ");
 		if(target_pid == -1 && target_tid == -1) {
-			fprintf(stderr, "\'%s", argv[0]);
+			fprintf(logfp, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
-				fprintf(stderr, " %s", argv[i]);
+				fprintf(logfp, " %s", argv[i]);
 		} else if (target_pid != -1)
-			fprintf(stderr, "process id \'%d", target_pid);
+			fprintf(logfp, "process id \'%d", target_pid);
 		else
-			fprintf(stderr, "thread id \'%d", target_tid);
+			fprintf(logfp, "thread id \'%d", target_tid);
 
-		fprintf(stderr, "\'");
+		fprintf(logfp, "\'");
 		if (run_count > 1)
-			fprintf(stderr, " (%d runs)", run_count);
-		fprintf(stderr, ":\n\n");
+			fprintf(logfp, " (%d runs)", run_count);
+		fprintf(logfp, ":\n\n");
 	}
 
 	if (no_aggr) {
@@ -591,15 +594,15 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	if (!csv_output) {
-		fprintf(stderr, "\n");
-		fprintf(stderr, " %18.9f  seconds time elapsed",
+		fprintf(logfp, "\n");
+		fprintf(logfp, " %18.9f  seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
-			fprintf(stderr, "   ( +- %7.3f%% )",
+			fprintf(logfp, "   ( +- %7.3f%% )",
 				100*stddev_stats(&walltime_nsecs_stats) /
 				avg_stats(&walltime_nsecs_stats));
 		}
-		fprintf(stderr, "\n\n");
+		fprintf(logfp, "\n\n");
 	}
 }
 
@@ -671,6 +674,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_INTEGER('l', "logfd", &logfd,
+		    "log output to fd, instead of stderr"),
 	OPT_END()
 };
 
@@ -688,6 +693,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 
+	logfp = fdopen(logfd, "w");
+	if (!logfp) {
+		perror("failed opening logfd");
+		exit(1);
+	}
+
 	if (csv_sep)
 		csv_output = true;
 	else
@@ -699,7 +710,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (csv_output) {
 		/* User explicitely passed -B? */
 		if (big_num_opt == 1) {
-			fprintf(stderr, "-B option not supported with -x\n");
+			fprintf(logfp, "-B option not supported with -x\n");
 			usage_with_options(stat_usage, options);
 		} else /* Nope, so disable big number formatting */
 			big_num = false;
@@ -713,7 +724,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	/* no_aggr, cgroup are for system-wide only */
 	if ((no_aggr || nr_cgroups) && !system_wide) {
-		fprintf(stderr, "both cgroup and no-aggregation "
+		fprintf(logfp, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
 		usage_with_options(stat_usage, options);
@@ -772,7 +783,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
-			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
+			fprintf(logfp, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
 		status = run_perf_stat(argc, argv);
 	}
 
-- 
1.7.4.1

