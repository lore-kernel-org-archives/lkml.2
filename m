Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab2CUULg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:11:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758171Ab2CUUL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:11:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: fixed: Don't supply voltage change ops when no GPIO is given
Date: Wed, 21 Mar 2012 20:11:23 +0000
Message-Id: <1332360683-26231-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1332360683-26231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1332360683-26231-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than replicating the core support for always on regulators use
a different set of ops with none of the enable related operations provided
when we don't have any ops. This ensures that we automatically pick up
any enhanced support for such regulators that the core has such as the
warnings about regulation constraints that can't be used.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 7d4f381..8a1e22a 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -105,10 +105,8 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
-	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, data->enable_high);
-		data->is_enabled = true;
-	}
+	gpio_set_value_cansleep(data->gpio, data->enable_high);
+	data->is_enabled = true;
 
 	return 0;
 }
@@ -117,10 +115,8 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
-	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, !data->enable_high);
-		data->is_enabled = false;
-	}
+	gpio_set_value_cansleep(data->gpio, !data->enable_high);
+	data->is_enabled = false;
 
 	return 0;
 }
@@ -153,7 +149,7 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
 	return data->microvolts;
 }
 
-static struct regulator_ops fixed_voltage_ops = {
+static struct regulator_ops fixed_voltage_gpio_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
 	.disable = fixed_voltage_disable,
@@ -162,6 +158,11 @@ static struct regulator_ops fixed_voltage_ops = {
 	.list_voltage = fixed_voltage_list_voltage,
 };
 
+static struct regulator_ops fixed_voltage_ops = {
+	.get_voltage = fixed_voltage_get_voltage,
+	.list_voltage = fixed_voltage_list_voltage,
+};
+
 static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
 	struct fixed_voltage_config *config;
@@ -192,7 +193,6 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	}
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
-	drvdata->desc.ops = &fixed_voltage_ops;
 
 	if (config->microvolts)
 		drvdata->desc.n_voltages = 1;
@@ -242,11 +242,10 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 			goto err_gpio;
 		}
 
+		drvdata->desc.ops = &fixed_voltage_gpio_ops;
+
 	} else {
-		/* Regulator without GPIO control is considered
-		 * always enabled
-		 */
-		drvdata->is_enabled = true;
+		drvdata->desc.ops = &fixed_voltage_ops;
 	}
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
-- 
1.7.9.1

