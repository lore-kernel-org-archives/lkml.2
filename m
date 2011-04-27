Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab1D0N6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:58:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1D0N6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bHcmxWdmxxn9piOYSQ86GzKZT529msRjXJzPNhwvBEIZHfbVjZT9YOeNhrznBrmmYl
         x3DPziUrSUXFHfW5xTHfgbEEg7oHTfebv539a28wIGI1kVJfhDByLRQ7eeGPY9pLN/Mb
         ynRBPu+n+AhSQmed+zojWsMsUQjggfZku8L5M=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-kernel@vger.kernel.org,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] leds: drop leds-h1940 driver
Date: Wed, 27 Apr 2011 16:56:37 +0300
Message-Id: <1303912597-32653-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H1940 machine now uses leds-gpio and leds-h1940 has no users anymore. So
drop it.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/leds/Kconfig      |    7 --
 drivers/leds/Makefile     |    1 -
 drivers/leds/leds-h1940.c |  170 ---------------------------------------------
 3 files changed, 0 insertions(+), 178 deletions(-)
 delete mode 100644 drivers/leds/leds-h1940.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9bec869..3040d06 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -115,13 +115,6 @@ config LEDS_ALIX2
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
 
-config LEDS_H1940
-	tristate "LED Support for iPAQ H1940 device"
-	depends on LEDS_CLASS
-	depends on ARCH_H1940
-	help
-	  This option enables support for the LEDs on the h1940.
-
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 39c80fc..0b6ad37 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
-obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
deleted file mode 100644
index 173d104..0000000
--- a/drivers/leds/leds-h1940.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * drivers/leds/leds-h1940.c
- * Copyright (c) Arnaud Patard <arnaud.patard@rtp-net.org>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- *
- * H1940 leds driver
- *
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
-#include <linux/gpio.h>
-
-#include <mach/regs-gpio.h>
-#include <mach/hardware.h>
-#include <mach/h1940-latch.h>
-
-/*
- * Green led.
- */
-static void h1940_greenled_set(struct led_classdev *led_dev,
-			       enum led_brightness value)
-{
-	switch (value) {
-	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
-		break;
-	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
-		break;
-	default:
-	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
-		break;
-	}
-}
-
-static struct led_classdev h1940_greenled = {
-	.name			= "h1940:green",
-	.brightness_set		= h1940_greenled_set,
-	.default_trigger	= "h1940-charger",
-};
-
-/*
- * Red led.
- */
-static void h1940_redled_set(struct led_classdev *led_dev,
-			     enum led_brightness value)
-{
-	switch (value) {
-	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
-		break;
-	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_RED);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
-		break;
-	default:
-	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_RED, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
-		break;
-	}
-}
-
-static struct led_classdev h1940_redled = {
-	.name			= "h1940:red",
-	.brightness_set		= h1940_redled_set,
-	.default_trigger	= "h1940-charger",
-};
-
-/*
- * Blue led.
- * (it can only be blue flashing led)
- */
-static void h1940_blueled_set(struct led_classdev *led_dev,
-			      enum led_brightness value)
-{
-	if (value) {
-		/* flashing Blue */
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
-	} else {
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
-	}
-
-}
-
-static struct led_classdev h1940_blueled = {
-	.name			= "h1940:blue",
-	.brightness_set		= h1940_blueled_set,
-	.default_trigger	= "h1940-bluetooth",
-};
-
-static int __devinit h1940leds_probe(struct platform_device *pdev)
-{
-	int ret;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_greenled);
-	if (ret)
-		goto err_green;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_redled);
-	if (ret)
-		goto err_red;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_blueled);
-	if (ret)
-		goto err_blue;
-
-	return 0;
-
-err_blue:
-	led_classdev_unregister(&h1940_redled);
-err_red:
-	led_classdev_unregister(&h1940_greenled);
-err_green:
-	return ret;
-}
-
-static int h1940leds_remove(struct platform_device *pdev)
-{
-	led_classdev_unregister(&h1940_greenled);
-	led_classdev_unregister(&h1940_redled);
-	led_classdev_unregister(&h1940_blueled);
-	return 0;
-}
-
-
-static struct platform_driver h1940leds_driver = {
-	.driver		= {
-		.name	= "h1940-leds",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= h1940leds_probe,
-	.remove		= h1940leds_remove,
-};
-
-
-static int __init h1940leds_init(void)
-{
-	return platform_driver_register(&h1940leds_driver);
-}
-
-static void __exit h1940leds_exit(void)
-{
-	platform_driver_unregister(&h1940leds_driver);
-}
-
-module_init(h1940leds_init);
-module_exit(h1940leds_exit);
-
-MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
-MODULE_DESCRIPTION("LED driver for the iPAQ H1940");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:h1940-leds");
-- 
1.7.5.rc1

