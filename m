Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab2CBB3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:29:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48102 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab2CBB2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:28:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.225.39 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330651724.6247.3.camel@phoenix>
Subject: [PATCH] regulator: Add a pointer to aat2870_data in struct
 aat2870_regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 02 Mar 2012 09:28:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason we add *pdev in struct aat2870_regulator is to use it
to get a pointer to struct aat2870_data.
Save a pointer to struct aat2870_data instead of pdev in struct
aat2870_regulator, this change makes the intention more clear.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/aat2870-regulator.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 685ad43..9ed5c5d 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -31,7 +31,7 @@
 #include <linux/mfd/aat2870.h>
 
 struct aat2870_regulator {
-	struct platform_device *pdev;
+	struct aat2870_data *aat2870;
 	struct regulator_desc desc;
 
 	const int *voltages; /* uV */
@@ -60,7 +60,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
 				       unsigned selector)
 {
 	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	struct aat2870_data *aat2870 = ri->aat2870;
 
 	return aat2870->update(aat2870, ri->voltage_addr, ri->voltage_mask,
 			       selector << ri->voltage_shift);
@@ -69,7 +69,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
 static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	struct aat2870_data *aat2870 = ri->aat2870;
 	u8 val;
 	int ret;
 
@@ -83,7 +83,7 @@ static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
 static int aat2870_ldo_enable(struct regulator_dev *rdev)
 {
 	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	struct aat2870_data *aat2870 = ri->aat2870;
 
 	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask,
 			       ri->enable_mask);
@@ -92,7 +92,7 @@ static int aat2870_ldo_enable(struct regulator_dev *rdev)
 static int aat2870_ldo_disable(struct regulator_dev *rdev)
 {
 	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	struct aat2870_data *aat2870 = ri->aat2870;
 
 	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask, 0);
 }
@@ -100,7 +100,7 @@ static int aat2870_ldo_disable(struct regulator_dev *rdev)
 static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
 {
 	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
-	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	struct aat2870_data *aat2870 = ri->aat2870;
 	u8 val;
 	int ret;
 
@@ -185,7 +185,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
 		return -EINVAL;
 	}
-	ri->pdev = pdev;
+	ri->aat2870 = dev_get_drvdata(pdev->dev.parent);
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
 				  pdev->dev.platform_data, ri, NULL);
-- 
1.7.5.4



