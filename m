Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2DIIgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:36:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10260 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2DIIgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:36:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Apr 2012 01:36:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/2] gpio: Add gpio driver for RICOH PMIC RC5T583
Date: Mon,  9 Apr 2012 13:55:54 +0530
Message-Id: <1333959955-968-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
References: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMIC device RC5T583 from RICOH supports 8 gpios.
Adding gpio driver for this device to access the pins
control through gpio library.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/Kconfig        |    9 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-rc5t583.c |  195 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rc5t583.h |    9 ++
 4 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-rc5t583.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..4e1bd9e 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -288,6 +288,15 @@ config GPIO_PCF857X
 	  This driver provides an in-kernel interface to those GPIOs using
 	  platform-neutral GPIO calls.
 
+config GPIO_RC5T583
+	bool "RICOH RC5T583 GPIO"
+	depends on MFD_RC5T583
+	help
+	  Select this option to enable GPIO driver for the Ricoh RC5T583
+	  chip family.
+	  This driver provides the support for driving/reading the gpio pins
+	  of RC5T583 device through standard gpio library.
+
 config GPIO_SX150X
 	bool "Semtech SX150x I2C GPIO expander"
 	depends on I2C=y
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 007f54b..a27bf53 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
+obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
diff --git a/drivers/gpio/gpio-rc5t583.c b/drivers/gpio/gpio-rc5t583.c
new file mode 100644
index 0000000..4990789
--- /dev/null
+++ b/drivers/gpio/gpio-rc5t583.c
@@ -0,0 +1,195 @@
+/*
+ * GPIO driver for RICOH583 power management chip.
+ *
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Laxman dewangan <ldewangan@nvidia.com>
+ *
+ * Based on code
+ *	Copyright (C) 2011 RICOH COMPANY,LTD
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/mfd/rc5t583.h>
+
+static int rc5t583_gpio_get(struct gpio_chip *chip, unsigned int offset)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	uint8_t val;
+	int ret;
+
+	ret = rc5t583_read(rc5t583->dev, RC5T583_GPIO_MON_IOIN, &val);
+	if (ret < 0)
+		return ret;
+
+	return !!(val & BIT(offset));
+}
+
+static void rc5t583_gpio_set(struct gpio_chip *chip, unsigned int offset,
+			int value)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	if (value)
+		rc5t583_set_bits(rc5t583->dev, RC5T583_GPIO_IOOUT, BIT(offset));
+	else
+		rc5t583_clear_bits(rc5t583->dev, RC5T583_GPIO_IOOUT,
+					BIT(offset));
+}
+
+static int rc5t583_gpio_input(struct gpio_chip *chip, unsigned int offset)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	return rc5t583_clear_bits(rc5t583->dev, RC5T583_GPIO_IOSEL,
+					BIT(offset));
+}
+
+static int rc5t583_gpio_output(struct gpio_chip *chip, unsigned offset,
+				int value)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	rc5t583_gpio_set(chip, offset, value);
+	return rc5t583_set_bits(rc5t583->dev, RC5T583_GPIO_IOSEL, BIT(offset));
+}
+
+static int rc5t583_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	if ((offset >= 0) && (offset < 8))
+		return rc5t583->irq_base + RC5T583_IRQ_GPIO0 + offset;
+	return -EINVAL;
+}
+
+static int rc5t583_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	return rc5t583_clear_bits(rc5t583->dev, RC5T583_GPIO_PGSEL,
+					BIT(offset));
+}
+
+static void rc5t583_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(chip->dev);
+	rc5t583_set_bits(rc5t583->dev, RC5T583_GPIO_PGSEL, BIT(offset));
+}
+
+static int __devinit rc5t583_gpio_probe(struct platform_device *pdev)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(pdev->dev.parent);
+	struct rc5t583_platform_data *pdata = dev_get_platdata(rc5t583->dev);
+	int ret;
+	int i;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data, exiting...\n");
+		return -ENODEV;
+	}
+	if (pdata->gpio_base <= 0) {
+		dev_err(&pdev->dev,
+			"GPIO base is not valid %d\n", pdata->gpio_base);
+		return -EINVAL;
+	}
+
+	rc5t583->gpio_chip = devm_kzalloc(rc5t583->dev,
+				sizeof(struct gpio_chip), GFP_KERNEL);
+	if (!rc5t583->gpio_chip) {
+		dev_warn(rc5t583->dev,
+			"%s(): Memory allocation error\n", __func__);
+		return -ENOMEM;
+	}
+
+	rc5t583->gpio_chip->label		= "gpio-rc5t583",
+	rc5t583->gpio_chip->owner		= THIS_MODULE,
+	rc5t583->gpio_chip->request		= rc5t583_gpio_request,
+	rc5t583->gpio_chip->free		= rc5t583_gpio_free,
+	rc5t583->gpio_chip->direction_input	= rc5t583_gpio_input,
+	rc5t583->gpio_chip->direction_output	= rc5t583_gpio_output,
+	rc5t583->gpio_chip->set			= rc5t583_gpio_set,
+	rc5t583->gpio_chip->get			= rc5t583_gpio_get,
+	rc5t583->gpio_chip->to_irq		= rc5t583_gpio_to_irq,
+	rc5t583->gpio_chip->ngpio		= RC5T583_MAX_GPIO,
+	rc5t583->gpio_chip->can_sleep		= 1,
+	rc5t583->gpio_chip->dev			= &pdev->dev;
+	rc5t583->gpio_chip->base		= pdata->gpio_base;
+
+	platform_set_drvdata(pdev, rc5t583);
+
+	for (i = 0; i < RC5T583_MAX_GPIO; ++i) {
+		if (pdata->gpio_enable_pulldn[i])
+			ret = rc5t583_set_bits(rc5t583->dev,
+					RC5T583_GPIO_PDEN, BIT(i));
+		else
+			ret = rc5t583_clear_bits(rc5t583->dev,
+					RC5T583_GPIO_PDEN, BIT(i));
+		if (ret < 0)
+			goto end;
+
+		if (pdata->gpio_init_flag[i] & GPIOF_IN)
+			ret = rc5t583_gpio_input(rc5t583->gpio_chip, i);
+		else
+			ret = rc5t583_gpio_output(rc5t583->gpio_chip, i,
+				!!(pdata->gpio_init_flag[i] & GPIOF_INIT_HIGH));
+		if (ret < 0)
+			goto end;
+
+		ret = rc5t583_clear_bits(rc5t583->dev, RC5T583_GPIO_PGSEL,
+						BIT(i));
+		if (ret < 0)
+			goto end;
+	}
+
+	ret = gpiochip_add(rc5t583->gpio_chip);
+	if (ret < 0)
+		goto end;
+
+	return 0;
+end:
+	dev_err(&pdev->dev, "Could not register gpio %d\n", ret);
+	return ret;
+}
+
+static int __devexit rc5t583_gpio_remove(struct platform_device *pdev)
+{
+	struct rc5t583 *rc5t583 = platform_get_drvdata(pdev);
+	return gpiochip_remove(rc5t583->gpio_chip);
+}
+
+static struct platform_driver rc5t583_gpio_driver = {
+	.driver.name    = "rc5t583-gpio",
+	.driver.owner   = THIS_MODULE,
+	.probe		= rc5t583_gpio_probe,
+	.remove		= __devexit_p(rc5t583_gpio_remove),
+};
+
+static int __init rc5t583_gpio_init(void)
+{
+	return platform_driver_register(&rc5t583_gpio_driver);
+}
+subsys_initcall(rc5t583_gpio_init);
+
+static void __exit rc5t583_gpio_exit(void)
+{
+	platform_driver_unregister(&rc5t583_gpio_driver);
+}
+module_exit(rc5t583_gpio_exit);
+
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("GPIO interface for RC5T583");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:rc5t583-gpio");
diff --git a/include/linux/mfd/rc5t583.h b/include/linux/mfd/rc5t583.h
index a2c6160..f5e64b2 100644
--- a/include/linux/mfd/rc5t583.h
+++ b/include/linux/mfd/rc5t583.h
@@ -252,6 +252,8 @@ enum {
 struct rc5t583 {
 	struct device	*dev;
 	struct regmap	*regmap;
+	int		gpio_base;
+	struct gpio_chip *gpio_chip;
 	int		chip_irq;
 	int		irq_base;
 	struct mutex	irq_lock;
@@ -270,13 +272,20 @@ struct rc5t583 {
 /*
  * rc5t583_platform_data: Platform data for ricoh rc5t583 pmu.
  * The board specific data is provided through this structure.
+ * @gpio_base: Gpio base number on which device starts its gpio.
  * @irq_base: Irq base number on which this device registers their interrupts.
  * @enable_shutdown: Enable shutdown through the input pin "shutdown".
+ * @gpio_enable_pulldn: Enable internal pull down of gpios.
+ * @gpio_init_flag: Initial gpio flag which need to be configure during gpio
+ *		registration.
  */
 
 struct rc5t583_platform_data {
+	int		gpio_base;
 	int		irq_base;
 	bool		enable_shutdown;
+	bool		gpio_enable_pulldn[RC5T583_MAX_GPIO];
+	unsigned int	gpio_init_flag[RC5T583_MAX_GPIO];
 };
 
 int rc5t583_write(struct device *dev, u8 reg, uint8_t val);
-- 
1.7.1.1

