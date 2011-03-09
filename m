Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1CIMDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:03:16 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:46858 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932113Ab1CIMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:03:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052 chips v2
Date: Wed, 9 Mar 2011 13:02:38 +0100
Message-ID: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The TPS61050/TPS61052 are boost converters, LED drivers, LED flash
drivers and a simple GPIO pin chips.

Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jonas Aberg <jonas.aberg@stericsson.com>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig          |    9 ++
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/tps6105x.c       |  244 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6105x.h |   95 ++++++++++++++++
 4 files changed, 349 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps6105x.c
 create mode 100644 include/linux/mfd/tps6105x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..35b085a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -118,6 +118,15 @@ config UCB1400_CORE
 	  To compile this driver as a module, choose M here: the
 	  module will be called ucb1400_core.
 
+config TPS6105X
+	tristate "TPS61050/61052 Boost Converters"
+	depends on I2C
+	help
+	  This option enables a driver for the TP61050/TPS61052
+	  high-power "white LED driver". This boost converter is
+	  sometimes used for other things than white LEDs, and
+	  also contains a GPIO pin.
+
 config TPS65010
 	tristate "TPS6501x Power Management chips"
 	depends on I2C && GPIOLIB
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a54e2c7..6eb8372 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
 
+obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_TPS6507X)		+= tps6507x.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
diff --git a/drivers/mfd/tps6105x.c b/drivers/mfd/tps6105x.c
new file mode 100644
index 0000000..d5c9507
--- /dev/null
+++ b/drivers/mfd/tps6105x.c
@@ -0,0 +1,244 @@
+/*
+ * Core driver for TPS61050/61052 boost converters, used for while LED
+ * driving, audio power amplification, white LED flash, and generic
+ * boost conversion. Additionally it provides a 1-bit GPIO pin (out or in)
+ * and a flash synchronization pin to synchronize flash events when used as
+ * flashgun.
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps6105x.h>
+
+int tps6105x_set(struct tps6105x *tps6105x, u8 reg, u8 value)
+{
+	int ret;
+
+	ret = mutex_lock_interruptible(&tps6105x->lock);
+	if (ret)
+		return ret;
+	ret = i2c_smbus_write_byte_data(tps6105x->client, reg, value);
+	mutex_unlock(&tps6105x->lock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int tps6105x_get(struct tps6105x *tps6105x, u8 reg, u8 *buf)
+{
+	int ret;
+
+	ret = mutex_lock_interruptible(&tps6105x->lock);
+	if (ret)
+		return ret;
+	ret = i2c_smbus_read_byte_data(tps6105x->client, reg);
+	mutex_unlock(&tps6105x->lock);
+	if (ret < 0)
+		return ret;
+
+	*buf = ret;
+	return 0;
+}
+
+/*
+ * Masks off the bits in the mask and sets the bits in the bitvalues
+ * parameter in one atomic operation
+ */
+int tps6105x_mask_and_set(struct tps6105x *tps6105x, u8 reg,
+			  u8 bitmask, u8 bitvalues)
+{
+	int ret;
+	u8 regval;
+
+	ret = mutex_lock_interruptible(&tps6105x->lock);
+	if (ret)
+		return ret;
+	ret = i2c_smbus_read_byte_data(tps6105x->client, reg);
+	if (ret < 0)
+		goto fail;
+	regval = ret;
+	regval = (~bitmask & regval) | (bitmask & bitvalues);
+	ret = i2c_smbus_write_byte_data(tps6105x->client, reg, regval);
+fail:
+	mutex_unlock(&tps6105x->lock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int __devinit tps6105x_startup(struct tps6105x *tps6105x)
+{
+	int ret;
+	u8 regval;
+
+	ret = tps6105x_get(tps6105x, TPS6105X_REG_0, &regval);
+	if (ret)
+		return ret;
+	switch (regval >> TPS6105X_REG0_MODE_SHIFT) {
+	case TPS6105X_REG0_MODE_SHUTDOWN:
+		dev_info(&tps6105x->client->dev,
+			 "TPS6105x found in SHUTDOWN mode\n");
+		break;
+	case TPS6105X_REG0_MODE_TORCH:
+		dev_info(&tps6105x->client->dev,
+			 "TPS6105x found in TORCH mode\n");
+		break;
+	case TPS6105X_REG0_MODE_TORCH_FLASH:
+		dev_info(&tps6105x->client->dev,
+			 "TPS6105x found in FLASH mode\n");
+		break;
+	case TPS6105X_REG0_MODE_VOLTAGE:
+		dev_info(&tps6105x->client->dev,
+			 "TPS6105x found in VOLTAGE mode\n");
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * MFD cells - we have one cell which is selected operation
+ * mode, and we always have a GPIO cell.
+ */
+static struct mfd_cell tps6105x_cells[] = {
+	{
+		/* name will be runtime assigned */
+		.id = -1,
+	},
+	{
+		.name = "tps6105x-gpio",
+		.id = -1,
+	},
+};
+
+static int __devinit tps6105x_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct tps6105x			*tps6105x;
+	struct tps6105x_platform_data	*pdata;
+	int ret;
+	int i;
+
+	tps6105x = kmalloc(sizeof(*tps6105x), GFP_KERNEL);
+	if (!tps6105x)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, tps6105x);
+	tps6105x->client = client;
+	pdata = client->dev.platform_data;
+	tps6105x->pdata = pdata;
+	mutex_init(&tps6105x->lock);
+
+	ret = tps6105x_startup(tps6105x);
+	if (ret) {
+		dev_err(&client->dev, "chip initialization failed\n");
+		goto fail;
+	}
+
+	/* Remove warning texts when you implement new cell drivers */
+	switch (pdata->mode) {
+	case TPS6105X_MODE_SHUTDOWN:
+		dev_info(&client->dev,
+			 "present, not used for anything, only GPIO\n");
+		break;
+	case TPS6105X_MODE_TORCH:
+		tps6105x_cells[0].name = "tps6105x-leds";
+		dev_warn(&client->dev,
+			 "torch mode is unsupported\n");
+		break;
+	case TPS6105X_MODE_TORCH_FLASH:
+		tps6105x_cells[0].name = "tps6105x-flash";
+		dev_warn(&client->dev,
+			 "flash mode is unsupported\n");
+		break;
+	case TPS6105X_MODE_VOLTAGE:
+		tps6105x_cells[0].name ="tps6105x-regulator";
+		break;
+	default:
+		break;
+	}
+
+	/* Set up and register the platform devices. */
+	for (i = 0; i < ARRAY_SIZE(tps6105x_cells); i++) {
+		/* One state holder for all drivers, this is simple */
+		tps6105x_cells[i].driver_data = tps6105x;
+	}
+
+	ret = mfd_add_devices(&client->dev, 0, tps6105x_cells,
+		ARRAY_SIZE(tps6105x_cells), NULL, 0);
+	if (ret)
+		goto fail;
+
+	return 0;
+
+fail:
+	i2c_set_clientdata(client, NULL);
+	kfree(tps6105x);
+	return ret;
+}
+
+static int __devexit tps6105x_remove(struct i2c_client *client)
+{
+	struct tps6105x *tps6105x = i2c_get_clientdata(client);
+
+	mfd_remove_devices(&client->dev);
+
+	/* Put chip in shutdown mode */
+	tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
+		TPS6105X_REG0_MODE_MASK,
+		TPS6105X_MODE_SHUTDOWN << TPS6105X_REG0_MODE_SHIFT);
+
+	kfree(tps6105x);
+	return 0;
+}
+
+static const struct i2c_device_id tps6105x_id[] = {
+	{ "tps61050", 0 },
+	{ "tps61052", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tps6105x_id);
+
+static struct i2c_driver tps6105x_driver = {
+	.driver = {
+		.name	= "tps6105x",
+	},
+	.probe		= tps6105x_probe,
+	.remove		= __devexit_p(tps6105x_remove),
+	.id_table	= tps6105x_id,
+};
+
+static int __init tps6105x_init(void)
+{
+	return i2c_add_driver(&tps6105x_driver);
+}
+subsys_initcall(tps6105x_init);
+
+static void __exit tps6105x_exit(void)
+{
+	i2c_del_driver(&tps6105x_driver);
+}
+module_exit(tps6105x_exit);
+
+MODULE_AUTHOR("Linus Walleij");
+MODULE_DESCRIPTION("TPS6105x White LED Boost Converter Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/tps6105x.h b/include/linux/mfd/tps6105x.h
new file mode 100644
index 0000000..f259244
--- /dev/null
+++ b/include/linux/mfd/tps6105x.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef MFD_TPS6105X_H
+#define MFD_TPS6105X_H
+
+#include <linux/i2c.h>
+
+/*
+ * Register definitions to all subdrivers
+ */
+#define TPS6105X_REG_0			0x00
+#define TPS6105X_REG0_MODE_SHIFT	6
+#define TPS6105X_REG0_MODE_MASK		(0x03<<6)
+/* These defines for both reg0 and reg1 */
+#define TPS6105X_REG0_MODE_SHUTDOWN	0x00
+#define TPS6105X_REG0_MODE_TORCH	0x01
+#define TPS6105X_REG0_MODE_TORCH_FLASH	0x02
+#define TPS6105X_REG0_MODE_VOLTAGE	0x03
+#define TPS6105X_REG0_VOLTAGE_SHIFT	4
+#define TPS6105X_REG0_VOLTAGE_MASK	(3<<4)
+#define TPS6105X_REG0_VOLTAGE_450	0
+#define TPS6105X_REG0_VOLTAGE_500	1
+#define TPS6105X_REG0_VOLTAGE_525	2
+#define TPS6105X_REG0_VOLTAGE_500_2	3
+#define TPS6105X_REG0_DIMMING_SHIFT	3
+#define TPS6105X_REG0_TORCHC_SHIFT	0
+#define TPS6105X_REG0_TORCHC_MASK	(7<<0)
+#define TPS6105X_REG0_TORCHC_0		0x00
+#define TPS6105X_REG0_TORCHC_50		0x01
+#define TPS6105X_REG0_TORCHC_75		0x02
+#define TPS6105X_REG0_TORCHC_100	0x03
+#define TPS6105X_REG0_TORCHC_150	0x04
+#define TPS6105X_REG0_TORCHC_200	0x05
+#define TPS6105X_REG0_TORCHC_250_400	0x06
+#define TPS6105X_REG0_TORCHC_250_500	0x07
+#define TPS6105X_REG_1			0x01
+#define TPS6105X_REG1_MODE_SHIFT	6
+#define TPS6105X_REG1_MODE_MASK		(0x03<<6)
+#define TPS6105X_REG1_MODE_SHUTDOWN	0x00
+#define TPS6105X_REG1_MODE_TORCH	0x01
+#define TPS6105X_REG1_MODE_TORCH_FLASH	0x02
+#define TPS6105X_REG1_MODE_VOLTAGE	0x03
+#define TPS6105X_REG_2			0x02
+#define TPS6105X_REG_3			0x03
+
+/**
+ * enum tps6105x_mode - desired mode for the TPS6105x
+ * @TPS6105X_MODE_SHUTDOWN: this instance is inactive, not used for anything
+ * @TPS61905X_MODE_TORCH: this instance is used as a LED, usually a while
+ *	LED, for example as backlight or flashlight. If this is set, the
+ *	TPS6105X will register to the LED framework
+ * @TPS6105X_MODE_TORCH_FLASH: this instance is used as a flashgun, usually
+ *	in a camera
+ * @TPS6105X_MODE_VOLTAGE: this instance is used as a voltage regulator and
+ *	will register to the regulator framework
+ */
+enum tps6105x_mode {
+	TPS6105X_MODE_SHUTDOWN,
+	TPS6105X_MODE_TORCH,
+	TPS6105X_MODE_TORCH_FLASH,
+	TPS6105X_MODE_VOLTAGE,
+};
+
+/**
+ * struct tps6105x_platform_data - TPS61905x platform data
+ * @mode: what mode this instance shall be operated in,
+ *	this is not selectable at runtime
+ */
+struct tps6105x_platform_data {
+	enum tps6105x_mode mode;
+};
+
+/**
+ * struct tps6105x - state holder for the TPS6105x drivers
+ * @mutex: mutex to serialize I2C accesses
+ * @i2c_client: corresponding I2C client
+ */
+struct tps6105x {
+	struct tps6105x_platform_data *pdata;
+	struct mutex		lock;
+	struct i2c_client	*client;
+};
+
+extern int tps6105x_set(struct tps6105x *tps6105x, u8 reg, u8 value);
+extern int tps6105x_get(struct tps6105x *tps6105x, u8 reg, u8 *buf);
+extern int tps6105x_mask_and_set(struct tps6105x *tps6105x, u8 reg,
+				 u8 bitmask, u8 bitvalues);
+
+#endif
-- 
1.7.3.2

