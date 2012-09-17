Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2IQETs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:19:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2IQETo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:19:44 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: "Jett.Zhou" <jtzhou@marvell.com>
Subject: [PATCH 3/9] regulator: 88pm860x: add pre-regulator support for 88pm860x regulator
Date: Mon, 17 Sep 2012 12:19:06 +0800
Message-Id: <1347855552-26213-4-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jett.Zhou" <jtzhou@marvell.com>

Pre-regulator of 88pm8606 is mainly for support charging based on vbus,
it needs to be enabled for charging battery, and will be disabled in
some exception condition like over-temp.
Add the pre-regulator support for 88pm860x regulator driver.

Signed-off-by: Jett.Zhou <jtzhou@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/regulator/88pm8607.c |   66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 843c89a..d34bd8c 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -23,6 +23,7 @@ struct pm8607_regulator_info {
 	struct pm860x_chip	*chip;
 	struct regulator_dev	*regulator;
 	struct i2c_client	*i2c;
+	struct i2c_client	*i2c_8606;
 
 	unsigned int	*vol_table;
 	unsigned int	*vol_suspend;
@@ -242,6 +243,35 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	return ret;
 }
 
+static int pm8606_preg_enable(struct regulator_dev *rdev)
+{
+	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
+
+	return pm860x_set_bits(info->i2c, rdev->desc->enable_reg,
+			       1 << rdev->desc->enable_mask, 0);
+}
+
+static int pm8606_preg_disable(struct regulator_dev *rdev)
+{
+	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
+
+	return pm860x_set_bits(info->i2c, rdev->desc->enable_reg,
+			       1 << rdev->desc->enable_mask,
+			       1 << rdev->desc->enable_mask);
+}
+
+static int pm8606_preg_is_enabled(struct regulator_dev *rdev)
+{
+	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	ret = pm860x_reg_read(info->i2c, rdev->desc->enable_reg);
+	if (ret < 0)
+		return ret;
+
+	return !((unsigned char)ret & (1 << rdev->desc->enable_mask));
+}
+
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
 	.set_voltage_sel = pm8607_set_voltage_sel,
@@ -251,6 +281,25 @@ static struct regulator_ops pm8607_regulator_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
+static struct regulator_ops pm8606_preg_ops = {
+	.enable		= pm8606_preg_enable,
+	.disable	= pm8606_preg_disable,
+	.is_enabled	= pm8606_preg_is_enabled,
+};
+
+#define PM8606_PREG(ereg, ebit)						\
+{									\
+	.desc	= {							\
+		.name	= "PREG",					\
+		.ops	= &pm8606_preg_ops,				\
+		.type	= REGULATOR_CURRENT,				\
+		.id	= PM8606_ID_PREG,				\
+		.owner	= THIS_MODULE,					\
+		.enable_reg = PM8606_##ereg,				\
+		.enable_mask = (ebit),					\
+	},								\
+}
+
 #define PM8607_DVC(vreg, ureg, ubit, ereg, ebit)			\
 {									\
 	.desc	= {							\
@@ -309,6 +358,8 @@ static struct pm8607_regulator_info pm8607_regulator_info[] = {
 	PM8607_LDO(12,        LDO12, 0, SUPPLIES_EN12, 5),
 	PM8607_LDO(13, VIBRATOR_SET, 1, VIBRATOR_SET, 0),
 	PM8607_LDO(14,        LDO14, 0, SUPPLIES_EN12, 6),
+
+	PM8606_PREG(PREREGULATORB, 5),
 };
 
 static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
@@ -336,6 +387,8 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
+	info->i2c_8606 = (chip->id == CHIP_PM8607) ? chip->companion :
+			chip->client;
 	info->chip = chip;
 
 	/* check DVC ramp slope double */
@@ -371,6 +424,18 @@ static int __devexit pm8607_regulator_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id pm8607_regulator_driver_ids[] = {
+	{
+		.name	= "88pm860x-regulator",
+		.driver_data	= 0,
+	}, {
+		.name	= "88pm860x-preg",
+		.driver_data	= 0,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, pm8607_regulator_driver_ids);
+
 static struct platform_driver pm8607_regulator_driver = {
 	.driver		= {
 		.name	= "88pm860x-regulator",
@@ -378,6 +443,7 @@ static struct platform_driver pm8607_regulator_driver = {
 	},
 	.probe		= pm8607_regulator_probe,
 	.remove		= __devexit_p(pm8607_regulator_remove),
+	.id_table	= pm8607_regulator_driver_ids,
 };
 
 static int __init pm8607_regulator_init(void)
-- 
1.7.9.5

