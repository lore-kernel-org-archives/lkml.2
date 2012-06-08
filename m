Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2FHA0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:26:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62822 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2FHA0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:26:50 -0400
Message-ID: <1339115204.4310.4.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: max1586: Convert max1586_v3_ops to
 set_voltage_sel and map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 08:26:44 +0800
In-Reply-To: <1339115141.4310.3.camel@phoenix>
References: <1339115141.4310.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index a54771e..f67af3c 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -63,28 +63,17 @@ static int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
  * R24 and R25=100kOhm as described in the data sheet.
  * The gain is approximately: 1 + R24/R25 + R24/185.5kOhm
  */
-static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV,
-			  unsigned *selector)
+static int max1586_v3_set_voltage_sel(struct regulator_dev *rdev,
+				      unsigned selector)
 {
 	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
 	struct i2c_client *client = max1586->client;
-	unsigned range_uV = max1586->max_uV - max1586->min_uV;
 	u8 v3_prog;
 
-	if (min_uV > max1586->max_uV || max_uV < max1586->min_uV)
-		return -EINVAL;
-	if (min_uV < max1586->min_uV)
-		min_uV = max1586->min_uV;
-
-	*selector = DIV_ROUND_UP((min_uV - max1586->min_uV) *
-				 MAX1586_V3_MAX_VSEL, range_uV);
-	if (regulator_list_voltage_linear(rdev, *selector) > max_uV)
-		return -EINVAL;
-
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
-		regulator_list_voltage_linear(rdev, *selector) / 1000);
+		regulator_list_voltage_linear(rdev, selector) / 1000);
 
-	v3_prog = I2C_V3_SELECT | (u8) *selector;
+	v3_prog = I2C_V3_SELECT | (u8) selector;
 	return i2c_smbus_write_byte(client, v3_prog);
 }
 
@@ -106,8 +95,9 @@ static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
  * the set up value.
  */
 static struct regulator_ops max1586_v3_ops = {
-	.set_voltage = max1586_v3_set,
+	.set_voltage_sel = max1586_v3_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 };
 
 static struct regulator_ops max1586_v6_ops = {
-- 
1.7.9.5



