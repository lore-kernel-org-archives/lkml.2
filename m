Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2AYBhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:37:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33840 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2AYBhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:37:03 -0500
Date: Tue, 24 Jan 2012 17:36:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120125013604.GI2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <1327435069.2767.1.camel@edumazet-laptop>
 <20120124211137.GD2381@linux.vnet.ibm.com>
 <20120124220700.GA11725@sirena.org.uk>
 <20120124224345.GG2381@linux.vnet.ibm.com>
 <20120124235123.GA32176@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124235123.GA32176@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012501-7408-0000-0000-00000224D1C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:51:24PM +0000, Mark Brown wrote:
> On Tue, Jan 24, 2012 at 02:43:45PM -0800, Paul E. McKenney wrote:
> > On Tue, Jan 24, 2012 at 10:07:00PM +0000, Mark Brown wrote:
> > > On Tue, Jan 24, 2012 at 01:11:37PM -0800, Paul E. McKenney wrote:
> 
> > > > Hmmm...  Residual power dissipation is given in milliwatts.  I could
> > > > imagine some heartburn from many of the more aggressive embedded folks,
> > > > given that they might prefer microwatts -- or maybe even nanowatts,
> > > > for all I know.
> 
> > > FWIW idle battery referenced draw from a modern smartphone will be in
> > > the low single digit miliwatts or so.
> 
> > Ah, OK, so only the non-smart cellphones would care, but they generally
> > don't run Linux, from what I understand.  Thanks for the info!
> 
> Well, that depends.  Anything you're actually accomplishing when you're
> optimising at that level is at the less than a milliwatt level.

OK, good point.

In the meantime, here are some alleged fixes for the corresponding bug in
the ARM tree.  Some of these are "interesting" in the sense that RCU can
be used more deeply in the idle loop than I would believe to be safe,
for example, via locking->lockdep->RCU after some interesting pieces
of hardware have been shut off.  I took my best guess and commented the
ones that I am least sure of.

Thoughts?  Other than I need to CC a cast of thousands?  (I cannot break
this up without having git bisect points with busted RCU on ARM.)

							Thanx, Paul

------------------------------------------------------------------------

arm: Avoid invoking RCU when CPU is idle

The idle loop is a quiscent state for RCU, which means that RCU ignores
CPUs that have told RCU that they are idle via rcu_idle_enter().
There are nevertheless quite a few places where idle CPUs use RCU, most
commonly indirectly via tracing.  This patch fixes these problems for ARM.

Many of these bugs have been in the kernel for quite some time, but
Frederic's recent change now gives warnings.

This patch takes the straightforward approach of pushing the
rcu_idle_enter()/rcu_idle_exit() pair further down into the core of the
idle loop.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..8241df7 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -207,7 +207,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_idle_enter();
-		rcu_idle_enter();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -237,7 +236,6 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index a851e6c..8feff6b 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -20,6 +20,7 @@
 #include <asm/proc-fns.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/rcupdate.h>
 
 #include "pm.h"
 
@@ -43,6 +44,7 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 
 	local_irq_disable();
 	do_gettimeofday(&before);
+	rcu_idle_enter();
 	if (index == 0)
 		/* Wait for interrupt state */
 		cpu_do_idle();
@@ -53,6 +55,7 @@ static int at91_enter_idle(struct cpuidle_device *dev,
 		cpu_do_idle();
 		sdram_selfrefresh_disable(saved_lpr);
 	}
+	rcu_idle_exit();
 	do_gettimeofday(&after);
 	local_irq_enable();
 	idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index a30c7c5..6594b7e 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -17,6 +17,7 @@
 #include <linux/cpuidle.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/rcupdate.h>
 #include <asm/proc-fns.h>
 
 #include <mach/cpuidle.h>
@@ -90,12 +91,14 @@ static int davinci_enter_idle(struct cpuidle_device *dev,
 	local_irq_disable();
 	do_gettimeofday(&before);
 
+	rcu_idle_enter();
 	if (ops && ops->enter)
 		ops->enter(ops->flags);
 	/* Wait for interrupt state */
 	cpu_do_idle();
 	if (ops && ops->exit)
 		ops->exit(ops->flags);
+	rcu_idle_exit();
 
 	do_gettimeofday(&after);
 	local_irq_enable();
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index c59e188..1e5844a 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -203,8 +203,10 @@ static struct map_desc exynos4_iodesc1[] __initdata = {
 
 static void exynos_idle(void)
 {
+	rcu_idle_enter();
 	if (!need_resched())
 		cpu_do_idle();
+	rcu_idle_exit();
 
 	local_irq_enable();
 }
diff --git a/arch/arm/mach-highbank/pm.c b/arch/arm/mach-highbank/pm.c
index 33b3beb..5ecc4bc 100644
--- a/arch/arm/mach-highbank/pm.c
+++ b/arch/arm/mach-highbank/pm.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/suspend.h>
+#include <linux/rcupdate.h>
 
 #include <asm/proc-fns.h>
 #include <asm/smp_scu.h>
@@ -33,12 +34,23 @@ static int highbank_suspend_finish(unsigned long val)
 
 static int highbank_pm_enter(suspend_state_t state)
 {
+	/*
+	 * Some of the functions preceding the cpu_suspend() can
+	 * invoke RCU, but only in case of failure to disable preemption
+	 * or preempt_disable() misnesting.  Assume that these errors
+	 * are not committed in the following code, because RCU just
+	 * doesn't want to run on a CPU that has its caches disabled.
+	 */
+	rcu_idle_enter();
+
 	hignbank_set_pwr_suspend();
 	highbank_set_cpu_jump(0, cpu_resume);
 
 	scu_power_mode(scu_base_addr, SCU_PM_POWEROFF);
 	cpu_suspend(0, highbank_suspend_finish);
 
+	rcu_idle_exit();
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 31807d2..0945b23 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/rcupdate.h>
 
 #include <asm/pgtable.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -34,6 +35,7 @@ static void imx3_idle(void)
 {
 	unsigned long reg = 0;
 
+	rcu_idle_enter();
 	if (!need_resched())
 		__asm__ __volatile__(
 			/* disable I and D cache */
@@ -58,6 +60,7 @@ static void imx3_idle(void)
 			"orr %0, %0, #0x00000004\n"
 			"mcr p15, 0, %0, c1, c0, 0\n"
 			: "=r" (reg));
+	rcu_idle_exit();
 	local_irq_enable();
 }
 
diff --git a/arch/arm/mach-imx/pm-imx27.c b/arch/arm/mach-imx/pm-imx27.c
index e455d2f..c4adc05 100644
--- a/arch/arm/mach-imx/pm-imx27.c
+++ b/arch/arm/mach-imx/pm-imx27.c
@@ -10,12 +10,14 @@
 #include <linux/kernel.h>
 #include <linux/suspend.h>
 #include <linux/io.h>
+#include <linux/rcupdate.h>
 #include <mach/system.h>
 #include <mach/hardware.h>
 
 static int mx27_suspend_enter(suspend_state_t state)
 {
 	u32 cscr;
+	rcu_idle_enter();
 	switch (state) {
 	case PM_SUSPEND_MEM:
 		/* Clear MPEN and SPEN to disable MPLL/SPLL */
@@ -24,9 +26,11 @@ static int mx27_suspend_enter(suspend_state_t state)
 		__raw_writel(cscr, MX27_IO_ADDRESS(MX27_CCM_BASE_ADDR));
 		/* Executes WFI */
 		arch_idle();
+		rcu_idle_exit();
 		break;
 
 	default:
+		rcu_idle_exit();
 		return -EINVAL;
 	}
 	return 0;
diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index f7b0c2b..b9c2589 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/suspend.h>
+#include <linux/rcupdate.h>
 #include <asm/cacheflush.h>
 #include <asm/proc-fns.h>
 #include <asm/suspend.h>
@@ -31,6 +32,7 @@ static int imx6q_suspend_finish(unsigned long val)
 
 static int imx6q_pm_enter(suspend_state_t state)
 {
+	rcu_idle_enter();
 	switch (state) {
 	case PM_SUSPEND_MEM:
 		imx6q_set_lpm(STOP_POWER_OFF);
@@ -40,8 +42,10 @@ static int imx6q_pm_enter(suspend_state_t state)
 		cpu_suspend(0, imx6q_suspend_finish);
 		imx_smp_prepare();
 		imx_gpc_post_resume();
+		rcu_idle_exit();
 		break;
 	default:
+		rcu_idle_exit();
 		return -EINVAL;
 	}
 
diff --git a/arch/arm/mach-kirkwood/cpuidle.c b/arch/arm/mach-kirkwood/cpuidle.c
index 7088180..de8e317 100644
--- a/arch/arm/mach-kirkwood/cpuidle.c
+++ b/arch/arm/mach-kirkwood/cpuidle.c
@@ -19,6 +19,7 @@
 #include <linux/cpuidle.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/rcupdate.h>
 #include <asm/proc-fns.h>
 #include <mach/kirkwood.h>
 
@@ -41,6 +42,7 @@ static int kirkwood_enter_idle(struct cpuidle_device *dev,
 
 	local_irq_disable();
 	do_gettimeofday(&before);
+	rcu_idle_enter();
 	if (index == 0)
 		/* Wait for interrupt state */
 		cpu_do_idle();
@@ -55,6 +57,7 @@ static int kirkwood_enter_idle(struct cpuidle_device *dev,
 		writel(0x7, DDR_OPERATION_BASE);
 		cpu_do_idle();
 	}
+	rcu_idle_exit();
 	do_gettimeofday(&after);
 	local_irq_enable();
 	idle_time = (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index bc17dfe..d919648 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/clk.h>
+#include <linux/rcupdate.h>
 
 #include <asm/mach/map.h>
 
@@ -37,7 +38,9 @@ static void imx5_idle(void)
 		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
 		if (tzic_enable_wake())
 			goto err1;
+		rcu_idle_enter();  /* No tracing until rcu_idle_exit(). */
 		cpu_do_idle();
+		rcu_idle_exit();
 err1:
 		clk_disable(gpc_dvfs_clk);
 	}
diff --git a/arch/arm/mach-mx5/pm-imx5.c b/arch/arm/mach-mx5/pm-imx5.c
index 98052fc..b4adf42 100644
--- a/arch/arm/mach-mx5/pm-imx5.c
+++ b/arch/arm/mach-mx5/pm-imx5.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/rcupdate.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <mach/common.h>
@@ -27,6 +28,7 @@ static int mx5_suspend_prepare(void)
 
 static int mx5_suspend_enter(suspend_state_t state)
 {
+	rcu_idle_enter();
 	switch (state) {
 	case PM_SUSPEND_MEM:
 		mx5_cpu_lp_set(STOP_POWER_OFF);
@@ -47,6 +49,7 @@ static int mx5_suspend_enter(suspend_state_t state)
 		__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
 	}
 	cpu_do_idle();
+	rcu_idle_exit();
 	return 0;
 }
 
diff --git a/arch/arm/mach-mxs/pm.c b/arch/arm/mach-mxs/pm.c
index fb042da..36a3a57 100644
--- a/arch/arm/mach-mxs/pm.c
+++ b/arch/arm/mach-mxs/pm.c
@@ -15,16 +15,20 @@
 #include <linux/kernel.h>
 #include <linux/suspend.h>
 #include <linux/io.h>
+#include <linux/rcupdate.h>
 #include <mach/system.h>
 
 static int mxs_suspend_enter(suspend_state_t state)
 {
+	rcu_idle_enter();
 	switch (state) {
 	case PM_SUSPEND_MEM:
 		arch_idle();
+		rcu_idle_exit();
 		break;
 
 	default:
+		rcu_idle_exit();
 		return -EINVAL;
 	}
 	return 0;
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 89ea20c..c661eba 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -108,11 +108,13 @@ void omap1_pm_idle(void)
 	__u32 use_idlect1 = arm_idlect1_mask;
 	int do_sleep = 0;
 
+	rcu_idle_enter();
 	local_irq_disable();
 	local_fiq_disable();
 	if (need_resched()) {
 		local_fiq_enable();
 		local_irq_enable();
+		rcu_idle_exit();
 		return;
 	}
 
@@ -158,6 +160,7 @@ void omap1_pm_idle(void)
 
 		local_fiq_enable();
 		local_irq_enable();
+		rcu_idle_exit();
 		return;
 	}
 	omap_sram_suspend(omap_readl(ARM_IDLECT1),
@@ -165,6 +168,7 @@ void omap1_pm_idle(void)
 
 	local_fiq_enable();
 	local_irq_enable();
+	rcu_idle_exit();
 }
 
 /*
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index b8822f8..2139e9d 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -232,6 +232,7 @@ static int omap2_can_sleep(void)
 
 static void omap2_pm_idle(void)
 {
+	rcu_idle_enter();
 	local_irq_disable();
 	local_fiq_disable();
 
@@ -250,6 +251,7 @@ static void omap2_pm_idle(void)
 out:
 	local_fiq_enable();
 	local_irq_enable();
+	rcu_idle_exit();
 }
 
 #ifdef CONFIG_SUSPEND
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index fc69875..58a8689 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -427,7 +427,9 @@ static void omap3_pm_idle(void)
 	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 	trace_cpu_idle(1, smp_processor_id());
 
+	rcu_idle_enter();
 	omap_sram_idle();
+	rcu_idle_exit();
 
 	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index c264ef7..038796c 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include "common.h"
 #include "clockdomain.h"
@@ -178,6 +179,7 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *unused)
  */
 static void omap_default_idle(void)
 {
+	rcu_idle_enter();
 	local_irq_disable();
 	local_fiq_disable();
 
@@ -185,6 +187,7 @@ static void omap_default_idle(void)
 
 	local_fiq_enable();
 	local_irq_enable();
+	rcu_idle_exit();
 }
 
 /**
diff --git a/arch/arm/mach-pnx4008/pm.c b/arch/arm/mach-pnx4008/pm.c
index f3e60a0..0b8703f 100644
--- a/arch/arm/mach-pnx4008/pm.c
+++ b/arch/arm/mach-pnx4008/pm.c
@@ -102,6 +102,7 @@ static inline void pnx4008_suspend(void)
 
 static int pnx4008_pm_enter(suspend_state_t state)
 {
+	rcu_idle_enter();
 	switch (state) {
 	case PM_SUSPEND_STANDBY:
 		pnx4008_standby();
@@ -110,6 +111,7 @@ static int pnx4008_pm_enter(suspend_state_t state)
 		pnx4008_suspend();
 		break;
 	}
+	rcu_idle_exit();
 	return 0;
 }
 
diff --git a/arch/arm/mach-prima2/pm.c b/arch/arm/mach-prima2/pm.c
index 26ebb57..1e35c8a 100644
--- a/arch/arm/mach-prima2/pm.c
+++ b/arch/arm/mach-prima2/pm.c
@@ -15,6 +15,7 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
+#include <linux/rcupdate.h>
 #include <linux/rtc/sirfsoc_rtciobrg.h>
 #include <asm/suspend.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -64,6 +65,7 @@ static int sirfsoc_pre_suspend_power_off(void)
 
 static int sirfsoc_pm_enter(suspend_state_t state)
 {
+	rcu_idle_enter(); /* No good place for this: locking->lockdep->RCU. */
 	switch (state) {
 	case PM_SUSPEND_MEM:
 		sirfsoc_pre_suspend_power_off();
@@ -73,8 +75,10 @@ static int sirfsoc_pm_enter(suspend_state_t state)
 		/* go zzz */
 		cpu_suspend(0, sirfsoc_finish_suspend);
 		outer_resume();
+		rcu_idle_exit();
 		break;
 	default:
+		rcu_idle_exit();
 		return -EINVAL;
 	}
 	return 0;
diff --git a/arch/arm/mach-s5p64x0/common.c b/arch/arm/mach-s5p64x0/common.c
index 52b89a3..c59a7f2 100644
--- a/arch/arm/mach-s5p64x0/common.c
+++ b/arch/arm/mach-s5p64x0/common.c
@@ -146,6 +146,7 @@ static void s5p64x0_idle(void)
 {
 	unsigned long val;
 
+	rcu_idle_enter();
 	if (!need_resched()) {
 		val = __raw_readl(S5P64X0_PWR_CFG);
 		val &= ~(0x3 << 5);
@@ -154,6 +155,7 @@ static void s5p64x0_idle(void)
 
 		cpu_do_idle();
 	}
+	rcu_idle_exit();
 	local_irq_enable();
 }
 
diff --git a/arch/arm/mach-s5pc100/common.c b/arch/arm/mach-s5pc100/common.c
index c909573..7bf02ff 100644
--- a/arch/arm/mach-s5pc100/common.c
+++ b/arch/arm/mach-s5pc100/common.c
@@ -131,9 +131,11 @@ static struct map_desc s5pc100_iodesc[] __initdata = {
 
 static void s5pc100_idle(void)
 {
+	rcu_idle_enter();
 	if (!need_resched())
 		cpu_do_idle();
 
+	rcu_idle_exit();
 	local_irq_enable();
 }
 
diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
index 9c1bcdc..ccd6b4d 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -144,9 +144,11 @@ static struct map_desc s5pv210_iodesc[] __initdata = {
 
 static void s5pv210_idle(void)
 {
+	rcu_idle_enter();
 	if (!need_resched())
 		cpu_do_idle();
 
+	rcu_idle_exit();
 	local_irq_enable();
 }
 
diff --git a/arch/arm/mach-shmobile/cpuidle.c b/arch/arm/mach-shmobile/cpuidle.c
index 1b23342..651e92b 100644
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@ -13,6 +13,7 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/rcupdate.h>
 #include <asm/system.h>
 #include <asm/io.h>
 
@@ -33,6 +34,7 @@ static int shmobile_cpuidle_enter(struct cpuidle_device *dev,
 
 	before = ktime_get();
 
+	rcu_idle_enter();
 	local_irq_disable();
 	local_fiq_disable();
 
@@ -40,6 +42,7 @@ static int shmobile_cpuidle_enter(struct cpuidle_device *dev,
 
 	local_irq_enable();
 	local_fiq_enable();
+	rcu_idle_exit();
 
 	after = ktime_get();
 	dev->last_residency = ktime_to_ns(ktime_sub(after, before)) >> 10;
diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
index fcf8b17..e11507e 100644
--- a/arch/arm/mach-shmobile/pm-sh7372.c
+++ b/arch/arm/mach-shmobile/pm-sh7372.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/bitrev.h>
 #include <linux/console.h>
+#include <linux/rcupdate.h>
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tlbflush.h>
@@ -520,17 +521,24 @@ static int sh7372_enter_suspend(suspend_state_t suspend_state)
 		    sh7372_a4s.genpd.status == GPD_STATE_POWER_OFF) {
 			/* enter A4S sleep with PLLC0 off */
 			pr_debug("entering A4S\n");
+			rcu_idle_enter();
 			sh7372_enter_a4s_common(0);
+			rcu_idle_exit();
 		} else {
 			/* enter A3SM sleep with PLLC0 off */
 			pr_debug("entering A3SM\n");
+			rcu_idle_enter();
 			sh7372_enter_a3sm_common(0);
+			rcu_idle_exit();
 		}
 	} else {
 		/* default to Core Standby that supports all wakeup sources */
 		pr_debug("entering Core Standby\n");
+		rcu_idle_enter();
 		sh7372_enter_core_standby();
+		rcu_idle_exit();
 	}
+
 	return 0;
 }
 

