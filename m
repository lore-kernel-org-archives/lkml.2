Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GIGHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:07:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11901 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2GIGH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:07:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Jul 2012 23:07:19 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCH V2 1/3] power sequences interpreter for device tree
Date: Mon, 9 Jul 2012 15:08:23 +0900
Message-ID: <1341814105-20690-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers (panel backlights especially) need to follow precise
sequences for powering on and off, involving gpios, regulators, PWMs
with a precise powering order and delays to respect between each steps.
These sequences are board-specific, and do not belong to a particular
driver - therefore they have been performed by board-specific hook
functions to far.

With the advent of the device tree, we cannot rely of board-specific
hooks anymore, but still need a way to implement these sequences in a
portable manner. This patch introduces a simple interpreter that can
execute such power sequences encoded either as platform data or within
the device tree.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/Makefile    |   2 +-
 drivers/video/backlight/power_seq.c | 298 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/pwm_bl.c    |   3 +-
 include/linux/power_seq.h           |  96 ++++++++++++
 4 files changed, 397 insertions(+), 2 deletions(-)
 create mode 100644 drivers/video/backlight/power_seq.c
 create mode 100644 include/linux/power_seq.h

diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index a2ac9cf..6bff124 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
-obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
+obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o power_seq.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
diff --git a/drivers/video/backlight/power_seq.c b/drivers/video/backlight/power_seq.c
new file mode 100644
index 0000000..f54cb7d
--- /dev/null
+++ b/drivers/video/backlight/power_seq.c
@@ -0,0 +1,298 @@
+#include <linux/err.h>
+#include <linux/of_gpio.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/power_seq.h>
+#include <linux/delay.h>
+#include <linux/pwm.h>
+#include <linux/regulator/consumer.h>
+
+#define PWM_SEQ_TYPE(type) [POWER_SEQ_ ## type] = #type
+static const char *pwm_seq_types[] = {
+	PWM_SEQ_TYPE(STOP),
+	PWM_SEQ_TYPE(DELAY),
+	PWM_SEQ_TYPE(REGULATOR),
+	PWM_SEQ_TYPE(PWM),
+	PWM_SEQ_TYPE(GPIO),
+};
+#undef PWM_SEQ_TYPE
+
+static bool power_seq_step_run(struct power_seq_step *step)
+{
+	switch (step->type) {
+	case POWER_SEQ_DELAY:
+		msleep(step->parameter);
+		break;
+	case POWER_SEQ_REGULATOR:
+		if (step->parameter)
+			regulator_enable(step->resource->regulator);
+		else
+			regulator_disable(step->resource->regulator);
+		break;
+	case POWER_SEQ_PWM:
+		if (step->parameter)
+			pwm_enable(step->resource->pwm);
+		else
+			pwm_disable(step->resource->pwm);
+		break;
+	case POWER_SEQ_GPIO:
+		gpio_set_value_cansleep(step->resource->gpio, step->parameter);
+		break;
+	/* should never happen since we verify the data when building it */
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int power_seq_run(power_seq *seq)
+{
+	int err;
+
+	if (!seq) return 0;
+
+	while (seq->type != POWER_SEQ_STOP) {
+		if ((err = power_seq_step_run(seq++))) {
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int of_parse_power_seq_step(struct device *dev, struct property *prop,
+				   struct platform_power_seq_step *seq,
+				   int max_steps)
+{
+	void *value = prop->value;
+	void *end = prop->value + prop->length;
+	int slen, smax, cpt = 0, i, ret;
+	char tmp_buf[32];
+
+	while (value < end && cpt < max_steps) {
+		smax = value - end;
+		slen = strnlen(value, end - value);
+
+		/* Unterminated string / not a string? */
+		if (slen >= end - value)
+			goto invalid_seq;
+
+		/* Find a matching sequence step type */
+		for (i = 0; i < POWER_SEQ_MAX; i++)
+			if (!strcmp(value, pwm_seq_types[i]))
+				break;
+
+		if (i >= POWER_SEQ_MAX)
+			goto unknown_step;
+
+		value += slen + 1;
+
+		seq[cpt].type = i;
+		switch (seq[cpt].type) {
+		case POWER_SEQ_DELAY:
+			/* integer parameter */
+			seq[cpt].parameter = be32_to_cpup(value);
+			value += sizeof(__be32);
+			break;
+		case POWER_SEQ_REGULATOR:
+		case POWER_SEQ_PWM:
+		case POWER_SEQ_GPIO:
+			/* consumer string */
+			slen = strnlen(value, end - value);
+			if (slen >= end - value)
+				goto invalid_seq;
+			seq[cpt].id = value;
+			value += slen + 1;
+
+			/* parameter */
+			seq[cpt].parameter = be32_to_cpup(value);
+			be32_to_cpup(value);
+			value += sizeof(__be32);
+
+			/* For GPIO we still need to resolve the phandle */
+			if (seq[cpt].type != POWER_SEQ_GPIO)
+				break;
+
+			strncpy(tmp_buf, seq[cpt].id, sizeof(tmp_buf) - 6);
+			tmp_buf[sizeof(tmp_buf) - 6] = 0;
+			strcat(tmp_buf, "-gpios");
+			ret = of_get_named_gpio(dev->of_node, tmp_buf, 0);
+			if (ret >= 0)
+				seq[cpt].value = ret;
+			else {
+				if (ret != -EPROBE_DEFER)
+					dev_err(dev, "cannot get gpio \"%s\"\n",
+						seq[cpt].id);
+				return ret;
+			}
+		default:
+			break;
+		}
+
+		cpt++;
+	}
+
+	if (cpt >= max_steps)
+		return -EOVERFLOW;
+
+	return 0;
+
+invalid_seq:
+	dev_err(dev, "invalid sequence \"%s\"\n", prop->name);
+		return -EINVAL;
+unknown_step:
+	dev_err(dev, "unknown step type \"%s\" in sequence \"%s\"\n",
+		(char *)value, prop->name);
+	return -EINVAL;
+}
+
+#define PWM_SEQ_MAX_LENGTH 16
+platform_power_seq *of_parse_power_seq(struct device *dev,
+				       struct device_node *node, char *propname)
+{
+	platform_power_seq *seq = NULL;
+	struct property *prop;
+	int length;
+	int ret;
+
+	prop = of_find_property(node, propname, &length);
+	if (prop && length > 0) {
+		seq = devm_kzalloc(dev, sizeof(*seq) * PWM_SEQ_MAX_LENGTH,
+				   GFP_KERNEL);
+		if (!seq)
+			return ERR_PTR(-ENOMEM);
+		/* keep one empty entry for the STOP step */
+		ret = of_parse_power_seq_step(dev, prop, seq,
+					      PWM_SEQ_MAX_LENGTH - 1);
+		if (ret < 0)
+			return ERR_PTR(ret);
+	}
+
+	return seq;
+}
+
+static
+struct power_seq_resource * power_seq_find_resource(power_seq_resources *ress,
+					struct platform_power_seq_step *res)
+{
+	struct power_seq_resource *step;
+
+	list_for_each_entry(step, ress, list) {
+		if (step->plat.type != res->type) continue;
+		switch (res->type) {
+		case POWER_SEQ_DELAY:
+		case POWER_SEQ_GPIO:
+			if (step->plat.value == res->value)
+				return step;
+			break;
+		default:
+			if (!strcmp(step->plat.id, res->id))
+				return step;
+			break;
+		}
+	}
+
+	return NULL;
+}
+
+power_seq *power_seq_build(struct device *dev, power_seq_resources *ress,
+			   platform_power_seq *pseq)
+{
+	struct power_seq_step *seq = NULL, *ret;
+	struct power_seq_resource *res;
+	int cpt;
+
+	/* first pass to count the number of elements */
+	for (cpt = 0; pseq[cpt].type != POWER_SEQ_STOP; cpt++);
+
+	if (!cpt)
+		return seq;
+
+	/* 1 more for the STOP step */
+	ret = seq = devm_kzalloc(dev, sizeof(*seq) * (cpt + 1), GFP_KERNEL);
+	if (!seq)
+		return ERR_PTR(-ENOMEM);
+
+	for (; pseq->type != POWER_SEQ_STOP; pseq++, seq++) {
+		seq->type = pseq->type;
+
+		switch (pseq->type) {
+			case POWER_SEQ_REGULATOR:
+			case POWER_SEQ_GPIO:
+			case POWER_SEQ_PWM:
+				if (!(res = power_seq_find_resource(ress, pseq))) {
+					/* create resource node */
+					res = devm_kzalloc(dev, sizeof(*res),
+							   GFP_KERNEL);
+					if (!res)
+						return ERR_PTR(-ENOMEM);
+					memcpy(&res->plat, pseq, sizeof(*pseq));
+
+					list_add(&res->list, ress);
+				}
+				seq->resource = res;
+			case POWER_SEQ_DELAY:
+				seq->parameter = pseq->parameter;
+				break;
+			default:
+				dev_err(dev, "invalid sequence step type!\n");
+				return ERR_PTR(-EINVAL);
+		}
+	}
+
+	return ret;
+}
+
+int power_seq_allocate_resources(struct device *dev, power_seq_resources *ress)
+{
+	struct power_seq_resource *res;
+	int err;
+
+	list_for_each_entry(res, ress, list) {
+		switch (res->plat.type) {
+		case POWER_SEQ_REGULATOR:
+			res->regulator = devm_regulator_get(dev, res->plat.id);
+			if (IS_ERR(res->regulator)) {
+				dev_err(dev, "cannot get regulator \"%s\"\n",
+					res->plat.id);
+				return PTR_ERR(res->regulator);
+			}
+			dev_dbg(dev, "got regulator %s\n", res->plat.id);
+			break;
+		case POWER_SEQ_PWM:
+			res->pwm = pwm_get(dev, res->plat.id);
+			if (IS_ERR(res->pwm)) {
+				dev_err(dev, "cannot get pwm \"%s\"\n",
+					res->plat.id);
+				return PTR_ERR(res->pwm);
+			}
+			dev_dbg(dev, "got PWM %s\n", res->plat.id);
+			break;
+		case POWER_SEQ_GPIO:
+			err = devm_gpio_request_one(dev, res->plat.value,
+				GPIOF_OUT_INIT_HIGH, "backlight_gpio");
+			if (err) {
+				dev_err(dev, "cannot get gpio %d\n",
+					res->plat.value);
+				return err;
+			}
+			res->gpio = res->plat.value;
+			dev_dbg(dev, "got GPIO %d\n", res->plat.value);
+			break;
+		default:
+			break;
+		};
+	}
+
+	return 0;
+}
+
+void power_seq_free_resources(power_seq_resources *ress) {
+	struct power_seq_resource *res;
+
+	list_for_each_entry(res, ress, list) {
+		if (res->plat.type == POWER_SEQ_PWM)
+			pwm_put(res->pwm);
+	}
+}
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index be48517..1a38953 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -203,8 +203,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (data->levels) {
 		max = data->levels[data->max_brightness];
 		pb->levels = data->levels;
-	} else
+	} else {
 		max = data->max_brightness;
+	}
 
 	pb->notify = data->notify;
 	pb->notify_after = data->notify_after;
diff --git a/include/linux/power_seq.h b/include/linux/power_seq.h
new file mode 100644
index 0000000..7f76270
--- /dev/null
+++ b/include/linux/power_seq.h
@@ -0,0 +1,96 @@
+/*
+ * Simple interpreter for defining power sequences as platform data or device
+ * tree properties. Mainly for use with backlight drivers.
+ */
+
+#ifndef __LINUX_POWER_SEQ_H
+#define __LINUX_POWER_SEQ_H
+
+#include <linux/of.h>
+#include <linux/types.h>
+
+/**
+ * The different kinds of resources that can be controlled during the sequences.
+ */
+typedef enum {
+	POWER_SEQ_STOP = 0,
+	POWER_SEQ_DELAY,
+	POWER_SEQ_REGULATOR,
+	POWER_SEQ_PWM,
+	POWER_SEQ_GPIO,
+	POWER_SEQ_MAX,
+} seq_type;
+
+/**
+ * Describe something to do during the power-up/down sequence.
+ */
+struct platform_power_seq_step {
+	seq_type type;
+	/**
+	 * Identify the resource. Steps of type DELAY use value, others name the
+	 * consumer to use in id.
+	 */
+	union {
+		const char *id;
+		int value;
+	};
+	/**
+	 * A value of 0 disables the resource, while a non-zero enables it.
+	 * For DELAY steps this contains the delay to wait in milliseconds.
+	 */
+	int parameter;
+};
+typedef struct platform_power_seq_step platform_power_seq;
+
+struct power_seq_resource {
+	/* copied from platform data */
+	struct platform_power_seq_step plat;
+	/* resolved resource */
+	union {
+		struct regulator *regulator;
+		struct pwm_device *pwm;
+		int gpio;
+	};
+	/* used to maintain a list of resources used by the driver */
+	struct list_head list;
+};
+typedef struct list_head power_seq_resources;
+
+struct power_seq_step {
+	seq_type type;
+	int parameter;
+	struct power_seq_resource *resource;
+};
+typedef struct power_seq_step power_seq;
+
+/**
+ * Build a platform data sequence from a device tree node. Memory for the
+ * sequence is allocated using devm_kzalloc on dev.
+ */
+platform_power_seq *of_parse_power_seq(struct device *dev,
+				       struct device_node *node,
+				       char *propname);
+/**
+ * Build a runnable power sequence from platform data, and add the resources
+ * it uses into ress. Memory for the sequence is allocated using devm_kzalloc
+ * on dev.
+ */
+power_seq *power_seq_build(struct device *dev, power_seq_resources *ress,
+			   platform_power_seq *pseq);
+/**
+ * Allocate all resources (regulators, PWMs, GPIOs) found by calls to
+ * power_seq_build() for use by dev. Return 0 in case of success, error code
+ * otherwise.
+ */
+int power_seq_allocate_resources(struct device *dev, power_seq_resources *ress);
+/**
+ * Free all the resources previously allocated by power_seq_allocate_resources.
+ */
+void power_seq_free_resources(power_seq_resources *ress);
+/**
+ * Run the given power sequence. Returns 0 on success, error code in case of
+ * failure.
+ */
+int power_seq_run(power_seq *seq);
+
+#endif
-- 
1.7.11.1

