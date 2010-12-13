Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab0LMMDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:03:01 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37205 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab0LMMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:58 -0500
Date: Mon, 13 Dec 2010 13:02:56 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Baruch Siach <baruch@tkos.co.il>, David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] gpio: pl061: irq_data conversion.
Message-ID: <20101213120256.GD15575@mail.wantstofly.org>
References: <cover.1292240053.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292240053.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/gpio/pl061.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 5005990..2975d22 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -129,10 +129,10 @@ static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 /*
  * PL061 GPIO IRQ
  */
-static void pl061_irq_disable(unsigned irq)
+static void pl061_irq_disable(struct irq_data *d)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -143,10 +143,10 @@ static void pl061_irq_disable(unsigned irq)
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_enable(unsigned irq)
+static void pl061_irq_enable(struct irq_data *d)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -157,10 +157,10 @@ static void pl061_irq_enable(unsigned irq)
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static int pl061_irq_type(unsigned irq, unsigned trigger)
+static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
@@ -203,9 +203,9 @@ static int pl061_irq_type(unsigned irq, unsigned trigger)
 
 static struct irq_chip pl061_irqchip = {
 	.name		= "GPIO",
-	.enable		= pl061_irq_enable,
-	.disable	= pl061_irq_disable,
-	.set_type	= pl061_irq_type,
+	.irq_enable	= pl061_irq_enable,
+	.irq_disable	= pl061_irq_disable,
+	.irq_set_type	= pl061_irq_type,
 };
 
 static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
@@ -214,7 +214,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -229,7 +229,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->chip->unmask(irq);
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 }
 
 static int pl061_probe(struct amba_device *dev, struct amba_id *id)
-- 
1.7.1

