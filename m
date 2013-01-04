Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3ADQpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:45:39 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:35437 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab3ADQph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:45:37 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
Date: Fri,  4 Jan 2013 17:45:08 +0100
Message-Id: <1357317909-12458-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP responsible for the muxing on the Allwinner SoCs are also
handling the GPIOs on the system. This patch adds the needed driver that
relies on the pinctrl driver for most of its operations.

The number of pins available for GPIOs operations are already declared
in the pinctrl driver, we only need to probe a generic driver to handle
the banks available for each SoC.

This driver has been tested on a A13-Olinuxino.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/gpio/gpio-sunxi.txt        |   77 ++++++++++
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-sunxi.c                          |  150 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                    |  106 ++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.h                    |    6 +-
 6 files changed, 345 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-sunxi.txt
 create mode 100644 drivers/gpio/gpio-sunxi.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-sunxi.txt b/Documentation/devicetree/bindings/gpio/gpio-sunxi.txt
new file mode 100644
index 0000000..cecdca0
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-sunxi.txt
@@ -0,0 +1,77 @@
+* Allwinner sunXi GPIO controller
+
+The Allwinner GPIO controller is part of the same IP than the PIN
+controller. The GPIOs are organized in port/bank. Each port consists
+of 32 GPIOs.
+
+As there is some interaction between the pinctrl driver and the gpio
+driver, you will need both enabled in your system for this driver to
+work.
+
+Required properties for GPIO node:
+- compatible : Should be "allwinner,sunxi-gpio".
+- gpio-controller : Marks the device node as a gpio controller.
+- #gpio-cells : Should be one. The cell is the pin number.
+
+Note: Each GPIO port should have an alias correctly numbered in "aliases"
+node.
+
+Examples:
+aliases {
+	gpio1 = &pb;
+	gpio2 = &pc;
+	gpio3 = &pd;
+	gpio4 = &pe;
+	gpio5 = &pf;
+	gpio6 = &pg;
+};
+
+
+pinctrl@01c20800 {
+	compatible = "allwinner,sun5i-a13-pinctrl";
+	reg = <0x01c20800 0x400>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+};
+
+pb: gpio@01c20824 {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c20824 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
+
+pc: gpio@01c20848 {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c20848 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
+
+pd: gpio@01c2086c {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c2086c 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
+
+pe: gpio@01c20890 {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c20890 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
+
+pf: gpio@01c208b4 {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c208b4 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
+
+pg: gpio@01c208d8 {
+	compatible = "allwinner,sunxi-gpio";
+	reg = <0x01c208d8 0x24>;
+	gpio-controller;
+	#gpio-cells = <1>;
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 682de75..6f4199f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -224,6 +224,12 @@ config GPIO_TS5500
 	  blocks of the TS-5500: DIO1, DIO2 and the LCD port, and the TS-5600
 	  LCD port.
 
+config GPIO_SUNXI
+	def_bool y
+	depends on ARCH_SUNXI
+	select GPIO_GENERIC
+	select GENERIC_IRQ_CHIP
+
 config GPIO_VT8500
 	bool "VIA/Wondermedia SoC GPIO Support"
 	depends on ARCH_VT8500
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index c5aebd0..c5a9306 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_GPIO_SPEAR_SPICS)	+= gpio-spear-spics.o
 obj-$(CONFIG_GPIO_STA2X11)	+= gpio-sta2x11.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
 obj-$(CONFIG_GPIO_STP_XWAY)	+= gpio-stp-xway.o
+obj-$(CONFIG_GPIO_SUNXI)	+= gpio-sunxi.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
diff --git a/drivers/gpio/gpio-sunxi.c b/drivers/gpio/gpio-sunxi.c
new file mode 100644
index 0000000..017ace4
--- /dev/null
+++ b/drivers/gpio/gpio-sunxi.c
@@ -0,0 +1,150 @@
+/*
+ * Allwinner A1X SoCs GPIO driver.
+ *
+ * Copyright (C) 2012 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+
+#include "../pinctrl/pinctrl-sunxi.h"
+
+struct sunxi_gpio_chip {
+	u32			bank;
+	struct gpio_chip	*chip;
+	void __iomem		*membase;
+};
+
+static int sunxi_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void sunxi_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int sunxi_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(chip->base + offset);
+}
+
+static int sunxi_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct sunxi_gpio_chip *sunxi_chip = dev_get_drvdata(chip->dev);
+
+	u32 reg = offset / DATA_PINS_PER_REG * 0x04 + DATA_REGS_OFFSET;
+	u8 index = (offset % DATA_PINS_PER_REG) * DATA_PINS_BITS;
+	u32 val = (readl(sunxi_chip->membase + reg) >> index) & 0x1;
+
+	return val;
+}
+
+static int sunxi_gpio_direction_output(struct gpio_chip *chip,
+		unsigned offset, int value)
+{
+	return pinctrl_gpio_direction_output(chip->base + offset);
+}
+
+static void sunxi_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct sunxi_gpio_chip *sunxi_chip = dev_get_drvdata(chip->dev);
+	int reg = offset / DATA_PINS_PER_REG * 0x04 + DATA_REGS_OFFSET;
+	int index = (offset % DATA_PINS_PER_REG) * DATA_PINS_BITS;
+
+	writel((value & 0x1) << index, sunxi_chip->membase + reg);
+}
+
+static struct gpio_chip sunxi_pio_gpio_chip __devinitconst = {
+	.owner			= THIS_MODULE,
+	.request		= sunxi_gpio_request,
+	.free			= sunxi_gpio_free,
+	.direction_input	= sunxi_gpio_direction_input,
+	.direction_output	= sunxi_gpio_direction_output,
+	.get			= sunxi_gpio_get,
+	.set			= sunxi_gpio_set,
+	.base			= -1,
+	.can_sleep		= 0,
+};
+
+
+static int __devinit sunxi_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct sunxi_gpio_chip *sunxi_chip;
+	int ret;
+
+	if (!node) {
+		dev_err(&pdev->dev, "No device tree node found\n");
+		return -ENODEV;
+	}
+
+	sunxi_chip = devm_kzalloc(&pdev->dev, sizeof(*sunxi_chip), GFP_KERNEL);
+	if (!sunxi_chip)
+		return -ENOMEM;
+
+	sunxi_chip->bank = of_alias_get_id(node, "gpio");
+	if (sunxi_chip->bank < 0) {
+		dev_err(&pdev->dev, "failed to get alias id\n");
+		return -EINVAL;
+	}
+
+	sunxi_chip->membase = of_iomap(node, 0);
+	if (!sunxi_chip->membase)
+		return -ENOMEM;
+
+	sunxi_chip->chip = &sunxi_pio_gpio_chip;
+	sunxi_chip->chip->base = sunxi_chip->bank * PINS_PER_BANK;
+	sunxi_chip->chip->ngpio = PINS_PER_BANK;
+	sunxi_chip->chip->label = dev_name(&pdev->dev);
+	sunxi_chip->chip->dev = &pdev->dev;
+	sunxi_chip->chip->owner = THIS_MODULE;
+
+	ret = gpiochip_add(sunxi_chip->chip);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, sunxi_chip);
+
+	dev_info(&pdev->dev, "initialized sunXi gpio bank\n");
+
+	return 0;
+}
+
+static const struct of_device_id sunxi_gpio_match[] = {
+	{ .compatible = "allwinner,sunxi-gpio", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sunxi_gpio_match);
+
+static struct platform_driver sunxi_gpio_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "sunxi-gpio",
+		.of_match_table = sunxi_gpio_match,
+	},
+	.probe = sunxi_gpio_probe,
+};
+
+static int __init sunxi_gpio_init(void)
+{
+	return platform_driver_register(&sunxi_gpio_driver);
+}
+postcore_initcall(sunxi_gpio_init);
+
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_DESCRIPTION("Allwinner sunXi GPIO driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index e122f75..3db404b 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -599,11 +599,57 @@ static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+static int
+sunxi_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range,
+			unsigned offset,
+			bool input)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct sunxi_desc_function *desc;
+	char *func, *pin_name;
+	u8 bank, pin;
+	int ret;
+
+	bank = (offset) / PINS_PER_BANK;
+	pin = (offset) % PINS_PER_BANK;
+
+	pin_name = kzalloc(5, GFP_KERNEL);
+	if (!pin_name)
+		return -ENOMEM;
+
+	ret = sprintf(pin_name, "P%c%d", 'A' + bank, pin);
+	if (!ret)
+		goto error;
+
+	if (input)
+		func = "gpio_in";
+	else
+		func = "gpio_out";
+
+	desc = sunxi_pinctrl_desc_find_function_by_name(pctl,
+							pin_name,
+							func);
+	if (!desc) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	sunxi_pmx_set(pctldev, offset, desc->muxval);
+
+	ret = 0;
+
+error:
+	kfree(pin_name);
+	return ret;
+}
+
 static struct pinmux_ops sunxi_pmx_ops = {
 	.get_functions_count	= sunxi_pmx_get_funcs_cnt,
 	.get_function_name	= sunxi_pmx_get_func_name,
 	.get_function_groups	= sunxi_pmx_get_func_groups,
 	.enable			= sunxi_pmx_enable,
+	.gpio_set_direction	= sunxi_pmx_gpio_set_direction,
 };
 
 static struct pinctrl_desc sunxi_pctrl_desc = {
@@ -721,6 +767,60 @@ static int __devinit sunxi_pinctrl_build_state(struct platform_device *pdev)
 	return 0;
 }
 
+static int __devinit
+sunxi_pinctrl_register_gpio_ranges(struct sunxi_pinctrl *pctl)
+{
+	int id = 0, base = 0, npins = 1, i, prev_pin = -1;
+	struct pinctrl_gpio_range *range;
+
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+		unsigned pin_num = pin->pin.number;
+
+		if (prev_pin < 0) {
+			prev_pin = pin_num;
+			base = pin_num;
+		} else if (prev_pin + 1 != pin_num) {
+			range = devm_kzalloc(pctl->dev,
+					sizeof(*range),
+					GFP_KERNEL);
+			if (!range)
+				return -ENOMEM;
+
+			range->name = "sunxi";
+			range->id = id;
+			range->base = base;
+			range->pin_base = base;
+			range->npins = npins;
+
+			pinctrl_add_gpio_range(pctl->pctl_dev, range);
+
+			id++;
+			npins = 1;
+			prev_pin = pin_num;
+			base = prev_pin;
+		} else {
+			prev_pin++;
+			npins++;
+		}
+	}
+
+	range = devm_kzalloc(pctl->dev, sizeof(*range),
+			GFP_KERNEL);
+	if (!range)
+		return -ENOMEM;
+
+	range->name = "sunxi";
+	range->id = id;
+	range->base = base;
+	range->pin_base = base;
+	range->npins = npins;
+
+	pinctrl_add_gpio_range(pctl->pctl_dev, range);
+
+	return 0;
+}
+
 static int __devinit sunxi_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -771,6 +871,12 @@ static int __devinit sunxi_pinctrl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	ret = sunxi_pinctrl_register_gpio_ranges(pctl);
+	if (ret) {
+		dev_err(&pdev->dev, "couldn't register gpio ranges\n");
+		return -EINVAL;
+	}
+
 	dev_info(&pdev->dev, "initialized sunXi pin control driver\n");
 
 	return 0;
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index 34f2496..665fedc 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -256,12 +256,15 @@
 
 #define BANK_MEM_SIZE		0x24
 #define MUX_REGS_OFFSET		0x0
+#define DATA_REGS_OFFSET	0x10
 #define DLEVEL_REGS_OFFSET	0x14
 #define PULL_REGS_OFFSET	0x1c
 
 #define PINS_PER_BANK		32
 #define MUX_PINS_PER_REG	8
 #define MUX_PINS_BITS		4
+#define DATA_PINS_PER_REG	32
+#define DATA_PINS_BITS		1
 #define DLEVEL_PINS_PER_REG	16
 #define DLEVEL_PINS_BITS	2
 #define PULL_PINS_PER_REG	16
@@ -280,6 +283,8 @@ struct sunxi_desc_pin {
 struct sunxi_pinctrl_desc {
 	const struct sunxi_desc_pin	*pins;
 	int				npins;
+	struct pinctrl_gpio_range	*ranges;
+	int				nranges;
 };
 
 struct sunxi_pinctrl_function {
@@ -318,7 +323,6 @@ struct sunxi_pinctrl {
 		.muxval = _val,					\
 	}
 
-
 /*
  * The sunXi PIO registers are organized as is:
  * 0x00 - 0x0c	Muxing values.
-- 
1.7.10.4

