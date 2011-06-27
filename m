Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1F0KHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:07:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65030 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab1F0KF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:05:59 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-94-4e085605fee9
Date: Mon, 27 Jun 2011 19:04:56 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] power_supply: MAX17042: Support additional properties
To: cbouatmailru@gmail.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Message-id: <1309169096-1447-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 27 Jun 2011 10:06:13.0275 (UTC)
 FILETIME=[D87BCEB0:01CC34B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports additional properties (PRESENT, CYCLE_COUNT,
VOLTAGE_MAX, VOLTAGE_MIN_DESIGN, CURRENT_NOW, CURRENT_AVG,
CHARGE_FULL, and TEMP).
Plus, initialization code for registers is added.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17042_battery.c       |  168 +++++++++++++++++++-------------
 include/linux/power/max17042_battery.h |   91 +++++++++++++++++
 2 files changed, 191 insertions(+), 68 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index c5c8805..a44888f 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -29,74 +29,6 @@
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
 
-enum max17042_register {
-	MAX17042_STATUS		= 0x00,
-	MAX17042_VALRT_Th	= 0x01,
-	MAX17042_TALRT_Th	= 0x02,
-	MAX17042_SALRT_Th	= 0x03,
-	MAX17042_AtRate		= 0x04,
-	MAX17042_RepCap		= 0x05,
-	MAX17042_RepSOC		= 0x06,
-	MAX17042_Age		= 0x07,
-	MAX17042_TEMP		= 0x08,
-	MAX17042_VCELL		= 0x09,
-	MAX17042_Current	= 0x0A,
-	MAX17042_AvgCurrent	= 0x0B,
-	MAX17042_Qresidual	= 0x0C,
-	MAX17042_SOC		= 0x0D,
-	MAX17042_AvSOC		= 0x0E,
-	MAX17042_RemCap		= 0x0F,
-	MAX17402_FullCAP	= 0x10,
-	MAX17042_TTE		= 0x11,
-	MAX17042_V_empty	= 0x12,
-
-	MAX17042_RSLOW		= 0x14,
-
-	MAX17042_AvgTA		= 0x16,
-	MAX17042_Cycles		= 0x17,
-	MAX17042_DesignCap	= 0x18,
-	MAX17042_AvgVCELL	= 0x19,
-	MAX17042_MinMaxTemp	= 0x1A,
-	MAX17042_MinMaxVolt	= 0x1B,
-	MAX17042_MinMaxCurr	= 0x1C,
-	MAX17042_CONFIG		= 0x1D,
-	MAX17042_ICHGTerm	= 0x1E,
-	MAX17042_AvCap		= 0x1F,
-	MAX17042_ManName	= 0x20,
-	MAX17042_DevName	= 0x21,
-	MAX17042_DevChem	= 0x22,
-
-	MAX17042_TempNom	= 0x24,
-	MAX17042_TempCold	= 0x25,
-	MAX17042_TempHot	= 0x26,
-	MAX17042_AIN		= 0x27,
-	MAX17042_LearnCFG	= 0x28,
-	MAX17042_SHFTCFG	= 0x29,
-	MAX17042_RelaxCFG	= 0x2A,
-	MAX17042_MiscCFG	= 0x2B,
-	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
-	MAX17042_CGAIN		= 0x2E,
-	MAX17042_COFF		= 0x2F,
-
-	MAX17042_Q_empty	= 0x33,
-	MAX17042_T_empty	= 0x34,
-
-	MAX17042_RCOMP0		= 0x38,
-	MAX17042_TempCo		= 0x39,
-	MAX17042_Rx		= 0x3A,
-	MAX17042_T_empty0	= 0x3B,
-	MAX17042_TaskPeriod	= 0x3C,
-	MAX17042_FSTAT		= 0x3D,
-
-	MAX17042_SHDNTIMER	= 0x3F,
-
-	MAX17042_VFRemCap	= 0x4A,
-
-	MAX17042_QH		= 0x4D,
-	MAX17042_QL		= 0x4E,
-};
-
 struct max17042_chip {
 	struct i2c_client *client;
 	struct power_supply battery;
@@ -123,10 +55,27 @@ static int max17042_read_reg(struct i2c_client *client, u8 reg)
 	return ret;
 }
 
+static void max17042_set_reg(struct i2c_client *client,
+			     struct max17042_reg_data *data, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		max17042_write_reg(client, data[i].addr, data[i].data);
+}
+
 static enum power_supply_property max17042_battery_props[] = {
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
 	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_TEMP,
 };
 
 static int max17042_get_property(struct power_supply *psy,
@@ -137,6 +86,30 @@ static int max17042_get_property(struct power_supply *psy,
 				struct max17042_chip, battery);
 
 	switch (psp) {
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_STATUS);
+		if (val->intval & MAX17042_STATUS_BattAbsent)
+			val->intval = 0;
+		else
+			val->intval = 1;
+		break;
+	case POWER_SUPPLY_PROP_CYCLE_COUNT:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_Cycles);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_MinMaxVolt);
+		val->intval >>= 8;
+		val->intval *= 20000; /* Units of LSB = 20mV */
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_V_empty);
+		val->intval >>= 7;
+		val->intval *= 10000; /* Units of LSB = 10mV */
+		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		val->intval = max17042_read_reg(chip->client,
 				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
@@ -145,10 +118,61 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval = max17042_read_reg(chip->client,
 				MAX17042_AvgVCELL) * 83;
 		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		if (chip->pdata->enable_current_sense) {
+			val->intval = max17042_read_reg(chip->client,
+					MAX17042_Current);
+			if (val->intval & 0x8000) {
+				/* Negative */
+				val->intval = ~val->intval & 0x7fff;
+				val->intval++;
+				val->intval *= -1;
+			}
+			val->intval >>= 4;
+			val->intval *= 1000000 * 25 / chip->pdata->r_sns;
+		} else {
+			return -EINVAL;
+		}
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		if (chip->pdata->enable_current_sense) {
+			val->intval = max17042_read_reg(chip->client,
+					MAX17042_AvgCurrent);
+			if (val->intval & 0x8000) {
+				/* Negative */
+				val->intval = ~val->intval & 0x7fff;
+				val->intval++;
+				val->intval *= -1;
+			}
+			val->intval *= 1562500 / chip->pdata->r_sns;
+		} else {
+			return -EINVAL;
+		}
+		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = max17042_read_reg(chip->client,
 				MAX17042_SOC) / 256;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_RepSOC);
+		if ((val->intval / 256) >= MAX17042_BATTERY_FULL)
+			val->intval = 1;
+		else if (val->intval >= 0)
+			val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_TEMP);
+		/* The value is signed. */
+		if (val->intval & 0x8000) {
+			val->intval = (0x7fff & ~val->intval) + 1;
+			val->intval *= -1;
+		}
+		/* The value is converted into deci-centigrade scale */
+		/* Units of LSB = 1 / 256 degree Celsius */
+		val->intval = val->intval * 10 / 256;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -188,10 +212,18 @@ static int __devinit max17042_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	/* Initialize registers according to values from the platform data */
+	if (chip->pdata->init_data)
+		max17042_set_reg(client, chip->pdata->init_data,
+				 chip->pdata->num_init_data);
+
 	if (!chip->pdata->enable_current_sense) {
 		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
 		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
 		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
+	} else {
+		if (chip->pdata->r_sns == 0)
+			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
 	}
 
 	return 0;
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index 7995deb..fe99211 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -23,8 +23,99 @@
 #ifndef __MAX17042_BATTERY_H_
 #define __MAX17042_BATTERY_H_
 
+#define MAX17042_STATUS_BattAbsent	(1 << 3)
+#define MAX17042_BATTERY_FULL	(100)
+#define MAX17042_DEFAULT_SNS_RESISTOR	(10000)
+
+enum max17042_register {
+	MAX17042_STATUS		= 0x00,
+	MAX17042_VALRT_Th	= 0x01,
+	MAX17042_TALRT_Th	= 0x02,
+	MAX17042_SALRT_Th	= 0x03,
+	MAX17042_AtRate		= 0x04,
+	MAX17042_RepCap		= 0x05,
+	MAX17042_RepSOC		= 0x06,
+	MAX17042_Age		= 0x07,
+	MAX17042_TEMP		= 0x08,
+	MAX17042_VCELL		= 0x09,
+	MAX17042_Current	= 0x0A,
+	MAX17042_AvgCurrent	= 0x0B,
+	MAX17042_Qresidual	= 0x0C,
+	MAX17042_SOC		= 0x0D,
+	MAX17042_AvSOC		= 0x0E,
+	MAX17042_RemCap		= 0x0F,
+	MAX17402_FullCAP	= 0x10,
+	MAX17042_TTE		= 0x11,
+	MAX17042_V_empty	= 0x12,
+
+	MAX17042_RSLOW		= 0x14,
+
+	MAX17042_AvgTA		= 0x16,
+	MAX17042_Cycles		= 0x17,
+	MAX17042_DesignCap	= 0x18,
+	MAX17042_AvgVCELL	= 0x19,
+	MAX17042_MinMaxTemp	= 0x1A,
+	MAX17042_MinMaxVolt	= 0x1B,
+	MAX17042_MinMaxCurr	= 0x1C,
+	MAX17042_CONFIG		= 0x1D,
+	MAX17042_ICHGTerm	= 0x1E,
+	MAX17042_AvCap		= 0x1F,
+	MAX17042_ManName	= 0x20,
+	MAX17042_DevName	= 0x21,
+	MAX17042_DevChem	= 0x22,
+
+	MAX17042_TempNom	= 0x24,
+	MAX17042_TempCold	= 0x25,
+	MAX17042_TempHot	= 0x26,
+	MAX17042_AIN		= 0x27,
+	MAX17042_LearnCFG	= 0x28,
+	MAX17042_SHFTCFG	= 0x29,
+	MAX17042_RelaxCFG	= 0x2A,
+	MAX17042_MiscCFG	= 0x2B,
+	MAX17042_TGAIN		= 0x2C,
+	MAx17042_TOFF		= 0x2D,
+	MAX17042_CGAIN		= 0x2E,
+	MAX17042_COFF		= 0x2F,
+
+	MAX17042_Q_empty	= 0x33,
+	MAX17042_T_empty	= 0x34,
+
+	MAX17042_RCOMP0		= 0x38,
+	MAX17042_TempCo		= 0x39,
+	MAX17042_Rx		= 0x3A,
+	MAX17042_T_empty0	= 0x3B,
+	MAX17042_TaskPeriod	= 0x3C,
+	MAX17042_FSTAT		= 0x3D,
+
+	MAX17042_SHDNTIMER	= 0x3F,
+
+	MAX17042_VFRemCap	= 0x4A,
+
+	MAX17042_QH		= 0x4D,
+	MAX17042_QL		= 0x4E,
+};
+
+/*
+ * used for setting a register to a desired value
+ * addr : address for a register
+ * data : setting value for the register
+ */
+struct max17042_reg_data {
+	u8 addr;
+	u16 data;
+};
+
 struct max17042_platform_data {
+	struct max17042_reg_data *init_data;
+	int num_init_data; /* Number of enties in init_data array */
 	bool enable_current_sense;
+
+	/*
+	 * R_sns in micro-ohms.
+	 * default 10000 (if r_sns = 0) as it is the recommended value by
+	 * the datasheet although it can be changed by board designers.
+	 */
+	unsigned int r_sns;
 };
 
 #endif /* __MAX17042_BATTERY_H_ */
-- 
1.7.4.1

