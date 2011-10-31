Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab1KAAW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:22:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1448 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091Ab1KAARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:46 -0400
Message-Id: <e97c6e$3uab0m@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132459542"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:43:24 -0500
Subject: [PATCH v5 18/36] Hexagon: Add time and timer functions
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/time.h       |   29 ++++
 arch/hexagon/include/asm/timer-regs.h |   39 +++++
 arch/hexagon/kernel/time.c            |  250 +++++++++++++++++++++++++++++++++
 3 files changed, 318 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/time.h
 create mode 100644 arch/hexagon/include/asm/timer-regs.h
 create mode 100644 arch/hexagon/kernel/time.c

diff --git a/arch/hexagon/include/asm/time.h b/arch/hexagon/include/asm/time.h
new file mode 100644
index 0000000..081b82c
--- /dev/null
+++ b/arch/hexagon/include/asm/time.h
@@ -0,0 +1,29 @@
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
+extern cycles_t        pcycle_freq_mhz;
+extern cycles_t        thread_freq_mhz;
+extern cycles_t        sleep_clk_freq;
+
+void setup_percpu_clockdev(void);
+void ipi_timer(void);
+
+#endif
diff --git a/arch/hexagon/include/asm/timer-regs.h b/arch/hexagon/include/asm/timer-regs.h
new file mode 100644
index 0000000..d80db23
--- /dev/null
+++ b/arch/hexagon/include/asm/timer-regs.h
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
diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
new file mode 100644
index 0000000..6bee15c
--- /dev/null
+++ b/arch/hexagon/kernel/time.c
@@ -0,0 +1,250 @@
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
+ * For the clocksource we need:
+ *	pcycle frequency (600MHz)
+ * For the loops_per_jiffy we need:
+ *	thread/cpu frequency (100MHz)
+ * And for the timer, we need:
+ *	sleep clock rate
+ */
+
+cycles_t	pcycle_freq_mhz;
+cycles_t	thread_freq_mhz;
+cycles_t	sleep_clk_freq;
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
+	u32 match;   /*  Match value  */
+	u32 count;
+	u32 enable;  /*  [1] - CLR_ON_MATCH_EN, [0] - EN  */
+	u32 clear;   /*  one-shot register that clears the count  */
+};
+
+/*  Look for "TCX0" for related constants.  */
+static __iomem struct adsp_hw_timer_struct *rtos_timer;
+
+static cycle_t timer_get_cycles(struct clocksource *cs)
+{
+	return (cycle_t) __vmgettime();
+}
+
+static struct clocksource hexagon_clocksource = {
+	.name		= "pcycles",
+	.rating		= 250,
+	.read		= timer_get_cycles,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int set_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	/*  Assuming the timer will be disabled when we enter here.  */
+
+	iowrite32(1, &rtos_timer->clear);
+	iowrite32(0, &rtos_timer->clear);
+
+	iowrite32(delta, &rtos_timer->match);
+	iowrite32(1 << TIMER_ENABLE, &rtos_timer->enable);
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
+	.irq		= RTOS_TIMER_INT,
+	.set_next_event = set_next_event,
+	.set_mode	= set_mode,
+#ifdef CONFIG_SMP
+	.broadcast	= broadcast,
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
+	struct clock_event_device *ce_dev = &per_cpu(clock_events, cpu);
+
+	ce_dev->event_handler(ce_dev);
+}
+#endif /* CONFIG_SMP */
+
+static irqreturn_t timer_interrupt(int irq, void *devid)
+{
+	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
+
+	iowrite32(0, &rtos_timer->enable);
+	ce_dev->event_handler(ce_dev);
+
+	return IRQ_HANDLED;
+}
+
+/*  This should also be pulled from devtree  */
+static struct irqaction rtos_timer_intdesc = {
+	.handler = timer_interrupt,
+	.flags = IRQF_TIMER | IRQF_TRIGGER_RISING,
+	.name = "rtos_timer"
+};
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
+	ce_dev->cpumask = cpu_all_mask;
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
+	clocksource_register_khz(&hexagon_clocksource, pcycle_freq_mhz * 1000);
+
+	/*  Note: the sim generic RTOS clock is apparently really 18750Hz  */
+
+	/*
+	 * Last arg is some guaranteed seconds for which the conversion will
+	 * work without overflow.
+	 */
+	clockevents_calc_mult_shift(ce_dev, sleep_clk_freq, 4);
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
+ * This could become parametric or perhaps even computed at run-time,
+ * but for now we take the observed simulator jitter.
+ */
+static long long fudgefactor = 350;  /* Maybe lower if kernel optimized. */
+
+void __udelay(unsigned long usecs)
+{
+	unsigned long long start = __vmgettime();
+	unsigned long long finish = (pcycle_freq_mhz * usecs) - fudgefactor;
+
+	while ((__vmgettime() - start) < finish)
+		cpu_relax(); /*  not sure how this improves readability  */
+}
+EXPORT_SYMBOL(__udelay);
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
