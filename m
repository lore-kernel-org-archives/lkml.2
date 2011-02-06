Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1BFTgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:36:38 -0500
Received: from www.tglx.de ([62.245.132.106]:53777 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1BFTge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:36:34 -0500
Message-Id: <20110206193617.333788348@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:36:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 2/3] microblaze: Convert irq_chip to new functions
References: <20110206193440.279124802@linutronix.de>
Content-Disposition: inline; filename=microblaze-convert-irqchip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper irq_desc wrappers while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/kernel/intc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

Index: linux-next/arch/microblaze/kernel/intc.c
===================================================================
--- linux-next.orig/arch/microblaze/kernel/intc.c
+++ linux-next/arch/microblaze/kernel/intc.c
@@ -40,46 +40,46 @@ unsigned int nr_irq;
 #define MER_ME (1<<0)
 #define MER_HIE (1<<1)
 
-static void intc_enable_or_unmask(unsigned int irq)
+static void intc_enable_or_unmask(struct irq_chip *d)
 {
-	unsigned long mask = 1 << irq;
-	pr_debug("enable_or_unmask: %d\n", irq);
+	unsigned long mask = 1 << d->irq;
+	pr_debug("enable_or_unmask: %d\n", d->irq);
 	out_be32(INTC_BASE + SIE, mask);
 
 	/* ack level irqs because they can't be acked during
 	 * ack function since the handle_level_irq function
 	 * acks the irq before calling the interrupt handler
 	 */
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_to_desc(d->irq)->status & IRQ_LEVEL)
 		out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_disable_or_mask(unsigned int irq)
+static void intc_disable_or_mask(struct irq_chip *d)
 {
-	pr_debug("disable: %d\n", irq);
-	out_be32(INTC_BASE + CIE, 1 << irq);
+	pr_debug("disable: %d\n", d->irq);
+	out_be32(INTC_BASE + CIE, 1 << d->irq);
 }
 
-static void intc_ack(unsigned int irq)
+static void intc_ack(struct irq_chip *d)
 {
-	pr_debug("ack: %d\n", irq);
-	out_be32(INTC_BASE + IAR, 1 << irq);
+	pr_debug("ack: %d\n", d->irq);
+	out_be32(INTC_BASE + IAR, 1 << d->irq);
 }
 
-static void intc_mask_ack(unsigned int irq)
+static void intc_mask_ack(struct irq_chip *d)
 {
-	unsigned long mask = 1 << irq;
-	pr_debug("disable_and_ack: %d\n", irq);
+	unsigned long mask = 1 << d->irq;
+	pr_debug("disable_and_ack: %d\n", d->irq);
 	out_be32(INTC_BASE + CIE, mask);
 	out_be32(INTC_BASE + IAR, mask);
 }
 
 static struct irq_chip intc_dev = {
 	.name = "Xilinx INTC",
-	.unmask = intc_enable_or_unmask,
-	.mask = intc_disable_or_mask,
-	.ack = intc_ack,
-	.mask_ack = intc_mask_ack,
+	.irq_unmask = intc_enable_or_unmask,
+	.irq_mask = intc_disable_or_mask,
+	.irq_ack = intc_ack,
+	.irq_mask_ack = intc_mask_ack,
 };
 
 unsigned int get_irq(struct pt_regs *regs)
@@ -159,11 +159,11 @@ void __init init_IRQ(void)
 		if (intr_type & (0x00000001 << i)) {
 			set_irq_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, intc_dev.name);
-			irq_desc[i].status &= ~IRQ_LEVEL;
+			irq_clear_status_flags(i, IRQ_LEVEL);
 		} else {
 			set_irq_chip_and_handler_name(i, &intc_dev,
 				handle_level_irq, intc_dev.name);
-			irq_desc[i].status |= IRQ_LEVEL;
+			irq_set_status_flags(i, IRQ_LEVEL);
 		}
 	}
 }


