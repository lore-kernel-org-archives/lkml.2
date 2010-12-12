Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0LLNTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:19:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44600 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751707Ab0LLNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:19:41 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
Date: Sun, 12 Dec 2010 13:19:48 +0000
Message-Id: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being updated to pass struct irq_data to irq_chip
operations instead of an irq number. Update the ADP5588 GPIO driver to
the new API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/adp5588-gpio.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index 0871f78..a8c1e58 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -146,9 +146,9 @@ static int adp5588_gpio_to_irq(struct gpio_chip *chip, unsigned off)
 	return dev->irq_base + off;
 }
 
-static void adp5588_irq_bus_lock(unsigned int irq)
+static void adp5588_irq_bus_lock(struct irq_data *data)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(data);
 	mutex_lock(&dev->irq_lock);
 }
 
@@ -160,9 +160,9 @@ static void adp5588_irq_bus_lock(unsigned int irq)
   * and unlocks the bus.
   */
 
-static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+static void adp5588_irq_bus_sync_unlock(struct irq_data *data)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(data);
 	int i;
 
 	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
@@ -175,31 +175,31 @@ static void adp5588_irq_bus_sync_unlock(unsigned int irq)
 	mutex_unlock(&dev->irq_lock);
 }
 
-static void adp5588_irq_mask(unsigned int irq)
+static void adp5588_irq_mask(struct irq_data *data)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(data);
+	unsigned gpio = data->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
 }
 
-static void adp5588_irq_unmask(unsigned int irq)
+static void adp5588_irq_unmask(struct irq_data *data)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(data);
+	unsigned gpio = data->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
 }
 
-static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+static int adp5588_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	uint16_t gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(data);
+	uint16_t gpio = data->irq - dev->irq_base;
 	unsigned bank, bit;
 
 	if ((type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			data->irq, type);
 		return -EINVAL;
 	}
 
@@ -222,11 +222,11 @@ static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
 
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
1.7.2.3

