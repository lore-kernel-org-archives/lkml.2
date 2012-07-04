Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2GDPKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:10:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10793 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2GDPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:10:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 08:10:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob@landley.net>, <rob.herring@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] regulator: fixed: dt: support for input supply
Date: Wed, 4 Jul 2012 20:35:33 +0530
Message-ID: <1341414333-6359-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for input supply in DT parsing of node.
The input supply will be provided by the property
"vin-supply" in the regulator node.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Based on discussion on patch
[PATCH 2/2] regulator: fixed: dt: support for input supply
that the supply name should be passed through desc->supply_name
in both DT and non-DT case.
Making the change to have this.

 .../bindings/regulator/fixed-regulator.txt         |    2 ++
 drivers/regulator/fixed.c                          |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
index 2f5b6b1..4fae41d 100644
--- a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
@@ -10,6 +10,7 @@ Optional properties:
 If this property is missing, the default assumed is Active low.
 - gpio-open-drain: GPIO is open drain type.
   If this property is missing then default assumption is false.
+-vin-supply: Input supply name.
 
 Any property defined as part of the core regulator
 binding, defined in regulator.txt, can also be used.
@@ -29,4 +30,5 @@ Example:
 		enable-active-high;
 		regulator-boot-on;
 		gpio-open-drain;
+		vin-supply = <&parent_reg>;
 	};
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index b8c3a91..f56e575 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -45,13 +45,14 @@ struct fixed_voltage_data {
 /**
  * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
  * @dev: device requesting for fixed_voltage_config
+ * @vin_supply: pointer to store whether input supply is available or not.
  *
  * Populates fixed_voltage_config structure by extracting data from device
  * tree node, returns a pointer to the populated structure of NULL if memory
  * alloc fails.
  */
 static struct fixed_voltage_config *
-of_get_fixed_voltage_config(struct device *dev)
+of_get_fixed_voltage_config(struct device *dev, bool *vin_supply)
 {
 	struct fixed_voltage_config *config;
 	struct device_node *np = dev->of_node;
@@ -106,6 +107,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (of_find_property(np, "gpio-open-drain", NULL))
 		config->gpio_is_open_drain = true;
 
+	if (of_find_property(np, "vin-supply", NULL))
+		*vin_supply = true;
+
 	return config;
 }
 
@@ -184,13 +188,18 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata;
 	struct regulator_config cfg = { };
 	int ret;
+	const char *supply_reg = NULL;
 
 	if (pdev->dev.of_node) {
-		config = of_get_fixed_voltage_config(&pdev->dev);
+		bool vin_supply = false;
+		config = of_get_fixed_voltage_config(&pdev->dev, &vin_supply);
 		if (IS_ERR(config))
 			return PTR_ERR(config);
+		if (vin_supply)
+			supply_reg = "vin";
 	} else {
 		config = pdev->dev.platform_data;
+		supply_reg = config->init_data->supply_regulator;
 	}
 
 	if (!config)
@@ -213,6 +222,8 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
 
+	drvdata->desc.supply_name = supply_reg;
+
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
 
-- 
1.7.1.1

