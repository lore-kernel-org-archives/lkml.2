Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1CGPze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:34 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33394 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1CGPzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:19 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Mar 2011 10:55:19 EST
X-ASG-Debug-ID: 1299512690-082b752d0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x
Subject: [PATCH] mfd: adopt mfd_data in 88pm860x
Date: Mon,  7 Mar 2011 23:43:12 +0800
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x
Message-Id: <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512690
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy 88pm860x platform data into different mfd_data structure for
onkey/touch/codec/power driver. So move the identification of
device node from those drivers to mfd driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/input/misc/88pm860x_onkey.c |    2 +-
 drivers/mfd/88pm860x-core.c         |  251 ++++++++++++++++++-----------------
 2 files changed, 127 insertions(+), 126 deletions(-)

diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
index 4cc8282..3dca3c1 100644
--- a/drivers/input/misc/88pm860x_onkey.c
+++ b/drivers/input/misc/88pm860x_onkey.c
@@ -74,7 +74,7 @@ static int __devinit pm860x_onkey_probe(struct platform_device *pdev)
 	info->chip = chip;
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->dev = &pdev->dev;
-	info->irq = irq + chip->irq_base;
+	info->irq = irq;
 
 	info->idev = input_allocate_device();
 	if (!info->idev) {
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 96ea0c6..9c511c1 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -57,6 +57,39 @@ static struct resource regulator_resources[] __initdata = {
 	{PM8607_ID_LDO15, PM8607_ID_LDO15, "ldo-15", IORESOURCE_IO,},
 };
 
+static struct resource touch_resources[] __initdata = {
+	{PM8607_IRQ_PEN, PM8607_IRQ_PEN, "touch", IORESOURCE_IRQ,},
+};
+
+static struct resource onkey_resources[] __initdata = {
+	{PM8607_IRQ_ONKEY, PM8607_IRQ_ONKEY, "onkey", IORESOURCE_IRQ,},
+};
+
+static struct resource codec_resources[] __initdata = {
+	/* Headset microphone insertion or removal */
+	{PM8607_IRQ_MICIN,   PM8607_IRQ_MICIN,   "micin",   IORESOURCE_IRQ,},
+	/* Hook-switch press or release */
+	{PM8607_IRQ_HOOK,    PM8607_IRQ_HOOK,    "hook",    IORESOURCE_IRQ,},
+	/* Headset insertion or removal */
+	{PM8607_IRQ_HEADSET, PM8607_IRQ_HEADSET, "headset", IORESOURCE_IRQ,},
+	/* Audio short */
+	{PM8607_IRQ_AUDIO_SHORT, PM8607_IRQ_AUDIO_SHORT, "audio-short", IORESOURCE_IRQ,},
+};
+
+static struct resource battery_resources[] __initdata = {
+	{PM8607_IRQ_CC,  PM8607_IRQ_CC,  "columb counter", IORESOURCE_IRQ,},
+	{PM8607_IRQ_BAT, PM8607_IRQ_BAT, "battery",        IORESOURCE_IRQ,},
+};
+
+static struct resource charger_resources[] __initdata = {
+	{PM8607_IRQ_CHG,  PM8607_IRQ_CHG,  "charger detect",  IORESOURCE_IRQ,},
+	{PM8607_IRQ_CHG_DONE,  PM8607_IRQ_CHG_DONE,  "charging done",       IORESOURCE_IRQ,},
+	{PM8607_IRQ_CHG_FAULT, PM8607_IRQ_CHG_FAULT, "charging timeout",    IORESOURCE_IRQ,},
+	{PM8607_IRQ_GPADC1,    PM8607_IRQ_GPADC1,    "battery temperature", IORESOURCE_IRQ,},
+	{PM8607_IRQ_VBAT, PM8607_IRQ_VBAT, "battery voltage", IORESOURCE_IRQ,},
+	{PM8607_IRQ_VCHG, PM8607_IRQ_VCHG, "vchg voltage",    IORESOURCE_IRQ,},
+};
+
 static struct mfd_cell bk_devs[] __initdata = {
 	{"88pm860x-backlight", 0,},
 	{"88pm860x-backlight", 1,},
@@ -93,98 +126,28 @@ static struct mfd_cell regulator_devs[] __initdata = {
 	{"88pm860x-regulator", 17,},
 };
 
-static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
-static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
-static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
-
-static struct resource touch_resources[] = {
-	{
-		.start	= PM8607_IRQ_PEN,
-		.end	= PM8607_IRQ_PEN,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct mfd_cell touch_devs[] __initdata = {
+	{"88pm860x-touch", -1,},
 };
 
-static struct mfd_cell touch_devs[] = {
-	{
-		.name		= "88pm860x-touch",
-		.num_resources	= 1,
-		.resources	= &touch_resources[0],
-	},
+static struct mfd_cell onkey_devs[] __initdata = {
+	{"88pm860x-onkey", -1,},
 };
 
-static struct resource power_supply_resources[] = {
-	{
-		.name		= "88pm860x-power",
-		.start		= PM8607_IRQ_CHG,
-		.end		= PM8607_IRQ_CHG,
-		.flags		= IORESOURCE_IRQ,
-	},
+static struct mfd_cell codec_devs[] __initdata = {
+	{"88pm860x-codec", -1,},
 };
 
 static struct mfd_cell power_devs[] = {
-	{
-		.name		= "88pm860x-power",
-		.num_resources	= 1,
-		.resources	= &power_supply_resources[0],
-		.id		= -1,
-	},
-};
-
-static struct resource onkey_resources[] = {
-	{
-		.name		= "88pm860x-onkey",
-		.start		= PM8607_IRQ_ONKEY,
-		.end		= PM8607_IRQ_ONKEY,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct mfd_cell onkey_devs[] = {
-	{
-		.name		= "88pm860x-onkey",
-		.num_resources	= 1,
-		.resources	= &onkey_resources[0],
-		.id		= -1,
-	},
-};
-
-static struct resource codec_resources[] = {
-	{
-		/* Headset microphone insertion or removal */
-		.name		= "micin",
-		.start		= PM8607_IRQ_MICIN,
-		.end		= PM8607_IRQ_MICIN,
-		.flags		= IORESOURCE_IRQ,
-	}, {
-		/* Hook-switch press or release */
-		.name		= "hook",
-		.start		= PM8607_IRQ_HOOK,
-		.end		= PM8607_IRQ_HOOK,
-		.flags		= IORESOURCE_IRQ,
-	}, {
-		/* Headset insertion or removal */
-		.name		= "headset",
-		.start		= PM8607_IRQ_HEADSET,
-		.end		= PM8607_IRQ_HEADSET,
-		.flags		= IORESOURCE_IRQ,
-	}, {
-		/* Audio short */
-		.name		= "audio-short",
-		.start		= PM8607_IRQ_AUDIO_SHORT,
-		.end		= PM8607_IRQ_AUDIO_SHORT,
-		.flags		= IORESOURCE_IRQ,
-	},
+	{"88pm860x-battery", -1,},
+	{"88pm860x-charger", -1,},
 };
 
-static struct mfd_cell codec_devs[] = {
-	{
-		.name		= "88pm860x-codec",
-		.num_resources	= ARRAY_SIZE(codec_resources),
-		.resources	= &codec_resources[0],
-		.id		= -1,
-	},
-};
+static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
+static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
+static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
+static struct pm860x_touch_pdata touch_pdata;
+static struct pm860x_power_pdata power_pdata;
 
 struct pm860x_irq_data {
 	int	reg;
@@ -672,6 +635,82 @@ out:
 	return;
 }
 
+static void __devinit device_touch_init(struct pm860x_chip *chip,
+					struct i2c_client *i2c,
+					struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->touch == NULL))
+		return;
+
+	memcpy(&touch_pdata, pdata->touch, sizeof(struct pm860x_touch_pdata));
+	touch_devs[0].mfd_data = &touch_pdata;
+	touch_devs[0].num_resources = ARRAY_SIZE(touch_resources);
+	touch_devs[0].resources = &touch_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
+			      ARRAY_SIZE(touch_devs), &touch_resources[0],
+			      chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add touch subdev\n");
+}
+
+static void __devinit device_power_init(struct pm860x_chip *chip,
+					struct i2c_client *i2c,
+					struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->power == NULL))
+		return;
+
+	memcpy(&power_pdata, pdata->power, sizeof(struct pm860x_power_pdata));
+	power_devs[0].mfd_data = &power_pdata;
+	power_devs[0].num_resources = ARRAY_SIZE(battery_resources);
+	power_devs[0].resources = &battery_resources[0],
+	ret = mfd_add_devices(chip->dev, 0, &power_devs[0], 1,
+			      &battery_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add battery subdev\n");
+
+	power_devs[1].mfd_data = &power_pdata;
+	power_devs[1].num_resources = ARRAY_SIZE(charger_resources);
+	power_devs[1].resources = &charger_resources[0],
+	ret = mfd_add_devices(chip->dev, 0, &power_devs[1], 1,
+			      &charger_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add charger subdev\n");
+}
+
+static void __devinit device_onkey_init(struct pm860x_chip *chip,
+					struct i2c_client *i2c,
+					struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	onkey_devs[0].num_resources = ARRAY_SIZE(onkey_resources);
+	onkey_devs[0].resources = &onkey_resources[0],
+	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
+			      ARRAY_SIZE(onkey_devs), &onkey_resources[0],
+			      chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add onkey subdev\n");
+}
+
+static void __devinit device_codec_init(struct pm860x_chip *chip,
+					struct i2c_client *i2c,
+					struct pm860x_platform_data *pdata)
+{
+	int ret;
+
+	codec_devs[0].num_resources = ARRAY_SIZE(codec_resources);
+	codec_devs[0].resources = &codec_resources[0],
+	ret = mfd_add_devices(chip->dev, 0, &codec_devs[0],
+			      ARRAY_SIZE(codec_devs), &codec_resources[0], 0);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add codec subdev\n");
+}
+
 static void __devinit device_8607_init(struct pm860x_chip *chip,
 				       struct i2c_client *i2c,
 				       struct pm860x_platform_data *pdata)
@@ -727,49 +766,11 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		goto out;
 
-	if (pdata && pdata->touch) {
-		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
-				      ARRAY_SIZE(touch_devs),
-				      &touch_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add touch "
-				"subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->power) {
-		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
-				      ARRAY_SIZE(power_devs),
-				      &power_supply_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add power supply "
-				"subdev\n");
-			goto out_dev;
-		}
-	}
-
-	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
-			      ARRAY_SIZE(onkey_devs),
-			      &onkey_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add onkey subdev\n");
-		goto out_dev;
-	}
-
-	ret = mfd_add_devices(chip->dev, 0, &codec_devs[0],
-			      ARRAY_SIZE(codec_devs),
-			      &codec_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add codec subdev\n");
-		goto out_dev;
-	}
-
 	device_regulator_init(chip, i2c, pdata);
-	return;
-out_dev:
-	mfd_remove_devices(chip->dev);
-	device_irq_exit(chip);
+	device_onkey_init(chip, i2c, pdata);
+	device_touch_init(chip, i2c, pdata);
+	device_power_init(chip, i2c, pdata);
+	device_codec_init(chip, i2c, pdata);
 out:
 	return;
 }
-- 
1.5.6.5

