Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1BFXjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:35 -0500
Received: from www.tglx.de ([62.245.132.106]:40366 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1BFXje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:34 -0500
Message-Id: <20110206233904.777004540@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 07/10] m68knommu: Convert 5272 intc irq_chip to new functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-5272-intc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/5272/intc.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

Index: linux-next/arch/m68knommu/platform/5272/intc.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/5272/intc.c
+++ linux-next/arch/m68knommu/platform/5272/intc.c
@@ -78,8 +78,10 @@ static struct irqmap intc_irqmap[MCFINT_
  * an interrupt on this irq (for the external irqs). So this mask function
  * is also an ack_mask function.
  */
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
 		irq -= MCFINT_VECBASE;
@@ -88,8 +90,10 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
 		irq -= MCFINT_VECBASE;
@@ -98,8 +102,10 @@ static void intc_irq_unmask(unsigned int
 	}
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
+
 	/* Only external interrupts are acked */
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		irq -= MCFINT_VECBASE;
@@ -113,8 +119,10 @@ static void intc_irq_ack(unsigned int ir
 	}
 }
 
-static int intc_irq_set_type(unsigned int irq, unsigned int type)
+static int intc_irq_set_type(struct irq_data *d, unsigned int type)
 {
+	unsigned int irq = d->irq;
+
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		irq -= MCFINT_VECBASE;
 		if (intc_irqmap[irq].ack) {
@@ -137,17 +145,17 @@ static int intc_irq_set_type(unsigned in
  */
 static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
 {
-	desc->chip->ack(irq);
+	get_irq_desc_chip(i)->irq_ack(desc->irq_data);
 	handle_simple_irq(irq, desc);
 }
 
 static struct irq_chip intc_irq_chip = {
 	.name		= "CF-INTC",
-	.mask		= intc_irq_mask,
-	.unmask		= intc_irq_unmask,
-	.mask_ack	= intc_irq_mask,
-	.ack		= intc_irq_ack,
-	.set_type	= intc_irq_set_type,
+	.irq_mask	= intc_irq_mask,
+	.irq_unmask	= intc_irq_unmask,
+	.irq_mask_ack	= intc_irq_mask,
+	.irq_ack	= intc_irq_ack,
+	.irq_set_type	= intc_irq_set_type,
 };
 
 void __init init_IRQ(void)


