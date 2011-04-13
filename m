Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1DMO4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:56:33 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:41566 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab1DMO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:56:12 -0400
X-ASG-Debug-ID: 1302706572-082d4b820001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
X-ASG-Orig-Subj: [PATCH 12/13] regulator: check name in initialization of max8925
Subject: [PATCH 12/13] regulator: check name in initialization of max8925
Date: Wed, 13 Apr 2011 22:51:03 +0800
X-ASG-Orig-Subj: [PATCH 12/13] regulator: check name in initialization of max8925
Message-Id: <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
References: <2011041301>
 <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302706572
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check name in initialization of max8925 regulator driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8925-regulator.c |   37 +++++++++++++++-----------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 8ae1475..ce821e4 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -169,7 +169,7 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 #define MAX8925_SDV(_id, min, max, step)			\
 {								\
 	.desc	= {						\
-		.name	= "SDV" #_id,				\
+		.name	= "SD" #_id,				\
 		.ops	= &max8925_regulator_sdv_ops,		\
 		.type	= REGULATOR_VOLTAGE,			\
 		.id	= MAX8925_ID_SD##_id,			\
@@ -231,39 +231,36 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_LDO(20, 750, 3900, 50),
 };
 
-static struct max8925_regulator_info * __devinit find_regulator_info(int id)
+static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
-	struct max8925_regulator_info *ri;
+	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
+	struct max8925_regulator_info *ri = NULL;
+	struct regulator_init_data *pdata;
+	struct regulator_dev *rdev;
 	int i;
 
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
 		ri = &max8925_regulator_info[i];
-		if (ri->desc.id == id)
-			return ri;
+		if (!strcmp(ri->desc.name, pdata->constraints.name))
+			break;
 	}
-	return NULL;
-}
-
-static int __devinit max8925_regulator_probe(struct platform_device *pdev)
-{
-	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct max8925_platform_data *pdata = chip->dev->platform_data;
-	struct max8925_regulator_info *ri;
-	struct regulator_dev *rdev;
-
-	ri = find_regulator_info(pdev->id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	if (i > ARRAY_SIZE(max8925_regulator_info)) {
+		dev_err(&pdev->dev, "Failed to find regulator %s\n",
+			pdata->constraints.name);
 		return -EINVAL;
 	}
 	ri->i2c = chip->i2c;
 	ri->chip = chip;
 
 	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdata->regulator[pdev->id], ri);
+				  pdata, ri);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				ri->desc.name);
+			ri->desc.name);
 		return PTR_ERR(rdev);
 	}
 
-- 
1.5.6.5

