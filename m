Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1EXWLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:11:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38898 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1EXWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YLSdC2ph4gv5veMPRZ3bKhzMCg6x52/+/KroRrBicQSco7/v0ZI+Rcf9cMs3xElHp9
         Vm7D5+tV9GEI/yFuQx5W3MW+00Q/01/fs0uX83VW9aUAuqvpg1lpZUwcF1spRJUfQs51
         zlrbSa90FDw3TxyGe+EppVHtLgKOK6FoNR3Ew=
From: Jim Cromie <jim.cromie@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] add --simple output mode to perf-stat, based upon csv-output
Date: Tue, 24 May 2011 16:11:11 -0600
Message-Id: <1306275071-12926-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com>
References: <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

produces output like this (WIP):

perf]$ ./perf stat -x'  ' -r3 -- sh -c 'sleep 3'
task-clock-msecs6.896594    1.105%
context-switches  3  0.000%
CPU-migrations  0  -nan%
page-faults  477  0.000%
cycles  5540483  1.002%  (scaled from 69.92%)
instructions  3881794  7.779%  (scaled from 83.70%)
branches  932435  3.343%  (scaled from 82.21%)
branch-misses  43830  11.999%
cache-references  1582931  3.718%  (scaled from 52.72%)
cache-misses  37199  10.154%  (scaled from 37.65%)

Its based upon csv-output, and prints event-name in 1st column, in
contrast to previous format.  This may be problematic for some
existing users, but is more "normal" and therefore better.

Whether '%' symbols or scalings should be printed is TBD.
Also, -A -a output needs work.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3a703e4..1711535 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -91,6 +91,7 @@ static int			big_num_opt			=  -1;
 static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
+static bool			simple				= false;
 
 static int logfd = 2;	/* stderr by default, override with -l */
 static FILE *logfp;	/* = fdopen(logfd,"w") */
@@ -212,7 +213,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	for (i = 0; i < 3; i++)
 		update_stats(&ps->res_stats[i], count[i]);
 
-	if (verbose) {
+	if (verbose || simple) {
 		fprintf(logfp, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
 			event_name(counter), count[0], count[1], count[2]);
 	}
@@ -383,22 +384,31 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 		return;
 
 	ps = evsel->priv;
-	fprintf(logfp, "   ( +- %7.3f%% )",
-			100 * stddev_stats(&ps->res_stats[0]) / avg);
+	if (!csv_output)
+		fprintf(logfp, "   ( +- %7.3f%% )",
+				100 * stddev_stats(&ps->res_stats[0]) / avg);
+	else
+	  fprintf(logfp, "%s%.3f%%",
+		  csv_sep, 100 * stddev_stats(&ps->res_stats[0]) / avg);
+
+
 }
 
 static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-24s";
+	const char *fmt = csv_output ? "%s%s%.6f%s" : "%s%18.6f%s%-24s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
 			evsel_list->cpus->map[cpu], csv_sep);
 
-	fprintf(logfp, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	if (!csv_output)
+	  fprintf(logfp, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	else
+	  fprintf(logfp, fmt, cpustr, event_name(evsel), csv_sep, msecs);
 
 	if (evsel->cgrp)
 		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
@@ -418,7 +428,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	const char *fmt;
 
 	if (csv_output)
-		fmt = "%s%.0f%s%s";
+		fmt = "%s%s%s%.0f";
 	else if (big_num)
 		fmt = "%s%'18.0f%s%-24s";
 	else
@@ -431,7 +441,10 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(logfp, fmt, cpustr, avg, csv_sep, event_name(evsel));
+	if (csv_output)
+	  fprintf(logfp, fmt, cpustr, event_name(evsel), csv_sep, avg);
+	else
+	  fprintf(logfp, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(logfp, "%s%s", csv_sep, evsel->cgrp->name);
@@ -475,7 +488,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
 
-	if (scaled == -1) {
+	if (scaled == -1 && !csv_output) {
 		fprintf(logfp, "%*s%s%*s",
 			csv_output ? 0 : 18,
 			"<not counted>",
@@ -495,7 +508,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	else
 		abs_printout(-1, counter, avg);
 
-	if (csv_output) {
+	if (0 && csv_output) {
 		fputc('\n', logfp);
 		return;
 	}
@@ -536,9 +549,12 @@ static void print_counter(struct perf_evsel *counter)
 				csv_output ? 0 : -24,
 				event_name(counter));
 
-			if (counter->cgrp)
+			if (counter->cgrp) {
+			  if (csv_output)
+				fprintf(logfp, "%s%s", counter->cgrp->name, csv_sep);
+			  else
 				fprintf(logfp, "%s%s", csv_sep, counter->cgrp->name);
-
+			}
 			fputc('\n', logfp);
 			continue;
 		}
@@ -567,6 +583,8 @@ static void print_stat(int argc, const char **argv)
 
 	fflush(stdout);
 
+	if (simple) return;
+
 	if (!csv_output) {
 		fprintf(logfp, "\n");
 		fprintf(logfp, " Performance counter stats for ");
@@ -670,12 +688,14 @@ static const struct option options[] = {
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
-		   "print counts with custom separator"),
+		   "print counts with custom separator (csv-output)"),
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
 	OPT_INTEGER('l', "logfd", &logfd,
 		    "log output to fd, instead of stderr"),
+	OPT_BOOLEAN('s', "simple", &simple,
+		    "simple output for scripts/automation"),
 	OPT_END()
 };
 
-- 
1.7.4.4

