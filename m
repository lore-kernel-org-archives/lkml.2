Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1GZJT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:19:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1GZJTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:19:20 -0400
Date: Tue, 26 Jul 2011 11:19:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
Message-ID: <20110726091917.GQ16561@pengutronix.de>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
 <4E2E3089.5070600@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E2E3089.5070600@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 08:12:09PM -0700, Frank Rowand wrote:
> On 07/24/11 03:33, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt3 release.
> 
> ARM panda board boots for PREEMPT_RT_FULL, with a BUG:
> 
> Freeing init memory: 308K
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
> in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper
> 1 lock held by swapper/0:
>  #0:  (&irq_desc_lock_class){-.....}, at: [<c00ed470>] handle_fasteoi_irq+0x14/0x10c
> irq event stamp: 21292
> hardirqs last  enabled at (21291): [<c0061ee0>] default_idle+0x2c/0x3c
> hardirqs last disabled at (21292): [<c0484bb4>] __irq_svc+0x34/0x138
> softirqs last  enabled at (0): [<  (null)>]   (null)
> softirqs last disabled at (0): [<  (null)>]   (null)
> [<c00681b8>] (unwind_backtrace+0x0/0xf0) from [<c0483d20>] (rt_spin_lock+0x24/0x5c)
> [<c0483d20>] (rt_spin_lock+0x24/0x5c) from [<c006df74>] (gic_mask_irq+0x28/0x7c)
> [<c006df74>] (gic_mask_irq+0x28/0x7c) from [<c00ece20>] (mask_irq+0x1c/0x2c)
> [<c00ece20>] (mask_irq+0x1c/0x2c) from [<c00ed514>] (handle_fasteoi_irq+0xb8/0x10c)
> [<c00ed514>] (handle_fasteoi_irq+0xb8/0x10c) from [<c00ea724>] (generic_handle_irq+0x34/0x50)
> [<c00ea724>] (generic_handle_irq+0x34/0x50) from [<c0055048>] (asm_do_IRQ+0x48/0xa8)
> [<c0055048>] (asm_do_IRQ+0x48/0xa8) from [<c0484bd0>] (__irq_svc+0x50/0x138)
I guess you need something like the patch below.

Best regards
Uwe

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 4ddd0a6..5c1dd07 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -33,7 +33,7 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
 
-static DEFINE_SPINLOCK(irq_controller_lock);
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /* Address of GIC 0 CPU interface */
 void __iomem *gic_cpu_base_addr __read_mostly;
@@ -88,30 +88,30 @@ static void gic_mask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_CLEAR + (gic_irq(d) / 32) * 4);
 	if (gic_arch_extn.irq_mask)
 		gic_arch_extn.irq_mask(d);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_unmask_irq(struct irq_data *d)
 {
 	u32 mask = 1 << (d->irq % 32);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	if (gic_arch_extn.irq_unmask)
 		gic_arch_extn.irq_unmask(d);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_SET + (gic_irq(d) / 32) * 4);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 }
 
 static void gic_eoi_irq(struct irq_data *d)
 {
 	if (gic_arch_extn.irq_eoi) {
-		spin_lock(&irq_controller_lock);
+		raw_spin_lock(&irq_controller_lock);
 		gic_arch_extn.irq_eoi(d);
-		spin_unlock(&irq_controller_lock);
+		raw_spin_unlock(&irq_controller_lock);
 	}
 
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
@@ -135,7 +135,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 
 	if (gic_arch_extn.irq_set_type)
 		gic_arch_extn.irq_set_type(d, type);
@@ -160,7 +160,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (enabled)
 		writel_relaxed(enablemask, base + GIC_DIST_ENABLE_SET + enableoff);
 
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
 }
@@ -188,11 +188,11 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	mask = 0xff << shift;
 	bit = 1 << (cpu + shift);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	d->node = cpu;
 	val = readl_relaxed(reg) & ~mask;
 	writel_relaxed(val | bit, reg);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
 }
@@ -222,9 +222,9 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 
 	chained_irq_enter(chip, desc);
 
-	spin_lock(&irq_controller_lock);
+	raw_spin_lock(&irq_controller_lock);
 	status = readl_relaxed(chip_data->cpu_base + GIC_CPU_INTACK);
-	spin_unlock(&irq_controller_lock);
+	raw_spin_unlock(&irq_controller_lock);
 
 	gic_irq = (status & 0x3ff);
 	if (gic_irq == 1023)
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
