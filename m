Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1IWQDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:03:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42079 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754920Ab1IWQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:03:06 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3 3/3] ARM: gic, local timers: use the request_percpu_irq() interface
Date: Fri, 23 Sep 2011 17:03:08 +0100
Message-Id: <1316793788-14500-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
References: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
X-OriginalArrivalTime: 23 Sep 2011 16:02:51.0381 (UTC) FILETIME=[3F19AA50:01CC7A0A]
X-MC-Unique: 111092317030301501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id p8NG3UeI005791

This patch remove the hardcoded link between local timers and PPIs,
and convert the PPI users (TWD and MSM timers) to the new *_percpu_irq
interface. Also some collateral cleanup (local_timer_ack() is gone,
and the interrupt handler is strictly private to each driver).

PPIs are now useable for more than just the local timers.

Cc: David Brown <davidb@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/common/gic.c               |   52 --------------------------
 arch/arm/include/asm/hardware/gic.h |    1 -
 arch/arm/include/asm/localtimer.h   |   17 ++++-----
 arch/arm/include/asm/smp_twd.h      |    2 +-
 arch/arm/kernel/smp.c               |   16 +--------
 arch/arm/kernel/smp_twd.c           |   47 +++++++++++++++++++++++-
 arch/arm/mach-exynos4/mct.c         |    5 ---
 arch/arm/mach-msm/timer.c           |   69 ++++++++++++++++++++---------------
 8 files changed, 94 insertions(+), 115 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 9b83077..a3f335c 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -35,7 +35,6 @@
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
-#include <asm/localtimer.h>
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
@@ -259,32 +258,6 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
-#ifdef CONFIG_LOCAL_TIMERS
-#define gic_ppi_handler		percpu_timer_handler
-#else
-static irqreturn_t gic_ppi_handler(int irq, void *dev_id)
-{
-	return IRQ_NONE;
-}
-#endif
-
-#define PPI_IRQACT(nr)						\
-	{							\
-		.handler	= gic_ppi_handler,		\
-		.flags		= IRQF_PERCPU | IRQF_TIMER,	\
-		.irq		= nr,				\
-		.name		= "PPI-" # nr,			\
-	}
-
-static struct irqaction ppi_irqaction_template[16] __initdata = {
-	PPI_IRQACT(0),  PPI_IRQACT(1),  PPI_IRQACT(2),  PPI_IRQACT(3),
-	PPI_IRQACT(4),  PPI_IRQACT(5),  PPI_IRQACT(6),  PPI_IRQACT(7),
-	PPI_IRQACT(8),  PPI_IRQACT(9),  PPI_IRQACT(10), PPI_IRQACT(11),
-	PPI_IRQACT(12), PPI_IRQACT(13), PPI_IRQACT(14), PPI_IRQACT(15),
-};
-
-static struct irqaction *ppi_irqaction;
-
 static void __init gic_dist_init(struct gic_chip_data *gic,
 	unsigned int irq_start)
 {
@@ -320,16 +293,6 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	if (gic == &gic_data[0]) {
 		nrppis = 16 - (irq_start & 15);
 		ppi_base = gic->irq_offset + 32 - nrppis;
-
-		ppi_irqaction = kmemdup(&ppi_irqaction_template[16 - nrppis],
-					sizeof(*ppi_irqaction) * nrppis,
-					GFP_KERNEL);
-
-		if (nrppis && !ppi_irqaction) {
-			pr_err("GIC: Can't allocate PPI memory");
-			nrppis = 0;
-			ppi_base = 0;
-		}
 	}
 
 	pr_info("Configuring GIC with %d sources (%d PPIs)\n",
@@ -372,17 +335,12 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	 */
 	for (i = 0; i < nrppis; i++) {
 		int ppi = i + ppi_base;
-		int err;
 
 		irq_set_percpu_devid(ppi);
 		irq_set_chip_and_handler(ppi, &gic_chip,
 					 handle_percpu_devid_irq);
 		irq_set_chip_data(ppi, gic);
 		set_irq_flags(ppi, IRQF_VALID | IRQF_NOAUTOEN);
-
-		err = setup_percpu_irq(ppi, &ppi_irqaction[i]);
-		if (err)
-			pr_err("GIC: can't setup PPI%d (%d)\n", ppi, err);
 	}
 
 	for (i = irq_start + nrppis; i < irq_limit; i++) {
@@ -443,16 +401,6 @@ void __cpuinit gic_secondary_init(unsigned int gic_nr)
 	gic_cpu_init(&gic_data[gic_nr]);
 }
 
-void __cpuinit gic_enable_ppi(unsigned int irq)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	irq_set_status_flags(irq, IRQ_NOPROBE);
-	gic_unmask_irq(irq_get_irq_data(irq));
-	local_irq_restore(flags);
-}
-
 #ifdef CONFIG_SMP
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 435d3f8..2dadd50 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -40,7 +40,6 @@ void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
 void gic_secondary_init(unsigned int);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
-void gic_enable_ppi(unsigned int);
 
 struct gic_chip_data {
 	unsigned int irq_offset;
diff --git a/arch/arm/include/asm/localtimer.h b/arch/arm/include/asm/localtimer.h
index e3663f7..f5e1cec 100644
--- a/arch/arm/include/asm/localtimer.h
+++ b/arch/arm/include/asm/localtimer.h
@@ -19,27 +19,20 @@ struct clock_event_device;
  */
 void percpu_timer_setup(void);
 
-/*
- * Per-cpu timer IRQ handler
- */
-irqreturn_t percpu_timer_handler(int irq, void *dev_id);
-
-
 #ifdef CONFIG_LOCAL_TIMERS
 
 #ifdef CONFIG_HAVE_ARM_TWD
 
 #include "smp_twd.h"
 
-#define local_timer_ack()	twd_timer_ack()
+#define local_timer_stop(c)	twd_timer_stop((c))
 
 #else
 
 /*
- * Platform provides this to acknowledge a local timer IRQ.
- * Returns true if the local timer IRQ is to be processed.
+ * Stop the local timer
  */
-int local_timer_ack(void);
+void local_timer_stop(struct clock_event_device *);
 
 #endif
 
@@ -54,6 +47,10 @@ static inline int local_timer_setup(struct clock_event_device *evt)
 {
 	return -ENXIO;
 }
+
+static inline void local_timer_stop(struct clock_event_device *evt)
+{
+}
 #endif
 
 #endif
diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index fed9981..ef9ffba 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -22,7 +22,7 @@ struct clock_event_device;
 
 extern void __iomem *twd_base;
 
-int twd_timer_ack(void);
 void twd_timer_setup(struct clock_event_device *);
+void twd_timer_stop(struct clock_event_device *);
 
 #endif
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8f73342..fcca40b 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -520,20 +520,6 @@ static void ipi_timer(void)
 	irq_exit();
 }
 
-#ifdef CONFIG_LOCAL_TIMERS
-irqreturn_t percpu_timer_handler(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = &__get_cpu_var(percpu_clockevent);
-
-	if (local_timer_ack()) {
-		evt->event_handler(evt);
-		return IRQ_HANDLED;
-	}
-
-	return IRQ_NONE;
-}
-#endif
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static void smp_timer_broadcast(const struct cpumask *mask)
 {
@@ -584,7 +570,7 @@ static void percpu_timer_stop(void)
 	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
 
-	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	local_timer_stop(evt);
 }
 #endif
 
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 01c1862..566c0fe 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 
 #include <asm/smp_twd.h>
+#include <asm/localtimer.h>
 #include <asm/hardware/gic.h>
 
 /* set up by the platform code */
@@ -26,6 +27,8 @@ void __iomem *twd_base;
 
 static unsigned long twd_timer_rate;
 
+static struct clock_event_device __percpu **twd_evt;
+
 static void twd_set_mode(enum clock_event_mode mode,
 			struct clock_event_device *clk)
 {
@@ -80,6 +83,12 @@ int twd_timer_ack(void)
 	return 0;
 }
 
+void twd_timer_stop(struct clock_event_device *clk)
+{
+	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	disable_percpu_irq(clk->irq);
+}
+
 static void __cpuinit twd_calibrate_rate(void)
 {
 	unsigned long count;
@@ -119,11 +128,43 @@ static void __cpuinit twd_calibrate_rate(void)
 	}
 }
 
+static irqreturn_t twd_handler(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
+
+	if (twd_timer_ack()) {
+		evt->event_handler(evt);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
 /*
  * Setup the local clock events for a CPU.
  */
 void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 {
+	struct clock_event_device **this_cpu_clk;
+
+	if (!twd_evt) {
+		int err;
+
+		twd_evt = alloc_percpu(struct clock_event_device *);
+		if (!twd_evt) {
+			pr_err("twd: can't allocate memory\n");
+			return;
+		}
+
+		err = request_percpu_irq(clk->irq, twd_handler,
+					 "twd", twd_evt);
+		if (err) {
+			pr_err("twd: can't register interrupt %d (%d)\n",
+			       clk->irq, err);
+			return;
+		}
+	}
+
 	twd_calibrate_rate();
 
 	clk->name = "local_timer";
@@ -137,8 +178,10 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	clk->max_delta_ns = clockevent_delta2ns(0xffffffff, clk);
 	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
 
+	this_cpu_clk = __this_cpu_ptr(twd_evt);
+	*this_cpu_clk = clk;
+
 	clockevents_register_device(clk);
 
-	/* Make sure our local interrupt controller has this enabled */
-	gic_enable_ppi(clk->irq);
+	enable_percpu_irq(clk->irq);
 }
diff --git a/arch/arm/mach-exynos4/mct.c b/arch/arm/mach-exynos4/mct.c
index ddd8686..b3a0016 100644
--- a/arch/arm/mach-exynos4/mct.c
+++ b/arch/arm/mach-exynos4/mct.c
@@ -402,11 +402,6 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 	return 0;
 }
 
-int local_timer_ack(void)
-{
-	return 0;
-}
-
 #endif /* CONFIG_LOCAL_TIMERS */
 
 static void __init exynos4_timer_resources(void)
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 63621f1..701d5e6 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -71,12 +71,16 @@ enum timer_location {
 struct msm_clock {
 	struct clock_event_device   clockevent;
 	struct clocksource          clocksource;
-	struct irqaction            irq;
+	unsigned int		    irq;
 	void __iomem                *regbase;
 	uint32_t                    freq;
 	uint32_t                    shift;
 	void __iomem                *global_counter;
 	void __iomem                *local_counter;
+	union {
+		struct clock_event_device		*evt;
+		struct clock_event_device __percpu	**percpu_evt;
+	};		
 };
 
 enum {
@@ -87,13 +91,10 @@ enum {
 
 
 static struct msm_clock msm_clocks[];
-static struct clock_event_device *local_clock_event;
 
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = dev_id;
-	if (smp_processor_id() != 0)
-		evt = local_clock_event;
+	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
 	if (evt->event_handler == NULL)
 		return IRQ_HANDLED;
 	evt->event_handler(evt);
@@ -171,13 +172,7 @@ static struct msm_clock msm_clocks[] = {
 			.mask           = CLOCKSOURCE_MASK(32),
 			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 		},
-		.irq = {
-			.name    = "gp_timer",
-			.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
-			.handler = msm_timer_interrupt,
-			.dev_id  = &msm_clocks[0].clockevent,
-			.irq     = INT_GP_TIMER_EXP
-		},
+		.irq = INT_GP_TIMER_EXP,
 		.freq = GPT_HZ,
 	},
 	[MSM_CLOCK_DGT] = {
@@ -196,13 +191,7 @@ static struct msm_clock msm_clocks[] = {
 			.mask           = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
 			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 		},
-		.irq = {
-			.name    = "dg_timer",
-			.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
-			.handler = msm_timer_interrupt,
-			.dev_id  = &msm_clocks[1].clockevent,
-			.irq     = INT_DEBUG_TIMER_EXP
-		},
+		.irq = INT_DEBUG_TIMER_EXP,
 		.freq = DGT_HZ >> MSM_DGT_SHIFT,
 		.shift = MSM_DGT_SHIFT,
 	}
@@ -261,10 +250,30 @@ static void __init msm_timer_init(void)
 			printk(KERN_ERR "msm_timer_init: clocksource_register "
 			       "failed for %s\n", cs->name);
 
-		res = setup_irq(clock->irq.irq, &clock->irq);
+		ce->irq = clock->irq;
+		if (cpu_is_msm8x60() || cpu_is_msm8960()) {
+			clock->percpu_evt = alloc_percpu(struct clock_event_device *);
+			if (!clock->percpu_evt) {
+				pr_err("msm_timer_init: memory allocation "
+				       "failed for %s\n", ce->name);
+				continue;
+			}
+
+			*__this_cpu_ptr(clock->percpu_evt) = ce;
+			res = request_percpu_irq(ce->irq, msm_timer_interrupt,
+						 ce->name, clock->percpu_evt);
+			if (!res)
+				enable_percpu_irq(ce->irq);
+		} else {
+			clock->evt = ce;
+			res = request_irq(ce->irq, msm_timer_interrupt,
+					  IRQF_TIMER | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+					  ce->name, &clock->evt);
+		}
+
 		if (res)
-			printk(KERN_ERR "msm_timer_init: setup_irq "
-			       "failed for %s\n", cs->name);
+			pr_err("msm_timer_init: request_irq failed for %s\n",
+			       ce->name);
 
 		clockevents_register_device(ce);
 	}
@@ -273,6 +282,7 @@ static void __init msm_timer_init(void)
 #ifdef CONFIG_SMP
 int __cpuinit local_timer_setup(struct clock_event_device *evt)
 {
+	static bool local_timer_inited;
 	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
 
 	/* Use existing clock_event for cpu 0 */
@@ -281,12 +291,13 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 
-	if (!local_clock_event) {
+	if (!local_timer_inited) {
 		writel(0, clock->regbase  + TIMER_ENABLE);
 		writel(0, clock->regbase + TIMER_CLEAR);
 		writel(~0, clock->regbase + TIMER_MATCH_VAL);
+		local_timer_inited = true;
 	}
-	evt->irq = clock->irq.irq;
+	evt->irq = clock->irq;
 	evt->name = "local_timer";
 	evt->features = CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = clock->clockevent.rating;
@@ -298,17 +309,17 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 		clockevent_delta2ns(0xf0000000 >> clock->shift, evt);
 	evt->min_delta_ns = clockevent_delta2ns(4, evt);
 
-	local_clock_event = evt;
-
-	gic_enable_ppi(clock->irq.irq);
+	*__this_cpu_ptr(clock->percpu_evt) = evt;
+	enable_percpu_irq(evt->irq);
 
 	clockevents_register_device(evt);
 	return 0;
 }
 
-inline int local_timer_ack(void)
+void local_timer_stop(struct clock_event_device *evt)
 {
-	return 1;
+	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	disable_percpu_irq(evt->irq);
 }
 
 #endif
-- 
1.7.0.4


