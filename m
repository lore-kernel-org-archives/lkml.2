Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0LFHQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:16:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0LFHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:16:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6188"; a="65617301"
X-IronPort-AV: E=Sophos;i="4.59,303,1288594800"; 
   d="scan'208";a="15879353"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: [PATCH 3/5] msm: timer: SMP timer support for msm
Date: Sun,  5 Dec 2010 23:16:16 -0800
Message-Id: <1291619778-30289-4-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 +-
 arch/arm/mach-msm/io.c                          |    1 +
 arch/arm/mach-msm/timer.c                       |  139 +++++++++++++++++++++--
 3 files changed, 136 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 45bab50..873e0b7 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -60,7 +60,11 @@
 
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR_PHYS		0x02000000
-#define MSM_TMR_SIZE		(SZ_1M)
+#define MSM_TMR_SIZE		SZ_4K
+
+#define MSM_TMR0_BASE		IOMEM(0xF0201000)
+#define MSM_TMR0_PHYS		0x02040000
+#define MSM_TMR0_SIZE		SZ_4K
 
 #define MSM_GPT_BASE		(MSM_TMR_BASE + 0x4)
 #define MSM_DGT_BASE		(MSM_TMR_BASE + 0x24)
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index d36b610..b826b6b 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -105,6 +105,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_DEVICE(QGIC_DIST),
 	MSM_DEVICE(QGIC_CPU),
 	MSM_DEVICE(TMR),
+	MSM_DEVICE(TMR0),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
 };
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 950100f..40f6d17 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -47,6 +47,19 @@ enum {
 
 #define GPT_HZ 32768
 
+enum timer_location {
+	LOCAL_TIMER = 0,
+	GLOBAL_TIMER = 1,
+};
+
+#ifdef MSM_TMR0_BASE
+#define MSM_TMR_GLOBAL		(MSM_TMR0_BASE - MSM_TMR_BASE)
+#else
+#define MSM_TMR_GLOBAL		0
+#endif
+
+#define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
+
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
 #define MSM_DGT_SHIFT (0)
@@ -67,38 +80,89 @@ struct msm_clock {
 	uint32_t                    shift;
 };
 
+enum {
+	MSM_CLOCK_GPT,
+	MSM_CLOCK_DGT,
+	NR_TIMERS,
+};
+
+
+static struct msm_clock msm_clocks[];
+static struct clock_event_device *local_clock_event;
+
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = dev_id;
+	if (smp_processor_id() != 0)
+		evt = local_clock_event;
+	if (evt->event_handler == NULL)
+		return IRQ_HANDLED;
 	evt->event_handler(evt);
 	return IRQ_HANDLED;
 }
 
+static uint32_t msm_read_timer_count(struct msm_clock *clock,
+				     enum timer_location global)
+{
+	uint32_t t1;
+
+	if (global)
+		t1 = readl(clock->regbase + TIMER_COUNT_VAL + MSM_TMR_GLOBAL);
+	else
+		t1 = readl(clock->regbase + TIMER_COUNT_VAL);
+
+	return t1;
+}
+
 static cycle_t msm_gpt_read(struct clocksource *cs)
 {
-	return readl(MSM_GPT_BASE + TIMER_COUNT_VAL);
+	struct msm_clock *clock = &msm_clocks[MSM_CLOCK_GPT];
+
+	return msm_read_timer_count(clock, GLOBAL_TIMER);
 }
 
 static cycle_t msm_dgt_read(struct clocksource *cs)
 {
-	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
+	struct msm_clock *clock = &msm_clocks[MSM_CLOCK_DGT];
+
+	return msm_read_timer_count(clock, GLOBAL_TIMER) >> MSM_DGT_SHIFT;
+}
+
+static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt)
+{
+#ifdef CONFIG_SMP
+	int i;
+	for (i = 0; i < NR_TIMERS; i++)
+		if (evt == &(msm_clocks[i].clockevent))
+			return &msm_clocks[i];
+	return &msm_clocks[MSM_GLOBAL_TIMER];
+#else
+	return container_of(evt, struct msm_clock, clockevent);
+#endif
 }
 
 static int msm_timer_set_next_event(unsigned long cycles,
 				    struct clock_event_device *evt)
 {
-	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
-	uint32_t now = readl(clock->regbase + TIMER_COUNT_VAL);
+	struct msm_clock *clock = clockevent_to_clock(evt);
+	uint32_t now = msm_read_timer_count(clock, LOCAL_TIMER);
 	uint32_t alarm = now + (cycles << clock->shift);
 	int late;
 
 	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
-	now = readl(clock->regbase + TIMER_COUNT_VAL);
+
+	now = msm_read_timer_count(clock, LOCAL_TIMER);
 	late = now - alarm;
 	if (late >= (-2 << clock->shift) && late < DGT_HZ*5) {
-		printk(KERN_NOTICE "msm_timer_set_next_event(%lu) clock %s, "
-		       "alarm already expired, now %x, alarm %x, late %d\n",
-		       cycles, clock->clockevent.name, now, alarm, late);
+		static int print_limit = 10;
+		if (print_limit > 0) {
+			print_limit--;
+			printk(KERN_NOTICE "msm_timer_set_next_event(%lu) "
+			       "clock %s, alarm already expired, now %x, "
+			       "alarm %x, late %d%s\n",
+			       cycles, clock->clockevent.name, now, alarm, late,
+			       print_limit ? "" : " stop printing");
+		}
 		return -ETIME;
 	}
 	return 0;
@@ -107,7 +171,11 @@ static int msm_timer_set_next_event(unsigned long cycles,
 static void msm_timer_set_mode(enum clock_event_mode mode,
 			      struct clock_event_device *evt)
 {
-	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
+	struct msm_clock *clock = clockevent_to_clock(evt);
+	unsigned long irq_flags;
+
+	local_irq_save(irq_flags);
+
 	switch (mode) {
 	case CLOCK_EVT_MODE_RESUME:
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -120,6 +188,7 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 		writel(0, clock->regbase + TIMER_ENABLE);
 		break;
 	}
+	local_irq_restore(irq_flags);
 }
 
 static struct msm_clock msm_clocks[] = {
@@ -220,6 +289,58 @@ static void __init msm_timer_init(void)
 	}
 }
 
+#ifdef CONFIG_SMP
+void local_timer_setup(struct clock_event_device *evt)
+{
+	unsigned long flags;
+	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
+
+#ifdef CONFIG_ARCH_MSM8X60
+	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
+#endif
+
+	if (!local_clock_event) {
+		writel(0, clock->regbase  + TIMER_ENABLE);
+		writel(0, clock->regbase + TIMER_CLEAR);
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
+#ifdef CONFIG_HOTPLUG_CPU
+void __cpuexit local_timer_stop(void)
+{
+	local_clock_event->set_mode(CLOCK_EVT_MODE_SHUTDOWN, local_clock_event);
+	get_irq_chip(local_clock_event->irq)->mask(local_clock_event->irq);
+	local_clock_event = NULL;
+}
+#endif
+#endif
+
 struct sys_timer msm_timer = {
 	.init = msm_timer_init
 };
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

