Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab2C1HAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:00:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2C1HAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:00:41 -0400
Message-ID: <1332918036.19101.3.camel@phoenix>
Subject: [PATCH 3/4] regulator: Convert 88pm8607 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Wed, 28 Mar 2012 15:00:36 +0800
In-Reply-To: <1332917909.19101.1.camel@phoenix>
References: <1332917909.19101.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |   43 +++--------------------------------------
 1 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 81b6659..7fafff2 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -223,51 +223,16 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return ret;
 }
 
-static int choose_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-	int i, ret = -ENOENT;
-
-	if (info->slope_double) {
-		min_uV = min_uV >> 1;
-		max_uV = max_uV >> 1;
-	}
-	if (info->vol_table) {
-		for (i = 0; i < rdev->desc->n_voltages; i++) {
-			if (!info->vol_table[i])
-				break;
-			if ((min_uV <= info->vol_table[i])
-				&& (max_uV >= info->vol_table[i])) {
-				ret = i;
-				break;
-			}
-		}
-	}
-	if (ret < 0)
-		pr_err("invalid voltage range (%d %d) uV\n", min_uV, max_uV);
-	return ret;
-}
-
-static int pm8607_set_voltage(struct regulator_dev *rdev,
-			      int min_uV, int max_uV, unsigned *selector)
+static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	uint8_t val, mask;
 	int ret;
 
-	if (min_uV > max_uV) {
-		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
-		return -EINVAL;
-	}
-
-	ret = choose_voltage(rdev, min_uV, max_uV);
-	if (ret < 0)
-		return -EINVAL;
-	*selector = ret;
-	val = (uint8_t)(ret << info->vol_shift);
+	val = (uint8_t)(selector << info->vol_shift);
 	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
 
-	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, val);
+	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, selector);
 	if (ret)
 		return ret;
 	switch (info->desc.id) {
@@ -328,7 +293,7 @@ static int pm8607_is_enabled(struct regulator_dev *rdev)
 
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
-	.set_voltage	= pm8607_set_voltage,
+	.set_voltage_sel = pm8607_set_voltage_sel,
 	.get_voltage	= pm8607_get_voltage,
 	.enable		= pm8607_enable,
 	.disable	= pm8607_disable,
-- 
1.7.5.4



