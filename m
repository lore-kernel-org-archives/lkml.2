Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2HEQc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:32:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2HEQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:32:54 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 1/5] mfd: use IORESOURCE_MEM in 88pm860x backlight
Date: Mon,  6 Aug 2012 00:32:49 +0800
Message-Id: <1344184373-9670-2-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to use IORESOURCE_IO in mfd core & backlight driver.
Use IORESOURCE_MEM instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/88pm860x-core.c           |   78 ++++++++++++----------
 drivers/video/backlight/88pm860x_bl.c |  114 +++++++++++++--------------------
 include/linux/mfd/88pm860x.h          |    8 ---
 3 files changed, 89 insertions(+), 111 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index d09918c..ee2445c 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -21,10 +21,20 @@
 
 #define INT_STATUS_NUM			3
 
-static struct resource bk_resources[] __devinitdata = {
-	{PM8606_BACKLIGHT1, PM8606_BACKLIGHT1, "backlight-0", IORESOURCE_IO,},
-	{PM8606_BACKLIGHT2, PM8606_BACKLIGHT2, "backlight-1", IORESOURCE_IO,},
-	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,},
+static struct resource bk0_resources[] __devinitdata = {
+	{2, 2, "duty cycle", IORESOURCE_MEM, },
+	{3, 3, "always on",  IORESOURCE_MEM, },
+	{3, 3, "current",    IORESOURCE_MEM, },
+};
+static struct resource bk1_resources[] __devinitdata = {
+	{4, 4, "duty cycle", IORESOURCE_MEM, },
+	{5, 5, "always on",  IORESOURCE_MEM, },
+	{5, 5, "current",    IORESOURCE_MEM, },
+};
+static struct resource bk2_resources[] __devinitdata = {
+	{6, 6, "duty cycle", IORESOURCE_MEM, },
+	{7, 7, "always on",  IORESOURCE_MEM, },
+	{5, 5, "current",    IORESOURCE_MEM, },
 };
 
 static struct resource led_resources[] __devinitdata = {
@@ -99,9 +109,22 @@ static struct resource rtc_resources[] __devinitdata = {
 };
 
 static struct mfd_cell bk_devs[] = {
-	{"88pm860x-backlight", 0,},
-	{"88pm860x-backlight", 1,},
-	{"88pm860x-backlight", 2,},
+	{
+		.name = "88pm860x-backlight",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(bk0_resources),
+		.resources = bk0_resources,
+	}, {
+		.name = "88pm860x-backlight",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(bk1_resources),
+		.resources = bk1_resources,
+	}, {
+		.name = "88pm860x-backlight",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(bk2_resources),
+		.resources = bk2_resources,
+	},
 };
 
 static struct mfd_cell led_devs[] = {
@@ -615,36 +638,21 @@ static void __devinit device_osc_init(struct i2c_client *i2c)
 static void __devinit device_bk_init(struct pm860x_chip *chip,
 				     struct pm860x_platform_data *pdata)
 {
-	int ret;
-	int i, j, id;
-
-	if ((pdata == NULL) || (pdata->backlight == NULL))
-		return;
-
-	if (pdata->num_backlights > ARRAY_SIZE(bk_devs))
-		pdata->num_backlights = ARRAY_SIZE(bk_devs);
-
-	for (i = 0; i < pdata->num_backlights; i++) {
-		bk_devs[i].platform_data = &pdata->backlight[i];
-		bk_devs[i].pdata_size = sizeof(struct pm860x_backlight_pdata);
-
-		for (j = 0; j < ARRAY_SIZE(bk_devs); j++) {
-			id = bk_resources[j].start;
-			if (pdata->backlight[i].flags != id)
-				continue;
-
-			bk_devs[i].num_resources = 1;
-			bk_devs[i].resources = &bk_resources[j];
-			ret = mfd_add_devices(chip->dev, 0,
-					      &bk_devs[i], 1,
-					      &bk_resources[j], 0);
-			if (ret < 0) {
-				dev_err(chip->dev, "Failed to add "
-					"backlight subdev\n");
-				return;
-			}
+	int ret, i;
+
+	if (pdata && pdata->backlight) {
+		if (pdata->num_backlights > ARRAY_SIZE(bk_devs))
+			pdata->num_backlights = ARRAY_SIZE(bk_devs);
+		for (i = 0; i < pdata->num_backlights; i++) {
+			bk_devs[i].platform_data = &pdata->backlight[i];
+			bk_devs[i].pdata_size =
+				sizeof(struct pm860x_backlight_pdata);
 		}
 	}
+	ret = mfd_add_devices(chip->dev, 0, bk_devs,
+			      ARRAY_SIZE(bk_devs), NULL, 0);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add backlight subdev\n");
 }
 
 static void __devinit device_led_init(struct pm860x_chip *chip,
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index f75da87..e48d846 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -31,57 +31,26 @@ struct pm860x_backlight_data {
 	int	port;
 	int	pwm;
 	int	iset;
+	int	reg_duty_cycle;
+	int	reg_always_on;
+	int	reg_current;
 };
 
-static inline int wled_a(int port)
-{
-	int ret;
-
-	ret = ((port - PM8606_BACKLIGHT1) << 1) + 2;
-	return ret;
-}
-
-static inline int wled_b(int port)
-{
-	int ret;
-
-	ret = ((port - PM8606_BACKLIGHT1) << 1) + 3;
-	return ret;
-}
-
-/* WLED2 & WLED3 share the same IDC */
-static inline int wled_idc(int port)
-{
-	int ret;
-
-	switch (port) {
-	case PM8606_BACKLIGHT1:
-	case PM8606_BACKLIGHT2:
-		ret = ((port - PM8606_BACKLIGHT1) << 1) + 3;
-		break;
-	case PM8606_BACKLIGHT3:
-	default:
-		ret = ((port - PM8606_BACKLIGHT2) << 1) + 3;
-		break;
-	}
-	return ret;
-}
-
 static int backlight_power_set(struct pm860x_chip *chip, int port,
 		int on)
 {
 	int ret = -EINVAL;
 
 	switch (port) {
-	case PM8606_BACKLIGHT1:
+	case 0:
 		ret = on ? pm8606_osc_enable(chip, WLED1_DUTY) :
 			pm8606_osc_disable(chip, WLED1_DUTY);
 		break;
-	case PM8606_BACKLIGHT2:
+	case 1:
 		ret = on ? pm8606_osc_enable(chip, WLED2_DUTY) :
 			pm8606_osc_disable(chip, WLED2_DUTY);
 		break;
-	case PM8606_BACKLIGHT3:
+	case 2:
 		ret = on ? pm8606_osc_enable(chip, WLED3_DUTY) :
 			pm8606_osc_disable(chip, WLED3_DUTY);
 		break;
@@ -104,13 +73,13 @@ static int pm860x_backlight_set(struct backlight_device *bl, int brightness)
 	if (brightness)
 		backlight_power_set(chip, data->port, 1);
 
-	ret = pm860x_reg_write(data->i2c, wled_a(data->port), value);
+	ret = pm860x_reg_write(data->i2c, data->reg_duty_cycle, value);
 	if (ret < 0)
 		goto out;
 
 	if ((data->current_brightness == 0) && brightness) {
 		if (data->iset) {
-			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
+			ret = pm860x_set_bits(data->i2c, data->reg_current,
 					      CURRENT_BITMASK, data->iset);
 			if (ret < 0)
 				goto out;
@@ -123,17 +92,17 @@ static int pm860x_backlight_set(struct backlight_device *bl, int brightness)
 		}
 		if (brightness == MAX_BRIGHTNESS) {
 			/* set WLED_ON bit as 100% */
-			ret = pm860x_set_bits(data->i2c, wled_b(data->port),
+			ret = pm860x_set_bits(data->i2c, data->reg_always_on,
 					      PM8606_WLED_ON, PM8606_WLED_ON);
 		}
 	} else {
 		if (brightness == MAX_BRIGHTNESS) {
 			/* set WLED_ON bit as 100% */
-			ret = pm860x_set_bits(data->i2c, wled_b(data->port),
+			ret = pm860x_set_bits(data->i2c, data->reg_always_on,
 					      PM8606_WLED_ON, PM8606_WLED_ON);
 		} else {
 			/* clear WLED_ON bit since it's not 100% */
-			ret = pm860x_set_bits(data->i2c, wled_b(data->port),
+			ret = pm860x_set_bits(data->i2c, data->reg_always_on,
 					      PM8606_WLED_ON, 0);
 		}
 	}
@@ -174,7 +143,7 @@ static int pm860x_backlight_get_brightness(struct backlight_device *bl)
 	struct pm860x_chip *chip = data->chip;
 	int ret;
 
-	ret = pm860x_reg_read(data->i2c, wled_a(data->port));
+	ret = pm860x_reg_read(data->i2c, data->reg_duty_cycle);
 	if (ret < 0)
 		goto out;
 	data->current_brightness = ret;
@@ -193,43 +162,50 @@ static const struct backlight_ops pm860x_backlight_ops = {
 static int pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_backlight_pdata *pdata = NULL;
+	struct pm860x_backlight_pdata *pdata = pdev->dev.platform_data;
 	struct pm860x_backlight_data *data;
 	struct backlight_device *bl;
 	struct resource *res;
 	struct backlight_properties props;
 	char name[MFD_NAME_SIZE];
-	int ret;
-
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "No I/O resource!\n");
-		return -EINVAL;
-	}
-
-	pdata = pdev->dev.platform_data;
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "platform data isn't assigned to "
-			"backlight\n");
-		return -EINVAL;
-	}
+	int ret = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_backlight_data),
 			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
-	strncpy(name, res->name, MFD_NAME_SIZE);
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "duty cycle");
+	if (!res) {
+		dev_err(&pdev->dev, "No memory resource for duty cycle\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	data->reg_duty_cycle = res->start;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "always on");
+	if (!res) {
+		dev_err(&pdev->dev, "No memory resorce for always on\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	data->reg_always_on = res->start;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "current");
+	if (!res) {
+		dev_err(&pdev->dev, "No memory resource for current\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	data->reg_current = res->start;
+
+	memset(name, 0, MFD_NAME_SIZE);
+	sprintf(name, "backlight-%d", pdev->id);
+	data->port = pdev->id;
 	data->chip = chip;
 	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
 			: chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
-	data->pwm = pdata->pwm;
-	data->iset = pdata->iset;
-	data->port = pdata->flags;
-	if (data->port < 0) {
-		dev_err(&pdev->dev, "wrong platform data is assigned");
-		kfree(data);
-		return -EINVAL;
+	if (pdata) {
+		data->pwm = pdata->pwm;
+		data->iset = pdata->iset;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -248,12 +224,14 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	/* read current backlight */
 	ret = pm860x_backlight_get_brightness(bl);
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
 
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 7b24943..b7e656d 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -35,12 +35,6 @@ enum {
 };
 
 enum {
-	PM8606_BACKLIGHT1 = 0,
-	PM8606_BACKLIGHT2,
-	PM8606_BACKLIGHT3,
-};
-
-enum {
 	PM8606_LED1_RED = 0,
 	PM8606_LED1_GREEN,
 	PM8606_LED1_BLUE,
@@ -340,10 +334,8 @@ enum {
 };
 
 struct pm860x_backlight_pdata {
-	int		id;
 	int		pwm;
 	int		iset;
-	unsigned long	flags;
 };
 
 struct pm860x_led_pdata {
-- 
1.7.9.5

