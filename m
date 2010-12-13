Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0LMMCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:02:42 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37189 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab0LMMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:40 -0500
Date: Mon, 13 Dec 2010 13:02:39 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Michael Hennerich <michael.hennerich@analog.com>,
        Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] gpio: adp5588-gpio: irq_data conversion.
Message-ID: <20101213120239.GZ15575@mail.wantstofly.org>
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
 drivers/gpio/adp5588-gpio.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index 0871f78..33fc685 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -146,9 +146,10 @@ static int adp5588_gpio_to_irq(struct gpio_chip *chip, unsigned off)
 	return dev->irq_base + off;
 }
 
-static void adp5588_irq_bus_lock(unsigned int irq)
+static void adp5588_irq_bus_lock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+
 	mutex_lock(&dev->irq_lock);
 }
 
@@ -160,9 +161,9 @@ static void adp5588_irq_bus_lock(unsigned int irq)
   * and unlocks the bus.
   */
 
-static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+static void adp5588_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
@@ -175,31 +176,31 @@ static void adp5588_irq_bus_sync_unlock(unsigned int irq)
 	mutex_unlock(&dev->irq_lock);
 }
 
-static void adp5588_irq_mask(unsigned int irq)
+static void adp5588_irq_mask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
 }
 
-static void adp5588_irq_unmask(unsigned int irq)
+static void adp5588_irq_unmask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
 }
 
-static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+static int adp5588_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	uint16_t gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	uint16_t gpio = d->irq - dev->irq_base;
 	unsigned bank, bit;
 
 	if ((type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -222,11 +223,11 @@ static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip adp5588_irq_chip = {
 	.name			= "adp5588",
-	.mask			= adp5588_irq_mask,
-	.unmask			= adp5588_irq_unmask,
-	.bus_lock		= adp5588_irq_bus_lock,
-	.bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
-	.set_type		= adp5588_irq_set_type,
+	.irq_mask		= adp5588_irq_mask,
+	.irq_unmask		= adp5588_irq_unmask,
+	.irq_bus_lock		= adp5588_irq_bus_lock,
+	.irq_bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
+	.irq_set_type		= adp5588_irq_set_type,
 };
 
 static int adp5588_gpio_read_intstat(struct i2c_client *client, u8 *buf)
-- 
1.7.1

