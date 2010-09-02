Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0IBDFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:05:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:55501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0IBDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:05:08 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
Date: Wed,  1 Sep 2010 20:04:34 -0700
Message-Id: <1283396674-4865-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock to the ARM TWD local timer scales with the cpu
frequency.  To allow the cpu frequency to change while
maintaining a constant TWD frequency, pick a lower target
frequency for the TWD and use the prescaler to divide down
to the closest lower frequency.

This patch provides a new initialization function that takes
a target TWD frequency and the relation between the cpu
clock and the TWD clock, required to be an integer divider
>= 2 by the ARM spec.  It also provides a function to be
called from cpufreq drivers to set the prescaler whenever
the cpu frequency changes.

Also fixes a typo in the printk of the calibrated frequency.

Change-Id: I45c76ae1ed501c40b94709c15834c8a0b6116c84
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/smp_twd.h |   19 +++++++++++++
 arch/arm/kernel/smp_twd.c      |   57 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index 634f357..79aebe2 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -17,6 +17,7 @@
 #define TWD_TIMER_CONTROL_ONESHOT	(0 << 1)
 #define TWD_TIMER_CONTROL_PERIODIC	(1 << 1)
 #define TWD_TIMER_CONTROL_IT_ENABLE	(1 << 2)
+#define TWD_TIMER_CONTROL_PRESCALE_MASK	(0xFF << 8)
 
 struct clock_event_device;
 
@@ -26,4 +27,22 @@ void twd_timer_stop(void);
 int twd_timer_ack(void);
 void twd_timer_setup(struct clock_event_device *);
 
+/*
+ * Use this setup function on systems where the cpu clock frequency may
+ * change.  periphclk_prescaler is the fixed divider value between the cpu
+ * clock and the PERIPHCLK clock that feeds the TWD.  target_rate should be
+ * low enough that the prescaler can accurately reach the target rate from the
+ * lowest cpu frequency.
+ */
+void twd_timer_setup_scalable(struct clock_event_device *,
+	unsigned long target_rate, unsigned int periphclk_prescaler);
+
+/*
+ * Recalculate the twd prescaler value when the cpu frequency changes. To
+ * prevent early timer interrupts, must be called before changing the cpu
+ * frequency if the frequency is increasing, or after if the frequency is
+ * decreasing.
+ */
+void twd_recalc_prescaler(unsigned long new_rate);
+
 #endif
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 35882fb..2b4f927 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -25,6 +25,8 @@
 void __iomem *twd_base;
 
 static unsigned long twd_timer_rate;
+static unsigned long twd_periphclk_prescaler;
+static unsigned long twd_target_rate;
 
 static void twd_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *clk)
@@ -79,10 +81,31 @@ int twd_timer_ack(void)
 	return 0;
 }
 
-static void __cpuinit twd_calibrate_rate(void)
+void twd_recalc_prescaler(unsigned long new_rate)
+{
+	u32 ctrl;
+	int prescaler;
+	unsigned long periphclk_rate;
+
+	BUG_ON(twd_periphclk_prescaler == 0 || twd_timer_rate == 0);
+
+	periphclk_rate = new_rate / twd_periphclk_prescaler;
+
+	prescaler = DIV_ROUND_UP(periphclk_rate, twd_timer_rate);
+	prescaler = clamp(prescaler - 1, 0, 0xFF);
+
+	ctrl = __raw_readl(twd_base + TWD_TIMER_CONTROL);
+	ctrl &= ~TWD_TIMER_CONTROL_PRESCALE_MASK;
+	ctrl |= prescaler << 8;
+	__raw_writel(ctrl, twd_base + TWD_TIMER_CONTROL);
+}
+
+static void __cpuinit twd_calibrate_rate(unsigned long target_rate,
+	unsigned int periphclk_prescaler)
 {
 	unsigned long load, count;
 	u64 waitjiffies;
+	unsigned long cpu_rate;
 
 	/*
 	 * If this is the first time round, we need to work out how fast
@@ -113,8 +136,22 @@ static void __cpuinit twd_calibrate_rate(void)
 
 		twd_timer_rate = (0xFFFFFFFFU - count) * (HZ / 5);
 
+		/*
+		 * If a target rate has been requested, adjust the TWD prescaler
+		 * to get the closest lower frequency.
+		 */
+		if (target_rate) {
+			twd_periphclk_prescaler = periphclk_prescaler;
+			twd_target_rate = target_rate;
+
+			cpu_rate = twd_timer_rate * periphclk_prescaler;
+			twd_recalc_prescaler(cpu_rate);
+
+			twd_timer_rate = twd_target_rate;
+		}
+
 		printk("%lu.%02luMHz.\n", twd_timer_rate / 1000000,
-			(twd_timer_rate / 100000) % 100);
+			(twd_timer_rate / 10000) % 100);
 	}
 
 	load = twd_timer_rate / HZ;
@@ -125,11 +162,12 @@ static void __cpuinit twd_calibrate_rate(void)
 /*
  * Setup the local clock events for a CPU.
  */
-void __cpuinit twd_timer_setup(struct clock_event_device *clk)
+static void __cpuinit __twd_timer_setup(struct clock_event_device *clk,
+	unsigned long target_rate, unsigned int periphclk_prescaler)
 {
 	unsigned long flags;
 
-	twd_calibrate_rate();
+	twd_calibrate_rate(target_rate, periphclk_prescaler);
 
 	clk->name = "local_timer";
 	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
@@ -151,6 +189,17 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clockevents_register_device(clk);
 }
 
+void __cpuinit twd_timer_setup_scalable(struct clock_event_device *clk,
+	unsigned long target_rate, unsigned int periphclk_prescaler)
+{
+	__twd_timer_setup(clk, target_rate, periphclk_prescaler);
+}
+
+void __cpuinit twd_timer_setup(struct clock_event_device *clk)
+{
+	__twd_timer_setup(clk, 0, 0);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 /*
  * take a local timer down
-- 
1.7.1

