Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3ACGcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:32:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49642 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3ACGcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:32:02 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] lp8788-buck: fix a parent device on devm_gpio_request()
Thread-Topic: [PATCH 2/5] lp8788-buck: fix a parent device on
 devm_gpio_request()
Thread-Index: Ac3pfAb/Xj6at6QsREWg08Ro+5uylA==
Date: Thu, 3 Jan 2013 06:31:57 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E11014@DQHE02.ent.ti.com>
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

 Use 'platform_device' rather than i2c client device node.
 Arguments are added in lp8788_init_dvs() and lp8788_dvs_gpio_request().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-buck.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 4916a55..98770e8 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -429,7 +429,8 @@ static struct regulator_desc lp8788_buck_desc[] = {
 	},
 };
 
-static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
+static int lp8788_dvs_gpio_request(struct platform_device *pdev,
+				struct lp8788_buck *buck,
 				enum lp8788_buck_id id)
 {
 	struct lp8788_platform_data *pdata = buck->lp->pdata;
@@ -440,7 +441,7 @@ static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 	switch (id) {
 	case BUCK1:
 		gpio = pdata->buck1_dvs->gpio;
-		ret = devm_gpio_request_one(buck->lp->dev, gpio, DVS_LOW,
+		ret = devm_gpio_request_one(&pdev->dev, gpio, DVS_LOW,
 					    b1_name);
 		if (ret)
 			return ret;
@@ -450,7 +451,7 @@ static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 	case BUCK2:
 		for (i = 0 ; i < LP8788_NUM_BUCK2_DVS ; i++) {
 			gpio = pdata->buck2_dvs->gpio[i];
-			ret = devm_gpio_request_one(buck->lp->dev, gpio,
+			ret = devm_gpio_request_one(&pdev->dev, gpio,
 						    DVS_LOW, b2_name[i]);
 			if (ret)
 				return ret;
@@ -464,7 +465,8 @@ static int lp8788_dvs_gpio_request(struct lp8788_buck *buck,
 	return 0;
 }
 
-static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
+static int lp8788_init_dvs(struct platform_device *pdev,
+			struct lp8788_buck *buck, enum lp8788_buck_id id)
 {
 	struct lp8788_platform_data *pdata = buck->lp->pdata;
 	u8 mask[] = { LP8788_BUCK1_DVS_SEL_M, LP8788_BUCK2_DVS_SEL_M };
@@ -483,7 +485,7 @@ static int lp8788_init_dvs(struct lp8788_buck *buck, enum lp8788_buck_id id)
 		(id == BUCK2 && !pdata->buck2_dvs))
 		goto set_default_dvs_mode;
 
-	if (lp8788_dvs_gpio_request(buck, id))
+	if (lp8788_dvs_gpio_request(pdev, buck, id))
 		goto set_default_dvs_mode;
 
 	return lp8788_update_bits(buck->lp, LP8788_BUCK_DVS_SEL, mask[id],
@@ -509,7 +511,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 
 	buck->lp = lp;
 
-	ret = lp8788_init_dvs(buck, id);
+	ret = lp8788_init_dvs(pdev, buck, id);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5


Best Regards,
Milo


