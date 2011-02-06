Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1BFVMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:12:24 -0500
Received: from www.tglx.de ([62.245.132.106]:54813 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1BFVMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:12:23 -0500
Message-Id: <20110206211137.653005586@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:12:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 1/3] xtensa: Convert main irq_chip to new functions
References: <20110206211051.865188529@linutronix.de>
Content-Disposition: inline; filename=xtensa-convert-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/kernel/irq.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

Index: linux-next/arch/xtensa/kernel/irq.c
===================================================================
--- linux-next.orig/arch/xtensa/kernel/irq.c
+++ linux-next/arch/xtensa/kernel/irq.c
@@ -35,7 +35,6 @@ atomic_t irq_err_count;
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc = irq_desc + irq;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -57,7 +56,7 @@ asmlinkage void do_IRQ(int irq, struct p
 			       sp - sizeof(struct thread_info));
 	}
 #endif
-	desc->handle_irq(irq, desc);
+	generic_handle_irq(irq);
 
 	irq_exit();
 	set_irq_regs(old_regs);
@@ -111,50 +110,50 @@ skip:
 	return 0;
 }
 
-static void xtensa_irq_mask(unsigned int irq)
+static void xtensa_irq_mask(struct irq_chip *d)
 {
-	cached_irq_mask &= ~(1 << irq);
+	cached_irq_mask &= ~(1 << d->irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(unsigned int irq)
+static void xtensa_irq_unmask(struct irq_chip *d)
 {
-	cached_irq_mask |= 1 << irq;
+	cached_irq_mask |= 1 << d->irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(unsigned int irq)
+static void xtensa_irq_enable(struct irq_chip *d)
 {
-	variant_irq_enable(irq);
-	xtensa_irq_unmask(irq);
+	variant_irq_enable(d->irq);
+	xtensa_irq_unmask(d->irq);
 }
 
-static void xtensa_irq_disable(unsigned int irq)
+static void xtensa_irq_disable(struct irq_chip *d)
 {
-	xtensa_irq_mask(irq);
-	variant_irq_disable(irq);
+	xtensa_irq_mask(d->irq);
+	variant_irq_disable(d->irq);
 }
 
-static void xtensa_irq_ack(unsigned int irq)
+static void xtensa_irq_ack(struct irq_chip *d)
 {
-	set_sr(1 << irq, INTCLEAR);
+	set_sr(1 << d->irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(unsigned int irq)
+static int xtensa_irq_retrigger(struct irq_chip *d)
 {
-	set_sr (1 << irq, INTSET);
+	set_sr (1 << d->irq, INTSET);
 	return 1;
 }
 
 
 static struct irq_chip xtensa_irq_chip = {
 	.name		= "xtensa",
-	.enable		= xtensa_irq_enable,
-	.disable	= xtensa_irq_disable,
-	.mask		= xtensa_irq_mask,
-	.unmask		= xtensa_irq_unmask,
-	.ack		= xtensa_irq_ack,
-	.retrigger	= xtensa_irq_retrigger,
+	.irq_enable	= xtensa_irq_enable,
+	.irq_disable	= xtensa_irq_disable,
+	.irq_mask	= xtensa_irq_mask,
+	.irq_unmask	= xtensa_irq_unmask,
+	.irq_ack	= xtensa_irq_ack,
+	.irq_retrigger	= xtensa_irq_retrigger,
 };
 
 void __init init_IRQ(void)


