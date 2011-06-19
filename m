Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1FSLrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:47:49 -0400
Received: from mail.southpole.se ([193.12.106.18]:37745 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1FSLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:20 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 08/19] OpenRISC: Timekeeping
Date: Sun, 19 Jun 2011 13:43:34 +0200
Message-Id: <1308483825-6023-9-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/timex.h |   35 +++++++
 arch/openrisc/kernel/time.c       |  182 +++++++++++++++++++++++++++++++++++++
 2 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/timex.h
 create mode 100644 arch/openrisc/kernel/time.c

diff --git a/arch/openrisc/include/asm/timex.h b/arch/openrisc/include/asm/timex.h
new file mode 100644
index 0000000..20d5619
--- /dev/null
+++ b/arch/openrisc/include/asm/timex.h
@@ -0,0 +1,35 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_TIMEX_H
+#define __ASM_OPENRISC_TIMEX_H
+
+#include <asm-generic/timex.h>
+
+#include <asm/param.h>
+#include <asm/cpuinfo.h>
+
+//#define CLOCK_TICK_RATE	(CONFIG_OPENRISC_SYS_CLK*1000000 / HZ)
+//#define CLOCK_TICK_RATE	(cpuinfo.clock_frequency / HZ)
+
+/* This isn't really used any more */
+#define CLOCK_TICK_RATE 1000
+
+#define ARCH_HAS_READ_CURRENT_TIMER
+
+#endif
diff --git a/arch/openrisc/kernel/time.c b/arch/openrisc/kernel/time.c
new file mode 100644
index 0000000..5b367cf
--- /dev/null
+++ b/arch/openrisc/kernel/time.c
@@ -0,0 +1,182 @@
+/*
+ * OpenRISC time.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/time.h>
+#include <linux/timex.h>
+#include <linux/interrupt.h>
+#include <linux/ftrace.h>
+
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include <asm/cpuinfo.h>
+
+static int openrisc_timer_set_next_event(unsigned long delta,
+                                     struct clock_event_device *dev)
+{
+	u32 c;
+
+	/* Read 32-bit counter value, add delta, mask off the low 28 bits.
+	 * We're guaranteed delta won't be bigger than 28 bits because the
+	 * generic timekeeping code ensures that for us.
+	 */
+	c = mfspr(SPR_TTCR);
+	c += delta;
+	c &= SPR_TTMR_TP;
+
+	/* Set counter and enable interrupt.
+	 * Keep timer in continuous mode always.
+	 */
+	mtspr(SPR_TTMR, SPR_TTMR_CR | SPR_TTMR_IE | c);
+
+        return 0;
+}
+
+static void openrisc_timer_set_mode(enum clock_event_mode mode,
+                                struct clock_event_device *evt)
+{
+        switch (mode) {
+        case CLOCK_EVT_MODE_PERIODIC:
+                pr_debug(KERN_INFO "%s: periodic\n", __func__);
+		BUG();
+                break;
+        case CLOCK_EVT_MODE_ONESHOT:
+                pr_debug(KERN_INFO "%s: oneshot\n", __func__);
+                break;
+        case CLOCK_EVT_MODE_UNUSED:
+                pr_debug(KERN_INFO "%s: unused\n", __func__);
+                break;
+        case CLOCK_EVT_MODE_SHUTDOWN:
+                pr_debug(KERN_INFO "%s: shutdown\n", __func__);
+                break;
+        case CLOCK_EVT_MODE_RESUME:
+                pr_debug(KERN_INFO "%s: resume\n", __func__);
+                break;
+        }
+}
+
+/* This is the clock event device based on the OR1K tick timer.
+ * As the timer is being used as a continuous clock-source (required for HR
+ * timers) we cannot enable the PERIODIC feature.  The tick timer can run using
+ * one-shot events, so no problem.
+ */
+
+static struct clock_event_device clockevent_openrisc_timer = {
+        .name           = "openrisc_timer_clockevent",
+        .features       = CLOCK_EVT_FEAT_ONESHOT,
+        .rating         = 300,
+        .set_next_event = openrisc_timer_set_next_event,
+        .set_mode       = openrisc_timer_set_mode,
+};
+
+static inline void timer_ack(void)
+{
+	/* Clear the IP bit and disable further interrupts */
+	/* This can be done very simply... we just need to keep the timer
+	   running, so just maintain the CR bits while clearing the rest
+	   of the register
+	*/
+	mtspr(SPR_TTMR, SPR_TTMR_CR);
+}
+
+/*
+ * The timer interrupt is mostly handled in generic code nowadays... this
+ * function just acknowledges the interrupt and fires the event handler that
+ * has been set on the clockevent device by the generic time management code.
+ *
+ * This function needs to be called by the timer exception handler and that's
+ * all the exception handler needs to do.
+ */
+
+irqreturn_t __irq_entry timer_interrupt(struct pt_regs * regs)
+{
+        struct pt_regs *old_regs = set_irq_regs(regs);
+        struct clock_event_device *evt = &clockevent_openrisc_timer;
+
+        timer_ack();
+
+	/*
+	 * update_process_times() expects us to have called irq_enter().
+	 */
+	irq_enter();
+        evt->event_handler(evt);
+	irq_exit();
+
+        set_irq_regs(old_regs);
+
+        return IRQ_HANDLED;
+}
+
+static __init void openrisc_clockevent_init(void)
+{
+	clockevents_calc_mult_shift(&clockevent_openrisc_timer,
+				    cpuinfo.clock_frequency, 4);
+
+	/* We only have 28 bits */
+        clockevent_openrisc_timer.max_delta_ns =
+                clockevent_delta2ns((u32)0x0fffffff,
+				    &clockevent_openrisc_timer);
+        clockevent_openrisc_timer.min_delta_ns =
+                clockevent_delta2ns(1, &clockevent_openrisc_timer);
+        clockevent_openrisc_timer.cpumask = cpumask_of(0);
+        clockevents_register_device(&clockevent_openrisc_timer);
+}
+
+
+/**
+ * Clocksource: Based on OpenRISC timer/counter
+ *
+ * This sets up the OpenRISC Tick Timer as a clock source.  The tick timer
+ * is 32 bits wide and runs at the CPU clock frequency.
+ */
+
+static cycle_t openrisc_timer_read(struct clocksource* cs) {
+	return (cycle_t) mfspr(SPR_TTCR);
+}
+
+static struct clocksource openrisc_timer = {
+	.name		= "openrisc_timer",
+        .rating         = 200,
+	.read		= openrisc_timer_read,
+        .mask           = CLOCKSOURCE_MASK(32),
+        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init openrisc_timer_init(void)
+{
+        if (clocksource_register_hz(&openrisc_timer, cpuinfo.clock_frequency))
+                panic("failed to register clocksource");
+
+	/* Enable the incrementer: 'continuous' mode with interrupt disabled */
+        mtspr(SPR_TTMR, SPR_TTMR_CR);
+
+        return 0;
+}
+
+void __init time_init(void)
+{
+	u32 upr;
+
+	upr = mfspr(SPR_UPR);
+	if (!(upr & SPR_UPR_TTP))
+		panic("Linux not supported on devices without tick timer");
+
+	openrisc_timer_init();
+	openrisc_clockevent_init();
+}
-- 
1.7.4.1

