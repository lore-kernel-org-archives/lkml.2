Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1CYNWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:34680 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609Ab1CYNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:09 -0400
Message-Id: <20110325132048.996818347@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 17/23] arm: at91: Cleanup irq chip
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-at91.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the whole lazy disable dance in the demux handler by providing a
irq_disable() callback.

Use the proper accessor functions and tidy up gpio_irq_handler()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-at91/gpio.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
@@ -375,6 +375,7 @@ static int gpio_irq_type(struct irq_data
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
+	.irq_disable	= gpio_irq_mask,
 	.irq_mask	= gpio_irq_mask,
 	.irq_unmask	= gpio_irq_unmask,
 	.irq_set_type	= gpio_irq_type,
@@ -384,16 +385,14 @@ static struct irq_chip gpio_irqchip = {
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	unsigned	pin;
-	struct irq_desc	*gpio;
-	struct at91_gpio_chip *at91_gpio;
-	void __iomem	*pio;
+	struct irq_data *idata = irq_desc_get_irq_data(desc);
+	struct irq_chip *chip = irq_data_get_chip(data);
+	struct at91_gpio_chip *at91_gpio = irq_data_get_chip_data(data);
+	void __iomem	*pio = at91_gpio->regbase;
 	u32		isr;
 
-	at91_gpio = get_irq_chip_data(irq);
-	pio = at91_gpio->regbase;
-
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	chip->irq_ack(idata);
 	for (;;) {
 		/* Reading ISR acks pending (edge triggered) GPIO interrupts.
 		 * When there none are pending, we're finished unless we need
@@ -409,27 +408,15 @@ static void gpio_irq_handler(unsigned ir
 		}
 
 		pin = at91_gpio->chip.base;
-		gpio = &irq_desc[pin];
 
 		while (isr) {
-			if (isr & 1) {
-				if (unlikely(gpio->depth)) {
-					/*
-					 * The core ARM interrupt handler lazily disables IRQs so
-					 * another IRQ must be generated before it actually gets
-					 * here to be disabled on the GPIO controller.
-					 */
-					gpio_irq_mask(irq_get_irq_data(pin));
-				}
-				else
-					generic_handle_irq(pin);
-			}
+			if (isr & 1)
+				generic_handle_irq(pin);
 			pin++;
-			gpio++;
 			isr >>= 1;
 		}
 	}
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	chip->irq_unmask(idata);
 	/* now it may re-trigger */
 }
 


