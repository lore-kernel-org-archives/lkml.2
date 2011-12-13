Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1LMXfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:35:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64114 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:35:38 -0500
Message-ID: <4EE7E0E7.1020802@solonet.org.ua>
Date: Wed, 14 Dec 2011 01:33:59 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v4] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use gpiolib.
 Fix error disabling pull during probe.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during probe.

Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
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
Changes v3->v4
	!! approach for XOR operation with (pd->flags & S3C24XX_LEDF_ACTLOW)
(otherwise code will became buggy when S3C24XX_LEDF_ACTLOW valu will be changed)

See https://lkml.org/lkml/2011/11/22/42 and https://lkml.org/lkml/2011/12/13/338
previous for discussions.

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 29f8b0f..8062664 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -46,23 +46,29 @@ static void s3c24xx_led_set(struct led_classdev *led_cdev,
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
+	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
+		if (value) {
+			/* invert value if S3C24XX_LEDF_ACTLOW is set */
+			gpio_direction_output(pd->gpio,
+				!!value ^ !!(pd->flags & S3C24XX_LEDF_ACTLOW));
+		} else {
+			gpio_direction_input(pd->gpio);
+		}
+	} else {
+		/* invert value if S3C24XX_LEDF_ACTLOW is set */
+		gpio_direction_output(pd->gpio,
+			!!value ^ !!(pd->flags & S3C24XX_LEDF_ACTLOW));
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
@@ -77,7 +83,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 	led = kzalloc(sizeof(struct s3c24xx_gpio_led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&dev->dev, "No memory for device\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_kzalloc;
 	}
 
 	platform_set_drvdata(dev, led);
@@ -89,15 +96,24 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 
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
@@ -105,11 +121,18 @@ static int s3c24xx_led_probe(struct platform_device *dev)
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
