Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1AXCCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42924 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1AXCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:01:58 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/28] ARM: tegra: timer: Add idle and suspend support to timers
Date: Sun, 23 Jan 2011 18:01:16 -0800
Message-Id: <1295834493-5019-12-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra processor cannot be woken from idle by the internal
ARM timers.  Reserve timer 4 to be used as a wake source
during idle.

Implement read_persistent_clock by reading the Tegra RTC
registers that stay running during suspend.

Save and restore the timer configuration register and the
sched_clock value in LP0.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/timer.c |   95 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index 36b53a7..2d0b76f 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -38,6 +38,10 @@
 #include "board.h"
 #include "clock.h"
 
+#define RTC_SECONDS            0x08
+#define RTC_SHADOW_SECONDS     0x0c
+#define RTC_MILLISECONDS       0x10
+
 #define TIMERUS_CNTR_1US 0x10
 #define TIMERUS_USEC_CFG 0x14
 #define TIMERUS_CNTR_FREEZE 0x4c
@@ -50,9 +54,11 @@
 #define TIMER_PTV 0x0
 #define TIMER_PCR 0x4
 
-struct tegra_timer;
-
 static void __iomem *timer_reg_base = IO_ADDRESS(TEGRA_TMR1_BASE);
+static void __iomem *rtc_base = IO_ADDRESS(TEGRA_RTC_BASE);
+
+static struct timespec persistent_ts;
+static u64 persistent_ms, last_persistent_ms;
 
 #define timer_writel(value, reg) \
 	__raw_writel(value, (u32)timer_reg_base + (reg))
@@ -133,6 +139,42 @@ static void notrace tegra_update_sched_clock(void)
 	update_sched_clock(&cd, cyc, (u32)~0);
 }
 
+/*
+ * tegra_rtc_read - Reads the Tegra RTC registers
+ * Care must be taken that this funciton is not called while the
+ * tegra_rtc driver could be executing to avoid race conditions
+ * on the RTC shadow register
+ */
+u64 tegra_rtc_read_ms(void)
+{
+	u32 ms = readl(rtc_base + RTC_MILLISECONDS);
+	u32 s = readl(rtc_base + RTC_SHADOW_SECONDS);
+	return (u64)s * MSEC_PER_SEC + ms;
+}
+
+/*
+ * read_persistent_clock -  Return time from a persistent clock.
+ *
+ * Reads the time from a source which isn't disabled during PM, the
+ * 32k sync timer.  Convert the cycles elapsed since last read into
+ * nsecs and adds to a monotonically increasing timespec.
+ * Care must be taken that this funciton is not called while the
+ * tegra_rtc driver could be executing to avoid race conditions
+ * on the RTC shadow register
+ */
+void read_persistent_clock(struct timespec *ts)
+{
+	u64 delta;
+	struct timespec *tsp = &persistent_ts;
+
+	last_persistent_ms = persistent_ms;
+	persistent_ms = tegra_rtc_read_ms();
+	delta = persistent_ms - last_persistent_ms;
+
+	timespec_add_ns(tsp, delta * NSEC_PER_MSEC);
+	*ts = *tsp;
+}
+
 static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
@@ -149,6 +191,20 @@ static struct irqaction tegra_timer_irq = {
 	.irq		= INT_TMR3,
 };
 
+static irqreturn_t tegra_lp2wake_interrupt(int irq, void *dev_id)
+{
+	timer_writel(1<<30, TIMER4_BASE + TIMER_PCR);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction tegra_lp2wake_irq = {
+	.name		= "timer_lp2wake",
+	.flags		= IRQF_DISABLED,
+	.handler	= tegra_lp2wake_interrupt,
+	.dev_id		= NULL,
+	.irq		= INT_TMR4,
+};
+
 static void __init tegra_init_timer(void)
 {
 	unsigned long rate = clk_measure_input_freq();
@@ -189,6 +245,12 @@ static void __init tegra_init_timer(void)
 		BUG();
 	}
 
+	ret = setup_irq(tegra_lp2wake_irq.irq, &tegra_lp2wake_irq);
+	if (ret) {
+		printk(KERN_ERR "Failed to register LP2 timer IRQ: %d\n", ret);
+		BUG();
+	}
+
 	clockevents_calc_mult_shift(&tegra_clockevent, 1000000, 5);
 	tegra_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x1fffffff, &tegra_clockevent);
@@ -204,3 +266,32 @@ static void __init tegra_init_timer(void)
 struct sys_timer tegra_timer = {
 	.init = tegra_init_timer,
 };
+
+void tegra_lp2_set_trigger(unsigned long cycles)
+{
+	timer_writel(0, TIMER4_BASE + TIMER_PTV);
+	if (cycles) {
+		u32 reg = 0x80000000ul | min(0x1ffffffful, cycles);
+		timer_writel(reg, TIMER4_BASE + TIMER_PTV);
+	}
+}
+EXPORT_SYMBOL(tegra_lp2_set_trigger);
+
+unsigned long tegra_lp2_timer_remain(void)
+{
+	return timer_readl(TIMER4_BASE + TIMER_PCR) & 0x1ffffffful;
+}
+
+#ifdef CONFIG_PM
+static u32 usec_config;
+
+void tegra_timer_suspend(void)
+{
+	usec_config = timer_readl(TIMERUS_USEC_CFG);
+}
+
+void tegra_timer_resume(void)
+{
+	timer_writel(usec_config, TIMERUS_USEC_CFG);
+}
+#endif
-- 
1.7.3.1

