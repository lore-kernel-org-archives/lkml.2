Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2HPGIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:08:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16980 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2HPGId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:08:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 15 Aug 2012 23:07:53 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 2/3] pwm_backlight: use power sequences
Date: Thu, 16 Aug 2012 15:08:56 +0900
Message-ID: <1345097337-24170-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
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
 .../bindings/video/backlight/pwm-backlight.txt     |  62 ++++++-
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 192 +++++++++++++++------
 include/linux/pwm_backlight.h                      |  16 +-
 4 files changed, 216 insertions(+), 55 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..51e814d 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -2,7 +2,6 @@ pwm-backlight bindings
 
 Required properties:
   - compatible: "pwm-backlight"
-  - pwms: OF device-tree PWM specification (see PWM binding[0])
   - brightness-levels: Array of distinct brightness levels. Typically these
       are in the range from 0 to 255, but any range starting at 0 will do.
       The actual brightness level (PWM duty cycle) will be interpolated
@@ -10,19 +9,72 @@ Required properties:
       last value in the array represents a 100% duty cycle (brightest).
   - default-brightness-level: the default brightness level (index into the
       array defined by the "brightness-levels" property)
+  - pwms: OF device-tree PWM specification (see PWM binding[0]). Exactly one PWM
+      must be specified
 
 Optional properties:
-  - pwm-names: a list of names for the PWM devices specified in the
-               "pwms" property (see PWM binding[0])
+  - *-supply: regulators used within a power sequence
+  - *-gpio: GPIOs used within a power sequence
+  - pwm-names: name for the PWM device specified in the "pwms" property (see PWM
+      binding[0]). Necessary if power sequences are used
+  - power-on-sequence: Power sequence (see Power sequences[1]) used to bring the
+      backlight on. This sequence must reference the PWM specified in the pwms
+      property by its name. It can also reference other resources supported by
+      the power sequences mechanism
+  - power-off-sequence: Power sequence (see Power sequences[1]) used to bring
+      the backlight off. This sequence must reference the PWM specified in the
+      pwms property by its name. It can also reference other resources supported
+      by the power sequences mechanism
 
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
+		enable-gpio = <&gpio 28 0>;
+
+		power-on-sequence {
+			step0 {
+				regulator = "power";
+				enable;
+			};
+			step1 {
+				delay = <10000>;
+			};
+			step2 {
+				pwm = "backlight";
+				enable;
+			};
+			step3 {
+				gpio = "enable";
+				enable;
+			};
+		};
+
+		power-off-sequence {
+			step0 {
+				gpio = "enable";
+				disable;
+			};
+			step1 {
+				pwm = "backlight";
+				disable;
+			};
+			step2 {
+				delay = <10000>;
+			};
+			step3 {
+				regulator = "power";
+				disable;
+			};
+		};
 	};
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index cf28276..6fb8aa3 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -246,6 +246,7 @@ config BACKLIGHT_CARILLO_RANCH
 config BACKLIGHT_PWM
 	tristate "Generic PWM based Backlight Driver"
 	depends on PWM
+	select POWER_SEQ
 	help
 	  If you have a LCD backlight adjustable by PWM, say Y to enable
 	  this driver.
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 995f016..f456a71 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,13 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	bool			enabled;
+	bool			use_power_seqs;
+	struct list_head	resources;
+	struct power_seq	*power_on_seq;
+	struct power_seq	*power_off_seq;
+
+	/* Legacy callbacks */
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -35,6 +42,49 @@ struct pwm_bl_data {
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
+	/* Legacy framework? */
+	if (!pb->use_power_seqs) {
+		pwm_config(pb->pwm, 0, pb->period);
+		pwm_disable(pb->pwm);
+		return;
+	}
+
+	ret = power_seq_run(pb->power_on_seq);
+	if (ret < 0)
+		dev_err(&bl->dev, "cannot run power on sequence\n");
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
+	/* Legacy framework? */
+	if (!pb->use_power_seqs) {
+		pwm_enable(pb->pwm);
+		return;
+	}
+
+	ret = power_seq_run(pb->power_off_seq);
+	if (ret < 0)
+		dev_err(&bl->dev, "cannot run power off sequence\n");
+
+	pb->enabled = false;
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -51,8 +101,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		brightness = pb->notify(pb->dev, brightness);
 
 	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_off(bl);
 	} else {
 		int duty_cycle;
 
@@ -66,7 +115,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
 		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
+		pwm_backlight_on(bl);
 	}
 
 	if (pb->notify_after)
@@ -98,7 +147,7 @@ static const struct backlight_ops pwm_backlight_ops = {
 static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
-	struct device_node *node = dev->of_node;
+	struct device_node *node = dev->of_node, *pseq_node;
 	struct property *prop;
 	int length;
 	u32 value;
@@ -145,11 +194,18 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	/* convert power sequences to platform data, if any */
+	pseq_node = of_find_node_by_name(node, "power-on-sequence");
+	if (pseq_node)
+		data->power_on_seq = of_parse_power_seq(dev, pseq_node);
+	if (IS_ERR(data->power_on_seq))
+		return PTR_ERR(data->power_on_seq);
+
+	pseq_node = of_find_node_by_name(node, "power-off-sequence");
+	if (pseq_node)
+		data->power_off_seq = of_parse_power_seq(dev, pseq_node);
+	if (IS_ERR(data->power_off_seq))
+		return PTR_ERR(data->power_off_seq);
 
 	return 0;
 }
@@ -172,33 +228,98 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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
+	INIT_LIST_HEAD(&pb->resources);
+
+	/* using new interface or device tree */
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
 
+	/* using legacy interface? */
+	if (!data->power_on_seq && !data->power_off_seq) {
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
+	} else {
+		/* build sequences and allocate resources from platform data */
+		if (data->power_on_seq) {
+			pb->power_on_seq = power_seq_build(&pdev->dev,
+							   &pb->resources,
+							   data->power_on_seq);
+			if (IS_ERR(pb->power_on_seq))
+				return PTR_ERR(pb->power_on_seq);
+		}
+		if (data->power_off_seq) {
+			pb->power_off_seq = power_seq_build(&pdev->dev,
+							    &pb->resources,
+							   data->power_off_seq);
+			if (IS_ERR(pb->power_off_seq))
+				return PTR_ERR(pb->power_off_seq);
+		}
+
+		/* we must have exactly one PWM for this driver */
+		list_for_each_entry(res, &pb->resources, list) {
+			if (res->pdata->type != POWER_SEQ_PWM)
+				continue;
+			if (pb->pwm) {
+				dev_err(&pdev->dev, "more than one PWM used\n");
+				return -EINVAL;
+			}
+			/* keep the pwm at hand */
+			pb->pwm = res->pwm;
+		}
+
+		pb->use_power_seqs = true;
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
@@ -213,28 +334,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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
 
@@ -246,18 +345,17 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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
@@ -269,9 +367,8 @@ static int pwm_backlight_remove(struct platform_device *pdev)
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
@@ -285,8 +382,7 @@ static int pwm_backlight_suspend(struct device *dev)
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_off(bl);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..5bc5e39 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -5,14 +5,26 @@
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
+	struct platform_power_seq *power_on_seq;
+	struct platform_power_seq *power_off_seq;
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
1.7.11.4

