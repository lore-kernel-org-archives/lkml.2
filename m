Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2LJMu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:50:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2LJMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:50:23 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        amit.kachhap@gmail.com, Thomas Abraham <thomas.abraham@linaro.org>,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 4/4] regulator: add device tree support for s5m8767
Date: Mon, 10 Dec 2012 18:19:42 +0530
Message-Id: <1355143782-15133-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
References: <1355143782-15133-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based discovery support for pmic block of s5m8767

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/regulator/s5m8767-regulator.txt       |  133 ++++++++++++++
 drivers/mfd/sec-core.c                             |   75 ++++++++-
 drivers/regulator/s5m8767.c                        |  190 +++++++++++++++++++-
 include/linux/mfd/samsung/core.h                   |    3 +
 4 files changed, 398 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
new file mode 100644
index 0000000..59c372b
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -0,0 +1,133 @@
+* Samsung S5M8767 Voltage and Current Regulator
+
+The Samsung S5M8767 is a multi-function device which includes volatage and
+current regulators, rtc, charger controller and other sub-blocks. It is
+interfaced to the host controller using a i2c interface. Each sub-block is
+addressed by the host system using different i2c slave address. This document
+describes the bindings for 'pmic' sub-block of s5m8767.
+
+Required properties:
+- compatible: Should be "samsung,s5m8767-pmic".
+- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
+
+- s5m8767,pmic-buck2-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck2 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+- s5m8767,pmic-buck3-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck3 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+- s5m8767,pmic-buck4-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
+  units for buck4 when changing voltage using gpio dvs. Refer to [1] below
+  for additional information.
+
+[1] If none of the 's5m8767,pmic-buck[2/3/4]-uses-gpio-dvs' optional
+    property is specified, the 's5m8767,pmic-buck[2/3/4]-dvs-voltage'
+    property should specify atleast one voltage level (which would be a
+    safe operating voltage).
+
+    If either of the 's5m8767,pmic-buck[2/3/4]-uses-gpio-dvs' optional
+    property is specified, then all the eigth voltage values for the
+    's5m8767,pmic-buck[2/3/4]-dvs-voltage' should be specified.
+
+Optional properties:
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from s5m8767 are delivered to.
+- interrupts: Interrupt specifiers for two interrupt sources.
+  - First interrupt specifier is for 'irq1' interrupt.
+  - Second interrupt specifier is for 'alert' interrupt.
+- s5m8767,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
+- s5m8767,pmic-buck3-uses-gpio-dvs: 'buck3' can be controlled by gpio dvs.
+- s5m8767,pmic-buck4-uses-gpio-dvs: 'buck4' can be controlled by gpio dvs.
+
+Additional properties required if either of the optional properties are used:
+
+- s5m8767,pmic-buck234-default-dvs-idx: Default voltage setting selected from
+  the possible 8 options selectable by the dvs gpios. The value of this
+  property should be between 0 and 7. If not specified or if out of range, the
+  default value of this property is set to 0.
+
+- s5m8767,pmic-buck-dvs-gpios: GPIO specifiers for three host gpio's used
+  for dvs. The format of the gpio specifier depends in the gpio controller.
+
+Regulators: The regulators of s5m8767 that have to be instantiated should be
+included in a sub-node named 'regulators'. Regulator nodes included in this
+sub-node should be of the format as listed below.
+
+	regulator_name {
+		standard regulator bindings here
+	};
+
+The following are the names of the regulators that the s5m8767 pmic block
+supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
+as per the datasheet of s5m8767.
+
+	- LDOn
+		  - valid values for n are 1 to 28
+		  - Example: LDO0, LD01, LDO28
+	- BUCKn
+		  - valid values for n are 1 to 9.
+		  - Example: BUCK1, BUCK2, BUCK9
+
+The bindings inside the regulator nodes use the standard regulator bindings
+which are documented elsewhere.
+
+Example:
+
+	s5m8767_pmic@66 {
+		compatible = "samsung,s5m8767-pmic";
+		reg = <0x66>;
+
+		s5m8767,pmic-buck2-uses-gpio-dvs;
+		s5m8767,pmic-buck3-uses-gpio-dvs;
+		s5m8767,pmic-buck4-uses-gpio-dvs;
+
+		s5m8767,pmic-buck-default-dvs-idx = <0>;
+
+		s5m8767,pmic-buck-dvs-gpios = <&gpx0 0 1 0 0>, /* DVS1 */
+						 <&gpx0 1 1 0 0>, /* DVS2 */
+						 <&gpx0 2 1 0 0>; /* DVS3 */
+
+		s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1 0 0>, /* SET1 */
+						<&gpx2 4 1 0 0>, /* SET2 */
+						<&gpx2 5 1 0 0>; /* SET3 */
+
+		s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
+						 <1250000>, <1200000>,
+						 <1150000>, <1100000>,
+						 <1000000>, <950000>;
+
+		s5m8767,pmic-buck3-dvs-voltage = <1100000>, <1100000>,
+						 <1100000>, <1100000>,
+						 <1000000>, <1000000>,
+						 <1000000>, <1000000>;
+
+		s5m8767,pmic-buck4-dvs-voltage = <1200000>, <1200000>,
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
+				regulator-name = "VDD_MIF_1.2V";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+	};
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 49d361a..51de531 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/of_irq.h>
 #include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
@@ -60,6 +61,15 @@ static struct mfd_cell s2mps11_devs[] = {
 	},
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id __devinitdata sec_dt_match[] = {
+	{	.compatible = "samsung,s5m8767-pmic",
+		.data = S5M8767X,
+	},
+	{},
+};
+#endif
+
 int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
 	return regmap_read(sec_pmic->regmap, reg, dest);
@@ -95,6 +105,57 @@ static struct regmap_config sec_regmap_config = {
 	.val_bits = 8,
 };
 
+
+#ifdef CONFIG_OF
+/*
+ * Only the common platform data elements for s5m8767 are parsed here from the
+ * device tree. Other sub-modules of s5m8767 such as pmic, rtc , charger and
+ * others have to parse their own platform data elements from device tree.
+ *
+ * The s5m8767 platform data structure is instantiated here and the drivers for
+ * the sub-modules need not instantiate another instance while parsing their
+ * platform data.
+ */
+static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
+					struct device *dev)
+{
+	struct sec_platform_data *pd;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "could not allocate memory for pdata\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/*
+	 * ToDo: the 'wakeup' member in the platform data is more of a linux
+	 * specfic information. Hence, there is no binding for that yet and
+	 * not parsed here.
+	 */
+
+	return pd;
+}
+#else
+static struct sec_platform_data *sec_i2c_parse_dt_pdata(
+					struct device *dev)
+{
+	return 0;
+}
+#endif
+
+static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
+						const struct i2c_device_id *id)
+{
+#ifdef CONFIG_OF
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(sec_dt_match, i2c->dev.of_node);
+		return (int)match->data;
+	}
+#endif
+	return (int)id->driver_data;
+}
+
 static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -111,13 +172,22 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	sec_pmic->dev = &i2c->dev;
 	sec_pmic->i2c = i2c;
 	sec_pmic->irq = i2c->irq;
-	sec_pmic->type = id->driver_data;
-
+	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
+
+	if (sec_pmic->dev->of_node) {
+		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
+		if (IS_ERR(pdata)) {
+			ret = PTR_ERR(pdata);
+			return ret;
+		}
+		pdata->device_type = sec_pmic->type;
+	}
 	if (pdata) {
 		sec_pmic->device_type = pdata->device_type;
 		sec_pmic->ono = pdata->ono;
 		sec_pmic->irq_base = pdata->irq_base;
 		sec_pmic->wakeup = pdata->wakeup;
+		sec_pmic->pdata = pdata;
 	}
 
 	sec_pmic->regmap = devm_regmap_init_i2c(i2c, &sec_regmap_config);
@@ -192,6 +262,7 @@ static struct i2c_driver sec_pmic_driver = {
 	.driver = {
 		   .name = "sec_pmic",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(sec_dt_match),
 	},
 	.probe = sec_pmic_probe,
 	.remove = sec_pmic_remove,
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 9f991f2..fcd606d 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -21,6 +22,11 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s5m8767.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/io.h>
+#include <mach/map.h>
+
+#define S5M8767_OPMODE_NORMAL_MODE 0x1
 
 struct s5m8767_info {
 	struct device *dev;
@@ -508,15 +514,196 @@ static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(BUCK9),
 };
 
+#ifdef CONFIG_OF
+static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
+			struct sec_platform_data *pdata,
+			struct device_node *pmic_np)
+{
+	int i, gpio;
+
+	for (i = 0; i < 3; i++) {
+		gpio = of_get_named_gpio(pmic_np,
+					"s5m8767,pmic-buck-dvs-gpios", i);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			return -EINVAL;
+		}
+		pdata->buck_gpios[i] = gpio;
+	}
+	return 0;
+}
+
+static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
+			struct sec_platform_data *pdata,
+			struct device_node *pmic_np)
+{
+	int i, gpio;
+
+	for (i = 0; i < 3; i++) {
+		gpio = of_get_named_gpio(pmic_np,
+					"s5m8767,pmic-buck-ds-gpios", i);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			return -EINVAL;
+		}
+		pdata->buck_ds[i] = gpio;
+	}
+	return 0;
+}
+
+static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+					struct sec_platform_data *pdata)
+{
+	struct device_node *pmic_np, *regulators_np, *reg_np;
+	struct sec_regulator_data *rdata;
+	struct sec_opmode_data *rmode;
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
+	for_each_child_of_node(regulators_np, reg_np) {
+		pdata->num_regulators++;
+	}
+
+	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+				pdata->num_regulators, GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev,
+			"could not allocate memory for regulator data\n");
+		return -ENOMEM;
+	}
+
+	rmode = devm_kzalloc(iodev->dev, sizeof(*rmode) *
+				pdata->num_regulators, GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev,
+			"could not allocate memory for regulator mode\n");
+		return -ENOMEM;
+	}
+
+
+	pdata->regulators = rdata;
+	pdata->opmode = rmode;
+	for_each_child_of_node(regulators_np, reg_np) {
+		for (i = 0; i < ARRAY_SIZE(regulators); i++)
+			if (!of_node_cmp(reg_np->name, regulators[i].name))
+				break;
+
+		if (i == ARRAY_SIZE(regulators)) {
+			dev_warn(iodev->dev,
+			"don't know how to configure regulator %s\n",
+			reg_np->name);
+			continue;
+		}
+
+		rdata->id = i;
+		rdata->initdata = of_get_regulator_init_data(
+						iodev->dev, reg_np);
+		rdata->reg_node = reg_np;
+		rdata++;
+		rmode->id = i;
+		if (of_property_read_u32(reg_np, "op_mode",
+				&rmode->mode)) {
+			dev_warn(iodev->dev, "no op_mode property property at %s\n",
+				reg_np->full_name);
+
+			rmode->mode = S5M8767_OPMODE_NORMAL_MODE;
+		}
+		rmode++;
+	}
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL))
+		pdata->buck2_gpiodvs = true;
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL))
+		pdata->buck3_gpiodvs = true;
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL))
+		pdata->buck4_gpiodvs = true;
+
+	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
+						pdata->buck4_gpiodvs) {
+		ret = s5m8767_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
+		if (ret)
+			return -EINVAL;
+
+		if (of_property_read_u32(pmic_np,
+				"s5m8767,pmic-buck-default-dvs-idx",
+				&pdata->buck_default_idx)) {
+			pdata->buck_default_idx = 0;
+		} else {
+			if (pdata->buck_default_idx >= 8) {
+				pdata->buck_default_idx = 0;
+				dev_info(iodev->dev,
+				"invalid value for default dvs index, use 0\n");
+			}
+		}
+
+		dvs_voltage_nr = 8;
+	}
+
+	ret = s5m8767_pmic_dt_parse_ds_gpio(iodev, pdata, pmic_np);
+	if (ret)
+		return -EINVAL;
+
+	if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck2-dvs-voltage",
+				pdata->buck2_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck2 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck3-dvs-voltage",
+				pdata->buck3_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck3 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck4-dvs-voltage",
+				pdata->buck4_voltage, dvs_voltage_nr)) {
+		dev_err(iodev->dev, "buck4 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+					struct sec_platform_data *pdata)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static int s5m8767_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct sec_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
 	int i, ret, size, buck_init;
 
+	if (iodev->dev->of_node) {
+		ret = s5m8767_pmic_dt_parse_pdata(iodev, pdata);
+		if (ret)
+			return ret;
+	}
+
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
 		return -ENODEV;
@@ -765,6 +952,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.dev = s5m8767->dev;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s5m8767;
+		config.of_node = pdata->regulators[i].reg_node;
 
 		rdev[i] = regulator_register(&regulators[id], &config);
 		if (IS_ERR(rdev[i])) {
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index b50c38f..380ed95 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -26,6 +26,7 @@ enum sec_device_type {
 /**
  * struct sec_pmic_dev - s5m87xx master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
+ * @pdata: pointer to private data used to pass platform data to child
  * @i2c: i2c client private data for regulator
  * @rtc: i2c client private data for rtc
  * @iolock: mutex for serializing io access
@@ -39,6 +40,7 @@ enum sec_device_type {
  */
 struct sec_pmic_dev {
 	struct device *dev;
+	struct sec_platform_data *pdata;
 	struct regmap *regmap;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
@@ -127,6 +129,7 @@ struct sec_platform_data {
 struct sec_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
+	struct device_node *reg_node;
 };
 
 /*
-- 
1.7.1

