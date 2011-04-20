Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1DTMAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:00:10 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:45178 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1DTMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:00:08 -0400
X-ASG-Debug-ID: 1303300807-082c76620001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 08/14] mfd: use platform_data in max8925
Subject: [PATCH 08/14] mfd: use platform_data in max8925
Date: Wed, 20 Apr 2011 19:54:26 +0800
X-ASG-Orig-Subj: [PATCH 08/14] mfd: use platform_data in max8925
Message-Id: <1303300466-1960-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303135451-26362-9-git-send-email-haojian.zhuang@marvell.com>
References: <1303135451-26362-9-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303300807
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_data to pass parameters to client driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/max8925-core.c |  287 +++++++++++++++++++++++++-------------------
 1 files changed, 162 insertions(+), 125 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 58cc5fd..a974711 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -17,102 +17,88 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
+#include <linux/regulator/machine.h>
 
-static struct resource backlight_resources[] = {
-	{
-		.name	= "max8925-backlight",
-		.start	= MAX8925_WLED_MODE_CNTL,
-		.end	= MAX8925_WLED_CNTL,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource bk_resources[] __devinitdata = {
+	{0, 0, "max8925-backlight", IORESOURCE_IO,},
 };
 
-static struct mfd_cell backlight_devs[] = {
-	{
-		.name		= "max8925-backlight",
-		.num_resources	= 1,
-		.resources	= &backlight_resources[0],
-		.id		= -1,
-	},
+static struct resource touch_resources[] __devinitdata = {
+	{MAX8925_IRQ_TSC_STICK,  MAX8925_IRQ_TSC_STICK,  "touch stick",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_TSC_NSTICK, MAX8925_IRQ_TSC_NSTICK, "touch nstick",
+	 IORESOURCE_IRQ,},
 };
 
-static struct resource touch_resources[] = {
-	{
-		.name	= "max8925-tsc",
-		.start	= MAX8925_TSC_IRQ,
-		.end	= MAX8925_ADC_RES_END,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource power_resources[] __devinitdata = {
+	{MAX8925_IRQ_VCHG_DC_OVP,    MAX8925_IRQ_VCHG_DC_OVP,		\
+	 "dc overvoltage",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DC_F,      MAX8925_IRQ_VCHG_DC_F,		\
+	 "dc falling",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DC_R,      MAX8925_IRQ_VCHG_DC_R,		\
+	 "dc rising",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_OVP,   MAX8925_IRQ_VCHG_USB_OVP,		\
+	 "usb overvoltage",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_F,     MAX8925_IRQ_VCHG_USB_F,		\
+	 "usb falling",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_USB_R,     MAX8925_IRQ_VCHG_USB_R,		\
+	 "usb rising",		IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_THM_OK_R,  MAX8925_IRQ_VCHG_THM_OK_R,		\
+	 "bat temp valid",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_THM_OK_F,  MAX8925_IRQ_VCHG_THM_OK_F,		\
+	 "bat temp invalid",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_SYSLOW_F, MAX8925_IRQ_VCHG_SYSLOW_F,		\
+	 "VSYSLOW falling",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_SYSLOW_R, MAX8925_IRQ_VCHG_SYSLOW_R,		\
+	 "VSYSLOW rising", IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_RST,       MAX8925_IRQ_VCHG_RST,		\
+	 "charger restart",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_DONE,      MAX8925_IRQ_VCHG_DONE,		\
+	 "charger done",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_TOPOFF,    MAX8925_IRQ_VCHG_TOPOFF,		\
+	 "charger topoff",	IORESOURCE_IRQ,},
+	{MAX8925_IRQ_VCHG_TMR_FAULT, MAX8925_IRQ_VCHG_TMR_FAULT,	\
+	 "charger expire",	IORESOURCE_IRQ,},
 };
 
-static struct mfd_cell touch_devs[] = {
-	{
-		.name		= "max8925-touch",
-		.num_resources	= 1,
-		.resources	= &touch_resources[0],
-		.id		= -1,
-	},
+static struct resource rtc_resources[] __devinitdata = {
+	{MAX8925_IRQ_RTC_ALARM0, MAX8925_IRQ_RTC_ALARM0, "rtc-alarm0",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_RTC_ALARM1, MAX8925_IRQ_RTC_ALARM1, "rtc-alarm1",
+	 IORESOURCE_IRQ,},
 };
 
-static struct resource power_supply_resources[] = {
-	{
-		.name	= "max8925-power",
-		.start	= MAX8925_CHG_IRQ1,
-		.end	= MAX8925_CHG_IRQ1_MASK,
-		.flags	= IORESOURCE_IO,
-	},
+static struct resource onkey_resources[] __devinitdata = {
+	{MAX8925_IRQ_GPM_SW_R, MAX8925_IRQ_GPM_SW_R, "onkey R",
+	 IORESOURCE_IRQ,},
+	{MAX8925_IRQ_GPM_SW_F, MAX8925_IRQ_GPM_SW_F, "onkey F",
+	 IORESOURCE_IRQ,},
 };
 
-static struct mfd_cell power_devs[] = {
-	{
-		.name		= "max8925-power",
-		.num_resources	= 1,
-		.resources	= &power_supply_resources[0],
-		.id		= -1,
-	},
+static struct mfd_cell bk_devs[] = {
+	{"max8925-backlight", -1,},
 };
 
-static struct resource rtc_resources[] = {
-	{
-		.name	= "max8925-rtc",
-		.start	= MAX8925_RTC_IRQ,
-		.end	= MAX8925_RTC_IRQ_MASK,
-		.flags	= IORESOURCE_IO,
-	},
+static struct mfd_cell touch_devs[] = {
+	{"max8925-touch", -1,},
 };
 
-static struct mfd_cell rtc_devs[] = {
-	{
-		.name		= "max8925-rtc",
-		.num_resources	= 1,
-		.resources	= &rtc_resources[0],
-		.id		= -1,
-	},
+static struct mfd_cell power_devs[] = {
+	{"max8925-power", -1,},
 };
 
-static struct resource onkey_resources[] = {
-	{
-		.name	= "max8925-onkey",
-		.start	= MAX8925_IRQ_GPM_SW_R,
-		.end	= MAX8925_IRQ_GPM_SW_R,
-		.flags	= IORESOURCE_IRQ,
-	}, {
-		.name	= "max8925-onkey",
-		.start	= MAX8925_IRQ_GPM_SW_F,
-		.end	= MAX8925_IRQ_GPM_SW_F,
-		.flags	= IORESOURCE_IRQ,
-	},
+static struct mfd_cell rtc_devs[] = {
+	{"max8925-rtc", -1,},
 };
 
 static struct mfd_cell onkey_devs[] = {
-	{
-		.name		= "max8925-onkey",
-		.num_resources	= 2,
-		.resources	= &onkey_resources[0],
-		.id		= -1,
-	},
+	{"max8925-onkey", -1,},
 };
 
+static struct max8925_backlight_pdata bk_pdata;
+static struct max8925_touch_pdata touch_pdata;
+static struct max8925_power_pdata power_pdata;
+
 #define MAX8925_REG_RESOURCE(_start, _end)	\
 {						\
 	.start	= MAX8925_##_start,		\
@@ -588,6 +574,101 @@ tsc_irq:
 	return 0;
 }
 
+static void __devinit device_bk_init(struct max8925_chip *chip,
+				     struct i2c_client *i2c,
+				     struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->backlight == NULL))
+		return;
+
+	memcpy(&bk_pdata, pdata->backlight,
+		sizeof(struct max8925_backlight_pdata));
+	bk_devs[0].platform_data = &bk_pdata;
+	bk_devs[0].pdata_size = sizeof(bk_pdata);
+
+	bk_devs[0].num_resources = 1;
+	bk_devs[0].resources = &bk_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &bk_devs[0], 1,
+			      &bk_resources[0], 0);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add backlight subdev\n");
+}
+
+static void __devinit device_rtc_init(struct max8925_chip *chip,
+				      struct i2c_client *i2c,
+				      struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	rtc_devs[0].num_resources = ARRAY_SIZE(rtc_resources);
+	rtc_devs[0].resources = &rtc_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0], 1,
+			      &rtc_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add rtc subdev\n");
+}
+
+static void __devinit device_touch_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->touch == NULL))
+		return;
+
+	memcpy(&touch_pdata, pdata->touch,
+		sizeof(struct max8925_touch_pdata));
+	touch_devs[0].platform_data = &touch_pdata;
+	touch_devs[0].pdata_size = sizeof(touch_pdata);
+	touch_devs[0].num_resources = ARRAY_SIZE(touch_resources);
+	touch_devs[0].resources = &touch_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
+			      ARRAY_SIZE(touch_devs),
+			      &touch_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add touch subdev\n");
+}
+
+static void __devinit device_power_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	if ((pdata == NULL) || (pdata->power == NULL))
+		return;
+
+	memcpy(&power_pdata, pdata->power,
+		sizeof(struct max8925_power_pdata));
+	power_devs[0].platform_data = &power_pdata;
+	power_devs[0].pdata_size = sizeof(power_pdata);
+	power_devs[0].num_resources = ARRAY_SIZE(power_resources);
+	power_devs[0].resources = &power_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
+				ARRAY_SIZE(power_devs),
+				&power_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add power supply subdev\n");
+}
+
+static void __devinit device_onkey_init(struct max8925_chip *chip,
+					struct i2c_client *i2c,
+					struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	onkey_devs[0].num_resources = ARRAY_SIZE(onkey_resources);
+	onkey_devs[0].resources = &onkey_resources[0];
+	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
+			      ARRAY_SIZE(onkey_devs),
+			      &onkey_resources[0], chip->irq_base);
+	if (ret < 0)
+		dev_err(chip->dev, "Failed to add onkey subdev\n");
+}
+
 int __devinit max8925_device_init(struct max8925_chip *chip,
 				  struct max8925_platform_data *pdata)
 {
@@ -604,28 +685,18 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 		do {
 			ret = max8925_reg_read(chip->adc, MAX8925_TSC_IRQ);
 		} while (ret & MAX8925_NREF_OK);
-		/* enaable ADC scheduler, interval is 1 second */
+		/* enable ADC scheduler, interval is 1 second */
 		max8925_set_bits(chip->adc, MAX8925_ADC_SCHED, 3, 2);
 	}
 
 	/* enable Momentary Power Loss */
 	max8925_set_bits(chip->rtc, MAX8925_MPL_CNTL, 1 << 4, 1 << 4);
 
-	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
-			      ARRAY_SIZE(rtc_devs),
-			      &rtc_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add rtc subdev\n");
-		goto out;
-	}
-
-	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
-			      ARRAY_SIZE(onkey_devs),
-			      &onkey_resources[0], 0);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to add onkey subdev\n");
-		goto out_dev;
-	}
+	device_bk_init(chip, chip->i2c, pdata);
+	device_rtc_init(chip, chip->rtc, pdata);
+	device_touch_init(chip, chip->adc, pdata);
+	device_power_init(chip, chip->adc, pdata);
+	device_onkey_init(chip, chip->i2c, pdata);
 
 	if (pdata && pdata->regulator[0]) {
 		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
@@ -637,42 +708,8 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 		}
 	}
 
-	if (pdata && pdata->backlight) {
-		ret = mfd_add_devices(chip->dev, 0, &backlight_devs[0],
-				      ARRAY_SIZE(backlight_devs),
-				      &backlight_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add backlight subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->power) {
-		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
-					ARRAY_SIZE(power_devs),
-					&power_supply_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add power supply "
-				"subdev\n");
-			goto out_dev;
-		}
-	}
-
-	if (pdata && pdata->touch) {
-		ret = mfd_add_devices(chip->dev, 0, &touch_devs[0],
-				      ARRAY_SIZE(touch_devs),
-				      &touch_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add touch subdev\n");
-			goto out_dev;
-		}
-	}
-
-	return 0;
 out_dev:
-	mfd_remove_devices(chip->dev);
-out:
-	return ret;
+	return 0;
 }
 
 void __devexit max8925_device_exit(struct max8925_chip *chip)
-- 
1.5.6.5

