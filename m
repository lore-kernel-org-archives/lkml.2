Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0IGHVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:21:40 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54693 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0IGHVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:21:36 -0400
MIME-Version: 1.0
X-Originating-IP: [81.243.35.243]
Date: Tue, 7 Sep 2010 09:21:32 +0200
Message-ID: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
Subject: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Cc: discuss@lesswatts.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch proposal for adding new trace events for power management.
Note: thread restarted after the initial discussions on LKML.

Jean

>From 6768b88e8133129fa847dd7a95dc6dd17c0662d2 Mon Sep 17 00:00:00 2001
From: Jean Pihet <jean.pihet@newoldbits.com>
Date: Tue, 7 Sep 2010 09:12:48 +0200
Subject: [PATCH] [PATCH] tracing, perf: add more power related events

This patch adds new generic events for dynamic power management
tracing:
- clock events class: used for clock enable/disable and for
  clock rate change,
- power_domain events class: used for power domains transitions.

The OMAP architecture is using the new events for PM debugging, however
the new events are made generic enough to be used by all platforms.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/cpuidle34xx.c |    2 +
 arch/arm/mach-omap2/pm34xx.c      |    4 ++
 arch/arm/mach-omap2/powerdomain.c |    3 +
 arch/arm/plat-omap/clock.c        |   13 ++++-
 arch/arm/plat-omap/cpu-omap.c     |    5 ++-
 include/trace/events/power.h      |   90 +++++++++++++++++++++++++++++++++++-
 6 files changed, 110 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle34xx.c
b/arch/arm/mach-omap2/cpuidle34xx.c
index 3d3d035..6113bd9 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -24,6 +24,7 @@

 #include <linux/sched.h>
 #include <linux/cpuidle.h>
+#include <trace/events/power.h>

 #include <plat/prcm.h>
 #include <plat/irqs.h>
@@ -130,6 +131,7 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 	local_irq_disable();
 	local_fiq_disable();

+	trace_power_start(POWER_CSTATE, cx->type, smp_processor_id());
 	pwrdm_set_next_pwrst(mpu_pd, mpu_state);
 	pwrdm_set_next_pwrst(core_pd, core_state);

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index f25bc3d..7bf8a87 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <trace/events/power.h>

 #include <plat/sram.h>
 #include <plat/clockdomain.h>
@@ -588,6 +589,7 @@ static void omap3_pm_idle(void)
 	if (omap_irq_pending() || need_resched())
 		goto out;

+	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 	omap_sram_idle();

 out:
@@ -628,6 +630,8 @@ static int omap3_pm_suspend(void)
 		omap2_pm_wakeup_on_timer(wakeup_timer_seconds,
 					 wakeup_timer_milliseconds);

+	trace_power_start(POWER_SSTATE, 1, smp_processor_id());
+
 	/* Read current next_pwrsts */
 	list_for_each_entry(pwrst, &pwrst_list, node)
 		pwrst->saved_state = pwrdm_read_next_pwrst(pwrst->pwrdm);
diff --git a/arch/arm/mach-omap2/powerdomain.c
b/arch/arm/mach-omap2/powerdomain.c
index 6527ec3..73cbe9a 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <asm/atomic.h>

@@ -440,6 +441,8 @@ int pwrdm_set_next_pwrst(struct powerdomain
*pwrdm, u8 pwrst)
 	pr_debug("powerdomain: setting next powerstate for %s to %0x\n",
 		 pwrdm->name, pwrst);

+	trace_power_domain_target(pwrdm->name, pwrst, smp_processor_id());
+
 	prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
 			     (pwrst << OMAP_POWERSTATE_SHIFT),
 			     pwrdm->prcm_offs, pwrstctrl_reg_offs);
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 7190cbd..d6518f5 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -21,6 +21,7 @@
 #include <linux/cpufreq.h>
 #include <linux/debugfs.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <plat/clock.h>

@@ -43,8 +44,10 @@ int clk_enable(struct clk *clk)
 		return -EINVAL;

 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_enable)
+	if (arch_clock->clk_enable) {
+		trace_clock_enable(clk->name, 1, smp_processor_id());
 		ret = arch_clock->clk_enable(clk);
+	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);

 	return ret;
@@ -66,8 +69,10 @@ void clk_disable(struct clk *clk)
 		goto out;
 	}

-	if (arch_clock->clk_disable)
+	if (arch_clock->clk_disable) {
+		trace_clock_disable(clk->name, 0, smp_processor_id());
 		arch_clock->clk_disable(clk);
+	}

 out:
 	spin_unlock_irqrestore(&clockfw_lock, flags);
@@ -120,8 +125,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		return ret;

 	spin_lock_irqsave(&clockfw_lock, flags);
-	if (arch_clock->clk_set_rate)
+	if (arch_clock->clk_set_rate) {
+		trace_clock_set_rate(clk->name, rate, smp_processor_id());
 		ret = arch_clock->clk_set_rate(clk, rate);
+	}
 	if (ret == 0) {
 		if (clk->recalc)
 			clk->rate = clk->recalc(clk);
diff --git a/arch/arm/plat-omap/cpu-omap.c b/arch/arm/plat-omap/cpu-omap.c
index df08829..cc4e41f 100644
--- a/arch/arm/plat-omap/cpu-omap.c
+++ b/arch/arm/plat-omap/cpu-omap.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <trace/events/power.h>

 #include <mach/hardware.h>
 #include <plat/clock.h>
@@ -116,8 +117,10 @@ static int omap_target(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 #elif defined(CONFIG_ARCH_OMAP3) && !defined(CONFIG_OMAP_PM_NONE)
 	freq = target_freq * 1000;
-	if (opp_find_freq_ceil(mpu_dev, &freq))
+	if (opp_find_freq_ceil(mpu_dev, &freq)) {
+		trace_power_frequency(POWER_PSTATE, freq, smp_processor_id());
 		omap_pm_cpu_set_freq(freq);
+	}
 #endif
 	return ret;
 }
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 35a2a6e..286784d 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -10,12 +10,17 @@
 #ifndef _TRACE_POWER_ENUM_
 #define _TRACE_POWER_ENUM_
 enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
+	POWER_NONE	= 0,
+	POWER_CSTATE	= 1,	/* C-State */
+	POWER_PSTATE	= 2,	/* Fequency change or DVFS */
+	POWER_SSTATE	= 3,	/* Suspend */
 };
 #endif

+/*
+ * The power events are used for cpuidle & suspend (power_start, power_end)
+ *  and for cpufreq (power_frequency)
+ */
 DECLARE_EVENT_CLASS(power,

 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
@@ -70,6 +75,85 @@ TRACE_EVENT(power_end,

 );

+/*
+ * The clock events are used for clock enable/disable and for
+ *  clock rate change
+ */
+DECLARE_EVENT_CLASS(clock,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__field(        u64,            state           )
+		__field(        u64,            cpu_id          )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+	),
+
+	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_enable,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_disable,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+DEFINE_EVENT(clock, clock_set_rate,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
+/*
+ * The power domain events are used for power domains transitions
+ */
+DECLARE_EVENT_CLASS(power_domain,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__field(        u64,            state           )
+		__field(        u64,            cpu_id          )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+		__entry->cpu_id = cpu_id;
+),
+
+	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
+		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
+);
+
+DEFINE_EVENT(power_domain, power_domain_target,
+
+	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
+
+	TP_ARGS(name, state, cpu_id)
+);
+
 #endif /* _TRACE_POWER_H */

 /* This part must be outside protection */
-- 
1.7.1
