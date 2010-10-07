Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab0JGOxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:53:13 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:39068 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615Ab0JGOxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:53:10 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 10:53:10 EDT
From: Tomas Hallenberg <tomas.hallenberg@pelagicore.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] gpio: timbgpio: Use a copy of the IER register to avoid it being trashed
Date: Thu, 7 Oct 2010 16:46:30 +0200
Message-Id: <C8039000-F0D0-42C4-A5DF-145769760876@pelagicore.com>
Cc: akpm@linux-foundation.org,
        =?iso-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of the hardware can trash the IER register if simultaneous
interrupts occur. This patch works around it by using a local copy of the
register and restoring it after every interrupt.

Signed-off-by: Tomas Hallenberg <tomas.hallenberg@pelagicore.com>
Acked-by: Richard Röjfors <richard.rojfors@pelagicore.com>
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index ddd0531..4529366 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -47,6 +47,7 @@ struct timbgpio {
 	spinlock_t		lock; /* mutual exclusion */
 	struct gpio_chip	gpio;
 	int			irq_base;
+	unsigned long		last_ier;
 };
 
 static int timbgpio_update_bit(struct gpio_chip *gpio, unsigned index,
@@ -112,16 +113,24 @@ static void timbgpio_irq_disable(unsigned irq)
 {
 	struct timbgpio *tgpio = get_irq_chip_data(irq);
 	int offset = irq - tgpio->irq_base;
+	unsigned long flags;
 
-	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
+	spin_lock_irqsave(&tgpio->lock, flags);
+	tgpio->last_ier &= ~(1 << offset);
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
+	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
 
 static void timbgpio_irq_enable(unsigned irq)
 {
 	struct timbgpio *tgpio = get_irq_chip_data(irq);
 	int offset = irq - tgpio->irq_base;
+	unsigned long flags;
 
-	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
+	spin_lock_irqsave(&tgpio->lock, flags);
+	tgpio->last_ier |= 1 << offset;
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
+	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
 
 static int timbgpio_irq_type(unsigned irq, unsigned trigger)
@@ -194,8 +203,16 @@ static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
+	/*
+	 * Some versions of the hardware trash the IER register if more than
+	 * one interrupt is received simultaneously.
+	 */
+	iowrite32(0, tgpio->membase + TGPIO_IER);
+
 	for_each_set_bit(offset, &ipr, tgpio->gpio.ngpio)
 		generic_handle_irq(timbgpio_to_irq(&tgpio->gpio, offset));
+
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 }
 
 static struct irq_chip timbgpio_irqchip = {

