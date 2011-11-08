Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab1KHSeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1KHSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133442200"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/8] msm: timer: Use GPT for clockevents and DGT for clocksource
Date: Tue,  8 Nov 2011 10:34:05 -0800
Message-Id: <1320777250-23263-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource shouldn't stop ticking when the clockevent stops.
This is exactly what happens today with MSM timers. The same
hardware is used for both the clockevent and the clocksource
because the ratings of the two are the same.

Fix this by registering a clockevent based on the GPT and a
clocksource based on the DGT. This removes any other possible
configuration (e.g. a GPT clocksource and a DGT clockevent) but
that shouldn't be a big issue since we want higher precision
timing than high precision scheduling interrupts.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |  121 +++++++++++++++++++-------------------------
 1 files changed, 52 insertions(+), 69 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index ce389ca..405e8a9 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -1,6 +1,7 @@
-/* linux/arch/arm/mach-msm/timer.c
+/*
  *
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -39,7 +40,7 @@
 
 #define GPT_HZ 32768
 
-#define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
+#define MSM_GLOBAL_TIMER MSM_CLOCK_GPT
 
 /* TODO: Remove these ifdefs */
 #if defined(CONFIG_ARCH_QSD8X50)
@@ -153,25 +154,10 @@ static struct msm_clock msm_clocks[] = {
 			.set_next_event = msm_timer_set_next_event,
 			.set_mode       = msm_timer_set_mode,
 		},
-		.clocksource = {
-			.name           = "gp_timer",
-			.rating         = 200,
-			.read           = msm_read_timer_count,
-			.mask           = CLOCKSOURCE_MASK(32),
-			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-		},
 		.irq = INT_GP_TIMER_EXP,
 		.freq = GPT_HZ,
 	},
 	[MSM_CLOCK_DGT] = {
-		.clockevent = {
-			.name           = "dg_timer",
-			.features       = CLOCK_EVT_FEAT_ONESHOT,
-			.shift          = 32 + MSM_DGT_SHIFT,
-			.rating         = 300,
-			.set_next_event = msm_timer_set_next_event,
-			.set_mode       = msm_timer_set_mode,
-		},
 		.clocksource = {
 			.name           = "dg_timer",
 			.rating         = 300,
@@ -179,7 +165,6 @@ static struct msm_clock msm_clocks[] = {
 			.mask           = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
 			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 		},
-		.irq = INT_DEBUG_TIMER_EXP,
 		.freq = DGT_HZ >> MSM_DGT_SHIFT,
 		.shift = MSM_DGT_SHIFT,
 	}
@@ -187,10 +172,13 @@ static struct msm_clock msm_clocks[] = {
 
 static void __init msm_timer_init(void)
 {
-	int i;
+	struct msm_clock *clock;
+	struct clock_event_device *ce = &msm_clocks[MSM_CLOCK_GPT].clockevent;
+	struct clocksource *cs = &msm_clocks[MSM_CLOCK_DGT].clocksource;
 	int res;
 	int global_offset = 0;
 
+
 	if (cpu_is_msm7x01()) {
 		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
 		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
@@ -213,58 +201,55 @@ static void __init msm_timer_init(void)
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(msm_clocks); i++) {
-		struct msm_clock *clock = &msm_clocks[i];
-		struct clock_event_device *ce = &clock->clockevent;
-		struct clocksource *cs = &clock->clocksource;
-
-		clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
-		clock->global_counter = clock->local_counter + global_offset;
-
-		writel(0, clock->regbase + TIMER_ENABLE);
-		writel(0, clock->regbase + TIMER_CLEAR);
-		writel(~0, clock->regbase + TIMER_MATCH_VAL);
+	clock = &msm_clocks[MSM_CLOCK_GPT];
+	clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
 
-		ce->mult = div_sc(clock->freq, NSEC_PER_SEC, ce->shift);
-		/* allow at least 10 seconds to notice that the timer wrapped */
-		ce->max_delta_ns =
-			clockevent_delta2ns(0xf0000000 >> clock->shift, ce);
-		/* 4 gets rounded down to 3 */
-		ce->min_delta_ns = clockevent_delta2ns(4, ce);
-		ce->cpumask = cpumask_of(0);
-
-		res = clocksource_register_hz(cs, clock->freq);
-		if (res)
-			printk(KERN_ERR "msm_timer_init: clocksource_register "
-			       "failed for %s\n", cs->name);
-
-		ce->irq = clock->irq;
-		if (cpu_is_msm8x60() || cpu_is_msm8960()) {
-			clock->percpu_evt = alloc_percpu(struct clock_event_device *);
-			if (!clock->percpu_evt) {
-				pr_err("msm_timer_init: memory allocation "
-				       "failed for %s\n", ce->name);
-				continue;
-			}
-
-			*__this_cpu_ptr(clock->percpu_evt) = ce;
-			res = request_percpu_irq(ce->irq, msm_timer_interrupt,
-						 ce->name, clock->percpu_evt);
-			if (!res)
-				enable_percpu_irq(ce->irq, 0);
-		} else {
-			clock->evt = ce;
-			res = request_irq(ce->irq, msm_timer_interrupt,
-					  IRQF_TIMER | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
-					  ce->name, &clock->evt);
+	writel_relaxed(0, clock->regbase + TIMER_ENABLE);
+	writel_relaxed(0, clock->regbase + TIMER_CLEAR);
+	writel_relaxed(~0, clock->regbase + TIMER_MATCH_VAL);
+	ce->mult = div_sc(clock->freq, NSEC_PER_SEC, ce->shift);
+	/*
+	 * allow at least 10 seconds to notice that the timer
+	 * wrapped
+	 */
+	ce->max_delta_ns =
+		clockevent_delta2ns(0xf0000000 >> clock->shift, ce);
+	/* 4 gets rounded down to 3 */
+	ce->min_delta_ns = clockevent_delta2ns(4, ce);
+	ce->cpumask = cpumask_of(0);
+
+	ce->irq = clock->irq;
+	if (cpu_is_msm8x60() || cpu_is_msm8960()) {
+		clock->percpu_evt = alloc_percpu(struct clock_event_device *);
+		if (!clock->percpu_evt) {
+			pr_err("memory allocation failed for %s\n", ce->name);
+			goto err;
 		}
 
-		if (res)
-			pr_err("msm_timer_init: request_irq failed for %s\n",
-			       ce->name);
-
-		clockevents_register_device(ce);
+		*__this_cpu_ptr(clock->percpu_evt) = ce;
+		res = request_percpu_irq(ce->irq, msm_timer_interrupt,
+					 ce->name, clock->percpu_evt);
+		if (!res)
+			enable_percpu_irq(ce->irq, 0);
+	} else {
+		clock->evt = ce;
+		res = request_irq(ce->irq, msm_timer_interrupt,
+				  IRQF_TIMER | IRQF_NOBALANCING |
+				  IRQF_TRIGGER_RISING, ce->name, &clock->evt);
 	}
+
+	if (res)
+		pr_err("request_irq failed for %s\n", ce->name);
+
+	clockevents_register_device(ce);
+err:
+	clock = &msm_clocks[MSM_CLOCK_DGT];
+	clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
+	clock->global_counter = clock->local_counter + global_offset;
+	writel_relaxed(TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
+	res = clocksource_register_hz(cs, clock->freq);
+	if (res)
+		pr_err("clocksource_register failed for %s\n", cs->name);
 }
 
 #ifdef CONFIG_LOCAL_TIMERS
@@ -277,8 +262,6 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 	if (!smp_processor_id())
 		return 0;
 
-	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
-
 	if (!local_timer_inited) {
 		writel(0, clock->regbase  + TIMER_ENABLE);
 		writel(0, clock->regbase + TIMER_CLEAR);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

