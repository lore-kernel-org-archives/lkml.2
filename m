Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab2FHEDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:03:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62993 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2FHEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:03:14 -0400
Message-ID: <1339128184.8259.1.camel@phoenix>
Subject: [PATCH] regulator: max77686: Check pdata->num_regulators earlier
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 08 Jun 2012 12:03:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this driver only works when pdata->num_regulators == MAX77686_REGULATORS,
let's check it earlier.

Also remove unused num_regulators from struct max77686_data.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max77686.c |   43 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index b76a038..b0c146d 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -65,7 +65,6 @@ enum max77686_ramp_rate {
 struct max77686_data {
 	struct device *dev;
 	struct max77686_dev *iodev;
-	int num_regulators;
 	struct regulator_dev **rdev;
 	int ramp_delay; /* in mV/us */
 };
@@ -235,6 +234,12 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
+	if (!pdata || pdata->num_regulators != MAX77686_REGULATORS) {
+		dev_err(&pdev->dev,
+			"Invalid initial data for regulator's initialiation\n");
+		return -EINVAL;
+	}
+
 	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
 				GFP_KERNEL);
 	if (!max77686)
@@ -248,8 +253,6 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 	rdev = max77686->rdev;
 	max77686->dev = &pdev->dev;
 	max77686->iodev = iodev;
-	if (pdata)
-		max77686->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, max77686);
 
 	max77686->ramp_delay = RAMP_RATE_NO_CTRL; /* Set 0x3 for RAMP */
@@ -263,34 +266,26 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 			MAX77686_REG_BUCK4CTRL1, MAX77686_RAMP_RATE_MASK,
 			max77686->ramp_delay << 6);
 
-	if (pdata->num_regulators == MAX77686_REGULATORS) {
-		for (i = 0; i < MAX77686_REGULATORS; i++) {
-			config.dev = max77686->dev;
-			config.regmap = iodev->regmap;
-			config.driver_data = max77686;
-			config.init_data = pdata->regulators[i].initdata;
-
-			rdev[i] = regulator_register(&regulators[i], &config);
-
-			if (IS_ERR(rdev[i])) {
-				ret = PTR_ERR(rdev[i]);
-				dev_err(max77686->dev,
+	for (i = 0; i < MAX77686_REGULATORS; i++) {
+		config.dev = max77686->dev;
+		config.regmap = iodev->regmap;
+		config.driver_data = max77686;
+		config.init_data = pdata->regulators[i].initdata;
+
+		rdev[i] = regulator_register(&regulators[i], &config);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(max77686->dev,
 				"regulator init failed for %d\n", i);
 				rdev[i] = NULL;
 				goto err;
-			}
 		}
-	} else {
-		dev_err(max77686->dev,
-			 "Lack of initial data for regulator's initialiation\n");
-		return -EINVAL;
 	}
+
 	return 0;
 err:
-	for (i = 0; i < MAX77686_REGULATORS; i++) {
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-	}
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
 	return ret;
 }
 
-- 
1.7.9.5



