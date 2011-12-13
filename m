Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1LMJie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:38:34 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39902 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751921Ab1LMJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:38:27 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
Date: Tue, 13 Dec 2011 17:40:52 +0800
Message-Id: <1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 13 Dec 2011 09:38:10.0933 (UTC) FILETIME=[ED8A8A50:01CCB97A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support pxa3xx/pxa168/pxa910/mmp2. Support to switch pin configuration.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/pinctrl/Kconfig          |   15 +
 drivers/pinctrl/Makefile         |    3 +
 drivers/pinctrl/pinctrl-pxa3xx.c |  193 +++++++++++
 drivers/pinctrl/pinmux-pxa168.c  |  170 ++++++++++
 drivers/pinctrl/pinmux-pxa300.c  |  647 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-pxa910.c  |  373 ++++++++++++++++++++++
 include/linux/pinctrl/pxa3xx.h   |  213 +++++++++++++
 7 files changed, 1614 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-pxa3xx.c
 create mode 100644 drivers/pinctrl/pinmux-pxa168.c
 create mode 100644 drivers/pinctrl/pinmux-pxa300.c
 create mode 100644 drivers/pinctrl/pinmux-pxa910.c
 create mode 100644 include/linux/pinctrl/pxa3xx.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c63c721..501d7aa 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -23,6 +23,21 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
+config PINMUX_PXA168
+	bool "PXA168 pinmux driver"
+	depends on ARCH_MMP
+	select PINMUX
+
+config PINMUX_PXA300
+	bool "PXA300 pinmux driver"
+	depends on ARCH_PXA
+	select PINMUX
+
+config PINMUX_PXA910
+	bool "PXA910 pinmux driver"
+	depends on ARCH_MMP
+	select PINMUX
+
 config PINMUX_SIRF
 	bool "CSR SiRFprimaII pinmux driver"
 	depends on ARCH_PRIMA2
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c046f78..47f6028 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,6 +5,9 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
+obj-$(CONFIG_PINMUX_PXA168)	+= pinmux-pxa168.o pinctrl-pxa3xx.o
+obj-$(CONFIG_PINMUX_PXA300)	+= pinmux-pxa300.o pinctrl-pxa3xx.o
+obj-$(CONFIG_PINMUX_PXA910)	+= pinmux-pxa910.o pinctrl-pxa3xx.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
new file mode 100644
index 0000000..1200906
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -0,0 +1,193 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa3xx.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/pinctrl/pxa3xx.h>
+
+static int pxa3xx_list_groups(struct pinctrl_dev *pctrldev, unsigned selector)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *pxa3xx_get_group_name(struct pinctrl_dev *pctrldev,
+					 unsigned selector)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return NULL;
+	return info->grp[selector].name;
+}
+
+static int pxa3xx_get_group_pins(struct pinctrl_dev *pctrldev,
+				 unsigned selector,
+				 const unsigned **pins,
+				 unsigned *num_pins)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (selector >= info->num_grps)
+		return -EINVAL;
+	*pins = info->grp[selector].pins;
+	*num_pins = info->grp[selector].num_pins;
+	return 0;
+}
+
+struct pinctrl_ops pxa3xx_pctrl_ops = {
+	.list_groups	= pxa3xx_list_groups,
+	.get_group_name	= pxa3xx_get_group_name,
+	.get_group_pins	= pxa3xx_get_group_pins,
+};
+
+static int pxa3xx_get_gpio_func(enum pxa_cpu_type cputype, unsigned int gpio)
+{
+	int ret = 0;
+
+	switch (cputype) {
+	case PINMUX_PXA300:
+	case PINMUX_PXA310:
+		if (gpio == 50)
+			ret = 2;
+		else if (gpio == 49 || gpio == 51 || gpio == 53)
+			ret = 3;
+		break;
+	case PINMUX_PXA320:
+		if (gpio == 56 || (gpio > 58 && gpio < 63))
+			goto out;
+		break;
+	case PINMUX_PXA168:
+		if ((gpio >= 0 && gpio < 16) || gpio == 17 || gpio == 19 ||
+			(gpio > 20 && gpio < 26) || (gpio > 26 && gpio < 34))
+			ret = 1;
+		break;
+	case PINMUX_PXA910:
+		if ((gpio > 116 && gpio < 121) || gpio == 122 || gpio == 123 ||
+			gpio == 125 || gpio == 99 || gpio == 58 || gpio == 59)
+			ret = 1;
+		break;
+	case PINMUX_PXA930:
+		if (gpio == 83)
+			goto out;
+		break;
+	case PINMUX_MMP2:
+		if ((gpio > 101 && gpio < 114) || (gpio > 141 && gpio <= 168))
+			ret = 1;
+		break;
+	default:
+		goto out;
+	}
+	return ret & MFPR_FUNC;
+out:
+	return -1;
+}
+
+int pxa3xx_get_mfpr(struct pxa3xx_pinmux_info *info, unsigned int pin)
+{
+	if (pin >= info->num_mfpr)
+		return -EINVAL;
+	return info->mfpr[pin];
+}
+
+static int pxa3xx_pmx_request_gpio(struct pinctrl_dev *pctrldev,
+			       struct pinctrl_gpio_range *range,
+			       unsigned pin)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	unsigned int data;
+	int mfpr, pin_func, gpio;
+
+	/* convert pin to gpio */
+	gpio = pin - range->pin_base + range->base;
+	pin_func = pxa3xx_get_gpio_func(info->cputype, gpio);
+	if (pin_func < 0)
+		goto out;
+	mfpr = pxa3xx_get_mfpr(info, pin);
+	if (mfpr < 0)
+		goto out;
+
+	/* write gpio function into mfpr register */
+	data = readl_relaxed(info->virt_base + mfpr) & MFPR_FUNC_MASK;
+	data |= pin_func;
+	writel_relaxed(data, info->virt_base + mfpr);
+	return 0;
+out:
+	return -EINVAL;
+}
+
+static int pxa3xx_pmx_enable(struct pinctrl_dev *pctrldev, unsigned func,
+			     unsigned group)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	struct pxa3xx_pin_group *pin_grp = &info->grp[group];
+	unsigned int data, pin_func;
+	int i, mfpr;
+
+	for (i = 0; i < pin_grp->num_pins; i++) {
+		mfpr = pxa3xx_get_mfpr(info, pin_grp->pins[i]);
+		if (mfpr < 0) {
+			dev_err(info->dev, "error pin:%d mfpr offset:%x\n",
+				pin_grp->pins[i], mfpr);
+			goto out;
+		}
+		pin_func = pin_grp->func[i];
+		data = readl_relaxed(info->virt_base + mfpr);
+	        data &= MFPR_FUNC_MASK;
+		data |= pin_func;
+		writel_relaxed(data, info->virt_base + mfpr);
+	}
+	return 0;
+out:
+	return -EINVAL;
+}
+
+static void pxa3xx_pmx_disable(struct pinctrl_dev *pctrldev, unsigned func,
+			       unsigned group)
+{
+}
+
+static int pxa3xx_pmx_list_func(struct pinctrl_dev *pctrldev, unsigned func)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	if (func >= info->num_funcs)
+		return -EINVAL;
+	return 0;
+}
+
+static const char *pxa3xx_pmx_get_func_name(struct pinctrl_dev *pctrldev,
+					    unsigned func)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	return info->func[func].name;
+}
+
+static int pxa3xx_pmx_get_groups(struct pinctrl_dev *pctrldev, unsigned func,
+				 const char * const **groups,
+				 unsigned * const num_groups)
+{
+	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
+	*groups = info->func[func].groups;
+	*num_groups = info->func[func].num_groups;
+	return 0;
+}
+
+struct pinmux_ops pxa3xx_pmx_ops = {
+	.list_functions		= pxa3xx_pmx_list_func,
+	.get_function_name	= pxa3xx_pmx_get_func_name,
+	.get_function_groups	= pxa3xx_pmx_get_groups,
+	.enable			= pxa3xx_pmx_enable,
+	.disable		= pxa3xx_pmx_disable,
+	.gpio_request_enable	= pxa3xx_pmx_request_gpio,
+};
diff --git a/drivers/pinctrl/pinmux-pxa168.c b/drivers/pinctrl/pinmux-pxa168.c
new file mode 100644
index 0000000..3bb7460
--- /dev/null
+++ b/drivers/pinctrl/pinmux-pxa168.c
@@ -0,0 +1,170 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa168.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/pinctrl/pxa3xx.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PXA168_DS_MASK		0x0C00
+#define PXA168_DS_SHIFT		10
+
+static struct pinctrl_pin_desc pxa168_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+};
+
+static unsigned pxa168_mfpr[] = {
+	/* GPIO[0:122] */
+	0x04C, 0x050, 0x054, 0x058, 0x05C, 0x060, 0x064, 0x068, 0x06C, 0x070,
+	0x074, 0x078, 0x07C, 0x080, 0x084, 0x088, 0x08C, 0x090, 0x094, 0x098,
+	0x09C, 0x0A0, 0x0A4, 0x0A8, 0x0AC, 0x0B0, 0x0B4, 0x0B8, 0x0BC, 0x0C0,
+	0x0C4, 0x0C8, 0x0CC, 0x0D0, 0x0D4, 0x0D8, 0x0DC, 0x000, 0x004, 0x008,
+	0x00C, 0x010, 0x014, 0x018, 0x01C, 0x020, 0x024, 0x028, 0x02C, 0x030,
+	0x034, 0x038, 0x03C, 0x040, 0x044, 0x048, 0x0E0, 0x0E4, 0x0E8, 0x0EC,
+	0x0F0, 0x0F4, 0x0F8, 0x0FC, 0x100, 0x104, 0x108, 0x10C, 0x110, 0x114,
+	0x118, 0x11C, 0x120, 0x124, 0x128, 0x12C, 0x130, 0x134, 0x138, 0x13C,
+	0x140, 0x144, 0x148, 0x14C, 0x150, 0x154, 0x158, 0x15C, 0x160, 0x164,
+	0x168, 0x16C, 0x170, 0x174, 0x178, 0x17C, 0x180, 0x184, 0x188, 0x18C,
+	0x190, 0x194, 0x198, 0x19C, 0x1A0, 0x1A4, 0x1A8, 0x1AC, 0x1B0, 0x1B4,
+	0x1B8, 0x1BC, 0x1C0, 0x1C4, 0x1C8, 0x1CC, 0x1D0, 0x1D4, 0x1D8, 0x1DC,
+	0x1E0, 0x1E4, 0x1E8,
+};
+
+static const unsigned pxa168_uart1_pins[] = {107, 108};
+static const unsigned pxa168_uart1_func[] = {2, 2};
+static const unsigned pxa168_ssp1_pins[] = {113, 114, 115, 116, 117};
+static const unsigned pxa168_ssp1_func[] = {6, 1, 1, 2, 2};
+static const unsigned pxa168_lcd_pins[] = {56, 57, 58, 59, 60, 61, 62, 63,
+		64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
+		79, 80, 81, 82, 83};
+static const unsigned pxa168_lcd_func[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
+static const unsigned pxa168_key_pins[] = {109, 110, 111, 112, 121};
+static const unsigned pxa168_key_func[] = {7, 7, 7, 7, 7};
+
+static struct pxa3xx_pin_group pxa168_pin_groups[] = {
+	{"uart1-2-pin", pxa168_uart1_func, ARRAY_AND_SIZE(pxa168_uart1_pins)},
+	{"ssp1", pxa168_ssp1_func, ARRAY_AND_SIZE(pxa168_ssp1_pins)},
+	{"lcd", pxa168_lcd_func, ARRAY_AND_SIZE(pxa168_lcd_pins)},
+	{"kp-3i-2o", pxa168_key_func, ARRAY_AND_SIZE(pxa168_key_pins)},
+};
+
+static const char * const pxa168_uart1_grps[] = {"uart1-2-pin"};
+static const char * const pxa168_ssp1_grps[] = {"ssp1"};
+static const char * const pxa168_lcd_grps[] = {"lcd"};
+static const char * const pxa168_key_grps[] = {"kp-3i-2o"};
+
+static struct pxa3xx_pmx_func pxa168_pmx_functions[] = {
+	{"uart1",	ARRAY_AND_SIZE(pxa168_uart1_grps)},
+	{"ssp1",	ARRAY_AND_SIZE(pxa168_ssp1_grps)},
+	{"lcd",		ARRAY_AND_SIZE(pxa168_lcd_grps)},
+	{"key",		ARRAY_AND_SIZE(pxa168_key_grps)},
+};
+
+static struct pinctrl_gpio_range pxa168_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 128),
+};
+
+static struct pinctrl_desc pxa168_pctrl_desc = {
+	.name		= "pxa168-pinctrl",
+	.pctlops	= &pxa3xx_pctrl_ops,
+	.pmxops		= &pxa3xx_pmx_ops,
+	.pins		= pxa168_pads,
+	.npins		= ARRAY_SIZE(pxa168_pads),
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static struct pxa3xx_pinmux_info pxa168_pmx_info = {
+	.grp		= pxa168_pin_groups,
+	.func		= pxa168_pmx_functions,
+	.range		= pxa168_gpio_ranges,
+	.mfpr		= pxa168_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa168_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa168_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa168_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa168_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa168_pads),
+};
+
+static int __devinit pxa168_pinmux_probe(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info;
+	struct resource *res;
+	int ret, i;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		return -ENOENT;
+	}
+	info = &pxa168_pmx_info;
+	info->dev = &pdev->dev;
+	info->cputype = PINMUX_PXA168;
+	info->phy_base = res->start;
+	info->phy_size = resource_size(res);
+	info->virt_base = ioremap(info->phy_base, info->phy_size);
+	if (!info->virt_base) {
+		return -ENOMEM;
+	}
+	info->pctl = pinctrl_register(&pxa168_pctrl_desc, &pdev->dev, info);
+	if (!info->pctl) {
+		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	for (i = 0; i < info->num_range; i++)
+		pinctrl_add_gpio_range(info->pctl, &info->range[i]);
+	platform_set_drvdata(pdev, info);
+	return 0;
+out:
+	iounmap(info->virt_base);
+	return ret;
+}
+
+static int __devexit pxa168_pinmux_remove(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(info->pctl);
+	iounmap(info->virt_base);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver pxa168_pinmux_driver = {
+	.driver = {
+		.name = "pxa168-pinmux",
+		.owner = THIS_MODULE,
+	},
+	.probe = pxa168_pinmux_probe,
+	.remove = __devexit_p(pxa168_pinmux_remove),
+};
+
+static int __init pxa168_pinmux_init(void)
+{
+	return platform_driver_register(&pxa168_pinmux_driver);
+}
+postcore_initcall(pxa168_pinmux_init);
+
+static void __exit pxa168_pinmux_exit(void)
+{
+	platform_driver_unregister(&pxa168_pinmux_driver);
+}
+module_exit(pxa168_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA910 pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinmux-pxa300.c b/drivers/pinctrl/pinmux-pxa300.c
new file mode 100644
index 0000000..7349410
--- /dev/null
+++ b/drivers/pinctrl/pinmux-pxa300.c
@@ -0,0 +1,647 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa3xx.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/pinctrl/pxa3xx.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PXA300_DS_MASK		0x1C00
+#define PXA300_DS_SHIFT		10
+
+static struct pinctrl_pin_desc pxa300_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+	GPIO123_GPIO127_PINS(),
+	DUP_GPIO0_GPIO6_PINS(),
+};
+
+static struct pinctrl_pin_desc pxa310_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+	GPIO123_GPIO127_PINS(),
+	DUP_GPIO0_GPIO6_PINS(),
+	DUP_GPIO7_GPIO10_PINS(),
+};
+
+static struct pinctrl_pin_desc pxa320_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+	GPIO123_GPIO127_PINS(),
+	DUP_GPIO0_GPIO6_PINS(),
+	DUP_GPIO7_GPIO10_PINS(),
+	PINCTRL_PIN(139, "GPIO11_2"),	PINCTRL_PIN(140, "GPIO12_2"),
+	PINCTRL_PIN(141, "GPIO13_2"),	PINCTRL_PIN(142, "GPIO14_2"),
+	PINCTRL_PIN(143, "GPIO15_2"),	PINCTRL_PIN(144, "GPIO16_2"),
+	PINCTRL_PIN(145, "GPIO17_2"),
+};
+
+static struct pinctrl_pin_desc pxa930_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	PINCTRL_PIN(107, "ND_nCS1"),
+};
+
+/* the sequence follows pxa300_pads[] */
+static unsigned pxa300_mfpr[] = {
+	0x0B4, 0x0B8, 0x0BC, 0x27C, 0x280, 0x284, 0x288, 0x28C, 0x290, 0x294,
+	0x298, 0x29C, 0x2A0, 0x2A4, 0x2A8, 0x2AC, 0x2B0, 0x2B4, 0x2B8, 0x2BC,
+	0x2C0, 0x2C4, 0x2C8, 0x2CC, 0x2D0, 0x2D4, 0x2D8, 0x400, 0x404, 0x408,
+	0x40C, 0x410, 0x414, 0x418, 0x41C, 0x420, 0x424, 0x428, 0x42C, 0x430,
+	0x434, 0x438, 0x43C, 0x440, 0x444, 0x448, 0x44C, 0x450, 0x454, 0x458,
+	0x45C, 0x460, 0x464, 0x468, 0x46C, 0x470, 0x474, 0x478, 0x47C, 0x480,
+	0x484, 0x488, 0x48C, 0x490, 0x494, 0x498, 0x49C, 0x4A0, 0x4A4, 0x4A8,
+	0x4AC, 0x4B0, 0x4B4, 0x4B8, 0x4BC, 0x4C0, 0x4C4, 0x4C8, 0x4CC, 0x4D0,
+	0x4D4, 0x4D8, 0x4DC, 0x4E0, 0x4E4, 0x4E8, 0x4EC, 0x4F0, 0x4F4, 0x4F8,
+	0x4FC, 0x500, 0x504, 0x508, 0x50C, 0x510, 0x514, 0x518, 0x51C, 0x600,
+	0x604, 0x608, 0x60C, 0x610, 0x614, 0x618, 0x61C, 0x620, 0x624, 0x628,
+	0x62C, 0x630, 0x634, 0x638, 0x63C, 0x640, 0x644, 0x648, 0x64C, 0x650,
+	0x654, 0x658, 0x65C, 0x660, 0x664, 0x668, 0x66C, 0x670,
+	/* the below pins can also be configured as GPIO[6:0] */
+	0x674, 0x678, 0x2DC, 0x2E0, 0x2E4, 0x2E8, 0x2EC,
+};
+
+/* the sequence follows pxa310_pads[] */
+static unsigned pxa310_mfpr[] = {
+	0x0B4, 0x0B8, 0x0BC, 0x27C, 0x280, 0x284, 0x288, 0x28C, 0x290, 0x294,
+	0x298, 0x29C, 0x2A0, 0x2A4, 0x2A8, 0x2AC, 0x2B0, 0x2B4, 0x2B8, 0x2BC,
+	0x2C0, 0x2C4, 0x2C8, 0x2CC, 0x2D0, 0x2D4, 0x2D8, 0x400, 0x404, 0x408,
+	0x418, 0x41C, 0x420, 0x424, 0x428, 0x42C, 0x430, 0x434, 0x438, 0x43C,
+	0x440, 0x444, 0x448, 0x44C, 0x450, 0x454, 0x458, 0x45C, 0x460, 0x464,
+	0x468, 0x46C, 0x470, 0x474, 0x478, 0x47C, 0x480, 0x484, 0x488, 0x48C,
+	0x490, 0x494, 0x498, 0x49C, 0x4A0, 0x4A4, 0x4A8, 0x4AC, 0x4B0, 0x4B4,
+	0x4B8, 0x4BC, 0x4C0, 0x4C4, 0x4C8, 0x4CC, 0x4D0, 0x4D4, 0x4D8, 0x4DC,
+	0x4E0, 0x4E4, 0x4E8, 0x4EC, 0x4F0, 0x4F4, 0x4F8, 0x4FC, 0x500, 0x504,
+	0x508, 0x50C, 0x510, 0x514, 0x518, 0x51C, 0x520, 0x524, 0x528, 0x600,
+	0x604, 0x608, 0x60C, 0x610, 0x614, 0x618, 0x61C, 0x620, 0x624, 0x628,
+	0x62C, 0x630, 0x634, 0x638, 0x63C, 0x640, 0x644, 0x648, 0x64C, 0x650,
+	0x654, 0x658, 0x65C, 0x660, 0x664, 0x668, 0x66C, 0x670,
+	/* the below pins can also be configured as GPIO[10:0] */
+	0x674, 0x678, 0x2DC, 0x2E0, 0x2E4, 0x2E8, 0x2EC, 0x52C, 0x530, 0x534,
+	0x538,
+};
+
+/* the sequence follows pxa320_pads[] */
+static unsigned pxa320_mfpr[] = {
+	0x124, 0x128, 0x12C, 0x130, 0x134, 0x28C, 0x290, 0x294, 0x298, 0x29C,
+	0x458, 0x2A0, 0x2A4, 0x2A8, 0x2AC, 0x2B0, 0x2B4, 0x2B8, 0x2BC, 0x2C0,
+	0x2C4, 0x2C8, 0x2CC, 0x2D0, 0x2D4, 0x2D8, 0x2DC, 0x400, 0x404, 0x408,
+	0x40C, 0x410, 0x414, 0x418, 0x41C, 0x420, 0x424, 0x428, 0x42C, 0x430,
+	0x434, 0x438, 0x43C, 0x440, 0x444, 0x448, 0x44C, 0x450, 0x454, 0x45C,
+	0x460, 0x464, 0x468, 0x46C, 0x470, 0x474, 0x478, 0x47C, 0x480, 0x484,
+	0x488, 0x48C, 0x490, 0x4B4, 0x4B8, 0x4BC, 0x4C0, 0x4C4, 0x4C8, 0x4CC,
+	0x4D0, 0x4D4, 0x4D8, 0x4DC, 0x4F0, 0x4F4, 0x4F8, 0x4FC, 0x500, 0x504,
+	0x508, 0x50C, 0x510, 0x514, 0x518, 0x51C, 0x520, 0x524, 0x528, 0x52C,
+	0x530, 0x534, 0x538, 0x53C, 0x540, 0x544, 0x548, 0x54C, 0x550, 0x600,
+	0x604, 0x608, 0x60C, 0x610, 0x614, 0x618, 0x61C, 0x620, 0x624, 0x628,
+	0x62C, 0x630, 0x634, 0x638, 0x63C, 0x640, 0x644, 0x648, 0x64C, 0x650,
+	0x654, 0x658, 0x65C, 0x660, 0x664, 0x668, 0x66C, 0x670,
+	/* the below pins can also be configured as GPIO[17:0] */
+	0x674, 0x678, 0x67C, 0x680, 0x684, 0x688, 0x494, 0x498, 0x49C, 0x4A0,
+	0x4A4, 0x4A8, 0x4AC, 0x4B0, 0x4E0, 0x4E4, 0x4E8, 0x4EC,
+};
+
+static unsigned pxa930_mfpr[] = {
+	/* GPIO[0:106] */
+	0x2E0, 0x2DC, 0x2E8, 0x2D8, 0x2E4, 0x2EC, 0x2F8, 0x2FC, 0x300, 0x2D4,
+	0x2F4, 0x2F0, 0x304, 0x310, 0x308, 0x30C, 0x4E8, 0x4F4, 0x4F8, 0x4FC,
+	0x518, 0x51C, 0x4EC, 0x500, 0x4F0, 0x504, 0x510, 0x514, 0x520, 0x600,
+	0x618, 0x610, 0x60C, 0x61C, 0x620, 0x628, 0x62C, 0x630, 0x634, 0x638,
+	0x63C, 0x614, 0x624, 0x608, 0x604, 0x50C, 0x508, 0x2BC, 0x2B4, 0x2B8,
+	0x2C8, 0x2C0, 0x2C4, 0x2D0, 0x2CC, 0x29C, 0x2A0, 0x294, 0x298, 0x2A4,
+	0x2A8, 0x2B0, 0x2AC, 0x640, 0x65C, 0x648, 0x644, 0x674, 0x658, 0x654,
+	0x660, 0x668, 0x664, 0x650, 0x66C, 0x64C, 0x670, 0x678, 0x67C, 0x694,
+	0x69C, 0x6A0, 0x6A4, 0x698, 0x6BC, 0x6B4, 0x6B0, 0x6C0, 0x6C4, 0x6AC,
+	0x680, 0x684, 0x688, 0x690, 0x68C, 0x6A8, 0x6B8, 0x418, 0x410, 0x41C,
+	0x414, 0x408, 0x324, 0x40C, 0x400, 0x328, 0x404,
+	/* not GPIO */
+	0x230,
+};
+
+/*
+ * pxa300_xxx_pins and pxa300_xxx_func are pairs.
+ * One is pin number, the other is function number.
+ */
+static const unsigned pxa300_uart1_8p_pins[] = {30, 31, 32, 33, 34, 35, 36, 37};
+static const unsigned pxa300_uart1_8p_func[] = {2, 2, 2, 2, 2, 2, 2, 2};
+static const unsigned pxa300_uart1_6p_pins[] = {77, 78, 79, 81, 83, 84};
+static const unsigned pxa300_uart1_6p_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned pxa300_uart2_4p_pins[] = {111, 112, 113, 114};
+static const unsigned pxa300_uart2_4p_func[] = {1, 1, 1, 1};
+static const unsigned pxa300_uart3_4p_pins[] = {107, 108, 109, 110};
+static const unsigned pxa300_uart3_4p_func[] = {1, 1, 1, 1};
+static const unsigned pxa300_uart3_2p_pins[] = {109, 110};
+static const unsigned pxa300_uart3_2p_func[] = {1, 1};
+static const unsigned pxa300_lcd_24p_pins[] = {54, 55, 56, 57, 58, 59, 60, 61,
+		62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76,
+		127};
+static const unsigned pxa300_lcd_24p_func[] = {1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2,
+		1};
+/* not include LCD_CS */
+static const unsigned pxa300_lcd_23p_pins[] = {54, 55, 56, 57, 58, 59, 60, 61,
+		62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76};
+static const unsigned pxa300_lcd_23p_func[] = {1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2};
+/* pxa300_ac97[] not include SDATA_IN_1 pin */
+static const unsigned pxa300_ac97_pins[] = {23, 24, 25, 27, 28, 29};
+static const unsigned pxa300_ac97_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned pxa300_ssp1_6p_pins[] = {85, 56, 87, 88, 89, 90};
+static const unsigned pxa300_ssp1_6p_func[] = {1, 1, 1, 1, 1, 1};
+/* SSPSCLK2 & SSPTXD2 */
+static const unsigned pxa300_ssp2_2p_pins[] = {25, 27};
+static const unsigned pxa300_ssp2_2p_func[] = {2, 2};
+/* SSPSCLK2, SSPSFRM2, SSPTXD2 & SSPEXTCLK2 */
+static const unsigned pxa300_ssp2_4p_pins[] = {25, 26, 27, 29};
+static const unsigned pxa300_ssp2_4p_func[] = {2, 2, 2, 2};
+static const unsigned pxa300_ssp3_4p_pins[] = {91, 92, 93, 94};
+static const unsigned pxa300_ssp3_4p_func[] = {1, 1, 1, 1};
+/* DKIN[1:0], MKIN[7:0] & MKOUT[7:0] */
+static const unsigned pxa300_kp_2d8i8o_pins[] = {107, 108, 115, 116, 117, 118,
+		119, 120, 130, 131, 121, 122, 123, 124, 125, 132, 133, 134};
+static const unsigned pxa300_kp_2d8i8o_func[] = {2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1};
+/* DKIN[1:0], MKIN[5:0] & MKOUT[4:0] */
+static const unsigned pxa300_kp_2d6i5o_pins[] = {107, 108, 115, 116, 117, 118,
+		119, 120, 121, 122, 123, 124, 125};
+static const unsigned pxa300_kp_2d6i5o_func[] = {2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1};
+/* MKIN[7:0] & MKOUT[5:0] */
+static const unsigned pxa300_kp_8i6o_pins[] = {115, 116, 117, 118, 119, 120,
+		130, 131, 121, 122, 123, 124, 125, 132};
+static const unsigned pxa300_kp_8i6o_func[] = {1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1};
+static const unsigned pxa300_mmc1_6p0_pins[] = {3, 4, 5, 6, 7, 8};
+static const unsigned pxa300_mmc1_6p0_func[] = {4, 4, 4, 4, 4, 4};
+static const unsigned pxa300_mmc1_6p1_pins[] = {3, 4, 5, 6, 7, 14};
+static const unsigned pxa300_mmc1_6p1_func[] = {4, 4, 4, 4, 4, 5};
+static const unsigned pxa300_mmc2_pins[] = {9, 10, 11, 12, 13, 14};
+static const unsigned pxa300_mmc2_func[] = {4, 4, 4, 4, 4, 4};
+static const unsigned pxa300_usbh_pins[] = {128, 129};
+static const unsigned pxa300_usbh_func[] = {1, 1};
+static const unsigned pxa300_usbp3_pins[] = {77, 78, 79, 80, 81, 82};
+static const unsigned pxa300_usbp3_func[] = {2, 2, 2, 2, 2, 2};
+static const unsigned pxa300_i2c_pins[] = {21, 22};
+static const unsigned pxa300_i2c_func[] = {1, 1};
+static const unsigned pxa300_smc_pins[] = {2};
+static const unsigned pxa300_smc_func[] = {1};
+static const unsigned pxa300_pwm3_pins[] = {20};
+static const unsigned pxa300_pwm3_func[] = {1};
+
+static struct pxa3xx_pin_group pxa300_pin_groups[] = {
+	{"ffuart-8p", pxa300_uart1_8p_func, ARRAY_AND_SIZE(pxa300_uart1_8p_pins)},
+	{"ffuart-6p", pxa300_uart1_6p_func, ARRAY_AND_SIZE(pxa300_uart1_6p_pins)},
+	{"btuart-4p", pxa300_uart2_4p_func, ARRAY_AND_SIZE(pxa300_uart2_4p_pins)},
+	{"stuart-4p", pxa300_uart3_4p_func, ARRAY_AND_SIZE(pxa300_uart3_4p_pins)},
+	{"stuart-2p", pxa300_uart3_2p_func, ARRAY_AND_SIZE(pxa300_uart3_2p_pins)},
+	{"lcd-24p", pxa300_lcd_24p_func, ARRAY_AND_SIZE(pxa300_lcd_24p_pins)},
+	{"lcd-23p", pxa300_lcd_23p_func, ARRAY_AND_SIZE(pxa300_lcd_23p_pins)},
+	{"ac97", pxa300_ac97_func, ARRAY_AND_SIZE(pxa300_ac97_pins)},
+	{"ssp2-2p", pxa300_ssp2_2p_func, ARRAY_AND_SIZE(pxa300_ssp2_2p_pins)},
+	{"ssp2-4p", pxa300_ssp2_4p_func, ARRAY_AND_SIZE(pxa300_ssp2_4p_pins)},
+	{"ssp3-4p", pxa300_ssp3_4p_func, ARRAY_AND_SIZE(pxa300_ssp3_4p_pins)},
+	{"key-18p", pxa300_kp_2d8i8o_func, ARRAY_AND_SIZE(pxa300_kp_2d8i8o_pins)},
+	{"key-13p", pxa300_kp_2d6i5o_func, ARRAY_AND_SIZE(pxa300_kp_2d6i5o_pins)},
+	{"key-14p", pxa300_kp_8i6o_func, ARRAY_AND_SIZE(pxa300_kp_8i6o_pins)},
+	{"mmc1-6p0", pxa300_mmc1_6p0_func, ARRAY_AND_SIZE(pxa300_mmc1_6p0_pins)},
+	{"mmc1-6p1", pxa300_mmc1_6p1_func, ARRAY_AND_SIZE(pxa300_mmc1_6p1_pins)},
+	{"mmc2", pxa300_mmc2_func, ARRAY_AND_SIZE(pxa300_mmc2_pins)},
+	{"usbh", pxa300_usbh_func, ARRAY_AND_SIZE(pxa300_usbh_pins)},
+	{"usbp3", pxa300_usbp3_func, ARRAY_AND_SIZE(pxa300_usbp3_pins)},
+	{"i2c", pxa300_i2c_func, ARRAY_AND_SIZE(pxa300_i2c_pins)},
+	{"smc", pxa300_smc_func, ARRAY_AND_SIZE(pxa300_smc_pins)},
+	{"pwm3", pxa300_pwm3_func, ARRAY_AND_SIZE(pxa300_pwm3_pins)},
+};
+
+static const char * const pxa300_uart0_grps[] = {"ffuart-8p", "ffuart-6p"};
+static const char * const pxa300_uart1_grps[] = {"btuart-4p"};
+static const char * const pxa300_uart2_grps[] = {"stuart-4p", "stuart-2p"};
+static const char * const pxa300_lcd_grps[] = {"lcd-24p", "lcd-23p"};
+static const char * const pxa300_ac97_grps[] = {"ac97"};
+static const char * const pxa300_ssp2_grps[] = {"ssp2-2p", "ssp2-4p"};
+static const char * const pxa300_ssp3_grps[] = {"ssp3-4p"};
+static const char * const pxa300_key_grps[] = {"key-18p", "key-13p", "key-14p"};
+static const char * const pxa300_mmc1_grps[] = {"mmc1-6p0", "mmc1-6p1"};
+static const char * const pxa300_mmc2_grps[] = {"mmc2"};
+static const char * const pxa300_usbh_grps[] = {"usbh"};
+static const char * const pxa300_usbp3_grps[] = {"usbp3"};
+static const char * const pxa300_i2c_grps[] = {"i2c"};
+static const char * const pxa300_smc_grps[] = {"smc"};
+static const char * const pxa300_pwm3_grps[] = {"pwm3"};
+
+static struct pxa3xx_pmx_func pxa300_pmx_functions[] = {
+	{"uart0",	ARRAY_AND_SIZE(pxa300_uart0_grps)},
+	{"uart1",	ARRAY_AND_SIZE(pxa300_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(pxa300_uart2_grps)},
+	{"lcd",		ARRAY_AND_SIZE(pxa300_lcd_grps)},
+	{"ac97",	ARRAY_AND_SIZE(pxa300_ac97_grps)},
+	{"ssp2",	ARRAY_AND_SIZE(pxa300_ssp2_grps)},
+	{"ssp3",	ARRAY_AND_SIZE(pxa300_ssp3_grps)},
+	{"key",		ARRAY_AND_SIZE(pxa300_key_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(pxa300_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(pxa300_mmc2_grps)},
+	{"usbh",	ARRAY_AND_SIZE(pxa300_usbh_grps)},
+	{"usbp3",	ARRAY_AND_SIZE(pxa300_usbp3_grps)},
+	{"i2c",		ARRAY_AND_SIZE(pxa300_i2c_grps)},
+	{"smc",		ARRAY_AND_SIZE(pxa300_smc_grps)},
+	{"pwm3",	ARRAY_AND_SIZE(pxa300_pwm3_grps)},
+};
+
+/* RxD, TxD, CTS, RTS of UART1 */
+static const unsigned pxa310_uart1_4p_pins[] = {99, 100, 101, 106};
+static const unsigned pxa310_uart1_4p_func[] = {1, 1, 1, 1};
+static const unsigned pxa310_mmc3_pins[] = {135, 136, 137, 138, 103, 105};
+static const unsigned pxa310_mmc3_func[] = {1, 1, 1, 1, 2, 2};
+static const unsigned pxa310_ulpi_pins[] = {30, 31, 32, 33, 34, 35, 36,
+		37, 38};
+static const unsigned pxa310_ulpi_func[] = {3, 3, 3, 3, 3, 3, 3, 3, 1};
+
+static struct pxa3xx_pin_group pxa310_pin_groups[] = {
+	{"ffuart-4p", pxa310_uart1_4p_func, ARRAY_AND_SIZE(pxa310_uart1_4p_pins)},
+	{"btuart-4p", pxa300_uart2_4p_func, ARRAY_AND_SIZE(pxa300_uart2_4p_pins)},
+	{"stuart-4p", pxa300_uart3_4p_func, ARRAY_AND_SIZE(pxa300_uart3_4p_pins)},
+	{"stuart-2p", pxa300_uart3_2p_func, ARRAY_AND_SIZE(pxa300_uart3_2p_pins)},
+	{"lcd-24p", pxa300_lcd_24p_func, ARRAY_AND_SIZE(pxa300_lcd_24p_pins)},
+	{"lcd-23p", pxa300_lcd_23p_func, ARRAY_AND_SIZE(pxa300_lcd_23p_pins)},
+	{"ac97", pxa300_ac97_func, ARRAY_AND_SIZE(pxa300_ac97_pins)},
+	{"ssp2-2p", pxa300_ssp2_2p_func, ARRAY_AND_SIZE(pxa300_ssp2_2p_pins)},
+	{"ssp3-4p", pxa300_ssp3_4p_func, ARRAY_AND_SIZE(pxa300_ssp3_4p_pins)},
+	{"key-18p", pxa300_kp_2d8i8o_func, ARRAY_AND_SIZE(pxa300_kp_2d8i8o_pins)},
+	{"key-13p", pxa300_kp_2d6i5o_func, ARRAY_AND_SIZE(pxa300_kp_2d6i5o_pins)},
+	{"key-14p", pxa300_kp_8i6o_func, ARRAY_AND_SIZE(pxa300_kp_8i6o_pins)},
+	{"mmc1-6p0", pxa300_mmc1_6p0_func, ARRAY_AND_SIZE(pxa300_mmc1_6p0_pins)},
+	{"mmc1-6p1", pxa300_mmc1_6p1_func, ARRAY_AND_SIZE(pxa300_mmc1_6p1_pins)},
+	{"mmc2", pxa300_mmc2_func, ARRAY_AND_SIZE(pxa300_mmc2_pins)},
+	{"mmc3", pxa310_mmc3_func, ARRAY_AND_SIZE(pxa310_mmc3_pins)},
+	{"usbh", pxa300_usbh_func, ARRAY_AND_SIZE(pxa300_usbh_pins)},
+	{"ulpi", pxa310_ulpi_func, ARRAY_AND_SIZE(pxa310_ulpi_pins)},
+	{"usbp3", pxa300_usbp3_func, ARRAY_AND_SIZE(pxa300_usbp3_pins)},
+	{"i2c", pxa300_i2c_func, ARRAY_AND_SIZE(pxa300_i2c_pins)},
+	{"smc", pxa300_smc_func, ARRAY_AND_SIZE(pxa300_smc_pins)},
+	{"pwm3", pxa300_pwm3_func, ARRAY_AND_SIZE(pxa300_pwm3_pins)},
+};
+
+static const char * const pxa310_uart0_grps[] = {"ffuart-4p"};
+static const char * const pxa310_mmc3_grps[] = {"mmc3"};
+static const char * const pxa310_ulpi_grps[] = {"ulpi"};
+
+static struct pxa3xx_pmx_func pxa310_pmx_functions[] = {
+	{"uart1",	ARRAY_AND_SIZE(pxa300_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(pxa300_uart2_grps)},
+	{"lcd",		ARRAY_AND_SIZE(pxa300_lcd_grps)},
+	{"ac97",	ARRAY_AND_SIZE(pxa300_ac97_grps)},
+	{"ssp3",	ARRAY_AND_SIZE(pxa300_ssp3_grps)},
+	{"key",		ARRAY_AND_SIZE(pxa300_key_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(pxa300_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(pxa300_mmc2_grps)},
+	{"usbh",	ARRAY_AND_SIZE(pxa300_usbh_grps)},
+	{"usbp3",	ARRAY_AND_SIZE(pxa300_usbp3_grps)},
+	{"i2c",		ARRAY_AND_SIZE(pxa300_i2c_grps)},
+	{"smc",		ARRAY_AND_SIZE(pxa300_smc_grps)},
+	{"pwm3",	ARRAY_AND_SIZE(pxa300_pwm3_grps)},
+	/* new in PXA310 */
+	{"uart0",	ARRAY_AND_SIZE(pxa310_uart0_grps)},
+	{"mmc3",	ARRAY_AND_SIZE(pxa310_mmc3_grps)},
+	{"ulpi",	ARRAY_AND_SIZE(pxa310_ulpi_grps)},
+};
+
+static const unsigned pxa320_lcd_pins[] = {134, 135, 136, 137, 138, 139,
+		140, 141, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74,
+		142, 143, 144, 145};
+static const unsigned pxa320_lcd_func[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1};
+static const unsigned pxa320_uart0_pins[] = {41, 42, 43, 44, 45, 46, 47, 48};
+static const unsigned pxa320_uart0_func[] = {2, 2, 2, 2, 2, 2, 2, 2};
+/* not include SDATA_IN_1 */
+static const unsigned pxa320_ac97_pins[] = {34, 35, 37, 38, 39, 40};
+static const unsigned pxa320_ac97_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned pxa320_ssp3_pins[] = {89, 90, 91, 92};
+static const unsigned pxa320_ssp3_func[] = {1, 1, 1, 1};
+static const unsigned pxa320_i2c_pins[] = {32, 33};
+static const unsigned pxa320_i2c_func[] = {1, 1};
+/* DKIN[1:0], MKIN[7:0] & MKOUT[7:0] */
+static const unsigned pxa320_key_pins[] = {105, 106, 113, 114, 115, 116, 117,
+		118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 133};
+static const unsigned pxa320_key_func[] = {2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1, 1, 1, 1};
+static const unsigned pxa320_smc_pins[] = {4};
+static const unsigned pxa320_smc_func[] = {1};
+static const unsigned pxa320_mmc1_pins[] = {18, 19, 20, 21, 22, 23};
+static const unsigned pxa320_mmc1_func[] = {4, 4, 4, 4, 4, 4};
+static const unsigned pxa320_mmc2_pins[] = {24, 25, 26, 27, 28, 29};
+static const unsigned pxa320_mmc2_func[] = {4, 4, 4, 4, 4, 4};
+static const unsigned pxa320_usbh_pins[] = {130, 131};
+static const unsigned pxa320_usbh_func[] = {1, 1};
+static const unsigned pxa320_pwm3_pins[] = {14};
+static const unsigned pxa320_pwm3_func[] = {1};
+static const unsigned pxa320_usim_pins[] = {15, 17};
+static const unsigned pxa320_usim_func[] = {1};
+
+static struct pxa3xx_pin_group pxa320_pin_groups[] = {
+	{"lcd", pxa320_lcd_func, ARRAY_AND_SIZE(pxa320_lcd_pins)},
+	{"ffuart", pxa320_uart0_func, ARRAY_AND_SIZE(pxa320_uart0_pins)},
+	{"ac97", pxa320_ac97_func, ARRAY_AND_SIZE(pxa320_ac97_pins)},
+	{"ssp3", pxa320_ssp3_func, ARRAY_AND_SIZE(pxa320_ssp3_pins)},
+	{"i2c", pxa320_i2c_func, ARRAY_AND_SIZE(pxa320_i2c_pins)},
+	{"key", pxa320_key_func, ARRAY_AND_SIZE(pxa320_key_pins)},
+	{"smc", pxa320_smc_func, ARRAY_AND_SIZE(pxa320_smc_pins)},
+	{"mmc1", pxa320_mmc1_func, ARRAY_AND_SIZE(pxa320_mmc1_pins)},
+	{"mmc2", pxa320_mmc2_func, ARRAY_AND_SIZE(pxa320_mmc2_pins)},
+	{"usbh", pxa320_usbh_func, ARRAY_AND_SIZE(pxa320_usbh_pins)},
+	{"pwm3", pxa320_pwm3_func, ARRAY_AND_SIZE(pxa320_pwm3_pins)},
+	{"usim", pxa320_usim_func, ARRAY_AND_SIZE(pxa320_usim_pins)},
+};
+
+static const char * const pxa320_lcd_grps[] = {"lcd"};
+static const char * const pxa320_uart0_grps[] = {"ffuart"};
+static const char * const pxa320_ac97_grps[] = {"ac97"};
+static const char * const pxa320_ssp3_grps[] = {"ssp3"};
+static const char * const pxa320_i2c_grps[] = {"i2c"};
+static const char * const pxa320_key_grps[] = {"key"};
+static const char * const pxa320_smc_grps[] = {"smc"};
+static const char * const pxa320_mmc1_grps[] = {"mmc1"};
+static const char * const pxa320_mmc2_grps[] = {"mmc2"};
+static const char * const pxa320_usbh_grps[] = {"usbh"};
+static const char * const pxa320_pwm3_grps[] = {"pwm3"};
+static const char * const pxa320_usim_grps[] = {"usim"};
+
+static struct pxa3xx_pmx_func pxa320_pmx_functions[] = {
+	{"lcd",		ARRAY_AND_SIZE(pxa320_lcd_grps)},
+	{"uart0",	ARRAY_AND_SIZE(pxa320_uart0_grps)},
+	{"ac97",	ARRAY_AND_SIZE(pxa320_ac97_grps)},
+	{"ssp3",	ARRAY_AND_SIZE(pxa320_ssp3_grps)},
+	{"i2c",		ARRAY_AND_SIZE(pxa320_i2c_grps)},
+	{"key",		ARRAY_AND_SIZE(pxa320_key_grps)},
+	{"smc",		ARRAY_AND_SIZE(pxa320_smc_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(pxa320_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(pxa320_mmc2_grps)},
+	{"usbh",	ARRAY_AND_SIZE(pxa320_usbh_grps)},
+	{"pwm3",	ARRAY_AND_SIZE(pxa320_pwm3_grps)},
+	{"usim",	ARRAY_AND_SIZE(pxa320_usim_grps)},
+};
+
+static const unsigned pxa930_smlcd_pins[] = {23, 24, 25, 26, 27, 28, 29,
+		44, 21, 22, 17, 18, 19};
+static const unsigned pxa930_smlcd_func[] = {1, 1, 1, 1, 1, 1, 1, 1,
+		1, 1, 1, 1, 1};
+static const unsigned pxa930_smc_pins[] = {107};
+static const unsigned pxa930_smc_func[] = {3};
+static const unsigned pxa930_uart0_pins[] = {53, 54};
+static const unsigned pxa930_uart0_func[] = {1, 1};
+static const unsigned pxa930_uart1_pins[] = {91, 92, 93, 94};
+static const unsigned pxa930_uart1_func[] = {1, 1, 1, 1};
+static const unsigned pxa930_uart2_pins[] = {45, 46};
+static const unsigned pxa930_uart2_func[] = {3, 3};
+static const unsigned pxa930_i2c_pins[] = {89, 90};
+static const unsigned pxa930_i2c_func[] = {1, 1};
+static const unsigned pxa930_ssp1_pins[] = {79, 80, 81, 82};
+static const unsigned pxa930_ssp1_func[] = {2, 2, 2, 2};
+static const unsigned pxa930_ssp2_pins[] = {85, 87, 88};
+static const unsigned pxa930_ssp2_func[] = {1, 1, 1};
+static const unsigned pxa930_qci_pins[] = {65, 66, 67, 68, 69, 70, 71, 72,
+		75, 76};
+static const unsigned pxa930_qci_func[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
+static const unsigned pxa930_mmc1_6p0_pins[] = {10, 11, 12, 13, 14, 15};
+static const unsigned pxa930_mmc1_6p0_func[] = {4, 4, 4, 4, 4, 4};
+static const unsigned pxa930_mmc1_6p1_pins[] = {55, 56, 57, 58, 59, 60};
+static const unsigned pxa930_mmc1_6p1_func[] = {3, 3, 3, 3, 3, 3};
+static const unsigned pxa930_mmc2_pins[] = {101, 102, 103, 104, 105, 106};
+static const unsigned pxa930_mmc2_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned pxa930_onewire_pins[] = {95};
+static const unsigned pxa930_onewire_func[] = {5};
+static const unsigned pxa930_key_pins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
+static const unsigned pxa930_key_func[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
+
+static struct pxa3xx_pin_group pxa930_pin_groups[] = {
+	{"smartlcd", pxa930_smlcd_func, ARRAY_AND_SIZE(pxa930_smlcd_pins)},
+	{"smc", pxa930_smc_func, ARRAY_AND_SIZE(pxa930_smc_pins)},
+	{"uart0", pxa930_uart0_func, ARRAY_AND_SIZE(pxa930_uart0_pins)},
+	{"uart1", pxa930_uart1_func, ARRAY_AND_SIZE(pxa930_uart1_pins)},
+	{"uart2", pxa930_uart2_func, ARRAY_AND_SIZE(pxa930_uart2_pins)},
+	{"ssp1", pxa930_ssp1_func, ARRAY_AND_SIZE(pxa930_ssp1_pins)},
+	{"ssp2", pxa930_ssp2_func, ARRAY_AND_SIZE(pxa930_ssp2_pins)},
+	{"mmc1-6p0", pxa930_mmc1_6p0_func, ARRAY_AND_SIZE(pxa930_mmc1_6p0_pins)},
+	{"mmc1-6p1", pxa930_mmc1_6p1_func, ARRAY_AND_SIZE(pxa930_mmc1_6p1_pins)},
+	{"mmc2", pxa930_mmc2_func, ARRAY_AND_SIZE(pxa930_mmc2_pins)},
+	{"i2c", pxa930_i2c_func, ARRAY_AND_SIZE(pxa930_i2c_pins)},
+	{"qci", pxa930_qci_func, ARRAY_AND_SIZE(pxa930_qci_pins)},
+	{"onewire", pxa930_onewire_func, ARRAY_AND_SIZE(pxa930_onewire_pins)},
+	{"key", pxa930_key_func, ARRAY_AND_SIZE(pxa930_key_pins)},
+};
+
+static const char * const pxa930_smlcd_grps[] = {"smartlcd"};
+static const char * const pxa930_smc_grps[] = {"smc"};
+static const char * const pxa930_uart0_grps[] = {"uart0"};
+static const char * const pxa930_uart1_grps[] = {"uart1"};
+static const char * const pxa930_uart2_grps[] = {"uart2"};
+static const char * const pxa930_ssp1_grps[] = {"ssp1"};
+static const char * const pxa930_ssp2_grps[] = {"ssp2"};
+static const char * const pxa930_mmc1_grps[] = {"mmc1_0", "mmc1_1"};
+static const char * const pxa930_mmc2_grps[] = {"mmc2"};
+static const char * const pxa930_i2c_grps[] = {"i2c"};
+static const char * const pxa930_qci_grps[] = {"qci"};
+static const char * const pxa930_onewire_grps[] = {"onewire"};
+static const char * const pxa930_key_grps[] = {"key"};
+
+static struct pxa3xx_pmx_func pxa930_pmx_functions[] = {
+	{"smartlcd",	ARRAY_AND_SIZE(pxa930_smlcd_grps)},
+	{"smc",		ARRAY_AND_SIZE(pxa930_smc_grps)},
+	{"uart0",	ARRAY_AND_SIZE(pxa930_uart0_grps)},
+	{"uart1",	ARRAY_AND_SIZE(pxa930_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(pxa930_uart2_grps)},
+	{"ssp1",	ARRAY_AND_SIZE(pxa930_ssp1_grps)},
+	{"ssp2",	ARRAY_AND_SIZE(pxa930_ssp2_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(pxa930_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(pxa930_mmc2_grps)},
+	{"i2c",		ARRAY_AND_SIZE(pxa930_i2c_grps)},
+	{"qci",		ARRAY_AND_SIZE(pxa930_qci_grps)},
+	{"onewire",	ARRAY_AND_SIZE(pxa930_onewire_grps)},
+	{"key",		ARRAY_AND_SIZE(pxa930_key_grps)},
+};
+
+static struct pinctrl_gpio_range pxa300_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 128),
+	PXA3xx_GPIO_RANGE(1, 0, 128, 7),
+};
+
+static struct pinctrl_gpio_range pxa310_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 128),
+	PXA3xx_GPIO_RANGE(1, 0, 128, 11),
+};
+
+static struct pinctrl_gpio_range pxa320_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 128),
+	PXA3xx_GPIO_RANGE(1, 0, 128, 18),
+};
+
+static struct pinctrl_gpio_range pxa930_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 107),
+};
+
+static struct pxa3xx_pinmux_info pxa300_pmx_info = {
+	.grp		= pxa300_pin_groups,
+	.func		= pxa300_pmx_functions,
+	.range		= pxa300_gpio_ranges,
+	.mfpr		= pxa300_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa300_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa300_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa300_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa300_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa300_pads),
+};
+
+static struct pxa3xx_pinmux_info pxa310_pmx_info = {
+	.grp		= pxa310_pin_groups,
+	.func		= pxa310_pmx_functions,
+	.range		= pxa310_gpio_ranges,
+	.mfpr		= pxa310_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa310_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa310_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa310_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa310_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa310_pads),
+};
+
+static struct pxa3xx_pinmux_info pxa320_pmx_info = {
+	.grp		= pxa320_pin_groups,
+	.func		= pxa320_pmx_functions,
+	.range		= pxa320_gpio_ranges,
+	.mfpr		= pxa320_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa320_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa320_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa320_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa320_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa320_pads),
+};
+
+static struct pxa3xx_pinmux_info pxa930_pmx_info = {
+	.grp		= pxa930_pin_groups,
+	.func		= pxa930_pmx_functions,
+	.range		= pxa930_gpio_ranges,
+	.mfpr		= pxa930_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa930_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa930_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa930_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa930_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa930_pads),
+};
+
+static struct pinctrl_desc pxa300_pctrl_desc = {
+	.name		= "pxa300-pinctrl",
+	.pctlops	= &pxa3xx_pctrl_ops,
+	.pmxops		= &pxa3xx_pmx_ops,
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static int __devinit pxa300_pinmux_probe(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info;
+	struct pxa3xx_pinmux_pdata *pdata;
+	struct resource *res;
+	int ret, i;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data of pxa3xx pinmux!\n");
+		return -ENOENT;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		return -ENOENT;
+	}
+	switch (pdata->cputype) {
+	case PINMUX_PXA300:
+		info = &pxa300_pmx_info;
+		pxa300_pctrl_desc.pins = pxa300_pads;
+		pxa300_pctrl_desc.npins = ARRAY_SIZE(pxa300_pads);
+		break;
+	case PINMUX_PXA310:
+		info = &pxa310_pmx_info;
+		pxa300_pctrl_desc.pins = pxa310_pads;
+		pxa300_pctrl_desc.npins = ARRAY_SIZE(pxa310_pads);
+		break;
+	case PINMUX_PXA320:
+		info = &pxa320_pmx_info;
+		pxa300_pctrl_desc.pins = pxa320_pads;
+		pxa300_pctrl_desc.npins = ARRAY_SIZE(pxa320_pads);
+		break;
+	case PINMUX_PXA930:
+		info = &pxa930_pmx_info;
+		pxa300_pctrl_desc.pins = pxa930_pads;
+		pxa300_pctrl_desc.npins = ARRAY_SIZE(pxa930_pads);
+		break;
+	default:
+		ret = -ENOENT;
+		goto out_cpu;
+	}
+	info->dev = &pdev->dev;
+	info->cputype = pdata->cputype;
+	info->phy_base = res->start;
+	info->phy_size = resource_size(res);
+	info->virt_base = ioremap(info->phy_base, info->phy_size);
+	if (!info->virt_base) {
+		ret = -ENOMEM;
+		goto out_cpu;
+	}
+	info->pctl = pinctrl_register(&pxa300_pctrl_desc, &pdev->dev, info);
+	if (!info->pctl) {
+		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
+		ret = -EINVAL;
+		goto out_reg;
+	}
+	for (i = 0; i < info->num_range; i++)
+		pinctrl_add_gpio_range(info->pctl, &info->range[i]);
+	platform_set_drvdata(pdev, info);
+	return 0;
+out_reg:
+	iounmap(info->virt_base);
+out_cpu:
+	return ret;
+}
+
+static int __devexit pxa300_pinmux_remove(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(info->pctl);
+	iounmap(info->virt_base);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver pxa300_pinmux_driver = {
+	.driver = {
+		.name = "pxa300-pinmux",
+		.owner = THIS_MODULE,
+	},
+	.probe = pxa300_pinmux_probe,
+	.remove = __devexit_p(pxa300_pinmux_remove),
+};
+
+static int __init pxa300_pinmux_init(void)
+{
+	return platform_driver_register(&pxa300_pinmux_driver);
+}
+postcore_initcall(pxa300_pinmux_init);
+
+static void __exit pxa300_pinmux_exit(void)
+{
+	platform_driver_unregister(&pxa300_pinmux_driver);
+}
+module_exit(pxa300_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA300 pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinmux-pxa910.c b/drivers/pinctrl/pinmux-pxa910.c
new file mode 100644
index 0000000..e20d8b6
--- /dev/null
+++ b/drivers/pinctrl/pinmux-pxa910.c
@@ -0,0 +1,373 @@
+/*
+ *  linux/drivers/pinctrl/pinmux-pxa910.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/pinctrl/pxa3xx.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PXA910_DS_MASK		0x1800
+#define PXA910_DS_SHIFT		11
+#define PXA910_SLEEP_MASK	0x38
+#define PXA910_SLEEP_SELECT	(1 << 9)
+#define PXA910_SLEEP_DATA	(1 << 8)
+#define PXA910_SLEEP_DIR	(1 << 7)
+
+static struct pinctrl_pin_desc pxa910_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+	GPIO123_GPIO127_PINS(),
+	PINCTRL_PIN(128, "MMC1 DAT7"),	PINCTRL_PIN(129, "MMC1 DAT6"),
+	PINCTRL_PIN(130, "MMC1 DAT5"),	PINCTRL_PIN(131, "MMC1 DAT4"),
+	PINCTRL_PIN(132, "MMC1 DAT3"),	PINCTRL_PIN(133, "MMC1 DAT2"),
+	PINCTRL_PIN(134, "MMC1 DAT1"),	PINCTRL_PIN(135, "MMC1 DAT0"),
+	PINCTRL_PIN(136, "MMC1 CMD"),	PINCTRL_PIN(137, "MMC1 CLK"),
+	PINCTRL_PIN(138, "MMC1 CD"),	PINCTRL_PIN(139, "MMC1 WP"),
+};
+
+static struct pinctrl_pin_desc mmp2_pads[] = {
+	GPIO0_GPIO106_PINS(),
+	GPIO107_GPIO122_PINS(),
+	GPIO123_GPIO127_PINS(),
+	GPIO128_GPIO168_PINS(),
+	PINCTRL_PIN(169, "PMIC INT"),
+};
+
+static unsigned pxa910_mfpr[] = {
+	0x0DC, 0x0E0, 0x0E4, 0x0E8, 0x0EC, 0x0F0, 0x0F4, 0x0F8, 0x0FC, 0x100,
+	0x104, 0x108, 0x10C, 0x110, 0x114, 0x118, 0x11C, 0x120, 0x124, 0x128,
+	0x12C, 0x130, 0x134, 0x138, 0x13C, 0x140, 0x144, 0x148, 0x14C, 0x150,
+	0x154, 0x158, 0x15C, 0x160, 0x164, 0x168, 0x16C, 0x170, 0x174, 0x178,
+	0x17C, 0x180, 0x184, 0x188, 0x18C, 0x190, 0x194, 0x198, 0x19C, 0x1A0,
+	0x1A4, 0x1A8, 0x1AC, 0x1B0, 0x1B4, 0x2F0, 0x2F4, 0x2F8, 0x2FC, 0x300,
+	0x304, 0x308, 0x30C, 0x310, 0x314, 0x318, 0x31C, 0x1B8, 0x1BC, 0x1C0,
+	0x1C4, 0x1C8, 0x1CC, 0x1D0, 0x1D4, 0x1D8, 0x1DC, 0x1E0, 0x1E4, 0x1E8,
+	0x1EC, 0x1F0, 0x1F4, 0x1F8, 0x1FC, 0x200, 0x204, 0x208, 0x20C, 0x210,
+	0x214, 0x218, 0x21C, 0x220, 0x224, 0x228, 0x22C, 0x230, 0x234, 0x0B0,
+	0x238, 0x23C, 0x240, 0x244, 0x248, 0x24C, 0x250, 0x254, 0x258, 0x25C,
+	0x298, 0x29C, 0x2A0, 0x2A4, 0x2A8, 0x2AC, 0x2B0, 0x0B4, 0x0B8, 0x0BC,
+	0x0C0, 0x32C, 0x0C8, 0x0CC, 0x0D0, 0x0D4, 0x06C, 0x070, 0x084, 0x088,
+	0x08C, 0x090, 0x094, 0x098, 0x09C, 0x0A0, 0x0A4, 0x0A8, 0x0AC, 0x0B0,
+};
+
+static unsigned mmp2_mfpr[] = {
+	0x054, 0x058, 0x05C, 0x060, 0x064, 0x068, 0x06C, 0x070, 0x074, 0x078,
+	0x07C, 0x080, 0x084, 0x088, 0x08C, 0x090, 0x094, 0x098, 0x09C, 0x0A0,
+	0x0A4, 0x0A8, 0x0AC, 0x0B0, 0x0B4, 0x0B8, 0x0BC, 0x0C0, 0x0C4, 0x0C8,
+	0x0CC, 0x0D0, 0x0D4, 0x0D8, 0x0DC, 0x0E0, 0x0E4, 0x0E8, 0x0EC, 0x0F0,
+	0x0F4, 0x0F8, 0x0FC, 0x100, 0x104, 0x108, 0x10C, 0x110, 0x114, 0x118,
+	0x11C, 0x120, 0x124, 0x128, 0x12C, 0x130, 0x134, 0x138, 0x13C, 0x280,
+	0x284, 0x288, 0x28C, 0x290, 0x294, 0x298, 0x29C, 0x2A0, 0x2A4, 0x2A8,
+	0x2AC, 0x2B0, 0x2B4, 0x2B8, 0x170, 0x174, 0x178, 0x17C, 0x180, 0x184,
+	0x188, 0x18C, 0x190, 0x194, 0x198, 0x19C, 0x1A0, 0x1A4, 0x1A8, 0x1AC,
+	0x1B0, 0x1B4, 0x1B8, 0x1BC, 0x1C0, 0x1C4, 0x1C8, 0x1CC, 0x1D0, 0x1D4,
+	0x1D8, 0x1DC, 0x000, 0x004, 0x1FC, 0x1F8, 0x1F4, 0x1F0, 0x21C, 0x218,
+	0x214, 0x200, 0x244, 0x25C, 0x164, 0x260, 0x264, 0x268, 0x26C, 0x270,
+	0x274, 0x278, 0x27C, 0x148, 0x00C, 0x010, 0x014, 0x018, 0x01C, 0x020,
+	0x024, 0x028, 0x02C, 0x030, 0x034, 0x038, 0x03C, 0x040, 0x044, 0x048,
+	0x04C, 0x050, 0x008, 0x220, 0x224, 0x228, 0x22C, 0x230, 0x234, 0x238,
+	0x23C, 0x240, 0x248, 0x24C, 0x254, 0x258, 0x14C, 0x150, 0x154, 0x158,
+	0x250, 0x210, 0x20C, 0x208, 0x204, 0x1EC, 0x1E8, 0x1E4, 0x1E0, 0x2C4,
+};
+
+static const unsigned pxa910_uart0_pins[] = {47, 48};
+static const unsigned pxa910_uart0_func[] = {6, 6};
+static const unsigned pxa910_uart1_pins[] = {29, 30, 31, 32};
+static const unsigned pxa910_uart1_func[] = {4, 4, 4, 4};
+static const unsigned pxa910_uart2_pins[] = {43, 44};
+static const unsigned pxa910_uart2_func[] = {7, 7};
+static const unsigned pxa910_twsi_pins[] = {53, 54};
+static const unsigned pxa910_twsi_func[] = {2, 2};
+static const unsigned pxa910_mmc1_pins[] = {128, 129, 130, 131, 132, 133, 134,
+		135, 136, 137, 138, 139};
+static const unsigned pxa910_mmc1_func[] = {0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0};
+static const unsigned pxa910_mmc2_pins[] = {37, 38, 39, 40, 41, 42};
+static const unsigned pxa910_mmc2_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned pxa910_ssp1_pins[] = {21, 22, 23, 24};
+static const unsigned pxa910_ssp1_func[] = {1, 1, 1, 1};
+static const unsigned pxa910_gssp_pins[] = {25, 26, 27, 28};
+static const unsigned pxa910_gssp_func[] = {1, 1, 1, 1};
+static const unsigned pxa910_kp_pins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 12};
+static const unsigned pxa910_kp_func[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
+
+static struct pxa3xx_pin_group pxa910_pin_groups[] = {
+	{"uart0", pxa910_uart0_func, ARRAY_AND_SIZE(pxa910_uart0_pins)},
+	{"uart1", pxa910_uart1_func, ARRAY_AND_SIZE(pxa910_uart1_pins)},
+	{"uart2", pxa910_uart2_func, ARRAY_AND_SIZE(pxa910_uart2_pins)},
+	{"twsi", pxa910_twsi_func, ARRAY_AND_SIZE(pxa910_twsi_pins)},
+	{"mmc1", pxa910_mmc1_func, ARRAY_AND_SIZE(pxa910_mmc1_pins)},
+	{"mmc2", pxa910_mmc2_func, ARRAY_AND_SIZE(pxa910_mmc2_pins)},
+	{"ssp1-4-pin", pxa910_ssp1_func, ARRAY_AND_SIZE(pxa910_ssp1_pins)},
+	{"gssp", pxa910_gssp_func, ARRAY_AND_SIZE(pxa910_gssp_pins)},
+	{"kp-6i-5o", pxa910_kp_func, ARRAY_AND_SIZE(pxa910_kp_pins)},
+};
+
+static const char * const pxa910_uart0_grps[] = {"uart0"};
+static const char * const pxa910_uart1_grps[] = {"uart1"};
+static const char * const pxa910_uart2_grps[] = {"uart2"};
+static const char * const pxa910_twsi_grps[] = {"twsi"};
+static const char * const pxa910_mmc1_grps[] = {"mmc1"};
+static const char * const pxa920_mmc2_grps[] = {"mmc2"};
+static const char * const pxa920_ssp1_grps[] = {"ssp1-4-pin"};
+static const char * const pxa920_gssp_grps[] = {"gssp"};
+static const char * const pxa920_kp_grps[] = {"kp-6i-5o"};
+
+static struct pxa3xx_pmx_func pxa910_pmx_functions[] = {
+	{"uart0",	ARRAY_AND_SIZE(pxa910_uart0_grps)},
+	{"uart1",	ARRAY_AND_SIZE(pxa910_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(pxa910_uart2_grps)},
+	{"twsi",	ARRAY_AND_SIZE(pxa910_twsi_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(pxa910_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(pxa920_mmc2_grps)},
+	{"ssp1",	ARRAY_AND_SIZE(pxa920_ssp1_grps)},
+	{"gssp",	ARRAY_AND_SIZE(pxa920_gssp_grps)},
+	{"kp",		ARRAY_AND_SIZE(pxa920_kp_grps)},
+};
+
+static struct pinctrl_gpio_range pxa910_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 107),
+};
+
+static const unsigned mmp2_uart1_4p_pins[] = {29, 30, 31, 32};
+static const unsigned mmp2_uart1_4p_func[] = {1, 1, 1, 1};
+static const unsigned mmp2_uart1_2p_pins[] = {45, 46};
+static const unsigned mmp2_uart1_2p_func[] = {1, 1};
+static const unsigned mmp2_uart2_4p_pins[] = {47, 48, 49, 50};
+static const unsigned mmp2_uart2_4p_func[] = {1, 1, 1, 1};
+static const unsigned mmp2_uart2_2p_pins[] = {47, 48};
+static const unsigned mmp2_uart2_2p_func[] = {1, 1};
+static const unsigned mmp2_uart3_pins[] = {51, 52};
+static const unsigned mmp2_uart3_func[] = {1, 1};
+static const unsigned mmp2_twsi2_pins[] = {43, 44};
+static const unsigned mmp2_twsi2_func[] = {1, 1};
+static const unsigned mmp2_twsi3_pins[] = {71, 72};
+static const unsigned mmp2_twsi3_func[] = {1, 1};
+static const unsigned mmp2_twsi5_pins[] = {99, 100};
+static const unsigned mmp2_twsi5_func[] = {4, 4};
+static const unsigned mmp2_twsi6_pins[] = {97, 98};
+static const unsigned mmp2_twsi6_func[] = {2, 2};
+static const unsigned mmp2_sspa1_pins[] = {24, 25, 26, 27, 28};
+static const unsigned mmp2_sspa1_func[] = {1, 1, 1, 1, 1};
+static const unsigned mmp2_sspa2_pins[] = {33, 34, 35, 36};
+static const unsigned mmp2_sspa2_func[] = {1, 1, 1, 1};
+static const unsigned mmp2_ssp3_pins[] = {74, 75, 76, 77};
+static const unsigned mmp2_ssp3_func[] = {4, 4, 4, 4};
+static const unsigned mmp2_mmc1_pins[] = {131, 132, 133, 134, 136, 139, 141, 140};
+static const unsigned mmp2_mmc1_func[] = {1, 1, 1, 1, 1, 1, 1, 1};
+static const unsigned mmp2_mmc2_pins[] = {37, 38, 39, 40, 41, 42};
+static const unsigned mmp2_mmc2_func[] = {1, 1, 1, 1, 1, 1};
+static const unsigned mmp2_mmc3_pins[] = {151, 112, 111, 168, 164, 167, 163,
+			166, 162, 165};
+static const unsigned mmp2_mmc3_func[] = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2};
+static const unsigned mmp2_pwm3_pins[] = {53};
+static const unsigned mmp2_pwm3_func[] = {5};
+/* HDMI CEC */
+static const unsigned mmp2_hdmi_pins[] = {54};
+static const unsigned mmp2_hdmi_func[] = {4};
+static const unsigned mmp2_dkin_4p_pins[] = {16, 17, 18, 19};
+static const unsigned mmp2_dkin_4p_func[] = {1, 1, 1, 1};
+static const unsigned mmp2_dkin_2p_pins[] = {16, 17};
+static const unsigned mmp2_dkin_2p_func[] = {1, 1};
+static const unsigned mmp2_pmic_pins[] = {169};
+static const unsigned mmp2_pmic_func[] = {0};
+
+static struct pxa3xx_pin_group mmp2_pin_groups[] = {
+	{"uart1-4-pin", mmp2_uart1_4p_func, ARRAY_AND_SIZE(mmp2_uart1_4p_pins)},
+	{"uart1-2-pin", mmp2_uart1_2p_func, ARRAY_AND_SIZE(mmp2_uart1_2p_pins)},
+	{"uart2-4-pin", mmp2_uart2_4p_func, ARRAY_AND_SIZE(mmp2_uart2_4p_pins)},
+	{"uart2-2-pin", mmp2_uart2_2p_func, ARRAY_AND_SIZE(mmp2_uart2_2p_pins)},
+	{"uart3", mmp2_uart3_func, ARRAY_AND_SIZE(mmp2_uart3_pins)},
+	{"twsi2", mmp2_twsi2_func, ARRAY_AND_SIZE(mmp2_twsi2_pins)},
+	{"twsi3", mmp2_twsi3_func, ARRAY_AND_SIZE(mmp2_twsi3_pins)},
+	{"twsi5", mmp2_twsi5_func, ARRAY_AND_SIZE(mmp2_twsi5_pins)},
+	{"twsi6", mmp2_twsi6_func, ARRAY_AND_SIZE(mmp2_twsi6_pins)},
+	{"sspa1", mmp2_sspa1_func, ARRAY_AND_SIZE(mmp2_sspa1_pins)},
+	{"sspa2", mmp2_sspa2_func, ARRAY_AND_SIZE(mmp2_sspa2_pins)},
+	{"ssp3", mmp2_ssp3_func, ARRAY_AND_SIZE(mmp2_ssp3_pins)},
+	{"mmc1", mmp2_mmc1_func, ARRAY_AND_SIZE(mmp2_mmc1_pins)},
+	{"mmc2", mmp2_mmc2_func, ARRAY_AND_SIZE(mmp2_mmc2_pins)},
+	{"mmc3", mmp2_mmc3_func, ARRAY_AND_SIZE(mmp2_mmc3_pins)},
+	{"pwm3", mmp2_pwm3_func, ARRAY_AND_SIZE(mmp2_pwm3_pins)},
+	{"hdmi", mmp2_hdmi_func, ARRAY_AND_SIZE(mmp2_hdmi_pins)},
+	{"dkin-4-pin", mmp2_dkin_4p_func, ARRAY_AND_SIZE(mmp2_dkin_4p_pins)},
+	{"dkin-2-pin", mmp2_dkin_2p_func, ARRAY_AND_SIZE(mmp2_dkin_2p_pins)},
+	{"pmic", mmp2_pmic_func, ARRAY_AND_SIZE(mmp2_pmic_pins)},
+};
+
+static const char * const mmp2_uart1_grps[] = {"uart1-4-pin", "uart1-2-pin"};
+static const char * const mmp2_uart2_grps[] = {"uart2-4-pin", "uart2-2-pin"};
+static const char * const mmp2_uart3_grps[] = {"uart3"};
+static const char * const mmp2_twsi2_grps[] = {"twsi2"};
+static const char * const mmp2_twsi3_grps[] = {"twsi3"};
+static const char * const mmp2_twsi5_grps[] = {"twsi5"};
+static const char * const mmp2_twsi6_grps[] = {"twsi6"};
+static const char * const mmp2_sspa1_grps[] = {"sspa1"};
+static const char * const mmp2_sspa2_grps[] = {"sspa2"};
+static const char * const mmp2_ssp3_grps[] = {"ssp3"};
+static const char * const mmp2_mmc1_grps[] = {"mmc1"};
+static const char * const mmp2_mmc2_grps[] = {"mmc2"};
+static const char * const mmp2_mmc3_grps[] = {"mmc3"};
+static const char * const mmp2_pwm3_grps[] = {"pwm3"};
+static const char * const mmp2_hdmi_grps[] = {"hdmi"};
+static const char * const mmp2_dkin_grps[] = {"dkin-4-pin", "dkin-2-pin"};
+static const char * const mmp2_pmic_grps[] = {"pmic"};
+
+static struct pxa3xx_pmx_func mmp2_pmx_functions[] = {
+	{"uart1",	ARRAY_AND_SIZE(mmp2_uart1_grps)},
+	{"uart2",	ARRAY_AND_SIZE(mmp2_uart2_grps)},
+	{"uart3",	ARRAY_AND_SIZE(mmp2_uart3_grps)},
+	{"twsi2",	ARRAY_AND_SIZE(mmp2_twsi2_grps)},
+	{"twsi3",	ARRAY_AND_SIZE(mmp2_twsi3_grps)},
+	{"twsi5",	ARRAY_AND_SIZE(mmp2_twsi5_grps)},
+	{"twsi6",	ARRAY_AND_SIZE(mmp2_twsi6_grps)},
+	{"sspa1",	ARRAY_AND_SIZE(mmp2_sspa1_grps)},
+	{"sspa2",	ARRAY_AND_SIZE(mmp2_sspa2_grps)},
+	{"ssp3",	ARRAY_AND_SIZE(mmp2_ssp3_grps)},
+	{"mmc1",	ARRAY_AND_SIZE(mmp2_mmc1_grps)},
+	{"mmc2",	ARRAY_AND_SIZE(mmp2_mmc2_grps)},
+	{"mmc3",	ARRAY_AND_SIZE(mmp2_mmc3_grps)},
+	{"pwm3",	ARRAY_AND_SIZE(mmp2_pwm3_grps)},
+	{"dkin",	ARRAY_AND_SIZE(mmp2_dkin_grps)},
+	{"pmic",	ARRAY_AND_SIZE(mmp2_pmic_grps)},
+};
+
+static struct pinctrl_gpio_range mmp2_gpio_ranges[] = {
+	PXA3xx_GPIO_RANGE(0, 0, 0, 169),
+};
+
+static struct pinctrl_desc pxa910_pctrl_desc = {
+	.name		= "pxa910-pinctrl",
+	.pctlops	= &pxa3xx_pctrl_ops,
+	.pmxops		= &pxa3xx_pmx_ops,
+	.maxpin		= 260,
+	.owner		= THIS_MODULE,
+};
+
+static struct pxa3xx_pinmux_info pxa910_pmx_info = {
+	.grp		= pxa910_pin_groups,
+	.func		= pxa910_pmx_functions,
+	.range		= pxa910_gpio_ranges,
+	.mfpr		= pxa910_mfpr,
+	.num_grps	= ARRAY_SIZE(pxa910_pin_groups),
+	.num_funcs	= ARRAY_SIZE(pxa910_pmx_functions),
+	.num_range	= ARRAY_SIZE(pxa910_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(pxa910_mfpr),
+	.num_pads	= ARRAY_SIZE(pxa910_pads),
+};
+
+static struct pxa3xx_pinmux_info mmp2_pmx_info = {
+	.grp		= mmp2_pin_groups,
+	.func		= mmp2_pmx_functions,
+	.range		= mmp2_gpio_ranges,
+	.mfpr		= mmp2_mfpr,
+	.num_grps	= ARRAY_SIZE(mmp2_pin_groups),
+	.num_funcs	= ARRAY_SIZE(mmp2_pmx_functions),
+	.num_range	= ARRAY_SIZE(mmp2_gpio_ranges),
+	.num_mfpr	= ARRAY_SIZE(mmp2_mfpr),
+	.num_pads	= ARRAY_SIZE(mmp2_pads),
+};
+
+static int __devinit pxa910_pinmux_probe(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info;
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+	enum pxa_cpu_type cputype = id->driver_data;
+	struct resource *res;
+	int ret = 0, i;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		return -ENOENT;
+	}
+	switch (cputype) {
+	case PINMUX_PXA910:
+		info = &pxa910_pmx_info;
+		pxa910_pctrl_desc.pins = pxa910_pads;
+		pxa910_pctrl_desc.npins = ARRAY_SIZE(pxa910_pads);
+		break;
+	case PINMUX_MMP2:
+		info = &mmp2_pmx_info;
+		pxa910_pctrl_desc.pins = mmp2_pads;
+		pxa910_pctrl_desc.npins = ARRAY_SIZE(mmp2_pads);
+		break;
+	default:
+		return -ENOENT;
+	}
+	info->dev = &pdev->dev;
+	info->cputype = cputype;
+	info->phy_base = res->start;
+	info->phy_size = resource_size(res);
+	info->virt_base = ioremap(info->phy_base, info->phy_size);
+	if (!info->virt_base) {
+		return -ENOMEM;
+	}
+	info->pctl = pinctrl_register(&pxa910_pctrl_desc, &pdev->dev, info);
+	if (!info->pctl) {
+		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	for (i = 0; i < info->num_range; i++)
+		pinctrl_add_gpio_range(info->pctl, &info->range[i]);
+	platform_set_drvdata(pdev, info);
+	return 0;
+out:
+	iounmap(info->virt_base);
+	return ret;
+}
+
+static int __devexit pxa910_pinmux_remove(struct platform_device *pdev)
+{
+	struct pxa3xx_pinmux_info *info = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(info->pctl);
+	iounmap(info->virt_base);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static const struct platform_device_id pxa910_pinmux_id_table[] = {
+	{ "pxa910-pinmux",	PINMUX_PXA910 },
+	{ "mmp2-pinmux",	PINMUX_MMP2 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, pxa910_pinmux_id_table);
+
+static struct platform_driver pxa910_pinmux_driver = {
+	.driver = {
+		.name	= "pxa910-pinmux",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= pxa910_pinmux_probe,
+	.remove		= __devexit_p(pxa910_pinmux_remove),
+	.id_table	= pxa910_pinmux_id_table,
+};
+
+static int __init pxa910_pinmux_init(void)
+{
+	return platform_driver_register(&pxa910_pinmux_driver);
+}
+postcore_initcall(pxa910_pinmux_init);
+
+static void __exit pxa910_pinmux_exit(void)
+{
+	platform_driver_unregister(&pxa910_pinmux_driver);
+}
+module_exit(pxa910_pinmux_exit);
+
+MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
+MODULE_DESCRIPTION("PXA910 pin control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/pinctrl/pxa3xx.h b/include/linux/pinctrl/pxa3xx.h
new file mode 100644
index 0000000..b1baa3a
--- /dev/null
+++ b/include/linux/pinctrl/pxa3xx.h
@@ -0,0 +1,213 @@
+/*
+ *  interface for pxa3xx pinmux
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2011, Marvell Technology Group Ltd.
+ *
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ */
+#ifndef __PINMUX_PXA3XX_H
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+enum pxa_cpu_type {
+	PINMUX_PXA300 = 0,
+	PINMUX_PXA310,
+	PINMUX_PXA320,
+	PINMUX_PXA168,
+	PINMUX_PXA910,
+	PINMUX_PXA930,
+	PINMUX_PXA955,
+	PINMUX_MMP2,
+	PINMUX_MAX,
+};
+
+#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
+#define MFPR_FUNC		7
+#define MFPR_FUNC_MASK		(~MFPR_FUNC)
+#define MFPR_PULL_MASK		0xE000
+#define MFPR_PULL_SEL		(1 << 15)
+#define MFPR_PULL_UP		(1 << 14)
+#define MFPR_PULL_DOWN		(1 << 13)
+#define MFPR_EDGE_MASK		0x0070
+#define MFPR_EDGE_SHIFT		4
+#define MFPR_EDGE_CLEAR		(1 << 6)
+#define MFPR_EDGE_FALL		(1 << 5)
+#define MFPR_EDGE_RISE		(1 << 4)
+#define DUMMY			0xFFFF
+
+#define PXA3xx_GPIO_RANGE(a, b, c, d)	{ .name = "pxa3xx-gpio", .id = a, \
+			.base = b, .pin_base = c, .npins = d }
+
+#define GPIO0_GPIO106_PINS()						\
+	PINCTRL_PIN(0, "GPIO0"), 	PINCTRL_PIN(1, "GPIO1"),	\
+	PINCTRL_PIN(2, "GPIO2"),	PINCTRL_PIN(3, "GPIO3"),	\
+	PINCTRL_PIN(4, "GPIO4"),	PINCTRL_PIN(5, "GPIO5"),	\
+	PINCTRL_PIN(6, "GPIO6"),	PINCTRL_PIN(7, "GPIO7"),	\
+	PINCTRL_PIN(8, "GPIO8"),	PINCTRL_PIN(9, "GPIO9"),	\
+	PINCTRL_PIN(10, "GPIO10"),	PINCTRL_PIN(11, "GPIO11"),	\
+	PINCTRL_PIN(12, "GPIO12"),	PINCTRL_PIN(13, "GPIO13"),	\
+	PINCTRL_PIN(14, "GPIO14"),	PINCTRL_PIN(15, "GPIO15"),	\
+	PINCTRL_PIN(16, "GPIO16"),	PINCTRL_PIN(17, "GPIO17"),	\
+	PINCTRL_PIN(18, "GPIO18"),	PINCTRL_PIN(19, "GPIO19"),	\
+	PINCTRL_PIN(20, "GPIO20"),	PINCTRL_PIN(21, "GPIO21"),	\
+	PINCTRL_PIN(22, "GPIO22"),	PINCTRL_PIN(23, "GPIO23"),	\
+	PINCTRL_PIN(24, "GPIO24"),	PINCTRL_PIN(25, "GPIO25"),	\
+	PINCTRL_PIN(26, "GPIO26"),	PINCTRL_PIN(27, "GPIO27"),	\
+	PINCTRL_PIN(28, "GPIO28"),	PINCTRL_PIN(29, "GPIO29"),	\
+	PINCTRL_PIN(30, "GPIO30"),	PINCTRL_PIN(31, "GPIO31"),	\
+	PINCTRL_PIN(32, "GPIO32"),	PINCTRL_PIN(33, "GPIO33"),	\
+	PINCTRL_PIN(34, "GPIO34"),	PINCTRL_PIN(35, "GPIO35"),	\
+	PINCTRL_PIN(36, "GPIO36"),	PINCTRL_PIN(37, "GPIO37"),	\
+	PINCTRL_PIN(38, "GPIO38"),	PINCTRL_PIN(39, "GPIO39"),	\
+	PINCTRL_PIN(40, "GPIO40"),	PINCTRL_PIN(41, "GPIO41"),	\
+	PINCTRL_PIN(42, "GPIO42"),	PINCTRL_PIN(43, "GPIO43"),	\
+	PINCTRL_PIN(44, "GPIO44"),	PINCTRL_PIN(45, "GPIO45"),	\
+	PINCTRL_PIN(46, "GPIO46"),	PINCTRL_PIN(47, "GPIO47"),	\
+	PINCTRL_PIN(48, "GPIO48"),	PINCTRL_PIN(49, "GPIO49"),	\
+	PINCTRL_PIN(50, "GPIO50"),	PINCTRL_PIN(51, "GPIO51"),	\
+	PINCTRL_PIN(52, "GPIO52"),	PINCTRL_PIN(53, "GPIO53"),	\
+	PINCTRL_PIN(54, "GPIO54"),	PINCTRL_PIN(55, "GPIO55"),	\
+	PINCTRL_PIN(56, "GPIO56"),	PINCTRL_PIN(57, "GPIO57"),	\
+	PINCTRL_PIN(58, "GPIO58"),	PINCTRL_PIN(59, "GPIO59"),	\
+	PINCTRL_PIN(60, "GPIO60"),	PINCTRL_PIN(61, "GPIO61"),	\
+	PINCTRL_PIN(62, "GPIO62"),	PINCTRL_PIN(63, "GPIO63"),	\
+	PINCTRL_PIN(64, "GPIO64"),	PINCTRL_PIN(65, "GPIO65"),	\
+	PINCTRL_PIN(66, "GPIO66"),	PINCTRL_PIN(67, "GPIO67"),	\
+	PINCTRL_PIN(68, "GPIO68"),	PINCTRL_PIN(69, "GPIO69"),	\
+	PINCTRL_PIN(70, "GPIO70"),	PINCTRL_PIN(71, "GPIO71"),	\
+	PINCTRL_PIN(72, "GPIO72"),	PINCTRL_PIN(73, "GPIO73"),	\
+	PINCTRL_PIN(74, "GPIO74"),	PINCTRL_PIN(75, "GPIO75"),	\
+	PINCTRL_PIN(76, "GPIO76"),	PINCTRL_PIN(77, "GPIO77"),	\
+	PINCTRL_PIN(78, "GPIO78"),	PINCTRL_PIN(79, "GPIO79"),	\
+	PINCTRL_PIN(80, "GPIO80"),	PINCTRL_PIN(81, "GPIO81"),	\
+	PINCTRL_PIN(82, "GPIO82"),	PINCTRL_PIN(83, "GPIO83"),	\
+	PINCTRL_PIN(84, "GPIO84"),	PINCTRL_PIN(85, "GPIO85"),	\
+	PINCTRL_PIN(86, "GPIO86"),	PINCTRL_PIN(87, "GPIO87"),	\
+	PINCTRL_PIN(88, "GPIO88"),	PINCTRL_PIN(89, "GPIO89"),	\
+	PINCTRL_PIN(90, "GPIO90"),	PINCTRL_PIN(91, "GPIO91"),	\
+	PINCTRL_PIN(92, "GPIO92"),	PINCTRL_PIN(93, "GPIO93"),	\
+	PINCTRL_PIN(94, "GPIO94"),	PINCTRL_PIN(95, "GPIO95"),	\
+	PINCTRL_PIN(96, "GPIO96"),	PINCTRL_PIN(97, "GPIO97"),	\
+	PINCTRL_PIN(98, "GPIO98"),	PINCTRL_PIN(99, "GPIO99"),	\
+	PINCTRL_PIN(100, "GPIO100"),	PINCTRL_PIN(101, "GPIO101"),	\
+	PINCTRL_PIN(102, "GPIO102"),	PINCTRL_PIN(103, "GPIO103"),	\
+	PINCTRL_PIN(104, "GPIO104"),	PINCTRL_PIN(105, "GPIO105"),	\
+	PINCTRL_PIN(106, "GPIO106")
+
+#define GPIO107_GPIO122_PINS()						\
+	PINCTRL_PIN(107, "GPIO107"),	PINCTRL_PIN(108, "GPIO108"),	\
+	PINCTRL_PIN(109, "GPIO109"),	PINCTRL_PIN(110, "GPIO110"),	\
+	PINCTRL_PIN(111, "GPIO111"),	PINCTRL_PIN(112, "GPIO112"),	\
+	PINCTRL_PIN(113, "GPIO113"),	PINCTRL_PIN(114, "GPIO114"),	\
+	PINCTRL_PIN(115, "GPIO115"),	PINCTRL_PIN(116, "GPIO116"),	\
+	PINCTRL_PIN(117, "GPIO117"),	PINCTRL_PIN(118, "GPIO118"),	\
+	PINCTRL_PIN(119, "GPIO119"),	PINCTRL_PIN(120, "GPIO120"),	\
+	PINCTRL_PIN(121, "GPIO121"),	PINCTRL_PIN(122, "GPIO122")
+
+#define GPIO123_GPIO127_PINS()						\
+	PINCTRL_PIN(123, "GPIO123"),	PINCTRL_PIN(124, "GPIO124"),	\
+	PINCTRL_PIN(125, "GPIO125"),	PINCTRL_PIN(126, "GPIO126"),	\
+	PINCTRL_PIN(127, "GPIO127")
+
+#define GPIO128_GPIO168_PINS()						\
+	PINCTRL_PIN(128, "GPIO128"),	PINCTRL_PIN(129, "GPIO129"),	\
+	PINCTRL_PIN(130, "GPIO130"),	PINCTRL_PIN(131, "GPIO131"),	\
+	PINCTRL_PIN(132, "GPIO132"),	PINCTRL_PIN(133, "GPIO133"),	\
+	PINCTRL_PIN(134, "GPIO134"),	PINCTRL_PIN(135, "GPIO135"),	\
+	PINCTRL_PIN(136, "GPIO136"),	PINCTRL_PIN(137, "GPIO137"),	\
+	PINCTRL_PIN(138, "GPIO138"),	PINCTRL_PIN(139, "GPIO139"),	\
+	PINCTRL_PIN(140, "GPIO140"),	PINCTRL_PIN(141, "GPIO141"),	\
+	PINCTRL_PIN(142, "GPIO142"),	PINCTRL_PIN(143, "GPIO143"),	\
+	PINCTRL_PIN(144, "GPIO144"),	PINCTRL_PIN(145, "GPIO145"),	\
+	PINCTRL_PIN(146, "GPIO146"),	PINCTRL_PIN(147, "GPIO147"),	\
+	PINCTRL_PIN(148, "GPIO148"),	PINCTRL_PIN(149, "GPIO149"),	\
+	PINCTRL_PIN(150, "GPIO150"),	PINCTRL_PIN(151, "GPIO151"),	\
+	PINCTRL_PIN(152, "GPIO152"),	PINCTRL_PIN(153, "GPIO153"),	\
+	PINCTRL_PIN(154, "GPIO154"),	PINCTRL_PIN(155, "GPIO155"),	\
+	PINCTRL_PIN(156, "GPIO156"),	PINCTRL_PIN(157, "GPIO157"),	\
+	PINCTRL_PIN(158, "GPIO158"),	PINCTRL_PIN(159, "GPIO159"),	\
+	PINCTRL_PIN(160, "GPIO160"),	PINCTRL_PIN(161, "GPIO161"),	\
+	PINCTRL_PIN(162, "GPIO162"),	PINCTRL_PIN(163, "GPIO163"),	\
+	PINCTRL_PIN(164, "GPIO164"),	PINCTRL_PIN(165, "GPIO165"),	\
+	PINCTRL_PIN(166, "GPIO166"),	PINCTRL_PIN(167, "GPIO167"),	\
+	PINCTRL_PIN(168, "GPIO168")
+
+#define DUP_GPIO0_GPIO6_PINS()						\
+	PINCTRL_PIN(128, "GPIO0_2"),	PINCTRL_PIN(129, "GPIO1_2"),	\
+	PINCTRL_PIN(130, "GPIO2_2"),	PINCTRL_PIN(131, "GPIO3_2"),	\
+	PINCTRL_PIN(132, "GPIO4_2"),	PINCTRL_PIN(133, "GPIO5_2"),	\
+	PINCTRL_PIN(134, "GPIO6_2")
+
+#define DUP_GPIO7_GPIO10_PINS()						\
+	PINCTRL_PIN(135, "GPIO7_2"),	PINCTRL_PIN(136, "GPIO8_2"),	\
+	PINCTRL_PIN(137, "GPIO9_2"),	PINCTRL_PIN(138, "GPIO10_2")
+
+enum pxa3xx_wakeup_config {
+	PXA3xx_NO_WAKEUP = 0,
+	PXA3xx_EDGE_RISE_WAKEUP,
+	PXA3xx_EDGE_FALL_WAKEUP,
+};
+
+enum pxa3xx_input_config {
+	PXA3xx_NO_EDGE = 0,
+	PXA3xx_EDGE_RISE,
+	PXA3xx_EDGE_FALL,
+	PXA3xx_EDGE_INVALID,
+};
+
+enum pxa910_lowpower_config {
+	PXA910_NO_LOWPOWER = 0,
+	PXA910_LOWPOWER_PULL_LOW,
+	PXA910_LOWPOWER_PULL_HIGH,
+	PXA910_LOWPOWER_DRIVE_LOW,
+	PXA910_LOWPOWER_DRIVE_HIGH,
+};
+
+struct pxa3xx_pinmux_pdata {
+	enum pxa_cpu_type cputype;
+};
+
+struct pxa3xx_pin_group {
+	const char *name;
+	const unsigned int *func;
+	const unsigned int *pins;
+	const unsigned int num_pins;
+};
+
+struct pxa3xx_pmx_func {
+	const char *name;
+	const char * const * groups;
+	const unsigned num_groups;
+};
+
+struct pxa3xx_pinmux_info {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	enum pxa_cpu_type cputype;
+	unsigned int phy_base;
+	unsigned int phy_size;
+	void __iomem *virt_base;
+	struct pxa3xx_pin_group *grp;
+	unsigned int num_grps;
+	struct pxa3xx_pmx_func *func;
+	unsigned int num_funcs;
+
+	unsigned int num_pads;
+	unsigned *mfpr;
+	unsigned int num_mfpr;
+	struct pinctrl_gpio_range *range;
+	unsigned int num_range;
+};
+
+extern struct pinmux_ops pxa3xx_pmx_ops;
+extern struct pinctrl_ops pxa3xx_pctrl_ops;
+
+extern int pxa3xx_get_mfpr(struct pxa3xx_pinmux_info *info, unsigned int pin);
+
+#endif	/* __PINMUX_PXA3XX_H */
-- 
1.7.0.4

