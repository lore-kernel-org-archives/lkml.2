Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab0JEMCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:02:09 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:46679 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab0JEMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:02:05 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <bgat@billgatliff.com>
Subject: [PATCHv2 6/7] pwm: move existing pwm driver to drivers/pwm
Date: Tue, 5 Oct 2010 17:30:01 +0530
Message-ID: <1286280002-1636-7-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
References: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now only ab8500 and twl6030 are moved.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Kconfig       |    9 --
 drivers/mfd/Makefile      |    1 -
 drivers/mfd/twl6030-pwm.c |  196 ---------------------------------------------
 drivers/misc/Kconfig      |    9 --
 drivers/misc/Makefile     |    1 -
 drivers/misc/ab8500-pwm.c |  157 ------------------------------------
 drivers/pwm/Kconfig       |   18 ++++
 drivers/pwm/Makefile      |    3 +
 drivers/pwm/pwm-ab8500.c  |  157 ++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-twl6040.c |  196 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 374 insertions(+), 373 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 delete mode 100644 drivers/misc/ab8500-pwm.c
 create mode 100644 drivers/pwm/pwm-ab8500.c
 create mode 100644 drivers/pwm/pwm-twl6040.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 256fabd..ab1d376 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -186,15 +186,6 @@ config TWL4030_CODEC
 	select MFD_CORE
 	default n
 
-config TWL6030_PWM
-	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
-	depends on TWL4030_CORE
-	select HAVE_PWM
-	default n
-	help
-	  Say yes here if you want support for TWL6030 PWM.
-	  This is used to control charging LED brightness.
-
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d5968cd..1a89dbf 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_MENELAUS)		+= menelaus.o
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
-obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 
 obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
 
diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/mfd/twl6030-pwm.c
deleted file mode 100644
index b78324b..0000000
--- a/drivers/mfd/twl6030-pwm.c
+++ /dev/null
@@ -1,196 +0,0 @@
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
-#include <linux/slab.h>
-#include <linux/pwm.h>
-#include <linux/err.h>
-#include <linux/i2c/twl.h>
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
-int twl6030_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
-{
-	u8 duty_cycle;
-	int ret = 0;
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
-
-int twl6030_pwm_enable(struct pwm_device *pwm)
-{
-	u8 val;
-	int ret = 0;
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
-
-int twl6030_pwm_disable(struct pwm_device *pwm)
-{
-	u8 val;
-	int ret = 0;
-
-	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-
-	val &= ~PWM_CTRL2_MODE_MASK;
-	val |= PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		pr_err("%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-	}
-	return ret;
-}
-
-static int __devinit twl6030_pwm_probe(struct platform_device *pdev)
-{
-	struct pwm_device *pwm;
-	struct pwm_ops *pops;
-	int ret;
-	u8 val;
-
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
-	if (pops == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		kfree(pwm);
-		return -ENOMEM;
-	}
-
-	pops->pwm_config = twl6030_pwm_config;
-	pops->pwm_enable = twl6030_pwm_enable;
-	pops->pwm_disable = twl6030_pwm_disable;
-	pops->name = &pdev->name;
-	pwm->dev = &pdev->dev;
-	pwm->pwm_id = pdev->id;
-	pwm->pops = pops;
-	ret = pwm_device_register(pwm);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to register pwm device\n");
-		kfree(pwm);
-		kfree(pops);
-		return ret;
-	}
-	platform_set_drvdata(pdev, pwm);
-	/* Configure PWM */
-	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
-							PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to configure PWM, Error %d\n", ret);
-		return ret;
-	}
-	dev_dbg(&pdev->dev, "pwm probe successful\n");
-	return ret;
-}
-
-static int __devexit twl6030_pwm_remove(struct platform_device *pdev)
-{
-	struct pwm_device *pwm = platform_get_drvdata(pdev);
-
-	pwm_device_unregister(pwm);
-	kfree(pwm->pops);
-	kfree(pwm);
-	dev_dbg(&pdev->dev, "pwm driver removed\n");
-	return 0;
-}
-
-static struct platform_driver twl6030_pwm_driver = {
-	.driver = {
-		.name = "twl6030_pwm",
-		.owner = THIS_MODULE,
-	},
-	.probe = twl6030_pwm_probe,
-	.remove = __devexit_p(twl6030_pwm_remove),
-};
-
-static int __init twl6030_pwm_init(void)
-{
-	return platform_driver_register(&twl6030_pwm_driver);
-}
-
-static void __exit twl6030_pwm_deinit(void)
-{
-	platform_driver_unregister(&twl6030_pwm_driver);
-}
-
-subsys_initcall(twl6030_pwm_init);
-module_exit(twl6030_pwm_deinit);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index ff8ea55..2c38d4e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -62,15 +62,6 @@ config ATMEL_PWM
 	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
-config AB8500_PWM
-	bool "AB8500 PWM support"
-	depends on AB8500_CORE
-	select HAVE_PWM
-	help
-	  This driver exports functions to enable/disble/config/free Pulse
-	  Width Modulation in the Analog Baseband Chip AB8500.
-	  It is used by led and backlight driver to control the intensity.
-
 config ATMEL_TCLIB
 	bool "Atmel AT32/AT91 Timer/Counter Library"
 	depends on (AVR32 || ARCH_AT91)
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5da82965..21b4761 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,5 +35,4 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
-obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
deleted file mode 100644
index d2b23b6..0000000
--- a/drivers/misc/ab8500-pwm.c
+++ /dev/null
@@ -1,157 +0,0 @@
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
-#include <linux/mfd/ab8500.h>
-#include <linux/mfd/abx500.h>
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
-static LIST_HEAD(pwm_list);
-
-int ab8500_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
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
-
-int ab8500_pwm_enable(struct pwm_device *pwm)
-{
-	int ret;
-
-	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
-				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (pwm->pwm_id-1), 1 << (pwm->pwm_id-1));
-	if (ret < 0)
-		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
-							pwm->label, ret);
-	return ret;
-}
-
-int ab8500_pwm_disable(struct pwm_device *pwm)
-{
-	int ret;
-
-	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
-				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (pwm->pwm_id-1), DISABLE_PWM);
-	if (ret < 0)
-		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
-							pwm->label, ret);
-	return ret;
-}
-
-static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
-{
-	int ret = 0;
-	struct pwm_ops *pops;
-	struct pwm_device *pwm_dev;
-	/*
-	 * Nothing to be done in probe, this is required to get the
-	 * device which is required for ab8500 read and write
-	 */
-	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
-	if (pops == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-	pwm_dev = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
-	if (pwm_dev == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		kfree(pops);
-		return -ENOMEM;
-	}
-	pops->pwm_config = ab8500_pwm_config;
-	pops->pwm_enable = ab8500_pwm_enable;
-	pops->pwm_disable = ab8500_pwm_disable;
-	pops->name = "ab8500";
-	pwm_dev->dev = &pdev->dev;
-	pwm_dev->pwm_id = pdev->id;
-	pwm_dev->pops = pops;
-	ret = pwm_device_register(pwm_dev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to register pwm device\n");
-		kfree(pwm_dev);
-		kfree(pops);
-		return ret;
-	}
-	platform_set_drvdata(pdev, pwm_dev);
-	dev_dbg(&pdev->dev, "pwm probe successful\n");
-	return ret;
-}
-
-static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
-{
-	struct pwm_device *pwm_dev = platform_get_drvdata(pdev);
-
-	pwm_device_unregister(pwm_dev);
-	dev_dbg(&pdev->dev, "pwm driver removed\n");
-	kfree(pwm_dev->pops);
-	kfree(pwm_dev);
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
-MODULE_ALIAS("AB8500 PWM driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 5483b7f..e4ef199 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -16,4 +16,22 @@ menuconfig PWM_DEVICES
 
 if PWM_DEVICES
 
+config AB8500_PWM
+	bool "AB8500 PWM support"
+	depends on AB8500_CORE
+	select HAVE_PWM
+	help
+	  This driver exports functions to enable/disble/config/free Pulse
+	  Width Modulation in the Analog Baseband Chip AB8500.
+	  It is used by led and backlight driver to control the intensity.
+
+config TWL6030_PWM
+	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
+	depends on TWL4030_CORE
+	select HAVE_PWM
+	default n
+	help
+	  Say yes here if you want support for TWL6030 PWM.
+	  This is used to control charging LED brightness.
+
 endif # PWM_DEVICES
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 552f969..f35afb4 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1 +1,4 @@
 obj-$(CONFIG_PWM_DEVICES)	+= pwm-core.o
+
+obj-$(CONFIG_AB8500_PWM)	+= pwm-ab8500.o
+obj-$(CONFIG_TWL6030_PWM)	+= pwm-twl6030.o
diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
new file mode 100644
index 0000000..d2b23b6
--- /dev/null
+++ b/drivers/pwm/pwm-ab8500.c
@@ -0,0 +1,157 @@
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
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
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
+static LIST_HEAD(pwm_list);
+
+int ab8500_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
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
+	reg = AB8500_PWM_OUT_CTRL1_REG + ((pwm->pwm_id - 1) * 2);
+
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			reg, (u8)lower_val);
+	if (ret < 0)
+		return ret;
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			(reg + 1), (u8)higher_val);
+
+	return ret;
+}
+
+int ab8500_pwm_enable(struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), 1 << (pwm->pwm_id-1));
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+
+int ab8500_pwm_disable(struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), DISABLE_PWM);
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+
+static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct pwm_ops *pops;
+	struct pwm_device *pwm_dev;
+	/*
+	 * Nothing to be done in probe, this is required to get the
+	 * device which is required for ab8500 read and write
+	 */
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	pwm_dev = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm_dev == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pops);
+		return -ENOMEM;
+	}
+	pops->pwm_config = ab8500_pwm_config;
+	pops->pwm_enable = ab8500_pwm_enable;
+	pops->pwm_disable = ab8500_pwm_disable;
+	pops->name = "ab8500";
+	pwm_dev->dev = &pdev->dev;
+	pwm_dev->pwm_id = pdev->id;
+	pwm_dev->pops = pops;
+	ret = pwm_device_register(pwm_dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		kfree(pwm_dev);
+		kfree(pops);
+		return ret;
+	}
+	platform_set_drvdata(pdev, pwm_dev);
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	return ret;
+}
+
+static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwm_dev = platform_get_drvdata(pdev);
+
+	pwm_device_unregister(pwm_dev);
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	kfree(pwm_dev->pops);
+	kfree(pwm_dev);
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
+
+static int __init ab8500_pwm_init(void)
+{
+	return platform_driver_register(&ab8500_pwm_driver);
+}
+
+static void __exit ab8500_pwm_exit(void)
+{
+	platform_driver_unregister(&ab8500_pwm_driver);
+}
+
+subsys_initcall(ab8500_pwm_init);
+module_exit(ab8500_pwm_exit);
+MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
+MODULE_ALIAS("AB8500 PWM driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pwm/pwm-twl6040.c b/drivers/pwm/pwm-twl6040.c
new file mode 100644
index 0000000..b78324b
--- /dev/null
+++ b/drivers/pwm/pwm-twl6040.c
@@ -0,0 +1,196 @@
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
+#include <linux/slab.h>
+#include <linux/pwm.h>
+#include <linux/err.h>
+#include <linux/i2c/twl.h>
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
+int twl6030_pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	u8 duty_cycle;
+	int ret = 0;
+
+	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
+		return -EINVAL;
+
+	duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
+
+	if (ret < 0) {
+		pr_err("%s: Failed to configure PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+	return 0;
+}
+
+int twl6030_pwm_enable(struct pwm_device *pwm)
+{
+	u8 val;
+	int ret = 0;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		return ret;
+	}
+
+	/* Change mode to software control */
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_SW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
+		return ret;
+	}
+
+	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	return 0;
+}
+
+int twl6030_pwm_disable(struct pwm_device *pwm)
+{
+	u8 val;
+	int ret = 0;
+
+	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+		return ret;
+	}
+
+	val &= ~PWM_CTRL2_MODE_MASK;
+	val |= PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		pr_err("%s: Failed to disable PWM, Error %d\n",
+			pwm->label, ret);
+	}
+	return ret;
+}
+
+static int __devinit twl6030_pwm_probe(struct platform_device *pdev)
+{
+	struct pwm_device *pwm;
+	struct pwm_ops *pops;
+	int ret;
+	u8 val;
+
+	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	pops = kzalloc(sizeof(struct pwm_ops), GFP_KERNEL);
+	if (pops == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		kfree(pwm);
+		return -ENOMEM;
+	}
+
+	pops->pwm_config = twl6030_pwm_config;
+	pops->pwm_enable = twl6030_pwm_enable;
+	pops->pwm_disable = twl6030_pwm_disable;
+	pops->name = &pdev->name;
+	pwm->dev = &pdev->dev;
+	pwm->pwm_id = pdev->id;
+	pwm->pops = pops;
+	ret = pwm_device_register(pwm);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register pwm device\n");
+		kfree(pwm);
+		kfree(pops);
+		return ret;
+	}
+	platform_set_drvdata(pdev, pwm);
+	/* Configure PWM */
+	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
+							PWM_CTRL2_MODE_HW;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to configure PWM, Error %d\n", ret);
+		return ret;
+	}
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	return ret;
+}
+
+static int __devexit twl6030_pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwm = platform_get_drvdata(pdev);
+
+	pwm_device_unregister(pwm);
+	kfree(pwm->pops);
+	kfree(pwm);
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	return 0;
+}
+
+static struct platform_driver twl6030_pwm_driver = {
+	.driver = {
+		.name = "twl6030_pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = twl6030_pwm_probe,
+	.remove = __devexit_p(twl6030_pwm_remove),
+};
+
+static int __init twl6030_pwm_init(void)
+{
+	return platform_driver_register(&twl6030_pwm_driver);
+}
+
+static void __exit twl6030_pwm_deinit(void)
+{
+	platform_driver_unregister(&twl6030_pwm_driver);
+}
+
+subsys_initcall(twl6030_pwm_init);
+module_exit(twl6030_pwm_deinit);
-- 
1.7.2.dirty

