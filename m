Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2FDE51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:57:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44770 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2FDE5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:57:06 -0400
Message-ID: <1338785818.9793.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: max1586: Convert max1586_v6_ops to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 04 Jun 2012 12:56:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index b9444ee..f215195 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -48,6 +48,14 @@ struct max1586_data {
 };
 
 /*
+ * V6 voltage
+ * On I2C bus, sending a "x" byte to the max1586 means :
+ *   set V6 to either 0V, 1.8V, 2.5V, 3V depending on (x & 0x3)
+ * As regulator framework doesn't accept voltages to be 0V, we use 1uV.
+ */
+static int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
+
+/*
  * V3 voltage
  * On I2C bus, sending a "x" byte to the max1586 means :
  *   set V3 to 0.700V + (x & 0x1f) * 0.025V
@@ -97,19 +105,6 @@ static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
 	return max1586_v3_calc_voltage(max1586, selector);
 }
 
-/*
- * V6 voltage
- * On I2C bus, sending a "x" byte to the max1586 means :
- *   set V6 to either 0V, 1.8V, 2.5V, 3V depending on (x & 0x3)
- * As regulator framework doesn't accept voltages to be 0V, we use 1uV.
- */
-static int max1586_v6_calc_voltage(unsigned selector)
-{
-	static int voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
-
-	return voltages_uv[selector];
-}
-
 static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 			  unsigned int *selector)
 {
@@ -130,23 +125,16 @@ static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	else if (min_uV >= 3000000)
 		*selector = 3;
 
-	if (max1586_v6_calc_voltage(*selector) > max_uV)
+	if (rdev->desc->volt_table[*selector] > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
-		max1586_v6_calc_voltage(*selector) / 1000);
+		rdev->desc->volt_table[*selector] / 1000);
 
 	v6_prog = I2C_V6_SELECT | (u8) *selector;
 	return i2c_smbus_write_byte(client, v6_prog);
 }
 
-static int max1586_v6_list(struct regulator_dev *rdev, unsigned selector)
-{
-	if (selector > MAX1586_V6_MAX_VSEL)
-		return -EINVAL;
-	return max1586_v6_calc_voltage(selector);
-}
-
 /*
  * The Maxim 1586 controls V3 and V6 voltages, but offers no way of reading back
  * the set up value.
@@ -158,7 +146,7 @@ static struct regulator_ops max1586_v3_ops = {
 
 static struct regulator_ops max1586_v6_ops = {
 	.set_voltage = max1586_v6_set,
-	.list_voltage = max1586_v6_list,
+	.list_voltage = regulator_list_voltage_table,
 };
 
 static const struct regulator_desc max1586_reg[] = {
@@ -176,6 +164,7 @@ static const struct regulator_desc max1586_reg[] = {
 		.ops = &max1586_v6_ops,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX1586_V6_MAX_VSEL + 1,
+		.volt_table = v6_voltages_uv,
 		.owner = THIS_MODULE,
 	},
 };
-- 
1.7.9.5



