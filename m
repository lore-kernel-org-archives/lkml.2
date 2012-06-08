Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab2FHA0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:26:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35197 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2FHAZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:25:47 -0400
Message-ID: <1339115141.4310.3.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: max1586: Convert max1586_v3_ops to
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 08:25:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 126c7d8..a54771e 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -63,14 +63,6 @@ static int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
  * R24 and R25=100kOhm as described in the data sheet.
  * The gain is approximately: 1 + R24/R25 + R24/185.5kOhm
  */
-static int max1586_v3_calc_voltage(struct max1586_data *max1586,
-	unsigned selector)
-{
-	unsigned range_uV = max1586->max_uV - max1586->min_uV;
-
-	return max1586->min_uV + (selector * range_uV / MAX1586_V3_MAX_VSEL);
-}
-
 static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 			  unsigned *selector)
 {
@@ -86,25 +78,16 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 
 	*selector = DIV_ROUND_UP((min_uV - max1586->min_uV) *
 				 MAX1586_V3_MAX_VSEL, range_uV);
-	if (max1586_v3_calc_voltage(max1586, *selector) > max_uV)
+	if (regulator_list_voltage_linear(rdev, *selector) > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
-		max1586_v3_calc_voltage(max1586, *selector) / 1000);
+		regulator_list_voltage_linear(rdev, *selector) / 1000);
 
 	v3_prog = I2C_V3_SELECT | (u8) *selector;
 	return i2c_smbus_write_byte(client, v3_prog);
 }
 
-static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
-{
-	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
-
-	if (selector > MAX1586_V3_MAX_VSEL)
-		return -EINVAL;
-	return max1586_v3_calc_voltage(max1586, selector);
-}
-
 static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
 				      unsigned int selector)
 {
@@ -124,7 +107,7 @@ static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
  */
 static struct regulator_ops max1586_v3_ops = {
 	.set_voltage = max1586_v3_set,
-	.list_voltage = max1586_v3_list,
+	.list_voltage = regulator_list_voltage_linear,
 };
 
 static struct regulator_ops max1586_v6_ops = {
@@ -132,7 +115,7 @@ static struct regulator_ops max1586_v6_ops = {
 	.list_voltage = regulator_list_voltage_table,
 };
 
-static const struct regulator_desc max1586_reg[] = {
+static struct regulator_desc max1586_reg[] = {
 	{
 		.name = "Output_V3",
 		.id = MAX1586_V3,
@@ -185,6 +168,13 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 			goto err;
 		}
 
+		if (id == MAX1586_V3) {
+			max1586_reg[id].min_uV = max1586->min_uV;
+			max1586_reg[id].uV_step =
+					(max1586->max_uV - max1586->min_uV) /
+					MAX1586_V3_MAX_VSEL;
+		}
+
 		config.dev = &client->dev;
 		config.init_data = pdata->subdevs[i].platform_data;
 		config.driver_data = max1586;
-- 
1.7.9.5



