Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2GJLKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:10:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50402 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab2GJLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:10:06 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Date: Tue, 10 Jul 2012 16:39:42 +0530
Message-ID: <1341918584-28004-2-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds device tree support for tps65217 pmic. And usage
details are added to device tree documentation. Driver is tested
by using kernel module with regulator set and get APIs.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 .../devicetree/bindings/regulator/tps65217.txt     |   91 ++++++++++++++++++++
 drivers/mfd/tps65217.c                             |   67 +++++++++++++-
 drivers/regulator/tps65217-regulator.c             |    1 +
 include/linux/mfd/tps65217.h                       |    3 +-
 4 files changed, 159 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65217.txt

diff --git a/Documentation/devicetree/bindings/regulator/tps65217.txt b/Documentation/devicetree/bindings/regulator/tps65217.txt
new file mode 100644
index 0000000..0487e96
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps65217.txt
@@ -0,0 +1,91 @@
+TPS65217 family of regulators
+
+Required properties:
+- compatible: "ti,tps65217"
+- reg: I2C slave address
+- regulators: list of regulators provided by this controller, must be named
+  after their hardware counterparts: dcdc[1-3] and ldo[1-4]
+- regulators: This is the list of child nodes that specify the regulator
+  initialization data for defined regulators. Not all regulators for the given
+  device need to be present. The definition for each of these nodes is defined
+  using the standard binding for regulators found at
+  Documentation/devicetree/bindings/regulator/regulator.txt.
+
+  The valid names for regulators are:
+  tps65217: dcdc1, dcdc2, dcdc3, ldo1, ldo2, ldo3 and ldo4
+
+Each regulator is defined using the standard binding for regulators.
+
+Example:
+
+	tps: tps@24 {
+		compatible = "ti,tps65217";
+
+		regulators {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			dcdc1_reg: regulator@0 {
+				reg = <0>;
+				regulator-compatible = "dcdc1";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			dcdc2_reg: regulator@1 {
+				reg = <1>;
+				regulator-compatible = "dcdc2";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			dcdc3_reg: regulator@2 {
+				reg = <2>;
+				regulator-compatible = "dcdc3";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo1_reg: regulator@3 {
+				reg = <3>;
+				regulator-compatible = "ldo1";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo2_reg: regulator@4 {
+				reg = <4>;
+				regulator-compatible = "ldo2";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo3_reg: regulator@5 {
+				reg = <5>;
+				regulator-compatible = "ldo3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo4_reg: regulator@6 {
+				reg = <6>;
+				regulator-compatible = "ldo4";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+	};
diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index db194e4..61c097a 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/regmap.h>
 #include <linux/err.h>
+#include <linux/regulator/of_regulator.h>
 
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65217.h>
@@ -132,6 +133,61 @@ int tps65217_clear_bits(struct tps65217 *tps, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(tps65217_clear_bits);
 
+#ifdef CONFIG_OF
+static struct of_regulator_match reg_matches[] = {
+	{ .name = "dcdc1", .driver_data = (void *)TPS65217_DCDC_1 },
+	{ .name = "dcdc2", .driver_data = (void *)TPS65217_DCDC_2 },
+	{ .name = "dcdc3", .driver_data = (void *)TPS65217_DCDC_3 },
+	{ .name = "ldo1", .driver_data = (void *)TPS65217_LDO_1 },
+	{ .name = "ldo2", .driver_data = (void *)TPS65217_LDO_2 },
+	{ .name = "ldo3", .driver_data = (void *)TPS65217_LDO_3 },
+	{ .name = "ldo4", .driver_data = (void *)TPS65217_LDO_4 },
+};
+
+static struct tps65217_board *tps65217_parse_dt(struct i2c_client *client)
+{
+	struct device_node *node = client->dev.of_node;
+	struct tps65217_board *pdata;
+	struct device_node *regs;
+	int count = ARRAY_SIZE(reg_matches);
+	int ret, i;
+
+	regs = of_find_node_by_name(node, "regulators");
+	if (!regs)
+		return NULL;
+
+	ret = of_regulator_match(&client->dev, regs, reg_matches, count);
+	of_node_put(regs);
+	if ((ret < 0) || (ret > count))
+		return NULL;
+
+	count = ret;
+	pdata = devm_kzalloc(&client->dev, count * sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	for (i = 0; i < count; i++) {
+		if (!reg_matches[i].init_data || !reg_matches[i].of_node)
+			continue;
+
+		pdata->tps65217_init_data[i] = reg_matches[i].init_data;
+		pdata->of_node[i] = reg_matches[i].of_node;
+	}
+
+	return pdata;
+}
+
+static struct of_device_id tps65217_of_match[] = {
+	{ .compatible = "ti,tps65217", },
+	{ },
+};
+#else
+static struct tps65217_board *tps65217_parse_dt(struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static struct regmap_config tps65217_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -141,10 +197,14 @@ static int __devinit tps65217_probe(struct i2c_client *client,
 				const struct i2c_device_id *ids)
 {
 	struct tps65217 *tps;
+	struct regulator_init_data *reg_data;
 	struct tps65217_board *pdata = client->dev.platform_data;
 	int i, ret;
 	unsigned int version;
 
+	if (!pdata && client->dev.of_node)
+		pdata = tps65217_parse_dt(client);
+
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps)
 		return -ENOMEM;
@@ -182,8 +242,9 @@ static int __devinit tps65217_probe(struct i2c_client *client,
 		}
 
 		pdev->dev.parent = tps->dev;
-		platform_device_add_data(pdev, &pdata->tps65217_init_data[i],
-					sizeof(pdata->tps65217_init_data[i]));
+		pdev->dev.of_node = pdata->of_node[i];
+		reg_data = pdata->tps65217_init_data[i];
+		platform_device_add_data(pdev, reg_data, sizeof(*reg_data));
 		tps->regulator_pdev[i] = pdev;
 
 		platform_device_add(pdev);
@@ -212,6 +273,8 @@ MODULE_DEVICE_TABLE(i2c, tps65217_id_table);
 static struct i2c_driver tps65217_driver = {
 	.driver		= {
 		.name	= "tps65217",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(tps65217_of_match),
 	},
 	.id_table	= tps65217_id_table,
 	.probe		= tps65217_probe,
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 9d371d2..75401c7 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -326,6 +326,7 @@ static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
 	tps->info[pdev->id] = info;
 
 	config.dev = &pdev->dev;
+	config.of_node = pdev->dev.of_node;
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = tps;
 
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index e030ef9..10e0595 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -217,7 +217,8 @@ enum tps65217_regulator_id {
  * Board data may be used to initialize regulator.
  */
 struct tps65217_board {
-	struct regulator_init_data *tps65217_init_data;
+	struct regulator_init_data *tps65217_init_data[TPS65217_NUM_REGULATOR];
+	struct device_node *of_node[TPS65217_NUM_REGULATOR];
 };
 
 /**
-- 
1.7.9.5

