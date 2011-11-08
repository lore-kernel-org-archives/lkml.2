Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1KHSeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab1KHSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802410"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/8] msm: timer: Remove SoC specific #ifdefs
Date: Tue,  8 Nov 2011 10:34:08 -0800
Message-Id: <1320777250-23263-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer frequency is currently ifdefed in addition to setting
the DGT clock's divider value on SCORPIONMP targets. Setup the
frequency dynamically using the existing cpu_is_*() branches and
assign a custom clocksource read function for 7x01a to get the
shift out of the generic path.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index fc06464..ca0a957 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -40,20 +40,7 @@
 
 #define GPT_HZ 32768
 
-/* TODO: Remove these ifdefs */
-#if defined(CONFIG_ARCH_QSD8X50)
-#define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
-#define MSM_DGT_SHIFT (0)
-#elif defined(CONFIG_ARCH_MSM7X30)
-#define DGT_HZ (24576000 / 4) /* 24.576 MHz (LPXO) / 4 by default */
-#define MSM_DGT_SHIFT (0)
-#elif defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)
-#define DGT_HZ (27000000 / 4) /* 27 MHz (PXO) / 4 by default */
-#define MSM_DGT_SHIFT (0)
-#else
-#define DGT_HZ 19200000 /* 19.2 MHz or 600 KHz after shift */
-#define MSM_DGT_SHIFT (5)
-#endif
+#define MSM_DGT_SHIFT 5
 
 static void __iomem *event_base;
 
@@ -123,18 +110,23 @@ static void __iomem *source_base;
 
 static cycle_t msm_read_timer_count(struct clocksource *cs)
 {
+	return readl_relaxed(source_base + TIMER_COUNT_VAL);
+}
+
+static cycle_t msm_read_timer_count_shift(struct clocksource *cs)
+{
 	/*
 	 * Shift timer count down by a constant due to unreliable lower bits
 	 * on some targets.
 	 */
-	return readl_relaxed(source_base + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
+	return msm_read_timer_count(cs) >> MSM_DGT_SHIFT;
 }
 
 static struct clocksource msm_clocksource = {
 	.name	= "dg_timer",
 	.rating	= 300,
 	.read	= msm_read_timer_count,
-	.mask	= CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
+	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -143,27 +135,31 @@ static void __init msm_timer_init(void)
 	struct clock_event_device *ce = &msm_clockevent;
 	struct clocksource *cs = &msm_clocksource;
 	int res;
+	u32 dgt_hz;
 
 	if (cpu_is_msm7x01()) {
 		event_base = MSM_CSR_BASE;
 		source_base = MSM_CSR_BASE + 0x10;
+		dgt_hz = 19200000 >> MSM_DGT_SHIFT; /* 600 KHz */
+		cs->read = msm_read_timer_count_shift;
+		cs->mask = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT));
 	} else if (cpu_is_msm7x30()) {
 		event_base = MSM_CSR_BASE + 0x04;
 		source_base = MSM_CSR_BASE + 0x24;
+		dgt_hz = 24576000 / 4;
 	} else if (cpu_is_qsd8x50()) {
 		event_base = MSM_CSR_BASE;
 		source_base = MSM_CSR_BASE + 0x10;
+		dgt_hz = 19200000 / 4;
 	} else if (cpu_is_msm8x60() || cpu_is_msm8960()) {
 		event_base = MSM_TMR_BASE + 0x04;
 		/* Use CPU0's timer as the global clock source. */
 		source_base = MSM_TMR0_BASE + 0x24;
+		dgt_hz = 27000000 / 4;
+		writel_relaxed(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 	} else
 		BUG();
 
-#ifdef CONFIG_ARCH_MSM_SCORPIONMP
-	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
-#endif
-
 	writel_relaxed(0, event_base + TIMER_ENABLE);
 	writel_relaxed(0, event_base + TIMER_CLEAR);
 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
@@ -201,7 +197,7 @@ static void __init msm_timer_init(void)
 	clockevents_register_device(ce);
 err:
 	writel_relaxed(TIMER_ENABLE_EN, source_base + TIMER_ENABLE);
-	res = clocksource_register_hz(cs, DGT_HZ >> MSM_DGT_SHIFT);
+	res = clocksource_register_hz(cs, dgt_hz);
 	if (res)
 		pr_err("clocksource_register failed\n");
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

