Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525Ab2CBUGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:06:03 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15324 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2CBUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:05:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 02 Mar 2012 12:05:57 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 6/7] pinctrl: Show selected function and group in pinmux-pins debugfs
Date: Fri, 2 Mar 2012 13:05:49 -0700
Message-ID: <1330718750-15217-7-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until recently, the pinctrl pinmux-pins debugfs file displayed the
selected function for each owned pin. This feature was removed during
restructing in support of recent API rework. This change restoreds this
feature, and also displays the group that the function was selected on,
in case a pin is a member of multiple groups.

Based on work by: Linus Walleij <linus.walleij@linaro.org>

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: New patch
---
 drivers/pinctrl/core.h   |    2 +
 drivers/pinctrl/pinmux.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 1cae372..5b3ff13 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -126,6 +126,7 @@ struct pinctrl_setting {
  * @owner: The name of the entity owning the pin. Typically, this is the name
  *	of the device that called pinctrl_get(). Alternatively, it may be the
  *	name of the GPIO passed to pinctrl_request_gpio().
+ * @mux_setting: The most recent selected mux setting for this pin, if any.
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
@@ -135,6 +136,7 @@ struct pin_desc {
 #ifdef CONFIG_PINMUX
 	unsigned usecount;
 	const char *owner;
+	const struct pinctrl_setting_mux *mux_setting;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 4852ebe..86e4017 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -187,6 +187,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 
 	owner = desc->owner;
 	desc->owner = NULL;
+	desc->mux_setting = NULL;
 	module_put(pctldev->owner);
 
 	return owner;
@@ -378,7 +379,34 @@ void pinmux_free_setting(struct pinctrl_setting const *setting)
 int pinmux_enable_setting(struct pinctrl_setting const *setting)
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	int ret;
+	const unsigned *pins;
+	unsigned num_pins;
+	int i;
+	struct pin_desc *desc;
+
+	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
+				      &pins, &num_pins);
+	if (ret) {
+		/* errors only affect debug data, so just warn */
+		dev_warn(pctldev->dev,
+			 "could not get pins for group selector %d\n",
+			 setting->data.mux.group);
+		num_pins = 0;
+	}
+
+	for (i = 0; i < num_pins; i++) {
+		desc = pin_desc_get(pctldev, pins[i]);
+		if (desc == NULL) {
+			dev_warn(pctldev->dev,
+				 "could not get pin desc for pin %d\n",
+				 pins[i]);
+			continue;
+		}
+		desc->mux_setting = &(setting->data.mux);
+	}
 
 	return ops->enable(pctldev, setting->data.mux.func,
 			   setting->data.mux.group);
@@ -387,7 +415,34 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 void pinmux_disable_setting(struct pinctrl_setting const *setting)
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	int ret;
+	const unsigned *pins;
+	unsigned num_pins;
+	int i;
+	struct pin_desc *desc;
+
+	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
+				      &pins, &num_pins);
+	if (ret) {
+		/* errors only affect debug data, so just warn */
+		dev_warn(pctldev->dev,
+			 "could not get pins for group selector %d\n",
+			 setting->data.mux.group);
+		num_pins = 0;
+	}
+
+	for (i = 0; i < num_pins; i++) {
+		desc = pin_desc_get(pctldev, pins[i]);
+		if (desc == NULL) {
+			dev_warn(pctldev->dev,
+				 "could not get pin desc for pin %d\n",
+				 pins[i]);
+			continue;
+		}
+		desc->mux_setting = NULL;
+	}
 
 	ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
 }
@@ -433,6 +488,8 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 static int pinmux_pins_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
 	unsigned i, pin;
 
 	seq_puts(s, "Pinmux settings per pin\n");
@@ -455,10 +512,19 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 		    !strcmp(desc->owner, pinctrl_dev_get_name(pctldev)))
 			is_hog = true;
 
-		seq_printf(s, "pin %d (%s): %s%s\n", pin,
+		seq_printf(s, "pin %d (%s): %s%s", pin,
 			   desc->name ? desc->name : "unnamed",
 			   desc->owner ? desc->owner : "UNCLAIMED",
 			   is_hog ? " (HOG)" : "");
+
+		if (desc->mux_setting)
+			seq_printf(s, " function %s group %s\n",
+				   pmxops->get_function_name(pctldev,
+					desc->mux_setting->func),
+				   pctlops->get_group_name(pctldev,
+					desc->mux_setting->group));
+		else
+			seq_printf(s, "\n");
 	}
 
 	mutex_unlock(&pinctrl_mutex);
-- 
1.7.0.4

