Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab2IEEjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2IEEjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:22 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] regulator: lp872x: remove regulator platform data
 dependency
Thread-Topic: [PATCH 1/5] regulator: lp872x: remove regulator platform data
 dependency
Thread-Index: Ac2LIGPFZfbFkFO0SNCfXGDUOqXPnw==
Date: Wed, 5 Sep 2012 04:39:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21C8@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 This patch enables registering the regulator driver even though
 the regulator_init_data is not defined in the platform side.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 6199d0f..ddd60c6 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -796,11 +796,15 @@ static int lp872x_config(struct lp872x *lp)
 static struct regulator_init_data
 *lp872x_find_regulator_init_data(int id, struct lp872x *lp)
 {
+	struct lp872x_platform_data *pdata = lp->pdata;
 	int i;
 
+	if (!pdata)
+		return NULL;
+
 	for (i = 0; i < lp->num_regulators; i++) {
-		if (lp->pdata->regulator_data[i].id == id)
-			return lp->pdata->regulator_data[i].init_data;
+		if (pdata->regulator_data[i].id == id)
+			return pdata->regulator_data[i].init_data;
 	}
 
 	return NULL;
@@ -861,18 +865,12 @@ static const struct regmap_config lp872x_regmap_config = {
 static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp872x *lp;
-	struct lp872x_platform_data *pdata = cl->dev.platform_data;
 	int ret, size, num_regulators;
 	const int lp872x_num_regulators[] = {
 		[LP8720] = LP8720_NUM_REGULATORS,
 		[LP8725] = LP8725_NUM_REGULATORS,
 	};
 
-	if (!pdata) {
-		dev_err(&cl->dev, "no platform data\n");
-		return -EINVAL;
-	}
-
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
 	if (!lp)
 		goto err_mem;
@@ -892,7 +890,7 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	}
 
 	lp->dev = &cl->dev;
-	lp->pdata = pdata;
+	lp->pdata = cl->dev.platform_data;
 	lp->chipid = id->driver_data;
 	lp->num_regulators = num_regulators;
 	i2c_set_clientdata(cl, lp);
-- 
1.7.9.5


Best Regards,
Milo

