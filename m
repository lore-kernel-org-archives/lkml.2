Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1AMSud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:50:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17284 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1AMSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:50:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Jan 2011 10:40:03 -0800
From: rklein@nvidia.com
To: cbouatmailru@gmail.com
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/1] power: bq20z75: add support for charge properties
Date: Thu, 13 Jan 2011 10:50:13 -0800
Message-Id: <1294944613-11006-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Adding support for charge properties for gas gauge.
Also ensuring that battery mode is correct now for energy as well as
charge properties by setting it on the fly.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |  107 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 492da27..f397866 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -38,11 +38,22 @@ enum {
 	REG_CYCLE_COUNT,
 	REG_SERIAL_NUMBER,
 	REG_REMAINING_CAPACITY,
+	REG_REMAINING_CAPACITY_CHARGE,
 	REG_FULL_CHARGE_CAPACITY,
+	REG_FULL_CHARGE_CAPACITY_CHARGE,
 	REG_DESIGN_CAPACITY,
+	REG_DESIGN_CAPACITY_CHARGE,
 	REG_DESIGN_VOLTAGE,
 };
 
+/* Battery Mode defines */
+#define BATTERY_MODE_OFFSET		0x03
+#define BATTERY_MODE_MASK		0x8000
+enum bq20z75_battery_mode {
+	BATTERY_MODE_AMPS,
+	BATTERY_MODE_WATTS
+};
+
 /* manufacturer access defines */
 #define MANUFACTURER_ACCESS_STATUS	0x0006
 #define MANUFACTURER_ACCESS_SLEEP	0x0011
@@ -78,8 +89,12 @@ static const struct bq20z75_device_data {
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
 	[REG_REMAINING_CAPACITY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
+	[REG_REMAINING_CAPACITY_CHARGE] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_NOW, 0x0F, 0, 65535),
 	[REG_FULL_CHARGE_CAPACITY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
+	[REG_FULL_CHARGE_CAPACITY_CHARGE] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL, 0x10, 0, 65535),
 	[REG_TIME_TO_EMPTY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0,
 			65535),
@@ -93,6 +108,9 @@ static const struct bq20z75_device_data {
 	[REG_DESIGN_CAPACITY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0,
 			65535),
+	[REG_DESIGN_CAPACITY_CHARGE] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, 0x18, 0,
+			65535),
 	[REG_DESIGN_VOLTAGE] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0,
 			65535),
@@ -117,6 +135,9 @@ static enum power_supply_property bq20z75_properties[] = {
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 };
 
 struct bq20z75_info {
@@ -260,6 +281,9 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 		val->intval *= BASE_UNIT_CONVERSION;
 		break;
 
@@ -281,11 +305,53 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 	}
 }
 
+static enum bq20z75_battery_mode
+bq20z75_set_battery_mode(struct i2c_client *client,
+	enum bq20z75_battery_mode mode)
+{
+	int ret, originalVal;
+
+	originalVal = bq20z75_read_word_data(client, BATTERY_MODE_OFFSET);
+	if (originalVal < 0)
+		return originalVal;
+
+	if ((originalVal & BATTERY_MODE_MASK) == mode)
+		return mode;
+
+	if (mode == BATTERY_MODE_AMPS)
+		ret = originalVal & ~BATTERY_MODE_MASK;
+	else
+		ret = originalVal | BATTERY_MODE_MASK;
+
+	ret = bq20z75_write_word_data(client, BATTERY_MODE_OFFSET, ret);
+	if (ret < 0)
+		return ret;
+
+	return originalVal & BATTERY_MODE_MASK;
+}
+
+#define PROP_NEEDS_AMPS(PSP) \
+	((PSP == POWER_SUPPLY_PROP_CHARGE_NOW) || \
+	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL) || \
+	 (PSP == POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN))
+
+#define PROP_NEEDS_WATTS(PSP) \
+	((PSP == POWER_SUPPLY_PROP_ENERGY_NOW) || \
+	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL) || \
+	 (PSP == POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN))
 static int bq20z75_get_battery_capacity(struct i2c_client *client,
 	int reg_offset, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
 	s32 ret;
+	enum bq20z75_battery_mode mode = BATTERY_MODE_WATTS;
+
+	if (PROP_NEEDS_AMPS(psp))
+		mode = BATTERY_MODE_AMPS;
+
+	mode = bq20z75_set_battery_mode(client, mode);
+	if (mode < 0)
+		return mode;
 
 	ret = bq20z75_read_word_data(client, bq20z75_data[reg_offset].addr);
 	if (ret < 0)
@@ -298,6 +364,10 @@ static int bq20z75_get_battery_capacity(struct i2c_client *client,
 	} else
 		val->intval = ret;
 
+	ret = bq20z75_set_battery_mode(client, mode);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -318,11 +388,25 @@ static int bq20z75_get_battery_serial_number(struct i2c_client *client,
 	return 0;
 }
 
+static int bq20z75_get_property_index(struct i2c_client *client,
+	enum power_supply_property psp)
+{
+	int count;
+	for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++)
+		if (psp == bq20z75_data[count].psp)
+			return count;
+
+	dev_warn(&client->dev,
+		"%s: Invalid Property - %d\n", __func__, psp);
+
+	return -EINVAL;
+}
+
 static int bq20z75_get_property(struct power_supply *psy,
 	enum power_supply_property psp,
 	union power_supply_propval *val)
 {
-	int count;
+	int ps_index;
 	int ret;
 	struct bq20z75_info *bq20z75_device = container_of(psy,
 				struct bq20z75_info, power_supply);
@@ -343,13 +427,15 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_CAPACITY:
-		for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++) {
-			if (psp == bq20z75_data[count].psp)
-				break;
-		}
+		ps_index = bq20z75_get_property_index(client, psp);
+		if (ps_index < 0)
+			return ps_index;
 
-		ret = bq20z75_get_battery_capacity(client, count, psp, val);
+		ret = bq20z75_get_battery_capacity(client, ps_index, psp, val);
 		if (ret)
 			return ret;
 
@@ -369,12 +455,11 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++) {
-			if (psp == bq20z75_data[count].psp)
-				break;
-		}
+		ps_index = bq20z75_get_property_index(client, psp);
+		if (ps_index < 0)
+			return ps_index;
 
-		ret = bq20z75_get_battery_property(client, count, psp, val);
+		ret = bq20z75_get_battery_property(client, ps_index, psp, val);
 		if (ret)
 			return ret;
 
-- 
1.7.0.4

