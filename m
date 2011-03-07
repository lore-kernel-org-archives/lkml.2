Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1CGP4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:56:04 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33395 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab1CGPzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:19 -0500
X-ASG-Debug-ID: 1299512687-082d75160001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x led
Subject: [PATCH] mfd: adopt mfd_data in 88pm860x led
Date: Mon,  7 Mar 2011 23:43:10 +0800
X-ASG-Orig-Subj: [PATCH] mfd: adopt mfd_data in 88pm860x led
Message-Id: <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512687
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy 88pm860x platform data into different mfd_data structure for
led driver. So move the identification of device node from led
driver to mfd driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/leds/leds-88pm860x.c |   60 +++++++++++------------
 drivers/mfd/88pm860x-core.c  |  109 +++++++++++++++++++-----------------------
 include/linux/mfd/88pm860x.h |    3 +-
 3 files changed, 79 insertions(+), 93 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index e672b44..416def8 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -17,6 +17,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 
 #define LED_PWM_SHIFT		(3)
@@ -118,7 +119,8 @@ static void pm860x_led_work(struct work_struct *work)
 
 	struct pm860x_led *led;
 	struct pm860x_chip *chip;
-	int mask;
+	unsigned char buf[3];
+	int mask, ret;
 
 	led = container_of(work, struct pm860x_led, work);
 	chip = led->chip;
@@ -128,16 +130,27 @@ static void pm860x_led_work(struct work_struct *work)
 			pm860x_set_bits(led->i2c, __led_off(led->port),
 					LED_CURRENT_MASK, led->iset);
 		}
+		pm860x_set_bits(led->i2c, __blink_off(led->port),
+				LED_BLINK_MASK, LED_ON_CONTINUOUS);
 		mask = __blink_ctl_mask(led->port);
 		pm860x_set_bits(led->i2c, PM8606_WLED3B, mask, mask);
-	} else if (led->brightness == 0) {
-		pm860x_set_bits(led->i2c, __led_off(led->port),
-				LED_CURRENT_MASK, 0);
-		mask = __blink_ctl_mask(led->port);
-		pm860x_set_bits(led->i2c, PM8606_WLED3B, mask, 0);
 	}
 	pm860x_set_bits(led->i2c, __led_off(led->port), LED_PWM_MASK,
 			led->brightness);
+
+	if (led->brightness == 0) {
+		pm860x_bulk_read(led->i2c, __led_off(led->port), 3, buf);
+		ret = buf[0] & LED_PWM_MASK;
+		ret |= buf[1] & LED_PWM_MASK;
+		ret |= buf[2] & LED_PWM_MASK;
+		if (ret == 0) {
+			/* unset current since no led is lighting */
+			pm860x_set_bits(led->i2c, __led_off(led->port),
+					LED_CURRENT_MASK, 0);
+			mask = __blink_ctl_mask(led->port);
+			pm860x_set_bits(led->i2c, PM8606_WLED3B, mask, 0);
+		}
+	}
 	led->current_brightness = led->brightness;
 	dev_dbg(chip->dev, "Update LED. (reg:%d, brightness:%d)\n",
 		__led_off(led->port), led->brightness);
@@ -153,31 +166,12 @@ static void pm860x_led_set(struct led_classdev *cdev,
 	schedule_work(&data->work);
 }
 
-static int __check_device(struct pm860x_led_pdata *pdata, char *name)
-{
-	struct pm860x_led_pdata *p = pdata;
-	int ret = -EINVAL;
-
-	while (p && p->id) {
-		if ((p->id != PM8606_ID_LED) || (p->flags < 0))
-			break;
-
-		if (!strncmp(name, pm860x_led_name[p->flags],
-			MFD_NAME_SIZE)) {
-			ret = (int)p->flags;
-			break;
-		}
-		p++;
-	}
-	return ret;
-}
-
 static int pm860x_led_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_platform_data *pm860x_pdata;
 	struct pm860x_led_pdata *pdata;
 	struct pm860x_led *data;
+	struct mfd_cell *cell;
 	struct resource *res;
 	int ret;
 
@@ -187,10 +181,11 @@ static int pm860x_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (pdev->dev.parent->platform_data) {
-		pm860x_pdata = pdev->dev.parent->platform_data;
-		pdata = pm860x_pdata->led;
-	} else {
+	cell = pdev->dev.platform_data;
+	if (cell == NULL)
+		return -ENODEV;
+	pdata = cell->mfd_data;
+	if (pdata == NULL) {
 		dev_err(&pdev->dev, "No platform data!\n");
 		return -EINVAL;
 	}
@@ -198,12 +193,12 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	data = kzalloc(sizeof(struct pm860x_led), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
-	strncpy(data->name, res->name, MFD_NAME_SIZE);
+	strncpy(data->name, res->name, MFD_NAME_SIZE - 1);
 	dev_set_drvdata(&pdev->dev, data);
 	data->chip = chip;
 	data->i2c = (chip->id == CHIP_PM8606) ? chip->client : chip->companion;
 	data->iset = pdata->iset;
-	data->port = __check_device(pdata, data->name);
+	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "check device failed\n");
 		kfree(data);
@@ -221,6 +216,7 @@ static int pm860x_led_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
 		goto out;
 	}
+	pm860x_led_set(&data->cdev, 0);
 	return 0;
 out:
 	kfree(data);
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index a88967a..cec375c 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -26,57 +26,32 @@ static struct resource bk_resources[] __initdata = {
 	{PM8606_BACKLIGHT3, PM8606_BACKLIGHT3, "backlight-2", IORESOURCE_IO,},
 };
 
+static struct resource led_resources[] __initdata = {
+	{PM8606_LED1_RED,   PM8606_LED1_RED,   "led0-red",   IORESOURCE_IO,},
+	{PM8606_LED1_GREEN, PM8606_LED1_GREEN, "led0-green", IORESOURCE_IO,},
+	{PM8606_LED1_BLUE,  PM8606_LED1_BLUE,  "led0-blue",  IORESOURCE_IO,},
+	{PM8606_LED2_RED,   PM8606_LED2_RED,   "led1-red",   IORESOURCE_IO,},
+	{PM8606_LED2_GREEN, PM8606_LED2_GREEN, "led1-green", IORESOURCE_IO,},
+	{PM8606_LED2_BLUE,  PM8606_LED2_BLUE,  "led1-blue",  IORESOURCE_IO,},
+};
+
 static struct mfd_cell bk_devs[] __initdata = {
 	{"88pm860x-backlight", 0,},
 	{"88pm860x-backlight", 1,},
 	{"88pm860x-backlight", 2,},
 };
 
-static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
-
-char pm860x_led_name[][MFD_NAME_SIZE] = {
-	"led0-red",
-	"led0-green",
-	"led0-blue",
-	"led1-red",
-	"led1-green",
-	"led1-blue",
-};
-EXPORT_SYMBOL(pm860x_led_name);
-
-#define PM8606_LED_RESOURCE(_i, _x)			\
-{							\
-	.name	= pm860x_led_name[_i],			\
-	.start	= PM8606_##_x,				\
-	.end	= PM8606_##_x,				\
-	.flags	= IORESOURCE_IO,			\
-}
-
-static struct resource led_resources[] = {
-	PM8606_LED_RESOURCE(PM8606_LED1_RED, RGB1B),
-	PM8606_LED_RESOURCE(PM8606_LED1_GREEN, RGB1C),
-	PM8606_LED_RESOURCE(PM8606_LED1_BLUE, RGB1D),
-	PM8606_LED_RESOURCE(PM8606_LED2_RED, RGB2B),
-	PM8606_LED_RESOURCE(PM8606_LED2_GREEN, RGB2C),
-	PM8606_LED_RESOURCE(PM8606_LED2_BLUE, RGB2D),
+static struct mfd_cell led_devs[] __initdata = {
+	{"88pm860x-led", 0,},
+	{"88pm860x-led", 1,},
+	{"88pm860x-led", 2,},
+	{"88pm860x-led", 3,},
+	{"88pm860x-led", 4,},
+	{"88pm860x-led", 5,},
 };
 
-#define PM8606_LED_DEVS(_i)				\
-{							\
-	.name		= "88pm860x-led",		\
-	.num_resources	= 1,				\
-	.resources	= &led_resources[_i],		\
-	.id		= _i,				\
-}
-
-static struct mfd_cell led_devs[] = {
-	PM8606_LED_DEVS(PM8606_LED1_RED),
-	PM8606_LED_DEVS(PM8606_LED1_GREEN),
-	PM8606_LED_DEVS(PM8606_LED1_BLUE),
-	PM8606_LED_DEVS(PM8606_LED2_RED),
-	PM8606_LED_DEVS(PM8606_LED2_GREEN),
-	PM8606_LED_DEVS(PM8606_LED2_BLUE),
-};
+static struct pm860x_backlight_pdata bk_pdata[ARRAY_SIZE(bk_devs)];
+static struct pm860x_led_pdata led_pdata[ARRAY_SIZE(led_devs)];
 
 static struct resource touch_resources[] = {
 	{
@@ -611,25 +586,41 @@ static void __devinit device_bk_init(struct pm860x_chip *chip,
 	}
 }
 
-static void __devinit device_8606_init(struct pm860x_chip *chip,
-				       struct i2c_client *i2c,
-				       struct pm860x_platform_data *pdata)
+static void __devinit device_led_init(struct pm860x_chip *chip,
+				      struct i2c_client *i2c,
+				      struct pm860x_platform_data *pdata)
 {
 	int ret;
+	int i, j, id;
 
-	if (pdata && pdata->led) {
-		ret = mfd_add_devices(chip->dev, 0, &led_devs[0],
-				      ARRAY_SIZE(led_devs),
-				      &led_resources[0], 0);
-		if (ret < 0) {
-			dev_err(chip->dev, "Failed to add led "
-				"subdev\n");
-			goto out_dev;
+	if ((pdata == NULL) || (pdata->led == NULL))
+		return;
+
+	if (pdata->num_leds > ARRAY_SIZE(led_devs))
+		pdata->num_leds = ARRAY_SIZE(led_devs);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		memcpy(&led_pdata[i], &pdata->led[i],
+			sizeof(struct pm860x_led_pdata));
+		led_devs[i].mfd_data = &led_pdata[i];
+
+		for (j = 0; j < ARRAY_SIZE(led_devs); j++) {
+			id = led_resources[j].start;
+			if (led_pdata[i].flags != id)
+				continue;
+
+			led_devs[i].num_resources = 1;
+			led_devs[i].resources = &led_resources[j],
+			ret = mfd_add_devices(chip->dev, 0,
+					      &led_devs[i], 1,
+					      &led_resources[j], 0);
+			if (ret < 0) {
+				dev_err(chip->dev, "Failed to add "
+					"led subdev\n");
+				return;
+			}
 		}
 	}
-	return;
-out_dev:
-	device_irq_exit(chip);
 }
 
 static void __devinit device_8607_init(struct pm860x_chip *chip,
@@ -748,7 +739,7 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 	switch (chip->id) {
 	case CHIP_PM8606:
 		device_bk_init(chip, chip->client, pdata);
-		device_8606_init(chip, chip->client, pdata);
+		device_led_init(chip, chip->client, pdata);
 		break;
 	case CHIP_PM8607:
 		device_8607_init(chip, chip->client, pdata);
@@ -759,7 +750,7 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 		switch (chip->id) {
 		case CHIP_PM8607:
 			device_bk_init(chip, chip->companion, pdata);
-			device_8606_init(chip, chip->companion, pdata);
+			device_led_init(chip, chip->companion, pdata);
 			break;
 		case CHIP_PM8606:
 			device_8607_init(chip, chip->companion, pdata);
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index f790d37..ff60614 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -356,12 +356,11 @@ struct pm860x_platform_data {
 	int		i2c_port;	/* Controlled by GI2C or PI2C */
 	int		irq_mode;	/* Clear interrupt by read/write(0/1) */
 	int		irq_base;	/* IRQ base number of 88pm860x */
+	int		num_leds;
 	int		num_backlights;
 	struct regulator_init_data *regulator[PM8607_MAX_REGULATOR];
 };
 
-extern char pm860x_led_name[][MFD_NAME_SIZE];
-
 extern int pm860x_reg_read(struct i2c_client *, int);
 extern int pm860x_reg_write(struct i2c_client *, int, unsigned char);
 extern int pm860x_bulk_read(struct i2c_client *, int, int, unsigned char *);
-- 
1.5.6.5

