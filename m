Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1KRVn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:43:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52996 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1KRVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:43:25 -0500
Message-ID: <4EC6D1D5.9060808@solonet.org.ua>
Date: Fri, 18 Nov 2011 23:44:53 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com> <4EC6C785.5010801@solonet.org.ua>
In-Reply-To: <4EC6C785.5010801@solonet.org.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:00 PM, Denis Kuzmenko wrote:
> On 11/18/2011 07:08 PM, Stephen Warren wrote:
>> Denis Kuzmenko wrote at Thursday, November 17, 2011 1:47 PM:
>>> Make s3c24xx LEDS driver use gpiolib.
>>
>> I made some slightly nit-picky
>> comments below.

How's that? (some comments are taken to account and problem with pull-resistor fixed)

---
Make s3c24xx LEDS driver use gpiolib. Disable using pull-resistor when not
using S3C24XX_LEDF_TRISTATE and enble it when in opposite case.

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
---

Patch is against 3.0.9
Tested on Mini2440 board which implements most complex case where both 
S3C24XX_LEDF_ACTLOW and S3C24XX_LEDF_TRISTATE are set

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index a77771d..02bd6a8 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -45,23 +45,35 @@ static void s3c24xx_led_set(struct led_classdev *led_cdev,
 	struct s3c24xx_gpio_led *led = to_gpio(led_cdev);
 	struct s3c24xx_led_platdata *pd = led->pdata;
 
-	/* there will be a short delay between setting the output and
-	 * going from output to input when using tristate. */
-
-	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
-			    (pd->flags & S3C24XX_LEDF_ACTLOW));
-
-	if (pd->flags & S3C24XX_LEDF_TRISTATE)
-		s3c2410_gpio_cfgpin(pd->gpio,
-			value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);
+	/*
+	 * ensure value is 0 or 1 to use it with bitwise XOR (^)
+	 * (only 100% brightness is supported)
+	 */
+	value = value ? 1 : 0;
+
+	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
+		if (value) {
+			/* invert value if S3C24XX_LEDF_ACTLOW is set */
+			value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
+			gpio_direction_output(pd->gpio, value);
+		} else {
+			gpio_direction_input(pd->gpio);
+		}
+	} else {
+		/* invert value if S3C24XX_LEDF_ACTLOW is set */
+		value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
+		gpio_set_value(pd->gpio, value);
+	}
 
 }
 
 static int s3c24xx_led_remove(struct platform_device *dev)
 {
+	struct s3c24xx_led_platdata *pdata = dev->dev.platform_data;
 	struct s3c24xx_gpio_led *led = pdev_to_gpio(dev);
 
 	led_classdev_unregister(&led->cdev);
+	gpio_free(pdata->gpio);
 	kfree(led);
 
 	return 0;
@@ -76,7 +88,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 	led = kzalloc(sizeof(struct s3c24xx_gpio_led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&dev->dev, "No memory for device\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_kzalloc;
 	}
 
 	platform_set_drvdata(dev, led);
@@ -88,15 +101,34 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 
 	led->pdata = pdata;
 
-	/* no point in having a pull-up if we are always driving */
+	ret = gpio_request(pdata->gpio, pdata->name);
+	if (ret < 0) {
+		dev_err(&dev->dev, "gpio_request failed\n");
+		goto err_gpio_request;
+	}
 
 	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
-		s3c2410_gpio_setpin(pdata->gpio, 0);
-		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
+		/*
+		 * pull is needed here to protect pin from being left
+		 * floating
+		 */
+		ret = s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_UP);
+		if (ret)
+			s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_DOWN);
+		/* initially turn off led */
+		ret = gpio_direction_input(pdata->gpio);
 	} else {
-		s3c2410_gpio_pullup(pdata->gpio, 0);
-		s3c2410_gpio_setpin(pdata->gpio, 0);
-		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
+		/* no point in having a pull-up as we are always driving */
+		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
+		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
+								pdata->name);
+		/* initially turn off led */
+		ret = gpio_direction_output(pdata->gpio,
+				!!(pdata->flags & S3C24XX_LEDF_ACTLOW));
+	}
+	if (ret < 0) {
+		dev_err(&dev->dev, "can't set gpio direction\n");
+		goto err_gpio_set_direction;
 	}
 
 	/* register our new led device */
@@ -104,11 +136,18 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 	ret = led_classdev_register(&dev->dev, &led->cdev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "led_classdev_register failed\n");
-		kfree(led);
-		return ret;
+		goto err_led_classdev_register;
 	}
 
 	return 0;
+
+err_led_classdev_register:
+err_gpio_set_direction:
+		gpio_free(pdata->gpio);
+err_gpio_request:
+		kfree(led);
+err_kzalloc:
+		return ret;
 }
 
 static struct platform_driver s3c24xx_led_driver = {
