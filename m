Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2F2QdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:33:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43890 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2F2QdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:33:22 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2] regulator: fixed: support deferred probe for DT GPIOs
Date: Fri, 29 Jun 2012 10:33:15 -0600
Message-Id: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

of_get_named_gpio() needs the driver hosting the GPIO that the DT
property references to have been probed. Detect this specific failure,
and defer the probe of the whole regulator until this API can complete.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Simplify the patch by returning ERR_PTR()s instead of a separate
defer_probe value.
---
 drivers/regulator/fixed.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 8bda365..b8c3a91 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -61,11 +61,11 @@ of_get_fixed_voltage_config(struct device *dev)
 	config = devm_kzalloc(dev, sizeof(struct fixed_voltage_config),
 								 GFP_KERNEL);
 	if (!config)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	config->init_data = of_get_regulator_init_data(dev, dev->of_node);
 	if (!config->init_data)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	init_data = config->init_data;
 	init_data->constraints.apply_uV = 0;
@@ -76,13 +76,26 @@ of_get_fixed_voltage_config(struct device *dev)
 	} else {
 		dev_err(dev,
 			 "Fixed regulator specified with variable voltages\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (init_data->constraints.boot_on)
 		config->enabled_at_boot = true;
 
 	config->gpio = of_get_named_gpio(np, "gpio", 0);
+	/*
+	 * of_get_named_gpio() currently returns ENODEV rather than
+	 * EPROBE_DEFER. This code attempts to be compatible with both
+	 * for now; the ENODEV check can be removed once the API is fixed.
+	 * of_get_named_gpio() doesn't differentiate between a missing
+	 * property (which would be fine here, since the GPIO is optional)
+	 * and some other error. Patches have been posted for both issues.
+	 * Once they are check in, we should replace this with:
+	 * if (config->gpio < 0 && config->gpio != -ENOENT)
+	 */
+	if ((config->gpio == -ENODEV) || (config->gpio == -EPROBE_DEFER))
+		return ERR_PTR(-EPROBE_DEFER);
+
 	delay = of_get_property(np, "startup-delay-us", NULL);
 	if (delay)
 		config->startup_delay = be32_to_cpu(*delay);
@@ -172,10 +185,13 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct regulator_config cfg = { };
 	int ret;
 
-	if (pdev->dev.of_node)
+	if (pdev->dev.of_node) {
 		config = of_get_fixed_voltage_config(&pdev->dev);
-	else
+		if (IS_ERR(config))
+			return PTR_ERR(config);
+	} else {
 		config = pdev->dev.platform_data;
+	}
 
 	if (!config)
 		return -ENOMEM;
-- 
1.7.0.4

