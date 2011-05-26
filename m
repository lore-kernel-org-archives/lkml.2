Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab1EZTub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:50:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40273 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1EZTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mitRzCuDQdneEfSc40kzBrCkm7YlstTvK15YrFCHcH4FqjqD5b1YHj1S8v8acwmkrr
         wCYyrtLyBeGCyCHca4d9KXGG7XiJRX58MuJh7TrgCEYrpGIg5NPKD8GrN71pPrB+fI3T
         5csE/GvzaHeijwDQ1E2f+jAv3/M70b07kOfS0=
From: Jim Cromie <jim.cromie@gmail.com>
To: mingo@elte.hu
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/3] perf-stat: clean up <no count> handling, CPUx prefixing
Date: Thu, 26 May 2011 13:50:06 -0600
Message-Id: <1306439406-18037-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
References: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
 <1306439406-18037-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

push <no-count> printing into print-ops to hide some cruft, and fold
away dynamic formats.  Refactor cpustr string prep into cpustr(int
cpu), use it everywhere, and change fn-sigs accordingly.

Also includes 1-line fixup for overlooked hack in earlier patch:
  -       if (scaled == -1 && !csv_output) {
  +       if (scaled == -1) {

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |  101 +++++++++++++++++++++++++++-----------------
 1 files changed, 62 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c59d199..9c03e99 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -383,12 +383,14 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 struct print_ops {
 	int (*noise)  (double numer, double denom);
-	int (*nsec)   (const char *evt_name, double msecs, char *cpustr);
-	int (*abs)    (const char*, double avg, char *cpustr);
+	int (*nsec)   (const char *evt_name, double msecs, int cpu);
+	int (*abs)    (const char*, double avg, int cpu);
 	int (*unit)   (const char*, double, double);
 	int (*scaled) (double);
 	int (*cgrp)   (const char *name);
 	int (*time)   (const char *label, double mtime);
+	int (*ctr)    (const char *label, int val);
+	int (*noct)   (const char *label, int cpu);
 };
 static struct print_ops *prt;
 
@@ -406,24 +408,48 @@ static int csv_pr_noise(double numer, double denom)
 		ratio = numer / denom;
 	return fprintf(logfp, "%s%.3f%%", csv_sep, ratio);
 }
-static int user_pr_nsec(const char *evt_name, double msecs, char *cpustr)
+
+static char _cpustr[16];
+static char * cpustr(int cpu)
+{
+	_cpustr[0] = '\0';
+	if (cpu > -1) {
+		sprintf(_cpustr, "CPU%*d%s",
+			csv_output ? 0 : -4,
+			cpu, csv_sep);
+	}
+	return _cpustr;
+}
+static int user_pr_nsec(const char *evt_name, double msecs, int cpu)
 {
 	return fprintf(logfp, "%s%18.6f%s%-24s",
-			cpustr, msecs, csv_sep, evt_name);
+			cpustr(cpu), msecs, csv_sep, evt_name);
 }
-static int csv_pr_nsec(const char *evt_name, double msecs, char *cpustr)
+static int csv_pr_nsec(const char *evt_name, double msecs, int cpu)
 {
-	return fprintf(logfp, "%s%s%s%.6f", cpustr, evt_name, csv_sep, msecs);
+	return fprintf(logfp, "%s%s%s%.6f", cpustr(cpu), evt_name,
+			csv_sep, msecs);
 }
 
-static int user_pr_abs(const char *evt_name, double avg, char *cpustr)
+static int user_pr_abs(const char *evt_name, double avg, int cpu)
 {
 	const char *fmt = (big_num) ? "%s%'18.0f%s%-24s" : "%s%18.0f%s%-24s";
-	return fprintf(logfp, fmt, cpustr, avg, csv_sep, evt_name);
+	return fprintf(logfp, fmt, cpustr(cpu), avg, csv_sep, evt_name);
+}
+static int csv_pr_abs(const char *evt_name, double avg, int cpu)
+{
+	return fprintf(logfp, "%s%s%s%.0f", cpustr(cpu), evt_name, csv_sep, avg);
+}
+
+static int user_pr_nc(const char *evt_name, int cpu)
+{
+	return fprintf(logfp, "%s%18s%s%-24s", cpustr(cpu), "<not counted>",
+			csv_sep, evt_name);
 }
-static int csv_pr_abs(const char *evt_name, double avg, char *cpustr)
+static int csv_pr_nc(const char *evt_name, int cpu)
 {
-	return fprintf(logfp, "%s%s%s%.0f", cpustr, evt_name, csv_sep, avg);
+	return fprintf(logfp, "%s%s%s%s", cpustr(cpu), evt_name,
+			csv_sep, "<not-counted>");
 }
 
 static int user_pr_unit(const char *unit, double numer, double denom)
@@ -468,6 +494,20 @@ static int csv_pr_time(const char *label, double mtime)
 	return fprintf(logfp, "%s%s%.9f", label, csv_sep, mtime);
 }
 
+static int _pr_ctr(const char *label, int val)
+{
+	if (csv_output)
+		return fprintf(logfp, "CPU%0d%s%s%s%s",
+				val, csv_sep,
+				"<not counted>", csv_sep,
+				label);
+	else
+		return fprintf(logfp, "CPU%-4d%s%18s%s%-24s",
+				val, csv_sep,
+				"<not counted>", csv_sep,
+				label);
+}
+
 struct print_ops user_print_ops = {
 	.noise	= user_pr_noise,
 	.nsec	= user_pr_nsec,
@@ -476,6 +516,8 @@ struct print_ops user_print_ops = {
 	.cgrp	= user_pr_cgrp,
 	.unit	= user_pr_unit,
 	.time	= user_pr_time,
+	.ctr	= _pr_ctr,
+	.noct	= user_pr_nc,
 };
 
 struct print_ops csv_print_ops = {
@@ -486,6 +528,8 @@ struct print_ops csv_print_ops = {
 	.cgrp	= csv_pr_cgrp,
 	.unit	= csv_pr_unit,
 	.time	= csv_pr_time,
+	.ctr	= _pr_ctr,
+	.noct	= csv_pr_nc,
 };
 
 static void print_noise(struct perf_evsel *evsel, double avg)
@@ -502,14 +546,8 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
-	char cpustr[16] = { '\0', };
-
-	if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
-			csv_output ? 0 : -4,
-			evsel_list->cpus->map[cpu], csv_sep);
 
-	prt->nsec(event_name(evsel), msecs, cpustr);
+	prt->nsec(event_name(evsel), msecs, cpu);
 
 	if (evsel->cgrp)
 		prt->cgrp(evsel->cgrp->name);
@@ -524,17 +562,11 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
-	char cpustr[16] = { '\0', };
+	prt->abs(event_name(evsel), avg, cpu);
 
-	if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
-			csv_output ? 0 : -4,
-			evsel_list->cpus->map[cpu], csv_sep);
-	else
+	if (!no_aggr)
 		cpu = 0;
 
-	prt->abs(event_name(evsel), avg, cpustr);
-
 	if (evsel->cgrp)
 		prt->cgrp(evsel->cgrp->name);
 
@@ -569,14 +601,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
 
-	if (scaled == -1 && !csv_output) {
+	if (scaled == -1) {
 
-		fprintf(logfp, "%*s%s%*s",
-			csv_output ? 0 : 18,
-			"<not counted>",
-			csv_sep,
-			csv_output ? 0 : -24,
-			event_name(counter));
+		prt->noct(event_name(counter), -1);
 
 		if (counter->cgrp)
 			prt->cgrp(counter->cgrp->name);
@@ -618,13 +645,9 @@ static void print_counter(struct perf_evsel *counter)
 		run = counter->counts->cpu[cpu].run;
 
 		if (run == 0 || ena == 0) {
-			fprintf(logfp, "CPU%*d%s%*s%s%*s",
-				csv_output ? 0 : -4,
-				evsel_list->cpus->map[cpu], csv_sep,
-				csv_output ? 0 : 18,
-				"<not counted>", csv_sep,
-				csv_output ? 0 : -24,
-				event_name(counter));
+
+			prt->ctr(event_name(counter),
+				evsel_list->cpus->map[cpu]);
 
 			if (counter->cgrp)
 				prt->cgrp(counter->cgrp->name);
-- 
1.7.4.4

