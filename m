Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3ACKsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:48:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18833 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3ACKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:48:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jan 2013 02:43:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>, <akpm@linux-foundation.org>
CC: <a.zummo@towertech.it>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
Date: Thu, 3 Jan 2013 16:16:59 +0530
Message-ID: <1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio driver for TI Palmas series PMIC. This has 8 gpio which can
work as input/output.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/Kconfig       |    7 ++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-palmas.c |  184 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-palmas.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 682de75..40a0ec3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -663,6 +663,13 @@ config GPIO_AB8500
 	help
 	  Select this to enable the AB8500 IC GPIO driver
 
+config GPIO_PALMAS
+	bool "TI PALMAS series PMICs GPIO"
+	depends on MFD_PALMAS
+	help
+	  Select this option to enable GPIO driver for the TI PALMAS
+	  series chip family.
+
 config GPIO_TPS6586X
 	bool "TPS6586X GPIO"
 	depends on MFD_TPS6586X
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index c5aebd0..8962c5f 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
+obj-$(CONFIG_GPIO_PALMAS)	+= gpio-palmas.o
 obj-$(CONFIG_GPIO_TPS6586X)	+= gpio-tps6586x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
new file mode 100644
index 0000000..e3a4e56
--- /dev/null
+++ b/drivers/gpio/gpio-palmas.c
@@ -0,0 +1,184 @@
+/*
+ * TI Palma series PMIC's GPIO driver.
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
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
+ */
+
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/palmas.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+struct palmas_gpio {
+	struct gpio_chip gpio_chip;
+	struct palmas *palmas;
+};
+
+static inline struct palmas_gpio *to_palmas_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct palmas_gpio, gpio_chip);
+}
+
+static int palmas_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct palmas_gpio *pg = to_palmas_gpio(gc);
+	struct palmas *palmas = pg->palmas;
+	unsigned int val;
+	int ret;
+
+	ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_IN, &val);
+	if (ret < 0) {
+		dev_err(gc->dev, "GPIO_DATA_IN read failed, err = %d\n", ret);
+		return ret;
+	}
+	return !!(val & BIT(offset));
+}
+
+static void palmas_gpio_set(struct gpio_chip *gc, unsigned offset,
+			int value)
+{
+	struct palmas_gpio *pg = to_palmas_gpio(gc);
+	struct palmas *palmas = pg->palmas;
+	int ret;
+
+	if (value)
+		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
+				PALMAS_GPIO_SET_DATA_OUT, BIT(offset));
+	else
+		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
+				PALMAS_GPIO_CLEAR_DATA_OUT, BIT(offset));
+	if (ret < 0)
+		dev_err(gc->dev, "%s write failed, err = %d\n",
+			(value) ? "GPIO_SET_DATA_OUT" : "GPIO_CLEAR_DATA_OUT",
+			ret);
+}
+
+static int palmas_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct palmas_gpio *pg = to_palmas_gpio(gc);
+	struct palmas *palmas = pg->palmas;
+	int ret;
+
+	/* Set the initial value */
+	palmas_gpio_set(gc, offset, value);
+
+	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
+		PALMAS_GPIO_DATA_DIR, BIT(offset), BIT(offset));
+	if (ret < 0)
+		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
+	return ret;
+}
+
+static int palmas_gpio_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct palmas_gpio *pg = to_palmas_gpio(gc);
+	struct palmas *palmas = pg->palmas;
+	int ret;
+
+	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
+		PALMAS_GPIO_DATA_DIR, BIT(offset), 0);
+	if (ret < 0)
+		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
+	return ret;
+}
+
+static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct palmas_gpio *pg = to_palmas_gpio(gc);
+	struct palmas *palmas = pg->palmas;
+
+	return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
+}
+
+static int palmas_gpio_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct palmas_platform_data *palmas_pdata;
+	struct palmas_gpio *palmas_gpio;
+	int ret;
+
+	palmas_gpio = devm_kzalloc(&pdev->dev,
+				sizeof(*palmas_gpio), GFP_KERNEL);
+	if (!palmas_gpio) {
+		dev_err(&pdev->dev, "Could not allocate palmas_gpio\n");
+		return -ENOMEM;
+	}
+
+	palmas_gpio->palmas = palmas;
+	palmas_gpio->gpio_chip.owner = THIS_MODULE;
+	palmas_gpio->gpio_chip.label = dev_name(&pdev->dev);
+	palmas_gpio->gpio_chip.ngpio = 8;
+	palmas_gpio->gpio_chip.can_sleep = 1;
+	palmas_gpio->gpio_chip.direction_input = palmas_gpio_input;
+	palmas_gpio->gpio_chip.direction_output = palmas_gpio_output;
+	palmas_gpio->gpio_chip.to_irq = palmas_gpio_to_irq;
+	palmas_gpio->gpio_chip.set	= palmas_gpio_set;
+	palmas_gpio->gpio_chip.get	= palmas_gpio_get;
+	palmas_gpio->gpio_chip.dev = &pdev->dev;
+#ifdef CONFIG_OF_GPIO
+	palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
+#endif
+	palmas_pdata = dev_get_platdata(palmas->dev);
+	if (palmas_pdata && palmas_pdata->gpio_base)
+		palmas_gpio->gpio_chip.base = palmas_pdata->gpio_base;
+	else
+		palmas_gpio->gpio_chip.base = -1;
+
+	ret = gpiochip_add(&palmas_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, palmas_gpio);
+	return ret;
+}
+
+static int palmas_gpio_remove(struct platform_device *pdev)
+{
+	struct palmas_gpio *palmas_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&palmas_gpio->gpio_chip);
+}
+
+static struct platform_driver palmas_gpio_driver = {
+	.driver.name	= "palmas-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= palmas_gpio_probe,
+	.remove		= palmas_gpio_remove,
+};
+
+static int __init palmas_gpio_init(void)
+{
+	return platform_driver_register(&palmas_gpio_driver);
+}
+subsys_initcall(palmas_gpio_init);
+
+static void __exit palmas_gpio_exit(void)
+{
+	platform_driver_unregister(&palmas_gpio_driver);
+}
+module_exit(palmas_gpio_exit);
+
+MODULE_ALIAS("platform:palmas-gpio");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("GPIO driver for TI Palmas series PMICs");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

