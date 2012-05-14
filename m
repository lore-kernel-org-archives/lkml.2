Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2ENHUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:20:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1727 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2ENHUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:20:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 14 May 2012 00:20:38 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <paul.gortmaker@windriver.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] gpio: rc5t583: add gpio driver for RICOH PMIC RC5T583
Date: Mon, 14 May 2012 12:46:12 +0530
Message-ID: <1336979772-4139-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMIC device RC5T583 from RICOH supports 8 gpios.
Adding gpio driver for this device to access the pins
control through gpio library.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Removing init flags through platform data.
- Configuring pins to gpio mode in direction_* functions.

 drivers/gpio/Kconfig        |    9 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-rc5t583.c |  185 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rc5t583.h |    2 +
 4 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-rc5t583.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0833ed5..34899cd 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -306,6 +306,15 @@ config GPIO_PCF857X
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
index ad96381..58897a8 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
+obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
diff --git a/drivers/gpio/gpio-rc5t583.c b/drivers/gpio/gpio-rc5t583.c
new file mode 100644
index 0000000..b5459c1
--- /dev/null
+++ b/drivers/gpio/gpio-rc5t583.c
@@ -0,0 +1,185 @@
+/*
+ * GPIO driver for RICOH583 power management chip.
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+struct rc5t583_gpio {
+	struct gpio_chip gpio_chip;
+	struct rc5t583 *rc5t583;
+};
+
+static inline struct rc5t583_gpio *to_rc5t583_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct rc5t583_gpio, gpio_chip);
+}
+
+static int rc5t583_gpio_get(struct gpio_chip *gc, unsigned int offset)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+	struct device *parent = rc5t583_gpio->rc5t583->dev;
+	uint8_t val = 0;
+	int ret;
+
+	ret = rc5t583_read(parent, RC5T583_GPIO_MON_IOIN, &val);
+	if (ret < 0)
+		return ret;
+
+	return !!(val & BIT(offset));
+}
+
+static void rc5t583_gpio_set(struct gpio_chip *gc, unsigned int offset, int val)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+	struct device *parent = rc5t583_gpio->rc5t583->dev;
+	if (val)
+		rc5t583_set_bits(parent, RC5T583_GPIO_IOOUT, BIT(offset));
+	else
+		rc5t583_clear_bits(parent, RC5T583_GPIO_IOOUT, BIT(offset));
+}
+
+static int rc5t583_gpio_dir_input(struct gpio_chip *gc, unsigned int offset)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+	struct device *parent = rc5t583_gpio->rc5t583->dev;
+	int ret;
+
+	ret = rc5t583_clear_bits(parent, RC5T583_GPIO_IOSEL, BIT(offset));
+	if (ret < 0)
+		return ret;
+
+	/* Set pin to gpio mode */
+	return rc5t583_clear_bits(parent, RC5T583_GPIO_PGSEL, BIT(offset));
+}
+
+static int rc5t583_gpio_dir_output(struct gpio_chip *gc, unsigned offset,
+			int value)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+	struct device *parent = rc5t583_gpio->rc5t583->dev;
+	int ret;
+
+	rc5t583_gpio_set(gc, offset, value);
+	ret = rc5t583_set_bits(parent, RC5T583_GPIO_IOSEL, BIT(offset));
+	if (ret < 0)
+		return ret;
+
+	/* Set pin to gpio mode */
+	return rc5t583_clear_bits(parent, RC5T583_GPIO_PGSEL, BIT(offset));
+}
+
+static int rc5t583_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+
+	if ((offset >= 0) && (offset < 8))
+		return rc5t583_gpio->rc5t583->irq_base +
+				RC5T583_IRQ_GPIO0 + offset;
+	return -EINVAL;
+}
+
+static void rc5t583_gpio_free(struct gpio_chip *gc, unsigned offset)
+{
+	struct rc5t583_gpio *rc5t583_gpio = to_rc5t583_gpio(gc);
+	struct device *parent = rc5t583_gpio->rc5t583->dev;
+
+	rc5t583_set_bits(parent, RC5T583_GPIO_PGSEL, BIT(offset));
+}
+
+static int __devinit rc5t583_gpio_probe(struct platform_device *pdev)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(pdev->dev.parent);
+	struct rc5t583_platform_data *pdata = dev_get_platdata(rc5t583->dev);
+	struct rc5t583_gpio *rc5t583_gpio;
+	int ret;
+
+	rc5t583_gpio = devm_kzalloc(&pdev->dev, sizeof(*rc5t583_gpio),
+					GFP_KERNEL);
+	if (!rc5t583_gpio) {
+		dev_warn(&pdev->dev, "Mem allocation for rc5t583_gpio failed");
+		return -ENOMEM;
+	}
+
+	rc5t583_gpio->gpio_chip.label		= "gpio-rc5t583",
+	rc5t583_gpio->gpio_chip.owner		= THIS_MODULE,
+	rc5t583_gpio->gpio_chip.free		= rc5t583_gpio_free,
+	rc5t583_gpio->gpio_chip.direction_input  = rc5t583_gpio_dir_input,
+	rc5t583_gpio->gpio_chip.direction_output = rc5t583_gpio_dir_output,
+	rc5t583_gpio->gpio_chip.set		= rc5t583_gpio_set,
+	rc5t583_gpio->gpio_chip.get		= rc5t583_gpio_get,
+	rc5t583_gpio->gpio_chip.to_irq		= rc5t583_gpio_to_irq,
+	rc5t583_gpio->gpio_chip.ngpio		= RC5T583_MAX_GPIO,
+	rc5t583_gpio->gpio_chip.can_sleep	= 1,
+	rc5t583_gpio->gpio_chip.dev		= &pdev->dev;
+
+	if (pdata && pdata->gpio_base)
+		rc5t583_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		rc5t583_gpio->gpio_chip.base = -1;
+
+	rc5t583_gpio->rc5t583 = rc5t583;
+
+	platform_set_drvdata(pdev, rc5t583_gpio);
+
+	ret = gpiochip_add(&rc5t583_gpio->gpio_chip);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Could not register gpio %d\n", ret);
+
+	return ret;
+}
+
+static int __devexit rc5t583_gpio_remove(struct platform_device *pdev)
+{
+	struct rc5t583_gpio *rc5t583_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&rc5t583_gpio->gpio_chip);
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
index c42fe92..3661c59 100644
--- a/include/linux/mfd/rc5t583.h
+++ b/include/linux/mfd/rc5t583.h
@@ -292,6 +292,7 @@ struct rc5t583 {
  * rc5t583_platform_data: Platform data for ricoh rc5t583 pmu.
  * The board specific data is provided through this structure.
  * @irq_base: Irq base number on which this device registers their interrupts.
+ * @gpio_base: GPIO base from which gpio of this device will start.
  * @enable_shutdown: Enable shutdown through the input pin "shutdown".
  * @regulator_deepsleep_slot: The slot number on which device goes to sleep
  *		in device sleep mode.
@@ -303,6 +304,7 @@ struct rc5t583 {
 
 struct rc5t583_platform_data {
 	int		irq_base;
+	int		gpio_base;
 	bool		enable_shutdown;
 	int		regulator_deepsleep_slot[RC5T583_REGULATOR_MAX];
 	unsigned long	regulator_ext_pwr_control[RC5T583_REGULATOR_MAX];
-- 
1.7.1.1

