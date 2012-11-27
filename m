Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab2K0KK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:10:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311Ab2K0KKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:10:21 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH v4 3/3] pwm: Remove pwm-twl6030 driver
Date: Tue, 27 Nov 2012 11:09:59 +0100
Message-ID: <1354010999-31371-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver only supported the Charging indicator LED.
New set of drivers going to provide support for both PWMs and LEDs for twl4030
and twl6030 series of PMICs.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/pwm/Kconfig       |   9 ---
 drivers/pwm/Makefile      |   1 -
 drivers/pwm/pwm-twl6030.c | 184 ----------------------------------------------
 3 files changed, 194 deletions(-)
 delete mode 100644 drivers/pwm/pwm-twl6030.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index aa89354..43cd93a 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -142,15 +142,6 @@ config  PWM_TIEHRPWM
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-tiehrpwm.
 
-config PWM_TWL6030
-	tristate "TWL6030 PWM support"
-	depends on TWL4030_CORE
-	help
-	  Generic PWM framework driver for TWL6030.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called pwm-twl6030.
-
 config PWM_TWL
 	tristate "TWL4030/6030 PWM support"
 	depends on TWL4030_CORE
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 82a92c7..5f26134 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
-obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
 obj-$(CONFIG_PWM_TWL)		+= pwm-twl.o
 obj-$(CONFIG_PWM_TWL_LED)	+= pwm-twl-led.o
 obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
diff --git a/drivers/pwm/pwm-twl6030.c b/drivers/pwm/pwm-twl6030.c
deleted file mode 100644
index 8e63878..0000000
--- a/drivers/pwm/pwm-twl6030.c
+++ /dev/null
@@ -1,184 +0,0 @@
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
-#include <linux/pwm.h>
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
-struct twl6030_pwm_chip {
-	struct pwm_chip chip;
-};
-
-static int twl6030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	int ret;
-	u8 val;
-
-	/* Configure PWM */
-	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
-	      PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(chip->dev, "%s: Failed to configure PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int twl6030_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
-			      int duty_ns, int period_ns)
-{
-	u8 duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
-	int ret;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
-	if (ret < 0) {
-		pr_err("%s: Failed to configure PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	int ret;
-	u8 val;
-
-	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-
-	/* Change mode to software control */
-	val &= ~PWM_CTRL2_MODE_MASK;
-	val |= PWM_CTRL2_MODE_SW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
-			pwm->label, ret);
-		return ret;
-	}
-
-	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	return 0;
-}
-
-static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
-{
-	int ret;
-	u8 val;
-
-	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-		return;
-	}
-
-	val &= ~PWM_CTRL2_MODE_MASK;
-	val |= PWM_CTRL2_MODE_HW;
-
-	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
-	if (ret < 0) {
-		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
-			pwm->label, ret);
-	}
-}
-
-static const struct pwm_ops twl6030_pwm_ops = {
-	.request = twl6030_pwm_request,
-	.config = twl6030_pwm_config,
-	.enable = twl6030_pwm_enable,
-	.disable = twl6030_pwm_disable,
-};
-
-static int twl6030_pwm_probe(struct platform_device *pdev)
-{
-	struct twl6030_pwm_chip *twl6030;
-	int ret;
-
-	twl6030 = devm_kzalloc(&pdev->dev, sizeof(*twl6030), GFP_KERNEL);
-	if (!twl6030)
-		return -ENOMEM;
-
-	twl6030->chip.dev = &pdev->dev;
-	twl6030->chip.ops = &twl6030_pwm_ops;
-	twl6030->chip.base = -1;
-	twl6030->chip.npwm = 1;
-
-	ret = pwmchip_add(&twl6030->chip);
-	if (ret < 0)
-		return ret;
-
-	platform_set_drvdata(pdev, twl6030);
-
-	return 0;
-}
-
-static int twl6030_pwm_remove(struct platform_device *pdev)
-{
-	struct twl6030_pwm_chip *twl6030 = platform_get_drvdata(pdev);
-
-	return pwmchip_remove(&twl6030->chip);
-}
-
-static struct platform_driver twl6030_pwm_driver = {
-	.driver = {
-		.name = "twl6030-pwm",
-	},
-	.probe = twl6030_pwm_probe,
-	.remove = __devexit_p(twl6030_pwm_remove),
-};
-module_platform_driver(twl6030_pwm_driver);
-
-MODULE_ALIAS("platform:twl6030-pwm");
-MODULE_LICENSE("GPL");
-- 
1.8.0

