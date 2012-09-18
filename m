Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2IRIaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:30:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2IRIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:30:00 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] pwm: Move TWL6030 PWM driver to PWM framework
Date: Tue, 18 Sep 2012 10:29:51 +0200
Message-Id: <1347956991-16088-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:rIbpHIZkSPh5dwBOiPntwhezaui+PdbjxD9W8W3iWFJ
 A/xh2P1YT6IOL9dafwMG3ibpwgaOifPdzcxh7NIuAm1QY8xU9M
 QGyLH+MlvYg6oZvSOukexOnJ2xOYY6DDHdecuycxO09urSwvKA
 f2Zjg85zp3NYP/qosZxtujb0DN7EOtWOrhkBLCzRpcWaa0OQM7
 5CBJGGPvIKl3HJ3lylpckaEGJhcNlzKGqrflaLuXdUctOHZ4WU
 tpr7yRaUMd12Db73cXjTnCVQZ5n05V8owObrFmf73eIxRW6Icp
 V0NSsLi6s2oO/5KETOlA7VPRCF3bQR9Fl96UuUpq9ae6kYOYET
 XaOz+YM6lyTKTgPW906KTHvmHitvqRsg5OxJiKIl8TKgXc3Ok+
 sunvolgJC1h1dyiftcsnLyt0LLZsa5x6729CDhf43YPyiWPhvy
 iqFHS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit moves the driver to drivers/pwm and converts it to the new
PWM framework. In order for this to work properly, register the PWM as
child of the multi-function TWL6030 device.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Changes in v2:
- check that chip is a 6030 before adding PWM child

 drivers/mfd/Kconfig                              |  10 --
 drivers/mfd/Makefile                             |   1 -
 drivers/mfd/twl-core.c                           |   7 ++
 drivers/pwm/Kconfig                              |   9 ++
 drivers/pwm/Makefile                             |   1 +
 drivers/{mfd/twl6030-pwm.c => pwm/pwm-twl6030.c} | 119 +++++++++++++----------
 6 files changed, 86 insertions(+), 61 deletions(-)
 rename drivers/{mfd/twl6030-pwm.c => pwm/pwm-twl6030.c} (55%)

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
diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/pwm/pwm-twl6030.c
similarity index 55%
rename from drivers/mfd/twl6030-pwm.c
rename to drivers/pwm/pwm-twl6030.c
index e8fee14..8e63878 100644
--- a/drivers/mfd/twl6030-pwm.c
+++ b/drivers/pwm/pwm-twl6030.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pwm.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
 
@@ -45,40 +46,54 @@
 
 #define PWM_CTRL2_MODE_MASK	0x3
 
-struct pwm_device {
-	const char *label;
-	unsigned int pwm_id;
+struct twl6030_pwm_chip {
+	struct pwm_chip chip;
 };
 
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+static int twl6030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	u8 duty_cycle;
 	int ret;
+	u8 val;
 
-	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
-		return -EINVAL;
+	/* Configure PWM */
+	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
+	      PWM_CTRL2_MODE_HW;
 
-	duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(chip->dev, "%s: Failed to configure PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
 
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
+	return 0;
+}
 
+static int twl6030_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	u8 duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
+	int ret;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
 	if (ret < 0) {
 		pr_err("%s: Failed to configure PWM, Error %d\n",
 			pwm->label, ret);
 		return ret;
 	}
+
 	return 0;
 }
-EXPORT_SYMBOL(pwm_config);
 
-int pwm_enable(struct pwm_device *pwm)
+static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	u8 val;
 	int ret;
+	u8 val;
 
 	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	if (ret < 0) {
-		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
+			pwm->label, ret);
 		return ret;
 	}
 
@@ -88,23 +103,23 @@ int pwm_enable(struct pwm_device *pwm)
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
 	if (ret < 0) {
-		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
+			pwm->label, ret);
 		return ret;
 	}
 
 	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	return 0;
 }
-EXPORT_SYMBOL(pwm_enable);
 
-void pwm_disable(struct pwm_device *pwm)
+static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	u8 val;
 	int ret;
+	u8 val;
 
 	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
 	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
 			pwm->label, ret);
 		return;
 	}
@@ -114,52 +129,56 @@ void pwm_disable(struct pwm_device *pwm)
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
 	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
 			pwm->label, ret);
-		return;
 	}
-	return;
 }
-EXPORT_SYMBOL(pwm_disable);
 
-struct pwm_device *pwm_request(int pwm_id, const char *label)
+static const struct pwm_ops twl6030_pwm_ops = {
+	.request = twl6030_pwm_request,
+	.config = twl6030_pwm_config,
+	.enable = twl6030_pwm_enable,
+	.disable = twl6030_pwm_disable,
+};
+
+static int twl6030_pwm_probe(struct platform_device *pdev)
 {
-	u8 val;
+	struct twl6030_pwm_chip *twl6030;
 	int ret;
-	struct pwm_device *pwm;
-
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm == NULL) {
-		pr_err("%s: failed to allocate memory\n", label);
-		return NULL;
-	}
 
-	pwm->label = label;
-	pwm->pwm_id = pwm_id;
-
-	/* Configure PWM */
-	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
-		PWM_CTRL2_MODE_HW;
+	twl6030 = devm_kzalloc(&pdev->dev, sizeof(*twl6030), GFP_KERNEL);
+	if (!twl6030)
+		return -ENOMEM;
 
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	twl6030->chip.dev = &pdev->dev;
+	twl6030->chip.ops = &twl6030_pwm_ops;
+	twl6030->chip.base = -1;
+	twl6030->chip.npwm = 1;
 
-	if (ret < 0) {
-		pr_err("%s: Failed to configure PWM, Error %d\n",
-			 pwm->label, ret);
+	ret = pwmchip_add(&twl6030->chip);
+	if (ret < 0)
+		return ret;
 
-		kfree(pwm);
-		return NULL;
-	}
+	platform_set_drvdata(pdev, twl6030);
 
-	return pwm;
+	return 0;
 }
-EXPORT_SYMBOL(pwm_request);
 
-void pwm_free(struct pwm_device *pwm)
+static int twl6030_pwm_remove(struct platform_device *pdev)
 {
-	pwm_disable(pwm);
-	kfree(pwm);
+	struct twl6030_pwm_chip *twl6030 = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&twl6030->chip);
 }
-EXPORT_SYMBOL(pwm_free);
 
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
 MODULE_LICENSE("GPL");
-- 
1.7.12

