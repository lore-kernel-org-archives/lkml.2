Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883Ab1ETAZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:25:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36727 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460Ab1ETAZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:25:42 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq change
Date: Thu, 19 May 2011 17:24:51 -0700
Message-Id: <1305851091-10096-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The localtimer's clock changes with the cpu clock.  After a
cpufreq transition, update the clockevent's frequency and
reprogram the next clock event.

Adds a clock called "smp_twd" that is used to determine the
twd frequency, which can also be used at init time to
avoid calibrating the twd frequency.

Clock changes are based on Rob Herring's work.

Change-Id: I413b5cd07fb2b79bc9fad8b4bf257332d1da7bcd
Signed-off-by: Colin Cross <ccross@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rob Herring <robherring2@gmail.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/kernel/smp_twd.c |   86 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 80 insertions(+), 6 deletions(-)

This patch depends on Thomas Gleixner's patch to add clockevents_update_freq

v2: Squash in changes from Linus Wallej, enable smp_twd clock during init

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 60636f4..b5bd303 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -10,13 +10,17 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/smp.h>
 #include <linux/jiffies.h>
 #include <linux/clockchips.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/percpu.h>
 
 #include <asm/smp_twd.h>
 #include <asm/hardware/gic.h>
@@ -24,7 +28,9 @@
 /* set up by the platform code */
 void __iomem *twd_base;
 
+static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
+static DEFINE_PER_CPU(struct clock_event_device *, twd_ce);
 
 static void twd_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *clk)
@@ -80,6 +86,48 @@ int twd_timer_ack(void)
 	return 0;
 }
 
+/*
+ * Updates clockevent frequency when the cpu frequency changes.
+ * Called on the cpu that is changing frequency with interrupts disabled.
+ */
+static void twd_update_frequency(void *data)
+{
+	twd_timer_rate = clk_get_rate(twd_clk);
+
+	clockevents_update_freq(__get_cpu_var(twd_ce), twd_timer_rate);
+}
+
+static int twd_cpufreq_transition(struct notifier_block *nb,
+	unsigned long state, void *data)
+{
+	struct cpufreq_freqs *freqs = data;
+
+	/*
+	 * The twd clock events must be reprogrammed to account for the new
+	 * frequency.  The timer is local to a cpu, so cross-call to the
+	 * changing cpu.
+	 */
+	if (state == CPUFREQ_POSTCHANGE || state == CPUFREQ_RESUMECHANGE)
+		smp_call_function_single(freqs->cpu, twd_update_frequency,
+			NULL, 1);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block twd_cpufreq_nb = {
+	.notifier_call = twd_cpufreq_transition,
+};
+
+static int twd_cpufreq_init(void)
+{
+	if (!IS_ERR_OR_NULL(twd_clk))
+		return cpufreq_register_notifier(&twd_cpufreq_nb,
+			CPUFREQ_TRANSITION_NOTIFIER);
+
+	return 0;
+}
+core_initcall(twd_cpufreq_init);
+
 static void __cpuinit twd_calibrate_rate(void)
 {
 	unsigned long count;
@@ -119,12 +167,39 @@ static void __cpuinit twd_calibrate_rate(void)
 	}
 }
 
+static struct clk *twd_get_clock(void)
+{
+	struct clk *clk;
+	int err;
+
+	clk = clk_get_sys("smp_twd", NULL);
+	if (IS_ERR(clk)) {
+		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
+		return clk;
+	}
+
+	err = clk_enable(clk);
+	if (err) {
+		pr_err("smp_twd: clock failed to enable: %d\n", err);
+		clk_put(clk);
+		return ERR_PTR(err);
+	}
+
+	return clk;
+}
+
 /*
  * Setup the local clock events for a CPU.
  */
 void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 {
-	twd_calibrate_rate();
+	if (!twd_clk)
+		twd_clk = twd_get_clock();
+
+	if (!IS_ERR_OR_NULL(twd_clk))
+		twd_timer_rate = clk_get_rate(twd_clk);
+	else
+		twd_calibrate_rate();
 
 	clk->name = "local_timer";
 	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
@@ -132,13 +207,12 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->rating = 350;
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
-	clk->shift = 20;
-	clk->mult = div_sc(twd_timer_rate, NSEC_PER_SEC, clk->shift);
-	clk->max_delta_ns = clockevent_delta2ns(0xffffffff, clk);
-	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
 
 	/* Make sure our local interrupt controller has this enabled */
 	gic_enable_ppi(clk->irq);
 
-	clockevents_register_device(clk);
+	__get_cpu_var(twd_ce) = clk;
+
+	clockevents_config_and_register(clk, twd_timer_rate,
+					0xf, 0xffffffff);
 }
-- 
1.7.4.1

