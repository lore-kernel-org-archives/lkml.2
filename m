Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2DTOs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:48:28 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14413
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab2DTOs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:48:26 -0400
X-SpamScore: 0
X-BigFish: VS0(zz1102I154dMc8kzz1202h1082kzz8275dh84d07hz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>
Subject: [PATCH v2 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Date: Fri, 20 Apr 2012 22:58:34 +0800
Message-ID: <1334933916-12971-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The driver has mux and config support while the gpio is still
not supported.
For select input setting, the driver will handle it internally
and do not need user to take care of it.

The pinctrl-imx core driver will parse the dts file and dynamically
create the pinmux functions and groups.

Each IMX SoC pinctrl driver should register pins with a pin register map
including mux register and config register and select input map to core
for proper operations.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
ChangeLog: v1->v2:
* Change the binding a bit.
  For fsl,pins property, change it from pin name strings to pin function id
  which represents a pin working on a specific function. Then we can remove
  fsl,mux property since the pin function id already contains the mux setting.
  Also remove other pin config property in the first patch.
  Because in the future, we will switch to use dtc macro, then using a lot of
  propertys to represent the each pin config like pull, speed and etc seems
  needless.
  Then each pin entry in dts file becomes a pair of PIN_FUNC_ID and CONFIG:
  fsl,pins = <PIN_FUNC_ID CONFIG ..>
  See binding doc for details.
* Sascha raised a question that pins in the same group may have different
  pad setting for example I2C_CLK needs pull up while I2C_DAT not.
  The v1 driver can aslo handle this issue but needs split the different
  pad setting pins into different groups which loses a bit flexibility.
  Also suggested by Richard Zhao and Jason Liu, we may still want the iomux
  v3 simililar using way that allows each pin has the abiblity to configure
  its pad which seems reasonable because from HW point of view, FSL IMX are
  indeed pin based SoC which should be able to set per pin.
  So the main changes in this v2 patch are change to support per pin config.
  Then the using of iomux is almost the same as the existing iomux v3 for
  non dt imx platforms. See binding doc for example.

  After introduce the new way, there're mainly two known issues:
  1) Since many pins in the same group may have the same pad config setting,
     thus there may be some data redundance, however, since it's one word
     and it's purely describe hw i would think it's not a big issue.
  2) Need a magic number to indicate no pad config need. In current iomux v3,
     It's 1<<16 which is not used by IMX5, i used 1<<31 for both MX5 and MX6.
     However, it's definitely possibile that in the future, the bit 31 may also
     be used, that means we may need change the binding doc or just handle it in
     driver for different SoCs.
  3) Due to core limitation, the current pinconf_group_set/get only support
     get/set the same config(a u32 value)for all the pins in the same group,
     so i removed the imx_group_set/get functions support, instead, using
     imx_pin_get/set.
     About this limitation, we may need some futher discussion on if we may
     need to enhance it to be more flexible to support configure different
     pins in the same group.
* Refactor probe handling based on Stephen's suggestion.
* Enhanced the binding doc and split it into two part, pinctrl-imx common part
  and pinctrl-soc driver part.
* Change functions name from imx_pmx_* to imx_pinctrl_*.
* Other fixes based on Sascha, Stephen, Linus, Shawn's comments.
---
 .../bindings/pinctrl/fsl,imx-pinctrl.txt           |   84 +++
 drivers/pinctrl/Kconfig                            |    5 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-imx.c                      |  624 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.h                      |  105 ++++
 5 files changed, 819 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
new file mode 100644
index 0000000..5ad9c6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/fsl,imx-pinctrl.txt
@@ -0,0 +1,84 @@
+* Freescale IOMUX Controller (IOMUXC) for i.MX
+
+The IOMUX Controller (IOMUXC), together with the IOMUX, enables the IC
+to share one PAD to several functional blocks. The sharing is done by
+multiplexing the PAD input/output signals. For each PAD there are up to
+8 muxing options (called ALT modes). Since different modules require
+different PAD settings (like pull up, keeper, etc) the IOMUXC controls
+also the PAD settings parameters.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Freescale IMX pin configuration node is a node of a group of pins which can be
+used for a specific device or function. This node represents both mux and config
+of the pins in that group. The 'mux' selects the function mode(also named mux
+mode) this pin can work on and the 'config' configures various pad settings
+such as pull-up, open drain, drive strength, etc.
+
+Required properties for iomux controller:
+- compatible: "fsl,<soc>-iomuxc"
+  Please refer to each fsl,<soc>-pinctrl.txt binding doc for supported SoCs.
+
+Required properties for pin configuration node:
+- fsl,pins: two integers array, represents a group of pins mux and config
+  setting. The format is fsl,pins = <PIN_FUNC_ID CONFIG>, PIN_FUNC_ID is a
+  pin working on a specific function, CONFIG is the pad setting value like
+  pull-up on this pin. Please refer to fsl,<soc>-pinctrl.txt for the valid
+  pins and functions of each SoC.
+  Note currently we are using supplying a magic number(0x80000000) in
+  CONFIG to indicate this pin does not need config since this bit is not
+  used in current IMX families.
+
+NOTE:
+Some requirements for using fsl,imx-pinctrl binding:
+1. The pin configuration node should be defined under an abstract function
+   node. The function node's name should represent what function the group
+   of pins of this pin configuration node are working on.
+2. The function nodes should be defined under iomux controller node
+3. The driver can use the function node's name and pin configuration node's
+   name describe the pins using hierarchy.
+   For example, Linux IMX pinctrl driver takes the function node's name
+   as the function name and pin configuration node's name as group name to
+   create the map table.
+4. Each pin configuration node should have a phandle, devices can set pins
+   configurations by referring to the phandle of that pin configuration node.
+
+Examples:
+usdhc@0219c000 { /* uSDHC4 */
+	fsl,card-wired;
+	vmmc-supply = <&reg_3p3v>;
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usdhc4_1>;
+};
+
+iomuxc@020e0000 {
+	compatible = "fsl,imx6q-iomuxc";
+	reg = <0x020e0000 0x4000>;
+
+	/* shared pinctrl settings */
+	usdhc4 {
+		pinctrl_usdhc4_1: usdhc4grp-1 {
+			fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
+				    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
+				    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
+				    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
+				    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
+				    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
+				    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
+				    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
+				    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
+				    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
+		};
+	};
+	....
+};
+Refer to the IOMUXC controller chapter in imx6q datasheet,
+0x17059 means enable hysteresis, 47KOhm Pull Up, 50Mhz speed,
+80Ohm driver strength and Fast Slew Rate.
+User should refer to each SoC spec to set the correct value.
+
+TODO: when dtc macro support is available, we can change above raw data
+to dt macro which can get better readability in dts file.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f73a5ea..aad2882 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -26,6 +26,11 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINCTRL_IMX
+	bool
+	select PINMUX
+	select PINCONF
+
 config PINCTRL_PXA3xx
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 8e3c95a..a01a97c 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -9,6 +9,7 @@ ifeq ($(CONFIG_OF),y)
 obj-$(CONFIG_PINCTRL)		+= devicetree.o
 endif
 obj-$(CONFIG_GENERIC_PINCONF)	+= pinconf-generic.o
+obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
 obj-$(CONFIG_PINCTRL_PXA3xx)	+= pinctrl-pxa3xx.o
 obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
 obj-$(CONFIG_PINCTRL_PXA168)	+= pinctrl-pxa168.o
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
new file mode 100644
index 0000000..222682c
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -0,0 +1,624 @@
+/*
+ * Core driver for the imx pin controller
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/slab.h>
+
+#include "core.h"
+#include "pinctrl-imx.h"
+
+#define IMX_PMX_DUMP(info, p, m, c, n)		\
+{						\
+	int i, j;				\
+	printk("Format: Pin Mux Config\n");	\
+	for (i = 0; i < n; i++) {		\
+		j = p[i];			\
+		printk("%s %d 0x%lx\n",		\
+			info->pins[j].name,	\
+			m[i], c[i]);		\
+	}					\
+}
+
+/*
+ * The magic number to indicate no pin config need. This bit currently is used
+ * in IMX SoC families.
+ */
+#define IMX_NO_PAD_CTL	0x80000000
+
+/**
+ * @dev: a pointer back to containing device
+ * @base: the offset to the controller in virtual memory
+ */
+struct imx_pinctrl {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	void __iomem *base;
+	const struct imx_pinctrl_soc_info *info;
+};
+
+static const struct imx_pin_reg *imx_find_pin_reg(
+				const struct imx_pinctrl_soc_info *info,
+				unsigned pin, bool is_mux, unsigned mux)
+{
+	const struct imx_pin_reg *pin_reg = NULL;
+	int i;
+
+	for (i = 0; i < info->npin_regs; i++) {
+		pin_reg = &info->pin_regs[i];
+		if (pin_reg->pid != pin)
+			continue;
+		if (!is_mux)
+			break;
+		else if (pin_reg->mux_mode == (mux & IMX_MUX_MASK))
+			break;
+	}
+
+	if (!pin_reg) {
+		dev_err(info->dev, "Pin(%s): unable to find pin reg map\n",
+			info->pins[pin].name);
+		return NULL;
+	}
+
+	return pin_reg;
+}
+
+static const inline struct imx_pin_group *imx_pinctrl_find_group_by_name(
+				const struct imx_pinctrl_soc_info *info,
+				const char *name)
+{
+	const struct imx_pin_group *grp = NULL;
+	int i;
+
+	for (i = 0; i < info->ngroups; i++) {
+		if (!strcmp(info->groups[i].name, name)) {
+			grp = &info->groups[i];
+			break;
+		}
+	}
+
+	return grp;
+}
+
+static int imx_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	return info->ngroups;
+}
+
+static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	return info->groups[selector].name;
+}
+
+static int imx_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       const unsigned **pins,
+			       unsigned *npins)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	if (selector >= info->ngroups)
+		return -EINVAL;
+
+	*pins = info->groups[selector].pins;
+	*npins = info->groups[selector].npins;
+
+	return 0;
+}
+
+static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
+		   unsigned offset)
+{
+	seq_printf(s, "%s", dev_name(pctldev->dev));
+}
+
+static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
+			struct device_node *np,
+			struct pinctrl_map **map, unsigned *num_maps)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_group *grp;
+	struct pinctrl_map *new_map;
+	struct device_node *parent;
+	int map_num = 1;
+	int i;
+
+	/*
+	 * first find the group of this node and check if we need create
+	 * config maps for pins
+	 */
+	grp = imx_pinctrl_find_group_by_name(info, np->name);
+	if (!grp) {
+		dev_err(info->dev, "unable to find group for node %s\n",
+			np->name);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < grp->npins; i++) {
+		if (!(grp->configs[i] & IMX_NO_PAD_CTL))
+			map_num++;
+	}
+
+	new_map = kmalloc(sizeof(struct pinctrl_map) * map_num, GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	*map = new_map;
+	*num_maps = map_num;
+
+	/* create mux map */
+	parent = of_get_parent(np);
+	if (!parent)
+		return -EINVAL;
+	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
+	new_map[0].data.mux.function = parent->name;
+	new_map[0].data.mux.group = np->name;
+	of_node_put(parent);
+
+	/* create config map */
+	new_map++;
+	for (i = 0; i < grp->npins; i++) {
+		if (!(grp->configs[i] & IMX_NO_PAD_CTL)) {
+			new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
+			new_map[i].data.configs.group_or_pin =
+					pin_get_name(pctldev, grp->pins[i]);
+			new_map[i].data.configs.configs = &grp->configs[i];
+			new_map[i].data.configs.num_configs = 1;
+		}
+	}
+
+	dev_dbg(pctldev->dev, "maps: function %s group %s num %d\n",
+		new_map->data.mux.function, new_map->data.mux.group, map_num);
+
+	return 0;
+}
+
+static void imx_dt_free_map(struct pinctrl_dev *pctldev,
+				struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		kfree(map);
+}
+
+static struct pinctrl_ops imx_pctrl_ops = {
+	.get_groups_count = imx_get_groups_count,
+	.get_group_name = imx_get_group_name,
+	.get_group_pins = imx_get_group_pins,
+	.pin_dbg_show = imx_pin_dbg_show,
+	.dt_node_to_map = imx_dt_node_to_map,
+	.dt_free_map = imx_dt_free_map,
+
+};
+
+static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
+			   unsigned group)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+	const unsigned *pins, *mux;
+	unsigned int npins, pin_id;
+	int i;
+
+	/*
+	 * Configure the mux mode for each pin in the group for a specific
+	 * function.
+	 */
+	pins = info->groups[group].pins;
+	npins = info->groups[group].npins;
+	mux = info->groups[group].mux_mode;
+
+	WARN_ON(!pins || !npins || !mux);
+
+	dev_dbg(ipctl->dev, "enable function %s group %s\n",
+		info->functions[selector].name, info->groups[group].name);
+
+	for (i = 0; i < npins; i++) {
+		pin_id = pins[i];
+
+		pin_reg = imx_find_pin_reg(info, pin_id, 1, mux[i]);
+		if (!pin_reg)
+			return -EINVAL;
+
+		if (!pin_reg->mux_reg) {
+			dev_err(ipctl->dev, "Pin(%s) does not support mux function\n",
+				info->pins[pin_id].name);
+			return -EINVAL;
+		}
+
+		writel(mux[i], ipctl->base + pin_reg->mux_reg);
+		dev_dbg(ipctl->dev, "write: offset 0x%x val 0x%x\n",
+			pin_reg->mux_reg, mux[i]);
+
+		/* some pins also need select input setting, set it if found */
+		if (pin_reg->input_reg) {
+			writel(pin_reg->input_val, ipctl->base + pin_reg->input_reg);
+			dev_dbg(ipctl->dev,
+				"==>select_input: offset 0x%x val 0x%x\n",
+				pin_reg->input_reg, pin_reg->input_val);
+		}
+	}
+
+	return 0;
+}
+
+static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned func_selector,
+			    unsigned group_selector)
+{
+	/* nothing to do here */
+}
+
+static int imx_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	return info->nfunctions;
+}
+
+static const char *imx_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					  unsigned selector)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	return info->functions[selector].name;
+}
+
+static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
+			       const char * const **groups,
+			       unsigned * const num_groups)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+
+	*groups = info->functions[selector].groups;
+	*num_groups = info->functions[selector].num_groups;
+
+	return 0;
+}
+
+static struct pinmux_ops imx_pmx_ops = {
+	.get_functions_count = imx_pmx_get_funcs_count,
+	.get_function_name = imx_pmx_get_func_name,
+	.get_function_groups = imx_pmx_get_groups,
+	.enable = imx_pmx_enable,
+	.disable = imx_pmx_disable,
+};
+
+static int imx_pinconf_get(struct pinctrl_dev *pctldev,
+			     unsigned pin_id, unsigned long *config)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg)
+		return -EINVAL;
+
+	if (!pin_reg->conf_reg) {
+		dev_err(info->dev, "Pin(%s) does not support config function\n",
+			info->pins[pin_id].name);
+		return -EINVAL;
+	}
+
+	*config = readl(ipctl->base + pin_reg->conf_reg);
+
+	return 0;
+}
+
+static int imx_pinconf_set(struct pinctrl_dev *pctldev,
+			     unsigned pin_id, unsigned long config)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg)
+		return -EINVAL;
+
+	if (!pin_reg->conf_reg) {
+		dev_err(info->dev, "Pin(%s) does not support config function\n",
+			info->pins[pin_id].name);
+		return -EINVAL;
+	}
+
+	dev_dbg(ipctl->dev, "pinconf set pin %s\n",
+		info->pins[pin_id].name);
+
+	writel(config, ipctl->base + pin_reg->conf_reg);
+	dev_dbg(ipctl->dev, "write: offset 0x%x val 0x%lx\n",
+		pin_reg->conf_reg, config);
+
+	return 0;
+}
+
+static void imx_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				   struct seq_file *s, unsigned pin_id)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	const struct imx_pin_reg *pin_reg;
+	unsigned long config;
+
+	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
+	if (!pin_reg || !pin_reg->conf_reg) {
+		seq_printf(s, "N/A");
+		return;
+	}
+
+	config = readl(ipctl->base + pin_reg->conf_reg);
+	seq_printf(s, "0x%lx", config);
+}
+
+static void imx_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+					 struct seq_file *s, unsigned group)
+{
+	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
+	const struct imx_pinctrl_soc_info *info = ipctl->info;
+	struct imx_pin_group *grp;
+	unsigned long config;
+	const char *name;
+	int i, ret;
+
+	if (group > info->ngroups)
+		return;
+
+	seq_printf(s, "\n");
+	grp = &info->groups[group];
+	for (i = 0; i < grp->npins; i++) {
+		name = pin_get_name(pctldev, grp->pins[i]);
+		ret = imx_pinconf_get(pctldev, grp->pins[i], &config);
+		if (ret)
+			return;
+		seq_printf(s, "%s: 0x%lx", name, config);
+	}
+}
+
+struct pinconf_ops imx_pinconf_ops = {
+	.pin_config_get = imx_pinconf_get,
+	.pin_config_set = imx_pinconf_set,
+	.pin_config_dbg_show = imx_pinconf_dbg_show,
+	.pin_config_group_dbg_show = imx_pinconf_group_dbg_show,
+};
+
+static struct pinctrl_desc imx_pinctrl_desc = {
+	.pctlops = &imx_pctrl_ops,
+	.pmxops = &imx_pmx_ops,
+	.confops = &imx_pinconf_ops,
+	.owner = THIS_MODULE,
+};
+
+/* decode pin id and mux from pin function id got from device tree*/
+static int imx_pinctrl_get_pin_id_and_mux(const struct imx_pinctrl_soc_info *info,
+				unsigned int pin_func_id, unsigned int *pin_id,
+				unsigned int *mux)
+{
+	if (pin_func_id > info->npin_regs)
+		return -EINVAL;
+
+	*pin_id = info->pin_regs[pin_func_id].pid;
+	*mux = info->pin_regs[pin_func_id].mux_mode;
+
+	return 0;
+}
+
+static int __devinit imx_pinctrl_parse_groups(struct device_node *np,
+				struct imx_pin_group *grp,
+				struct imx_pinctrl_soc_info *info,
+				u32 index)
+{
+	unsigned int pin_func_id;
+	int ret, size;
+	const const __be32 *list;
+	int i, j;
+
+	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
+
+	/* Initialise group */
+	grp->name = np->name;
+
+	/*
+	 * the binding format is fsl,pins = <PIN_FUNC_ID CONFIG ...>,
+	 * do sanity check and calculate pins number
+	 */
+	list = of_get_property(np, "fsl,pins", &size);
+	/* we do not check return since it's safe node passed down */
+	size /= sizeof(*list);
+	if (!size || size % 2) {
+		dev_err(info->dev, "wrong pins number or pins and configs should be pairs\n");
+		return -EINVAL;
+	}
+
+	grp->npins = size / 2;
+	grp->pins = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned int),
+				GFP_KERNEL);
+	grp->mux_mode = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned int),
+				GFP_KERNEL);
+	grp->configs = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned long),
+				GFP_KERNEL);
+	for (i = 0, j = 0; i < size; i += 2, j++) {
+		pin_func_id = be32_to_cpu(*list++);
+		ret = imx_pinctrl_get_pin_id_and_mux(info, pin_func_id,
+					&grp->pins[j], &grp->mux_mode[j]);
+		if (ret) {
+			dev_err(info->dev, "get invalid pin function id\n");
+			return -EINVAL;
+		}
+		grp->configs[j] = be32_to_cpu(*list++);
+	}
+
+#ifdef DEBUG
+	IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
+#endif
+	return 0;
+}
+
+static int __devinit imx_pinctrl_parse_functions(struct device_node *np,
+			struct imx_pinctrl_soc_info *info, u32 index)
+{
+	struct device_node *child;
+	struct imx_pmx_func *func;
+	struct imx_pin_group *grp;
+	int ret;
+	static u32 grp_index;
+	u32 i = 0;
+
+	dev_dbg(info->dev, "parse function(%d): %s\n", index, np->name);
+
+	func = &info->functions[index];
+
+	/* Initialise function */
+	func->name = np->name;
+	func->num_groups = of_get_child_count(np);
+	if (func->num_groups <= 0) {
+		dev_err(info->dev, "no groups defined\n");
+		return -EINVAL;
+	}
+	func->groups = devm_kzalloc(info->dev,
+			func->num_groups * sizeof(char *), GFP_KERNEL);
+
+	for_each_child_of_node(np, child) {
+		func->groups[i] = child->name;
+		grp = &info->groups[grp_index++];
+		ret = imx_pinctrl_parse_groups(child, grp, info, i++);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int __devinit imx_pinctrl_probe_dt(struct platform_device *pdev,
+				struct imx_pinctrl_soc_info *info)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *child;
+	int ret;
+	u32 nfuncs = 0;
+	u32 i = 0;
+
+	if (!np)
+		return -ENODEV;
+
+	nfuncs = of_get_child_count(np);
+	if (nfuncs <= 0) {
+		dev_err(&pdev->dev, "no functions defined\n");
+		return -EINVAL;
+	}
+
+	info->nfunctions = nfuncs;
+	info->functions = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pmx_func),
+					GFP_KERNEL);
+	if (!info->functions)
+		return -ENOMEM;
+
+	info->ngroups = 0;
+	for_each_child_of_node(np, child)
+		info->ngroups += of_get_child_count(child);
+	info->groups = devm_kzalloc(&pdev->dev, info->ngroups * sizeof(struct imx_pin_group),
+					GFP_KERNEL);
+	if (!info->groups)
+		return -ENOMEM;
+
+	for_each_child_of_node(np, child) {
+		ret = imx_pinctrl_parse_functions(child, info, i++);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to parse function\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+int __devinit imx_pinctrl_probe(struct platform_device *pdev,
+				struct imx_pinctrl_soc_info *info)
+{
+	struct imx_pinctrl *ipctl;
+	struct resource *res;
+	int ret;
+
+	if (!info || !info->pins || !info->npins
+		  || !info->pin_regs || !info->npin_regs) {
+		dev_err(&pdev->dev, "wrong pinctrl info\n");
+		return -EINVAL;
+	}
+	info->dev = &pdev->dev;
+
+	/* Create state holders etc for this driver */
+	ipctl = devm_kzalloc(&pdev->dev, sizeof(*ipctl), GFP_KERNEL);
+	if (!ipctl)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
+	ipctl->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!ipctl->base)
+		return -EBUSY;
+
+	imx_pinctrl_desc.name = dev_name(&pdev->dev);
+	imx_pinctrl_desc.pins = info->pins;
+	imx_pinctrl_desc.npins = info->npins;
+
+	ret = imx_pinctrl_probe_dt(pdev, info);
+	if (ret) {
+		dev_err(&pdev->dev, "fail to probe dt properties\n");
+		return ret;
+	}
+
+	ipctl->info = info;
+	ipctl->dev = info->dev;
+	platform_set_drvdata(pdev, ipctl);
+	ipctl->pctl = pinctrl_register(&imx_pinctrl_desc, &pdev->dev, ipctl);
+	if (!ipctl->pctl) {
+		dev_err(&pdev->dev, "could not register IMX pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	dev_info(&pdev->dev, "initialized IMX pinctrl driver\n");
+
+	return 0;
+}
+
+int __devexit imx_pinctrl_remove(struct platform_device *pdev)
+{
+	struct imx_pinctrl *ipctl = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(ipctl->pctl);
+
+	return 0;
+}
diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/pinctrl-imx.h
new file mode 100644
index 0000000..6b05b9c
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-imx.h
@@ -0,0 +1,105 @@
+/*
+ * IMX pinmux core definitions
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DRIVERS_PINCTRL_IMX_H
+#define __DRIVERS_PINCTRL_IMX_H
+
+struct platform_device;
+
+/**
+ * struct imx_pin_group - describes an IMX pin group
+ * @name: the name of this specific pin group
+ * @pins: an array of discrete physical pins used in this group, taken
+ *	from the driver-local pin enumeration space
+ * @npins: the number of pins in this group array, i.e. the number of
+ *	elements in .pins so we can iterate over that array
+ * @mux_mode: the mux mode for each pin in this group. The size of this
+ *	array is the same as pins.
+ * @configs: the config for each pin in this group. The size of this
+ *	array is the same as pins.
+ */
+struct imx_pin_group {
+	const char *name;
+	unsigned int *pins;
+	unsigned npins;
+	unsigned int *mux_mode;
+	unsigned long *configs;
+};
+
+/**
+ * struct imx_pmx_func - describes IMX pinmux functions
+ * @name: the name of this specific function
+ * @groups: corresponding pin groups
+ * @num_groups: the number of groups
+ */
+struct imx_pmx_func {
+	const char *name;
+	const char **groups;
+	unsigned num_groups;
+};
+
+/**
+ * struct imx_pin_reg - describe a pin reg map
+ * The last 3 members are used for select input setting
+ * @pid: pin id
+ * @mux_reg: mux register offset
+ * @conf_reg: config register offset
+ * @mux_mode: mux mode
+ * @input_reg: select input register offset for this mux if any
+ *  0 if no select input setting needed.
+ * @input_val: the value set to select input register
+ */
+struct imx_pin_reg {
+	unsigned int pid;
+	unsigned int mux_reg;
+	unsigned int conf_reg;
+	unsigned int mux_mode;
+	unsigned int input_reg;
+	unsigned int input_val;
+};
+
+struct imx_pinctrl_soc_info {
+	struct device *dev;
+	const struct pinctrl_pin_desc *pins;
+	unsigned int npins;
+	const struct imx_pin_reg *pin_regs;
+	unsigned int npin_regs;
+	struct imx_pin_group *groups;
+	unsigned int ngroups;
+	struct imx_pmx_func *functions;
+	unsigned int nfunctions;
+};
+
+#define NO_MUX		0x0
+#define NO_PAD		0x0
+
+#define IMX_PIN_REG(id, conf, mux, mode, input, val)	\
+	{						\
+		.pid = id,				\
+		.conf_reg = conf,			\
+		.mux_reg = mux,				\
+		.mux_mode  = mode,			\
+		.input_reg = input,			\
+		.input_val = val,			\
+	}
+
+#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
+
+#define PAD_CTL_MASK(len)	((1 << len) - 1)
+#define IMX_MUX_MASK	0x7
+
+int imx_pinctrl_probe(struct platform_device *pdev,
+			struct imx_pinctrl_soc_info *info);
+int imx_pinctrl_remove(struct platform_device *pdev);
+#endif /* __DRIVERS_PINCTRL_IMX_H */
-- 
1.7.0.4


