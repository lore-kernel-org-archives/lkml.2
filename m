Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1ECNnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:43:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:5429
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab1ECNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:43:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz936eKc8kzz1202hzz8275bhz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Date: Tue, 3 May 2011 19:12:21 +0530
Subject: [PATCHv1 -next] REGULATOR: Regulator module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 -next] REGULATOR: Regulator module of DA9052 PMIC
 driver
Thread-Index: AcwJl+0oTPtA3NF5TMm4OUCVOzFrpA==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AF7A@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p43DhLCT025327

Hi Mark,

Regulator Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. separate ops for buck peri

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---

diff -Naur linux-next-20110421.orig/drivers/regulator/da9052-regulator.c linux-next-20110421/drivers/regulator/da9052-regulator.c
--- linux-next-20110421.orig/drivers/regulator/da9052-regulator.c       1970-01-01 05:00:00.000000000 +0500
+++ linux-next-20110421/drivers/regulator/da9052-regulator.c    2011-05-03 17:18:49.000000000 +0500
@@ -0,0 +1,502 @@
+/*
+* da9052-regulator.c: Regulator driver for DA9052
+*
+* Copyright(c) 2011 Dialog Semiconductor Ltd.
+*
+*Author: David Dajun Chen <dchen@diasemi.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/pdata.h>
+
+/* LDO and Buck index */
+#define DA9052_BUCK_CORE               0
+#define DA9052_BUCK_PRO                1
+#define DA9052_BUCK_MEM                2
+#define DA9052_BUCK_PERI               3
+
+#define DA9052_LDO2                    4
+#define DA9052_LDO3                    5
+
+/* Buck step size Macros */
+#define DA9052_BUCK_PERI_3uV_STEP                      100000
+#define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV      24
+#define DA9052_CONST_3uV                               3000000
+
+#define DA9052_REGULATOR_INIT(max, min) \
+{\
+       .constraints = {\
+               .max_uV         = (max) * 1000,\
+               .min_uV         = (min) * 1000,\
+               .valid_ops_mask = REGULATOR_CHANGE_VOLTAGE\
+               |REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
+               .valid_modes_mask = REGULATOR_MODE_NORMAL,\
+       },\
+}
+
+struct regulator_init_data da9052_regulators_init[] = {
+       /* BUCKS */
+       DA9052_REGULATOR_INIT(2075, 500),
+       DA9052_REGULATOR_INIT(2075, 500),
+       DA9052_REGULATOR_INIT(2500, 925),
+       DA9052_REGULATOR_INIT(3600, 1800),
+       /* LDO */
+       DA9052_REGULATOR_INIT(1800, 600),
+       DA9052_REGULATOR_INIT(1800, 600),
+       DA9052_REGULATOR_INIT(3300, 1725),
+       DA9052_REGULATOR_INIT(3300, 1725),
+       DA9052_REGULATOR_INIT(3600, 1200),
+       DA9052_REGULATOR_INIT(3600, 1200),
+       DA9052_REGULATOR_INIT(3600, 1200),
+       DA9052_REGULATOR_INIT(3600, 1200),
+       DA9052_REGULATOR_INIT(3650, 1250),
+       DA9052_REGULATOR_INIT(3600, 1200),
+
+};
+
+struct da9052_regulator_info {
+       struct regulator_desc reg_desc;
+       int step_uV;
+       int max_uV;
+       int min_uV;
+       unsigned char volt_shift;
+       unsigned char enable_bit;
+       unsigned char supply_v_mask;
+
+};
+
+struct da9052_regulator {
+       struct da9052 *da9052;
+       struct regulator_dev *rdev;
+};
+
+static inline struct da9052 *to_da9052(struct regulator_dev *rdev)
+{
+       return rdev_get_dev(rdev)->parent->parent;
+}
+
+static int verify_range(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+
+       if (min_uV < info->min_uV || min_uV > info->max_uV)
+                       return -EINVAL;
+       if (max_uV < info->min_uV || max_uV > info->max_uV)
+                       return -EINVAL;
+
+       return 0;
+}
+
+static int da9052_regulator_enable(struct regulator_dev *rdev)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+
+       ret = da9052_reg_update(da9052, DA9052_BUCKCORE_REG + offset,
+                       1 << info->enable_bit, 1 << info->enable_bit);
+       if (ret < 0)
+               return -EIO;
+
+       return 0;
+}
+
+static int da9052_regulator_disable(struct regulator_dev *rdev)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+
+       ret = da9052_reg_update(da9052, DA9052_BUCKCORE_REG + offset,
+                                               1 << info->enable_bit, 0);
+       if (ret < 0)
+               return -EIO;
+
+       return 0;
+}
+
+static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+
+       ret = da9052_reg_read(da9052, DA9052_BUCKCORE_REG + offset);
+
+       if (ret < 0)
+               return -EIO;
+
+       return ret & (1 << info->enable_bit);
+
+}
+
+static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
+                                                       unsigned int selector)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       int volt_uV;
+
+       if (selector >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV) {
+               volt_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV * info->step_uV) +
+                                       info->min_uV);
+               volt_uV += (selector - DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
+                                               *(DA9052_BUCK_PERI_3uV_STEP);
+               } else {
+                       volt_uV = (selector * info->step_uV) + info->min_uV;
+               }
+
+       if (volt_uV > info->max_uV)
+               return -EINVAL;
+
+       return volt_uV;
+}
+
+static int da9052_list_voltage(struct regulator_dev *rdev,
+                                               unsigned int selector)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       int volt_uV;
+
+       volt_uV = info->min_uV + info->step_uV * selector;
+
+       if (volt_uV > info->max_uV)
+               return -EINVAL;
+
+       return volt_uV;
+}
+
+static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
+                                int max_uV, unsigned int *selector)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+
+       /* Verify voltage range */
+       if (verify_range(rdev, min_uV, max_uV))
+               return -EINVAL;
+
+       /* Determine the voltage selector */
+       if (min_uV >= DA9052_CONST_3uV)
+               *selector = DA9052_CONST_3uV + ((min_uV - DA9052_CONST_3uV) /
+                                       (DA9052_BUCK_PERI_3uV_STEP));
+       else
+               *selector = (min_uV - info->min_uV) / info->step_uV;
+
+       /* Validate the selector */
+       if (da9052_list_buckperi_voltage(rdev, *selector))
+                       return -EINVAL;
+
+       ret = da9052_reg_update(da9052, DA9052_BUCKCORE_REG + offset,
+                       (1 << info->volt_shift) - 1, *selector);
+       if (ret < 0)
+               return -EIO;
+
+       return 0;
+}
+
+static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
+                       int min_uV, int max_uV, unsigned int *selector)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+
+       /* Verify voltage range */
+       if (verify_range(rdev, min_uV, max_uV))
+               return -EINVAL;
+
+       /* Determine voltage selector */
+       *selector = (min_uV - info->min_uV) / info->step_uV;
+
+       /* Validate the selector */
+       if (da9052_list_voltage(rdev, *selector))
+                       return -EINVAL;
+
+       ret = da9052_reg_update(da9052, DA9052_BUCKCORE_REG + offset,
+                       (1 << info->volt_shift) - 1, *selector);
+       if (ret < 0)
+               return -EIO;
+
+       /* Enable regualtor bit */
+       if (info->supply_v_mask != 0) {
+               ret = da9052_reg_update(da9052, DA9052_SUPPLY_REG, 0,
+                                               info->supply_v_mask);
+               if (ret < 0)
+                       return -EIO;
+       }
+
+       return 0;
+}
+
+static int da9052_get_buckperi_voltage(struct regulator_dev *rdev)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+       int regval;
+       int volt_uV;
+
+       ret = da9052_reg_read(da9052, DA9052_BUCKCORE_REG + offset);
+
+       if (ret < 0)
+               return -EIO;
+
+       regval = ret & ((1 << info->volt_shift) - 1);
+
+       /* Convert regsister value into micro volt */
+       volt_uV = da9052_list_buckperi_voltage(rdev, regval);
+
+       return volt_uV;
+}
+
+
+static int da9052_regulator_get_voltage(struct regulator_dev *rdev)
+{
+       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
+       struct da9052 *da9052 = to_da9052(rdev);
+       int offset = rdev_get_id(rdev);
+       int ret;
+       int regval;
+       int volt_uV;
+
+       ret = da9052_reg_read(da9052, DA9052_BUCKCORE_REG + offset);
+
+       if (ret < 0)
+               return -EIO;
+
+       regval = ret & ((1 << info->volt_shift) - 1);
+
+       /* Convert regsister value into micro volt */
+       volt_uV = da9052_list_voltage(rdev, regval);
+
+       return volt_uV;
+}
+
+
+static struct regulator_ops da9052_buckperi_ops = {
+       .is_enabled             = da9052_regulator_is_enabled,
+       .enable         = da9052_regulator_enable,
+       .disable                = da9052_regulator_disable,
+       .get_voltage    = da9052_get_buckperi_voltage,
+       .set_voltage    = da9052_set_buckperi_voltage,
+       .list_voltage   = da9052_list_buckperi_voltage,
+};
+
+
+static struct regulator_ops da9052_regulator_ops = {
+       .is_enabled             = da9052_regulator_is_enabled,
+       .enable         = da9052_regulator_enable,
+       .disable                = da9052_regulator_disable,
+       .get_voltage    = da9052_regulator_get_voltage,
+       .set_voltage    = da9052_regulator_set_voltage,
+       .list_voltage   = da9052_list_voltage,
+};
+
+#define DA9052_LDO(_id, step, max, min, sbits, ebits, mbits) \
+{\
+               .reg_desc       = {\
+               .name                   = "LDO" #_id,\
+               .ops                    = &da9052_regulator_ops,\
+               .type                   = REGULATOR_VOLTAGE,\
+               .id                     = _id,\
+               .owner          = THIS_MODULE,\
+       },\
+               .max_uV         = (max) * 1000,\
+               .min_uV         = (min) * 1000,\
+               .step_uV                = (step) * 1000,\
+               .volt_shift             = (sbits),\
+               .enable_bit             = (ebits),\
+               .supply_v_mask  = (mbits),\
+}
+
+#define DA9052_DCDC(_id, step, max, min, sbits, ebits, mbits) \
+{\
+               .reg_desc       = {\
+               .name                   = "BUCK" #_id,\
+               .ops                    = &da9052_regulator_ops,\
+               .type                   = REGULATOR_VOLTAGE,\
+               .id                     = _id,\
+               .owner          = THIS_MODULE,\
+       },\
+               .max_uV         = (max) * 1000,\
+               .min_uV         = (min) * 1000,\
+               .step_uV                = (step) * 1000,\
+               .volt_shift             = (sbits),\
+               .enable_bit             = (ebits),\
+               .supply_v_mask  = (mbits),\
+}
+
+#define DA9052_BUCKPERI(_id, step, max, min, sbits, ebits, mbits) \
+{\
+               .reg_desc       = {\
+               .name                   = "BUCK" #_id,\
+               .ops                    = &da9052_buckperi_ops,\
+               .type                   = REGULATOR_VOLTAGE,\
+               .id                     = _id,\
+               .owner          = THIS_MODULE,\
+       },\
+               .max_uV         = (max) * 1000,\
+               .min_uV         = (min) * 1000,\
+               .step_uV                = (step) * 1000,\
+               .volt_shift             = (sbits),\
+               .enable_bit             = (ebits),\
+               .supply_v_mask  = (mbits),\
+}
+
+struct da9052_regulator_info da9052_regulator_info[] = {
+       /* Buck1 - 4*/
+       DA9052_DCDC(0, 25, 2075, 500, 6, 6, DA9052_SUPPLY_VBCOREGO),
+       DA9052_DCDC(1, 25, 2075, 500, 6, 6, DA9052_SUPPLY_VBPROGO),
+       DA9052_DCDC(2, 25, 2500, 925, 6, 6, DA9052_SUPPLY_VBMEMGO),
+       DA9052_BUCKPERI(3, 50, 3600, 1800, 5, 6, 0),
+       /* LD01 - LDO10*/
+       DA9052_LDO(4, 50, 1800, 600, 5, 6, 0),
+       DA9052_LDO(5, 25, 1800, 600, 6, 6, DA9052_SUPPLY_VLDO2GO),
+       DA9052_LDO(6, 25, 3300, 1725, 6, 6, DA9052_SUPPLY_VLDO3GO),
+       DA9052_LDO(7, 25, 3300, 1725, 6, 6, 0),
+       DA9052_LDO(8, 50, 3600, 1200, 6, 6, 0),
+       DA9052_LDO(9, 50, 3600, 1200, 6, 6, 0),
+       DA9052_LDO(10, 50, 3600, 1200, 6, 6, 0),
+       DA9052_LDO(11, 50, 3600, 1200, 6, 6, 0),
+       DA9052_LDO(12, 50, 3650, 1250, 6, 6, 0),
+       DA9052_LDO(13, 50, 3600, 1200, 6, 6, 0),
+};
+
+static int da9052_remove_subdev(struct device *dev, void *unused)
+{
+       platform_device_unregister(to_platform_device(dev));
+       return 0;
+}
+
+void da9052_add_regulator_devices(struct da9052 *da9052,
+                               struct da9052_pdata *pdata)
+{
+       struct platform_device *pdev;
+       int i;
+       int ret;
+
+       for (i = 0; i < pdata->num_regulators; i++) {
+
+               pdev = platform_device_alloc("da9052-regulator", i);
+               if (!pdev) {
+                       ret = -ENOMEM;
+                       goto failed;
+               }
+               pdev->id = i;
+               pdev->dev.parent = da9052->dev;
+               ret = platform_device_add(pdev);
+               if (ret) {
+                       platform_device_put(pdev);
+                       goto failed;
+               }
+       }
+       return;
+
+failed:
+       device_for_each_child(da9052->dev, NULL, da9052_remove_subdev);
+       return;
+}
+EXPORT_SYMBOL(da9052_add_regulator_devices);
+
+
+static inline struct da9052_regulator_info *find_regulator_info(int id)
+{
+       struct da9052_regulator_info *info;
+       int i;
+
+       for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
+               info = &da9052_regulator_info[i];
+               if (info->reg_desc.id == id)
+                       return info;
+       }
+       return NULL;
+}
+
+static int __devinit da9052_regulator_probe(struct platform_device *pdev)
+{
+       struct da9052_regulator_info *info;
+       struct da9052_regulator *regulator;
+       struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+
+       regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
+       if (!regulator)
+               return -ENOMEM;
+
+       regulator->da9052 = da9052;
+
+       info = find_regulator_info(pdev->id);
+       if (info == NULL) {
+               dev_err(&pdev->dev, "invalid regulator ID specified\n");
+               return -EINVAL;
+       }
+
+       regulator->rdev = regulator_register(&info->reg_desc, &pdev->dev,
+                                &da9052_regulators_init[pdev->id], info);
+       if (IS_ERR(regulator->rdev)) {
+               dev_err(&pdev->dev, "failed to register regulator %s\n",
+                               info->reg_desc.name);
+               return PTR_ERR(regulator->rdev);
+       }
+
+       platform_set_drvdata(pdev, regulator);
+
+       return 0;
+
+}
+
+static int __devexit da9052_regulator_remove(struct platform_device *pdev)
+{
+       struct da9052_regulator *regulator = platform_get_drvdata(pdev);
+
+       regulator_unregister(regulator->rdev);
+
+       kfree(regulator);
+       return 0;
+}
+
+static struct platform_driver da9052_regulator_driver = {
+       .driver = {
+               .name   = "da9052-regulator",
+               .owner  = THIS_MODULE,
+       },
+       .probe          = da9052_regulator_probe,
+       .remove         = __devexit_p(da9052_regulator_remove),
+};
+
+static int __init da9052_regulator_init(void)
+{
+       return platform_driver_register(&da9052_regulator_driver);
+}
+subsys_initcall(da9052_regulator_init);
+
+static void __exit da9052_regulator_exit(void)
+{
+       platform_driver_unregister(&da9052_regulator_driver);
+}
+module_exit(da9052_regulator_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-regulator");
diff -Naur linux-next-20110421.orig/drivers/regulator/Kconfig linux-next-20110421/drivers/regulator/Kconfig
--- linux-next-20110421.orig/drivers/regulator/Kconfig  2011-04-26 09:31:41.000000000 +0500
+++ linux-next-20110421/drivers/regulator/Kconfig       2011-05-03 17:22:24.000000000 +0500
@@ -167,6 +167,13 @@
          Say y here to support the BUCKs and LDOs regulators found on
          Dialog Semiconductor DA9030/DA9034 PMIC.

+config REGULATOR_DA9052
+       tristate "Dialog DA9052 regulators"
+       depends on PMIC_DA9052
+       help
+         Say y here to support the BUCKs and LDOs regulators found on
+         Dialog Semiconductor DA9052 PMIC.
+
 config REGULATOR_PCF50633
        tristate "PCF50633 regulator driver"
         depends on MFD_PCF50633
diff -Naur linux-next-20110421.orig/drivers/regulator/Makefile linux-next-20110421/drivers/regulator/Makefile
--- linux-next-20110421.orig/drivers/regulator/Makefile 2011-04-26 09:31:41.000000000 +0500
+++ linux-next-20110421/drivers/regulator/Makefile      2011-05-03 17:22:22.000000000 +0500
@@ -28,6 +28,7 @@
 obj-$(CONFIG_REGULATOR_WM8994)         += wm8994-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6586X)       += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X) += da903x.o
+obj-$(CONFIG_REGULATOR_DA9052)         += da9052-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633)       += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP)   += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783)        += mc13783-regulator.o


Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
