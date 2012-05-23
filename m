Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2EWXwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:52:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2EWXwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:52:13 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Subject: [PATCH 1/3] pinctrl: add samsung pinctrl and gpiolib driver
Date: Thu, 24 May 2012 05:17:35 +0530
Message-Id: <1337816857-14694-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
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
gpio chips, which are SoC specific, are parsed from device tree node.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 .../bindings/pinctrl/samsung-pinctrl.txt           |  111 +++
 drivers/pinctrl/Kconfig                            |    4 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-samsung.c                  |  881 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h                  |  170 ++++
 5 files changed, 1167 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
new file mode 100644
index 0000000..031196f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -0,0 +1,111 @@
+Samsung GPIO and Pin Mux/Config controller
+
+Samsung's ARM based SoC's integrates a GPIO and Pin mux/config hardware
+controller. It controls the input/output settings on the available pads/pins
+and also provides ability to multiplex and configure the output of various
+on-chip controllers onto these pads.
+
+Required Properties:
+- compatible: should be one of the following.
+  - "samsung,pinctrl-exynos4210": for Exynos4210 compatible pin-controller.
+  - "samsung,pinctrl-exynos5250": for Exynos5250 compatible pin-controller.
+
+- reg: Base address of the pin controller hardware module and length of
+  the address space it occupies.
+
+- interrupts: interrupt specifier for the controller. The format and value of
+  the interrupt specifier depends on the interrupt parent for the controller.
+
+- Pin mux/config groups as child nodes: The pin mux (selecting pin function
+  mode) and pin config (pull up/down, driver strength) settings are represented
+  as child nodes of the pin-controller node. There should be atleast one
+  child node and there is no limit on the count of these child nodes.
+
+  The child node should contain a list of pin(s) on which a particular pin
+  function selection or pin configuration (or both) have to applied. This
+  list of pins is specified using the property name "samsung,pins". There
+  should be atleast one pin specfied for this property and there is no upper
+  limit on the count of pins that can be specified. The pins are specified
+  using pin names which are derived from the hardware manual of the SoC. As
+  an example, the pins in GPA0 bank of the pin controller can be represented
+  as "gpa0-0", "gpa0-1", "gpa0-2" and so on. The names should be in lower case.
+  The format of the pin names should be (as per the hardware manual)
+  "[pin bank name]-[pin number within the bank]".
+
+  The pin function selection that should be applied on the pins listed in the
+  child node is specified using the "samsung,pin-function" property. The value
+  of this property that should be applied to each of the pins listed in the
+  "samsung,pins" property should be picked from the hardware manual of the SoC
+  for the specified pin group. This property is optional in the child node if
+  no specific function selection is desired for the pins listed in the child
+  node. The value of this property is used as-is to program the pin-controller
+  function selector register of the pin-bank.
+
+  The child node can also optionally specify one or more of the pin
+  configuration that should be applied on all the pins listed in the
+  "samsung,pins" property of the child node. The following pin configuration
+  properties are supported.
+
+  - samsung,pin-pud: Pull up/down configuration.
+  - samsung,pin-drv: Drive strength configuration.
+  - samsung,pin-pud-pdn: Pull up/down configuration in power down mode.
+  - samsung,pin-drv-pdn: Drive strength configuration in power down mode.
+
+  The values specified by these config properties should be dervied from the
+  hardware manual and these values are programmed as-is into the pin
+  pull up/down and driver strength register of the pin-controller.
+
+  Note: A child should include atleast a pin function selection property or
+  pin configuration property (one or more) or both.
+
+  The client nodes that require a particular pin function selection and/or
+  pin configuration should use the bindings listed in the "pinctrl-bindings.txt"
+  file.
+
+Aliases:
+
+All the pin controller nodes should be represented in the aliases node using
+the following format 'pinctrl{n}' where n is a unique number for the alias.
+
+Example:
+
+	pinctrl_0: pinctrl@11400000 {
+		compatible = "samsung,pinctrl-exynos4210";
+		reg = <0x11400000 0x1000>;
+		interrupts = <0 47 0>;
+
+		uart0_data: uart0-data {
+			samsung,pins = "gpa0-0", "gpa0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart0_fctl: uart0-fctl {
+			samsung,pins = "gpa0-2", "gpa0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart1_data: uart1-data {
+			samsung,pins = "gpa0-4", "gpa0-5";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		uart1_fctl: uart1-fctl {
+			samsung,pins = "gpa0-6", "gpa0-7";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		i2c2_bus: i2c2-bus {
+			samsung,pins = "gpa0-6", "gpa0-7";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <3>;
+			samsung,pin-drv = <0>;
+		};
+	};
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 91c1f64..a6198c1 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -127,6 +127,10 @@ config PINCTRL_COH901
 	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
 	  ports of 8 GPIO pins each.
 
+config PINCTRL_SAMSUNG
+	bool "Samsung pinctrl driver"
+	depends on OF
+
 endmenu
 
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 515e32f..35986ed 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
+obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
new file mode 100644
index 0000000..480e2f0
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -0,0 +1,881 @@
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/gpio.h>
+
+#include "core.h"
+#include "pinctrl-samsung.h"
+
+/* list of all possible config options supported */
+struct pin_config {
+	char		*prop_cfg;
+	unsigned int	cfg_type;
+} const pcfgs[] = {
+	{ "samsung,pin-pud", PINCFG_TYPE_PUD },
+	{ "samsung,pin-drv", PINCFG_TYPE_DRV },
+	{ "samsung,pin-pud-pdn", PINCFG_TYPE_CON_PND },
+	{ "samsung,pin-drv-pdn", PINCFG_TYPE_PUD_PND },
+};
+
+/* check if the selector is a valid pin group selector */
+static int samsung_get_group_count(struct pinctrl_dev *pctldev)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	return drvdata->nr_groups;
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
+/* create pinctrl_map entries by parsing device tree nodes */
+int samsung_dt_node_to_map(struct pinctrl_dev *pctldev,
+			struct device_node *np, struct pinctrl_map **maps,
+			unsigned *nmaps)
+{
+	struct device *dev = pctldev->dev;
+	struct pinctrl_map *map;
+	unsigned long *cfg = NULL;
+	char *gname, *fname;
+	int cfg_cnt = 0, map_cnt = 0;
+	int idx = 0;
+
+	/* count the number of config options specfied in the node */
+	for (idx = 0; idx < ARRAY_SIZE(pcfgs); idx++) {
+		if (of_find_property(np, pcfgs[idx].prop_cfg, NULL))
+			cfg_cnt++;
+	}
+
+	/*
+	 * Find out the number of map entries to create. All the config options
+	 * can be accomadated into a single config map entry.
+	 */
+	if (cfg_cnt)
+		map_cnt = 1;
+	if (of_find_property(np, "samsung,pin-function", NULL))
+		map_cnt++;
+	if (!map_cnt) {
+		dev_err(dev, "node %s does not have either config or function "
+				"configurations\n", np->name);
+		return -EINVAL;
+	}
+
+	/* Allocate memory for pin-map entries */
+	map = kzalloc(sizeof(*map) * map_cnt, GFP_KERNEL);
+	if (!map) {
+		dev_err(dev, "could not alloc memory for pin-maps\n");
+		return -ENOMEM;
+	}
+	*nmaps = 0;
+
+	/* Allocate memory for pin group name. The pin group name is derived
+	 * from the node name from which these map entries are be created.
+	 */
+	gname = kzalloc(strlen(np->name) + 4, GFP_KERNEL);
+	if (!gname) {
+		dev_err(dev, "failed to alloc memory for group name\n");
+		goto free_map;
+	}
+	sprintf(gname, "%s-grp", np->name);
+
+	/*
+	 * don't have config options? then skip over to creating function
+	 * map entries.
+	 */
+	if (!cfg_cnt)
+		goto skip_cfgs;
+
+	/* Allocate memory for config entries */
+	cfg = kzalloc(sizeof(*cfg) * cfg_cnt, GFP_KERNEL);
+	if (!cfg) {
+		dev_err(dev, "failed to alloc memory for configs\n");
+		goto free_gname;
+	}
+
+	/* Prepare a list of config settings */
+	for (idx = 0, cfg_cnt = 0; idx < ARRAY_SIZE(pcfgs); idx++) {
+		u32 value;
+		if (!of_property_read_u32(np, pcfgs[idx].prop_cfg, &value))
+			cfg[cfg_cnt++] =
+				PINCFG_PACK(pcfgs[idx].cfg_type, value);
+	}
+
+	/* create the config map entry */
+	map[*nmaps].data.configs.group_or_pin = gname;
+	map[*nmaps].data.configs.configs = cfg;
+	map[*nmaps].data.configs.num_configs = cfg_cnt;
+	map[*nmaps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	*nmaps += 1;
+
+skip_cfgs:
+	/* create the function map entry */
+	if (of_find_property(np, "samsung,pin-function", NULL)) {
+		fname = kzalloc(strlen(np->name) + 4, GFP_KERNEL);
+		if (!fname) {
+			dev_err(dev, "failed to alloc memory for func name\n");
+			goto free_cfg;
+		}
+		sprintf(fname, "%s-mux", np->name);
+
+		map[*nmaps].data.mux.group = gname;
+		map[*nmaps].data.mux.function = fname;
+		map[*nmaps].type = PIN_MAP_TYPE_MUX_GROUP;
+		*nmaps += 1;
+	}
+
+	*maps = map;
+	return 0;
+
+free_cfg:
+	kfree(cfg);
+free_gname:
+	kfree(gname);
+free_map:
+	kfree(map);
+	return -ENOMEM;
+}
+
+/* free the memory allocated to hold the pin-map table */
+void samsung_dt_free_map(struct pinctrl_dev *pctldev,
+			     struct pinctrl_map *map, unsigned num_maps)
+{
+	int idx;
+
+	for (idx = 0; idx < num_maps; idx++) {
+		if (map[idx].type == PIN_MAP_TYPE_MUX_GROUP) {
+			kfree(map[idx].data.mux.function);
+			if (!idx)
+				kfree(map[idx].data.mux.group);
+		} else if (map->type == PIN_MAP_TYPE_CONFIGS_GROUP) {
+			kfree(map[idx].data.configs.configs);
+			if (!idx)
+				kfree(map[idx].data.configs.group_or_pin);
+		}
+	};
+
+	kfree(map);
+}
+
+/* list of pinctrl callbacks for the pinctrl core */
+static struct pinctrl_ops samsung_pctrl_ops = {
+	.get_groups_count	= samsung_get_group_count,
+	.get_group_name		= samsung_get_group_name,
+	.get_group_pins		= samsung_get_group_pins,
+	.dt_node_to_map		= samsung_dt_node_to_map,
+	.dt_free_map		= samsung_dt_free_map,
+};
+
+/* check if the selector is a valid pin function selector */
+static int samsung_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	return drvdata->nr_functions;
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
+static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
+					unsigned group, bool enable)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	const unsigned int *pins;
+	unsigned long data, pin_offset, cnt;
+	struct samsung_pin_bank *bank;
+	void __iomem *reg;
+	unsigned int mask, shift;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pins = drvdata->pin_groups[group].pins;
+
+	/*
+	 * for each pin in the pin group selected, program the correspoding pin
+	 * pin function number in the config register.
+	 */
+	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++) {
+		pin_to_reg_bank(drvdata->gc, pins[cnt] - drvdata->ctrl->base,
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
+	samsung_pinmux_setup(pctldev, selector, group, true);
+	return 0;
+}
+
+/* disable a specified pinmux by writing to registers */
+static void samsung_pinmux_disable(struct pinctrl_dev *pctldev,
+					unsigned selector, unsigned group)
+{
+	samsung_pinmux_setup(pctldev, selector, group, false);
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
+	.get_functions_count	= samsung_get_functions_count,
+	.get_function_name	= samsung_pinmux_get_fname,
+	.get_function_groups	= samsung_pinmux_get_groups,
+	.enable			= samsung_pinmux_enable,
+	.disable		= samsung_pinmux_disable,
+	.gpio_set_direction	= samsung_pinmux_gpio_set_direction,
+};
+
+/* configure the pull up/down registers */
+static void samsung_pinconf_set_pud(struct samsung_pinctrl_drv_data *drvdata,
+		struct samsung_pin_bank *bank, void __iomem *reg,
+		unsigned long pin_offset, unsigned long config)
+{
+	unsigned int mask, shift, pud;
+	unsigned long data;
+
+	/* update the pull up/down configuration */
+	mask = (1 << bank->pud_width) - 1;
+	shift = pin_offset * bank->pud_width;
+	pud =  PINCFG_UNPACK_VALUE(config);
+
+	if (!drvdata->pctl_dev->dev->of_node && drvdata->ctrl->xlate_pud)
+		pud = drvdata->ctrl->xlate_pud(pud);
+
+	data = readl(reg + PUD_REG);
+	data &= ~(mask << shift);
+	data |= (pud << shift);
+	writel(data, reg + PUD_REG);
+}
+
+/* configure the driver strength registers */
+static void samsung_pinconf_set_drv(struct samsung_pinctrl_drv_data *drvdata,
+		struct samsung_pin_bank *bank, void __iomem *reg,
+		unsigned long pin_offset, unsigned long config)
+{
+	unsigned int mask, shift, drv;
+	unsigned long data;
+
+	/* update the drive strength configuration */
+	mask = (1 << bank->drv_width) - 1;
+	shift = pin_offset * bank->drv_width;
+	drv = PINCFG_UNPACK_VALUE(config);
+
+	if (!drvdata->pctl_dev->dev->of_node && drvdata->ctrl->xlate_drv)
+		drv = drvdata->ctrl->xlate_drv(drv);
+
+	data = readl(reg + DRV_REG);
+	data &= ~(mask << shift);
+	data |= (drv << shift);
+	writel(data, reg + DRV_REG);
+}
+
+/* set the pull up/down and driver strength settings for a specified pin */
+static int samsung_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
+					unsigned long config)
+{
+	struct samsung_pinctrl_drv_data *drvdata;
+	unsigned long pin_offset;
+	struct samsung_pin_bank *bank;
+	void __iomem *reg;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pin_to_reg_bank(drvdata->gc, pin - drvdata->ctrl->base, &reg,
+					&pin_offset, &bank);
+
+	switch (PINCFG_UNPACK_TYPE(config)) {
+	case PINCFG_TYPE_PUD:
+		samsung_pinconf_set_pud(drvdata, bank, reg, pin_offset, config);
+		break;
+	case PINCFG_TYPE_DRV:
+		samsung_pinconf_set_drv(drvdata, bank, reg, pin_offset, config);
+		break;
+	}
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
+	const unsigned int *pins;
+	unsigned int cnt;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+	pins = drvdata->pin_groups[group].pins;
+
+	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++)
+		samsung_pinconf_set(pctldev, pins[cnt], config);
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
+	writel(data, reg + DAT_REG);
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
+	samsung_gpio_set(gc, offset, value);
+	return pinctrl_gpio_direction_output(gc->base + offset);
+}
+
+/*
+ * Parse the pin names listed in the 'samsung,pins' property and convert it
+ * into a list of gpio numbers are create a pin group from it.
+ */
+static int __init samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
+			struct device_node *cfg_np, struct pinctrl_desc *pctl,
+			unsigned int **pin_list, unsigned int *npins)
+{
+	struct device *dev = &pdev->dev;
+	struct property *prop;
+	struct pinctrl_pin_desc const *pdesc = pctl->pins;
+	unsigned int idx = 0, cnt;
+	const char *pin_name;
+
+	*npins = of_property_count_strings(cfg_np, "samsung,pins");
+	if (*npins < 0) {
+		dev_err(dev, "invalid pin list in %s node", cfg_np->name);
+		return -EINVAL;
+	}
+
+	*pin_list = devm_kzalloc(dev, *npins * sizeof(**pin_list), GFP_KERNEL);
+	if (!*pin_list) {
+		dev_err(dev, "failed to allocate memory for pin list\n");
+		return -ENOMEM;
+	}
+
+	of_property_for_each_string(cfg_np, "samsung,pins", prop, pin_name) {
+		for (cnt = 0; cnt < pctl->npins; cnt++) {
+			if (pdesc[cnt].name) {
+				if (!strcmp(pin_name, pdesc[cnt].name)) {
+					(*pin_list)[idx++] = pdesc[cnt].number;
+					break;
+				}
+			}
+		}
+		if (cnt == pctl->npins) {
+			dev_err(dev, "pin %s not valid in %s node\n",
+					pin_name, cfg_np->name);
+			devm_kfree(dev, *pin_list);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Parse the information about all the available pin groups and pin functions
+ * from device node of the pin-controller. A pin group is formed with all
+ * the pins listed in the "samsung,pins" property.
+ */
+static int __init samsung_pinctrl_parse_dt(struct platform_device *pdev,
+				struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *dev_np = dev->of_node;
+	struct device_node *cfg_np;
+	struct samsung_pin_group *groups, *grp;
+	struct samsung_pmx_func *functions, *func;
+	unsigned *pin_list;
+	unsigned int npins, grp_cnt, func_idx = 0;
+	char *gname, *fname;
+	int ret;
+
+	grp_cnt = of_get_child_count(dev_np);
+	if (!grp_cnt)
+		return -EINVAL;
+
+	groups = devm_kzalloc(dev, grp_cnt * sizeof(*groups), GFP_KERNEL);
+	if (!groups) {
+		dev_err(dev, "failed allocate memory for ping group list\n");
+		return -EINVAL;
+	}
+	grp = groups;
+
+	functions = devm_kzalloc(dev, grp_cnt * sizeof(*functions), GFP_KERNEL);
+	if (!functions) {
+		dev_err(dev, "failed to allocate memory for function list\n");
+		return -EINVAL;
+	}
+	func = functions;
+
+	/*
+	 * Iterate over all the child nodes of the pin controller node
+	 * and create pin groups and pin function lists.
+	 */
+	for_each_child_of_node(dev_np, cfg_np) {
+		ret = samsung_pinctrl_parse_dt_pins(pdev, cfg_np, drvdata->pctl,
+							&pin_list, &npins);
+		if (ret)
+			return ret;
+
+		/* derive pin group name from the node name */
+		gname = devm_kzalloc(dev, strlen(cfg_np->name) + 4, GFP_KERNEL);
+		if (!gname) {
+			dev_err(dev, "failed to alloc memory for group name\n");
+			return -ENOMEM;
+		}
+		sprintf(gname, "%s-grp", cfg_np->name);
+
+		grp->name = gname;
+		grp->pins = pin_list;
+		grp->num_pins = npins;
+		of_property_read_u32(cfg_np, "samsung,pin-function",
+						&grp->func);
+		grp++;
+
+		if (!of_find_property(cfg_np, "samsung,pin-function", NULL))
+			continue;
+
+		/* derive function name from the node name */
+		fname = devm_kzalloc(dev, strlen(cfg_np->name) + 4, GFP_KERNEL);
+		if (!fname) {
+			dev_err(dev, "failed to alloc memory for func name\n");
+			return -ENOMEM;
+		}
+		sprintf(fname, "%s-mux", cfg_np->name);
+
+		func->name = fname;
+		func->groups = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
+		if (!func->groups) {
+			dev_err(dev, "failed to alloc memory for group list "
+					"in pin function");
+			return -ENOMEM;
+		}
+		func->groups[0] = gname;
+		func->num_groups = 1;
+		func++;
+		func_idx++;
+	}
+
+	drvdata->pin_groups = groups;
+	drvdata->nr_groups = grp_cnt;
+	drvdata->pmx_functions = functions;
+	drvdata->nr_functions = func_idx;
+
+	return 0;
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
+	int pin, bank, ret;
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
+	if (pdev->dev.of_node) {
+		ret = samsung_pinctrl_parse_dt(pdev, drvdata);
+		if (ret) {
+			pinctrl_unregister(drvdata->pctl_dev);
+			return ret;
+		}
+	}
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
+/* unregister the gpiolib interface with the gpiolib subsystem */
+static int __init samsung_gpiolib_unregister(struct platform_device *pdev,
+				struct samsung_pinctrl_drv_data *drvdata)
+{
+	int ret = gpiochip_remove(drvdata->gc);
+	if (ret) {
+		dev_err(&pdev->dev, "gpio chip remove failed\n");
+		return ret;
+	}
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
+		int id;
+		const struct of_device_id *match;
+		const struct device_node *node = pdev->dev.of_node;
+
+		id = of_alias_get_id(pdev->dev.of_node, "pinctrl");
+		if (id < 0) {
+			dev_err(&pdev->dev, "failed to get alias id\n");
+			return NULL;
+		}
+		match = of_match_node(samsung_pinctrl_dt_match, node);
+		return (struct samsung_pinctrl_drv_data *)match->data + id;
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
+	drvdata->virt_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!drvdata->virt_base) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -ENODEV;
+	}
+
+	ret = samsung_gpiolib_register(pdev, drvdata);
+	if (ret)
+		return ret;
+
+	ret = samsung_pinctrl_register(pdev, drvdata);
+	if (ret) {
+		samsung_gpiolib_unregister(pdev, drvdata);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+	return 0;
+}
+
+/* driver data for various samsung soc's */
+#ifdef CONFIG_CPU_EXYNOS4210
+#define EXYNOS4210_PCTRL_DRVDATA (&exynos4210_pinctrl_drv_data)
+#else
+#define EXYNOS4210_PCTRL_DRVDATA (NULL)
+#endif /* CONFIG_CPU_EXYNOS4210 */
+
+static struct platform_device_id samsung_pinctrl_driver_ids[] = {
+	{
+		.name		= "exynos4-pinctrl",
+		.driver_data	= (kernel_ulong_t)EXYNOS4210_PCTRL_DRVDATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, samsung_pinctrl_driver_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id samsung_pinctrl_dt_match[] = {
+#ifdef CONFIG_CPU_EXYNOS4210
+	{ .compatible = "samsung,pinctrl-exynos4210",
+		.data = (void *)exynos4210_pinctrl_drv_data },
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
index 0000000..a367769
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -0,0 +1,170 @@
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
+#include <plat/pinctrl-samsung.h>
+
+/* register offsets within a pin bank */
+#define DAT_REG		0x4
+#define PUD_REG		0x8
+#define DRV_REG		0xC
+
+/* pinmux function number for pin as gpio output line */
+#define FUNC_OUTPUT	0x1
+
+/* Pin configuration types */
+#define PINCFG_TYPE_PUD			0
+#define PINCFG_TYPE_DRV			1
+#define PINCFG_TYPE_CON_PND		2
+#define PINCFG_TYPE_PUD_PND		3
+#define PINCFG_TYPE_MASK		0xFF
+
+#define PUD_NONE	0
+#define PUD_DOWN	1
+#define PUD_UP		2
+
+#define DRV_1X		0
+#define DRV_2X		1
+#define DRV_3X		2
+#define DRV_4X		3
+
+#define PINCFG_VALUE_SHIFT		8
+#define PINCFG_VALUE_MASK		(0xFF << PINCFG_VALUE_SHIFT)
+
+#define PINCFG_PACK(type, value)	(((value) << PINCFG_VALUE_SHIFT) | type)
+#define PINCFG_UNPACK_TYPE(cfg)		((cfg) & PINCFG_TYPE_MASK)
+#define PINCFG_UNPACK_VALUE(cfg)	(((cfg) & PINCFG_VALUE_MASK) >> \
+						PINCFG_VALUE_SHIFT)
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
+ * @irq_base: starting linux virq number of the bank.
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
+	unsigned int			irq_base;
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
+	unsigned int		num_pins;
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
+	const char		**groups;
+	unsigned		num_groups;
+};
+
+extern struct samsung_pinctrl_drv_data exynos4210_pinctrl_drv_data[];
+
+#endif /* __PINCTRL_SAMSUNG_H */
-- 
1.6.6.rc2

