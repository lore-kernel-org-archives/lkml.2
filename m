Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2KGNHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:07:43 -0500
Received: from antcom.de ([188.40.178.216]:50329 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2KGNHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:07:42 -0500
From: Roland Stigge <stigge@antcom.de>
To: cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] leds: leds-gpio: Defer probing in case of deferred gpio probing
Date: Wed,  7 Nov 2012 14:06:49 +0100
Message-Id: <1352293609-22659-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes leds-gpio's probe() return -EPROBE_DEFER if any of the gpios
to register are deferred themselves. This makes a change of
gpio_leds_create_of()'s return value necessary: Instead of returning NULL on
error, we now use ERR_PTR() error coding.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/leds/leds-gpio.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- linux-2.6.orig/drivers/leds/leds-gpio.c
+++ linux-2.6/drivers/leds/leds-gpio.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/err.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
@@ -176,12 +177,16 @@ static struct gpio_leds_priv * __devinit
 	/* count LEDs in this device, so we know how much to allocate */
 	count = of_get_child_count(np);
 	if (!count)
-		return NULL;
+		return ERR_PTR(-ENODEV);
+
+	for_each_child_of_node(np, child)
+		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
+			return ERR_PTR(-EPROBE_DEFER);
 
 	priv = devm_kzalloc(&pdev->dev, sizeof_gpio_leds_priv(count),
 			GFP_KERNEL);
 	if (!priv)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	for_each_child_of_node(np, child) {
 		struct gpio_led led = {};
@@ -216,7 +221,7 @@ static struct gpio_leds_priv * __devinit
 err:
 	for (count = priv->num_leds - 2; count >= 0; count--)
 		delete_gpio_led(&priv->leds[count]);
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static const struct of_device_id of_gpio_leds_match[] = {
@@ -226,7 +231,7 @@ static const struct of_device_id of_gpio
 #else /* CONFIG_OF_GPIO */
 static struct gpio_leds_priv * __devinit gpio_leds_create_of(struct platform_device *pdev)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 #endif /* CONFIG_OF_GPIO */
 
@@ -264,8 +269,8 @@ static int __devinit gpio_led_probe(stru
 		}
 	} else {
 		priv = gpio_leds_create_of(pdev);
-		if (!priv)
-			return -ENODEV;
+		if (IS_ERR(priv))
+			return PTR_ERR(priv);
 	}
 
 	platform_set_drvdata(pdev, priv);
