Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1EFJ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:29:13 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50542 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab1EFJ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:08 -0400
X-ASG-Debug-ID: 1304674147-082dceb60001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it,
        khali@linux-fr.org, ben-linux@fluff.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 2/6] mfd: 88pm860x: avoid to allocate static platform data
Subject: [PATCH 2/6] mfd: 88pm860x: avoid to allocate static platform data
Date: Fri,  6 May 2011 17:21:21 +0800
X-ASG-Orig-Subj: [PATCH 2/6] mfd: 88pm860x: avoid to allocate static platform data
Message-Id: <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1304674147
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe multiple PMIC devices are installed into one board. Static variable
can only make driver logic mess. So remove these variable, and use
platform data from platform driver instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/88pm860x-core.c |   45 +++++++++++++++---------------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index f2cac92..04ab50c 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -151,11 +151,6 @@ static struct mfd_cell rtc_devs[] = {
 	{"88pm860x-rtc", -1,},
 };
 
-static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
-static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
-static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
-static struct pm860x_touch_pdata touch_pdata;
-static struct pm860x_power_pdata power_pdata;
 
 struct pm860x_irq_data {
 	int	reg;
@@ -522,14 +517,12 @@ static void __devinit device_bk_init(struct pm860x_chip *chip,
 		pdata->num_backlights = ARRAY_SIZE(bk_devs);
 
 	for (i = 0; i < pdata->num_backlights; i++) {
-		memcpy(&bk_pdata[i], &pdata->backlight[i],
-			sizeof(struct pm860x_backlight_pdata));
-		bk_devs[i].platform_data = &bk_pdata[i];
-		bk_devs[i].pdata_size = sizeof(bk_pdata[i]);
+		bk_devs[i].platform_data = &pdata->backlight[i];
+		bk_devs[i].pdata_size = sizeof(struct pm860x_backlight_pdata);
 
 		for (j = 0; j < ARRAY_SIZE(bk_devs); j++) {
 			id = bk_resources[j].start;
-			if (bk_pdata[i].flags != id)
+			if (pdata->backlight[i].flags != id)
 				continue;
 
 			bk_devs[i].num_resources = 1;
@@ -560,14 +553,12 @@ static void __devinit device_led_init(struct pm860x_chip *chip,
 		pdata->num_leds = ARRAY_SIZE(led_devs);
 
 	for (i = 0; i < pdata->num_leds; i++) {
-		memcpy(&led_pdata[i], &pdata->led[i],
-			sizeof(struct pm860x_led_pdata));
-		led_devs[i].platform_data = &led_pdata[i];
-		led_devs[i].pdata_size = sizeof(led_pdata[i]);
+		led_devs[i].platform_data = &pdata->led[i];
+		led_devs[i].pdata_size = sizeof(struct pm860x_led_pdata);
 
 		for (j = 0; j < ARRAY_SIZE(led_devs); j++) {
 			id = led_resources[j].start;
-			if (led_pdata[i].flags != id)
+			if (pdata->led[i].flags != id)
 				continue;
 
 			led_devs[i].num_resources = 1;
@@ -625,10 +616,8 @@ static void __devinit device_regulator_init(struct pm860x_chip *chip,
 				initdata->constraints.name);
 			goto out;
 		}
-		memcpy(&regulator_pdata[i], &pdata->regulator[i],
-			sizeof(struct regulator_init_data));
-		regulator_devs[i].platform_data = &regulator_pdata[i];
-		regulator_devs[i].pdata_size = sizeof(regulator_pdata[i]);
+		regulator_devs[i].platform_data = &pdata->regulator[i];
+		regulator_devs[i].pdata_size = sizeof(struct regulator_init_data);
 		regulator_devs[i].num_resources = 1;
 		regulator_devs[i].resources = &regulator_resources[j];
 
@@ -669,12 +658,11 @@ static void __devinit device_touch_init(struct pm860x_chip *chip,
 {
 	int ret;
 
-	if ((pdata == NULL) || (pdata->touch == NULL))
+	if (pdata == NULL)
 		return;
 
-	memcpy(&touch_pdata, pdata->touch, sizeof(struct pm860x_touch_pdata));
-	touch_devs[0].platform_data = &touch_pdata;
-	touch_devs[0].pdata_size = sizeof(touch_pdata);
+	touch_devs[0].platform_data = pdata->touch;
+	touch_devs[0].pdata_size = sizeof(struct pm860x_touch_pdata);
 	touch_devs[0].num_resources = ARRAY_SIZE(touch_resources);
 	touch_devs[0].resources = &touch_resources[0];
 	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
@@ -690,12 +678,11 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 {
 	int ret;
 
-	if ((pdata == NULL) || (pdata->power == NULL))
+	if (pdata == NULL)
 		return;
 
-	memcpy(&power_pdata, pdata->power, sizeof(struct pm860x_power_pdata));
-	power_devs[0].platform_data = &power_pdata;
-	power_devs[0].pdata_size = sizeof(power_pdata);
+	power_devs[0].platform_data = pdata->power;
+	power_devs[0].pdata_size = sizeof(struct pm860x_power_pdata);
 	power_devs[0].num_resources = ARRAY_SIZE(battery_resources);
 	power_devs[0].resources = &battery_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[0], 1,
@@ -703,8 +690,8 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		dev_err(chip->dev, "Failed to add battery subdev\n");
 
-	power_devs[1].platform_data = &power_pdata;
-	power_devs[0].pdata_size = sizeof(power_pdata);
+	power_devs[1].platform_data = pdata->power;
+	power_devs[1].pdata_size = sizeof(struct pm860x_power_pdata);
 	power_devs[1].num_resources = ARRAY_SIZE(charger_resources);
 	power_devs[1].resources = &charger_resources[0],
 	ret = mfd_add_devices(chip->dev, 0, &power_devs[1], 1,
-- 
1.5.6.5

