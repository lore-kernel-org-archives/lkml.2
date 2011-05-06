Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1EFJ3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:29:14 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50596 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1EFJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:11 -0400
X-ASG-Debug-ID: 1304674150-082bcecf0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it,
        khali@linux-fr.org, ben-linux@fluff.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>
X-ASG-Orig-Subj: [PATCH 4/6] mfd: 88pm860x: avoid to use constraint name in regulator driver
Subject: [PATCH 4/6] mfd: 88pm860x: avoid to use constraint name in regulator driver
Date: Fri,  6 May 2011 17:21:23 +0800
X-ASG-Orig-Subj: [PATCH 4/6] mfd: 88pm860x: avoid to use constraint name in regulator driver
Message-Id: <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1304674150
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to use constraint name in regulator driver. So use regulator id is used
instead in platform driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/88pm860x-core.c  |   35 ++++++++---------------------------
 drivers/regulator/88pm8607.c |   25 +++++++++++++------------
 2 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 04ab50c..8e88fba 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -581,7 +581,7 @@ static void __devinit device_regulator_init(struct pm860x_chip *chip,
 {
 	struct regulator_init_data *initdata;
 	int ret;
-	int i, j;
+	int i, seq;
 
 	if ((pdata == NULL) || (pdata->regulator == NULL))
 		return;
@@ -589,40 +589,21 @@ static void __devinit device_regulator_init(struct pm860x_chip *chip,
 	if (pdata->num_regulators > ARRAY_SIZE(regulator_devs))
 		pdata->num_regulators = ARRAY_SIZE(regulator_devs);
 
-	for (i = 0, j = -1; i < pdata->num_regulators; i++) {
+	for (i = 0, seq = -1; i < pdata->num_regulators; i++) {
 		initdata = &pdata->regulator[i];
-		if (strstr(initdata->constraints.name, "BUCK")) {
-			sscanf(initdata->constraints.name, "BUCK%d", &j);
-			/* BUCK1 ~ BUCK3 */
-			if ((j < 1) || (j > 3)) {
-				dev_err(chip->dev, "Failed to add constraint "
-					"(%s)\n", initdata->constraints.name);
-				goto out;
-			}
-			j = (j - 1) + PM8607_ID_BUCK1;
-		}
-		if (strstr(initdata->constraints.name, "LDO")) {
-			sscanf(initdata->constraints.name, "LDO%d", &j);
-			/* LDO1 ~ LDO15 */
-			if ((j < 1) || (j > 15)) {
-				dev_err(chip->dev, "Failed to add constraint "
-					"(%s)\n", initdata->constraints.name);
-				goto out;
-			}
-			j = (j - 1) + PM8607_ID_LDO1;
-		}
-		if (j == -1) {
-			dev_err(chip->dev, "Failed to add constraint (%s)\n",
-				initdata->constraints.name);
+		seq = *(unsigned int *)initdata->driver_data;
+		if ((seq < 0) || (seq > PM8607_ID_RG_MAX)) {
+			dev_err(chip->dev, "Wrong ID(%d) on regulator(%s)\n",
+				seq, initdata->constraints.name);
 			goto out;
 		}
 		regulator_devs[i].platform_data = &pdata->regulator[i];
 		regulator_devs[i].pdata_size = sizeof(struct regulator_init_data);
 		regulator_devs[i].num_resources = 1;
-		regulator_devs[i].resources = &regulator_resources[j];
+		regulator_devs[i].resources = &regulator_resources[seq];
 
 		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
-				      &regulator_resources[j], 0);
+				      &regulator_resources[seq], 0);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add regulator subdev\n");
 			goto out;
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 784ea77..1904be9 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -398,32 +398,33 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm8607_regulator_info *info = NULL;
-	struct regulator_init_data *pdata;
+	struct regulator_init_data *pdata = pdev->dev.platform_data;
+	struct resource *res;
 	int i;
 
-	pdata = pdev->dev.platform_data;
-	if (pdata == NULL)
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource!\n");
 		return -EINVAL;
-
+	}
 	for (i = 0; i < ARRAY_SIZE(pm8607_regulator_info); i++) {
 		info = &pm8607_regulator_info[i];
-		if (!strcmp(info->desc.name, pdata->constraints.name))
+		if (info->desc.id == res->start)
 			break;
 	}
-	if (i > ARRAY_SIZE(pm8607_regulator_info)) {
-		dev_err(&pdev->dev, "Failed to find regulator %s\n",
-			pdata->constraints.name);
+	if ((i < 0) || (i > PM8607_ID_RG_MAX)) {
+		dev_err(&pdev->dev, "Failed to find regulator %d\n",
+			res->start);
 		return -EINVAL;
 	}
-
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->chip = chip;
 
 	/* check DVC ramp slope double */
-	if (!strcmp(info->desc.name, "BUCK3"))
-		if (info->chip->buck3_double)
-			info->slope_double = 1;
+	if ((i == PM8607_ID_BUCK3) && info->chip->buck3_double)
+		info->slope_double = 1;
 
+	/* replace driver_data with info */
 	info->regulator = regulator_register(&info->desc, &pdev->dev,
 					     pdata, info);
 	if (IS_ERR(info->regulator)) {
-- 
1.5.6.5

