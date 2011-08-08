Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1HHSag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:30:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41400 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab1HHSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:30:32 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 2/4] regulator: tps65023: Set missing bit for update core-voltage
Date: Mon,  8 Aug 2011 20:29:33 +0200
Message-Id: <1312828175-11999-3-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312828175-11999-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1312828175-11999-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the GO bit in CTRL2 for updating the core voltage

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 7bd3c4d..1011470 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -277,6 +277,7 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 	int vsel;
+	int ret;
 
 	if (dcdc != TPS65023_DCDC_1)
 		return -EINVAL;
@@ -299,11 +300,21 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 
 	*selector = vsel;
 
-	/* write to the register in case we found a match */
 	if (vsel == tps->info[dcdc]->table_len)
-		return -EINVAL;
-	else
-		return tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
+		goto failed;
+
+	ret = tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
+
+	/* Tell the chip that we have changed the value in DEFCORE
+	 * and its time to update the core voltage
+	 */
+	tps_65023_set_bits(tps, TPS65023_REG_CON_CTRL2,
+						TPS65023_REG_CTRL2_GO);
+
+	return ret;
+
+failed:
+	return -EINVAL;
 }
 
 static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
-- 
1.7.4.1

