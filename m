Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2CKMmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:42:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2CKMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:53 -0400
X-AuditID: cbfee61b-b7c62ae000000989-76-4f5c9d906468
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 1/5] pinctrl: add samsung pinctrl and gpiolib driver
Date: Sun, 11 Mar 2012 18:16:01 +0530
Message-id: <1331469965-28846-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pinctrl and gpiolib driver for Samsung SoC's. This driver provides a
common framework for all Samsung SoC's to interface with the pinctrl and
gpiolib subsystems.

This driver is split into two parts: the pinctrl interface and the gpiolib
interface. The pinctrl interface registers pinctrl devices with the pinctrl
subsystem and gpiolib interface registers gpio chips with the gpiolib
subsystem. The information about the pins, pin groups, pin functions and
gpio chips, which are SoC specific, are all provided to the driver using
driver data. The driver registers all the pinctrl devices and gpio chips
which are found in the driver data.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/plat-samsung/include/plat/pinctrl.h |   35 ++
 drivers/pinctrl/Kconfig                      |    3 +
 drivers/pinctrl/Makefile                     |    1 +
 drivers/pinctrl/pinctrl-samsung.c            |  589 ++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h            |  143 +++++++
 5 files changed, 771 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-samsung/include/plat/pinctrl.h
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h

diff --git a/arch/arm/plat-samsung/include/plat/pinctrl.h b/arch/arm/plat-samsung/include/plat/pinctrl.h
new file mode 100644
index 0000000..0c226b2
--- /dev/null
+++ b/arch/arm/plat-samsung/include/plat/pinctrl.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2012 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * Samsung Pinctrl driver helper macros
+ *
+ * Author: Thomas Abraham <thomas.ab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PLAT_SAMSUNG_PINCTRL_H
+#define __PLAT_SAMSUNG_PINCTRL_H __FILE__
+
+#define _PUD_MASK	0xF
+#define PUD_NONE	0
+#define PUD_DOWN	1
+#define PUD_UP		2
+
+#define _DRV_SHIFT	4
+#define _DRV_MASK	0xF
+#define DRV_1X		0
+#define DRV_2X		1
+#define DRV_3X		2
+#define DRV_4X		3
+
+#define PINCTRL_CFG_PACK(PUD, DRV)	((DRV << _DRV_SHIFT) | PUD)
+#define PINCTRL_CFG_UNPACK_PUD(CFG)	(CFG & _PUD_MASK)
+#define PINCTRL_CFG_UNPACK_DRV(CFG)	((CFG >> _DRV_SHIFT) & _DRV_MASK)
+
+#endif /* __PLAT_SAMSUNG_PINCTRL_H */
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6d29ff..a068d16 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -79,6 +79,9 @@ config PINCTRL_COH901
 	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
 	  ports of 8 GPIO pins each.
 
+config PINCTRL_SAMSUNG
+	bool "Samsung pinctrl driver"
+
 endmenu
 
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 754329b..eaccc1b 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
+obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
new file mode 100644
index 0000000..262dc3b
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -0,0 +1,589 @@
+/*
+ * pin-controller/pin-mux/pin-config/gpio-driver for Samsung's SoC's.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2012 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * Author: Thomas Abraham <thomas.ab@samsung.com>
+ *
+ * This driver is divided into two main components, gpiolib subsystem interface
+ * and the pin-controller subsystem interface. This model help to better
+ * abstract the details of pad controller for all the Samsung SoC's. The driver
+ * is designed to be reusuable on all the Samsung SoC's providing both gpiolib
+ * and pinctrl subsystem interfaces.
+ *
+ * The driver functions are kept as generic as possible such that they are
+ * usable across multiple Samsung SoC's. The driver data differentiates the
+ * operation of the driver for each SoC by describing the complete
+ * pad-controller structure to the driver and the generic driver code operates
+ * on the SoC specific driver data. The driver data also includes runtime data
+ * required for the operation of the driver.
+ *
+ * List of ToDo's:
+ * 1. Add GPIO Interrupt support.
+ * 2. Add external interrupt (wakeup) support.
+ * 3  Add power management support.
+ * 4. Find a better way to populate data about pins and functions.
+ * 5. Add driver data, pins, groups, functions for all Samsung SoC's and test.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/gpio.h>
+
+#include <plat/pinctrl.h>
+
+#include "pinctrl-samsung.h"
+
+/* check if the selector is a valid pin group selector */
+static int samsung_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	if (selector >= drvdata->nr_groups)
+		return -EINVAL;
+	return 0;
+}
+
+/* return the name of the group selected by the group selector */
+static const char *samsung_get_group_name(struct pinctrl_dev *pctldev,
+						unsigned selector)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	return drvdata->pin_groups[selector].name;
+}
+
+/* return the pin numbers associated with the specified group */
+static int samsung_get_group_pins(struct pinctrl_dev *pctldev,
+		unsigned selector, const unsigned **pins, unsigned *num_pins)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	*pins = drvdata->pin_groups[selector].pins;
+	*num_pins = drvdata->pin_groups[selector].num_pins;
+	return 0;
+}
+
+/* list of pinctrl callbacks for the pinctrl core */
+static struct pinctrl_ops samsung_pctrl_ops = {
+	.list_groups	= samsung_list_groups,
+	.get_group_name	= samsung_get_group_name,
+	.get_group_pins	= samsung_get_group_pins,
+};
+
+
+/* check if the selector is a valid pin function selector */
+static int samsung_pinmux_list_funcs(struct pinctrl_dev *pctldev,
+					unsigned selector)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	if (selector >= drvdata->nr_groups)
+		return -EINVAL;
+	return 0;
+}
+
+/* return the name of the pin function specified */
+static const char *samsung_pinmux_get_fname(struct pinctrl_dev *pctldev,
+						unsigned selector)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	return drvdata->pmx_functions[selector].name;
+}
+
+/* return the groups associated for the specified function selector */
+static int samsung_pinmux_get_groups(struct pinctrl_dev *pctldev,
+		unsigned selector, const char * const **groups,
+		unsigned * const num_groups)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	*groups = drvdata->pmx_functions[selector].groups;
+	*num_groups = drvdata->pmx_functions[selector].num_groups;
+	return 0;
+}
+
+/*
+ * given a pin number that is local to a pin controller, find out the pin bank
+ * and the register base of the pin bank.
+ */
+static void pin_to_reg_bank(struct gpio_chip *gc, unsigned pin,
+			void __iomem **reg, unsigned long *offset,
+			struct samsung_pin_bank **bank)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	struct samsung_pin_bank *b;
+
+	drvdata = dev_get_drvdata(gc->dev);
+	b = drvdata->ctrl->pin_banks;
+
+	while (b->pin_base + b->nr_pins < pin)
+		b++;
+
+	*reg = drvdata->virt_base + b->reg_offset;
+	*offset = pin - b->pin_base;
+	if (bank)
+		*bank = b;
+
+	/* some banks have two config registers in a single bank */
+	if (*offset * b->func_width > BITS_PER_LONG)
+		*reg += 4;
+}
+
+/* enable or disable a pinmux function */
+static void samsung_pimux_setup(struct pinctrl_dev *pctldev, unsigned selector,
+					unsigned group, bool enable)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	const unsigned int *pin;
+	unsigned long data, pin_offset, cnt;
+	struct samsung_pin_bank *bank;
+	void __iomem *reg;
+	unsigned int mask, shift;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pin = drvdata->pin_groups[group].pins;
+
+	/*
+	 * for each pin in the pin group selected, program the correspoding pin
+	 * pin function number in the config register.
+	 */
+	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++, pin++) {
+		pin_to_reg_bank(drvdata->gc, *pin - drvdata->ctrl->base,
+				&reg, &pin_offset, &bank);
+		mask = (1 << bank->func_width) - 1;
+		shift = pin_offset * bank->func_width;
+
+		data = readl(reg);
+		data &= ~(mask << shift);
+		if (enable)
+			data |= drvdata->pin_groups[group].func << shift;
+		writel(data, reg);
+	}
+}
+
+/* enable a specified pinmux by writing to registers */
+static int samsung_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
+					unsigned group)
+{
+	samsung_pimux_setup(pctldev, selector, group, true);
+	return 0;
+}
+
+/* disable a specified pinmux by writing to registers */
+static void samsung_pinmux_disable(struct pinctrl_dev *pctldev,
+					unsigned selector, unsigned group)
+{
+	samsung_pimux_setup(pctldev, selector, group, false);
+}
+
+/*
+ * The calls to gpio_direction_output() and gpio_direction_input()
+ * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
+ * function called from the gpiolib interface).
+ */
+static int samsung_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
+		struct pinctrl_gpio_range *range, unsigned offset, bool input)
+{
+	unsigned long data, pin_offset;
+	struct samsung_pin_bank *bank;
+	void __iomem *reg;
+	unsigned int mask, shift;
+
+	pin_to_reg_bank(range->gc, offset, &reg, &pin_offset, &bank);
+	mask = (1 << bank->func_width) - 1;
+	shift = pin_offset * bank->func_width;
+
+	data = readl(reg);
+	data &= ~(mask << shift);
+	if (!input)
+		data |= FUNC_OUTPUT << shift;
+	writel(data, reg);
+	return 0;
+}
+
+/* list of pinmux callbacks for the pinmux vertical in pinctrl core */
+static struct pinmux_ops samsung_pinmux_ops = {
+	.list_functions		= samsung_pinmux_list_funcs,
+	.get_function_name	= samsung_pinmux_get_fname,
+	.get_function_groups	= samsung_pinmux_get_groups,
+	.enable			= samsung_pinmux_enable,
+	.disable		= samsung_pinmux_disable,
+	.gpio_set_direction	= samsung_pinmux_gpio_set_direction,
+};
+
+/* set the pull up/down and driver strength settings for a specified pin */
+static int samsung_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
+					unsigned long config)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	unsigned long data, pin_offset;
+	struct samsung_pin_bank *bank;
+	void __iomem *reg;
+	unsigned int mask, shift;
+	unsigned int pud, drv;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pin_to_reg_bank(drvdata->gc, pin - drvdata->ctrl->base, &reg,
+					&pin_offset, &bank);
+
+	/* update the pull up/down configuration */
+	mask = (1 << bank->pud_width) - 1;
+	shift = pin_offset * bank->pud_width;
+	pud =  PINCTRL_CFG_UNPACK_PUD(config);
+
+	if (drvdata->ctrl->xlate_pud)
+		pud = drvdata->ctrl->xlate_pud(pud);
+
+	data = readl(reg + PUD_REG);
+	data &= ~(mask << shift);
+	data |= (pud << shift);
+	writel(data, reg + PUD_REG);
+
+	/* update the drive strength configuration */
+	mask = (1 << bank->drv_width) - 1;
+	shift = pin_offset * bank->drv_width;
+	drv = PINCTRL_CFG_UNPACK_DRV(config);
+
+	if (drvdata->ctrl->xlate_drv)
+		drv = drvdata->ctrl->xlate_drv(drv);
+
+	data = readl(reg + DRV_REG);
+	data &= ~(mask << shift);
+	data |= (drv << shift);
+	writel(data, reg + DRV_REG);
+
+	return 0;
+}
+
+/*
+ * set the pull up/down and driver strength settings for all the pins in a
+ * specified pin group
+ */
+static int samsung_pinconf_group_set(struct pinctrl_dev *pctldev,
+			unsigned group, unsigned long config)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	const unsigned int *pin;
+	unsigned int cnt;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pin = drvdata->pin_groups[group].pins;
+
+	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++, pin++)
+		samsung_pinconf_set(pctldev, *pin, config);
+
+	return 0;
+}
+
+/* reading pin pull up/down and driver strength settings not implemented */
+static int samsung_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
+					unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+/* reading pin pull up/down and driver strength settings not implemented */
+static int samsung_pinconf_group_get(struct pinctrl_dev *pctldev,
+				unsigned int group, unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+/* list of pinconfig callbacks for pinconfig vertical in the pinctrl code */
+static struct pinconf_ops samsung_pinconf_ops = {
+	.pin_config_get		= samsung_pinconf_get,
+	.pin_config_set		= samsung_pinconf_set,
+	.pin_config_group_get	= samsung_pinconf_group_get,
+	.pin_config_group_set	= samsung_pinconf_group_set,
+};
+
+/* gpiolib gpio_set callback function */
+static void samsung_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	void __iomem *reg;
+	unsigned long pin_offset, data;
+
+	pin_to_reg_bank(gc, offset, &reg, &pin_offset, NULL);
+	data = readl(reg + DAT_REG);
+	data &= ~(1 << pin_offset);
+	if (value)
+		data |= 1 << pin_offset;
+	__raw_writel(data, reg + DAT_REG);
+}
+
+/* gpiolib gpio_get callback function */
+static int samsung_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	void __iomem *reg;
+	unsigned long pin_offset, data;
+
+	pin_to_reg_bank(gc, offset, &reg, &pin_offset, NULL);
+	data = readl(reg + DAT_REG);
+	data >>= pin_offset;
+	data &= 1;
+	return data;
+}
+
+/*
+ * gpiolib gpio_direction_input callback function. The setting of the pin
+ * mux function as 'gpio input' will be handled by the pinctrl susbsystem
+ * interface.
+ */
+static int samsung_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(gc->base + offset);
+}
+
+/*
+* gpiolib gpio_direction_output callback function. The setting of the pin
+* mux function as 'gpio output' will be handled by the pinctrl susbsystem
+* interface.
+*/
+static int samsung_gpio_direction_output(struct gpio_chip *gc, unsigned offset,
+							int value)
+{
+	int ret;
+
+	ret = pinctrl_gpio_direction_output(gc->base + offset);
+	if (!ret)
+		samsung_gpio_set(gc, offset, value);
+	return ret;
+}
+
+/* register the pinctrl interface with the pinctrl subsystem */
+static int __init samsung_pinctrl_register(struct platform_device *pdev,
+				struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct pinctrl_desc *ctrldesc = drvdata->pctl;
+	struct pinctrl_pin_desc *pindesc, *pdesc;
+	struct samsung_pin_bank *pin_bank;
+	char *pin_names;
+	int pin, bank;
+
+	drvdata->pctl->pctlops = &samsung_pctrl_ops;
+	drvdata->pctl->pmxops = &samsung_pinmux_ops;
+	drvdata->pctl->confops = &samsung_pinconf_ops;
+
+	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
+			drvdata->ctrl->nr_pins, GFP_KERNEL);
+	if (!pindesc) {
+		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
+		return -ENOMEM;
+	}
+	ctrldesc->pins = pindesc;
+	ctrldesc->npins = drvdata->ctrl->nr_pins;
+	ctrldesc->npins = drvdata->ctrl->nr_pins;
+
+	/* dynamically populate the pin number and  pin name for pindesc */
+	for (pin = 0, pdesc = pindesc; pin < ctrldesc->npins; pin++, pdesc++)
+		pdesc->number = pin + drvdata->ctrl->base;
+
+	/*
+	 * allocate space for storing the dynamically generated names for all
+	 * the pins which belong to this pin-controller.
+	 */
+	pin_names = devm_kzalloc(&pdev->dev, sizeof(char) * PIN_NAME_LENGTH *
+					drvdata->ctrl->nr_pins, GFP_KERNEL);
+	if (!pin_names) {
+		dev_err(&pdev->dev, "mem alloc for pin names failed\n");
+		return -ENOMEM;
+	}
+
+	/* for each pin, the name of the pin is pin-bank name + pin number */
+	for (bank = 0; bank < drvdata->ctrl->nr_banks; bank++) {
+		pin_bank = &drvdata->ctrl->pin_banks[bank];
+		for (pin = 0; pin < pin_bank->nr_pins; pin++) {
+			sprintf(pin_names, "%s-%d", pin_bank->name, pin);
+			pdesc = pindesc + pin_bank->pin_base + pin;
+			pdesc->name = pin_names;
+			pin_names += PIN_NAME_LENGTH;
+		}
+	}
+
+	drvdata->pctl_dev = pinctrl_register(ctrldesc, &pdev->dev, drvdata);
+	if (!drvdata->pctl_dev) {
+		dev_err(&pdev->dev, "could not register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	drvdata->ctrl->grange->base = drvdata->ctrl->base;
+	drvdata->ctrl->grange->npins = drvdata->ctrl->nr_pins;
+	drvdata->ctrl->grange->gc = drvdata->gc;
+	pinctrl_add_gpio_range(drvdata->pctl_dev, drvdata->ctrl->grange);
+
+	return 0;
+}
+
+/* register the gpiolib interface with the gpiolib subsystem */
+static int __init samsung_gpiolib_register(struct platform_device *pdev,
+				struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct gpio_chip *gc;
+	int ret;
+
+	gc = devm_kzalloc(&pdev->dev, sizeof(*gc), GFP_KERNEL);
+	if (!gc) {
+		dev_err(&pdev->dev, "mem alloc for gpio_chip failed\n");
+		return -ENOMEM;
+	}
+
+	drvdata->gc = gc;
+	gc->base = drvdata->ctrl->base;
+	gc->ngpio = drvdata->ctrl->nr_pins;
+	gc->dev = &pdev->dev;
+	gc->set = samsung_gpio_set;
+	gc->get = samsung_gpio_get;
+	gc->direction_input = samsung_gpio_direction_input;
+	gc->direction_output = samsung_gpio_direction_output;
+	gc->label = drvdata->ctrl->label;
+	gc->owner = THIS_MODULE;
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register gpio_chip %s, error "
+					"code: %d\n", gc->label, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id samsung_pinctrl_dt_match[];
+
+static inline struct samsung_pinctrl_drv_data *samsung_pinctrl_get_driver_data(
+				struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		const struct of_node *node = pdev->dev.of_node;
+		match = of_match_node(samsung_pinctrl_dt_match, node);
+		return (struct samsung_pinctrl_drv_data *)match->data;
+	}
+#endif
+	return (struct samsung_pinctrl_drv_data *)
+		platform_get_device_id(pdev)->driver_data + (pdev->id);
+}
+
+static int __devinit samsung_pinctrl_probe(struct platform_device *pdev)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	struct resource *res;
+	int ret;
+
+	drvdata = samsung_pinctrl_get_driver_data(pdev);
+	if (!drvdata) {
+		dev_err(&pdev->dev, "driver data not available\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "cannot find IO resource\n");
+		return -ENOENT;
+	}
+
+	res = request_mem_region(res->start, resource_size(res),
+					pdev->name);
+	if (!res) {
+		dev_err(&pdev->dev, "request for mem region failed\n");
+		return -EBUSY;
+	}
+
+	drvdata->virt_base = ioremap(res->start, resource_size(res));
+	if (!drvdata->virt_base) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -EINVAL;
+	}
+
+	ret = samsung_gpiolib_register(pdev, drvdata);
+	if (ret)
+		return ret;
+
+	ret = samsung_pinctrl_register(pdev, drvdata);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, drvdata);
+	return 0;
+}
+
+/* driver data for various samsung soc's */
+#ifdef CONFIG_CPU_EXYNOS4210
+
+#define EXYNOS4210_PCTRL_DRVDATA ((kernel_ulong_t)&exynos4210_pinctrl_drv_data)
+#else
+#define EXYNOS4210_PCTRL_DRVDATA ((kernel_ulong_t)NULL)
+#endif /* CONFIG_CPU_EXYNOS4210 */
+
+static struct platform_device_id samsung_pinctrl_driver_ids[] = {
+	{
+		.name		= "exynos4-pinctrl",
+		.driver_data	= EXYNOS4210_PCTRL_DRVDATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, samsung_pinctrl_driver_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id samsung_pinctrl_dt_match[] = {
+#ifdef CONFIG_CPU_EXYNOS4210
+	{ .compatible = "samsung,exynos4210-pinctrl0",
+		.data = (void *)&exynos4210_pinctrl_drv_data[0] },
+	{ .compatible = "samsung,exynos4210-pinctrl1",
+		.data = (void *)&exynos4210_pinctrl_drv_data[1] },
+	{ .compatible = "samsung,exynos4210-pinctrl2",
+		.data = (void *)&exynos4210_pinctrl_drv_data[2] },
+#endif /* CONFIG_CPU_EXYNOS4210 */
+	{},
+};
+MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
+#endif /* CONFIG_OF */
+
+static struct platform_driver samsung_pinctrl_driver = {
+	.probe		= samsung_pinctrl_probe,
+	.id_table	= samsung_pinctrl_driver_ids,
+	.driver = {
+		.name	= "samsung-pinctrl",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(samsung_pinctrl_dt_match),
+	},
+};
+
+static int __init samsung_pinctrl_drv_register(void)
+{
+	return platform_driver_register(&samsung_pinctrl_driver);
+}
+postcore_initcall(samsung_pinctrl_drv_register);
+
+static void __exit samsung_pinctrl_drv_unregister(void)
+{
+	platform_driver_unregister(&samsung_pinctrl_driver);
+}
+module_exit(samsung_pinctrl_drv_unregister);
+
+MODULE_AUTHOR("Thomas Abraham <thomas.ab@samsung.com>");
+MODULE_DESCRIPTION("Samsung pinctrl driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
new file mode 100644
index 0000000..d28bd46
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -0,0 +1,143 @@
+/*
+ * pin-controller/pin-mux/pin-config/gpio-driver for Samsung's SoC's.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2012 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * Author: Thomas Abraham <thomas.ab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PINCTRL_SAMSUNG_H
+#define __PINCTRL_SAMSUNG_H
+
+/* register offsets within a pin bank */
+#define DAT_REG		0x4
+#define PUD_REG		0x8
+#define DRV_REG		0xC
+
+/* pinmux function number for pin as gpio output line */
+#define FUNC_OUTPUT	0x1
+
+/* maximum length of a pin in pin descriptor */
+#define PIN_NAME_LENGTH	10
+
+#define PIN_GROUP(n, p, f)				\
+	{						\
+		.name		= n,			\
+		.pins		= p,			\
+		.num_pins	= ARRAY_SIZE(p),	\
+		.func		= f			\
+	}
+
+#define PMX_FUNC(n, g)					\
+	{						\
+		.name		= n,			\
+		.groups		= g,			\
+		.num_groups	= ARRAY_SIZE(g),	\
+	}
+
+/**
+ * struct samsung_pin_bank: represent a controller pin-bank.
+ * @reg_offset: starting offset of the pin-bank registers.
+ * @pin_base: starting pin number of the bank.
+ * @nr_pins: number of pins included in this bank.
+ * @func_width: width of the function selector bit field.
+ * @pud_width: width of the pin pull up/down selector bit field.
+ * @drc_width: width of the pin driver strength selector bit field.
+ * @irq_base: starting eint number of the bank.
+ * @name: name to be prefixed for each pin in this pin bank.
+ */
+struct samsung_pin_bank {
+	unsigned int		reg_offset;
+	unsigned int		pin_base;
+	unsigned int		nr_pins;
+	unsigned int		func_width;
+	unsigned int		pud_width;
+	unsigned int		drv_width;
+	unsigned int		irq_base;
+	char			*name;
+};
+
+/**
+ * struct samsung_pin_ctrl: represent a pin controller.
+ * @pin_banks: list of pin banks included in this controller.
+ * @nr_banks: number of pin banks.
+ * @base: starting system wide pin number.
+ * @nr_pins: number of pins supported by the controller.
+ * @xlate_pud: soc specific callback to translate PUD_XXX values to soc
+ *	specific pull up/down register values (optional).
+ * @xlate_drv: soc specific callback to translate DRV_XXX values to soc
+ *	specific driver strength register values (optional).
+ * @label: for debug information.
+ */
+struct samsung_pin_ctrl {
+	struct pinctrl_gpio_range	*grange;
+	struct samsung_pin_bank		*pin_banks;
+	unsigned int			nr_banks;
+	unsigned int			base;
+	unsigned int			nr_pins;
+	int (*xlate_pud)(unsigned int pud);
+	int (*xlate_drv)(unsigned int drv);
+	char				*label;
+};
+
+/**
+ * struct samsung_pinctrl_drv_data: wrapper for holding driver data together.
+ * @virt_base: register base address of the controller.
+ * @ctrl: pin controller instance managed by the driver.
+ * @pctl: pin controller descriptor registered with the pinctrl subsystem.
+ * @pctl_dev: cookie representing pinctrl device instance.
+ * @pin_groups: list of pin groups available to the driver.
+ * @nr_groups: number of such pin groups.
+ * @pmx_functions: list of pin functions available to the driver.
+ * @nr_function: number of such pin functions.
+ * @gc: gpio_chip instance registered with gpiolib.
+ */
+struct samsung_pinctrl_drv_data {
+	void __iomem			*virt_base;
+	struct samsung_pin_ctrl		*ctrl;
+	struct pinctrl_desc		*pctl;
+	struct pinctrl_dev		*pctl_dev;
+	const struct samsung_pin_group	*pin_groups;
+	unsigned int			nr_groups;
+	const struct samsung_pmx_func	*pmx_functions;
+	unsigned int			nr_functions;
+	struct gpio_chip		*gc;
+};
+
+/**
+ * struct samsung_pin_group: represent group of pins of a pinmux function.
+ * @name: name of the pin group, used to lookup the group.
+ * @pins: the pins included in this group.
+ * @num_pins: number of pins included in this group.
+ * @func: the function number to be programmed when selected.
+ */
+struct samsung_pin_group {
+	const char		*name;
+	const unsigned int	*pins;
+	const unsigned int	num_pins;
+	unsigned int		func;
+};
+
+/**
+ * struct samsung_pmx_func: represent a pin function.
+ * @name: name of the pin function, used to lookup the function.
+ * @groups: one or more names of pin groups that provide this function.
+ * @num_groups: number of groups included in @groups.
+ */
+struct samsung_pmx_func {
+	const char		*name;
+	const char * const	*groups;
+	const unsigned		num_groups;
+};
+
+extern struct samsung_pinctrl_drv_data exynos4210_pinctrl_drv_data[];
+
+#endif /* __PINCTRL_SAMSUNG_H */
-- 
1.6.6.rc2

