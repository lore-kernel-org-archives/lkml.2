Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2LJKBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:01:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58286 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2LJKBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:01:03 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v3 4/4] leds: leds-pwm: Add device tree bindings
Date: Mon, 10 Dec 2012 11:00:37 +0100
Message-ID: <1355133637-2784-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for device tree booted kernel.

For usage see:
Documentation/devicetree/bindings/leds/leds-pwm.txt

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/leds/leds-pwm.txt          |  46 ++++++++
 drivers/leds/leds-pwm.c                            | 124 +++++++++++++++++----
 2 files changed, 149 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-pwm.txt b/Documentation/devicetree/bindings/leds/leds-pwm.txt
new file mode 100644
index 0000000..abdff60
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-pwm.txt
@@ -0,0 +1,46 @@
+LED connected to PWM
+
+Required properties:
+- compatible : should be "pwm-leds".
+
+Each LED is represented as a sub-node of the pwm-leds device.  Each
+node's name represents the name of the corresponding LED.
+
+LED sub-node properties:
+- pwms : PWM property, please refer to: 
+  Documentation/devicetree/bindings/pwm/pwm.txt
+- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
+- max-brightness : Maximum brightness possible for the LED
+- label :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
+- linux,default-trigger :  (optional)
+  see Documentation/devicetree/bindings/leds/common.txt
+
+Example:
+
+twl_pwm: pwm {
+	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
+	compatible = "ti,twl6030-pwm";
+	#pwm-cells = <2>;
+};
+
+twl_pwmled: pwmled {
+	/* provides one PWM (id 0 for Charing indicator LED) */
+	compatible = "ti,twl6030-pwmled";
+	#pwm-cells = <2>;
+};
+
+pwmleds {
+	compatible = "pwm-leds";
+	kpad {
+		label = "omap4::keypad";
+		pwms = <&twl_pwm 0 7812500>;
+		max-brightness = <127>;
+	};
+
+	charging {
+		label = "omap4:green:chrg";
+		pwms = <&twl_pwmled 0 7812500>;
+		max-brightness = <255>;
+	};
+};
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 02f0c0c..a57ac27 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/of_platform.h>
 #include <linux/fb.h>
 #include <linux/leds.h>
 #include <linux/err.h>
@@ -58,46 +59,115 @@ static inline int sizeof_pwm_leds_priv(int num_leds)
 		      (sizeof(struct led_pwm_data) * num_leds);
 }
 
-static int led_pwm_probe(struct platform_device *pdev)
+static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 {
-	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *child;
 	struct led_pwm_priv *priv;
-	int i, ret = 0;
+	int count, ret;
 
-	if (!pdata)
-		return -EBUSY;
+	/* count LEDs in this device, so we know how much to allocate */
+	count = of_get_child_count(node);
+	if (!count)
+		return NULL;
 
-	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(pdata->num_leds),
+	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(count),
 			    GFP_KERNEL);
 	if (!priv)
-		return -ENOMEM;
+		return NULL;
+
+	for_each_child_of_node(node, child) {
+		struct led_pwm_data *led_dat = &priv->leds[priv->num_leds];
 
-	for (i = 0; i < pdata->num_leds; i++) {
-		struct led_pwm *cur_led = &pdata->leds[i];
-		struct led_pwm_data *led_dat = &priv->leds[i];
+		led_dat->cdev.name = of_get_property(child, "label",
+						     NULL) ? : child->name;
 
-		led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
+		led_dat->pwm = of_pwm_request(child, NULL);
 		if (IS_ERR(led_dat->pwm)) {
-			ret = PTR_ERR(led_dat->pwm);
 			dev_err(&pdev->dev, "unable to request PWM for %s\n",
-				cur_led->name);
+				led_dat->cdev.name);
 			goto err;
 		}
+		/* Get the period from PWM core when n*/
+		led_dat->period = pwm_get_period(led_dat->pwm);
+
+		led_dat->cdev.default_trigger = of_get_property(child,
+						"linux,default-trigger", NULL);
+		of_property_read_u32(child, "max-brightness",
+				     &led_dat->cdev.max_brightness);
 
-		led_dat->cdev.name = cur_led->name;
-		led_dat->cdev.default_trigger = cur_led->default_trigger;
-		led_dat->active_low = cur_led->active_low;
-		led_dat->period = cur_led->pwm_period_ns;
 		led_dat->cdev.brightness_set = led_pwm_set;
 		led_dat->cdev.brightness = LED_OFF;
-		led_dat->cdev.max_brightness = cur_led->max_brightness;
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
 		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to register for %s\n",
+				led_dat->cdev.name);
+			of_node_put(child);
+			pwm_put(led_dat->pwm);
 			goto err;
+		}
+		priv->num_leds++;
+	}
+
+	return priv;
+err:
+	if (priv->num_leds > 0) {
+		for (count = priv->num_leds - 1; count >= 0; count--) {
+			led_classdev_unregister(&priv->leds[count].cdev);
+			pwm_put(priv->leds[count].pwm);
+		}
+	}
+
+	return NULL;
+}
+
+static int led_pwm_probe(struct platform_device *pdev)
+{
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct led_pwm_priv *priv;
+	int i, ret = 0;
+
+	if (pdata && pdata->num_leds) {
+		priv = devm_kzalloc(&pdev->dev,
+				    sizeof_pwm_leds_priv(pdata->num_leds),
+				    GFP_KERNEL);
+		if (!priv)
+			return -ENOMEM;
+
+		for (i = 0; i < pdata->num_leds; i++) {
+			struct led_pwm *cur_led = &pdata->leds[i];
+			struct led_pwm_data *led_dat = &priv->leds[i];
+
+			led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
+			if (IS_ERR(led_dat->pwm)) {
+				ret = PTR_ERR(led_dat->pwm);
+				dev_err(&pdev->dev,
+					"unable to request PWM for %s\n",
+					cur_led->name);
+				goto err;
+			}
+
+			led_dat->cdev.name = cur_led->name;
+			led_dat->cdev.default_trigger = cur_led->default_trigger;
+			led_dat->active_low = cur_led->active_low;
+			led_dat->period = cur_led->pwm_period_ns;
+			led_dat->cdev.brightness_set = led_pwm_set;
+			led_dat->cdev.brightness = LED_OFF;
+			led_dat->cdev.max_brightness = cur_led->max_brightness;
+			led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
+
+			ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
+			if (ret < 0)
+				goto err;
+		}
+		priv->num_leds = pdata->num_leds;
+	} else {
+		priv = led_pwm_create_of(pdev);
+		if (!priv)
+			return -ENODEV;
 	}
-	priv->num_leds = pdata->num_leds;
 
 	platform_set_drvdata(pdev, priv);
 
@@ -114,21 +184,33 @@ err:
 
 static int led_pwm_remove(struct platform_device *pdev)
 {
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
 	struct led_pwm_priv *priv = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < priv->num_leds; i++)
+	for (i = 0; i < priv->num_leds; i++) {
 		led_classdev_unregister(&priv->leds[i].cdev);
+		if (!pdata)
+			pwm_put(priv->leds[i].pwm);
+	}
 
 	return 0;
 }
 
+static const struct of_device_id of_pwm_leds_match[] = {
+	{ .compatible = "pwm-leds", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, of_pwm_leds_match);
+
 static struct platform_driver led_pwm_driver = {
 	.probe		= led_pwm_probe,
 	.remove		= led_pwm_remove,
 	.driver		= {
 		.name	= "leds_pwm",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(of_pwm_leds_match),
 	},
 };
 
-- 
1.8.0

