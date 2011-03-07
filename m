Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CGP4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:56:07 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33401 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1CGPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:22 -0500
X-ASG-Debug-ID: 1299512689-082c75230001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x regulator
Subject: [PATCH] mfd: adopt mfd_data in 88pm860x regulator
Date: Mon,  7 Mar 2011 23:43:11 +0800
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x regulator
Message-Id: <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512689
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy 88pm860x platform data into different mfd_data structure for
regulator driver. So move the identification of device node from
regulator driver to mfd driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c  |  165 ++++++++++++++++++++++++++----------------
 drivers/regulator/88pm8607.c |   46 ++++++------
 include/linux/mfd/88pm860x.h |    7 +-
 3 files changed, 132 insertions(+), 86 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index cec375c..96ea0c6 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
+#include <linux/regulator/machine.h>
 
 #define INT_STATUS_NUM			3
 
@@ -35,6 +36,27 @@ static struct resource led_resources[] __initdata = {
 	{PM8606_LED2_BLUE,  PM8606_LED2_BLUE,  "led1-blue",  IORESOURCE_IO,},
 };
 
+static struct resource regulator_resources[] __initdata = {
+	{PM8607_ID_BUCK1, PM8607_ID_BUCK1, "buck-1", IORESOURCE_IO,},
+	{PM8607_ID_BUCK2, PM8607_ID_BUCK2, "buck-2", IORESOURCE_IO,},
+	{PM8607_ID_BUCK3, PM8607_ID_BUCK3, "buck-3", IORESOURCE_IO,},
+	{PM8607_ID_LDO1,  PM8607_ID_LDO1,  "ldo-01", IORESOURCE_IO,},
+	{PM8607_ID_LDO2,  PM8607_ID_LDO2,  "ldo-02", IORESOURCE_IO,},
+	{PM8607_ID_LDO3,  PM8607_ID_LDO3,  "ldo-03", IORESOURCE_IO,},
+	{PM8607_ID_LDO4,  PM8607_ID_LDO4,  "ldo-04", IORESOURCE_IO,},
+	{PM8607_ID_LDO5,  PM8607_ID_LDO5,  "ldo-05", IORESOURCE_IO,},
+	{PM8607_ID_LDO6,  PM8607_ID_LDO6,  "ldo-06", IORESOURCE_IO,},
+	{PM8607_ID_LDO7,  PM8607_ID_LDO7,  "ldo-07", IORESOURCE_IO,},
+	{PM8607_ID_LDO8,  PM8607_ID_LDO8,  "ldo-08", IORESOURCE_IO,},
+	{PM8607_ID_LDO9,  PM8607_ID_LDO9,  "ldo-09", IORESOURCE_IO,},
+	{PM8607_ID_LDO10, PM8607_ID_LDO10, "ldo-10", IORESOURCE_IO,},
+	{PM8607_ID_LDO11, PM8607_ID_LDO11, "ldo-11", IORESOURCE_IO,},
+	{PM8607_ID_LDO12, PM8607_ID_LDO12, "ldo-12", IORESOURCE_IO,},
+	{PM8607_ID_LDO13, PM8607_ID_LDO13, "ldo-13", IORESOURCE_IO,},
+	{PM8607_ID_LDO14, PM8607_ID_LDO14, "ldo-14", IORESOURCE_IO,},
+	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
+};
+
 static struct mfd_cell bk_devs[] __initdata = {
 	{"88pm860x-backlight", 0,},
 	{"88pm860x-backlight", 1,},
@@ -50,8 +72,30 @@ static struct mfd_cell led_devs[] __initdata = {
 	{"88pm860x-led", 5,},
 };
 
+static struct mfd_cell regulator_devs[] __initdata = {
+	{"88pm860x-regulator", 0,},
+	{"88pm860x-regulator", 1,},
+	{"88pm860x-regulator", 2,},
+	{"88pm860x-regulator", 3,},
+	{"88pm860x-regulator", 4,},
+	{"88pm860x-regulator", 5,},
+	{"88pm860x-regulator", 6,},
+	{"88pm860x-regulator", 7,},
+	{"88pm860x-regulator", 8,},
+	{"88pm860x-regulator", 9,},
+	{"88pm860x-regulator", 10,},
+	{"88pm860x-regulator", 11,},
+	{"88pm860x-regulator", 12,},
+	{"88pm860x-regulator", 13,},
+	{"88pm860x-regulator", 14,},
+	{"88pm860x-regulator", 15,},
+	{"88pm860x-regulator", 16,},
+	{"88pm860x-regulator", 17,},
+};
+
 static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
 static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
+static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
 
 static struct resource touch_resources[] = {
 	{
@@ -69,13 +113,6 @@ static struct mfd_cell touch_devs[] = {
 	},
 };
 
-#define PM8607_REG_RESOURCE(_start, _end)		\
-{							\
-	.start	= PM8607_##_start,			\
-	.end	= PM8607_##_end,			\
-	.flags	= IORESOURCE_IO,			\
-}
-
 static struct resource power_supply_resources[] = {
 	{
 		.name		= "88pm860x-power",
@@ -149,52 +186,6 @@ static struct mfd_cell codec_devs[] = {
 	},
 };
 
-static struct resource regulator_resources[] = {
-	PM8607_REG_RESOURCE(BUCK1, BUCK1),
-	PM8607_REG_RESOURCE(BUCK2, BUCK2),
-	PM8607_REG_RESOURCE(BUCK3, BUCK3),
-	PM8607_REG_RESOURCE(LDO1,  LDO1),
-	PM8607_REG_RESOURCE(LDO2,  LDO2),
-	PM8607_REG_RESOURCE(LDO3,  LDO3),
-	PM8607_REG_RESOURCE(LDO4,  LDO4),
-	PM8607_REG_RESOURCE(LDO5,  LDO5),
-	PM8607_REG_RESOURCE(LDO6,  LDO6),
-	PM8607_REG_RESOURCE(LDO7,  LDO7),
-	PM8607_REG_RESOURCE(LDO8,  LDO8),
-	PM8607_REG_RESOURCE(LDO9,  LDO9),
-	PM8607_REG_RESOURCE(LDO10, LDO10),
-	PM8607_REG_RESOURCE(LDO12, LDO12),
-	PM8607_REG_RESOURCE(VIBRATOR_SET, VIBRATOR_SET),
-	PM8607_REG_RESOURCE(LDO14, LDO14),
-};
-
-#define PM8607_REG_DEVS(_id)						\
-{									\
-	.name		= "88pm860x-regulator",				\
-	.num_resources	= 1,						\
-	.resources	= &regulator_resources[PM8607_ID_##_id],	\
-	.id		= PM8607_ID_##_id,				\
-}
-
-static struct mfd_cell regulator_devs[] = {
-	PM8607_REG_DEVS(BUCK1),
-	PM8607_REG_DEVS(BUCK2),
-	PM8607_REG_DEVS(BUCK3),
-	PM8607_REG_DEVS(LDO1),
-	PM8607_REG_DEVS(LDO2),
-	PM8607_REG_DEVS(LDO3),
-	PM8607_REG_DEVS(LDO4),
-	PM8607_REG_DEVS(LDO5),
-	PM8607_REG_DEVS(LDO6),
-	PM8607_REG_DEVS(LDO7),
-	PM8607_REG_DEVS(LDO8),
-	PM8607_REG_DEVS(LDO9),
-	PM8607_REG_DEVS(LDO10),
-	PM8607_REG_DEVS(LDO12),
-	PM8607_REG_DEVS(LDO13),
-	PM8607_REG_DEVS(LDO14),
-};
-
 struct pm860x_irq_data {
 	int	reg;
 	int	mask_reg;
@@ -623,6 +614,64 @@ static void __devinit device_led_init(struct pm860x_chip *chip,
 	}
 }
 
+static void __devinit device_regulator_init(struct pm860x_chip *chip,
+					    struct i2c_client *i2c,
+					    struct pm860x_platform_data *pdata)
+{
+	struct regulator_init_data *initdata;
+	int ret;
+	int i, j;
+
+	if ((pdata == NULL) || (pdata->regulator == NULL))
+		return;
+
+	if (pdata->num_regulators > ARRAY_SIZE(regulator_devs))
+		pdata->num_regulators = ARRAY_SIZE(regulator_devs);
+
+	for (i = 0, j = -1; i < pdata->num_regulators; i++) {
+		initdata = &pdata->regulator[i];
+		if (strstr(initdata->constraints.name, "BUCK")) {
+			sscanf(initdata->constraints.name, "BUCK%d", &j);
+			/* BUCK1 ~ BUCK3 */
+			if ((j < 1) || (j > 3)) {
+				dev_err(chip->dev, "Failed to add constraint "
+					"(%s)\n", initdata->constraints.name);
+				goto out;
+			}
+			j = (j - 1) + PM8607_ID_BUCK1;
+		}
+		if (strstr(initdata->constraints.name, "LDO")) {
+			sscanf(initdata->constraints.name, "LDO%d", &j);
+			/* LDO1 ~ LDO15 */
+			if ((j < 1) || (j > 15)) {
+				dev_err(chip->dev, "Failed to add constraint "
+					"(%s)\n", initdata->constraints.name);
+				goto out;
+			}
+			j = (j - 1) + PM8607_ID_LDO1;
+		}
+		if (j == -1) {
+			dev_err(chip->dev, "Failed to add constraint (%s)\n",
+				initdata->constraints.name);
+			goto out;
+		}
+		memcpy(&regulator_pdata[i], &pdata->regulator[i],
+			sizeof(struct regulator_init_data));
+		regulator_devs[i].mfd_data = &regulator_pdata[i];
+		regulator_devs[i].num_resources = 1;
+		regulator_devs[i].resources = &regulator_resources[j];
+
+		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
+				      &regulator_resources[j], 0);
+		if (ret < 0) {
+			dev_err(chip->dev, "Failed to add regulator subdev\n");
+			goto out;
+		}
+	}
+out:
+	return;
+}
+
 static void __devinit device_8607_init(struct pm860x_chip *chip,
 				       struct i2c_client *i2c,
 				       struct pm860x_platform_data *pdata)
@@ -678,14 +727,6 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		goto out;
 
-	ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
-			      ARRAY_SIZE(regulator_devs),
-			      &regulator_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add regulator subdev\n");
-		goto out_dev;
-	}
-
 	if (pdata && pdata->touch) {
 		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
 				      ARRAY_SIZE(touch_devs),
@@ -723,6 +764,8 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 		dev_err(chip->dev, "Failed to add codec subdev\n");
 		goto out_dev;
 	}
+
+	device_regulator_init(chip, i2c, pdata);
 	return;
 out_dev:
 	mfd_remove_devices(chip->dev);
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index dd63084..8592512 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 
 struct pm8607_regulator_info {
@@ -394,47 +395,48 @@ static struct pm8607_regulator_info pm8607_regulator_info[] = {
 	PM8607_LDO(14,        LDO14, 0, 4, SUPPLIES_EN12, 6),
 };
 
-static inline struct pm8607_regulator_info *find_regulator_info(int id)
+static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 {
-	struct pm8607_regulator_info *info;
+	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
+	struct pm8607_regulator_info *info = NULL;
+	struct regulator_init_data *pdata;
+	struct mfd_cell *cell;
 	int i;
 
+	cell = pdev->dev.platform_data;
+	if (cell == NULL)
+		return -ENODEV;
+	pdata = cell->mfd_data;
+	if (pdata == NULL)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(pm8607_regulator_info); i++) {
 		info = &pm8607_regulator_info[i];
-		if (info->desc.id == id)
-			return info;
+		if (!strcmp(info->desc.name, pdata->constraints.name))
+			break;
 	}
-	return NULL;
-}
-
-static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
-{
-	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_platform_data *pdata = chip->dev->platform_data;
-	struct pm8607_regulator_info *info = NULL;
-
-	info = find_regulator_info(pdev->id);
-	if (info == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	if (i > ARRAY_SIZE(pm8607_regulator_info)) {
+		dev_err(&pdev->dev, "Failed to find regulator %s\n",
+			pdata->constraints.name);
 		return -EINVAL;
 	}
 
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->chip = chip;
 
+	/* check DVC ramp slope double */
+	if (!strcmp(info->desc.name, "BUCK3"))
+		if (info->chip->buck3_double)
+			info->slope_double = 1;
+
 	info->regulator = regulator_register(&info->desc, &pdev->dev,
-					     pdata->regulator[pdev->id], info);
+					     pdata, info);
 	if (IS_ERR(info->regulator)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
 		return PTR_ERR(info->regulator);
 	}
 
-	/* check DVC ramp slope double */
-	if (info->desc.id == PM8607_ID_BUCK3)
-		if (info->chip->buck3_double)
-			info->slope_double = 1;
-
 	platform_set_drvdata(pdev, info);
 	return 0;
 }
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index ff60614..a6f6f81 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -131,9 +131,11 @@ enum {
 	PM8607_ID_LDO8,
 	PM8607_ID_LDO9,
 	PM8607_ID_LDO10,
+	PM8607_ID_LDO11,
 	PM8607_ID_LDO12,
 	PM8607_ID_LDO13,
 	PM8607_ID_LDO14,
+	PM8607_ID_LDO15,
 
 	PM8607_ID_RG_MAX,
 };
@@ -310,8 +312,6 @@ struct pm860x_chip {
 
 };
 
-#define PM8607_MAX_REGULATOR	PM8607_ID_RG_MAX	/* 3 Bucks, 13 LDOs */
-
 enum {
 	GI2C_PORT = 0,
 	PI2C_PORT,
@@ -351,6 +351,7 @@ struct pm860x_platform_data {
 	struct pm860x_led_pdata		*led;
 	struct pm860x_touch_pdata	*touch;
 	struct pm860x_power_pdata	*power;
+	struct regulator_init_data	*regulator;
 
 	unsigned short	companion_addr;	/* I2C address of companion chip */
 	int		i2c_port;	/* Controlled by GI2C or PI2C */
@@ -358,7 +359,7 @@ struct pm860x_platform_data {
 	int		irq_base;	/* IRQ base number of 88pm860x */
 	int		num_leds;
 	int		num_backlights;
-	struct regulator_init_data *regulator[PM8607_MAX_REGULATOR];
+	int		num_regulators;
 };
 
 extern int pm860x_reg_read(struct i2c_client *, int);
-- 
1.5.6.5

