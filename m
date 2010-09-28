Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0I1Kwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:52:31 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:2775 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185Ab0I1Kw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:52:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu, gregkh@suse.de, linux@arm.linux.org.uk, tony@atomide.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        travis@sgi.com, akataria@vmware.com
Subject: [PATCH 1/4] calibrate: extract fall-back calculation into own helper
Date: Tue, 28 Sep 2010 13:44:57 +0300
Message-Id: <1285670700-11099-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1285670700-11099-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1285670700-11099-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... so that it can be modified more clinically.

This is almost entirely cosmetic. The only change to the operation
is that the global variable is only set once after the estimation is
completed, rather than taking on all the intermediate values. However,
there are no readers of that variable, so this change is unimportant.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 init/calibrate.c |   73 +++++++++++++++++++++++++++++------------------------
 1 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 6eb48e5..f7042ff 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -119,10 +119,47 @@ static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
  */
 #define LPS_PREC 8
 
-void __cpuinit calibrate_delay(void)
+static unsigned long __cpuinit calibrate_delay_converge(void)
 {
-	unsigned long ticks, loopbit;
+	unsigned long lpj, ticks, loopbit;
 	int lps_precision = LPS_PREC;
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
+		if (jiffies != ticks)	/* longer than 1 tick */
+			lpj &= ~loopbit;
+	}
+
+	return lpj;
+}
+
+void __cpuinit calibrate_delay(void)
+{
 	static bool printed;
 
 	if (preset_lpj) {
@@ -139,39 +176,9 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay using timer "
 				"specific routine.. ");
 	} else {
-		loops_per_jiffy = (1<<12);
-
 		if (!printed)
 			pr_info("Calibrating delay loop... ");
-		while ((loops_per_jiffy <<= 1) != 0) {
-			/* wait for "start of" clock tick */
-			ticks = jiffies;
-			while (ticks == jiffies)
-				/* nothing */;
-			/* Go .. */
-			ticks = jiffies;
-			__delay(loops_per_jiffy);
-			ticks = jiffies - ticks;
-			if (ticks)
-				break;
-		}
-
-		/*
-		 * Do a binary approximation to get loops_per_jiffy set to
-		 * equal one clock (up to lps_precision bits)
-		 */
-		loops_per_jiffy >>= 1;
-		loopbit = loops_per_jiffy;
-		while (lps_precision-- && (loopbit >>= 1)) {
-			loops_per_jiffy |= loopbit;
-			ticks = jiffies;
-			while (ticks == jiffies)
-				/* nothing */;
-			ticks = jiffies;
-			__delay(loops_per_jiffy);
-			if (jiffies != ticks)	/* longer than 1 tick */
-				loops_per_jiffy &= ~loopbit;
-		}
+		loops_per_jiffy = calibrate_delay_converge();
 	}
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-- 
1.7.2.rc1.37.gf8c40

