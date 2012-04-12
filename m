Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab2DLPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:40:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41188 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934404Ab2DLPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:40:03 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, broonie@opensource.wolfsonmicro.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: [PATCH 1/2] mfd: da9052: add device-tree support for i2c driver
Date: Thu, 12 Apr 2012 23:39:41 +0800
Message-Id: <1334245182-31725-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

This patch adds device-tree support for dialog MFD and the binding
documentations.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 .../devicetree/bindings/mfd/da9052-i2c.txt         |   58 ++++++++++++++++++++
 drivers/mfd/da9052-i2c.c                           |   54 +++++++++++++++---
 2 files changed, 104 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9052-i2c.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9052-i2c.txt b/Documentation/devicetree/bindings/mfd/da9052-i2c.txt
new file mode 100644
index 0000000..042d042
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9052-i2c.txt
@@ -0,0 +1,58 @@
+* Dialog DA9052/53 Power Management Integrated Circuit (PMIC)
+
+Required properties:
+- compatible : Should be "dialog,da9052", "dialog,da9053-aa",
+			 "dialog,da9053-ab", or "dialog,da9053-bb"
+
+Sub-nodes:
+- regulators : Contain the regulator nodes.  The DA9052 regulators are
+  sorted as following:
+
+    buck_core : regulator BUCK_CORE (id: 0 )
+    buck_pro  : regulator BUCK_PRO  (id: 1 )
+    buck_mem  : regulator BUCK_MEM  (id: 2 )
+    buck_peri : regulator BUCK_PERI (id: 3 )
+    ldo1      : regulator LDO1	    (id: 4 )
+    ldo2      : regulator LDO2	    (id: 5 )
+    ldo3      : regulator LDO3	    (id: 6 )
+    ldo4      : regulator LDO4	    (id: 7 )
+    ldo5      : regulator LDO5	    (id: 8 )
+    ldo6      : regulator LDO6	    (id: 9 )
+    ldo7      : regulator LDO7	    (id: 10)
+    ldo8      : regulator LDO8	    (id: 11)
+    ldo9      : regulator LDO9	    (id: 12)
+    ldo10     : regulator LDO10     (id: 13)
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
+		compatible = "dialog,da9053-aa";
+		reg = <0x48>;
+
+		regulators {
+			regulator-buck0 {
+				regulator-name = "DA9052_BUCK_CORE";
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			regulator-buck1 {
+				regulator-name = "DA9052_BUCK_PRO";
+				regulator-min-microvolt = <500000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			regulator-buck2 {
+				regulator-name = "DA9052_BUCK_MEM";
+				regulator-min-microvolt = <925000>;
+				regulator-max-microvolt = <2500000>;
+			};
+		};
+	};
+};
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 36b88e3..e07bcfa 100644
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
+	{ .compatible = "dialog,da9052" },
+	{ .compatible = "dialog,da9053-aa" },
+	{ .compatible = "dialog,da9053-ab" },
+	{ .compatible = "dialog,da9053-bb" },
+	{ /* sentinel */ }
+};
+#endif
+
 static int __devinit da9052_i2c_probe(struct i2c_client *client,
 				       const struct i2c_device_id *id)
 {
@@ -76,6 +99,26 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_regmap;
 
+#ifdef CONFIG_OF
+	if (!id) {
+		int i;
+		struct device_node *np = client->dev.of_node;
+
+		for (i = 0;
+		     i < sizeof(dialog_dt_ids)/sizeof(dialog_dt_ids[0]);
+		     i++)
+			if (of_device_is_compatible(np,
+						dialog_dt_ids[i].compatible))
+				id = &da9052_i2c_id[i];
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
@@ -100,14 +143,6 @@ static int __devexit da9052_i2c_remove(struct i2c_client *client)
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
@@ -115,6 +150,9 @@ static struct i2c_driver da9052_i2c_driver = {
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

