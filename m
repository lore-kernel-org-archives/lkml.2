Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2ILJ4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:56:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1332 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2ILJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:56:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 12 Sep 2012 02:55:41 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v6 2/4] pwm_backlight: use power sequences
Date: Wed, 12 Sep 2012 18:57:45 +0900
Message-ID: <1347443867-18868-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the power sequences specified in the device tree or platform
data to control how the backlight is powered on and off.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../bindings/video/backlight/pwm-backlight.txt     |  65 +++++++-
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 180 +++++++++++++++------
 include/linux/pwm_backlight.h                      |  15 +-
 4 files changed, 208 insertions(+), 53 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 689c7d2..3b7e99b 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -2,7 +2,8 @@ pwm-backlight bindings
 
 Required properties:
   - compatible: "pwm-backlight"
-  - pwms: OF device-tree PWM specification (see PWM binding[0])
+  - pwms: OF device-tree PWM specification (see PWM binding[0]). Exactly one PWM
+      must be specified
   - brightness-levels: Array of distinct brightness levels. Typically these
       are in the range from 0 to 255, but any range starting at 0 will do.
       The actual brightness level (PWM duty cycle) will be interpolated
@@ -16,17 +17,75 @@ Optional properties:
                "pwms" property (see PWM binding[0])
   - low_threshold_brightness: brightness threshold low level. (get linear
 		 scales in brightness in low end of brightness levels)
+  - pwm-names: name for the PWM device specified in the "pwms" property (see PWM
+      binding[0]). Necessary if power sequences are used
+  - power-sequences: Power sequences (see Power sequences[1]) used to bring the
+      backlight on and off. If this property is present, then two power
+      sequences named "power-on" and "power-off" must be defined to control how
+      the backlight is to be powered on and off. These sequences must reference
+      the PWM specified in the pwms property by its name, and can also reference
+      other resources supported by the power sequences mechanism
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
+[1]: Documentation/devicetree/bindings/power_seq/power_seq.txt
 
 Example:
 
 	backlight {
 		compatible = "pwm-backlight";
-		pwms = <&pwm 0 5000000>;
-
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+
+		/* resources used by the sequences */
+		pwms = <&pwm 2 5000000>;
+		pwm-names = "backlight";
+		power-supply = <&backlight_reg>;
+
+		power-sequences {
+			power-on {
+				step0 {
+					type = "regulator";
+					id = "power";
+					enable;
+				};
+				step1 {
+					type = "delay";
+					delay = <10000>;
+				};
+				step2 {
+					type = "pwm";
+					id = "backlight";
+					enable;
+				};
+				step3 {
+					type = "gpio";
+					gpio = <&gpio 28 0>;
+					value = <1>;
+				};
+			};
+
+			power-off {
+				step0 {
+					type = "gpio";
+					gpio = <&gpio 28 0>;
+					value = <0>;
+				};
+				step1 {
+					type = "pwm";
+					id = "backlight";
+					disable;
+				};
+				step2 {
+					type = "delay";
+					delay = <10000>;
+				};
+				step3 {
+					type = "regulator";
+					id = "power";
+					disable;
+				};
+			};
+		};
 	};
 
 Example for brightness_threshold_level:
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 950a131..ca86125 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -239,6 +239,7 @@ config BACKLIGHT_CARILLO_RANCH
 config BACKLIGHT_PWM
 	tristate "Generic PWM based Backlight Driver"
 	depends on PWM
+	select POWER_SEQ
 	help
 	  If you have a LCD backlight adjustable by PWM, say Y to enable
 	  this driver.
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 4965408..37a23c5 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,12 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	bool			enabled;
+	struct power_seq_set	*power_seqs;
+	struct power_seq	*power_on_seq;
+	struct power_seq	*power_off_seq;
+
+	/* Legacy callbacks */
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -35,6 +41,52 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_on(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	int ret;
+
+	if (pb->enabled)
+		return;
+
+	if (pb->power_seqs) {
+		ret = power_seq_run(pb->power_on_seq);
+		if (ret < 0) {
+			dev_err(&bl->dev, "cannot run power on sequence\n");
+			return;
+		}
+	} else {
+		/* legacy framework */
+		pwm_config(pb->pwm, 0, pb->period);
+		pwm_disable(pb->pwm);
+	}
+
+	pb->enabled = true;
+}
+
+static void pwm_backlight_off(struct backlight_device *bl)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	int ret;
+
+	if (!pb->enabled)
+		return;
+
+	if (pb->power_seqs) {
+		ret = power_seq_run(pb->power_off_seq);
+		if (ret < 0) {
+			dev_err(&bl->dev, "cannot run power off sequence\n");
+			return;
+		}
+	} else {
+		/* legacy framework */
+		pwm_enable(pb->pwm);
+		return;
+	}
+
+	pb->enabled = false;
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -51,8 +103,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		brightness = pb->notify(pb->dev, brightness);
 
 	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_off(bl);
 	} else {
 		int duty_cycle;
 
@@ -66,7 +117,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
 		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
+		pwm_backlight_on(bl);
 	}
 
 	if (pb->notify_after)
@@ -150,12 +201,6 @@ static int pwm_backlight_parse_dt(struct device *dev,
 			data->lth_brightness = value;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
-
 	return 0;
 }
 
@@ -177,33 +222,97 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 {
 	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
 	struct platform_pwm_backlight_data defdata;
+	struct power_seq_resource *res;
 	struct backlight_properties props;
 	struct backlight_device *bl;
 	struct pwm_bl_data *pb;
 	unsigned int max;
 	int ret;
 
+	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
+	if (!pb) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	/* using device tree? */
 	if (!data) {
+		/* build platform data from device tree */
 		ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
-		if (ret < 0) {
+		if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else if (ret < 0) {
 			dev_err(&pdev->dev, "failed to find platform data\n");
 			return ret;
 		}
-
 		data = &defdata;
 	}
 
+	/* using power sequences? */
+	pb->power_seqs = devm_power_seq_set_build(&pdev->dev, data->power_seqs);
+	if (pb->power_seqs) {
+		struct power_seq_set *seqs = pb->power_seqs;
+
+		if (IS_ERR(seqs))
+			return PTR_ERR(seqs);
+
+		pb->power_on_seq = power_seq_lookup(seqs, "power-on");
+		if (!pb->power_on_seq) {
+			dev_err(&pdev->dev, "missing power-on sequence\n");
+			return -EINVAL;
+		}
+		pb->power_off_seq = power_seq_lookup(seqs, "power-off");
+		if (!pb->power_off_seq) {
+			dev_err(&pdev->dev, "missing power-off sequence\n");
+			return -EINVAL;
+		}
+
+		/* we must have exactly one PWM for this driver */
+		power_seq_for_each_resource(res, seqs) {
+			if (res->type != POWER_SEQ_PWM)
+				continue;
+			if (pb->pwm) {
+				dev_err(&pdev->dev, "more than one PWM used\n");
+				return -EINVAL;
+			}
+			/* keep the pwm at hand */
+			pb->pwm = res->pwm.pwm;
+		}
+	}
+	/* using legacy interface? */
+	else {
+		pb->pwm = devm_pwm_get(&pdev->dev, NULL);
+		if (IS_ERR(pb->pwm)) {
+			dev_err(&pdev->dev,
+				"unable to request PWM, trying legacy API\n");
+
+			pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
+			if (IS_ERR(pb->pwm)) {
+				dev_err(&pdev->dev,
+					"unable to request legacy PWM\n");
+				return PTR_ERR(pb->pwm);
+			}
+		}
+
+		/*
+		* The DT case will set the pwm_period_ns field to 0 and store
+		* the period, parsed from the DT, in the PWM device. For the
+		* non-DT case, set the period from platform data.
+		*/
+		if (data->pwm_period_ns > 0)
+			pwm_set_period(pb->pwm, data->pwm_period_ns);
+	}
+
 	if (data->init) {
 		ret = data->init(&pdev->dev);
 		if (ret < 0)
-			return ret;
+			goto err;
 	}
 
-	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
-	if (!pb) {
-		dev_err(&pdev->dev, "no memory for state\n");
-		ret = -ENOMEM;
-		goto err_alloc;
+	/* from here we should have a PWM */
+	if (!pb->pwm) {
+		dev_err(&pdev->dev, "no PWM defined!\n");
+		return -EINVAL;
 	}
 
 	if (data->levels) {
@@ -218,28 +327,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->exit = data->exit;
 	pb->dev = &pdev->dev;
 
-	pb->pwm = pwm_get(&pdev->dev, NULL);
-	if (IS_ERR(pb->pwm)) {
-		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
-
-		pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
-		if (IS_ERR(pb->pwm)) {
-			dev_err(&pdev->dev, "unable to request legacy PWM\n");
-			ret = PTR_ERR(pb->pwm);
-			goto err_alloc;
-		}
-	}
-
-	dev_dbg(&pdev->dev, "got pwm for backlight\n");
-
-	/*
-	 * The DT case will set the pwm_period_ns field to 0 and store the
-	 * period, parsed from the DT, in the PWM device. For the non-DT case,
-	 * set the period from platform data.
-	 */
-	if (data->pwm_period_ns > 0)
-		pwm_set_period(pb->pwm, data->pwm_period_ns);
-
 	pb->period = pwm_get_period(pb->pwm);
 	pb->lth_brightness = data->lth_brightness * (pb->period / max);
 
@@ -251,18 +338,17 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
-		goto err_bl;
+		goto err;
 	}
 
 	bl->props.brightness = data->dft_brightness;
 	backlight_update_status(bl);
 
 	platform_set_drvdata(pdev, bl);
+
 	return 0;
 
-err_bl:
-	pwm_put(pb->pwm);
-err_alloc:
+err:
 	if (data->exit)
 		data->exit(&pdev->dev);
 	return ret;
@@ -274,9 +360,8 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
 	backlight_device_unregister(bl);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
-	pwm_put(pb->pwm);
+	pwm_backlight_off(bl);
+
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
@@ -290,8 +375,7 @@ static int pwm_backlight_suspend(struct device *dev)
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_off(bl);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..70d22f2 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -5,14 +5,25 @@
 #define __LINUX_PWM_BACKLIGHT_H
 
 #include <linux/backlight.h>
+#include <linux/power_seq.h>
 
 struct platform_pwm_backlight_data {
-	int pwm_id;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
-	unsigned int pwm_period_ns;
 	unsigned int *levels;
+	/*
+	 * New interface using power sequences
+	 */
+	struct platform_power_seq_set *power_seqs;
+	/*
+	 * Legacy interface - use power sequences instead!
+	 *
+	 * pwm_id and pwm_period_ns need only be specified
+	 * if get_pwm(dev, NULL) would return NULL.
+	 */
+	int pwm_id;
+	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*notify_after)(struct device *dev, int brightness);
-- 
1.7.12

