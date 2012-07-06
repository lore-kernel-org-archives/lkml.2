Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2GFJ0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:26:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34472 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab2GFJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:26:32 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2] mfd: max77686: Add device tree support.
Date: Fri,  6 Jul 2012 14:26:14 +0530
Message-Id: <1341564974-16885-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20120705124141.GB4111@opensource.wolfsonmicro.com>
References: <20120705124141.GB4111@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for mfd driver and adds
Documentation/devicetree/bindings/mfd/max77686.txt

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt |   59 ++++++++++++++++++++
 drivers/mfd/max77686.c                             |   43 +++++++++++++--
 2 files changed, 97 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77686.txt

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
new file mode 100644
index 0000000..c6a3469
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -0,0 +1,59 @@
+Maxim MAX77686 multi-function device
+
+MAX77686 is a Mulitifunction device with PMIC, RTC and Charger on chip. It is
+interfaced to host controller using i2c interface. PMIC and Charger submodules
+are addressed using same i2c slave address whereas RTC submodule uses
+different i2c slave address,presently for which we are statically creating i2c
+client while probing.This document describes the binding for mfd device and
+PMIC submodule.
+
+Required properties:
+- compatible : Must be "maxim,max77686";
+- reg : Specifies the i2c slave address of PMIC block.
+- interrupts : This i2c device has an IRQ line connected to the main SoC.
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+- voltage-regulators : The regulators of max77686 have to be instantiated
+  under subnode named "voltage-regulators" using the following format.
+
+	regulator_name {
+		regulator-compatible = LDOn/BUCKn
+		standard regulator constraints....
+	};
+	refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+  The regulator-compatible property of regulator should initialized with string
+to get matched with their hardware counterparts as follow:
+
+	-LDOn 	:	for LDOs, where n can lie in range 1 to 26.
+		 	example: LDO1, LDO2, LDO26.
+	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 9.
+			example: BUCK1, BUCK5, BUCK9.
+
+Example:
+
+	max77686@09 {
+		compatible = "maxim,max77686";
+		interrupt-parent = <&wakeup_eint>;
+		interrupts = <26 0>;
+		reg = <0x09>;
+
+		voltage-regulators {
+			ldo11_reg {
+				regulator-compatible = "LDO11";
+				regulator-name = "vdd_ldo11";
+				regulator-min-microvolt = <1900000>;
+				regulator-max-microvolt = <1900000>;
+				regulator-always-on;
+			};
+
+			buck1_reg {
+				regulator-compatible = "BUCK1";
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+	}
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 5c78e94..21bc8c5 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -35,6 +35,11 @@
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
+static struct of_device_id __devinitdata max77686_pmic_dt_match[] = {
+	{.compatible = "maxim,max77686",        .data = 0},
+	{},
+};
+
 static struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-pmic", },
 	{ .name = "max77686-rtc", },
@@ -45,6 +50,29 @@ static struct regmap_config max77686_regmap_config = {
 	.val_bits = 8,
 };
 
+#ifdef CONFIG_OF
+static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
+								  *dev)
+{
+	struct max77686_platform_data *pd;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "could not allocate memory for pdata\n");
+		return NULL;
+	}
+
+	dev->platform_data = pd;
+	return pd;
+}
+#else
+static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
+								  *dev)
+{
+	return 0;
+}
+#endif
+
 static int max77686_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -53,6 +81,15 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	unsigned int data;
 	int ret = 0;
 
+	if (i2c->dev.of_node)
+		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
+
+	if (!pdata) {
+		ret = -EIO;
+		dev_err(&i2c->dev, "No platform data found.\n");
+		goto err;
+	}
+
 	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
 	if (max77686 == NULL)
 		return -ENOMEM;
@@ -71,11 +108,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->i2c = i2c;
 	max77686->type = id->driver_data;
 
-	if (!pdata) {
-		ret = -EIO;
-		goto err;
-	}
-
 	max77686->wakeup = pdata->wakeup;
 	max77686->irq_gpio = pdata->irq_gpio;
 	max77686->irq = i2c->irq;
@@ -133,6 +165,7 @@ static struct i2c_driver max77686_i2c_driver = {
 	.driver = {
 		   .name = "max77686",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(max77686_pmic_dt_match),
 	},
 	.probe = max77686_i2c_probe,
 	.remove = max77686_i2c_remove,
-- 
1.7.0.4

