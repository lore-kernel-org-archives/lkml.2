Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1CYN1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:27:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:34610 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386Ab1CYNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:57 -0400
Message-Id: <20110325132047.844709252@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 05/23] arm: msm: Convert to new irq chip functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-msm-convert-chip-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-msm/gpio-v2.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio-v2.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
@@ -230,18 +230,18 @@ static void msm_gpio_update_dual_edge_po
 	       val, val2);
 }
 
-static void msm_gpio_irq_ack(unsigned int irq)
+static void msm_gpio_irq_ack(struct irq_data *d)
 {
-	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
 
 	writel(BIT(INTR_STATUS), GPIO_INTR_STATUS(gpio));
 	if (test_bit(gpio, msm_gpio.dual_edge_irqs))
 		msm_gpio_update_dual_edge_pos(gpio);
 }
 
-static void msm_gpio_irq_mask(unsigned int irq)
+static void msm_gpio_irq_mask(struct irq_data *d)
 {
-	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
@@ -251,9 +251,9 @@ static void msm_gpio_irq_mask(unsigned i
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
 
-static void msm_gpio_irq_unmask(unsigned int irq)
+static void msm_gpio_irq_unmask(struct irq_data *d)
 {
-	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
@@ -263,9 +263,9 @@ static void msm_gpio_irq_unmask(unsigned
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
 
-static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
-	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
 	unsigned long irq_flags;
 	uint32_t bits;
 
@@ -309,6 +309,7 @@ static int msm_gpio_irq_set_type(unsigne
  */
 static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_data *data = irq_desc_get_irq_data(desc);
 	unsigned long i;
 
 	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
@@ -318,12 +319,12 @@ static void msm_summary_irq_handler(unsi
 			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
 							   i));
 	}
-	desc->chip->ack(irq);
+	data->chip->irq_ack(data);
 }
 
-static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 {
-	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
 
 	if (on) {
 		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
@@ -340,11 +341,11 @@ static int msm_gpio_irq_set_wake(unsigne
 
 static struct irq_chip msm_gpio_irq_chip = {
 	.name		= "msmgpio",
-	.mask		= msm_gpio_irq_mask,
-	.unmask		= msm_gpio_irq_unmask,
-	.ack		= msm_gpio_irq_ack,
-	.set_type	= msm_gpio_irq_set_type,
-	.set_wake	= msm_gpio_irq_set_wake,
+	.irq_mask	= msm_gpio_irq_mask,
+	.irq_unmask	= msm_gpio_irq_unmask,
+	.irq_ack	= msm_gpio_irq_ack,
+	.irq_set_type	= msm_gpio_irq_set_type,
+	.irq_set_wake	= msm_gpio_irq_set_wake,
 };
 
 static int __devinit msm_gpio_probe(struct platform_device *dev)


