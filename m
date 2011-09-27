Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1I0Ues (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1I0Ua0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:26 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 11/24] C6X: time management
Date: Tue, 27 Sep 2011 16:29:52 -0400
Message-Id: <1317155405-26235-12-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C6X architecture includes a 64-bit free running core clock counter which
is used as the clocksource. The SoCs have a number of 64-bit programmable
timers. One of these is used as the clockevent timer.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/timer64.h |    6 ++
 arch/c6x/include/asm/timex.h   |   38 ++++++++
 arch/c6x/kernel/time.c         |   65 ++++++++++++++
 arch/c6x/platforms/timer64.c   |  188 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 297 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/timer64.h
 create mode 100644 arch/c6x/include/asm/timex.h
 create mode 100644 arch/c6x/kernel/time.c
 create mode 100644 arch/c6x/platforms/timer64.c

diff --git a/arch/c6x/include/asm/timer64.h b/arch/c6x/include/asm/timer64.h
new file mode 100644
index 0000000..bbe27bb
--- /dev/null
+++ b/arch/c6x/include/asm/timer64.h
@@ -0,0 +1,6 @@
+#ifndef _C6X_TIMER64_H
+#define _C6X_TIMER64_H
+
+extern void __init timer64_init(void);
+
+#endif /* _C6X_TIMER64_H */
diff --git a/arch/c6x/include/asm/timex.h b/arch/c6x/include/asm/timex.h
new file mode 100644
index 0000000..8739a23
--- /dev/null
+++ b/arch/c6x/include/asm/timex.h
@@ -0,0 +1,38 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Modified for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_TIMEX_H
+#define _ASM_C6X_TIMEX_H
+
+/*
+ * This should be close enough...
+ */
+#define CLOCK_TICK_RATE ((1000 * 1000000UL) / 6)
+
+/* 64-bit timestamp */
+typedef unsigned long long cycles_t;
+
+extern cycles_t cacheflush_time;
+
+static inline cycles_t get_cycles(void)
+{
+	unsigned l, h;
+
+	asm volatile (" dint\n"
+		      " mvc .s2 TSCL,%0\n"
+		      " mvc .s2 TSCH,%1\n"
+		      " rint\n"
+		      : "=b"(l), "=b"(h));
+	return ((cycles_t)h << 32) | l;
+}
+
+#endif /* _ASM_C6X_TIMEX_H */
diff --git a/arch/c6x/kernel/time.c b/arch/c6x/kernel/time.c
new file mode 100644
index 0000000..4c9f136
--- /dev/null
+++ b/arch/c6x/kernel/time.c
@@ -0,0 +1,65 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clocksource.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/timex.h>
+#include <linux/profile.h>
+
+#include <asm/timer64.h>
+
+static u32 sched_clock_multiplier;
+#define SCHED_CLOCK_SHIFT 16
+
+static cycle_t tsc_read(struct clocksource *cs)
+{
+	return get_cycles();
+}
+
+static struct clocksource clocksource_tsc = {
+	.name		= "timestamp",
+	.rating		= 300,
+	.read		= tsc_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/*
+ * scheduler clock - returns current time in nanoseconds.
+ */
+u64 sched_clock(void)
+{
+	u64 tsc = get_cycles();
+
+	return (tsc * sched_clock_multiplier) >> SCHED_CLOCK_SHIFT;
+}
+
+void time_init(void)
+{
+	u64 tmp = (u64)NSEC_PER_SEC << SCHED_CLOCK_SHIFT;
+
+	do_div(tmp, c6x_core_freq);
+	sched_clock_multiplier = tmp;
+
+	clocksource_register_hz(&clocksource_tsc, c6x_core_freq);
+
+	/* write anything into TSCL to enable counting */
+	set_creg(TSCL, 0);
+
+	/* probe for timer64 event timer */
+	timer64_init();
+}
diff --git a/arch/c6x/platforms/timer64.c b/arch/c6x/platforms/timer64.c
new file mode 100644
index 0000000..1894eb0
--- /dev/null
+++ b/arch/c6x/platforms/timer64.c
@@ -0,0 +1,188 @@
+/*
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Contributed by: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <asm/soc.h>
+#include <asm/dscr.h>
+#include <asm/timer64.h>
+
+struct timer_regs {
+	u32	reserved0;
+	u32	emumgt;
+	u32	reserved1;
+	u32	reserved2;
+	u32	cntlo;
+	u32	cnthi;
+	u32	prdlo;
+	u32	prdhi;
+	u32	tcr;
+	u32	tgcr;
+	u32	wdtcr;
+};
+
+static struct timer_regs __iomem *timer;
+
+#define TCR_TSTATLO	     0x001
+#define TCR_INVOUTPLO	     0x002
+#define TCR_INVINPLO	     0x004
+#define TCR_CPLO	     0x008
+#define TCR_ENAMODELO_ONCE   0x040
+#define TCR_ENAMODELO_CONT   0x080
+#define TCR_ENAMODELO_MASK   0x0c0
+#define TCR_PWIDLO_MASK      0x030
+#define TCR_CLKSRCLO	     0x100
+#define TCR_TIENLO	     0x200
+#define TCR_TSTATHI	     (0x001 << 16)
+#define TCR_INVOUTPHI	     (0x002 << 16)
+#define TCR_CPHI	     (0x008 << 16)
+#define TCR_PWIDHI_MASK      (0x030 << 16)
+#define TCR_ENAMODEHI_ONCE   (0x040 << 16)
+#define TCR_ENAMODEHI_CONT   (0x080 << 16)
+#define TCR_ENAMODEHI_MASK   (0x0c0 << 16)
+
+#define TGCR_TIMLORS	     0x001
+#define TGCR_TIMHIRS	     0x002
+#define TGCR_TIMMODE_UD32    0x004
+#define TGCR_TIMMODE_WDT64   0x008
+#define TGCR_TIMMODE_CD32    0x00c
+#define TGCR_TIMMODE_MASK    0x00c
+#define TGCR_PSCHI_MASK      (0x00f << 8)
+#define TGCR_TDDRHI_MASK     (0x00f << 12)
+
+/*
+ * Timer clocks are divided down from the CPU clock
+ * The divisor is in the EMUMGTCLKSPD register
+ */
+#define TIMER_DIVISOR \
+	((soc_readl(&timer->emumgt) & (0xf << 16)) >> 16)
+
+#define timer_period(f, d)	      (((f) * 1000000) / ((d) * HZ))
+#define ticks2usecs(f, d, x)	      (((x) * (d)) / (f))
+
+
+static int next_event(unsigned long delta,
+		      struct clock_event_device *evt)
+{
+	soc_writel(soc_readl(&timer->tcr) & ~TCR_ENAMODELO_MASK, &timer->tcr);
+	soc_writel(delta - 1, &timer->prdlo);
+	soc_writel(0, &timer->cntlo);
+	soc_writel(soc_readl(&timer->tcr) | TCR_ENAMODELO_ONCE, &timer->tcr);
+
+	return 0;
+}
+
+static void set_clock_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+}
+
+static struct clock_event_device t64_clockevent_device = {
+	.name		= "TIMER64_EVT32_TIMER",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.rating		= 200,
+	.set_mode	= set_clock_mode,
+	.set_next_event	= next_event,
+};
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *cd = &t64_clockevent_device;
+
+	cd->event_handler(cd);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_iact = {
+	.name		= "timer",
+	.flags		= IRQF_TIMER,
+	.handler	= timer_interrupt,
+	.dev_id		= &t64_clockevent_device,
+};
+
+void __init timer64_init(void)
+{
+	struct clock_event_device *cd = &t64_clockevent_device;
+	struct device_node *np, *first = NULL;
+	u32 val;
+	int err, found = 0;
+
+	for_each_compatible_node(np, NULL, "ti,c64x+timer64") {
+		err = of_property_read_u32_array(np, "ti,core-mask", &val, 1);
+		if (!err) {
+			if (val & (1 << get_coreid())) {
+				found = 1;
+				break;
+			}
+		} else if (!first)
+			first = np;
+	}
+	if (!found) {
+		/* try first one with no core-mask */
+		if (first)
+			np = of_node_get(first);
+		else {
+			pr_debug("Cannot find ti,c64x+timer64 timer.\n");
+			return;
+		}
+	}
+
+	timer = of_iomap(np, 0);
+	if (!timer) {
+		pr_debug("%s: Cannot map timer registers.\n", np->full_name);
+		goto out;
+	}
+	pr_debug("%s: Timer registers=%p.\n", np->full_name, timer);
+
+	cd->irq	= irq_of_parse_and_map(np, 0);
+	if (cd->irq == NO_IRQ) {
+		pr_debug("%s: Cannot find interrupt.\n", np->full_name);
+		iounmap(timer);
+		goto out;
+	}
+
+	/* If there is a device state control, enable it. */
+	err = of_property_read_u32_array(np, "ti,dscr-dev-enable", &val, 1);
+	if (!err)
+		dscr_set_devstate(val, DSCR_DEVSTATE_ENABLED);
+
+	/* disable timer, reset count */
+	soc_writel(soc_readl(&timer->tcr) & ~TCR_ENAMODELO_MASK, &timer->tcr);
+	soc_writel(0, &timer->prdlo);
+
+	/* use internal clock and 1 cycle pulse width */
+	val = soc_readl(&timer->tcr);
+	soc_writel(val & ~(TCR_CLKSRCLO | TCR_PWIDLO_MASK), &timer->tcr);
+
+	/* dual 32-bit unchained mode */
+	val = soc_readl(&timer->tgcr) & ~TGCR_TIMMODE_MASK;
+	soc_writel(val, &timer->tgcr);
+	soc_writel(val | (TGCR_TIMLORS | TGCR_TIMMODE_UD32), &timer->tgcr);
+
+	pr_debug("%s: Timer irq=%d.\n", np->full_name, cd->irq);
+
+	clockevents_calc_mult_shift(cd, c6x_core_freq / TIMER_DIVISOR, 5);
+
+	cd->max_delta_ns	= clockevent_delta2ns(0x7fffffff, cd);
+	cd->min_delta_ns	= clockevent_delta2ns(250, cd);
+
+	cd->cpumask		= cpumask_of(smp_processor_id());
+
+	clockevents_register_device(cd);
+	setup_irq(cd->irq, &timer_iact);
+
+out:
+	of_node_put(np);
+	return;
+}
-- 
1.7.6.2

