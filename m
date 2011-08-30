Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1H3TTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:19:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1H3TPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113875049"
Message-Id: <20110830190801.448257740@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:47 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch v2 18/35] Hexagon: Add time and timer functions
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=timer.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/time.h       |   27 +++
 arch/hexagon/include/asm/timer-regs.h |   39 ++++
 arch/hexagon/kernel/time.c            |  283 ++++++++++++++++++++++++++++++++++
 3 files changed, 349 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/time.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/time.h	2011-08-24 18:45:48.233877192 -0500
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef ASM_TIME_H
+#define ASM_TIME_H
+
+#ifdef CONFIG_SMP
+void setup_percpu_clockdev(void);
+void ipi_timer(void);
+#endif
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/timer-regs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/timer-regs.h	2011-08-24 18:45:48.233877192 -0500
@@ -0,0 +1,39 @@
+/*
+ * Timer support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_TIMER_REGS_H
+#define _ASM_TIMER_REGS_H
+
+/*  This stuff should go into a platform specific file  */
+#define TCX0_CLK_RATE		19200
+#define TIMER_ENABLE		0
+#define TIMER_CLR_ON_MATCH	1
+
+/*
+ * 8x50 HDD Specs 5-8.  Simulator co-sim not fixed until
+ * release 1.1, and then it's "adjustable" and probably not defaulted.
+ */
+#define RTOS_TIMER_INT		3
+#ifdef CONFIG_HEXAGON_COMET
+#define RTOS_TIMER_REGS_ADDR	0xAB000000UL
+#endif
+#define SLEEP_CLK_RATE		32000
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/time.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/time.c	2011-08-24 18:45:48.233877192 -0500
@@ -0,0 +1,283 @@
+/*
+ * Time related functions for Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#include <asm/timer-regs.h>
+#include <asm/hexagon_vm.h>
+
+/*
+ * For now, hard wire the simulated CPU/pcycle frequency.
+ * XXX TODO fish it out of device tree!
+ */
+#define CPU_MHZ 600
+
+static struct resource rtos_timer_resources[] = {
+	{
+		.start	= RTOS_TIMER_REGS_ADDR,
+		.end	= RTOS_TIMER_REGS_ADDR+PAGE_SIZE-1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device rtos_timer_device = {
+	.name		= "rtos_timer",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(rtos_timer_resources),
+	.resource	= rtos_timer_resources,
+};
+
+/*  A lot of this stuff should move into a platform specific section.  */
+struct adsp_hw_timer_struct {
+	unsigned int match;   /*  Match value  */
+	unsigned int count;
+	unsigned int enable;  /*  [1] - CLR_ON_MATCH_EN, [0] - EN  */
+	unsigned int clear;   /*  one-shot register that clears the count  */
+};
+
+/*  Look for "TCX0" for related constants.  */
+static volatile struct adsp_hw_timer_struct *rtos_timer = (void *) 0x0;
+
+void debug_adsp_timers(void)
+{
+	printk(KERN_INFO "rtos_timer->match=0x%08x\n", rtos_timer->match);
+	printk(KERN_INFO "rtos_timer->count=%d\n", rtos_timer->count);
+	printk(KERN_INFO "rtos_timer->enable=%d\n", rtos_timer->enable);
+	printk(KERN_INFO "rtos_timer->clear=%d\n", rtos_timer->clear);
+}
+
+static cycle_t timer_get_cycles(struct clocksource *cs)
+{
+	return (cycle_t) __vmgettime();
+}
+
+static struct clocksource hexagon_clocksource = {
+	.name		= "pcycles",
+	.rating		= 250,
+	.shift		= 16,
+	.read		= timer_get_cycles,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int set_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	/*  Assuming the timer will be disabled when we enter here.  */
+	rtos_timer->clear = 1;
+	rtos_timer->clear = 0;
+
+	/*  Does this need massaging?  */
+	rtos_timer->match = delta;
+	rtos_timer->enable = 1 << TIMER_ENABLE;
+	return 0;
+}
+
+/*
+ * Sets the mode (periodic, shutdown, oneshot, etc) of a timer.
+ */
+static void set_mode(enum clock_event_mode mode,
+	struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* XXX implement me */
+	default:
+		break;
+	}
+}
+
+#ifdef CONFIG_SMP
+/*  Broadcast mechanism  */
+static void broadcast(const struct cpumask *mask)
+{
+	send_ipi(mask, IPI_TIMER);
+}
+#endif
+
+static struct clock_event_device hexagon_clockevent_dev = {
+	.name		= "clockevent",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.rating		= 400,
+	.shift		= 32,
+	.irq		= RTOS_TIMER_INT,
+	.set_next_event = set_next_event,
+	.set_mode	= set_mode,
+#ifdef CONFIG_SMP
+	.broadcast	= broadcast
+#endif
+};
+
+#ifdef CONFIG_SMP
+static DEFINE_PER_CPU(struct clock_event_device, clock_events);
+
+void setup_percpu_clockdev(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
+	struct clock_event_device *dummy_clock_dev =
+		&per_cpu(clock_events, cpu);
+
+	memcpy(dummy_clock_dev, ce_dev, sizeof(*dummy_clock_dev));
+	INIT_LIST_HEAD(&dummy_clock_dev->list);
+
+	dummy_clock_dev->features = CLOCK_EVT_FEAT_DUMMY;
+	dummy_clock_dev->cpumask = cpumask_of(cpu);
+	dummy_clock_dev->mode = CLOCK_EVT_MODE_UNUSED;
+
+	clockevents_register_device(dummy_clock_dev);
+}
+
+/*  Called from smp.c for each CPU's timer ipi call  */
+void ipi_timer(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
+
+	ce_dev = &per_cpu(clock_events, cpu);
+	ce_dev->event_handler(ce_dev);
+}
+#endif /* CONFIG_SMP */
+
+static irqreturn_t timer_interrupt(int irq, void *devid)
+{
+	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
+
+	rtos_timer->enable = 0;
+	ce_dev->event_handler(ce_dev);
+
+	return IRQ_HANDLED;
+}
+
+/*  This should also be pulled from devtree  */
+static struct irqaction rtos_timer_intdesc = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
+	.name = "rtos_timer"
+};
+
+void clocksource_debug(struct clocksource *cs)
+{
+	printk(KERN_DEBUG "cs->mult=0x%08x\n", cs->mult);
+	printk(KERN_DEBUG "cs->shift=%d\n", cs->shift);
+}
+
+void clockevent_debug(struct clock_event_device *ce)
+{
+	printk(KERN_DEBUG "ce->mult=0x%08x\n", ce->mult);
+	printk(KERN_DEBUG "ce->shift=%d\n", ce->shift);
+}
+
+/*
+ * time_init_deferred - called by start_kernel to set up timer/clock source
+ *
+ * Install the IRQ handler for the clock, setup timers.
+ * This is done late, as that way, we can use ioremap().
+ *
+ * This runs just before the delay loop is calibrated, and
+ * is used for delay calibration.
+ */
+void __init time_init_deferred(void)
+{
+	struct resource *resource = NULL;
+	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
+	struct device_node *dn;
+	struct resource r;
+	int err;
+
+#ifdef CONFIG_SMP
+	ce_dev->cpumask = cpu_all_mask;
+#else
+	ce_dev->cpumask = cpumask_of(0);
+#endif
+
+	if (!resource)
+		resource = rtos_timer_device.resource;
+
+	/*  ioremap here means this has to run later, after paging init  */
+	rtos_timer = ioremap(resource->start, resource->end
+		- resource->start + 1);
+
+	if (!rtos_timer) {
+		release_mem_region(resource->start, resource->end
+			- resource->start + 1);
+	}
+	/*  Change to clocksource_register_khz in newer kernels  */
+	hexagon_clocksource.mult = clocksource_hz2mult(CPU_MHZ * 1000000,
+		hexagon_clocksource.shift);
+	clocksource_register(&hexagon_clocksource);
+	clocksource_debug(&hexagon_clocksource);
+
+	/*  Note: the sim generic RTOS clock is apparently really 18750Hz  */
+	/*  Change to clockevents_calc_mult_shift()  */
+	/*  SLEEP_CLK_RATE should be pulled from devtree?  */
+	ce_dev->mult  = div_sc(SLEEP_CLK_RATE, NSEC_PER_SEC,
+			       ce_dev->shift);
+
+	ce_dev->max_delta_ns = clockevent_delta2ns(0x7fffffff, ce_dev);
+	ce_dev->min_delta_ns = clockevent_delta2ns(0xf, ce_dev);
+
+#ifdef CONFIG_SMP
+	setup_percpu_clockdev();
+#endif
+
+	clockevents_register_device(ce_dev);
+	setup_irq(ce_dev->irq, &rtos_timer_intdesc);
+}
+
+void __init time_init(void)
+{
+	late_time_init = time_init_deferred;
+}
+
+/*
+ * Some architectures inline this, which seems slightly insane.
+ * Why burn memory to speed up a delay function?
+ *
+ * Note that there are hooks for MP systems to have different
+ * delay values for different CPUs.  We should ultimately replace
+ * the CPU_MHZ constant below with a reference to whatever per-CPU
+ * state is dedicated to that role.
+ */
+
+/*
+ * This could become parametric or perhaps even computed at run-time,
+ * but for now we take the observed simulator jitter.
+ * XXX TODO fish this out of the device tree!
+ */
+static long long fudgefactor = 350;  /* Maybe lower if kernel optimized. */
+
+void __udelay(unsigned long usecs)
+{
+	unsigned long long start = __vmgettime();
+	unsigned long long finish = (CPU_MHZ * usecs) - fudgefactor;
+
+	while ((__vmgettime() - start) < finish)
+		; /*  not sure how this improves readability  */
+}
+EXPORT_SYMBOL(__udelay);

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

