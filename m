Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2BVSG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:06:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58547 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2BVSGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:06:20 -0500
Date: Wed, 22 Feb 2012 19:06:21 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/3] max17042_battery: Preserve properties outside of platform
 data
In-reply-to: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbou@mail.ru, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1329933982-2529-3-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fields originally found in platform data back to max17042_chip,
as the former data structure might be not available on device
tree-based systems.

This commit makes it possible to safely declare platform data with
__initdata tag.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17042_battery.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 21a3650..49c1377 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -33,7 +33,8 @@
 struct max17042_chip {
 	struct i2c_client *client;
 	struct power_supply battery;
-	struct max17042_platform_data *pdata;
+	bool enable_current_sense;
+	u32 r_sns;
 };
 
 static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
@@ -168,7 +169,7 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval = val->intval * 10 / 256;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		if (chip->pdata->enable_current_sense) {
+		if (chip->enable_current_sense) {
 			ret = max17042_read_reg(chip->client, MAX17042_Current);
 			if (ret < 0)
 				return ret;
@@ -180,13 +181,13 @@ static int max17042_get_property(struct power_supply *psy,
 				val->intval++;
 				val->intval *= -1;
 			}
-			val->intval *= 1562500 / chip->pdata->r_sns;
+			val->intval *= 1562500 / chip->r_sns;
 		} else {
 			return -EINVAL;
 		}
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
-		if (chip->pdata->enable_current_sense) {
+		if (chip->enable_current_sense) {
 			ret = max17042_read_reg(chip->client,
 						MAX17042_AvgCurrent);
 			if (ret < 0)
@@ -199,7 +200,7 @@ static int max17042_get_property(struct power_supply *psy,
 				val->intval++;
 				val->intval *= -1;
 			}
-			val->intval *= 1562500 / chip->pdata->r_sns;
+			val->intval *= 1562500 / chip->r_sns;
 		} else {
 			return -EINVAL;
 		}
@@ -215,6 +216,7 @@ static int __devinit max17042_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct max17042_chip *chip;
+	struct max17042_platform_data *pdata;
 	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
@@ -225,7 +227,7 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
-	chip->pdata = client->dev.platform_data;
+	pdata = client->dev.platform_data;
 
 	i2c_set_clientdata(client, chip);
 
@@ -235,13 +237,21 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	chip->battery.properties	= max17042_battery_props;
 	chip->battery.num_properties	= ARRAY_SIZE(max17042_battery_props);
 
+	if (pdata) {
+		chip->r_sns = pdata->r_sns;
+		chip->enable_current_sense = pdata->enable_current_sense;
+	} else {
+		dev_warn(&client->dev, "no driver data provided\n");
+		return -ENODEV;
+	}
+
 	/* When current is not measured,
 	 * CURRENT_NOW and CURRENT_AVG properties should be invisible. */
-	if (!chip->pdata->enable_current_sense)
+	if (!chip->enable_current_sense)
 		chip->battery.num_properties -= 2;
 
-	if (chip->pdata->r_sns == 0)
-		chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
+	if (chip->r_sns == 0)
+		chip->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
 
 	ret = power_supply_register(&client->dev, &chip->battery);
 	if (ret) {
@@ -250,11 +260,11 @@ static int __devinit max17042_probe(struct i2c_client *client,
 	}
 
 	/* Initialize registers according to values from the platform data */
-	if (chip->pdata->init_data)
-		max17042_set_reg(client, chip->pdata->init_data,
-				 chip->pdata->num_init_data);
+	if (pdata && pdata->init_data)
+		max17042_set_reg(client, pdata->init_data,
+				 pdata->num_init_data);
 
-	if (!chip->pdata->enable_current_sense) {
+	if (!chip->enable_current_sense) {
 		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
 		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
 		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
-- 
1.7.8.3

