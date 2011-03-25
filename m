Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1CYNYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:24:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:34673 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330Ab1CYNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:08 -0400
Message-Id: <20110325132048.908367739@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 16/23] arm: davinci: Cleanup irq chip code
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-davinci.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new functionality which ensures that irq_set_type is
called with the chip masked. Unmask is only done when the interrupt is
not disabled.

Retrieve the trigger type from irq_data in unmask

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-davinci/gpio.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6-tip/arch/arm/mach-davinci/gpio.c
@@ -218,7 +218,7 @@ static void gpio_irq_enable(struct irq_d
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
 	u32 mask = (u32) irq_data_get_irq_data(d);
-	unsigned status = irq_desc[d->irq].status;
+	unsigned status = irqd_get_trigger_type(d);
 
 	status &= IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING;
 	if (!status)
@@ -238,16 +238,6 @@ static int gpio_irq_type(struct irq_data
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	irq_desc[d->irq].status &= ~IRQ_TYPE_SENSE_MASK;
-	irq_desc[d->irq].status |= trigger;
-
-	/* don't enable the IRQ if it's currently disabled */
-	if (irq_desc[d->irq].depth == 0) {
-		__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
-			     ? &g->set_falling : &g->clr_falling);
-		__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_RISING)
-			     ? &g->set_rising : &g->clr_rising);
-	}
 	return 0;
 }
 
@@ -256,6 +246,7 @@ static struct irq_chip gpio_irqchip = {
 	.irq_enable	= gpio_irq_enable,
 	.irq_disable	= gpio_irq_disable,
 	.irq_set_type	= gpio_irq_type,
+	.flags		= IRQCHIP_SET_TYPE_MASKED,
 };
 
 static void
@@ -395,7 +386,7 @@ static int __init davinci_gpio_irq_setup
 
 		/* AINTC handles mask/unmask; GPIO handles triggering */
 		irq = bank_irq;
-		gpio_irqchip_unbanked = *get_irq_desc_chip(irq_to_desc(irq));
+		gpio_irqchip_unbanked = *irq_get_chip(irq);
 		gpio_irqchip_unbanked.name = "GPIO-AINTC";
 		gpio_irqchip_unbanked.irq_set_type = gpio_irq_type_unbanked;
 
@@ -409,7 +400,7 @@ static int __init davinci_gpio_irq_setup
 			set_irq_chip(irq, &gpio_irqchip_unbanked);
 			set_irq_data(irq, (void *) __gpio_mask(gpio));
 			set_irq_chip_data(irq, (__force void *) g);
-			irq_desc[irq].status |= IRQ_TYPE_EDGE_BOTH;
+			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
 		}
 
 		goto done;


