Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab1FXOco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:32:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:57938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab1FXOcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:32:41 -0400
Date: Fri, 24 Jun 2011 14:30:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-2739ce151665a72acdc19ed9dc6b9f6a235b7c30@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110609130622.026152527@linutronix.de>
References: <20110609130622.026152527@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] x86: Use common i8253 clockevent
Git-Commit-ID: 2739ce151665a72acdc19ed9dc6b9f6a235b7c30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Jun 2011 14:31:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2739ce151665a72acdc19ed9dc6b9f6a235b7c30
Gitweb:     http://git.kernel.org/tip/2739ce151665a72acdc19ed9dc6b9f6a235b7c30
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jun 2011 13:08:26 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 24 Jun 2011 16:22:54 +0200

x86: Use common i8253 clockevent

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20110609130622.026152527@linutronix.de
---
 arch/x86/Kconfig        |    2 +-
 arch/x86/kernel/i8253.c |   93 ++---------------------------------------------
 2 files changed, 4 insertions(+), 91 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2dd95b5..26a14b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -71,7 +71,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
-	select I8253_LOCK
+	select CLKEVT_I8253
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 5783e6d..f2b96de 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
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
@@ -121,7 +34,7 @@ static int __init init_pit_clocksource(void)
 	  * - when local APIC timer is active (PIT is switched off)
 	  */
 	if (num_possible_cpus() > 1 || is_hpet_enabled() ||
-	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
+	    i8253_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
 	return clocksource_i8253_init();
