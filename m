Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2KGJmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:42:22 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56591 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab2KGJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:42:20 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 5/7] mfd: max8925: support dt for regulator
Date: Wed,  7 Nov 2012 17:42:55 +0800
Message-Id: <1352281375-17056-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 07 Nov 2012 09:42:11.0267 (UTC) FILETIME=[291C1930:01CDBCCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 .../bindings/regulator/max8925-regulator.txt       |   29 ++++++++
 drivers/regulator/max8925-regulator.c              |   72 +++++++++++++++++++-
 2 files changed, 98 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8925-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8925-regulator.txt b/Documentation/devicetree/bindings/regulator/max8925-regulator.txt
new file mode 100644
index 0000000..073b41d
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8925-regulator.txt
@@ -0,0 +1,29 @@
+Max8925 Voltage regulators
+
+max8925 regulator device register is still handled by mfd_add_devices, not by
+of_xxx, so, it is not necessary to add compatible name. Also, those reg
+offset and id info is stored in mfd_cell(see max8925-core.c), as a result
+there is not private properties in dts.
+
+node's name should match with the definition in max8925_regulator_matches
+(see max8925-regulator.c)
+
+
+Optional properties:
+- Any optional property defined in bindings/regulator/regulator.txt
+
+
+Example:
+
+
+	regulators {
+		SDV1 {
+			regulator-min-microvolt = <637500>;
+			regulator-max-microvolt = <1425000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		...
+		...
+	}
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 9bb0be3..5e84921 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -17,6 +17,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/mfd/max8925.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
 
 #define SD1_DVM_VMIN		850000
 #define SD1_DVM_VMAX		1000000
@@ -187,6 +189,34 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 	.enable_reg	= MAX8925_LDOCTL##_id,			\
 }
 
+#ifdef CONFIG_OF
+static struct of_regulator_match max8925_regulator_matches[] = {
+	{ .name	= "SDV1",},
+	{ .name = "SDV2",},
+	{ .name = "SDV3",},
+	{ .name = "LDO1",},
+	{ .name = "LDO2",},
+	{ .name = "LDO3",},
+	{ .name = "LDO4",},
+	{ .name = "LDO5",},
+	{ .name = "LDO6",},
+	{ .name = "LDO7",},
+	{ .name = "LDO8",},
+	{ .name = "LDO9",},
+	{ .name = "LDO10",},
+	{ .name = "LDO11",},
+	{ .name = "LDO12",},
+	{ .name = "LDO13",},
+	{ .name = "LDO14",},
+	{ .name = "LDO15",},
+	{ .name = "LDO16",},
+	{ .name = "LDO17",},
+	{ .name = "LDO18",},
+	{ .name = "LDO19",},
+	{ .name = "LDO20",},
+};
+#endif
+
 static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_SDV(1, 637.5, 1425, 12.5),
 	MAX8925_SDV(2,   650, 2225,   25),
@@ -214,6 +244,36 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_LDO(20, 750, 3900, 50),
 };
 
+#ifdef CONFIG_OF
+static int max8925_regulator_dt_init(struct platform_device *pdev,
+				    struct max8925_regulator_info *info,
+				    struct regulator_config *config,
+				    int ridx)
+{
+	struct device_node *nproot, *np;
+	int rcount;
+	nproot = pdev->dev.parent->of_node;
+	if (!nproot)
+		return -ENODEV;
+	np = of_find_node_by_name(nproot, "regulators");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find regulators node\n");
+		return -ENODEV;
+	}
+
+	rcount = of_regulator_match(&pdev->dev, np,
+				&max8925_regulator_matches[ridx], 1);
+	if (rcount < 0)
+		return -ENODEV;
+	config->init_data =	max8925_regulator_matches[ridx].init_data;
+	config->of_node = max8925_regulator_matches[ridx].of_node;
+
+	return 0;
+}
+#else
+#define max8925_regulator_dt_init(x, y, z)	(-1)
+#endif
+
 static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -222,7 +282,7 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	struct max8925_regulator_info *ri;
 	struct resource *res;
 	struct regulator_dev *rdev;
-	int i;
+	int i, regulator_idx;
 
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
@@ -231,9 +291,12 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	}
 	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
 		ri = &max8925_regulator_info[i];
-		if (ri->vol_reg == res->start)
+		if (ri->vol_reg == res->start) {
+			regulator_idx = i;
 			break;
+		}
 	}
+
 	if (i == ARRAY_SIZE(max8925_regulator_info)) {
 		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
 			(unsigned long long)res->start);
@@ -243,9 +306,12 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	ri->chip = chip;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdata;
 	config.driver_data = ri;
 
+	if (max8925_regulator_dt_init(pdev, ri, &config, regulator_idx))
+		if (pdata)
+			config.init_data = pdata;
+
 	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-- 
1.7.0.4

