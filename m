Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3AHVnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:43:40 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:45505 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3AHVnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:43:32 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] ARM: sunxi: Add pinctrl driver for Allwinner SoCs
Date: Tue,  8 Jan 2013 22:43:13 +0100
Message-Id: <1357681398-23956-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner SoCs have an IP module that handle both the muxing and the
GPIOs.

This IP has 8 banks of 32 bits, with a number of pins actually useful
for each of these banks varying from one to another, and depending on
the SoC used on the board.

This driver only implements the pinctrl part, the gpio part will come
eventually.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   60 +++
 arch/arm/mach-sunxi/Kconfig                        |    1 +
 drivers/pinctrl/Kconfig                            |    5 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-sunxi.c                    |  549 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.h                    |  384 ++++++++++++++
 6 files changed, 1000 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-sunxi.c
 create mode 100644 drivers/pinctrl/pinctrl-sunxi.h

diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
new file mode 100644
index 0000000..dff0e5f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -0,0 +1,60 @@
+* Allwinner A1X Pin Controller
+
+The pins controlled by sunXi pin controller are organized in banks,
+each bank has 32 pins.  Each pin has 7 multiplexing functions, with
+the first two functions being GPIO in and out. The configuration on
+the pins includes drive strength and pull-up.
+
+Required properties:
+- compatible: "allwinner,<soc>-pinctrl". Supported SoCs for now are:
+  sun5i-a13.
+- reg: Should contain the register physical address and length for the
+  pin controller.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices.
+
+A pinctrl node should contain at least one subnodes representing the
+pinctrl groups available on the machine. Each subnode will list the
+pins it needs, and how they should be configured, with regard to muxer
+configuration, drive strength and pullups. If one of these options is
+not set, its actual value will be unspecified.
+
+Required subnode-properties:
+
+- allwinner,pins: List of strings containing the pin name.
+- allwinner,function: Function to mux the pins listed above to.
+
+Optional subnode-properties:
+- allwinner,drive: Integer. Represents the current sent to the pin
+    0: 10 mA
+    1: 20 mA
+    2: 30 mA
+    3: 40 mA
+- allwinner,pull: Integer.
+    0: No resistor
+    1: Pull-up resistor
+    2: Pull-down resistor
+
+Examples:
+
+pinctrl@01c20800 {
+	compatible = "allwinner,sun5i-a13-pinctrl";
+	reg = <0x01c20800 0x400>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	uart1_pins_a: uart1@0 {
+		allwinner,pins = "PE10", "PE11";
+		allwinner,function = "uart1";
+		allwinner,drive = <0>;
+		allwinner,pull = <0>;
+	};
+
+	uart1_pins_b: uart1@1 {
+		allwinner,pins = "PG3", "PG4";
+		allwinner,function = "uart1";
+		allwinner,drive = <0>;
+		allwinner,pull = <0>;
+	};
+};
diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
index 3fdd008..8709a39 100644
--- a/arch/arm/mach-sunxi/Kconfig
+++ b/arch/arm/mach-sunxi/Kconfig
@@ -7,3 +7,4 @@ config ARCH_SUNXI
 	select PINCTRL
 	select SPARSE_IRQ
 	select SUNXI_TIMER
+	select PINCTRL_SUNXI
\ No newline at end of file
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c31aeb0..88840a4 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -151,6 +151,11 @@ config PINCTRL_SIRF
 	depends on ARCH_SIRF
 	select PINMUX
 
+config PINCTRL_SUNXI
+	bool
+	select PINMUX
+	select GENERIC_PINCONF
+
 config PINCTRL_TEGRA
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index fc4606f..a2427da 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
 obj-$(CONFIG_PINCTRL_PXA910)	+= pinctrl-pxa910.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
+obj-$(CONFIG_PINCTRL_SUNXI)	+= pinctrl-sunxi.o
 obj-$(CONFIG_PINCTRL_TEGRA)	+= pinctrl-tegra.o
 obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
new file mode 100644
index 0000000..1b85a81
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -0,0 +1,549 @@
+/*
+ * Allwinner A1X SoCs pinctrl driver.
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
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "core.h"
+#include "pinctrl-sunxi.h"
+
+static struct sunxi_pinctrl_group *
+sunxi_pinctrl_find_group_by_name(struct sunxi_pinctrl *pctl, const char *group)
+{
+	int i;
+
+	for (i = 0; i < pctl->ngroups; i++) {
+		struct sunxi_pinctrl_group *grp = pctl->groups + i;
+
+		if (!strcmp(grp->name, group))
+			return grp;
+	}
+
+	return NULL;
+}
+
+static struct sunxi_pinctrl_function *
+sunxi_pinctrl_find_function_by_name(struct sunxi_pinctrl *pctl,
+				    const char *name)
+{
+	struct sunxi_pinctrl_function *func = pctl->functions;
+	int i;
+
+	for (i = 0; i < pctl->nfunctions; i++) {
+		if (!func[i].name)
+			break;
+
+		if (!strcmp(func[i].name, name))
+			return func + i;
+	}
+
+	return NULL;
+}
+
+static struct sunxi_desc_function *
+sunxi_pinctrl_desc_find_function_by_name(struct sunxi_pinctrl *pctl,
+					 const char *pin_name,
+					 const char *func_name)
+{
+	int i;
+
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+
+		if (!strcmp(pin->pin.name, pin_name)) {
+			struct sunxi_desc_function *func = pin->functions;
+
+			while (func->name) {
+				if (!strcmp(func->name, func_name))
+					return func;
+
+				func++;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static int sunxi_pctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->ngroups;
+}
+
+static const char *sunxi_pctrl_get_group_name(struct pinctrl_dev *pctldev,
+					      unsigned group)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->groups[group].name;
+}
+
+static int sunxi_pctrl_get_group_pins(struct pinctrl_dev *pctldev,
+				      unsigned group,
+				      const unsigned **pins,
+				      unsigned *num_pins)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = (unsigned *)&pctl->groups[group].pin;
+	*num_pins = 1;
+
+	return 0;
+}
+
+static int sunxi_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				      struct device_node *node,
+				      struct pinctrl_map **map,
+				      unsigned *num_maps)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	unsigned long *pinconfig;
+	struct property *prop;
+	const char *function;
+	const char *group;
+	int ret, nmaps, i = 0;
+	u32 val;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = of_property_read_string(node, "allwinner,function", &function);
+	if (ret) {
+		dev_err(pctl->dev,
+			"missing allwinner,function property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	nmaps = of_property_count_strings(node, "allwinner,pins") * 2;
+	if (nmaps < 0) {
+		dev_err(pctl->dev,
+			"missing allwinner,pins property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	*map = kmalloc(nmaps * sizeof(struct pinctrl_map), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	of_property_for_each_string(node, "allwinner,pins", prop, group) {
+		struct sunxi_pinctrl_group *grp =
+			sunxi_pinctrl_find_group_by_name(pctl, group);
+		int j = 0, configlen = 0;
+
+		if (!grp) {
+			dev_err(pctl->dev, "unknown pin %s", group);
+			continue;
+		}
+
+		if (!sunxi_pinctrl_desc_find_function_by_name(pctl,
+							      grp->name,
+							      function)) {
+			dev_err(pctl->dev, "unsupported function %s on pin %s",
+				function, group);
+			continue;
+		}
+
+		(*map)[i].type = PIN_MAP_TYPE_MUX_GROUP;
+		(*map)[i].data.mux.group = group;
+		(*map)[i].data.mux.function = function;
+
+		i++;
+
+		(*map)[i].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+		(*map)[i].data.configs.group_or_pin = group;
+
+		if (of_find_property(node, "allwinner,drive", NULL))
+			configlen++;
+		if (of_find_property(node, "allwinner,pull", NULL))
+			configlen++;
+
+		pinconfig = kzalloc(configlen * sizeof(*pinconfig), GFP_KERNEL);
+
+		if (!of_property_read_u32(node, "allwinner,drive", &val)) {
+			u16 strength = (val + 1) * 10;
+			pinconfig[j++] =
+				pinconf_to_config_packed(PIN_CONFIG_DRIVE_STRENGTH,
+							 strength);
+		}
+
+		if (!of_property_read_u32(node, "allwinner,pull", &val)) {
+			enum pin_config_param pull = PIN_CONFIG_END;
+			if (val == 1)
+				pull = PIN_CONFIG_BIAS_PULL_UP;
+			else if (val == 2)
+				pull = PIN_CONFIG_BIAS_PULL_DOWN;
+			pinconfig[j++] = pinconf_to_config_packed(pull, 0);
+		}
+
+		(*map)[i].data.configs.configs = pinconfig;
+		(*map)[i].data.configs.num_configs = configlen;
+
+		i++;
+	}
+
+	*num_maps = nmaps;
+
+	return 0;
+}
+
+static void sunxi_pctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				    struct pinctrl_map *map,
+				    unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++) {
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+	}
+
+	kfree(map);
+}
+
+static struct pinctrl_ops sunxi_pctrl_ops = {
+	.dt_node_to_map		= sunxi_pctrl_dt_node_to_map,
+	.dt_free_map		= sunxi_pctrl_dt_free_map,
+	.get_groups_count	= sunxi_pctrl_get_groups_count,
+	.get_group_name		= sunxi_pctrl_get_group_name,
+	.get_group_pins		= sunxi_pctrl_get_group_pins,
+};
+
+static int sunxi_pconf_group_get(struct pinctrl_dev *pctldev,
+				 unsigned group,
+				 unsigned long *config)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	*config = pctl->groups[group].config;
+
+	return 0;
+}
+
+static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
+				 unsigned group,
+				 unsigned long config)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct sunxi_pinctrl_group *g = &pctl->groups[group];
+	u32 val, mask;
+	u16 strength;
+	u8 dlevel;
+
+	switch (pinconf_to_config_param(config)) {
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		strength = pinconf_to_config_argument(config);
+		/*
+		 * We convert from mA to what the register expects:
+		 *   - 0: 10mA
+		 *   - 1: 20mA
+		 *   - 2: 30mA
+		 *   - 3: 40mA
+		 */
+		dlevel = strength / 10 - 1;
+		val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
+		mask = ((1 << DLEVEL_PINS_BITS) - 1) << sunxi_dlevel_offset(g->pin);
+		val &= ~mask;
+		val |= dlevel << sunxi_dlevel_offset(g->pin);
+		writel(val, pctl->membase + sunxi_dlevel_reg(g->pin));
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		val = readl(pctl->membase + sunxi_pull_reg(g->pin));
+		mask = ((1 << PULL_PINS_BITS) - 1) << sunxi_pull_offset(g->pin);
+		val &= ~mask;
+		val |= 1 << sunxi_pull_offset(g->pin);
+		writel(val, pctl->membase + sunxi_pull_reg(g->pin));
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		val = readl(pctl->membase + sunxi_pull_reg(g->pin));
+		mask = ((1 << PULL_PINS_BITS) - 1) << sunxi_pull_offset(g->pin);
+		val &= ~mask;
+		val |= 2 << sunxi_pull_offset(g->pin);
+		writel(val, pctl->membase + sunxi_pull_reg(g->pin));
+		break;
+	default:
+		break;
+	}
+
+	/* cache the config value */
+	g->config = config;
+
+	return 0;
+}
+
+static struct pinconf_ops sunxi_pconf_ops = {
+	.pin_config_group_get	= sunxi_pconf_group_get,
+	.pin_config_group_set	= sunxi_pconf_group_set,
+};
+
+static int sunxi_pmx_get_funcs_cnt(struct pinctrl_dev *pctldev)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->nfunctions;
+}
+
+static const char *sunxi_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					   unsigned function)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->functions[function].name;
+}
+
+static int sunxi_pmx_get_func_groups(struct pinctrl_dev *pctldev,
+				     unsigned function,
+				     const char * const **groups,
+				     unsigned * const num_groups)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = pctl->functions[function].groups;
+	*num_groups = pctl->functions[function].ngroups;
+
+	return 0;
+}
+
+static void sunxi_pmx_set(struct pinctrl_dev *pctldev,
+				 unsigned pin,
+				 u8 config)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	u32 val = readl(pctl->membase + sunxi_mux_reg(pin));
+	u32 mask = ((1 << MUX_PINS_BITS) - 1) << sunxi_mux_offset(pin);
+	writel((val & ~mask) | config << sunxi_mux_offset(pin),
+		pctl->membase + sunxi_mux_reg(pin));
+}
+
+static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
+			    unsigned function,
+			    unsigned group)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct sunxi_pinctrl_group *g = pctl->groups + group;
+	struct sunxi_pinctrl_function *func = pctl->functions + function;
+	struct sunxi_desc_function *desc =
+		sunxi_pinctrl_desc_find_function_by_name(pctl,
+							 g->name,
+							 func->name);
+
+	if (!desc)
+		return -EINVAL;
+
+	sunxi_pmx_set(pctldev, g->pin, desc->muxval);
+
+	return 0;
+}
+
+static struct pinmux_ops sunxi_pmx_ops = {
+	.get_functions_count	= sunxi_pmx_get_funcs_cnt,
+	.get_function_name	= sunxi_pmx_get_func_name,
+	.get_function_groups	= sunxi_pmx_get_func_groups,
+	.enable			= sunxi_pmx_enable,
+};
+
+static struct pinctrl_desc sunxi_pctrl_desc = {
+	.confops	= &sunxi_pconf_ops,
+	.pctlops	= &sunxi_pctrl_ops,
+	.pmxops		= &sunxi_pmx_ops,
+};
+
+static struct of_device_id sunxi_pinctrl_match[] __devinitconst = {
+	{}
+};
+MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);
+
+static int __devinit sunxi_pinctrl_add_function(struct sunxi_pinctrl *pctl,
+					const char *name)
+{
+	struct sunxi_pinctrl_function *func = pctl->functions;
+
+	while (func->name) {
+		/* function already there */
+		if (strcmp(func->name, name) == 0) {
+			func->ngroups++;
+			return -EEXIST;
+		}
+		func++;
+	}
+
+	func->name = name;
+	func->ngroups = 1;
+
+	pctl->nfunctions++;
+
+	return 0;
+}
+
+static int __devinit sunxi_pinctrl_build_state(struct platform_device *pdev)
+{
+	struct sunxi_pinctrl *pctl = platform_get_drvdata(pdev);
+	int i;
+
+	pctl->ngroups = pctl->desc->npins;
+
+	/* Allocate groups */
+	pctl->groups = devm_kzalloc(&pdev->dev,
+				    pctl->ngroups * sizeof(*pctl->groups),
+				    GFP_KERNEL);
+	if (!pctl->groups)
+		return -ENOMEM;
+
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+		struct sunxi_pinctrl_group *group = pctl->groups + i;
+
+		group->name = pin->pin.name;
+		group->pin = pin->pin.number;
+	}
+
+	/*
+	 * We suppose that we won't have any more functions than pins,
+	 * we'll reallocate that later anyway
+	 */
+	pctl->functions = devm_kzalloc(&pdev->dev,
+				pctl->desc->npins * sizeof(*pctl->functions),
+				GFP_KERNEL);
+	if (!pctl->functions)
+		return -ENOMEM;
+
+	/* Count functions and their associated groups */
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+		struct sunxi_desc_function *func = pin->functions;
+
+		while (func->name) {
+			sunxi_pinctrl_add_function(pctl, func->name);
+			func++;
+		}
+	}
+
+	pctl->functions = krealloc(pctl->functions,
+				pctl->nfunctions * sizeof(*pctl->functions),
+				GFP_KERNEL);
+
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+		struct sunxi_desc_function *func = pin->functions;
+
+		while (func->name) {
+			struct sunxi_pinctrl_function *func_item;
+			const char **func_grp;
+
+			func_item = sunxi_pinctrl_find_function_by_name(pctl,
+									func->name);
+			if (!func_item)
+				return -EINVAL;
+
+			if (!func_item->groups) {
+				func_item->groups =
+					devm_kzalloc(&pdev->dev,
+						     func_item->ngroups * sizeof(*func_item->groups),
+						     GFP_KERNEL);
+				if (!func_item->groups)
+					return -ENOMEM;
+			}
+
+			func_grp = func_item->groups;
+			while (*func_grp)
+				func_grp++;
+
+			*func_grp = pin->pin.name;
+			func++;
+		}
+	}
+
+	return 0;
+}
+
+static int __devinit sunxi_pinctrl_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	const struct of_device_id *device;
+	struct pinctrl_pin_desc *pins;
+	struct sunxi_pinctrl *pctl;
+	int i, ret;
+
+	pctl = devm_kzalloc(&pdev->dev, sizeof(*pctl), GFP_KERNEL);
+	if (!pctl)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, pctl);
+
+	pctl->membase = of_iomap(node, 0);
+	if (!pctl->membase)
+		return -ENOMEM;
+
+	device = of_match_device(sunxi_pinctrl_match, &pdev->dev);
+	if (!device)
+		return -ENODEV;
+
+	pctl->desc = (struct sunxi_pinctrl_desc *)device->data;
+
+	ret = sunxi_pinctrl_build_state(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "dt probe failed: %d\n", ret);
+		return ret;
+	}
+
+	pins = devm_kzalloc(&pdev->dev,
+			    pctl->desc->npins * sizeof(*pins),
+			    GFP_KERNEL);
+	if (!pins)
+		return -ENOMEM;
+
+	for (i = 0; i < pctl->desc->npins; i++)
+		pins[i] = pctl->desc->pins[i].pin;
+
+	sunxi_pctrl_desc.name = dev_name(&pdev->dev);
+	sunxi_pctrl_desc.owner = THIS_MODULE;
+	sunxi_pctrl_desc.pins = pins;
+	sunxi_pctrl_desc.npins = pctl->desc->npins;
+	pctl->dev = &pdev->dev;
+	pctl->pctl_dev = pinctrl_register(&sunxi_pctrl_desc,
+					  &pdev->dev, pctl);
+	if (!pctl->pctl_dev) {
+		dev_err(&pdev->dev, "couldn't register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	dev_info(&pdev->dev, "initialized sunXi pin control driver\n");
+
+	return 0;
+}
+
+static struct platform_driver sunxi_pinctrl_driver = {
+	.probe = sunxi_pinctrl_probe,
+	.driver = {
+		.name = "sunxi-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = sunxi_pinctrl_match,
+	},
+};
+module_platform_driver(sunxi_pinctrl_driver);
+
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_DESCRIPTION("Allwinner A1X pinctrl driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
new file mode 100644
index 0000000..34f2496
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -0,0 +1,384 @@
+/*
+ * Allwinner A1X SoCs pinctrl driver.
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
+#ifndef __PINCTRL_SUNXI_H
+#define __PINCTRL_SUNXI_H
+
+#include <linux/kernel.h>
+
+#define PA_BASE	0
+#define PB_BASE	32
+#define PC_BASE	64
+#define PD_BASE	96
+#define PE_BASE	128
+#define PF_BASE	160
+#define PG_BASE	192
+
+#define SUNXI_PINCTRL_PIN_PA0	PINCTRL_PIN(PA_BASE + 0, "PA0")
+#define SUNXI_PINCTRL_PIN_PA1	PINCTRL_PIN(PA_BASE + 1, "PA1")
+#define SUNXI_PINCTRL_PIN_PA2	PINCTRL_PIN(PA_BASE + 2, "PA2")
+#define SUNXI_PINCTRL_PIN_PA3	PINCTRL_PIN(PA_BASE + 3, "PA3")
+#define SUNXI_PINCTRL_PIN_PA4	PINCTRL_PIN(PA_BASE + 4, "PA4")
+#define SUNXI_PINCTRL_PIN_PA5	PINCTRL_PIN(PA_BASE + 5, "PA5")
+#define SUNXI_PINCTRL_PIN_PA6	PINCTRL_PIN(PA_BASE + 6, "PA6")
+#define SUNXI_PINCTRL_PIN_PA7	PINCTRL_PIN(PA_BASE + 7, "PA7")
+#define SUNXI_PINCTRL_PIN_PA8	PINCTRL_PIN(PA_BASE + 8, "PA8")
+#define SUNXI_PINCTRL_PIN_PA9	PINCTRL_PIN(PA_BASE + 9, "PA9")
+#define SUNXI_PINCTRL_PIN_PA10	PINCTRL_PIN(PA_BASE + 10, "PA10")
+#define SUNXI_PINCTRL_PIN_PA11	PINCTRL_PIN(PA_BASE + 11, "PA11")
+#define SUNXI_PINCTRL_PIN_PA12	PINCTRL_PIN(PA_BASE + 12, "PA12")
+#define SUNXI_PINCTRL_PIN_PA13	PINCTRL_PIN(PA_BASE + 13, "PA13")
+#define SUNXI_PINCTRL_PIN_PA14	PINCTRL_PIN(PA_BASE + 14, "PA14")
+#define SUNXI_PINCTRL_PIN_PA15	PINCTRL_PIN(PA_BASE + 15, "PA15")
+#define SUNXI_PINCTRL_PIN_PA16	PINCTRL_PIN(PA_BASE + 16, "PA16")
+#define SUNXI_PINCTRL_PIN_PA17	PINCTRL_PIN(PA_BASE + 17, "PA17")
+#define SUNXI_PINCTRL_PIN_PA18	PINCTRL_PIN(PA_BASE + 18, "PA18")
+#define SUNXI_PINCTRL_PIN_PA19	PINCTRL_PIN(PA_BASE + 19, "PA19")
+#define SUNXI_PINCTRL_PIN_PA20	PINCTRL_PIN(PA_BASE + 20, "PA20")
+#define SUNXI_PINCTRL_PIN_PA21	PINCTRL_PIN(PA_BASE + 21, "PA21")
+#define SUNXI_PINCTRL_PIN_PA22	PINCTRL_PIN(PA_BASE + 22, "PA22")
+#define SUNXI_PINCTRL_PIN_PA23	PINCTRL_PIN(PA_BASE + 23, "PA23")
+#define SUNXI_PINCTRL_PIN_PA24	PINCTRL_PIN(PA_BASE + 24, "PA24")
+#define SUNXI_PINCTRL_PIN_PA25	PINCTRL_PIN(PA_BASE + 25, "PA25")
+#define SUNXI_PINCTRL_PIN_PA26	PINCTRL_PIN(PA_BASE + 26, "PA26")
+#define SUNXI_PINCTRL_PIN_PA27	PINCTRL_PIN(PA_BASE + 27, "PA27")
+#define SUNXI_PINCTRL_PIN_PA28	PINCTRL_PIN(PA_BASE + 28, "PA28")
+#define SUNXI_PINCTRL_PIN_PA29	PINCTRL_PIN(PA_BASE + 29, "PA29")
+#define SUNXI_PINCTRL_PIN_PA30	PINCTRL_PIN(PA_BASE + 30, "PA30")
+#define SUNXI_PINCTRL_PIN_PA31	PINCTRL_PIN(PA_BASE + 31, "PA31")
+
+#define SUNXI_PINCTRL_PIN_PB0	PINCTRL_PIN(PB_BASE + 0, "PB0")
+#define SUNXI_PINCTRL_PIN_PB1	PINCTRL_PIN(PB_BASE + 1, "PB1")
+#define SUNXI_PINCTRL_PIN_PB2	PINCTRL_PIN(PB_BASE + 2, "PB2")
+#define SUNXI_PINCTRL_PIN_PB3	PINCTRL_PIN(PB_BASE + 3, "PB3")
+#define SUNXI_PINCTRL_PIN_PB4	PINCTRL_PIN(PB_BASE + 4, "PB4")
+#define SUNXI_PINCTRL_PIN_PB5	PINCTRL_PIN(PB_BASE + 5, "PB5")
+#define SUNXI_PINCTRL_PIN_PB6	PINCTRL_PIN(PB_BASE + 6, "PB6")
+#define SUNXI_PINCTRL_PIN_PB7	PINCTRL_PIN(PB_BASE + 7, "PB7")
+#define SUNXI_PINCTRL_PIN_PB8	PINCTRL_PIN(PB_BASE + 8, "PB8")
+#define SUNXI_PINCTRL_PIN_PB9	PINCTRL_PIN(PB_BASE + 9, "PB9")
+#define SUNXI_PINCTRL_PIN_PB10	PINCTRL_PIN(PB_BASE + 10, "PB10")
+#define SUNXI_PINCTRL_PIN_PB11	PINCTRL_PIN(PB_BASE + 11, "PB11")
+#define SUNXI_PINCTRL_PIN_PB12	PINCTRL_PIN(PB_BASE + 12, "PB12")
+#define SUNXI_PINCTRL_PIN_PB13	PINCTRL_PIN(PB_BASE + 13, "PB13")
+#define SUNXI_PINCTRL_PIN_PB14	PINCTRL_PIN(PB_BASE + 14, "PB14")
+#define SUNXI_PINCTRL_PIN_PB15	PINCTRL_PIN(PB_BASE + 15, "PB15")
+#define SUNXI_PINCTRL_PIN_PB16	PINCTRL_PIN(PB_BASE + 16, "PB16")
+#define SUNXI_PINCTRL_PIN_PB17	PINCTRL_PIN(PB_BASE + 17, "PB17")
+#define SUNXI_PINCTRL_PIN_PB18	PINCTRL_PIN(PB_BASE + 18, "PB18")
+#define SUNXI_PINCTRL_PIN_PB19	PINCTRL_PIN(PB_BASE + 19, "PB19")
+#define SUNXI_PINCTRL_PIN_PB20	PINCTRL_PIN(PB_BASE + 20, "PB20")
+#define SUNXI_PINCTRL_PIN_PB21	PINCTRL_PIN(PB_BASE + 21, "PB21")
+#define SUNXI_PINCTRL_PIN_PB22	PINCTRL_PIN(PB_BASE + 22, "PB22")
+#define SUNXI_PINCTRL_PIN_PB23	PINCTRL_PIN(PB_BASE + 23, "PB23")
+#define SUNXI_PINCTRL_PIN_PB24	PINCTRL_PIN(PB_BASE + 24, "PB24")
+#define SUNXI_PINCTRL_PIN_PB25	PINCTRL_PIN(PB_BASE + 25, "PB25")
+#define SUNXI_PINCTRL_PIN_PB26	PINCTRL_PIN(PB_BASE + 26, "PB26")
+#define SUNXI_PINCTRL_PIN_PB27	PINCTRL_PIN(PB_BASE + 27, "PB27")
+#define SUNXI_PINCTRL_PIN_PB28	PINCTRL_PIN(PB_BASE + 28, "PB28")
+#define SUNXI_PINCTRL_PIN_PB29	PINCTRL_PIN(PB_BASE + 29, "PB29")
+#define SUNXI_PINCTRL_PIN_PB30	PINCTRL_PIN(PB_BASE + 30, "PB30")
+#define SUNXI_PINCTRL_PIN_PB31	PINCTRL_PIN(PB_BASE + 31, "PB31")
+
+#define SUNXI_PINCTRL_PIN_PC0	PINCTRL_PIN(PC_BASE + 0, "PC0")
+#define SUNXI_PINCTRL_PIN_PC1	PINCTRL_PIN(PC_BASE + 1, "PC1")
+#define SUNXI_PINCTRL_PIN_PC2	PINCTRL_PIN(PC_BASE + 2, "PC2")
+#define SUNXI_PINCTRL_PIN_PC3	PINCTRL_PIN(PC_BASE + 3, "PC3")
+#define SUNXI_PINCTRL_PIN_PC4	PINCTRL_PIN(PC_BASE + 4, "PC4")
+#define SUNXI_PINCTRL_PIN_PC5	PINCTRL_PIN(PC_BASE + 5, "PC5")
+#define SUNXI_PINCTRL_PIN_PC6	PINCTRL_PIN(PC_BASE + 6, "PC6")
+#define SUNXI_PINCTRL_PIN_PC7	PINCTRL_PIN(PC_BASE + 7, "PC7")
+#define SUNXI_PINCTRL_PIN_PC8	PINCTRL_PIN(PC_BASE + 8, "PC8")
+#define SUNXI_PINCTRL_PIN_PC9	PINCTRL_PIN(PC_BASE + 9, "PC9")
+#define SUNXI_PINCTRL_PIN_PC10	PINCTRL_PIN(PC_BASE + 10, "PC10")
+#define SUNXI_PINCTRL_PIN_PC11	PINCTRL_PIN(PC_BASE + 11, "PC11")
+#define SUNXI_PINCTRL_PIN_PC12	PINCTRL_PIN(PC_BASE + 12, "PC12")
+#define SUNXI_PINCTRL_PIN_PC13	PINCTRL_PIN(PC_BASE + 13, "PC13")
+#define SUNXI_PINCTRL_PIN_PC14	PINCTRL_PIN(PC_BASE + 14, "PC14")
+#define SUNXI_PINCTRL_PIN_PC15	PINCTRL_PIN(PC_BASE + 15, "PC15")
+#define SUNXI_PINCTRL_PIN_PC16	PINCTRL_PIN(PC_BASE + 16, "PC16")
+#define SUNXI_PINCTRL_PIN_PC17	PINCTRL_PIN(PC_BASE + 17, "PC17")
+#define SUNXI_PINCTRL_PIN_PC18	PINCTRL_PIN(PC_BASE + 18, "PC18")
+#define SUNXI_PINCTRL_PIN_PC19	PINCTRL_PIN(PC_BASE + 19, "PC19")
+#define SUNXI_PINCTRL_PIN_PC20	PINCTRL_PIN(PC_BASE + 20, "PC20")
+#define SUNXI_PINCTRL_PIN_PC21	PINCTRL_PIN(PC_BASE + 21, "PC21")
+#define SUNXI_PINCTRL_PIN_PC22	PINCTRL_PIN(PC_BASE + 22, "PC22")
+#define SUNXI_PINCTRL_PIN_PC23	PINCTRL_PIN(PC_BASE + 23, "PC23")
+#define SUNXI_PINCTRL_PIN_PC24	PINCTRL_PIN(PC_BASE + 24, "PC24")
+#define SUNXI_PINCTRL_PIN_PC25	PINCTRL_PIN(PC_BASE + 25, "PC25")
+#define SUNXI_PINCTRL_PIN_PC26	PINCTRL_PIN(PC_BASE + 26, "PC26")
+#define SUNXI_PINCTRL_PIN_PC27	PINCTRL_PIN(PC_BASE + 27, "PC27")
+#define SUNXI_PINCTRL_PIN_PC28	PINCTRL_PIN(PC_BASE + 28, "PC28")
+#define SUNXI_PINCTRL_PIN_PC29	PINCTRL_PIN(PC_BASE + 29, "PC29")
+#define SUNXI_PINCTRL_PIN_PC30	PINCTRL_PIN(PC_BASE + 30, "PC30")
+#define SUNXI_PINCTRL_PIN_PC31	PINCTRL_PIN(PC_BASE + 31, "PC31")
+
+#define SUNXI_PINCTRL_PIN_PD0	PINCTRL_PIN(PD_BASE + 0, "PD0")
+#define SUNXI_PINCTRL_PIN_PD1	PINCTRL_PIN(PD_BASE + 1, "PD1")
+#define SUNXI_PINCTRL_PIN_PD2	PINCTRL_PIN(PD_BASE + 2, "PD2")
+#define SUNXI_PINCTRL_PIN_PD3	PINCTRL_PIN(PD_BASE + 3, "PD3")
+#define SUNXI_PINCTRL_PIN_PD4	PINCTRL_PIN(PD_BASE + 4, "PD4")
+#define SUNXI_PINCTRL_PIN_PD5	PINCTRL_PIN(PD_BASE + 5, "PD5")
+#define SUNXI_PINCTRL_PIN_PD6	PINCTRL_PIN(PD_BASE + 6, "PD6")
+#define SUNXI_PINCTRL_PIN_PD7	PINCTRL_PIN(PD_BASE + 7, "PD7")
+#define SUNXI_PINCTRL_PIN_PD8	PINCTRL_PIN(PD_BASE + 8, "PD8")
+#define SUNXI_PINCTRL_PIN_PD9	PINCTRL_PIN(PD_BASE + 9, "PD9")
+#define SUNXI_PINCTRL_PIN_PD10	PINCTRL_PIN(PD_BASE + 10, "PD10")
+#define SUNXI_PINCTRL_PIN_PD11	PINCTRL_PIN(PD_BASE + 11, "PD11")
+#define SUNXI_PINCTRL_PIN_PD12	PINCTRL_PIN(PD_BASE + 12, "PD12")
+#define SUNXI_PINCTRL_PIN_PD13	PINCTRL_PIN(PD_BASE + 13, "PD13")
+#define SUNXI_PINCTRL_PIN_PD14	PINCTRL_PIN(PD_BASE + 14, "PD14")
+#define SUNXI_PINCTRL_PIN_PD15	PINCTRL_PIN(PD_BASE + 15, "PD15")
+#define SUNXI_PINCTRL_PIN_PD16	PINCTRL_PIN(PD_BASE + 16, "PD16")
+#define SUNXI_PINCTRL_PIN_PD17	PINCTRL_PIN(PD_BASE + 17, "PD17")
+#define SUNXI_PINCTRL_PIN_PD18	PINCTRL_PIN(PD_BASE + 18, "PD18")
+#define SUNXI_PINCTRL_PIN_PD19	PINCTRL_PIN(PD_BASE + 19, "PD19")
+#define SUNXI_PINCTRL_PIN_PD20	PINCTRL_PIN(PD_BASE + 20, "PD20")
+#define SUNXI_PINCTRL_PIN_PD21	PINCTRL_PIN(PD_BASE + 21, "PD21")
+#define SUNXI_PINCTRL_PIN_PD22	PINCTRL_PIN(PD_BASE + 22, "PD22")
+#define SUNXI_PINCTRL_PIN_PD23	PINCTRL_PIN(PD_BASE + 23, "PD23")
+#define SUNXI_PINCTRL_PIN_PD24	PINCTRL_PIN(PD_BASE + 24, "PD24")
+#define SUNXI_PINCTRL_PIN_PD25	PINCTRL_PIN(PD_BASE + 25, "PD25")
+#define SUNXI_PINCTRL_PIN_PD26	PINCTRL_PIN(PD_BASE + 26, "PD26")
+#define SUNXI_PINCTRL_PIN_PD27	PINCTRL_PIN(PD_BASE + 27, "PD27")
+#define SUNXI_PINCTRL_PIN_PD28	PINCTRL_PIN(PD_BASE + 28, "PD28")
+#define SUNXI_PINCTRL_PIN_PD29	PINCTRL_PIN(PD_BASE + 29, "PD29")
+#define SUNXI_PINCTRL_PIN_PD30	PINCTRL_PIN(PD_BASE + 30, "PD30")
+#define SUNXI_PINCTRL_PIN_PD31	PINCTRL_PIN(PD_BASE + 31, "PD31")
+
+#define SUNXI_PINCTRL_PIN_PE0	PINCTRL_PIN(PE_BASE + 0, "PE0")
+#define SUNXI_PINCTRL_PIN_PE1	PINCTRL_PIN(PE_BASE + 1, "PE1")
+#define SUNXI_PINCTRL_PIN_PE2	PINCTRL_PIN(PE_BASE + 2, "PE2")
+#define SUNXI_PINCTRL_PIN_PE3	PINCTRL_PIN(PE_BASE + 3, "PE3")
+#define SUNXI_PINCTRL_PIN_PE4	PINCTRL_PIN(PE_BASE + 4, "PE4")
+#define SUNXI_PINCTRL_PIN_PE5	PINCTRL_PIN(PE_BASE + 5, "PE5")
+#define SUNXI_PINCTRL_PIN_PE6	PINCTRL_PIN(PE_BASE + 6, "PE6")
+#define SUNXI_PINCTRL_PIN_PE7	PINCTRL_PIN(PE_BASE + 7, "PE7")
+#define SUNXI_PINCTRL_PIN_PE8	PINCTRL_PIN(PE_BASE + 8, "PE8")
+#define SUNXI_PINCTRL_PIN_PE9	PINCTRL_PIN(PE_BASE + 9, "PE9")
+#define SUNXI_PINCTRL_PIN_PE10	PINCTRL_PIN(PE_BASE + 10, "PE10")
+#define SUNXI_PINCTRL_PIN_PE11	PINCTRL_PIN(PE_BASE + 11, "PE11")
+#define SUNXI_PINCTRL_PIN_PE12	PINCTRL_PIN(PE_BASE + 12, "PE12")
+#define SUNXI_PINCTRL_PIN_PE13	PINCTRL_PIN(PE_BASE + 13, "PE13")
+#define SUNXI_PINCTRL_PIN_PE14	PINCTRL_PIN(PE_BASE + 14, "PE14")
+#define SUNXI_PINCTRL_PIN_PE15	PINCTRL_PIN(PE_BASE + 15, "PE15")
+#define SUNXI_PINCTRL_PIN_PE16	PINCTRL_PIN(PE_BASE + 16, "PE16")
+#define SUNXI_PINCTRL_PIN_PE17	PINCTRL_PIN(PE_BASE + 17, "PE17")
+#define SUNXI_PINCTRL_PIN_PE18	PINCTRL_PIN(PE_BASE + 18, "PE18")
+#define SUNXI_PINCTRL_PIN_PE19	PINCTRL_PIN(PE_BASE + 19, "PE19")
+#define SUNXI_PINCTRL_PIN_PE20	PINCTRL_PIN(PE_BASE + 20, "PE20")
+#define SUNXI_PINCTRL_PIN_PE21	PINCTRL_PIN(PE_BASE + 21, "PE21")
+#define SUNXI_PINCTRL_PIN_PE22	PINCTRL_PIN(PE_BASE + 22, "PE22")
+#define SUNXI_PINCTRL_PIN_PE23	PINCTRL_PIN(PE_BASE + 23, "PE23")
+#define SUNXI_PINCTRL_PIN_PE24	PINCTRL_PIN(PE_BASE + 24, "PE24")
+#define SUNXI_PINCTRL_PIN_PE25	PINCTRL_PIN(PE_BASE + 25, "PE25")
+#define SUNXI_PINCTRL_PIN_PE26	PINCTRL_PIN(PE_BASE + 26, "PE26")
+#define SUNXI_PINCTRL_PIN_PE27	PINCTRL_PIN(PE_BASE + 27, "PE27")
+#define SUNXI_PINCTRL_PIN_PE28	PINCTRL_PIN(PE_BASE + 28, "PE28")
+#define SUNXI_PINCTRL_PIN_PE29	PINCTRL_PIN(PE_BASE + 29, "PE29")
+#define SUNXI_PINCTRL_PIN_PE30	PINCTRL_PIN(PE_BASE + 30, "PE30")
+#define SUNXI_PINCTRL_PIN_PE31	PINCTRL_PIN(PE_BASE + 31, "PE31")
+
+#define SUNXI_PINCTRL_PIN_PF0	PINCTRL_PIN(PF_BASE + 0, "PF0")
+#define SUNXI_PINCTRL_PIN_PF1	PINCTRL_PIN(PF_BASE + 1, "PF1")
+#define SUNXI_PINCTRL_PIN_PF2	PINCTRL_PIN(PF_BASE + 2, "PF2")
+#define SUNXI_PINCTRL_PIN_PF3	PINCTRL_PIN(PF_BASE + 3, "PF3")
+#define SUNXI_PINCTRL_PIN_PF4	PINCTRL_PIN(PF_BASE + 4, "PF4")
+#define SUNXI_PINCTRL_PIN_PF5	PINCTRL_PIN(PF_BASE + 5, "PF5")
+#define SUNXI_PINCTRL_PIN_PF6	PINCTRL_PIN(PF_BASE + 6, "PF6")
+#define SUNXI_PINCTRL_PIN_PF7	PINCTRL_PIN(PF_BASE + 7, "PF7")
+#define SUNXI_PINCTRL_PIN_PF8	PINCTRL_PIN(PF_BASE + 8, "PF8")
+#define SUNXI_PINCTRL_PIN_PF9	PINCTRL_PIN(PF_BASE + 9, "PF9")
+#define SUNXI_PINCTRL_PIN_PF10	PINCTRL_PIN(PF_BASE + 10, "PF10")
+#define SUNXI_PINCTRL_PIN_PF11	PINCTRL_PIN(PF_BASE + 11, "PF11")
+#define SUNXI_PINCTRL_PIN_PF12	PINCTRL_PIN(PF_BASE + 12, "PF12")
+#define SUNXI_PINCTRL_PIN_PF13	PINCTRL_PIN(PF_BASE + 13, "PF13")
+#define SUNXI_PINCTRL_PIN_PF14	PINCTRL_PIN(PF_BASE + 14, "PF14")
+#define SUNXI_PINCTRL_PIN_PF15	PINCTRL_PIN(PF_BASE + 15, "PF15")
+#define SUNXI_PINCTRL_PIN_PF16	PINCTRL_PIN(PF_BASE + 16, "PF16")
+#define SUNXI_PINCTRL_PIN_PF17	PINCTRL_PIN(PF_BASE + 17, "PF17")
+#define SUNXI_PINCTRL_PIN_PF18	PINCTRL_PIN(PF_BASE + 18, "PF18")
+#define SUNXI_PINCTRL_PIN_PF19	PINCTRL_PIN(PF_BASE + 19, "PF19")
+#define SUNXI_PINCTRL_PIN_PF20	PINCTRL_PIN(PF_BASE + 20, "PF20")
+#define SUNXI_PINCTRL_PIN_PF21	PINCTRL_PIN(PF_BASE + 21, "PF21")
+#define SUNXI_PINCTRL_PIN_PF22	PINCTRL_PIN(PF_BASE + 22, "PF22")
+#define SUNXI_PINCTRL_PIN_PF23	PINCTRL_PIN(PF_BASE + 23, "PF23")
+#define SUNXI_PINCTRL_PIN_PF24	PINCTRL_PIN(PF_BASE + 24, "PF24")
+#define SUNXI_PINCTRL_PIN_PF25	PINCTRL_PIN(PF_BASE + 25, "PF25")
+#define SUNXI_PINCTRL_PIN_PF26	PINCTRL_PIN(PF_BASE + 26, "PF26")
+#define SUNXI_PINCTRL_PIN_PF27	PINCTRL_PIN(PF_BASE + 27, "PF27")
+#define SUNXI_PINCTRL_PIN_PF28	PINCTRL_PIN(PF_BASE + 28, "PF28")
+#define SUNXI_PINCTRL_PIN_PF29	PINCTRL_PIN(PF_BASE + 29, "PF29")
+#define SUNXI_PINCTRL_PIN_PF30	PINCTRL_PIN(PF_BASE + 30, "PF30")
+#define SUNXI_PINCTRL_PIN_PF31	PINCTRL_PIN(PF_BASE + 31, "PF31")
+
+#define SUNXI_PINCTRL_PIN_PG0	PINCTRL_PIN(PG_BASE + 0, "PG0")
+#define SUNXI_PINCTRL_PIN_PG1	PINCTRL_PIN(PG_BASE + 1, "PG1")
+#define SUNXI_PINCTRL_PIN_PG2	PINCTRL_PIN(PG_BASE + 2, "PG2")
+#define SUNXI_PINCTRL_PIN_PG3	PINCTRL_PIN(PG_BASE + 3, "PG3")
+#define SUNXI_PINCTRL_PIN_PG4	PINCTRL_PIN(PG_BASE + 4, "PG4")
+#define SUNXI_PINCTRL_PIN_PG5	PINCTRL_PIN(PG_BASE + 5, "PG5")
+#define SUNXI_PINCTRL_PIN_PG6	PINCTRL_PIN(PG_BASE + 6, "PG6")
+#define SUNXI_PINCTRL_PIN_PG7	PINCTRL_PIN(PG_BASE + 7, "PG7")
+#define SUNXI_PINCTRL_PIN_PG8	PINCTRL_PIN(PG_BASE + 8, "PG8")
+#define SUNXI_PINCTRL_PIN_PG9	PINCTRL_PIN(PG_BASE + 9, "PG9")
+#define SUNXI_PINCTRL_PIN_PG10	PINCTRL_PIN(PG_BASE + 10, "PG10")
+#define SUNXI_PINCTRL_PIN_PG11	PINCTRL_PIN(PG_BASE + 11, "PG11")
+#define SUNXI_PINCTRL_PIN_PG12	PINCTRL_PIN(PG_BASE + 12, "PG12")
+#define SUNXI_PINCTRL_PIN_PG13	PINCTRL_PIN(PG_BASE + 13, "PG13")
+#define SUNXI_PINCTRL_PIN_PG14	PINCTRL_PIN(PG_BASE + 14, "PG14")
+#define SUNXI_PINCTRL_PIN_PG15	PINCTRL_PIN(PG_BASE + 15, "PG15")
+#define SUNXI_PINCTRL_PIN_PG16	PINCTRL_PIN(PG_BASE + 16, "PG16")
+#define SUNXI_PINCTRL_PIN_PG17	PINCTRL_PIN(PG_BASE + 17, "PG17")
+#define SUNXI_PINCTRL_PIN_PG18	PINCTRL_PIN(PG_BASE + 18, "PG18")
+#define SUNXI_PINCTRL_PIN_PG19	PINCTRL_PIN(PG_BASE + 19, "PG19")
+#define SUNXI_PINCTRL_PIN_PG20	PINCTRL_PIN(PG_BASE + 20, "PG20")
+#define SUNXI_PINCTRL_PIN_PG21	PINCTRL_PIN(PG_BASE + 21, "PG21")
+#define SUNXI_PINCTRL_PIN_PG22	PINCTRL_PIN(PG_BASE + 22, "PG22")
+#define SUNXI_PINCTRL_PIN_PG23	PINCTRL_PIN(PG_BASE + 23, "PG23")
+#define SUNXI_PINCTRL_PIN_PG24	PINCTRL_PIN(PG_BASE + 24, "PG24")
+#define SUNXI_PINCTRL_PIN_PG25	PINCTRL_PIN(PG_BASE + 25, "PG25")
+#define SUNXI_PINCTRL_PIN_PG26	PINCTRL_PIN(PG_BASE + 26, "PG26")
+#define SUNXI_PINCTRL_PIN_PG27	PINCTRL_PIN(PG_BASE + 27, "PG27")
+#define SUNXI_PINCTRL_PIN_PG28	PINCTRL_PIN(PG_BASE + 28, "PG28")
+#define SUNXI_PINCTRL_PIN_PG29	PINCTRL_PIN(PG_BASE + 29, "PG29")
+#define SUNXI_PINCTRL_PIN_PG30	PINCTRL_PIN(PG_BASE + 30, "PG30")
+#define SUNXI_PINCTRL_PIN_PG31	PINCTRL_PIN(PG_BASE + 31, "PG31")
+
+#define BANK_MEM_SIZE		0x24
+#define MUX_REGS_OFFSET		0x0
+#define DLEVEL_REGS_OFFSET	0x14
+#define PULL_REGS_OFFSET	0x1c
+
+#define PINS_PER_BANK		32
+#define MUX_PINS_PER_REG	8
+#define MUX_PINS_BITS		4
+#define DLEVEL_PINS_PER_REG	16
+#define DLEVEL_PINS_BITS	2
+#define PULL_PINS_PER_REG	16
+#define PULL_PINS_BITS		2
+
+struct sunxi_desc_function {
+	const char	*name;
+	u8		muxval;
+};
+
+struct sunxi_desc_pin {
+	struct pinctrl_pin_desc		pin;
+	struct sunxi_desc_function	*functions;
+};
+
+struct sunxi_pinctrl_desc {
+	const struct sunxi_desc_pin	*pins;
+	int				npins;
+};
+
+struct sunxi_pinctrl_function {
+	const char	*name;
+	const char	**groups;
+	unsigned	ngroups;
+};
+
+struct sunxi_pinctrl_group {
+	const char	*name;
+	unsigned long	config;
+	unsigned	pin;
+};
+
+struct sunxi_pinctrl {
+	void __iomem			*membase;
+	struct sunxi_pinctrl_desc	*desc;
+	struct device			*dev;
+	struct sunxi_pinctrl_function	*functions;
+	unsigned			nfunctions;
+	struct sunxi_pinctrl_group	*groups;
+	unsigned			ngroups;
+	struct pinctrl_dev		*pctl_dev;
+};
+
+#define SUNXI_PIN(_pin, ...)					\
+	{							\
+		.pin = _pin,					\
+		.functions = (struct sunxi_desc_function[]){	\
+			__VA_ARGS__, { } },			\
+	}
+
+#define SUNXI_FUNCTION(_val, _name)				\
+	{							\
+		.name = _name,					\
+		.muxval = _val,					\
+	}
+
+
+/*
+ * The sunXi PIO registers are organized as is:
+ * 0x00 - 0x0c	Muxing values.
+ *		8 pins per register, each pin having a 4bits value
+ * 0x10		Pin values
+ *		32 bits per register, each pin corresponding to one bit
+ * 0x14 - 0x18	Drive level
+ *		16 pins per register, each pin having a 2bits value
+ * 0x1c - 0x20	Pull-Up values
+ *		16 pins per register, each pin having a 2bits value
+ *
+ * This is for the first bank. Each bank will have the same layout,
+ * with an offset being a multiple of 0x24.
+ *
+ * The following functions calculate from the pin number the register
+ * and the bit offset that we should access.
+ */
+static inline u32 sunxi_mux_reg(u16 pin)
+{
+	u8 bank = pin / PINS_PER_BANK;
+	u32 offset = bank * BANK_MEM_SIZE;
+	offset += MUX_REGS_OFFSET;
+	offset += pin % PINS_PER_BANK / MUX_PINS_PER_REG * 0x04;
+	return round_down(offset, 4);
+}
+
+static inline u32 sunxi_mux_offset(u16 pin)
+{
+	u32 pin_num = pin % MUX_PINS_PER_REG;
+	return pin_num * MUX_PINS_BITS;
+}
+
+static inline u32 sunxi_dlevel_reg(u16 pin)
+{
+	u8 bank = pin / PINS_PER_BANK;
+	u32 offset = bank * BANK_MEM_SIZE;
+	offset += DLEVEL_REGS_OFFSET;
+	offset += pin % PINS_PER_BANK / DLEVEL_PINS_PER_REG * 0x04;
+	return round_down(offset, 4);
+}
+
+static inline u32 sunxi_dlevel_offset(u16 pin)
+{
+	u32 pin_num = pin % DLEVEL_PINS_PER_REG;
+	return pin_num * DLEVEL_PINS_BITS;
+}
+
+static inline u32 sunxi_pull_reg(u16 pin)
+{
+	u8 bank = pin / PINS_PER_BANK;
+	u32 offset = bank * BANK_MEM_SIZE;
+	offset += PULL_REGS_OFFSET;
+	offset += pin % PINS_PER_BANK / PULL_PINS_PER_REG * 0x04;
+	return round_down(offset, 4);
+}
+
+static inline u32 sunxi_pull_offset(u16 pin)
+{
+	u32 pin_num = pin % PULL_PINS_PER_REG;
+	return pin_num * PULL_PINS_BITS;
+}
+
+#endif /* __PINCTRL_SUNXI_H */
-- 
1.7.10.4

