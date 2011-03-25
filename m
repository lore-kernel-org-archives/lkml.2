Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1CYNZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:25:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:34637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578Ab1CYNWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:02 -0400
Message-Id: <20110325132048.319759599@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 10/23] arm: plat-omap: Cleanup irq_desc access
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-omap.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Core code stores the flow type already
2) Flow type is accessible in irq_data

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-omap/gpio.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6-tip/arch/arm/plat-omap/gpio.c
@@ -755,12 +755,6 @@ static int gpio_irq_type(struct irq_data
 	bank = irq_data_get_irq_chip_data(d);
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
-	if (retval == 0) {
-		struct irq_desc *desc = irq_to_desc(d->irq);
-
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= type;
-	}
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
@@ -1270,8 +1264,7 @@ static void gpio_unmask_irq(struct irq_d
 	unsigned int gpio = d->irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned int irq_mask = 1 << get_gpio_index(gpio);
-	struct irq_desc *desc = irq_to_desc(d->irq);
-	u32 trigger = desc->status & IRQ_TYPE_SENSE_MASK;
+	u32 trigger = irqd_get_trigger_type(d);
 
 	if (trigger)
 		_set_gpio_triggering(bank, get_gpio_index(gpio), trigger);


