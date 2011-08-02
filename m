Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1HBLAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:00:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1HBLAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:00:03 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 2/4] regulator: tps65023: Set missing bit for update core-voltage
Date: Tue,  2 Aug 2011 12:59:32 +0200
Message-Id: <1312282774-30880-3-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312282774-30880-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1312282774-30880-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the GO bit in CTRL2 for updating the core voltage

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index a81abd4..8bd41fa 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -277,6 +277,7 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 	int vsel;
+	int ret;
 
 	if (dcdc != TPS65023_DCDC_1)
 		return -EINVAL;
@@ -299,11 +300,19 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 
 	*selector = vsel;
 
-	/* write to the register in case we found a match */
-	if (vsel == tps->info[dcdc]->table_len)
-		return -EINVAL;
-	else
-		return tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
+	if (vsel == tps->info[dcdc]->table_len) {
+		ret = -EINVAL;
+	} else {
+		ret = tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
+
+		/* Tell the chip that we have changed the value in DEFCORE
+		 * and its time to update the core voltage
+		 */
+		tps_65023_set_bits(tps, TPS65023_REG_CON_CTRL2,
+							TPS65023_REG_CTRL2_GO);
+	}
+
+	return ret;
 }
 
 static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
-- 
1.7.4.1

