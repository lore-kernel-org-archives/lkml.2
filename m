Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab2GEMrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:47:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8179 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2GEMrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:47:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 05 Jul 2012 05:46:52 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <arnd@arndb.de>, <linus.walleij@linaro.org>, <lee.jones@linaro.org>,
        <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 REBASED] regulator: fixed: dt: support for input supply
Date: Thu, 5 Jul 2012 18:12:01 +0530
Message-ID: <1341492121-14049-1-git-send-email-ldewangan@nvidia.com>
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

Changes from V3:
There was conflict in applying patch and so rebasing this in Mark's for-next
and sending.

 .../bindings/regulator/fixed-regulator.txt         |    2 ++
 drivers/regulator/fixed.c                          |   19 ++++++++++++++++++-
 include/linux/regulator/fixed.h                    |    2 ++
 3 files changed, 22 insertions(+), 1 deletions(-)

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
index 1a0b17e..185468c 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -102,6 +102,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (of_find_property(np, "gpio-open-drain", NULL))
 		config->gpio_is_open_drain = true;
 
+	if (of_find_property(np, "vin-supply", NULL))
+		config->input_supply = "vin";
+
 	return config;
 }
 
@@ -169,6 +172,17 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->desc.enable_time = config->startup_delay;
 
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
 
@@ -202,7 +216,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_name;
+		goto err_input;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
@@ -212,6 +226,8 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_input:
+	kfree(drvdata->desc.supply_name);
 err_name:
 	kfree(drvdata->desc.name);
 err:
@@ -223,6 +239,7 @@ static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
 	regulator_unregister(drvdata->dev);
+	kfree(drvdata->desc.supply_name);
 	kfree(drvdata->desc.name);
 
 	return 0;
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

