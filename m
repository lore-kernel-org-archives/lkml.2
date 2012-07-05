Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2GED7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GED7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:39 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 6/6] regulator: max77686: Add device tree support.
Date: Thu,  5 Jul 2012 09:28:25 +0530
Message-Id: <1341460705-10868-6-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch device tree support for regulator driver. It uses the parent
(mfd's) DT node to parse the regulator data for max77686.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |   58 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 23f956a..fc695eb 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
 
@@ -233,6 +234,50 @@ static struct regulator_desc regulators[] = {
 	regulator_desc_buck(9),
 };
 
+#ifdef CONFIG_OF
+static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+					struct max77686_platform_data *pdata)
+{
+	struct device_node *pmic_np, *regulators_np;
+	struct max77686_regulator_data *rdata;
+	struct of_regulator_match rmatch;
+	unsigned int i;
+
+	pmic_np = iodev->dev->of_node;
+	regulators_np = of_find_node_by_name(pmic_np, "voltage-regulators");
+	if (!regulators_np) {
+		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	pdata->num_regulators = ARRAY_SIZE(regulators);
+	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+			     pdata->num_regulators, GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev,
+			"could not allocate memory for regulator data\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		rmatch.name = regulators[i].name;
+		rmatch.init_data = NULL;
+		of_regulator_match(iodev->dev, regulators_np, &rmatch, 1);
+		rdata[i].initdata = rmatch.init_data;
+	}
+
+	pdata->regulators = rdata;
+
+	return 0;
+}
+#else
+static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+					struct max77686_platform_data *pdata)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -245,7 +290,18 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
-	if (!pdata || pdata->num_regulators != MAX77686_REGULATORS) {
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data found for regulator\n");
+		return -ENODEV;
+	}
+
+	if (iodev->dev->of_node) {
+		ret = max77686_pmic_dt_parse_pdata(iodev, pdata);
+		if (ret)
+			return ret;
+	}
+
+	if (pdata->num_regulators != MAX77686_REGULATORS) {
 		dev_err(&pdev->dev,
 			"Invalid initial data for regulator's initialiation\n");
 		return -EINVAL;
-- 
1.7.0.4

