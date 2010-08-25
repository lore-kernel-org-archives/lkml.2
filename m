Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0HYE65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:58:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0HYE6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012244"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366138"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: [PATCH 08/24] msm: timer: support 8x60 timers
Date: Tue, 24 Aug 2010 21:57:37 -0700
Message-Id: <1282712273-344-9-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   10 +-
 arch/arm/mach-msm/timer.c                       |  226 +++++++++++++++++------
 2 files changed, 177 insertions(+), 59 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index ee58da5..1f15bbb 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -35,7 +35,6 @@
  *
  */
 
-
 #define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
 #define MSM_QGIC_DIST_PHYS	0x02080000
 #define MSM_QGIC_DIST_SIZE	SZ_4K
@@ -56,7 +55,14 @@
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
 
-#define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
+#define MSM_TMR_BASE		IOMEM(0xF0100000)
+#define MSM_TMR_PHYS		0x02000000
+#define MSM_TMR_SIZE		(SZ_1M)
+
+#define MSM_GPT_BASE		(MSM_TMR_BASE + 0x4)
+#define MSM_DGT_BASE		(MSM_TMR_BASE + 0x24)
+
+#define MSM_SHARED_RAM_BASE	IOMEM(0xF0200000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
 
 
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index dec5ca6..e76d869 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -1,6 +1,6 @@
-/* linux/arch/arm/mach-msm/timer.c
- *
+/*
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -21,6 +21,7 @@
 #include <linux/clockchips.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/percpu.h>
 
 #include <asm/mach/time.h>
 #include <mach/msm_iomap.h>
@@ -28,7 +29,20 @@
 #ifndef MSM_DGT_BASE
 #define MSM_DGT_BASE (MSM_GPT_BASE + 0x10)
 #endif
+
+#ifdef CONFIG_MSM7X00A_USE_GP_TIMER
+	#define DG_TIMER_RATING 100
+	#define MSM_GLOBAL_TIMER MSM_CLOCK_GPT
+#else
+	#define DG_TIMER_RATING 300
+	#define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
+#endif
+
+#if defined(CONFIG_ARCH_MSM_ARM11)
 #define MSM_DGT_SHIFT (5)
+#else
+#define MSM_DGT_SHIFT (0)
+#endif
 
 #define TIMER_MATCH_VAL         0x0000
 #define TIMER_COUNT_VAL         0x0004
@@ -40,8 +54,32 @@
 #define CSR_PROTECTION          0x0020
 #define CSR_PROTECTION_EN               1
 
+#define LOCAL_TIMER 0
+#define GLOBAL_TIMER 1
+
+#ifdef CONFIG_ARCH_MSM8X60
+#define MSM_TMR_BASE_CPU0      0x40000
+#else
+#define MSM_TMR_BASE_CPU0      0
+#endif
+
+#define NR_TIMERS ARRAY_SIZE(msm_clocks)
+
 #define GPT_HZ 32768
-#define DGT_HZ 19200000 /* 19.2 MHz or 600 KHz after shift */
+
+#if defined(CONFIG_ARCH_QSD8X50) || defined(CONFIG_ARCH_MSM8X60)
+#define DGT_HZ 4800000	/* Uses TCXO/4 (19.2 MHz / 4) */
+#else
+#define DGT_HZ 19200000	/* Uses TCXO (19.2 MHz) */
+#endif
+
+static irqreturn_t msm_timer_interrupt(int irq, void *dev_id);
+static cycle_t msm_gpt_read(struct clocksource *cs);
+static cycle_t msm_dgt_read(struct clocksource *cs);
+static void msm_timer_set_mode(enum clock_event_mode mode,
+			       struct clock_event_device *evt);
+static int msm_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt);
 
 struct msm_clock {
 	struct clock_event_device   clockevent;
@@ -52,60 +90,10 @@ struct msm_clock {
 	uint32_t                    shift;
 };
 
-static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = dev_id;
-	evt->event_handler(evt);
-	return IRQ_HANDLED;
-}
-
-static cycle_t msm_gpt_read(struct clocksource *cs)
-{
-	return readl(MSM_GPT_BASE + TIMER_COUNT_VAL);
-}
-
-static cycle_t msm_dgt_read(struct clocksource *cs)
-{
-	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
-}
-
-static int msm_timer_set_next_event(unsigned long cycles,
-				    struct clock_event_device *evt)
-{
-	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
-	uint32_t now = readl(clock->regbase + TIMER_COUNT_VAL);
-	uint32_t alarm = now + (cycles << clock->shift);
-	int late;
-
-	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
-	now = readl(clock->regbase + TIMER_COUNT_VAL);
-	late = now - alarm;
-	if (late >= (-2 << clock->shift) && late < DGT_HZ*5) {
-		printk(KERN_NOTICE "msm_timer_set_next_event(%lu) clock %s, "
-		       "alarm already expired, now %x, alarm %x, late %d\n",
-		       cycles, clock->clockevent.name, now, alarm, late);
-		return -ETIME;
-	}
-	return 0;
-}
-
-static void msm_timer_set_mode(enum clock_event_mode mode,
-			      struct clock_event_device *evt)
-{
-	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
-	switch (mode) {
-	case CLOCK_EVT_MODE_RESUME:
-	case CLOCK_EVT_MODE_PERIODIC:
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-		writel(TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		writel(0, clock->regbase + TIMER_ENABLE);
-		break;
-	}
-}
+enum {
+	MSM_CLOCK_GPT,
+	MSM_CLOCK_DGT,
+};
 
 static struct msm_clock msm_clocks[] = {
 	{
@@ -165,6 +153,89 @@ static struct msm_clock msm_clocks[] = {
 	}
 };
 
+static struct clock_event_device *local_clock_event;
+
+static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	if (smp_processor_id() != 0)
+		evt = local_clock_event;
+	if (evt->event_handler == NULL)
+		return IRQ_HANDLED;
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static cycle_t msm_gpt_read(struct clocksource *cs)
+{
+	struct msm_clock *clock =
+		container_of(cs, struct msm_clock, clocksource);
+	return readl(clock->regbase + TIMER_COUNT_VAL + MSM_TMR_BASE_CPU0);
+}
+
+static cycle_t msm_dgt_read(struct clocksource *cs)
+{
+	struct msm_clock *clock =
+		container_of(cs, struct msm_clock, clocksource);
+	return readl(clock->regbase + TIMER_COUNT_VAL + MSM_TMR_BASE_CPU0)
+		>> MSM_DGT_SHIFT;
+}
+
+static int msm_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt)
+{
+	struct msm_clock *clock;
+	uint32_t now;
+	uint32_t alarm;
+	int late;
+
+#ifdef CONFIG_SMP
+	clock = &msm_clocks[MSM_GLOBAL_TIMER];
+#else
+	clock = container_of(evt, struct msm_clock, clockevent);
+#endif
+	now = readl(clock->regbase + TIMER_COUNT_VAL);
+	alarm = now + (cycles << clock->shift);
+	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
+	late = now - alarm;
+	if (late >= (-2 << clock->shift) && late < DGT_HZ*5) {
+		printk(KERN_NOTICE "msm_timer_set_next_event(%lu) clock %s, "
+		       "alarm already expired, now %x, alarm %x, late %d\n",
+		       cycles, clock->clockevent.name, now, alarm, late);
+		return -ETIME;
+	}
+	return 0;
+}
+
+static void msm_timer_set_mode(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	struct msm_clock *clock;
+	unsigned long irq_flags;
+
+#ifdef CONFIG_SMP
+	clock = &msm_clocks[MSM_GLOBAL_TIMER];
+#else
+	clock = container_of(evt, struct msm_clock, clockevent);
+#endif
+	local_irq_save(irq_flags);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel(TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		writel(0, clock->regbase + TIMER_ENABLE);
+		break;
+	}
+
+	local_irq_restore(irq_flags);
+}
+
 static void __init msm_timer_init(void)
 {
 	int i;
@@ -201,6 +272,47 @@ static void __init msm_timer_init(void)
 	}
 }
 
+#ifdef CONFIG_SMP
+void local_timer_setup(struct clock_event_device *evt)
+{
+	unsigned long flags;
+	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
+
+	if (!local_clock_event) {
+		writel(0, clock->regbase  + TIMER_ENABLE);
+		writel(1, clock->regbase + TIMER_CLEAR);
+		writel(0, clock->regbase + TIMER_COUNT_VAL);
+		writel(~0, clock->regbase + TIMER_MATCH_VAL);
+	}
+	evt->irq = clock->irq.irq;
+	evt->name = "local_timer";
+	evt->features = CLOCK_EVT_FEAT_ONESHOT;
+	evt->rating = clock->clockevent.rating;
+	evt->set_mode = msm_timer_set_mode;
+	evt->set_next_event = msm_timer_set_next_event;
+	evt->shift = clock->clockevent.shift;
+	evt->mult = div_sc(clock->freq, NSEC_PER_SEC, evt->shift);
+	evt->max_delta_ns =
+		clockevent_delta2ns(0xf0000000 >> clock->shift, evt);
+	evt->min_delta_ns = clockevent_delta2ns(4, evt);
+	evt->cpumask = cpumask_of(smp_processor_id());
+
+	local_clock_event = evt;
+
+	local_irq_save(flags);
+	get_irq_chip(clock->irq.irq)->unmask(clock->irq.irq);
+	local_irq_restore(flags);
+
+	clockevents_register_device(evt);
+}
+
+int local_timer_ack(void)
+{
+	return 1;
+}
+
+#endif
+
 struct sys_timer msm_timer = {
 	.init = msm_timer_init
 };
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
