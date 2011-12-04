Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1LDLiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:38:09 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:26752
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752586Ab1LDLiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:38:05 -0500
X-SpamScore: 7
X-BigFish: VS7(zzc8kzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>
Subject: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Date: Sun, 4 Dec 2011 19:49:42 +0800
Message-ID: <1322999384-7886-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
This patch series shows the basic idea of driver design. There're still
some TODOes like adding more pinmux functions and gpio support.
The patch is here for request for comments on the driver design
and other might exist issues.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shanw.guo@freescale.com>
---
 drivers/pinctrl/Kconfig           |    6 +
 drivers/pinctrl/Makefile          |    2 +
 drivers/pinctrl/pinmux-imx-core.c |  284 +++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-imx-core.h |   83 +++++++++++
 4 files changed, 375 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index ef56644..214d072 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -40,4 +40,10 @@ config PINMUX_U300
 	help
 	  Say Y here to enable the U300 pinmux driver
 
+config PINMUX_IMX
+	bool "IMX pinmux driver"
+	depends on ARCH_MXC
+	select PINMUX
+	help
+	  Say Y here to enable the IMX pinmux driver
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index bdc548a..764657b 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -4,5 +4,7 @@ ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
 
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
+obj-$(CONFIG_PINMUX_IMX)	+= pinmux-imx-core.o \
+				   pinmux-imx53.o pinmux-imx6q.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
diff --git a/drivers/pinctrl/pinmux-imx-core.c b/drivers/pinctrl/pinmux-imx-core.c
new file mode 100644
index 0000000..1e60932
--- /dev/null
+++ b/drivers/pinctrl/pinmux-imx-core.c
@@ -0,0 +1,284 @@
+/*
+ * Core driver for the imx pin controller
+ *
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ * Copyright (C) 2011 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "pinmux-imx-core.h"
+
+#define DRIVER_NAME "pinmux-imx"
+
+/**
+ * @dev: a pointer back to containing device
+ * @virtbase: the offset to the controller in virtual memory
+ */
+struct imx_pmx {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	void __iomem *virtbase;
+	struct imx_pinctrl_info *info;
+};
+
+#define IMX_PINCTRL_REG_SIZE 4
+#define IMX_PINCTRL_MAX_FUNC 7
+
+extern struct imx_pinctrl_info mx53_pinctrl_info;
+extern struct imx_pinctrl_info mx6q_pinctrl_info;
+
+static struct platform_device_id imx_pinctrl_devtype[] = {
+	{
+		.name = "sdhci-pinctrl-imx53",
+		.driver_data = (kernel_ulong_t)&mx53_pinctrl_info,
+	}, {
+		.name = "sdhci-pinctrl-imx6q",
+		.driver_data = (kernel_ulong_t)&mx6q_pinctrl_info,
+	},
+};
+
+static int imx_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->ngroups)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->ngroups)
+		return NULL;
+
+	return info->groups[selector].name;
+}
+
+static int imx_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       const unsigned **pins,
+			       unsigned *num_pins)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->ngroups)
+		return -EINVAL;
+
+	*pins = info->groups[selector].pins;
+	*num_pins = info->groups[selector].num_pins;
+
+	return 0;
+}
+
+static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
+		   unsigned offset)
+{
+	seq_printf(s, " " DRIVER_NAME);
+}
+
+static struct pinctrl_ops imx_pctrl_ops = {
+	.list_groups = imx_list_groups,
+	.get_group_name = imx_get_group_name,
+	.get_group_pins = imx_get_group_pins,
+	.pin_dbg_show = imx_pin_dbg_show,
+};
+
+static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
+			   unsigned group)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+	const unsigned *pins, *mux;
+	unsigned int num_pins, num_mux;
+	u32 regval, offset;
+	int i;
+
+	/*
+	 * Configure the mux mode for each pin in the group for a specific
+	 * function.
+	 */
+	pins = info->groups[group].pins;
+	num_pins = info->groups[group].num_pins;
+	mux = info->groups[group].mux_mode;
+	num_mux = info->groups[group].num_mux;
+
+	dev_dbg(ipmx->dev, "function %s group %s\n",
+		info->functions[selector].name, info->groups[group].name);
+
+	if (num_pins != num_mux) {
+		dev_err(ipmx->dev, "num_mux is not equal to num_pins\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_pins; i++) {
+		if (mux[i] > IMX_PINCTRL_MAX_FUNC)
+			dev_err(ipmx->dev, "exceeds the maximum mux mode(0x7)\n");
+		offset = info->mux_offset + pins[i] * IMX_PINCTRL_REG_SIZE;
+		regval = readl(ipmx->virtbase + offset);
+		regval &= ~IMX_PINCTRL_MAX_FUNC;
+		writel(mux[i] | regval, ipmx->virtbase + offset);
+		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%x\n",
+			offset, regval);
+	}
+
+	return 0;
+}
+
+static int imx_pmx_list_funcs(struct pinctrl_dev *pctldev, unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	if (selector >= info->nfunctions)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const char *imx_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					  unsigned selector)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	return info->functions[selector].name;
+}
+
+static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
+			       const char * const **groups,
+			       unsigned * const num_groups)
+{
+	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
+	struct imx_pinctrl_info *info = ipmx->info;
+
+	*groups = info->functions[selector].groups;
+	*num_groups = info->functions[selector].num_groups;
+
+	return 0;
+}
+
+static struct pinmux_ops imx_pmx_ops = {
+	.list_functions = imx_pmx_list_funcs,
+	.get_function_name = imx_pmx_get_func_name,
+	.get_function_groups = imx_pmx_get_groups,
+	.enable = imx_pmx_enable,
+};
+
+static struct pinctrl_desc imx_pmx_desc = {
+	.name = DRIVER_NAME,
+	.pctlops = &imx_pctrl_ops,
+	.pmxops = &imx_pmx_ops,
+	.owner = THIS_MODULE,
+};
+
+static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
+				const struct imx_pinctrl_info *info)
+{
+	pmx_desc->pins = info->pins;
+	pmx_desc->npins = info->npins;
+	pmx_desc->maxpin = info->maxpin;
+}
+
+static int __init imx_pmx_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct imx_pmx *ipmx;
+	struct resource *res;
+	struct imx_pinctrl_info *info;
+	resource_size_t res_size;
+
+	info = (struct imx_pinctrl_info *)pdev->id_entry->driver_data;
+	if (!info || !info->pins || !info->groups || !info->functions
+		|| (info->maxpin > info->npins)) {
+		dev_err(&pdev->dev, "wrong pinctrl info\n");
+		return -EINVAL;
+	}
+
+	/* Create state holders etc for this driver */
+	ipmx = devm_kzalloc(&pdev->dev, sizeof(*ipmx), GFP_KERNEL);
+	if (!ipmx)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
+	res_size = resource_size(res);
+	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
+		return -EBUSY;
+
+	ipmx->virtbase = devm_ioremap_nocache(dev, res->start, res_size);
+	if (!ipmx->virtbase)
+		return -EBUSY;
+
+	imx_pmx_desc_init(&imx_pmx_desc, info);
+
+	ipmx->pctl = pinctrl_register(&imx_pmx_desc, &pdev->dev, ipmx);
+	if (!ipmx->pctl) {
+		dev_err(&pdev->dev, "could not register IMX pinmux driver\n");
+		return -EINVAL;
+	}
+
+	ipmx->info = info;
+	ipmx->dev = &pdev->dev;
+	platform_set_drvdata(pdev, ipmx);
+
+	dev_info(&pdev->dev, "initialized IMX pinmux driver\n");
+
+	return 0;
+}
+
+static int __exit imx_pmx_remove(struct platform_device *pdev)
+{
+	struct imx_pmx *ipmx = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(ipmx->pctl);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver imx_pmx_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.id_table = imx_pinctrl_devtype,
+	.remove = __exit_p(imx_pmx_remove),
+};
+
+static int __init imx_pmx_init(void)
+{
+	return platform_driver_probe(&imx_pmx_driver, imx_pmx_probe);
+}
+arch_initcall(imx_pmx_init);
+
+static void __exit imx_pmx_exit(void)
+{
+	platform_driver_unregister(&imx_pmx_driver);
+}
+module_exit(imx_pmx_exit);
+
+MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
+MODULE_DESCRIPTION("IMX Pin Control Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinmux-imx-core.h b/drivers/pinctrl/pinmux-imx-core.h
new file mode 100644
index 0000000..8ccc0c6
--- /dev/null
+++ b/drivers/pinctrl/pinmux-imx-core.h
@@ -0,0 +1,83 @@
+/*
+ * IMX pinmux core definitions
+ *
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ * Copyright (C) 2011 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DRIVERS_PINCTRL_PINMUX_IMX_H
+#define __DRIVERS_PINCTRL_PINMUX_IMX_H
+
+/* Supported Pinctrl type */
+enum imx_pinctrl_type {
+	MX53_PINCTRL,
+	MX6Q_PINCTRL,
+};
+
+/**
+ * struct imx_pin_group - describes an IMX pin group
+ * @name: the name of this specific pin group
+ * @pins: an array of discrete physical pins used in this group, taken
+ *	from the driver-local pin enumeration space
+ * @num_pins: the number of pins in this group array, i.e. the number of
+ *	elements in .pins so we can iterate over that array
+ * @mux_mode: the mux mode for each pins in this group. The size of this
+ *	array is the same as pins.
+ */
+struct imx_pin_group {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned num_pins;
+	const unsigned int *mux_mode;
+	const unsigned num_mux;
+};
+
+/**
+ * struct imx_pmx_func - describes IMX pinmux functions
+ * @name: the name of this specific function
+ * @groups: corresponding pin groups
+ */
+struct imx_pmx_func {
+	const char *name;
+	const char * const *groups;
+	const unsigned num_groups;
+};
+
+struct imx_pinctrl_info {
+	u32 type;
+	const struct pinctrl_pin_desc *pins;
+	unsigned int npins;
+	unsigned int maxpin;
+	const struct imx_pin_group *groups;
+	unsigned int ngroups;
+	const struct imx_pmx_func *functions;
+	unsigned int nfunctions;
+	u32 mux_offset;
+};
+
+#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
+
+#define IMX_PIN_GROUP(n, p, m)  \
+	{			\
+		.name = n,	\
+		.pins = p,	\
+		.num_pins = ARRAY_SIZE(p),	\
+		.mux_mode = m,	\
+		.num_mux = ARRAY_SIZE(m),	\
+	}
+
+#define IMX_PMX_FUNC(n, g)  \
+	{			\
+		.name = n,	\
+		.groups = g,	\
+		.num_groups = ARRAY_SIZE(g),	\
+	}
+
+#endif /* __DRIVERS_PINCTRL_PINMUX_IMX_H */
-- 
1.7.0.4


