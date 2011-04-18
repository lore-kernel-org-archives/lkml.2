Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1DROK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:10:59 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58478 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1DROJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:55 -0400
X-ASG-Debug-ID: 1303135795-082e703e0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 13/14] regulator: check name in initialization of max8925
Subject: [PATCH 13/14] regulator: check name in initialization of max8925
Date: Mon, 18 Apr 2011 22:04:10 +0800
X-ASG-Orig-Subj: [PATCH 13/14] regulator: check name in initialization of max8925
Message-Id: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135795
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
 drivers/regulator/max8925-regulator.c |   39 ++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index e4dbd66..7ce8147 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -174,7 +174,7 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 #define MAX8925_SDV(_id, min, max, step)			\
 {								\
 	.desc	= {						\
-		.name	= "SDV" #_id,				\
+		.name	= "SD" #_id,				\
 		.ops	= &max8925_regulator_sdv_ops,		\
 		.type	= REGULATOR_VOLTAGE,			\
 		.id	= MAX8925_ID_SD##_id,			\
@@ -236,39 +236,38 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
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
+	if ((pdata == NULL) || (pdata->driver_data == NULL))
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
 		ri = &max8925_regulator_info[i];
-		if (ri->desc.id == id)
-			return ri;
+		/* pdata->driver_data stores the name of regulator */
+		if (!strcmp(ri->desc.name, pdata->driver_data))
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
 
+	/* replace driver_data with ri */
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

