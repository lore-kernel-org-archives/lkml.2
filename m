Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439Ab2CBM55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:57:57 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:56712 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2CBM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:57:55 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] regulator: Remove bq24022 regulator driver
Date: Fri, 2 Mar 2012 13:57:44 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
References: <201203021355.21669.heiko@sntech.de>
In-Reply-To: <201203021355.21669.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021357.44770.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bq24022 driver is just a specialised form of a gpio-regulator.

As all former users of it now use the gpio-regulator directly, there
is no need to keep it around.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/Kconfig         |    8 --
 drivers/regulator/Makefile        |    1 -
 drivers/regulator/bq24022.c       |  162 -------------------------------------
 include/linux/regulator/bq24022.h |   24 ------
 4 files changed, 0 insertions(+), 195 deletions(-)
 delete mode 100644 drivers/regulator/bq24022.c
 delete mode 100644 include/linux/regulator/bq24022.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c733df5..25cfe1c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -250,14 +250,6 @@ config REGULATOR_DB8500_PRCMU
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
 
-config REGULATOR_BQ24022
-	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
-	help
-	  This driver controls a TI bq24022 Charger attached via
-	  GPIOs. The provided current regulator can enable/disable
-	  charging select between 100 mA and 500 mA charging current
-	  limit.
-
 config REGULATOR_TPS6105X
 	tristate "TI TPS6105X Power regulators"
 	depends on TPS6105X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index cf0934b..1339198 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
-obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
deleted file mode 100644
index 9fab6d1..0000000
--- a/drivers/regulator/bq24022.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
- * 1-Cell Li-Ion Charger connected via GPIOs.
- *
- * Copyright (c) 2008 Philipp Zabel
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/gpio.h>
-#include <linux/regulator/bq24022.h>
-#include <linux/regulator/driver.h>
-
-
-static int bq24022_set_current_limit(struct regulator_dev *rdev,
-					int min_uA, int max_uA)
-{
-	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "setting current limit to %s mA\n",
-		max_uA >= 500000 ? "500" : "100");
-
-	/* REVISIT: maybe return error if min_uA != 0 ? */
-	gpio_set_value(pdata->gpio_iset2, max_uA >= 500000);
-	return 0;
-}
-
-static int bq24022_get_current_limit(struct regulator_dev *rdev)
-{
-	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
-
-	return gpio_get_value(pdata->gpio_iset2) ? 500000 : 100000;
-}
-
-static int bq24022_enable(struct regulator_dev *rdev)
-{
-	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "enabling charger\n");
-
-	gpio_set_value(pdata->gpio_nce, 0);
-	return 0;
-}
-
-static int bq24022_disable(struct regulator_dev *rdev)
-{
-	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "disabling charger\n");
-
-	gpio_set_value(pdata->gpio_nce, 1);
-	return 0;
-}
-
-static int bq24022_is_enabled(struct regulator_dev *rdev)
-{
-	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
-
-	return !gpio_get_value(pdata->gpio_nce);
-}
-
-static struct regulator_ops bq24022_ops = {
-	.set_current_limit = bq24022_set_current_limit,
-	.get_current_limit = bq24022_get_current_limit,
-	.enable            = bq24022_enable,
-	.disable           = bq24022_disable,
-	.is_enabled        = bq24022_is_enabled,
-};
-
-static struct regulator_desc bq24022_desc = {
-	.name  = "bq24022",
-	.ops   = &bq24022_ops,
-	.type  = REGULATOR_CURRENT,
-	.owner = THIS_MODULE,
-};
-
-static int __init bq24022_probe(struct platform_device *pdev)
-{
-	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
-	struct regulator_dev *bq24022;
-	int ret;
-
-	if (!pdata || !pdata->gpio_nce || !pdata->gpio_iset2)
-		return -EINVAL;
-
-	ret = gpio_request(pdata->gpio_nce, "ncharge_en");
-	if (ret) {
-		dev_dbg(&pdev->dev, "couldn't request nCE GPIO: %d\n",
-			pdata->gpio_nce);
-		goto err_ce;
-	}
-	ret = gpio_request(pdata->gpio_iset2, "charge_mode");
-	if (ret) {
-		dev_dbg(&pdev->dev, "couldn't request ISET2 GPIO: %d\n",
-			pdata->gpio_iset2);
-		goto err_iset2;
-	}
-	ret = gpio_direction_output(pdata->gpio_iset2, 0);
-	ret = gpio_direction_output(pdata->gpio_nce, 1);
-
-	bq24022 = regulator_register(&bq24022_desc, &pdev->dev,
-				     pdata->init_data, pdata, NULL);
-	if (IS_ERR(bq24022)) {
-		dev_dbg(&pdev->dev, "couldn't register regulator\n");
-		ret = PTR_ERR(bq24022);
-		goto err_reg;
-	}
-	platform_set_drvdata(pdev, bq24022);
-	dev_dbg(&pdev->dev, "registered regulator\n");
-
-	return 0;
-err_reg:
-	gpio_free(pdata->gpio_iset2);
-err_iset2:
-	gpio_free(pdata->gpio_nce);
-err_ce:
-	return ret;
-}
-
-static int __devexit bq24022_remove(struct platform_device *pdev)
-{
-	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
-	struct regulator_dev *bq24022 = platform_get_drvdata(pdev);
-
-	regulator_unregister(bq24022);
-	gpio_free(pdata->gpio_iset2);
-	gpio_free(pdata->gpio_nce);
-
-	return 0;
-}
-
-static struct platform_driver bq24022_driver = {
-	.driver = {
-		.name = "bq24022",
-	},
-	.remove = __devexit_p(bq24022_remove),
-};
-
-static int __init bq24022_init(void)
-{
-	return platform_driver_probe(&bq24022_driver, bq24022_probe);
-}
-
-static void __exit bq24022_exit(void)
-{
-	platform_driver_unregister(&bq24022_driver);
-}
-
-module_init(bq24022_init);
-module_exit(bq24022_exit);
-
-MODULE_AUTHOR("Philipp Zabel");
-MODULE_DESCRIPTION("TI bq24022 Li-Ion Charger driver");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/bq24022.h b/include/linux/regulator/bq24022.h
deleted file mode 100644
index a6d0140..0000000
--- a/include/linux/regulator/bq24022.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
- * 1-Cell Li-Ion Charger connected via GPIOs.
- *
- * Copyright (c) 2008 Philipp Zabel
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-struct regulator_init_data;
-
-/**
- * bq24022_mach_info - platform data for bq24022
- * @gpio_nce: GPIO line connected to the nCE pin, used to enable / disable charging
- * @gpio_iset2: GPIO line connected to the ISET2 pin, used to limit charging current to 100 mA / 500 mA
- */
-struct bq24022_mach_info {
-	int gpio_nce;
-	int gpio_iset2;
-	struct regulator_init_data *init_data;
-};
-- 
1.7.5.4

