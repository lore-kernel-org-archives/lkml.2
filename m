Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2FDOox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:44:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50936 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab2FDOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:44:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: wm831x: Add initial WM831x clock driver
Date: Mon,  4 Jun 2012 15:44:48 +0100
Message-Id: <1338821089-9755-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x and WM832x series of PMICs contain a flexible clocking
subsystem intended to provide always on and system core clocks.  It
features:

- A 32.768kHz crystal oscillator which can optionally be used to pass
  through an externally generated clock.
- A FLL which can be clocked from either the 32.768kHz oscillator or
  the CLKIN pin.
- A CLKOUT pin which can bring out either the oscillator or the FLL
  output.
- The 32.768kHz clock can also optionally be brought out on the GPIO
  pins of the device.

This driver fully supports the 32.768kHz oscillator and CLKOUT.  The FLL
is supported only in AUTO mode, the full flexibility of the FLL cannot
currently be used.

Due to a lack of access to systems where the core SoC has been converted
to use the generic clock API this driver has been compile tested only.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS              |    1 +
 drivers/clk/Kconfig      |    7 +
 drivers/clk/Makefile     |    3 +
 drivers/clk/clk-wm831x.c |  428 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 439 insertions(+)
 create mode 100644 drivers/clk/clk-wm831x.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b54f50c..7b51a06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7575,6 +7575,7 @@ W:	http://opensource.wolfsonmicro.com/content/linux-drivers-wolfson-devices
 S:	Supported
 F:	Documentation/hwmon/wm83??
 F:	arch/arm/mach-s3c64xx/mach-crag6410*
+F:	drivers/clk/clk-wm83*.c
 F:	drivers/leds/leds-wm83*.c
 F:	drivers/hwmon/wm83??-hwmon.c
 F:	drivers/input/misc/wm831x-on.c
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6835e6a..7f0b5ca 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -33,4 +33,11 @@ config COMMON_CLK_DEBUG
 	  clk_flags, clk_prepare_count, clk_enable_count &
 	  clk_notifier_count.
 
+config COMMON_CLK_WM831X
+	tristate "Clock driver for WM831x/2x PMICs"
+	depends on MFD_WM831X
+	---help---
+          Supports the clocking subsystem of the WM831x/2x series of
+	  PMICs from Wolfson Microlectronics.
+
 endmenu
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index b9a5158..b679f11 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -5,3 +5,6 @@ obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 # SoCs specific
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
+
+# Chip specific
+obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
new file mode 100644
index 0000000..e7b7765
--- /dev/null
+++ b/drivers/clk/clk-wm831x.c
@@ -0,0 +1,428 @@
+/*
+ * WM831x clock control
+ *
+ * Copyright 2011-2 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/wm831x/core.h>
+
+struct wm831x_clk {
+	struct wm831x *wm831x;
+	struct clk_hw xtal_hw;
+	struct clk_hw fll_hw;
+	struct clk_hw clkout_hw;
+	struct clk *xtal;
+	struct clk *fll;
+	struct clk *clkout;
+	bool xtal_ena;
+};
+
+static int wm831x_xtal_is_enabled(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  xtal_hw);
+
+	return clkdata->xtal_ena;
+}
+
+static unsigned long wm831x_xtal_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  xtal_hw);
+
+	if (clkdata->xtal_ena)
+		return 32768;
+	else
+		return 0;
+}
+
+static const struct clk_ops wm831x_xtal_ops = {
+	.is_enabled = wm831x_xtal_is_enabled,
+	.recalc_rate = wm831x_xtal_recalc_rate,
+};
+
+static struct clk_init_data wm831x_xtal_init = {
+	.name = "xtal",
+	.ops = &wm831x_xtal_ops,
+	.flags = CLK_IS_ROOT,
+};
+
+static const unsigned long wm831x_fll_auto_rates[] = {
+	 2048000,
+	11289600,
+	12000000,
+	12288000,
+	19200000,
+	22579600,
+	24000000,
+	24576000,
+};
+
+static int wm831x_fll_is_enabled(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_FLL_CONTROL_1);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read FLL_CONTROL_1: %d\n",
+			ret);
+		return true;
+	}
+
+	return (ret & WM831X_FLL_ENA) != 0;
+}
+
+static int wm831x_fll_prepare(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_2,
+			      WM831X_FLL_ENA, WM831X_FLL_ENA);
+	if (ret != 0)
+		dev_crit(wm831x->dev, "Failed to enable FLL: %d\n", ret);
+
+	usleep_range(2000, 2000);
+
+	return ret;
+}
+
+static void wm831x_fll_unprepare(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_2, WM831X_FLL_ENA, 0);
+	if (ret != 0)
+		dev_crit(wm831x->dev, "Failed to disaable FLL: %d\n", ret);
+}
+
+static unsigned long wm831x_fll_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_2: %d\n",
+			ret);
+		return 0;
+	}
+
+	if (ret & WM831X_FLL_AUTO)
+		return wm831x_fll_auto_rates[ret & WM831X_FLL_AUTO_FREQ_MASK];
+
+	dev_err(wm831x->dev, "FLL only supported in AUTO mode\n");
+
+	return 0;
+}
+
+static long wm831x_fll_round_rate(struct clk_hw *hw, unsigned long rate,
+				  unsigned long *unused)
+{
+	int best = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_fll_auto_rates); i++)
+		if (abs(wm831x_fll_auto_rates[i] - rate) <
+		    abs(wm831x_fll_auto_rates[best] - rate))
+			best = i;
+
+	return wm831x_fll_auto_rates[best];
+}
+
+static int wm831x_fll_set_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long parent_rate)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_fll_auto_rates); i++)
+		if (wm831x_fll_auto_rates[i] == rate)
+			break;
+	if (i == ARRAY_SIZE(wm831x_fll_auto_rates))
+		return -EINVAL;
+
+	if (wm831x_fll_is_enabled(hw))
+		return -EPERM;
+
+	return wm831x_set_bits(wm831x, WM831X_CLOCK_CONTROL_2,
+			       WM831X_FLL_AUTO_FREQ_MASK, i);
+}
+
+static const char *wm831x_fll_parents[] = {
+	"xtal",
+	"clkin",
+};
+
+static u8 wm831x_fll_get_parent(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  fll_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	/* AUTO mode is always clocked from the crystal */
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_2: %d\n",
+			ret);
+		return 0;
+	}
+
+	if (ret & WM831X_FLL_AUTO)
+		return 0;
+
+	ret = wm831x_reg_read(wm831x, WM831X_FLL_CONTROL_5);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read FLL_CONTROL_5: %d\n",
+			ret);
+		return 0;
+	}
+
+	switch (ret & WM831X_FLL_CLK_SRC_MASK) {
+	case 0:
+		return 0;
+	case 1:
+		return 1;
+	default:
+		dev_err(wm831x->dev, "Unsupported FLL clock source %d\n",
+			ret & WM831X_FLL_CLK_SRC_MASK);
+		return 0;
+	}
+}
+
+static const struct clk_ops wm831x_fll_ops = {
+	.is_enabled = wm831x_fll_is_enabled,
+	.prepare = wm831x_fll_prepare,
+	.unprepare = wm831x_fll_unprepare,
+	.round_rate = wm831x_fll_round_rate,
+	.recalc_rate = wm831x_fll_recalc_rate,
+	.set_rate = wm831x_fll_set_rate,
+	.get_parent = wm831x_fll_get_parent,
+};
+
+static struct clk_init_data wm831x_fll_init = {
+	.name = "fll",
+	.ops = &wm831x_fll_ops,
+	.parent_names = wm831x_fll_parents,
+	.num_parents = ARRAY_SIZE(wm831x_fll_parents),
+	.flags = CLK_SET_RATE_GATE,
+};
+
+static int wm831x_clkout_is_enabled(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  clkout_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_1);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_1: %d\n",
+			ret);
+		return true;
+	}
+
+	return (ret & WM831X_CLKOUT_ENA) != 0;
+}
+
+static int wm831x_clkout_prepare(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  clkout_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret != 0) {
+		dev_crit(wm831x->dev, "Failed to lock registers: %d\n", ret);
+		return ret;
+	}
+
+	ret = wm831x_set_bits(wm831x, WM831X_CLOCK_CONTROL_1,
+			      WM831X_CLKOUT_ENA, WM831X_CLKOUT_ENA);
+	if (ret != 0)
+		dev_crit(wm831x->dev, "Failed to enable CLKOUT: %d\n", ret);
+
+	wm831x_reg_lock(wm831x);
+
+	return ret;
+}
+
+static void wm831x_clkout_unprepare(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  clkout_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret != 0) {
+		dev_crit(wm831x->dev, "Failed to lock registers: %d\n", ret);
+		return;
+	}
+
+	ret = wm831x_set_bits(wm831x, WM831X_CLOCK_CONTROL_1,
+			      WM831X_CLKOUT_ENA, 0);
+	if (ret != 0)
+		dev_crit(wm831x->dev, "Failed to disable CLKOUT: %d\n", ret);
+
+	wm831x_reg_lock(wm831x);
+}
+
+static const char *wm831x_clkout_parents[] = {
+	"xtal",
+	"fll",
+};
+
+static u8 wm831x_clkout_get_parent(struct clk_hw *hw)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  clkout_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_1);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_1: %d\n",
+			ret);
+		return 0;
+	}
+
+	if (ret & WM831X_CLKOUT_SRC)
+		return 0;
+	else
+		return 1;
+}
+
+static int wm831x_clkout_set_parent(struct clk_hw *hw, u8 parent)
+{
+	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
+						  clkout_hw);
+	struct wm831x *wm831x = clkdata->wm831x;
+
+	return wm831x_set_bits(wm831x, WM831X_CLOCK_CONTROL_1,
+			       WM831X_CLKOUT_SRC,
+			       parent << WM831X_CLKOUT_SRC_SHIFT);
+}
+
+static const struct clk_ops wm831x_clkout_ops = {
+	.is_enabled = wm831x_clkout_is_enabled,
+	.prepare = wm831x_clkout_prepare,
+	.unprepare = wm831x_clkout_unprepare,
+	.get_parent = wm831x_clkout_get_parent,
+	.set_parent = wm831x_clkout_set_parent,
+};
+
+static struct clk_init_data wm831x_clkout_init = {
+	.name = "clkout",
+	.ops = &wm831x_clkout_ops,
+	.parent_names = wm831x_clkout_parents,
+	.num_parents = ARRAY_SIZE(wm831x_clkout_parents),
+	.flags = CLK_SET_RATE_PARENT,
+};
+
+static __devinit int wm831x_clk_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_clk *clkdata;
+	int ret;
+
+	clkdata = devm_kzalloc(&pdev->dev, sizeof(*clkdata), GFP_KERNEL);
+	if (!clkdata)
+		return -ENOMEM;
+
+	/* XTAL_ENA can only be set via OTP/InstantConfig so just read once */
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_2: %d\n",
+			ret);
+		return ret;
+	}
+	clkdata->xtal_ena = ret & WM831X_XTAL_ENA;
+
+	clkdata->xtal_hw.init = &wm831x_xtal_init;
+	clkdata->xtal = clk_register(&pdev->dev, &clkdata->xtal_hw);
+	if (!clkdata->xtal)
+		return -EINVAL;
+
+	clkdata->fll_hw.init = &wm831x_fll_init;
+	clkdata->fll = clk_register(&pdev->dev, &clkdata->fll_hw);
+	if (!clkdata->fll) {
+		ret = -EINVAL;
+		goto err_xtal;
+	}
+
+	clkdata->clkout_hw.init = &wm831x_clkout_init;
+	clkdata->clkout = clk_register(&pdev->dev, &clkdata->clkout_hw);
+	if (!clkdata->clkout) {
+		ret = -EINVAL;
+		goto err_fll;
+	}
+
+	dev_set_drvdata(&pdev->dev, clkdata);
+
+	return 0;
+
+err_fll:
+	clk_unregister(clkdata->fll);
+err_xtal:
+	clk_unregister(clkdata->xtal);
+	return ret;
+}
+
+static int __devexit wm831x_clk_remove(struct platform_device *pdev)
+{
+	struct wm831x_clk *clkdata = dev_get_drvdata(&pdev->dev);
+
+	clk_unregister(clkdata->clkout);
+	clk_unregister(clkdata->fll);
+	clk_unregister(clkdata->xtal);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_clk_driver = {
+	.probe = wm831x_clk_probe,
+	.remove = __devexit_p(wm831x_clk_remove),
+	.driver		= {
+		.name	= "wm831x-clk",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(wm831x_clk_driver);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM831x clock driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-clk");
-- 
1.7.10

