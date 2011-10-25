Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab1JYMi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:38:29 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:43168 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932667Ab1JYMi1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:38:27 -0400
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 08:38:26 EDT
Date: Tue, 25 Oct 2011 13:12:03 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111025131203.1f21ebcf@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
References: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 85.13.70.251
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, arnd@arndb.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, chaos.youn@samsung.com, kgene.kim@samsung.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 07:45:32 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Arnd,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-exynos4/include/mach/entry-macro.S between commit
> 292b293ceef2 ("ARM: gic: consolidate PPI handling") from the arm tree and
> commit 3a0622811292 ("ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212")
> from the arm-soc tree.
> 
> Again, I hacked it up (again probably incorrectly - I kept both
> additions).

Here's the patch I've applied to my local copy of next-20111025.
Compile-tested only.

>From bb5510b2bf42bece7f8b27fff05e8841c5832cd5 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Tue, 25 Oct 2011 12:42:01 +0100
Subject: [PATCH] ARM: EXYNOS4: convert MCT to percpu interrupt API

MCT recently gained per cpu interrupts, and missed the fact that
ARM has moved to a genirq based implementation.

This patch converts the driver to the new API.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-exynos4/mct.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-exynos4/mct.c b/arch/arm/mach-exynos4/mct.c
index f191608..4764c5d 100644
--- a/arch/arm/mach-exynos4/mct.c
+++ b/arch/arm/mach-exynos4/mct.c
@@ -44,7 +44,7 @@ struct mct_clock_event_device {
 	char name[10];
 };
 
-struct mct_clock_event_device mct_tick[NR_CPUS];
+static DEFINE_PER_CPU(struct mct_clock_event_device, percpu_mct_tick);
 
 static void exynos4_mct_write(unsigned int value, void *addr)
 {
@@ -302,7 +302,7 @@ static void exynos4_mct_tick_start(unsigned long cycles,
 static int exynos4_tick_set_next_event(unsigned long cycles,
 				       struct clock_event_device *evt)
 {
-	struct mct_clock_event_device *mevt = &mct_tick[smp_processor_id()];
+	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
 
 	exynos4_mct_tick_start(cycles, mevt);
 
@@ -312,7 +312,7 @@ static int exynos4_tick_set_next_event(unsigned long cycles,
 static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
 					 struct clock_event_device *evt)
 {
-	struct mct_clock_event_device *mevt = &mct_tick[smp_processor_id()];
+	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
 
 	exynos4_mct_tick_stop(mevt);
 
@@ -376,14 +376,16 @@ static struct irqaction mct_tick1_event_irq = {
 
 static void exynos4_mct_tick_init(struct clock_event_device *evt)
 {
+	struct mct_clock_event_device *mevt;
 	unsigned int cpu = smp_processor_id();
 
-	mct_tick[cpu].evt = evt;
+	mevt = this_cpu_ptr(&percpu_mct_tick);
+	mevt->evt = evt;
 
-	mct_tick[cpu].base = EXYNOS4_MCT_L_BASE(cpu);
-	sprintf(mct_tick[cpu].name, "mct_tick%d", cpu);
+	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
+	sprintf(mevt->name, "mct_tick%d", cpu);
 
-	evt->name = mct_tick[cpu].name;
+	evt->name = mevt->name;
 	evt->cpumask = cpumask_of(cpu);
 	evt->set_next_event = exynos4_tick_set_next_event;
 	evt->set_mode = exynos4_tick_set_mode;
@@ -398,21 +400,21 @@ static void exynos4_mct_tick_init(struct clock_event_device *evt)
 
 	clockevents_register_device(evt);
 
-	exynos4_mct_write(0x1, mct_tick[cpu].base + MCT_L_TCNTB_OFFSET);
+	exynos4_mct_write(0x1, mevt->base + MCT_L_TCNTB_OFFSET);
 
 	if (mct_int_type == MCT_INT_SPI) {
 		if (cpu == 0) {
-			mct_tick0_event_irq.dev_id = &mct_tick[cpu];
+			mct_tick0_event_irq.dev_id = mevt;
 			evt->irq = IRQ_MCT_L0;
 			setup_irq(IRQ_MCT_L0, &mct_tick0_event_irq);
 		} else {
-			mct_tick1_event_irq.dev_id = &mct_tick[cpu];
+			mct_tick1_event_irq.dev_id = mevt;
 			evt->irq = IRQ_MCT_L1;
 			setup_irq(IRQ_MCT_L1, &mct_tick1_event_irq);
 			irq_set_affinity(IRQ_MCT_L1, cpumask_of(1));
 		}
 	} else {
-		gic_enable_ppi(IRQ_MCT_LOCALTIMER);
+		enable_percpu_irq(IRQ_MCT_LOCALTIMER, 0);
 	}
 }
 
@@ -427,9 +429,11 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 void local_timer_stop(struct clock_event_device *evt)
 {
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
-	disable_irq(evt->irq);
+	if (mct_int_type == MCT_INT_SPI)
+		disable_irq(evt->irq);
+	else
+		disable_percpu_irq(IRQ_MCT_LOCALTIMER);
 }
-
 #endif /* CONFIG_LOCAL_TIMERS */
 
 static void __init exynos4_timer_resources(void)
@@ -438,6 +442,16 @@ static void __init exynos4_timer_resources(void)
 	mct_clk = clk_get(NULL, "xtal");
 
 	clk_rate = clk_get_rate(mct_clk);
+
+	if (mct_int_type == MCT_INT_PPI) {
+		int err;
+
+		err = request_percpu_irq(IRQ_MCT_LOCALTIMER,
+					 exynos4_mct_tick_isr, "MCT",
+					 &percpu_mct_tick);
+		WARN(err, "MCT: can't request IRQ %d (%d)\n",
+		     IRQ_MCT_LOCALTIMER, err);
+	}		
 }
 
 static void __init exynos4_timer_init(void)
-- 
1.7.7


-- 
I'm the slime oozin' out from your TV set...
