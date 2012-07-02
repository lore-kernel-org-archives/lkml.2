Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GBKL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:11:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5782 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2GBKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:11:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 02 Jul 2012 03:11:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: fixed: dt: support for input supply
Date: Mon, 2 Jul 2012 15:37:25 +0530
Message-ID: <1341223645-7817-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com>
References: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com>
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
 .../bindings/regulator/fixed-regulator.txt         |    2 ++
 drivers/regulator/fixed.c                          |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

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
index 0a0baf3..8633e21 100644
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
@@ -93,6 +94,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (of_find_property(np, "gpio-open-drain", NULL))
 		config->gpio_is_open_drain = true;
 
+	if (of_find_property(np, "vin-supply", NULL))
+		*vin_supply = true;
+
 	return config;
 }
 
@@ -171,9 +175,10 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata;
 	struct regulator_config cfg = { };
 	int ret;
+	bool vin_supply = false;
 
 	if (pdev->dev.of_node)
-		config = of_get_fixed_voltage_config(&pdev->dev);
+		config = of_get_fixed_voltage_config(&pdev->dev , &vin_supply);
 	else
 		config = pdev->dev.platform_data;
 
@@ -197,6 +202,9 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
 
+	if (vin_supply)
+		drvdata->desc.supply_name = "vin";
+
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
 
-- 
1.7.1.1

