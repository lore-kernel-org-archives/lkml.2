Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2LHB46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:56:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34654 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530Ab2LHB45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:56:57 -0500
Message-ID: <1354931808.6623.0.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Kill _rdev_to_offset() function
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 08 Dec 2012 09:56:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one user calling _rdev_to_offset() function.
Remove _rdev_to_offset() makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp872x.c |   36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 9289ead..8e3c7ae 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -181,20 +181,6 @@ static inline int lp872x_update_bits(struct lp872x *lp, u8 addr,
 	return regmap_update_bits(lp->regmap, addr, mask, data);
 }
 
-static int _rdev_to_offset(struct regulator_dev *rdev)
-{
-	enum lp872x_regulator_id id = rdev_get_id(rdev);
-
-	switch (id) {
-	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
-		return id;
-	case LP8725_ID_LDO1 ... LP8725_ID_BUCK2:
-		return id - LP8725_ID_BASE;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int lp872x_get_timestep_usec(struct lp872x *lp)
 {
 	enum lp872x_id chip = lp->chipid;
@@ -234,28 +220,20 @@ static int lp872x_get_timestep_usec(struct lp872x *lp)
 static int lp872x_regulator_enable_time(struct regulator_dev *rdev)
 {
 	struct lp872x *lp = rdev_get_drvdata(rdev);
-	enum lp872x_regulator_id regulator = rdev_get_id(rdev);
+	enum lp872x_regulator_id rid = rdev_get_id(rdev);
 	int time_step_us = lp872x_get_timestep_usec(lp);
-	int ret, offset;
+	int ret;
 	u8 addr, val;
 
 	if (time_step_us < 0)
 		return -EINVAL;
 
-	switch (regulator) {
-	case LP8720_ID_LDO1 ... LP8720_ID_LDO5:
-	case LP8725_ID_LDO1 ... LP8725_ID_LILO2:
-		offset = _rdev_to_offset(rdev);
-		if (offset < 0)
-			return -EINVAL;
-
-		addr = LP872X_LDO1_VOUT + offset;
-		break;
-	case LP8720_ID_BUCK:
-		addr = LP8720_BUCK_VOUT1;
+	switch (rid) {
+	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
+		addr = LP872X_LDO1_VOUT + rid;
 		break;
-	case LP8725_ID_BUCK1:
-		addr = LP8725_BUCK1_VOUT1;
+	case LP8725_ID_LDO1 ... LP8725_ID_BUCK1:
+		addr = LP872X_LDO1_VOUT + rid - LP8725_ID_BASE;
 		break;
 	case LP8725_ID_BUCK2:
 		addr = LP8725_BUCK2_VOUT1;
-- 
1.7.9.5



