Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2KLTI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 14:08:57 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:35901 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KLTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:08:51 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, sameo@linux.intel.com
Subject: =?UTF-8?q?=5BRESEND=20PATCH=20v3=202/4=5D=20mfd=3A=20introduce=20retu-mfd=20driver?=
Date: Mon, 12 Nov 2012 21:08:43 +0200
Message-Id: <1352747326-2195-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352747326-2195-1-git-send-email-aaro.koskinen@iki.fi>
References: <1352747326-2195-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retu is a multi-function device found on Nokia Internet Tablets
implementing at least watchdog, RTC, headset detection and power button
functionality.

This patch implements minimum functionality providing register access,
IRQ handling and power off functions.

Cc: sameo@linux.intel.com
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/mfd/Kconfig      |    9 ++
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/retu-mfd.c   |  264 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/retu.h |   22 ++++
 4 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/retu-mfd.c
 create mode 100644 include/linux/mfd/retu.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acab3ef..7528c5e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1044,6 +1044,15 @@ config MFD_PALMAS
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
 
+config MFD_RETU
+	tristate "Support for Retu multi-function device"
+	select MFD_CORE
+	depends on I2C
+	select REGMAP_IRQ
+	help
+	  Retu is a multi-function device found on Nokia Internet Tablets
+	  (770, N800 and N810).
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d8ccb63..ad7879f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -138,3 +138,4 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
+obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
new file mode 100644
index 0000000..7ff4a37
--- /dev/null
+++ b/drivers/mfd/retu-mfd.c
@@ -0,0 +1,264 @@
+/*
+ * Retu MFD driver
+ *
+ * Copyright (C) 2004, 2005 Nokia Corporation
+ *
+ * Based on code written by Juha Yrjölä, David Weinehall and Mikko Ylinen.
+ * Rewritten by Aaro Koskinen.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/retu.h>
+#include <linux/interrupt.h>
+#include <linux/moduleparam.h>
+
+/* Registers */
+#define RETU_REG_ASICR		0x00		/* ASIC ID and revision */
+#define RETU_REG_ASICR_VILMA	(1 << 7)	/* Bit indicating Vilma */
+#define RETU_REG_IDR		0x01		/* Interrupt ID */
+#define RETU_REG_IMR		0x02		/* Interrupt mask */
+
+/* Interrupt sources */
+#define RETU_INT_PWR		0		/* Power button */
+
+struct retu_dev {
+	struct regmap			*regmap;
+	struct device			*dev;
+	struct mutex			mutex;
+	struct regmap_irq_chip_data	*irq_data;
+};
+
+static struct resource retu_pwrbutton_res[] = {
+	{
+		.name	= "retu-pwrbutton",
+		.start	= RETU_INT_PWR,
+		.end	= RETU_INT_PWR,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell retu_devs[] = {
+	{
+		.name		= "retu-wdt"
+	},
+	{
+		.name		= "retu-pwrbutton",
+		.resources	= retu_pwrbutton_res,
+		.num_resources	= ARRAY_SIZE(retu_pwrbutton_res),
+	}
+};
+
+static struct regmap_irq retu_irqs[] = {
+	[RETU_INT_PWR] = {
+		.mask = 1 << RETU_INT_PWR,
+	}
+};
+
+static struct regmap_irq_chip retu_irq_chip = {
+	.name		= "RETU",
+	.irqs		= retu_irqs,
+	.num_irqs	= ARRAY_SIZE(retu_irqs),
+	.num_regs	= 1,
+	.status_base	= RETU_REG_IDR,
+	.mask_base	= RETU_REG_IMR,
+	.ack_base	= RETU_REG_IDR,
+};
+
+/* Retu device registered for the power off. */
+static struct retu_dev *retu_pm_power_off;
+
+int retu_read(struct retu_dev *rdev, u8 reg)
+{
+	int ret;
+	int value;
+
+	mutex_lock(&rdev->mutex);
+	ret = regmap_read(rdev->regmap, reg, &value);
+	mutex_unlock(&rdev->mutex);
+
+	return ret ? ret : value;
+}
+EXPORT_SYMBOL_GPL(retu_read);
+
+int retu_write(struct retu_dev *rdev, u8 reg, u16 data)
+{
+	int ret;
+
+	mutex_lock(&rdev->mutex);
+	ret = regmap_write(rdev->regmap, reg, data);
+	mutex_unlock(&rdev->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(retu_write);
+
+static void retu_power_off(void)
+{
+	struct retu_dev *rdev = retu_pm_power_off;
+	int reg;
+
+	mutex_lock(&retu_pm_power_off->mutex);
+
+	/* Ignore power button state */
+	regmap_read(rdev->regmap, RETU_REG_CC1, &reg);
+	regmap_write(rdev->regmap, RETU_REG_CC1, reg | 2);
+
+	/* Expire watchdog immediately */
+	regmap_write(rdev->regmap, RETU_REG_WATCHDOG, 0);
+
+	/* Wait for poweroff */
+	for (;;)
+		cpu_relax();
+
+	mutex_unlock(&retu_pm_power_off->mutex);
+}
+
+static int retu_regmap_read(void *context, const void *reg, size_t reg_size,
+			    void *val, size_t val_size)
+{
+	int ret;
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	BUG_ON(reg_size != 1 || val_size != 2);
+
+	ret = i2c_smbus_read_word_data(i2c, *(u8 const *)reg);
+	if (ret < 0)
+		return ret;
+
+	*(u16 *)val = ret;
+	return 0;
+}
+
+static int retu_regmap_write(void *context, const void *data, size_t count)
+{
+	u8 reg;
+	u16 val;
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	BUG_ON(count != sizeof(reg) + sizeof(val));
+	memcpy(&reg, data, sizeof(reg));
+	memcpy(&val, data + sizeof(reg), sizeof(val));
+	return i2c_smbus_write_word_data(i2c, reg, val);
+}
+
+static struct regmap_bus retu_bus = {
+	.read = retu_regmap_read,
+	.write = retu_regmap_write,
+	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
+};
+
+static struct regmap_config retu_config = {
+	.reg_bits = 8,
+	.val_bits = 16,
+};
+
+static int __devinit retu_probe(struct i2c_client *i2c,
+				const struct i2c_device_id *id)
+{
+	struct retu_dev *rdev;
+	int ret;
+
+	rdev = devm_kzalloc(&i2c->dev, sizeof(*rdev), GFP_KERNEL);
+	if (rdev == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, rdev);
+	rdev->dev = &i2c->dev;
+	mutex_init(&rdev->mutex);
+	rdev->regmap = devm_regmap_init(&i2c->dev, &retu_bus, &i2c->dev,
+					&retu_config);
+	if (IS_ERR(rdev->regmap))
+		return PTR_ERR(rdev->regmap);
+
+	ret = retu_read(rdev, RETU_REG_ASICR);
+	if (ret < 0) {
+		dev_err(rdev->dev, "could not read Retu revision: %d\n", ret);
+		return ret;
+	}
+
+	dev_info(rdev->dev, "Retu%s v%d.%d found\n",
+		 (ret & RETU_REG_ASICR_VILMA) ? " & Vilma" : "",
+		 (ret >> 4) & 0x7, ret & 0xf);
+
+	/* Mask all RETU interrupts. */
+	ret = retu_write(rdev, RETU_REG_IMR, 0xffff);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_add_irq_chip(rdev->regmap, i2c->irq, IRQF_ONESHOT, -1,
+				  &retu_irq_chip, &rdev->irq_data);
+	if (ret < 0)
+		return ret;
+
+	ret = mfd_add_devices(rdev->dev, -1, retu_devs, ARRAY_SIZE(retu_devs),
+			      NULL, regmap_irq_chip_get_base(rdev->irq_data),
+			      NULL);
+	if (ret < 0) {
+		regmap_del_irq_chip(i2c->irq, rdev->irq_data);
+		return ret;
+	}
+
+	if (!pm_power_off) {
+		retu_pm_power_off = rdev;
+		pm_power_off	  = retu_power_off;
+	}
+
+	return 0;
+}
+
+static int __devexit retu_remove(struct i2c_client *i2c)
+{
+	struct retu_dev *rdev = i2c_get_clientdata(i2c);
+
+	if (retu_pm_power_off == rdev) {
+		pm_power_off	  = NULL;
+		retu_pm_power_off = NULL;
+	}
+	mfd_remove_devices(rdev->dev);
+	regmap_del_irq_chip(i2c->irq, rdev->irq_data);
+
+	return 0;
+}
+
+static const struct i2c_device_id retu_id[] = {
+	{ "retu-mfd", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, retu_id);
+
+static struct i2c_driver retu_driver = {
+	.driver		= {
+		.name = "retu-mfd",
+		.owner = THIS_MODULE,
+	},
+	.probe		= retu_probe,
+	.remove		= retu_remove,
+	.id_table	= retu_id,
+};
+module_i2c_driver(retu_driver);
+
+MODULE_DESCRIPTION("Retu MFD driver");
+MODULE_AUTHOR("Juha Yrjölä");
+MODULE_AUTHOR("David Weinehall");
+MODULE_AUTHOR("Mikko Ylinen");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/retu.h b/include/linux/mfd/retu.h
new file mode 100644
index 0000000..1e2715d
--- /dev/null
+++ b/include/linux/mfd/retu.h
@@ -0,0 +1,22 @@
+/*
+ * Retu MFD driver interface
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef __LINUX_MFD_RETU_H
+#define __LINUX_MFD_RETU_H
+
+struct retu_dev;
+
+int retu_read(struct retu_dev *, u8);
+int retu_write(struct retu_dev *, u8, u16);
+
+/* Registers */
+#define RETU_REG_WATCHDOG	0x17		/* Watchdog */
+#define RETU_REG_CC1		0x0d		/* Common control register 1 */
+#define RETU_REG_STATUS		0x16		/* Status register */
+
+#endif /* __LINUX_MFD_RETU_H */
-- 
1.7.2.5

