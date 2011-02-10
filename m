Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1BJGn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:43:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1BJGn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:43:58 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/15] ARM: tegra: timer: Add idle and suspend support to timers
Date: Wed,  9 Feb 2011 22:43:16 -0800
Message-Id: <1297320204-31882-8-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement read_persistent_clock by reading the Tegra RTC
registers that stay running during suspend.

Save and restore the timer configuration register in
suspend.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/timer.c |   60 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index 36b53a7..ffa6a68 100644
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
@@ -204,3 +246,17 @@ static void __init tegra_init_timer(void)
 struct sys_timer tegra_timer = {
 	.init = tegra_init_timer,
 };
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

