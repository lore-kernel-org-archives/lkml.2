Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1DTMBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:01:22 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:45202 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1DTMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:01:20 -0400
X-ASG-Debug-ID: 1303300880-082c76640001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 13/14] regulator: max8925: fix not add device if missing init data
Subject: [PATCH 13/14] regulator: max8925: fix not add device if missing init data
Date: Wed, 20 Apr 2011 19:55:39 +0800
X-ASG-Orig-Subj: [PATCH 13/14] regulator: max8925: fix not add device if missing init data
Message-Id: <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303300880
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If regulator[0] is missed in init data, all regulators of max8925 won't
be initialized.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/max8925-core.c            |  171 ++++++++++++++++++---------------
 drivers/regulator/max8925-regulator.c |   37 ++++----
 include/linux/mfd/max8925.h           |    3 +-
 3 files changed, 112 insertions(+), 99 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index a974711..93f2731 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -75,6 +75,32 @@ static struct resource onkey_resources[] __devinitdata = {
 	 IORESOURCE_IRQ,},
 };
 
+static struct resource regulator_resources[] __devinitdata = {
+	{MAX8925_ID_SD1,   MAX8925_ID_SD1,   "SD1",   IORESOURCE_IO,},
+	{MAX8925_ID_SD2,   MAX8925_ID_SD2,   "SD2",   IORESOURCE_IO,},
+	{MAX8925_ID_SD3,   MAX8925_ID_SD3,   "SD3",   IORESOURCE_IO,},
+	{MAX8925_ID_LDO1,  MAX8925_ID_LDO1,  "LDO01", IORESOURCE_IO,},
+	{MAX8925_ID_LDO2,  MAX8925_ID_LDO2,  "LDO02", IORESOURCE_IO,},
+	{MAX8925_ID_LDO3,  MAX8925_ID_LDO3,  "LDO03", IORESOURCE_IO,},
+	{MAX8925_ID_LDO4,  MAX8925_ID_LDO4,  "LDO04", IORESOURCE_IO,},
+	{MAX8925_ID_LDO5,  MAX8925_ID_LDO5,  "LDO05", IORESOURCE_IO,},
+	{MAX8925_ID_LDO6,  MAX8925_ID_LDO6,  "LDO06", IORESOURCE_IO,},
+	{MAX8925_ID_LDO7,  MAX8925_ID_LDO7,  "LDO07", IORESOURCE_IO,},
+	{MAX8925_ID_LDO8,  MAX8925_ID_LDO8,  "LDO08", IORESOURCE_IO,},
+	{MAX8925_ID_LDO9,  MAX8925_ID_LDO9,  "LDO09", IORESOURCE_IO,},
+	{MAX8925_ID_LDO10, MAX8925_ID_LDO10, "LDO10", IORESOURCE_IO,},
+	{MAX8925_ID_LDO11, MAX8925_ID_LDO11, "LDO11", IORESOURCE_IO,},
+	{MAX8925_ID_LDO12, MAX8925_ID_LDO12, "LDO12", IORESOURCE_IO,},
+	{MAX8925_ID_LDO13, MAX8925_ID_LDO13, "LDO13", IORESOURCE_IO,},
+	{MAX8925_ID_LDO14, MAX8925_ID_LDO14, "LDO14", IORESOURCE_IO,},
+	{MAX8925_ID_LDO15, MAX8925_ID_LDO15, "LDO15", IORESOURCE_IO,},
+	{MAX8925_ID_LDO16, MAX8925_ID_LDO16, "LDO16", IORESOURCE_IO,},
+	{MAX8925_ID_LDO17, MAX8925_ID_LDO17, "LDO17", IORESOURCE_IO,},
+	{MAX8925_ID_LDO18, MAX8925_ID_LDO18, "LDO18", IORESOURCE_IO,},
+	{MAX8925_ID_LDO19, MAX8925_ID_LDO19, "LDO19", IORESOURCE_IO,},
+	{MAX8925_ID_LDO20, MAX8925_ID_LDO20, "LDO20", IORESOURCE_IO,},
+};
+
 static struct mfd_cell bk_devs[] = {
 	{"max8925-backlight", -1,},
 };
@@ -95,76 +121,36 @@ static struct mfd_cell onkey_devs[] = {
 	{"max8925-onkey", -1,},
 };
 
+static struct mfd_cell regulator_devs[] = {
+	{"max8925-regulator", 0,},
+	{"max8925-regulator", 1,},
+	{"max8925-regulator", 2,},
+	{"max8925-regulator", 3,},
+	{"max8925-regulator", 4,},
+	{"max8925-regulator", 5,},
+	{"max8925-regulator", 6,},
+	{"max8925-regulator", 7,},
+	{"max8925-regulator", 8,},
+	{"max8925-regulator", 9,},
+	{"max8925-regulator", 10,},
+	{"max8925-regulator", 11,},
+	{"max8925-regulator", 12,},
+	{"max8925-regulator", 13,},
+	{"max8925-regulator", 14,},
+	{"max8925-regulator", 15,},
+	{"max8925-regulator", 16,},
+	{"max8925-regulator", 17,},
+	{"max8925-regulator", 18,},
+	{"max8925-regulator", 19,},
+	{"max8925-regulator", 20,},
+	{"max8925-regulator", 21,},
+	{"max8925-regulator", 22,},
+};
+
 static struct max8925_backlight_pdata bk_pdata;
 static struct max8925_touch_pdata touch_pdata;
 static struct max8925_power_pdata power_pdata;
-
-#define MAX8925_REG_RESOURCE(_start, _end)	\
-{						\
-	.start	= MAX8925_##_start,		\
-	.end	= MAX8925_##_end,		\
-	.flags	= IORESOURCE_IO,		\
-}
-
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
-
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
-};
+static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
 
 enum {
 	FLAGS_ADC = 1,	/* register in ADC component */
@@ -669,6 +655,45 @@ static void __devinit device_onkey_init(struct max8925_chip *chip,
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 }
 
+static void __devinit device_regulator_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	struct regulator_init_data *initdata;
+	int ret, i, seq;
+
+	if ((pdata == NULL) || (pdata->regulator == NULL))
+		return;
+
+	if (pdata->num_regulators > ARRAY_SIZE(regulator_devs))
+		pdata->num_regulators = ARRAY_SIZE(regulator_devs);
+
+	for (i = 0, seq = -1; i < pdata->num_regulators; i++) {
+		initdata = &pdata->regulator[i];
+		seq = *(unsigned int *)initdata->driver_data;
+		if ((seq < 0) || (seq > MAX8925_ID_MAX)) {
+			dev_err(chip->dev, "Wrong ID(%d) on regulator(%s)\n",
+				seq, initdata->constraints.name);
+			goto out;
+		}
+		memcpy(&regulator_pdata[i], &pdata->regulator[i],
+			sizeof(struct regulator_init_data));
+		regulator_devs[i].platform_data = &regulator_pdata[i];
+		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
+		regulator_devs[i].num_resources = 1;
+		regulator_devs[i].resources = &regulator_resources[seq];
+
+		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
+				      &regulator_resources[seq], 0);
+		if (ret < 0) {
+			dev_err(chip->dev, "Failed to add regulator subdev\n");
+			goto out;
+		}
+	}
+out:
+	return;
+}
+
 int __devinit max8925_device_init(struct max8925_chip *chip,
 				  struct max8925_platform_data *pdata)
 {
@@ -697,18 +722,8 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	device_touch_init(chip, chip->adc, pdata);
 	device_power_init(chip, chip->adc, pdata);
 	device_onkey_init(chip, chip->i2c, pdata);
+	device_regulator_init(chip, chip->i2c, pdata);
 
-	if (pdata && pdata->regulator[0]) {
-		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
-				      ARRAY_SIZE(regulator_devs),
-				      &regulator_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add regulator subdev\n");
-			goto out_dev;
-		}
-	}
-
-out_dev:
 	return 0;
 }
 
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index e4dbd66..733dcd2 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -236,39 +236,36 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
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
-	struct max8925_regulator_info *ri;
+	struct max8925_regulator_info *ri = NULL;
+	struct regulator_init_data *pdata = pdev->dev.platform_data;
 	struct regulator_dev *rdev;
+	struct resource *res;
+	int i;
 
-	ri = find_regulator_info(pdev->id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource!\n");
+		return -EINVAL;
+	}
+	i = res->start;
+	if ((i < 0) || (i > MAX8925_ID_MAX)) {
+		dev_err(&pdev->dev, "Failed to find regulator %d\n",
+			res->start);
 		return -EINVAL;
 	}
+	ri = &max8925_regulator_info[i];
 	ri->i2c = chip->i2c;
 	ri->chip = chip;
 
+	/* replace driver_data with ri */
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdata->regulator[pdev->id], ri);
+				  pdata, ri);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				ri->desc.name);
+			ri->desc.name);
 		return PTR_ERR(rdev);
 	}
 
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 5259dfe..438a734 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -233,10 +233,11 @@ struct max8925_platform_data {
 	struct max8925_backlight_pdata	*backlight;
 	struct max8925_touch_pdata	*touch;
 	struct max8925_power_pdata	*power;
-	struct regulator_init_data	*regulator[MAX8925_MAX_REGULATOR];
+	struct regulator_init_data	*regulator;
 
 	int		irq_base;
 	int		tsc_irq;
+	int		num_regulators;
 };
 
 extern int max8925_reg_read(struct i2c_client *, int);
-- 
1.5.6.5

