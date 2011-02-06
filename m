Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1BFQbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:31:10 -0500
Received: from www.tglx.de ([62.245.132.106]:41510 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1BFQao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:30:44 -0500
Message-Id: <20110206163009.190112353@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 16:30:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [patch 3/4] avr32: at32ap: Convert pop irq_chip to new functions
References: <20110206162900.250401028@linutronix.de>
Content-Disposition: inline; filename=avr32-at32ap-pio-convert-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also replace the open coded handler call with the proper wrapper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/mach-at32ap/pio.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Index: linux-next/arch/avr32/mach-at32ap/pio.c
===================================================================
--- linux-next.orig/arch/avr32/mach-at32ap/pio.c
+++ linux-next/arch/avr32/mach-at32ap/pio.c
@@ -249,23 +249,23 @@ static void gpio_set(struct gpio_chip *c
 
 /* GPIO IRQ support */
 
-static void gpio_irq_mask(unsigned irq)
+static void gpio_irq_mask(struct irq_data *d)
 {
-	unsigned		gpio = irq_to_gpio(irq);
+	unsigned		gpio = irq_to_gpio(d->irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
 }
 
-static void gpio_irq_unmask(unsigned irq)
+static void gpio_irq_unmask(struct irq_data *d))
 {
-	unsigned		gpio = irq_to_gpio(irq);
+	unsigned		gpio = irq_to_gpio(d->irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IER, 1 << (gpio & 0x1f));
 }
 
-static int gpio_irq_type(unsigned irq, unsigned type)
+static int gpio_irq_type(struct irq_data *d, unsigned type)
 {
 	if (type != IRQ_TYPE_EDGE_BOTH && type != IRQ_TYPE_NONE)
 		return -EINVAL;
@@ -275,20 +275,19 @@ static int gpio_irq_type(unsigned irq, u
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "gpio",
-	.mask		= gpio_irq_mask,
-	.unmask		= gpio_irq_unmask,
-	.set_type	= gpio_irq_type,
+	.irq_mask	= gpio_irq_mask,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_set_type	= gpio_irq_type,
 };
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct pio_device	*pio = get_irq_chip_data(irq);
+	struct pio_device	*pio = get_irq_desc_chip_data(desc);
 	unsigned		gpio_irq;
 
 	gpio_irq = (unsigned) get_irq_data(irq);
 	for (;;) {
 		u32		isr;
-		struct irq_desc	*d;
 
 		/* ack pending GPIO interrupts */
 		isr = pio_readl(pio, ISR) & pio_readl(pio, IMR);
@@ -301,9 +300,7 @@ static void gpio_irq_handler(unsigned ir
 			isr &= ~(1 << i);
 
 			i += gpio_irq;
-			d = &irq_desc[i];
-
-			d->handle_irq(i, d);
+			generic_handle_irq(i);
 		} while (isr);
 	}
 }


