Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2DOQCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:02:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38777 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2DOQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:02:52 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: [PATCH v4] mfd: da9052: add device-tree support for i2c driver
Date: Mon, 16 Apr 2012 00:01:50 +0800
Message-Id: <1334505710-8919-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

This patch adds device-tree support for dialog MFD and the binding
documentations.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 .../devicetree/bindings/mfd/da9052-i2c.txt         |   60 ++++++++++++++++++++
 drivers/mfd/da9052-i2c.c                           |   50 +++++++++++++---
 2 files changed, 102 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9052-i2c.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9052-i2c.txt b/Documentation/devicetree/bindings/mfd/da9052-i2c.txt
new file mode 100644
index 0000000..1857f4a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9052-i2c.txt
@@ -0,0 +1,60 @@
+* Dialog DA9052/53 Power Management Integrated Circuit (PMIC)
+
+Required properties:
+- compatible : Should be "dlg,da9052", "dlg,da9053-aa",
+			 "dlg,da9053-ab", or "dlg,da9053-bb"
+
+Sub-nodes:
+- regulators : Contain the regulator nodes. The DA9052/53 regulators are
+  bound using their names as listed below:
+
+    buck0     : regulator BUCK0
+    buck1     : regulator BUCK1
+    buck2     : regulator BUCK2
+    buck3     : regulator BUCK3
+    ldo4      : regulator LDO4
+    ldo5      : regulator LDO5
+    ldo6      : regulator LDO6
+    ldo7      : regulator LDO7
+    ldo8      : regulator LDO8
+    ldo9      : regulator LDO9
+    ldo10     : regulator LDO10
+    ldo11     : regulator LDO11
+    ldo12     : regulator LDO12
+    ldo13     : regulator LDO13
+
+  The bindings details of individual regulator device can be found in:
+  Documentation/devicetree/bindings/regulator/regulator.txt
+
+Examples:
+
+i2c@63fc8000 { /* I2C1 */
+	status = "okay";
+
+	pmic: dialog@48 {
+		compatible = "dlg,da9053-aa";
+		reg = <0x48>;
+
+		regulators {
+			buck0 {
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			buck1 {
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			buck2 {
+				regulator-min-microvolt = <925000>;
+				regulator-max-microvolt = <2500000>;
+			};
+
+			buck3 {
+				regulator-min-microvolt = <925000>;
+				regulator-max-microvolt = <2500000>;
+			};
+		};
+	};
+};
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 36b88e3..d8abdb3 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -22,6 +22,11 @@
 #include <linux/mfd/da9052/da9052.h>
 #include <linux/mfd/da9052/reg.h>
 
+#ifdef CONFIG_OF
+#include <linux/of.h>
+#include <linux/of_device.h>
+#endif
+
 static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 {
 	int reg_val, ret;
@@ -41,6 +46,24 @@ static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 	return 0;
 }
 
+static struct i2c_device_id da9052_i2c_id[] = {
+	{"da9052", DA9052},
+	{"da9053-aa", DA9053_AA},
+	{"da9053-ba", DA9053_BA},
+	{"da9053-bb", DA9053_BB},
+	{}
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id dialog_dt_ids[] = {
+	{ .compatible = "dlg,da9052", .data = &da9052_i2c_id[0] },
+	{ .compatible = "dlg,da9053-aa", .data = &da9052_i2c_id[1] },
+	{ .compatible = "dlg,da9053-ab", .data = &da9052_i2c_id[2] },
+	{ .compatible = "dlg,da9053-bb", .data = &da9052_i2c_id[3] },
+	{ /* sentinel */ }
+};
+#endif
+
 static int __devinit da9052_i2c_probe(struct i2c_client *client,
 				       const struct i2c_device_id *id)
 {
@@ -76,6 +99,22 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_regmap;
 
+#ifdef CONFIG_OF
+	if (!id) {
+		struct device_node *np = client->dev.of_node;
+		const struct of_device_id *deviceid;
+
+		deviceid = of_match_node(np, dialog_dt_ids);
+		id = (const struct i2c_device_id *)deviceid->data;
+	}
+#endif
+
+	if (!id) {
+		ret = -ENODEV;
+		dev_err(&client->dev, "id is null.\n");
+		goto err_regmap;
+	}
+
 	ret = da9052_device_init(da9052, id->driver_data);
 	if (ret != 0)
 		goto err_regmap;
@@ -100,14 +139,6 @@ static int __devexit da9052_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id da9052_i2c_id[] = {
-	{"da9052", DA9052},
-	{"da9053-aa", DA9053_AA},
-	{"da9053-ba", DA9053_BA},
-	{"da9053-bb", DA9053_BB},
-	{}
-};
-
 static struct i2c_driver da9052_i2c_driver = {
 	.probe = da9052_i2c_probe,
 	.remove = __devexit_p(da9052_i2c_remove),
@@ -115,6 +146,9 @@ static struct i2c_driver da9052_i2c_driver = {
 	.driver = {
 		.name = "da9052",
 		.owner = THIS_MODULE,
+#ifdef CONFIG_OF
+		.of_match_table = dialog_dt_ids,
+#endif
 	},
 };
 
-- 
1.7.9.5

