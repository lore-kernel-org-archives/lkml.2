Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2BWMc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:32:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9977 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2BWMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:32:12 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-f6-4f4631ca5cb8
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v3 2/2] regulator: add device tree support for max8997
Date: Thu, 23 Feb 2012 18:08:08 +0530
Message-id: <1330000688-11226-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based discovery support for max8997.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 .../devicetree/bindings/regulator/max8997-pmic.txt |  134 +++++++++++++++++++
 drivers/mfd/max8997.c                              |   72 ++++++++++-
 drivers/regulator/max8997.c                        |  139 +++++++++++++++++++-
 include/linux/mfd/max8997.h                        |    1 +
 4 files changed, 344 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8997-pmic.txt b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
new file mode 100644
index 0000000..d282635
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
@@ -0,0 +1,134 @@
+* Maxim MAX8997 Voltage and Current Regulator
+
+The Maxim MAX8997 is a multi-function device which includes volatage and
+current regulators, rtc, charger controller and other sub-blocks. It is
+interfaced to the host controller using a i2c interface. Each sub-block is
+addressed by the host system using different i2c slave address. This document
+describes the bindings for 'pmic' sub-block of max8997.
+
+Required properties:
+- compatible: Should be "maxim,max8997-pmic".
+- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
+
+- max8997,pmic-buck1-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck1 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+- max8997,pmic-buck2-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck2 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+- max8997,pmic-buck5-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck5 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+[1] If none of the 'max8997,pmic-buck[1/2/5]-uses-gpio-dvs' optional
+    property is specified, the 'max8997,pmic-buck[1/2/5]-dvs-voltage'
+    property should specify atleast one voltage level (which would be a
+    safe operating voltage).
+
+    If either of the 'max8997,pmic-buck[1/2/5]-uses-gpio-dvs' optional
+    property is specified, then all the eigth voltage values for the
+    'max8997,pmic-buck[1/2/5]-dvs-voltage' should be specified.
+
+Optional properties:
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from max8997 are delivered to.
+- interrupts: Interrupt specifiers for two interrupt sources.
+  - First interrupt specifier is for 'irq1' interrupt.
+  - Second interrupt specifier is for 'alert' interrupt.
+- max8997,pmic-buck1-uses-gpio-dvs: 'buck1' can be controlled by gpio dvs.
+- max8997,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
+- max8997,pmic-buck5-uses-gpio-dvs: 'buck5' can be controlled by gpio dvs.
+
+Additional properties required if either of the optional properties are used:
+- max8997,pmic-ignore-gpiodvs-side-effect: When GPIO-DVS mode is used for
+  multiple bucks, changing the voltage value of one of the bucks may affect
+  that of another buck, which is the side effect of the change (set_voltage).
+  Use this property to ignore such side effects and change the voltage.
+
+- max8997,pmic-buck125-default-dvs-idx: Default voltage setting selected from
+  the possible 8 options selectable by the dvs gpios. The value of this
+  property should be between 0 and 7. If not specified or if out of range, the
+  default value of this property is set to 0.
+
+- max8997,pmic-buck125-dvs-gpios: GPIO specifiers for three host gpio's used
+  for dvs. The format of the gpio specifier depends in the gpio controller.
+
+
+Regulators: The regulators of max8997 that have to be instantiated should be
+included in a sub-node named 'regulators'. Regulator nodes included in this
+sub-node should be of the format as below. Note: The 'n' in LDOn and BUCKn
+represents the LDO or BUCK number as per the datasheet of max8997.
+
+    For LDO's:
+		LDOn {
+			standard regulator bindings here
+		};
+
+    For BUCK's:
+		BUCKn {
+			standard regulator bindings here
+		};
+
+The bindings inside the regulator nodes use the standard regulator bindings
+which are documented elsewhere.
+
+Example:
+
+	max8997_pmic@66 {
+		compatible = "maxim,max8997-pmic";
+		interrupt-parent = <&wakeup_eint>;
+		reg = <0x66>;
+		interrupts = <4 0>, <3 0>;
+
+		max8997,pmic-buck1-uses-gpio-dvs;
+		max8997,pmic-buck2-uses-gpio-dvs;
+		max8997,pmic-buck5-uses-gpio-dvs;
+
+		max8997,pmic-ignore-gpiodvs-side-effect;
+		max8997,pmic-buck125-default-dvs-idx = <0>;
+
+		max8997,pmic-buck125-dvs-gpios = <&gpx0 0 1 0 0>, /* SET1 */
+						 <&gpx0 1 1 0 0>, /* SET2 */
+						 <&gpx0 2 1 0 0>; /* SET3 */
+
+		max8997,pmic-buck1-dvs-voltage = <1350000>, <1300000>,
+						 <1250000>, <1200000>,
+						 <1150000>, <1100000>,
+						 <1000000>, <950000>;
+
+		max8997,pmic-buck2-dvs-voltage = <1100000>, <1100000>,
+				    		 <1100000>, <1100000>,
+						 <1000000>, <1000000>,
+						 <1000000>, <1000000>;
+
+		max8997,pmic-buck5-dvs-voltage = <1200000>, <1200000>,
+						 <1200000>, <1200000>,
+						 <1200000>, <1200000>,
+						 <1200000>, <1200000>;
+
+		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "VDD_ABB_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "VDD_ALIVE_1.1V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "VDD_ARM_1.2V";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+	};
+
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 20ecad3..13180be 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -23,6 +23,7 @@
 
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/of_irq.h>
 #include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
@@ -123,6 +124,60 @@ int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 }
 EXPORT_SYMBOL_GPL(max8997_update_reg);
 
+#ifdef CONFIG_OF
+/*
+ * Only the common platform data elements for max8997 are parsed here from the
+ * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
+ * to parse their own platform data elements from device tree.
+ *
+ * The max8997 platform data structure is instantiated here and the drivers for
+ * the sub-modules need not instantiate another instance while parsing their
+ * platform data.
+ */
+static int max8997_i2c_parse_dt_pdata(struct device *dev,
+					struct max8997_platform_data **pdata)
+{
+	struct max8997_platform_data *pd;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "could not allocate memory for pdata\n");
+		return -ENOMEM;
+	}
+
+	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
+
+	/*
+	 * ToDo: the 'wakeup' member in the platform data is more of a linux
+	 * specfic information. Hence, there is no binding for that yet and
+	 * not parsed here.
+	 */
+
+	*pdata = pd;
+	return 0;
+}
+#else
+static int max8997_i2c_parse_dt_pdata(struct device *dev,
+					struct max8997_platform_data **pdata)
+{
+	return 0;
+}
+#endif
+
+static struct of_device_id __devinitdata max8997_pmic_dt_match[];
+static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
+						const struct i2c_device_id *id)
+{
+#ifdef CONFIG_OF
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
+		return (int)match->data;
+	}
+#endif
+	return (int)id->driver_data;
+}
+
 static int max8997_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -137,9 +192,16 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, max8997);
 	max8997->dev = &i2c->dev;
 	max8997->i2c = i2c;
-	max8997->type = id->driver_data;
+	max8997->type = max8997_i2c_get_driver_data(i2c, id);
 	max8997->irq = i2c->irq;
 
+	if (max8997->dev->of_node) {
+		ret = max8997_i2c_parse_dt_pdata(max8997->dev, &pdata);
+		if (ret)
+			goto err;
+		i2c->dev.platform_data = pdata;
+	}
+
 	if (!pdata)
 		goto err;
 
@@ -429,11 +491,19 @@ const struct dev_pm_ops max8997_pm = {
 	.restore = max8997_restore,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id __devinitdata max8997_pmic_dt_match[] = {
+	{ .compatible = "maxim,max8997-pmic", .data = TYPE_MAX8997 },
+	{},
+};
+#endif
+
 static struct i2c_driver max8997_i2c_driver = {
 	.driver = {
 		   .name = "max8997",
 		   .owner = THIS_MODULE,
 		   .pm = &max8997_pm,
+		   .of_match_table = of_match_ptr(max8997_pmic_dt_match),
 	},
 	.probe = max8997_i2c_probe,
 	.remove = max8997_i2c_remove,
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index bb7cd9d..b31c4c9 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -32,6 +33,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
+#include <linux/regulator/of_regulator.h>
 
 struct max8997_data {
 	struct device *dev;
@@ -958,6 +960,134 @@ static struct regulator_desc regulators[] = {
 	},
 };
 
+#ifdef CONFIG_OF
+static int max8997_pmic_dt_parse_dvs_gpio(struct max8997_dev *iodev,
+			struct max8997_platform_data *pdata,
+			struct device_node *pmic_np)
+{
+	int i, gpio;
+
+	for (i = 0; i < 3; i++) {
+		gpio = of_get_named_gpio(pmic_np,
+					"max8997,pmic-buck125-dvs-gpios", i);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			return -EINVAL;
+		}
+		pdata->buck125_gpios[i] = gpio;
+	}
+	return 0;
+}
+
+static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
+					struct max8997_platform_data *pdata)
+{
+	struct device_node *pmic_np, *regulators_np, *reg_np;
+	struct max8997_regulator_data *rdata;
+	unsigned int i, dvs_voltage_nr = 1, ret;
+
+	pmic_np = iodev->dev->of_node;
+	if (!pmic_np) {
+		dev_err(iodev->dev, "could not find pmic sub-node\n");
+		return -ENODEV;
+	}
+
+	regulators_np = of_find_node_by_name(pmic_np, "regulators");
+	if (!regulators_np) {
+		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	/* count the number of regulators to be supported in pmic */
+	pdata->num_regulators = 0;
+	for_each_child_of_node(regulators_np, reg_np)
+		pdata->num_regulators++;
+
+	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+				pdata->num_regulators, GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev, "could not allocate memory for "
+						"regulator data\n");
+		return -ENOMEM;
+	}
+
+	pdata->regulators = rdata;
+	for_each_child_of_node(regulators_np, reg_np) {
+		for (i = 0; i < ARRAY_SIZE(regulators); i++)
+			if (!of_node_cmp(reg_np->name, regulators[i].name))
+				break;
+		rdata->id = i;
+		rdata->initdata = of_get_regulator_init_data(
+						iodev->dev, reg_np);
+		rdata->reg_node = reg_np;
+		rdata++;
+	}
+
+	if (of_get_property(pmic_np, "max8997,pmic-buck1-uses-gpio-dvs", NULL))
+		pdata->buck1_gpiodvs = true;
+
+	if (of_get_property(pmic_np, "max8997,pmic-buck2-uses-gpio-dvs", NULL))
+		pdata->buck2_gpiodvs = true;
+
+	if (of_get_property(pmic_np, "max8997,pmic-buck5-uses-gpio-dvs", NULL))
+		pdata->buck5_gpiodvs = true;
+
+	if (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
+						pdata->buck5_gpiodvs) {
+		ret = max8997_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
+		if (ret)
+			return -EINVAL;
+
+		if (of_property_read_u32(pmic_np,
+				"max8997,pmic-buck125-default-dvs-idx",
+				&pdata->buck125_default_idx)) {
+			pdata->buck125_default_idx = 0;
+		} else {
+			if (pdata->buck125_default_idx >= 8) {
+				pdata->buck125_default_idx = 0;
+				dev_info(iodev->dev, "invalid value for "
+				"default dvs index, using 0 instead\n");
+			}
+		}
+
+		if (of_get_property(pmic_np,
+			"max8997,pmic-ignore-gpiodvs-side-effect", NULL))
+			pdata->ignore_gpiodvs_side_effect = true;
+
+		dvs_voltage_nr = 8;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"max8997,pmic-buck1-dvs-voltage",
+				pdata->buck1_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck1 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"max8997,pmic-buck2-dvs-voltage",
+				pdata->buck2_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck2 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"max8997,pmic-buck5-dvs-voltage",
+				pdata->buck5_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck5 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
+					struct max8997_platform_data *pdata)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 {
 	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -968,6 +1098,12 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 	int i, ret, size;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
+	if (iodev->dev->of_node) {
+		ret = max8997_pmic_dt_parse_pdata(iodev, pdata);
+		if (ret)
+			return ret;
+	}
+
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
 		return -ENODEV;
@@ -1146,7 +1282,8 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 			regulators[id].n_voltages = 16;
 
 		rdev[i] = regulator_register(&regulators[id], max8997->dev,
-				pdata->regulators[i].initdata, max8997, NULL);
+				pdata->regulators[i].initdata, max8997,
+				pdata->regulators[i].reg_node);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8997->dev, "regulator init failed for %d\n",
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 818486c..ba92375 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -75,6 +75,7 @@ enum max8998_regulators {
 struct max8997_regulator_data {
 	int id;
 	struct regulator_init_data *initdata;
+	struct device_node *reg_node;
 };
 
 enum max8997_muic_usb_type {
-- 
1.6.6.rc2

