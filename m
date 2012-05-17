Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2EQFGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:06:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2EQFG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:06:29 -0400
Message-ID: <1337231178.22713.2.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: ab3100: Use
 regulator_map_voltage_iterate()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 17 May 2012 13:06:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_map_voltage_iterate() is for drivers implementing set_voltage_sel()
and list_voltage() to use it as their map_voltage() operation.

In this case, regulator_map_voltage_iterate() happen to be doing the same thing
as ab3100_get_best_voltage_index() function. So we can use it to replace
ab3100_get_best_voltage_index() function.


Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   35 +----------------------------------
 1 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index e2062ad..03f4d9c 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -304,39 +304,6 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 	return abreg->typ_voltages[regval];
 }
 
-static int ab3100_get_best_voltage_index(struct regulator_dev *reg,
-				   int min_uV, int max_uV)
-{
-	struct ab3100_regulator *abreg = reg->reg_data;
-	int i;
-	int bestmatch;
-	int bestindex;
-
-	/*
-	 * Locate the minimum voltage fitting the criteria on
-	 * this regulator. The switchable voltages are not
-	 * in strict falling order so we need to check them
-	 * all for the best match.
-	 */
-	bestmatch = INT_MAX;
-	bestindex = -1;
-	for (i = 0; i < abreg->voltages_len; i++) {
-		if (abreg->typ_voltages[i] <= max_uV &&
-		    abreg->typ_voltages[i] >= min_uV &&
-		    abreg->typ_voltages[i] < bestmatch) {
-			bestmatch = abreg->typ_voltages[i];
-			bestindex = i;
-		}
-	}
-
-	if (bestindex < 0) {
-		dev_warn(&reg->dev, "requested %d<=x<=%d uV, out of range!\n",
-			 min_uV, max_uV);
-		return -EINVAL;
-	}
-	return bestindex;
-}
-
 static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
 					    unsigned selector)
 {
@@ -383,7 +350,7 @@ static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
 		return -EINVAL;
 
 	/* LDO E and BUCK have special suspend voltages you can set */
-	bestindex = ab3100_get_best_voltage_index(reg, uV, uV);
+	bestindex = regulator_map_voltage_iterate(reg, uV, uV);
 
 	err = abx500_get_register_interruptible(abreg->dev, 0,
 						targetreg, &regval);
-- 
1.7.5.4



