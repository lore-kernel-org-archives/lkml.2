Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab2GMCMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 22:12:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41143 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab2GMCMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 22:12:46 -0400
Message-ID: <1342145560.19496.5.camel@phoenix>
Subject: [PATCH] regulator: s2mps11: Use array to save pointer to rdev
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 10:12:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of regulator is known at compile time, use array to save pointer to
rdev makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s2mps11.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 4669dc9..926f9c8 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/samsung/s2mps11.h>
 
 struct s2mps11_info {
-	struct regulator_dev **rdev;
+	struct regulator_dev *rdev[S2MPS11_REGULATOR_MAX];
 
 	int ramp_delay2;
 	int ramp_delay34;
@@ -236,9 +236,8 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct regulator_config config = { };
-	struct regulator_dev **rdev;
 	struct s2mps11_info *s2mps11;
-	int i, ret, size;
+	int i, ret;
 	unsigned char ramp_enable, ramp_reg = 0;
 
 	if (!pdata) {
@@ -251,13 +250,6 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	if (!s2mps11)
 		return -ENOMEM;
 
-	size = sizeof(struct regulator_dev *) * S2MPS11_REGULATOR_MAX;
-	s2mps11->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!s2mps11->rdev) {
-		return -ENOMEM;
-	}
-
-	rdev = s2mps11->rdev;
 	platform_set_drvdata(pdev, s2mps11);
 
 	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
@@ -297,12 +289,12 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s2mps11;
 
-		rdev[i] = regulator_register(&regulators[i], &config);
-		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
+		s2mps11->rdev[i] = regulator_register(&regulators[i], &config);
+		if (IS_ERR(s2mps11->rdev[i])) {
+			ret = PTR_ERR(s2mps11->rdev[i]);
 			dev_err(&pdev->dev, "regulator init failed for %d\n",
 				i);
-			rdev[i] = NULL;
+			s2mps11->rdev[i] = NULL;
 			goto err;
 		}
 	}
@@ -310,8 +302,7 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	return 0;
 err:
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
+		regulator_unregister(s2mps11->rdev[i]);
 
 	return ret;
 }
@@ -319,12 +310,10 @@ err:
 static int __devexit s2mps11_pmic_remove(struct platform_device *pdev)
 {
 	struct s2mps11_info *s2mps11 = platform_get_drvdata(pdev);
-	struct regulator_dev **rdev = s2mps11->rdev;
 	int i;
 
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
+		regulator_unregister(s2mps11->rdev[i]);
 
 	return 0;
 }
-- 
1.7.9.5



