Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0IJKE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:04:27 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:4026 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542Ab0IJKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:03:48 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, akataria@vmware.com
Subject: [PATCH 2/3] calibrate: home in on correct lpj bounds more quickly
Date: Fri, 10 Sep 2010 12:54:27 +0300
Message-Id: <1284112468-18498-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binary chop with a jiffy-resync on each step to find an upper bound
is slow, so just race in a tight-ish loop to find an underestimate.
If done with lots of individual steps, sometimes several hundreds
of loops would be required, which would impose a significant overhead,
and make the initial estimate very low. By taking slowly increasing
steps there will be less overhead.

E.g. an x86_64 2.67GHz could have fitted in 613 individual small
delays, but in reality should have been able to fit in a single
delay 649 times longer, so underestimated by 36 steps. To reach
the equivalent of 649 small delays with the accellerating scheme
now requires about 130 steps, or <1/4th of the overhead.

As now we have a better initial estimate we can now binary chop
over a smaller range. With the loop overhead in the initial estimate
kept low, and the step sizes moderate, we won't have under-estimated
by much, so chose as tight a range as we can.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 init/calibrate.c |   57 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index f7042ff..7315c9a 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -110,8 +110,8 @@ static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
 
 /*
  * This is the number of bits of precision for the loops_per_jiffy.  Each
- * bit takes on average 1.5/HZ seconds.  This (like the original) is a little
- * better than 1%
+ * time we refine our estimate after the first takes 1.5/HZ seconds, so try
+ * to start with a good estimate.
  * For the boot cpu we can skip the delay calibration and assign it a value
  * calculated based on the timer frequency.
  * For the rest of the CPUs we cannot assume that the timer frequency is same as
@@ -121,38 +121,49 @@ static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
 
 static unsigned long __cpuinit calibrate_delay_converge(void)
 {
-	unsigned long lpj, ticks, loopbit;
-	int lps_precision = LPS_PREC;
+	/* First stage - slowly accelerate to find initial bounds */
+	unsigned long lpj, ticks, loopadd, chop_limit;
+	int trials = 0, band = 0, trial_in_band = 0;
 
 	lpj = (1<<12);
-	while ((lpj <<= 1) != 0) {
-		/* wait for "start of" clock tick */
-		ticks = jiffies;
-		while (ticks == jiffies)
-			/* nothing */;
-		/* Go .. */
-		ticks = jiffies;
-		__delay(lpj);
-		ticks = jiffies - ticks;
-		if (ticks)
-			break;
-	}
+
+	/* wait for "start of" clock tick */
+	ticks = jiffies;
+	while (ticks == jiffies)
+		; /* nothing */
+	/* Go .. */
+	ticks = jiffies;
+	do {
+		if (++trial_in_band == (1<<band)) {
+			++band;
+			trial_in_band = 0;
+		}
+		__delay(lpj * band);
+		trials += band;
+	} while (ticks == jiffies);
+	/*
+	 * We overshot, so retreat to a clear underestimate. Then estimate
+	 * the largest likely undershoot. This defines our chop bounds.
+	 */
+	trials -= band;
+	loopadd = lpj * band;
+	lpj *= trials;
+	chop_limit = lpj >> (LPS_PREC + 1);
 
 	/*
 	 * Do a binary approximation to get lpj set to
-	 * equal one clock (up to lps_precision bits)
+	 * equal one clock (up to LPS_PREC bits)
 	 */
-	lpj >>= 1;
-	loopbit = lpj;
-	while (lps_precision-- && (loopbit >>= 1)) {
-		lpj |= loopbit;
+	while (loopadd > chop_limit) {
+		lpj += loopadd;
 		ticks = jiffies;
 		while (ticks == jiffies)
-			/* nothing */;
+			; /* nothing */
 		ticks = jiffies;
 		__delay(lpj);
 		if (jiffies != ticks)	/* longer than 1 tick */
-			lpj &= ~loopbit;
+			lpj -= loopadd;
+		loopadd >>= 1;
 	}
 
 	return lpj;
-- 
1.7.2.rc1.37.gf8c40

