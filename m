Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CJOwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:52:41 -0500
Received: from smtp.nokia.com ([147.243.128.24]:25613 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1CJOwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:52:40 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: [PATCH 1/4] calibrate: extract fall-back calculation into own helper
Date: Thu, 10 Mar 2011 16:48:04 +0200
Message-Id: <1299768487-13200-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Nokia-AV: Clean
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
index 24fe022..b71643a 100644
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

