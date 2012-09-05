Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2IEEjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53265 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab2IEEjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:39 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] regulator: lp872x: fix NULL pointer access problem
Thread-Topic: [PATCH 4/5] regulator: lp872x: fix NULL pointer access problem
Thread-Index: Ac2LIHGy1PFTymxvTRu2wjBSIhDNmw==
Date: Wed, 5 Sep 2012 04:39:33 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21E0@DQHE02.ent.ti.com>
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

 The lp872x_set_dvs() is used for changing the DVS pin state.
 This function works only when the DVS platform data is defined.
 So don't assume that DVS data is always valid.
 In case the platform data is not defined, the DVS data is set to NULL
 for skipping the DVS pin control.

 DVS selection and GPIO pin number are used for the LP872x DVS pin control.
 For better readability, DVS selection argument is added in lp872x_set_dvs().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index b16a941..86485e8 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -273,9 +273,9 @@ static int lp872x_regulator_enable_time(struct regulator_dev *rdev)
 	return val > MAX_DELAY ? 0 : val * time_step_us;
 }
 
-static void lp872x_set_dvs(struct lp872x *lp, int gpio)
+static void lp872x_set_dvs(struct lp872x *lp, enum lp872x_dvs_sel dvs_sel,
+			int gpio)
 {
-	enum lp872x_dvs_sel dvs_sel = lp->pdata->dvs->vsel;
 	enum lp872x_dvs_state state;
 
 	state = dvs_sel == SEL_V1 ? DVS_HIGH : DVS_LOW;
@@ -343,10 +343,10 @@ static int lp872x_buck_set_voltage_sel(struct regulator_dev *rdev,
 	struct lp872x *lp = rdev_get_drvdata(rdev);
 	enum lp872x_regulator_id buck = rdev_get_id(rdev);
 	u8 addr, mask = LP872X_VOUT_M;
-	struct lp872x_dvs *dvs = lp->pdata->dvs;
+	struct lp872x_dvs *dvs = lp->pdata ? lp->pdata->dvs : NULL;
 
 	if (dvs && gpio_is_valid(dvs->gpio))
-		lp872x_set_dvs(lp, dvs->gpio);
+		lp872x_set_dvs(lp, dvs->vsel, dvs->gpio);
 
 	addr = lp872x_select_buck_vout_addr(lp, buck);
 	if (!lp872x_is_valid_buck_addr(addr))
-- 
1.7.9.5


Best Regards,
Milo


