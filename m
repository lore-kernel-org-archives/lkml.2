Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1JYSLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:11:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48822 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1JYSLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:11:37 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 6/8] clocksource: m86knommu: Convert to clocksource_register_hz/khz
Date: Tue, 25 Oct 2011 11:08:14 -0700
Message-Id: <1319566096-3222-6-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
x-cbid: 11102518-5930-0000-0000-000000912CB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

This converts the m86knommu clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/m68k/platform/68328/timers.c         |    4 +-
 arch/m68k/platform/coldfire/dma_timer.c   |    5 +-
 arch/m68knommu/platform/coldfire/pit.c    |  167 ++++++++++++++++++++++++++++
 arch/m68knommu/platform/coldfire/timers.c |  172 +++++++++++++++++++++++++++++
 4 files changed, 341 insertions(+), 7 deletions(-)
 create mode 100644 arch/m68knommu/platform/coldfire/pit.c
 create mode 100644 arch/m68knommu/platform/coldfire/timers.c

diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
index 309f725..f267886 100644
--- a/arch/m68k/platform/68328/timers.c
+++ b/arch/m68k/platform/68328/timers.c
@@ -93,7 +93,6 @@ static struct clocksource m68328_clk = {
 	.name	= "timer",
 	.rating	= 250,
 	.read	= m68328_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -115,8 +114,7 @@ void hw_timer_init(void)
 
 	/* Enable timer 1 */
 	TCTL |= TCTL_TEN;
-	m68328_clk.mult = clocksource_hz2mult(TICKS_PER_JIFFY*HZ, m68328_clk.shift);
-	clocksource_register(&m68328_clk);
+	clocksource_register_hz(&m68328_clk, TICKS_PER_JIFFY*HZ);
 }
 
 /***************************************************************************/
diff --git a/arch/m68k/platform/coldfire/dma_timer.c b/arch/m68k/platform/coldfire/dma_timer.c
index a5f5628..235ad57 100644
--- a/arch/m68k/platform/coldfire/dma_timer.c
+++ b/arch/m68k/platform/coldfire/dma_timer.c
@@ -44,7 +44,6 @@ static struct clocksource clocksource_cf_dt = {
 	.rating		= 200,
 	.read		= cf_dt_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -60,9 +59,7 @@ static int __init  init_cf_dt_clocksource(void)
 	__raw_writeb(0x00, DTER0);
 	__raw_writel(0x00000000, DTRR0);
 	__raw_writew(DMA_DTMR_CLK_DIV_16 | DMA_DTMR_ENABLE, DTMR0);
-	clocksource_cf_dt.mult = clocksource_hz2mult(DMA_FREQ,
-						     clocksource_cf_dt.shift);
-	return clocksource_register(&clocksource_cf_dt);
+	return clocksource_register_hz(&clocksource_cf_dt, DMA_FREQ);
 }
 
 arch_initcall(init_cf_dt_clocksource);
diff --git a/arch/m68knommu/platform/coldfire/pit.c b/arch/m68knommu/platform/coldfire/pit.c
new file mode 100644
index 0000000..ff5e34a
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/pit.c
@@ -0,0 +1,167 @@
+/***************************************************************************/
+
+/*
+ *	pit.c -- Freescale ColdFire PIT timer. Currently this type of
+ *	         hardware timer only exists in the Freescale ColdFire
+ *		 5270/5271, 5282 and 5208 CPUs. No doubt newer ColdFire
+ *		 family members will probably use it too.
+ *
+ *	Copyright (C) 1999-2008, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/clockchips.h>
+#include <asm/machdep.h>
+#include <asm/io.h>
+#include <asm/coldfire.h>
+#include <asm/mcfpit.h>
+#include <asm/mcfsim.h>
+
+/***************************************************************************/
+
+/*
+ *	By default use timer1 as the system clock timer.
+ */
+#define	FREQ	((MCF_CLK / 2) / 64)
+#define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
+#define PIT_CYCLES_PER_JIFFY (FREQ / HZ)
+
+static u32 pit_cnt;
+
+/*
+ * Initialize the PIT timer.
+ *
+ * This is also called after resume to bring the PIT into operation again.
+ */
+
+static void init_cf_pit_timer(enum clock_event_mode mode,
+                             struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+
+		__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
+		__raw_writew(PIT_CYCLES_PER_JIFFY, TA(MCFPIT_PMR));
+		__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | \
+				MCFPIT_PCSR_OVW | MCFPIT_PCSR_RLD | \
+				MCFPIT_PCSR_CLK64, TA(MCFPIT_PCSR));
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+
+		__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+
+		__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
+		__raw_writew(MCFPIT_PCSR_EN | MCFPIT_PCSR_PIE | \
+				MCFPIT_PCSR_OVW | MCFPIT_PCSR_CLK64, \
+				TA(MCFPIT_PCSR));
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+}
+
+/*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in PIT ticks
+ */
+static int cf_pit_next_event(unsigned long delta,
+		struct clock_event_device *evt)
+{
+	__raw_writew(delta, TA(MCFPIT_PMR));
+	return 0;
+}
+
+struct clock_event_device cf_pit_clockevent = {
+	.name		= "pit",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= init_cf_pit_timer,
+	.set_next_event	= cf_pit_next_event,
+	.shift		= 32,
+	.irq		= MCFINT_VECBASE + MCFINT_PIT1,
+};
+
+
+
+/***************************************************************************/
+
+static irqreturn_t pit_tick(int irq, void *dummy)
+{
+	struct clock_event_device *evt = &cf_pit_clockevent;
+	u16 pcsr;
+
+	/* Reset the ColdFire timer */
+	pcsr = __raw_readw(TA(MCFPIT_PCSR));
+	__raw_writew(pcsr | MCFPIT_PCSR_PIF, TA(MCFPIT_PCSR));
+
+	pit_cnt += PIT_CYCLES_PER_JIFFY;
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+/***************************************************************************/
+
+static struct irqaction pit_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = pit_tick,
+};
+
+/***************************************************************************/
+
+static cycle_t pit_read_clk(struct clocksource *cs)
+{
+	unsigned long flags;
+	u32 cycles;
+	u16 pcntr;
+
+	local_irq_save(flags);
+	pcntr = __raw_readw(TA(MCFPIT_PCNTR));
+	cycles = pit_cnt;
+	local_irq_restore(flags);
+
+	return cycles + PIT_CYCLES_PER_JIFFY - pcntr;
+}
+
+/***************************************************************************/
+
+static struct clocksource pit_clk = {
+	.name	= "pit",
+	.rating	= 100,
+	.read	= pit_read_clk,
+	.mask	= CLOCKSOURCE_MASK(32),
+};
+
+/***************************************************************************/
+
+void hw_timer_init(void)
+{
+	cf_pit_clockevent.cpumask = cpumask_of(smp_processor_id());
+	cf_pit_clockevent.mult = div_sc(FREQ, NSEC_PER_SEC, 32);
+	cf_pit_clockevent.max_delta_ns =
+		clockevent_delta2ns(0xFFFF, &cf_pit_clockevent);
+	cf_pit_clockevent.min_delta_ns =
+		clockevent_delta2ns(0x3f, &cf_pit_clockevent);
+	clockevents_register_device(&cf_pit_clockevent);
+
+	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &pit_irq);
+
+	clocksource_register_hz(&pit_clk, FREQ);
+}
+
+/***************************************************************************/
diff --git a/arch/m68knommu/platform/coldfire/timers.c b/arch/m68knommu/platform/coldfire/timers.c
new file mode 100644
index 0000000..6b8faec
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/timers.c
@@ -0,0 +1,172 @@
+/***************************************************************************/
+
+/*
+ *	timers.c -- generic ColdFire hardware timer support.
+ *
+ *	Copyright (C) 1999-2008, Greg Ungerer <gerg@snapgear.com>
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/profile.h>
+#include <linux/clocksource.h>
+#include <asm/io.h>
+#include <asm/traps.h>
+#include <asm/machdep.h>
+#include <asm/coldfire.h>
+#include <asm/mcftimer.h>
+#include <asm/mcfsim.h>
+
+/***************************************************************************/
+
+/*
+ *	By default use timer1 as the system clock timer.
+ */
+#define	FREQ	(MCF_BUSCLK / 16)
+#define	TA(a)	(MCF_MBAR + MCFTIMER_BASE1 + (a))
+
+/*
+ *	These provide the underlying interrupt vector support.
+ *	Unfortunately it is a little different on each ColdFire.
+ */
+void coldfire_profile_init(void);
+
+#if defined(CONFIG_M532x)
+#define	__raw_readtrr	__raw_readl
+#define	__raw_writetrr	__raw_writel
+#else
+#define	__raw_readtrr	__raw_readw
+#define	__raw_writetrr	__raw_writew
+#endif
+
+static u32 mcftmr_cycles_per_jiffy;
+static u32 mcftmr_cnt;
+
+/***************************************************************************/
+
+static irqreturn_t mcftmr_tick(int irq, void *dummy)
+{
+	/* Reset the ColdFire timer */
+	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, TA(MCFTIMER_TER));
+
+	mcftmr_cnt += mcftmr_cycles_per_jiffy;
+	return arch_timer_interrupt(irq, dummy);
+}
+
+/***************************************************************************/
+
+static struct irqaction mcftmr_timer_irq = {
+	.name	 = "timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = mcftmr_tick,
+};
+
+/***************************************************************************/
+
+static cycle_t mcftmr_read_clk(struct clocksource *cs)
+{
+	unsigned long flags;
+	u32 cycles;
+	u16 tcn;
+
+	local_irq_save(flags);
+	tcn = __raw_readw(TA(MCFTIMER_TCN));
+	cycles = mcftmr_cnt;
+	local_irq_restore(flags);
+
+	return cycles + tcn;
+}
+
+/***************************************************************************/
+
+static struct clocksource mcftmr_clk = {
+	.name	= "tmr",
+	.rating	= 250,
+	.read	= mcftmr_read_clk,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/***************************************************************************/
+
+void hw_timer_init(void)
+{
+	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
+	mcftmr_cycles_per_jiffy = FREQ / HZ;
+	/*
+	 *	The coldfire timer runs from 0 to TRR included, then 0
+	 *	again and so on.  It counts thus actually TRR + 1 steps
+	 *	for 1 tick, not TRR.  So if you want n cycles,
+	 *	initialize TRR with n - 1.
+	 */
+	__raw_writetrr(mcftmr_cycles_per_jiffy - 1, TA(MCFTIMER_TRR));
+	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
+		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
+
+	clocksource_register_hz(&mcftmr_clk, FREQ);
+
+	setup_irq(MCF_IRQ_TIMER, &mcftmr_timer_irq);
+
+#ifdef CONFIG_HIGHPROFILE
+	coldfire_profile_init();
+#endif
+}
+
+/***************************************************************************/
+#ifdef CONFIG_HIGHPROFILE
+/***************************************************************************/
+
+/*
+ *	By default use timer2 as the profiler clock timer.
+ */
+#define	PA(a)	(MCF_MBAR + MCFTIMER_BASE2 + (a))
+
+/*
+ *	Choose a reasonably fast profile timer. Make it an odd value to
+ *	try and get good coverage of kernel operations.
+ */
+#define	PROFILEHZ	1013
+
+/*
+ *	Use the other timer to provide high accuracy profiling info.
+ */
+irqreturn_t coldfire_profile_tick(int irq, void *dummy)
+{
+	/* Reset ColdFire timer2 */
+	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, PA(MCFTIMER_TER));
+	if (current->pid)
+		profile_tick(CPU_PROFILING);
+	return IRQ_HANDLED;
+}
+
+/***************************************************************************/
+
+static struct irqaction coldfire_profile_irq = {
+	.name	 = "profile timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = coldfire_profile_tick,
+};
+
+void coldfire_profile_init(void)
+{
+	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n",
+	       PROFILEHZ);
+
+	/* Set up TIMER 2 as high speed profile clock */
+	__raw_writew(MCFTIMER_TMR_DISABLE, PA(MCFTIMER_TMR));
+
+	__raw_writetrr(((MCF_BUSCLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
+	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
+		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, PA(MCFTIMER_TMR));
+
+	setup_irq(MCF_IRQ_PROFILER, &coldfire_profile_irq);
+}
+
+/***************************************************************************/
+#endif	/* CONFIG_HIGHPROFILE */
+/***************************************************************************/
-- 
1.7.3.2.146.gca209

