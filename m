Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2IBKbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:31:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2IBKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:31:05 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Date: Sun,  2 Sep 2012 12:30:58 +0200
Message-Id: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:Twn43vCz5fNig+TubWMFrL9QFBY5rgzpYntl7ITri8h
 ny0ws2Q9wbykXc01CF7ZKcguX30kja8sW8DcncvR06bQCMgEJ8
 d/gVT10h0g/2DC9DJMdiDyvJTtGgz4QhXCsQBVvwOqFAbi/DoL
 POf5awN0Iai7jnij3jgNdWvGtqbFjTFnd2q+zXuH4qh4Q3Vpp0
 Fi8L+UQnyMEzn69KV9JWd55RzRftjuecrTosM8nqDRdzr/W8aV
 EcPsC6OheC4lH6TKuRSOscbADSfs2c7oxdNZat2sedAXPxJn/8
 am7ZUpy5RZ4Sxqr/V8LcKoRdvXZst8IrW6wXdhwRdG0UviSYMj
 7AcrT6RnxTi/FowAinWiMemq6d+1UZZPyJRfQ65cDgaKlHxPtQ
 MuB5EfT2W0T8CXYp78zLXg5a8oSeWfSVZIYHRN91r8To0ftqil
 PRy/X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit moves the driver to drivers/pwm and converts it to the new
PWM framework.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note: I'll take this through the PWM tree, but I'd like to have it
acknowledged by a few people who know the hardware and can actually
test whether this still works.

 drivers/misc/Kconfig      |  10 ---
 drivers/misc/Makefile     |   1 -
 drivers/misc/ab8500-pwm.c | 169 ----------------------------------------------
 drivers/pwm/Kconfig       |   9 +++
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-ab8500.c  | 153 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 163 insertions(+), 180 deletions(-)
 delete mode 100644 drivers/misc/ab8500-pwm.c
 create mode 100644 drivers/pwm/pwm-ab8500.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 98a442d..041b656 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -60,16 +60,6 @@ config ATMEL_PWM
 	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
-config AB8500_PWM
-	bool "AB8500 PWM support"
-	depends on AB8500_CORE && ARCH_U8500
-	select HAVE_PWM
-	depends on !PWM
-	help
-	  This driver exports functions to enable/disble/config/free Pulse
-	  Width Modulation in the Analog Baseband Chip AB8500.
-	  It is used by led and backlight driver to control the intensity.
-
 config ATMEL_TCLIB
 	bool "Atmel AT32/AT91 Timer/Counter Library"
 	depends on (AVR32 || ARCH_AT91)
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index b88df7a..2129377 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
-obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
deleted file mode 100644
index d7a9aa1..0000000
--- a/drivers/misc/ab8500-pwm.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Arun R Murthy <arun.murthy@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-#include <linux/err.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/pwm.h>
-#include <linux/mfd/abx500.h>
-#include <linux/mfd/abx500/ab8500.h>
-#include <linux/module.h>
-
-/*
- * PWM Out generators
- * Bank: 0x10
- */
-#define AB8500_PWM_OUT_CTRL1_REG	0x60
-#define AB8500_PWM_OUT_CTRL2_REG	0x61
-#define AB8500_PWM_OUT_CTRL7_REG	0x66
-
-/* backlight driver constants */
-#define ENABLE_PWM			1
-#define DISABLE_PWM			0
-
-struct pwm_device {
-	struct device *dev;
-	struct list_head node;
-	const char *label;
-	unsigned int pwm_id;
-};
-
-static LIST_HEAD(pwm_list);
-
-int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
-{
-	int ret = 0;
-	unsigned int higher_val, lower_val;
-	u8 reg;
-
-	/*
-	 * get the first 8 bits that are be written to
-	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
-	 */
-	lower_val = duty_ns & 0x00FF;
-	/*
-	 * get bits [9:10] that are to be written to
-	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
-	 */
-	higher_val = ((duty_ns & 0x0300) >> 8);
-
-	reg = AB8500_PWM_OUT_CTRL1_REG + ((pwm->pwm_id - 1) * 2);
-
-	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
-			reg, (u8)lower_val);
-	if (ret < 0)
-		return ret;
-	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
-			(reg + 1), (u8)higher_val);
-
-	return ret;
-}
-EXPORT_SYMBOL(pwm_config);
-
-int pwm_enable(struct pwm_device *pwm)
-{
-	int ret;
-
-	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
-				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (pwm->pwm_id-1), ENABLE_PWM);
-	if (ret < 0)
-		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
-							pwm->label, ret);
-	return ret;
-}
-EXPORT_SYMBOL(pwm_enable);
-
-void pwm_disable(struct pwm_device *pwm)
-{
-	int ret;
-
-	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
-				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (pwm->pwm_id-1), DISABLE_PWM);
-	if (ret < 0)
-		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
-							pwm->label, ret);
-	return;
-}
-EXPORT_SYMBOL(pwm_disable);
-
-struct pwm_device *pwm_request(int pwm_id, const char *label)
-{
-	struct pwm_device *pwm;
-
-	list_for_each_entry(pwm, &pwm_list, node) {
-		if (pwm->pwm_id == pwm_id) {
-			pwm->label = label;
-			pwm->pwm_id = pwm_id;
-			return pwm;
-		}
-	}
-
-	return ERR_PTR(-ENOENT);
-}
-EXPORT_SYMBOL(pwm_request);
-
-void pwm_free(struct pwm_device *pwm)
-{
-	pwm_disable(pwm);
-}
-EXPORT_SYMBOL(pwm_free);
-
-static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
-{
-	struct pwm_device *pwm;
-	/*
-	 * Nothing to be done in probe, this is required to get the
-	 * device which is required for ab8500 read and write
-	 */
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-	pwm->dev = &pdev->dev;
-	pwm->pwm_id = pdev->id;
-	list_add_tail(&pwm->node, &pwm_list);
-	platform_set_drvdata(pdev, pwm);
-	dev_dbg(pwm->dev, "pwm probe successful\n");
-	return 0;
-}
-
-static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
-{
-	struct pwm_device *pwm = platform_get_drvdata(pdev);
-	list_del(&pwm->node);
-	dev_dbg(&pdev->dev, "pwm driver removed\n");
-	kfree(pwm);
-	return 0;
-}
-
-static struct platform_driver ab8500_pwm_driver = {
-	.driver = {
-		.name = "ab8500-pwm",
-		.owner = THIS_MODULE,
-	},
-	.probe = ab8500_pwm_probe,
-	.remove = __devexit_p(ab8500_pwm_remove),
-};
-
-static int __init ab8500_pwm_init(void)
-{
-	return platform_driver_register(&ab8500_pwm_driver);
-}
-
-static void __exit ab8500_pwm_exit(void)
-{
-	platform_driver_unregister(&ab8500_pwm_driver);
-}
-
-subsys_initcall(ab8500_pwm_init);
-module_exit(ab8500_pwm_exit);
-MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
-MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
-MODULE_ALIAS("platform:ab8500-pwm");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 007c225..e678005 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -28,6 +28,15 @@ menuconfig PWM
 
 if PWM
 
+config PWM_AB8500
+	tristate "AB8500 PWM support"
+	depends on AB8500_CORE && ARCH_U8500
+	help
+	  Generic PWM framework driver for Analog Baseband AB8500.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-ab8500.
+
 config PWM_BFIN
 	tristate "Blackfin PWM support"
 	depends on BFIN_GPTIMERS
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index c8e521b..29cf57e 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_PWM)		+= core.o
+obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
new file mode 100644
index 0000000..cfb72ca
--- /dev/null
+++ b/drivers/pwm/pwm-ab8500.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pwm.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/module.h>
+
+/*
+ * PWM Out generators
+ * Bank: 0x10
+ */
+#define AB8500_PWM_OUT_CTRL1_REG	0x60
+#define AB8500_PWM_OUT_CTRL2_REG	0x61
+#define AB8500_PWM_OUT_CTRL7_REG	0x66
+
+/* backlight driver constants */
+#define ENABLE_PWM			1
+#define DISABLE_PWM			0
+
+struct ab8500_pwm_chip {
+	struct pwm_chip chip;
+};
+
+static int ab8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			     int duty_ns, int period_ns)
+{
+	int ret = 0;
+	unsigned int higher_val, lower_val;
+	u8 reg;
+
+	/*
+	 * get the first 8 bits that are be written to
+	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
+	 */
+	lower_val = duty_ns & 0x00FF;
+	/*
+	 * get bits [9:10] that are to be written to
+	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
+	 */
+	higher_val = ((duty_ns & 0x0300) >> 8);
+
+	reg = AB8500_PWM_OUT_CTRL1_REG + ((chip->base - 1) * 2);
+
+	ret = abx500_set_register_interruptible(chip->dev, AB8500_MISC,
+			reg, (u8)lower_val);
+	if (ret < 0)
+		return ret;
+	ret = abx500_set_register_interruptible(chip->dev, AB8500_MISC,
+			(reg + 1), (u8)higher_val);
+
+	return ret;
+}
+
+static int ab8500_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(chip->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (chip->base - 1), ENABLE_PWM);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+
+static void ab8500_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(chip->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (chip->base - 1), DISABLE_PWM);
+	if (ret < 0)
+		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return;
+}
+
+static const struct pwm_ops ab8500_pwm_ops = {
+	.config = ab8500_pwm_config,
+	.enable = ab8500_pwm_enable,
+	.disable = ab8500_pwm_disable,
+};
+
+static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
+{
+	struct ab8500_pwm_chip *ab8500;
+	int err;
+
+	/*
+	 * Nothing to be done in probe, this is required to get the
+	 * device which is required for ab8500 read and write
+	 */
+	ab8500 = kzalloc(sizeof(*ab8500), GFP_KERNEL);
+	if (ab8500 == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	ab8500->chip.dev = &pdev->dev;
+	ab8500->chip.ops = &ab8500_pwm_ops;
+	ab8500->chip.base = pdev->id;
+	ab8500->chip.npwm = 1;
+
+	err = pwmchip_add(&ab8500->chip);
+	if (err < 0) {
+		kfree(ab8500);
+		return err;
+	}
+
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	platform_set_drvdata(pdev, ab8500);
+
+	return 0;
+}
+
+static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
+{
+	struct ab8500_pwm_chip *ab8500 = platform_get_drvdata(pdev);
+	int err;
+
+	err = pwmchip_remove(&ab8500->chip);
+	if (err < 0)
+		return err;
+
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	kfree(ab8500);
+
+	return 0;
+}
+
+static struct platform_driver ab8500_pwm_driver = {
+	.driver = {
+		.name = "ab8500-pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = ab8500_pwm_probe,
+	.remove = __devexit_p(ab8500_pwm_remove),
+};
+module_platform_driver(ab8500_pwm_driver);
+
+MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
+MODULE_ALIAS("platform:ab8500-pwm");
+MODULE_LICENSE("GPL v2");
-- 
1.7.12

