Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1BFXjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:37 -0500
Received: from www.tglx.de ([62.245.132.106]:40373 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1BFXjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:35 -0500
Message-Id: <20110206233904.874075727@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 08/10] m68knommu Convert 5249 intc irq_chip to new functions
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline; filename=m68k-nommu-convert-5249-intc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/me idly wonders what sets the handlers for this chip.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/platform/5249/intc2.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-next/arch/m68knommu/platform/5249/intc2.c
===================================================================
--- linux-next.orig/arch/m68knommu/platform/5249/intc2.c
+++ linux-next/arch/m68knommu/platform/5249/intc2.c
@@ -17,32 +17,32 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 
-static void intc2_irq_gpio_mask(unsigned int irq)
+static void intc2_irq_gpio_mask(struct irq_data *d)
 {
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
-	imr &= ~(0x1 << (irq - MCFINTC2_GPIOIRQ0));
+	imr &= ~(0x1 << (d->irq - MCFINTC2_GPIOIRQ0));
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_unmask(unsigned int irq)
+static void intc2_irq_gpio_unmask(struct irq_data *d)
 {
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
-	imr |= (0x1 << (irq - MCFINTC2_GPIOIRQ0));
+	imr |= (0x1 << (d->irq - MCFINTC2_GPIOIRQ0));
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_ack(unsigned int irq)
+static void intc2_irq_gpio_ack(struct irq_data *d)
 {
-	writel(0x1 << (irq - MCFINTC2_GPIOIRQ0), MCF_MBAR2 + MCFSIM2_GPIOINTCLEAR);
+	writel(0x1 << (d->irq - MCFINTC2_GPIOIRQ0), MCF_MBAR2 + MCFSIM2_GPIOINTCLEAR);
 }
 
 static struct irq_chip intc2_irq_gpio_chip = {
 	.name		= "CF-INTC2",
-	.mask		= intc2_irq_gpio_mask,
-	.unmask		= intc2_irq_gpio_unmask,
-	.ack		= intc2_irq_gpio_ack,
+	.irq_mask	= intc2_irq_gpio_mask,
+	.irq_unmask	= intc2_irq_gpio_unmask,
+	.irq_ack	= intc2_irq_gpio_ack,
 };
 
 static int __init mcf_intc2_init(void)
@@ -51,7 +51,7 @@ static int __init mcf_intc2_init(void)
 
 	/* GPIO interrupt sources */
 	for (irq = MCFINTC2_GPIOIRQ0; (irq <= MCFINTC2_GPIOIRQ7); irq++)
-		irq_desc[irq].chip = &intc2_irq_gpio_chip;
+		set_irq_chip(irq, &intc2_irq_gpio_chip);
 
 	return 0;
 }


