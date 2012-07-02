Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2GBKL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:11:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5781 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2GBKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:11:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 03:11:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] regulator: fixed: use devm_* for gpio request
Date: Mon, 2 Jul 2012 15:37:24 +0530
Message-ID: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* version of gpio APIs gpio_request_one() for
requesting gpios.
This avoid extra code for freeing gpios.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/fixed.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 8bda365..0a0baf3 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -235,7 +235,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 		if (config->gpio_is_open_drain)
 			gpio_flag |= GPIOF_OPEN_DRAIN;
 
-		ret = gpio_request_one(config->gpio, gpio_flag,
+		ret = devm_gpio_request_one(&pdev->dev, config->gpio, gpio_flag,
 						config->supply_name);
 		if (ret) {
 			dev_err(&pdev->dev,
@@ -259,7 +259,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_gpio;
+		goto err_name;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
@@ -269,9 +269,6 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_gpio:
-	if (gpio_is_valid(config->gpio))
-		gpio_free(config->gpio);
 err_name:
 	kfree(drvdata->desc.name);
 err:
@@ -283,8 +280,6 @@ static int __devexit reg_fixed_voltage_remove(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
 	regulator_unregister(drvdata->dev);
-	if (gpio_is_valid(drvdata->gpio))
-		gpio_free(drvdata->gpio);
 	kfree(drvdata->desc.name);
 
 	return 0;
-- 
1.7.1.1

