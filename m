Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab1EXXT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:19:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab1EXXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:19:56 -0400
From: Sameer Nanda <snanda@chromium.org>
To: akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com,
        Tim.Deegan@citrix.com, jbeulich@novell.com, snanda@google.com
Cc: linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] init: skip calibration delay if previously done
Date: Tue, 24 May 2011 16:19:06 -0700
Message-Id: <1306279146-23487-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each CPU, do the calibration delay only once. For subsequent calls,
use the cached per-CPU value of loops_per_jiffy.

This saves about 200ms of resume time on dual core Intel Atom N5xx based
systems. This helps bring down the kernel resume time on such systems from
about 500ms to about 300ms.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 init/calibrate.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 76ac919..47d3408 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -183,11 +183,18 @@ recalibrate:
 	return lpj;
 }
 
+DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+
 void __cpuinit calibrate_delay(void)
 {
 	static bool printed;
+	int this_cpu = smp_processor_id();
 
-	if (preset_lpj) {
+	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
+		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
+		pr_info("Calibrating delay loop (skipped) "
+				"already calibrated this CPU previously.. ");
+	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
@@ -205,6 +212,7 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay loop... ");
 		loops_per_jiffy = calibrate_delay_converge();
 	}
+	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
-- 
1.7.3.1

