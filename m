Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2GIGHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:07:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11298 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2GIGHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:07:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 08 Jul 2012 23:07:22 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCH V2 2/3] pwm_backlight: use power sequences
Date: Mon, 9 Jul 2012 15:08:24 +0900
Message-ID: <1341814105-20690-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the power sequences specified in the device tree or platform
data, if any.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../bindings/video/backlight/pwm-backlight.txt     |  28 ++-
 drivers/video/backlight/power_seq.c                |  44 ++---
 drivers/video/backlight/pwm_bl.c                   | 210 +++++++++++++++------
 include/linux/pwm_backlight.h                      |  37 +++-
 4 files changed, 239 insertions(+), 80 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..86c9253 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -2,7 +2,10 @@ pwm-backlight bindings
 
 Required properties:
   - compatible: "pwm-backlight"
-  - pwms: OF device-tree PWM specification (see PWM binding[0])
+  - pwms: OF device-tree PWM specification (see PWM binding[0]). Exactly one PWM
+      must be specified
+  - pwm-names: a list of names for the PWM devices specified in the
+      "pwms" property (see PWM binding[0])
   - brightness-levels: Array of distinct brightness levels. Typically these
       are in the range from 0 to 255, but any range starting at 0 will do.
       The actual brightness level (PWM duty cycle) will be interpolated
@@ -10,10 +13,18 @@ Required properties:
       last value in the array represents a 100% duty cycle (brightest).
   - default-brightness-level: the default brightness level (index into the
       array defined by the "brightness-levels" property)
+  - power-on-sequence: Power sequence that will bring the backlight on. This
+      sequence must reference the PWM specified in the pwms property by its
+      name. It can also reference extra GPIOs or regulators, and introduce
+      delays between sequence steps
+  - power-off-sequence: Power sequence that will bring the backlight off. This
+      sequence must reference the PWM specified in the pwms property by its
+      name. It can also reference extra GPIOs or regulators, and introduce
+      delays between sequence steps
 
 Optional properties:
-  - pwm-names: a list of names for the PWM devices specified in the
-               "pwms" property (see PWM binding[0])
+  - *-supply: a reference to a regulator used within a power sequence
+  - *-gpios: a reference to a GPIO used within a power sequence.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -22,7 +33,18 @@ Example:
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 5000000>;
+		pwm-names = "backlight";
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		power-supply = <&backlight_reg>;
+		enable-gpios = <&gpio 6 0>;
+		power-on-sequence = "REGULATOR", "power", <1>,
+				    "DELAY", <10>,
+				    "PWM", "backlight", <1>,
+				    "GPIO", "enable", <1>;
+		power-off-sequence = "GPIO", "enable", <0>,
+				     "PWM", "backlight", <0>,
+				     "DELAY", <10>,
+				     "REGULATOR", "power", <0>;
 	};
diff --git a/drivers/video/backlight/power_seq.c b/drivers/video/backlight/power_seq.c
index f54cb7d..f8737db 100644
--- a/drivers/video/backlight/power_seq.c
+++ b/drivers/video/backlight/power_seq.c
@@ -118,9 +118,9 @@ static int of_parse_power_seq_step(struct device *dev, struct property *prop,
 			tmp_buf[sizeof(tmp_buf) - 6] = 0;
 			strcat(tmp_buf, "-gpios");
 			ret = of_get_named_gpio(dev->of_node, tmp_buf, 0);
-			if (ret >= 0)
+			if (ret >= 0) {
 				seq[cpt].value = ret;
-			else {
+			} else {
 				if (ret != -EPROBE_DEFER)
 					dev_err(dev, "cannot get gpio \"%s\"\n",
 						seq[cpt].id);
@@ -218,26 +218,26 @@ power_seq *power_seq_build(struct device *dev, power_seq_resources *ress,
 		seq->type = pseq->type;
 
 		switch (pseq->type) {
-			case POWER_SEQ_REGULATOR:
-			case POWER_SEQ_GPIO:
-			case POWER_SEQ_PWM:
-				if (!(res = power_seq_find_resource(ress, pseq))) {
-					/* create resource node */
-					res = devm_kzalloc(dev, sizeof(*res),
-							   GFP_KERNEL);
-					if (!res)
-						return ERR_PTR(-ENOMEM);
-					memcpy(&res->plat, pseq, sizeof(*pseq));
-
-					list_add(&res->list, ress);
-				}
-				seq->resource = res;
-			case POWER_SEQ_DELAY:
-				seq->parameter = pseq->parameter;
-				break;
-			default:
-				dev_err(dev, "invalid sequence step type!\n");
-				return ERR_PTR(-EINVAL);
+		case POWER_SEQ_REGULATOR:
+		case POWER_SEQ_GPIO:
+		case POWER_SEQ_PWM:
+			if (!(res = power_seq_find_resource(ress, pseq))) {
+				/* create resource node */
+				res = devm_kzalloc(dev, sizeof(*res),
+						   GFP_KERNEL);
+				if (!res)
+					return ERR_PTR(-ENOMEM);
+				memcpy(&res->plat, pseq, sizeof(*pseq));
+
+				list_add(&res->list, ress);
+			}
+			seq->resource = res;
+		case POWER_SEQ_DELAY:
+			seq->parameter = pseq->parameter;
+			break;
+		default:
+			dev_err(dev, "invalid sequence step type!\n");
+			return ERR_PTR(-EINVAL);
 		}
 	}
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1a38953..2936819 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,12 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	bool			enabled;
+	power_seq_resources	resources;
+	power_seq		*power_on_seq;
+	power_seq		*power_off_seq;
+
+	/* Legacy callbacks */
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -35,6 +41,34 @@ struct pwm_bl_data {
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
+	if ((ret = power_seq_run(pb->power_on_seq)) < 0)
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
+	if ((ret = power_seq_run(pb->power_off_seq)) < 0)
+		dev_err(&bl->dev, "cannot run power off sequence\n");
+
+	pb->enabled = false;
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -51,8 +85,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		brightness = pb->notify(pb->dev, brightness);
 
 	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		pwm_backlight_off(bl);
 	} else {
 		int duty_cycle;
 		if (pb->levels) {
@@ -144,12 +177,15 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
-	/*
-	 * TODO: Most users of this driver use a number of GPIOs to control
-	 *       backlight power. Support for specifying these needs to be
-	 *       added.
-	 */
+	data->power_on_seq = of_parse_power_seq(dev, node, "power-on-sequence");
+	if (IS_ERR(data->power_on_seq))
+		return PTR_ERR(data->power_on_seq);
+	data->power_off_seq = of_parse_power_seq(dev, node,
+						 "power-off-sequence");
+	if (IS_ERR(data->power_off_seq))
+		return PTR_ERR(data->power_off_seq);
 
+	data->use_power_sequences = true;
 	return 0;
 }
 
@@ -167,37 +203,134 @@ static int pwm_backlight_parse_dt(struct device *dev,
 }
 #endif
 
+/**
+ * Construct the power sequences corresponding to the legacy platform data.
+ */
+static int pwm_backlight_legacy_probe(struct platform_device *pdev,
+				      struct pwm_bl_data *pb)
+{
+	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct power_seq_resource *res;
+	struct power_seq_step *step;
+
+	pb->pwm = pwm_get(dev, NULL);
+	if (IS_ERR(pb->pwm)) {
+		dev_warn(dev, "unable to request PWM, trying legacy API\n");
+
+		pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
+		if (IS_ERR(pb->pwm)) {
+			dev_err(dev, "unable to request legacy PWM\n");
+			return PTR_ERR(pb->pwm);
+		}
+		pwm_set_period(pb->pwm, data->pwm_period_ns);
+	}
+
+	pb->notify = data->notify;
+	pb->notify_after = data->notify_after;
+	pb->check_fb = data->check_fb;
+	pb->exit = data->exit;
+	pb->dev = dev;
+
+	/* Now build the resources and sequences corresponding to this PWM */
+	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
+	if (!res) return -ENOMEM;
+	res->plat.type = POWER_SEQ_PWM;
+	res->plat.id = "pwm-backlight";
+	res->pwm = pb->pwm;
+	list_add(&res->list, &pb->resources);
+
+	/* allocate both power on and off sequences at the same time */
+	step = devm_kzalloc(dev, sizeof(*step) * 4, GFP_KERNEL);
+	if (!step) return -ENOMEM;
+	step->type = POWER_SEQ_PWM;
+	step->resource = res;
+	memcpy(&step[2], &step[0], sizeof(*step));
+	step[0].parameter = 1;
+	pb->power_on_seq = &step[0];
+	pb->power_off_seq = &step[2];
+
+	return 0;
+}
+
 static int pwm_backlight_probe(struct platform_device *pdev)
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
 
-	if (data->init) {
-		ret = data->init(&pdev->dev);
+	if (!data->use_power_sequences) {
+		/* using legacy interface */
+		ret = pwm_backlight_legacy_probe(pdev, pb);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* build sequences and allocate resources from platform data */
+		if (data->power_on_seq) {
+			pb->power_on_seq = power_seq_build(&pdev->dev, &pb->resources,
+							   data->power_on_seq);
+			if (IS_ERR(pb->power_on_seq))
+				return PTR_ERR(pb->power_on_seq);
+		}
+		if (data->power_off_seq) {
+			pb->power_off_seq = power_seq_build(&pdev->dev, &pb->resources,
+							   data->power_off_seq);
+			if (IS_ERR(pb->power_off_seq))
+				return PTR_ERR(pb->power_off_seq);
+		}
+		ret = power_seq_allocate_resources(&pdev->dev, &pb->resources);
 		if (ret < 0)
 			return ret;
+
+		/* we must have exactly one PWM for this driver */
+		list_for_each_entry(res, &pb->resources, list) {
+			if (res->plat.type != POWER_SEQ_PWM)
+				continue;
+			if (pb->pwm) {
+				dev_err(&pdev->dev, "cannot use more than one PWM\n");
+				return -EINVAL;
+			}
+			/* keep the pwm at hand */
+			pb->pwm = res->pwm;
+		}
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
+	}
+
+	if (data->init) {
+		ret = data->init(&pdev->dev);
+		if (ret < 0)
+			goto err;
 	}
 
 	if (data->levels) {
@@ -207,34 +340,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		max = data->max_brightness;
 	}
 
-	pb->notify = data->notify;
-	pb->notify_after = data->notify_after;
-	pb->check_fb = data->check_fb;
-	pb->exit = data->exit;
-	pb->dev = &pdev->dev;
-
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
 
@@ -246,20 +351,20 @@ static int pwm_backlight_probe(struct platform_device *pdev)
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
+	power_seq_free_resources(&pb->resources);
 	return ret;
 }
 
@@ -269,9 +374,9 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
 	backlight_device_unregister(bl);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
-	pwm_put(pb->pwm);
+	pwm_backlight_off(bl);
+	power_seq_free_resources(&pb->resources);
+
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
@@ -285,8 +390,7 @@ static int pwm_backlight_suspend(struct device *dev)
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_off(bl);
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
 	return 0;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..dda267e 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -5,14 +5,47 @@
 #define __LINUX_PWM_BACKLIGHT_H
 
 #include <linux/backlight.h>
+#include <linux/power_seq.h>
 
+/**
+ * Two ways of passing data to the driver can be used:
+ * 1) If not using device tree and use_power_sequences is not set, the legacy
+ *    interface is used. power_on_sequence and power_off_sequences are ignored,
+ *    and pwm_id and pwm_period_ns can be used to assign a PWM and period to
+ *    the backlight. The callback functions will also be called by the driver
+ *    at appropriate times.
+ * 2) If use_power_sequences is set, the power sequences should either be NULL
+ *    of contain an array of platform_pwm_backlight_seq_step instances
+ *    terminated by a full-zero'd one. The described sequences will then be used
+ *    for powering the backlight on and off, and the callbacks will not be
+ *    called. Instances of resources will be obtained using the get_* functions,
+ *    giving id as a consumer name.
+ *
+ * If the device tree is used, the power sequences properties are parsed and
+ * converted to the corresponding power sequences of this structure, which is
+ * passed to the driver with use_power_sequences set to true. See the
+ * pwm-backlight bindings documentation file for more details.
+ */
 struct platform_pwm_backlight_data {
-	int pwm_id;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
-	unsigned int pwm_period_ns;
 	unsigned int *levels;
+	/* Set this to true otherwise the legacy interface will be used */
+	bool use_power_sequences;
+	/*
+	 * New interface - arrays of steps terminated by a STOP instance, or
+	 * NULL if unused.
+	 */
+	struct platform_power_seq_step *power_on_seq;
+	struct platform_power_seq_step *power_off_seq;
+	/*
+	 * Legacy interface - single PWM and callback methods to control
+	 * the power sequence. pwm_id and pwm_period_ns need only be specified
+	 * if get_pwm(dev, NULL) will return NULL.
+	 */
+	int pwm_id;
+	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*notify_after)(struct device *dev, int brightness);
-- 
1.7.11.1

