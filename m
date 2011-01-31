Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab1AaNUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:20:18 -0500
Received: from www.tglx.de ([62.245.132.106]:59144 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1AaNUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:20:11 -0500
Message-Id: <20110131131808.822602368@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 31 Jan 2011 13:19:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: [patch 1/3] mn10300: Remove stale code
References: <20110131131707.795836437@linutronix.de>
Content-Disposition: inline; filename=mn10300-remove-stale-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mn10300 implements clocksource and clockevents and selects them
unconditionally in Kconfig. Remove the stale code which seems to be a
leftover of the conversion. Cleanup the configuration switches as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Mark Salter <msalter@redhat.com>
---
 arch/mn10300/Kconfig         |   15 ------------
 arch/mn10300/kernel/Makefile |    5 +---
 arch/mn10300/kernel/time.c   |   53 -------------------------------------------
 3 files changed, 2 insertions(+), 71 deletions(-)

Index: linux-2.6/arch/mn10300/Kconfig
===================================================================
--- linux-2.6.orig/arch/mn10300/Kconfig
+++ linux-2.6/arch/mn10300/Kconfig
@@ -53,21 +53,6 @@ config GENERIC_TIME
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config GENERIC_CLOCKEVENTS_BUILD
-	def_bool y
-	depends on GENERIC_CLOCKEVENTS
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
-config CEVT_MN10300
-       def_bool y
-       depends on GENERIC_CLOCKEVENTS
-
-config CSRC_MN10300
-       def_bool y
-       depends on GENERIC_TIME
-
 config GENERIC_BUG
 	def_bool y
 
Index: linux-2.6/arch/mn10300/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/Makefile
+++ linux-2.6/arch/mn10300/kernel/Makefile
@@ -8,7 +8,8 @@ fpu-obj-$(CONFIG_FPU) := fpu.o fpu-low.o
 
 obj-y   := process.o signal.o entry.o traps.o irq.o \
 	   ptrace.o setup.o time.o sys_mn10300.o io.o kthread.o \
-	   switch_to.o mn10300_ksyms.o kernel_execve.o $(fpu-obj-y)
+	   switch_to.o mn10300_ksyms.o kernel_execve.o $(fpu-obj-y) \
+	   csrc-mn10300.o cevt-mn10300.o
 
 obj-$(CONFIG_SMP) += smp.o smp-low.o
 
@@ -28,5 +29,3 @@ obj-$(CONFIG_MN10300_RTC) += rtc.o
 obj-$(CONFIG_PROFILE) += profile.o profile-low.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KPROBES) += kprobes.o
-obj-$(CONFIG_CSRC_MN10300) += csrc-mn10300.o
-obj-$(CONFIG_CEVT_MN10300) += cevt-mn10300.o
Index: linux-2.6/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/time.c
+++ linux-2.6/arch/mn10300/kernel/time.c
@@ -93,47 +93,6 @@ irqreturn_t local_timer_interrupt(void)
 	return IRQ_HANDLED;
 }
 
-#ifndef CONFIG_GENERIC_TIME
-/*
- * advance the kernel's time keeping clocks (xtime and jiffies)
- * - we use Timer 0 & 1 cascaded as a clock to nudge us the next time
- *   there's a need to update
- */
-static irqreturn_t timer_interrupt(int irq, void *dev_id)
-{
-	unsigned tsc, elapse;
-	irqreturn_t ret;
-
-	write_seqlock(&xtime_lock);
-
-	while (tsc = get_cycles(),
-	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
-						 * tick */
-	       elapse > MN10300_TSC_PER_HZ
-	       ) {
-		mn10300_last_tsc += MN10300_TSC_PER_HZ;
-
-		/* advance the kernel's time tracking system */
-		do_timer(1);
-	}
-
-	write_sequnlock(&xtime_lock);
-
-	ret = local_timer_interrupt();
-#ifdef CONFIG_SMP
-	send_IPI_allbutself(LOCAL_TIMER_IPI);
-#endif
-	return ret;
-}
-
-static struct irqaction timer_irq = {
-	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
-	.name		= "timer",
-};
-#endif /* CONFIG_GENERIC_TIME */
-
-#ifdef CONFIG_CSRC_MN10300
 void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 {
 	u64 temp;
@@ -149,9 +108,7 @@ void __init clocksource_set_clock(struct
 	cs->shift = shift;
 	cs->mult = (u32) temp;
 }
-#endif
 
-#if CONFIG_CEVT_MN10300
 void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
 				    unsigned int clock)
 {
@@ -168,7 +125,6 @@ void __cpuinit clockevent_set_clock(stru
 	cd->shift = shift;
 	cd->mult = (u32) temp;
 }
-#endif
 
 /*
  * initialise the various timers used by the main part of the kernel
@@ -181,11 +137,7 @@ void __init time_init(void)
 	 */
 	TMPSCNT |= TMPSCNT_ENABLE;
 
-#ifdef CONFIG_GENERIC_TIME
 	init_clocksource();
-#else
-	startup_timestamp_counter();
-#endif
 
 	printk(KERN_INFO
 	       "timestamp counter I/O clock running at %lu.%02lu"
@@ -194,12 +146,7 @@ void __init time_init(void)
 
 	mn10300_last_tsc = read_timestamp_counter();
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 	init_clockevents();
-#else
-	reload_jiffies_counter(MN10300_JC_PER_HZ - 1);
-	setup_jiffies_interrupt(TMJCIRQ, &timer_irq, CONFIG_TIMER_IRQ_LEVEL);
-#endif
 
 #ifdef CONFIG_MN10300_WD_TIMER
 	/* start the watchdog timer */


