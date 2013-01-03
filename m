Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3ACGcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:32:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39127 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3ACGcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:32:16 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] lp8788-ldo: fix a parent device in _probe()
Thread-Topic: [PATCH 4/5] lp8788-ldo: fix a parent device in _probe()
Thread-Index: Ac3pfA+JxiK55PGCT1C4kDsnWa97aQ==
Date: Thu, 3 Jan 2013 06:32:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E11024@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The lp8788-ldo is a platform driver of lp8788-mfd.
 The platform device is allocated when mfd_add_devices() is called
 in lp8788-mfd.
 On the other hand, 'lp->dev' is the i2c client device.

 Therefore, this 'platform_device' is a proper parent device in case of
 resource managed mem alloc, registering regulators and device kernel messages.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-ldo.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 3792741..40403e9 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -712,7 +712,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	int ret;
 
-	ldo = devm_kzalloc(lp->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
 	if (!ldo)
 		return -ENOMEM;
 
@@ -721,7 +721,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cfg.dev = lp->dev;
+	cfg.dev = pdev->dev.parent;
 	cfg.init_data = lp->pdata ? lp->pdata->dldo_data[id] : NULL;
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
@@ -729,7 +729,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	rdev = regulator_register(&lp8788_dldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
-		dev_err(lp->dev, "DLDO%d regulator register err = %d\n",
+		dev_err(&pdev->dev, "DLDO%d regulator register err = %d\n",
 				id + 1, ret);
 		return ret;
 	}
@@ -768,7 +768,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	int ret;
 
-	ldo = devm_kzalloc(lp->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
+	ldo = devm_kzalloc(&pdev->dev, sizeof(struct lp8788_ldo), GFP_KERNEL);
 	if (!ldo)
 		return -ENOMEM;
 
@@ -777,7 +777,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cfg.dev = lp->dev;
+	cfg.dev = pdev->dev.parent;
 	cfg.init_data = lp->pdata ? lp->pdata->aldo_data[id] : NULL;
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
@@ -785,7 +785,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	rdev = regulator_register(&lp8788_aldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
-		dev_err(lp->dev, "ALDO%d regulator register err = %d\n",
+		dev_err(&pdev->dev, "ALDO%d regulator register err = %d\n",
 				id + 1, ret);
 		return ret;
 	}
-- 
1.7.9.5


Best Regards,
Milo


