Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1L0Pgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:36:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1L0PgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:36:02 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip:perf/core 2/4] perf stat: Introduce get_ratio_color() helper
Date: Wed, 28 Dec 2011 00:35:49 +0900
Message-Id: <1325000151-4463-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_ratio_color() returns appropriate color string
based on @ratio. It helps reducing code duplication.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-stat.c |   91 +++++++++++++++++---------------------------
 1 files changed, 35 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index cc53de335ced..f5d2a63eba66 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -578,6 +578,33 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 			avg / avg_stats(&walltime_nsecs_stats));
 }
 
+/* used for get_ratio_color() */
+enum grc_type {
+	GRC_STALLED_CYCLES_FE,
+	GRC_STALLED_CYCLES_BE,
+	GRC_CACHE_MISSES,
+	GRC_MAX_NR
+};
+
+static const char *get_ratio_color(enum grc_type type, double ratio)
+{
+	static const double grc_table[GRC_MAX_NR][3] = {
+		[GRC_STALLED_CYCLES_FE] = { 50.0, 30.0, 10.0 },
+		[GRC_STALLED_CYCLES_BE] = { 75.0, 50.0, 20.0 },
+		[GRC_CACHE_MISSES] 	= { 20.0, 10.0, 5.0 },
+	};
+	const char *color = PERF_COLOR_NORMAL;
+
+	if (ratio > grc_table[type][0])
+		color = PERF_COLOR_RED;
+	else if (ratio > grc_table[type][1])
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > grc_table[type][2])
+		color = PERF_COLOR_YELLOW;
+
+	return color;
+}
+
 static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __used, double avg)
 {
 	double total, ratio = 0.0;
@@ -588,13 +615,7 @@ static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __us
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 50.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 30.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_STALLED_CYCLES_FE, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -611,13 +632,7 @@ static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __use
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 75.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 50.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 20.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_STALLED_CYCLES_BE, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -634,13 +649,7 @@ static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -657,13 +666,7 @@ static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -680,13 +683,7 @@ static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -703,13 +700,7 @@ static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -726,13 +717,7 @@ static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
@@ -749,13 +734,7 @@ static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, doub
 	if (total)
 		ratio = avg / total * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 20.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 10.0)
-		color = PERF_COLOR_MAGENTA;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
+	color = get_ratio_color(GRC_CACHE_MISSES, ratio);
 
 	fprintf(output, " #  ");
 	color_fprintf(output, color, "%6.2f%%", ratio);
-- 
1.7.6

