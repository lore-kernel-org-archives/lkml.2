Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1G0Kdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:33:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41360 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1G0KdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:33:08 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 1/3] regulator: tps65023: Fixes i2c configuration issues
Date: Wed, 27 Jul 2011 12:32:45 +0200
Message-Id: <1311762767-20263-2-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original driver is missing the following:
* Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2
* Setting the GO bit in CTRL2 for updating the core voltage

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 701a590..d43533b 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -63,6 +63,13 @@
 #define TPS65023_REG_CTRL_LDO2_EN	BIT(2)
 #define TPS65023_REG_CTRL_LDO1_EN	BIT(1)
 
+/* REG_CTRL2 bitfields */
+#define TPS65023_REG_CTRL2_GO		BIT(7)
+#define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
+#define TPS65023_REG_CTRL2_DCDC2	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC1	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC3	BIT(0)
+
 /* LDO_CTRL bitfields */
 #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
 #define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
@@ -270,6 +277,7 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 	int vsel;
+	int ret;
 
 	if (dcdc != TPS65023_DCDC_1)
 		return -EINVAL;
@@ -293,10 +301,19 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	*selector = vsel;
 
 	/* write to the register in case we found a match */
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
@@ -475,6 +492,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, tps);
 
+	/* Enable setting output voltage by I2C */
+	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
+						TPS65023_REG_CTRL2_CORE_ADJ);
+
 	return 0;
 
  fail:
-- 
1.7.4.1

