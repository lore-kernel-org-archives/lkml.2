Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1AaNUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:20:22 -0500
Received: from www.tglx.de ([62.245.132.106]:59151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1AaNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:20:21 -0500
Message-Id: <20110131131808.916682507@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 31 Jan 2011 13:19:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: [patch 2/3] mn10300: Use clocksource_register_hz()
References: <20110131131707.795836437@linutronix.de>
Content-Disposition: inline; filename=mn10300-use-clocksource-register-hz.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource_register_hz() calculates the shift/mult pair for the
clocksource. Remove the mn10300 duplicate implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Mark Salter <msalter@redhat.com>
---
 arch/mn10300/kernel/csrc-mn10300.c |    3 +--
 arch/mn10300/kernel/internal.h     |    3 ---
 arch/mn10300/kernel/time.c         |   16 ----------------
 3 files changed, 1 insertion(+), 21 deletions(-)

Index: linux-2.6/arch/mn10300/kernel/csrc-mn10300.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/csrc-mn10300.c
+++ linux-2.6/arch/mn10300/kernel/csrc-mn10300.c
@@ -29,7 +29,6 @@ static struct clocksource clocksource_mn
 int __init init_clocksource(void)
 {
 	startup_timestamp_counter();
-	clocksource_set_clock(&clocksource_mn10300, MN10300_TSCCLK);
-	clocksource_register(&clocksource_mn10300);
+	clocksource_register_hz(&clocksource_mn10300, MN10300_TSCCLK);
 	return 0;
 }
Index: linux-2.6/arch/mn10300/kernel/internal.h
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/internal.h
+++ linux-2.6/arch/mn10300/kernel/internal.h
@@ -37,9 +37,6 @@ extern irqreturn_t local_timer_interrupt
 /*
  * time.c
  */
-#ifdef CONFIG_CEVT_MN10300
-extern void clockevent_set_clock(struct clock_event_device *, unsigned int);
-#endif
 #ifdef CONFIG_CSRC_MN10300
 extern void clocksource_set_clock(struct clocksource *, unsigned int);
 #endif
Index: linux-2.6/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/time.c
+++ linux-2.6/arch/mn10300/kernel/time.c
@@ -93,22 +93,6 @@ irqreturn_t local_timer_interrupt(void)
 	return IRQ_HANDLED;
 }
 
-void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
-{
-	u64 temp;
-	u32 shift;
-
-	/* Find a shift value */
-	for (shift = 32; shift > 0; shift--) {
-		temp = (u64) NSEC_PER_SEC << shift;
-		do_div(temp, clock);
-		if ((temp >> 32) == 0)
-			break;
-	}
-	cs->shift = shift;
-	cs->mult = (u32) temp;
-}
-
 void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
 				    unsigned int clock)
 {


