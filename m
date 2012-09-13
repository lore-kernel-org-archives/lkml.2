Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2IMIXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:23:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2IMIWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:22:51 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v2 1/2] mfd: max8925: use register offset as REG in backlight
Date: Thu, 13 Sep 2012 16:22:21 +0800
Message-Id: <1347524542-4569-2-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347524542-4569-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347524542-4569-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the register offset definition. All these register offset
are transfered as IORESOURCE_REG resources.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/max8925-core.c           |   31 ++++++-------
 drivers/video/backlight/max8925_bl.c |   79 ++++++++++++++++++----------------
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index f2ff31f..cdcaec8 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -18,20 +18,16 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
 
-static struct resource backlight_resources[] = {
-	{
-		.name	= "max8925-backlight",
-		.start	= MAX8925_WLED_MODE_CNTL,
-		.end	= MAX8925_WLED_CNTL,
-		.flags	= IORESOURCE_REG,
-	},
+static struct resource bk_resources[] __devinitdata = {
+	{ 0x84, 0x84, "mode control", IORESOURCE_REG, },
+	{ 0x85, 0x85, "control",      IORESOURCE_REG, },
 };
 
-static struct mfd_cell backlight_devs[] = {
+static struct mfd_cell bk_devs[] __devinitdata = {
 	{
 		.name		= "max8925-backlight",
-		.num_resources	= 1,
-		.resources	= &backlight_resources[0],
+		.num_resources	= ARRAY_SIZE(bk_resources),
+		.resources	= &bk_resources[0],
 		.id		= -1,
 	},
 };
@@ -623,13 +619,14 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	}
 
 	if (pdata && pdata->backlight) {
-		ret = mfd_add_devices(chip->dev, 0, &backlight_devs[0],
-				      ARRAY_SIZE(backlight_devs),
-				      &backlight_resources[0], 0, NULL);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add backlight subdev\n");
-			goto out_dev;
-		}
+		bk_devs[0].platform_data = &pdata->backlight;
+		bk_devs[0].pdata_size = sizeof(struct max8925_backlight_pdata);
+	}
+	ret = mfd_add_devices(chip->dev, 0, bk_devs, ARRAY_SIZE(bk_devs),
+			      NULL, 0);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to add backlight subdev\n");
+		goto out_dev;
 	}
 
 	if (pdata && pdata->power) {
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 996dadf..f72ba54 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -27,7 +27,9 @@
 struct max8925_backlight_data {
 	struct max8925_chip	*chip;
 
-	int		current_brightness;
+	int	current_brightness;
+	int	reg_mode_cntl;
+	int	reg_cntl;
 };
 
 static int max8925_backlight_set(struct backlight_device *bl, int brightness)
@@ -42,16 +44,16 @@ static int max8925_backlight_set(struct backlight_device *bl, int brightness)
 	else
 		value = brightness;
 
-	ret = max8925_reg_write(chip->i2c, MAX8925_WLED_CNTL, value);
+	ret = max8925_reg_write(chip->i2c, data->reg_cntl, value);
 	if (ret < 0)
 		goto out;
 
 	if (!data->current_brightness && brightness)
 		/* enable WLED output */
-		ret = max8925_set_bits(chip->i2c, MAX8925_WLED_MODE_CNTL, 1, 1);
+		ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 1, 1);
 	else if (!brightness)
 		/* disable WLED output */
-		ret = max8925_set_bits(chip->i2c, MAX8925_WLED_MODE_CNTL, 1, 0);
+		ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 1, 0);
 	if (ret < 0)
 		goto out;
 	dev_dbg(chip->dev, "set brightness %d\n", value);
@@ -85,7 +87,7 @@ static int max8925_backlight_get_brightness(struct backlight_device *bl)
 	struct max8925_chip *chip = data->chip;
 	int ret;
 
-	ret = max8925_reg_read(chip->i2c, MAX8925_WLED_CNTL);
+	ret = max8925_reg_read(chip->i2c, data->reg_cntl);
 	if (ret < 0)
 		return -EINVAL;
 	data->current_brightness = ret;
@@ -102,69 +104,70 @@ static const struct backlight_ops max8925_backlight_ops = {
 static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct max8925_platform_data *max8925_pdata;
-	struct max8925_backlight_pdata *pdata = NULL;
+	struct max8925_backlight_pdata *pdata = pdev->dev.platform_data;
 	struct max8925_backlight_data *data;
 	struct backlight_device *bl;
 	struct backlight_properties props;
 	struct resource *res;
-	char name[MAX8925_NAME_SIZE];
 	unsigned char value;
-	int ret;
-
-	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "No I/O resource!\n");
-		return -EINVAL;
-	}
-
-	if (pdev->dev.parent->platform_data) {
-		max8925_pdata = pdev->dev.parent->platform_data;
-		pdata = max8925_pdata->backlight;
-	}
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "platform data isn't assigned to "
-			"backlight\n");
-		return -EINVAL;
-	}
+	int ret = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct max8925_backlight_data),
 			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
-	strncpy(name, res->name, MAX8925_NAME_SIZE);
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "No REG resource for mode control!\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	data->reg_mode_cntl = res->start;
+	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
+	if (!res) {
+		dev_err(&pdev->dev, "No REG resource for control!\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	data->reg_cntl = res->start;
+
 	data->chip = chip;
 	data->current_brightness = 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
-	bl = backlight_device_register(name, &pdev->dev, data,
+	bl = backlight_device_register("max8925-backlight", &pdev->dev, data,
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		return PTR_ERR(bl);
+		ret = PTR_ERR(bl);
+		goto out;
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
 
 	platform_set_drvdata(pdev, bl);
 
 	value = 0;
-	if (pdata->lxw_scl)
-		value |= (1 << 7);
-	if (pdata->lxw_freq)
-		value |= (LWX_FREQ(pdata->lxw_freq) << 4);
-	if (pdata->dual_string)
-		value |= (1 << 1);
-	ret = max8925_set_bits(chip->i2c, MAX8925_WLED_MODE_CNTL, 0xfe, value);
+	if (pdata) {
+		if (pdata->lxw_scl)
+			value |= (1 << 7);
+		if (pdata->lxw_freq)
+			value |= (LWX_FREQ(pdata->lxw_freq) << 4);
+		if (pdata->dual_string)
+			value |= (1 << 1);
+	}
+	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
 	if (ret < 0)
-		goto out;
+		goto out_brt;
 
 	backlight_update_status(bl);
 	return 0;
-out:
+out_brt:
 	backlight_device_unregister(bl);
+out:
+	devm_kfree(&pdev->dev, data);
 	return ret;
 }
 
-- 
1.7.9.5

