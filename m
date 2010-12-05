Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0LEXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:09:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0LEXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:09:57 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] ARM: tegra: timer: Add idle and suspend support to timers
Date: Sun,  5 Dec 2010 15:08:57 -0800
Message-Id: <1291590548-7341-11-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
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
 arch/arm/mach-tegra/timer.c |  113 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index ef2fc29..b46650b 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -28,6 +28,7 @@
 #include <linux/cnt32_to_63.h>
 
 #include <asm/mach/time.h>
+#include <asm/mach/time.h>
 #include <asm/localtimer.h>
 
 #include <mach/iomap.h>
@@ -37,6 +38,10 @@
 #include "board.h"
 #include "clock.h"
 
+#define RTC_SECONDS		0x08
+#define RTC_SHADOW_SECONDS	0x0c
+#define RTC_MILLISECONDS	0x10
+
 #define TIMERUS_CNTR_1US 0x10
 #define TIMERUS_USEC_CFG 0x14
 #define TIMERUS_CNTR_FREEZE 0x4c
@@ -49,15 +54,17 @@
 #define TIMER_PTV 0x0
 #define TIMER_PCR 0x4
 
-struct tegra_timer;
-
 static void __iomem *timer_reg_base = IO_ADDRESS(TEGRA_TMR1_BASE);
+static void __iomem *rtc_base = IO_ADDRESS(TEGRA_RTC_BASE);
 
 #define timer_writel(value, reg) \
 	__raw_writel(value, (u32)timer_reg_base + (reg))
 #define timer_readl(reg) \
 	__raw_readl((u32)timer_reg_base + (reg))
 
+static u64 tegra_sched_clock_offset;
+static u64 tegra_sched_clock_resume_offset;
+
 static int tegra_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
@@ -111,9 +118,61 @@ static struct clocksource tegra_clocksource = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
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
+	return (u64)s * 1000 + ms;
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
+static struct timespec persistent_ts;
+static u64 persistent_ms, last_persistent_ms;
+void read_persistent_clock(struct timespec *ts)
+{
+	u64 delta;
+	struct timespec *tsp = &persistent_ts;
+
+	last_persistent_ms = persistent_ms;
+	persistent_ms = tegra_rtc_read_ms();
+	delta = persistent_ms - last_persistent_ms;
+
+	timespec_add_ns(tsp, delta * 1000000);
+	*ts = *tsp;
+}
+
 unsigned long long sched_clock(void)
 {
-	return cnt32_to_63(timer_readl(TIMERUS_CNTR_1US)) * 1000;
+	return tegra_sched_clock_offset +
+		cnt32_to_63(timer_readl(TIMERUS_CNTR_1US)) * 1000;
+}
+
+static void tegra_sched_clock_suspend(void)
+{
+	tegra_sched_clock_resume_offset = sched_clock() -
+		tegra_rtc_read_ms() * 1000000;
+}
+
+static void tegra_sched_clock_resume(void)
+{
+	tegra_sched_clock_offset += tegra_sched_clock_resume_offset +
+		tegra_rtc_read_ms() * 1000000 -
+		sched_clock();
 }
 
 static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
@@ -132,6 +191,20 @@ static struct irqaction tegra_timer_irq = {
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
@@ -169,6 +242,12 @@ static void __init tegra_init_timer(void)
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
@@ -184,3 +263,31 @@ static void __init tegra_init_timer(void)
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
+static u32 usec_config;
+void tegra_timer_suspend(void)
+{
+	tegra_sched_clock_suspend();
+	usec_config = timer_readl(TIMERUS_USEC_CFG);
+}
+
+void tegra_timer_resume(void)
+{
+	timer_writel(usec_config, TIMERUS_USEC_CFG);
+	tegra_sched_clock_resume();
+}
-- 
1.7.3.1

