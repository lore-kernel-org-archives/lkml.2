Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2IJMKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:10:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab2IJMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:10:32 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] pwm: Move TWL6030 PWM driver to PWM framework
Date: Mon, 10 Sep 2012 14:10:20 +0200
Message-Id: <1347279020-15596-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:myHfXQ+C2GnbBEEAlJfTEvOPRHL1w1+09p3dy2p8eZ5
 0KlBmfoNBCJwHzyICVRa5RiLXlDZygmg3QdQ4b02V53thvSZai
 elTB3WQ1ukcgrMqFicoSM8ZuYwMWJjUqjuMh7qyvMTadDtQe83
 4ekhB/Mn61WxXUDH6QLVgb5N+jXinpREmFG5a85R0GPCcLJLzj
 zDs+XdQpHjs+v8kKGHoImI2letRuVpwkLHWFnLaPoeX1dHEDjc
 kqFdLpMRKYPrjlnwOGh7VriXIfF3d8QoSFHP/1xlEZc6tXlm3A
 CZFveAvzAW1Xzp+Cw+wU0lxAhAOOdXAaRmMAyRknkCPMJqRKCL
 GQNtX6H+TbmvQh/NVcngyNtew/zqLkjqgjOolquYhqEiFFiJbx
 2LI5LbDm7vAa9sUMKumT4sYBmpQB5ZdiVaHTBZf78J3V7WS4/y
 4QvQq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit moves the driver to drivers/pwm and converts it to the new
PWM framework. In order for this to work properly, register the PWM as
child of the multi-function TWL6030 device.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- check that chip is a 6030 before adding PWM child

 drivers/mfd/Kconfig       |  10 ---
 drivers/mfd/Makefile      |   1 -
 drivers/mfd/twl-core.c    |   7 ++
 drivers/mfd/twl6030-pwm.c | 165 -----------------------------------------
 drivers/pwm/Kconfig       |   9 +++
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-twl6030.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 201 insertions(+), 176 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 create mode 100644 drivers/pwm/pwm-twl6030.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d1facef..2f45891 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -298,16 +298,6 @@ config MFD_TWL4030_AUDIO
 	select MFD_CORE
 	default n
 
-config TWL6030_PWM
-	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
-	depends on TWL4030_CORE
-	select HAVE_PWM
-	depends on !PWM
-	default n
-	help
-	  Say yes here if you want support for TWL6030 PWM.
-	  This is used to control charging LED brightness.
-
 config TWL6040_CORE
 	bool "Support for TWL6040 audio codec"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..53063a8 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -63,7 +63,6 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
-obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 5fbb2a6..05b052a 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -638,6 +638,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 			return PTR_ERR(child);
 	}
 
+	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
+		child = add_child(TWL6030_MODULE_ID1, "twl6030-pwm", NULL, 0,
+				  false, 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (IS_ENABLED(CONFIG_TWL4030_USB) && pdata->usb &&
 	    twl_class_is_4030()) {
 
diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/mfd/twl6030-pwm.c
deleted file mode 100644
index e8fee14..0000000
--- a/drivers/mfd/twl6030-pwm.c
+++ /dev/null
@@ -1,165 +0,0 @@
-/*
- * twl6030_pwm.c
- * Driver for PHOENIX (TWL6030) Pulse Width Modulator
- *
- * Copyright (C) 2010 Texas Instruments
- * Author: Hemanth V <hemanthv@ti.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/i2c/twl.h>
-#include <linux/slab.h>
-
-#define LED_PWM_CTRL1	0xF4
-#define LED_PWM_CTRL2	0xF5
-
-/* Max value for CTRL1 register */
-#define PWM_CTRL1_MAX	255
-
-/* Pull down disable */
-#define PWM_CTRL2_DIS_PD	(1 << 6)
-
-/* Current control 2.5 milli Amps */
-#define PWM_CTRL2_CURR_02	(2 << 4)
-
-/* LED supply source */
-#define PWM_CTRL2_SRC_VAC	(1 << 2)
-
-/* LED modes */
-#define PWM_CTRL2_MODE_HW	(0 << 0)
-#define PWM_CTRL2_MODE_SW	(1 << 0)
-#define PWM_CTRL2_MODE_DIS	(2 << 0)
-
-#define PWM_CTRL2_MODE_MASK	0x3
-
-struct pwm_device {
-	const char *label;
-	unsigned int pwm_id;
-};
-
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
-{
-	u8 duty_cycle;
-	int ret;
-
-	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
-		return -EINVAL;
-
-	duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
-
-	if (ret < 0) {
-		pr_err("%s: Failed to configure PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(pwm_config);
-
-int pwm_enable(struct pwm_device *pwm)
-{
-	u8 val;
-	int ret;
-
-	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
-		return ret;
-	}
-
-	/* Change mode to software control */
-	val &= ~PWM_CTRL2_MODE_MASK;
-	val |= PWM_CTRL2_MODE_SW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
-		return ret;
-	}
-
-	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	return 0;
-}
-EXPORT_SYMBOL(pwm_enable);
-
-void pwm_disable(struct pwm_device *pwm)
-{
-	u8 val;
-	int ret;
-
-	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-		return;
-	}
-
-	val &= ~PWM_CTRL2_MODE_MASK;
-	val |= PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-		return;
-	}
-	return;
-}
-EXPORT_SYMBOL(pwm_disable);
-
-struct pwm_device *pwm_request(int pwm_id, const char *label)
-{
-	u8 val;
-	int ret;
-	struct pwm_device *pwm;
-
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm == NULL) {
-		pr_err("%s: failed to allocate memory\n", label);
-		return NULL;
-	}
-
-	pwm->label = label;
-	pwm->pwm_id = pwm_id;
-
-	/* Configure PWM */
-	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
-		PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-
-	if (ret < 0) {
-		pr_err("%s: Failed to configure PWM, Error %d\n",
-			 pwm->label, ret);
-
-		kfree(pwm);
-		return NULL;
-	}
-
-	return pwm;
-}
-EXPORT_SYMBOL(pwm_request);
-
-void pwm_free(struct pwm_device *pwm)
-{
-	pwm_disable(pwm);
-	kfree(pwm);
-}
-EXPORT_SYMBOL(pwm_free);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index e678005..ed81720 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -142,6 +142,15 @@ config  PWM_TIEHRPWM
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-tiehrpwm.
 
+config PWM_TWL6030
+	tristate "TWL6030 PWM support"
+	depends on TWL4030_CORE
+	help
+	  Generic PWM framework driver for TWL6030.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-twl6030.
+
 config PWM_VT8500
 	tristate "vt8500 pwm support"
 	depends on ARCH_VT8500
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 29cf57e..acfe482 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -11,4 +11,5 @@ obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
+obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
 obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
diff --git a/drivers/pwm/pwm-twl6030.c b/drivers/pwm/pwm-twl6030.c
new file mode 100644
index 0000000..8e63878
--- /dev/null
+++ b/drivers/pwm/pwm-twl6030.c
@@ -0,0 +1,184 @@
+/*
+ * twl6030_pwm.c
+ * Driver for PHOENIX (TWL6030) Pulse Width Modulator
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/i2c/twl.h>
+#include <linux/slab.h>
+
+#define LED_PWM_CTRL1	0xF4
+#define LED_PWM_CTRL2	0xF5
+
+/* Max value for CTRL1 register */
+#define PWM_CTRL1_MAX	255
+
+/* Pull down disable */
+#define PWM_CTRL2_DIS_PD	(1 << 6)
+
+/* Current control 2.5 milli Amps */
+#define PWM_CTRL2_CURR_02	(2 << 4)
+
+/* LED supply source */
+#define PWM_CTRL2_SRC_VAC	(1 << 2)
+
+/* LED modes */
+#define PWM_CTRL2_MODE_HW	(0 << 0)
+#define PWM_CTRL2_MODE_SW	(1 << 0)
+#define PWM_CTRL2_MODE_DIS	(2 << 0)
+
+#define PWM_CTRL2_MODE_MASK	0x3
+
+struct twl6030_pwm_chip {
+	struct pwm_chip chip;
+};
+
+static int twl6030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	/* Configure PWM */
+	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
+	      PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to configure PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int twl6030_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	u8 duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
+	int ret;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
+	if (ret < 0) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+
+	/* Change mode to software control */
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_SW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+
+	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	return 0;
+}
+
+static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	u8 val;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+		return;
+	}
+
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+	}
+}
+
+static const struct pwm_ops twl6030_pwm_ops = {
+	.request = twl6030_pwm_request,
+	.config = twl6030_pwm_config,
+	.enable = twl6030_pwm_enable,
+	.disable = twl6030_pwm_disable,
+};
+
+static int twl6030_pwm_probe(struct platform_device *pdev)
+{
+	struct twl6030_pwm_chip *twl6030;
+	int ret;
+
+	twl6030 = devm_kzalloc(&pdev->dev, sizeof(*twl6030), GFP_KERNEL);
+	if (!twl6030)
+		return -ENOMEM;
+
+	twl6030->chip.dev = &pdev->dev;
+	twl6030->chip.ops = &twl6030_pwm_ops;
+	twl6030->chip.base = -1;
+	twl6030->chip.npwm = 1;
+
+	ret = pwmchip_add(&twl6030->chip);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, twl6030);
+
+	return 0;
+}
+
+static int twl6030_pwm_remove(struct platform_device *pdev)
+{
+	struct twl6030_pwm_chip *twl6030 = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&twl6030->chip);
+}
+
+static struct platform_driver twl6030_pwm_driver = {
+	.driver = {
+		.name = "twl6030-pwm",
+	},
+	.probe = twl6030_pwm_probe,
+	.remove = __devexit_p(twl6030_pwm_remove),
+};
+module_platform_driver(twl6030_pwm_driver);
+
+MODULE_ALIAS("platform:twl6030-pwm");
+MODULE_LICENSE("GPL");
-- 
1.7.12

