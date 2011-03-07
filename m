Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1CGPzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:51 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33399 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1CGPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:22 -0500
X-ASG-Debug-ID: 1299512686-082e751b0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x backlight
Subject: [PATCH] mfd: adopt mfd_data in 88pm860x backlight
Date: Mon,  7 Mar 2011 23:43:09 +0800
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x backlight
Message-Id: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512686
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy 88pm860x platform data into different mfd_data structure for
backlight driver. So move the identification of device node from
backlight driver to mfd driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c           |   96 +++++++++++++++++---------------
 drivers/video/backlight/88pm860x_bl.c |   34 +++---------
 include/linux/mfd/88pm860x.h          |    2 +-
 3 files changed, 60 insertions(+), 72 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 793300c..a88967a 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -20,12 +20,19 @@
 
 #define INT_STATUS_NUM			3
 
-char pm860x_backlight_name[][MFD_NAME_SIZE] = {
-	"backlight-0",
-	"backlight-1",
-	"backlight-2",
+static struct resource bk_resources[] __initdata = {
+	{PM8606_BACKLIGHT1, PM8606_BACKLIGHT1, "backlight-0", IORESOURCE_IO,},
+	{PM8606_BACKLIGHT2, PM8606_BACKLIGHT2, "backlight-1", IORESOURCE_IO,},
+	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,},
 };
-EXPORT_SYMBOL(pm860x_backlight_name);
+
+static struct mfd_cell bk_devs[] __initdata = {
+	{"88pm860x-backlight", 0,},
+	{"88pm860x-backlight", 1,},
+	{"88pm860x-backlight", 2,},
+};
+
+static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
 
 char pm860x_led_name[][MFD_NAME_SIZE] = {
 	"led0-red",
@@ -37,34 +44,6 @@ char pm860x_led_name[][MFD_NAME_SIZE] = {
 };
 EXPORT_SYMBOL(pm860x_led_name);
 
-#define PM8606_BACKLIGHT_RESOURCE(_i, _x)		\
-{							\
-	.name	= pm860x_backlight_name[_i],		\
-	.start	= PM8606_##_x,				\
-	.end	= PM8606_##_x,				\
-	.flags	= IORESOURCE_IO,			\
-}
-
-static struct resource backlight_resources[] = {
-	PM8606_BACKLIGHT_RESOURCE(PM8606_BACKLIGHT1, WLED1A),
-	PM8606_BACKLIGHT_RESOURCE(PM8606_BACKLIGHT2, WLED2A),
-	PM8606_BACKLIGHT_RESOURCE(PM8606_BACKLIGHT3, WLED3A),
-};
-
-#define PM8606_BACKLIGHT_DEVS(_i)			\
-{							\
-	.name		= "88pm860x-backlight",		\
-	.num_resources	= 1,				\
-	.resources	= &backlight_resources[_i],	\
-	.id		= _i,				\
-}
-
-static struct mfd_cell backlight_devs[] = {
-	PM8606_BACKLIGHT_DEVS(PM8606_BACKLIGHT1),
-	PM8606_BACKLIGHT_DEVS(PM8606_BACKLIGHT2),
-	PM8606_BACKLIGHT_DEVS(PM8606_BACKLIGHT3),
-};
-
 #define PM8606_LED_RESOURCE(_i, _x)			\
 {							\
 	.name	= pm860x_led_name[_i],			\
@@ -595,23 +574,49 @@ static void device_irq_exit(struct pm860x_chip *chip)
 		free_irq(chip->core_irq, chip);
 }
 
+static void __devinit device_bk_init(struct pm860x_chip *chip,
+				     struct i2c_client *i2c,
+				     struct pm860x_platform_data *pdata)
+{
+	int ret;
+	int i, j, id;
+
+	if ((pdata == NULL) || (pdata->backlight == NULL))
+		return;
+
+	if (pdata->num_backlights > ARRAY_SIZE(bk_devs))
+		pdata->num_backlights = ARRAY_SIZE(bk_devs);
+
+	for (i = 0; i < pdata->num_backlights; i++) {
+		memcpy(&bk_pdata[i], &pdata->backlight[i],
+			sizeof(struct pm860x_backlight_pdata));
+		bk_devs[i].mfd_data = &bk_pdata[i];
+
+		for (j = 0; j < ARRAY_SIZE(bk_devs); j++) {
+			id = bk_resources[j].start;
+			if (bk_pdata[i].flags != id)
+				continue;
+
+			bk_devs[i].num_resources = 1;
+			bk_devs[i].resources = &bk_resources[j];
+			ret = mfd_add_devices(chip->dev, 0,
+					      &bk_devs[i], 1,
+					      &bk_resources[j], 0);
+			if (ret < 0) {
+				dev_err(chip->dev, "Failed to add "
+					"backlight subdev\n");
+				return;
+			}
+		}
+	}
+}
+
 static void __devinit device_8606_init(struct pm860x_chip *chip,
 				       struct i2c_client *i2c,
 				       struct pm860x_platform_data *pdata)
 {
 	int ret;
 
-	if (pdata && pdata->backlight) {
-		ret = mfd_add_devices(chip->dev, 0, &backlight_devs[0],
-				      ARRAY_SIZE(backlight_devs),
-				      &backlight_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add backlight "
-				"subdev\n");
-			goto out_dev;
-		}
-	}
-
 	if (pdata && pdata->led) {
 		ret = mfd_add_devices(chip->dev, 0, &led_devs[0],
 				      ARRAY_SIZE(led_devs),
@@ -624,7 +629,6 @@ static void __devinit device_8606_init(struct pm860x_chip *chip,
 	}
 	return;
 out_dev:
-	mfd_remove_devices(chip->dev);
 	device_irq_exit(chip);
 }
 
@@ -743,6 +747,7 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 
 	switch (chip->id) {
 	case CHIP_PM8606:
+		device_bk_init(chip, chip->client, pdata);
 		device_8606_init(chip, chip->client, pdata);
 		break;
 	case CHIP_PM8607:
@@ -753,6 +758,7 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 	if (chip->companion) {
 		switch (chip->id) {
 		case CHIP_PM8607:
+			device_bk_init(chip, chip->companion, pdata);
 			device_8606_init(chip, chip->companion, pdata);
 			break;
 		case CHIP_PM8606:
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index b224396..552825c 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -12,11 +12,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/i2c.h>
 #include <linux/backlight.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
-#include <linux/slab.h>
 
 #define MAX_BRIGHTNESS		(0xFF)
 #define MIN_BRIGHTNESS		(0)
@@ -161,32 +162,13 @@ static const struct backlight_ops pm860x_backlight_ops = {
 	.get_brightness	= pm860x_backlight_get_brightness,
 };
 
-static int __check_device(struct pm860x_backlight_pdata *pdata, char *name)
-{
-	struct pm860x_backlight_pdata *p = pdata;
-	int ret = -EINVAL;
-
-	while (p && p->id) {
-		if ((p->id != PM8606_ID_BACKLIGHT) || (p->flags < 0))
-			break;
-
-		if (!strncmp(name, pm860x_backlight_name[p->flags],
-			MFD_NAME_SIZE)) {
-			ret = (int)p->flags;
-			break;
-		}
-		p++;
-	}
-	return ret;
-}
-
 static int pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_platform_data *pm860x_pdata;
 	struct pm860x_backlight_pdata *pdata = NULL;
 	struct pm860x_backlight_data *data;
 	struct backlight_device *bl;
+	struct mfd_cell *cell;
 	struct resource *res;
 	struct backlight_properties props;
 	unsigned char value;
@@ -199,10 +181,10 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (pdev->dev.parent->platform_data) {
-		pm860x_pdata = pdev->dev.parent->platform_data;
-		pdata = pm860x_pdata->backlight;
-	}
+	cell = pdev->dev.platform_data;
+	if (cell == NULL)
+		return -ENODEV;
+	pdata = cell->mfd_data;
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"backlight\n");
@@ -219,7 +201,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = MAX_BRIGHTNESS;
 	data->pwm = pdata->pwm;
 	data->iset = pdata->iset;
-	data->port = __check_device(pdata, name);
+	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "wrong platform data is assigned");
 		kfree(data);
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 4db1fbd..f790d37 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -356,10 +356,10 @@ struct pm860x_platform_data {
 	int		i2c_port;	/* Controlled by GI2C or PI2C */
 	int		irq_mode;	/* Clear interrupt by read/write(0/1) */
 	int		irq_base;	/* IRQ base number of 88pm860x */
+	int		num_backlights;
 	struct regulator_init_data *regulator[PM8607_MAX_REGULATOR];
 };
 
-extern char pm860x_backlight_name[][MFD_NAME_SIZE];
 extern char pm860x_led_name[][MFD_NAME_SIZE];
 
 extern int pm860x_reg_read(struct i2c_client *, int);
-- 
1.5.6.5

