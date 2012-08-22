Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2HVIZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:25:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48138 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2HVIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:22:43 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
Date: Wed, 22 Aug 2012 10:22:22 +0200
Message-Id: <1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a pinctrl driver core for Marvell SoCs plus DT
binding documentation. This core driver will be used by SoC family
specific drivers, i.e. Armada XP, Armada 370, Dove, Kirkwood, aso.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
v2:
- restructured Kconfig to have a common PINCTRL_MVEBU that are selected by
  SoC specific drivers.
- cleaned pinctrl-mvebu and replaced 'magic numbers' by defines
- make use of of_iomap instead of get_resource/ioremap
- extended include documentation and checked with scripts/kernel-doc
- cleaned devicetree binding documentation

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt     |   45 ++
 arch/arm/Kconfig                                   |    1 +
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-mvebu.c                    |  761 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-mvebu.h                    |  192 +++++
 6 files changed, 1006 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.c
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.h

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
new file mode 100644
index 0000000..dc419e3
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
@@ -0,0 +1,45 @@
+* Marvell SoC pinctrl core driver for mpp
+
+The pinctrl driver enables Marvell SoCs to configure the multi-purpose pins
+(mpp) to a specific function. For each SoC family there is a SoC specific
+driver using this core driver.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+A Marvell SoC pin configuration node is a node of a group of pins which can
+be used for a specific device or function. Each node requires one or more
+mpp pins or group of pins and a mpp function common to all pins.
+
+Required properties for pinctrl driver:
+- compatible: "marvell,<soc>-pinctrl"
+  Please refer to each marvell,<soc>-pinctrl.txt binding doc for supported SoCs.
+
+Required properties for pin configuration node:
+- marvell,pins: string array of mpp pins or group of pins to be muxed.
+- marvell,function: string representing a function to mux to for all
+    marvell,pins given in this pin configuration node. The function has to be
+    common for all marvell,pins. Please refer to marvell,<soc>-pinctrl.txt for
+    valid pin/pin group names and available function names for each SoC.
+
+Examples:
+
+uart1: serial@12100 {
+	compatible = "ns16550a";
+	reg = <0x12100 0x100>;
+	reg-shift = <2>;
+	interrupts = <7>;
+
+	pinctrl-0 = <&pmx_uart1_sw>;
+};
+
+pinctrl: pinctrl@d0200 {
+	compatible = "marvell,dove-pinctrl";
+	reg = <0xd0200 0x20>;
+
+	pmx_uart1_sw: pmx-uart1-sw {
+		marvell,pins = "mpp_uart1";
+		marvell,function = "uart1";
+	};
+};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a2b6f74..2eb3f6b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -574,6 +574,7 @@ config ARCH_MVEBU
 	select IRQ_DOMAIN
 	select COMMON_CLK
 	select PLAT_ORION
+	select PINCTRL
 	help
 	  Support for the Marvell SoC Family with device tree support
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 54e3588..20bfdc3 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -145,6 +145,12 @@ config PINCTRL_COH901
 	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
 	  ports of 8 GPIO pins each.
 
+config PINCTRL_MVEBU
+	bool
+	depends on ARCH_MVEBU
+	select PINMUX
+	select PINCONF
+
 source "drivers/pinctrl/spear/Kconfig"
 
 endmenu
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index f40b1f8..007ed32 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -29,5 +29,6 @@ obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
+obj-$(CONFIG_PINCTRL_MVEBU)	+= pinctrl-mvebu.o
 
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/pinctrl/pinctrl-mvebu.c b/drivers/pinctrl/pinctrl-mvebu.c
new file mode 100644
index 0000000..5397765
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-mvebu.c
@@ -0,0 +1,761 @@
+/*
+ * Marvell MVEBU pinctrl core driver
+ *
+ * Authors: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *          Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "core.h"
+#include "pinctrl-mvebu.h"
+
+#define MPPS_PER_REG	8
+#define MPP_BITS	4
+#define MPP_MASK	0xf
+
+struct mvebu_pinctrl_function {
+	unsigned fid;
+	const char *name;
+	const char *setting;
+	const char **groups;
+	unsigned num_groups;
+};
+
+struct mvebu_pinctrl_group {
+	const char *name;
+	struct mvebu_mpp_ctrl *ctrl;
+	struct mvebu_mpp_ctrl_setting *settings;
+	unsigned num_settings;
+	unsigned gid;
+	unsigned *pins;
+	unsigned npins;
+};
+
+struct mvebu_pinctrl {
+	struct device *dev;
+	struct pinctrl_dev *pctldev;
+	struct pinctrl_desc desc;
+	void __iomem *base;
+	struct mvebu_pinctrl_group *groups;
+	unsigned num_groups;
+	struct mvebu_pinctrl_function *functions;
+	unsigned num_functions;
+	u8 variant;
+};
+
+struct mvebu_pinctrl_group *mvebu_pinctrl_find_group_by_pid(
+	struct mvebu_pinctrl *pctl, unsigned pid)
+{
+	unsigned n;
+	for (n = 0; n < pctl->num_groups; n++) {
+		if (pid >= pctl->groups[n].pins[0] &&
+		    pid < pctl->groups[n].pins[0] +
+			pctl->groups[n].npins)
+			return &pctl->groups[n];
+	}
+	return NULL;
+}
+
+struct mvebu_pinctrl_group *mvebu_pinctrl_find_group_by_name(
+	struct mvebu_pinctrl *pctl, const char *name)
+{
+	unsigned n;
+	for (n = 0; n < pctl->num_groups; n++) {
+		if (strcmp(name, pctl->groups[n].name) == 0)
+			return &pctl->groups[n];
+	}
+	return NULL;
+}
+
+struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_setting_by_val(
+	struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp,
+	unsigned long config)
+{
+	unsigned n;
+	for (n = 0; n < grp->num_settings; n++) {
+		if (config == grp->settings[n].val) {
+			if (!pctl->variant || (pctl->variant &
+					       grp->settings[n].variant))
+				return &grp->settings[n];
+		}
+	}
+	return NULL;
+}
+
+struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_setting_by_name(
+	struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp,
+	const char *name)
+{
+	unsigned n;
+	for (n = 0; n < grp->num_settings; n++) {
+		if (strcmp(name, grp->settings[n].name) == 0) {
+			if (!pctl->variant || (pctl->variant &
+					       grp->settings[n].variant))
+				return &grp->settings[n];
+		}
+	}
+	return NULL;
+}
+
+struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_gpio_setting(
+	struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp)
+{
+	unsigned n;
+	for (n = 0; n < grp->num_settings; n++) {
+		if (grp->settings[n].flags &
+			(MVEBU_SETTING_GPO | MVEBU_SETTING_GPI)) {
+			if (!pctl->variant || (pctl->variant &
+						grp->settings[n].variant))
+				return &grp->settings[n];
+		}
+	}
+	return NULL;
+}
+
+struct mvebu_pinctrl_function *mvebu_pinctrl_find_function_by_name(
+	struct mvebu_pinctrl *pctl, const char *name)
+{
+	unsigned n;
+	for (n = 0; n < pctl->num_functions; n++) {
+		if (strcmp(name, pctl->functions[n].name) == 0)
+			return &pctl->functions[n];
+	}
+	return NULL;
+}
+
+/*
+ * Common mpp pin configuration registers on MVEBU are
+ * registers of eight 4-bit values for each mpp setting.
+ * Register offset and bit mask are calculated accordingly below.
+ */
+static int mvebu_common_mpp_get(struct mvebu_pinctrl *pctl,
+				struct mvebu_pinctrl_group *grp,
+				unsigned long *config)
+{
+	unsigned pin = grp->gid;
+	unsigned off = (pin / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (pin % MPPS_PER_REG) * MPP_BITS;
+
+	*config = readl(pctl->base + off);
+	*config >>= shift;
+	*config &= MPP_MASK;
+
+	return 0;
+}
+
+static int mvebu_common_mpp_set(struct mvebu_pinctrl *pctl,
+				struct mvebu_pinctrl_group *grp,
+				unsigned long config)
+{
+	unsigned pin = grp->gid;
+	unsigned off = (pin / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (pin % MPPS_PER_REG) * MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(pctl->base + off);
+	reg &= ~(MPP_MASK << shift);
+	reg |= (config << shift);
+	writel(reg, pctl->base + off);
+
+	return 0;
+}
+
+static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
+				unsigned gid, unsigned long *config)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
+
+	if (!grp->ctrl)
+		return -EINVAL;
+
+	if (grp->ctrl->mpp_get)
+		return grp->ctrl->mpp_get(grp->ctrl, config);
+
+	return mvebu_common_mpp_get(pctl, grp, config);
+}
+
+static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
+				unsigned gid, unsigned long config)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
+
+	if (!grp->ctrl)
+		return -EINVAL;
+
+	if (grp->ctrl->mpp_set)
+		return grp->ctrl->mpp_set(grp->ctrl, config);
+
+	return mvebu_common_mpp_set(pctl, grp, config);
+}
+
+static void mvebu_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+					struct seq_file *s, unsigned gid)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
+	struct mvebu_mpp_ctrl_setting *curr;
+	unsigned long config;
+	unsigned n;
+
+	if (mvebu_pinconf_group_get(pctldev, gid, &config))
+		return;
+
+	curr = mvebu_pinctrl_find_setting_by_val(pctl, grp, config);
+
+	if (curr) {
+		seq_printf(s, "current: %s", curr->name);
+		if (curr->subname)
+			seq_printf(s, "(%s)", curr->subname);
+		if (curr->flags & (MVEBU_SETTING_GPO | MVEBU_SETTING_GPI)) {
+			seq_printf(s, "(");
+			if (curr->flags & MVEBU_SETTING_GPI)
+				seq_printf(s, "i");
+			if (curr->flags & MVEBU_SETTING_GPO)
+				seq_printf(s, "o");
+			seq_printf(s, ")");
+		}
+	} else
+		seq_printf(s, "current: UNKNOWN");
+
+	if (grp->num_settings > 1) {
+		seq_printf(s, ", available = [");
+		for (n = 0; n < grp->num_settings; n++) {
+			if (curr == &grp->settings[n])
+				continue;
+
+			/* skip unsupported settings for this variant */
+			if (pctl->variant &&
+			    !(pctl->variant & grp->settings[n].variant))
+				continue;
+
+			seq_printf(s, " %s", grp->settings[n].name);
+			if (grp->settings[n].subname)
+				seq_printf(s, "(%s)", grp->settings[n].subname);
+			if (grp->settings[n].flags &
+				(MVEBU_SETTING_GPO | MVEBU_SETTING_GPI)) {
+				seq_printf(s, "(");
+				if (grp->settings[n].flags & MVEBU_SETTING_GPI)
+					seq_printf(s, "i");
+				if (grp->settings[n].flags & MVEBU_SETTING_GPO)
+					seq_printf(s, "o");
+				seq_printf(s, ")");
+			}
+		}
+		seq_printf(s, " ]");
+	}
+	return;
+}
+
+struct pinconf_ops mvebu_pinconf_ops = {
+	.pin_config_group_get = mvebu_pinconf_group_get,
+	.pin_config_group_set = mvebu_pinconf_group_set,
+	.pin_config_group_dbg_show = mvebu_pinconf_group_dbg_show,
+};
+
+static int mvebu_pinmux_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->num_functions;
+}
+
+static const char *mvebu_pinmux_get_func_name(struct pinctrl_dev *pctldev,
+					unsigned fid)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctl->functions[fid].name;
+}
+
+static int mvebu_pinmux_get_groups(struct pinctrl_dev *pctldev, unsigned fid,
+				const char * const **groups,
+				unsigned * const num_groups)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = pctl->functions[fid].groups;
+	*num_groups = pctl->functions[fid].num_groups;
+	return 0;
+}
+
+static int mvebu_pinmux_enable(struct pinctrl_dev *pctldev, unsigned fid,
+			unsigned gid)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_function *func = &pctl->functions[fid];
+	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
+	struct mvebu_mpp_ctrl_setting *setting;
+	int ret;
+
+	setting = mvebu_pinctrl_find_setting_by_name(pctl, grp,
+						     func->setting);
+	if (!setting) {
+		dev_err(pctl->dev,
+			"unable to find setting %s in group %s\n",
+			func->setting, func->groups[gid]);
+		return -EINVAL;
+	}
+
+	ret = mvebu_pinconf_group_set(pctldev, grp->gid, setting->val);
+	if (ret) {
+		dev_err(pctl->dev, "cannot set group %s to %s\n",
+			func->groups[gid], func->setting);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mvebu_pinmux_gpio_request_enable(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range, unsigned offset)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_group *grp;
+	struct mvebu_mpp_ctrl_setting *setting;
+
+	grp = mvebu_pinctrl_find_group_by_pid(pctl, offset);
+	if (!grp)
+		return -EINVAL;
+
+	if (grp->ctrl->mpp_gpio_req)
+		return grp->ctrl->mpp_gpio_req(grp->ctrl, offset);
+
+	setting = mvebu_pinctrl_find_gpio_setting(pctl, grp);
+	if (!setting)
+		return -ENOTSUPP;
+
+	return mvebu_pinconf_group_set(pctldev, grp->gid, setting->val);
+}
+
+static int mvebu_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
+	   struct pinctrl_gpio_range *range, unsigned offset, bool input)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct mvebu_pinctrl_group *grp;
+	struct mvebu_mpp_ctrl_setting *setting;
+
+	grp = mvebu_pinctrl_find_group_by_pid(pctl, offset);
+	if (!grp)
+		return -EINVAL;
+
+	if (grp->ctrl->mpp_gpio_dir)
+		return grp->ctrl->mpp_gpio_dir(grp->ctrl, offset, input);
+
+	setting = mvebu_pinctrl_find_gpio_setting(pctl, grp);
+	if (!setting)
+		return -ENOTSUPP;
+
+	if ((input && (setting->flags & MVEBU_SETTING_GPI)) ||
+	    (!input && (setting->flags & MVEBU_SETTING_GPO)))
+		return 0;
+
+	return -ENOTSUPP;
+}
+
+static struct pinmux_ops mvebu_pinmux_ops = {
+	.get_functions_count = mvebu_pinmux_get_funcs_count,
+	.get_function_name = mvebu_pinmux_get_func_name,
+	.get_function_groups = mvebu_pinmux_get_groups,
+	.gpio_request_enable = mvebu_pinmux_gpio_request_enable,
+	.gpio_set_direction = mvebu_pinmux_gpio_set_direction,
+	.enable = mvebu_pinmux_enable,
+};
+
+static int mvebu_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	return pctl->num_groups;
+}
+
+static const char *mvebu_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
+						unsigned gid)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	return pctl->groups[gid].name;
+}
+
+static int mvebu_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+					unsigned gid, const unsigned **pins,
+					unsigned *num_pins)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	*pins = pctl->groups[gid].pins;
+	*num_pins = pctl->groups[gid].npins;
+	return 0;
+}
+
+static int mvebu_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+					struct device_node *np,
+					struct pinctrl_map **map,
+					unsigned *num_maps)
+{
+	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct property *prop;
+	const char *function;
+	const char *group;
+	int ret, nmaps, n;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = of_property_read_string(np, "marvell,function", &function);
+	if (ret) {
+		dev_err(pctl->dev,
+			"missing marvell,function in node %s\n", np->name);
+		return 0;
+	}
+
+	nmaps = of_property_count_strings(np, "marvell,pins");
+	if (nmaps < 0) {
+		dev_err(pctl->dev,
+			"missing marvell,pins in node %s\n", np->name);
+		return 0;
+	}
+
+	*map = kmalloc(nmaps * sizeof(struct pinctrl_map), GFP_KERNEL);
+	if (map == NULL) {
+		dev_err(pctl->dev,
+			"cannot allocate pinctrl_map memory for %s\n",
+			np->name);
+		return -ENOMEM;
+	}
+
+	n = 0;
+	of_property_for_each_string(np, "marvell,pins", prop, group) {
+		struct mvebu_pinctrl_group *grp =
+			mvebu_pinctrl_find_group_by_name(pctl, group);
+
+		if (!grp) {
+			dev_err(pctl->dev, "unknown pin %s", group);
+			continue;
+		}
+
+		if (!mvebu_pinctrl_find_setting_by_name(pctl, grp, function)) {
+			dev_err(pctl->dev, "unsupported function %s on pin %s",
+				function, group);
+			continue;
+		}
+
+		(*map)[n].type = PIN_MAP_TYPE_MUX_GROUP;
+		(*map)[n].data.mux.group = group;
+		(*map)[n].data.mux.function = np->name;
+		n++;
+	}
+
+	*num_maps = nmaps;
+
+	return 0;
+}
+
+static void mvebu_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				struct pinctrl_map *map, unsigned num_maps)
+{
+	kfree(map);
+}
+
+static struct pinctrl_ops mvebu_pinctrl_ops = {
+	.get_groups_count = mvebu_pinctrl_get_groups_count,
+	.get_group_name = mvebu_pinctrl_get_group_name,
+	.get_group_pins = mvebu_pinctrl_get_group_pins,
+	.dt_node_to_map = mvebu_pinctrl_dt_node_to_map,
+	.dt_free_map = mvebu_pinctrl_dt_free_map,
+};
+
+static int __devinit mvebu_pinctrl_dt_parse_function(struct mvebu_pinctrl *pctl,
+					struct device_node *np, unsigned idx)
+{
+	struct mvebu_pinctrl_function *func = &pctl->functions[idx];
+	struct property *prop;
+	const char *setting;
+	const char *group;
+	unsigned n = 0;
+	int ret, num_groups;
+
+	ret = of_property_read_string(np, "marvell,function", &setting);
+	if (ret) {
+		dev_err(pctl->dev,
+			"missing marvell,function in node %s\n", np->name);
+		return -EINVAL;
+	}
+
+	num_groups = of_property_count_strings(np, "marvell,pins");
+	if (num_groups <= 0) {
+		dev_err(pctl->dev,
+			"missing marvell,pins in node %s\n", np->name);
+		return -EINVAL;
+	}
+
+	func->fid = idx;
+	func->name = np->name;
+	func->setting = setting;
+	func->num_groups = num_groups;
+	func->groups = devm_kzalloc(pctl->dev, num_groups * sizeof(char *),
+				    GFP_KERNEL);
+	if (!func->groups) {
+		dev_err(pctl->dev,
+			"unable to alloc function groups\n");
+		return -ENOMEM;
+	}
+
+	of_property_for_each_string(np, "marvell,pins", prop, group) {
+		struct mvebu_pinctrl_group *grp =
+			mvebu_pinctrl_find_group_by_name(pctl, group);
+
+		if (!grp) {
+			dev_err(pctl->dev, "unknown pin %s", group);
+			return -EINVAL;
+		}
+
+		if (!mvebu_pinctrl_find_setting_by_name(pctl, grp, setting)) {
+			dev_err(pctl->dev, "unsupported function %s on pin %s",
+				setting, group);
+			return -EINVAL;
+		}
+
+		func->groups[n++] = group;
+	}
+	return 0;
+}
+
+static int __devinit mvebu_pinctrl_dt_parse(struct platform_device *pdev,
+					struct mvebu_pinctrl *pctl)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *np;
+	unsigned nfuncs = 0, n = 0;
+	int ret;
+
+	if (!node)
+		return -ENODEV;
+
+	nfuncs = of_get_child_count(node);
+	if (nfuncs <= 0) {
+		dev_warn(pctl->dev, "no function defined in device node\n");
+		return 0;
+	}
+
+	pctl->num_functions = nfuncs;
+	pctl->functions = devm_kzalloc(&pdev->dev, nfuncs *
+				sizeof(struct mvebu_pinctrl_function),
+				GFP_KERNEL);
+	if (!pctl->functions) {
+		dev_err(pctl->dev, "unable to alloc functions\n");
+		return -ENOMEM;
+	}
+
+	for_each_child_of_node(node, np) {
+		ret = mvebu_pinctrl_dt_parse_function(pctl, np, n++);
+		if (ret) {
+			dev_warn(pctl->dev, "failed to parse function %s\n",
+				np->name);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+int __devinit mvebu_pinctrl_probe(struct platform_device *pdev)
+{
+	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
+	struct mvebu_pinctrl *pctl;
+	void __iomem *base;
+	struct pinctrl_pin_desc *pdesc;
+	unsigned gid, n, k;
+	int ret;
+
+	if (!soc || !soc->controls || !soc->modes) {
+		dev_err(&pdev->dev, "wrong pinctrl soc info\n");
+		return -EINVAL;
+	}
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		dev_err(&pdev->dev, "unable to get base address\n");
+		return -ENODEV;
+	}
+
+	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
+			GFP_KERNEL);
+	if (!pctl) {
+		dev_err(&pdev->dev, "unable to alloc driver\n");
+		return -ENOMEM;
+	}
+
+	pctl->desc.name = dev_name(&pdev->dev);
+	pctl->desc.owner = THIS_MODULE;
+	pctl->desc.pctlops = &mvebu_pinctrl_ops;
+	pctl->desc.pmxops = &mvebu_pinmux_ops;
+	pctl->desc.confops = &mvebu_pinconf_ops;
+	pctl->variant = soc->variant;
+	pctl->base = base;
+	pctl->dev = &pdev->dev;
+	platform_set_drvdata(pdev, pctl);
+
+	/* count controls and create names for mvebu generic
+	   register controls; also does sanity checks */
+	pctl->num_groups = 0;
+	pctl->desc.npins = 0;
+	for (n = 0; n < soc->ncontrols; n++) {
+		struct mvebu_mpp_ctrl *ctrl = &soc->controls[n];
+		char *names;
+
+		pctl->desc.npins += ctrl->npins;
+		/* initial control pins */
+		for (k = 0; k < ctrl->npins; k++)
+			ctrl->pins[k] = ctrl->pid + k;
+
+		/* special soc specific control */
+		if (ctrl->mpp_get || ctrl->mpp_set) {
+			if (!ctrl->name || !ctrl->mpp_set || !ctrl->mpp_set) {
+				dev_err(&pdev->dev, "wrong soc control info\n");
+				return -EINVAL;
+			}
+			pctl->num_groups += 1;
+			continue;
+		}
+
+		/* generic mvebu register control */
+		names = devm_kzalloc(&pdev->dev, ctrl->npins * 8, GFP_KERNEL);
+		if (!names) {
+			dev_err(&pdev->dev, "failed to alloc mpp names\n");
+			return -ENOMEM;
+		}
+		for (k = 0; k < ctrl->npins; k++)
+			sprintf(names + 8*k, "mpp%d", ctrl->pid+k);
+		ctrl->name = names;
+		pctl->num_groups += ctrl->npins;
+	}
+
+	pdesc = devm_kzalloc(&pdev->dev, pctl->desc.npins *
+			     sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
+	if (!pdesc) {
+		dev_err(&pdev->dev, "failed to alloc pinctrl pins\n");
+		return -ENOMEM;
+	}
+
+	for (n = 0; n < pctl->desc.npins; n++)
+		pdesc[n].number = n;
+	pctl->desc.pins = pdesc;
+
+	pctl->groups = devm_kzalloc(&pdev->dev, pctl->num_groups *
+			     sizeof(struct mvebu_pinctrl_group), GFP_KERNEL);
+	if (!pctl->groups) {
+		dev_err(&pdev->dev, "failed to alloc pinctrl groups\n");
+		return -ENOMEM;
+	}
+
+	/* assign mpp controls to groups */
+	gid = 0;
+	for (n = 0; n < soc->ncontrols; n++) {
+		struct mvebu_mpp_ctrl *ctrl = &soc->controls[n];
+		pctl->groups[gid].gid = gid;
+		pctl->groups[gid].ctrl = ctrl;
+		pctl->groups[gid].name = ctrl->name;
+		pctl->groups[gid].pins = ctrl->pins;
+		pctl->groups[gid].npins = ctrl->npins;
+
+		/* generic mvebu register control maps to a number of groups */
+		if (!ctrl->mpp_get && !ctrl->mpp_set) {
+			pctl->groups[gid].npins = 1;
+
+			for (k = 1; k < ctrl->npins; k++) {
+				gid++;
+				pctl->groups[gid].gid = gid;
+				pctl->groups[gid].ctrl = ctrl;
+				pctl->groups[gid].name = &ctrl->name[8*k];
+				pctl->groups[gid].pins = &ctrl->pins[k];
+				pctl->groups[gid].npins = 1;
+			}
+		}
+		gid++;
+	}
+
+	/* assign mpp modes to groups */
+	for (n = 0; n < soc->nmodes; n++) {
+		struct mvebu_mpp_mode *mode = &soc->modes[n];
+		struct mvebu_pinctrl_group *grp =
+			mvebu_pinctrl_find_group_by_pid(pctl, mode->pid);
+		unsigned num_settings;
+
+		if (!grp) {
+			dev_warn(&pdev->dev, "unknown pinctrl group %d\n",
+				mode->pid);
+			continue;
+		}
+
+		for (num_settings = 0; ;) {
+			struct mvebu_mpp_ctrl_setting *set =
+				&mode->settings[num_settings];
+
+			if (!set->name)
+				break;
+			num_settings++;
+
+			/* skip unsupported settings for this variant */
+			if (pctl->variant && !(pctl->variant & set->variant))
+				continue;
+
+			/* find gpio/gpo/gpi settings */
+			if (strcmp(set->name, "gpio") == 0)
+				set->flags = MVEBU_SETTING_GPI |
+					MVEBU_SETTING_GPO;
+			else if (strcmp(set->name, "gpo") == 0)
+				set->flags = MVEBU_SETTING_GPO;
+			else if (strcmp(set->name, "gpi") == 0)
+				set->flags = MVEBU_SETTING_GPI;
+		}
+
+		grp->settings = mode->settings;
+		grp->num_settings = num_settings;
+	}
+
+	ret = mvebu_pinctrl_dt_parse(pdev, pctl);
+	if (ret) {
+		/* look for pinmux functions in platform_device data */
+		dev_err(&pdev->dev, "unable to parse device tree\n");
+		return ret;
+	}
+
+	pctl->pctldev = pinctrl_register(&pctl->desc, &pdev->dev, pctl);
+	if (!pctl->pctldev) {
+		dev_err(&pdev->dev, "unable to register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	dev_info(&pdev->dev, "registered pinctrl driver\n");
+
+	/* register gpio ranges */
+	for (n = 0; n < soc->ngpioranges; n++)
+		pinctrl_add_gpio_range(pctl->pctldev, &soc->gpioranges[n]);
+
+	return 0;
+}
+
+int __devexit mvebu_pinctrl_remove(struct platform_device *pdev)
+{
+	struct mvebu_pinctrl *pctl = platform_get_drvdata(pdev);
+	pinctrl_unregister(pctl->pctldev);
+	return 0;
+}
diff --git a/drivers/pinctrl/pinctrl-mvebu.h b/drivers/pinctrl/pinctrl-mvebu.h
new file mode 100644
index 0000000..90bd3be
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-mvebu.h
@@ -0,0 +1,192 @@
+/*
+ * Marvell MVEBU pinctrl driver
+ *
+ * Authors: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *          Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PINCTRL_MVEBU_H__
+#define __PINCTRL_MVEBU_H__
+
+/**
+ * struct mvebu_mpp_ctrl - describe a mpp control
+ * @name: name of the control group
+ * @pid: first pin id handled by this control
+ * @npins: number of pins controlled by this control
+ * @mpp_get: (optional) special function to get mpp setting
+ * @mpp_set: (optional) special function to set mpp setting
+ * @mpp_gpio_req: (optional) special function to request gpio
+ * @mpp_gpio_dir: (optional) special function to set gpio direction
+ *
+ * A mpp_ctrl describes a muxable unit, e.g. pin, group of pins, or
+ * internal function, inside the SoC. Each muxable unit can be switched
+ * between two or more different settings, e.g. assign mpp pin 13 to
+ * uart1 or sata.
+ *
+ * If optional mpp_get/_set functions are set these are used to get/set
+ * a specific mode. Otherwise it is assumed that the mpp control is based
+ * on 4-bit groups in subsequent registers. The optional mpp_gpio_req/_dir
+ * functions can be used to allow pin settings with varying gpio pins.
+ */
+struct mvebu_mpp_ctrl {
+	const char *name;
+	u8 pid;
+	u8 npins;
+	unsigned *pins;
+	int (*mpp_get)(struct mvebu_mpp_ctrl *ctrl, unsigned long *config);
+	int (*mpp_set)(struct mvebu_mpp_ctrl *ctrl, unsigned long config);
+	int (*mpp_gpio_req)(struct mvebu_mpp_ctrl *ctrl, u8 pid);
+	int (*mpp_gpio_dir)(struct mvebu_mpp_ctrl *ctrl, u8 pid, bool input);
+};
+
+/**
+ * struct mvebu_mpp_ctrl_setting - describe a mpp ctrl setting
+ * @val: ctrl setting value
+ * @name: ctrl setting name, e.g. uart2, spi0 - unique per mpp_mode
+ * @subname: (optional) additional ctrl setting name, e.g. rts, cts
+ * @variant: (optional) variant identifier mask
+ * @flags: (private) flags to store gpi/gpo/gpio capabilities
+ *
+ * A ctrl_setting describes a specific internal mux function that a mpp pin
+ * can be switched to. The value (val) will be written in the corresponding
+ * register for common mpp pin configuration registers on MVEBU. SoC specific
+ * mpp_get/_set function may use val to distinguish between different settings.
+ *
+ * The name will be used to switch to this setting in DT description, e.g.
+ * marvell,function = "uart2". subname is only for debugging purposes.
+ *
+ * If name is one of "gpi", "gpo", "gpio" gpio capabilities are
+ * parsed during initialization and stored in flags.
+ *
+ * The variant can be used to combine different revisions of one SoC to a
+ * common pinctrl driver. It is matched (AND) with variant of soc_info to
+ * determine if a setting is available on the current SoC revision.
+ */
+struct mvebu_mpp_ctrl_setting {
+	u8 val;
+	const char *name;
+	const char *subname;
+	u8 variant;
+	u8 flags;
+#define  MVEBU_SETTING_GPO	(1 << 0)
+#define  MVEBU_SETTING_GPI	(1 << 1)
+};
+
+/**
+ * struct mvebu_mpp_mode - link ctrl and settings
+ * @pid: first pin id handled by this mode
+ * @settings: list of settings available for this mode
+ *
+ * A mode connects all available settings with the corresponding mpp_ctrl
+ * given by pid.
+ */
+struct mvebu_mpp_mode {
+	u8 pid;
+	struct mvebu_mpp_ctrl_setting *settings;
+};
+
+/**
+ * struct mvebu_pinctrl_soc_info - SoC specific info passed to pinctrl-mvebu
+ * @variant: variant mask of soc_info
+ * @controls: list of available mvebu_mpp_ctrls
+ * @ncontrols: number of available mvebu_mpp_ctrls
+ * @modes: list of available mvebu_mpp_modes
+ * @nmodes: number of available mvebu_mpp_modes
+ * @gpioranges: list of pinctrl_gpio_ranges
+ * @ngpioranges: number of available pinctrl_gpio_ranges
+ *
+ * This struct describes all pinctrl related information for a specific SoC.
+ * If variant is unequal 0 it will be matched (AND) with variant of each
+ * setting and allows to distinguish between different revisions of one SoC.
+ */
+struct mvebu_pinctrl_soc_info {
+	u8 variant;
+	struct mvebu_mpp_ctrl *controls;
+	int ncontrols;
+	struct mvebu_mpp_mode *modes;
+	int nmodes;
+	struct pinctrl_gpio_range *gpioranges;
+	int ngpioranges;
+};
+
+#define MPP_REG_CTRL(_idl, _idh)				\
+	{							\
+		.name = NULL,					\
+		.pid = _idl,					\
+		.npins = _idh - _idl + 1,			\
+		.pins = (unsigned[_idh - _idl + 1]) { },	\
+		.mpp_get = NULL,				\
+		.mpp_set = NULL,				\
+		.mpp_gpio_req = NULL,				\
+		.mpp_gpio_dir = NULL,				\
+	}
+
+#define MPP_FUNC_CTRL(_idl, _idh, _name, _func)			\
+	{							\
+		.name = _name,					\
+		.pid = _idl,					\
+		.npins = _idh - _idl + 1,			\
+		.pins = (unsigned[_idh - _idl + 1]) { },	\
+		.mpp_get = _func ## _get,			\
+		.mpp_set = _func ## _set,			\
+		.mpp_gpio_req = NULL,				\
+		.mpp_gpio_dir = NULL,				\
+	}
+
+#define MPP_FUNC_GPIO_CTRL(_idl, _idh, _name, _func)		\
+	{							\
+		.name = _name,					\
+		.pid = _idl,					\
+		.npins = _idh - _idl + 1,			\
+		.pins = (unsigned[_idh - _idl + 1]) { },	\
+		.mpp_get = _func ## _get,			\
+		.mpp_set = _func ## _set,			\
+		.mpp_gpio_req = _func ## _gpio_req,		\
+		.mpp_gpio_dir = _func ## _gpio_dir,		\
+	}
+
+#define _MPP_VAR_FUNCTION(_val, _name, _subname, _mask)		\
+	{							\
+		.val = _val,					\
+		.name = _name,					\
+		.subname = _subname,				\
+		.variant = _mask,				\
+		.flags = 0,					\
+	}
+
+#if defined(CONFIG_DEBUG_FS)
+#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)		\
+	_MPP_VAR_FUNCTION(_val, _name, _subname, _mask)
+#else
+#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)		\
+	_MPP_VAR_FUNCTION(_val, _name, NULL, _mask)
+#endif
+
+#define MPP_FUNCTION(_val, _name, _subname)			\
+	MPP_VAR_FUNCTION(_val, _name, _subname, (u8)-1)
+
+#define MPP_MODE(_id, ...)					\
+	{							\
+		.pid = _id,					\
+		.settings = (struct mvebu_mpp_ctrl_setting[]){	\
+			__VA_ARGS__, { } },			\
+	}
+
+#define MPP_GPIO_RANGE(_id, _pinbase, _gpiobase, _npins)	\
+	{							\
+		.name = "mvebu-gpio",				\
+		.id = _id,					\
+		.pin_base = _pinbase,				\
+		.base = _gpiobase,				\
+		.npins = _npins,				\
+	}
+
+int mvebu_pinctrl_probe(struct platform_device *pdev);
+int mvebu_pinctrl_remove(struct platform_device *pdev);
+
+#endif
-- 
1.7.10.4

