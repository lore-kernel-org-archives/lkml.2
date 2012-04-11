Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab2DKTAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:00:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46916 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab2DKTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:00:46 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: tegra: refactor probe handling
Date: Wed, 11 Apr 2012 13:00:39 -0600
Message-Id: <1334170839-10396-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Rather than having a single tegra-pinctrl driver that determines whether
it's running on Tegra20 or Tegra30, instead have separate drivers for
each that call into utility functions to implement the majority of the
driver. This change is based on review feedback of the SPEAr pinctrl
driver, which had originally copied to Tegra driver structure.

This requires that the two drivers have unique names. Update a couple
spots in arch/arm/mach-tegra for the name change.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Linus, It'll be easiest for me to merge this through the Tegra tree, since
the arch/arm changes depend on the patches there that switch to using the
pinctrl driver. If you could ack this, it'd be great. Thanks.

 arch/arm/mach-tegra/board-pinmux.h |    2 +-
 arch/arm/mach-tegra/devices.c      |    2 +-
 drivers/pinctrl/pinctrl-tegra.c    |   80 +++++------------------------------
 drivers/pinctrl/pinctrl-tegra.h    |   23 +---------
 drivers/pinctrl/pinctrl-tegra20.c  |   40 ++++++++++++++++-
 drivers/pinctrl/pinctrl-tegra30.c  |   40 ++++++++++++++++-
 6 files changed, 91 insertions(+), 96 deletions(-)

diff --git a/arch/arm/mach-tegra/board-pinmux.h b/arch/arm/mach-tegra/board-pinmux.h
index 45b5ad8..c5f3f33 100644
--- a/arch/arm/mach-tegra/board-pinmux.h
+++ b/arch/arm/mach-tegra/board-pinmux.h
@@ -19,7 +19,7 @@
 
 #include <mach/pinconf-tegra.h>
 
-#define PINMUX_DEV "tegra-pinmux"
+#define PINMUX_DEV "tegra20-pinctrl"
 
 #define TEGRA_MAP_MUX(_group_, _function_) \
 	PIN_MAP_MUX_GROUP_HOG_DEFAULT(PINMUX_DEV, _group_, _function_)
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index 58e5803..2d8dfa2 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -110,7 +110,7 @@ static struct resource pinmux_resource[] = {
 };
 
 struct platform_device tegra_pinmux_device = {
-	.name		= "tegra-pinmux",
+	.name		= "tegra20-pinctrl",
 	.id		= -1,
 	.resource	= pinmux_resource,
 	.num_resources	= ARRAY_SIZE(pinmux_resource),
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index f6eba9c..3ac8ad3 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -1,7 +1,7 @@
 /*
  * Driver for the NVIDIA Tegra pinmux
  *
- * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
  *
  * Derived from code:
  * Copyright (C) 2010 Google, Inc.
@@ -22,7 +22,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
@@ -31,10 +32,9 @@
 
 #include <mach/pinconf-tegra.h>
 
+#include "core.h"
 #include "pinctrl-tegra.h"
 
-#define DRIVER_NAME "tegra-pinmux"
-
 struct tegra_pmx {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
@@ -87,7 +87,7 @@ static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 				       struct seq_file *s,
 				       unsigned offset)
 {
-	seq_printf(s, " " DRIVER_NAME);
+	seq_printf(s, " %s", dev_name(pctldev->dev));
 }
 
 static int reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
@@ -589,60 +589,29 @@ static struct pinctrl_gpio_range tegra_pinctrl_gpio_range = {
 };
 
 static struct pinctrl_desc tegra_pinctrl_desc = {
-	.name = DRIVER_NAME,
 	.pctlops = &tegra_pinctrl_ops,
 	.pmxops = &tegra_pinmux_ops,
 	.confops = &tegra_pinconf_ops,
 	.owner = THIS_MODULE,
 };
 
-static struct of_device_id tegra_pinctrl_of_match[] __devinitdata = {
-#ifdef CONFIG_PINCTRL_TEGRA20
-	{
-		.compatible = "nvidia,tegra20-pinmux",
-		.data = tegra20_pinctrl_init,
-	},
-#endif
-#ifdef CONFIG_PINCTRL_TEGRA30
-	{
-		.compatible = "nvidia,tegra30-pinmux",
-		.data = tegra30_pinctrl_init,
-	},
-#endif
-	{},
-};
-
-static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
+int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
+			const struct tegra_pinctrl_soc_data *soc_data)
 {
-	const struct of_device_id *match;
-	tegra_pinctrl_soc_initf initf = NULL;
 	struct tegra_pmx *pmx;
 	struct resource *res;
 	int i;
 
-	match = of_match_device(tegra_pinctrl_of_match, &pdev->dev);
-	if (match)
-		initf = (tegra_pinctrl_soc_initf)match->data;
-#ifdef CONFIG_PINCTRL_TEGRA20
-	if (!initf)
-		initf = tegra20_pinctrl_init;
-#endif
-	if (!initf) {
-		dev_err(&pdev->dev,
-			"Could not determine SoC-specific init func\n");
-		return -EINVAL;
-	}
-
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
 	if (!pmx) {
 		dev_err(&pdev->dev, "Can't alloc tegra_pmx\n");
 		return -ENOMEM;
 	}
 	pmx->dev = &pdev->dev;
-
-	(*initf)(&pmx->soc);
+	pmx->soc = soc_data;
 
 	tegra_pinctrl_gpio_range.npins = pmx->soc->ngpios;
+	tegra_pinctrl_desc.name = dev_name(&pdev->dev);
 	tegra_pinctrl_desc.pins = pmx->soc->pins;
 	tegra_pinctrl_desc.npins = pmx->soc->npins;
 
@@ -697,8 +666,9 @@ static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(tegra_pinctrl_probe);
 
-static int __devexit tegra_pinctrl_remove(struct platform_device *pdev)
+int __devexit tegra_pinctrl_remove(struct platform_device *pdev)
 {
 	struct tegra_pmx *pmx = platform_get_drvdata(pdev);
 
@@ -707,30 +677,4 @@ static int __devexit tegra_pinctrl_remove(struct platform_device *pdev)
 
 	return 0;
 }
-
-static struct platform_driver tegra_pinctrl_driver = {
-	.driver = {
-		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_pinctrl_of_match,
-	},
-	.probe = tegra_pinctrl_probe,
-	.remove = __devexit_p(tegra_pinctrl_remove),
-};
-
-static int __init tegra_pinctrl_init(void)
-{
-	return platform_driver_register(&tegra_pinctrl_driver);
-}
-arch_initcall(tegra_pinctrl_init);
-
-static void __exit tegra_pinctrl_exit(void)
-{
-	platform_driver_unregister(&tegra_pinctrl_driver);
-}
-module_exit(tegra_pinctrl_exit);
-
-MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
-MODULE_DESCRIPTION("NVIDIA Tegra pinctrl driver");
-MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(of, tegra_pinctrl_of_match);
+EXPORT_SYMBOL_GPL(tegra_pinctrl_remove);
diff --git a/drivers/pinctrl/pinctrl-tegra.h b/drivers/pinctrl/pinctrl-tegra.h
index 782c795..705c007 100644
--- a/drivers/pinctrl/pinctrl-tegra.h
+++ b/drivers/pinctrl/pinctrl-tegra.h
@@ -139,25 +139,8 @@ struct tegra_pinctrl_soc_data {
 	unsigned ngroups;
 };
 
-/**
- * tegra_pinctrl_soc_initf() - Retrieve pin controller details for a SoC.
- * @soc_data:	This pointer must be updated to point at a struct containing
- *		details of the SoC.
- */
-typedef void (*tegra_pinctrl_soc_initf)(
-			const struct tegra_pinctrl_soc_data **soc_data);
-
-/**
- * tegra20_pinctrl_init() - Retrieve pin controller details for Tegra20
- * @soc_data:	This pointer will be updated to point at a struct containing
- *		details of Tegra20's pin controller.
- */
-void tegra20_pinctrl_init(const struct tegra_pinctrl_soc_data **soc_data);
-/**
- * tegra30_pinctrl_init() - Retrieve pin controller details for Tegra20
- * @soc_data:	This pointer will be updated to point at a struct containing
- *		details of Tegra30's pin controller.
- */
-void tegra30_pinctrl_init(const struct tegra_pinctrl_soc_data **soc_data);
+int tegra_pinctrl_probe(struct platform_device *pdev,
+			const struct tegra_pinctrl_soc_data *soc_data);
+int tegra_pinctrl_remove(struct platform_device *pdev);
 
 #endif
diff --git a/drivers/pinctrl/pinctrl-tegra20.c b/drivers/pinctrl/pinctrl-tegra20.c
index f69ff96..a74f9a5 100644
--- a/drivers/pinctrl/pinctrl-tegra20.c
+++ b/drivers/pinctrl/pinctrl-tegra20.c
@@ -1,7 +1,7 @@
 /*
  * Pinctrl data for the NVIDIA Tegra20 pinmux
  *
- * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
  *
  * Derived from code:
  * Copyright (C) 2010 Google, Inc.
@@ -17,6 +17,8 @@
  * more details.
  */
 
+#include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
@@ -2854,7 +2856,39 @@ static const struct tegra_pinctrl_soc_data tegra20_pinctrl = {
 	.ngroups = ARRAY_SIZE(tegra20_groups),
 };
 
-void __devinit tegra20_pinctrl_init(const struct tegra_pinctrl_soc_data **soc)
+static int __devinit tegra20_pinctrl_probe(struct platform_device *pdev)
 {
-	*soc = &tegra20_pinctrl;
+	return tegra_pinctrl_probe(pdev, &tegra20_pinctrl);
 }
+
+static struct of_device_id tegra20_pinctrl_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-pinmux", },
+	{ },
+};
+
+static struct platform_driver tegra20_pinctrl_driver = {
+	.driver = {
+		.name = "tegra20-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra20_pinctrl_of_match,
+	},
+	.probe = tegra20_pinctrl_probe,
+	.remove = __devexit_p(tegra_pinctrl_remove),
+};
+
+static int __init tegra20_pinctrl_init(void)
+{
+	return platform_driver_register(&tegra20_pinctrl_driver);
+}
+arch_initcall(tegra20_pinctrl_init);
+
+static void __exit tegra20_pinctrl_exit(void)
+{
+	platform_driver_unregister(&tegra20_pinctrl_driver);
+}
+module_exit(tegra20_pinctrl_exit);
+
+MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra20 pinctrl driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, tegra20_pinctrl_of_match);
diff --git a/drivers/pinctrl/pinctrl-tegra30.c b/drivers/pinctrl/pinctrl-tegra30.c
index 4d7571d..0386fdf 100644
--- a/drivers/pinctrl/pinctrl-tegra30.c
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -1,7 +1,7 @@
 /*
  * Pinctrl data for the NVIDIA Tegra30 pinmux
  *
- * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -13,6 +13,8 @@
  * more details.
  */
 
+#include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
@@ -3720,7 +3722,39 @@ static const struct tegra_pinctrl_soc_data tegra30_pinctrl = {
 	.ngroups = ARRAY_SIZE(tegra30_groups),
 };
 
-void __devinit tegra30_pinctrl_init(const struct tegra_pinctrl_soc_data **soc)
+static int __devinit tegra30_pinctrl_probe(struct platform_device *pdev)
 {
-	*soc = &tegra30_pinctrl;
+	return tegra_pinctrl_probe(pdev, &tegra30_pinctrl);
 }
+
+static struct of_device_id tegra30_pinctrl_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra30-pinmux", },
+	{ },
+};
+
+static struct platform_driver tegra30_pinctrl_driver = {
+	.driver = {
+		.name = "tegra30-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra30_pinctrl_of_match,
+	},
+	.probe = tegra30_pinctrl_probe,
+	.remove = __devexit_p(tegra_pinctrl_remove),
+};
+
+static int __init tegra30_pinctrl_init(void)
+{
+	return platform_driver_register(&tegra30_pinctrl_driver);
+}
+arch_initcall(tegra30_pinctrl_init);
+
+static void __exit tegra30_pinctrl_exit(void)
+{
+	platform_driver_unregister(&tegra30_pinctrl_driver);
+}
+module_exit(tegra30_pinctrl_exit);
+
+MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra30 pinctrl driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, tegra30_pinctrl_of_match);
-- 
1.7.0.4

