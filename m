Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2GEHHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:07:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19082 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2GEHHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:07:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Jul 2012 00:07:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3] regulator: fixed: dt: support for input supply
Date: Thu, 5 Jul 2012 12:31:48 +0530
Message-ID: <1341471708-1225-1-git-send-email-ldewangan@nvidia.com>
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

Changes from V2:
Add input_supply in the platform data and initialzing it with
"vin" in dt case. In non-dt case, this will be set through platform 
data. Then making copy of this to the desc->supply_name to
pass the input supply regulator.

 .../bindings/regulator/fixed-regulator.txt         |    2 ++
 drivers/regulator/fixed.c                          |   18 +++++++++++++++++-
 include/linux/regulator/fixed.h                    |    2 ++
 3 files changed, 21 insertions(+), 1 deletions(-)

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
index b8c3a91..b98f0b0 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -106,6 +106,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (of_find_property(np, "gpio-open-drain", NULL))
 		config->gpio_is_open_drain = true;
 
+	if (of_find_property(np, "vin-supply", NULL))
+		config->input_supply = "vin";
+
 	return config;
 }
 
@@ -213,6 +216,17 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
 
+	if (config->input_supply) {
+		drvdata->desc.supply_name = kstrdup(config->input_supply,
+							GFP_KERNEL);
+		if (!drvdata->desc.supply_name) {
+			dev_err(&pdev->dev,
+				"Failed to allocate input supply\n");
+			ret = -ENOMEM;
+			goto err_name;
+		}
+	}
+
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
 
@@ -257,7 +271,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 			   "Could not obtain regulator enable GPIO %d: %d\n",
 							config->gpio, ret);
-			goto err_name;
+			goto err_input;
 		}
 
 		drvdata->desc.ops = &fixed_voltage_gpio_ops;
@@ -288,6 +302,8 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 err_gpio:
 	if (gpio_is_valid(config->gpio))
 		gpio_free(config->gpio);
+err_input:
+	kfree(drvdata->desc.supply_name);
 err_name:
 	kfree(drvdata->desc.name);
 err:
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 680f24e..48918be 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -22,6 +22,7 @@ struct regulator_init_data;
 /**
  * struct fixed_voltage_config - fixed_voltage_config structure
  * @supply_name:	Name of the regulator supply
+ * @input_supply:	Name of the input regulator supply
  * @microvolts:		Output voltage of regulator
  * @gpio:		GPIO to use for enable control
  * 			set to -EINVAL if not used
@@ -46,6 +47,7 @@ struct regulator_init_data;
  */
 struct fixed_voltage_config {
 	const char *supply_name;
+	const char *input_supply;
 	int microvolts;
 	int gpio;
 	unsigned startup_delay;
-- 
1.7.1.1

