Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1KHSgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:36:04 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1KHSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133442201"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/8] msm: timer: Remove msm_clocks[] and simplify code
Date: Tue,  8 Nov 2011 10:34:07 -0800
Message-Id: <1320777250-23263-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can simplify the timer code now that we only use the DGT for
the clocksource and the GPT for the clockevent. Get rid of the
msm_clocks[] array and propagate the changes throughout the code.
This reduces the lines of code in this file and improves
readability.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |  221 ++++++++++++++++-----------------------------
 1 files changed, 76 insertions(+), 145 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 9f3671a..fc06464 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -40,8 +40,6 @@
 
 #define GPT_HZ 32768
 
-#define MSM_GLOBAL_TIMER MSM_CLOCK_GPT
-
 /* TODO: Remove these ifdefs */
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
@@ -57,31 +55,7 @@
 #define MSM_DGT_SHIFT (5)
 #endif
 
-struct msm_clock {
-	struct clock_event_device   clockevent;
-	struct clocksource          clocksource;
-	unsigned int		    irq;
-	void __iomem                *regbase;
-	uint32_t                    freq;
-	uint32_t                    shift;
-	void __iomem                *global_counter;
-	void __iomem                *local_counter;
-	union {
-		struct clock_event_device		*evt;
-		struct clock_event_device __percpu	**percpu_evt;
-	};		
-};
-
-enum {
-	MSM_CLOCK_GPT,
-	MSM_CLOCK_DGT,
-	NR_TIMERS,
-};
-
-
-static struct msm_clock msm_clocks[];
-
-static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt);
+static void __iomem *event_base;
 
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
@@ -90,59 +64,31 @@ static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	/* Stop the timer tick */
 	if (evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-		struct msm_clock *clock = clockevent_to_clock(evt);
-		u32 ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
+		u32 ctrl = readl_relaxed(event_base + TIMER_ENABLE);
 		ctrl &= ~TIMER_ENABLE_EN;
-		writel_relaxed(ctrl, clock->regbase + TIMER_ENABLE);
+		writel_relaxed(ctrl, event_base + TIMER_ENABLE);
 	}
 	evt->event_handler(evt);
 	return IRQ_HANDLED;
 }
 
-static cycle_t msm_read_timer_count(struct clocksource *cs)
-{
-	struct msm_clock *clk = container_of(cs, struct msm_clock, clocksource);
-
-	/*
-	 * Shift timer count down by a constant due to unreliable lower bits
-	 * on some targets.
-	 */
-	return readl(clk->global_counter) >> clk->shift;
-}
-
-static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt)
-{
-#ifdef CONFIG_SMP
-	int i;
-	for (i = 0; i < NR_TIMERS; i++)
-		if (evt == &(msm_clocks[i].clockevent))
-			return &msm_clocks[i];
-	return &msm_clocks[MSM_GLOBAL_TIMER];
-#else
-	return container_of(evt, struct msm_clock, clockevent);
-#endif
-}
-
 static int msm_timer_set_next_event(unsigned long cycles,
 				    struct clock_event_device *evt)
 {
-	struct msm_clock *clock = clockevent_to_clock(evt);
-	u32 match = cycles << clock->shift;
-	u32 ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
+	u32 ctrl = readl_relaxed(event_base + TIMER_ENABLE);
 
-	writel_relaxed(0, clock->regbase + TIMER_CLEAR);
-	writel_relaxed(match, clock->regbase + TIMER_MATCH_VAL);
-	writel_relaxed(ctrl | TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
+	writel_relaxed(0, event_base + TIMER_CLEAR);
+	writel_relaxed(cycles, event_base + TIMER_MATCH_VAL);
+	writel_relaxed(ctrl | TIMER_ENABLE_EN, event_base + TIMER_ENABLE);
 	return 0;
 }
 
 static void msm_timer_set_mode(enum clock_event_mode mode,
 			      struct clock_event_device *evt)
 {
-	struct msm_clock *clock = clockevent_to_clock(evt);
 	u32 ctrl;
 
-	ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
+	ctrl = readl_relaxed(event_base + TIMER_ENABLE);
 	ctrl &= ~(TIMER_ENABLE_EN | TIMER_ENABLE_CLR_ON_MATCH_EN);
 
 	switch (mode) {
@@ -156,59 +102,61 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		break;
 	}
-	writel_relaxed(ctrl, clock->regbase + TIMER_ENABLE);
+	writel_relaxed(ctrl, event_base + TIMER_ENABLE);
 }
 
-static struct msm_clock msm_clocks[] = {
-	[MSM_CLOCK_GPT] = {
-		.clockevent = {
-			.name           = "gp_timer",
-			.features       = CLOCK_EVT_FEAT_ONESHOT,
-			.shift          = 32,
-			.rating         = 200,
-			.set_next_event = msm_timer_set_next_event,
-			.set_mode       = msm_timer_set_mode,
-		},
-		.irq = INT_GP_TIMER_EXP,
-		.freq = GPT_HZ,
-	},
-	[MSM_CLOCK_DGT] = {
-		.clocksource = {
-			.name           = "dg_timer",
-			.rating         = 300,
-			.read           = msm_read_timer_count,
-			.mask           = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
-			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-		},
-		.freq = DGT_HZ >> MSM_DGT_SHIFT,
-		.shift = MSM_DGT_SHIFT,
-	}
+static struct clock_event_device msm_clockevent = {
+	.name		= "gp_timer",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.rating		= 200,
+	.set_next_event	= msm_timer_set_next_event,
+	.set_mode	= msm_timer_set_mode,
+};
+
+static union {
+	struct clock_event_device *evt;
+	struct clock_event_device __percpu **percpu_evt;
+} msm_evt;
+
+static void __iomem *source_base;
+
+static cycle_t msm_read_timer_count(struct clocksource *cs)
+{
+	/*
+	 * Shift timer count down by a constant due to unreliable lower bits
+	 * on some targets.
+	 */
+	return readl_relaxed(source_base + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
+}
+
+static struct clocksource msm_clocksource = {
+	.name	= "dg_timer",
+	.rating	= 300,
+	.read	= msm_read_timer_count,
+	.mask	= CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init msm_timer_init(void)
 {
-	struct msm_clock *clock;
-	struct clock_event_device *ce = &msm_clocks[MSM_CLOCK_GPT].clockevent;
-	struct clocksource *cs = &msm_clocks[MSM_CLOCK_DGT].clocksource;
+	struct clock_event_device *ce = &msm_clockevent;
+	struct clocksource *cs = &msm_clocksource;
 	int res;
-	int global_offset = 0;
-
 
 	if (cpu_is_msm7x01()) {
-		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
-		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
+		event_base = MSM_CSR_BASE;
+		source_base = MSM_CSR_BASE + 0x10;
 	} else if (cpu_is_msm7x30()) {
-		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
-		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
+		event_base = MSM_CSR_BASE + 0x04;
+		source_base = MSM_CSR_BASE + 0x24;
 	} else if (cpu_is_qsd8x50()) {
-		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
-		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
+		event_base = MSM_CSR_BASE;
+		source_base = MSM_CSR_BASE + 0x10;
 	} else if (cpu_is_msm8x60() || cpu_is_msm8960()) {
-		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
-		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
-
-		/* Use CPU0's timer as the global timer. */
-		global_offset = MSM_TMR0_BASE - MSM_TMR_BASE;
+		event_base = MSM_TMR_BASE + 0x04;
+		/* Use CPU0's timer as the global clock source. */
+		source_base = MSM_TMR0_BASE + 0x24;
 	} else
 		BUG();
 
@@ -216,88 +164,71 @@ static void __init msm_timer_init(void)
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 #endif
 
-	clock = &msm_clocks[MSM_CLOCK_GPT];
-	clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
-
-	writel_relaxed(0, clock->regbase + TIMER_ENABLE);
-	writel_relaxed(0, clock->regbase + TIMER_CLEAR);
-	writel_relaxed(~0, clock->regbase + TIMER_MATCH_VAL);
-	ce->mult = div_sc(clock->freq, NSEC_PER_SEC, ce->shift);
+	writel_relaxed(0, event_base + TIMER_ENABLE);
+	writel_relaxed(0, event_base + TIMER_CLEAR);
+	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
+	ce->mult = div_sc(GPT_HZ, NSEC_PER_SEC, ce->shift);
 	/*
 	 * allow at least 10 seconds to notice that the timer
 	 * wrapped
 	 */
-	ce->max_delta_ns =
-		clockevent_delta2ns(0xf0000000 >> clock->shift, ce);
+	ce->max_delta_ns = clockevent_delta2ns(0xf0000000, ce);
 	/* 4 gets rounded down to 3 */
 	ce->min_delta_ns = clockevent_delta2ns(4, ce);
 	ce->cpumask = cpumask_of(0);
 
-	ce->irq = clock->irq;
+	ce->irq = INT_GP_TIMER_EXP;
 	if (cpu_is_msm8x60() || cpu_is_msm8960()) {
-		clock->percpu_evt = alloc_percpu(struct clock_event_device *);
-		if (!clock->percpu_evt) {
+		msm_evt.percpu_evt = alloc_percpu(struct clock_event_device *);
+		if (!msm_evt.percpu_evt) {
 			pr_err("memory allocation failed for %s\n", ce->name);
 			goto err;
 		}
-
-		*__this_cpu_ptr(clock->percpu_evt) = ce;
+		*__this_cpu_ptr(msm_evt.percpu_evt) = ce;
 		res = request_percpu_irq(ce->irq, msm_timer_interrupt,
-					 ce->name, clock->percpu_evt);
+					 ce->name, msm_evt.percpu_evt);
 		if (!res)
 			enable_percpu_irq(ce->irq, 0);
 	} else {
-		clock->evt = ce;
+		msm_evt.evt = ce;
 		res = request_irq(ce->irq, msm_timer_interrupt,
 				  IRQF_TIMER | IRQF_NOBALANCING |
-				  IRQF_TRIGGER_RISING, ce->name, &clock->evt);
+				  IRQF_TRIGGER_RISING, ce->name, &msm_evt.evt);
 	}
 
 	if (res)
 		pr_err("request_irq failed for %s\n", ce->name);
-
 	clockevents_register_device(ce);
 err:
-	clock = &msm_clocks[MSM_CLOCK_DGT];
-	clock->local_counter = clock->regbase + TIMER_COUNT_VAL;
-	clock->global_counter = clock->local_counter + global_offset;
-	writel_relaxed(TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
-	res = clocksource_register_hz(cs, clock->freq);
+	writel_relaxed(TIMER_ENABLE_EN, source_base + TIMER_ENABLE);
+	res = clocksource_register_hz(cs, DGT_HZ >> MSM_DGT_SHIFT);
 	if (res)
-		pr_err("clocksource_register failed for %s\n", cs->name);
+		pr_err("clocksource_register failed\n");
 }
 
 #ifdef CONFIG_LOCAL_TIMERS
 int __cpuinit local_timer_setup(struct clock_event_device *evt)
 {
-	static bool local_timer_inited;
-	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
-
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
 		return 0;
 
-	if (!local_timer_inited) {
-		writel(0, clock->regbase  + TIMER_ENABLE);
-		writel(0, clock->regbase + TIMER_CLEAR);
-		writel(~0, clock->regbase + TIMER_MATCH_VAL);
-		local_timer_inited = true;
-	}
-	evt->irq = clock->irq;
+	writel_relaxed(0, event_base + TIMER_ENABLE);
+	writel_relaxed(0, event_base + TIMER_CLEAR);
+	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
+	evt->irq = msm_clockevent.irq;
 	evt->name = "local_timer";
-	evt->features = CLOCK_EVT_FEAT_ONESHOT;
-	evt->rating = clock->clockevent.rating;
+	evt->features = msm_clockevent.features;
+	evt->rating = msm_clockevent.rating;
 	evt->set_mode = msm_timer_set_mode;
 	evt->set_next_event = msm_timer_set_next_event;
-	evt->shift = clock->clockevent.shift;
-	evt->mult = div_sc(clock->freq, NSEC_PER_SEC, evt->shift);
-	evt->max_delta_ns =
-		clockevent_delta2ns(0xf0000000 >> clock->shift, evt);
+	evt->shift = msm_clockevent.shift;
+	evt->mult = div_sc(GPT_HZ, NSEC_PER_SEC, evt->shift);
+	evt->max_delta_ns = clockevent_delta2ns(0xf0000000, evt);
 	evt->min_delta_ns = clockevent_delta2ns(4, evt);
 
-	*__this_cpu_ptr(clock->percpu_evt) = evt;
+	*__this_cpu_ptr(msm_evt.percpu_evt) = evt;
 	enable_percpu_irq(evt->irq, 0);
-
 	clockevents_register_device(evt);
 	return 0;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

