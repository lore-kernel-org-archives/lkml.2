Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2K1Sfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:35:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40807 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2K1Sfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:35:48 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 3/3] mfd: stmpe: Update DT support in stmpe driver
Date: Thu, 29 Nov 2012 00:05:22 +0530
Message-Id: <d3668fc1bd4c964a0a827ef14892b03180843d5e.1354127005.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
References: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
In-Reply-To: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
References: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

This patch extends existing DT support for stmpe devices. This updates:
- DT support from stmpe SPI and I2C drivers
- missing header files in stmpe.c
- stmpe_of_probe() with pwm, rotator and new bindings.
- Bindings are updated in binding document.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V3->V4:
- Remove need to pass irq type and polarity from DT.
- Remove need to pass id from platform data.

 Documentation/devicetree/bindings/mfd/stmpe.txt |  9 ++++++---
 drivers/mfd/stmpe-i2c.c                         | 15 +++++++++++++++
 drivers/mfd/stmpe-spi.c                         | 15 +++++++++++++++
 drivers/mfd/stmpe.c                             | 22 ++++++++++++++++------
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
index 8f0aeda..d2d88d9 100644
--- a/Documentation/devicetree/bindings/mfd/stmpe.txt
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -1,8 +1,11 @@
-* STMPE Multi-Functional Device
+* ST Microelectronics STMPE Multi-Functional Device
+
+STMPE is an MFD device which may expose following inbuilt devices: gpio, keypad,
+touchscreen, adc, pwm, rotator.
 
 Required properties:
- - compatible                   : "st,stmpe[811|1601|2401|2403]"
- - reg                          : I2C address of the device
+ - compatible                   : "st,stmpe[610|801|811|1601|2401|2403]"
+ - reg                          : I2C/SPI address of the device
 
 Optional properties:
  - interrupts                   : The interrupt outputs from the controller
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index c734dc3..003c49b 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include "stmpe.h"
 
@@ -81,6 +82,19 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, stmpe_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_dt_ids[] = {
+	{ .compatible = "st,stmpe610", .data = &stmpe_i2c_id[0], },
+	{ .compatible = "st,stmpe801", .data = &stmpe_i2c_id[1], },
+	{ .compatible = "st,stmpe811", .data = &stmpe_i2c_id[2], },
+	{ .compatible = "st,stmpe1601", .data = &stmpe_i2c_id[3], },
+	{ .compatible = "st,stmpe2401", .data = &stmpe_i2c_id[4], },
+	{ .compatible = "st,stmpe2403", .data = &stmpe_i2c_id[5], },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
+#endif
+
 static struct i2c_driver stmpe_i2c_driver = {
 	.driver = {
 		.name = "stmpe-i2c",
@@ -88,6 +102,7 @@ static struct i2c_driver stmpe_i2c_driver = {
 #ifdef CONFIG_PM
 		.pm = &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(stmpe_dt_ids),
 	},
 	.probe		= stmpe_i2c_probe,
 	.remove		= __devexit_p(stmpe_i2c_remove),
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index f86e3fc..e482f5f 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/spi/spi.h>
 #include <linux/types.h>
 #include "stmpe.h"
@@ -119,6 +120,19 @@ static const struct spi_device_id stmpe_spi_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, stmpe_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id stmpe_dt_ids[] = {
+	{ .compatible = "st,stmpe610", .data = (void *)STMPE610, },
+	{ .compatible = "st,stmpe801", .data = (void *)STMPE801, },
+	{ .compatible = "st,stmpe811", .data = (void *)STMPE811, },
+	{ .compatible = "st,stmpe1601", .data = (void *)STMPE1601, },
+	{ .compatible = "st,stmpe2401", .data = (void *)STMPE2401, },
+	{ .compatible = "st,stmpe2403", .data = (void *)STMPE2403, },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
+#endif
+
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
 		.name	= "stmpe-spi",
@@ -126,6 +140,7 @@ static struct spi_driver stmpe_spi_driver = {
 #ifdef CONFIG_PM
 		.pm	= &stmpe_dev_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(stmpe_dt_ids),
 	},
 	.probe		= stmpe_spi_probe,
 	.remove		= __devexit_p(stmpe_spi_remove),
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index fa22ef4..d3771ba 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -7,6 +7,7 @@
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
  */
 
+#include <linux/err.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
@@ -14,6 +15,8 @@
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/mfd/core.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include "stmpe.h"
@@ -1019,6 +1022,12 @@ void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
 {
 	struct device_node *child;
 
+	/*
+	 * Distinct names of same cell-type within multiple instances of stmpe
+	 * will be guaranteed by DT.
+	 */
+	pdata->id = -1;
+
 	of_property_read_u32(np, "st,autosleep-timeout",
 			&pdata->autosleep_timeout);
 
@@ -1027,15 +1036,16 @@ void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
 	for_each_child_of_node(np, child) {
 		if (!strcmp(child->name, "stmpe_gpio")) {
 			pdata->blocks |= STMPE_BLOCK_GPIO;
-		}
-		if (!strcmp(child->name, "stmpe_keypad")) {
+		} else if (!strcmp(child->name, "stmpe_keypad")) {
 			pdata->blocks |= STMPE_BLOCK_KEYPAD;
-		}
-		if (!strcmp(child->name, "stmpe_touchscreen")) {
+		} else if (!strcmp(child->name, "stmpe_touchscreen")) {
 			pdata->blocks |= STMPE_BLOCK_TOUCHSCREEN;
-		}
-		if (!strcmp(child->name, "stmpe_adc")) {
+		} else if (!strcmp(child->name, "stmpe_adc")) {
 			pdata->blocks |= STMPE_BLOCK_ADC;
+		} else if (!strcmp(child->name, "stmpe_pwm")) {
+			pdata->blocks |= STMPE_BLOCK_PWM;
+		} else if (!strcmp(child->name, "stmpe_rotator")) {
+			pdata->blocks |= STMPE_BLOCK_ROTATOR;
 		}
 	}
 }
-- 
1.7.12.rc2.18.g61b472e

