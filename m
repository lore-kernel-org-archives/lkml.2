Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2IMIXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:23:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2IMIXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:23:32 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v2 2/2] mfd: max8925: remove array in regulator platform data
Date: Thu, 13 Sep 2012 16:22:22 +0800
Message-Id: <1347524542-4569-3-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347524542-4569-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347524542-4569-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove array in parent's platform data. Use struct regulator_init_data
as regulator device's platform data directly. So a lot of pdata are
added into parent's platform data. And voltage out register offset
is used as IORESOURCE_REG to distinguish different regualtor devices.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/max8925-core.c            |  388 +++++++++++++++++++++++++++------
 drivers/regulator/max8925-regulator.c |   35 ++-
 include/linux/mfd/max8925.h           |   26 ++-
 3 files changed, 356 insertions(+), 93 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index cdcaec8..b968525 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -15,6 +15,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/machine.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
 
@@ -109,71 +110,215 @@ static struct mfd_cell onkey_devs[] = {
 	},
 };
 
-#define MAX8925_REG_RESOURCE(_start, _end)	\
-{						\
-	.start	= MAX8925_##_start,		\
-	.end	= MAX8925_##_end,		\
-	.flags	= IORESOURCE_REG,		\
-}
+static struct resource sd1_resources[] __devinitdata = {
+	{0x06, 0x06, "sdv", IORESOURCE_REG, },
+};
 
-static struct resource regulator_resources[] = {
-	MAX8925_REG_RESOURCE(SDCTL1, SDCTL1),
-	MAX8925_REG_RESOURCE(SDCTL2, SDCTL2),
-	MAX8925_REG_RESOURCE(SDCTL3, SDCTL3),
-	MAX8925_REG_RESOURCE(LDOCTL1, LDOCTL1),
-	MAX8925_REG_RESOURCE(LDOCTL2, LDOCTL2),
-	MAX8925_REG_RESOURCE(LDOCTL3, LDOCTL3),
-	MAX8925_REG_RESOURCE(LDOCTL4, LDOCTL4),
-	MAX8925_REG_RESOURCE(LDOCTL5, LDOCTL5),
-	MAX8925_REG_RESOURCE(LDOCTL6, LDOCTL6),
-	MAX8925_REG_RESOURCE(LDOCTL7, LDOCTL7),
-	MAX8925_REG_RESOURCE(LDOCTL8, LDOCTL8),
-	MAX8925_REG_RESOURCE(LDOCTL9, LDOCTL9),
-	MAX8925_REG_RESOURCE(LDOCTL10, LDOCTL10),
-	MAX8925_REG_RESOURCE(LDOCTL11, LDOCTL11),
-	MAX8925_REG_RESOURCE(LDOCTL12, LDOCTL12),
-	MAX8925_REG_RESOURCE(LDOCTL13, LDOCTL13),
-	MAX8925_REG_RESOURCE(LDOCTL14, LDOCTL14),
-	MAX8925_REG_RESOURCE(LDOCTL15, LDOCTL15),
-	MAX8925_REG_RESOURCE(LDOCTL16, LDOCTL16),
-	MAX8925_REG_RESOURCE(LDOCTL17, LDOCTL17),
-	MAX8925_REG_RESOURCE(LDOCTL18, LDOCTL18),
-	MAX8925_REG_RESOURCE(LDOCTL19, LDOCTL19),
-	MAX8925_REG_RESOURCE(LDOCTL20, LDOCTL20),
-};
-
-#define MAX8925_REG_DEVS(_id)						\
-{									\
-	.name		= "max8925-regulator",				\
-	.num_resources	= 1,						\
-	.resources	= &regulator_resources[MAX8925_ID_##_id],	\
-	.id		= MAX8925_ID_##_id,				\
-}
+static struct resource sd2_resources[] __devinitdata = {
+	{0x09, 0x09, "sdv", IORESOURCE_REG, },
+};
+
+static struct resource sd3_resources[] __devinitdata = {
+	{0x0c, 0x0c, "sdv", IORESOURCE_REG, },
+};
+
+static struct resource ldo1_resources[] __devinitdata = {
+	{0x1a, 0x1a, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo2_resources[] __devinitdata = {
+	{0x1e, 0x1e, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo3_resources[] __devinitdata = {
+	{0x22, 0x22, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo4_resources[] __devinitdata = {
+	{0x26, 0x26, "ldov", IORESOURCE_REG, },
+};
 
-static struct mfd_cell regulator_devs[] = {
-	MAX8925_REG_DEVS(SD1),
-	MAX8925_REG_DEVS(SD2),
-	MAX8925_REG_DEVS(SD3),
-	MAX8925_REG_DEVS(LDO1),
-	MAX8925_REG_DEVS(LDO2),
-	MAX8925_REG_DEVS(LDO3),
-	MAX8925_REG_DEVS(LDO4),
-	MAX8925_REG_DEVS(LDO5),
-	MAX8925_REG_DEVS(LDO6),
-	MAX8925_REG_DEVS(LDO7),
-	MAX8925_REG_DEVS(LDO8),
-	MAX8925_REG_DEVS(LDO9),
-	MAX8925_REG_DEVS(LDO10),
-	MAX8925_REG_DEVS(LDO11),
-	MAX8925_REG_DEVS(LDO12),
-	MAX8925_REG_DEVS(LDO13),
-	MAX8925_REG_DEVS(LDO14),
-	MAX8925_REG_DEVS(LDO15),
-	MAX8925_REG_DEVS(LDO16),
-	MAX8925_REG_DEVS(LDO17),
-	MAX8925_REG_DEVS(LDO18),
-	MAX8925_REG_DEVS(LDO19),
-	MAX8925_REG_DEVS(LDO20),
+static struct resource ldo5_resources[] __devinitdata = {
+	{0x2a, 0x2a, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo6_resources[] __devinitdata = {
+	{0x2e, 0x2e, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo7_resources[] __devinitdata = {
+	{0x32, 0x32, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo8_resources[] __devinitdata = {
+	{0x36, 0x36, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo9_resources[] __devinitdata = {
+	{0x3a, 0x3a, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo10_resources[] __devinitdata = {
+	{0x3e, 0x3e, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo11_resources[] __devinitdata = {
+	{0x42, 0x42, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo12_resources[] __devinitdata = {
+	{0x46, 0x46, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo13_resources[] __devinitdata = {
+	{0x4a, 0x4a, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo14_resources[] __devinitdata = {
+	{0x4e, 0x4e, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo15_resources[] __devinitdata = {
+	{0x52, 0x52, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo16_resources[] __devinitdata = {
+	{0x12, 0x12, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo17_resources[] __devinitdata = {
+	{0x16, 0x16, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo18_resources[] __devinitdata = {
+	{0x74, 0x74, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo19_resources[] __devinitdata = {
+	{0x5e, 0x5e, "ldov", IORESOURCE_REG, },
+};
+
+static struct resource ldo20_resources[] __devinitdata = {
+	{0x9e, 0x9e, "ldov", IORESOURCE_REG, },
+};
+
+static struct mfd_cell reg_devs[] __devinitdata = {
+	{
+		.name = "max8925-regulator",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(sd1_resources),
+		.resources = sd1_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(sd2_resources),
+		.resources = sd2_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(sd3_resources),
+		.resources = sd3_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(ldo1_resources),
+		.resources = ldo1_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(ldo2_resources),
+		.resources = ldo2_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 5,
+		.num_resources = ARRAY_SIZE(ldo3_resources),
+		.resources = ldo3_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 6,
+		.num_resources = ARRAY_SIZE(ldo4_resources),
+		.resources = ldo4_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 7,
+		.num_resources = ARRAY_SIZE(ldo5_resources),
+		.resources = ldo5_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 8,
+		.num_resources = ARRAY_SIZE(ldo6_resources),
+		.resources = ldo6_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 9,
+		.num_resources = ARRAY_SIZE(ldo7_resources),
+		.resources = ldo7_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 10,
+		.num_resources = ARRAY_SIZE(ldo8_resources),
+		.resources = ldo8_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 11,
+		.num_resources = ARRAY_SIZE(ldo9_resources),
+		.resources = ldo9_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 12,
+		.num_resources = ARRAY_SIZE(ldo10_resources),
+		.resources = ldo10_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 13,
+		.num_resources = ARRAY_SIZE(ldo11_resources),
+		.resources = ldo11_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 14,
+		.num_resources = ARRAY_SIZE(ldo12_resources),
+		.resources = ldo12_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 15,
+		.num_resources = ARRAY_SIZE(ldo13_resources),
+		.resources = ldo13_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 16,
+		.num_resources = ARRAY_SIZE(ldo14_resources),
+		.resources = ldo14_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 17,
+		.num_resources = ARRAY_SIZE(ldo15_resources),
+		.resources = ldo15_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 18,
+		.num_resources = ARRAY_SIZE(ldo16_resources),
+		.resources = ldo16_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 19,
+		.num_resources = ARRAY_SIZE(ldo17_resources),
+		.resources = ldo17_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 20,
+		.num_resources = ARRAY_SIZE(ldo18_resources),
+		.resources = ldo18_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 21,
+		.num_resources = ARRAY_SIZE(ldo19_resources),
+		.resources = ldo19_resources,
+	}, {
+		.name = "max8925-regulator",
+		.id = 22,
+		.num_resources = ARRAY_SIZE(ldo20_resources),
+		.resources = ldo20_resources,
+	},
 };
 
 enum {
@@ -569,6 +714,113 @@ tsc_irq:
 	return 0;
 }
 
+static void __devinit init_regulator(struct max8925_chip *chip,
+				     struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if (!pdata)
+		return;
+	if (pdata->sd1) {
+		reg_devs[0].platform_data = pdata->sd1;
+		reg_devs[0].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->sd2) {
+		reg_devs[1].platform_data = pdata->sd2;
+		reg_devs[1].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->sd3) {
+		reg_devs[2].platform_data = pdata->sd3;
+		reg_devs[2].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo1) {
+		reg_devs[3].platform_data = pdata->ldo1;
+		reg_devs[3].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo2) {
+		reg_devs[4].platform_data = pdata->ldo2;
+		reg_devs[4].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo3) {
+		reg_devs[5].platform_data = pdata->ldo3;
+		reg_devs[5].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo4) {
+		reg_devs[6].platform_data = pdata->ldo4;
+		reg_devs[6].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo5) {
+		reg_devs[7].platform_data = pdata->ldo5;
+		reg_devs[7].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo6) {
+		reg_devs[8].platform_data = pdata->ldo6;
+		reg_devs[8].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo7) {
+		reg_devs[9].platform_data = pdata->ldo7;
+		reg_devs[9].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo8) {
+		reg_devs[10].platform_data = pdata->ldo8;
+		reg_devs[10].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo9) {
+		reg_devs[11].platform_data = pdata->ldo9;
+		reg_devs[11].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo10) {
+		reg_devs[12].platform_data = pdata->ldo10;
+		reg_devs[12].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo11) {
+		reg_devs[13].platform_data = pdata->ldo11;
+		reg_devs[13].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo12) {
+		reg_devs[14].platform_data = pdata->ldo12;
+		reg_devs[14].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo13) {
+		reg_devs[15].platform_data = pdata->ldo13;
+		reg_devs[15].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo14) {
+		reg_devs[16].platform_data = pdata->ldo14;
+		reg_devs[16].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo15) {
+		reg_devs[17].platform_data = pdata->ldo15;
+		reg_devs[17].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo16) {
+		reg_devs[18].platform_data = pdata->ldo16;
+		reg_devs[18].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo17) {
+		reg_devs[19].platform_data = pdata->ldo17;
+		reg_devs[19].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo18) {
+		reg_devs[20].platform_data = pdata->ldo18;
+		reg_devs[20].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo19) {
+		reg_devs[21].platform_data = pdata->ldo19;
+		reg_devs[21].pdata_size = sizeof(struct regulator_init_data);
+	}
+	if (pdata->ldo20) {
+		reg_devs[22].platform_data = pdata->ldo20;
+		reg_devs[22].pdata_size = sizeof(struct regulator_init_data);
+	}
+	ret = mfd_add_devices(chip->dev, 0, reg_devs, ARRAY_SIZE(reg_devs),
+			      NULL, 0);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to add regulator subdev\n");
+		return;
+	}
+}
+
 int __devinit max8925_device_init(struct max8925_chip *chip,
 				  struct max8925_platform_data *pdata)
 {
@@ -608,15 +860,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 		goto out_dev;
 	}
 
-	if (pdata) {
-		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
-				      ARRAY_SIZE(regulator_devs),
-				      &regulator_resources[0], 0, NULL);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add regulator subdev\n");
-			goto out_dev;
-		}
-	}
+	init_regulator(chip, pdata);
 
 	if (pdata && pdata->backlight) {
 		bk_devs[0].platform_data = &pdata->backlight;
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 43dc97ec..9bb0be3 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -214,37 +214,36 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_LDO(20, 750, 3900, 50),
 };
 
-static struct max8925_regulator_info * __devinit find_regulator_info(int id)
-{
-	struct max8925_regulator_info *ri;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
-		ri = &max8925_regulator_info[i];
-		if (ri->desc.id == id)
-			return ri;
-	}
-	return NULL;
-}
-
 static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct max8925_platform_data *pdata = chip->dev->platform_data;
+	struct regulator_init_data *pdata = pdev->dev.platform_data;
 	struct regulator_config config = { };
 	struct max8925_regulator_info *ri;
+	struct resource *res;
 	struct regulator_dev *rdev;
+	int i;
 
-	ri = find_regulator_info(pdev->id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "No REG resource!\n");
+		return -EINVAL;
+	}
+	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
+		ri = &max8925_regulator_info[i];
+		if (ri->vol_reg == res->start)
+			break;
+	}
+	if (i == ARRAY_SIZE(max8925_regulator_info)) {
+		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
+			(unsigned long long)res->start);
 		return -EINVAL;
 	}
 	ri->i2c = chip->i2c;
 	ri->chip = chip;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdata->regulator[pdev->id];
+	config.init_data = pdata;
 	config.driver_data = ri;
 
 	rdev = regulator_register(&ri->desc, &config);
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 15b2392..74d8e29 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -158,8 +158,6 @@ enum {
 #define TSC_IRQ_MASK			(0x03)
 #define RTC_IRQ_MASK			(0x0c)
 
-#define MAX8925_MAX_REGULATOR		(23)
-
 #define MAX8925_NAME_SIZE		(32)
 
 /* IRQ definitions */
@@ -236,7 +234,29 @@ struct max8925_platform_data {
 	struct max8925_backlight_pdata	*backlight;
 	struct max8925_touch_pdata	*touch;
 	struct max8925_power_pdata	*power;
-	struct regulator_init_data	*regulator[MAX8925_MAX_REGULATOR];
+	struct regulator_init_data	*sd1;
+	struct regulator_init_data	*sd2;
+	struct regulator_init_data	*sd3;
+	struct regulator_init_data	*ldo1;
+	struct regulator_init_data	*ldo2;
+	struct regulator_init_data	*ldo3;
+	struct regulator_init_data	*ldo4;
+	struct regulator_init_data	*ldo5;
+	struct regulator_init_data	*ldo6;
+	struct regulator_init_data	*ldo7;
+	struct regulator_init_data	*ldo8;
+	struct regulator_init_data	*ldo9;
+	struct regulator_init_data	*ldo10;
+	struct regulator_init_data	*ldo11;
+	struct regulator_init_data	*ldo12;
+	struct regulator_init_data	*ldo13;
+	struct regulator_init_data	*ldo14;
+	struct regulator_init_data	*ldo15;
+	struct regulator_init_data	*ldo16;
+	struct regulator_init_data	*ldo17;
+	struct regulator_init_data	*ldo18;
+	struct regulator_init_data	*ldo19;
+	struct regulator_init_data	*ldo20;
 
 	int		irq_base;
 	int		tsc_irq;
-- 
1.7.9.5

