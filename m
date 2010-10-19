Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0JSUfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:35:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34051 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0JSUfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:35:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: device-drivers-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH v2] gpio: adp5588-gpio: support interrupt controller
Date: Tue, 19 Oct 2010 16:37:48 -0400
Message-Id: <1287520668-12913-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287442218-7265-1-git-send-email-vapier@gentoo.org>
References: <1287442218-7265-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This patch implements irq_chip functionality on ADP5588/5587 GPIO
expanders.  Only level sensitive interrupts are supported.
Interrupts provided by this irq_chip must be requested using
request_threaded_irq().

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- update feedback from akpm

 drivers/gpio/Kconfig        |    7 +
 drivers/gpio/adp5588-gpio.c |  277 +++++++++++++++++++++++++++++++++++++++----
 include/linux/i2c/adp5588.h |   15 +++
 3 files changed, 278 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7face91..cc912d2 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -249,6 +249,13 @@ config GPIO_ADP5588
 	  To compile this driver as a module, choose M here: the module will be
 	  called adp5588-gpio.
 
+config GPIO_ADP5588_IRQ
+	bool "Interrupt controller support for ADP5588"
+	depends on GPIO_ADP5588=y
+	help
+	  Say yes here to enable the adp5588 to be used as an interrupt
+	  controller. It requires the driver to be built in the kernel.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index 2e8e9e2..0871f78 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -1,8 +1,8 @@
 /*
  * GPIO Chip driver for Analog Devices
- * ADP5588 I/O Expander and QWERTY Keypad Controller
+ * ADP5588/ADP5587 I/O Expander and QWERTY Keypad Controller
  *
- * Copyright 2009 Analog Devices Inc.
+ * Copyright 2009-2010 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -13,21 +13,34 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <linux/i2c/adp5588.h>
 
-#define DRV_NAME		"adp5588-gpio"
-#define MAXGPIO			18
-#define ADP_BANK(offs)		((offs) >> 3)
-#define ADP_BIT(offs)		(1u << ((offs) & 0x7))
+#define DRV_NAME	"adp5588-gpio"
+
+/*
+ * Early pre 4.0 Silicon required to delay readout by at least 25ms,
+ * since the Event Counter Register updated 25ms after the interrupt
+ * asserted.
+ */
+#define WA_DELAYED_READOUT_REVID(rev)	((rev) < 4)
 
 struct adp5588_gpio {
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
 	struct mutex lock;	/* protect cached dir, dat_out */
+	/* protect serialized access to the interrupt controller bus */
+	struct mutex irq_lock;
 	unsigned gpio_start;
+	unsigned irq_base;
 	uint8_t dat_out[3];
 	uint8_t dir[3];
+	uint8_t int_lvl[3];
+	uint8_t int_en[3];
+	uint8_t irq_mask[3];
+	uint8_t irq_stat[3];
 };
 
 static int adp5588_gpio_read(struct i2c_client *client, u8 reg)
@@ -55,8 +68,8 @@ static int adp5588_gpio_get_value(struct gpio_chip *chip, unsigned off)
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	return !!(adp5588_gpio_read(dev->client, GPIO_DAT_STAT1 + ADP_BANK(off))
-		  & ADP_BIT(off));
+	return !!(adp5588_gpio_read(dev->client,
+		  GPIO_DAT_STAT1 + ADP5588_BANK(off)) & ADP5588_BIT(off));
 }
 
 static void adp5588_gpio_set_value(struct gpio_chip *chip,
@@ -66,8 +79,8 @@ static void adp5588_gpio_set_value(struct gpio_chip *chip,
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
-	bit = ADP_BIT(off);
+	bank = ADP5588_BANK(off);
+	bit = ADP5588_BIT(off);
 
 	mutex_lock(&dev->lock);
 	if (val)
@@ -87,10 +100,10 @@ static int adp5588_gpio_direction_input(struct gpio_chip *chip, unsigned off)
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
+	bank = ADP5588_BANK(off);
 
 	mutex_lock(&dev->lock);
-	dev->dir[bank] &= ~ADP_BIT(off);
+	dev->dir[bank] &= ~ADP5588_BIT(off);
 	ret = adp5588_gpio_write(dev->client, GPIO_DIR1 + bank, dev->dir[bank]);
 	mutex_unlock(&dev->lock);
 
@@ -105,8 +118,8 @@ static int adp5588_gpio_direction_output(struct gpio_chip *chip,
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
-	bit = ADP_BIT(off);
+	bank = ADP5588_BANK(off);
+	bit = ADP5588_BIT(off);
 
 	mutex_lock(&dev->lock);
 	dev->dir[bank] |= bit;
@@ -125,6 +138,213 @@ static int adp5588_gpio_direction_output(struct gpio_chip *chip,
 	return ret;
 }
 
+#ifdef CONFIG_GPIO_ADP5588_IRQ
+static int adp5588_gpio_to_irq(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5588_gpio *dev =
+		container_of(chip, struct adp5588_gpio, gpio_chip);
+	return dev->irq_base + off;
+}
+
+static void adp5588_irq_bus_lock(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	mutex_lock(&dev->irq_lock);
+}
+
+ /*
+  * genirq core code can issue chip->mask/unmask from atomic context.
+  * This doesn't work for slow busses where an access needs to sleep.
+  * bus_sync_unlock() is therefore called outside the atomic context,
+  * syncs the current irq mask state with the slow external controller
+  * and unlocks the bus.
+  */
+
+static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
+		if (dev->int_en[i] ^ dev->irq_mask[i]) {
+			dev->int_en[i] = dev->irq_mask[i];
+			adp5588_gpio_write(dev->client, GPIO_INT_EN1 + i,
+					   dev->int_en[i]);
+		}
+
+	mutex_unlock(&dev->irq_lock);
+}
+
+static void adp5588_irq_mask(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	unsigned gpio = irq - dev->irq_base;
+
+	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
+}
+
+static void adp5588_irq_unmask(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	unsigned gpio = irq - dev->irq_base;
+
+	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
+}
+
+static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	uint16_t gpio = irq - dev->irq_base;
+	unsigned bank, bit;
+
+	if ((type & IRQ_TYPE_EDGE_BOTH)) {
+		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
+			irq, type);
+		return -EINVAL;
+	}
+
+	bank = ADP5588_BANK(gpio);
+	bit = ADP5588_BIT(gpio);
+
+	if (type & IRQ_TYPE_LEVEL_HIGH)
+		dev->int_lvl[bank] |= bit;
+	else if (type & IRQ_TYPE_LEVEL_LOW)
+		dev->int_lvl[bank] &= ~bit;
+	else
+		return -EINVAL;
+
+	adp5588_gpio_direction_input(&dev->gpio_chip, gpio);
+	adp5588_gpio_write(dev->client, GPIO_INT_LVL1 + bank,
+			   dev->int_lvl[bank]);
+
+	return 0;
+}
+
+static struct irq_chip adp5588_irq_chip = {
+	.name			= "adp5588",
+	.mask			= adp5588_irq_mask,
+	.unmask			= adp5588_irq_unmask,
+	.bus_lock		= adp5588_irq_bus_lock,
+	.bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
+	.set_type		= adp5588_irq_set_type,
+};
+
+static int adp5588_gpio_read_intstat(struct i2c_client *client, u8 *buf)
+{
+	int ret = i2c_smbus_read_i2c_block_data(client, GPIO_INT_STAT1, 3, buf);
+
+	if (ret < 0)
+		dev_err(&client->dev, "Read INT_STAT Error\n");
+
+	return ret;
+}
+
+static irqreturn_t adp5588_irq_handler(int irq, void *devid)
+{
+	struct adp5588_gpio *dev = devid;
+	unsigned status, bank, bit, pending;
+	int ret;
+	status = adp5588_gpio_read(dev->client, INT_STAT);
+
+	if (status & ADP5588_GPI_INT) {
+		ret = adp5588_gpio_read_intstat(dev->client, dev->irq_stat);
+		if (ret < 0)
+			memset(dev->irq_stat, 0, ARRAY_SIZE(dev->irq_stat));
+
+		for (bank = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
+			bank++, bit = 0) {
+			pending = dev->irq_stat[bank] & dev->irq_mask[bank];
+
+			while (pending) {
+				if (pending & (1 << bit)) {
+					handle_nested_irq(dev->irq_base +
+							  (bank << 3) + bit);
+					pending &= ~(1 << bit);
+
+				}
+				bit++;
+			}
+		}
+	}
+
+	adp5588_gpio_write(dev->client, INT_STAT, status); /* Status is W1C */
+
+	return IRQ_HANDLED;
+}
+
+static int adp5588_irq_setup(struct adp5588_gpio *dev)
+{
+	struct i2c_client *client = dev->client;
+	struct adp5588_gpio_platform_data *pdata = client->dev.platform_data;
+	unsigned gpio;
+	int ret;
+
+	adp5588_gpio_write(client, CFG, ADP5588_AUTO_INC);
+	adp5588_gpio_write(client, INT_STAT, -1); /* status is W1C */
+	adp5588_gpio_read_intstat(client, dev->irq_stat); /* read to clear */
+
+	dev->irq_base = pdata->irq_base;
+	mutex_init(&dev->irq_lock);
+
+	for (gpio = 0; gpio < dev->gpio_chip.ngpio; gpio++) {
+		int irq = gpio + dev->irq_base;
+		set_irq_chip_data(irq, dev);
+		set_irq_chip_and_handler(irq, &adp5588_irq_chip,
+					 handle_level_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		/*
+		 * ARM needs us to explicitly flag the IRQ as VALID,
+		 * once we do so, it will also set the noprobe.
+		 */
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	ret = request_threaded_irq(client->irq,
+				   NULL,
+				   adp5588_irq_handler,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   dev_name(&client->dev), dev);
+	if (ret) {
+		dev_err(&client->dev, "failed to request irq %d\n",
+			client->irq);
+		goto out;
+	}
+
+	dev->gpio_chip.to_irq = adp5588_gpio_to_irq;
+	adp5588_gpio_write(client, CFG,
+		ADP5588_AUTO_INC | ADP5588_INT_CFG | ADP5588_GPI_INT);
+
+	return 0;
+
+out:
+	dev->irq_base = 0;
+	return ret;
+}
+
+static void adp5588_irq_teardown(struct adp5588_gpio *dev)
+{
+	if (dev->irq_base)
+		free_irq(dev->client->irq, dev);
+}
+
+#else
+static int adp5588_irq_setup(struct adp5588_gpio *dev)
+{
+	struct i2c_client *client = dev->client;
+	dev_warn(&client->dev, "interrupt support not compiled in\n");
+
+	return 0;
+}
+
+static void adp5588_irq_teardown(struct adp5588_gpio *dev)
+{
+}
+#endif /* CONFIG_GPIO_ADP5588_IRQ */
+
 static int __devinit adp5588_gpio_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -160,37 +380,46 @@ static int __devinit adp5588_gpio_probe(struct i2c_client *client,
 	gc->can_sleep = 1;
 
 	gc->base = pdata->gpio_start;
-	gc->ngpio = MAXGPIO;
+	gc->ngpio = ADP5588_MAXGPIO;
 	gc->label = client->name;
 	gc->owner = THIS_MODULE;
 
 	mutex_init(&dev->lock);
 
-
 	ret = adp5588_gpio_read(dev->client, DEV_ID);
 	if (ret < 0)
 		goto err;
 
 	revid = ret & ADP5588_DEVICE_ID_MASK;
 
-	for (i = 0, ret = 0; i <= ADP_BANK(MAXGPIO); i++) {
+	for (i = 0, ret = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++) {
 		dev->dat_out[i] = adp5588_gpio_read(client, GPIO_DAT_OUT1 + i);
 		dev->dir[i] = adp5588_gpio_read(client, GPIO_DIR1 + i);
 		ret |= adp5588_gpio_write(client, KP_GPIO1 + i, 0);
 		ret |= adp5588_gpio_write(client, GPIO_PULL1 + i,
 				(pdata->pullup_dis_mask >> (8 * i)) & 0xFF);
-
+		ret |= adp5588_gpio_write(client, GPIO_INT_EN1 + i, 0);
 		if (ret)
 			goto err;
 	}
 
+	if (pdata->irq_base) {
+		if (WA_DELAYED_READOUT_REVID(revid)) {
+			dev_warn(&client->dev, "GPIO int not supported\n");
+		} else {
+			ret = adp5588_irq_setup(dev);
+			if (ret)
+				goto err;
+		}
+	}
+
 	ret = gpiochip_add(&dev->gpio_chip);
 	if (ret)
-		goto err;
+		goto err_irq;
 
-	dev_info(&client->dev, "gpios %d..%d on a %s Rev. %d\n",
+	dev_info(&client->dev, "gpios %d..%d (IRQ Base %d) on a %s Rev. %d\n",
 			gc->base, gc->base + gc->ngpio - 1,
-			client->name, revid);
+			pdata->irq_base, client->name, revid);
 
 	if (pdata->setup) {
 		ret = pdata->setup(client, gc->base, gc->ngpio, pdata->context);
@@ -199,8 +428,11 @@ static int __devinit adp5588_gpio_probe(struct i2c_client *client,
 	}
 
 	i2c_set_clientdata(client, dev);
+
 	return 0;
 
+err_irq:
+	adp5588_irq_teardown(dev);
 err:
 	kfree(dev);
 	return ret;
@@ -222,6 +454,9 @@ static int __devexit adp5588_gpio_remove(struct i2c_client *client)
 		}
 	}
 
+	if (dev->irq_base)
+		free_irq(dev->client->irq, dev);
+
 	ret = gpiochip_remove(&dev->gpio_chip);
 	if (ret) {
 		dev_err(&client->dev, "gpiochip_remove failed %d\n", ret);
diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
index b02ff58..32dde3e 100644
--- a/include/linux/i2c/adp5588.h
+++ b/include/linux/i2c/adp5588.h
@@ -74,6 +74,20 @@
 
 #define ADP5588_DEVICE_ID_MASK	0xF
 
+ /* Configuration Register1 */
+#define ADP5588_AUTO_INC	(1 << 7)
+#define ADP5588_GPIEM_CFG	(1 << 6)
+#define ADP5588_INT_CFG		(1 << 4)
+#define ADP5588_GPI_IEN		(1 << 1)
+
+/* Interrupt Status Register */
+#define ADP5588_GPI_INT		(1 << 1)
+#define ADP5588_KE_INT		(1 << 0)
+
+#define ADP5588_MAXGPIO		18
+#define ADP5588_BANK(offs)	((offs) >> 3)
+#define ADP5588_BIT(offs)	(1u << ((offs) & 0x7))
+
 /* Put one of these structures in i2c_board_info platform_data */
 
 #define ADP5588_KEYMAPSIZE	80
@@ -129,6 +143,7 @@ struct i2c_client; /* forward declaration */
 
 struct adp5588_gpio_platform_data {
 	unsigned gpio_start;		/* GPIO Chip base # */
+	unsigned irq_base;		/* interrupt base # */
 	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
 	int	(*setup)(struct i2c_client *client,
 				int gpio, unsigned ngpio,
-- 
1.7.3.1

