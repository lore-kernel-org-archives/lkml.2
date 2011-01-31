Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1AaNUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:20:17 -0500
Received: from www.tglx.de ([62.245.132.106]:59148 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1AaNUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:20:12 -0500
Message-Id: <20110131131809.017899070@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 31 Jan 2011 13:19:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: [patch 3/3] mn10300: Use clockevents_calc_mult_shift()
References: <20110131131707.795836437@linutronix.de>
Content-Disposition: inline;
	filename=mn10300-use-clockevents_calc_mult_shift.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clockevents_calc_mult_shift() instead of the homebrewn function in
mn10300/kernel/time.c.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Mark Salter <msalter@redhat.com> 
---
 arch/mn10300/kernel/cevt-mn10300.c |    5 +++--
 arch/mn10300/kernel/internal.h     |    7 -------
 arch/mn10300/kernel/time.c         |   17 -----------------
 3 files changed, 3 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/mn10300/kernel/cevt-mn10300.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/cevt-mn10300.c
+++ linux-2.6/arch/mn10300/kernel/cevt-mn10300.c
@@ -89,9 +89,10 @@ int __init init_clockevents(void)
 	cd->name		= "Timestamp";
 	cd->features		= CLOCK_EVT_FEAT_ONESHOT;
 
-	/* Calculate the min / max delta */
-	clockevent_set_clock(cd, MN10300_JCCLK);
+	/* Calculate shift/mult. We want to spawn at least 1 second */
+	clockevents_calc_mult_shift(cd, MN10300_JCCLK, 1);
 
+	/* Calculate the min / max delta */
 	cd->max_delta_ns	= clockevent_delta2ns(TMJCBR_MAX, cd);
 	cd->min_delta_ns	= clockevent_delta2ns(100, cd);
 
Index: linux-2.6/arch/mn10300/kernel/internal.h
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/internal.h
+++ linux-2.6/arch/mn10300/kernel/internal.h
@@ -33,10 +33,3 @@ extern void mn10300_low_ipi_handler(void
  * time.c
  */
 extern irqreturn_t local_timer_interrupt(void);
-
-/*
- * time.c
- */
-#ifdef CONFIG_CSRC_MN10300
-extern void clocksource_set_clock(struct clocksource *, unsigned int);
-#endif
Index: linux-2.6/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/time.c
+++ linux-2.6/arch/mn10300/kernel/time.c
@@ -93,23 +93,6 @@ irqreturn_t local_timer_interrupt(void)
 	return IRQ_HANDLED;
 }
 
-void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
-				    unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) clock << shift;
-		do_div(temp, NSEC_PER_SEC);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cd->shift = shift;
-	cd->mult = (u32) temp;
-}
-
 /*
  * initialise the various timers used by the main part of the kernel
  */


