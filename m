Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1CYNWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:34616 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab1CYNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:58 -0400
Message-Id: <20110325132047.940493428@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 06/23] arm: Cleanup irq_desc access
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-orion.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper wrappers and use the flow type in irq_data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-orion/gpio.c |   25 ++++++++++---------------
 arch/arm/plat-orion/irq.c  |    2 +-
 2 files changed, 11 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-orion/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/gpio.c
+++ linux-2.6-tip/arch/arm/plat-orion/gpio.c
@@ -324,9 +324,8 @@ EXPORT_SYMBOL(orion_gpio_set_blink);
 static void gpio_irq_ack(struct irq_data *d)
 {
 	struct orion_gpio_chip *ochip = irq_data_get_irq_chip_data(d);
-	int type;
+	int type = irqd_get_trigger_type(d);
 
-	type = irq_desc[d->irq].status & IRQ_TYPE_SENSE_MASK;
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 		int pin = d->irq - ochip->secondary_irq_base;
 
@@ -337,11 +336,10 @@ static void gpio_irq_ack(struct irq_data
 static void gpio_irq_mask(struct irq_data *d)
 {
 	struct orion_gpio_chip *ochip = irq_data_get_irq_chip_data(d);
-	int type;
+	int type = irqd_get_trigger_type(d);
 	void __iomem *reg;
 	int pin;
 
-	type = irq_desc[d->irq].status & IRQ_TYPE_SENSE_MASK;
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
 		reg = GPIO_EDGE_MASK(ochip);
 	else
@@ -355,11 +353,10 @@ static void gpio_irq_mask(struct irq_dat
 static void gpio_irq_unmask(struct irq_data *d)
 {
 	struct orion_gpio_chip *ochip = irq_data_get_irq_chip_data(d);
-	int type;
+	int type = irqd_get_trigger_type(d);
 	void __iomem *reg;
 	int pin;
 
-	type = irq_desc[d->irq].status & IRQ_TYPE_SENSE_MASK;
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
 		reg = GPIO_EDGE_MASK(ochip);
 	else
@@ -389,9 +386,9 @@ static int gpio_irq_set_type(struct irq_
 	 * Set edge/level type.
 	 */
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
-		set_irq_handler(d->irq, handle_edge_irq);
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	} else if (type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
-		set_irq_handler(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	} else {
 		printk(KERN_ERR "failed to set irq=%d (type=%d)\n",
 		       d->irq, type);
@@ -480,7 +477,7 @@ void __init orion_gpio_init(int gpio_bas
 		set_irq_chip(irq, &orion_gpio_irq_chip);
 		set_irq_handler(irq, handle_level_irq);
 		set_irq_chip_data(irq, ochip);
-		irq_desc[irq].status |= IRQ_LEVEL;
+		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
@@ -488,7 +485,7 @@ void __init orion_gpio_init(int gpio_bas
 void orion_gpio_irq_handler(int pinoff)
 {
 	struct orion_gpio_chip *ochip;
-	u32 cause;
+	u32 cause, type;
 	int i;
 
 	ochip = orion_gpio_chip_find(pinoff);
@@ -500,15 +497,14 @@ void orion_gpio_irq_handler(int pinoff)
 
 	for (i = 0; i < ochip->chip.ngpio; i++) {
 		int irq;
-		struct irq_desc *desc;
 
 		irq = ochip->secondary_irq_base + i;
 
 		if (!(cause & (1 << i)))
 			continue;
 
-		desc = irq_desc + irq;
-		if ((desc->status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+		type = irqd_get_trigger_type(irq_get_irq_data(irq));
+		if ((type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 			/* Swap polarity (race with GPIO line) */
 			u32 polarity;
 
@@ -516,7 +512,6 @@ void orion_gpio_irq_handler(int pinoff)
 			polarity ^= 1 << i;
 			writel(polarity, GPIO_IN_POL(ochip));
 		}
-
-		desc_handle_irq(irq, desc);
+		generic_handle_irq(irq);
 	}
 }
Index: linux-2.6-tip/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6-tip/arch/arm/plat-orion/irq.c
@@ -59,7 +59,7 @@ void __init orion_irq_init(unsigned int 
 		set_irq_chip(irq, &orion_irq_chip);
 		set_irq_chip_data(irq, maskaddr);
 		set_irq_handler(irq, handle_level_irq);
-		irq_desc[irq].status |= IRQ_LEVEL;
+		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }


