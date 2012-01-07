Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2AGR0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:26:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2AGRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:57 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] perf report: Fix --stdio output alignment when --showcpuutilization used
Date: Sun,  8 Jan 2012 02:25:32 +0900
Message-Id: <1325957132-10600-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current perf report output is broken if --showcpuutilization is used.
Combination with -n and/or --show-total-period make things worse.
This patch fixes it as follows:

before:
# Events: 13  cycles
#
# Overhead  sys    us    Command      Shared Object                 Symbol
# ........  .......  .................  .....................
#
    48.25%    48.25%     0.00%    sleep  [kernel.kallsyms]  [k] trace_hardirqs_off
    34.99%    34.99%     0.00%    sleep  [kernel.kallsyms]  [k] __find_get_block_slow
    15.99%    15.99%     0.00%    sleep  [kernel.kallsyms]  [k] lock_release_holdtime
     0.77%     0.77%     0.00%    sleep  [kernel.kallsyms]  [k] native_write_msr_safe

after:
# Events: 13  cycles
#
# Overhead     sys        us    Command      Shared Object                 Symbol
# ........   .......   .......  .......  .................  .....................
#
    48.25%    48.25%     0.00%    sleep  [kernel.kallsyms]  [k] trace_hardirqs_off
    34.99%    34.99%     0.00%    sleep  [kernel.kallsyms]  [k] __find_get_block_slow
    15.99%    15.99%     0.00%    sleep  [kernel.kallsyms]  [k] lock_release_holdtime
     0.77%     0.77%     0.00%    sleep  [kernel.kallsyms]  [k] native_write_msr_safe

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/hist.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index abef2703cd24..7561d5c90d98 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -917,20 +917,6 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 
 	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
 
-	if (symbol_conf.show_nr_samples) {
-		if (sep)
-			fprintf(fp, "%cSamples", *sep);
-		else
-			fputs("  Samples  ", fp);
-	}
-
-	if (symbol_conf.show_total_period) {
-		if (sep)
-			ret += fprintf(fp, "%cPeriod", *sep);
-		else
-			ret += fprintf(fp, "   Period    ");
-	}
-
 	if (symbol_conf.show_cpu_utilization) {
 		if (sep) {
 			ret += fprintf(fp, "%csys", *sep);
@@ -940,8 +926,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 				ret += fprintf(fp, "%cguest us", *sep);
 			}
 		} else {
-			ret += fprintf(fp, "  sys  ");
-			ret += fprintf(fp, "  us  ");
+			ret += fprintf(fp, "     sys  ");
+			ret += fprintf(fp, "      us  ");
 			if (perf_guest) {
 				ret += fprintf(fp, "  guest sys  ");
 				ret += fprintf(fp, "  guest us  ");
@@ -949,6 +935,20 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		}
 	}
 
+	if (symbol_conf.show_nr_samples) {
+		if (sep)
+			fprintf(fp, "%cSamples", *sep);
+		else
+			fputs("  Samples  ", fp);
+	}
+
+	if (symbol_conf.show_total_period) {
+		if (sep)
+			ret += fprintf(fp, "%cPeriod", *sep);
+		else
+			ret += fprintf(fp, "   Period    ");
+	}
+
 	if (pair) {
 		if (sep)
 			ret += fprintf(fp, "%cDelta", *sep);
@@ -993,6 +993,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		goto print_entries;
 
 	fprintf(fp, "# ........");
+	if (symbol_conf.show_cpu_utilization)
+		fprintf(fp, "   .......   .......");
 	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
 	if (symbol_conf.show_total_period)
-- 
1.7.6

