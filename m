Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2JIKXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:23:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1754 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2JIKXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:23:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Oct 2012 03:12:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <sameo@linux.intel.com>, <vbyravarasu@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/4] regulator: tps65090: add external control support for DCDC
Date: Tue, 9 Oct 2012 15:19:02 +0530
Message-ID: <1349776142-6409-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65090's DCDC output can also be enable/disable through the
external digital input signal. Add support for enable/disable
either through register access via I2C or through external
control inputs. The external control inputs can be driven through
GPIOs also and hence adding support for passing the GPIO number.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Simplify external control implemetation.
 
 drivers/regulator/tps65090-regulator.c |   77 +++++++++++++++++++++++--------
 include/linux/mfd/tps65090.h           |    7 +++-
 2 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 0732d9b..4124138 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
@@ -31,10 +32,13 @@ struct tps65090_regulator {
 	struct regulator_dev	*rdev;
 };
 
-static struct regulator_ops tps65090_ops = {
-	.enable = regulator_enable_regmap,
-	.disable = regulator_disable_regmap,
-	.is_enabled = regulator_is_enabled_regmap,
+static struct regulator_ops tps65090_ext_control_ops = {
+};
+
+static struct regulator_ops tps65090_reg_contol_ops = {
+	.enable		= regulator_enable_regmap,
+	.disable	= regulator_disable_regmap,
+	.is_enabled	= regulator_is_enabled_regmap,
 };
 
 static struct regulator_ops tps65090_ldo_ops = {
@@ -53,16 +57,16 @@ static struct regulator_ops tps65090_ldo_ops = {
 }
 
 static struct regulator_desc tps65090_regulator_desc[] = {
-	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_ops),
-	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_ops),
-	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_ops),
-	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_ops),
-	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_ops),
-	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_ops),
-	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_ops),
-	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
-	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
-	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
+	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_reg_contol_ops),
+	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_reg_contol_ops),
 	tps65090_REG_DESC(LDO1,  "vsys_l1", 0,    tps65090_ldo_ops),
 	tps65090_REG_DESC(LDO2,  "vsys_l2", 0,    tps65090_ldo_ops),
 };
@@ -118,6 +122,22 @@ static int __devinit tps65090_regulator_disable_ext_control(
 	return tps65090_config_ext_control(ri, false);
 }
 
+static void __devinit tps65090_configure_regulator_config(
+		struct tps65090_regulator_plat_data *tps_pdata,
+		struct regulator_config *config)
+{
+	if (gpio_is_valid(tps_pdata->gpio)) {
+		int gpio_flag = GPIOF_OUT_INIT_LOW;
+
+		if (tps_pdata->reg_init_data->constraints.always_on ||
+				tps_pdata->reg_init_data->constraints.boot_on)
+			gpio_flag = GPIOF_OUT_INIT_HIGH;
+
+		config->ena_gpio = tps_pdata->gpio;
+		config->ena_gpio_flags = gpio_flag;
+	}
+}
+
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
@@ -154,18 +174,24 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 
 		/*
 		 * TPS5090 DCDC support the control from external digital input.
-		 * It may be possible that during boot, the external control is
-		 * enabled. Disabling external control for DCDC.
+		 * Configure it as per platform data.
 		 */
 		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data) {
-			ret = tps65090_regulator_disable_ext_control(
+			if (tps_pdata->enable_ext_control) {
+				tps65090_configure_regulator_config(
+						tps_pdata, &config);
+				ri->desc->ops = &tps65090_ext_control_ops;
+			} else {
+				ret = tps65090_regulator_disable_ext_control(
 						ri, tps_pdata);
-			if (ret < 0) {
-				dev_err(&pdev->dev,
+				if (ret < 0) {
+					dev_err(&pdev->dev,
 						"failed disable ext control\n");
-				goto scrub;
+					goto scrub;
+				}
 			}
 		}
+
 		config.dev = &pdev->dev;
 		config.driver_data = ri;
 		config.regmap = tps65090_mfd->rmap;
@@ -182,6 +208,17 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 			goto scrub;
 		}
 		ri->rdev = rdev;
+
+		/* Enable external control if it is require */
+		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data &&
+				tps_pdata->enable_ext_control) {
+			ret = tps65090_config_ext_control(ri, true);
+			if (ret < 0) {
+				/* Increment num to get unregister rdev */
+				num++;
+				goto scrub;
+			}
+		}
 	}
 
 	platform_set_drvdata(pdev, pmic);
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 5989212..804e280 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -64,10 +64,15 @@ struct tps65090_subdev_info {
  * struct tps65090_regulator_plat_data
  *
  * @reg_init_data: The regulator init data.
+ * @enable_ext_control: Enable extrenal control or not. Only available for
+ *     DCDC1, DCDC2 and DCDC3.
+ * @gpio: Gpio number if external control is enabled and controlled through
+ *     gpio.
  */
-
 struct tps65090_regulator_plat_data {
 	struct regulator_init_data *reg_init_data;
+	bool enable_ext_control;
+	int gpio;
 };
 
 struct tps65090_platform_data {
-- 
1.7.1.1

