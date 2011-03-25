Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1CYNWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:34632 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab1CYNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:01 -0400
Message-Id: <20110325132048.226483405@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 09/23] arm: nomadik: Use local irq state
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-nomadik.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the enabled mask in the local state, so there is no need to
fiddle in the irq descriptor.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-nomadik/gpio.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-nomadik/gpio.c
+++ linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
@@ -54,6 +54,7 @@ struct nmk_gpio_chip {
 	u32 rwimsc;
 	u32 fwimsc;
 	u32 slpm;
+	u32 enabled;
 };
 
 static struct nmk_gpio_chip *
@@ -564,6 +565,11 @@ static int nmk_gpio_irq_maskunmask(struc
 	if (!nmk_chip)
 		return -EINVAL;
 
+	if (enable)
+		nmk_chip->enabled |= bitmask;
+	else
+		nmk_chip->enabled &= ~bitmask;
+
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -590,8 +596,6 @@ static void nmk_gpio_irq_unmask(struct i
 
 static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(d->irq);
-	bool enabled = !(desc->status & IRQ_DISABLED);
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 	u32 bitmask;
@@ -606,7 +610,7 @@ static int nmk_gpio_irq_set_wake(struct 
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
-	if (!enabled)
+	if (!(nmk_chip->enabled & bitmask))
 		__nmk_gpio_set_wake(nmk_chip, gpio, on);
 
 	if (on)
@@ -622,9 +626,7 @@ static int nmk_gpio_irq_set_wake(struct 
 
 static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct irq_desc *desc = irq_to_desc(d->irq);
-	bool enabled = !(desc->status & IRQ_DISABLED);
-	bool wake = desc->wake_depth;
+	bool enabled, wake = irqd_is_wakeup_set(d);
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
@@ -641,6 +643,8 @@ static int nmk_gpio_irq_set_type(struct 
 	if (type & IRQ_TYPE_LEVEL_LOW)
 		return -EINVAL;
 
+	enabled = nmk_chip->enabled & bitmask;
+
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 
 	if (enabled)


