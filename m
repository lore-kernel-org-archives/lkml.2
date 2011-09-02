Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1IBOnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:43:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:2596 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab1IBOnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,319,1312182000"; 
   d="scan'208";a="45064143"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, dwmw2@infradead.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        KyungMin Park <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        durgadoss.r@intel.com
Subject: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
Date: Fri,  2 Sep 2011 12:15:21 +0530
Message-Id: <1314945921-27191-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In max17042_get_property(...), the values returned by
max17042_read_reg are directly assigned to the variables,
even if the read results in an error.

This patch checks for the return code from max17042_read_reg and
exits the function if there is any error.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
 1 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 98bfab3..cae910d 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -84,55 +84,79 @@ static int max17042_get_property(struct power_supply *psy,
 {
 	struct max17042_chip *chip = container_of(psy,
 				struct max17042_chip, battery);
+	int ret;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_STATUS);
-		if (val->intval & MAX17042_STATUS_BattAbsent)
+		ret = max17042_read_reg(chip->client, MAX17042_STATUS);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MAX17042_STATUS_BattAbsent)
 			val->intval = 0;
 		else
 			val->intval = 1;
 		break;
 	case POWER_SUPPLY_PROP_CYCLE_COUNT:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_Cycles);
+		ret = max17042_read_reg(chip->client, MAX17042_Cycles);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_MinMaxVolt);
-		val->intval >>= 8;
+		ret = max17042_read_reg(chip->client, MAX17042_MinMaxVolt);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 8;
 		val->intval *= 20000; /* Units of LSB = 20mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_V_empty);
-		val->intval >>= 7;
+		ret = max17042_read_reg(chip->client, MAX17042_V_empty);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 7;
 		val->intval *= 10000; /* Units of LSB = 10mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
+		ret = max17042_read_reg(chip->client, MAX17042_VCELL);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 83; /* 1000 / 12 = 83 */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_AvgVCELL) * 83;
+		ret = max17042_read_reg(chip->client, MAX17042_AvgVCELL);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 83; /* 1000 / 12 = 83 */
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_SOC) / 256;
+		ret = max17042_read_reg(chip->client, MAX17042_SOC);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret >> 8;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_RepSOC);
-		if ((val->intval / 256) >= MAX17042_BATTERY_FULL)
+		ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
+		if (ret < 0)
+			return ret;
+
+		if ((ret >> 8) >= MAX17042_BATTERY_FULL)
 			val->intval = 1;
-		else if (val->intval >= 0)
+		else if (ret >= 0)
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_TEMP);
+		ret = max17042_read_reg(chip->client, MAX17042_TEMP);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret;
 		/* The value is signed. */
 		if (val->intval & 0x8000) {
 			val->intval = (0x7fff & ~val->intval) + 1;
@@ -144,8 +168,11 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		if (chip->pdata->enable_current_sense) {
-			val->intval = max17042_read_reg(chip->client,
-					MAX17042_Current);
+			ret = max17042_read_reg(chip->client, MAX17042_Current);
+			if (ret < 0)
+				return ret;
+
+			val->intval = ret;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
@@ -160,8 +187,12 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		if (chip->pdata->enable_current_sense) {
-			val->intval = max17042_read_reg(chip->client,
-					MAX17042_AvgCurrent);
+			ret = max17042_read_reg(chip->client,
+						MAX17042_AvgCurrent);
+			if (ret < 0)
+				return ret;
+
+			val->intval = ret;
 			if (val->intval & 0x8000) {
 				/* Negative */
 				val->intval = ~val->intval & 0x7fff;
-- 
1.7.0.4

