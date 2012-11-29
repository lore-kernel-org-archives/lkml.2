Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab2K2FNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:13:30 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39767 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2K2FN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:13:29 -0500
Message-ID: <1354166000.15490.2.camel@phoenix>
Subject: [PATCH RFT] regulator: max1586: Implement get_voltage_sel callback
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Thu, 29 Nov 2012 13:13:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required since commit f7df20ec32
"regulator: core: Use list_voltage() to read single voltage regulators",
otherwise _regulator_get_voltage returns rdev->desc->ops->list_voltage(rdev, 0).

The Maxim 1586 controls V3 and V6 voltages, but offers no way of reading back
the set up value. Thus this patch caches the setting when setting new voltage.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max1586.c |   44 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 3a035ec..98ffa0d 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -44,6 +44,9 @@ struct max1586_data {
 	unsigned int min_uV;
 	unsigned int max_uV;
 
+	unsigned int v3_curr_sel;
+	unsigned int v6_curr_sel;
+
 	struct regulator_dev *rdev[0];
 };
 
@@ -63,31 +66,60 @@ static int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
  * R24 and R25=100kOhm as described in the data sheet.
  * The gain is approximately: 1 + R24/R25 + R24/185.5kOhm
  */
+static int max1586_v3_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
+
+	return regulator_list_voltage_linear(rdev, max1586->v3_curr_sel);
+}
+
 static int max1586_v3_set_voltage_sel(struct regulator_dev *rdev,
 				      unsigned selector)
 {
 	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
 	struct i2c_client *client = max1586->client;
+	int ret;
 	u8 v3_prog;
 
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
 		regulator_list_voltage_linear(rdev, selector) / 1000);
 
 	v3_prog = I2C_V3_SELECT | (u8) selector;
-	return i2c_smbus_write_byte(client, v3_prog);
+	ret = i2c_smbus_write_byte(client, v3_prog);
+	if (ret)
+		return ret;
+
+	max1586->v3_curr_sel = selector;
+
+	return 0;
+}
+
+static int max1586_v6_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
+
+	return regulator_list_voltage_table(rdev, max1586->v6_curr_sel);
 }
 
 static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
 				      unsigned int selector)
 {
-	struct i2c_client *client = rdev_get_drvdata(rdev);
+	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
+	struct i2c_client *client = max1586->client;
 	u8 v6_prog;
+	int ret;
 
 	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
 		rdev->desc->volt_table[selector] / 1000);
 
 	v6_prog = I2C_V6_SELECT | (u8) selector;
-	return i2c_smbus_write_byte(client, v6_prog);
+	ret = i2c_smbus_write_byte(client, v6_prog);
+	if (ret)
+		return ret;
+
+	max1586->v6_curr_sel = selector;
+
+	return 0;
 }
 
 /*
@@ -95,12 +127,14 @@ static int max1586_v6_set_voltage_sel(struct regulator_dev *rdev,
  * the set up value.
  */
 static struct regulator_ops max1586_v3_ops = {
+	.get_voltage_sel = max1586_v3_get_voltage_sel,
 	.set_voltage_sel = max1586_v3_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
 
 static struct regulator_ops max1586_v6_ops = {
+	.get_voltage_sel = max1586_v6_get_voltage_sel,
 	.set_voltage_sel = max1586_v6_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
 };
@@ -148,6 +182,10 @@ static int max1586_pmic_probe(struct i2c_client *client,
 	max1586->min_uV = MAX1586_V3_MIN_UV / 1000 * pdata->v3_gain / 1000;
 	max1586->max_uV = MAX1586_V3_MAX_UV / 1000 * pdata->v3_gain / 1000;
 
+	/* Set curr_sel to default voltage on power-up */
+	max1586->v3_curr_sel = 24; /* 1.3V */
+	max1586->v6_curr_sel = 0;
+
 	rdev = max1586->rdev;
 	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
 		id = pdata->subdevs[i].id;
-- 
1.7.9.5



