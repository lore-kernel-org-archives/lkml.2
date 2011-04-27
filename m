Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab1D0QDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:03:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:59591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364Ab1D0QDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:03:42 -0400
Date: Wed, 27 Apr 2011 16:03:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-ybqukg7p86leiup7gl03ecgk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Print branch misses warning colors
Git-Commit-ID: c78df6c1d49b5d798f1579141e3a12be7c325d1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:03:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c78df6c1d49b5d798f1579141e3a12be7c325d1e
Gitweb:     http://git.kernel.org/tip/c78df6c1d49b5d798f1579141e3a12be7c325d1e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 12:16:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:58 +0200

perf stat: Print branch misses warning colors

Print the missed-branches percentage with different warning level ASCII colors,
as the percentage passes the 5%/10%/20% thresholds.

These thresholds are set to relatively low levels, because on most CPUs even a
moderate percentage of branch-misses already shows up as a slowdown.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-ybqukg7p86leiup7gl03ecgk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e7d91f9..5d4e1b9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -450,6 +450,29 @@ static void print_stalled_cycles(int cpu, struct perf_evsel *evsel __used, doubl
 	fprintf(stderr, " of all cycles are idle ");
 }
 
+static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_branches_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #   ");
+	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " of all branches        ");
+}
+
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
@@ -495,13 +518,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_branches_stats[cpu]);
-
-		if (total)
-			ratio = avg * 100 / total;
-
-		fprintf(stderr, " #   %5.2f  %% of all branches      ", ratio);
-
+		print_branch_misses(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_cacherefs_stats[cpu]);
