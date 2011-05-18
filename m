Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1ERVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:35:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:54550 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1ERVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:41 -0400
Message-Id: <20110518210136.109811585@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 2/7] clocksource: Get rid of the hardcoded 5 seconds sleep
 time limit
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-make-shift-mult-calc-more-clever.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slow clocksources can have a way longer sleep time than 5 seconds and
even fast ones can easily cope with 600 seconds and still maintain
proper accuracy.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/kernel/time/clocksource.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/clocksource.c
+++ linux-2.6-tip/kernel/time/clocksource.c
@@ -626,19 +626,6 @@ static void clocksource_enqueue(struct c
 	list_add(&cs->list, entry);
 }
 
-
-/*
- * Maximum time we expect to go between ticks. This includes idle
- * tickless time. It provides the trade off between selecting a
- * mult/shift pair that is very precise but can only handle a short
- * period of time, vs. a mult/shift pair that can handle long periods
- * of time but isn't as precise.
- *
- * This is a subsystem constant, and actual hardware limitations
- * may override it (ie: clocksources that wrap every 3 seconds).
- */
-#define MAX_UPDATE_LENGTH 5 /* Seconds */
-
 /**
  * __clocksource_updatefreq_scale - Used update clocksource with new freq
  * @t:		clocksource to be registered
@@ -652,15 +639,28 @@ static void clocksource_enqueue(struct c
  */
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
+	unsigned long sec;
+
 	/*
-	 * Ideally we want to use  some of the limits used in
-	 * clocksource_max_deferment, to provide a more informed
-	 * MAX_UPDATE_LENGTH. But for now this just gets the
-	 * register interface working properly.
+	 * Calc the maximum number of seconds which we can run before
+	 * wrapping around. For clocksources which have a mask > 32bit
+	 * we need to limit the max sleep time to have a good
+	 * conversion precision. 10 minutes is still a reasonable
+	 * amount. That results in a shift value of 24 for a
+	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
+	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
+	 * margin as we do in clocksource_max_deferment()
 	 */
+	sec = (cs->mask - (cs->mask >> 5));
+	do_div(sec, freq);
+	do_div(sec, scale);
+	if (!sec)
+		sec = 1;
+	else if (sec > 600 && cs->mask > UINT_MAX)
+		sec = 600;
+
 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
-				      NSEC_PER_SEC/scale,
-				      MAX_UPDATE_LENGTH*scale);
+			       NSEC_PER_SEC / scale, sec * scale);
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);


