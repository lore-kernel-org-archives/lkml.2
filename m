Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2AHPmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:42:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:59591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2AHPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf report: Fix --stdio output alignment when --showcpuutilization used
Date: Sun,  8 Jan 2012 13:42:18 -0200
Message-Id: <1326037339-31125-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Current perf report output is broken if --showcpuutilization is used.
Combination with -n and/or --show-total-period make things worse.
This patch fixes it as follows:

before:
    48.25%    48.25%     0.00%    sleep  [kernel.kallsyms]  [k] trace_hardirqs_off
    34.99%    34.99%     0.00%    sleep  [kernel.kallsyms]  [k] __find_get_block_slow
    15.99%    15.99%     0.00%    sleep  [kernel.kallsyms]  [k] lock_release_holdtime
     0.77%     0.77%     0.00%    sleep  [kernel.kallsyms]  [k] native_write_msr_safe

after:
    48.25%    48.25%     0.00%    sleep  [kernel.kallsyms]  [k] trace_hardirqs_off
    34.99%    34.99%     0.00%    sleep  [kernel.kallsyms]  [k] __find_get_block_slow
    15.99%    15.99%     0.00%    sleep  [kernel.kallsyms]  [k] lock_release_holdtime
     0.77%     0.77%     0.00%    sleep  [kernel.kallsyms]  [k] native_write_msr_safe

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-8-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4df4495..6f505d1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -919,20 +919,6 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 
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
@@ -942,8 +928,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
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
@@ -951,6 +937,20 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
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
@@ -995,6 +995,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		goto print_entries;
 
 	fprintf(fp, "# ........");
+	if (symbol_conf.show_cpu_utilization)
+		fprintf(fp, "   .......   .......");
 	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
 	if (symbol_conf.show_total_period)
-- 
1.7.8.GIT

