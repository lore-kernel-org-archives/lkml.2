Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1BFVM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:12:28 -0500
Received: from www.tglx.de ([62.245.132.106]:54821 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1BFVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:12:25 -0500
Message-Id: <20110206211137.750284615@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:12:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 2/3] xtensa: Convert s6000 gpio irq_chip to new functions
References: <20110206211051.865188529@linutronix.de>
Content-Disposition: inline; filename=xtensa-convert-s6000-gpio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use proper wrappers for irq_desc access.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/variants/s6000/gpio.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-next/arch/xtensa/variants/s6000/gpio.c
===================================================================
--- linux-next.orig/arch/xtensa/variants/s6000/gpio.c
+++ linux-next/arch/xtensa/variants/s6000/gpio.c
@@ -85,30 +85,29 @@ int s6_gpio_init(u32 afsel)
 	return gpiochip_add(&gpiochip);
 }
 
-static void ack(unsigned int irq)
+static void ack(struct irq_data *d)
 {
-	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
+	writeb(1 << (d->irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
 }
 
-static void mask(unsigned int irq)
+static void mask(struct irq_data *d)
 {
 	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
-	r &= ~(1 << (irq - IRQ_BASE));
+	r &= ~(1 << (d->irq - IRQ_BASE));
 	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static void unmask(unsigned int irq)
+static void unmask(struct irq_data *d)
 {
 	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
-	m |= 1 << (irq - IRQ_BASE);
+	m |= 1 << (d->irq - IRQ_BASE);
 	writeb(m, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static int set_type(unsigned int irq, unsigned int type)
+static int set_type(struct irq_data *d, unsigned int type)
 {
-	const u8 m = 1 << (irq - IRQ_BASE);
+	const u8 m = 1 << (d->irq - IRQ_BASE);
 	irq_flow_handler_t handler;
-	struct irq_desc *desc;
 	u8 reg;
 
 	if (type == IRQ_TYPE_PROBE) {
@@ -129,8 +128,7 @@ static int set_type(unsigned int irq, un
 		handler = handle_edge_irq;
 	}
 	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
-	desc = irq_to_desc(irq);
-	desc->handle_irq = handler;
+	__set_irq_handler_unlocked(irq, handler);
 
 	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
 	if (type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING))
@@ -160,12 +158,13 @@ static u8 demux_masks[4];
 
 static void demux_irqs(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = get_irq_desc_chip(desc);
 	u8 *mask = get_irq_desc_data(desc);
 	u8 pending;
 	int cirq;
 
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	chip->mask(&desc->irq_data);
+	chip->ack(&desc->irq_data));
 	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
 	cirq = IRQ_BASE - 1;
 	while (pending) {
@@ -174,7 +173,7 @@ static void demux_irqs(unsigned int irq,
 		pending >>= n;
 		generic_handle_irq(cirq);
 	}
-	desc->chip->unmask(irq);
+	chip->unmask(&desc->irq_data));
 }
 
 extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];


