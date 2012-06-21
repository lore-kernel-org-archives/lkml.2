Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2FUIEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:04:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34214 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2FUID4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:03:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [PATCH 2/3] regulator: replace devm_gpio_request_one() for loaded
 module
Thread-Topic: [PATCH 2/3] regulator: replace devm_gpio_request_one() for
 loaded module
Thread-Index: Ac1PhGMjyZ3CPb4zRn6jJ06Ift3+vQ==
Date: Thu, 21 Jun 2012 08:03:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC052@DQHE02.ent.ti.com>
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

At this moment, devm_gpio_request_one() has not been exported yet.
But lp872x driver can be used as a module, so related functions should be changed.

devm_gpio_request_one() -> gpio_request_one() and gpio_free()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index e8f54ef..daaa0ed 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -768,7 +768,7 @@ static int lp872x_init_dvs(struct lp872x *lp)
 	}
 
 	pinstate = dvs->init_state;
-	ret = devm_gpio_request_one(lp->dev, gpio, pinstate, "LP872X DVS");
+	ret = gpio_request_one(gpio, pinstate, "LP872X DVS");
 	if (ret) {
 		dev_err(lp->dev, "gpio request err: %d\n", ret);
 		return ret;
@@ -780,6 +780,12 @@ static int lp872x_init_dvs(struct lp872x *lp)
 	return 0;
 }
 
+static void lp872x_deinit_dvs(struct lp872x *lp)
+{
+	if (lp->dvs_gpio)
+		gpio_free(lp->dvs_gpio);
+}
+
 static int lp872x_config(struct lp872x *lp)
 {
 	struct lp872x_platform_data *pdata = lp->pdata;
@@ -917,10 +923,16 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (ret)
 		goto err_dev;
 
-	return lp872x_regulator_register(lp);
+	ret = lp872x_regulator_register(lp);
+	if (ret)
+		goto err_reg;
+
+	return 0;
 
 err_mem:
 	return -ENOMEM;
+err_reg:
+	lp872x_deinit_dvs(lp);
 err_dev:
 	return ret;
 }
@@ -930,6 +942,7 @@ static int __devexit lp872x_remove(struct i2c_client *cl)
 	struct lp872x *lp = i2c_get_clientdata(cl);
 
 	lp872x_regulator_unregister(lp);
+	lp872x_deinit_dvs(lp);
 	return 0;
 }
 
-- 
1.7.2.5


Best Regards,
Milo (Woogyom) Kim


