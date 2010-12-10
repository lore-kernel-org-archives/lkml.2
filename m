Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0LJTxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:53:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63486 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab0LJTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:53:31 -0500
From: jean.pihet@newoldbits.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 2/3] perf: add OMAP support for the new power events
Date: Fri, 10 Dec 2010 20:52:00 +0100
Message-Id: <1292010721-17426-3-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292010721-17426-1-git-send-email-j-pihet@ti.com>
References: <1292010721-17426-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

The patch adds the new power management trace points for
the OMAP architecture.

The trace points are for:
- default idle handler. Since the cpuidle framework is
  instrumented in the generic way there is no need to
  add trace points in the OMAP specific cpuidle handler;
- cpufreq (DVFS),
- clocks changes (enable, disable, set_rate),
- change of power domains next power states.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/pm34xx.c      |    7 +++++++
 arch/arm/mach-omap2/powerdomain.c |    3 +++
 arch/arm/plat-omap/clock.c        |   13 ++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 0ec8a04..0ee0b0e 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/console.h>
+#include <trace/events/power.h>
 
 #include <plat/sram.h>
 #include <plat/clockdomain.h>
@@ -506,8 +507,14 @@ static void omap3_pm_idle(void)
 	if (omap_irq_pending() || need_resched())
 		goto out;
 
+	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+	trace_cpu_idle(1, smp_processor_id());
+
 	omap_sram_idle();
 
+	trace_power_end(smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+
 out:
 	local_fiq_enable();
 	local_irq_enable();
diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index 6527ec3..73cbe9a 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <trace/events/power.h>
 
 #include <asm/atomic.h>
 
@@ -440,6 +441,8 @@ int pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
 	pr_debug("powerdomain: setting next powerstate for %s to %0x\n",
 		 pwrdm->name, pwrst);
 
+	trace_power_domain_target(pwrdm->name, pwrst, smp_processor_id());
+
 	prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
 			     (pwrst << OMAP_POWERSTATE_SHIFT),
 			     pwrdm->prcm_offs, pwrstctrl_reg_offs);
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index fc62fb5..7cbb09b 100644
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
-- 
1.7.2.3

