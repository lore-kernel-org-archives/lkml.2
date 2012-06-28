Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2F1Wbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:31:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42249 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F1Wbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:31:40 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regulator: fixed: support deferred probe for DT GPIOs
Date: Thu, 28 Jun 2012 16:31:32 -0600
Message-Id: <1340922692-24092-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

of_get_named_gpio() needs the driver hosting the GPIO that the DT
property references to have been probed. Detect this specific failure,
and defer the probe of the whole regulator until this API can complete.

Note that of_get_named_gpio() currently returns -ENODEV in this case,
but a patch has been sent to make it return -EPROBE_DEFER. Hence, this
patch checks both so that it works with/without the other patch.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/fixed.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 8bda365..1acd60a 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -51,13 +51,15 @@ struct fixed_voltage_data {
  * alloc fails.
  */
 static struct fixed_voltage_config *
-of_get_fixed_voltage_config(struct device *dev)
+of_get_fixed_voltage_config(struct device *dev, bool *defer_probe)
 {
 	struct fixed_voltage_config *config;
 	struct device_node *np = dev->of_node;
 	const __be32 *delay;
 	struct regulator_init_data *init_data;
 
+	*defer_probe = false;
+
 	config = devm_kzalloc(dev, sizeof(struct fixed_voltage_config),
 								 GFP_KERNEL);
 	if (!config)
@@ -83,6 +85,11 @@ of_get_fixed_voltage_config(struct device *dev)
 		config->enabled_at_boot = true;
 
 	config->gpio = of_get_named_gpio(np, "gpio", 0);
+	if ((config->gpio == -ENODEV) || (config->gpio == -EPROBE_DEFER)) {
+		*defer_probe = true;
+		return NULL;
+	}
+
 	delay = of_get_property(np, "startup-delay-us", NULL);
 	if (delay)
 		config->startup_delay = be32_to_cpu(*delay);
@@ -167,15 +174,19 @@ static struct regulator_ops fixed_voltage_ops = {
 
 static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
+	bool defer_probe;
 	struct fixed_voltage_config *config;
 	struct fixed_voltage_data *drvdata;
 	struct regulator_config cfg = { };
 	int ret;
 
-	if (pdev->dev.of_node)
-		config = of_get_fixed_voltage_config(&pdev->dev);
-	else
+	if (pdev->dev.of_node) {
+		config = of_get_fixed_voltage_config(&pdev->dev, &defer_probe);
+		if (defer_probe)
+			return -EPROBE_DEFER;
+	} else {
 		config = pdev->dev.platform_data;
+	}
 
 	if (!config)
 		return -ENOMEM;
-- 
1.7.0.4

