Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2AIH2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:28:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2AIH2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:28:42 -0500
Date: Sun, 8 Jan 2012 23:28:26 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-0ed35abc2b569e94498705d250c4767c5284f643@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325957132-10600-8-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-8-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Fix --stdio output alignment when --showcpuutilization used
Git-Commit-ID: 0ed35abc2b569e94498705d250c4767c5284f643
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:28:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ed35abc2b569e94498705d250c4767c5284f643
Gitweb:     http://git.kernel.org/tip/0ed35abc2b569e94498705d250c4767c5284f643
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 8 Jan 2012 02:25:32 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:32:51 -0200

perf report: Fix --stdio output alignment when --showcpuutilization used

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
