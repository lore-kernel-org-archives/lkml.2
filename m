Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab1FXOeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:34:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:57979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab1FXOeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:34:20 -0400
Date: Fri, 24 Jun 2011 14:31:46 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-594fa4ac22954c9cb8d65040c5c3676778b08e1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110609130622.133068765@linutronix.de>
References: <20110609130622.133068765@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] mips: Use common i8253 clockevent
Git-Commit-ID: 594fa4ac22954c9cb8d65040c5c3676778b08e1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Jun 2011 14:32:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  594fa4ac22954c9cb8d65040c5c3676778b08e1d
Gitweb:     http://git.kernel.org/tip/594fa4ac22954c9cb8d65040c5c3676778b08e1d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jun 2011 13:08:27 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 24 Jun 2011 16:22:55 +0200

mips: Use common i8253 clockevent

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20110609130622.133068765@linutronix.de
---
 arch/mips/Kconfig        |    1 +
 arch/mips/kernel/i8253.c |   97 +---------------------------------------------
 2 files changed, 3 insertions(+), 95 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 45f7aac..6cb60ad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2391,6 +2391,7 @@ config MMU
 config I8253
 	bool
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select MIPS_EXTERNAL_TIMER
 
 config ZONE_DMA32
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 3d2ff57..8d95fe4f 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -4,92 +4,15 @@
  */
 #include <linux/clockchips.h>
 #include <linux/i8253.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/spinlock.h>
 #include <linux/irq.h>
 
-#include <asm/delay.h>
-#include <asm/io.h>
 #include <asm/time.h>
 
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
-	switch(mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		/* binary, mode 2, LSB/MSB, ch 0 */
-		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_p(0x30, PIT_MODE);
-			outb_p(0, PIT_CH0);
-			outb_p(0, PIT_CH0);
-		}
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* One shot setup */
-		outb_p(0x38, PIT_MODE);
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
-	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
-	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	raw_spin_unlock(&i8253_lock);
-
-	return 0;
-}
-
-/*
- * On UP the PIT can serve all of the possible timer functions. On SMP systems
- * it can be solely used for the global tick.
- *
- * The profiling and update capabilites are switched off once the local apic is
- * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
- * !using_apic_timer decisions in do_timer_interrupt_hook()
- */
-static struct clock_event_device pit_clockevent = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= init_pit_timer,
-	.set_next_event = pit_next_event,
-	.irq		= 0,
-};
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	pit_clockevent.event_handler(&pit_clockevent);
+	i8253_clockevent.event_handler(&pit_clockevent);
 
 	return IRQ_HANDLED;
 }
@@ -100,25 +23,9 @@ static struct irqaction irq0  = {
 	.name = "timer"
 };
 
-/*
- * Initialize the conversion factor and the min/max deltas of the clock event
- * structure and register the clock event source with the framework.
- */
 void __init setup_pit_timer(void)
 {
-	struct clock_event_device *cd = &pit_clockevent;
-	unsigned int cpu = smp_processor_id();
-
-	/*
-	 * Start pit with the boot cpu mask and make it global after the
-	 * IO_APIC has been initialized.
-	 */
-	cd->cpumask = cpumask_of(cpu);
-	clockevent_set_clock(cd, CLOCK_TICK_RATE);
-	cd->max_delta_ns = clockevent_delta2ns(0x7FFF, cd);
-	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
-	clockevents_register_device(cd);
-
+	clockevent_i8253_init(true);
 	setup_irq(0, &irq0);
 }
 
