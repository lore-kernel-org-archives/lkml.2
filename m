Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2GOI5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:57:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2GOI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:57:22 -0400
Message-ID: <1342342632.2939.2.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Simplify implementation of
 lp872x_find_regulator_init_data()
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 15 Jul 2012 16:57:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass regulator id rahter than the index to lp872x_find_regulator_init_data(),
then the code can be simpler.
We can also get max_regulators by lp->num_regulators.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp872x.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 471f8e8..212c38e 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -796,30 +796,16 @@ static int lp872x_config(struct lp872x *lp)
 }
 
 static struct regulator_init_data
-*lp872x_find_regulator_init_data(int idx, struct lp872x *lp)
+*lp872x_find_regulator_init_data(int id, struct lp872x *lp)
 {
-	int i, base, id, max_regulators;
-
-	switch (lp->chipid) {
-	case LP8720:
-		base = LP8720_ID_BASE;
-		max_regulators = LP8720_NUM_REGULATORS;
-		break;
-	case LP8725:
-		base = LP8725_ID_BASE;
-		max_regulators = LP8725_NUM_REGULATORS;
-		break;
-	default:
-		return NULL;
-	}
+	int i;
 
-	id = base + idx;
-	for (i = 0 ; i < max_regulators ; i++)
+	for (i = 0; i < lp->num_regulators; i++) {
 		if (lp->pdata->regulator_data[i].id == id)
-			break;
+			return lp->pdata->regulator_data[i].init_data;
+	}
 
-	return (i == max_regulators) ? NULL :
-			lp->pdata->regulator_data[i].init_data;
+	return NULL;
 }
 
 static int lp872x_regulator_register(struct lp872x *lp)
@@ -834,7 +820,7 @@ static int lp872x_regulator_register(struct lp872x *lp)
 						&lp8725_regulator_desc[i];
 
 		cfg.dev = lp->dev;
-		cfg.init_data = lp872x_find_regulator_init_data(i, lp);
+		cfg.init_data = lp872x_find_regulator_init_data(desc->id, lp);
 		cfg.driver_data = lp;
 		cfg.regmap = lp->regmap;
 
-- 
1.7.9.5



