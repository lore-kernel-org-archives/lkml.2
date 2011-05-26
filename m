Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1EZTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:50:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58663 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab1EZTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l8abiZ/o4ZvFTMJVjbv+XZbobrMmDzOZ9WrcYLdIehjGQi92hhAJ2aJN6qJ4rfhz0d
         kZSdI6VlOkui2TqVof85JjfCrDLzpS/CZH/I6ZPcmry3OEziffKrXz8buzd5pn3ydgIm
         z5xDGRJz4EvkJYUtS3hkXEJt85mKGT6LNmY58=
From: Jim Cromie <jim.cromie@gmail.com>
To: mingo@elte.hu
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/3] perf-stat: refactor print/formatting into print-ops for pretty, csv
Date: Thu, 26 May 2011 13:50:04 -0600
Message-Id: <1306439406-18037-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
References: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
 <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

produces output like this for csv-output:

[jimc@harpo perf]$  sudo ./perf stat -Aa -x'\t' perl -e '$i++ for 1..100000'
CPU0	task-clock-msecs	16.255272
CPU0	context-switches	12
CPU0	CPU-migrations	0
CPU0	page-faults	445
CPU0	cycles	27441481	67.07%
CPU0	instructions	36775396	73.16%
CPU0	branches	8836245	20.72%
CPU0	branch-misses	21646	14.62%
CPU0	cache-references	58221	12.31%
CPU0	cache-misses	6815	12.28%
seconds-time-elapsed	0.016211262

This alters csv-output form by printing event-name in 1st column,
swapping cols 1, 2 from previous table.  This may be problematic for
some existing users, but is more "normal" and therefore better
long-term.  The 3rd - 5th colums match those in pretty

As before, csv-output is triggered by use of -x "sep", where sep can
be any string, not just a char.  This patch adds special case for
"\t", which is converted to a tab.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |  213 +++++++++++++++++++++++++++++++--------------
 1 files changed, 149 insertions(+), 64 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3858573..71bbf72 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -195,6 +195,7 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 	return 0;
 }
 
+
 /*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
@@ -375,6 +376,113 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
+struct print_ops {
+	int (*noise)  (double numer, double denom);
+	int (*nsec)   (const char *evt_name, double msecs, char *cpustr);
+	int (*abs)    (const char*, double avg, char *cpustr);
+	int (*unit)   (const char*, double, double);
+	int (*scaled) (double);
+	int (*cgrp)   (const char *name);
+	int (*time)   (const char *label, double mtime);
+};
+static struct print_ops *prt;
+
+static int user_pr_noise(double numer, double denom)
+{
+	double ratio = 0.0;
+	if (denom)
+		ratio = numer / denom;
+	return fprintf(logfp, "   ( +- %7.3f%% )", ratio);
+}
+static int csv_pr_noise(double numer, double denom)
+{
+	double ratio = 0.0;
+	if (denom)
+		ratio = numer / denom;
+	return fprintf(logfp, "%s%.3f%%", csv_sep, ratio);
+}
+static int user_pr_nsec(const char *evt_name, double msecs, char *cpustr)
+{
+	return fprintf(logfp, "%s%18.6f%s%-24s",
+			cpustr, msecs, csv_sep, evt_name);
+}
+static int csv_pr_nsec(const char *evt_name, double msecs, char *cpustr)
+{
+	return fprintf(logfp, "%s%s%s%.6f", cpustr, evt_name, csv_sep, msecs);
+}
+
+static int user_pr_abs(const char *evt_name, double avg, char *cpustr)
+{
+	const char *fmt = (big_num) ? "%s%'18.0f%s%-24s" : "%s%18.0f%s%-24s";
+	return fprintf(logfp, fmt, cpustr, avg, csv_sep, evt_name);
+}
+static int csv_pr_abs(const char *evt_name, double avg, char *cpustr)
+{
+	return fprintf(logfp, "%s%s%s%.0f", cpustr, evt_name, csv_sep, avg);
+}
+
+static int user_pr_unit(const char *unit, double numer, double denom)
+{
+	double ratio = 0.0;
+	if (denom)
+		ratio = numer / denom;
+	return fprintf(logfp, " # %10.3f %-5s", ratio, unit);
+}
+static int csv_pr_unit(const char *unit, double numer, double denom)
+{
+	double ratio = 0.0;
+	if (denom)
+		ratio = numer / denom;
+	return fprintf(logfp, "%s%.3f%s", csv_sep, ratio, unit);
+}
+
+static int user_pr_scaled(double val)
+{
+	return fprintf(logfp, "  (scaled from %.2f%%)", val);
+}
+static int csv_pr_scaled(double val)
+{
+	return fprintf(logfp, "%s%.2f%%", csv_sep, val);
+}
+
+static int user_pr_cgrp(const char *name)
+{
+	return fprintf(logfp, "%s%s", name, csv_sep);
+}
+static int csv_pr_cgrp(const char *name)
+{
+	return fprintf(logfp, "%s%s", csv_sep, name);
+}
+
+static int user_pr_time(const char *label, double mtime)
+{
+	return fprintf(logfp, " %18.9f  %s", mtime, label);
+}
+static int csv_pr_time(const char *label, double mtime)
+{
+	return fprintf(logfp, "%s%s%.9f", label, csv_sep, mtime);
+}
+
+struct print_ops user_print_ops = {
+	.noise	= user_pr_noise,
+	.nsec	= user_pr_nsec,
+	.abs	= user_pr_abs,
+	.scaled	= user_pr_scaled,
+	.cgrp	= user_pr_cgrp,
+	.unit	= user_pr_unit,
+	.time	= user_pr_time,
+};
+
+struct print_ops csv_print_ops = {
+	.noise	= csv_pr_noise,
+	.nsec	= csv_pr_nsec,
+	.abs	= csv_pr_abs,
+	.scaled	= csv_pr_scaled,
+	.cgrp	= csv_pr_cgrp,
+	.unit	= csv_pr_unit,
+	.time	= csv_pr_time,
+};
+
 static void print_noise(struct perf_evsel *evsel, double avg)
 {
 	struct perf_stat *ps;
@@ -383,46 +491,35 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 		return;
 
 	ps = evsel->priv;
-	fprintf(logfp, "   ( +- %7.3f%% )",
-			100 * stddev_stats(&ps->res_stats[0]) / avg);
+	prt->noise(100 * stddev_stats(&ps->res_stats[0]), avg);
 }
 
 static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-24s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
 			evsel_list->cpus->map[cpu], csv_sep);
 
-	fprintf(logfp, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	prt->nsec(event_name(evsel), msecs, cpustr);
 
 	if (evsel->cgrp)
-		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
+		prt->cgrp(evsel->cgrp->name);
 
 	if (csv_output)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(logfp, " # %10.3f CPUs ",
-				avg / avg_stats(&walltime_nsecs_stats));
+		prt->unit("CPUs", avg,
+			avg_stats(&walltime_nsecs_stats));
 }
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
-	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
-	const char *fmt;
-
-	if (csv_output)
-		fmt = "%s%.0f%s%s";
-	else if (big_num)
-		fmt = "%s%'18.0f%s%-24s";
-	else
-		fmt = "%s%18.0f%s%-24s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -431,37 +528,29 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(logfp, fmt, cpustr, avg, csv_sep, event_name(evsel));
+	prt->abs(event_name(evsel), avg, cpustr);
 
 	if (evsel->cgrp)
-		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
+		prt->cgrp(evsel->cgrp->name);
 
 	if (csv_output)
 		return;
 
 	if (perf_evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS)) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
 
-		if (total)
-			ratio = avg / total;
+		prt->unit("IPC", avg,
+			avg_stats(&runtime_cycles_stats[cpu]));
 
-		fprintf(logfp, " # %10.3f IPC  ", ratio);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_branches_stats[cpu]);
-
-		if (total)
-			ratio = avg * 100 / total;
 
-		fprintf(logfp, " # %10.3f %%    ", ratio);
+		prt->unit("%", avg * 100,
+			avg_stats(&runtime_branches_stats[cpu]));
 
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
-		if (total)
-			ratio = 1000.0 * avg / total;
-
-		fprintf(logfp, " # %10.3f M/sec", ratio);
+		prt->unit("M/sec", 1000.0 * avg,
+			avg_stats(&runtime_nsecs_stats[cpu]));
 	}
 }
 
@@ -475,7 +564,8 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
 
-	if (scaled == -1) {
+	if (scaled == -1 && !csv_output) {
+
 		fprintf(logfp, "%*s%s%*s",
 			csv_output ? 0 : 18,
 			"<not counted>",
@@ -484,7 +574,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 			event_name(counter));
 
 		if (counter->cgrp)
-			fprintf(logfp, "%s%s", csv_sep, counter->cgrp->name);
+			prt->cgrp(counter->cgrp->name);
 
 		fputc('\n', logfp);
 		return;
@@ -495,11 +585,6 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	else
 		abs_printout(-1, counter, avg);
 
-	if (csv_output) {
-		fputc('\n', logfp);
-		return;
-	}
-
 	print_noise(counter, avg);
 
 	if (scaled) {
@@ -508,8 +593,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(logfp, "  (scaled from %.2f%%)",
-				100 * avg_running / avg_enabled);
+		prt->scaled(100 * avg_running / avg_enabled);
 	}
 	fprintf(logfp, "\n");
 }
@@ -527,6 +611,7 @@ static void print_counter(struct perf_evsel *counter)
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
+
 		if (run == 0 || ena == 0) {
 			fprintf(logfp, "CPU%*d%s%*s%s%*s",
 				csv_output ? 0 : -4,
@@ -537,7 +622,7 @@ static void print_counter(struct perf_evsel *counter)
 				event_name(counter));
 
 			if (counter->cgrp)
-				fprintf(logfp, "%s%s", csv_sep, counter->cgrp->name);
+				prt->cgrp(counter->cgrp->name);
 
 			fputc('\n', logfp);
 			continue;
@@ -548,14 +633,12 @@ static void print_counter(struct perf_evsel *counter)
 		else
 			abs_printout(cpu, counter, val);
 
-		if (!csv_output) {
+		if (!csv_output)
 			print_noise(counter, 1.0);
 
-			if (run != ena) {
-				fprintf(logfp, "  (scaled from %.2f%%)",
-					100.0 * run / ena);
-			}
-		}
+		if (run != ena)
+			prt->scaled(100.0 * run / ena);
+
 		fputc('\n', logfp);
 	}
 }
@@ -593,17 +676,15 @@ static void print_stat(int argc, const char **argv)
 			print_counter_aggr(counter);
 	}
 
-	if (!csv_output) {
+	if (!csv_output)
 		fprintf(logfp, "\n");
-		fprintf(logfp, " %18.9f  seconds time elapsed",
-				avg_stats(&walltime_nsecs_stats)/1e9);
-		if (run_count > 1) {
-			fprintf(logfp, "   ( +- %7.3f%% )",
-				100*stddev_stats(&walltime_nsecs_stats) /
-				avg_stats(&walltime_nsecs_stats));
-		}
-		fprintf(logfp, "\n\n");
-	}
+
+	prt->time("seconds-time-elapsed", avg_stats(&walltime_nsecs_stats)/1e9);
+	if (run_count > 1)
+		prt->noise(
+			100 * stddev_stats(&walltime_nsecs_stats),
+			avg_stats(&walltime_nsecs_stats));
+	fprintf(logfp, "\n");
 }
 
 static volatile int signr = -1;
@@ -662,7 +743,7 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
-	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
+	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL,
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu",
@@ -670,7 +751,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
-		   "print counts with custom separator"),
+		   "print counts with custom separator (csv-output)"),
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
@@ -699,16 +780,20 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		exit(1);
 	}
 
-	if (csv_sep)
+	if (csv_sep) {
 		csv_output = true;
-	else
+		prt = &csv_print_ops;
+		if (!strcmp(csv_sep, "\\t"))
+			csv_sep = "\t";
+	} else {
 		csv_sep = DEFAULT_SEPARATOR;
-
+		prt = &user_print_ops;
+	}
 	/*
 	 * let the spreadsheet do the pretty-printing
 	 */
 	if (csv_output) {
-		/* User explicitely passed -B? */
+		/* User explicitly passed -B? */
 		if (big_num_opt == 1) {
 			fprintf(logfp, "-B option not supported with -x\n");
 			usage_with_options(stat_usage, options);
-- 
1.7.4.4

