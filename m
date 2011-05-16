Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1EPXW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:22:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1EPXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:22:27 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists-infradead.org
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <robherring2@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: smp_twd: Reconfigure clockevents after cpufreq change
Date: Mon, 16 May 2011 16:21:54 -0700
Message-Id: <1305588114-23728-1-git-send-email-ccross@android.com>
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

Signed-off-by: Colin Cross <ccross@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rob Herring <robherring2@gmail.com>
---
 arch/arm/kernel/smp_twd.c |   69 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 66 insertions(+), 3 deletions(-)

This patch depends on Thomas Gleixner's patch to add clockevents_reconfigure
See: https://lkml.org/lkml/2011/5/13/122

This patch adds a clock that can be used to skip calibration as well
as update the frequency.  A later patch (or a later version of this patch)
will drop twd_calibrate_rate once all platforms provide the necessary
smp_twd clock.

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 60636f4..dbf58d4 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -10,21 +10,29 @@
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
 
+#define TWD_MIN_RANGE 4
+
 /* set up by the platform code */
 void __iomem *twd_base;
 
+static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
+static DEFINE_PER_CPU(struct clock_event_device *, twd_ce);
 
 static void twd_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *clk)
@@ -80,6 +88,49 @@ int twd_timer_ack(void)
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
+	clockevents_reconfigure(__get_cpu_var(twd_ce), twd_timer_rate,
+			TWD_MIN_RANGE);
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
@@ -124,7 +175,16 @@ static void __cpuinit twd_calibrate_rate(void)
  */
 void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 {
-	twd_calibrate_rate();
+	if (twd_clk == NULL) {
+		twd_clk = clk_get_sys("smp_twd", NULL);
+		if (IS_ERR_OR_NULL(twd_clk))
+			pr_warn("%s: no clock found\n", __func__);
+	}
+
+	if (!IS_ERR_OR_NULL(twd_clk))
+		twd_timer_rate = clk_get_rate(twd_clk);
+	else
+		twd_calibrate_rate();
 
 	clk->name = "local_timer";
 	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
@@ -132,13 +192,16 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->rating = 350;
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
-	clk->shift = 20;
-	clk->mult = div_sc(twd_timer_rate, NSEC_PER_SEC, clk->shift);
+
+	clockevents_calc_mult_shift(clk, twd_timer_rate, TWD_MIN_RANGE);
+
 	clk->max_delta_ns = clockevent_delta2ns(0xffffffff, clk);
 	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
 
 	/* Make sure our local interrupt controller has this enabled */
 	gic_enable_ppi(clk->irq);
 
+	__get_cpu_var(twd_ce) = clk;
+
 	clockevents_register_device(clk);
 }
-- 
1.7.4.1

