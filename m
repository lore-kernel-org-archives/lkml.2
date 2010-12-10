Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0LJKKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:10:31 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:59319 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab0LJKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:10:29 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 6/9] regulators: Modified ab8500 error handling
Date: Fri, 10 Dec 2010 11:08:45 +0100
Message-ID: <1291975728-12525-7-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling is updated to catch NULL pointer errors.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |   53 +++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ccb0bfd..2a15b63 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -100,12 +100,13 @@ static const int ldo_vintcore_voltages[] = {
 
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
@@ -118,12 +119,13 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 
 static int ab8500_regulator_disable(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
@@ -136,13 +138,14 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 
 static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 value;
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_get_register_interruptible(info->dev,
 		info->update_bank, info->update_reg, &value);
@@ -160,12 +163,12 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 
 static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 {
-	int regulator_id;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	/* return the uV for the fixed regulators */
 	if (info->fixed_uV)
@@ -179,13 +182,14 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 
 static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	u8 value;
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_get_register_interruptible(info->dev, info->voltage_bank,
 		info->voltage_reg, &value);
@@ -197,7 +201,7 @@ static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 
 	/* vintcore has a different layout */
 	value &= info->voltage_mask;
-	if (regulator_id == AB8500_LDO_INTCORE)
+	if (info->desc.id == AB8500_LDO_INTCORE)
 		ret = info->voltages[value >> 0x3];
 	else
 		ret = info->voltages[value];
@@ -225,12 +229,13 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 					int min_uV, int max_uV,
 					unsigned *selector)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	/* get the appropriate voltages within the range */
 	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
@@ -264,12 +269,12 @@ static struct regulator_ops ab8500_regulator_ops = {
 
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
 {
-	int regulator_id;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	return info->fixed_uV;
 }
@@ -368,6 +373,10 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	pdata = dev_get_platdata(ab8500->dev);
+	if (!pdata) {
+		dev_err(&pdev->dev, "null pdata\n");
+		return -EINVAL;
+	}
 
 	/* make sure the platform data has the correct size */
 	if (pdata->num_regulator != ARRAY_SIZE(ab8500_regulator_info)) {
-- 
1.7.2.2

