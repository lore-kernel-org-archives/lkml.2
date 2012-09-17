Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2IQEVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:21:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2IQEVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:21:04 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 8/9] mfd: 88pm860x: move gpadc init into touch
Date: Mon, 17 Sep 2012 12:19:11 +0800
Message-Id: <1347855552-26213-9-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initilization of GPADC is moved from core driver to touch driver
with DT support.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/input/touchscreen/88pm860x-ts.c |   91 +++++++++++++++++++++++++++++--
 drivers/mfd/88pm860x-core.c             |   51 -----------------
 2 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index 4f81e6e..326218d 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -116,9 +116,13 @@ static void pm860x_touch_close(struct input_dev *dev)
 
 #ifdef CONFIG_OF
 static int __devinit pm860x_touch_dt_init(struct platform_device *pdev,
+					  struct pm860x_chip *chip,
 					  int *res_x)
 {
 	struct device_node *np = pdev->dev.parent->of_node;
+	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
+				 : chip->companion;
+	int data, n, ret;
 	if (!np)
 		return -ENODEV;
 	np = of_find_node_by_name(np, "touch");
@@ -126,11 +130,43 @@ static int __devinit pm860x_touch_dt_init(struct platform_device *pdev,
 		dev_err(&pdev->dev, "Can't find touch node\n");
 		return -EINVAL;
 	}
+	/* set GPADC MISC1 register */
+	data = 0;
+	if (!of_property_read_u32(np, "marvell,88pm860x-gpadc-prebias", &n))
+		data |= (n << 1) & PM8607_GPADC_PREBIAS_MASK;
+	if (!of_property_read_u32(np, "marvell,88pm860x-gpadc-slot-cycle", &n))
+		data |= (n << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
+	if (!of_property_read_u32(np, "marvell,88pm860x-gpadc-off-scale", &n))
+		data |= (n << 5) & PM8607_GPADC_OFF_SCALE_MASK;
+	if (!of_property_read_u32(np, "marvell,88pm860x-gpadc-sw-cal", &n))
+		data |= (n << 7) & PM8607_GPADC_SW_CAL_MASK;
+	if (data) {
+		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
+		if (ret < 0)
+			return -EINVAL;
+	}
+	/* set tsi prebias time */
+	if (!of_property_read_u32(np, "marvell,88pm860x-tsi-prebias", &data)) {
+		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
+		if (ret < 0)
+			return -EINVAL;
+	}
+	/* set prebias & prechg time of pen detect */
+	data = 0;
+	if (!of_property_read_u32(np, "marvell,88pm860x-pen-prebias", &n))
+		data |= n & PM8607_PD_PREBIAS_MASK;
+	if (!of_property_read_u32(np, "marvell,88pm860x-pen-prechg", &n))
+		data |= n & PM8607_PD_PRECHG_MASK;
+	if (data) {
+		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
+		if (ret < 0)
+			return -EINVAL;
+	}
 	of_property_read_u32(np, "marvell,88pm860x-resistor-X", res_x);
 	return 0;
 }
 #else
-#define pm860x_touch_dt_init(x, y)	(-1)
+#define pm860x_touch_dt_init(x, y, z)	(-1)
 #endif
 
 static int __devinit pm860x_touch_probe(struct platform_device *pdev)
@@ -138,7 +174,9 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm860x_touch_pdata *pdata = pdev->dev.platform_data;
 	struct pm860x_touch *touch;
-	int irq, ret, res_x = 0;
+	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
+				 : chip->companion;
+	int irq, ret, res_x = 0, data = 0;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -146,14 +184,55 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (pm860x_touch_dt_init(pdev, &res_x)) {
-		if (pdata)
+	if (pm860x_touch_dt_init(pdev, chip, &res_x)) {
+		if (pdata) {
+			/* set GPADC MISC1 register */
+			data = 0;
+			data |= (pdata->gpadc_prebias << 1)
+				& PM8607_GPADC_PREBIAS_MASK;
+			data |= (pdata->slot_cycle << 3)
+				& PM8607_GPADC_SLOT_CYCLE_MASK;
+			data |= (pdata->off_scale << 5)
+				& PM8607_GPADC_OFF_SCALE_MASK;
+			data |= (pdata->sw_cal << 7)
+				& PM8607_GPADC_SW_CAL_MASK;
+			if (data) {
+				ret = pm860x_reg_write(i2c,
+					PM8607_GPADC_MISC1, data);
+				if (ret < 0)
+					return -EINVAL;
+			}
+			/* set tsi prebias time */
+			if (pdata->tsi_prebias) {
+				data = pdata->tsi_prebias;
+				ret = pm860x_reg_write(i2c,
+					PM8607_TSI_PREBIAS, data);
+				if (ret < 0)
+					return -EINVAL;
+			}
+			/* set prebias & prechg time of pen detect */
+			data = 0;
+			data |= pdata->pen_prebias
+				& PM8607_PD_PREBIAS_MASK;
+			data |= (pdata->pen_prechg << 5)
+				& PM8607_PD_PRECHG_MASK;
+			if (data) {
+				ret = pm860x_reg_write(i2c,
+					PM8607_PD_PREBIAS, data);
+				if (ret < 0)
+					return -EINVAL;
+			}
 			res_x = pdata->res_x;
-		else {
+		} else {
 			dev_err(&pdev->dev, "failed to get platform data\n");
 			return -EINVAL;
 		}
 	}
+	/* enable GPADC */
+	ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1, PM8607_GPADC_EN,
+			      PM8607_GPADC_EN);
+	if (ret)
+		return ret;
 
 	touch = kzalloc(sizeof(struct pm860x_touch), GFP_KERNEL);
 	if (touch == NULL)
@@ -174,7 +253,7 @@ static int __devinit pm860x_touch_probe(struct platform_device *pdev)
 	touch->idev->open = pm860x_touch_open;
 	touch->idev->close = pm860x_touch_close;
 	touch->chip = chip;
-	touch->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
+	touch->i2c = i2c;
 	touch->irq = irq;
 	touch->res_x = res_x;
 	input_set_drvdata(touch->idev, touch);
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 15ded0b..90d8ca6 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -558,53 +558,6 @@ static struct irq_domain_ops pm860x_irq_domain_ops = {
 	.xlate	= irq_domain_xlate_onetwocell,
 };
 
-static int __devinit device_gpadc_init(struct pm860x_chip *chip,
-				       struct pm860x_platform_data *pdata)
-{
-	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
-				: chip->companion;
-	int data;
-	int ret;
-
-	/* initialize GPADC without activating it */
-
-	if (!pdata || !pdata->touch)
-		return -EINVAL;
-
-	/* set GPADC MISC1 register */
-	data = 0;
-	data |= (pdata->touch->gpadc_prebias << 1) & PM8607_GPADC_PREBIAS_MASK;
-	data |= (pdata->touch->slot_cycle << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
-	data |= (pdata->touch->off_scale << 5) & PM8607_GPADC_OFF_SCALE_MASK;
-	data |= (pdata->touch->sw_cal << 7) & PM8607_GPADC_SW_CAL_MASK;
-	if (data) {
-		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
-		if (ret < 0)
-			goto out;
-	}
-	/* set tsi prebias time */
-	if (pdata->touch->tsi_prebias) {
-		data = pdata->touch->tsi_prebias;
-		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
-		if (ret < 0)
-			goto out;
-	}
-	/* set prebias & prechg time of pen detect */
-	data = 0;
-	data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
-	data |= (pdata->touch->pen_prechg << 5) & PM8607_PD_PRECHG_MASK;
-	if (data) {
-		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
-		if (ret < 0)
-			goto out;
-	}
-
-	ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
-			      PM8607_GPADC_EN, PM8607_GPADC_EN);
-out:
-	return ret;
-}
-
 static int __devinit device_irq_init(struct pm860x_chip *chip,
 				     struct pm860x_platform_data *pdata)
 {
@@ -1053,10 +1006,6 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 		goto out;
 	}
 
-	ret = device_gpadc_init(chip, pdata);
-	if (ret < 0)
-		goto out;
-
 	ret = device_irq_init(chip, pdata);
 	if (ret < 0)
 		goto out;
-- 
1.7.9.5

