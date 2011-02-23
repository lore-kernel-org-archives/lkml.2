Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BWEeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49850 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1BWEeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:05 -0500
Subject: [RFC PATCH 05/15] leds/leds-gpio: merge platform_driver with
	of_platform_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:00 -0700
Message-ID: <20110223043400.20795.32203.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both interfaces can be driven with the same driver, and
of_platform_driver is getting removed.  This patch merges the two
driver registrations.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/leds/leds-gpio.c |  206 +++++++++++++++++++---------------------------
 1 files changed, 83 insertions(+), 123 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 4d9fa38..c4efece 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -14,6 +14,8 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -151,96 +153,34 @@ static void delete_gpio_led(struct gpio_led_data *led)
 	gpio_free(led->gpio);
 }
 
-#ifdef CONFIG_LEDS_GPIO_PLATFORM
-static int __devinit gpio_led_probe(struct platform_device *pdev)
-{
-	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
-	struct gpio_led_data *leds_data;
-	int i, ret = 0;
-
-	if (!pdata)
-		return -EBUSY;
-
-	leds_data = kzalloc(sizeof(struct gpio_led_data) * pdata->num_leds,
-				GFP_KERNEL);
-	if (!leds_data)
-		return -ENOMEM;
-
-	for (i = 0; i < pdata->num_leds; i++) {
-		ret = create_gpio_led(&pdata->leds[i], &leds_data[i],
-				      &pdev->dev, pdata->gpio_blink_set);
-		if (ret < 0)
-			goto err;
-	}
-
-	platform_set_drvdata(pdev, leds_data);
-
-	return 0;
-
-err:
-	for (i = i - 1; i >= 0; i--)
-		delete_gpio_led(&leds_data[i]);
-
-	kfree(leds_data);
-
-	return ret;
-}
+struct gpio_leds_priv {
+	int num_leds;
+	struct gpio_led_data leds[];
+};
 
-static int __devexit gpio_led_remove(struct platform_device *pdev)
+static inline int sizeof_gpio_leds_priv(int num_leds)
 {
-	int i;
-	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
-	struct gpio_led_data *leds_data;
-
-	leds_data = platform_get_drvdata(pdev);
-
-	for (i = 0; i < pdata->num_leds; i++)
-		delete_gpio_led(&leds_data[i]);
-
-	kfree(leds_data);
-
-	return 0;
+	return sizeof(struct gpio_leds_priv) +
+		(sizeof(struct gpio_led_data) * num_leds);
 }
 
-static struct platform_driver gpio_led_driver = {
-	.probe		= gpio_led_probe,
-	.remove		= __devexit_p(gpio_led_remove),
-	.driver		= {
-		.name	= "leds-gpio",
-		.owner	= THIS_MODULE,
-	},
-};
-
-MODULE_ALIAS("platform:leds-gpio");
-#endif /* CONFIG_LEDS_GPIO_PLATFORM */
-
 /* Code to create from OpenFirmware platform devices */
 #ifdef CONFIG_LEDS_GPIO_OF
-#include <linux/of_platform.h>
-#include <linux/of_gpio.h>
-
-struct gpio_led_of_platform_data {
-	int num_leds;
-	struct gpio_led_data led_data[];
-};
-
-static int __devinit of_gpio_leds_probe(struct platform_device *ofdev,
-					const struct of_device_id *match)
+static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 {
 	struct device_node *np = ofdev->dev.of_node, *child;
-	struct gpio_led_of_platform_data *pdata;
+	struct gpio_leds_priv *priv;
 	int count = 0, ret;
 
-	/* count LEDs defined by this device, so we know how much to allocate */
+	/* count LEDs in this device, so we know how much to allocate */
 	for_each_child_of_node(np, child)
 		count++;
 	if (!count)
-		return 0; /* or ENODEV? */
+		return NULL;
 
-	pdata = kzalloc(sizeof(*pdata) + sizeof(struct gpio_led_data) * count,
-			GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
+	priv = kzalloc(sizeof_gpio_leds_priv(count), GFP_KERNEL);
+	if (!priv)
+		return NULL;
 
 	for_each_child_of_node(np, child) {
 		struct gpio_led led = {};
@@ -256,13 +196,13 @@ static int __devinit of_gpio_leds_probe(struct platform_device *ofdev,
 		if (state) {
 			if (!strcmp(state, "keep"))
 				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
-			else if(!strcmp(state, "on"))
+			else if (!strcmp(state, "on"))
 				led.default_state = LEDS_GPIO_DEFSTATE_ON;
 			else
 				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
 		}
 
-		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
+		ret = create_gpio_led(&led, &priv->leds[priv->num_leds++],
 				      &ofdev->dev, NULL);
 		if (ret < 0) {
 			of_node_put(child);
@@ -270,78 +210,98 @@ static int __devinit of_gpio_leds_probe(struct platform_device *ofdev,
 		}
 	}
 
-	dev_set_drvdata(&ofdev->dev, pdata);
-
-	return 0;
+	return priv;
 
 err:
 	for (count = pdata->num_leds - 2; count >= 0; count--)
 		delete_gpio_led(&pdata->led_data[count]);
+	kfree(priv);
+	return NULL;
+}
 
-	kfree(pdata);
+static const struct of_device_id of_gpio_leds_match[] = {
+	{ .compatible = "gpio-leds", },
+	{},
+};
+#else
+static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
+{
+	return NULL;
+}
+#define of_gpio_leds_match NULL
+#endif
 
-	return ret;
+
+static int __devinit gpio_led_probe(struct platform_device *pdev)
+{
+	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_leds_priv *priv;
+	int i, ret = 0;
+
+	if (pdata && pdata->num_leds) {
+		priv = kzalloc(sizeof_gpio_leds_priv(pdata->num_leds),
+				GFP_KERNEL);
+		if (!priv)
+			return -ENOMEM;
+
+		priv->num_leds = pdata->num_leds;
+		for (i = 0; i < priv->num_leds; i++) {
+			ret = create_gpio_led(&pdata->leds[i],
+					      &priv->leds[i],
+					      &pdev->dev, pdata->gpio_blink_set);
+			if (ret < 0) {
+				/* On failure: unwind the led creations */
+				for (i = i - 1; i >= 0; i--)
+					delete_gpio_led(&priv->leds[i]);
+				kfree(priv);
+				return ret;
+			}
+		}
+	} else {
+		priv = gpio_leds_create_of(pdev);
+		if (!priv)
+			return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
 }
 
-static int __devexit of_gpio_leds_remove(struct platform_device *ofdev)
+static int __devexit gpio_led_remove(struct platform_device *pdev)
 {
-	struct gpio_led_of_platform_data *pdata = dev_get_drvdata(&ofdev->dev);
+	struct gpio_leds_priv *priv = dev_get_drvdata(&pdev->dev);
 	int i;
 
-	for (i = 0; i < pdata->num_leds; i++)
-		delete_gpio_led(&pdata->led_data[i]);
-
-	kfree(pdata);
+	for (i = 0; i < priv->num_leds; i++)
+		delete_gpio_led(&priv->leds[i]);
 
-	dev_set_drvdata(&ofdev->dev, NULL);
+	dev_set_drvdata(&pdev->dev, NULL);
+	kfree(priv);
 
 	return 0;
 }
 
-static const struct of_device_id of_gpio_leds_match[] = {
-	{ .compatible = "gpio-leds", },
-	{},
-};
-
-static struct of_platform_driver of_gpio_leds_driver = {
-	.driver = {
-		.name = "of_gpio_leds",
-		.owner = THIS_MODULE,
+static struct platform_driver gpio_led_driver = {
+	.probe		= gpio_led_probe,
+	.remove		= __devexit_p(gpio_led_remove),
+	.driver		= {
+		.name	= "leds-gpio",
+		.owner	= THIS_MODULE,
 		.of_match_table = of_gpio_leds_match,
 	},
-	.probe = of_gpio_leds_probe,
-	.remove = __devexit_p(of_gpio_leds_remove),
 };
-#endif
+
+MODULE_ALIAS("platform:leds-gpio");
 
 static int __init gpio_led_init(void)
 {
-	int ret = 0;
-
-#ifdef CONFIG_LEDS_GPIO_PLATFORM	
-	ret = platform_driver_register(&gpio_led_driver);
-	if (ret)
-		return ret;
-#endif
-#ifdef CONFIG_LEDS_GPIO_OF
-	ret = of_register_platform_driver(&of_gpio_leds_driver);
-#endif
-#ifdef CONFIG_LEDS_GPIO_PLATFORM	
-	if (ret)
-		platform_driver_unregister(&gpio_led_driver);
-#endif
-
-	return ret;
+	return platform_driver_register(&gpio_led_driver);
 }
 
 static void __exit gpio_led_exit(void)
 {
-#ifdef CONFIG_LEDS_GPIO_PLATFORM
 	platform_driver_unregister(&gpio_led_driver);
-#endif
-#ifdef CONFIG_LEDS_GPIO_OF
-	of_unregister_platform_driver(&of_gpio_leds_driver);
-#endif
 }
 
 module_init(gpio_led_init);

