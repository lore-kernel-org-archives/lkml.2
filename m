Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2DRIHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:07:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49597 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab2DRIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:07:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] clk: wm831x: Add initial WM831x clock driver
Date: Wed, 18 Apr 2012 09:07:13 +0100
Message-Id: <1334736433-3402-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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
 drivers/clk/Makefile     |    1 +
 drivers/clk/clk-wm831x.c |  402 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 411 insertions(+)
 create mode 100644 drivers/clk/clk-wm831x.c

diff --git a/MAINTAINERS b/MAINTAINERS
index df3bc8c..20244ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7459,6 +7459,7 @@ W:	http://opensource.wolfsonmicro.com/content/linux-drivers-wolfson-devices
 S:	Supported
 F:	Documentation/hwmon/wm83??
 F:	arch/arm/mach-s3c64xx/mach-crag6410*
+F:	drivers/clk/clk-wm83*.c
 F:	drivers/leds/leds-wm83*.c
 F:	drivers/hwmon/wm83??-hwmon.c
 F:	drivers/input/misc/wm831x-on.c
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..367ba74 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -44,4 +44,11 @@ config COMMON_CLK_DEBUG
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
index 1f736bc..a155102 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 				   clk-mux.o clk-divider.o
+obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
new file mode 100644
index 0000000..3474591
--- /dev/null
+++ b/drivers/clk/clk-wm831x.c
@@ -0,0 +1,402 @@
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
+static int wm831x_fll_set_rate(struct clk_hw *hw, unsigned long rate)
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
+	if (!clk_register(&pdev->dev, "xtal", &wm831x_xtal_ops,
+			  &clkdata->xtal_hw, NULL, 0, CLK_IS_ROOT))
+		return -EINVAL;
+
+	if (!clk_register(&pdev->dev, "fll", &wm831x_fll_ops, &clkdata->fll_hw,
+			  wm831x_fll_parents, ARRAY_SIZE(wm831x_fll_parents),
+			  0)) {
+		ret = -EINVAL;
+		goto err_xtal;
+	}
+
+	if (!clk_register(&pdev->dev, "clkout", &wm831x_clkout_ops,
+			  &clkdata->clkout_hw, wm831x_clkout_parents,
+			  ARRAY_SIZE(wm831x_clkout_parents),
+			  CLK_SET_RATE_PARENT)) {
+		ret = -EINVAL;
+		goto err_fll;
+	}
+
+	dev_set_drvdata(&pdev->dev, clkdata);
+
+	return 0;
+
+err_fll:
+	clk_unregister(clkdata->fll_hw.clk);
+err_xtal:
+	clk_unregister(clkdata->xtal_hw.clk);
+	return ret;
+}
+
+static __devexit int wm831x_clk_remove(struct platform_device *pdev)
+{
+	struct wm831x_clk *clkdata = dev_get_drvdata(&pdev->dev);
+
+	clk_unregister(clkdata->clkout_hw.clk);
+	clk_unregister(clkdata->fll_hw.clk);
+	clk_unregister(clkdata->xtal_hw.clk);
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

