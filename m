Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2IEEjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2IEEjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:23 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] regulator: lp872x: set the default DVS mode
Thread-Topic: [PATCH 2/5] regulator: lp872x: set the default DVS mode
Thread-Index: Ac2LIGfvswvmyc59ROiyRX1Mr3VR5A==
Date: Wed, 5 Sep 2012 04:39:16 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21D0@DQHE02.ent.ti.com>
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

 The lp872x driver has the DVS platform data which select the register address
 of the BUCK voltage.
 This patch enables updating the default DVS mode when the DVS platform data
 is not defined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index ddd60c6..d86b6a3 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -86,6 +86,10 @@
 #define EXTERN_DVS_USED			0
 #define MAX_DELAY			6
 
+/* Default DVS Mode */
+#define LP8720_DEFAULT_DVS		0
+#define LP8725_DEFAULT_DVS		BIT(2)
+
 /* dump registers in regmap-debugfs */
 #define MAX_REGISTERS			0x0F
 
@@ -750,8 +754,13 @@ static int lp872x_check_dvs_validity(struct lp872x *lp)
 static int lp872x_init_dvs(struct lp872x *lp)
 {
 	int ret, gpio;
-	struct lp872x_dvs *dvs = lp->pdata->dvs;
+	struct lp872x_dvs *dvs = lp->pdata ? lp->pdata->dvs : NULL;
 	enum lp872x_dvs_state pinstate;
+	u8 mask[] = { LP8720_EXT_DVS_M, LP8725_DVS1_M | LP8725_DVS2_M };
+	u8 default_dvs_mode[] = { LP8720_DEFAULT_DVS, LP8725_DEFAULT_DVS };
+
+	if (!dvs)
+		goto set_default_dvs_mode;
 
 	ret = lp872x_check_dvs_validity(lp);
 	if (ret) {
@@ -776,6 +785,10 @@ static int lp872x_init_dvs(struct lp872x *lp)
 	lp->dvs_gpio = gpio;
 
 	return 0;
+
+set_default_dvs_mode:
+	return lp872x_update_bits(lp, LP872X_GENERAL_CFG, mask[lp->chipid],
+				default_dvs_mode[lp->chipid]);
 }
 
 static int lp872x_config(struct lp872x *lp)
-- 
1.7.9.5


Best Regards,
Milo


