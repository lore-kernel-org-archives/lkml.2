Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2IQEUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:20:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43956 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2IQEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:20:05 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH 4/9] mfd: 88pm860x: avoid to check resource for preg regulator
Date: Mon, 17 Sep 2012 12:19:07 +0800
Message-Id: <1347855552-26213-5-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haojian Zhuang <haojian.zhuang@marvell.com>

Since PREG regulator is the only one regulator in 88PM8606, and other
regulators are in 88PM8607. Checking resource as identifying regulator
is not a good way. We can use NULL resource to indentify PREG regulator.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c  |    8 +-------
 drivers/regulator/88pm8607.c |   32 +++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 0c01d74..d2b0bf8 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -150,10 +150,6 @@ static struct resource charger_resources[] __devinitdata = {
 	{PM8607_IRQ_VCHG, PM8607_IRQ_VCHG, "vchg voltage",    IORESOURCE_IRQ,},
 };
 
-static struct resource preg_resources[] __devinitdata = {
-	{PM8606_ID_PREG,  PM8606_ID_PREG,  "preg",   IORESOURCE_REG,},
-};
-
 static struct resource rtc_resources[] __devinitdata = {
 	{PM8607_IRQ_RTC, PM8607_IRQ_RTC, "rtc", IORESOURCE_IRQ,},
 };
@@ -960,10 +956,8 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 
 	power_devs[2].platform_data = &preg_init_data;
 	power_devs[2].pdata_size = sizeof(struct regulator_init_data);
-	power_devs[2].num_resources = ARRAY_SIZE(preg_resources);
-	power_devs[2].resources = &preg_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[2], 1,
-			      &preg_resources[0], chip->irq_base, NULL);
+			      NULL, chip->irq_base, NULL);
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add preg subdev\n");
 }
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index d34bd8c..f96fbe3 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -358,7 +358,9 @@ static struct pm8607_regulator_info pm8607_regulator_info[] = {
 	PM8607_LDO(12,        LDO12, 0, SUPPLIES_EN12, 5),
 	PM8607_LDO(13, VIBRATOR_SET, 1, VIBRATOR_SET, 0),
 	PM8607_LDO(14,        LDO14, 0, SUPPLIES_EN12, 6),
+};
 
+static struct pm8607_regulator_info pm8606_regulator_info[] = {
 	PM8606_PREG(PREREGULATORB, 5),
 };
 
@@ -372,19 +374,23 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "No REG resource!\n");
-		return -EINVAL;
-	}
-	for (i = 0; i < ARRAY_SIZE(pm8607_regulator_info); i++) {
-		info = &pm8607_regulator_info[i];
-		if (info->desc.vsel_reg == res->start)
-			break;
-	}
-	if (i == ARRAY_SIZE(pm8607_regulator_info)) {
-		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
-			(unsigned long long)res->start);
-		return -EINVAL;
+	if (res) {
+		/* There're resources in 88PM8607 regulator driver */
+		for (i = 0; i < ARRAY_SIZE(pm8607_regulator_info); i++) {
+			info = &pm8607_regulator_info[i];
+			if (info->desc.vsel_reg == res->start)
+				break;
+		}
+		if (i == ARRAY_SIZE(pm8607_regulator_info)) {
+			dev_err(&pdev->dev, "Failed to find regulator %llu\n",
+				(unsigned long long)res->start);
+			return -EINVAL;
+		}
+	} else {
+		/* There's no resource in 88PM8606 PREG regulator driver */
+		info = &pm8606_regulator_info[0];
+		/* i is used to check regulator ID */
+		i = -1;
 	}
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->i2c_8606 = (chip->id == CHIP_PM8607) ? chip->companion :
-- 
1.7.9.5

