Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3ACGbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:31:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49613 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3ACGbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:31:14 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] lp8788-buck: fix a parent deivce in _probe()
Thread-Topic: [PATCH 1/5] lp8788-buck: fix a parent deivce in _probe()
Thread-Index: Ac3pe+Xn6u8aYOi4RzaZNl21eavUhg==
Date: Thu, 3 Jan 2013 06:31:02 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E11005@DQHE02.ent.ti.com>
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

 The lp8788-buck is a platform driver of lp8788-mfd.
 The platform device is allocated when mfd_add_devices() is called
 in lp8788-mfd.
 On the other hand, 'lp->dev' is the i2c client device.

 Therefore, this 'platform_device' is a proper parent device in case of
 resource managed mem alloc, registering a regulator and device kernel message.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-buck.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index aef3f2b..4916a55 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -503,7 +503,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	int ret;
 
-	buck = devm_kzalloc(lp->dev, sizeof(struct lp8788_buck), GFP_KERNEL);
+	buck = devm_kzalloc(&pdev->dev, sizeof(struct lp8788_buck), GFP_KERNEL);
 	if (!buck)
 		return -ENOMEM;
 
@@ -513,7 +513,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cfg.dev = lp->dev;
+	cfg.dev = pdev->dev.parent;
 	cfg.init_data = lp->pdata ? lp->pdata->buck_data[id] : NULL;
 	cfg.driver_data = buck;
 	cfg.regmap = lp->regmap;
@@ -521,7 +521,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	rdev = regulator_register(&lp8788_buck_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
-		dev_err(lp->dev, "BUCK%d regulator register err = %d\n",
+		dev_err(&pdev->dev, "BUCK%d regulator register err = %d\n",
 				id + 1, ret);
 		return ret;
 	}
-- 
1.7.9.5


Best Regards,
Milo


