Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2F2NVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:21:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14129 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2F2NVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:21:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 29 Jun 2012 06:21:03 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] pwm-backlight: add regulator and GPIO support
Date: Fri, 29 Jun 2012 22:22:47 +0900
Message-ID: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for an optional power regulator and enable/disable GPIO.
This scheme is commonly used in embedded systems.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../bindings/video/backlight/pwm-backlight         |  4 +
 drivers/video/backlight/pwm_bl.c                   | 86 ++++++++++++++++++----
 include/linux/pwm_backlight.h                      |  5 ++
 3 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight b/Documentation/devicetree/bindings/video/backlight/pwm-backlight
index 1e4fc72..85cbb7b 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight
@@ -14,6 +14,8 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - power-supply: a reference to a regulator used to control the backlight power
+  - enable-gpios: a reference to a GPIO used to enable/disable the backlight
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -25,4 +27,6 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		power-supply = <&backlight_reg>;
+		enable-gpios = <&gpio 6 0>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 057389d..821e03e 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -20,6 +20,8 @@
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/slab.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/consumer.h>
 
 struct pwm_bl_data {
 	struct pwm_device	*pwm;
@@ -27,6 +29,9 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	bool			enabled;
+	struct regulator	*power_reg;
+	int			enable_gpio;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -35,6 +40,40 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_off(struct pwm_bl_data *pb)
+{
+	if (!pb->enabled)
+		return;
+
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_set_value_cansleep(pb->enable_gpio, 0);
+
+	if (pb->power_reg)
+		regulator_disable(pb->power_reg);
+
+	pwm_config(pb->pwm, 0, pb->period);
+	pwm_disable(pb->pwm);
+
+	pb->enabled = false;
+}
+
+static void pwm_backlight_on(struct pwm_bl_data *pb, int brightness)
+{
+	pwm_config(pb->pwm, brightness, pb->period);
+	pwm_enable(pb->pwm);
+
+	if (pb->enabled)
+		return;
+
+	if (pb->power_reg)
+		regulator_enable(pb->power_reg);
+
+	if (gpio_is_valid(pb->enable_gpio))
+		gpio_set_value_cansleep(pb->enable_gpio, 1);
+
+	pb->enabled = true;
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -51,8 +90,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		brightness = pb->notify(pb->dev, brightness);
 
 	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_off(pb);
 	} else {
 		if (pb->levels) {
 			brightness = pb->levels[brightness];
@@ -61,8 +99,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 		brightness = pb->lth_brightness +
 			(brightness * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, brightness, pb->period);
-		pwm_enable(pb->pwm);
+		pwm_backlight_on(pb, brightness);
 	}
 
 	if (pb->notify_after)
@@ -141,11 +178,14 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	ret = of_get_named_gpio(node, "enable-gpios", 0);
+	if (ret >= 0) {
+		data->enable_gpio = of_get_named_gpio(node, "enable-gpios", 0);
+		data->use_enable_gpio = true;
+	} else if (ret != -ENOENT) {
+		/* GPIO is optional, so ENOENT is not an error here */
+		return ret;
+	}
 
 	return 0;
 }
@@ -176,7 +216,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 	if (!data) {
 		ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
-		if (ret < 0) {
+		if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else if (ret < 0) {
 			dev_err(&pdev->dev, "failed to find platform data\n");
 			return ret;
 		}
@@ -221,8 +263,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev_dbg(&pdev->dev, "got pwm for backlight\n");
-
 	/*
 	 * The DT case will set the pwm_period_ns field to 0 and store the
 	 * period, parsed from the DT, in the PWM device. For the non-DT case,
@@ -231,6 +271,22 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (data->pwm_period_ns > 0)
 		pwm_set_period(pb->pwm, data->pwm_period_ns);
 
+
+	pb->power_reg = devm_regulator_get(&pdev->dev, "power");
+	if (IS_ERR(pb->power_reg))
+		return PTR_ERR(pb->power_reg);
+
+	pb->enable_gpio = -EINVAL;
+	if (data->use_enable_gpio) {
+		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
+				GPIOF_OUT_INIT_HIGH, "backlight_enable");
+		if (ret)
+			dev_warn(&pdev->dev,
+				"error %d requesting control gpio\n", ret);
+		else
+			pb->enable_gpio = data->enable_gpio;
+	}
+
 	pb->period = pwm_get_period(pb->pwm);
 	pb->lth_brightness = data->lth_brightness * (pb->period / max);
 
@@ -265,8 +321,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
 	backlight_device_unregister(bl);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_off(pb);
 	pwm_put(pb->pwm);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
@@ -281,8 +336,7 @@ static int pwm_backlight_suspend(struct device *dev)
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_off(pb);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..5ae2cd0 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -18,6 +18,11 @@ struct platform_pwm_backlight_data {
 	void (*notify_after)(struct device *dev, int brightness);
 	void (*exit)(struct device *dev);
 	int (*check_fb)(struct device *dev, struct fb_info *info);
+	/* optional GPIO that enables/disables the backlight */
+	int enable_gpio;
+	/* 0 (default initialization value) is a valid GPIO number. Make use of
+	 * control gpio explicit to avoid bad surprises. */
+	bool use_enable_gpio;
 };
 
 #endif
-- 
1.7.11.1

