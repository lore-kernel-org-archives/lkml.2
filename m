Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0IJKD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:03:59 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:4025 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689Ab0IJKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:03:48 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, akataria@vmware.com
Subject: [PATCH 3/3] DO NOT INTEGRATE: test-only timing
Date: Fri, 10 Sep 2010 12:54:28 +0300
Message-Id: <1284112468-18498-4-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always run both the old and the converging method to see
what they would say, even if we have more accurate values.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 init/calibrate.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 7315c9a..b6d592e 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -146,6 +146,8 @@ static unsigned long __cpuinit calibrate_delay_converge(void)
 	 * the largest likely undershoot. This defines our chop bounds.
 	 */
 	trials -= band;
+	pr_info("lpj underestimate = %lu * %i = %lu, band = %i\n",
+		lpj, trials, trials * lpj, band);
 	loopadd = lpj * band;
 	lpj *= trials;
 	chop_limit = lpj >> (LPS_PREC + 1);
@@ -169,32 +171,96 @@ static unsigned long __cpuinit calibrate_delay_converge(void)
 	return lpj;
 }
 
+/* Old version for timing purposes only */
+static unsigned long __cpuinit calibrate_delay_converge_slowly(void)
+{
+	unsigned long lpj, ticks, loopbit;
+	int lps_precision = LPS_PREC;
+
+	lpj = (1<<12);
+	while ((lpj <<= 1) != 0) {
+		/* wait for "start of" clock tick */
+		ticks = jiffies;
+		while (ticks == jiffies)
+			/* nothing */;
+		/* Go .. */
+		ticks = jiffies;
+		__delay(lpj);
+		ticks = jiffies - ticks;
+		if (ticks)
+			break;
+	}
+
+	/*
+	 * Do a binary approximation to get lpj set to
+	 * equal one clock (up to lps_precision bits)
+	 */
+	lpj >>= 1;
+	loopbit = lpj;
+	while (lps_precision-- && (loopbit >>= 1)) {
+		lpj |= loopbit;
+		ticks = jiffies;
+		while (ticks == jiffies)
+			/* nothing */;
+		ticks = jiffies;
+		__delay(lpj);
+		if (jiffies != ticks)   /* longer than 1 tick */
+			lpj &= ~loopbit;
+	}
+
+	return lpj;
+}
+
+static void finally_print_bogomips(unsigned long lpj, unsigned int ticks)
+{
+	/* This calculation is bogus */
+	pr_cont("%lu.%02lu BogoMIPS (lpj=%lu) took %u jiffies\n",
+		lpj/(500000/HZ), (lpj/(5000/HZ)) % 100, lpj, ticks);
+}
+
 void __cpuinit calibrate_delay(void)
 {
+	enum methods { DUNNO, PRESET, FINE, DIRECT, CONVERGE };
 	static bool printed;
+	int method_used = DUNNO;
+	unsigned long ojiffs = jiffies;
 
 	if (preset_lpj) {
+		method_used = PRESET;
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
 	} else if ((!printed) && lpj_fine) {
+		method_used = FINE;
 		loops_per_jiffy = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
+		method_used = DIRECT;
 		if (!printed)
 			pr_info("Calibrating delay using timer "
 				"specific routine.. ");
 	} else {
+		method_used = CONVERGE;
 		if (!printed)
 			pr_info("Calibrating delay loop... ");
 		loops_per_jiffy = calibrate_delay_converge();
 	}
-	if (!printed)
-		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+	if (!printed) {
+		unsigned long tmp_lpj;
+		finally_print_bogomips(loops_per_jiffy, jiffies-ojiffs);
+		if (method_used != CONVERGE) {
+			ojiffs = jiffies;
+			pr_info("New-style converging method... ");
+			tmp_lpj = calibrate_delay_converge();
+			finally_print_bogomips(tmp_lpj, jiffies-ojiffs);
+		}
+		ojiffs = jiffies;
+		pr_info("Old-style converging method... ");
+		tmp_lpj = calibrate_delay_converge_slowly();
+		finally_print_bogomips(tmp_lpj, jiffies-ojiffs);
+	}
 
 	printed = true;
 }
-- 
1.7.2.rc1.37.gf8c40

