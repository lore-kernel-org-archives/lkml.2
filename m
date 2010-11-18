Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KRGPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:15:31 -0500
Received: from smtp-out.google.com ([74.125.121.35]:7360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0KRGP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:15:29 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists-infradead.org
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>,
        Rob Herring <robherring2@gmail.com>, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
Date: Wed, 17 Nov 2010 22:14:59 -0800
Message-Id: <1290060899-9786-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock to the ARM TWD local timer scales with the cpu
frequency. To allow the cpu frequency to change while
maintaining a constant TWD frequency, pick a lower target
frequency for the TWD and use the prescaler to divide down
to the closest lower frequency.

This patch provides a new initialization function that takes
a target TWD frequency and the ratio between the cpu
clock and the TWD clock, specified as an integer divider >= 2
in the Cortex A9 MPCore TRM, and 2 in the ARM11 MPCore TRM.
It also registers a cpufreq notifier that adjusts the
prescaler when the cpu frequency changes.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/smp_twd.h |   11 ++++
 arch/arm/kernel/smp_twd.c      |  106 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index 634f357..5119763 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -17,6 +17,7 @@
 #define TWD_TIMER_CONTROL_ONESHOT	(0 << 1)
 #define TWD_TIMER_CONTROL_PERIODIC	(1 << 1)
 #define TWD_TIMER_CONTROL_IT_ENABLE	(1 << 2)
+#define TWD_TIMER_CONTROL_PRESCALE_MASK	(0xFF << 8)
 
 struct clock_event_device;
 
@@ -26,4 +27,14 @@ void twd_timer_stop(void);
 int twd_timer_ack(void);
 void twd_timer_setup(struct clock_event_device *);
 
+/*
+ * Use this setup function on systems that support cpufreq.
+ * periphclk_prescaler is the fixed divider value between the cpu
+ * clock and the PERIPHCLK clock that feeds the TWD.  target_rate should be
+ * low enough that the prescaler can accurately reach the target rate from the
+ * lowest cpu frequency, but high enough to give a reasonable timer accuracy.
+ */
+void twd_timer_setup_scalable(struct clock_event_device *,
+	unsigned long target_rate, unsigned int periphclk_prescaler);
+
 #endif
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 35882fb..e2bc65c 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -17,6 +17,7 @@
 #include <linux/clockchips.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include <asm/smp_twd.h>
 #include <asm/hardware/gic.h>
@@ -25,11 +26,17 @@
 void __iomem *twd_base;
 
 static unsigned long twd_timer_rate;
+static unsigned long twd_periphclk_prescaler;
+static unsigned long twd_target_rate;
 
 static void twd_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *clk)
 {
 	unsigned long ctrl;
+	unsigned long prescale;
+
+	prescale = __raw_readl(twd_base + TWD_TIMER_CONTROL) &
+			TWD_TIMER_CONTROL_PRESCALE_MASK;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -47,6 +54,8 @@ static void twd_set_mode(enum clock_event_mode mode,
 		ctrl = 0;
 	}
 
+	ctrl |= prescale;
+
 	__raw_writel(ctrl, twd_base + TWD_TIMER_CONTROL);
 }
 
@@ -79,9 +88,55 @@ int twd_timer_ack(void)
 	return 0;
 }
 
+/*
+ * must be called with interrupts disabled and on the cpu that is being changed
+ */
+static void twd_update_cpu_frequency(unsigned long new_rate)
+{
+	u32 ctrl;
+	int prescaler;
+
+	BUG_ON(twd_periphclk_prescaler == 0 || twd_target_rate == 0);
+
+	twd_timer_rate = new_rate / twd_periphclk_prescaler;
+
+	prescaler = DIV_ROUND_UP(twd_timer_rate, twd_target_rate);
+	prescaler = clamp(prescaler - 1, 0, 0xFF);
+
+	ctrl = __raw_readl(twd_base + TWD_TIMER_CONTROL);
+	ctrl &= ~TWD_TIMER_CONTROL_PRESCALE_MASK;
+	ctrl |= prescaler << 8;
+	__raw_writel(ctrl, twd_base + TWD_TIMER_CONTROL);
+}
+
+static void twd_update_cpu_frequency_on_cpu(void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	twd_update_cpu_frequency(freq->new * 1000);
+}
+
+static int twd_cpufreq_notifier(struct notifier_block *nb,
+			unsigned long event, void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	if (event == CPUFREQ_RESUMECHANGE ||
+	    (event == CPUFREQ_PRECHANGE && freq->new > freq->old) ||
+	    (event == CPUFREQ_POSTCHANGE && freq->new < freq->old))
+		smp_call_function_single(freq->cpu,
+			twd_update_cpu_frequency_on_cpu, freq, 1);
+
+	return 0;
+}
+
+static struct notifier_block twd_cpufreq_notifier_block = {
+	.notifier_call = twd_cpufreq_notifier,
+};
+
 static void __cpuinit twd_calibrate_rate(void)
 {
-	unsigned long load, count;
+	unsigned long count;
 	u64 waitjiffies;
 
 	/*
@@ -114,23 +169,37 @@ static void __cpuinit twd_calibrate_rate(void)
 		twd_timer_rate = (0xFFFFFFFFU - count) * (HZ / 5);
 
 		printk("%lu.%02luMHz.\n", twd_timer_rate / 1000000,
-			(twd_timer_rate / 100000) % 100);
+			(twd_timer_rate / 10000) % 100);
 	}
-
-	load = twd_timer_rate / HZ;
-
-	__raw_writel(load, twd_base + TWD_TIMER_LOAD);
 }
 
 /*
  * Setup the local clock events for a CPU.
  */
-void __cpuinit twd_timer_setup(struct clock_event_device *clk)
+static void __cpuinit __twd_timer_setup(struct clock_event_device *clk,
+	unsigned long target_rate, unsigned int periphclk_prescaler)
 {
 	unsigned long flags;
+	unsigned long load;
+	unsigned long cpu_rate;
+	unsigned long twd_tick_rate;
 
 	twd_calibrate_rate();
 
+	if (target_rate && periphclk_prescaler) {
+		cpu_rate = twd_timer_rate * periphclk_prescaler;
+		twd_target_rate = target_rate;
+		twd_periphclk_prescaler = periphclk_prescaler;
+		twd_update_cpu_frequency(cpu_rate);
+		twd_tick_rate = twd_target_rate;
+	} else {
+		twd_tick_rate = twd_timer_rate;
+	}
+
+	load = twd_tick_rate / HZ;
+
+	__raw_writel(load, twd_base + TWD_TIMER_LOAD);
+
 	clk->name = "local_timer";
 	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
 			CLOCK_EVT_FEAT_C3STOP;
@@ -138,7 +207,7 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
 	clk->shift = 20;
-	clk->mult = div_sc(twd_timer_rate, NSEC_PER_SEC, clk->shift);
+	clk->mult = div_sc(twd_tick_rate, NSEC_PER_SEC, clk->shift);
 	clk->max_delta_ns = clockevent_delta2ns(0xffffffff, clk);
 	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
 
@@ -151,6 +220,27 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
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
+static int twd_timer_setup_cpufreq(void)
+{
+	if (twd_periphclk_prescaler)
+		cpufreq_register_notifier(&twd_cpufreq_notifier_block,
+			CPUFREQ_TRANSITION_NOTIFIER);
+
+	return 0;
+}
+arch_initcall(twd_timer_setup_cpufreq);
+
 #ifdef CONFIG_HOTPLUG_CPU
 /*
  * take a local timer down
-- 
1.7.3.1

