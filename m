Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2BCWfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:35:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:65429 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab2BCWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:35:23 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, shawn.guo@linaro.org,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v4 3/4] ARM: imx: add irq domain support to tzic
Date: Fri,  3 Feb 2012 16:35:11 -0600
Message-Id: <1328308512-22594-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add irq domain support to tzic. This is needed to enable DT.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/plat-mxc/tzic.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 98308ec..25c10bb 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -77,7 +77,7 @@ static int tzic_set_irq_fiq(unsigned int irq, unsigned int type)
 static void tzic_irq_suspend(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	int idx = gc->irq_base >> 5;
+	int idx = d->hwirq / 32;
 
 	__raw_writel(gc->wake_active, tzic_base + TZIC_WAKEUP0(idx));
 }
@@ -85,7 +85,7 @@ static void tzic_irq_suspend(struct irq_data *d)
 static void tzic_irq_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	int idx = gc->irq_base >> 5;
+	int idx = d->hwirq / 32;
 
 	__raw_writel(__raw_readl(tzic_base + TZIC_ENSET0(idx)),
 		     tzic_base + TZIC_WAKEUP0(idx));
@@ -102,18 +102,13 @@ static struct mxc_extra_irq tzic_extra_irq = {
 #endif
 };
 
-static __init void tzic_init_gc(unsigned int irq_start)
+static __init void tzic_init_gc(struct irq_chip_generic *gc)
 {
-	struct irq_chip_generic *gc;
-	struct irq_chip_type *ct;
-	int idx = irq_start >> 5;
+	struct irq_chip_type *ct = gc->chip_types;
+	int idx = gc->hwirq_base / 32;
 
-	gc = irq_alloc_generic_chip("tzic", 1, irq_start, tzic_base,
-				    handle_level_irq);
-	gc->private = &tzic_extra_irq;
 	gc->wake_enabled = IRQ_MSK(32);
 
-	ct = gc->chip_types;
 	ct->chip.irq_mask = irq_gc_mask_disable_reg;
 	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
 	ct->chip.irq_set_wake = irq_gc_set_wake;
@@ -122,7 +117,7 @@ static __init void tzic_init_gc(unsigned int irq_start)
 	ct->regs.disable = TZIC_ENCLEAR0(idx);
 	ct->regs.enable = TZIC_ENSET0(idx);
 
-	irq_setup_generic_chip(gc, IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
+	return 0;
 }
 
 asmlinkage void __exception_irq_entry tzic_handle_irq(struct pt_regs *regs)
@@ -175,8 +170,10 @@ void __init tzic_init_irq(void __iomem *irqbase)
 
 	/* all IRQ no FIQ Warning :: No selection */
 
-	for (i = 0; i < TZIC_NUM_IRQS; i += 32)
-		tzic_init_gc(i);
+	irq_setup_generic_chip_domain("tzic", NULL, 1, 0, tzic_base,
+				      handle_level_irq, TZIC_NUM_IRQS, 0,
+				      IRQ_NOREQUEST, 0,
+				      tzic_init_gc, &tzic_extra_irq);
 
 #ifdef CONFIG_FIQ
 	/* Initialize FIQ */
-- 
1.7.5.4

