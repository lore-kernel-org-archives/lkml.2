Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2DJFvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:51:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2DJFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:51:11 -0400
Message-ID: <1334037066.15859.5.camel@phoenix>
Subject: [PATCH 3/3] regulator: Fix build error for mc13783 and mc13892
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 13:51:06 +0800
In-Reply-To: <1334036844.15859.1.camel@phoenix>
References: <1334036844.15859.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mc13783 and mc13892 to use a struct to pass in regulator runtime
configuration.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |   12 +++++++++---
 drivers/regulator/mc13892-regulator.c |    8 ++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 6c0face..7dcdfa2 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -340,6 +340,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx_regulator_platform_data *pdata =
 		dev_get_platdata(&pdev->dev);
 	struct mc13xxx_regulator_init_data *init_data;
+	struct regulator_config config = { };
 	int i, ret;
 
 	dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
@@ -357,11 +358,16 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 	priv->mc13xxx = mc13783;
 
 	for (i = 0; i < pdata->num_regulators; i++) {
+		struct regulator_desc *desc;
+
 		init_data = &pdata->regulators[i];
-		priv->regulators[i] = regulator_register(
-				&mc13783_regulators[init_data->id].desc,
-				&pdev->dev, init_data->init_data, priv, NULL);
+		desc = &mc13783_regulators[init_data->id].desc;
+
+		config.dev = &pdev->dev;
+		config.init_data = init_data->init_data;
+		config.driver_data = priv;
 
+		priv->regulators[i] = regulator_register(desc, &config);
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 				mc13783_regulators[i].desc.name);
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 8830807..970a233 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -519,6 +519,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx_regulator_platform_data *pdata =
 		dev_get_platdata(&pdev->dev);
 	struct mc13xxx_regulator_init_data *mc13xxx_data;
+	struct regulator_config config = { };
 	int i, ret;
 	int num_regulators = 0;
 	u32 val;
@@ -588,9 +589,12 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 		}
 		desc = &mc13892_regulators[id].desc;
 
-		priv->regulators[i] = regulator_register(
-			desc, &pdev->dev, init_data, priv, node);
+		config.dev = &pdev->dev;
+		config.init_data = init_data;
+		config.driver_data = priv;
+		config.of_node = node;
 
+		priv->regulators[i] = regulator_register(desc, &config);
 		if (IS_ERR(priv->regulators[i])) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 				mc13892_regulators[i].desc.name);
-- 
1.7.5.4



