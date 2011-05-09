Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1EIAd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:59945 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab1EIAdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="432671260"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 17/19] mfd: Use mfd cell platform_data for 88pm860x cells platform bits
Date: Mon,  9 May 2011 02:32:09 +0200
Message-Id: <1304901131-7104-18-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/leds/leds-88pm860x.c          |    7 +------
 drivers/mfd/88pm860x-core.c           |   18 ++++++++++++------
 drivers/regulator/88pm8607.c          |    7 +------
 drivers/video/backlight/88pm860x_bl.c |    7 +------
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 416def8..0d4c166 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -17,7 +17,6 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 
 #define LED_PWM_SHIFT		(3)
@@ -171,7 +170,6 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm860x_led_pdata *pdata;
 	struct pm860x_led *data;
-	struct mfd_cell *cell;
 	struct resource *res;
 	int ret;
 
@@ -181,10 +179,7 @@ static int pm860x_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	cell = pdev->dev.platform_data;
-	if (cell == NULL)
-		return -ENODEV;
-	pdata = cell->mfd_data;
+	pdata = pdev->dev.platform_data;
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "No platform data!\n");
 		return -EINVAL;
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 011cb6c..801aff7 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -516,7 +516,8 @@ static void __devinit device_bk_init(struct pm860x_chip *chip,
 	for (i = 0; i < pdata->num_backlights; i++) {
 		memcpy(&bk_pdata[i], &pdata->backlight[i],
 			sizeof(struct pm860x_backlight_pdata));
-		bk_devs[i].mfd_data = &bk_pdata[i];
+		bk_devs[i].platform_data = &bk_pdata[i];
+		bk_devs[i].pdata_size = sizeof(bk_pdata[i]);
 
 		for (j = 0; j < ARRAY_SIZE(bk_devs); j++) {
 			id = bk_resources[j].start;
@@ -553,7 +554,8 @@ static void __devinit device_led_init(struct pm860x_chip *chip,
 	for (i = 0; i < pdata->num_leds; i++) {
 		memcpy(&led_pdata[i], &pdata->led[i],
 			sizeof(struct pm860x_led_pdata));
-		led_devs[i].mfd_data = &led_pdata[i];
+		led_devs[i].platform_data = &led_pdata[i];
+		led_devs[i].pdata_size = sizeof(led_pdata[i]);
 
 		for (j = 0; j < ARRAY_SIZE(led_devs); j++) {
 			id = led_resources[j].start;
@@ -617,7 +619,8 @@ static void __devinit device_regulator_init(struct pm860x_chip *chip,
 		}
 		memcpy(&regulator_pdata[i], &pdata->regulator[i],
 			sizeof(struct regulator_init_data));
-		regulator_devs[i].mfd_data = &regulator_pdata[i];
+		regulator_devs[i].platform_data = &regulator_pdata[i];
+		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
 		regulator_devs[i].num_resources = 1;
 		regulator_devs[i].resources = &regulator_resources[j];
 
@@ -642,7 +645,8 @@ static void __devinit device_touch_init(struct pm860x_chip *chip,
 		return;
 
 	memcpy(&touch_pdata, pdata->touch, sizeof(struct pm860x_touch_pdata));
-	touch_devs[0].mfd_data = &touch_pdata;
+	touch_devs[0].platform_data = &touch_pdata;
+	touch_devs[0].pdata_size = sizeof(touch_pdata);
 	touch_devs[0].num_resources = ARRAY_SIZE(touch_resources);
 	touch_devs[0].resources = &touch_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
@@ -662,7 +666,8 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 		return;
 
 	memcpy(&power_pdata, pdata->power, sizeof(struct pm860x_power_pdata));
-	power_devs[0].mfd_data = &power_pdata;
+	power_devs[0].platform_data = &power_pdata;
+	power_devs[0].pdata_size = sizeof(power_pdata);
 	power_devs[0].num_resources = ARRAY_SIZE(battery_resources);
 	power_devs[0].resources = &battery_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[0], 1,
@@ -670,7 +675,8 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add battery subdev\n");
 
-	power_devs[1].mfd_data = &power_pdata;
+	power_devs[1].platform_data = &power_pdata;
+	power_devs[0].pdata_size = sizeof(power_pdata);
 	power_devs[1].num_resources = ARRAY_SIZE(charger_resources);
 	power_devs[1].resources = &charger_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[1], 1,
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 8592512..784ea77 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -15,7 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 
 struct pm8607_regulator_info {
@@ -400,13 +399,9 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm8607_regulator_info *info = NULL;
 	struct regulator_init_data *pdata;
-	struct mfd_cell *cell;
 	int i;
 
-	cell = pdev->dev.platform_data;
-	if (cell == NULL)
-		return -ENODEV;
-	pdata = cell->mfd_data;
+	pdata = pdev->dev.platform_data;
 	if (pdata == NULL)
 		return -EINVAL;
 
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index c8b520e..c04b94d 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -16,7 +16,6 @@
 #include <linux/fb.h>
 #include <linux/i2c.h>
 #include <linux/backlight.h>
-#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 
 #define MAX_BRIGHTNESS		(0xFF)
@@ -168,7 +167,6 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	struct pm860x_backlight_pdata *pdata = NULL;
 	struct pm860x_backlight_data *data;
 	struct backlight_device *bl;
-	struct mfd_cell *cell;
 	struct resource *res;
 	struct backlight_properties props;
 	unsigned char value;
@@ -181,10 +179,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	cell = pdev->dev.platform_data;
-	if (cell == NULL)
-		return -ENODEV;
-	pdata = cell->mfd_data;
+	pdata = pdev->dev.platform_data;
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"backlight\n");
-- 
1.7.2.3

