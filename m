Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2BAVFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:05:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13624 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2BAVE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:04:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 01 Feb 2012 13:04:54 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
Date: Wed,  1 Feb 2012 14:04:47 -0700
Message-Id: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the Tegra pinmux, and required parameterization
data for Tegra20 and Tegra30.

The driver is initially added with driver name and device tree compatible
value that won't cause this driver to be used. A later change will switch
the pinctrl driver to use the correct values, switch the old pinmux
driver to be disabled, and update all code that uses the old pinmux APIs
to use the new pinctrl APIs.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Olof Johansson <olof@lixom.net>
--
v2: Add kerneldoc to pinctrl-tegra.h, use bit fields throughout struct
tegra_pingroup to reduce the static data size for each pin group.
---
 arch/arm/mach-tegra/include/mach/pinconf-tegra.h |   63 +
 drivers/pinctrl/Kconfig                          |   15 +
 drivers/pinctrl/Makefile                         |    3 +
 drivers/pinctrl/pinctrl-tegra.c                  |  559 ++++
 drivers/pinctrl/pinctrl-tegra.h                  |  163 +
 drivers/pinctrl/pinctrl-tegra20.c                | 2860 +++++++++++++++++
 drivers/pinctrl/pinctrl-tegra30.c                | 3726 ++++++++++++++++++++++
 7 files changed, 7389 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/pinconf-tegra.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra20.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra30.c

diff --git a/arch/arm/mach-tegra/include/mach/pinconf-tegra.h b/arch/arm/mach-tegra/include/mach/pinconf-tegra.h
new file mode 100644
index 0000000..1f24d30
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/pinconf-tegra.h
@@ -0,0 +1,63 @@
+/*
+ * pinctrl configuration definitions for the NVIDIA Tegra pinmux
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __PINCONF_TEGRA_H__
+#define __PINCONF_TEGRA_H__
+
+enum tegra_pinconf_param {
+	/* argument: tegra_pinconf_pull */
+	TEGRA_PINCONF_PARAM_PULL,
+	/* argument: tegra_pinconf_tristate */
+	TEGRA_PINCONF_PARAM_TRISTATE,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_ENABLE_INPUT,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_OPEN_DRAIN,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_LOCK,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_IORESET,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_SCHMITT,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_LOW_POWER_MODE,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING,
+};
+
+enum tegra_pinconf_pull {
+	TEGRA_PINCONFIG_PULL_NONE,
+	TEGRA_PINCONFIG_PULL_DOWN,
+	TEGRA_PINCONFIG_PULL_UP,
+};
+
+enum tegra_pinconf_tristate {
+	TEGRA_PINCONFIG_DRIVEN,
+	TEGRA_PINCONFIG_TRISTATE,
+};
+
+#define TEGRA_PINCONF_PACK(_param_, _arg_) ((_param_) << 16 | (_arg_))
+#define TEGRA_PINCONF_UNPACK_PARAM(_conf_) ((_conf_) >> 16)
+#define TEGRA_PINCONF_UNPACK_ARG(_conf_) ((_conf_) & 0xffff)
+
+#endif
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 3bea79f..c6d29ff 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -50,6 +50,21 @@ config PINCTRL_SIRF
 	depends on ARCH_PRIMA2
 	select PINMUX
 
+config PINCTRL_TEGRA
+	bool
+
+config PINCTRL_TEGRA20
+	bool
+	select PINMUX
+	select PINCONF
+	select PINCTRL_TEGRA
+
+config PINCTRL_TEGRA30
+	bool
+	select PINMUX
+	select PINCONF
+	select PINCTRL_TEGRA
+
 config PINCTRL_U300
 	bool "U300 pin controller driver"
 	depends on ARCH_U300
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c95d91e..754329b 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -10,5 +10,8 @@ obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
 obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
 obj-$(CONFIG_PINCTRL_PXA910)	+= pinctrl-pxa910.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
+obj-$(CONFIG_PINCTRL_TEGRA)	+= pinctrl-tegra.o
+obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
+obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
new file mode 100644
index 0000000..9b32968
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -0,0 +1,559 @@
+/*
+ * Driver for the NVIDIA Tegra pinmux
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Derived from code:
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2010 NVIDIA Corporation
+ * Copyright (C) 2009-2011 ST-Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+
+#include <mach/pinconf-tegra.h>
+
+#include "pinctrl-tegra.h"
+
+#define DRIVER_NAME "tegra-pinmux-disabled"
+
+struct tegra_pmx {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+
+	const struct tegra_pinctrl_soc_data *soc;
+
+	int nbanks;
+	void __iomem **regs;
+};
+
+static inline u32 pmx_readl(struct tegra_pmx *pmx, u32 bank, u32 reg)
+{
+	return readl(pmx->regs[bank] + reg);
+}
+
+static inline void pmx_writel(struct tegra_pmx *pmx, u32 val, u32 bank, u32 reg)
+{
+	writel(val, pmx->regs[bank] + reg);
+}
+
+static int tegra_pinctrl_list_groups(struct pinctrl_dev *pctldev,
+				     unsigned group)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (group >= pmx->soc->ngroups)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const char *tegra_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
+						unsigned group)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (group >= pmx->soc->ngroups)
+		return NULL;
+
+	return pmx->soc->groups[group].name;
+}
+
+static int tegra_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+					unsigned group,
+					const unsigned **pins,
+					unsigned *num_pins)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (group >= pmx->soc->ngroups)
+		return -EINVAL;
+
+	*pins = pmx->soc->groups[group].pins;
+	*num_pins = pmx->soc->groups[group].npins;
+
+	return 0;
+}
+
+static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
+				       struct seq_file *s,
+				       unsigned offset)
+{
+	seq_printf(s, " " DRIVER_NAME);
+}
+
+static struct pinctrl_ops tegra_pinctrl_ops = {
+	.list_groups = tegra_pinctrl_list_groups,
+	.get_group_name = tegra_pinctrl_get_group_name,
+	.get_group_pins = tegra_pinctrl_get_group_pins,
+	.pin_dbg_show = tegra_pinctrl_pin_dbg_show,
+};
+
+static int tegra_pinctrl_list_funcs(struct pinctrl_dev *pctldev,
+				    unsigned function)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= pmx->soc->nfunctions)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const char *tegra_pinctrl_get_func_name(struct pinctrl_dev *pctldev,
+					       unsigned function)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= pmx->soc->nfunctions)
+		return NULL;
+
+	return pmx->soc->functions[function].name;
+}
+
+static int tegra_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
+					 unsigned function,
+					 const char * const **groups,
+					 unsigned * const num_groups)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= pmx->soc->nfunctions)
+		return -EINVAL;
+
+	*groups = pmx->soc->functions[function].groups;
+	*num_groups = pmx->soc->functions[function].ngroups;
+
+	return 0;
+}
+
+static int tegra_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
+			       unsigned group)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tegra_pingroup *g;
+	int i;
+	u32 val;
+
+	if (group >= pmx->soc->ngroups)
+		return -EINVAL;
+	g = &pmx->soc->groups[group];
+
+	if (g->mux_reg < 0)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(g->funcs); i++) {
+		if (g->funcs[i] == function)
+			break;
+	}
+	if (i == ARRAY_SIZE(g->funcs))
+		return -EINVAL;
+
+	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
+	val &= ~(0x3 << g->mux_bit);
+	val |= i << g->mux_bit;
+	pmx_writel(pmx, val, g->mux_bank, g->mux_reg);
+
+	return 0;
+}
+
+static void tegra_pinctrl_disable(struct pinctrl_dev *pctldev,
+				  unsigned function, unsigned group)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tegra_pingroup *g;
+	u32 val;
+
+	if (group >= pmx->soc->ngroups)
+		return;
+	g = &pmx->soc->groups[group];
+
+	if (g->mux_reg < 0)
+		return;
+
+	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
+	val &= ~(0x3 << g->mux_bit);
+	val |= g->func_safe << g->mux_bit;
+	pmx_writel(pmx, val, g->mux_bank, g->mux_reg);
+}
+
+static struct pinmux_ops tegra_pinmux_ops = {
+	.list_functions = tegra_pinctrl_list_funcs,
+	.get_function_name = tegra_pinctrl_get_func_name,
+	.get_function_groups = tegra_pinctrl_get_func_groups,
+	.enable = tegra_pinctrl_enable,
+	.disable = tegra_pinctrl_disable,
+};
+
+static int tegra_pinconf_reg(struct tegra_pmx *pmx,
+			     const struct tegra_pingroup *g,
+			     enum tegra_pinconf_param param,
+			     s8 *bank, s16 *reg, s8 *bit, s8 *width)
+{
+	switch (param) {
+	case TEGRA_PINCONF_PARAM_PULL:
+		*bank = g->pupd_bank;
+		*reg = g->pupd_reg;
+		*bit = g->pupd_bit;
+		*width = 2;
+		break;
+	case TEGRA_PINCONF_PARAM_TRISTATE:
+		*bank = g->tri_bank;
+		*reg = g->tri_reg;
+		*bit = g->tri_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_ENABLE_INPUT:
+		*bank = g->einput_bank;
+		*reg = g->einput_reg;
+		*bit = g->einput_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_OPEN_DRAIN:
+		*bank = g->odrain_bank;
+		*reg = g->odrain_reg;
+		*bit = g->odrain_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_LOCK:
+		*bank = g->lock_bank;
+		*reg = g->lock_reg;
+		*bit = g->lock_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_IORESET:
+		*bank = g->ioreset_bank;
+		*reg = g->ioreset_reg;
+		*bit = g->ioreset_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->hsm_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_SCHMITT:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->schmitt_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_LOW_POWER_MODE:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->lpmd_bit;
+		*width = 1;
+		break;
+	case TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->drvdn_bit;
+		*width = g->drvdn_width;
+		break;
+	case TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->drvup_bit;
+		*width = g->drvup_width;
+		break;
+	case TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->slwf_bit;
+		*width = g->slwf_width;
+		break;
+	case TEGRA_PINCONF_PARAM_SLEW_RATE_RISING:
+		*bank = g->drv_bank;
+		*reg = g->drv_reg;
+		*bit = g->slwr_bit;
+		*width = g->slwr_width;
+		break;
+	default:
+		dev_err(pmx->dev, "Invalid config param %04x\n", param);
+		return -ENOTSUPP;
+	}
+
+	if (*reg < 0) {
+		dev_err(pmx->dev,
+			"Config param %04x not supported on group %s\n",
+			param, g->name);
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int tegra_pinconf_get(struct pinctrl_dev *pctldev,
+			     unsigned pin, unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+static int tegra_pinconf_set(struct pinctrl_dev *pctldev,
+			     unsigned pin, unsigned long config)
+{
+	return -ENOTSUPP;
+}
+
+static int tegra_pinconf_group_get(struct pinctrl_dev *pctldev,
+				   unsigned group, unsigned long *config)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum tegra_pinconf_param param = TEGRA_PINCONF_UNPACK_PARAM(*config);
+	u16 arg;
+	const struct tegra_pingroup *g;
+	int ret;
+	s8 bank, bit, width;
+	s16 reg;
+	u32 val, mask;
+
+	if (group >= pmx->soc->ngroups)
+		return -EINVAL;
+	g = &pmx->soc->groups[group];
+
+	ret = tegra_pinconf_reg(pmx, g, param, &bank, &reg, &bit, &width);
+	if (ret < 0)
+		return ret;
+
+	val = pmx_readl(pmx, bank, reg);
+	mask = (1 << width) - 1;
+	arg = (val >> bit) & mask;
+
+	*config = TEGRA_PINCONF_PACK(param, arg);
+
+	return 0;
+}
+
+static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
+				   unsigned group, unsigned long config)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum tegra_pinconf_param param = TEGRA_PINCONF_UNPACK_PARAM(config);
+	u16 arg = TEGRA_PINCONF_UNPACK_ARG(config);
+	const struct tegra_pingroup *g;
+	int ret;
+	s8 bank, bit, width;
+	s16 reg;
+	u32 val, mask;
+
+	if (group >= pmx->soc->ngroups)
+		return -EINVAL;
+	g = &pmx->soc->groups[group];
+
+	ret = tegra_pinconf_reg(pmx, g, param, &bank, &reg, &bit, &width);
+	if (ret < 0)
+		return ret;
+
+	val = pmx_readl(pmx, bank, reg);
+
+	/* LOCK can't be cleared */
+	if (param == TEGRA_PINCONF_PARAM_LOCK) {
+		if ((val & BIT(bit)) && !arg)
+			return -EINVAL;
+	}
+
+	/* Special-case Boolean values; allow any non-zero as true */
+	if (width == 1)
+		arg = !!arg;
+
+	/* Range-check user-supplied value */
+	mask = (1 << width) - 1;
+	if (arg & ~mask)
+		return -EINVAL;
+
+	/* Update register */
+	val &= ~(mask << bit);
+	val |= arg << bit;
+	pmx_writel(pmx, val, bank, reg);
+
+	return 0;
+}
+
+static void tegra_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				   struct seq_file *s, unsigned offset)
+{
+}
+
+static void tegra_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+					 struct seq_file *s, unsigned selector)
+{
+}
+
+struct pinconf_ops tegra_pinconf_ops = {
+	.pin_config_get = tegra_pinconf_get,
+	.pin_config_set = tegra_pinconf_set,
+	.pin_config_group_get = tegra_pinconf_group_get,
+	.pin_config_group_set = tegra_pinconf_group_set,
+	.pin_config_dbg_show = tegra_pinconf_dbg_show,
+	.pin_config_group_dbg_show = tegra_pinconf_group_dbg_show,
+};
+
+static struct pinctrl_gpio_range tegra_pinctrl_gpio_range = {
+	.name = "Tegra GPIOs",
+	.id = 0,
+	.base = 0,
+};
+
+static struct pinctrl_desc tegra_pinctrl_desc = {
+	.name = DRIVER_NAME,
+	.pctlops = &tegra_pinctrl_ops,
+	.pmxops = &tegra_pinmux_ops,
+	.confops = &tegra_pinconf_ops,
+	.owner = THIS_MODULE,
+};
+
+static struct of_device_id tegra_pinctrl_of_match[] __devinitdata = {
+#ifdef CONFIG_PINCTRL_TEGRA20
+	{
+		.compatible = "nvidia,tegra20-pinmux-disabled",
+		.data = tegra20_pinctrl_init,
+	},
+#endif
+#ifdef CONFIG_PINCTRL_TEGRA30
+	{
+		.compatible = "nvidia,tegra30-pinmux-disabled",
+		.data = tegra30_pinctrl_init,
+	},
+#endif
+	{},
+};
+
+static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	tegra_pinctrl_soc_initf initf = NULL;
+	struct tegra_pmx *pmx;
+	struct resource *res;
+	int i;
+
+	match = of_match_device(tegra_pinctrl_of_match, &pdev->dev);
+	if (match)
+		initf = (tegra_pinctrl_soc_initf)match->data;
+#ifdef CONFIG_PINCTRL_TEGRA20
+	if (!initf)
+		initf = tegra20_pinctrl_init;
+#endif
+	if (!initf) {
+		dev_err(&pdev->dev,
+			"Could not determine SoC-specific init func\n");
+		return -EINVAL;
+	}
+
+	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
+	if (!pmx) {
+		dev_err(&pdev->dev, "Can't alloc tegra_pmx\n");
+		return -ENOMEM;
+	}
+	pmx->dev = &pdev->dev;
+
+	(*initf)(&pmx->soc);
+
+	tegra_pinctrl_gpio_range.npins = pmx->soc->ngpios;
+	tegra_pinctrl_desc.pins = pmx->soc->pins;
+	tegra_pinctrl_desc.npins = pmx->soc->npins;
+
+	for (i = 0; ; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res)
+			break;
+	}
+	pmx->nbanks = i;
+
+	pmx->regs = devm_kzalloc(&pdev->dev, pmx->nbanks * sizeof(*pmx->regs),
+				 GFP_KERNEL);
+	if (!pmx->regs) {
+		dev_err(&pdev->dev, "Can't alloc regs pointer\n");
+		return -ENODEV;
+	}
+
+	for (i = 0; i < pmx->nbanks; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res) {
+			dev_err(&pdev->dev, "Missing MEM resource\n");
+			return -ENODEV;
+		}
+
+		if (!devm_request_mem_region(&pdev->dev, res->start,
+					    resource_size(res),
+					    dev_name(&pdev->dev))) {
+			dev_err(&pdev->dev,
+				"Couldn't request MEM resource %d\n", i);
+			return -ENODEV;
+		}
+
+		pmx->regs[i] = devm_ioremap(&pdev->dev, res->start,
+					    resource_size(res));
+		if (!pmx->regs[i]) {
+			dev_err(&pdev->dev, "Couldn't ioremap regs %d\n", i);
+			return -ENODEV;
+		}
+	}
+
+	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
+	if (IS_ERR(pmx->pctl)) {
+		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
+		return PTR_ERR(pmx->pctl);
+	}
+
+	pinctrl_add_gpio_range(pmx->pctl, &tegra_pinctrl_gpio_range);
+
+	platform_set_drvdata(pdev, pmx);
+
+	dev_dbg(&pdev->dev, "Probed Tegra pinctrl driver\n");
+
+	return 0;
+}
+
+static int __devexit tegra_pinctrl_remove(struct platform_device *pdev)
+{
+	struct tegra_pmx *pmx = platform_get_drvdata(pdev);
+
+	pinctrl_remove_gpio_range(pmx->pctl, &tegra_pinctrl_gpio_range);
+	pinctrl_unregister(pmx->pctl);
+
+	return 0;
+}
+
+static struct platform_driver tegra_pinctrl_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_pinctrl_of_match,
+	},
+	.probe = tegra_pinctrl_probe,
+	.remove = __devexit_p(tegra_pinctrl_remove),
+};
+
+static int __init tegra_pinctrl_init(void)
+{
+	return platform_driver_register(&tegra_pinctrl_driver);
+}
+arch_initcall(tegra_pinctrl_init);
+
+static void __exit tegra_pinctrl_exit(void)
+{
+	platform_driver_unregister(&tegra_pinctrl_driver);
+}
+module_exit(tegra_pinctrl_exit);
+
+MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra pinctrl driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, tegra_pinctrl_of_match);
diff --git a/drivers/pinctrl/pinctrl-tegra.h b/drivers/pinctrl/pinctrl-tegra.h
new file mode 100644
index 0000000..782c795
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tegra.h
@@ -0,0 +1,163 @@
+/*
+ * Driver for the NVIDIA Tegra pinmux
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __PINMUX_TEGRA_H__
+#define __PINMUX_TEGRA_H__
+
+/**
+ * struct tegra_function - Tegra pinctrl mux function
+ * @name: The name of the function, exported to pinctrl core.
+ * @groups: An array of pin groups that may select this function.
+ * @ngroups: The number of entries in @groups.
+ */
+struct tegra_function {
+	const char *name;
+	const char * const *groups;
+	unsigned ngroups;
+};
+
+/**
+ * struct tegra_pingroup - Tegra pin group
+ * @mux_reg:		Mux register offset. -1 if unsupported.
+ * @mux_bank:		Mux register bank. 0 if unsupported.
+ * @mux_bit:		Mux register bit. 0 if unsupported.
+ * @pupd_reg:		Pull-up/down register offset. -1 if unsupported.
+ * @pupd_bank:		Pull-up/down register bank. 0 if unsupported.
+ * @pupd_bit:		Pull-up/down register bit. 0 if unsupported.
+ * @tri_reg:		Tri-state register offset. -1 if unsupported.
+ * @tri_bank:		Tri-state register bank. 0 if unsupported.
+ * @tri_bit:		Tri-state register bit. 0 if unsupported.
+ * @einput_reg:		Enable-input register offset. -1 if unsupported.
+ * @einput_bank:	Enable-input register bank. 0 if unsupported.
+ * @einput_bit:		Enable-input register bit. 0 if unsupported.
+ * @odrain_reg:		Open-drain register offset. -1 if unsupported.
+ * @odrain_bank:	Open-drain register bank. 0 if unsupported.
+ * @odrain_bit:		Open-drain register bit. 0 if unsupported.
+ * @lock_reg:		Lock register offset. -1 if unsupported.
+ * @lock_bank:		Lock register bank. 0 if unsupported.
+ * @lock_bit:		Lock register bit. 0 if unsupported.
+ * @ioreset_reg:	IO reset register offset. -1 if unsupported.
+ * @ioreset_bank:	IO reset register bank. 0 if unsupported.
+ * @ioreset_bit:	IO reset register bit. 0 if unsupported.
+ * @drv_reg:		Drive fields register offset. -1 if unsupported.
+ *			This register contains the hsm, schmitt, lpmd, drvdn,
+ *			drvup, slwr, and slwf parameters.
+ * @drv_bank:		Drive fields register bank. 0 if unsupported.
+ * @hsm_bit:		High Speed Mode register bit. 0 if unsupported.
+ * @schmitt_bit:	Scmitt register bit. 0 if unsupported.
+ * @lpmd_bit:		Low Power Mode register bit. 0 if unsupported.
+ * @drvdn_bit:		Drive Down register bit. 0 if unsupported.
+ * @drvdn_width:	Drive Down field width. 0 if unsupported.
+ * @drvup_bit:		Drive Up register bit. 0 if unsupported.
+ * @drvup_width:	Drive Up field width. 0 if unsupported.
+ * @slwr_bit:		Slew Rising register bit. 0 if unsupported.
+ * @slwr_width:		Slew Rising field width. 0 if unsupported.
+ * @slwf_bit:		Slew Falling register bit. 0 if unsupported.
+ * @slwf_width:		Slew Falling field width. 0 if unsupported.
+ *
+ * A representation of a group of pins (possibly just one pin) in the Tegra
+ * pin controller. Each group allows some parameter or parameters to be
+ * configured. The most common is mux function selection. Many others exist
+ * such as pull-up/down, tri-state, etc. Tegra's pin controller is complex;
+ * certain groups may only support configuring certain parameters, hence
+ * each parameter is optional, represented by a -1 "reg" value.
+ */
+struct tegra_pingroup {
+	const char *name;
+	const unsigned *pins;
+	unsigned npins;
+	unsigned funcs[4];
+	unsigned func_safe;
+	s16 mux_reg;
+	s16 pupd_reg;
+	s16 tri_reg;
+	s16 einput_reg;
+	s16 odrain_reg;
+	s16 lock_reg;
+	s16 ioreset_reg;
+	s16 drv_reg;
+	u32 mux_bank:2;
+	u32 pupd_bank:2;
+	u32 tri_bank:2;
+	u32 einput_bank:2;
+	u32 odrain_bank:2;
+	u32 ioreset_bank:2;
+	u32 lock_bank:2;
+	u32 drv_bank:2;
+	u32 mux_bit:5;
+	u32 pupd_bit:5;
+	u32 tri_bit:5;
+	u32 einput_bit:5;
+	u32 odrain_bit:5;
+	u32 lock_bit:5;
+	u32 ioreset_bit:5;
+	u32 hsm_bit:5;
+	u32 schmitt_bit:5;
+	u32 lpmd_bit:5;
+	u32 drvdn_bit:5;
+	u32 drvup_bit:5;
+	u32 slwr_bit:5;
+	u32 slwf_bit:5;
+	u32 drvdn_width:6;
+	u32 drvup_width:6;
+	u32 slwr_width:6;
+	u32 slwf_width:6;
+};
+
+/**
+ * struct tegra_pinctrl_soc_data - Tegra pin controller driver configuration
+ * @ngpios:	The number of GPIO pins the pin controller HW affects.
+ * @pins:	An array describing all pins the pin controller affects.
+ *		All pins which are also GPIOs must be listed first within the
+ *		array, and be numbered identically to the GPIO controller's
+ *		numbering.
+ * @npins:	The numbmer of entries in @pins.
+ * @functions:	An array describing all mux functions the SoC supports.
+ * @nfunctions:	The numbmer of entries in @functions.
+ * @groups:	An array describing all pin groups the pin SoC supports.
+ * @ngroups:	The numbmer of entries in @groups.
+ */
+struct tegra_pinctrl_soc_data {
+	unsigned ngpios;
+	const struct pinctrl_pin_desc *pins;
+	unsigned npins;
+	const struct tegra_function *functions;
+	unsigned nfunctions;
+	const struct tegra_pingroup *groups;
+	unsigned ngroups;
+};
+
+/**
+ * tegra_pinctrl_soc_initf() - Retrieve pin controller details for a SoC.
+ * @soc_data:	This pointer must be updated to point at a struct containing
+ *		details of the SoC.
+ */
+typedef void (*tegra_pinctrl_soc_initf)(
+			const struct tegra_pinctrl_soc_data **soc_data);
+
+/**
+ * tegra20_pinctrl_init() - Retrieve pin controller details for Tegra20
+ * @soc_data:	This pointer will be updated to point at a struct containing
+ *		details of Tegra20's pin controller.
+ */
+void tegra20_pinctrl_init(const struct tegra_pinctrl_soc_data **soc_data);
+/**
+ * tegra30_pinctrl_init() - Retrieve pin controller details for Tegra20
+ * @soc_data:	This pointer will be updated to point at a struct containing
+ *		details of Tegra30's pin controller.
+ */
+void tegra30_pinctrl_init(const struct tegra_pinctrl_soc_data **soc_data);
+
+#endif
diff --git a/drivers/pinctrl/pinctrl-tegra20.c b/drivers/pinctrl/pinctrl-tegra20.c
new file mode 100644
index 0000000..f69ff96
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tegra20.c
@@ -0,0 +1,2860 @@
+/*
+ * Pinctrl data for the NVIDIA Tegra20 pinmux
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Derived from code:
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2010 NVIDIA Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "pinctrl-tegra.h"
+
+/*
+ * Most pins affected by the pinmux can also be GPIOs. Define these first.
+ * These must match how the GPIO driver names/numbers its pins.
+ */
+#define _GPIO(offset)			(offset)
+
+#define TEGRA_PIN_VI_GP6_PA0		_GPIO(0)
+#define TEGRA_PIN_UART3_CTS_N_PA1	_GPIO(1)
+#define TEGRA_PIN_DAP2_FS_PA2		_GPIO(2)
+#define TEGRA_PIN_DAP2_SCLK_PA3		_GPIO(3)
+#define TEGRA_PIN_DAP2_DIN_PA4		_GPIO(4)
+#define TEGRA_PIN_DAP2_DOUT_PA5		_GPIO(5)
+#define TEGRA_PIN_SDIO3_CLK_PA6		_GPIO(6)
+#define TEGRA_PIN_SDIO3_CMD_PA7		_GPIO(7)
+#define TEGRA_PIN_GMI_AD17_PB0		_GPIO(8)
+#define TEGRA_PIN_GMI_AD18_PB1		_GPIO(9)
+#define TEGRA_PIN_LCD_PWR0_PB2		_GPIO(10)
+#define TEGRA_PIN_LCD_PCLK_PB3		_GPIO(11)
+#define TEGRA_PIN_SDIO3_DAT3_PB4	_GPIO(12)
+#define TEGRA_PIN_SDIO3_DAT2_PB5	_GPIO(13)
+#define TEGRA_PIN_SDIO3_DAT1_PB6	_GPIO(14)
+#define TEGRA_PIN_SDIO3_DAT0_PB7	_GPIO(15)
+#define TEGRA_PIN_UART3_RTS_N_PC0	_GPIO(16)
+#define TEGRA_PIN_LCD_PWR1_PC1		_GPIO(17)
+#define TEGRA_PIN_UART2_TXD_PC2		_GPIO(18)
+#define TEGRA_PIN_UART2_RXD_PC3		_GPIO(19)
+#define TEGRA_PIN_GEN1_I2C_SCL_PC4	_GPIO(20)
+#define TEGRA_PIN_GEN1_I2C_SDA_PC5	_GPIO(21)
+#define TEGRA_PIN_LCD_PWR2_PC6		_GPIO(22)
+#define TEGRA_PIN_GMI_WP_N_PC7		_GPIO(23)
+#define TEGRA_PIN_SDIO3_DAT5_PD0	_GPIO(24)
+#define TEGRA_PIN_SDIO3_DAT4_PD1	_GPIO(25)
+#define TEGRA_PIN_VI_GP5_PD2		_GPIO(26)
+#define TEGRA_PIN_SDIO3_DAT6_PD3	_GPIO(27)
+#define TEGRA_PIN_SDIO3_DAT7_PD4	_GPIO(28)
+#define TEGRA_PIN_VI_D1_PD5		_GPIO(29)
+#define TEGRA_PIN_VI_VSYNC_PD6		_GPIO(30)
+#define TEGRA_PIN_VI_HSYNC_PD7		_GPIO(31)
+#define TEGRA_PIN_LCD_D0_PE0		_GPIO(32)
+#define TEGRA_PIN_LCD_D1_PE1		_GPIO(33)
+#define TEGRA_PIN_LCD_D2_PE2		_GPIO(34)
+#define TEGRA_PIN_LCD_D3_PE3		_GPIO(35)
+#define TEGRA_PIN_LCD_D4_PE4		_GPIO(36)
+#define TEGRA_PIN_LCD_D5_PE5		_GPIO(37)
+#define TEGRA_PIN_LCD_D6_PE6		_GPIO(38)
+#define TEGRA_PIN_LCD_D7_PE7		_GPIO(39)
+#define TEGRA_PIN_LCD_D8_PF0		_GPIO(40)
+#define TEGRA_PIN_LCD_D9_PF1		_GPIO(41)
+#define TEGRA_PIN_LCD_D10_PF2		_GPIO(42)
+#define TEGRA_PIN_LCD_D11_PF3		_GPIO(43)
+#define TEGRA_PIN_LCD_D12_PF4		_GPIO(44)
+#define TEGRA_PIN_LCD_D13_PF5		_GPIO(45)
+#define TEGRA_PIN_LCD_D14_PF6		_GPIO(46)
+#define TEGRA_PIN_LCD_D15_PF7		_GPIO(47)
+#define TEGRA_PIN_GMI_AD0_PG0		_GPIO(48)
+#define TEGRA_PIN_GMI_AD1_PG1		_GPIO(49)
+#define TEGRA_PIN_GMI_AD2_PG2		_GPIO(50)
+#define TEGRA_PIN_GMI_AD3_PG3		_GPIO(51)
+#define TEGRA_PIN_GMI_AD4_PG4		_GPIO(52)
+#define TEGRA_PIN_GMI_AD5_PG5		_GPIO(53)
+#define TEGRA_PIN_GMI_AD6_PG6		_GPIO(54)
+#define TEGRA_PIN_GMI_AD7_PG7		_GPIO(55)
+#define TEGRA_PIN_GMI_AD8_PH0		_GPIO(56)
+#define TEGRA_PIN_GMI_AD9_PH1		_GPIO(57)
+#define TEGRA_PIN_GMI_AD10_PH2		_GPIO(58)
+#define TEGRA_PIN_GMI_AD11_PH3		_GPIO(59)
+#define TEGRA_PIN_GMI_AD12_PH4		_GPIO(60)
+#define TEGRA_PIN_GMI_AD13_PH5		_GPIO(61)
+#define TEGRA_PIN_GMI_AD14_PH6		_GPIO(62)
+#define TEGRA_PIN_GMI_AD15_PH7		_GPIO(63)
+#define TEGRA_PIN_GMI_HIOW_N_PI0	_GPIO(64)
+#define TEGRA_PIN_GMI_HIOR_N_PI1	_GPIO(65)
+#define TEGRA_PIN_GMI_CS5_N_PI2		_GPIO(66)
+#define TEGRA_PIN_GMI_CS6_N_PI3		_GPIO(67)
+#define TEGRA_PIN_GMI_RST_N_PI4		_GPIO(68)
+#define TEGRA_PIN_GMI_IORDY_PI5		_GPIO(69)
+#define TEGRA_PIN_GMI_CS7_N_PI6		_GPIO(70)
+#define TEGRA_PIN_GMI_WAIT_PI7		_GPIO(71)
+#define TEGRA_PIN_GMI_CS0_N_PJ0		_GPIO(72)
+#define TEGRA_PIN_LCD_DE_PJ1		_GPIO(73)
+#define TEGRA_PIN_GMI_CS1_N_PJ2		_GPIO(74)
+#define TEGRA_PIN_LCD_HSYNC_PJ3		_GPIO(75)
+#define TEGRA_PIN_LCD_VSYNC_PJ4		_GPIO(76)
+#define TEGRA_PIN_UART2_CTS_N_PJ5	_GPIO(77)
+#define TEGRA_PIN_UART2_RTS_N_PJ6	_GPIO(78)
+#define TEGRA_PIN_GMI_AD16_PJ7		_GPIO(79)
+#define TEGRA_PIN_GMI_ADV_N_PK0		_GPIO(80)
+#define TEGRA_PIN_GMI_CLK_PK1		_GPIO(81)
+#define TEGRA_PIN_GMI_CS4_N_PK2		_GPIO(82)
+#define TEGRA_PIN_GMI_CS2_N_PK3		_GPIO(83)
+#define TEGRA_PIN_GMI_CS3_N_PK4		_GPIO(84)
+#define TEGRA_PIN_SPDIF_OUT_PK5		_GPIO(85)
+#define TEGRA_PIN_SPDIF_IN_PK6		_GPIO(86)
+#define TEGRA_PIN_GMI_AD19_PK7		_GPIO(87)
+#define TEGRA_PIN_VI_D2_PL0		_GPIO(88)
+#define TEGRA_PIN_VI_D3_PL1		_GPIO(89)
+#define TEGRA_PIN_VI_D4_PL2		_GPIO(90)
+#define TEGRA_PIN_VI_D5_PL3		_GPIO(91)
+#define TEGRA_PIN_VI_D6_PL4		_GPIO(92)
+#define TEGRA_PIN_VI_D7_PL5		_GPIO(93)
+#define TEGRA_PIN_VI_D8_PL6		_GPIO(94)
+#define TEGRA_PIN_VI_D9_PL7		_GPIO(95)
+#define TEGRA_PIN_LCD_D16_PM0		_GPIO(96)
+#define TEGRA_PIN_LCD_D17_PM1		_GPIO(97)
+#define TEGRA_PIN_LCD_D18_PM2		_GPIO(98)
+#define TEGRA_PIN_LCD_D19_PM3		_GPIO(99)
+#define TEGRA_PIN_LCD_D20_PM4		_GPIO(100)
+#define TEGRA_PIN_LCD_D21_PM5		_GPIO(101)
+#define TEGRA_PIN_LCD_D22_PM6		_GPIO(102)
+#define TEGRA_PIN_LCD_D23_PM7		_GPIO(103)
+#define TEGRA_PIN_DAP1_FS_PN0		_GPIO(104)
+#define TEGRA_PIN_DAP1_DIN_PN1		_GPIO(105)
+#define TEGRA_PIN_DAP1_DOUT_PN2		_GPIO(106)
+#define TEGRA_PIN_DAP1_SCLK_PN3		_GPIO(107)
+#define TEGRA_PIN_LCD_CS0_N_PN4		_GPIO(108)
+#define TEGRA_PIN_LCD_SDOUT_PN5		_GPIO(109)
+#define TEGRA_PIN_LCD_DC0_PN6		_GPIO(110)
+#define TEGRA_PIN_HDMI_INT_N_PN7	_GPIO(111)
+#define TEGRA_PIN_ULPI_DATA7_PO0	_GPIO(112)
+#define TEGRA_PIN_ULPI_DATA0_PO1	_GPIO(113)
+#define TEGRA_PIN_ULPI_DATA1_PO2	_GPIO(114)
+#define TEGRA_PIN_ULPI_DATA2_PO3	_GPIO(115)
+#define TEGRA_PIN_ULPI_DATA3_PO4	_GPIO(116)
+#define TEGRA_PIN_ULPI_DATA4_PO5	_GPIO(117)
+#define TEGRA_PIN_ULPI_DATA5_PO6	_GPIO(118)
+#define TEGRA_PIN_ULPI_DATA6_PO7	_GPIO(119)
+#define TEGRA_PIN_DAP3_FS_PP0		_GPIO(120)
+#define TEGRA_PIN_DAP3_DIN_PP1		_GPIO(121)
+#define TEGRA_PIN_DAP3_DOUT_PP2		_GPIO(122)
+#define TEGRA_PIN_DAP3_SCLK_PP3		_GPIO(123)
+#define TEGRA_PIN_DAP4_FS_PP4		_GPIO(124)
+#define TEGRA_PIN_DAP4_DIN_PP5		_GPIO(125)
+#define TEGRA_PIN_DAP4_DOUT_PP6		_GPIO(126)
+#define TEGRA_PIN_DAP4_SCLK_PP7		_GPIO(127)
+#define TEGRA_PIN_KB_COL0_PQ0		_GPIO(128)
+#define TEGRA_PIN_KB_COL1_PQ1		_GPIO(129)
+#define TEGRA_PIN_KB_COL2_PQ2		_GPIO(130)
+#define TEGRA_PIN_KB_COL3_PQ3		_GPIO(131)
+#define TEGRA_PIN_KB_COL4_PQ4		_GPIO(132)
+#define TEGRA_PIN_KB_COL5_PQ5		_GPIO(133)
+#define TEGRA_PIN_KB_COL6_PQ6		_GPIO(134)
+#define TEGRA_PIN_KB_COL7_PQ7		_GPIO(135)
+#define TEGRA_PIN_KB_ROW0_PR0		_GPIO(136)
+#define TEGRA_PIN_KB_ROW1_PR1		_GPIO(137)
+#define TEGRA_PIN_KB_ROW2_PR2		_GPIO(138)
+#define TEGRA_PIN_KB_ROW3_PR3		_GPIO(139)
+#define TEGRA_PIN_KB_ROW4_PR4		_GPIO(140)
+#define TEGRA_PIN_KB_ROW5_PR5		_GPIO(141)
+#define TEGRA_PIN_KB_ROW6_PR6		_GPIO(142)
+#define TEGRA_PIN_KB_ROW7_PR7		_GPIO(143)
+#define TEGRA_PIN_KB_ROW8_PS0		_GPIO(144)
+#define TEGRA_PIN_KB_ROW9_PS1		_GPIO(145)
+#define TEGRA_PIN_KB_ROW10_PS2		_GPIO(146)
+#define TEGRA_PIN_KB_ROW11_PS3		_GPIO(147)
+#define TEGRA_PIN_KB_ROW12_PS4		_GPIO(148)
+#define TEGRA_PIN_KB_ROW13_PS5		_GPIO(149)
+#define TEGRA_PIN_KB_ROW14_PS6		_GPIO(150)
+#define TEGRA_PIN_KB_ROW15_PS7		_GPIO(151)
+#define TEGRA_PIN_VI_PCLK_PT0		_GPIO(152)
+#define TEGRA_PIN_VI_MCLK_PT1		_GPIO(153)
+#define TEGRA_PIN_VI_D10_PT2		_GPIO(154)
+#define TEGRA_PIN_VI_D11_PT3		_GPIO(155)
+#define TEGRA_PIN_VI_D0_PT4		_GPIO(156)
+#define TEGRA_PIN_GEN2_I2C_SCL_PT5	_GPIO(157)
+#define TEGRA_PIN_GEN2_I2C_SDA_PT6	_GPIO(158)
+#define TEGRA_PIN_GMI_DPD_PT7		_GPIO(159)
+#define TEGRA_PIN_PU0			_GPIO(160)
+#define TEGRA_PIN_PU1			_GPIO(161)
+#define TEGRA_PIN_PU2			_GPIO(162)
+#define TEGRA_PIN_PU3			_GPIO(163)
+#define TEGRA_PIN_PU4			_GPIO(164)
+#define TEGRA_PIN_PU5			_GPIO(165)
+#define TEGRA_PIN_PU6			_GPIO(166)
+#define TEGRA_PIN_JTAG_RTCK_PU7		_GPIO(167)
+#define TEGRA_PIN_PV0			_GPIO(168)
+#define TEGRA_PIN_PV1			_GPIO(169)
+#define TEGRA_PIN_PV2			_GPIO(170)
+#define TEGRA_PIN_PV3			_GPIO(171)
+#define TEGRA_PIN_PV4			_GPIO(172)
+#define TEGRA_PIN_PV5			_GPIO(173)
+#define TEGRA_PIN_PV6			_GPIO(174)
+#define TEGRA_PIN_LCD_DC1_PV7		_GPIO(175)
+#define TEGRA_PIN_LCD_CS1_N_PW0		_GPIO(176)
+#define TEGRA_PIN_LCD_M1_PW1		_GPIO(177)
+#define TEGRA_PIN_SPI2_CS1_N_PW2	_GPIO(178)
+#define TEGRA_PIN_SPI2_CS2_N_PW3	_GPIO(179)
+#define TEGRA_PIN_DAP_MCLK1_PW4		_GPIO(180)
+#define TEGRA_PIN_DAP_MCLK2_PW5		_GPIO(181)
+#define TEGRA_PIN_UART3_TXD_PW6		_GPIO(182)
+#define TEGRA_PIN_UART3_RXD_PW7		_GPIO(183)
+#define TEGRA_PIN_SPI2_MOSI_PX0		_GPIO(184)
+#define TEGRA_PIN_SPI2_MISO_PX1		_GPIO(185)
+#define TEGRA_PIN_SPI2_SCK_PX2		_GPIO(186)
+#define TEGRA_PIN_SPI2_CS0_N_PX3	_GPIO(187)
+#define TEGRA_PIN_SPI1_MOSI_PX4		_GPIO(188)
+#define TEGRA_PIN_SPI1_SCK_PX5		_GPIO(189)
+#define TEGRA_PIN_SPI1_CS0_N_PX6	_GPIO(190)
+#define TEGRA_PIN_SPI1_MISO_PX7		_GPIO(191)
+#define TEGRA_PIN_ULPI_CLK_PY0		_GPIO(192)
+#define TEGRA_PIN_ULPI_DIR_PY1		_GPIO(193)
+#define TEGRA_PIN_ULPI_NXT_PY2		_GPIO(194)
+#define TEGRA_PIN_ULPI_STP_PY3		_GPIO(195)
+#define TEGRA_PIN_SDIO1_DAT3_PY4	_GPIO(196)
+#define TEGRA_PIN_SDIO1_DAT2_PY5	_GPIO(197)
+#define TEGRA_PIN_SDIO1_DAT1_PY6	_GPIO(198)
+#define TEGRA_PIN_SDIO1_DAT0_PY7	_GPIO(199)
+#define TEGRA_PIN_SDIO1_CLK_PZ0		_GPIO(200)
+#define TEGRA_PIN_SDIO1_CMD_PZ1		_GPIO(201)
+#define TEGRA_PIN_LCD_SDIN_PZ2		_GPIO(202)
+#define TEGRA_PIN_LCD_WR_N_PZ3		_GPIO(203)
+#define TEGRA_PIN_LCD_SCK_PZ4		_GPIO(204)
+#define TEGRA_PIN_SYS_CLK_REQ_PZ5	_GPIO(205)
+#define TEGRA_PIN_PWR_I2C_SCL_PZ6	_GPIO(206)
+#define TEGRA_PIN_PWR_I2C_SDA_PZ7	_GPIO(207)
+#define TEGRA_PIN_GMI_AD20_PAA0		_GPIO(208)
+#define TEGRA_PIN_GMI_AD21_PAA1		_GPIO(209)
+#define TEGRA_PIN_GMI_AD22_PAA2		_GPIO(210)
+#define TEGRA_PIN_GMI_AD23_PAA3		_GPIO(211)
+#define TEGRA_PIN_GMI_AD24_PAA4		_GPIO(212)
+#define TEGRA_PIN_GMI_AD25_PAA5		_GPIO(213)
+#define TEGRA_PIN_GMI_AD26_PAA6		_GPIO(214)
+#define TEGRA_PIN_GMI_AD27_PAA7		_GPIO(215)
+#define TEGRA_PIN_LED_BLINK_PBB0	_GPIO(216)
+#define TEGRA_PIN_VI_GP0_PBB1		_GPIO(217)
+#define TEGRA_PIN_CAM_I2C_SCL_PBB2	_GPIO(218)
+#define TEGRA_PIN_CAM_I2C_SDA_PBB3	_GPIO(219)
+#define TEGRA_PIN_VI_GP3_PBB4		_GPIO(220)
+#define TEGRA_PIN_VI_GP4_PBB5		_GPIO(221)
+#define TEGRA_PIN_PBB6			_GPIO(222)
+#define TEGRA_PIN_PBB7			_GPIO(223)
+
+/* All non-GPIO pins follow */
+#define NUM_GPIOS			(TEGRA_PIN_PBB7 + 1)
+#define _PIN(offset)			(NUM_GPIOS + (offset))
+
+#define TEGRA_PIN_CRT_HSYNC		_PIN(30)
+#define TEGRA_PIN_CRT_VSYNC		_PIN(31)
+#define TEGRA_PIN_DDC_SCL		_PIN(32)
+#define TEGRA_PIN_DDC_SDA		_PIN(33)
+#define TEGRA_PIN_OWC			_PIN(34)
+#define TEGRA_PIN_CORE_PWR_REQ		_PIN(35)
+#define TEGRA_PIN_CPU_PWR_REQ		_PIN(36)
+#define TEGRA_PIN_PWR_INT_N		_PIN(37)
+#define TEGRA_PIN_CLK_32_K_IN		_PIN(38)
+#define TEGRA_PIN_DDR_COMP_PD		_PIN(39)
+#define TEGRA_PIN_DDR_COMP_PU		_PIN(40)
+#define TEGRA_PIN_DDR_A0		_PIN(41)
+#define TEGRA_PIN_DDR_A1		_PIN(42)
+#define TEGRA_PIN_DDR_A2		_PIN(43)
+#define TEGRA_PIN_DDR_A3		_PIN(44)
+#define TEGRA_PIN_DDR_A4		_PIN(45)
+#define TEGRA_PIN_DDR_A5		_PIN(46)
+#define TEGRA_PIN_DDR_A6		_PIN(47)
+#define TEGRA_PIN_DDR_A7		_PIN(48)
+#define TEGRA_PIN_DDR_A8		_PIN(49)
+#define TEGRA_PIN_DDR_A9		_PIN(50)
+#define TEGRA_PIN_DDR_A10		_PIN(51)
+#define TEGRA_PIN_DDR_A11		_PIN(52)
+#define TEGRA_PIN_DDR_A12		_PIN(53)
+#define TEGRA_PIN_DDR_A13		_PIN(54)
+#define TEGRA_PIN_DDR_A14		_PIN(55)
+#define TEGRA_PIN_DDR_CAS_N		_PIN(56)
+#define TEGRA_PIN_DDR_BA0		_PIN(57)
+#define TEGRA_PIN_DDR_BA1		_PIN(58)
+#define TEGRA_PIN_DDR_BA2		_PIN(59)
+#define TEGRA_PIN_DDR_DQS0P		_PIN(60)
+#define TEGRA_PIN_DDR_DQS0N		_PIN(61)
+#define TEGRA_PIN_DDR_DQS1P		_PIN(62)
+#define TEGRA_PIN_DDR_DQS1N		_PIN(63)
+#define TEGRA_PIN_DDR_DQS2P		_PIN(64)
+#define TEGRA_PIN_DDR_DQS2N		_PIN(65)
+#define TEGRA_PIN_DDR_DQS3P		_PIN(66)
+#define TEGRA_PIN_DDR_DQS3N		_PIN(67)
+#define TEGRA_PIN_DDR_CKE0		_PIN(68)
+#define TEGRA_PIN_DDR_CKE1		_PIN(69)
+#define TEGRA_PIN_DDR_CLK		_PIN(70)
+#define TEGRA_PIN_DDR_CLK_N		_PIN(71)
+#define TEGRA_PIN_DDR_DM0		_PIN(72)
+#define TEGRA_PIN_DDR_DM1		_PIN(73)
+#define TEGRA_PIN_DDR_DM2		_PIN(74)
+#define TEGRA_PIN_DDR_DM3		_PIN(75)
+#define TEGRA_PIN_DDR_ODT		_PIN(76)
+#define TEGRA_PIN_DDR_QUSE0		_PIN(77)
+#define TEGRA_PIN_DDR_QUSE1		_PIN(78)
+#define TEGRA_PIN_DDR_QUSE2		_PIN(79)
+#define TEGRA_PIN_DDR_QUSE3		_PIN(80)
+#define TEGRA_PIN_DDR_RAS_N		_PIN(81)
+#define TEGRA_PIN_DDR_WE_N		_PIN(82)
+#define TEGRA_PIN_DDR_DQ0		_PIN(83)
+#define TEGRA_PIN_DDR_DQ1		_PIN(84)
+#define TEGRA_PIN_DDR_DQ2		_PIN(85)
+#define TEGRA_PIN_DDR_DQ3		_PIN(86)
+#define TEGRA_PIN_DDR_DQ4		_PIN(87)
+#define TEGRA_PIN_DDR_DQ5		_PIN(88)
+#define TEGRA_PIN_DDR_DQ6		_PIN(89)
+#define TEGRA_PIN_DDR_DQ7		_PIN(90)
+#define TEGRA_PIN_DDR_DQ8		_PIN(91)
+#define TEGRA_PIN_DDR_DQ9		_PIN(92)
+#define TEGRA_PIN_DDR_DQ10		_PIN(93)
+#define TEGRA_PIN_DDR_DQ11		_PIN(94)
+#define TEGRA_PIN_DDR_DQ12		_PIN(95)
+#define TEGRA_PIN_DDR_DQ13		_PIN(96)
+#define TEGRA_PIN_DDR_DQ14		_PIN(97)
+#define TEGRA_PIN_DDR_DQ15		_PIN(98)
+#define TEGRA_PIN_DDR_DQ16		_PIN(99)
+#define TEGRA_PIN_DDR_DQ17		_PIN(100)
+#define TEGRA_PIN_DDR_DQ18		_PIN(101)
+#define TEGRA_PIN_DDR_DQ19		_PIN(102)
+#define TEGRA_PIN_DDR_DQ20		_PIN(103)
+#define TEGRA_PIN_DDR_DQ21		_PIN(104)
+#define TEGRA_PIN_DDR_DQ22		_PIN(105)
+#define TEGRA_PIN_DDR_DQ23		_PIN(106)
+#define TEGRA_PIN_DDR_DQ24		_PIN(107)
+#define TEGRA_PIN_DDR_DQ25		_PIN(108)
+#define TEGRA_PIN_DDR_DQ26		_PIN(109)
+#define TEGRA_PIN_DDR_DQ27		_PIN(110)
+#define TEGRA_PIN_DDR_DQ28		_PIN(111)
+#define TEGRA_PIN_DDR_DQ29		_PIN(112)
+#define TEGRA_PIN_DDR_DQ30		_PIN(113)
+#define TEGRA_PIN_DDR_DQ31		_PIN(114)
+#define TEGRA_PIN_DDR_CS0_N		_PIN(115)
+#define TEGRA_PIN_DDR_CS1_N		_PIN(116)
+#define TEGRA_PIN_SYS_RESET		_PIN(117)
+#define TEGRA_PIN_JTAG_TRST_N		_PIN(118)
+#define TEGRA_PIN_JTAG_TDO		_PIN(119)
+#define TEGRA_PIN_JTAG_TMS		_PIN(120)
+#define TEGRA_PIN_JTAG_TCK		_PIN(121)
+#define TEGRA_PIN_JTAG_TDI		_PIN(122)
+#define TEGRA_PIN_TEST_MODE_EN		_PIN(123)
+
+static const struct pinctrl_pin_desc tegra20_pins[] = {
+	PINCTRL_PIN(TEGRA_PIN_VI_GP6_PA0, "VI_GP6 PA0"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_CTS_N_PA1, "UART3_CTS_N PA1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_FS_PA2, "DAP2_FS PA2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_SCLK_PA3, "DAP2_SCLK PA3"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DIN_PA4, "DAP2_DIN PA4"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DOUT_PA5, "DAP2_DOUT PA5"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_CLK_PA6, "SDIO3_CLK PA6"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_CMD_PA7, "SDIO3_CMD PA7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD17_PB0, "GMI_AD17 PB0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD18_PB1, "GMI_AD18 PB1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR0_PB2, "LCD_PWR0 PB2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PCLK_PB3, "LCD_PCLK PB3"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT3_PB4, "SDIO3_DAT3 PB4"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT2_PB5, "SDIO3_DAT2 PB5"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT1_PB6, "SDIO3_DAT1 PB6"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT0_PB7, "SDIO3_DAT0 PB7"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_RTS_N_PC0, "UART3_RTS_N PC0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR1_PC1, "LCD_PWR1 PC1"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_TXD_PC2, "UART2_TXD PC2"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_RXD_PC3, "UART2_RXD PC3"),
+	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SCL_PC4, "GEN1_I2C_SCL PC4"),
+	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SDA_PC5, "GEN1_I2C_SDA PC5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR2_PC6, "LCD_PWR2 PC6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_WP_N_PC7, "GMI_WP_N PC7"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT5_PD0, "SDIO3_DAT5 PD0"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT4_PD1, "SDIO3_DAT4 PD1"),
+	PINCTRL_PIN(TEGRA_PIN_VI_GP5_PD2, "VI_GP5 PD2"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT6_PD3, "SDIO3_DAT6 PD3"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO3_DAT7_PD4, "SDIO3_DAT7 PD4"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D1_PD5, "VI_D1 PD5"),
+	PINCTRL_PIN(TEGRA_PIN_VI_VSYNC_PD6, "VI_VSYNC PD6"),
+	PINCTRL_PIN(TEGRA_PIN_VI_HSYNC_PD7, "VI_HSYNC PD7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D0_PE0, "LCD_D0 PE0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D1_PE1, "LCD_D1 PE1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D2_PE2, "LCD_D2 PE2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D3_PE3, "LCD_D3 PE3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D4_PE4, "LCD_D4 PE4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D5_PE5, "LCD_D5 PE5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D6_PE6, "LCD_D6 PE6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D7_PE7, "LCD_D7 PE7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D8_PF0, "LCD_D8 PF0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D9_PF1, "LCD_D9 PF1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D10_PF2, "LCD_D10 PF2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D11_PF3, "LCD_D11 PF3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D12_PF4, "LCD_D12 PF4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D13_PF5, "LCD_D13 PF5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D14_PF6, "LCD_D14 PF6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D15_PF7, "LCD_D15 PF7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD0_PG0, "GMI_AD0 PG0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD1_PG1, "GMI_AD1 PG1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD2_PG2, "GMI_AD2 PG2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD3_PG3, "GMI_AD3 PG3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD4_PG4, "GMI_AD4 PG4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD5_PG5, "GMI_AD5 PG5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD6_PG6, "GMI_AD6 PG6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD7_PG7, "GMI_AD7 PG7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD8_PH0, "GMI_AD8 PH0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD9_PH1, "GMI_AD9 PH1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD10_PH2, "GMI_AD10 PH2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD11_PH3, "GMI_AD11 PH3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD12_PH4, "GMI_AD12 PH4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD13_PH5, "GMI_AD13 PH5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD14_PH6, "GMI_AD14 PH6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD15_PH7, "GMI_AD15 PH7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_HIOW_N_PI0, "GMI_HIOW_N PI0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_HIOR_N_PI1, "GMI_HIOR_N PI1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS5_N_PI2, "GMI_CS5_N PI2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS6_N_PI3, "GMI_CS6_N PI3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_RST_N_PI4, "GMI_RST_N PI4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_IORDY_PI5, "GMI_IORDY PI5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS7_N_PI6, "GMI_CS7_N PI6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_WAIT_PI7, "GMI_WAIT PI7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS0_N_PJ0, "GMI_CS0_N PJ0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DE_PJ1, "LCD_DE PJ1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS1_N_PJ2, "GMI_CS1_N PJ2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_HSYNC_PJ3, "LCD_HSYNC PJ3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_VSYNC_PJ4, "LCD_VSYNC PJ4"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_CTS_N_PJ5, "UART2_CTS_N PJ5"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_RTS_N_PJ6, "UART2_RTS_N PJ6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD16_PJ7, "GMI_AD16 PJ7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_ADV_N_PK0, "GMI_ADV_N PK0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CLK_PK1, "GMI_CLK PK1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS4_N_PK2, "GMI_CS4_N PK2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS2_N_PK3, "GMI_CS2_N PK3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS3_N_PK4, "GMI_CS3_N PK4"),
+	PINCTRL_PIN(TEGRA_PIN_SPDIF_OUT_PK5, "SPDIF_OUT PK5"),
+	PINCTRL_PIN(TEGRA_PIN_SPDIF_IN_PK6, "SPDIF_IN PK6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD19_PK7, "GMI_AD19 PK7"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D2_PL0, "VI_D2 PL0"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D3_PL1, "VI_D3 PL1"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D4_PL2, "VI_D4 PL2"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D5_PL3, "VI_D5 PL3"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D6_PL4, "VI_D6 PL4"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D7_PL5, "VI_D7 PL5"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D8_PL6, "VI_D8 PL6"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D9_PL7, "VI_D9 PL7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D16_PM0, "LCD_D16 PM0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D17_PM1, "LCD_D17 PM1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D18_PM2, "LCD_D18 PM2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D19_PM3, "LCD_D19 PM3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D20_PM4, "LCD_D20 PM4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D21_PM5, "LCD_D21 PM5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D22_PM6, "LCD_D22 PM6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D23_PM7, "LCD_D23 PM7"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_FS_PN0, "DAP1_FS PN0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_DIN_PN1, "DAP1_DIN PN1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_DOUT_PN2, "DAP1_DOUT PN2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_SCLK_PN3, "DAP1_SCLK PN3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_CS0_N_PN4, "LCD_CS0_N PN4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SDOUT_PN5, "LCD_SDOUT PN5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DC0_PN6, "LCD_DC0 PN6"),
+	PINCTRL_PIN(TEGRA_PIN_HDMI_INT_N_PN7, "HDMI_INT_N PN7"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA7_PO0, "ULPI_DATA7 PO0"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA0_PO1, "ULPI_DATA0 PO1"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA1_PO2, "ULPI_DATA1 PO2"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA2_PO3, "ULPI_DATA2 PO3"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA3_PO4, "ULPI_DATA3 PO4"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA4_PO5, "ULPI_DATA4 PO5"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA5_PO6, "ULPI_DATA5 PO6"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA6_PO7, "ULPI_DATA6 PO7"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_FS_PP0, "DAP3_FS PP0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_DIN_PP1, "DAP3_DIN PP1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_DOUT_PP2, "DAP3_DOUT PP2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_SCLK_PP3, "DAP3_SCLK PP3"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_FS_PP4, "DAP4_FS PP4"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_DIN_PP5, "DAP4_DIN PP5"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_DOUT_PP6, "DAP4_DOUT PP6"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_SCLK_PP7, "DAP4_SCLK PP7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL0_PQ0, "KB_COL0 PQ0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL1_PQ1, "KB_COL1 PQ1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL2_PQ2, "KB_COL2 PQ2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL3_PQ3, "KB_COL3 PQ3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL4_PQ4, "KB_COL4 PQ4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL5_PQ5, "KB_COL5 PQ5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL6_PQ6, "KB_COL6 PQ6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL7_PQ7, "KB_COL7 PQ7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW0_PR0, "KB_ROW0 PR0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW1_PR1, "KB_ROW1 PR1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW2_PR2, "KB_ROW2 PR2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW3_PR3, "KB_ROW3 PR3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW4_PR4, "KB_ROW4 PR4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW5_PR5, "KB_ROW5 PR5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW6_PR6, "KB_ROW6 PR6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW7_PR7, "KB_ROW7 PR7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW8_PS0, "KB_ROW8 PS0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW9_PS1, "KB_ROW9 PS1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW10_PS2, "KB_ROW10 PS2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW11_PS3, "KB_ROW11 PS3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW12_PS4, "KB_ROW12 PS4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW13_PS5, "KB_ROW13 PS5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW14_PS6, "KB_ROW14 PS6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW15_PS7, "KB_ROW15 PS7"),
+	PINCTRL_PIN(TEGRA_PIN_VI_PCLK_PT0, "VI_PCLK PT0"),
+	PINCTRL_PIN(TEGRA_PIN_VI_MCLK_PT1, "VI_MCLK PT1"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D10_PT2, "VD_D10 PT2"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D11_PT3, "VI_D11 PT3"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D0_PT4, "VI_D0 PT4"),
+	PINCTRL_PIN(TEGRA_PIN_GEN2_I2C_SCL_PT5, "GEN2_I2C_SCL PT5"),
+	PINCTRL_PIN(TEGRA_PIN_GEN2_I2C_SDA_PT6, "GEN2_I2C_SDA PT6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_DPD_PT7, "GMI_DPD PT7"),
+	/* PU0..6: GPIO only */
+	PINCTRL_PIN(TEGRA_PIN_PU0, "PU0"),
+	PINCTRL_PIN(TEGRA_PIN_PU1, "PU1"),
+	PINCTRL_PIN(TEGRA_PIN_PU2, "PU2"),
+	PINCTRL_PIN(TEGRA_PIN_PU3, "PU3"),
+	PINCTRL_PIN(TEGRA_PIN_PU4, "PU4"),
+	PINCTRL_PIN(TEGRA_PIN_PU5, "PU5"),
+	PINCTRL_PIN(TEGRA_PIN_PU6, "PU6"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_RTCK_PU7, "JTAG_RTCK PU7"),
+	/* PV0..1: GPIO only */
+	PINCTRL_PIN(TEGRA_PIN_PV0, "PV0"),
+	PINCTRL_PIN(TEGRA_PIN_PV1, "PV1"),
+	/* PV2..3: Balls are named after GPIO not function */
+	PINCTRL_PIN(TEGRA_PIN_PV2, "PV2"),
+	PINCTRL_PIN(TEGRA_PIN_PV3, "PV3"),
+	/* PV4..6: GPIO only */
+	PINCTRL_PIN(TEGRA_PIN_PV4, "PV4"),
+	PINCTRL_PIN(TEGRA_PIN_PV5, "PV5"),
+	PINCTRL_PIN(TEGRA_PIN_PV6, "PV6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DC1_PV7, "LCD_DC1 PV7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_CS1_N_PW0, "LCD_CS1_N PW0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_M1_PW1, "LCD_M1 PW1"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS1_N_PW2, "SPI2_CS1_N PW2"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS2_N_PW3, "SPI2_CS2_N PW3"),
+	PINCTRL_PIN(TEGRA_PIN_DAP_MCLK1_PW4, "DAP_MCLK1 PW4"),
+	PINCTRL_PIN(TEGRA_PIN_DAP_MCLK2_PW5, "DAP_MCLK2 PW5"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_TXD_PW6, "UART3_TXD PW6"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_RXD_PW7, "UART3_RXD PW7"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_MOSI_PX0, "SPI2_MOSI PX0"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_MISO_PX1, "SPI2_MISO PX1"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_SCK_PX2, "SPI2_SCK PX2"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS0_N_PX3, "SPI2_CS0_N PX3"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_MOSI_PX4, "SPI1_MOSI PX4"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_SCK_PX5, "SPI1_SCK PX5"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_CS0_N_PX6, "SPI1_CS0_N PX6"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_MISO_PX7, "SPI1_MISO PX7"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_CLK_PY0, "ULPI_CLK PY0"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DIR_PY1, "ULPI_DIR PY1"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_NXT_PY2, "ULPI_NXT PY2"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_STP_PY3, "ULPI_STP PY3"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_DAT3_PY4, "SDIO1_DAT3 PY4"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_DAT2_PY5, "SDIO1_DAT2 PY5"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_DAT1_PY6, "SDIO1_DAT1 PY6"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_DAT0_PY7, "SDIO1_DAT0 PY7"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_CLK_PZ0, "SDIO1_CLK PZ0"),
+	PINCTRL_PIN(TEGRA_PIN_SDIO1_CMD_PZ1, "SDIO1_CMD PZ1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SDIN_PZ2, "LCD_SDIN PZ2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_WR_N_PZ3, "LCD_WR_N PZ3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SCK_PZ4, "LCD_SCK PZ4"),
+	PINCTRL_PIN(TEGRA_PIN_SYS_CLK_REQ_PZ5, "SYS_CLK_REQ PZ5"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_I2C_SCL_PZ6, "PWR_I2C_SCL PZ6"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_I2C_SDA_PZ7, "PWR_I2C_SDA PZ7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD20_PAA0, "GMI_AD20 PAA0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD21_PAA1, "GMI_AD21 PAA1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD22_PAA2, "GMI_AD22 PAA2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD23_PAA3, "GMI_AD23 PAA3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD24_PAA4, "GMI_AD24 PAA4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD25_PAA5, "GMI_AD25 PAA5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD26_PAA6, "GMI_AD26 PAA6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD27_PAA7, "GMI_AD27 PAA7"),
+	PINCTRL_PIN(TEGRA_PIN_LED_BLINK_PBB0, "LED_BLINK PBB0"),
+	PINCTRL_PIN(TEGRA_PIN_VI_GP0_PBB1, "VI_GP0 PBB1"),
+	PINCTRL_PIN(TEGRA_PIN_CAM_I2C_SCL_PBB2, "CAM_I2C_SCL PBB2"),
+	PINCTRL_PIN(TEGRA_PIN_CAM_I2C_SDA_PBB3, "CAM_I2C_SDA PBB3"),
+	PINCTRL_PIN(TEGRA_PIN_VI_GP3_PBB4, "VI_GP3 PBB4"),
+	PINCTRL_PIN(TEGRA_PIN_VI_GP4_PBB5, "VI_GP4 PBB5"),
+	PINCTRL_PIN(TEGRA_PIN_PBB6, "PBB6"),
+	PINCTRL_PIN(TEGRA_PIN_PBB7, "PBB7"),
+	PINCTRL_PIN(TEGRA_PIN_CRT_HSYNC, "CRT_HSYNC"),
+	PINCTRL_PIN(TEGRA_PIN_CRT_VSYNC, "CRT_VSYNC"),
+	PINCTRL_PIN(TEGRA_PIN_DDC_SCL, "DDC_SCL"),
+	PINCTRL_PIN(TEGRA_PIN_DDC_SDA, "DDC_SDA"),
+	PINCTRL_PIN(TEGRA_PIN_OWC, "OWC"),
+	PINCTRL_PIN(TEGRA_PIN_CORE_PWR_REQ, "CORE_PWR_REQ"),
+	PINCTRL_PIN(TEGRA_PIN_CPU_PWR_REQ, "CPU_PWR_REQ"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_INT_N, "PWR_INT_N"),
+	PINCTRL_PIN(TEGRA_PIN_CLK_32_K_IN, "CLK_32_K_IN"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_COMP_PD, "DDR_COMP_PD"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_COMP_PU, "DDR_COMP_PU"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A0, "DDR_A0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A1, "DDR_A1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A2, "DDR_A2"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A3, "DDR_A3"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A4, "DDR_A4"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A5, "DDR_A5"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A6, "DDR_A6"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A7, "DDR_A7"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A8, "DDR_A8"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A9, "DDR_A9"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A10, "DDR_A10"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A11, "DDR_A11"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A12, "DDR_A12"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A13, "DDR_A13"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_A14, "DDR_A14"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CAS_N, "DDR_CAS_N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_BA0, "DDR_BA0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_BA1, "DDR_BA1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_BA2, "DDR_BA2"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS0P, "DDR_DQS0P"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS0N, "DDR_DQS0N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS1P, "DDR_DQS1P"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS1N, "DDR_DQS1N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS2P, "DDR_DQS2P"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS2N, "DDR_DQS2N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS3P, "DDR_DQS3P"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQS3N, "DDR_DQS3N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CKE0, "DDR_CKE0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CKE1, "DDR_CKE1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CLK, "DDR_CLK"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CLK_N, "DDR_CLK_N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DM0, "DDR_DM0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DM1, "DDR_DM1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DM2, "DDR_DM2"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DM3, "DDR_DM3"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_ODT, "DDR_ODT"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_QUSE0, "DDR_QUSE0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_QUSE1, "DDR_QUSE1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_QUSE2, "DDR_QUSE2"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_QUSE3, "DDR_QUSE3"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_RAS_N, "DDR_RAS_N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_WE_N, "DDR_WE_N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ0, "DDR_DQ0"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ1, "DDR_DQ1"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ2, "DDR_DQ2"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ3, "DDR_DQ3"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ4, "DDR_DQ4"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ5, "DDR_DQ5"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ6, "DDR_DQ6"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ7, "DDR_DQ7"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ8, "DDR_DQ8"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ9, "DDR_DQ9"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ10, "DDR_DQ10"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ11, "DDR_DQ11"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ12, "DDR_DQ12"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ13, "DDR_DQ13"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ14, "DDR_DQ14"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ15, "DDR_DQ15"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ16, "DDR_DQ16"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ17, "DDR_DQ17"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ18, "DDR_DQ18"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ19, "DDR_DQ19"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ20, "DDR_DQ20"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ21, "DDR_DQ21"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ22, "DDR_DQ22"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ23, "DDR_DQ23"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ24, "DDR_DQ24"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ25, "DDR_DQ25"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ26, "DDR_DQ26"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ27, "DDR_DQ27"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ28, "DDR_DQ28"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ29, "DDR_DQ29"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ30, "DDR_DQ30"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_DQ31, "DDR_DQ31"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CS0_N, "DDR_CS0_N"),
+	PINCTRL_PIN(TEGRA_PIN_DDR_CS1_N, "DDR_CS1_N"),
+	PINCTRL_PIN(TEGRA_PIN_SYS_RESET, "SYS_RESET"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TRST_N, "JTAG_TRST_N"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TDO, "JTAG_TDO"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TMS, "JTAG_TMS"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TCK, "JTAG_TCK"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TDI, "JTAG_TDI"),
+	PINCTRL_PIN(TEGRA_PIN_TEST_MODE_EN, "TEST_MODE_EN"),
+};
+
+static const unsigned ata_pins[] = {
+	TEGRA_PIN_GMI_CS6_N_PI3,
+	TEGRA_PIN_GMI_CS7_N_PI6,
+	TEGRA_PIN_GMI_RST_N_PI4,
+};
+
+static const unsigned atb_pins[] = {
+	TEGRA_PIN_GMI_CS5_N_PI2,
+	TEGRA_PIN_GMI_DPD_PT7,
+};
+
+static const unsigned atc_pins[] = {
+	TEGRA_PIN_GMI_IORDY_PI5,
+	TEGRA_PIN_GMI_WAIT_PI7,
+	TEGRA_PIN_GMI_ADV_N_PK0,
+	TEGRA_PIN_GMI_CLK_PK1,
+	TEGRA_PIN_GMI_CS2_N_PK3,
+	TEGRA_PIN_GMI_CS3_N_PK4,
+	TEGRA_PIN_GMI_CS4_N_PK2,
+	TEGRA_PIN_GMI_AD0_PG0,
+	TEGRA_PIN_GMI_AD1_PG1,
+	TEGRA_PIN_GMI_AD2_PG2,
+	TEGRA_PIN_GMI_AD3_PG3,
+	TEGRA_PIN_GMI_AD4_PG4,
+	TEGRA_PIN_GMI_AD5_PG5,
+	TEGRA_PIN_GMI_AD6_PG6,
+	TEGRA_PIN_GMI_AD7_PG7,
+	TEGRA_PIN_GMI_HIOW_N_PI0,
+	TEGRA_PIN_GMI_HIOR_N_PI1,
+};
+
+static const unsigned atd_pins[] = {
+	TEGRA_PIN_GMI_AD8_PH0,
+	TEGRA_PIN_GMI_AD9_PH1,
+	TEGRA_PIN_GMI_AD10_PH2,
+	TEGRA_PIN_GMI_AD11_PH3,
+};
+
+static const unsigned ate_pins[] = {
+	TEGRA_PIN_GMI_AD12_PH4,
+	TEGRA_PIN_GMI_AD13_PH5,
+	TEGRA_PIN_GMI_AD14_PH6,
+	TEGRA_PIN_GMI_AD15_PH7,
+};
+
+static const unsigned cdev1_pins[] = {
+	TEGRA_PIN_DAP_MCLK1_PW4,
+};
+
+static const unsigned cdev2_pins[] = {
+	TEGRA_PIN_DAP_MCLK2_PW5,
+};
+
+static const unsigned crtp_pins[] = {
+	TEGRA_PIN_CRT_HSYNC,
+	TEGRA_PIN_CRT_VSYNC,
+};
+
+static const unsigned csus_pins[] = {
+	TEGRA_PIN_VI_MCLK_PT1,
+};
+
+static const unsigned dap1_pins[] = {
+	TEGRA_PIN_DAP1_FS_PN0,
+	TEGRA_PIN_DAP1_DIN_PN1,
+	TEGRA_PIN_DAP1_DOUT_PN2,
+	TEGRA_PIN_DAP1_SCLK_PN3,
+};
+
+static const unsigned dap2_pins[] = {
+	TEGRA_PIN_DAP2_FS_PA2,
+	TEGRA_PIN_DAP2_SCLK_PA3,
+	TEGRA_PIN_DAP2_DIN_PA4,
+	TEGRA_PIN_DAP2_DOUT_PA5,
+};
+
+static const unsigned dap3_pins[] = {
+	TEGRA_PIN_DAP3_FS_PP0,
+	TEGRA_PIN_DAP3_DIN_PP1,
+	TEGRA_PIN_DAP3_DOUT_PP2,
+	TEGRA_PIN_DAP3_SCLK_PP3,
+};
+
+static const unsigned dap4_pins[] = {
+	TEGRA_PIN_DAP4_FS_PP4,
+	TEGRA_PIN_DAP4_DIN_PP5,
+	TEGRA_PIN_DAP4_DOUT_PP6,
+	TEGRA_PIN_DAP4_SCLK_PP7,
+};
+
+static const unsigned ddc_pins[] = {
+	TEGRA_PIN_DDC_SCL,
+	TEGRA_PIN_DDC_SDA,
+};
+
+static const unsigned dta_pins[] = {
+	TEGRA_PIN_VI_D0_PT4,
+	TEGRA_PIN_VI_D1_PD5,
+};
+
+static const unsigned dtb_pins[] = {
+	TEGRA_PIN_VI_D10_PT2,
+	TEGRA_PIN_VI_D11_PT3,
+};
+
+static const unsigned dtc_pins[] = {
+	TEGRA_PIN_VI_HSYNC_PD7,
+	TEGRA_PIN_VI_VSYNC_PD6,
+};
+
+static const unsigned dtd_pins[] = {
+	TEGRA_PIN_VI_PCLK_PT0,
+	TEGRA_PIN_VI_D2_PL0,
+	TEGRA_PIN_VI_D3_PL1,
+	TEGRA_PIN_VI_D4_PL2,
+	TEGRA_PIN_VI_D5_PL3,
+	TEGRA_PIN_VI_D6_PL4,
+	TEGRA_PIN_VI_D7_PL5,
+	TEGRA_PIN_VI_D8_PL6,
+	TEGRA_PIN_VI_D9_PL7,
+};
+
+static const unsigned dte_pins[] = {
+	TEGRA_PIN_VI_GP0_PBB1,
+	TEGRA_PIN_VI_GP3_PBB4,
+	TEGRA_PIN_VI_GP4_PBB5,
+	TEGRA_PIN_VI_GP5_PD2,
+	TEGRA_PIN_VI_GP6_PA0,
+};
+
+static const unsigned dtf_pins[] = {
+	TEGRA_PIN_CAM_I2C_SCL_PBB2,
+	TEGRA_PIN_CAM_I2C_SDA_PBB3,
+};
+
+static const unsigned gma_pins[] = {
+	TEGRA_PIN_GMI_AD20_PAA0,
+	TEGRA_PIN_GMI_AD21_PAA1,
+	TEGRA_PIN_GMI_AD22_PAA2,
+	TEGRA_PIN_GMI_AD23_PAA3,
+};
+
+static const unsigned gmb_pins[] = {
+	TEGRA_PIN_GMI_WP_N_PC7,
+};
+
+static const unsigned gmc_pins[] = {
+	TEGRA_PIN_GMI_AD16_PJ7,
+	TEGRA_PIN_GMI_AD17_PB0,
+	TEGRA_PIN_GMI_AD18_PB1,
+	TEGRA_PIN_GMI_AD19_PK7,
+};
+
+static const unsigned gmd_pins[] = {
+	TEGRA_PIN_GMI_CS0_N_PJ0,
+	TEGRA_PIN_GMI_CS1_N_PJ2,
+};
+
+static const unsigned gme_pins[] = {
+	TEGRA_PIN_GMI_AD24_PAA4,
+	TEGRA_PIN_GMI_AD25_PAA5,
+	TEGRA_PIN_GMI_AD26_PAA6,
+	TEGRA_PIN_GMI_AD27_PAA7,
+};
+
+static const unsigned gpu_pins[] = {
+	TEGRA_PIN_PU0,
+	TEGRA_PIN_PU1,
+	TEGRA_PIN_PU2,
+	TEGRA_PIN_PU3,
+	TEGRA_PIN_PU4,
+	TEGRA_PIN_PU5,
+	TEGRA_PIN_PU6,
+};
+
+static const unsigned gpu7_pins[] = {
+	TEGRA_PIN_JTAG_RTCK_PU7,
+};
+
+static const unsigned gpv_pins[] = {
+	TEGRA_PIN_PV4,
+	TEGRA_PIN_PV5,
+	TEGRA_PIN_PV6,
+};
+
+static const unsigned hdint_pins[] = {
+	TEGRA_PIN_HDMI_INT_N_PN7,
+};
+
+static const unsigned i2cp_pins[] = {
+	TEGRA_PIN_PWR_I2C_SCL_PZ6,
+	TEGRA_PIN_PWR_I2C_SDA_PZ7,
+};
+
+static const unsigned irrx_pins[] = {
+	TEGRA_PIN_UART2_RTS_N_PJ6,
+};
+
+static const unsigned irtx_pins[] = {
+	TEGRA_PIN_UART2_CTS_N_PJ5,
+};
+
+static const unsigned kbca_pins[] = {
+	TEGRA_PIN_KB_ROW0_PR0,
+	TEGRA_PIN_KB_ROW1_PR1,
+	TEGRA_PIN_KB_ROW2_PR2,
+};
+
+static const unsigned kbcb_pins[] = {
+	TEGRA_PIN_KB_ROW7_PR7,
+	TEGRA_PIN_KB_ROW8_PS0,
+	TEGRA_PIN_KB_ROW9_PS1,
+	TEGRA_PIN_KB_ROW10_PS2,
+	TEGRA_PIN_KB_ROW11_PS3,
+	TEGRA_PIN_KB_ROW12_PS4,
+	TEGRA_PIN_KB_ROW13_PS5,
+	TEGRA_PIN_KB_ROW14_PS6,
+	TEGRA_PIN_KB_ROW15_PS7,
+};
+
+static const unsigned kbcc_pins[] = {
+	TEGRA_PIN_KB_COL0_PQ0,
+	TEGRA_PIN_KB_COL1_PQ1,
+};
+
+static const unsigned kbcd_pins[] = {
+	TEGRA_PIN_KB_ROW3_PR3,
+	TEGRA_PIN_KB_ROW4_PR4,
+	TEGRA_PIN_KB_ROW5_PR5,
+	TEGRA_PIN_KB_ROW6_PR6,
+};
+
+static const unsigned kbce_pins[] = {
+	TEGRA_PIN_KB_COL7_PQ7,
+};
+
+static const unsigned kbcf_pins[] = {
+	TEGRA_PIN_KB_COL2_PQ2,
+	TEGRA_PIN_KB_COL3_PQ3,
+	TEGRA_PIN_KB_COL4_PQ4,
+	TEGRA_PIN_KB_COL5_PQ5,
+	TEGRA_PIN_KB_COL6_PQ6,
+};
+
+static const unsigned lcsn_pins[] = {
+	TEGRA_PIN_LCD_CS0_N_PN4,
+};
+
+static const unsigned ld0_pins[] = {
+	TEGRA_PIN_LCD_D0_PE0,
+};
+
+static const unsigned ld1_pins[] = {
+	TEGRA_PIN_LCD_D1_PE1,
+};
+
+static const unsigned ld2_pins[] = {
+	TEGRA_PIN_LCD_D2_PE2,
+};
+
+static const unsigned ld3_pins[] = {
+	TEGRA_PIN_LCD_D3_PE3,
+};
+
+static const unsigned ld4_pins[] = {
+	TEGRA_PIN_LCD_D4_PE4,
+};
+
+static const unsigned ld5_pins[] = {
+	TEGRA_PIN_LCD_D5_PE5,
+};
+
+static const unsigned ld6_pins[] = {
+	TEGRA_PIN_LCD_D6_PE6,
+};
+
+static const unsigned ld7_pins[] = {
+	TEGRA_PIN_LCD_D7_PE7,
+};
+
+static const unsigned ld8_pins[] = {
+	TEGRA_PIN_LCD_D8_PF0,
+};
+
+static const unsigned ld9_pins[] = {
+	TEGRA_PIN_LCD_D9_PF1,
+};
+
+static const unsigned ld10_pins[] = {
+	TEGRA_PIN_LCD_D10_PF2,
+};
+
+static const unsigned ld11_pins[] = {
+	TEGRA_PIN_LCD_D11_PF3,
+};
+
+static const unsigned ld12_pins[] = {
+	TEGRA_PIN_LCD_D12_PF4,
+};
+
+static const unsigned ld13_pins[] = {
+	TEGRA_PIN_LCD_D13_PF5,
+};
+
+static const unsigned ld14_pins[] = {
+	TEGRA_PIN_LCD_D14_PF6,
+};
+
+static const unsigned ld15_pins[] = {
+	TEGRA_PIN_LCD_D15_PF7,
+};
+
+static const unsigned ld16_pins[] = {
+	TEGRA_PIN_LCD_D16_PM0,
+};
+
+static const unsigned ld17_pins[] = {
+	TEGRA_PIN_LCD_D17_PM1,
+};
+
+static const unsigned ldc_pins[] = {
+	TEGRA_PIN_LCD_DC0_PN6,
+};
+
+static const unsigned ldi_pins[] = {
+	TEGRA_PIN_LCD_D22_PM6,
+};
+
+static const unsigned lhp0_pins[] = {
+	TEGRA_PIN_LCD_D21_PM5,
+};
+
+static const unsigned lhp1_pins[] = {
+	TEGRA_PIN_LCD_D18_PM2,
+};
+
+static const unsigned lhp2_pins[] = {
+	TEGRA_PIN_LCD_D19_PM3,
+};
+
+static const unsigned lhs_pins[] = {
+	TEGRA_PIN_LCD_HSYNC_PJ3,
+};
+
+static const unsigned lm0_pins[] = {
+	TEGRA_PIN_LCD_CS1_N_PW0,
+};
+
+static const unsigned lm1_pins[] = {
+	TEGRA_PIN_LCD_M1_PW1,
+};
+
+static const unsigned lpp_pins[] = {
+	TEGRA_PIN_LCD_D23_PM7,
+};
+
+static const unsigned lpw0_pins[] = {
+	TEGRA_PIN_LCD_PWR0_PB2,
+};
+
+static const unsigned lpw1_pins[] = {
+	TEGRA_PIN_LCD_PWR1_PC1,
+};
+
+static const unsigned lpw2_pins[] = {
+	TEGRA_PIN_LCD_PWR2_PC6,
+};
+
+static const unsigned lsc0_pins[] = {
+	TEGRA_PIN_LCD_PCLK_PB3,
+};
+
+static const unsigned lsc1_pins[] = {
+	TEGRA_PIN_LCD_WR_N_PZ3,
+};
+
+static const unsigned lsck_pins[] = {
+	TEGRA_PIN_LCD_SCK_PZ4,
+};
+
+static const unsigned lsda_pins[] = {
+	TEGRA_PIN_LCD_SDOUT_PN5,
+};
+
+static const unsigned lsdi_pins[] = {
+	TEGRA_PIN_LCD_SDIN_PZ2,
+};
+
+static const unsigned lspi_pins[] = {
+	TEGRA_PIN_LCD_DE_PJ1,
+};
+
+static const unsigned lvp0_pins[] = {
+	TEGRA_PIN_LCD_DC1_PV7,
+};
+
+static const unsigned lvp1_pins[] = {
+	TEGRA_PIN_LCD_D20_PM4,
+};
+
+static const unsigned lvs_pins[] = {
+	TEGRA_PIN_LCD_VSYNC_PJ4,
+};
+
+static const unsigned ls_pins[] = {
+	TEGRA_PIN_LCD_PWR0_PB2,
+	TEGRA_PIN_LCD_PWR1_PC1,
+	TEGRA_PIN_LCD_PWR2_PC6,
+	TEGRA_PIN_LCD_SDIN_PZ2,
+	TEGRA_PIN_LCD_SDOUT_PN5,
+	TEGRA_PIN_LCD_WR_N_PZ3,
+	TEGRA_PIN_LCD_CS0_N_PN4,
+	TEGRA_PIN_LCD_DC0_PN6,
+	TEGRA_PIN_LCD_SCK_PZ4,
+};
+
+static const unsigned lc_pins[] = {
+	TEGRA_PIN_LCD_PCLK_PB3,
+	TEGRA_PIN_LCD_DE_PJ1,
+	TEGRA_PIN_LCD_HSYNC_PJ3,
+	TEGRA_PIN_LCD_VSYNC_PJ4,
+	TEGRA_PIN_LCD_CS1_N_PW0,
+	TEGRA_PIN_LCD_M1_PW1,
+	TEGRA_PIN_LCD_DC1_PV7,
+	TEGRA_PIN_HDMI_INT_N_PN7,
+};
+
+static const unsigned ld17_0_pins[] = {
+	TEGRA_PIN_LCD_D0_PE0,
+	TEGRA_PIN_LCD_D1_PE1,
+	TEGRA_PIN_LCD_D2_PE2,
+	TEGRA_PIN_LCD_D3_PE3,
+	TEGRA_PIN_LCD_D4_PE4,
+	TEGRA_PIN_LCD_D5_PE5,
+	TEGRA_PIN_LCD_D6_PE6,
+	TEGRA_PIN_LCD_D7_PE7,
+	TEGRA_PIN_LCD_D8_PF0,
+	TEGRA_PIN_LCD_D9_PF1,
+	TEGRA_PIN_LCD_D10_PF2,
+	TEGRA_PIN_LCD_D11_PF3,
+	TEGRA_PIN_LCD_D12_PF4,
+	TEGRA_PIN_LCD_D13_PF5,
+	TEGRA_PIN_LCD_D14_PF6,
+	TEGRA_PIN_LCD_D15_PF7,
+	TEGRA_PIN_LCD_D16_PM0,
+	TEGRA_PIN_LCD_D17_PM1,
+};
+
+static const unsigned ld19_18_pins[] = {
+	TEGRA_PIN_LCD_D18_PM2,
+	TEGRA_PIN_LCD_D19_PM3,
+};
+
+static const unsigned ld21_20_pins[] = {
+	TEGRA_PIN_LCD_D20_PM4,
+	TEGRA_PIN_LCD_D21_PM5,
+};
+
+static const unsigned ld23_22_pins[] = {
+	TEGRA_PIN_LCD_D22_PM6,
+	TEGRA_PIN_LCD_D23_PM7,
+};
+
+static const unsigned owc_pins[] = {
+	TEGRA_PIN_OWC,
+};
+
+static const unsigned pmc_pins[] = {
+	TEGRA_PIN_LED_BLINK_PBB0,
+	TEGRA_PIN_SYS_CLK_REQ_PZ5,
+	TEGRA_PIN_CORE_PWR_REQ,
+	TEGRA_PIN_CPU_PWR_REQ,
+	TEGRA_PIN_PWR_INT_N,
+};
+
+static const unsigned pta_pins[] = {
+	TEGRA_PIN_GEN2_I2C_SCL_PT5,
+	TEGRA_PIN_GEN2_I2C_SDA_PT6,
+};
+
+static const unsigned rm_pins[] = {
+	TEGRA_PIN_GEN1_I2C_SCL_PC4,
+	TEGRA_PIN_GEN1_I2C_SDA_PC5,
+};
+
+static const unsigned sdb_pins[] = {
+	TEGRA_PIN_SDIO3_CMD_PA7,
+};
+
+static const unsigned sdc_pins[] = {
+	TEGRA_PIN_SDIO3_DAT0_PB7,
+	TEGRA_PIN_SDIO3_DAT1_PB6,
+	TEGRA_PIN_SDIO3_DAT2_PB5,
+	TEGRA_PIN_SDIO3_DAT3_PB4,
+};
+
+static const unsigned sdd_pins[] = {
+	TEGRA_PIN_SDIO3_CLK_PA6,
+};
+
+static const unsigned sdio1_pins[] = {
+	TEGRA_PIN_SDIO1_CLK_PZ0,
+	TEGRA_PIN_SDIO1_CMD_PZ1,
+	TEGRA_PIN_SDIO1_DAT0_PY7,
+	TEGRA_PIN_SDIO1_DAT1_PY6,
+	TEGRA_PIN_SDIO1_DAT2_PY5,
+	TEGRA_PIN_SDIO1_DAT3_PY4,
+};
+
+static const unsigned slxa_pins[] = {
+	TEGRA_PIN_SDIO3_DAT4_PD1,
+};
+
+static const unsigned slxc_pins[] = {
+	TEGRA_PIN_SDIO3_DAT6_PD3,
+};
+
+static const unsigned slxd_pins[] = {
+	TEGRA_PIN_SDIO3_DAT7_PD4,
+};
+
+static const unsigned slxk_pins[] = {
+	TEGRA_PIN_SDIO3_DAT5_PD0,
+};
+
+static const unsigned spdi_pins[] = {
+	TEGRA_PIN_SPDIF_IN_PK6,
+};
+
+static const unsigned spdo_pins[] = {
+	TEGRA_PIN_SPDIF_OUT_PK5,
+};
+
+static const unsigned spia_pins[] = {
+	TEGRA_PIN_SPI2_MOSI_PX0,
+};
+
+static const unsigned spib_pins[] = {
+	TEGRA_PIN_SPI2_MISO_PX1,
+};
+
+static const unsigned spic_pins[] = {
+	TEGRA_PIN_SPI2_CS0_N_PX3,
+	TEGRA_PIN_SPI2_SCK_PX2,
+};
+
+static const unsigned spid_pins[] = {
+	TEGRA_PIN_SPI1_MOSI_PX4,
+};
+
+static const unsigned spie_pins[] = {
+	TEGRA_PIN_SPI1_CS0_N_PX6,
+	TEGRA_PIN_SPI1_SCK_PX5,
+};
+
+static const unsigned spif_pins[] = {
+	TEGRA_PIN_SPI1_MISO_PX7,
+};
+
+static const unsigned spig_pins[] = {
+	TEGRA_PIN_SPI2_CS1_N_PW2,
+};
+
+static const unsigned spih_pins[] = {
+	TEGRA_PIN_SPI2_CS2_N_PW3,
+};
+
+static const unsigned uaa_pins[] = {
+	TEGRA_PIN_ULPI_DATA0_PO1,
+	TEGRA_PIN_ULPI_DATA1_PO2,
+	TEGRA_PIN_ULPI_DATA2_PO3,
+	TEGRA_PIN_ULPI_DATA3_PO4,
+};
+
+static const unsigned uab_pins[] = {
+	TEGRA_PIN_ULPI_DATA4_PO5,
+	TEGRA_PIN_ULPI_DATA5_PO6,
+	TEGRA_PIN_ULPI_DATA6_PO7,
+	TEGRA_PIN_ULPI_DATA7_PO0,
+};
+
+static const unsigned uac_pins[] = {
+	TEGRA_PIN_PV0,
+	TEGRA_PIN_PV1,
+	TEGRA_PIN_PV2,
+	TEGRA_PIN_PV3,
+};
+
+static const unsigned ck32_pins[] = {
+	TEGRA_PIN_CLK_32_K_IN,
+};
+
+static const unsigned uad_pins[] = {
+	TEGRA_PIN_UART2_RXD_PC3,
+	TEGRA_PIN_UART2_TXD_PC2,
+};
+
+static const unsigned uca_pins[] = {
+	TEGRA_PIN_UART3_RXD_PW7,
+	TEGRA_PIN_UART3_TXD_PW6,
+};
+
+static const unsigned ucb_pins[] = {
+	TEGRA_PIN_UART3_CTS_N_PA1,
+	TEGRA_PIN_UART3_RTS_N_PC0,
+};
+
+static const unsigned uda_pins[] = {
+	TEGRA_PIN_ULPI_CLK_PY0,
+	TEGRA_PIN_ULPI_DIR_PY1,
+	TEGRA_PIN_ULPI_NXT_PY2,
+	TEGRA_PIN_ULPI_STP_PY3,
+};
+
+static const unsigned ddrc_pins[] = {
+	TEGRA_PIN_DDR_COMP_PD,
+	TEGRA_PIN_DDR_COMP_PU,
+};
+
+static const unsigned pmca_pins[] = {
+	TEGRA_PIN_LED_BLINK_PBB0,
+};
+
+static const unsigned pmcb_pins[] = {
+	TEGRA_PIN_SYS_CLK_REQ_PZ5,
+};
+
+static const unsigned pmcc_pins[] = {
+	TEGRA_PIN_CORE_PWR_REQ,
+};
+
+static const unsigned pmcd_pins[] = {
+	TEGRA_PIN_CPU_PWR_REQ,
+};
+
+static const unsigned pmce_pins[] = {
+	TEGRA_PIN_PWR_INT_N,
+};
+
+static const unsigned xm2c_pins[] = {
+	TEGRA_PIN_DDR_A0,
+	TEGRA_PIN_DDR_A1,
+	TEGRA_PIN_DDR_A2,
+	TEGRA_PIN_DDR_A3,
+	TEGRA_PIN_DDR_A4,
+	TEGRA_PIN_DDR_A5,
+	TEGRA_PIN_DDR_A6,
+	TEGRA_PIN_DDR_A7,
+	TEGRA_PIN_DDR_A8,
+	TEGRA_PIN_DDR_A9,
+	TEGRA_PIN_DDR_A10,
+	TEGRA_PIN_DDR_A11,
+	TEGRA_PIN_DDR_A12,
+	TEGRA_PIN_DDR_A13,
+	TEGRA_PIN_DDR_A14,
+	TEGRA_PIN_DDR_CAS_N,
+	TEGRA_PIN_DDR_BA0,
+	TEGRA_PIN_DDR_BA1,
+	TEGRA_PIN_DDR_BA2,
+	TEGRA_PIN_DDR_DQS0P,
+	TEGRA_PIN_DDR_DQS0N,
+	TEGRA_PIN_DDR_DQS1P,
+	TEGRA_PIN_DDR_DQS1N,
+	TEGRA_PIN_DDR_DQS2P,
+	TEGRA_PIN_DDR_DQS2N,
+	TEGRA_PIN_DDR_DQS3P,
+	TEGRA_PIN_DDR_DQS3N,
+	TEGRA_PIN_DDR_CS0_N,
+	TEGRA_PIN_DDR_CS1_N,
+	TEGRA_PIN_DDR_CKE0,
+	TEGRA_PIN_DDR_CKE1,
+	TEGRA_PIN_DDR_CLK,
+	TEGRA_PIN_DDR_CLK_N,
+	TEGRA_PIN_DDR_DM0,
+	TEGRA_PIN_DDR_DM1,
+	TEGRA_PIN_DDR_DM2,
+	TEGRA_PIN_DDR_DM3,
+	TEGRA_PIN_DDR_ODT,
+	TEGRA_PIN_DDR_RAS_N,
+	TEGRA_PIN_DDR_WE_N,
+	TEGRA_PIN_DDR_QUSE0,
+	TEGRA_PIN_DDR_QUSE1,
+	TEGRA_PIN_DDR_QUSE2,
+	TEGRA_PIN_DDR_QUSE3,
+};
+
+static const unsigned xm2d_pins[] = {
+	TEGRA_PIN_DDR_DQ0,
+	TEGRA_PIN_DDR_DQ1,
+	TEGRA_PIN_DDR_DQ2,
+	TEGRA_PIN_DDR_DQ3,
+	TEGRA_PIN_DDR_DQ4,
+	TEGRA_PIN_DDR_DQ5,
+	TEGRA_PIN_DDR_DQ6,
+	TEGRA_PIN_DDR_DQ7,
+	TEGRA_PIN_DDR_DQ8,
+	TEGRA_PIN_DDR_DQ9,
+	TEGRA_PIN_DDR_DQ10,
+	TEGRA_PIN_DDR_DQ11,
+	TEGRA_PIN_DDR_DQ12,
+	TEGRA_PIN_DDR_DQ13,
+	TEGRA_PIN_DDR_DQ14,
+	TEGRA_PIN_DDR_DQ15,
+	TEGRA_PIN_DDR_DQ16,
+	TEGRA_PIN_DDR_DQ17,
+	TEGRA_PIN_DDR_DQ18,
+	TEGRA_PIN_DDR_DQ19,
+	TEGRA_PIN_DDR_DQ20,
+	TEGRA_PIN_DDR_DQ21,
+	TEGRA_PIN_DDR_DQ22,
+	TEGRA_PIN_DDR_DQ23,
+	TEGRA_PIN_DDR_DQ24,
+	TEGRA_PIN_DDR_DQ25,
+	TEGRA_PIN_DDR_DQ26,
+	TEGRA_PIN_DDR_DQ27,
+	TEGRA_PIN_DDR_DQ28,
+	TEGRA_PIN_DDR_DQ29,
+	TEGRA_PIN_DDR_DQ30,
+	TEGRA_PIN_DDR_DQ31,
+};
+
+static const unsigned drive_ao1_pins[] = {
+	TEGRA_PIN_SYS_RESET,
+	TEGRA_PIN_PWR_I2C_SCL_PZ6,
+	TEGRA_PIN_PWR_I2C_SDA_PZ7,
+	TEGRA_PIN_KB_ROW0_PR0,
+	TEGRA_PIN_KB_ROW1_PR1,
+	TEGRA_PIN_KB_ROW2_PR2,
+	TEGRA_PIN_KB_ROW3_PR3,
+	TEGRA_PIN_KB_ROW4_PR4,
+	TEGRA_PIN_KB_ROW5_PR5,
+	TEGRA_PIN_KB_ROW6_PR6,
+	TEGRA_PIN_KB_ROW7_PR7,
+};
+
+static const unsigned drive_ao2_pins[] = {
+	TEGRA_PIN_KB_ROW8_PS0,
+	TEGRA_PIN_KB_ROW9_PS1,
+	TEGRA_PIN_KB_ROW10_PS2,
+	TEGRA_PIN_KB_ROW11_PS3,
+	TEGRA_PIN_KB_ROW12_PS4,
+	TEGRA_PIN_KB_ROW13_PS5,
+	TEGRA_PIN_KB_ROW14_PS6,
+	TEGRA_PIN_KB_ROW15_PS7,
+	TEGRA_PIN_KB_COL0_PQ0,
+	TEGRA_PIN_KB_COL1_PQ1,
+	TEGRA_PIN_KB_COL2_PQ2,
+	TEGRA_PIN_KB_COL3_PQ3,
+	TEGRA_PIN_KB_COL4_PQ4,
+	TEGRA_PIN_KB_COL5_PQ5,
+	TEGRA_PIN_KB_COL6_PQ6,
+	TEGRA_PIN_KB_COL7_PQ7,
+	TEGRA_PIN_LED_BLINK_PBB0,
+	TEGRA_PIN_SYS_CLK_REQ_PZ5,
+	TEGRA_PIN_CORE_PWR_REQ,
+	TEGRA_PIN_CPU_PWR_REQ,
+	TEGRA_PIN_PWR_INT_N,
+	TEGRA_PIN_CLK_32_K_IN,
+};
+
+static const unsigned drive_at1_pins[] = {
+	TEGRA_PIN_GMI_IORDY_PI5,
+	TEGRA_PIN_GMI_AD8_PH0,
+	TEGRA_PIN_GMI_AD9_PH1,
+	TEGRA_PIN_GMI_AD10_PH2,
+	TEGRA_PIN_GMI_AD11_PH3,
+	TEGRA_PIN_GMI_AD12_PH4,
+	TEGRA_PIN_GMI_AD13_PH5,
+	TEGRA_PIN_GMI_AD14_PH6,
+	TEGRA_PIN_GMI_AD15_PH7,
+	TEGRA_PIN_GMI_CS7_N_PI6,
+	TEGRA_PIN_GMI_DPD_PT7,
+	TEGRA_PIN_GEN2_I2C_SCL_PT5,
+	TEGRA_PIN_GEN2_I2C_SDA_PT6,
+};
+
+static const unsigned drive_at2_pins[] = {
+	TEGRA_PIN_GMI_WAIT_PI7,
+	TEGRA_PIN_GMI_ADV_N_PK0,
+	TEGRA_PIN_GMI_CLK_PK1,
+	TEGRA_PIN_GMI_CS6_N_PI3,
+	TEGRA_PIN_GMI_CS5_N_PI2,
+	TEGRA_PIN_GMI_CS4_N_PK2,
+	TEGRA_PIN_GMI_CS3_N_PK4,
+	TEGRA_PIN_GMI_CS2_N_PK3,
+	TEGRA_PIN_GMI_AD0_PG0,
+	TEGRA_PIN_GMI_AD1_PG1,
+	TEGRA_PIN_GMI_AD2_PG2,
+	TEGRA_PIN_GMI_AD3_PG3,
+	TEGRA_PIN_GMI_AD4_PG4,
+	TEGRA_PIN_GMI_AD5_PG5,
+	TEGRA_PIN_GMI_AD6_PG6,
+	TEGRA_PIN_GMI_AD7_PG7,
+	TEGRA_PIN_GMI_HIOW_N_PI0,
+	TEGRA_PIN_GMI_HIOR_N_PI1,
+	TEGRA_PIN_GMI_RST_N_PI4,
+};
+
+static const unsigned drive_cdev1_pins[] = {
+	TEGRA_PIN_DAP_MCLK1_PW4,
+};
+
+static const unsigned drive_cdev2_pins[] = {
+	TEGRA_PIN_DAP_MCLK2_PW5,
+};
+
+static const unsigned drive_csus_pins[] = {
+	TEGRA_PIN_VI_MCLK_PT1,
+};
+
+static const unsigned drive_dap1_pins[] = {
+	TEGRA_PIN_DAP1_FS_PN0,
+	TEGRA_PIN_DAP1_DIN_PN1,
+	TEGRA_PIN_DAP1_DOUT_PN2,
+	TEGRA_PIN_DAP1_SCLK_PN3,
+	TEGRA_PIN_SPDIF_OUT_PK5,
+	TEGRA_PIN_SPDIF_IN_PK6,
+};
+
+static const unsigned drive_dap2_pins[] = {
+	TEGRA_PIN_DAP2_FS_PA2,
+	TEGRA_PIN_DAP2_SCLK_PA3,
+	TEGRA_PIN_DAP2_DIN_PA4,
+	TEGRA_PIN_DAP2_DOUT_PA5,
+};
+
+static const unsigned drive_dap3_pins[] = {
+	TEGRA_PIN_DAP3_FS_PP0,
+	TEGRA_PIN_DAP3_DIN_PP1,
+	TEGRA_PIN_DAP3_DOUT_PP2,
+	TEGRA_PIN_DAP3_SCLK_PP3,
+};
+
+static const unsigned drive_dap4_pins[] = {
+	TEGRA_PIN_DAP4_FS_PP4,
+	TEGRA_PIN_DAP4_DIN_PP5,
+	TEGRA_PIN_DAP4_DOUT_PP6,
+	TEGRA_PIN_DAP4_SCLK_PP7,
+};
+
+static const unsigned drive_dbg_pins[] = {
+	TEGRA_PIN_PU0,
+	TEGRA_PIN_PU1,
+	TEGRA_PIN_PU2,
+	TEGRA_PIN_PU3,
+	TEGRA_PIN_PU4,
+	TEGRA_PIN_PU5,
+	TEGRA_PIN_PU6,
+	TEGRA_PIN_JTAG_RTCK_PU7,
+	TEGRA_PIN_GEN1_I2C_SDA_PC5,
+	TEGRA_PIN_GEN1_I2C_SCL_PC4,
+	TEGRA_PIN_JTAG_TRST_N,
+	TEGRA_PIN_JTAG_TDO,
+	TEGRA_PIN_JTAG_TMS,
+	TEGRA_PIN_JTAG_TCK,
+	TEGRA_PIN_JTAG_TDI,
+	TEGRA_PIN_TEST_MODE_EN,
+};
+
+static const unsigned drive_lcd1_pins[] = {
+	TEGRA_PIN_LCD_PWR1_PC1,
+	TEGRA_PIN_LCD_PWR2_PC6,
+	TEGRA_PIN_LCD_SDIN_PZ2,
+	TEGRA_PIN_LCD_SDOUT_PN5,
+	TEGRA_PIN_LCD_WR_N_PZ3,
+	TEGRA_PIN_LCD_CS0_N_PN4,
+	TEGRA_PIN_LCD_DC0_PN6,
+	TEGRA_PIN_LCD_SCK_PZ4,
+};
+
+static const unsigned drive_lcd2_pins[] = {
+	TEGRA_PIN_LCD_PWR0_PB2,
+	TEGRA_PIN_LCD_PCLK_PB3,
+	TEGRA_PIN_LCD_DE_PJ1,
+	TEGRA_PIN_LCD_HSYNC_PJ3,
+	TEGRA_PIN_LCD_VSYNC_PJ4,
+	TEGRA_PIN_LCD_D0_PE0,
+	TEGRA_PIN_LCD_D1_PE1,
+	TEGRA_PIN_LCD_D2_PE2,
+	TEGRA_PIN_LCD_D3_PE3,
+	TEGRA_PIN_LCD_D4_PE4,
+	TEGRA_PIN_LCD_D5_PE5,
+	TEGRA_PIN_LCD_D6_PE6,
+	TEGRA_PIN_LCD_D7_PE7,
+	TEGRA_PIN_LCD_D8_PF0,
+	TEGRA_PIN_LCD_D9_PF1,
+	TEGRA_PIN_LCD_D10_PF2,
+	TEGRA_PIN_LCD_D11_PF3,
+	TEGRA_PIN_LCD_D12_PF4,
+	TEGRA_PIN_LCD_D13_PF5,
+	TEGRA_PIN_LCD_D14_PF6,
+	TEGRA_PIN_LCD_D15_PF7,
+	TEGRA_PIN_LCD_D16_PM0,
+	TEGRA_PIN_LCD_D17_PM1,
+	TEGRA_PIN_LCD_D18_PM2,
+	TEGRA_PIN_LCD_D19_PM3,
+	TEGRA_PIN_LCD_D20_PM4,
+	TEGRA_PIN_LCD_D21_PM5,
+	TEGRA_PIN_LCD_D22_PM6,
+	TEGRA_PIN_LCD_D23_PM7,
+	TEGRA_PIN_LCD_CS1_N_PW0,
+	TEGRA_PIN_LCD_M1_PW1,
+	TEGRA_PIN_LCD_DC1_PV7,
+	TEGRA_PIN_HDMI_INT_N_PN7,
+};
+
+static const unsigned drive_sdmmc2_pins[] = {
+	TEGRA_PIN_SDIO3_DAT4_PD1,
+	TEGRA_PIN_SDIO3_DAT5_PD0,
+	TEGRA_PIN_SDIO3_DAT6_PD3,
+	TEGRA_PIN_SDIO3_DAT7_PD4,
+};
+
+static const unsigned drive_sdmmc3_pins[] = {
+	TEGRA_PIN_SDIO3_CLK_PA6,
+	TEGRA_PIN_SDIO3_CMD_PA7,
+	TEGRA_PIN_SDIO3_DAT0_PB7,
+	TEGRA_PIN_SDIO3_DAT1_PB6,
+	TEGRA_PIN_SDIO3_DAT2_PB5,
+	TEGRA_PIN_SDIO3_DAT3_PB4,
+	TEGRA_PIN_PV4,
+	TEGRA_PIN_PV5,
+	TEGRA_PIN_PV6,
+};
+
+static const unsigned drive_spi_pins[] = {
+	TEGRA_PIN_SPI2_MOSI_PX0,
+	TEGRA_PIN_SPI2_MISO_PX1,
+	TEGRA_PIN_SPI2_SCK_PX2,
+	TEGRA_PIN_SPI2_CS0_N_PX3,
+	TEGRA_PIN_SPI1_MOSI_PX4,
+	TEGRA_PIN_SPI1_SCK_PX5,
+	TEGRA_PIN_SPI1_CS0_N_PX6,
+	TEGRA_PIN_SPI1_MISO_PX7,
+	TEGRA_PIN_SPI2_CS1_N_PW2,
+	TEGRA_PIN_SPI2_CS2_N_PW3,
+};
+
+static const unsigned drive_uaa_pins[] = {
+	TEGRA_PIN_ULPI_DATA0_PO1,
+	TEGRA_PIN_ULPI_DATA1_PO2,
+	TEGRA_PIN_ULPI_DATA2_PO3,
+	TEGRA_PIN_ULPI_DATA3_PO4,
+};
+
+static const unsigned drive_uab_pins[] = {
+	TEGRA_PIN_ULPI_DATA4_PO5,
+	TEGRA_PIN_ULPI_DATA5_PO6,
+	TEGRA_PIN_ULPI_DATA6_PO7,
+	TEGRA_PIN_ULPI_DATA7_PO0,
+	TEGRA_PIN_PV0,
+	TEGRA_PIN_PV1,
+	TEGRA_PIN_PV2,
+	TEGRA_PIN_PV3,
+};
+
+static const unsigned drive_uart2_pins[] = {
+	TEGRA_PIN_UART2_TXD_PC2,
+	TEGRA_PIN_UART2_RXD_PC3,
+	TEGRA_PIN_UART2_RTS_N_PJ6,
+	TEGRA_PIN_UART2_CTS_N_PJ5,
+};
+
+static const unsigned drive_uart3_pins[] = {
+	TEGRA_PIN_UART3_TXD_PW6,
+	TEGRA_PIN_UART3_RXD_PW7,
+	TEGRA_PIN_UART3_RTS_N_PC0,
+	TEGRA_PIN_UART3_CTS_N_PA1,
+};
+
+static const unsigned drive_vi1_pins[] = {
+	TEGRA_PIN_VI_D0_PT4,
+	TEGRA_PIN_VI_D1_PD5,
+	TEGRA_PIN_VI_D2_PL0,
+	TEGRA_PIN_VI_D3_PL1,
+	TEGRA_PIN_VI_D4_PL2,
+	TEGRA_PIN_VI_D5_PL3,
+	TEGRA_PIN_VI_D6_PL4,
+	TEGRA_PIN_VI_D7_PL5,
+	TEGRA_PIN_VI_D8_PL6,
+	TEGRA_PIN_VI_D9_PL7,
+	TEGRA_PIN_VI_D10_PT2,
+	TEGRA_PIN_VI_D11_PT3,
+	TEGRA_PIN_VI_PCLK_PT0,
+	TEGRA_PIN_VI_VSYNC_PD6,
+	TEGRA_PIN_VI_HSYNC_PD7,
+};
+
+static const unsigned drive_vi2_pins[] = {
+	TEGRA_PIN_VI_GP0_PBB1,
+	TEGRA_PIN_CAM_I2C_SCL_PBB2,
+	TEGRA_PIN_CAM_I2C_SDA_PBB3,
+	TEGRA_PIN_VI_GP3_PBB4,
+	TEGRA_PIN_VI_GP4_PBB5,
+	TEGRA_PIN_VI_GP5_PD2,
+	TEGRA_PIN_VI_GP6_PA0,
+};
+
+static const unsigned drive_xm2a_pins[] = {
+	TEGRA_PIN_DDR_A0,
+	TEGRA_PIN_DDR_A1,
+	TEGRA_PIN_DDR_A2,
+	TEGRA_PIN_DDR_A3,
+	TEGRA_PIN_DDR_A4,
+	TEGRA_PIN_DDR_A5,
+	TEGRA_PIN_DDR_A6,
+	TEGRA_PIN_DDR_A7,
+	TEGRA_PIN_DDR_A8,
+	TEGRA_PIN_DDR_A9,
+	TEGRA_PIN_DDR_A10,
+	TEGRA_PIN_DDR_A11,
+	TEGRA_PIN_DDR_A12,
+	TEGRA_PIN_DDR_A13,
+	TEGRA_PIN_DDR_A14,
+	TEGRA_PIN_DDR_BA0,
+	TEGRA_PIN_DDR_BA1,
+	TEGRA_PIN_DDR_BA2,
+	TEGRA_PIN_DDR_CS0_N,
+	TEGRA_PIN_DDR_CS1_N,
+	TEGRA_PIN_DDR_ODT,
+	TEGRA_PIN_DDR_RAS_N,
+	TEGRA_PIN_DDR_CAS_N,
+	TEGRA_PIN_DDR_WE_N,
+	TEGRA_PIN_DDR_CKE0,
+	TEGRA_PIN_DDR_CKE1,
+};
+
+static const unsigned drive_xm2c_pins[] = {
+	TEGRA_PIN_DDR_DQS0P,
+	TEGRA_PIN_DDR_DQS0N,
+	TEGRA_PIN_DDR_DQS1P,
+	TEGRA_PIN_DDR_DQS1N,
+	TEGRA_PIN_DDR_DQS2P,
+	TEGRA_PIN_DDR_DQS2N,
+	TEGRA_PIN_DDR_DQS3P,
+	TEGRA_PIN_DDR_DQS3N,
+	TEGRA_PIN_DDR_QUSE0,
+	TEGRA_PIN_DDR_QUSE1,
+	TEGRA_PIN_DDR_QUSE2,
+	TEGRA_PIN_DDR_QUSE3,
+};
+
+static const unsigned drive_xm2d_pins[] = {
+	TEGRA_PIN_DDR_DQ0,
+	TEGRA_PIN_DDR_DQ1,
+	TEGRA_PIN_DDR_DQ2,
+	TEGRA_PIN_DDR_DQ3,
+	TEGRA_PIN_DDR_DQ4,
+	TEGRA_PIN_DDR_DQ5,
+	TEGRA_PIN_DDR_DQ6,
+	TEGRA_PIN_DDR_DQ7,
+	TEGRA_PIN_DDR_DQ8,
+	TEGRA_PIN_DDR_DQ9,
+	TEGRA_PIN_DDR_DQ10,
+	TEGRA_PIN_DDR_DQ11,
+	TEGRA_PIN_DDR_DQ12,
+	TEGRA_PIN_DDR_DQ13,
+	TEGRA_PIN_DDR_DQ14,
+	TEGRA_PIN_DDR_DQ15,
+	TEGRA_PIN_DDR_DQ16,
+	TEGRA_PIN_DDR_DQ17,
+	TEGRA_PIN_DDR_DQ18,
+	TEGRA_PIN_DDR_DQ19,
+	TEGRA_PIN_DDR_DQ20,
+	TEGRA_PIN_DDR_DQ21,
+	TEGRA_PIN_DDR_DQ22,
+	TEGRA_PIN_DDR_DQ23,
+	TEGRA_PIN_DDR_DQ24,
+	TEGRA_PIN_DDR_DQ25,
+	TEGRA_PIN_DDR_DQ26,
+	TEGRA_PIN_DDR_DQ27,
+	TEGRA_PIN_DDR_DQ28,
+	TEGRA_PIN_DDR_DQ29,
+	TEGRA_PIN_DDR_DQ30,
+	TEGRA_PIN_DDR_DQ31,
+	TEGRA_PIN_DDR_DM0,
+	TEGRA_PIN_DDR_DM1,
+	TEGRA_PIN_DDR_DM2,
+	TEGRA_PIN_DDR_DM3,
+};
+
+static const unsigned drive_xm2clk_pins[] = {
+	TEGRA_PIN_DDR_CLK,
+	TEGRA_PIN_DDR_CLK_N,
+};
+
+static const unsigned drive_sdio1_pins[] = {
+	TEGRA_PIN_SDIO1_CLK_PZ0,
+	TEGRA_PIN_SDIO1_CMD_PZ1,
+	TEGRA_PIN_SDIO1_DAT0_PY7,
+	TEGRA_PIN_SDIO1_DAT1_PY6,
+	TEGRA_PIN_SDIO1_DAT2_PY5,
+	TEGRA_PIN_SDIO1_DAT3_PY4,
+};
+
+static const unsigned drive_crt_pins[] = {
+	TEGRA_PIN_CRT_HSYNC,
+	TEGRA_PIN_CRT_VSYNC,
+};
+
+static const unsigned drive_ddc_pins[] = {
+	TEGRA_PIN_DDC_SCL,
+	TEGRA_PIN_DDC_SDA,
+};
+
+static const unsigned drive_gma_pins[] = {
+	TEGRA_PIN_GMI_AD20_PAA0,
+	TEGRA_PIN_GMI_AD21_PAA1,
+	TEGRA_PIN_GMI_AD22_PAA2,
+	TEGRA_PIN_GMI_AD23_PAA3,
+};
+
+static const unsigned drive_gmb_pins[] = {
+	TEGRA_PIN_GMI_WP_N_PC7,
+};
+
+static const unsigned drive_gmc_pins[] = {
+	TEGRA_PIN_GMI_AD16_PJ7,
+	TEGRA_PIN_GMI_AD17_PB0,
+	TEGRA_PIN_GMI_AD18_PB1,
+	TEGRA_PIN_GMI_AD19_PK7,
+};
+
+static const unsigned drive_gmd_pins[] = {
+	TEGRA_PIN_GMI_CS0_N_PJ0,
+	TEGRA_PIN_GMI_CS1_N_PJ2,
+};
+
+static const unsigned drive_gme_pins[] = {
+	TEGRA_PIN_GMI_AD24_PAA4,
+	TEGRA_PIN_GMI_AD25_PAA5,
+	TEGRA_PIN_GMI_AD26_PAA6,
+	TEGRA_PIN_GMI_AD27_PAA7,
+};
+
+static const unsigned drive_owr_pins[] = {
+	TEGRA_PIN_OWC,
+};
+
+static const unsigned drive_uda_pins[] = {
+	TEGRA_PIN_ULPI_CLK_PY0,
+	TEGRA_PIN_ULPI_DIR_PY1,
+	TEGRA_PIN_ULPI_NXT_PY2,
+	TEGRA_PIN_ULPI_STP_PY3,
+};
+
+enum tegra_mux {
+	TEGRA_MUX_AHB_CLK,
+	TEGRA_MUX_APB_CLK,
+	TEGRA_MUX_AUDIO_SYNC,
+	TEGRA_MUX_CRT,
+	TEGRA_MUX_DAP1,
+	TEGRA_MUX_DAP2,
+	TEGRA_MUX_DAP3,
+	TEGRA_MUX_DAP4,
+	TEGRA_MUX_DAP5,
+	TEGRA_MUX_DISPLAYA,
+	TEGRA_MUX_DISPLAYB,
+	TEGRA_MUX_EMC_TEST0_DLL,
+	TEGRA_MUX_EMC_TEST1_DLL,
+	TEGRA_MUX_GMI,
+	TEGRA_MUX_GMI_INT,
+	TEGRA_MUX_HDMI,
+	TEGRA_MUX_I2CP,
+	TEGRA_MUX_I2C1,
+	TEGRA_MUX_I2C2,
+	TEGRA_MUX_I2C3,
+	TEGRA_MUX_IDE,
+	TEGRA_MUX_IRDA,
+	TEGRA_MUX_KBC,
+	TEGRA_MUX_MIO,
+	TEGRA_MUX_MIPI_HS,
+	TEGRA_MUX_NAND,
+	TEGRA_MUX_OSC,
+	TEGRA_MUX_OWR,
+	TEGRA_MUX_PCIE,
+	TEGRA_MUX_PLLA_OUT,
+	TEGRA_MUX_PLLC_OUT1,
+	TEGRA_MUX_PLLM_OUT1,
+	TEGRA_MUX_PLLP_OUT2,
+	TEGRA_MUX_PLLP_OUT3,
+	TEGRA_MUX_PLLP_OUT4,
+	TEGRA_MUX_PWM,
+	TEGRA_MUX_PWR_INTR,
+	TEGRA_MUX_PWR_ON,
+	TEGRA_MUX_RSVD1,
+	TEGRA_MUX_RSVD2,
+	TEGRA_MUX_RSVD3,
+	TEGRA_MUX_RSVD4,
+	TEGRA_MUX_RTCK,
+	TEGRA_MUX_SDIO1,
+	TEGRA_MUX_SDIO2,
+	TEGRA_MUX_SDIO3,
+	TEGRA_MUX_SDIO4,
+	TEGRA_MUX_SFLASH,
+	TEGRA_MUX_SPDIF,
+	TEGRA_MUX_SPI1,
+	TEGRA_MUX_SPI2,
+	TEGRA_MUX_SPI2_ALT,
+	TEGRA_MUX_SPI3,
+	TEGRA_MUX_SPI4,
+	TEGRA_MUX_TRACE,
+	TEGRA_MUX_TWC,
+	TEGRA_MUX_UARTA,
+	TEGRA_MUX_UARTB,
+	TEGRA_MUX_UARTC,
+	TEGRA_MUX_UARTD,
+	TEGRA_MUX_UARTE,
+	TEGRA_MUX_ULPI,
+	TEGRA_MUX_VI,
+	TEGRA_MUX_VI_SENSOR_CLK,
+	TEGRA_MUX_XIO,
+};
+
+static const char * const ahb_clk_groups[] = {
+	"cdev2",
+};
+
+static const char * const apb_clk_groups[] = {
+	"cdev2",
+};
+
+static const char * const audio_sync_groups[] = {
+	"cdev1",
+};
+
+static const char * const crt_groups[] = {
+	"crtp",
+	"lm1",
+};
+
+static const char * const dap1_groups[] = {
+	"dap1",
+};
+
+static const char * const dap2_groups[] = {
+	"dap2",
+};
+
+static const char * const dap3_groups[] = {
+	"dap3",
+};
+
+static const char * const dap4_groups[] = {
+	"dap4",
+};
+
+static const char * const dap5_groups[] = {
+	"gme",
+};
+
+static const char * const displaya_groups[] = {
+	"lcsn",
+	"ld0",
+	"ld1",
+	"ld10",
+	"ld11",
+	"ld12",
+	"ld13",
+	"ld14",
+	"ld15",
+	"ld16",
+	"ld17",
+	"ld2",
+	"ld3",
+	"ld4",
+	"ld5",
+	"ld6",
+	"ld7",
+	"ld8",
+	"ld9",
+	"ldc",
+	"ldi",
+	"lhp0",
+	"lhp1",
+	"lhp2",
+	"lhs",
+	"lm0",
+	"lm1",
+	"lpp",
+	"lpw0",
+	"lpw1",
+	"lpw2",
+	"lsc0",
+	"lsc1",
+	"lsck",
+	"lsda",
+	"lsdi",
+	"lspi",
+	"lvp0",
+	"lvp1",
+	"lvs",
+};
+
+static const char * const displayb_groups[] = {
+	"lcsn",
+	"ld0",
+	"ld1",
+	"ld10",
+	"ld11",
+	"ld12",
+	"ld13",
+	"ld14",
+	"ld15",
+	"ld16",
+	"ld17",
+	"ld2",
+	"ld3",
+	"ld4",
+	"ld5",
+	"ld6",
+	"ld7",
+	"ld8",
+	"ld9",
+	"ldc",
+	"ldi",
+	"lhp0",
+	"lhp1",
+	"lhp2",
+	"lhs",
+	"lm0",
+	"lm1",
+	"lpp",
+	"lpw0",
+	"lpw1",
+	"lpw2",
+	"lsc0",
+	"lsc1",
+	"lsck",
+	"lsda",
+	"lsdi",
+	"lspi",
+	"lvp0",
+	"lvp1",
+	"lvs",
+};
+
+static const char * const emc_test0_dll_groups[] = {
+	"kbca",
+};
+
+static const char * const emc_test1_dll_groups[] = {
+	"kbcc",
+};
+
+static const char * const gmi_groups[] = {
+	"ata",
+	"atb",
+	"atc",
+	"atd",
+	"ate",
+	"dap1",
+	"dap2",
+	"dap4",
+	"gma",
+	"gmb",
+	"gmc",
+	"gmd",
+	"gme",
+	"gpu",
+	"irrx",
+	"irtx",
+	"pta",
+	"spia",
+	"spib",
+	"spic",
+	"spid",
+	"spie",
+	"uca",
+	"ucb",
+};
+
+static const char * const gmi_int_groups[] = {
+	"gmb",
+};
+
+static const char * const hdmi_groups[] = {
+	"hdint",
+	"lpw0",
+	"lpw2",
+	"lsc1",
+	"lsck",
+	"lsda",
+	"lspi",
+	"pta",
+};
+
+static const char * const i2cp_groups[] = {
+	"i2cp",
+};
+
+static const char * const i2c1_groups[] = {
+	"rm",
+	"spdi",
+	"spdo",
+	"spig",
+	"spih",
+};
+
+static const char * const i2c2_groups[] = {
+	"ddc",
+	"pta",
+};
+
+static const char * const i2c3_groups[] = {
+	"dtf",
+};
+
+static const char * const ide_groups[] = {
+	"ata",
+	"atb",
+	"atc",
+	"atd",
+	"ate",
+	"gmb",
+};
+
+static const char * const irda_groups[] = {
+	"uad",
+};
+
+static const char * const kbc_groups[] = {
+	"kbca",
+	"kbcb",
+	"kbcc",
+	"kbcd",
+	"kbce",
+	"kbcf",
+};
+
+static const char * const mio_groups[] = {
+	"kbcb",
+	"kbcd",
+	"kbcf",
+};
+
+static const char * const mipi_hs_groups[] = {
+	"uaa",
+	"uab",
+};
+
+static const char * const nand_groups[] = {
+	"ata",
+	"atb",
+	"atc",
+	"atd",
+	"ate",
+	"gmb",
+	"gmd",
+	"kbca",
+	"kbcb",
+	"kbcc",
+	"kbcd",
+	"kbce",
+	"kbcf",
+};
+
+static const char * const osc_groups[] = {
+	"cdev1",
+	"cdev2",
+};
+
+static const char * const owr_groups[] = {
+	"kbce",
+	"owc",
+	"uac",
+};
+
+static const char * const pcie_groups[] = {
+	"gpv",
+	"slxa",
+	"slxk",
+};
+
+static const char * const plla_out_groups[] = {
+	"cdev1",
+};
+
+static const char * const pllc_out1_groups[] = {
+	"csus",
+};
+
+static const char * const pllm_out1_groups[] = {
+	"cdev1",
+};
+
+static const char * const pllp_out2_groups[] = {
+	"csus",
+};
+
+static const char * const pllp_out3_groups[] = {
+	"csus",
+};
+
+static const char * const pllp_out4_groups[] = {
+	"cdev2",
+};
+
+static const char * const pwm_groups[] = {
+	"gpu",
+	"sdb",
+	"sdc",
+	"sdd",
+	"ucb",
+};
+
+static const char * const pwr_intr_groups[] = {
+	"pmc",
+};
+
+static const char * const pwr_on_groups[] = {
+	"pmc",
+};
+
+static const char * const rsvd1_groups[] = {
+	"dta",
+	"dtb",
+	"dtc",
+	"dtd",
+	"dte",
+	"gmd",
+	"gme",
+};
+
+static const char * const rsvd2_groups[] = {
+	"crtp",
+	"dap1",
+	"dap3",
+	"dap4",
+	"ddc",
+	"dtb",
+	"dtc",
+	"dte",
+	"dtf",
+	"gpu7",
+	"gpv",
+	"hdint",
+	"i2cp",
+	"owc",
+	"rm",
+	"sdio1",
+	"spdi",
+	"spdo",
+	"uac",
+	"uca",
+	"uda",
+};
+
+static const char * const rsvd3_groups[] = {
+	"crtp",
+	"dap2",
+	"dap3",
+	"ddc",
+	"gpu7",
+	"gpv",
+	"hdint",
+	"i2cp",
+	"ld17",
+	"ldc",
+	"ldi",
+	"lhp0",
+	"lhp1",
+	"lhp2",
+	"lm1",
+	"lpp",
+	"lpw1",
+	"lvp0",
+	"lvp1",
+	"owc",
+	"pmc",
+	"rm",
+	"uac",
+};
+
+static const char * const rsvd4_groups[] = {
+	"ata",
+	"ate",
+	"crtp",
+	"dap3",
+	"dap4",
+	"ddc",
+	"dta",
+	"dtc",
+	"dtd",
+	"dtf",
+	"gpu",
+	"gpu7",
+	"gpv",
+	"hdint",
+	"i2cp",
+	"kbce",
+	"lcsn",
+	"ld0",
+	"ld1",
+	"ld2",
+	"ld3",
+	"ld4",
+	"ld5",
+	"ld6",
+	"ld7",
+	"ld8",
+	"ld9",
+	"ld10",
+	"ld11",
+	"ld12",
+	"ld13",
+	"ld14",
+	"ld15",
+	"ld16",
+	"ld17",
+	"ldc",
+	"ldi",
+	"lhp0",
+	"lhp1",
+	"lhp2",
+	"lhs",
+	"lm0",
+	"lpp",
+	"lpw1",
+	"lsc0",
+	"lsdi",
+	"lvp0",
+	"lvp1",
+	"lvs",
+	"owc",
+	"pmc",
+	"pta",
+	"rm",
+	"spif",
+	"uac",
+	"uca",
+	"ucb",
+};
+
+static const char * const rtck_groups[] = {
+	"gpu7",
+};
+
+static const char * const sdio1_groups[] = {
+	"sdio1",
+};
+
+static const char * const sdio2_groups[] = {
+	"dap1",
+	"dta",
+	"dtd",
+	"kbca",
+	"kbcb",
+	"kbcd",
+	"spdi",
+	"spdo",
+};
+
+static const char * const sdio3_groups[] = {
+	"sdb",
+	"sdc",
+	"sdd",
+	"slxa",
+	"slxc",
+	"slxd",
+	"slxk",
+};
+
+static const char * const sdio4_groups[] = {
+	"atb",
+	"atc",
+	"atd",
+	"gma",
+	"gme",
+};
+
+static const char * const sflash_groups[] = {
+	"gmc",
+	"gmd",
+};
+
+static const char * const spdif_groups[] = {
+	"slxc",
+	"slxd",
+	"spdi",
+	"spdo",
+	"uad",
+};
+
+static const char * const spi1_groups[] = {
+	"dtb",
+	"dte",
+	"spia",
+	"spib",
+	"spic",
+	"spid",
+	"spie",
+	"spif",
+	"uda",
+};
+
+static const char * const spi2_groups[] = {
+	"sdb",
+	"slxa",
+	"slxc",
+	"slxd",
+	"slxk",
+	"spia",
+	"spib",
+	"spic",
+	"spid",
+	"spie",
+	"spif",
+	"spig",
+	"spih",
+	"uab",
+};
+
+static const char * const spi2_alt_groups[] = {
+	"spid",
+	"spie",
+	"spig",
+	"spih",
+};
+
+static const char * const spi3_groups[] = {
+	"gma",
+	"lcsn",
+	"lm0",
+	"lpw0",
+	"lpw2",
+	"lsc1",
+	"lsck",
+	"lsda",
+	"lsdi",
+	"sdc",
+	"sdd",
+	"spia",
+	"spib",
+	"spic",
+	"spif",
+	"spig",
+	"spih",
+	"uaa",
+};
+
+static const char * const spi4_groups[] = {
+	"gmc",
+	"irrx",
+	"irtx",
+	"slxa",
+	"slxc",
+	"slxd",
+	"slxk",
+	"uad",
+};
+
+static const char * const trace_groups[] = {
+	"kbcc",
+	"kbcf",
+};
+
+static const char * const twc_groups[] = {
+	"dap2",
+	"sdc",
+};
+
+static const char * const uarta_groups[] = {
+	"gpu",
+	"irrx",
+	"irtx",
+	"sdb",
+	"sdd",
+	"sdio1",
+	"uaa",
+	"uab",
+	"uad",
+};
+
+static const char * const uartb_groups[] = {
+	"irrx",
+	"irtx",
+};
+
+static const char * const uartc_groups[] = {
+	"uca",
+	"ucb",
+};
+
+static const char * const uartd_groups[] = {
+	"gmc",
+	"uda",
+};
+
+static const char * const uarte_groups[] = {
+	"gma",
+	"sdio1",
+};
+
+static const char * const ulpi_groups[] = {
+	"uaa",
+	"uab",
+	"uda",
+};
+
+static const char * const vi_groups[] = {
+	"dta",
+	"dtb",
+	"dtc",
+	"dtd",
+	"dte",
+	"dtf",
+};
+
+static const char * const vi_sensor_clk_groups[] = {
+	"csus",
+};
+
+static const char * const xio_groups[] = {
+	"ld0",
+	"ld1",
+	"ld10",
+	"ld11",
+	"ld12",
+	"ld13",
+	"ld14",
+	"ld15",
+	"ld16",
+	"ld2",
+	"ld3",
+	"ld4",
+	"ld5",
+	"ld6",
+	"ld7",
+	"ld8",
+	"ld9",
+	"lhs",
+	"lsc0",
+	"lspi",
+	"lvs",
+};
+
+#define FUNCTION(fname)					\
+	{						\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+	}
+
+static const struct tegra_function tegra20_functions[] = {
+	FUNCTION(ahb_clk),
+	FUNCTION(apb_clk),
+	FUNCTION(audio_sync),
+	FUNCTION(crt),
+	FUNCTION(dap1),
+	FUNCTION(dap2),
+	FUNCTION(dap3),
+	FUNCTION(dap4),
+	FUNCTION(dap5),
+	FUNCTION(displaya),
+	FUNCTION(displayb),
+	FUNCTION(emc_test0_dll),
+	FUNCTION(emc_test1_dll),
+	FUNCTION(gmi),
+	FUNCTION(gmi_int),
+	FUNCTION(hdmi),
+	FUNCTION(i2cp),
+	FUNCTION(i2c1),
+	FUNCTION(i2c2),
+	FUNCTION(i2c3),
+	FUNCTION(ide),
+	FUNCTION(irda),
+	FUNCTION(kbc),
+	FUNCTION(mio),
+	FUNCTION(mipi_hs),
+	FUNCTION(nand),
+	FUNCTION(osc),
+	FUNCTION(owr),
+	FUNCTION(pcie),
+	FUNCTION(plla_out),
+	FUNCTION(pllc_out1),
+	FUNCTION(pllm_out1),
+	FUNCTION(pllp_out2),
+	FUNCTION(pllp_out3),
+	FUNCTION(pllp_out4),
+	FUNCTION(pwm),
+	FUNCTION(pwr_intr),
+	FUNCTION(pwr_on),
+	FUNCTION(rsvd1),
+	FUNCTION(rsvd2),
+	FUNCTION(rsvd3),
+	FUNCTION(rsvd4),
+	FUNCTION(rtck),
+	FUNCTION(sdio1),
+	FUNCTION(sdio2),
+	FUNCTION(sdio3),
+	FUNCTION(sdio4),
+	FUNCTION(sflash),
+	FUNCTION(spdif),
+	FUNCTION(spi1),
+	FUNCTION(spi2),
+	FUNCTION(spi2_alt),
+	FUNCTION(spi3),
+	FUNCTION(spi4),
+	FUNCTION(trace),
+	FUNCTION(twc),
+	FUNCTION(uarta),
+	FUNCTION(uartb),
+	FUNCTION(uartc),
+	FUNCTION(uartd),
+	FUNCTION(uarte),
+	FUNCTION(ulpi),
+	FUNCTION(vi),
+	FUNCTION(vi_sensor_clk),
+	FUNCTION(xio),
+};
+
+#define TRISTATE_REG_A		0x14
+#define PIN_MUX_CTL_REG_A	0x80
+#define PULLUPDOWN_REG_A	0xa0
+#define PINGROUP_REG_A		0x868
+
+/* Pin group with mux control, and typically tri-state and pull-up/down too */
+#define MUX_PG(pg_name, f0, f1, f2, f3, f_safe,			\
+	       tri_r, tri_b, mux_r, mux_b, pupd_r, pupd_b)	\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.funcs = {					\
+			TEGRA_MUX_ ## f0,			\
+			TEGRA_MUX_ ## f1,			\
+			TEGRA_MUX_ ## f2,			\
+			TEGRA_MUX_ ## f3,			\
+		},						\
+		.func_safe = TEGRA_MUX_ ## f_safe,		\
+		.mux_reg = ((mux_r) - PIN_MUX_CTL_REG_A),	\
+		.mux_bank = 1,					\
+		.mux_bit = mux_b,				\
+		.pupd_reg = ((pupd_r) - PULLUPDOWN_REG_A),	\
+		.pupd_bank = 2,					\
+		.pupd_bit = pupd_b,				\
+		.tri_reg = ((tri_r) - TRISTATE_REG_A),		\
+		.tri_bank = 0,					\
+		.tri_bit = tri_b,				\
+		.einput_reg = -1,				\
+		.odrain_reg = -1,				\
+		.lock_reg = -1,					\
+		.ioreset_reg = -1,				\
+		.drv_reg = -1,					\
+	}
+
+/* Pin groups with only pull up and pull down control */
+#define PULL_PG(pg_name, pupd_r, pupd_b)			\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.mux_reg = -1,					\
+		.pupd_reg = ((pupd_r) - PULLUPDOWN_REG_A),	\
+		.pupd_bank = 2,					\
+		.pupd_bit = pupd_b,				\
+		.tri_reg = -1,					\
+		.einput_reg = -1,				\
+		.odrain_reg = -1,				\
+		.lock_reg = -1,					\
+		.ioreset_reg = -1,				\
+		.drv_reg = -1,					\
+	}
+
+/* Pin groups for drive strength registers (configurable version) */
+#define DRV_PG_EXT(pg_name, r, hsm_b, schmitt_b, lpmd_b,	\
+		   drvdn_b, drvup_b,				\
+		   slwr_b, slwr_w, slwf_b, slwf_w)		\
+	{							\
+		.name = "drive_" #pg_name,			\
+		.pins = drive_##pg_name##_pins,			\
+		.npins = ARRAY_SIZE(drive_##pg_name##_pins),	\
+		.mux_reg = -1,					\
+		.pupd_reg = -1,					\
+		.tri_reg = -1,					\
+		.einput_reg = -1,				\
+		.odrain_reg = -1,				\
+		.lock_reg = -1,					\
+		.ioreset_reg = -1,				\
+		.drv_reg = ((r) - PINGROUP_REG_A),		\
+		.drv_bank = 3,					\
+		.hsm_bit = hsm_b,				\
+		.schmitt_bit = schmitt_b,			\
+		.lpmd_bit = lpmd_b,				\
+		.drvdn_bit = drvdn_b,				\
+		.drvdn_width = 5,				\
+		.drvup_bit = drvup_b,				\
+		.drvup_width = 5,				\
+		.slwr_bit = slwr_b,				\
+		.slwr_width = slwr_w,				\
+		.slwf_bit = slwf_b,				\
+		.slwf_width = slwf_w,				\
+	}
+
+/* Pin groups for drive strength registers (simple version) */
+#define DRV_PG(pg_name, r) \
+	DRV_PG_EXT(pg_name, r, 2,  3,  4, 12, 20, 28, 2, 30, 2)
+
+static const struct tegra_pingroup tegra20_groups[] = {
+	/*     name,   f0,        f1,        f2,        f3,            f_safe,    tri r/b,  mux r/b,  pupd r/b */
+	MUX_PG(ata,    IDE,       NAND,      GMI,       RSVD4,         IDE,       0x14, 0,  0x80, 24, 0xa0, 0),
+	MUX_PG(atb,    IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 1,  0x80, 16, 0xa0, 2),
+	MUX_PG(atc,    IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 2,  0x80, 22, 0xa0, 4),
+	MUX_PG(atd,    IDE,       NAND,      GMI,       SDIO4,         IDE,       0x14, 3,  0x80, 20, 0xa0, 6),
+	MUX_PG(ate,    IDE,       NAND,      GMI,       RSVD4,         IDE,       0x18, 25, 0x80, 12, 0xa0, 8),
+	MUX_PG(cdev1,  OSC,       PLLA_OUT,  PLLM_OUT1, AUDIO_SYNC,    OSC,       0x14, 4,  0x88, 2,  0xa8, 0),
+	MUX_PG(cdev2,  OSC,       AHB_CLK,   APB_CLK,   PLLP_OUT4,     OSC,       0x14, 5,  0x88, 4,  0xa8, 2),
+	MUX_PG(crtp,   CRT,       RSVD2,     RSVD3,     RSVD4,         RSVD2,     0x20, 14, 0x98, 20, 0xa4, 24),
+	MUX_PG(csus,   PLLC_OUT1, PLLP_OUT2, PLLP_OUT3, VI_SENSOR_CLK, PLLC_OUT1, 0x14, 6,  0x88, 6,  0xac, 24),
+	MUX_PG(dap1,   DAP1,      RSVD2,     GMI,       SDIO2,         DAP1,      0x14, 7,  0x88, 20, 0xa0, 10),
+	MUX_PG(dap2,   DAP2,      TWC,       RSVD3,     GMI,           DAP2,      0x14, 8,  0x88, 22, 0xa0, 12),
+	MUX_PG(dap3,   DAP3,      RSVD2,     RSVD3,     RSVD4,         DAP3,      0x14, 9,  0x88, 24, 0xa0, 14),
+	MUX_PG(dap4,   DAP4,      RSVD2,     GMI,       RSVD4,         DAP4,      0x14, 10, 0x88, 26, 0xa0, 16),
+	MUX_PG(ddc,    I2C2,      RSVD2,     RSVD3,     RSVD4,         RSVD4,     0x18, 31, 0x88, 0,  0xb0, 28),
+	MUX_PG(dta,    RSVD1,     SDIO2,     VI,        RSVD4,         RSVD4,     0x14, 11, 0x84, 20, 0xa0, 18),
+	MUX_PG(dtb,    RSVD1,     RSVD2,     VI,        SPI1,          RSVD1,     0x14, 12, 0x84, 22, 0xa0, 20),
+	MUX_PG(dtc,    RSVD1,     RSVD2,     VI,        RSVD4,         RSVD1,     0x14, 13, 0x84, 26, 0xa0, 22),
+	MUX_PG(dtd,    RSVD1,     SDIO2,     VI,        RSVD4,         RSVD1,     0x14, 14, 0x84, 28, 0xa0, 24),
+	MUX_PG(dte,    RSVD1,     RSVD2,     VI,        SPI1,          RSVD1,     0x14, 15, 0x84, 30, 0xa0, 26),
+	MUX_PG(dtf,    I2C3,      RSVD2,     VI,        RSVD4,         RSVD4,     0x20, 12, 0x98, 30, 0xa0, 28),
+	MUX_PG(gma,    UARTE,     SPI3,      GMI,       SDIO4,         SPI3,      0x14, 28, 0x84, 0,  0xb0, 20),
+	MUX_PG(gmb,    IDE,       NAND,      GMI,       GMI_INT,       GMI,       0x18, 29, 0x88, 28, 0xb0, 22),
+	MUX_PG(gmc,    UARTD,     SPI4,      GMI,       SFLASH,        SPI4,      0x14, 29, 0x84, 2,  0xb0, 24),
+	MUX_PG(gmd,    RSVD1,     NAND,      GMI,       SFLASH,        GMI,       0x18, 30, 0x88, 30, 0xb0, 26),
+	MUX_PG(gme,    RSVD1,     DAP5,      GMI,       SDIO4,         GMI,       0x18, 0,  0x8c, 0,  0xa8, 24),
+	MUX_PG(gpu,    PWM,       UARTA,     GMI,       RSVD4,         RSVD4,     0x14, 16, 0x8c, 4,  0xa4, 20),
+	MUX_PG(gpu7,   RTCK,      RSVD2,     RSVD3,     RSVD4,         RTCK,      0x20, 11, 0x98, 28, 0xa4, 6),
+	MUX_PG(gpv,    PCIE,      RSVD2,     RSVD3,     RSVD4,         PCIE,      0x14, 17, 0x8c, 2,  0xa0, 30),
+	MUX_PG(hdint,  HDMI,      RSVD2,     RSVD3,     RSVD4,         HDMI,      0x1c, 23, 0x84, 4,  -1,   -1),
+	MUX_PG(i2cp,   I2CP,      RSVD2,     RSVD3,     RSVD4,         RSVD4,     0x14, 18, 0x88, 8,  0xa4, 2),
+	MUX_PG(irrx,   UARTA,     UARTB,     GMI,       SPI4,          UARTB,     0x14, 20, 0x88, 18, 0xa8, 22),
+	MUX_PG(irtx,   UARTA,     UARTB,     GMI,       SPI4,          UARTB,     0x14, 19, 0x88, 16, 0xa8, 20),
+	MUX_PG(kbca,   KBC,       NAND,      SDIO2,     EMC_TEST0_DLL, KBC,       0x14, 22, 0x88, 10, 0xa4, 8),
+	MUX_PG(kbcb,   KBC,       NAND,      SDIO2,     MIO,           KBC,       0x14, 21, 0x88, 12, 0xa4, 10),
+	MUX_PG(kbcc,   KBC,       NAND,      TRACE,     EMC_TEST1_DLL, KBC,       0x18, 26, 0x88, 14, 0xa4, 12),
+	MUX_PG(kbcd,   KBC,       NAND,      SDIO2,     MIO,           KBC,       0x20, 10, 0x98, 26, 0xa4, 14),
+	MUX_PG(kbce,   KBC,       NAND,      OWR,       RSVD4,         KBC,       0x14, 26, 0x80, 28, 0xb0, 2),
+	MUX_PG(kbcf,   KBC,       NAND,      TRACE,     MIO,           KBC,       0x14, 27, 0x80, 26, 0xb0, 0),
+	MUX_PG(lcsn,   DISPLAYA,  DISPLAYB,  SPI3,      RSVD4,         RSVD4,     0x1c, 31, 0x90, 12, -1,   -1),
+	MUX_PG(ld0,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 0,  0x94, 0,  -1,   -1),
+	MUX_PG(ld1,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 1,  0x94, 2,  -1,   -1),
+	MUX_PG(ld2,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 2,  0x94, 4,  -1,   -1),
+	MUX_PG(ld3,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 3,  0x94, 6,  -1,   -1),
+	MUX_PG(ld4,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 4,  0x94, 8,  -1,   -1),
+	MUX_PG(ld5,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 5,  0x94, 10, -1,   -1),
+	MUX_PG(ld6,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 6,  0x94, 12, -1,   -1),
+	MUX_PG(ld7,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 7,  0x94, 14, -1,   -1),
+	MUX_PG(ld8,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 8,  0x94, 16, -1,   -1),
+	MUX_PG(ld9,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 9,  0x94, 18, -1,   -1),
+	MUX_PG(ld10,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 10, 0x94, 20, -1,   -1),
+	MUX_PG(ld11,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 11, 0x94, 22, -1,   -1),
+	MUX_PG(ld12,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 12, 0x94, 24, -1,   -1),
+	MUX_PG(ld13,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 13, 0x94, 26, -1,   -1),
+	MUX_PG(ld14,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 14, 0x94, 28, -1,   -1),
+	MUX_PG(ld15,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 15, 0x94, 30, -1,   -1),
+	MUX_PG(ld16,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 16, 0x98, 0,  -1,   -1),
+	MUX_PG(ld17,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 17, 0x98, 2,  -1,   -1),
+	MUX_PG(ldc,    DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 30, 0x90, 14, -1,   -1),
+	MUX_PG(ldi,    DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x20, 6,  0x98, 16, -1,   -1),
+	MUX_PG(lhp0,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 18, 0x98, 10, -1,   -1),
+	MUX_PG(lhp1,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 19, 0x98, 4,  -1,   -1),
+	MUX_PG(lhp2,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 20, 0x98, 6,  -1,   -1),
+	MUX_PG(lhs,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x20, 7,  0x90, 22, -1,   -1),
+	MUX_PG(lm0,    DISPLAYA,  DISPLAYB,  SPI3,      RSVD4,         RSVD4,     0x1c, 24, 0x90, 26, -1,   -1),
+	MUX_PG(lm1,    DISPLAYA,  DISPLAYB,  RSVD3,     CRT,           RSVD3,     0x1c, 25, 0x90, 28, -1,   -1),
+	MUX_PG(lpp,    DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x20, 8,  0x98, 14, -1,   -1),
+	MUX_PG(lpw0,   DISPLAYA,  DISPLAYB,  SPI3,      HDMI,          DISPLAYA,  0x20, 3,  0x90, 0,  -1,   -1),
+	MUX_PG(lpw1,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x20, 4,  0x90, 2,  -1,   -1),
+	MUX_PG(lpw2,   DISPLAYA,  DISPLAYB,  SPI3,      HDMI,          DISPLAYA,  0x20, 5,  0x90, 4,  -1,   -1),
+	MUX_PG(lsc0,   DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 27, 0x90, 18, -1,   -1),
+	MUX_PG(lsc1,   DISPLAYA,  DISPLAYB,  SPI3,      HDMI,          DISPLAYA,  0x1c, 28, 0x90, 20, -1,   -1),
+	MUX_PG(lsck,   DISPLAYA,  DISPLAYB,  SPI3,      HDMI,          DISPLAYA,  0x1c, 29, 0x90, 16, -1,   -1),
+	MUX_PG(lsda,   DISPLAYA,  DISPLAYB,  SPI3,      HDMI,          DISPLAYA,  0x20, 1,  0x90, 8,  -1,   -1),
+	MUX_PG(lsdi,   DISPLAYA,  DISPLAYB,  SPI3,      RSVD4,         DISPLAYA,  0x20, 2,  0x90, 6,  -1,   -1),
+	MUX_PG(lspi,   DISPLAYA,  DISPLAYB,  XIO,       HDMI,          DISPLAYA,  0x20, 0,  0x90, 10, -1,   -1),
+	MUX_PG(lvp0,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 21, 0x90, 30, -1,   -1),
+	MUX_PG(lvp1,   DISPLAYA,  DISPLAYB,  RSVD3,     RSVD4,         RSVD4,     0x1c, 22, 0x98, 8,  -1,   -1),
+	MUX_PG(lvs,    DISPLAYA,  DISPLAYB,  XIO,       RSVD4,         RSVD4,     0x1c, 26, 0x90, 24, -1,   -1),
+	MUX_PG(owc,    OWR,       RSVD2,     RSVD3,     RSVD4,         OWR,       0x14, 31, 0x84, 8,  0xb0, 30),
+	MUX_PG(pmc,    PWR_ON,    PWR_INTR,  RSVD3,     RSVD4,         PWR_ON,    0x14, 23, 0x98, 18, -1,   -1),
+	MUX_PG(pta,    I2C2,      HDMI,      GMI,       RSVD4,         RSVD4,     0x14, 24, 0x98, 22, 0xa4, 4),
+	MUX_PG(rm,     I2C1,      RSVD2,     RSVD3,     RSVD4,         RSVD4,     0x14, 25, 0x80, 14, 0xa4, 0),
+	MUX_PG(sdb,    UARTA,     PWM,       SDIO3,     SPI2,          PWM,       0x20, 15, 0x8c, 10, -1,   -1),
+	MUX_PG(sdc,    PWM,       TWC,       SDIO3,     SPI3,          TWC,       0x18, 1,  0x8c, 12, 0xac, 28),
+	MUX_PG(sdd,    UARTA,     PWM,       SDIO3,     SPI3,          PWM,       0x18, 2,  0x8c, 14, 0xac, 30),
+	MUX_PG(sdio1,  SDIO1,     RSVD2,     UARTE,     UARTA,         RSVD2,     0x14, 30, 0x80, 30, 0xb0, 18),
+	MUX_PG(slxa,   PCIE,      SPI4,      SDIO3,     SPI2,          PCIE,      0x18, 3,  0x84, 6,  0xa4, 22),
+	MUX_PG(slxc,   SPDIF,     SPI4,      SDIO3,     SPI2,          SPI4,      0x18, 5,  0x84, 10, 0xa4, 26),
+	MUX_PG(slxd,   SPDIF,     SPI4,      SDIO3,     SPI2,          SPI4,      0x18, 6,  0x84, 12, 0xa4, 28),
+	MUX_PG(slxk,   PCIE,      SPI4,      SDIO3,     SPI2,          PCIE,      0x18, 7,  0x84, 14, 0xa4, 30),
+	MUX_PG(spdi,   SPDIF,     RSVD2,     I2C1,      SDIO2,         RSVD2,     0x18, 8,  0x8c, 8,  0xa4, 16),
+	MUX_PG(spdo,   SPDIF,     RSVD2,     I2C1,      SDIO2,         RSVD2,     0x18, 9,  0x8c, 6,  0xa4, 18),
+	MUX_PG(spia,   SPI1,      SPI2,      SPI3,      GMI,           GMI,       0x18, 10, 0x8c, 30, 0xa8, 4),
+	MUX_PG(spib,   SPI1,      SPI2,      SPI3,      GMI,           GMI,       0x18, 11, 0x8c, 28, 0xa8, 6),
+	MUX_PG(spic,   SPI1,      SPI2,      SPI3,      GMI,           GMI,       0x18, 12, 0x8c, 26, 0xa8, 8),
+	MUX_PG(spid,   SPI2,      SPI1,      SPI2_ALT,  GMI,           GMI,       0x18, 13, 0x8c, 24, 0xa8, 10),
+	MUX_PG(spie,   SPI2,      SPI1,      SPI2_ALT,  GMI,           GMI,       0x18, 14, 0x8c, 22, 0xa8, 12),
+	MUX_PG(spif,   SPI3,      SPI1,      SPI2,      RSVD4,         RSVD4,     0x18, 15, 0x8c, 20, 0xa8, 14),
+	MUX_PG(spig,   SPI3,      SPI2,      SPI2_ALT,  I2C1,          SPI2_ALT,  0x18, 16, 0x8c, 18, 0xa8, 16),
+	MUX_PG(spih,   SPI3,      SPI2,      SPI2_ALT,  I2C1,          SPI2_ALT,  0x18, 17, 0x8c, 16, 0xa8, 18),
+	MUX_PG(uaa,    SPI3,      MIPI_HS,   UARTA,     ULPI,          MIPI_HS,   0x18, 18, 0x80, 0,  0xac, 0),
+	MUX_PG(uab,    SPI2,      MIPI_HS,   UARTA,     ULPI,          MIPI_HS,   0x18, 19, 0x80, 2,  0xac, 2),
+	MUX_PG(uac,    OWR,       RSVD2,     RSVD3,     RSVD4,         RSVD4,     0x18, 20, 0x80, 4,  0xac, 4),
+	MUX_PG(uad,    IRDA,      SPDIF,     UARTA,     SPI4,          SPDIF,     0x18, 21, 0x80, 6,  0xac, 6),
+	MUX_PG(uca,    UARTC,     RSVD2,     GMI,       RSVD4,         RSVD4,     0x18, 22, 0x84, 16, 0xac, 8),
+	MUX_PG(ucb,    UARTC,     PWM,       GMI,       RSVD4,         RSVD4,     0x18, 23, 0x84, 18, 0xac, 10),
+	MUX_PG(uda,    SPI1,      RSVD2,     UARTD,     ULPI,          RSVD2,     0x20, 13, 0x80, 8,  0xb0, 16),
+	/*      pg_name, pupd_r/b */
+	PULL_PG(ck32,    0xb0, 14),
+	PULL_PG(ddrc,    0xac, 26),
+	PULL_PG(pmca,    0xb0, 4),
+	PULL_PG(pmcb,    0xb0, 6),
+	PULL_PG(pmcc,    0xb0, 8),
+	PULL_PG(pmcd,    0xb0, 10),
+	PULL_PG(pmce,    0xb0, 12),
+	PULL_PG(xm2c,    0xa8, 30),
+	PULL_PG(xm2d,    0xa8, 28),
+	PULL_PG(ls,      0xac, 20),
+	PULL_PG(lc,      0xac, 22),
+	PULL_PG(ld17_0,  0xac, 12),
+	PULL_PG(ld19_18, 0xac, 14),
+	PULL_PG(ld21_20, 0xac, 16),
+	PULL_PG(ld23_22, 0xac, 18),
+	/*     pg_name,    r */
+	DRV_PG(ao1,        0x868),
+	DRV_PG(ao2,        0x86c),
+	DRV_PG(at1,        0x870),
+	DRV_PG(at2,        0x874),
+	DRV_PG(cdev1,      0x878),
+	DRV_PG(cdev2,      0x87c),
+	DRV_PG(csus,       0x880),
+	DRV_PG(dap1,       0x884),
+	DRV_PG(dap2,       0x888),
+	DRV_PG(dap3,       0x88c),
+	DRV_PG(dap4,       0x890),
+	DRV_PG(dbg,        0x894),
+	DRV_PG(lcd1,       0x898),
+	DRV_PG(lcd2,       0x89c),
+	DRV_PG(sdmmc2,     0x8a0),
+	DRV_PG(sdmmc3,     0x8a4),
+	DRV_PG(spi,        0x8a8),
+	DRV_PG(uaa,        0x8ac),
+	DRV_PG(uab,        0x8b0),
+	DRV_PG(uart2,      0x8b4),
+	DRV_PG(uart3,      0x8b8),
+	DRV_PG(vi1,        0x8bc),
+	DRV_PG(vi2,        0x8c0),
+	/*         pg_name, r, hsm_b, schmitt_b, lpmd_b, drvdn_b, drvup_b, slwr_b, slwr_w, slwf_b, slwf_w */
+	DRV_PG_EXT(xm2a,   0x8c4, -1, -1,  4, 14, 19, 24, 4, 28, 4),
+	DRV_PG_EXT(xm2c,   0x8c8, -1,  3, -1, 14, 19, 24, 4, 28, 4),
+	DRV_PG_EXT(xm2d,   0x8cc, -1,  3, -1, 14, 19, 24, 4, 28, 4),
+	DRV_PG_EXT(xm2clk, 0x8d0, -1, -1, -1, 14, 19, 24, 4, 28, 4),
+	/*     pg_name,    r */
+	DRV_PG(sdio1,      0x8e0),
+	DRV_PG(crt,        0x8ec),
+	DRV_PG(ddc,        0x8f0),
+	DRV_PG(gma,        0x8f4),
+	DRV_PG(gmb,        0x8f8),
+	DRV_PG(gmc,        0x8fc),
+	DRV_PG(gmd,        0x900),
+	DRV_PG(gme,        0x904),
+	DRV_PG(owr,        0x908),
+	DRV_PG(uda,        0x90c),
+};
+
+static const struct tegra_pinctrl_soc_data tegra20_pinctrl = {
+	.ngpios = NUM_GPIOS,
+	.pins = tegra20_pins,
+	.npins = ARRAY_SIZE(tegra20_pins),
+	.functions = tegra20_functions,
+	.nfunctions = ARRAY_SIZE(tegra20_functions),
+	.groups = tegra20_groups,
+	.ngroups = ARRAY_SIZE(tegra20_groups),
+};
+
+void __devinit tegra20_pinctrl_init(const struct tegra_pinctrl_soc_data **soc)
+{
+	*soc = &tegra20_pinctrl;
+}
diff --git a/drivers/pinctrl/pinctrl-tegra30.c b/drivers/pinctrl/pinctrl-tegra30.c
new file mode 100644
index 0000000..1ea1e6a
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -0,0 +1,3726 @@
+/*
+ * Pinctrl data for the NVIDIA Tegra30 pinmux
+ *
+ * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "pinctrl-tegra.h"
+
+/*
+ * Most pins affected by the pinmux can also be GPIOs. Define these first.
+ * These must match how the GPIO driver names/numbers its pins.
+ */
+#define _GPIO(offset)				(offset)
+
+#define TEGRA_PIN_CLK_32K_OUT_PA0	_GPIO(0)
+#define TEGRA_PIN_UART3_CTS_N_PA1	_GPIO(1)
+#define TEGRA_PIN_DAP2_FS_PA2		_GPIO(2)
+#define TEGRA_PIN_DAP2_SCLK_PA3		_GPIO(3)
+#define TEGRA_PIN_DAP2_DIN_PA4		_GPIO(4)
+#define TEGRA_PIN_DAP2_DOUT_PA5		_GPIO(5)
+#define TEGRA_PIN_SDMMC3_CLK_PA6	_GPIO(6)
+#define TEGRA_PIN_SDMMC3_CMD_PA7	_GPIO(7)
+#define TEGRA_PIN_GMI_A17_PB0		_GPIO(8)
+#define TEGRA_PIN_GMI_A18_PB1		_GPIO(9)
+#define TEGRA_PIN_LCD_PWR0_PB2		_GPIO(10)
+#define TEGRA_PIN_LCD_PCLK_PB3		_GPIO(11)
+#define TEGRA_PIN_SDMMC3_DAT3_PB4	_GPIO(12)
+#define TEGRA_PIN_SDMMC3_DAT2_PB5	_GPIO(13)
+#define TEGRA_PIN_SDMMC3_DAT1_PB6	_GPIO(14)
+#define TEGRA_PIN_SDMMC3_DAT0_PB7	_GPIO(15)
+#define TEGRA_PIN_UART3_RTS_N_PC0	_GPIO(16)
+#define TEGRA_PIN_LCD_PWR1_PC1		_GPIO(17)
+#define TEGRA_PIN_UART2_TXD_PC2		_GPIO(18)
+#define TEGRA_PIN_UART2_RXD_PC3		_GPIO(19)
+#define TEGRA_PIN_GEN1_I2C_SCL_PC4	_GPIO(20)
+#define TEGRA_PIN_GEN1_I2C_SDA_PC5	_GPIO(21)
+#define TEGRA_PIN_LCD_PWR2_PC6		_GPIO(22)
+#define TEGRA_PIN_GMI_WP_N_PC7		_GPIO(23)
+#define TEGRA_PIN_SDMMC3_DAT5_PD0	_GPIO(24)
+#define TEGRA_PIN_SDMMC3_DAT4_PD1	_GPIO(25)
+#define TEGRA_PIN_LCD_DC1_PD2		_GPIO(26)
+#define TEGRA_PIN_SDMMC3_DAT6_PD3	_GPIO(27)
+#define TEGRA_PIN_SDMMC3_DAT7_PD4	_GPIO(28)
+#define TEGRA_PIN_VI_D1_PD5		_GPIO(29)
+#define TEGRA_PIN_VI_VSYNC_PD6		_GPIO(30)
+#define TEGRA_PIN_VI_HSYNC_PD7		_GPIO(31)
+#define TEGRA_PIN_LCD_D0_PE0		_GPIO(32)
+#define TEGRA_PIN_LCD_D1_PE1		_GPIO(33)
+#define TEGRA_PIN_LCD_D2_PE2		_GPIO(34)
+#define TEGRA_PIN_LCD_D3_PE3		_GPIO(35)
+#define TEGRA_PIN_LCD_D4_PE4		_GPIO(36)
+#define TEGRA_PIN_LCD_D5_PE5		_GPIO(37)
+#define TEGRA_PIN_LCD_D6_PE6		_GPIO(38)
+#define TEGRA_PIN_LCD_D7_PE7		_GPIO(39)
+#define TEGRA_PIN_LCD_D8_PF0		_GPIO(40)
+#define TEGRA_PIN_LCD_D9_PF1		_GPIO(41)
+#define TEGRA_PIN_LCD_D10_PF2		_GPIO(42)
+#define TEGRA_PIN_LCD_D11_PF3		_GPIO(43)
+#define TEGRA_PIN_LCD_D12_PF4		_GPIO(44)
+#define TEGRA_PIN_LCD_D13_PF5		_GPIO(45)
+#define TEGRA_PIN_LCD_D14_PF6		_GPIO(46)
+#define TEGRA_PIN_LCD_D15_PF7		_GPIO(47)
+#define TEGRA_PIN_GMI_AD0_PG0		_GPIO(48)
+#define TEGRA_PIN_GMI_AD1_PG1		_GPIO(49)
+#define TEGRA_PIN_GMI_AD2_PG2		_GPIO(50)
+#define TEGRA_PIN_GMI_AD3_PG3		_GPIO(51)
+#define TEGRA_PIN_GMI_AD4_PG4		_GPIO(52)
+#define TEGRA_PIN_GMI_AD5_PG5		_GPIO(53)
+#define TEGRA_PIN_GMI_AD6_PG6		_GPIO(54)
+#define TEGRA_PIN_GMI_AD7_PG7		_GPIO(55)
+#define TEGRA_PIN_GMI_AD8_PH0		_GPIO(56)
+#define TEGRA_PIN_GMI_AD9_PH1		_GPIO(57)
+#define TEGRA_PIN_GMI_AD10_PH2		_GPIO(58)
+#define TEGRA_PIN_GMI_AD11_PH3		_GPIO(59)
+#define TEGRA_PIN_GMI_AD12_PH4		_GPIO(60)
+#define TEGRA_PIN_GMI_AD13_PH5		_GPIO(61)
+#define TEGRA_PIN_GMI_AD14_PH6		_GPIO(62)
+#define TEGRA_PIN_GMI_AD15_PH7		_GPIO(63)
+#define TEGRA_PIN_GMI_WR_N_PI0		_GPIO(64)
+#define TEGRA_PIN_GMI_OE_N_PI1		_GPIO(65)
+#define TEGRA_PIN_GMI_DQS_PI2		_GPIO(66)
+#define TEGRA_PIN_GMI_CS6_N_PI3		_GPIO(67)
+#define TEGRA_PIN_GMI_RST_N_PI4		_GPIO(68)
+#define TEGRA_PIN_GMI_IORDY_PI5		_GPIO(69)
+#define TEGRA_PIN_GMI_CS7_N_PI6		_GPIO(70)
+#define TEGRA_PIN_GMI_WAIT_PI7		_GPIO(71)
+#define TEGRA_PIN_GMI_CS0_N_PJ0		_GPIO(72)
+#define TEGRA_PIN_LCD_DE_PJ1		_GPIO(73)
+#define TEGRA_PIN_GMI_CS1_N_PJ2		_GPIO(74)
+#define TEGRA_PIN_LCD_HSYNC_PJ3		_GPIO(75)
+#define TEGRA_PIN_LCD_VSYNC_PJ4		_GPIO(76)
+#define TEGRA_PIN_UART2_CTS_N_PJ5	_GPIO(77)
+#define TEGRA_PIN_UART2_RTS_N_PJ6	_GPIO(78)
+#define TEGRA_PIN_GMI_A16_PJ7		_GPIO(79)
+#define TEGRA_PIN_GMI_ADV_N_PK0		_GPIO(80)
+#define TEGRA_PIN_GMI_CLK_PK1		_GPIO(81)
+#define TEGRA_PIN_GMI_CS4_N_PK2		_GPIO(82)
+#define TEGRA_PIN_GMI_CS2_N_PK3		_GPIO(83)
+#define TEGRA_PIN_GMI_CS3_N_PK4		_GPIO(84)
+#define TEGRA_PIN_SPDIF_OUT_PK5		_GPIO(85)
+#define TEGRA_PIN_SPDIF_IN_PK6		_GPIO(86)
+#define TEGRA_PIN_GMI_A19_PK7		_GPIO(87)
+#define TEGRA_PIN_VI_D2_PL0		_GPIO(88)
+#define TEGRA_PIN_VI_D3_PL1		_GPIO(89)
+#define TEGRA_PIN_VI_D4_PL2		_GPIO(90)
+#define TEGRA_PIN_VI_D5_PL3		_GPIO(91)
+#define TEGRA_PIN_VI_D6_PL4		_GPIO(92)
+#define TEGRA_PIN_VI_D7_PL5		_GPIO(93)
+#define TEGRA_PIN_VI_D8_PL6		_GPIO(94)
+#define TEGRA_PIN_VI_D9_PL7		_GPIO(95)
+#define TEGRA_PIN_LCD_D16_PM0		_GPIO(96)
+#define TEGRA_PIN_LCD_D17_PM1		_GPIO(97)
+#define TEGRA_PIN_LCD_D18_PM2		_GPIO(98)
+#define TEGRA_PIN_LCD_D19_PM3		_GPIO(99)
+#define TEGRA_PIN_LCD_D20_PM4		_GPIO(100)
+#define TEGRA_PIN_LCD_D21_PM5		_GPIO(101)
+#define TEGRA_PIN_LCD_D22_PM6		_GPIO(102)
+#define TEGRA_PIN_LCD_D23_PM7		_GPIO(103)
+#define TEGRA_PIN_DAP1_FS_PN0		_GPIO(104)
+#define TEGRA_PIN_DAP1_DIN_PN1		_GPIO(105)
+#define TEGRA_PIN_DAP1_DOUT_PN2		_GPIO(106)
+#define TEGRA_PIN_DAP1_SCLK_PN3		_GPIO(107)
+#define TEGRA_PIN_LCD_CS0_N_PN4		_GPIO(108)
+#define TEGRA_PIN_LCD_SDOUT_PN5		_GPIO(109)
+#define TEGRA_PIN_LCD_DC0_PN6		_GPIO(110)
+#define TEGRA_PIN_HDMI_INT_PN7		_GPIO(111)
+#define TEGRA_PIN_ULPI_DATA7_PO0	_GPIO(112)
+#define TEGRA_PIN_ULPI_DATA0_PO1	_GPIO(113)
+#define TEGRA_PIN_ULPI_DATA1_PO2	_GPIO(114)
+#define TEGRA_PIN_ULPI_DATA2_PO3	_GPIO(115)
+#define TEGRA_PIN_ULPI_DATA3_PO4	_GPIO(116)
+#define TEGRA_PIN_ULPI_DATA4_PO5	_GPIO(117)
+#define TEGRA_PIN_ULPI_DATA5_PO6	_GPIO(118)
+#define TEGRA_PIN_ULPI_DATA6_PO7	_GPIO(119)
+#define TEGRA_PIN_DAP3_FS_PP0		_GPIO(120)
+#define TEGRA_PIN_DAP3_DIN_PP1		_GPIO(121)
+#define TEGRA_PIN_DAP3_DOUT_PP2		_GPIO(122)
+#define TEGRA_PIN_DAP3_SCLK_PP3		_GPIO(123)
+#define TEGRA_PIN_DAP4_FS_PP4		_GPIO(124)
+#define TEGRA_PIN_DAP4_DIN_PP5		_GPIO(125)
+#define TEGRA_PIN_DAP4_DOUT_PP6		_GPIO(126)
+#define TEGRA_PIN_DAP4_SCLK_PP7		_GPIO(127)
+#define TEGRA_PIN_KB_COL0_PQ0		_GPIO(128)
+#define TEGRA_PIN_KB_COL1_PQ1		_GPIO(129)
+#define TEGRA_PIN_KB_COL2_PQ2		_GPIO(130)
+#define TEGRA_PIN_KB_COL3_PQ3		_GPIO(131)
+#define TEGRA_PIN_KB_COL4_PQ4		_GPIO(132)
+#define TEGRA_PIN_KB_COL5_PQ5		_GPIO(133)
+#define TEGRA_PIN_KB_COL6_PQ6		_GPIO(134)
+#define TEGRA_PIN_KB_COL7_PQ7		_GPIO(135)
+#define TEGRA_PIN_KB_ROW0_PR0		_GPIO(136)
+#define TEGRA_PIN_KB_ROW1_PR1		_GPIO(137)
+#define TEGRA_PIN_KB_ROW2_PR2		_GPIO(138)
+#define TEGRA_PIN_KB_ROW3_PR3		_GPIO(139)
+#define TEGRA_PIN_KB_ROW4_PR4		_GPIO(140)
+#define TEGRA_PIN_KB_ROW5_PR5		_GPIO(141)
+#define TEGRA_PIN_KB_ROW6_PR6		_GPIO(142)
+#define TEGRA_PIN_KB_ROW7_PR7		_GPIO(143)
+#define TEGRA_PIN_KB_ROW8_PS0		_GPIO(144)
+#define TEGRA_PIN_KB_ROW9_PS1		_GPIO(145)
+#define TEGRA_PIN_KB_ROW10_PS2		_GPIO(146)
+#define TEGRA_PIN_KB_ROW11_PS3		_GPIO(147)
+#define TEGRA_PIN_KB_ROW12_PS4		_GPIO(148)
+#define TEGRA_PIN_KB_ROW13_PS5		_GPIO(149)
+#define TEGRA_PIN_KB_ROW14_PS6		_GPIO(150)
+#define TEGRA_PIN_KB_ROW15_PS7		_GPIO(151)
+#define TEGRA_PIN_VI_PCLK_PT0		_GPIO(152)
+#define TEGRA_PIN_VI_MCLK_PT1		_GPIO(153)
+#define TEGRA_PIN_VI_D10_PT2		_GPIO(154)
+#define TEGRA_PIN_VI_D11_PT3		_GPIO(155)
+#define TEGRA_PIN_VI_D0_PT4		_GPIO(156)
+#define TEGRA_PIN_GEN2_I2C_SCL_PT5	_GPIO(157)
+#define TEGRA_PIN_GEN2_I2C_SDA_PT6	_GPIO(158)
+#define TEGRA_PIN_SDMMC4_CMD_PT7	_GPIO(159)
+#define TEGRA_PIN_PU0			_GPIO(160)
+#define TEGRA_PIN_PU1			_GPIO(161)
+#define TEGRA_PIN_PU2			_GPIO(162)
+#define TEGRA_PIN_PU3			_GPIO(163)
+#define TEGRA_PIN_PU4			_GPIO(164)
+#define TEGRA_PIN_PU5			_GPIO(165)
+#define TEGRA_PIN_PU6			_GPIO(166)
+#define TEGRA_PIN_JTAG_RTCK_PU7		_GPIO(167)
+#define TEGRA_PIN_PV0			_GPIO(168)
+#define TEGRA_PIN_PV1			_GPIO(169)
+#define TEGRA_PIN_PV2			_GPIO(170)
+#define TEGRA_PIN_PV3			_GPIO(171)
+#define TEGRA_PIN_DDC_SCL_PV4		_GPIO(172)
+#define TEGRA_PIN_DDC_SDA_PV5		_GPIO(173)
+#define TEGRA_PIN_CRT_HSYNC_PV6		_GPIO(174)
+#define TEGRA_PIN_CRT_VSYNC_PV7		_GPIO(175)
+#define TEGRA_PIN_LCD_CS1_N_PW0		_GPIO(176)
+#define TEGRA_PIN_LCD_M1_PW1		_GPIO(177)
+#define TEGRA_PIN_SPI2_CS1_N_PW2	_GPIO(178)
+#define TEGRA_PIN_SPI2_CS2_N_PW3	_GPIO(179)
+#define TEGRA_PIN_CLK1_OUT_PW4		_GPIO(180)
+#define TEGRA_PIN_CLK2_OUT_PW5		_GPIO(181)
+#define TEGRA_PIN_UART3_TXD_PW6		_GPIO(182)
+#define TEGRA_PIN_UART3_RXD_PW7		_GPIO(183)
+#define TEGRA_PIN_SPI2_MOSI_PX0		_GPIO(184)
+#define TEGRA_PIN_SPI2_MISO_PX1		_GPIO(185)
+#define TEGRA_PIN_SPI2_SCK_PX2		_GPIO(186)
+#define TEGRA_PIN_SPI2_CS0_N_PX3	_GPIO(187)
+#define TEGRA_PIN_SPI1_MOSI_PX4		_GPIO(188)
+#define TEGRA_PIN_SPI1_SCK_PX5		_GPIO(189)
+#define TEGRA_PIN_SPI1_CS0_N_PX6	_GPIO(190)
+#define TEGRA_PIN_SPI1_MISO_PX7		_GPIO(191)
+#define TEGRA_PIN_ULPI_CLK_PY0		_GPIO(192)
+#define TEGRA_PIN_ULPI_DIR_PY1		_GPIO(193)
+#define TEGRA_PIN_ULPI_NXT_PY2		_GPIO(194)
+#define TEGRA_PIN_ULPI_STP_PY3		_GPIO(195)
+#define TEGRA_PIN_SDMMC1_DAT3_PY4	_GPIO(196)
+#define TEGRA_PIN_SDMMC1_DAT2_PY5	_GPIO(197)
+#define TEGRA_PIN_SDMMC1_DAT1_PY6	_GPIO(198)
+#define TEGRA_PIN_SDMMC1_DAT0_PY7	_GPIO(199)
+#define TEGRA_PIN_SDMMC1_CLK_PZ0	_GPIO(200)
+#define TEGRA_PIN_SDMMC1_CMD_PZ1	_GPIO(201)
+#define TEGRA_PIN_LCD_SDIN_PZ2		_GPIO(202)
+#define TEGRA_PIN_LCD_WR_N_PZ3		_GPIO(203)
+#define TEGRA_PIN_LCD_SCK_PZ4		_GPIO(204)
+#define TEGRA_PIN_SYS_CLK_REQ_PZ5	_GPIO(205)
+#define TEGRA_PIN_PWR_I2C_SCL_PZ6	_GPIO(206)
+#define TEGRA_PIN_PWR_I2C_SDA_PZ7	_GPIO(207)
+#define TEGRA_PIN_SDMMC4_DAT0_PAA0	_GPIO(208)
+#define TEGRA_PIN_SDMMC4_DAT1_PAA1	_GPIO(209)
+#define TEGRA_PIN_SDMMC4_DAT2_PAA2	_GPIO(210)
+#define TEGRA_PIN_SDMMC4_DAT3_PAA3	_GPIO(211)
+#define TEGRA_PIN_SDMMC4_DAT4_PAA4	_GPIO(212)
+#define TEGRA_PIN_SDMMC4_DAT5_PAA5	_GPIO(213)
+#define TEGRA_PIN_SDMMC4_DAT6_PAA6	_GPIO(214)
+#define TEGRA_PIN_SDMMC4_DAT7_PAA7	_GPIO(215)
+#define TEGRA_PIN_PBB0			_GPIO(216)
+#define TEGRA_PIN_CAM_I2C_SCL_PBB1	_GPIO(217)
+#define TEGRA_PIN_CAM_I2C_SDA_PBB2	_GPIO(218)
+#define TEGRA_PIN_PBB3			_GPIO(219)
+#define TEGRA_PIN_PBB4			_GPIO(220)
+#define TEGRA_PIN_PBB5			_GPIO(221)
+#define TEGRA_PIN_PBB6			_GPIO(222)
+#define TEGRA_PIN_PBB7			_GPIO(223)
+#define TEGRA_PIN_CAM_MCLK_PCC0		_GPIO(224)
+#define TEGRA_PIN_PCC1			_GPIO(225)
+#define TEGRA_PIN_PCC2			_GPIO(226)
+#define TEGRA_PIN_SDMMC4_RST_N_PCC3	_GPIO(227)
+#define TEGRA_PIN_SDMMC4_CLK_PCC4	_GPIO(228)
+#define TEGRA_PIN_CLK2_REQ_PCC5		_GPIO(229)
+#define TEGRA_PIN_PEX_L2_RST_N_PCC6	_GPIO(230)
+#define TEGRA_PIN_PEX_L2_CLKREQ_N_PCC7	_GPIO(231)
+#define TEGRA_PIN_PEX_L0_PRSNT_N_PDD0	_GPIO(232)
+#define TEGRA_PIN_PEX_L0_RST_N_PDD1	_GPIO(233)
+#define TEGRA_PIN_PEX_L0_CLKREQ_N_PDD2	_GPIO(234)
+#define TEGRA_PIN_PEX_WAKE_N_PDD3	_GPIO(235)
+#define TEGRA_PIN_PEX_L1_PRSNT_N_PDD4	_GPIO(236)
+#define TEGRA_PIN_PEX_L1_RST_N_PDD5	_GPIO(237)
+#define TEGRA_PIN_PEX_L1_CLKREQ_N_PDD6	_GPIO(238)
+#define TEGRA_PIN_PEX_L2_PRSNT_N_PDD7	_GPIO(239)
+#define TEGRA_PIN_CLK3_OUT_PEE0		_GPIO(240)
+#define TEGRA_PIN_CLK3_REQ_PEE1		_GPIO(241)
+#define TEGRA_PIN_CLK1_REQ_PEE2		_GPIO(242)
+#define TEGRA_PIN_HDMI_CEC_PEE3		_GPIO(243)
+#define TEGRA_PIN_PEE4			_GPIO(244)
+#define TEGRA_PIN_PEE5			_GPIO(245)
+#define TEGRA_PIN_PEE6			_GPIO(246)
+#define TEGRA_PIN_PEE7			_GPIO(247)
+
+/* All non-GPIO pins follow */
+#define NUM_GPIOS				(TEGRA_PIN_PEE7 + 1)
+#define _PIN(offset)				(NUM_GPIOS + (offset))
+
+/* Non-GPIO pins */
+#define TEGRA_PIN_CLK_32K_IN		_PIN(0)
+#define TEGRA_PIN_CORE_PWR_REQ		_PIN(1)
+#define TEGRA_PIN_CPU_PWR_REQ		_PIN(2)
+#define TEGRA_PIN_JTAG_TCK		_PIN(3)
+#define TEGRA_PIN_JTAG_TDI		_PIN(4)
+#define TEGRA_PIN_JTAG_TDO		_PIN(5)
+#define TEGRA_PIN_JTAG_TMS		_PIN(6)
+#define TEGRA_PIN_JTAG_TRST_N		_PIN(7)
+#define TEGRA_PIN_OWR			_PIN(8)
+#define TEGRA_PIN_PWR_INT_N		_PIN(9)
+#define TEGRA_PIN_SYS_RESET_N		_PIN(10)
+#define TEGRA_PIN_TEST_MODE_EN		_PIN(11)
+
+static const struct pinctrl_pin_desc tegra30_pins[] = {
+	PINCTRL_PIN(TEGRA_PIN_CLK_32K_OUT_PA0, "CLK_32K_OUT PA0"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_CTS_N_PA1, "UART3_CTS_N PA1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_FS_PA2, "DAP2_FS PA2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_SCLK_PA3, "DAP2_SCLK PA3"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DIN_PA4, "DAP2_DIN PA4"),
+	PINCTRL_PIN(TEGRA_PIN_DAP2_DOUT_PA5, "DAP2_DOUT PA5"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_CLK_PA6, "SDMMC3_CLK PA6"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_CMD_PA7, "SDMMC3_CMD PA7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_A17_PB0, "GMI_A17 PB0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_A18_PB1, "GMI_A18 PB1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR0_PB2, "LCD_PWR0 PB2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PCLK_PB3, "LCD_PCLK PB3"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT3_PB4, "SDMMC3_DAT3 PB4"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT2_PB5, "SDMMC3_DAT2 PB5"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT1_PB6, "SDMMC3_DAT1 PB6"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT0_PB7, "SDMMC3_DAT0 PB7"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_RTS_N_PC0, "UART3_RTS_N PC0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR1_PC1, "LCD_PWR1 PC1"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_TXD_PC2, "UART2_TXD PC2"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_RXD_PC3, "UART2_RXD PC3"),
+	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SCL_PC4, "GEN1_I2C_SCL PC4"),
+	PINCTRL_PIN(TEGRA_PIN_GEN1_I2C_SDA_PC5, "GEN1_I2C_SDA PC5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_PWR2_PC6, "LCD_PWR2 PC6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_WP_N_PC7, "GMI_WP_N PC7"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT5_PD0, "SDMMC3_DAT5 PD0"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT4_PD1, "SDMMC3_DAT4 PD1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DC1_PD2, "LCD_DC1 PD2"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT6_PD3, "SDMMC3_DAT6 PD3"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC3_DAT7_PD4, "SDMMC3_DAT7 PD4"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D1_PD5, "VI_D1 PD5"),
+	PINCTRL_PIN(TEGRA_PIN_VI_VSYNC_PD6, "VI_VSYNC PD6"),
+	PINCTRL_PIN(TEGRA_PIN_VI_HSYNC_PD7, "VI_HSYNC PD7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D0_PE0, "LCD_D0 PE0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D1_PE1, "LCD_D1 PE1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D2_PE2, "LCD_D2 PE2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D3_PE3, "LCD_D3 PE3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D4_PE4, "LCD_D4 PE4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D5_PE5, "LCD_D5 PE5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D6_PE6, "LCD_D6 PE6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D7_PE7, "LCD_D7 PE7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D8_PF0, "LCD_D8 PF0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D9_PF1, "LCD_D9 PF1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D10_PF2, "LCD_D10 PF2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D11_PF3, "LCD_D11 PF3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D12_PF4, "LCD_D12 PF4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D13_PF5, "LCD_D13 PF5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D14_PF6, "LCD_D14 PF6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D15_PF7, "LCD_D15 PF7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD0_PG0, "GMI_AD0 PG0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD1_PG1, "GMI_AD1 PG1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD2_PG2, "GMI_AD2 PG2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD3_PG3, "GMI_AD3 PG3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD4_PG4, "GMI_AD4 PG4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD5_PG5, "GMI_AD5 PG5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD6_PG6, "GMI_AD6 PG6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD7_PG7, "GMI_AD7 PG7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD8_PH0, "GMI_AD8 PH0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD9_PH1, "GMI_AD9 PH1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD10_PH2, "GMI_AD10 PH2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD11_PH3, "GMI_AD11 PH3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD12_PH4, "GMI_AD12 PH4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD13_PH5, "GMI_AD13 PH5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD14_PH6, "GMI_AD14 PH6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_AD15_PH7, "GMI_AD15 PH7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_WR_N_PI0, "GMI_WR_N PI0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_OE_N_PI1, "GMI_OE_N PI1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_DQS_PI2, "GMI_DQS PI2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS6_N_PI3, "GMI_CS6_N PI3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_RST_N_PI4, "GMI_RST_N PI4"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_IORDY_PI5, "GMI_IORDY PI5"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS7_N_PI6, "GMI_CS7_N PI6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_WAIT_PI7, "GMI_WAIT PI7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS0_N_PJ0, "GMI_CS0_N PJ0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DE_PJ1, "LCD_DE PJ1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS1_N_PJ2, "GMI_CS1_N PJ2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_HSYNC_PJ3, "LCD_HSYNC PJ3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_VSYNC_PJ4, "LCD_VSYNC PJ4"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_CTS_N_PJ5, "UART2_CTS_N PJ5"),
+	PINCTRL_PIN(TEGRA_PIN_UART2_RTS_N_PJ6, "UART2_RTS_N PJ6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_A16_PJ7, "GMI_A16 PJ7"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_ADV_N_PK0, "GMI_ADV_N PK0"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CLK_PK1, "GMI_CLK PK1"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS4_N_PK2, "GMI_CS4_N PK2"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS2_N_PK3, "GMI_CS2_N PK3"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_CS3_N_PK4, "GMI_CS3_N PK4"),
+	PINCTRL_PIN(TEGRA_PIN_SPDIF_OUT_PK5, "SPDIF_OUT PK5"),
+	PINCTRL_PIN(TEGRA_PIN_SPDIF_IN_PK6, "SPDIF_IN PK6"),
+	PINCTRL_PIN(TEGRA_PIN_GMI_A19_PK7, "GMI_A19 PK7"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D2_PL0, "VI_D2 PL0"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D3_PL1, "VI_D3 PL1"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D4_PL2, "VI_D4 PL2"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D5_PL3, "VI_D5 PL3"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D6_PL4, "VI_D6 PL4"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D7_PL5, "VI_D7 PL5"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D8_PL6, "VI_D8 PL6"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D9_PL7, "VI_D9 PL7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D16_PM0, "LCD_D16 PM0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D17_PM1, "LCD_D17 PM1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D18_PM2, "LCD_D18 PM2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D19_PM3, "LCD_D19 PM3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D20_PM4, "LCD_D20 PM4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D21_PM5, "LCD_D21 PM5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D22_PM6, "LCD_D22 PM6"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_D23_PM7, "LCD_D23 PM7"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_FS_PN0, "DAP1_FS PN0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_DIN_PN1, "DAP1_DIN PN1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_DOUT_PN2, "DAP1_DOUT PN2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP1_SCLK_PN3, "DAP1_SCLK PN3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_CS0_N_PN4, "LCD_CS0_N PN4"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SDOUT_PN5, "LCD_SDOUT PN5"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_DC0_PN6, "LCD_DC0 PN6"),
+	PINCTRL_PIN(TEGRA_PIN_HDMI_INT_PN7, "HDMI_INT PN7"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA7_PO0, "ULPI_DATA7 PO0"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA0_PO1, "ULPI_DATA0 PO1"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA1_PO2, "ULPI_DATA1 PO2"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA2_PO3, "ULPI_DATA2 PO3"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA3_PO4, "ULPI_DATA3 PO4"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA4_PO5, "ULPI_DATA4 PO5"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA5_PO6, "ULPI_DATA5 PO6"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DATA6_PO7, "ULPI_DATA6 PO7"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_FS_PP0, "DAP3_FS PP0"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_DIN_PP1, "DAP3_DIN PP1"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_DOUT_PP2, "DAP3_DOUT PP2"),
+	PINCTRL_PIN(TEGRA_PIN_DAP3_SCLK_PP3, "DAP3_SCLK PP3"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_FS_PP4, "DAP4_FS PP4"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_DIN_PP5, "DAP4_DIN PP5"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_DOUT_PP6, "DAP4_DOUT PP6"),
+	PINCTRL_PIN(TEGRA_PIN_DAP4_SCLK_PP7, "DAP4_SCLK PP7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL0_PQ0, "KB_COL0 PQ0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL1_PQ1, "KB_COL1 PQ1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL2_PQ2, "KB_COL2 PQ2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL3_PQ3, "KB_COL3 PQ3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL4_PQ4, "KB_COL4 PQ4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL5_PQ5, "KB_COL5 PQ5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL6_PQ6, "KB_COL6 PQ6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_COL7_PQ7, "KB_COL7 PQ7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW0_PR0, "KB_ROW0 PR0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW1_PR1, "KB_ROW1 PR1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW2_PR2, "KB_ROW2 PR2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW3_PR3, "KB_ROW3 PR3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW4_PR4, "KB_ROW4 PR4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW5_PR5, "KB_ROW5 PR5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW6_PR6, "KB_ROW6 PR6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW7_PR7, "KB_ROW7 PR7"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW8_PS0, "KB_ROW8 PS0"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW9_PS1, "KB_ROW9 PS1"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW10_PS2, "KB_ROW10 PS2"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW11_PS3, "KB_ROW11 PS3"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW12_PS4, "KB_ROW12 PS4"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW13_PS5, "KB_ROW13 PS5"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW14_PS6, "KB_ROW14 PS6"),
+	PINCTRL_PIN(TEGRA_PIN_KB_ROW15_PS7, "KB_ROW15 PS7"),
+	PINCTRL_PIN(TEGRA_PIN_VI_PCLK_PT0, "VI_PCLK PT0"),
+	PINCTRL_PIN(TEGRA_PIN_VI_MCLK_PT1, "VI_MCLK PT1"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D10_PT2, "VI_D10 PT2"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D11_PT3, "VI_D11 PT3"),
+	PINCTRL_PIN(TEGRA_PIN_VI_D0_PT4, "VI_D0 PT4"),
+	PINCTRL_PIN(TEGRA_PIN_GEN2_I2C_SCL_PT5, "GEN2_I2C_SCL PT5"),
+	PINCTRL_PIN(TEGRA_PIN_GEN2_I2C_SDA_PT6, "GEN2_I2C_SDA PT6"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_CMD_PT7, "SDMMC4_CMD PT7"),
+	PINCTRL_PIN(TEGRA_PIN_PU0, "PU0"),
+	PINCTRL_PIN(TEGRA_PIN_PU1, "PU1"),
+	PINCTRL_PIN(TEGRA_PIN_PU2, "PU2"),
+	PINCTRL_PIN(TEGRA_PIN_PU3, "PU3"),
+	PINCTRL_PIN(TEGRA_PIN_PU4, "PU4"),
+	PINCTRL_PIN(TEGRA_PIN_PU5, "PU5"),
+	PINCTRL_PIN(TEGRA_PIN_PU6, "PU6"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_RTCK_PU7, "JTAG_RTCK PU7"),
+	PINCTRL_PIN(TEGRA_PIN_PV0, "PV0"),
+	PINCTRL_PIN(TEGRA_PIN_PV1, "PV1"),
+	PINCTRL_PIN(TEGRA_PIN_PV2, "PV2"),
+	PINCTRL_PIN(TEGRA_PIN_PV3, "PV3"),
+	PINCTRL_PIN(TEGRA_PIN_DDC_SCL_PV4, "DDC_SCL PV4"),
+	PINCTRL_PIN(TEGRA_PIN_DDC_SDA_PV5, "DDC_SDA PV5"),
+	PINCTRL_PIN(TEGRA_PIN_CRT_HSYNC_PV6, "CRT_HSYNC PV6"),
+	PINCTRL_PIN(TEGRA_PIN_CRT_VSYNC_PV7, "CRT_VSYNC PV7"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_CS1_N_PW0, "LCD_CS1_N PW0"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_M1_PW1, "LCD_M1 PW1"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS1_N_PW2, "SPI2_CS1_N PW2"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS2_N_PW3, "SPI2_CS2_N PW3"),
+	PINCTRL_PIN(TEGRA_PIN_CLK1_OUT_PW4, "CLK1_OUT PW4"),
+	PINCTRL_PIN(TEGRA_PIN_CLK2_OUT_PW5, "CLK2_OUT PW5"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_TXD_PW6, "UART3_TXD PW6"),
+	PINCTRL_PIN(TEGRA_PIN_UART3_RXD_PW7, "UART3_RXD PW7"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_MOSI_PX0, "SPI2_MOSI PX0"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_MISO_PX1, "SPI2_MISO PX1"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_SCK_PX2, "SPI2_SCK PX2"),
+	PINCTRL_PIN(TEGRA_PIN_SPI2_CS0_N_PX3, "SPI2_CS0_N PX3"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_MOSI_PX4, "SPI1_MOSI PX4"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_SCK_PX5, "SPI1_SCK PX5"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_CS0_N_PX6, "SPI1_CS0_N PX6"),
+	PINCTRL_PIN(TEGRA_PIN_SPI1_MISO_PX7, "SPI1_MISO PX7"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_CLK_PY0, "ULPI_CLK PY0"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_DIR_PY1, "ULPI_DIR PY1"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_NXT_PY2, "ULPI_NXT PY2"),
+	PINCTRL_PIN(TEGRA_PIN_ULPI_STP_PY3, "ULPI_STP PY3"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_DAT3_PY4, "SDMMC1_DAT3 PY4"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_DAT2_PY5, "SDMMC1_DAT2 PY5"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_DAT1_PY6, "SDMMC1_DAT1 PY6"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_DAT0_PY7, "SDMMC1_DAT0 PY7"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_CLK_PZ0, "SDMMC1_CLK PZ0"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC1_CMD_PZ1, "SDMMC1_CMD PZ1"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SDIN_PZ2, "LCD_SDIN PZ2"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_WR_N_PZ3, "LCD_WR_N PZ3"),
+	PINCTRL_PIN(TEGRA_PIN_LCD_SCK_PZ4, "LCD_SCK PZ4"),
+	PINCTRL_PIN(TEGRA_PIN_SYS_CLK_REQ_PZ5, "SYS_CLK_REQ PZ5"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_I2C_SCL_PZ6, "PWR_I2C_SCL PZ6"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_I2C_SDA_PZ7, "PWR_I2C_SDA PZ7"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT0_PAA0, "SDMMC4_DAT0 PAA0"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT1_PAA1, "SDMMC4_DAT1 PAA1"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT2_PAA2, "SDMMC4_DAT2 PAA2"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT3_PAA3, "SDMMC4_DAT3 PAA3"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT4_PAA4, "SDMMC4_DAT4 PAA4"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT5_PAA5, "SDMMC4_DAT5 PAA5"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT6_PAA6, "SDMMC4_DAT6 PAA6"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_DAT7_PAA7, "SDMMC4_DAT7 PAA7"),
+	PINCTRL_PIN(TEGRA_PIN_PBB0, "PBB0"),
+	PINCTRL_PIN(TEGRA_PIN_CAM_I2C_SCL_PBB1, "CAM_I2C_SCL PBB1"),
+	PINCTRL_PIN(TEGRA_PIN_CAM_I2C_SDA_PBB2, "CAM_I2C_SDA PBB2"),
+	PINCTRL_PIN(TEGRA_PIN_PBB3, "PBB3"),
+	PINCTRL_PIN(TEGRA_PIN_PBB4, "PBB4"),
+	PINCTRL_PIN(TEGRA_PIN_PBB5, "PBB5"),
+	PINCTRL_PIN(TEGRA_PIN_PBB6, "PBB6"),
+	PINCTRL_PIN(TEGRA_PIN_PBB7, "PBB7"),
+	PINCTRL_PIN(TEGRA_PIN_CAM_MCLK_PCC0, "CAM_MCLK PCC0"),
+	PINCTRL_PIN(TEGRA_PIN_PCC1, "PCC1"),
+	PINCTRL_PIN(TEGRA_PIN_PCC2, "PCC2"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_RST_N_PCC3, "SDMMC4_RST_N PCC3"),
+	PINCTRL_PIN(TEGRA_PIN_SDMMC4_CLK_PCC4, "SDMMC4_CLK PCC4"),
+	PINCTRL_PIN(TEGRA_PIN_CLK2_REQ_PCC5, "CLK2_REQ PCC5"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L2_RST_N_PCC6, "PEX_L2_RST_N PCC6"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L2_CLKREQ_N_PCC7, "PEX_L2_CLKREQ_N PCC7"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L0_PRSNT_N_PDD0, "PEX_L0_PRSNT_N PDD0"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L0_RST_N_PDD1, "PEX_L0_RST_N PDD1"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L0_CLKREQ_N_PDD2, "PEX_L0_CLKREQ_N PDD2"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_WAKE_N_PDD3, "PEX_WAKE_N PDD3"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L1_PRSNT_N_PDD4, "PEX_L1_PRSNT_N PDD4"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L1_RST_N_PDD5, "PEX_L1_RST_N PDD5"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L1_CLKREQ_N_PDD6, "PEX_L1_CLKREQ_N PDD6"),
+	PINCTRL_PIN(TEGRA_PIN_PEX_L2_PRSNT_N_PDD7, "PEX_L2_PRSNT_N PDD7"),
+	PINCTRL_PIN(TEGRA_PIN_CLK3_OUT_PEE0, "CLK3_OUT PEE0"),
+	PINCTRL_PIN(TEGRA_PIN_CLK3_REQ_PEE1, "CLK3_REQ PEE1"),
+	PINCTRL_PIN(TEGRA_PIN_CLK1_REQ_PEE2, "CLK1_REQ PEE2"),
+	PINCTRL_PIN(TEGRA_PIN_HDMI_CEC_PEE3, "HDMI_CEC PEE3"),
+	PINCTRL_PIN(TEGRA_PIN_PEE4, "PEE4"),
+	PINCTRL_PIN(TEGRA_PIN_PEE5, "PEE5"),
+	PINCTRL_PIN(TEGRA_PIN_PEE6, "PEE6"),
+	PINCTRL_PIN(TEGRA_PIN_PEE7, "PEE7"),
+	PINCTRL_PIN(TEGRA_PIN_CLK_32K_IN, "CLK_32K_IN"),
+	PINCTRL_PIN(TEGRA_PIN_CORE_PWR_REQ, "CORE_PWR_REQ"),
+	PINCTRL_PIN(TEGRA_PIN_CPU_PWR_REQ, "CPU_PWR_REQ"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TCK, "JTAG_TCK"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TDI, "JTAG_TDI"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TDO, "JTAG_TDO"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TMS, "JTAG_TMS"),
+	PINCTRL_PIN(TEGRA_PIN_JTAG_TRST_N, "JTAG_TRST_N"),
+	PINCTRL_PIN(TEGRA_PIN_OWR, "OWR"),
+	PINCTRL_PIN(TEGRA_PIN_PWR_INT_N, "PWR_INT_N"),
+	PINCTRL_PIN(TEGRA_PIN_SYS_RESET_N, "SYS_RESET_N"),
+	PINCTRL_PIN(TEGRA_PIN_TEST_MODE_EN, "TEST_MODE_EN"),
+};
+
+static const unsigned clk_32k_out_pa0_pins[] = {
+	TEGRA_PIN_CLK_32K_OUT_PA0,
+};
+
+static const unsigned uart3_cts_n_pa1_pins[] = {
+	TEGRA_PIN_UART3_CTS_N_PA1,
+};
+
+static const unsigned dap2_fs_pa2_pins[] = {
+	TEGRA_PIN_DAP2_FS_PA2,
+};
+
+static const unsigned dap2_sclk_pa3_pins[] = {
+	TEGRA_PIN_DAP2_SCLK_PA3,
+};
+
+static const unsigned dap2_din_pa4_pins[] = {
+	TEGRA_PIN_DAP2_DIN_PA4,
+};
+
+static const unsigned dap2_dout_pa5_pins[] = {
+	TEGRA_PIN_DAP2_DOUT_PA5,
+};
+
+static const unsigned sdmmc3_clk_pa6_pins[] = {
+	TEGRA_PIN_SDMMC3_CLK_PA6,
+};
+
+static const unsigned sdmmc3_cmd_pa7_pins[] = {
+	TEGRA_PIN_SDMMC3_CMD_PA7,
+};
+
+static const unsigned gmi_a17_pb0_pins[] = {
+	TEGRA_PIN_GMI_A17_PB0,
+};
+
+static const unsigned gmi_a18_pb1_pins[] = {
+	TEGRA_PIN_GMI_A18_PB1,
+};
+
+static const unsigned lcd_pwr0_pb2_pins[] = {
+	TEGRA_PIN_LCD_PWR0_PB2,
+};
+
+static const unsigned lcd_pclk_pb3_pins[] = {
+	TEGRA_PIN_LCD_PCLK_PB3,
+};
+
+static const unsigned sdmmc3_dat3_pb4_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT3_PB4,
+};
+
+static const unsigned sdmmc3_dat2_pb5_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT2_PB5,
+};
+
+static const unsigned sdmmc3_dat1_pb6_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT1_PB6,
+};
+
+static const unsigned sdmmc3_dat0_pb7_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT0_PB7,
+};
+
+static const unsigned uart3_rts_n_pc0_pins[] = {
+	TEGRA_PIN_UART3_RTS_N_PC0,
+};
+
+static const unsigned lcd_pwr1_pc1_pins[] = {
+	TEGRA_PIN_LCD_PWR1_PC1,
+};
+
+static const unsigned uart2_txd_pc2_pins[] = {
+	TEGRA_PIN_UART2_TXD_PC2,
+};
+
+static const unsigned uart2_rxd_pc3_pins[] = {
+	TEGRA_PIN_UART2_RXD_PC3,
+};
+
+static const unsigned gen1_i2c_scl_pc4_pins[] = {
+	TEGRA_PIN_GEN1_I2C_SCL_PC4,
+};
+
+static const unsigned gen1_i2c_sda_pc5_pins[] = {
+	TEGRA_PIN_GEN1_I2C_SDA_PC5,
+};
+
+static const unsigned lcd_pwr2_pc6_pins[] = {
+	TEGRA_PIN_LCD_PWR2_PC6,
+};
+
+static const unsigned gmi_wp_n_pc7_pins[] = {
+	TEGRA_PIN_GMI_WP_N_PC7,
+};
+
+static const unsigned sdmmc3_dat5_pd0_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT5_PD0,
+};
+
+static const unsigned sdmmc3_dat4_pd1_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT4_PD1,
+};
+
+static const unsigned lcd_dc1_pd2_pins[] = {
+	TEGRA_PIN_LCD_DC1_PD2,
+};
+
+static const unsigned sdmmc3_dat6_pd3_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT6_PD3,
+};
+
+static const unsigned sdmmc3_dat7_pd4_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT7_PD4,
+};
+
+static const unsigned vi_d1_pd5_pins[] = {
+	TEGRA_PIN_VI_D1_PD5,
+};
+
+static const unsigned vi_vsync_pd6_pins[] = {
+	TEGRA_PIN_VI_VSYNC_PD6,
+};
+
+static const unsigned vi_hsync_pd7_pins[] = {
+	TEGRA_PIN_VI_HSYNC_PD7,
+};
+
+static const unsigned lcd_d0_pe0_pins[] = {
+	TEGRA_PIN_LCD_D0_PE0,
+};
+
+static const unsigned lcd_d1_pe1_pins[] = {
+	TEGRA_PIN_LCD_D1_PE1,
+};
+
+static const unsigned lcd_d2_pe2_pins[] = {
+	TEGRA_PIN_LCD_D2_PE2,
+};
+
+static const unsigned lcd_d3_pe3_pins[] = {
+	TEGRA_PIN_LCD_D3_PE3,
+};
+
+static const unsigned lcd_d4_pe4_pins[] = {
+	TEGRA_PIN_LCD_D4_PE4,
+};
+
+static const unsigned lcd_d5_pe5_pins[] = {
+	TEGRA_PIN_LCD_D5_PE5,
+};
+
+static const unsigned lcd_d6_pe6_pins[] = {
+	TEGRA_PIN_LCD_D6_PE6,
+};
+
+static const unsigned lcd_d7_pe7_pins[] = {
+	TEGRA_PIN_LCD_D7_PE7,
+};
+
+static const unsigned lcd_d8_pf0_pins[] = {
+	TEGRA_PIN_LCD_D8_PF0,
+};
+
+static const unsigned lcd_d9_pf1_pins[] = {
+	TEGRA_PIN_LCD_D9_PF1,
+};
+
+static const unsigned lcd_d10_pf2_pins[] = {
+	TEGRA_PIN_LCD_D10_PF2,
+};
+
+static const unsigned lcd_d11_pf3_pins[] = {
+	TEGRA_PIN_LCD_D11_PF3,
+};
+
+static const unsigned lcd_d12_pf4_pins[] = {
+	TEGRA_PIN_LCD_D12_PF4,
+};
+
+static const unsigned lcd_d13_pf5_pins[] = {
+	TEGRA_PIN_LCD_D13_PF5,
+};
+
+static const unsigned lcd_d14_pf6_pins[] = {
+	TEGRA_PIN_LCD_D14_PF6,
+};
+
+static const unsigned lcd_d15_pf7_pins[] = {
+	TEGRA_PIN_LCD_D15_PF7,
+};
+
+static const unsigned gmi_ad0_pg0_pins[] = {
+	TEGRA_PIN_GMI_AD0_PG0,
+};
+
+static const unsigned gmi_ad1_pg1_pins[] = {
+	TEGRA_PIN_GMI_AD1_PG1,
+};
+
+static const unsigned gmi_ad2_pg2_pins[] = {
+	TEGRA_PIN_GMI_AD2_PG2,
+};
+
+static const unsigned gmi_ad3_pg3_pins[] = {
+	TEGRA_PIN_GMI_AD3_PG3,
+};
+
+static const unsigned gmi_ad4_pg4_pins[] = {
+	TEGRA_PIN_GMI_AD4_PG4,
+};
+
+static const unsigned gmi_ad5_pg5_pins[] = {
+	TEGRA_PIN_GMI_AD5_PG5,
+};
+
+static const unsigned gmi_ad6_pg6_pins[] = {
+	TEGRA_PIN_GMI_AD6_PG6,
+};
+
+static const unsigned gmi_ad7_pg7_pins[] = {
+	TEGRA_PIN_GMI_AD7_PG7,
+};
+
+static const unsigned gmi_ad8_ph0_pins[] = {
+	TEGRA_PIN_GMI_AD8_PH0,
+};
+
+static const unsigned gmi_ad9_ph1_pins[] = {
+	TEGRA_PIN_GMI_AD9_PH1,
+};
+
+static const unsigned gmi_ad10_ph2_pins[] = {
+	TEGRA_PIN_GMI_AD10_PH2,
+};
+
+static const unsigned gmi_ad11_ph3_pins[] = {
+	TEGRA_PIN_GMI_AD11_PH3,
+};
+
+static const unsigned gmi_ad12_ph4_pins[] = {
+	TEGRA_PIN_GMI_AD12_PH4,
+};
+
+static const unsigned gmi_ad13_ph5_pins[] = {
+	TEGRA_PIN_GMI_AD13_PH5,
+};
+
+static const unsigned gmi_ad14_ph6_pins[] = {
+	TEGRA_PIN_GMI_AD14_PH6,
+};
+
+static const unsigned gmi_ad15_ph7_pins[] = {
+	TEGRA_PIN_GMI_AD15_PH7,
+};
+
+static const unsigned gmi_wr_n_pi0_pins[] = {
+	TEGRA_PIN_GMI_WR_N_PI0,
+};
+
+static const unsigned gmi_oe_n_pi1_pins[] = {
+	TEGRA_PIN_GMI_OE_N_PI1,
+};
+
+static const unsigned gmi_dqs_pi2_pins[] = {
+	TEGRA_PIN_GMI_DQS_PI2,
+};
+
+static const unsigned gmi_cs6_n_pi3_pins[] = {
+	TEGRA_PIN_GMI_CS6_N_PI3,
+};
+
+static const unsigned gmi_rst_n_pi4_pins[] = {
+	TEGRA_PIN_GMI_RST_N_PI4,
+};
+
+static const unsigned gmi_iordy_pi5_pins[] = {
+	TEGRA_PIN_GMI_IORDY_PI5,
+};
+
+static const unsigned gmi_cs7_n_pi6_pins[] = {
+	TEGRA_PIN_GMI_CS7_N_PI6,
+};
+
+static const unsigned gmi_wait_pi7_pins[] = {
+	TEGRA_PIN_GMI_WAIT_PI7,
+};
+
+static const unsigned gmi_cs0_n_pj0_pins[] = {
+	TEGRA_PIN_GMI_CS0_N_PJ0,
+};
+
+static const unsigned lcd_de_pj1_pins[] = {
+	TEGRA_PIN_LCD_DE_PJ1,
+};
+
+static const unsigned gmi_cs1_n_pj2_pins[] = {
+	TEGRA_PIN_GMI_CS1_N_PJ2,
+};
+
+static const unsigned lcd_hsync_pj3_pins[] = {
+	TEGRA_PIN_LCD_HSYNC_PJ3,
+};
+
+static const unsigned lcd_vsync_pj4_pins[] = {
+	TEGRA_PIN_LCD_VSYNC_PJ4,
+};
+
+static const unsigned uart2_cts_n_pj5_pins[] = {
+	TEGRA_PIN_UART2_CTS_N_PJ5,
+};
+
+static const unsigned uart2_rts_n_pj6_pins[] = {
+	TEGRA_PIN_UART2_RTS_N_PJ6,
+};
+
+static const unsigned gmi_a16_pj7_pins[] = {
+	TEGRA_PIN_GMI_A16_PJ7,
+};
+
+static const unsigned gmi_adv_n_pk0_pins[] = {
+	TEGRA_PIN_GMI_ADV_N_PK0,
+};
+
+static const unsigned gmi_clk_pk1_pins[] = {
+	TEGRA_PIN_GMI_CLK_PK1,
+};
+
+static const unsigned gmi_cs4_n_pk2_pins[] = {
+	TEGRA_PIN_GMI_CS4_N_PK2,
+};
+
+static const unsigned gmi_cs2_n_pk3_pins[] = {
+	TEGRA_PIN_GMI_CS2_N_PK3,
+};
+
+static const unsigned gmi_cs3_n_pk4_pins[] = {
+	TEGRA_PIN_GMI_CS3_N_PK4,
+};
+
+static const unsigned spdif_out_pk5_pins[] = {
+	TEGRA_PIN_SPDIF_OUT_PK5,
+};
+
+static const unsigned spdif_in_pk6_pins[] = {
+	TEGRA_PIN_SPDIF_IN_PK6,
+};
+
+static const unsigned gmi_a19_pk7_pins[] = {
+	TEGRA_PIN_GMI_A19_PK7,
+};
+
+static const unsigned vi_d2_pl0_pins[] = {
+	TEGRA_PIN_VI_D2_PL0,
+};
+
+static const unsigned vi_d3_pl1_pins[] = {
+	TEGRA_PIN_VI_D3_PL1,
+};
+
+static const unsigned vi_d4_pl2_pins[] = {
+	TEGRA_PIN_VI_D4_PL2,
+};
+
+static const unsigned vi_d5_pl3_pins[] = {
+	TEGRA_PIN_VI_D5_PL3,
+};
+
+static const unsigned vi_d6_pl4_pins[] = {
+	TEGRA_PIN_VI_D6_PL4,
+};
+
+static const unsigned vi_d7_pl5_pins[] = {
+	TEGRA_PIN_VI_D7_PL5,
+};
+
+static const unsigned vi_d8_pl6_pins[] = {
+	TEGRA_PIN_VI_D8_PL6,
+};
+
+static const unsigned vi_d9_pl7_pins[] = {
+	TEGRA_PIN_VI_D9_PL7,
+};
+
+static const unsigned lcd_d16_pm0_pins[] = {
+	TEGRA_PIN_LCD_D16_PM0,
+};
+
+static const unsigned lcd_d17_pm1_pins[] = {
+	TEGRA_PIN_LCD_D17_PM1,
+};
+
+static const unsigned lcd_d18_pm2_pins[] = {
+	TEGRA_PIN_LCD_D18_PM2,
+};
+
+static const unsigned lcd_d19_pm3_pins[] = {
+	TEGRA_PIN_LCD_D19_PM3,
+};
+
+static const unsigned lcd_d20_pm4_pins[] = {
+	TEGRA_PIN_LCD_D20_PM4,
+};
+
+static const unsigned lcd_d21_pm5_pins[] = {
+	TEGRA_PIN_LCD_D21_PM5,
+};
+
+static const unsigned lcd_d22_pm6_pins[] = {
+	TEGRA_PIN_LCD_D22_PM6,
+};
+
+static const unsigned lcd_d23_pm7_pins[] = {
+	TEGRA_PIN_LCD_D23_PM7,
+};
+
+static const unsigned dap1_fs_pn0_pins[] = {
+	TEGRA_PIN_DAP1_FS_PN0,
+};
+
+static const unsigned dap1_din_pn1_pins[] = {
+	TEGRA_PIN_DAP1_DIN_PN1,
+};
+
+static const unsigned dap1_dout_pn2_pins[] = {
+	TEGRA_PIN_DAP1_DOUT_PN2,
+};
+
+static const unsigned dap1_sclk_pn3_pins[] = {
+	TEGRA_PIN_DAP1_SCLK_PN3,
+};
+
+static const unsigned lcd_cs0_n_pn4_pins[] = {
+	TEGRA_PIN_LCD_CS0_N_PN4,
+};
+
+static const unsigned lcd_sdout_pn5_pins[] = {
+	TEGRA_PIN_LCD_SDOUT_PN5,
+};
+
+static const unsigned lcd_dc0_pn6_pins[] = {
+	TEGRA_PIN_LCD_DC0_PN6,
+};
+
+static const unsigned hdmi_int_pn7_pins[] = {
+	TEGRA_PIN_HDMI_INT_PN7,
+};
+
+static const unsigned ulpi_data7_po0_pins[] = {
+	TEGRA_PIN_ULPI_DATA7_PO0,
+};
+
+static const unsigned ulpi_data0_po1_pins[] = {
+	TEGRA_PIN_ULPI_DATA0_PO1,
+};
+
+static const unsigned ulpi_data1_po2_pins[] = {
+	TEGRA_PIN_ULPI_DATA1_PO2,
+};
+
+static const unsigned ulpi_data2_po3_pins[] = {
+	TEGRA_PIN_ULPI_DATA2_PO3,
+};
+
+static const unsigned ulpi_data3_po4_pins[] = {
+	TEGRA_PIN_ULPI_DATA3_PO4,
+};
+
+static const unsigned ulpi_data4_po5_pins[] = {
+	TEGRA_PIN_ULPI_DATA4_PO5,
+};
+
+static const unsigned ulpi_data5_po6_pins[] = {
+	TEGRA_PIN_ULPI_DATA5_PO6,
+};
+
+static const unsigned ulpi_data6_po7_pins[] = {
+	TEGRA_PIN_ULPI_DATA6_PO7,
+};
+
+static const unsigned dap3_fs_pp0_pins[] = {
+	TEGRA_PIN_DAP3_FS_PP0,
+};
+
+static const unsigned dap3_din_pp1_pins[] = {
+	TEGRA_PIN_DAP3_DIN_PP1,
+};
+
+static const unsigned dap3_dout_pp2_pins[] = {
+	TEGRA_PIN_DAP3_DOUT_PP2,
+};
+
+static const unsigned dap3_sclk_pp3_pins[] = {
+	TEGRA_PIN_DAP3_SCLK_PP3,
+};
+
+static const unsigned dap4_fs_pp4_pins[] = {
+	TEGRA_PIN_DAP4_FS_PP4,
+};
+
+static const unsigned dap4_din_pp5_pins[] = {
+	TEGRA_PIN_DAP4_DIN_PP5,
+};
+
+static const unsigned dap4_dout_pp6_pins[] = {
+	TEGRA_PIN_DAP4_DOUT_PP6,
+};
+
+static const unsigned dap4_sclk_pp7_pins[] = {
+	TEGRA_PIN_DAP4_SCLK_PP7,
+};
+
+static const unsigned kb_col0_pq0_pins[] = {
+	TEGRA_PIN_KB_COL0_PQ0,
+};
+
+static const unsigned kb_col1_pq1_pins[] = {
+	TEGRA_PIN_KB_COL1_PQ1,
+};
+
+static const unsigned kb_col2_pq2_pins[] = {
+	TEGRA_PIN_KB_COL2_PQ2,
+};
+
+static const unsigned kb_col3_pq3_pins[] = {
+	TEGRA_PIN_KB_COL3_PQ3,
+};
+
+static const unsigned kb_col4_pq4_pins[] = {
+	TEGRA_PIN_KB_COL4_PQ4,
+};
+
+static const unsigned kb_col5_pq5_pins[] = {
+	TEGRA_PIN_KB_COL5_PQ5,
+};
+
+static const unsigned kb_col6_pq6_pins[] = {
+	TEGRA_PIN_KB_COL6_PQ6,
+};
+
+static const unsigned kb_col7_pq7_pins[] = {
+	TEGRA_PIN_KB_COL7_PQ7,
+};
+
+static const unsigned kb_row0_pr0_pins[] = {
+	TEGRA_PIN_KB_ROW0_PR0,
+};
+
+static const unsigned kb_row1_pr1_pins[] = {
+	TEGRA_PIN_KB_ROW1_PR1,
+};
+
+static const unsigned kb_row2_pr2_pins[] = {
+	TEGRA_PIN_KB_ROW2_PR2,
+};
+
+static const unsigned kb_row3_pr3_pins[] = {
+	TEGRA_PIN_KB_ROW3_PR3,
+};
+
+static const unsigned kb_row4_pr4_pins[] = {
+	TEGRA_PIN_KB_ROW4_PR4,
+};
+
+static const unsigned kb_row5_pr5_pins[] = {
+	TEGRA_PIN_KB_ROW5_PR5,
+};
+
+static const unsigned kb_row6_pr6_pins[] = {
+	TEGRA_PIN_KB_ROW6_PR6,
+};
+
+static const unsigned kb_row7_pr7_pins[] = {
+	TEGRA_PIN_KB_ROW7_PR7,
+};
+
+static const unsigned kb_row8_ps0_pins[] = {
+	TEGRA_PIN_KB_ROW8_PS0,
+};
+
+static const unsigned kb_row9_ps1_pins[] = {
+	TEGRA_PIN_KB_ROW9_PS1,
+};
+
+static const unsigned kb_row10_ps2_pins[] = {
+	TEGRA_PIN_KB_ROW10_PS2,
+};
+
+static const unsigned kb_row11_ps3_pins[] = {
+	TEGRA_PIN_KB_ROW11_PS3,
+};
+
+static const unsigned kb_row12_ps4_pins[] = {
+	TEGRA_PIN_KB_ROW12_PS4,
+};
+
+static const unsigned kb_row13_ps5_pins[] = {
+	TEGRA_PIN_KB_ROW13_PS5,
+};
+
+static const unsigned kb_row14_ps6_pins[] = {
+	TEGRA_PIN_KB_ROW14_PS6,
+};
+
+static const unsigned kb_row15_ps7_pins[] = {
+	TEGRA_PIN_KB_ROW15_PS7,
+};
+
+static const unsigned vi_pclk_pt0_pins[] = {
+	TEGRA_PIN_VI_PCLK_PT0,
+};
+
+static const unsigned vi_mclk_pt1_pins[] = {
+	TEGRA_PIN_VI_MCLK_PT1,
+};
+
+static const unsigned vi_d10_pt2_pins[] = {
+	TEGRA_PIN_VI_D10_PT2,
+};
+
+static const unsigned vi_d11_pt3_pins[] = {
+	TEGRA_PIN_VI_D11_PT3,
+};
+
+static const unsigned vi_d0_pt4_pins[] = {
+	TEGRA_PIN_VI_D0_PT4,
+};
+
+static const unsigned gen2_i2c_scl_pt5_pins[] = {
+	TEGRA_PIN_GEN2_I2C_SCL_PT5,
+};
+
+static const unsigned gen2_i2c_sda_pt6_pins[] = {
+	TEGRA_PIN_GEN2_I2C_SDA_PT6,
+};
+
+static const unsigned sdmmc4_cmd_pt7_pins[] = {
+	TEGRA_PIN_SDMMC4_CMD_PT7,
+};
+
+static const unsigned pu0_pins[] = {
+	TEGRA_PIN_PU0,
+};
+
+static const unsigned pu1_pins[] = {
+	TEGRA_PIN_PU1,
+};
+
+static const unsigned pu2_pins[] = {
+	TEGRA_PIN_PU2,
+};
+
+static const unsigned pu3_pins[] = {
+	TEGRA_PIN_PU3,
+};
+
+static const unsigned pu4_pins[] = {
+	TEGRA_PIN_PU4,
+};
+
+static const unsigned pu5_pins[] = {
+	TEGRA_PIN_PU5,
+};
+
+static const unsigned pu6_pins[] = {
+	TEGRA_PIN_PU6,
+};
+
+static const unsigned jtag_rtck_pu7_pins[] = {
+	TEGRA_PIN_JTAG_RTCK_PU7,
+};
+
+static const unsigned pv0_pins[] = {
+	TEGRA_PIN_PV0,
+};
+
+static const unsigned pv1_pins[] = {
+	TEGRA_PIN_PV1,
+};
+
+static const unsigned pv2_pins[] = {
+	TEGRA_PIN_PV2,
+};
+
+static const unsigned pv3_pins[] = {
+	TEGRA_PIN_PV3,
+};
+
+static const unsigned ddc_scl_pv4_pins[] = {
+	TEGRA_PIN_DDC_SCL_PV4,
+};
+
+static const unsigned ddc_sda_pv5_pins[] = {
+	TEGRA_PIN_DDC_SDA_PV5,
+};
+
+static const unsigned crt_hsync_pv6_pins[] = {
+	TEGRA_PIN_CRT_HSYNC_PV6,
+};
+
+static const unsigned crt_vsync_pv7_pins[] = {
+	TEGRA_PIN_CRT_VSYNC_PV7,
+};
+
+static const unsigned lcd_cs1_n_pw0_pins[] = {
+	TEGRA_PIN_LCD_CS1_N_PW0,
+};
+
+static const unsigned lcd_m1_pw1_pins[] = {
+	TEGRA_PIN_LCD_M1_PW1,
+};
+
+static const unsigned spi2_cs1_n_pw2_pins[] = {
+	TEGRA_PIN_SPI2_CS1_N_PW2,
+};
+
+static const unsigned spi2_cs2_n_pw3_pins[] = {
+	TEGRA_PIN_SPI2_CS2_N_PW3,
+};
+
+static const unsigned clk1_out_pw4_pins[] = {
+	TEGRA_PIN_CLK1_OUT_PW4,
+};
+
+static const unsigned clk2_out_pw5_pins[] = {
+	TEGRA_PIN_CLK2_OUT_PW5,
+};
+
+static const unsigned uart3_txd_pw6_pins[] = {
+	TEGRA_PIN_UART3_TXD_PW6,
+};
+
+static const unsigned uart3_rxd_pw7_pins[] = {
+	TEGRA_PIN_UART3_RXD_PW7,
+};
+
+static const unsigned spi2_mosi_px0_pins[] = {
+	TEGRA_PIN_SPI2_MOSI_PX0,
+};
+
+static const unsigned spi2_miso_px1_pins[] = {
+	TEGRA_PIN_SPI2_MISO_PX1,
+};
+
+static const unsigned spi2_sck_px2_pins[] = {
+	TEGRA_PIN_SPI2_SCK_PX2,
+};
+
+static const unsigned spi2_cs0_n_px3_pins[] = {
+	TEGRA_PIN_SPI2_CS0_N_PX3,
+};
+
+static const unsigned spi1_mosi_px4_pins[] = {
+	TEGRA_PIN_SPI1_MOSI_PX4,
+};
+
+static const unsigned spi1_sck_px5_pins[] = {
+	TEGRA_PIN_SPI1_SCK_PX5,
+};
+
+static const unsigned spi1_cs0_n_px6_pins[] = {
+	TEGRA_PIN_SPI1_CS0_N_PX6,
+};
+
+static const unsigned spi1_miso_px7_pins[] = {
+	TEGRA_PIN_SPI1_MISO_PX7,
+};
+
+static const unsigned ulpi_clk_py0_pins[] = {
+	TEGRA_PIN_ULPI_CLK_PY0,
+};
+
+static const unsigned ulpi_dir_py1_pins[] = {
+	TEGRA_PIN_ULPI_DIR_PY1,
+};
+
+static const unsigned ulpi_nxt_py2_pins[] = {
+	TEGRA_PIN_ULPI_NXT_PY2,
+};
+
+static const unsigned ulpi_stp_py3_pins[] = {
+	TEGRA_PIN_ULPI_STP_PY3,
+};
+
+static const unsigned sdmmc1_dat3_py4_pins[] = {
+	TEGRA_PIN_SDMMC1_DAT3_PY4,
+};
+
+static const unsigned sdmmc1_dat2_py5_pins[] = {
+	TEGRA_PIN_SDMMC1_DAT2_PY5,
+};
+
+static const unsigned sdmmc1_dat1_py6_pins[] = {
+	TEGRA_PIN_SDMMC1_DAT1_PY6,
+};
+
+static const unsigned sdmmc1_dat0_py7_pins[] = {
+	TEGRA_PIN_SDMMC1_DAT0_PY7,
+};
+
+static const unsigned sdmmc1_clk_pz0_pins[] = {
+	TEGRA_PIN_SDMMC1_CLK_PZ0,
+};
+
+static const unsigned sdmmc1_cmd_pz1_pins[] = {
+	TEGRA_PIN_SDMMC1_CMD_PZ1,
+};
+
+static const unsigned lcd_sdin_pz2_pins[] = {
+	TEGRA_PIN_LCD_SDIN_PZ2,
+};
+
+static const unsigned lcd_wr_n_pz3_pins[] = {
+	TEGRA_PIN_LCD_WR_N_PZ3,
+};
+
+static const unsigned lcd_sck_pz4_pins[] = {
+	TEGRA_PIN_LCD_SCK_PZ4,
+};
+
+static const unsigned sys_clk_req_pz5_pins[] = {
+	TEGRA_PIN_SYS_CLK_REQ_PZ5,
+};
+
+static const unsigned pwr_i2c_scl_pz6_pins[] = {
+	TEGRA_PIN_PWR_I2C_SCL_PZ6,
+};
+
+static const unsigned pwr_i2c_sda_pz7_pins[] = {
+	TEGRA_PIN_PWR_I2C_SDA_PZ7,
+};
+
+static const unsigned sdmmc4_dat0_paa0_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT0_PAA0,
+};
+
+static const unsigned sdmmc4_dat1_paa1_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT1_PAA1,
+};
+
+static const unsigned sdmmc4_dat2_paa2_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT2_PAA2,
+};
+
+static const unsigned sdmmc4_dat3_paa3_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT3_PAA3,
+};
+
+static const unsigned sdmmc4_dat4_paa4_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT4_PAA4,
+};
+
+static const unsigned sdmmc4_dat5_paa5_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT5_PAA5,
+};
+
+static const unsigned sdmmc4_dat6_paa6_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT6_PAA6,
+};
+
+static const unsigned sdmmc4_dat7_paa7_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT7_PAA7,
+};
+
+static const unsigned pbb0_pins[] = {
+	TEGRA_PIN_PBB0,
+};
+
+static const unsigned cam_i2c_scl_pbb1_pins[] = {
+	TEGRA_PIN_CAM_I2C_SCL_PBB1,
+};
+
+static const unsigned cam_i2c_sda_pbb2_pins[] = {
+	TEGRA_PIN_CAM_I2C_SDA_PBB2,
+};
+
+static const unsigned pbb3_pins[] = {
+	TEGRA_PIN_PBB3,
+};
+
+static const unsigned pbb4_pins[] = {
+	TEGRA_PIN_PBB4,
+};
+
+static const unsigned pbb5_pins[] = {
+	TEGRA_PIN_PBB5,
+};
+
+static const unsigned pbb6_pins[] = {
+	TEGRA_PIN_PBB6,
+};
+
+static const unsigned pbb7_pins[] = {
+	TEGRA_PIN_PBB7,
+};
+
+static const unsigned cam_mclk_pcc0_pins[] = {
+	TEGRA_PIN_CAM_MCLK_PCC0,
+};
+
+static const unsigned pcc1_pins[] = {
+	TEGRA_PIN_PCC1,
+};
+
+static const unsigned pcc2_pins[] = {
+	TEGRA_PIN_PCC2,
+};
+
+static const unsigned sdmmc4_rst_n_pcc3_pins[] = {
+	TEGRA_PIN_SDMMC4_RST_N_PCC3,
+};
+
+static const unsigned sdmmc4_clk_pcc4_pins[] = {
+	TEGRA_PIN_SDMMC4_CLK_PCC4,
+};
+
+static const unsigned clk2_req_pcc5_pins[] = {
+	TEGRA_PIN_CLK2_REQ_PCC5,
+};
+
+static const unsigned pex_l2_rst_n_pcc6_pins[] = {
+	TEGRA_PIN_PEX_L2_RST_N_PCC6,
+};
+
+static const unsigned pex_l2_clkreq_n_pcc7_pins[] = {
+	TEGRA_PIN_PEX_L2_CLKREQ_N_PCC7,
+};
+
+static const unsigned pex_l0_prsnt_n_pdd0_pins[] = {
+	TEGRA_PIN_PEX_L0_PRSNT_N_PDD0,
+};
+
+static const unsigned pex_l0_rst_n_pdd1_pins[] = {
+	TEGRA_PIN_PEX_L0_RST_N_PDD1,
+};
+
+static const unsigned pex_l0_clkreq_n_pdd2_pins[] = {
+	TEGRA_PIN_PEX_L0_CLKREQ_N_PDD2,
+};
+
+static const unsigned pex_wake_n_pdd3_pins[] = {
+	TEGRA_PIN_PEX_WAKE_N_PDD3,
+};
+
+static const unsigned pex_l1_prsnt_n_pdd4_pins[] = {
+	TEGRA_PIN_PEX_L1_PRSNT_N_PDD4,
+};
+
+static const unsigned pex_l1_rst_n_pdd5_pins[] = {
+	TEGRA_PIN_PEX_L1_RST_N_PDD5,
+};
+
+static const unsigned pex_l1_clkreq_n_pdd6_pins[] = {
+	TEGRA_PIN_PEX_L1_CLKREQ_N_PDD6,
+};
+
+static const unsigned pex_l2_prsnt_n_pdd7_pins[] = {
+	TEGRA_PIN_PEX_L2_PRSNT_N_PDD7,
+};
+
+static const unsigned clk3_out_pee0_pins[] = {
+	TEGRA_PIN_CLK3_OUT_PEE0,
+};
+
+static const unsigned clk3_req_pee1_pins[] = {
+	TEGRA_PIN_CLK3_REQ_PEE1,
+};
+
+static const unsigned clk1_req_pee2_pins[] = {
+	TEGRA_PIN_CLK1_REQ_PEE2,
+};
+
+static const unsigned hdmi_cec_pee3_pins[] = {
+	TEGRA_PIN_HDMI_CEC_PEE3,
+};
+
+static const unsigned clk_32k_in_pins[] = {
+	TEGRA_PIN_CLK_32K_IN,
+};
+
+static const unsigned core_pwr_req_pins[] = {
+	TEGRA_PIN_CORE_PWR_REQ,
+};
+
+static const unsigned cpu_pwr_req_pins[] = {
+	TEGRA_PIN_CPU_PWR_REQ,
+};
+
+static const unsigned owr_pins[] = {
+	TEGRA_PIN_OWR,
+};
+
+static const unsigned pwr_int_n_pins[] = {
+	TEGRA_PIN_PWR_INT_N,
+};
+
+static const unsigned drive_ao1_pins[] = {
+	TEGRA_PIN_KB_ROW0_PR0,
+	TEGRA_PIN_KB_ROW1_PR1,
+	TEGRA_PIN_KB_ROW2_PR2,
+	TEGRA_PIN_KB_ROW3_PR3,
+	TEGRA_PIN_KB_ROW4_PR4,
+	TEGRA_PIN_KB_ROW5_PR5,
+	TEGRA_PIN_KB_ROW6_PR6,
+	TEGRA_PIN_KB_ROW7_PR7,
+	TEGRA_PIN_PWR_I2C_SCL_PZ6,
+	TEGRA_PIN_PWR_I2C_SDA_PZ7,
+	TEGRA_PIN_SYS_RESET_N,
+};
+
+static const unsigned drive_ao2_pins[] = {
+	TEGRA_PIN_CLK_32K_OUT_PA0,
+	TEGRA_PIN_KB_COL0_PQ0,
+	TEGRA_PIN_KB_COL1_PQ1,
+	TEGRA_PIN_KB_COL2_PQ2,
+	TEGRA_PIN_KB_COL3_PQ3,
+	TEGRA_PIN_KB_COL4_PQ4,
+	TEGRA_PIN_KB_COL5_PQ5,
+	TEGRA_PIN_KB_COL6_PQ6,
+	TEGRA_PIN_KB_COL7_PQ7,
+	TEGRA_PIN_KB_ROW8_PS0,
+	TEGRA_PIN_KB_ROW9_PS1,
+	TEGRA_PIN_KB_ROW10_PS2,
+	TEGRA_PIN_KB_ROW11_PS3,
+	TEGRA_PIN_KB_ROW12_PS4,
+	TEGRA_PIN_KB_ROW13_PS5,
+	TEGRA_PIN_KB_ROW14_PS6,
+	TEGRA_PIN_KB_ROW15_PS7,
+	TEGRA_PIN_SYS_CLK_REQ_PZ5,
+	TEGRA_PIN_CLK_32K_IN,
+	TEGRA_PIN_CORE_PWR_REQ,
+	TEGRA_PIN_CPU_PWR_REQ,
+	TEGRA_PIN_PWR_INT_N,
+};
+
+static const unsigned drive_at1_pins[] = {
+	TEGRA_PIN_GMI_AD8_PH0,
+	TEGRA_PIN_GMI_AD9_PH1,
+	TEGRA_PIN_GMI_AD10_PH2,
+	TEGRA_PIN_GMI_AD11_PH3,
+	TEGRA_PIN_GMI_AD12_PH4,
+	TEGRA_PIN_GMI_AD13_PH5,
+	TEGRA_PIN_GMI_AD14_PH6,
+	TEGRA_PIN_GMI_AD15_PH7,
+	TEGRA_PIN_GMI_IORDY_PI5,
+	TEGRA_PIN_GMI_CS7_N_PI6,
+};
+
+static const unsigned drive_at2_pins[] = {
+	TEGRA_PIN_GMI_AD0_PG0,
+	TEGRA_PIN_GMI_AD1_PG1,
+	TEGRA_PIN_GMI_AD2_PG2,
+	TEGRA_PIN_GMI_AD3_PG3,
+	TEGRA_PIN_GMI_AD4_PG4,
+	TEGRA_PIN_GMI_AD5_PG5,
+	TEGRA_PIN_GMI_AD6_PG6,
+	TEGRA_PIN_GMI_AD7_PG7,
+	TEGRA_PIN_GMI_WR_N_PI0,
+	TEGRA_PIN_GMI_OE_N_PI1,
+	TEGRA_PIN_GMI_DQS_PI2,
+	TEGRA_PIN_GMI_CS6_N_PI3,
+	TEGRA_PIN_GMI_RST_N_PI4,
+	TEGRA_PIN_GMI_WAIT_PI7,
+	TEGRA_PIN_GMI_ADV_N_PK0,
+	TEGRA_PIN_GMI_CLK_PK1,
+	TEGRA_PIN_GMI_CS4_N_PK2,
+	TEGRA_PIN_GMI_CS2_N_PK3,
+	TEGRA_PIN_GMI_CS3_N_PK4,
+};
+
+static const unsigned drive_at3_pins[] = {
+	TEGRA_PIN_GMI_WP_N_PC7,
+	TEGRA_PIN_GMI_CS0_N_PJ0,
+};
+
+static const unsigned drive_at4_pins[] = {
+	TEGRA_PIN_GMI_A17_PB0,
+	TEGRA_PIN_GMI_A18_PB1,
+	TEGRA_PIN_GMI_CS1_N_PJ2,
+	TEGRA_PIN_GMI_A16_PJ7,
+	TEGRA_PIN_GMI_A19_PK7,
+};
+
+static const unsigned drive_at5_pins[] = {
+	TEGRA_PIN_GEN2_I2C_SCL_PT5,
+	TEGRA_PIN_GEN2_I2C_SDA_PT6,
+};
+
+static const unsigned drive_cdev1_pins[] = {
+	TEGRA_PIN_CLK1_OUT_PW4,
+	TEGRA_PIN_CLK1_REQ_PEE2,
+};
+
+static const unsigned drive_cdev2_pins[] = {
+	TEGRA_PIN_CLK2_OUT_PW5,
+	TEGRA_PIN_CLK2_REQ_PCC5,
+};
+
+static const unsigned drive_cec_pins[] = {
+	TEGRA_PIN_HDMI_CEC_PEE3,
+};
+
+static const unsigned drive_crt_pins[] = {
+	TEGRA_PIN_CRT_HSYNC_PV6,
+	TEGRA_PIN_CRT_VSYNC_PV7,
+};
+
+static const unsigned drive_csus_pins[] = {
+	TEGRA_PIN_VI_MCLK_PT1,
+};
+
+static const unsigned drive_dap1_pins[] = {
+	TEGRA_PIN_SPDIF_OUT_PK5,
+	TEGRA_PIN_SPDIF_IN_PK6,
+	TEGRA_PIN_DAP1_FS_PN0,
+	TEGRA_PIN_DAP1_DIN_PN1,
+	TEGRA_PIN_DAP1_DOUT_PN2,
+	TEGRA_PIN_DAP1_SCLK_PN3,
+};
+
+static const unsigned drive_dap2_pins[] = {
+	TEGRA_PIN_DAP2_FS_PA2,
+	TEGRA_PIN_DAP2_SCLK_PA3,
+	TEGRA_PIN_DAP2_DIN_PA4,
+	TEGRA_PIN_DAP2_DOUT_PA5,
+};
+
+static const unsigned drive_dap3_pins[] = {
+	TEGRA_PIN_DAP3_FS_PP0,
+	TEGRA_PIN_DAP3_DIN_PP1,
+	TEGRA_PIN_DAP3_DOUT_PP2,
+	TEGRA_PIN_DAP3_SCLK_PP3,
+};
+
+static const unsigned drive_dap4_pins[] = {
+	TEGRA_PIN_DAP4_FS_PP4,
+	TEGRA_PIN_DAP4_DIN_PP5,
+	TEGRA_PIN_DAP4_DOUT_PP6,
+	TEGRA_PIN_DAP4_SCLK_PP7,
+};
+
+static const unsigned drive_dbg_pins[] = {
+	TEGRA_PIN_GEN1_I2C_SCL_PC4,
+	TEGRA_PIN_GEN1_I2C_SDA_PC5,
+	TEGRA_PIN_PU0,
+	TEGRA_PIN_PU1,
+	TEGRA_PIN_PU2,
+	TEGRA_PIN_PU3,
+	TEGRA_PIN_PU4,
+	TEGRA_PIN_PU5,
+	TEGRA_PIN_PU6,
+	TEGRA_PIN_JTAG_RTCK_PU7,
+	TEGRA_PIN_JTAG_TCK,
+	TEGRA_PIN_JTAG_TDI,
+	TEGRA_PIN_JTAG_TDO,
+	TEGRA_PIN_JTAG_TMS,
+	TEGRA_PIN_JTAG_TRST_N,
+	TEGRA_PIN_TEST_MODE_EN,
+};
+
+static const unsigned drive_ddc_pins[] = {
+	TEGRA_PIN_DDC_SCL_PV4,
+	TEGRA_PIN_DDC_SDA_PV5,
+};
+
+static const unsigned drive_dev3_pins[] = {
+	TEGRA_PIN_CLK3_OUT_PEE0,
+	TEGRA_PIN_CLK3_REQ_PEE1,
+};
+
+static const unsigned drive_gma_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT0_PAA0,
+	TEGRA_PIN_SDMMC4_DAT1_PAA1,
+	TEGRA_PIN_SDMMC4_DAT2_PAA2,
+	TEGRA_PIN_SDMMC4_DAT3_PAA3,
+	TEGRA_PIN_SDMMC4_RST_N_PCC3,
+};
+
+static const unsigned drive_gmb_pins[] = {
+	TEGRA_PIN_SDMMC4_DAT4_PAA4,
+	TEGRA_PIN_SDMMC4_DAT5_PAA5,
+	TEGRA_PIN_SDMMC4_DAT6_PAA6,
+	TEGRA_PIN_SDMMC4_DAT7_PAA7,
+};
+
+static const unsigned drive_gmc_pins[] = {
+	TEGRA_PIN_SDMMC4_CLK_PCC4,
+};
+
+static const unsigned drive_gmd_pins[] = {
+	TEGRA_PIN_SDMMC4_CMD_PT7,
+};
+
+static const unsigned drive_gme_pins[] = {
+	TEGRA_PIN_PBB0,
+	TEGRA_PIN_CAM_I2C_SCL_PBB1,
+	TEGRA_PIN_CAM_I2C_SDA_PBB2,
+	TEGRA_PIN_PBB3,
+	TEGRA_PIN_PCC2,
+};
+
+static const unsigned drive_gmf_pins[] = {
+	TEGRA_PIN_PBB4,
+	TEGRA_PIN_PBB5,
+	TEGRA_PIN_PBB6,
+	TEGRA_PIN_PBB7,
+};
+
+static const unsigned drive_gmg_pins[] = {
+	TEGRA_PIN_CAM_MCLK_PCC0,
+};
+
+static const unsigned drive_gmh_pins[] = {
+	TEGRA_PIN_PCC1,
+};
+
+static const unsigned drive_gpv_pins[] = {
+	TEGRA_PIN_PEX_L2_RST_N_PCC6,
+	TEGRA_PIN_PEX_L2_CLKREQ_N_PCC7,
+	TEGRA_PIN_PEX_L0_PRSNT_N_PDD0,
+	TEGRA_PIN_PEX_L0_RST_N_PDD1,
+	TEGRA_PIN_PEX_L0_CLKREQ_N_PDD2,
+	TEGRA_PIN_PEX_WAKE_N_PDD3,
+	TEGRA_PIN_PEX_L1_PRSNT_N_PDD4,
+	TEGRA_PIN_PEX_L1_RST_N_PDD5,
+	TEGRA_PIN_PEX_L1_CLKREQ_N_PDD6,
+	TEGRA_PIN_PEX_L2_PRSNT_N_PDD7,
+};
+
+static const unsigned drive_lcd1_pins[] = {
+	TEGRA_PIN_LCD_PWR1_PC1,
+	TEGRA_PIN_LCD_PWR2_PC6,
+	TEGRA_PIN_LCD_CS0_N_PN4,
+	TEGRA_PIN_LCD_SDOUT_PN5,
+	TEGRA_PIN_LCD_DC0_PN6,
+	TEGRA_PIN_LCD_SDIN_PZ2,
+	TEGRA_PIN_LCD_WR_N_PZ3,
+	TEGRA_PIN_LCD_SCK_PZ4,
+};
+
+static const unsigned drive_lcd2_pins[] = {
+	TEGRA_PIN_LCD_PWR0_PB2,
+	TEGRA_PIN_LCD_PCLK_PB3,
+	TEGRA_PIN_LCD_DC1_PD2,
+	TEGRA_PIN_LCD_D0_PE0,
+	TEGRA_PIN_LCD_D1_PE1,
+	TEGRA_PIN_LCD_D2_PE2,
+	TEGRA_PIN_LCD_D3_PE3,
+	TEGRA_PIN_LCD_D4_PE4,
+	TEGRA_PIN_LCD_D5_PE5,
+	TEGRA_PIN_LCD_D6_PE6,
+	TEGRA_PIN_LCD_D7_PE7,
+	TEGRA_PIN_LCD_D8_PF0,
+	TEGRA_PIN_LCD_D9_PF1,
+	TEGRA_PIN_LCD_D10_PF2,
+	TEGRA_PIN_LCD_D11_PF3,
+	TEGRA_PIN_LCD_D12_PF4,
+	TEGRA_PIN_LCD_D13_PF5,
+	TEGRA_PIN_LCD_D14_PF6,
+	TEGRA_PIN_LCD_D15_PF7,
+	TEGRA_PIN_LCD_DE_PJ1,
+	TEGRA_PIN_LCD_HSYNC_PJ3,
+	TEGRA_PIN_LCD_VSYNC_PJ4,
+	TEGRA_PIN_LCD_D16_PM0,
+	TEGRA_PIN_LCD_D17_PM1,
+	TEGRA_PIN_LCD_D18_PM2,
+	TEGRA_PIN_LCD_D19_PM3,
+	TEGRA_PIN_LCD_D20_PM4,
+	TEGRA_PIN_LCD_D21_PM5,
+	TEGRA_PIN_LCD_D22_PM6,
+	TEGRA_PIN_LCD_D23_PM7,
+	TEGRA_PIN_HDMI_INT_PN7,
+	TEGRA_PIN_LCD_CS1_N_PW0,
+	TEGRA_PIN_LCD_M1_PW1,
+};
+
+static const unsigned drive_owr_pins[] = {
+	TEGRA_PIN_OWR,
+};
+
+static const unsigned drive_sdio1_pins[] = {
+	TEGRA_PIN_SDMMC1_DAT3_PY4,
+	TEGRA_PIN_SDMMC1_DAT2_PY5,
+	TEGRA_PIN_SDMMC1_DAT1_PY6,
+	TEGRA_PIN_SDMMC1_DAT0_PY7,
+	TEGRA_PIN_SDMMC1_CLK_PZ0,
+	TEGRA_PIN_SDMMC1_CMD_PZ1,
+};
+
+static const unsigned drive_sdio2_pins[] = {
+	TEGRA_PIN_SDMMC3_DAT5_PD0,
+	TEGRA_PIN_SDMMC3_DAT4_PD1,
+	TEGRA_PIN_SDMMC3_DAT6_PD3,
+	TEGRA_PIN_SDMMC3_DAT7_PD4,
+};
+
+static const unsigned drive_sdio3_pins[] = {
+	TEGRA_PIN_SDMMC3_CLK_PA6,
+	TEGRA_PIN_SDMMC3_CMD_PA7,
+	TEGRA_PIN_SDMMC3_DAT3_PB4,
+	TEGRA_PIN_SDMMC3_DAT2_PB5,
+	TEGRA_PIN_SDMMC3_DAT1_PB6,
+	TEGRA_PIN_SDMMC3_DAT0_PB7,
+};
+
+static const unsigned drive_spi_pins[] = {
+	TEGRA_PIN_SPI2_CS1_N_PW2,
+	TEGRA_PIN_SPI2_CS2_N_PW3,
+	TEGRA_PIN_SPI2_MOSI_PX0,
+	TEGRA_PIN_SPI2_MISO_PX1,
+	TEGRA_PIN_SPI2_SCK_PX2,
+	TEGRA_PIN_SPI2_CS0_N_PX3,
+	TEGRA_PIN_SPI1_MOSI_PX4,
+	TEGRA_PIN_SPI1_SCK_PX5,
+	TEGRA_PIN_SPI1_CS0_N_PX6,
+	TEGRA_PIN_SPI1_MISO_PX7,
+};
+
+static const unsigned drive_uaa_pins[] = {
+	TEGRA_PIN_ULPI_DATA0_PO1,
+	TEGRA_PIN_ULPI_DATA1_PO2,
+	TEGRA_PIN_ULPI_DATA2_PO3,
+	TEGRA_PIN_ULPI_DATA3_PO4,
+};
+
+static const unsigned drive_uab_pins[] = {
+	TEGRA_PIN_ULPI_DATA7_PO0,
+	TEGRA_PIN_ULPI_DATA4_PO5,
+	TEGRA_PIN_ULPI_DATA5_PO6,
+	TEGRA_PIN_ULPI_DATA6_PO7,
+	TEGRA_PIN_PV0,
+	TEGRA_PIN_PV1,
+	TEGRA_PIN_PV2,
+	TEGRA_PIN_PV3,
+};
+
+static const unsigned drive_uart2_pins[] = {
+	TEGRA_PIN_UART2_TXD_PC2,
+	TEGRA_PIN_UART2_RXD_PC3,
+	TEGRA_PIN_UART2_CTS_N_PJ5,
+	TEGRA_PIN_UART2_RTS_N_PJ6,
+};
+
+static const unsigned drive_uart3_pins[] = {
+	TEGRA_PIN_UART3_CTS_N_PA1,
+	TEGRA_PIN_UART3_RTS_N_PC0,
+	TEGRA_PIN_UART3_TXD_PW6,
+	TEGRA_PIN_UART3_RXD_PW7,
+};
+
+static const unsigned drive_uda_pins[] = {
+	TEGRA_PIN_ULPI_CLK_PY0,
+	TEGRA_PIN_ULPI_DIR_PY1,
+	TEGRA_PIN_ULPI_NXT_PY2,
+	TEGRA_PIN_ULPI_STP_PY3,
+};
+
+static const unsigned drive_vi1_pins[] = {
+	TEGRA_PIN_VI_D1_PD5,
+	TEGRA_PIN_VI_VSYNC_PD6,
+	TEGRA_PIN_VI_HSYNC_PD7,
+	TEGRA_PIN_VI_D2_PL0,
+	TEGRA_PIN_VI_D3_PL1,
+	TEGRA_PIN_VI_D4_PL2,
+	TEGRA_PIN_VI_D5_PL3,
+	TEGRA_PIN_VI_D6_PL4,
+	TEGRA_PIN_VI_D7_PL5,
+	TEGRA_PIN_VI_D8_PL6,
+	TEGRA_PIN_VI_D9_PL7,
+	TEGRA_PIN_VI_PCLK_PT0,
+	TEGRA_PIN_VI_D10_PT2,
+	TEGRA_PIN_VI_D11_PT3,
+	TEGRA_PIN_VI_D0_PT4,
+};
+
+enum tegra_mux {
+	TEGRA_MUX_BLINK,
+	TEGRA_MUX_CEC,
+	TEGRA_MUX_CLK_12M_OUT,
+	TEGRA_MUX_CLK_32K_IN,
+	TEGRA_MUX_CORE_PWR_REQ,
+	TEGRA_MUX_CPU_PWR_REQ,
+	TEGRA_MUX_CRT,
+	TEGRA_MUX_DAP,
+	TEGRA_MUX_DDR,
+	TEGRA_MUX_DEV3,
+	TEGRA_MUX_DISPLAYA,
+	TEGRA_MUX_DISPLAYB,
+	TEGRA_MUX_DTV,
+	TEGRA_MUX_EXTPERIPH1,
+	TEGRA_MUX_EXTPERIPH2,
+	TEGRA_MUX_EXTPERIPH3,
+	TEGRA_MUX_GMI,
+	TEGRA_MUX_GMI_ALT,
+	TEGRA_MUX_HDA,
+	TEGRA_MUX_HDCP,
+	TEGRA_MUX_HDMI,
+	TEGRA_MUX_HSI,
+	TEGRA_MUX_I2C1,
+	TEGRA_MUX_I2C2,
+	TEGRA_MUX_I2C3,
+	TEGRA_MUX_I2C4,
+	TEGRA_MUX_I2CPWR,
+	TEGRA_MUX_I2S0,
+	TEGRA_MUX_I2S1,
+	TEGRA_MUX_I2S2,
+	TEGRA_MUX_I2S3,
+	TEGRA_MUX_I2S4,
+	TEGRA_MUX_INVALID,
+	TEGRA_MUX_KBC,
+	TEGRA_MUX_MIO,
+	TEGRA_MUX_NAND,
+	TEGRA_MUX_NAND_ALT,
+	TEGRA_MUX_OWR,
+	TEGRA_MUX_PCIE,
+	TEGRA_MUX_PWM0,
+	TEGRA_MUX_PWM1,
+	TEGRA_MUX_PWM2,
+	TEGRA_MUX_PWM3,
+	TEGRA_MUX_PWR_INT_N,
+	TEGRA_MUX_RSVD1,
+	TEGRA_MUX_RSVD2,
+	TEGRA_MUX_RSVD3,
+	TEGRA_MUX_RSVD4,
+	TEGRA_MUX_RTCK,
+	TEGRA_MUX_SATA,
+	TEGRA_MUX_SDMMC1,
+	TEGRA_MUX_SDMMC2,
+	TEGRA_MUX_SDMMC3,
+	TEGRA_MUX_SDMMC4,
+	TEGRA_MUX_SPDIF,
+	TEGRA_MUX_SPI1,
+	TEGRA_MUX_SPI2,
+	TEGRA_MUX_SPI2_ALT,
+	TEGRA_MUX_SPI3,
+	TEGRA_MUX_SPI4,
+	TEGRA_MUX_SPI5,
+	TEGRA_MUX_SPI6,
+	TEGRA_MUX_SYSCLK,
+	TEGRA_MUX_TEST,
+	TEGRA_MUX_TRACE,
+	TEGRA_MUX_UARTA,
+	TEGRA_MUX_UARTB,
+	TEGRA_MUX_UARTC,
+	TEGRA_MUX_UARTD,
+	TEGRA_MUX_UARTE,
+	TEGRA_MUX_ULPI,
+	TEGRA_MUX_VGP1,
+	TEGRA_MUX_VGP2,
+	TEGRA_MUX_VGP3,
+	TEGRA_MUX_VGP4,
+	TEGRA_MUX_VGP5,
+	TEGRA_MUX_VGP6,
+	TEGRA_MUX_VI,
+	TEGRA_MUX_VI_ALT1,
+	TEGRA_MUX_VI_ALT2,
+	TEGRA_MUX_VI_ALT3,
+};
+static const char * const blink_groups[] = {
+	"CLK_32K_OUT_PA0",
+};
+
+static const char * const cec_groups[] = {
+	"HDMI_CEC_PEE3",
+	"OWR",
+};
+
+static const char * const clk_12m_out_groups[] = {
+	"PV3",
+};
+
+static const char * const clk_32k_in_groups[] = {
+	"CLK_32K_IN",
+};
+
+static const char * const core_pwr_req_groups[] = {
+	"CORE_PWR_REQ",
+};
+
+static const char * const cpu_pwr_req_groups[] = {
+	"CPU_PWR_REQ",
+};
+
+static const char * const crt_groups[] = {
+	"CRT_HSYNC_PV6",
+	"CRT_VSYNC_PV7",
+};
+
+static const char * const dap_groups[] = {
+	"CLK1_REQ_PEE2",
+	"CLK2_REQ_PCC5",
+};
+
+static const char * const ddr_groups[] = {
+	"VI_D0_PT4",
+	"VI_D1_PD5",
+	"VI_D10_PT2",
+	"VI_D11_PT3",
+	"VI_D2_PL0",
+	"VI_D3_PL1",
+	"VI_D4_PL2",
+	"VI_D5_PL3",
+	"VI_D6_PL4",
+	"VI_D7_PL5",
+	"VI_D8_PL6",
+	"VI_D9_PL7",
+	"VI_HSYNC_PD7",
+	"VI_VSYNC_PD6",
+};
+
+static const char * const dev3_groups[] = {
+	"CLK3_REQ_PEE1",
+};
+
+static const char * const displaya_groups[] = {
+	"DAP3_DIN_PP1",
+	"DAP3_DOUT_PP2",
+	"DAP3_FS_PP0",
+	"DAP3_SCLK_PP3",
+	"PBB3",
+	"PBB4",
+	"PBB5",
+	"PBB6",
+	"LCD_CS0_N_PN4",
+	"LCD_CS1_N_PW0",
+	"LCD_D0_PE0",
+	"LCD_D1_PE1",
+	"LCD_D10_PF2",
+	"LCD_D11_PF3",
+	"LCD_D12_PF4",
+	"LCD_D13_PF5",
+	"LCD_D14_PF6",
+	"LCD_D15_PF7",
+	"LCD_D16_PM0",
+	"LCD_D17_PM1",
+	"LCD_D18_PM2",
+	"LCD_D19_PM3",
+	"LCD_D2_PE2",
+	"LCD_D20_PM4",
+	"LCD_D21_PM5",
+	"LCD_D22_PM6",
+	"LCD_D23_PM7",
+	"LCD_D3_PE3",
+	"LCD_D4_PE4",
+	"LCD_D5_PE5",
+	"LCD_D6_PE6",
+	"LCD_D7_PE7",
+	"LCD_D8_PF0",
+	"LCD_D9_PF1",
+	"LCD_DC0_PN6",
+	"LCD_DC1_PD2",
+	"LCD_DE_PJ1",
+	"LCD_HSYNC_PJ3",
+	"LCD_M1_PW1",
+	"LCD_PCLK_PB3",
+	"LCD_PWR0_PB2",
+	"LCD_PWR1_PC1",
+	"LCD_PWR2_PC6",
+	"LCD_SCK_PZ4",
+	"LCD_SDIN_PZ2",
+	"LCD_SDOUT_PN5",
+	"LCD_VSYNC_PJ4",
+	"LCD_WR_N_PZ3",
+};
+
+static const char * const displayb_groups[] = {
+	"DAP3_DIN_PP1",
+	"DAP3_DOUT_PP2",
+	"DAP3_FS_PP0",
+	"DAP3_SCLK_PP3",
+	"PBB3",
+	"PBB4",
+	"PBB5",
+	"PBB6",
+	"LCD_CS0_N_PN4",
+	"LCD_CS1_N_PW0",
+	"LCD_D0_PE0",
+	"LCD_D1_PE1",
+	"LCD_D10_PF2",
+	"LCD_D11_PF3",
+	"LCD_D12_PF4",
+	"LCD_D13_PF5",
+	"LCD_D14_PF6",
+	"LCD_D15_PF7",
+	"LCD_D16_PM0",
+	"LCD_D17_PM1",
+	"LCD_D18_PM2",
+	"LCD_D19_PM3",
+	"LCD_D2_PE2",
+	"LCD_D20_PM4",
+	"LCD_D21_PM5",
+	"LCD_D22_PM6",
+	"LCD_D23_PM7",
+	"LCD_D3_PE3",
+	"LCD_D4_PE4",
+	"LCD_D5_PE5",
+	"LCD_D6_PE6",
+	"LCD_D7_PE7",
+	"LCD_D8_PF0",
+	"LCD_D9_PF1",
+	"LCD_DC0_PN6",
+	"LCD_DC1_PD2",
+	"LCD_DE_PJ1",
+	"LCD_HSYNC_PJ3",
+	"LCD_M1_PW1",
+	"LCD_PCLK_PB3",
+	"LCD_PWR0_PB2",
+	"LCD_PWR1_PC1",
+	"LCD_PWR2_PC6",
+	"LCD_SCK_PZ4",
+	"LCD_SDIN_PZ2",
+	"LCD_SDOUT_PN5",
+	"LCD_VSYNC_PJ4",
+	"LCD_WR_N_PZ3",
+};
+
+static const char * const dtv_groups[] = {
+	"GMI_A17_PB0",
+	"GMI_A18_PB1",
+	"GMI_CS0_N_PJ0",
+	"GMI_CS1_N_PJ2",
+};
+
+static const char * const extperiph1_groups[] = {
+	"CLK1_OUT_PW4",
+};
+
+static const char * const extperiph2_groups[] = {
+	"CLK2_OUT_PW5",
+};
+
+static const char * const extperiph3_groups[] = {
+	"CLK3_OUT_PEE0",
+};
+
+static const char * const gmi_groups[] = {
+	"DAP1_DIN_PN1",
+	"DAP1_DOUT_PN2",
+	"DAP1_FS_PN0",
+	"DAP1_SCLK_PN3",
+	"DAP2_DIN_PA4",
+	"DAP2_DOUT_PA5",
+	"DAP2_FS_PA2",
+	"DAP2_SCLK_PA3",
+	"DAP4_DIN_PP5",
+	"DAP4_DOUT_PP6",
+	"DAP4_FS_PP4",
+	"DAP4_SCLK_PP7",
+	"GEN2_I2C_SCL_PT5",
+	"GEN2_I2C_SDA_PT6",
+	"GMI_A16_PJ7",
+	"GMI_A17_PB0",
+	"GMI_A18_PB1",
+	"GMI_A19_PK7",
+	"GMI_AD0_PG0",
+	"GMI_AD1_PG1",
+	"GMI_AD10_PH2",
+	"GMI_AD11_PH3",
+	"GMI_AD12_PH4",
+	"GMI_AD13_PH5",
+	"GMI_AD14_PH6",
+	"GMI_AD15_PH7",
+	"GMI_AD2_PG2",
+	"GMI_AD3_PG3",
+	"GMI_AD4_PG4",
+	"GMI_AD5_PG5",
+	"GMI_AD6_PG6",
+	"GMI_AD7_PG7",
+	"GMI_AD8_PH0",
+	"GMI_AD9_PH1",
+	"GMI_ADV_N_PK0",
+	"GMI_CLK_PK1",
+	"GMI_CS0_N_PJ0",
+	"GMI_CS1_N_PJ2",
+	"GMI_CS2_N_PK3",
+	"GMI_CS3_N_PK4",
+	"GMI_CS4_N_PK2",
+	"GMI_CS6_N_PI3",
+	"GMI_CS7_N_PI6",
+	"GMI_DQS_PI2",
+	"GMI_IORDY_PI5",
+	"GMI_OE_N_PI1",
+	"GMI_RST_N_PI4",
+	"GMI_WAIT_PI7",
+	"GMI_WP_N_PC7",
+	"GMI_WR_N_PI0",
+	"PU0",
+	"PU1",
+	"PU2",
+	"PU3",
+	"PU4",
+	"PU5",
+	"PU6",
+	"SDMMC4_CLK_PCC4",
+	"SDMMC4_CMD_PT7",
+	"SDMMC4_DAT0_PAA0",
+	"SDMMC4_DAT1_PAA1",
+	"SDMMC4_DAT2_PAA2",
+	"SDMMC4_DAT3_PAA3",
+	"SDMMC4_DAT4_PAA4",
+	"SDMMC4_DAT5_PAA5",
+	"SDMMC4_DAT6_PAA6",
+	"SDMMC4_DAT7_PAA7",
+	"SPI1_CS0_N_PX6",
+	"SPI1_MOSI_PX4",
+	"SPI1_SCK_PX5",
+	"SPI2_CS0_N_PX3",
+	"SPI2_MISO_PX1",
+	"SPI2_MOSI_PX0",
+	"SPI2_SCK_PX2",
+	"UART2_CTS_N_PJ5",
+	"UART2_RTS_N_PJ6",
+	"UART3_CTS_N_PA1",
+	"UART3_RTS_N_PC0",
+	"UART3_RXD_PW7",
+	"UART3_TXD_PW6",
+};
+
+static const char * const gmi_alt_groups[] = {
+	"GMI_A16_PJ7",
+	"GMI_CS3_N_PK4",
+	"GMI_CS7_N_PI6",
+	"GMI_WP_N_PC7",
+};
+
+static const char * const hda_groups[] = {
+	"CLK1_REQ_PEE2",
+	"DAP1_DIN_PN1",
+	"DAP1_DOUT_PN2",
+	"DAP1_FS_PN0",
+	"DAP1_SCLK_PN3",
+	"DAP2_DIN_PA4",
+	"DAP2_DOUT_PA5",
+	"DAP2_FS_PA2",
+	"DAP2_SCLK_PA3",
+	"PEX_L0_CLKREQ_N_PDD2",
+	"PEX_L0_PRSNT_N_PDD0",
+	"PEX_L0_RST_N_PDD1",
+	"PEX_L1_CLKREQ_N_PDD6",
+	"PEX_L1_PRSNT_N_PDD4",
+	"PEX_L1_RST_N_PDD5",
+	"PEX_L2_CLKREQ_N_PCC7",
+	"PEX_L2_PRSNT_N_PDD7",
+	"PEX_L2_RST_N_PCC6",
+	"PEX_WAKE_N_PDD3",
+	"SPDIF_IN_PK6",
+};
+
+static const char * const hdcp_groups[] = {
+	"GEN2_I2C_SCL_PT5",
+	"GEN2_I2C_SDA_PT6",
+	"LCD_PWR0_PB2",
+	"LCD_PWR2_PC6",
+	"LCD_SCK_PZ4",
+	"LCD_SDOUT_PN5",
+	"LCD_WR_N_PZ3",
+};
+
+static const char * const hdmi_groups[] = {
+	"HDMI_INT_PN7",
+};
+
+static const char * const hsi_groups[] = {
+	"ULPI_DATA0_PO1",
+	"ULPI_DATA1_PO2",
+	"ULPI_DATA2_PO3",
+	"ULPI_DATA3_PO4",
+	"ULPI_DATA4_PO5",
+	"ULPI_DATA5_PO6",
+	"ULPI_DATA6_PO7",
+	"ULPI_DATA7_PO0",
+};
+
+static const char * const i2c1_groups[] = {
+	"GEN1_I2C_SCL_PC4",
+	"GEN1_I2C_SDA_PC5",
+	"SPDIF_IN_PK6",
+	"SPDIF_OUT_PK5",
+	"SPI2_CS1_N_PW2",
+	"SPI2_CS2_N_PW3",
+};
+
+static const char * const i2c2_groups[] = {
+	"GEN2_I2C_SCL_PT5",
+	"GEN2_I2C_SDA_PT6",
+};
+
+static const char * const i2c3_groups[] = {
+	"CAM_I2C_SCL_PBB1",
+	"CAM_I2C_SDA_PBB2",
+	"SDMMC4_CMD_PT7",
+	"SDMMC4_DAT4_PAA4",
+};
+
+static const char * const i2c4_groups[] = {
+	"DDC_SCL_PV4",
+	"DDC_SDA_PV5",
+};
+
+static const char * const i2cpwr_groups[] = {
+	"PWR_I2C_SCL_PZ6",
+	"PWR_I2C_SDA_PZ7",
+};
+
+static const char * const i2s0_groups[] = {
+	"DAP1_DIN_PN1",
+	"DAP1_DOUT_PN2",
+	"DAP1_FS_PN0",
+	"DAP1_SCLK_PN3",
+};
+
+static const char * const i2s1_groups[] = {
+	"DAP2_DIN_PA4",
+	"DAP2_DOUT_PA5",
+	"DAP2_FS_PA2",
+	"DAP2_SCLK_PA3",
+};
+
+static const char * const i2s2_groups[] = {
+	"DAP3_DIN_PP1",
+	"DAP3_DOUT_PP2",
+	"DAP3_FS_PP0",
+	"DAP3_SCLK_PP3",
+};
+
+static const char * const i2s3_groups[] = {
+	"DAP4_DIN_PP5",
+	"DAP4_DOUT_PP6",
+	"DAP4_FS_PP4",
+	"DAP4_SCLK_PP7",
+};
+
+static const char * const i2s4_groups[] = {
+	"PBB0",
+	"PBB7",
+	"PCC1",
+	"PCC2",
+	"SDMMC4_DAT4_PAA4",
+	"SDMMC4_DAT5_PAA5",
+	"SDMMC4_DAT6_PAA6",
+	"SDMMC4_DAT7_PAA7",
+};
+
+static const char * const invalid_groups[] = {
+	"KB_ROW3_PR3",
+	"SDMMC4_CLK_PCC4",
+};
+
+static const char * const kbc_groups[] = {
+	"KB_COL0_PQ0",
+	"KB_COL1_PQ1",
+	"KB_COL2_PQ2",
+	"KB_COL3_PQ3",
+	"KB_COL4_PQ4",
+	"KB_COL5_PQ5",
+	"KB_COL6_PQ6",
+	"KB_COL7_PQ7",
+	"KB_ROW0_PR0",
+	"KB_ROW1_PR1",
+	"KB_ROW10_PS2",
+	"KB_ROW11_PS3",
+	"KB_ROW12_PS4",
+	"KB_ROW13_PS5",
+	"KB_ROW14_PS6",
+	"KB_ROW15_PS7",
+	"KB_ROW2_PR2",
+	"KB_ROW3_PR3",
+	"KB_ROW4_PR4",
+	"KB_ROW5_PR5",
+	"KB_ROW6_PR6",
+	"KB_ROW7_PR7",
+	"KB_ROW8_PS0",
+	"KB_ROW9_PS1",
+};
+
+static const char * const mio_groups[] = {
+	"KB_COL6_PQ6",
+	"KB_COL7_PQ7",
+	"KB_ROW10_PS2",
+	"KB_ROW11_PS3",
+	"KB_ROW12_PS4",
+	"KB_ROW13_PS5",
+	"KB_ROW14_PS6",
+	"KB_ROW15_PS7",
+	"KB_ROW6_PR6",
+	"KB_ROW7_PR7",
+	"KB_ROW8_PS0",
+	"KB_ROW9_PS1",
+};
+
+static const char * const nand_groups[] = {
+	"GMI_AD0_PG0",
+	"GMI_AD1_PG1",
+	"GMI_AD10_PH2",
+	"GMI_AD11_PH3",
+	"GMI_AD12_PH4",
+	"GMI_AD13_PH5",
+	"GMI_AD14_PH6",
+	"GMI_AD15_PH7",
+	"GMI_AD2_PG2",
+	"GMI_AD3_PG3",
+	"GMI_AD4_PG4",
+	"GMI_AD5_PG5",
+	"GMI_AD6_PG6",
+	"GMI_AD7_PG7",
+	"GMI_AD8_PH0",
+	"GMI_AD9_PH1",
+	"GMI_ADV_N_PK0",
+	"GMI_CLK_PK1",
+	"GMI_CS0_N_PJ0",
+	"GMI_CS1_N_PJ2",
+	"GMI_CS2_N_PK3",
+	"GMI_CS3_N_PK4",
+	"GMI_CS4_N_PK2",
+	"GMI_CS6_N_PI3",
+	"GMI_CS7_N_PI6",
+	"GMI_DQS_PI2",
+	"GMI_IORDY_PI5",
+	"GMI_OE_N_PI1",
+	"GMI_RST_N_PI4",
+	"GMI_WAIT_PI7",
+	"GMI_WP_N_PC7",
+	"GMI_WR_N_PI0",
+	"KB_COL0_PQ0",
+	"KB_COL1_PQ1",
+	"KB_COL2_PQ2",
+	"KB_COL3_PQ3",
+	"KB_COL4_PQ4",
+	"KB_COL5_PQ5",
+	"KB_COL6_PQ6",
+	"KB_COL7_PQ7",
+	"KB_ROW0_PR0",
+	"KB_ROW1_PR1",
+	"KB_ROW10_PS2",
+	"KB_ROW11_PS3",
+	"KB_ROW12_PS4",
+	"KB_ROW13_PS5",
+	"KB_ROW14_PS6",
+	"KB_ROW15_PS7",
+	"KB_ROW2_PR2",
+	"KB_ROW3_PR3",
+	"KB_ROW4_PR4",
+	"KB_ROW5_PR5",
+	"KB_ROW6_PR6",
+	"KB_ROW7_PR7",
+	"KB_ROW8_PS0",
+	"KB_ROW9_PS1",
+	"SDMMC4_CLK_PCC4",
+	"SDMMC4_CMD_PT7",
+};
+
+static const char * const nand_alt_groups[] = {
+	"GMI_CS6_N_PI3",
+	"GMI_CS7_N_PI6",
+	"GMI_RST_N_PI4",
+};
+
+static const char * const owr_groups[] = {
+	"PU0",
+	"PV2",
+	"KB_ROW5_PR5",
+	"OWR",
+};
+
+static const char * const pcie_groups[] = {
+	"PEX_L0_CLKREQ_N_PDD2",
+	"PEX_L0_PRSNT_N_PDD0",
+	"PEX_L0_RST_N_PDD1",
+	"PEX_L1_CLKREQ_N_PDD6",
+	"PEX_L1_PRSNT_N_PDD4",
+	"PEX_L1_RST_N_PDD5",
+	"PEX_L2_CLKREQ_N_PCC7",
+	"PEX_L2_PRSNT_N_PDD7",
+	"PEX_L2_RST_N_PCC6",
+	"PEX_WAKE_N_PDD3",
+};
+
+static const char * const pwm0_groups[] = {
+	"GMI_AD8_PH0",
+	"PU3",
+	"SDMMC3_DAT3_PB4",
+	"SDMMC3_DAT5_PD0",
+	"UART3_RTS_N_PC0",
+};
+
+static const char * const pwm1_groups[] = {
+	"GMI_AD9_PH1",
+	"PU4",
+	"SDMMC3_DAT2_PB5",
+	"SDMMC3_DAT4_PD1",
+};
+
+static const char * const pwm2_groups[] = {
+	"GMI_AD10_PH2",
+	"PU5",
+	"SDMMC3_CLK_PA6",
+};
+
+static const char * const pwm3_groups[] = {
+	"GMI_AD11_PH3",
+	"PU6",
+	"SDMMC3_CMD_PA7",
+};
+
+static const char * const pwr_int_n_groups[] = {
+	"PWR_INT_N",
+};
+
+static const char * const rsvd1_groups[] = {
+	"GMI_AD0_PG0",
+	"GMI_AD1_PG1",
+	"GMI_AD12_PH4",
+	"GMI_AD13_PH5",
+	"GMI_AD14_PH6",
+	"GMI_AD15_PH7",
+	"GMI_AD2_PG2",
+	"GMI_AD3_PG3",
+	"GMI_AD4_PG4",
+	"GMI_AD5_PG5",
+	"GMI_AD6_PG6",
+	"GMI_AD7_PG7",
+	"GMI_ADV_N_PK0",
+	"GMI_CLK_PK1",
+	"GMI_CS0_N_PJ0",
+	"GMI_CS1_N_PJ2",
+	"GMI_CS2_N_PK3",
+	"GMI_CS3_N_PK4",
+	"GMI_CS4_N_PK2",
+	"GMI_DQS_PI2",
+	"GMI_IORDY_PI5",
+	"GMI_OE_N_PI1",
+	"GMI_WAIT_PI7",
+	"GMI_WP_N_PC7",
+	"GMI_WR_N_PI0",
+	"PU1",
+	"PU2",
+	"PV0",
+	"PV1",
+	"SDMMC3_DAT0_PB7",
+	"SDMMC3_DAT1_PB6",
+	"SDMMC3_DAT2_PB5",
+	"SDMMC3_DAT3_PB4",
+	"VI_PCLK_PT0",
+};
+
+static const char * const rsvd2_groups[] = {
+	"CLK1_OUT_PW4",
+	"CLK2_OUT_PW5",
+	"CLK2_REQ_PCC5",
+	"CLK3_OUT_PEE0",
+	"CLK3_REQ_PEE1",
+	"CLK_32K_IN",
+	"CLK_32K_OUT_PA0",
+	"CORE_PWR_REQ",
+	"CPU_PWR_REQ",
+	"CRT_HSYNC_PV6",
+	"CRT_VSYNC_PV7",
+	"DAP3_DIN_PP1",
+	"DAP3_DOUT_PP2",
+	"DAP3_FS_PP0",
+	"DAP3_SCLK_PP3",
+	"DAP4_DIN_PP5",
+	"DAP4_DOUT_PP6",
+	"DAP4_FS_PP4",
+	"DAP4_SCLK_PP7",
+	"DDC_SCL_PV4",
+	"DDC_SDA_PV5",
+	"GEN1_I2C_SCL_PC4",
+	"GEN1_I2C_SDA_PC5",
+	"PBB0",
+	"PBB7",
+	"PCC1",
+	"PCC2",
+	"PV0",
+	"PV1",
+	"PV2",
+	"PV3",
+	"HDMI_CEC_PEE3",
+	"HDMI_INT_PN7",
+	"JTAG_RTCK_PU7",
+	"PWR_I2C_SCL_PZ6",
+	"PWR_I2C_SDA_PZ7",
+	"PWR_INT_N",
+	"SDMMC1_CLK_PZ0",
+	"SDMMC1_CMD_PZ1",
+	"SDMMC1_DAT0_PY7",
+	"SDMMC1_DAT1_PY6",
+	"SDMMC1_DAT2_PY5",
+	"SDMMC1_DAT3_PY4",
+	"SDMMC3_DAT0_PB7",
+	"SDMMC3_DAT1_PB6",
+	"SDMMC4_RST_N_PCC3",
+	"SPDIF_OUT_PK5",
+	"SYS_CLK_REQ_PZ5",
+	"UART3_CTS_N_PA1",
+	"UART3_RXD_PW7",
+	"UART3_TXD_PW6",
+	"ULPI_CLK_PY0",
+	"ULPI_DIR_PY1",
+	"ULPI_NXT_PY2",
+	"ULPI_STP_PY3",
+	"VI_D0_PT4",
+	"VI_D10_PT2",
+	"VI_D11_PT3",
+	"VI_HSYNC_PD7",
+	"VI_VSYNC_PD6",
+};
+
+static const char * const rsvd3_groups[] = {
+	"CAM_I2C_SCL_PBB1",
+	"CAM_I2C_SDA_PBB2",
+	"CLK1_OUT_PW4",
+	"CLK1_REQ_PEE2",
+	"CLK2_OUT_PW5",
+	"CLK2_REQ_PCC5",
+	"CLK3_OUT_PEE0",
+	"CLK3_REQ_PEE1",
+	"CLK_32K_IN",
+	"CLK_32K_OUT_PA0",
+	"CORE_PWR_REQ",
+	"CPU_PWR_REQ",
+	"CRT_HSYNC_PV6",
+	"CRT_VSYNC_PV7",
+	"DAP2_DIN_PA4",
+	"DAP2_DOUT_PA5",
+	"DAP2_FS_PA2",
+	"DAP2_SCLK_PA3",
+	"DDC_SCL_PV4",
+	"DDC_SDA_PV5",
+	"GEN1_I2C_SCL_PC4",
+	"GEN1_I2C_SDA_PC5",
+	"PBB0",
+	"PBB7",
+	"PCC1",
+	"PCC2",
+	"PV0",
+	"PV1",
+	"PV2",
+	"PV3",
+	"HDMI_CEC_PEE3",
+	"HDMI_INT_PN7",
+	"JTAG_RTCK_PU7",
+	"KB_ROW0_PR0",
+	"KB_ROW1_PR1",
+	"KB_ROW2_PR2",
+	"KB_ROW3_PR3",
+	"LCD_D0_PE0",
+	"LCD_D1_PE1",
+	"LCD_D10_PF2",
+	"LCD_D11_PF3",
+	"LCD_D12_PF4",
+	"LCD_D13_PF5",
+	"LCD_D14_PF6",
+	"LCD_D15_PF7",
+	"LCD_D16_PM0",
+	"LCD_D17_PM1",
+	"LCD_D18_PM2",
+	"LCD_D19_PM3",
+	"LCD_D2_PE2",
+	"LCD_D20_PM4",
+	"LCD_D21_PM5",
+	"LCD_D22_PM6",
+	"LCD_D23_PM7",
+	"LCD_D3_PE3",
+	"LCD_D4_PE4",
+	"LCD_D5_PE5",
+	"LCD_D6_PE6",
+	"LCD_D7_PE7",
+	"LCD_D8_PF0",
+	"LCD_D9_PF1",
+	"LCD_DC0_PN6",
+	"LCD_DC1_PD2",
+	"LCD_DE_PJ1",
+	"LCD_HSYNC_PJ3",
+	"LCD_M1_PW1",
+	"LCD_PCLK_PB3",
+	"LCD_PWR1_PC1",
+	"LCD_VSYNC_PJ4",
+	"OWR",
+	"PEX_L0_CLKREQ_N_PDD2",
+	"PEX_L0_PRSNT_N_PDD0",
+	"PEX_L0_RST_N_PDD1",
+	"PEX_L1_CLKREQ_N_PDD6",
+	"PEX_L1_PRSNT_N_PDD4",
+	"PEX_L1_RST_N_PDD5",
+	"PEX_L2_CLKREQ_N_PCC7",
+	"PEX_L2_PRSNT_N_PDD7",
+	"PEX_L2_RST_N_PCC6",
+	"PEX_WAKE_N_PDD3",
+	"PWR_I2C_SCL_PZ6",
+	"PWR_I2C_SDA_PZ7",
+	"PWR_INT_N",
+	"SDMMC1_CLK_PZ0",
+	"SDMMC1_CMD_PZ1",
+	"SDMMC4_RST_N_PCC3",
+	"SYS_CLK_REQ_PZ5",
+};
+
+static const char * const rsvd4_groups[] = {
+	"CLK1_OUT_PW4",
+	"CLK1_REQ_PEE2",
+	"CLK2_OUT_PW5",
+	"CLK2_REQ_PCC5",
+	"CLK3_OUT_PEE0",
+	"CLK3_REQ_PEE1",
+	"CLK_32K_IN",
+	"CLK_32K_OUT_PA0",
+	"CORE_PWR_REQ",
+	"CPU_PWR_REQ",
+	"CRT_HSYNC_PV6",
+	"CRT_VSYNC_PV7",
+	"DAP4_DIN_PP5",
+	"DAP4_DOUT_PP6",
+	"DAP4_FS_PP4",
+	"DAP4_SCLK_PP7",
+	"DDC_SCL_PV4",
+	"DDC_SDA_PV5",
+	"GEN1_I2C_SCL_PC4",
+	"GEN1_I2C_SDA_PC5",
+	"GEN2_I2C_SCL_PT5",
+	"GEN2_I2C_SDA_PT6",
+	"GMI_A19_PK7",
+	"GMI_AD0_PG0",
+	"GMI_AD1_PG1",
+	"GMI_AD10_PH2",
+	"GMI_AD11_PH3",
+	"GMI_AD12_PH4",
+	"GMI_AD13_PH5",
+	"GMI_AD14_PH6",
+	"GMI_AD15_PH7",
+	"GMI_AD2_PG2",
+	"GMI_AD3_PG3",
+	"GMI_AD4_PG4",
+	"GMI_AD5_PG5",
+	"GMI_AD6_PG6",
+	"GMI_AD7_PG7",
+	"GMI_AD8_PH0",
+	"GMI_AD9_PH1",
+	"GMI_ADV_N_PK0",
+	"GMI_CLK_PK1",
+	"GMI_CS2_N_PK3",
+	"GMI_CS4_N_PK2",
+	"GMI_DQS_PI2",
+	"GMI_IORDY_PI5",
+	"GMI_OE_N_PI1",
+	"GMI_RST_N_PI4",
+	"GMI_WAIT_PI7",
+	"GMI_WR_N_PI0",
+	"PCC2",
+	"PU0",
+	"PU1",
+	"PU2",
+	"PU3",
+	"PU4",
+	"PU5",
+	"PU6",
+	"PV0",
+	"PV1",
+	"PV2",
+	"PV3",
+	"HDMI_CEC_PEE3",
+	"HDMI_INT_PN7",
+	"JTAG_RTCK_PU7",
+	"KB_COL2_PQ2",
+	"KB_COL3_PQ3",
+	"KB_COL4_PQ4",
+	"KB_COL5_PQ5",
+	"KB_ROW0_PR0",
+	"KB_ROW1_PR1",
+	"KB_ROW2_PR2",
+	"KB_ROW4_PR4",
+	"LCD_CS0_N_PN4",
+	"LCD_CS1_N_PW0",
+	"LCD_D0_PE0",
+	"LCD_D1_PE1",
+	"LCD_D10_PF2",
+	"LCD_D11_PF3",
+	"LCD_D12_PF4",
+	"LCD_D13_PF5",
+	"LCD_D14_PF6",
+	"LCD_D15_PF7",
+	"LCD_D16_PM0",
+	"LCD_D17_PM1",
+	"LCD_D18_PM2",
+	"LCD_D19_PM3",
+	"LCD_D2_PE2",
+	"LCD_D20_PM4",
+	"LCD_D21_PM5",
+	"LCD_D22_PM6",
+	"LCD_D23_PM7",
+	"LCD_D3_PE3",
+	"LCD_D4_PE4",
+	"LCD_D5_PE5",
+	"LCD_D6_PE6",
+	"LCD_D7_PE7",
+	"LCD_D8_PF0",
+	"LCD_D9_PF1",
+	"LCD_DC0_PN6",
+	"LCD_DC1_PD2",
+	"LCD_DE_PJ1",
+	"LCD_HSYNC_PJ3",
+	"LCD_M1_PW1",
+	"LCD_PCLK_PB3",
+	"LCD_PWR1_PC1",
+	"LCD_SDIN_PZ2",
+	"LCD_VSYNC_PJ4",
+	"OWR",
+	"PEX_L0_CLKREQ_N_PDD2",
+	"PEX_L0_PRSNT_N_PDD0",
+	"PEX_L0_RST_N_PDD1",
+	"PEX_L1_CLKREQ_N_PDD6",
+	"PEX_L1_PRSNT_N_PDD4",
+	"PEX_L1_RST_N_PDD5",
+	"PEX_L2_CLKREQ_N_PCC7",
+	"PEX_L2_PRSNT_N_PDD7",
+	"PEX_L2_RST_N_PCC6",
+	"PEX_WAKE_N_PDD3",
+	"PWR_I2C_SCL_PZ6",
+	"PWR_I2C_SDA_PZ7",
+	"PWR_INT_N",
+	"SPI1_MISO_PX7",
+	"SYS_CLK_REQ_PZ5",
+	"UART3_CTS_N_PA1",
+	"UART3_RTS_N_PC0",
+	"UART3_RXD_PW7",
+	"UART3_TXD_PW6",
+	"VI_D0_PT4",
+	"VI_D1_PD5",
+	"VI_D10_PT2",
+	"VI_D11_PT3",
+	"VI_D2_PL0",
+	"VI_D3_PL1",
+	"VI_D4_PL2",
+	"VI_D5_PL3",
+	"VI_D6_PL4",
+	"VI_D7_PL5",
+	"VI_D8_PL6",
+	"VI_D9_PL7",
+	"VI_HSYNC_PD7",
+	"VI_PCLK_PT0",
+	"VI_VSYNC_PD6",
+};
+
+static const char * const rtck_groups[] = {
+	"JTAG_RTCK_PU7",
+};
+
+static const char * const sata_groups[] = {
+	"GMI_CS6_N_PI3",
+};
+
+static const char * const sdmmc1_groups[] = {
+	"SDMMC1_CLK_PZ0",
+	"SDMMC1_CMD_PZ1",
+	"SDMMC1_DAT0_PY7",
+	"SDMMC1_DAT1_PY6",
+	"SDMMC1_DAT2_PY5",
+	"SDMMC1_DAT3_PY4",
+};
+
+static const char * const sdmmc2_groups[] = {
+	"DAP1_DIN_PN1",
+	"DAP1_DOUT_PN2",
+	"DAP1_FS_PN0",
+	"DAP1_SCLK_PN3",
+	"KB_ROW10_PS2",
+	"KB_ROW11_PS3",
+	"KB_ROW12_PS4",
+	"KB_ROW13_PS5",
+	"KB_ROW14_PS6",
+	"KB_ROW15_PS7",
+	"KB_ROW6_PR6",
+	"KB_ROW7_PR7",
+	"KB_ROW8_PS0",
+	"KB_ROW9_PS1",
+	"SPDIF_IN_PK6",
+	"SPDIF_OUT_PK5",
+	"VI_D1_PD5",
+	"VI_D2_PL0",
+	"VI_D3_PL1",
+	"VI_D4_PL2",
+	"VI_D5_PL3",
+	"VI_D6_PL4",
+	"VI_D7_PL5",
+	"VI_D8_PL6",
+	"VI_D9_PL7",
+	"VI_PCLK_PT0",
+};
+
+static const char * const sdmmc3_groups[] = {
+	"SDMMC3_CLK_PA6",
+	"SDMMC3_CMD_PA7",
+	"SDMMC3_DAT0_PB7",
+	"SDMMC3_DAT1_PB6",
+	"SDMMC3_DAT2_PB5",
+	"SDMMC3_DAT3_PB4",
+	"SDMMC3_DAT4_PD1",
+	"SDMMC3_DAT5_PD0",
+	"SDMMC3_DAT6_PD3",
+	"SDMMC3_DAT7_PD4",
+};
+
+static const char * const sdmmc4_groups[] = {
+	"CAM_I2C_SCL_PBB1",
+	"CAM_I2C_SDA_PBB2",
+	"CAM_MCLK_PCC0",
+	"PBB0",
+	"PBB3",
+	"PBB4",
+	"PBB5",
+	"PBB6",
+	"PBB7",
+	"PCC1",
+	"SDMMC4_CLK_PCC4",
+	"SDMMC4_CMD_PT7",
+	"SDMMC4_DAT0_PAA0",
+	"SDMMC4_DAT1_PAA1",
+	"SDMMC4_DAT2_PAA2",
+	"SDMMC4_DAT3_PAA3",
+	"SDMMC4_DAT4_PAA4",
+	"SDMMC4_DAT5_PAA5",
+	"SDMMC4_DAT6_PAA6",
+	"SDMMC4_DAT7_PAA7",
+	"SDMMC4_RST_N_PCC3",
+};
+
+static const char * const spdif_groups[] = {
+	"SDMMC3_DAT6_PD3",
+	"SDMMC3_DAT7_PD4",
+	"SPDIF_IN_PK6",
+	"SPDIF_OUT_PK5",
+	"UART2_RXD_PC3",
+	"UART2_TXD_PC2",
+};
+
+static const char * const spi1_groups[] = {
+	"SPI1_CS0_N_PX6",
+	"SPI1_MISO_PX7",
+	"SPI1_MOSI_PX4",
+	"SPI1_SCK_PX5",
+	"ULPI_CLK_PY0",
+	"ULPI_DIR_PY1",
+	"ULPI_NXT_PY2",
+	"ULPI_STP_PY3",
+};
+
+static const char * const spi2_groups[] = {
+	"SDMMC3_CMD_PA7",
+	"SDMMC3_DAT4_PD1",
+	"SDMMC3_DAT5_PD0",
+	"SDMMC3_DAT6_PD3",
+	"SDMMC3_DAT7_PD4",
+	"SPI1_CS0_N_PX6",
+	"SPI1_MOSI_PX4",
+	"SPI1_SCK_PX5",
+	"SPI2_CS0_N_PX3",
+	"SPI2_CS1_N_PW2",
+	"SPI2_CS2_N_PW3",
+	"SPI2_MISO_PX1",
+	"SPI2_MOSI_PX0",
+	"SPI2_SCK_PX2",
+	"ULPI_DATA4_PO5",
+	"ULPI_DATA5_PO6",
+	"ULPI_DATA6_PO7",
+	"ULPI_DATA7_PO0",
+};
+
+static const char * const spi2_alt_groups[] = {
+	"SPI1_CS0_N_PX6",
+	"SPI1_MISO_PX7",
+	"SPI1_MOSI_PX4",
+	"SPI1_SCK_PX5",
+	"SPI2_CS1_N_PW2",
+	"SPI2_CS2_N_PW3",
+};
+
+static const char * const spi3_groups[] = {
+	"SDMMC3_CLK_PA6",
+	"SDMMC3_DAT0_PB7",
+	"SDMMC3_DAT1_PB6",
+	"SDMMC3_DAT2_PB5",
+	"SDMMC3_DAT3_PB4",
+	"SDMMC4_DAT0_PAA0",
+	"SDMMC4_DAT1_PAA1",
+	"SDMMC4_DAT2_PAA2",
+	"SDMMC4_DAT3_PAA3",
+	"SPI1_MISO_PX7",
+	"SPI2_CS0_N_PX3",
+	"SPI2_CS1_N_PW2",
+	"SPI2_CS2_N_PW3",
+	"SPI2_MISO_PX1",
+	"SPI2_MOSI_PX0",
+	"SPI2_SCK_PX2",
+	"ULPI_DATA0_PO1",
+	"ULPI_DATA1_PO2",
+	"ULPI_DATA2_PO3",
+	"ULPI_DATA3_PO4",
+};
+
+static const char * const spi4_groups[] = {
+	"GMI_A16_PJ7",
+	"GMI_A17_PB0",
+	"GMI_A18_PB1",
+	"GMI_A19_PK7",
+	"SDMMC3_DAT4_PD1",
+	"SDMMC3_DAT5_PD0",
+	"SDMMC3_DAT6_PD3",
+	"SDMMC3_DAT7_PD4",
+	"UART2_CTS_N_PJ5",
+	"UART2_RTS_N_PJ6",
+	"UART2_RXD_PC3",
+	"UART2_TXD_PC2",
+};
+
+static const char * const spi5_groups[] = {
+	"LCD_CS0_N_PN4",
+	"LCD_CS1_N_PW0",
+	"LCD_PWR0_PB2",
+	"LCD_PWR2_PC6",
+	"LCD_SCK_PZ4",
+	"LCD_SDIN_PZ2",
+	"LCD_SDOUT_PN5",
+	"LCD_WR_N_PZ3",
+};
+
+static const char * const spi6_groups[] = {
+	"SPI2_CS0_N_PX3",
+	"SPI2_MISO_PX1",
+	"SPI2_MOSI_PX0",
+	"SPI2_SCK_PX2",
+};
+
+static const char * const sysclk_groups[] = {
+	"SYS_CLK_REQ_PZ5",
+};
+
+static const char * const test_groups[] = {
+	"KB_COL0_PQ0",
+	"KB_COL1_PQ1",
+};
+
+static const char * const trace_groups[] = {
+	"KB_COL0_PQ0",
+	"KB_COL1_PQ1",
+	"KB_COL2_PQ2",
+	"KB_COL3_PQ3",
+	"KB_COL4_PQ4",
+	"KB_COL5_PQ5",
+	"KB_COL6_PQ6",
+	"KB_COL7_PQ7",
+	"KB_ROW4_PR4",
+	"KB_ROW5_PR5",
+};
+
+static const char * const uarta_groups[] = {
+	"PU0",
+	"PU1",
+	"PU2",
+	"PU3",
+	"PU4",
+	"PU5",
+	"PU6",
+	"SDMMC1_CLK_PZ0",
+	"SDMMC1_CMD_PZ1",
+	"SDMMC1_DAT0_PY7",
+	"SDMMC1_DAT1_PY6",
+	"SDMMC1_DAT2_PY5",
+	"SDMMC1_DAT3_PY4",
+	"SDMMC3_CLK_PA6",
+	"SDMMC3_CMD_PA7",
+	"UART2_CTS_N_PJ5",
+	"UART2_RTS_N_PJ6",
+	"UART2_RXD_PC3",
+	"UART2_TXD_PC2",
+	"ULPI_DATA0_PO1",
+	"ULPI_DATA1_PO2",
+	"ULPI_DATA2_PO3",
+	"ULPI_DATA3_PO4",
+	"ULPI_DATA4_PO5",
+	"ULPI_DATA5_PO6",
+	"ULPI_DATA6_PO7",
+	"ULPI_DATA7_PO0",
+};
+
+static const char * const uartb_groups[] = {
+	"UART2_CTS_N_PJ5",
+	"UART2_RTS_N_PJ6",
+	"UART2_RXD_PC3",
+	"UART2_TXD_PC2",
+};
+
+static const char * const uartc_groups[] = {
+	"UART3_CTS_N_PA1",
+	"UART3_RTS_N_PC0",
+	"UART3_RXD_PW7",
+	"UART3_TXD_PW6",
+};
+
+static const char * const uartd_groups[] = {
+	"GMI_A16_PJ7",
+	"GMI_A17_PB0",
+	"GMI_A18_PB1",
+	"GMI_A19_PK7",
+	"ULPI_CLK_PY0",
+	"ULPI_DIR_PY1",
+	"ULPI_NXT_PY2",
+	"ULPI_STP_PY3",
+};
+
+static const char * const uarte_groups[] = {
+	"SDMMC1_DAT0_PY7",
+	"SDMMC1_DAT1_PY6",
+	"SDMMC1_DAT2_PY5",
+	"SDMMC1_DAT3_PY4",
+	"SDMMC4_DAT0_PAA0",
+	"SDMMC4_DAT1_PAA1",
+	"SDMMC4_DAT2_PAA2",
+	"SDMMC4_DAT3_PAA3",
+};
+
+static const char * const ulpi_groups[] = {
+	"ULPI_CLK_PY0",
+	"ULPI_DATA0_PO1",
+	"ULPI_DATA1_PO2",
+	"ULPI_DATA2_PO3",
+	"ULPI_DATA3_PO4",
+	"ULPI_DATA4_PO5",
+	"ULPI_DATA5_PO6",
+	"ULPI_DATA6_PO7",
+	"ULPI_DATA7_PO0",
+	"ULPI_DIR_PY1",
+	"ULPI_NXT_PY2",
+	"ULPI_STP_PY3",
+};
+
+static const char * const vgp1_groups[] = {
+	"CAM_I2C_SCL_PBB1",
+};
+
+static const char * const vgp2_groups[] = {
+	"CAM_I2C_SDA_PBB2",
+};
+
+static const char * const vgp3_groups[] = {
+	"PBB3",
+	"SDMMC4_DAT5_PAA5",
+};
+
+static const char * const vgp4_groups[] = {
+	"PBB4",
+	"SDMMC4_DAT6_PAA6",
+};
+
+static const char * const vgp5_groups[] = {
+	"PBB5",
+	"SDMMC4_DAT7_PAA7",
+};
+
+static const char * const vgp6_groups[] = {
+	"PBB6",
+	"SDMMC4_RST_N_PCC3",
+};
+
+static const char * const vi_groups[] = {
+	"CAM_MCLK_PCC0",
+	"VI_D0_PT4",
+	"VI_D1_PD5",
+	"VI_D10_PT2",
+	"VI_D11_PT3",
+	"VI_D2_PL0",
+	"VI_D3_PL1",
+	"VI_D4_PL2",
+	"VI_D5_PL3",
+	"VI_D6_PL4",
+	"VI_D7_PL5",
+	"VI_D8_PL6",
+	"VI_D9_PL7",
+	"VI_HSYNC_PD7",
+	"VI_MCLK_PT1",
+	"VI_PCLK_PT0",
+	"VI_VSYNC_PD6",
+};
+
+static const char * const vi_alt1_groups[] = {
+	"CAM_MCLK_PCC0",
+	"VI_MCLK_PT1",
+};
+
+static const char * const vi_alt2_groups[] = {
+	"VI_MCLK_PT1",
+};
+
+static const char * const vi_alt3_groups[] = {
+	"CAM_MCLK_PCC0",
+	"VI_MCLK_PT1",
+};
+
+#define FUNCTION(fname)					\
+	{						\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+	}
+
+static const struct tegra_function tegra30_functions[] = {
+	FUNCTION(blink),
+	FUNCTION(cec),
+	FUNCTION(clk_12m_out),
+	FUNCTION(clk_32k_in),
+	FUNCTION(core_pwr_req),
+	FUNCTION(cpu_pwr_req),
+	FUNCTION(crt),
+	FUNCTION(dap),
+	FUNCTION(ddr),
+	FUNCTION(dev3),
+	FUNCTION(displaya),
+	FUNCTION(displayb),
+	FUNCTION(dtv),
+	FUNCTION(extperiph1),
+	FUNCTION(extperiph2),
+	FUNCTION(extperiph3),
+	FUNCTION(gmi),
+	FUNCTION(gmi_alt),
+	FUNCTION(hda),
+	FUNCTION(hdcp),
+	FUNCTION(hdmi),
+	FUNCTION(hsi),
+	FUNCTION(i2c1),
+	FUNCTION(i2c2),
+	FUNCTION(i2c3),
+	FUNCTION(i2c4),
+	FUNCTION(i2cpwr),
+	FUNCTION(i2s0),
+	FUNCTION(i2s1),
+	FUNCTION(i2s2),
+	FUNCTION(i2s3),
+	FUNCTION(i2s4),
+	FUNCTION(invalid),
+	FUNCTION(kbc),
+	FUNCTION(mio),
+	FUNCTION(nand),
+	FUNCTION(nand_alt),
+	FUNCTION(owr),
+	FUNCTION(pcie),
+	FUNCTION(pwm0),
+	FUNCTION(pwm1),
+	FUNCTION(pwm2),
+	FUNCTION(pwm3),
+	FUNCTION(pwr_int_n),
+	FUNCTION(rsvd1),
+	FUNCTION(rsvd2),
+	FUNCTION(rsvd3),
+	FUNCTION(rsvd4),
+	FUNCTION(rtck),
+	FUNCTION(sata),
+	FUNCTION(sdmmc1),
+	FUNCTION(sdmmc2),
+	FUNCTION(sdmmc3),
+	FUNCTION(sdmmc4),
+	FUNCTION(spdif),
+	FUNCTION(spi1),
+	FUNCTION(spi2),
+	FUNCTION(spi2_alt),
+	FUNCTION(spi3),
+	FUNCTION(spi4),
+	FUNCTION(spi5),
+	FUNCTION(spi6),
+	FUNCTION(sysclk),
+	FUNCTION(test),
+	FUNCTION(trace),
+	FUNCTION(uarta),
+	FUNCTION(uartb),
+	FUNCTION(uartc),
+	FUNCTION(uartd),
+	FUNCTION(uarte),
+	FUNCTION(ulpi),
+	FUNCTION(vgp1),
+	FUNCTION(vgp2),
+	FUNCTION(vgp3),
+	FUNCTION(vgp4),
+	FUNCTION(vgp5),
+	FUNCTION(vgp6),
+	FUNCTION(vi),
+	FUNCTION(vi_alt1),
+	FUNCTION(vi_alt2),
+	FUNCTION(vi_alt3),
+};
+
+#define MUXCTL_REG_A	0x3000
+#define PINGROUP_REG_A	0x868
+
+#define PINGROUP_REG_Y(r) ((r) - MUXCTL_REG_A)
+#define PINGROUP_REG_N(r) -1
+
+#define PINGROUP(pg_name, f0, f1, f2, f3, f_safe, r, od, ior)	\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.funcs = {					\
+			TEGRA_MUX_ ## f0,			\
+			TEGRA_MUX_ ## f1,			\
+			TEGRA_MUX_ ## f2,			\
+			TEGRA_MUX_ ## f3,			\
+		},						\
+		.func_safe = TEGRA_MUX_ ## f_safe,		\
+		.mux_reg = PINGROUP_REG_Y(r),			\
+		.mux_bank = 0,					\
+		.mux_bit = 0,					\
+		.pupd_reg = PINGROUP_REG_Y(r),			\
+		.pupd_bank = 0,					\
+		.pupd_bit = 2,					\
+		.tri_reg = PINGROUP_REG_Y(r),			\
+		.tri_bank = 0,					\
+		.tri_bit = 4,					\
+		.einput_reg = PINGROUP_REG_Y(r),		\
+		.einput_bank = 0,				\
+		.einput_bit = 5,				\
+		.odrain_reg = PINGROUP_REG_##od(r),		\
+		.odrain_bank = 0,				\
+		.odrain_bit = 6,				\
+		.lock_reg = PINGROUP_REG_Y(r),			\
+		.lock_bank = 0,					\
+		.lock_bit = 7,					\
+		.ioreset_reg = PINGROUP_REG_##ior(r),		\
+		.ioreset_bank = 0,				\
+		.ioreset_bit = 8,				\
+		.drv_reg = -1,					\
+	}
+
+#define DRV_PINGROUP(pg_name, r, hsm_b, schmitt_b, lpmd_b,	\
+		     drvdn_b, drvdn_w, drvup_b, drvup_w,	\
+		     slwr_b, slwr_w, slwf_b, slwf_w)		\
+	{							\
+		.name = "drive_" #pg_name,			\
+		.pins = drive_##pg_name##_pins,			\
+		.npins = ARRAY_SIZE(drive_##pg_name##_pins),	\
+		.mux_reg = -1,					\
+		.pupd_reg = -1,					\
+		.tri_reg = -1,					\
+		.einput_reg = -1,				\
+		.odrain_reg = -1,				\
+		.lock_reg = -1,					\
+		.ioreset_reg = -1,				\
+		.drv_reg = ((r) - PINGROUP_REG_A),		\
+		.drv_bank = 1,					\
+		.hsm_bit = hsm_b,				\
+		.schmitt_bit = schmitt_b,			\
+		.lpmd_bit = lpmd_b,				\
+		.drvdn_bit = drvdn_b,				\
+		.drvdn_width = drvdn_w,				\
+		.drvup_bit = drvup_b,				\
+		.drvup_width = drvup_w,				\
+		.slwr_bit = slwr_b,				\
+		.slwr_width = slwr_w,				\
+		.slwf_bit = slwf_b,				\
+		.slwf_width = slwf_w,				\
+	}
+
+static const struct tegra_pingroup tegra30_groups[] = {
+	/*       pg_name,              f0,           f1,           f2,           f3,           safe,         r,      od, ior */
+	/* FIXME: Fill in correct data in safe column */
+	PINGROUP(clk_32k_out_pa0,      BLINK,        RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x331c, N, N),
+	PINGROUP(uart3_cts_n_pa1,      UARTC,        RSVD2,        GMI,          RSVD4,        RSVD4,        0x317c, N, N),
+	PINGROUP(dap2_fs_pa2,          I2S1,         HDA,          RSVD3,        GMI,          RSVD3,        0x3358, N, N),
+	PINGROUP(dap2_sclk_pa3,        I2S1,         HDA,          RSVD3,        GMI,          RSVD3,        0x3364, N, N),
+	PINGROUP(dap2_din_pa4,         I2S1,         HDA,          RSVD3,        GMI,          RSVD3,        0x335c, N, N),
+	PINGROUP(dap2_dout_pa5,        I2S1,         HDA,          RSVD3,        GMI,          RSVD3,        0x3360, N, N),
+	PINGROUP(sdmmc3_clk_pa6,       UARTA,        PWM2,         SDMMC3,       SPI3,         SPI3,         0x3390, N, N),
+	PINGROUP(sdmmc3_cmd_pa7,       UARTA,        PWM3,         SDMMC3,       SPI2,         SPI2,         0x3394, N, N),
+	PINGROUP(gmi_a17_pb0,          UARTD,        SPI4,         GMI,          DTV,          DTV,          0x3234, N, N),
+	PINGROUP(gmi_a18_pb1,          UARTD,        SPI4,         GMI,          DTV,          DTV,          0x3238, N, N),
+	PINGROUP(lcd_pwr0_pb2,         DISPLAYA,     DISPLAYB,     SPI5,         HDCP,         HDCP,         0x3090, N, N),
+	PINGROUP(lcd_pclk_pb3,         DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3094, N, N),
+	PINGROUP(sdmmc3_dat3_pb4,      RSVD1,        PWM0,         SDMMC3,       SPI3,         RSVD1,        0x33a4, N, N),
+	PINGROUP(sdmmc3_dat2_pb5,      RSVD1,        PWM1,         SDMMC3,       SPI3,         RSVD1,        0x33a0, N, N),
+	PINGROUP(sdmmc3_dat1_pb6,      RSVD1,        RSVD2,        SDMMC3,       SPI3,         RSVD2,        0x339c, N, N),
+	PINGROUP(sdmmc3_dat0_pb7,      RSVD1,        RSVD2,        SDMMC3,       SPI3,         RSVD2,        0x3398, N, N),
+	PINGROUP(uart3_rts_n_pc0,      UARTC,        PWM0,         GMI,          RSVD4,        RSVD4,        0x3180, N, N),
+	PINGROUP(lcd_pwr1_pc1,         DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3070, N, N),
+	PINGROUP(uart2_txd_pc2,        UARTB,        SPDIF,        UARTA,        SPI4,         SPI4,         0x3168, N, N),
+	PINGROUP(uart2_rxd_pc3,        UARTB,        SPDIF,        UARTA,        SPI4,         SPI4,         0x3164, N, N),
+	PINGROUP(gen1_i2c_scl_pc4,     I2C1,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x31a4, Y, N),
+	PINGROUP(gen1_i2c_sda_pc5,     I2C1,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x31a0, Y, N),
+	PINGROUP(lcd_pwr2_pc6,         DISPLAYA,     DISPLAYB,     SPI5,         HDCP,         HDCP,         0x3074, N, N),
+	PINGROUP(gmi_wp_n_pc7,         RSVD1,        NAND,         GMI,          GMI_ALT,      RSVD1,        0x31c0, N, N),
+	PINGROUP(sdmmc3_dat5_pd0,      PWM0,         SPI4,         SDMMC3,       SPI2,         SPI2,         0x33ac, N, N),
+	PINGROUP(sdmmc3_dat4_pd1,      PWM1,         SPI4,         SDMMC3,       SPI2,         SPI2,         0x33a8, N, N),
+	PINGROUP(lcd_dc1_pd2,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x310c, N, N),
+	PINGROUP(sdmmc3_dat6_pd3,      SPDIF,        SPI4,         SDMMC3,       SPI2,         SPI2,         0x33b0, N, N),
+	PINGROUP(sdmmc3_dat7_pd4,      SPDIF,        SPI4,         SDMMC3,       SPI2,         SPI2,         0x33b4, N, N),
+	PINGROUP(vi_d1_pd5,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3128, N, Y),
+	PINGROUP(vi_vsync_pd6,         DDR,          RSVD2,        VI,           RSVD4,        RSVD4,        0x315c, N, Y),
+	PINGROUP(vi_hsync_pd7,         DDR,          RSVD2,        VI,           RSVD4,        RSVD4,        0x3160, N, Y),
+	PINGROUP(lcd_d0_pe0,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30a4, N, N),
+	PINGROUP(lcd_d1_pe1,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30a8, N, N),
+	PINGROUP(lcd_d2_pe2,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30ac, N, N),
+	PINGROUP(lcd_d3_pe3,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30b0, N, N),
+	PINGROUP(lcd_d4_pe4,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30b4, N, N),
+	PINGROUP(lcd_d5_pe5,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30b8, N, N),
+	PINGROUP(lcd_d6_pe6,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30bc, N, N),
+	PINGROUP(lcd_d7_pe7,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30c0, N, N),
+	PINGROUP(lcd_d8_pf0,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30c4, N, N),
+	PINGROUP(lcd_d9_pf1,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30c8, N, N),
+	PINGROUP(lcd_d10_pf2,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30cc, N, N),
+	PINGROUP(lcd_d11_pf3,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30d0, N, N),
+	PINGROUP(lcd_d12_pf4,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30d4, N, N),
+	PINGROUP(lcd_d13_pf5,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30d8, N, N),
+	PINGROUP(lcd_d14_pf6,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30dc, N, N),
+	PINGROUP(lcd_d15_pf7,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30e0, N, N),
+	PINGROUP(gmi_ad0_pg0,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31f0, N, N),
+	PINGROUP(gmi_ad1_pg1,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31f4, N, N),
+	PINGROUP(gmi_ad2_pg2,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31f8, N, N),
+	PINGROUP(gmi_ad3_pg3,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31fc, N, N),
+	PINGROUP(gmi_ad4_pg4,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3200, N, N),
+	PINGROUP(gmi_ad5_pg5,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3204, N, N),
+	PINGROUP(gmi_ad6_pg6,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3208, N, N),
+	PINGROUP(gmi_ad7_pg7,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x320c, N, N),
+	PINGROUP(gmi_ad8_ph0,          PWM0,         NAND,         GMI,          RSVD4,        RSVD4,        0x3210, N, N),
+	PINGROUP(gmi_ad9_ph1,          PWM1,         NAND,         GMI,          RSVD4,        RSVD4,        0x3214, N, N),
+	PINGROUP(gmi_ad10_ph2,         PWM2,         NAND,         GMI,          RSVD4,        RSVD4,        0x3218, N, N),
+	PINGROUP(gmi_ad11_ph3,         PWM3,         NAND,         GMI,          RSVD4,        RSVD4,        0x321c, N, N),
+	PINGROUP(gmi_ad12_ph4,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3220, N, N),
+	PINGROUP(gmi_ad13_ph5,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3224, N, N),
+	PINGROUP(gmi_ad14_ph6,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3228, N, N),
+	PINGROUP(gmi_ad15_ph7,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x322c, N, N),
+	PINGROUP(gmi_wr_n_pi0,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3240, N, N),
+	PINGROUP(gmi_oe_n_pi1,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3244, N, N),
+	PINGROUP(gmi_dqs_pi2,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x3248, N, N),
+	PINGROUP(gmi_cs6_n_pi3,        NAND,         NAND_ALT,     GMI,          SATA,         SATA,         0x31e8, N, N),
+	PINGROUP(gmi_rst_n_pi4,        NAND,         NAND_ALT,     GMI,          RSVD4,        RSVD4,        0x324c, N, N),
+	PINGROUP(gmi_iordy_pi5,        RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31c4, N, N),
+	PINGROUP(gmi_cs7_n_pi6,        NAND,         NAND_ALT,     GMI,          GMI_ALT,      GMI_ALT,      0x31ec, N, N),
+	PINGROUP(gmi_wait_pi7,         RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31c8, N, N),
+	PINGROUP(gmi_cs0_n_pj0,        RSVD1,        NAND,         GMI,          DTV,          RSVD1,        0x31d4, N, N),
+	PINGROUP(lcd_de_pj1,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3098, N, N),
+	PINGROUP(gmi_cs1_n_pj2,        RSVD1,        NAND,         GMI,          DTV,          RSVD1,        0x31d8, N, N),
+	PINGROUP(lcd_hsync_pj3,        DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x309c, N, N),
+	PINGROUP(lcd_vsync_pj4,        DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30a0, N, N),
+	PINGROUP(uart2_cts_n_pj5,      UARTA,        UARTB,        GMI,          SPI4,         SPI4,         0x3170, N, N),
+	PINGROUP(uart2_rts_n_pj6,      UARTA,        UARTB,        GMI,          SPI4,         SPI4,         0x316c, N, N),
+	PINGROUP(gmi_a16_pj7,          UARTD,        SPI4,         GMI,          GMI_ALT,      GMI_ALT,      0x3230, N, N),
+	PINGROUP(gmi_adv_n_pk0,        RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31cc, N, N),
+	PINGROUP(gmi_clk_pk1,          RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31d0, N, N),
+	PINGROUP(gmi_cs4_n_pk2,        RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31e4, N, N),
+	PINGROUP(gmi_cs2_n_pk3,        RSVD1,        NAND,         GMI,          RSVD4,        RSVD4,        0x31dc, N, N),
+	PINGROUP(gmi_cs3_n_pk4,        RSVD1,        NAND,         GMI,          GMI_ALT,      RSVD1,        0x31e0, N, N),
+	PINGROUP(spdif_out_pk5,        SPDIF,        RSVD2,        I2C1,         SDMMC2,       RSVD2,        0x3354, N, N),
+	PINGROUP(spdif_in_pk6,         SPDIF,        HDA,          I2C1,         SDMMC2,       SDMMC2,       0x3350, N, N),
+	PINGROUP(gmi_a19_pk7,          UARTD,        SPI4,         GMI,          RSVD4,        RSVD4,        0x323c, N, N),
+	PINGROUP(vi_d2_pl0,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x312c, N, Y),
+	PINGROUP(vi_d3_pl1,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3130, N, Y),
+	PINGROUP(vi_d4_pl2,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3134, N, Y),
+	PINGROUP(vi_d5_pl3,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3138, N, Y),
+	PINGROUP(vi_d6_pl4,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x313c, N, Y),
+	PINGROUP(vi_d7_pl5,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3140, N, Y),
+	PINGROUP(vi_d8_pl6,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3144, N, Y),
+	PINGROUP(vi_d9_pl7,            DDR,          SDMMC2,       VI,           RSVD4,        RSVD4,        0x3148, N, Y),
+	PINGROUP(lcd_d16_pm0,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30e4, N, N),
+	PINGROUP(lcd_d17_pm1,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30e8, N, N),
+	PINGROUP(lcd_d18_pm2,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30ec, N, N),
+	PINGROUP(lcd_d19_pm3,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30f0, N, N),
+	PINGROUP(lcd_d20_pm4,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30f4, N, N),
+	PINGROUP(lcd_d21_pm5,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30f8, N, N),
+	PINGROUP(lcd_d22_pm6,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x30fc, N, N),
+	PINGROUP(lcd_d23_pm7,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3100, N, N),
+	PINGROUP(dap1_fs_pn0,          I2S0,         HDA,          GMI,          SDMMC2,       SDMMC2,       0x3338, N, N),
+	PINGROUP(dap1_din_pn1,         I2S0,         HDA,          GMI,          SDMMC2,       SDMMC2,       0x333c, N, N),
+	PINGROUP(dap1_dout_pn2,        I2S0,         HDA,          GMI,          SDMMC2,       SDMMC2,       0x3340, N, N),
+	PINGROUP(dap1_sclk_pn3,        I2S0,         HDA,          GMI,          SDMMC2,       SDMMC2,       0x3344, N, N),
+	PINGROUP(lcd_cs0_n_pn4,        DISPLAYA,     DISPLAYB,     SPI5,         RSVD4,        RSVD4,        0x3084, N, N),
+	PINGROUP(lcd_sdout_pn5,        DISPLAYA,     DISPLAYB,     SPI5,         HDCP,         HDCP,         0x307c, N, N),
+	PINGROUP(lcd_dc0_pn6,          DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3088, N, N),
+	PINGROUP(hdmi_int_pn7,         HDMI,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3110, N, N),
+	PINGROUP(ulpi_data7_po0,       SPI2,         HSI,          UARTA,        ULPI,         ULPI,         0x301c, N, N),
+	PINGROUP(ulpi_data0_po1,       SPI3,         HSI,          UARTA,        ULPI,         ULPI,         0x3000, N, N),
+	PINGROUP(ulpi_data1_po2,       SPI3,         HSI,          UARTA,        ULPI,         ULPI,         0x3004, N, N),
+	PINGROUP(ulpi_data2_po3,       SPI3,         HSI,          UARTA,        ULPI,         ULPI,         0x3008, N, N),
+	PINGROUP(ulpi_data3_po4,       SPI3,         HSI,          UARTA,        ULPI,         ULPI,         0x300c, N, N),
+	PINGROUP(ulpi_data4_po5,       SPI2,         HSI,          UARTA,        ULPI,         ULPI,         0x3010, N, N),
+	PINGROUP(ulpi_data5_po6,       SPI2,         HSI,          UARTA,        ULPI,         ULPI,         0x3014, N, N),
+	PINGROUP(ulpi_data6_po7,       SPI2,         HSI,          UARTA,        ULPI,         ULPI,         0x3018, N, N),
+	PINGROUP(dap3_fs_pp0,          I2S2,         RSVD2,        DISPLAYA,     DISPLAYB,     RSVD2,        0x3030, N, N),
+	PINGROUP(dap3_din_pp1,         I2S2,         RSVD2,        DISPLAYA,     DISPLAYB,     RSVD2,        0x3034, N, N),
+	PINGROUP(dap3_dout_pp2,        I2S2,         RSVD2,        DISPLAYA,     DISPLAYB,     RSVD2,        0x3038, N, N),
+	PINGROUP(dap3_sclk_pp3,        I2S2,         RSVD2,        DISPLAYA,     DISPLAYB,     RSVD2,        0x303c, N, N),
+	PINGROUP(dap4_fs_pp4,          I2S3,         RSVD2,        GMI,          RSVD4,        RSVD4,        0x31a8, N, N),
+	PINGROUP(dap4_din_pp5,         I2S3,         RSVD2,        GMI,          RSVD4,        RSVD4,        0x31ac, N, N),
+	PINGROUP(dap4_dout_pp6,        I2S3,         RSVD2,        GMI,          RSVD4,        RSVD4,        0x31b0, N, N),
+	PINGROUP(dap4_sclk_pp7,        I2S3,         RSVD2,        GMI,          RSVD4,        RSVD4,        0x31b4, N, N),
+	PINGROUP(kb_col0_pq0,          KBC,          NAND,         TRACE,        TEST,         TEST,         0x32fc, N, N),
+	PINGROUP(kb_col1_pq1,          KBC,          NAND,         TRACE,        TEST,         TEST,         0x3300, N, N),
+	PINGROUP(kb_col2_pq2,          KBC,          NAND,         TRACE,        RSVD4,        RSVD4,        0x3304, N, N),
+	PINGROUP(kb_col3_pq3,          KBC,          NAND,         TRACE,        RSVD4,        RSVD4,        0x3308, N, N),
+	PINGROUP(kb_col4_pq4,          KBC,          NAND,         TRACE,        RSVD4,        RSVD4,        0x330c, N, N),
+	PINGROUP(kb_col5_pq5,          KBC,          NAND,         TRACE,        RSVD4,        RSVD4,        0x3310, N, N),
+	PINGROUP(kb_col6_pq6,          KBC,          NAND,         TRACE,        MIO,          MIO,          0x3314, N, N),
+	PINGROUP(kb_col7_pq7,          KBC,          NAND,         TRACE,        MIO,          MIO,          0x3318, N, N),
+	PINGROUP(kb_row0_pr0,          KBC,          NAND,         RSVD3,        RSVD4,        RSVD4,        0x32bc, N, N),
+	PINGROUP(kb_row1_pr1,          KBC,          NAND,         RSVD3,        RSVD4,        RSVD4,        0x32c0, N, N),
+	PINGROUP(kb_row2_pr2,          KBC,          NAND,         RSVD3,        RSVD4,        RSVD4,        0x32c4, N, N),
+	PINGROUP(kb_row3_pr3,          KBC,          NAND,         RSVD3,        INVALID,      RSVD3,        0x32c8, N, N),
+	PINGROUP(kb_row4_pr4,          KBC,          NAND,         TRACE,        RSVD4,        RSVD4,        0x32cc, N, N),
+	PINGROUP(kb_row5_pr5,          KBC,          NAND,         TRACE,        OWR,          OWR,          0x32d0, N, N),
+	PINGROUP(kb_row6_pr6,          KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32d4, N, N),
+	PINGROUP(kb_row7_pr7,          KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32d8, N, N),
+	PINGROUP(kb_row8_ps0,          KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32dc, N, N),
+	PINGROUP(kb_row9_ps1,          KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32e0, N, N),
+	PINGROUP(kb_row10_ps2,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32e4, N, N),
+	PINGROUP(kb_row11_ps3,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32e8, N, N),
+	PINGROUP(kb_row12_ps4,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32ec, N, N),
+	PINGROUP(kb_row13_ps5,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32f0, N, N),
+	PINGROUP(kb_row14_ps6,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32f4, N, N),
+	PINGROUP(kb_row15_ps7,         KBC,          NAND,         SDMMC2,       MIO,          MIO,          0x32f8, N, N),
+	PINGROUP(vi_pclk_pt0,          RSVD1,        SDMMC2,       VI,           RSVD4,        RSVD4,        0x3154, N, Y),
+	PINGROUP(vi_mclk_pt1,          VI,           VI_ALT1,      VI_ALT2,      VI_ALT3,      VI_ALT3,      0x3158, N, Y),
+	PINGROUP(vi_d10_pt2,           DDR,          RSVD2,        VI,           RSVD4,        RSVD4,        0x314c, N, Y),
+	PINGROUP(vi_d11_pt3,           DDR,          RSVD2,        VI,           RSVD4,        RSVD4,        0x3150, N, Y),
+	PINGROUP(vi_d0_pt4,            DDR,          RSVD2,        VI,           RSVD4,        RSVD4,        0x3124, N, Y),
+	PINGROUP(gen2_i2c_scl_pt5,     I2C2,         HDCP,         GMI,          RSVD4,        RSVD4,        0x3250, Y, N),
+	PINGROUP(gen2_i2c_sda_pt6,     I2C2,         HDCP,         GMI,          RSVD4,        RSVD4,        0x3254, Y, N),
+	PINGROUP(sdmmc4_cmd_pt7,       I2C3,         NAND,         GMI,          SDMMC4,       SDMMC4,       0x325c, N, Y),
+	PINGROUP(pu0,                  OWR,          UARTA,        GMI,          RSVD4,        RSVD4,        0x3184, N, N),
+	PINGROUP(pu1,                  RSVD1,        UARTA,        GMI,          RSVD4,        RSVD4,        0x3188, N, N),
+	PINGROUP(pu2,                  RSVD1,        UARTA,        GMI,          RSVD4,        RSVD4,        0x318c, N, N),
+	PINGROUP(pu3,                  PWM0,         UARTA,        GMI,          RSVD4,        RSVD4,        0x3190, N, N),
+	PINGROUP(pu4,                  PWM1,         UARTA,        GMI,          RSVD4,        RSVD4,        0x3194, N, N),
+	PINGROUP(pu5,                  PWM2,         UARTA,        GMI,          RSVD4,        RSVD4,        0x3198, N, N),
+	PINGROUP(pu6,                  PWM3,         UARTA,        GMI,          RSVD4,        RSVD4,        0x319c, N, N),
+	PINGROUP(jtag_rtck_pu7,        RTCK,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x32b0, N, N),
+	PINGROUP(pv0,                  RSVD1,        RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3040, N, N),
+	PINGROUP(pv1,                  RSVD1,        RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3044, N, N),
+	PINGROUP(pv2,                  OWR,          RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3060, N, N),
+	PINGROUP(pv3,                  CLK_12M_OUT,  RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3064, N, N),
+	PINGROUP(ddc_scl_pv4,          I2C4,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3114, N, N),
+	PINGROUP(ddc_sda_pv5,          I2C4,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3118, N, N),
+	PINGROUP(crt_hsync_pv6,        CRT,          RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x311c, N, N),
+	PINGROUP(crt_vsync_pv7,        CRT,          RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3120, N, N),
+	PINGROUP(lcd_cs1_n_pw0,        DISPLAYA,     DISPLAYB,     SPI5,         RSVD4,        RSVD4,        0x3104, N, N),
+	PINGROUP(lcd_m1_pw1,           DISPLAYA,     DISPLAYB,     RSVD3,        RSVD4,        RSVD4,        0x3108, N, N),
+	PINGROUP(spi2_cs1_n_pw2,       SPI3,         SPI2,         SPI2_ALT,     I2C1,         I2C1,         0x3388, N, N),
+	PINGROUP(spi2_cs2_n_pw3,       SPI3,         SPI2,         SPI2_ALT,     I2C1,         I2C1,         0x338c, N, N),
+	PINGROUP(clk1_out_pw4,         EXTPERIPH1,   RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x334c, N, N),
+	PINGROUP(clk2_out_pw5,         EXTPERIPH2,   RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3068, N, N),
+	PINGROUP(uart3_txd_pw6,        UARTC,        RSVD2,        GMI,          RSVD4,        RSVD4,        0x3174, N, N),
+	PINGROUP(uart3_rxd_pw7,        UARTC,        RSVD2,        GMI,          RSVD4,        RSVD4,        0x3178, N, N),
+	PINGROUP(spi2_mosi_px0,        SPI6,         SPI2,         SPI3,         GMI,          GMI,          0x3368, N, N),
+	PINGROUP(spi2_miso_px1,        SPI6,         SPI2,         SPI3,         GMI,          GMI,          0x336c, N, N),
+	PINGROUP(spi2_sck_px2,         SPI6,         SPI2,         SPI3,         GMI,          GMI,          0x3374, N, N),
+	PINGROUP(spi2_cs0_n_px3,       SPI6,         SPI2,         SPI3,         GMI,          GMI,          0x3370, N, N),
+	PINGROUP(spi1_mosi_px4,        SPI2,         SPI1,         SPI2_ALT,     GMI,          GMI,          0x3378, N, N),
+	PINGROUP(spi1_sck_px5,         SPI2,         SPI1,         SPI2_ALT,     GMI,          GMI,          0x337c, N, N),
+	PINGROUP(spi1_cs0_n_px6,       SPI2,         SPI1,         SPI2_ALT,     GMI,          GMI,          0x3380, N, N),
+	PINGROUP(spi1_miso_px7,        SPI3,         SPI1,         SPI2_ALT,     RSVD4,        RSVD4,        0x3384, N, N),
+	PINGROUP(ulpi_clk_py0,         SPI1,         RSVD2,        UARTD,        ULPI,         RSVD2,        0x3020, N, N),
+	PINGROUP(ulpi_dir_py1,         SPI1,         RSVD2,        UARTD,        ULPI,         RSVD2,        0x3024, N, N),
+	PINGROUP(ulpi_nxt_py2,         SPI1,         RSVD2,        UARTD,        ULPI,         RSVD2,        0x3028, N, N),
+	PINGROUP(ulpi_stp_py3,         SPI1,         RSVD2,        UARTD,        ULPI,         RSVD2,        0x302c, N, N),
+	PINGROUP(sdmmc1_dat3_py4,      SDMMC1,       RSVD2,        UARTE,        UARTA,        RSVD2,        0x3050, N, N),
+	PINGROUP(sdmmc1_dat2_py5,      SDMMC1,       RSVD2,        UARTE,        UARTA,        RSVD2,        0x3054, N, N),
+	PINGROUP(sdmmc1_dat1_py6,      SDMMC1,       RSVD2,        UARTE,        UARTA,        RSVD2,        0x3058, N, N),
+	PINGROUP(sdmmc1_dat0_py7,      SDMMC1,       RSVD2,        UARTE,        UARTA,        RSVD2,        0x305c, N, N),
+	PINGROUP(sdmmc1_clk_pz0,       SDMMC1,       RSVD2,        RSVD3,        UARTA,        RSVD3,        0x3048, N, N),
+	PINGROUP(sdmmc1_cmd_pz1,       SDMMC1,       RSVD2,        RSVD3,        UARTA,        RSVD3,        0x304c, N, N),
+	PINGROUP(lcd_sdin_pz2,         DISPLAYA,     DISPLAYB,     SPI5,         RSVD4,        RSVD4,        0x3078, N, N),
+	PINGROUP(lcd_wr_n_pz3,         DISPLAYA,     DISPLAYB,     SPI5,         HDCP,         HDCP,         0x3080, N, N),
+	PINGROUP(lcd_sck_pz4,          DISPLAYA,     DISPLAYB,     SPI5,         HDCP,         HDCP,         0x308c, N, N),
+	PINGROUP(sys_clk_req_pz5,      SYSCLK,       RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3320, N, N),
+	PINGROUP(pwr_i2c_scl_pz6,      I2CPWR,       RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x32b4, Y, N),
+	PINGROUP(pwr_i2c_sda_pz7,      I2CPWR,       RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x32b8, Y, N),
+	PINGROUP(sdmmc4_dat0_paa0,     UARTE,        SPI3,         GMI,          SDMMC4,       SDMMC4,       0x3260, N, Y),
+	PINGROUP(sdmmc4_dat1_paa1,     UARTE,        SPI3,         GMI,          SDMMC4,       SDMMC4,       0x3264, N, Y),
+	PINGROUP(sdmmc4_dat2_paa2,     UARTE,        SPI3,         GMI,          SDMMC4,       SDMMC4,       0x3268, N, Y),
+	PINGROUP(sdmmc4_dat3_paa3,     UARTE,        SPI3,         GMI,          SDMMC4,       SDMMC4,       0x326c, N, Y),
+	PINGROUP(sdmmc4_dat4_paa4,     I2C3,         I2S4,         GMI,          SDMMC4,       SDMMC4,       0x3270, N, Y),
+	PINGROUP(sdmmc4_dat5_paa5,     VGP3,         I2S4,         GMI,          SDMMC4,       SDMMC4,       0x3274, N, Y),
+	PINGROUP(sdmmc4_dat6_paa6,     VGP4,         I2S4,         GMI,          SDMMC4,       SDMMC4,       0x3278, N, Y),
+	PINGROUP(sdmmc4_dat7_paa7,     VGP5,         I2S4,         GMI,          SDMMC4,       SDMMC4,       0x327c, N, Y),
+	PINGROUP(pbb0,                 I2S4,         RSVD2,        RSVD3,        SDMMC4,       RSVD3,        0x328c, N, N),
+	PINGROUP(cam_i2c_scl_pbb1,     VGP1,         I2C3,         RSVD3,        SDMMC4,       RSVD3,        0x3290, Y, N),
+	PINGROUP(cam_i2c_sda_pbb2,     VGP2,         I2C3,         RSVD3,        SDMMC4,       RSVD3,        0x3294, Y, N),
+	PINGROUP(pbb3,                 VGP3,         DISPLAYA,     DISPLAYB,     SDMMC4,       SDMMC4,       0x3298, N, N),
+	PINGROUP(pbb4,                 VGP4,         DISPLAYA,     DISPLAYB,     SDMMC4,       SDMMC4,       0x329c, N, N),
+	PINGROUP(pbb5,                 VGP5,         DISPLAYA,     DISPLAYB,     SDMMC4,       SDMMC4,       0x32a0, N, N),
+	PINGROUP(pbb6,                 VGP6,         DISPLAYA,     DISPLAYB,     SDMMC4,       SDMMC4,       0x32a4, N, N),
+	PINGROUP(pbb7,                 I2S4,         RSVD2,        RSVD3,        SDMMC4,       RSVD3,        0x32a8, N, N),
+	PINGROUP(cam_mclk_pcc0,        VI,           VI_ALT1,      VI_ALT3,      SDMMC4,       SDMMC4,       0x3284, N, N),
+	PINGROUP(pcc1,                 I2S4,         RSVD2,        RSVD3,        SDMMC4,       RSVD3,        0x3288, N, N),
+	PINGROUP(pcc2,                 I2S4,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x32ac, N, N),
+	PINGROUP(sdmmc4_rst_n_pcc3,    VGP6,         RSVD2,        RSVD3,        SDMMC4,       RSVD3,        0x3280, N, Y),
+	PINGROUP(sdmmc4_clk_pcc4,      INVALID,      NAND,         GMI,          SDMMC4,       SDMMC4,       0x3258, N, Y),
+	PINGROUP(clk2_req_pcc5,        DAP,          RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x306c, N, N),
+	PINGROUP(pex_l2_rst_n_pcc6,    PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33d8, N, N),
+	PINGROUP(pex_l2_clkreq_n_pcc7, PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33dc, N, N),
+	PINGROUP(pex_l0_prsnt_n_pdd0,  PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33b8, N, N),
+	PINGROUP(pex_l0_rst_n_pdd1,    PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33bc, N, N),
+	PINGROUP(pex_l0_clkreq_n_pdd2, PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33c0, N, N),
+	PINGROUP(pex_wake_n_pdd3,      PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33c4, N, N),
+	PINGROUP(pex_l1_prsnt_n_pdd4,  PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33c8, N, N),
+	PINGROUP(pex_l1_rst_n_pdd5,    PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33cc, N, N),
+	PINGROUP(pex_l1_clkreq_n_pdd6, PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33d0, N, N),
+	PINGROUP(pex_l2_prsnt_n_pdd7,  PCIE,         HDA,          RSVD3,        RSVD4,        RSVD4,        0x33d4, N, N),
+	PINGROUP(clk3_out_pee0,        EXTPERIPH3,   RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x31b8, N, N),
+	PINGROUP(clk3_req_pee1,        DEV3,         RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x31bc, N, N),
+	PINGROUP(clk1_req_pee2,        DAP,          HDA,          RSVD3,        RSVD4,        RSVD4,        0x3348, N, N),
+	PINGROUP(hdmi_cec_pee3,        CEC,          RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x33e0, Y, N),
+	PINGROUP(clk_32k_in,           CLK_32K_IN,   RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3330, N, N),
+	PINGROUP(core_pwr_req,         CORE_PWR_REQ, RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3324, N, N),
+	PINGROUP(cpu_pwr_req,          CPU_PWR_REQ,  RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x3328, N, N),
+	PINGROUP(owr,                  OWR,          CEC,          RSVD3,        RSVD4,        RSVD4,        0x3334, N, N),
+	PINGROUP(pwr_int_n,            PWR_INT_N,    RSVD2,        RSVD3,        RSVD4,        RSVD4,        0x332c, N, N),
+	/* pg_name, r, hsm_b, schmitt_b, lpmd_b, drvdn_b, drvdn_w, drvup_b, drvup_w, slwr_b, slwr_w, slwf_b, slwf_w */
+	DRV_PINGROUP(ao1,   0x868,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(ao2,   0x86c,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(at1,   0x870,  2,  3,  4,  14,  5,  19,  5,  24,  2,  28,  2),
+	DRV_PINGROUP(at2,   0x874,  2,  3,  4,  14,  5,  19,  5,  24,  2,  28,  2),
+	DRV_PINGROUP(at3,   0x878,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(at4,   0x87c,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(at5,   0x880,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(cdev1, 0x884,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(cdev2, 0x888,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(cec,   0x938,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(crt,   0x8f8,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(csus,  0x88c, -1, -1, -1,  12,  5,  19,  5,  24,  4,  28,  4),
+	DRV_PINGROUP(dap1,  0x890,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(dap2,  0x894,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(dap3,  0x898,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(dap4,  0x89c,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(dbg,   0x8a0,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(ddc,   0x8fc,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(dev3,  0x92c,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(gma,   0x900, -1, -1, -1,  14,  5,  19,  5,  24,  4,  28,  4),
+	DRV_PINGROUP(gmb,   0x904, -1, -1, -1,  14,  5,  19,  5,  24,  4,  28,  4),
+	DRV_PINGROUP(gmc,   0x908, -1, -1, -1,  14,  5,  19,  5,  24,  4,  28,  4),
+	DRV_PINGROUP(gmd,   0x90c, -1, -1, -1,  14,  5,  19,  5,  24,  4,  28,  4),
+	DRV_PINGROUP(gme,   0x910,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(gmf,   0x914,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(gmg,   0x918,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(gmh,   0x91c,  2,  3,  4,  14,  5,  19,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(gpv,   0x928,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(lcd1,  0x8a4,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(lcd2,  0x8a8,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(owr,   0x920,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(sdio1, 0x8ec,  2,  3, -1,  12,  7,  20,  7,  28,  2,  30,  2),
+	DRV_PINGROUP(sdio2, 0x8ac,  2,  3, -1,  12,  7,  20,  7,  28,  2,  30,  2),
+	DRV_PINGROUP(sdio3, 0x8b0,  2,  3, -1,  12,  7,  20,  7,  28,  2,  30,  2),
+	DRV_PINGROUP(spi,   0x8b4,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(uaa,   0x8b8,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(uab,   0x8bc,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(uart2, 0x8c0,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(uart3, 0x8c4,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(uda,   0x924,  2,  3,  4,  12,  5,  20,  5,  28,  2,  30,  2),
+	DRV_PINGROUP(vi1,   0x8c8, -1, -1, -1,  14,  5,  19,  5,  24,  4,  28,  4),
+};
+
+static const struct tegra_pinctrl_soc_data tegra30_pinctrl = {
+	.ngpios = NUM_GPIOS,
+	.pins = tegra30_pins,
+	.npins = ARRAY_SIZE(tegra30_pins),
+	.functions = tegra30_functions,
+	.nfunctions = ARRAY_SIZE(tegra30_functions),
+	.groups = tegra30_groups,
+	.ngroups = ARRAY_SIZE(tegra30_groups),
+};
+
+void __devinit tegra30_pinctrl_init(const struct tegra_pinctrl_soc_data **soc)
+{
+	*soc = &tegra30_pinctrl;
+}
-- 
1.7.0.4

