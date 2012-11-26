Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2KZH0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:26:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35243 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2KZH0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:26:47 -0500
Message-ID: <1353914801.11550.3.camel@phoenix>
Subject: [PATCH RFT] regulator: da9055: Select maximum current in specific
 range for set_current_limit
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 15:26:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting the minimal value is only true for voltage regulators.
For current regulators the maximum in the given range should be
selected instead.

This issue was reported by Heiko Stuebner for gpio-regulator driver [1],
and the conclusion is to select the max current for current regulators [2].

[1] https://lkml.org/lkml/2012/8/5/162
[2] https://lkml.org/lkml/2012/8/6/183

This patch also ensures da9055_buck_set_current_limit return -EINVAL when the
supported current limit does not meet the request range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9055-regulator.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 121564b..db59ce7 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -187,21 +187,18 @@ static int da9055_buck_set_current_limit(struct regulator_dev *rdev, int min_uA,
 {
 	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9055_regulator_info *info = regulator->info;
-	int i, val = 0;
-
-	if (min_uA > da9055_current_limits[DA9055_MAX_UA] ||
-	    max_uA < da9055_current_limits[DA9055_MIN_UA])
-		return -EINVAL;
+	int i;
 
-	for (i = 0; i < ARRAY_SIZE(da9055_current_limits); i++) {
-		if (min_uA <= da9055_current_limits[i]) {
-			val = i;
-			break;
-		}
+	for (i = ARRAY_SIZE(da9055_current_limits) - 1; i >= 0; i--) {
+		if ((min_uA <= da9055_current_limits[i]) &&
+		    (da9055_current_limits[i] <= max_uA))
+			return da9055_reg_update(regulator->da9055,
+						 DA9055_REG_BUCK_LIM,
+						 info->mode.mask,
+						 i << info->mode.shift);
 	}
 
-	return da9055_reg_update(regulator->da9055, DA9055_REG_BUCK_LIM,
-				info->mode.mask, val << info->mode.shift);
+	return -EINVAL;
 }
 
 static int da9055_list_voltage(struct regulator_dev *rdev, unsigned selector)
-- 
1.7.9.5



