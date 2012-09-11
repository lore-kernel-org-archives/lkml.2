Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab2IKTTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:19:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39871 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2IKTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:19:51 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: broonie@opensource.wolfsonmicro.com, ldewangan@nvidia.com,
        bilhuang@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] mfd: max8907: add power off control
Date: Tue, 11 Sep 2012 13:19:41 -0600
Message-Id: <1347391181-31005-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Add DT property "maxim,system-power-controller" to indicate whether the
PMIC is in charge of controlling the system power. If this is set, the
driver will provide the pm_power_off() function.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: This is based on my patch "mfd: add MAX8907 core driver", which I don't
believe is applied yet.

 .../devicetree/bindings/regulator/max8907.txt      |    6 ++++++
 drivers/mfd/max8907.c                              |   20 ++++++++++++++++++++
 include/linux/mfd/max8907.h                        |    2 ++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/max8907.txt b/Documentation/devicetree/bindings/regulator/max8907.txt
index 4fd847f..51e683b 100644
--- a/Documentation/devicetree/bindings/regulator/max8907.txt
+++ b/Documentation/devicetree/bindings/regulator/max8907.txt
@@ -16,6 +16,10 @@ Required properties:
   property, with valid values listed below. The content of each sub-node
   is defined by the standard binding for regulators; see regulator.txt.
 
+Optional properties:
+- maxim,system-power-controller: Boolean property indicating that the PMIC
+  controls the overall system power.
+
 Valid regulator-compatible values are:
 
   sd1, sd2, sd3, ldo1, ldo2, ldo3, ldo4, ldo5, ldo6, ldo7, ldo8, ldo9, ldo10,
@@ -29,6 +33,8 @@ Example:
 			reg = <0x3c>;
 			interrupts = <0 86 0x4>;
 
+			maxim,system-power-controller;
+
 			mbatt-supply = <&some_reg>;
 			in-v1-supply = <&mbatt_reg>;
 			...
diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 5295276..3cc6b04 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -176,11 +176,26 @@ static const struct regmap_irq_chip max8907_rtc_irq_chip = {
 	.num_irqs = ARRAY_SIZE(max8907_rtc_irqs),
 };
 
+struct max8907 *max8907_pm_off;
+static void max8907_power_off(void)
+{
+	regmap_update_bits(max8907_pm_off->regmap_gen, MAX8907_REG_RESET_CNFG,
+			MAX8907_MASK_POWER_OFF, MAX8907_MASK_POWER_OFF);
+}
+
 static __devinit int max8907_i2c_probe(struct i2c_client *i2c,
 				       const struct i2c_device_id *id)
 {
 	struct max8907 *max8907;
 	int ret;
+	struct max8907_platform_data *pdata = dev_get_platdata(&i2c->dev);
+	bool pm_off = false;
+
+	if (pdata)
+		pm_off = pdata->pm_off;
+	else if (i2c->dev.of_node)
+		pm_off = of_property_read_bool(i2c->dev.of_node,
+					"maxim,system-power-controller");
 
 	max8907 = devm_kzalloc(&i2c->dev, sizeof(struct max8907), GFP_KERNEL);
 	if (!max8907) {
@@ -251,6 +266,11 @@ static __devinit int max8907_i2c_probe(struct i2c_client *i2c,
 		goto err_add_devices;
 	}
 
+	if (pm_off && !pm_power_off) {
+		max8907_pm_off = max8907;
+		pm_power_off = max8907_power_off;
+	}
+
 	return 0;
 
 err_add_devices:
diff --git a/include/linux/mfd/max8907.h b/include/linux/mfd/max8907.h
index 283531f..b06f7a6 100644
--- a/include/linux/mfd/max8907.h
+++ b/include/linux/mfd/max8907.h
@@ -167,6 +167,7 @@
 #define MAX8907_MASK_OUT5V_VINEN	0x10
 #define MAX8907_MASK_OUT5V_ENSRC	0x0E
 #define MAX8907_MASK_OUT5V_EN		0x01
+#define MAX8907_MASK_POWER_OFF		0x40
 
 /* Regulator IDs */
 #define MAX8907_MBATT	0
@@ -231,6 +232,7 @@ enum {
 
 struct max8907_platform_data {
 	struct regulator_init_data *init_data[MAX8907_NUM_REGULATORS];
+	bool pm_off;
 };
 
 struct regmap_irq_chips_data;
-- 
1.7.0.4

