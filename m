Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2KLOlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:41:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45579 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2KLOld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:41:33 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 3/3] leds: leds-pwm: Add device tree bindings
Date: Mon, 12 Nov 2012 15:41:10 +0100
Message-ID: <1352731270-27534-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for device tree booted kernel.
When the kernel is booted with DeviceTree blob we support one led per
leds-pwm device to have cleaner integration with the PWM subsystem.

For usage see:
Documentation/devicetree/bindings/leds/leds-pwm.txt

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/leds/leds-pwm.txt          |  34 ++++++
 drivers/leds/leds-pwm.c                            | 125 +++++++++++++++------
 2 files changed, 127 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-pwm.txt b/Documentation/devicetree/bindings/leds/leds-pwm.txt
new file mode 100644
index 0000000..9fe3040
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-pwm.txt
@@ -0,0 +1,34 @@
+LED connected to PWM
+
+Required properties:
+- compatible : should be "pwm-leds".
+- pwms : PWM property, please refer to: 
+  Documentation/devicetree/bindings/pwm/pwm.txt
+- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
+- label : (optional) The label for this LED.  If omitted, the label is
+  taken from the node name (excluding the unit address).
+- max-brightness : Maximum brightness possible for the LED
+- linux,default-trigger :  (optional) This parameter, if present, is a
+  string defining the trigger assigned to the LED.  Current triggers are:
+    "backlight" - LED will act as a back-light, controlled by the framebuffer
+		  system
+    "default-on" - LED will turn on, but see "default-state" below
+    "heartbeat" - LED "double" flashes at a load average based rate
+    "ide-disk" - LED indicates disk activity
+    "timer" - LED flashes at a fixed, configurable rate
+
+Example:
+
+twl_pwm: pwm {
+	compatible = "ti,twl6030-pwm";
+	#pwm-cells = <2>;
+};
+
+pwmled_keypad {
+	compatible = "pwm-leds";
+	pwms = <&twl_pwm 0 7812500>;
+	pwm-names = "Keypad LED";
+
+	label = "omap4::keypad";
+	max-brightness = <127>;
+};
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index b219ea9..333c942 100644
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
@@ -58,46 +59,98 @@ static inline int sizeof_pwm_leds_priv(int num_leds)
 		      (sizeof(struct led_pwm_data) * num_leds);
 }
 
+static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct led_pwm_priv *priv;
+	struct led_pwm_data *led_dat;
+	int ret;
+
+	/* With DT boot we support one LED per leds-pwm device */
+	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(1),
+			    GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	led_dat = &priv->leds[priv->num_leds];
+	led_dat->cdev.name = of_get_property(node, "label", NULL) ? : node->name;
+	led_dat->pwm = devm_pwm_get(&pdev->dev, NULL);
+	if (IS_ERR(led_dat->pwm)) {
+		dev_err(&pdev->dev, "unable to request PWM for %s\n",
+			led_dat->cdev.name);
+		return NULL;
+	}
+	/* Get the period from PWM core when n*/
+	led_dat->period = pwm_get_period(led_dat->pwm);
+
+	led_dat->cdev.default_trigger = of_get_property(node,
+							"linux,default-trigger",
+							NULL);
+	of_property_read_u32(node, "max-brightness",
+			     &led_dat->cdev.max_brightness);
+
+	led_dat->cdev.brightness_set = led_pwm_set;
+	led_dat->cdev.brightness = LED_OFF;
+	led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
+
+	ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register for %s\n",
+			led_dat->cdev.name);
+		of_node_put(node);
+		return NULL;
+	}
+
+	priv->num_leds = 1;
+
+	return priv;
+}
+
 static int led_pwm_probe(struct platform_device *pdev)
 {
 	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
 	struct led_pwm_priv *priv;
 	int i, ret = 0;
 
-	if (!pdata)
-		return -EBUSY;
-
-	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(pdata->num_leds),
-			    GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	for (i = 0; i < pdata->num_leds; i++) {
-		struct led_pwm *cur_led = &pdata->leds[i];
-		struct led_pwm_data *led_dat = &priv->leds[i];
-
-		led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
-		if (IS_ERR(led_dat->pwm)) {
-			ret = PTR_ERR(led_dat->pwm);
-			dev_err(&pdev->dev, "unable to request PWM for %s\n",
-				cur_led->name);
-			goto err;
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
 		}
-
-		led_dat->cdev.name = cur_led->name;
-		led_dat->cdev.default_trigger = cur_led->default_trigger;
-		led_dat->active_low = cur_led->active_low;
-		led_dat->period = cur_led->pwm_period_ns;
-		led_dat->cdev.brightness_set = led_pwm_set;
-		led_dat->cdev.brightness = LED_OFF;
-		led_dat->cdev.max_brightness = cur_led->max_brightness;
-		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
-
-		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
-		if (ret < 0)
-			goto err;
+		priv->num_leds = pdata->num_leds;
+	} else {
+		priv = led_pwm_create_of(pdev);
+		if (!priv)
+			return -ENODEV;
 	}
-	priv->num_leds = pdata->num_leds;
 
 	platform_set_drvdata(pdev, priv);
 
@@ -123,12 +176,20 @@ static int __devexit led_pwm_remove(struct platform_device *pdev)
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
 	.remove		= __devexit_p(led_pwm_remove),
 	.driver		= {
 		.name	= "leds_pwm",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(of_pwm_leds_match),
 	},
 };
 
-- 
1.8.0

