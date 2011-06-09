Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1FINId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:59787 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab1FINI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:28 -0400
Message-Id: <20110609130622.026152527@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:08:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Subject: [patch 2/5] x86: Use common i8253 clockevent
References: <20110609130509.346588418@linutronix.de>
Content-Disposition: inline; filename=x86-use-common-i8253-ce.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig        |    2 -
 arch/x86/kernel/i8253.c |   93 +-----------------------------------------------
 2 files changed, 4 insertions(+), 91 deletions(-)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -71,7 +71,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
-	select I8253_LOCK
+	select CLKEVT_I8253
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: linux-2.6-tip/arch/x86/kernel/i8253.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/i8253.c
+++ linux-2.6-tip/arch/x86/kernel/i8253.c
@@ -3,15 +3,9 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/timex.h>
-#include <linux/delay.h>
 #include <linux/i8253.h>
-#include <linux/init.h>
-#include <linux/io.h>
 
 #include <asm/hpet.h>
 #include <asm/time.h>
@@ -23,91 +17,10 @@
  */
 struct clock_event_device *global_clock_event;
 
-/*
- * Initialize the PIT timer.
- *
- * This is also called after resume to bring the PIT into operation again.
- */
-static void init_pit_timer(enum clock_event_mode mode,
-			   struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		/* binary, mode 2, LSB/MSB, ch 0 */
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb_pit(LATCH >> 8 , PIT_CH0);		/* MSB */
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_pit(0x30, PIT_MODE);
-			outb_pit(0, PIT_CH0);
-			outb_pit(0, PIT_CH0);
-		}
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* One shot setup */
-		outb_pit(0x38, PIT_MODE);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
-	}
-	raw_spin_unlock(&i8253_lock);
-}
-
-/*
- * Program the next event in oneshot mode
- *
- * Delta is given in PIT ticks
- */
-static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-	outb_pit(delta & 0xff , PIT_CH0);	/* LSB */
-	outb_pit(delta >> 8 , PIT_CH0);		/* MSB */
-	raw_spin_unlock(&i8253_lock);
-
-	return 0;
-}
-
-/*
- * On UP the PIT can serve all of the possible timer functions. On SMP systems
- * it can be solely used for the global tick.
- *
- * The profiling and update capabilities are switched off once the local apic is
- * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
- * !using_apic_timer decisions in do_timer_interrupt_hook()
- */
-static struct clock_event_device pit_ce = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= init_pit_timer,
-	.set_next_event = pit_next_event,
-	.irq		= 0,
-};
-
-/*
- * Initialize the conversion factor and the min/max deltas of the clock event
- * structure and register the clock event source with the framework.
- */
 void __init setup_pit_timer(void)
 {
-	/*
-	 * Start pit with the boot cpu mask and make it global after the
-	 * IO_APIC has been initialized.
-	 */
-	pit_ce.cpumask = cpumask_of(smp_processor_id());
-
-	clockevents_config_and_register(&pit_ce, CLOCK_TICK_RATE, 0xF, 0x7FFF);
-	global_clock_event = &pit_ce;
+	clockevent_i8253_init(true);
+	global_clock_event = &i8253_clockevent;
 }
 
 #ifndef CONFIG_X86_64
@@ -121,7 +34,7 @@ static int __init init_pit_clocksource(v
 	  * - when local APIC timer is active (PIT is switched off)
 	  */
 	if (num_possible_cpus() > 1 || is_hpet_enabled() ||
-	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
+	    i8253_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
 	return clocksource_i8253_init();


