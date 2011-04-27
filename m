Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab1D0QDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:03:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759417Ab1D0QDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:03:13 -0400
Date: Wed, 27 Apr 2011 16:02:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-e25zz44rcms7mu9az4fu5zp0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Print stalled cycles warning colors
Git-Commit-ID: a5d243d04a150acbfa79d641154f49e5d920f64f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:03:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5d243d04a150acbfa79d641154f49e5d920f64f
Gitweb:     http://git.kernel.org/tip/a5d243d04a150acbfa79d641154f49e5d920f64f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 05:39:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:58 +0200

perf stat: Print stalled cycles warning colors

Print the stalled-cycles percentage with different warning level ASCII colors,
as the percentage passes the 25%/50%/75% thresholds.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-e25zz44rcms7mu9az4fu5zp0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 845ded8..e7d91f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -46,6 +46,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/debug.h"
+#include "util/color.h"
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
@@ -426,6 +427,29 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
 }
 
+static void print_stalled_cycles(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_cycles_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 75.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 50.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 25.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #   ");
+	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " of all cycles are idle ");
+}
+
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
@@ -488,12 +512,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
-
-		if (total)
-			ratio = avg / total * 100.0;
-
-		fprintf(stderr, " #   %5.2f%% of all cycles are idle ", ratio);
+		print_stalled_cycles(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
@@ -508,6 +527,8 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 			ratio = 1000.0 * avg / total;
 
 		fprintf(stderr, " # %8.3f M/sec                  ", ratio);
+	} else {
+		fprintf(stderr, "                                   ");
 	}
 }
 
