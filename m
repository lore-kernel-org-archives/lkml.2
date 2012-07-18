Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2GRGao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:30:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18728 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2GRGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:30:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jul 2012 23:30:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 4/6] gpio: tps6586x: add gpio support through platform driver
Date: Wed, 18 Jul 2012 11:50:48 +0530
Message-ID: <1342592450-12488-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting the gpio driver of tps6586x to a platform
driver in place of registering the gpio through core
driver.
The motivation of the change is:
- This is inline with the mfd drivers implementation.
- This will move the related gpio support to gpio driver
  folder where all gpio related drivers are available.
  This will be easy the maintenance and enhancement is
  anything done for gpio.
- The gpio functionality can be selected through config
  variable.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
Changes V1 -> V2: 
Remove non-require header inclusion.
Changes V2 -> V3: 
No change, generated new patch for V3 series.

 drivers/gpio/Kconfig         |    7 ++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-tps6586x.c |  158 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps6586x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 502b5ea..b16c8a7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -597,6 +597,13 @@ config GPIO_AB8500
 	help
 	  Select this to enable the AB8500 IC GPIO driver
 
+config GPIO_TPS6586X
+	bool "TPS6586X GPIO"
+	depends on MFD_TPS6586X
+	help
+	  Select this option to enable GPIO driver for the TPS6586X
+	  chip family.
+
 config GPIO_TPS65910
 	bool "TPS65910 GPIO"
 	depends on MFD_TPS65910
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index d370481..153cace 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
+obj-$(CONFIG_GPIO_TPS6586X)	+= gpio-tps6586x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
diff --git a/drivers/gpio/gpio-tps6586x.c b/drivers/gpio/gpio-tps6586x.c
new file mode 100644
index 0000000..2526b3b
--- /dev/null
+++ b/drivers/gpio/gpio-tps6586x.c
@@ -0,0 +1,158 @@
+/*
+ * TI TPS6586x GPIO driver
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Laxman dewangan <ldewangan@nvidia.com>
+ *
+ * Based on tps6586x.c
+ * Copyright (c) 2010 CompuLab Ltd.
+ * Mike Rapoport <mike@compulab.co.il>
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
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/tps6586x.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+/* GPIO control registers */
+#define TPS6586X_GPIOSET1	0x5d
+#define TPS6586X_GPIOSET2	0x5e
+
+struct tps6586x_gpio {
+	struct gpio_chip gpio_chip;
+	struct device *parent;
+};
+
+static inline struct tps6586x_gpio *to_tps6586x_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct tps6586x_gpio, gpio_chip);
+}
+
+static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps6586x_gpio *tps6586x_gpio = to_tps6586x_gpio(gc);
+	uint8_t val;
+	int ret;
+
+	ret = tps6586x_read(tps6586x_gpio->parent, TPS6586X_GPIOSET2, &val);
+	if (ret)
+		return ret;
+
+	return !!(val & (1 << offset));
+}
+
+static void tps6586x_gpio_set(struct gpio_chip *gc, unsigned offset,
+			      int value)
+{
+	struct tps6586x_gpio *tps6586x_gpio = to_tps6586x_gpio(gc);
+
+	tps6586x_update(tps6586x_gpio->parent, TPS6586X_GPIOSET2,
+			value << offset, 1 << offset);
+}
+
+static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct tps6586x_gpio *tps6586x_gpio = to_tps6586x_gpio(gc);
+	uint8_t val, mask;
+
+	tps6586x_gpio_set(gc, offset, value);
+
+	val = 0x1 << (offset * 2);
+	mask = 0x3 << (offset * 2);
+
+	return tps6586x_update(tps6586x_gpio->parent, TPS6586X_GPIOSET1,
+				val, mask);
+}
+
+static int __devinit tps6586x_gpio_probe(struct platform_device *pdev)
+{
+	struct tps6586x_platform_data *pdata;
+	struct tps6586x_gpio *tps6586x_gpio;
+	int ret;
+
+	pdata = dev_get_platdata(pdev->dev.parent);
+	tps6586x_gpio = devm_kzalloc(&pdev->dev,
+				sizeof(*tps6586x_gpio), GFP_KERNEL);
+	if (!tps6586x_gpio) {
+		dev_err(&pdev->dev, "Could not allocate tps6586x_gpio\n");
+		return -ENOMEM;
+	}
+
+	tps6586x_gpio->parent = pdev->dev.parent;
+
+	tps6586x_gpio->gpio_chip.owner = THIS_MODULE;
+	tps6586x_gpio->gpio_chip.label = pdev->name;
+	tps6586x_gpio->gpio_chip.dev = &pdev->dev;
+	tps6586x_gpio->gpio_chip.ngpio = 4;
+	tps6586x_gpio->gpio_chip.can_sleep = 1;
+
+	/* FIXME: add handling of GPIOs as dedicated inputs */
+	tps6586x_gpio->gpio_chip.direction_output = tps6586x_gpio_output;
+	tps6586x_gpio->gpio_chip.set	= tps6586x_gpio_set;
+	tps6586x_gpio->gpio_chip.get	= tps6586x_gpio_get;
+
+#ifdef CONFIG_OF_GPIO
+	tps6586x_gpio->gpio_chip.of_node = pdev->dev.parent->of_node;
+#endif
+	if (pdata && pdata->gpio_base)
+		tps6586x_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		tps6586x_gpio->gpio_chip.base = -1;
+
+	ret = gpiochip_add(&tps6586x_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, tps6586x_gpio);
+
+	return ret;
+}
+
+static int __devexit tps6586x_gpio_remove(struct platform_device *pdev)
+{
+	struct tps6586x_gpio *tps6586x_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&tps6586x_gpio->gpio_chip);
+}
+
+static struct platform_driver tps6586x_gpio_driver = {
+	.driver.name	= "tps6586x-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= tps6586x_gpio_probe,
+	.remove		= __devexit_p(tps6586x_gpio_remove),
+};
+
+static int __init tps6586x_gpio_init(void)
+{
+	return platform_driver_register(&tps6586x_gpio_driver);
+}
+subsys_initcall(tps6586x_gpio_init);
+
+static void __exit tps6586x_gpio_exit(void)
+{
+	platform_driver_unregister(&tps6586x_gpio_driver);
+}
+module_exit(tps6586x_gpio_exit);
+
+MODULE_ALIAS("platform:tps6586x-gpio");
+MODULE_DESCRIPTION("GPIO interface for TPS6586X PMIC");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.1.1

