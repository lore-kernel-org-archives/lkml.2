Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1LMUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:24:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63798 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1LMUYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:24:30 -0500
Message-ID: <4EE7B41C.5080006@solonet.org.ua>
Date: Tue, 13 Dec 2011 22:22:52 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH v3 resend2] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver
 use gpiolib
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during probe.

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
Acked-by: Stephen Warren <swarren@nvidia.com>
---

There is a comment "no point in having a pull-up if we are always driving"
but code was actually enabled pull-resistor for that case probably because of
function parameter misunderstanding (1 - disables, 0 - enables). So this was
changed to another function which takes alphabetically defined constant as
parameter.
Tested on Mini2440 board which implements most complex case where both
S3C24XX_LEDF_ACTLOW and S3C24XX_LEDF_TRISTATE are set.

Changes v1->v2
        Fix typo's and style problems.
Changes v2->v3
        Remove pull-resistor enabling code for case of S3C24XX_LEDF_TRISTATE
flag is set

See https://lkml.org/lkml/2011/11/22/42 for discussion and ack.

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index a77771d..a1dbf54 100644
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
@@ -88,15 +101,24 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 
 	led->pdata = pdata;
 
-	/* no point in having a pull-up if we are always driving */
+	ret = gpio_request(pdata->gpio, pdata->name);
+	if (ret < 0) {
+		dev_err(&dev->dev, "gpio_request failed\n");
+		goto err_gpio_request;
+	}
 
+	/* apply GPIO settings and initially turn off the LED */
 	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
-		s3c2410_gpio_setpin(pdata->gpio, 0);
-		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
+		ret = gpio_direction_input(pdata->gpio);
 	} else {
-		s3c2410_gpio_pullup(pdata->gpio, 0);
-		s3c2410_gpio_setpin(pdata->gpio, 0);
-		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
+		/* no point in having a pull-up as we are always driving */
+		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
+		ret = gpio_direction_output(pdata->gpio,
+				!!(pdata->flags & S3C24XX_LEDF_ACTLOW));
+	}
+	if (ret < 0) {
+		dev_err(&dev->dev, "can't set gpio direction\n");
+		goto err_gpio_set_direction;
 	}
 
 	/* register our new led device */
@@ -104,11 +126,18 @@ static int s3c24xx_led_probe(struct platform_device *dev)
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
