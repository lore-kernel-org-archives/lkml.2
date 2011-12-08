Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1LHWlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:41:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1LHWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:41:13 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, kernel@pengutronix.de
Subject: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Date: Thu,  8 Dec 2011 23:40:57 +0100
Message-Id: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Note that there is no support yet for efm32 in mainline, so ARCH_EFM32
isn't defined.
---
 drivers/pinctrl/Kconfig                    |    6 +
 drivers/pinctrl/Makefile                   |    1 +
 drivers/pinctrl/pinmux-efm32.c             |  352 ++++++++++++++++++++++++++++
 include/linux/platform_data/efm32-pinctl.h |   60 +++++
 4 files changed, 419 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinmux-efm32.c
 create mode 100644 include/linux/platform_data/efm32-pinctl.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e17e2f8..5067056 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -20,6 +20,12 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINMUX_EFM32
+	bool "EFM32 pinmux driver"
+	depends on ARCH_EFM32
+	default y
+	select PINMUX
+
 config PINMUX_SIRF
 	bool "CSR SiRFprimaII pinmux driver"
 	depends on ARCH_PRIMA2
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 50a2e2f..61846b0 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -4,5 +4,6 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
+obj-$(CONFIG_PINMUX_EFM32)	+= pinmux-efm32.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
diff --git a/drivers/pinctrl/pinmux-efm32.c b/drivers/pinctrl/pinmux-efm32.c
new file mode 100644
index 0000000..2cb1ba5
--- /dev/null
+++ b/drivers/pinctrl/pinmux-efm32.c
@@ -0,0 +1,352 @@
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/efm32-pinctl.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#include "core.h"
+
+#define DRIVER_NAME "efm32-pinctl"
+
+#define EFM32_REG_CTRL		0x00
+#define EFM32_REG_MODEL		0x04
+#define EFM32_REG_MODEH		0x04
+#define EFM32_REG_DOUTSET	0x10
+#define EFM32_REG_DOUTCLR	0x14
+
+/*
+ * The lower 4 bits of these values go into the MODE register,
+ * the 5th into DOUT if the 6th bit is set
+ */
+#define EFM32_MODE_DISABLE		0x20
+#define EFM32_MODE_INPUT		0x21
+#define EFM32_MODE_PUSHPULL		0x04
+#define EFM32_MODE_PUSHPULL_LOW		0x24
+#define EFM32_MODE_PUSHPULL_HIGH	0x34
+
+struct efm32_pinctrl_ddata {
+	struct pinctrl_desc pinctrldesc;
+	const struct efm32_pinctl_pdata *pdata;
+	struct platform_device *pdev;
+	struct pinctrl_dev *pinctrldev;
+	void __iomem *base;
+	struct clk *clk;
+};
+
+#define efm32_pinctrl_dbg(ddata, fmt, arg...)				\
+	dev_dbg(&ddata->pdev->dev, fmt, ##arg)
+
+static int efm32_pinctl_pctl_list_groups(struct pinctrl_dev *pctldev,
+		unsigned selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	if (selector >= pdata->ngroups)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *efm32_pinctl_pctl_get_group_name(struct pinctrl_dev *pctldev,
+		unsigned selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	return pdata->groups[selector]->name;
+}
+
+static int efm32_pinctl_pctl_get_group_pins(struct pinctrl_dev *pctldev,
+		unsigned selector,
+		const unsigned **pins,
+		unsigned *npins)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	*pins = pdata->groups[selector]->pins;
+	*npins = pdata->groups[selector]->npins;
+
+	return 0;
+}
+
+#if defined(CONFIG_DEBUG_FS)
+static void efm32_pinctl_pctl_pin_dbg_show(struct pinctrl_dev *pctldev,
+		struct seq_file *s, unsigned offset)
+{
+	seq_printf(s, " " DRIVER_NAME);
+}
+#else
+#define efm32_pinctl_pctl_pin_dbg_show NULL
+#endif
+
+static struct pinctrl_ops efm32_pinctrl_pctlops = {
+	.list_groups = efm32_pinctl_pctl_list_groups,
+	.get_group_name = efm32_pinctl_pctl_get_group_name,
+	.get_group_pins = efm32_pinctl_pctl_get_group_pins,
+	.pin_dbg_show = efm32_pinctl_pctl_pin_dbg_show,
+};
+
+struct efm32_pmx_func {
+	const char *name;
+	const char **groups;
+	const unsigned ngroups;
+	const unsigned *mode;
+};
+
+static const char *efm32_us1_groups[] = {
+	"us1_loc0",
+	"us1_loc1",
+	"us1_loc2",
+};
+
+/* order: TX, RX, CS, CLK */
+static const unsigned efm32_us_modes[] = {
+	EFM32_MODE_PUSHPULL_HIGH, EFM32_MODE_INPUT,
+	EFM32_MODE_DISABLE, EFM32_MODE_DISABLE
+};
+
+#define EFM32_PMXFUNC(_name, num) {					\
+		.name = #_name #num,					\
+		.groups = efm32_ ## _name ## num ## _groups,		\
+		.ngroups = ARRAY_SIZE(efm32_ ## _name ## num ## _groups),\
+		.mode = efm32_ ## _name ## _modes,			\
+	}
+
+static const struct efm32_pmx_func efm32_pmx_funcs[] = {
+	EFM32_PMXFUNC(us, 1),
+};
+
+static int efm32_pinctrl_pmx_list_functions(struct pinctrl_dev *pctldev,
+	       	unsigned selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	if (selector >= pdata->nfuncs)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *efm32_pinctrl_pmx_get_function_name(
+		struct pinctrl_dev *pctldev, unsigned selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	return pdata->funcs[selector].name;
+}
+
+static int efm32_pinctrl_pmx_get_function_groups(
+		struct pinctrl_dev *pctldev,
+		unsigned selector,
+		const char * const **groups,
+		unsigned * const ngroups)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	*groups = pdata->funcs[selector].groups;
+	*ngroups = pdata->funcs[selector].ngroups;
+	return 0;
+}
+
+static void efm32_pinctrl_pmx_config(struct efm32_pinctrl_ddata *ddata,
+		unsigned pin, unsigned mode)
+{
+	unsigned bank = pin / 16;
+	unsigned bankpin = pin % 16;
+	unsigned bank_regoff = bank * 0x24;
+	unsigned mode_regoff = bankpin < 8 ? EFM32_REG_MODEL : EFM32_REG_MODEH;
+	unsigned dout_regoff =
+		mode & 0x10 ? EFM32_REG_DOUTSET : EFM32_REG_DOUTCLR;
+	u32 regmode;
+
+	efm32_pinctrl_dbg(ddata, "config(%u, 0x%x)\n", pin, mode);
+
+	/*
+	 * first set/unset DOUT unless the pin will be disabled. This prevents
+	 * most glitches in practise.
+	 */
+	if (mode & 0x20 && mode & 0xf)
+		writel(1 << bankpin, ddata->base + bank_regoff + dout_regoff);
+
+	regmode = readl(ddata->base + bank_regoff + mode_regoff);
+
+	regmode &= ~(0xf << (4 * (bankpin % 8)));
+	regmode |= (mode & 0xf) << (4 * (bankpin % 8));
+
+	efm32_pinctrl_dbg(ddata, "[%03x] <- %08x\n",
+		       	bank_regoff + mode_regoff, regmode);
+	writel(regmode, ddata->base + bank_regoff + mode_regoff);
+
+	if (mode & 0x20 && !(mode & 0xf))
+		writel(1 << bankpin, ddata->base + bank_regoff + dout_regoff);
+}
+
+static const struct efm32_pinctl_group *efm32_pinctrl_lookup_group(
+		struct pinctrl_dev *pctldev, const char *name)
+{
+	unsigned i;
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
+
+	for (i = 0; i < pdata->ngroups; ++i) {
+		if (!strcmp(pdata->groups[i]->name, name))
+			return pdata->groups[i];
+	}
+
+	return NULL;
+}
+
+static int efm32_pinctrl_pmx_enable(struct pinctrl_dev *pctldev,
+		unsigned func_selector,
+		unsigned group_selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+
+	const struct efm32_pmx_func *func;
+	const char *groupname;
+	const struct efm32_pinctl_group *group;
+	unsigned i;
+
+	efm32_pinctrl_dbg(ddata, "%s(%u, %u)\n",
+			__func__, func_selector, group_selector);
+
+	func = &efm32_pmx_funcs[func_selector];
+	groupname = func->groups[group_selector];
+	group = efm32_pinctrl_lookup_group(pctldev, groupname);
+
+	if (!group)
+		return -EINVAL;
+
+	for (i = 0; i < group->npins; ++i)
+		efm32_pinctrl_pmx_config(ddata, group->pins[i], func->mode[i]);
+
+	return 0;
+}
+
+static void efm32_pinctrl_pmx_disable(struct pinctrl_dev *pctldev,
+		unsigned func_selector,
+		unsigned group_selector)
+{
+	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
+
+	const struct efm32_pmx_func *func = &efm32_pmx_funcs[func_selector];
+	const char *groupname = func->groups[group_selector];
+	const struct efm32_pinctl_group *group = efm32_pinctrl_lookup_group(pctldev, groupname);
+	unsigned i;
+
+	for (i = 0; i < group->npins; ++i)
+		efm32_pinctrl_pmx_config(ddata, group->pins[i],
+				EFM32_MODE_DISABLE);
+}
+
+static struct pinmux_ops efm32_pinctrl_pmxops = {
+	.list_functions = efm32_pinctrl_pmx_list_functions,
+	.get_function_name = efm32_pinctrl_pmx_get_function_name,
+	.get_function_groups = efm32_pinctrl_pmx_get_function_groups,
+	.enable = efm32_pinctrl_pmx_enable,
+	.disable = efm32_pinctrl_pmx_disable,
+};
+
+static int __devinit efm32_pinctrl_probe(struct platform_device *pdev)
+{
+	int ret = -ENOMEM;
+	struct efm32_pinctrl_ddata *ddata;
+	const struct resource *res;
+
+       	ddata = kzalloc(sizeof(*ddata), GFP_KERNEL);
+	if (!ddata) {
+		dev_dbg(&pdev->dev, "allocating ddata failed\n");
+		goto err_ddata_kzalloc;
+	}
+
+	ddata->pdev = pdev;
+	ddata->pdata = dev_get_platdata(&pdev->dev);
+
+	if (!ddata->pdata) {
+		dev_dbg(&pdev->dev, "no platform data\n");
+		goto err_platdata;
+	}
+
+	ddata->pinctrldesc.name = DRIVER_NAME;
+	ddata->pinctrldesc.pins = ddata->pdata->pins;
+	ddata->pinctrldesc.npins = ddata->pdata->npins;
+	ddata->pinctrldesc.maxpin = ddata->pdata->npins;
+	ddata->pinctrldesc.pctlops = &efm32_pinctrl_pctlops;
+	ddata->pinctrldesc.pmxops = &efm32_pinctrl_pmxops;
+	ddata->pinctrldesc.owner = THIS_MODULE;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENODEV;
+		dev_dbg(&pdev->dev, "getting base address failed\n");
+		goto err_get_base;
+	}
+
+	ddata->base = ioremap(res->start, 0x140);
+	if (!ddata->base) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "failed to remap\n");
+		goto err_ioremap;
+	}
+
+	ddata->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(ddata->clk)) {
+		ret = PTR_ERR(ddata->clk);
+		dev_dbg(&pdev->dev, "failed to get clock\n");
+		goto err_clk_get;
+	}
+
+	ret = clk_prepare(ddata->clk);
+	if (ret) {
+		dev_dbg(&pdev->dev, "failed to prepare clock\n");
+		goto err_clk_prepare;
+	}
+
+	ddata->pinctrldev = pinctrl_register(&ddata->pinctrldesc,
+			&pdev->dev, ddata);
+	if (!ddata->pinctrldev) {
+		ret = -EINVAL;
+		dev_dbg(&pdev->dev, "failed to register pinctrl device");
+
+		clk_unprepare(ddata->clk);
+err_clk_prepare:
+
+		clk_put(ddata->clk);
+err_clk_get:
+
+		iounmap(ddata->base);
+err_ioremap:
+err_get_base:
+err_platdata:
+		kfree(ddata);
+	} else
+		efm32_pinctrl_dbg(ddata, "initialized (%p, %p)\n", ddata, ddata->pinctrldev);
+
+err_ddata_kzalloc:
+	return ret;
+}
+
+static struct platform_driver efm32_pinctrl_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = efm32_pinctrl_probe,
+};
+
+static int __init efm32_pinctrl_init(void)
+{
+	return platform_driver_register(&efm32_pinctrl_driver);
+}
+arch_initcall(efm32_pinctrl_init);
+
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_DESCRIPTION("efm32 pin control");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/efm32-pinctl.h b/include/linux/platform_data/efm32-pinctl.h
new file mode 100644
index 0000000..38d0f9e6
--- /dev/null
+++ b/include/linux/platform_data/efm32-pinctl.h
@@ -0,0 +1,60 @@
+#ifndef __LINUX_PLATFORM_DATA_EFM32_PINCTL_H__
+#define __LINUX_PLATFORM_DATA_EFM32_PINCTL_H__
+/*
+ * The lower 4 bits of these values go into the MODE register,
+ * the 5th into DOUT if the 6th bit is set
+ */
+#define EFM32_MODE_DISABLE              0x20
+#define EFM32_MODE_INPUT                0x21
+#define EFM32_MODE_PUSHPULL             0x04
+#define EFM32_MODE_PUSHPULL_LOW         0x24
+#define EFM32_MODE_PUSHPULL_HIGH        0x34
+
+/**
+ * struct efm32_pinctl_group
+ * @name: name of the group
+ * @pins: list of pins that form the group
+ * @npins: length of @pins
+ */
+struct efm32_pinctl_group {
+	const char *name;
+	const unsigned *pins;
+	unsigned npins;
+};
+
+/**
+ * struct efm32_pinctl_muxfunc
+ * @name: name of the function
+ * @groups: list of groups this function can be muxed to
+ * @ngroups: length of @groups
+ * @modes: modes to set for the pins when the function is enabled
+ *
+ * All groups must have the same length and order and their length must match
+ * the length of @modes. When the function is enabled for group g, g->pins[i]
+ * gets assigned mode modes[i].
+ */
+struct efm32_pinctl_muxfunc {
+	const char *name;
+	const char *const *groups;
+	unsigned ngroups;
+	const unsigned *modes;
+};
+
+/**
+ * @pins: list of pins available
+ * @npins: length of @pins
+ * @groups: list of groups available
+ * @ngroups: length of @groups
+ * @funcs: list of functions available
+ * @nfuncs: length oflength of @funcs
+ */
+struct efm32_pinctl_pdata {
+	const struct pinctrl_pin_desc *pins;
+	unsigned npins;
+	const struct efm32_pinctl_group *const *groups;
+	unsigned ngroups;
+	const struct efm32_pinctl_muxfunc *funcs;
+	unsigned nfuncs;
+};
+
+#endif /* ifndef __LINUX_PLATFORM_DATA_EFM32_PINCTL_H__ */
-- 
1.7.7.3

