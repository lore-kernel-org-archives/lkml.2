Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2DPIrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:47:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:21203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab2DPIrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:47:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="132931843"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton.vorontsov@linaro.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/4] power-supply: smb347-charger: convert to regmap API
Date: Mon, 16 Apr 2012 11:48:41 +0300
Message-Id: <1334566121-8243-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smb347-charger driver does a lot of read-modify-write to the device
registers. Instead of open-coding everything we can take advantage of regmap
API which provides nice functions to do this kind of things.

In addition there is no need for custom debugfs file for dumping registers as
this is already provided by the regmap API.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/power/Kconfig          |    1 +
 drivers/power/smb347-charger.c |  555 +++++++++++++++++-----------------------
 2 files changed, 230 insertions(+), 326 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 99dc29f..c505295 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -291,6 +291,7 @@ config CHARGER_MAX8998
 config CHARGER_SMB347
 	tristate "Summit Microelectronics SMB347 Battery Charger"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say Y to include support for Summit Microelectronics SMB347
 	  Battery Charger.
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 781c058..fca73ce 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -11,7 +11,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/debugfs.h>
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -21,7 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/power_supply.h>
 #include <linux/power/smb347-charger.h>
-#include <linux/seq_file.h>
+#include <linux/regmap.h>
 
 /*
  * Configuration registers. These are mirrored to volatile RAM and can be
@@ -39,6 +38,7 @@
 #define CFG_CURRENT_LIMIT_DC_SHIFT		4
 #define CFG_CURRENT_LIMIT_USB_MASK		0x0f
 #define CFG_FLOAT_VOLTAGE			0x03
+#define CFG_FLOAT_VOLTAGE_FLOAT_MASK		0x3f
 #define CFG_FLOAT_VOLTAGE_THRESHOLD_MASK	0xc0
 #define CFG_FLOAT_VOLTAGE_THRESHOLD_SHIFT	6
 #define CFG_STAT				0x05
@@ -113,29 +113,31 @@
 #define STAT_C_CHARGER_ERROR			BIT(6)
 #define STAT_E					0x3f
 
+#define SMB347_MAX_REGISTER			0x3f
+
 /**
  * struct smb347_charger - smb347 charger instance
  * @lock: protects concurrent access to online variables
- * @client: pointer to i2c client
+ * @dev: pointer to device
+ * @regmap: pointer to driver regmap
  * @mains: power_supply instance for AC/DC power
  * @usb: power_supply instance for USB power
  * @battery: power_supply instance for battery
  * @mains_online: is AC/DC input connected
  * @usb_online: is USB input connected
  * @charging_enabled: is charging enabled
- * @dentry: for debugfs
  * @pdata: pointer to platform data
  */
 struct smb347_charger {
 	struct mutex		lock;
-	struct i2c_client	*client;
+	struct device		*dev;
+	struct regmap		*regmap;
 	struct power_supply	mains;
 	struct power_supply	usb;
 	struct power_supply	battery;
 	bool			mains_online;
 	bool			usb_online;
 	bool			charging_enabled;
-	struct dentry		*dentry;
 	const struct smb347_charger_platform_data *pdata;
 };
 
@@ -212,28 +214,6 @@ static int current_to_hw(const unsigned int *tbl, size_t size, unsigned int val)
 	return i > 0 ? i - 1 : -EINVAL;
 }
 
-static int smb347_read(struct smb347_charger *smb, u8 reg)
-{
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(smb->client, reg);
-	if (ret < 0)
-		dev_warn(&smb->client->dev, "failed to read reg 0x%x: %d\n",
-			 reg, ret);
-	return ret;
-}
-
-static int smb347_write(struct smb347_charger *smb, u8 reg, u8 val)
-{
-	int ret;
-
-	ret = i2c_smbus_write_byte_data(smb->client, reg, val);
-	if (ret < 0)
-		dev_warn(&smb->client->dev, "failed to write reg 0x%x: %d\n",
-			 reg, ret);
-	return ret;
-}
-
 /**
  * smb347_update_ps_status - refreshes the power source status
  * @smb: pointer to smb347 charger instance
@@ -246,9 +226,10 @@ static int smb347_update_ps_status(struct smb347_charger *smb)
 {
 	bool usb = false;
 	bool dc = false;
+	unsigned int val;
 	int ret;
 
-	ret = smb347_read(smb, IRQSTAT_E);
+	ret = regmap_read(smb->regmap, IRQSTAT_E, &val);
 	if (ret < 0)
 		return ret;
 
@@ -257,9 +238,9 @@ static int smb347_update_ps_status(struct smb347_charger *smb)
 	 * platform data _and_ whether corresponding undervoltage is set.
 	 */
 	if (smb->pdata->use_mains)
-		dc = !(ret & IRQSTAT_E_DCIN_UV_STAT);
+		dc = !(val & IRQSTAT_E_DCIN_UV_STAT);
 	if (smb->pdata->use_usb)
-		usb = !(ret & IRQSTAT_E_USBIN_UV_STAT);
+		usb = !(val & IRQSTAT_E_USBIN_UV_STAT);
 
 	mutex_lock(&smb->lock);
 	ret = smb->mains_online != dc || smb->usb_online != usb;
@@ -299,16 +280,17 @@ static bool smb347_is_ps_online(struct smb347_charger *smb)
  */
 static int smb347_charging_status(struct smb347_charger *smb)
 {
+	unsigned int val;
 	int ret;
 
 	if (!smb347_is_ps_online(smb))
 		return 0;
 
-	ret = smb347_read(smb, STAT_C);
+	ret = regmap_read(smb->regmap, STAT_C, &val);
 	if (ret < 0)
 		return 0;
 
-	return (ret & STAT_C_CHG_MASK) >> STAT_C_CHG_SHIFT;
+	return (val & STAT_C_CHG_MASK) >> STAT_C_CHG_SHIFT;
 }
 
 static int smb347_charging_set(struct smb347_charger *smb, bool enable)
@@ -316,27 +298,17 @@ static int smb347_charging_set(struct smb347_charger *smb, bool enable)
 	int ret = 0;
 
 	if (smb->pdata->enable_control != SMB347_CHG_ENABLE_SW) {
-		dev_dbg(&smb->client->dev,
-			"charging enable/disable in SW disabled\n");
+		dev_dbg(smb->dev, "charging enable/disable in SW disabled\n");
 		return 0;
 	}
 
 	mutex_lock(&smb->lock);
 	if (smb->charging_enabled != enable) {
-		ret = smb347_read(smb, CMD_A);
-		if (ret < 0)
-			goto out;
-
-		smb->charging_enabled = enable;
-
-		if (enable)
-			ret |= CMD_A_CHG_ENABLED;
-		else
-			ret &= ~CMD_A_CHG_ENABLED;
-
-		ret = smb347_write(smb, CMD_A, ret);
+		ret = regmap_update_bits(smb->regmap, CMD_A, CMD_A_CHG_ENABLED,
+					 enable ? CMD_A_CHG_ENABLED : 0);
+		if (!ret)
+			smb->charging_enabled = enable;
 	}
-out:
 	mutex_unlock(&smb->lock);
 	return ret;
 }
@@ -363,13 +335,11 @@ static int smb347_start_stop_charging(struct smb347_charger *smb)
 	if (smb347_is_ps_online(smb)) {
 		ret = smb347_charging_enable(smb);
 		if (ret < 0)
-			dev_err(&smb->client->dev,
-				"failed to enable charging\n");
+			dev_err(smb->dev, "failed to enable charging\n");
 	} else {
 		ret = smb347_charging_disable(smb);
 		if (ret < 0)
-			dev_err(&smb->client->dev,
-				"failed to disable charging\n");
+			dev_err(smb->dev, "failed to disable charging\n");
 	}
 
 	return ret;
@@ -377,106 +347,113 @@ static int smb347_start_stop_charging(struct smb347_charger *smb)
 
 static int smb347_set_charge_current(struct smb347_charger *smb)
 {
-	int ret, val;
-
-	ret = smb347_read(smb, CFG_CHARGE_CURRENT);
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	if (smb->pdata->max_charge_current) {
-		val = current_to_hw(fcc_tbl, ARRAY_SIZE(fcc_tbl),
+		ret = current_to_hw(fcc_tbl, ARRAY_SIZE(fcc_tbl),
 				    smb->pdata->max_charge_current);
-		if (val < 0)
-			return val;
+		if (ret < 0)
+			return ret;
 
-		ret &= ~CFG_CHARGE_CURRENT_FCC_MASK;
-		ret |= val << CFG_CHARGE_CURRENT_FCC_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_CHARGE_CURRENT,
+					 CFG_CHARGE_CURRENT_FCC_MASK,
+					 ret << CFG_CHARGE_CURRENT_FCC_SHIFT);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (smb->pdata->pre_charge_current) {
-		val = current_to_hw(pcc_tbl, ARRAY_SIZE(pcc_tbl),
+		ret = current_to_hw(pcc_tbl, ARRAY_SIZE(pcc_tbl),
 				    smb->pdata->pre_charge_current);
-		if (val < 0)
-			return val;
+		if (ret < 0)
+			return ret;
 
-		ret &= ~CFG_CHARGE_CURRENT_PCC_MASK;
-		ret |= val << CFG_CHARGE_CURRENT_PCC_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_CHARGE_CURRENT,
+					 CFG_CHARGE_CURRENT_PCC_MASK,
+					 ret << CFG_CHARGE_CURRENT_PCC_SHIFT);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (smb->pdata->termination_current) {
-		val = current_to_hw(tc_tbl, ARRAY_SIZE(tc_tbl),
+		ret = current_to_hw(tc_tbl, ARRAY_SIZE(tc_tbl),
 				    smb->pdata->termination_current);
-		if (val < 0)
-			return val;
+		if (ret < 0)
+			return ret;
 
-		ret &= ~CFG_CHARGE_CURRENT_TC_MASK;
-		ret |= val;
+		ret = regmap_update_bits(smb->regmap, CFG_CHARGE_CURRENT,
+					 CFG_CHARGE_CURRENT_TC_MASK, ret);
+		if (ret < 0)
+			return ret;
 	}
 
-	return smb347_write(smb, CFG_CHARGE_CURRENT, ret);
+	return 0;
 }
 
 static int smb347_set_current_limits(struct smb347_charger *smb)
 {
-	int ret, val;
-
-	ret = smb347_read(smb, CFG_CURRENT_LIMIT);
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	if (smb->pdata->mains_current_limit) {
-		val = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+		ret = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
 				    smb->pdata->mains_current_limit);
-		if (val < 0)
-			return val;
+		if (ret < 0)
+			return ret;
 
-		ret &= ~CFG_CURRENT_LIMIT_DC_MASK;
-		ret |= val << CFG_CURRENT_LIMIT_DC_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_CURRENT_LIMIT,
+					 CFG_CURRENT_LIMIT_DC_MASK,
+					 ret << CFG_CURRENT_LIMIT_DC_SHIFT);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (smb->pdata->usb_hc_current_limit) {
-		val = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+		ret = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
 				    smb->pdata->usb_hc_current_limit);
-		if (val < 0)
-			return val;
+		if (ret < 0)
+			return ret;
 
-		ret &= ~CFG_CURRENT_LIMIT_USB_MASK;
-		ret |= val;
+		ret = regmap_update_bits(smb->regmap, CFG_CURRENT_LIMIT,
+					 CFG_CURRENT_LIMIT_USB_MASK, ret);
+		if (ret < 0)
+			return ret;
 	}
 
-	return smb347_write(smb, CFG_CURRENT_LIMIT, ret);
+	return 0;
 }
 
 static int smb347_set_voltage_limits(struct smb347_charger *smb)
 {
-	int ret, val;
-
-	ret = smb347_read(smb, CFG_FLOAT_VOLTAGE);
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	if (smb->pdata->pre_to_fast_voltage) {
-		val = smb->pdata->pre_to_fast_voltage;
+		ret = smb->pdata->pre_to_fast_voltage;
 
 		/* uV */
-		val = clamp_val(val, 2400000, 3000000) - 2400000;
-		val /= 200000;
+		ret = clamp_val(ret, 2400000, 3000000) - 2400000;
+		ret /= 200000;
 
-		ret &= ~CFG_FLOAT_VOLTAGE_THRESHOLD_MASK;
-		ret |= val << CFG_FLOAT_VOLTAGE_THRESHOLD_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_FLOAT_VOLTAGE,
+				CFG_FLOAT_VOLTAGE_THRESHOLD_MASK,
+				ret << CFG_FLOAT_VOLTAGE_THRESHOLD_SHIFT);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (smb->pdata->max_charge_voltage) {
-		val = smb->pdata->max_charge_voltage;
+		ret = smb->pdata->max_charge_voltage;
 
 		/* uV */
-		val = clamp_val(val, 3500000, 4500000) - 3500000;
-		val /= 20000;
+		ret = clamp_val(ret, 3500000, 4500000) - 3500000;
+		ret /= 20000;
 
-		ret |= val;
+		ret = regmap_update_bits(smb->regmap, CFG_FLOAT_VOLTAGE,
+					 CFG_FLOAT_VOLTAGE_FLOAT_MASK, ret);
+		if (ret < 0)
+			return ret;
 	}
 
-	return smb347_write(smb, CFG_FLOAT_VOLTAGE, ret);
+	return 0;
 }
 
 static int smb347_set_temp_limits(struct smb347_charger *smb)
@@ -491,22 +468,13 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		val = clamp_val(val, 100, 130) - 100;
 		val /= 10;
 
-		ret = smb347_read(smb, CFG_OTG);
-		if (ret < 0)
-			return ret;
-
-		ret &= ~CFG_OTG_TEMP_THRESHOLD_MASK;
-		ret |= val << CFG_OTG_TEMP_THRESHOLD_SHIFT;
-
-		ret = smb347_write(smb, CFG_OTG, ret);
+		ret = regmap_update_bits(smb->regmap, CFG_OTG,
+					 CFG_OTG_TEMP_THRESHOLD_MASK,
+					 val << CFG_OTG_TEMP_THRESHOLD_SHIFT);
 		if (ret < 0)
 			return ret;
 	}
 
-	ret = smb347_read(smb, CFG_TEMP_LIMIT);
-	if (ret < 0)
-		return ret;
-
 	if (smb->pdata->soft_cold_temp_limit != SMB347_TEMP_USE_DEFAULT) {
 		val = smb->pdata->soft_cold_temp_limit;
 
@@ -515,8 +483,11 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		/* this goes from higher to lower so invert the value */
 		val = ~val & 0x3;
 
-		ret &= ~CFG_TEMP_LIMIT_SOFT_COLD_MASK;
-		ret |= val << CFG_TEMP_LIMIT_SOFT_COLD_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_TEMP_LIMIT,
+					 CFG_TEMP_LIMIT_SOFT_COLD_MASK,
+					 val << CFG_TEMP_LIMIT_SOFT_COLD_SHIFT);
+		if (ret < 0)
+			return ret;
 
 		enable_therm_monitor = true;
 	}
@@ -527,8 +498,11 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		val = clamp_val(val, 40, 55) - 40;
 		val /= 5;
 
-		ret &= ~CFG_TEMP_LIMIT_SOFT_HOT_MASK;
-		ret |= val << CFG_TEMP_LIMIT_SOFT_HOT_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_TEMP_LIMIT,
+					 CFG_TEMP_LIMIT_SOFT_HOT_MASK,
+					 val << CFG_TEMP_LIMIT_SOFT_HOT_SHIFT);
+		if (ret < 0)
+			return ret;
 
 		enable_therm_monitor = true;
 	}
@@ -541,8 +515,11 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		/* this goes from higher to lower so invert the value */
 		val = ~val & 0x3;
 
-		ret &= ~CFG_TEMP_LIMIT_HARD_COLD_MASK;
-		ret |= val << CFG_TEMP_LIMIT_HARD_COLD_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_TEMP_LIMIT,
+					 CFG_TEMP_LIMIT_HARD_COLD_MASK,
+					 val << CFG_TEMP_LIMIT_HARD_COLD_SHIFT);
+		if (ret < 0)
+			return ret;
 
 		enable_therm_monitor = true;
 	}
@@ -553,16 +530,15 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		val = clamp_val(val, 50, 65) - 50;
 		val /= 5;
 
-		ret &= ~CFG_TEMP_LIMIT_HARD_HOT_MASK;
-		ret |= val << CFG_TEMP_LIMIT_HARD_HOT_SHIFT;
+		ret = regmap_update_bits(smb->regmap, CFG_TEMP_LIMIT,
+					 CFG_TEMP_LIMIT_HARD_HOT_MASK,
+					 val << CFG_TEMP_LIMIT_HARD_HOT_SHIFT);
+		if (ret < 0)
+			return ret;
 
 		enable_therm_monitor = true;
 	}
 
-	ret = smb347_write(smb, CFG_TEMP_LIMIT, ret);
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * If any of the temperature limits are set, we also enable the
 	 * thermistor monitoring.
@@ -574,25 +550,15 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 	 * depending on the configuration.
 	 */
 	if (enable_therm_monitor) {
-		ret = smb347_read(smb, CFG_THERM);
-		if (ret < 0)
-			return ret;
-
-		ret &= ~CFG_THERM_MONITOR_DISABLED;
-
-		ret = smb347_write(smb, CFG_THERM, ret);
+		ret = regmap_update_bits(smb->regmap, CFG_THERM,
+					 CFG_THERM_MONITOR_DISABLED, 0);
 		if (ret < 0)
 			return ret;
 	}
 
 	if (smb->pdata->suspend_on_hard_temp_limit) {
-		ret = smb347_read(smb, CFG_SYSOK);
-		if (ret < 0)
-			return ret;
-
-		ret &= ~CFG_SYSOK_SUSPEND_HARD_LIMIT_DISABLED;
-
-		ret = smb347_write(smb, CFG_SYSOK, ret);
+		ret = regmap_update_bits(smb->regmap, CFG_SYSOK,
+				 CFG_SYSOK_SUSPEND_HARD_LIMIT_DISABLED, 0);
 		if (ret < 0)
 			return ret;
 	}
@@ -601,17 +567,15 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 	    SMB347_SOFT_TEMP_COMPENSATE_DEFAULT) {
 		val = smb->pdata->soft_temp_limit_compensation & 0x3;
 
-		ret = smb347_read(smb, CFG_THERM);
+		ret = regmap_update_bits(smb->regmap, CFG_THERM,
+				 CFG_THERM_SOFT_HOT_COMPENSATION_MASK,
+				 val << CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT);
 		if (ret < 0)
 			return ret;
 
-		ret &= ~CFG_THERM_SOFT_HOT_COMPENSATION_MASK;
-		ret |= val << CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT;
-
-		ret &= ~CFG_THERM_SOFT_COLD_COMPENSATION_MASK;
-		ret |= val << CFG_THERM_SOFT_COLD_COMPENSATION_SHIFT;
-
-		ret = smb347_write(smb, CFG_THERM, ret);
+		ret = regmap_update_bits(smb->regmap, CFG_THERM,
+				 CFG_THERM_SOFT_COLD_COMPENSATION_MASK,
+				 val << CFG_THERM_SOFT_COLD_COMPENSATION_SHIFT);
 		if (ret < 0)
 			return ret;
 	}
@@ -622,14 +586,9 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
 		if (val < 0)
 			return val;
 
-		ret = smb347_read(smb, CFG_OTG);
-		if (ret < 0)
-			return ret;
-
-		ret &= ~CFG_OTG_CC_COMPENSATION_MASK;
-		ret |= (val & 0x3) << CFG_OTG_CC_COMPENSATION_SHIFT;
-
-		ret = smb347_write(smb, CFG_OTG, ret);
+		ret = regmap_update_bits(smb->regmap, CFG_OTG,
+				CFG_OTG_CC_COMPENSATION_MASK,
+				(val & 0x3) << CFG_OTG_CC_COMPENSATION_SHIFT);
 		if (ret < 0)
 			return ret;
 	}
@@ -648,22 +607,13 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
  */
 static int smb347_set_writable(struct smb347_charger *smb, bool writable)
 {
-	int ret;
-
-	ret = smb347_read(smb, CMD_A);
-	if (ret < 0)
-		return ret;
-
-	if (writable)
-		ret |= CMD_A_ALLOW_WRITE;
-	else
-		ret &= ~CMD_A_ALLOW_WRITE;
-
-	return smb347_write(smb, CMD_A, ret);
+	return regmap_update_bits(smb->regmap, CMD_A, CMD_A_ALLOW_WRITE,
+				  writable ? CMD_A_ALLOW_WRITE : 0);
 }
 
 static int smb347_hw_init(struct smb347_charger *smb)
 {
+	unsigned int val;
 	int ret;
 
 	ret = smb347_set_writable(smb, true);
@@ -692,34 +642,19 @@ static int smb347_hw_init(struct smb347_charger *smb)
 
 	/* If USB charging is disabled we put the USB in suspend mode */
 	if (!smb->pdata->use_usb) {
-		ret = smb347_read(smb, CMD_A);
-		if (ret < 0)
-			goto fail;
-
-		ret |= CMD_A_SUSPEND_ENABLED;
-
-		ret = smb347_write(smb, CMD_A, ret);
+		ret = regmap_update_bits(smb->regmap, CMD_A,
+					 CMD_A_SUSPEND_ENABLED,
+					 CMD_A_SUSPEND_ENABLED);
 		if (ret < 0)
 			goto fail;
 	}
 
-	ret = smb347_read(smb, CFG_OTHER);
-	if (ret < 0)
-		goto fail;
-
 	/*
 	 * If configured by platform data, we enable hardware Auto-OTG
 	 * support for driving VBUS. Otherwise we disable it.
 	 */
-	ret &= ~CFG_OTHER_RID_MASK;
-	if (smb->pdata->use_usb_otg)
-		ret |= CFG_OTHER_RID_ENABLED_AUTO_OTG;
-
-	ret = smb347_write(smb, CFG_OTHER, ret);
-	if (ret < 0)
-		goto fail;
-
-	ret = smb347_read(smb, CFG_PIN);
+	ret = regmap_update_bits(smb->regmap, CFG_OTHER, CFG_OTHER_RID_MASK,
+		smb->pdata->use_usb_otg ? CFG_OTHER_RID_ENABLED_AUTO_OTG : 0);
 	if (ret < 0)
 		goto fail;
 
@@ -728,24 +663,25 @@ static int smb347_hw_init(struct smb347_charger *smb)
 	 * command register unless pin control is specified in the platform
 	 * data.
 	 */
-	ret &= ~CFG_PIN_EN_CTRL_MASK;
-
 	switch (smb->pdata->enable_control) {
-	case SMB347_CHG_ENABLE_SW:
-		/* Do nothing, 0 means i2c control */
-		break;
 	case SMB347_CHG_ENABLE_PIN_ACTIVE_LOW:
-		ret |= CFG_PIN_EN_CTRL_ACTIVE_LOW;
+		val = CFG_PIN_EN_CTRL_ACTIVE_LOW;
 		break;
 	case SMB347_CHG_ENABLE_PIN_ACTIVE_HIGH:
-		ret |= CFG_PIN_EN_CTRL_ACTIVE_HIGH;
+		val = CFG_PIN_EN_CTRL_ACTIVE_HIGH;
+		break;
+	default:
+		val = 0;
 		break;
 	}
 
-	/* Disable Automatic Power Source Detection (APSD) interrupt. */
-	ret &= ~CFG_PIN_EN_APSD_IRQ;
+	ret = regmap_update_bits(smb->regmap, CFG_PIN, CFG_PIN_EN_CTRL_MASK,
+				 val);
+	if (ret < 0)
+		goto fail;
 
-	ret = smb347_write(smb, CFG_PIN, ret);
+	/* Disable Automatic Power Source Detection (APSD) interrupt. */
+	ret = regmap_update_bits(smb->regmap, CFG_PIN, CFG_PIN_EN_APSD_IRQ, 0);
 	if (ret < 0)
 		goto fail;
 
@@ -763,24 +699,25 @@ fail:
 static irqreturn_t smb347_interrupt(int irq, void *data)
 {
 	struct smb347_charger *smb = data;
-	int stat_c, irqstat_e, irqstat_c;
-	irqreturn_t ret = IRQ_NONE;
+	unsigned int stat_c, irqstat_e, irqstat_c;
+	bool handled = false;
+	int ret;
 
-	stat_c = smb347_read(smb, STAT_C);
-	if (stat_c < 0) {
-		dev_warn(&smb->client->dev, "reading STAT_C failed\n");
+	ret = regmap_read(smb->regmap, STAT_C, &stat_c);
+	if (ret < 0) {
+		dev_warn(smb->dev, "reading STAT_C failed\n");
 		return IRQ_NONE;
 	}
 
-	irqstat_c = smb347_read(smb, IRQSTAT_C);
-	if (irqstat_c < 0) {
-		dev_warn(&smb->client->dev, "reading IRQSTAT_C failed\n");
+	ret = regmap_read(smb->regmap, IRQSTAT_C, &irqstat_c);
+	if (ret < 0) {
+		dev_warn(smb->dev, "reading IRQSTAT_C failed\n");
 		return IRQ_NONE;
 	}
 
-	irqstat_e = smb347_read(smb, IRQSTAT_E);
-	if (irqstat_e < 0) {
-		dev_warn(&smb->client->dev, "reading IRQSTAT_E failed\n");
+	ret = regmap_read(smb->regmap, IRQSTAT_E, &irqstat_e);
+	if (ret < 0) {
+		dev_warn(smb->dev, "reading IRQSTAT_E failed\n");
 		return IRQ_NONE;
 	}
 
@@ -789,13 +726,11 @@ static irqreturn_t smb347_interrupt(int irq, void *data)
 	 * disable charging.
 	 */
 	if (stat_c & STAT_C_CHARGER_ERROR) {
-		dev_err(&smb->client->dev,
-			"error in charger, disabling charging\n");
+		dev_err(smb->dev, "error in charger, disabling charging\n");
 
 		smb347_charging_disable(smb);
 		power_supply_changed(&smb->battery);
-
-		ret = IRQ_HANDLED;
+		handled = true;
 	}
 
 	/*
@@ -806,7 +741,7 @@ static irqreturn_t smb347_interrupt(int irq, void *data)
 	if (irqstat_c & (IRQSTAT_C_TERMINATION_IRQ | IRQSTAT_C_TAPER_IRQ)) {
 		if (irqstat_c & IRQSTAT_C_TERMINATION_STAT)
 			power_supply_changed(&smb->battery);
-		ret = IRQ_HANDLED;
+		handled = true;
 	}
 
 	/*
@@ -819,10 +754,10 @@ static irqreturn_t smb347_interrupt(int irq, void *data)
 			power_supply_changed(&smb->mains);
 			power_supply_changed(&smb->usb);
 		}
-		ret = IRQ_HANDLED;
+		handled = true;
 	}
 
-	return ret;
+	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int smb347_irq_set(struct smb347_charger *smb, bool enable)
@@ -839,41 +774,18 @@ static int smb347_irq_set(struct smb347_charger *smb, bool enable)
 	 *	- termination current reached
 	 *	- charger error
 	 */
-	if (enable) {
-		ret = smb347_write(smb, CFG_FAULT_IRQ, CFG_FAULT_IRQ_DCIN_UV);
-		if (ret < 0)
-			goto fail;
-
-		ret = smb347_write(smb, CFG_STATUS_IRQ,
-				   CFG_STATUS_IRQ_TERMINATION_OR_TAPER);
-		if (ret < 0)
-			goto fail;
-
-		ret = smb347_read(smb, CFG_PIN);
-		if (ret < 0)
-			goto fail;
-
-		ret |= CFG_PIN_EN_CHARGER_ERROR;
-
-		ret = smb347_write(smb, CFG_PIN, ret);
-	} else {
-		ret = smb347_write(smb, CFG_FAULT_IRQ, 0);
-		if (ret < 0)
-			goto fail;
-
-		ret = smb347_write(smb, CFG_STATUS_IRQ, 0);
-		if (ret < 0)
-			goto fail;
-
-		ret = smb347_read(smb, CFG_PIN);
-		if (ret < 0)
-			goto fail;
-
-		ret &= ~CFG_PIN_EN_CHARGER_ERROR;
+	ret = regmap_update_bits(smb->regmap, CFG_FAULT_IRQ, 0xff,
+				 enable ? CFG_FAULT_IRQ_DCIN_UV : 0);
+	if (ret < 0)
+		goto fail;
 
-		ret = smb347_write(smb, CFG_PIN, ret);
-	}
+	ret = regmap_update_bits(smb->regmap, CFG_STATUS_IRQ, 0xff,
+			enable ? CFG_STATUS_IRQ_TERMINATION_OR_TAPER : 0);
+	if (ret < 0)
+		goto fail;
 
+	ret = regmap_update_bits(smb->regmap, CFG_PIN, CFG_PIN_EN_CHARGER_ERROR,
+				 enable ? CFG_PIN_EN_CHARGER_ERROR : 0);
 fail:
 	smb347_set_writable(smb, false);
 	return ret;
@@ -889,18 +801,18 @@ static inline int smb347_irq_disable(struct smb347_charger *smb)
 	return smb347_irq_set(smb, false);
 }
 
-static int smb347_irq_init(struct smb347_charger *smb)
+static int smb347_irq_init(struct smb347_charger *smb,
+			   struct i2c_client *client)
 {
 	const struct smb347_charger_platform_data *pdata = smb->pdata;
 	int ret, irq = gpio_to_irq(pdata->irq_gpio);
 
-	ret = gpio_request_one(pdata->irq_gpio, GPIOF_IN, smb->client->name);
+	ret = gpio_request_one(pdata->irq_gpio, GPIOF_IN, client->name);
 	if (ret < 0)
 		goto fail;
 
 	ret = request_threaded_irq(irq, NULL, smb347_interrupt,
-				   IRQF_TRIGGER_FALLING, smb->client->name,
-				   smb);
+				   IRQF_TRIGGER_FALLING, client->name, smb);
 	if (ret < 0)
 		goto fail_gpio;
 
@@ -912,19 +824,14 @@ static int smb347_irq_init(struct smb347_charger *smb)
 	 * Configure the STAT output to be suitable for interrupts: disable
 	 * all other output (except interrupts) and make it active low.
 	 */
-	ret = smb347_read(smb, CFG_STAT);
-	if (ret < 0)
-		goto fail_readonly;
-
-	ret &= ~CFG_STAT_ACTIVE_HIGH;
-	ret |= CFG_STAT_DISABLED;
-
-	ret = smb347_write(smb, CFG_STAT, ret);
+	ret = regmap_update_bits(smb->regmap, CFG_STAT,
+				 CFG_STAT_ACTIVE_HIGH | CFG_STAT_DISABLED,
+				 CFG_STAT_DISABLED);
 	if (ret < 0)
 		goto fail_readonly;
 
 	smb347_set_writable(smb, false);
-	smb->client->irq = irq;
+	client->irq = irq;
 	return 0;
 
 fail_readonly:
@@ -934,7 +841,7 @@ fail_irq:
 fail_gpio:
 	gpio_free(pdata->irq_gpio);
 fail:
-	smb->client->irq = 0;
+	client->irq = 0;
 	return ret;
 }
 
@@ -981,6 +888,7 @@ static int smb347_battery_get_property(struct power_supply *psy,
 	struct smb347_charger *smb =
 			container_of(psy, struct smb347_charger, battery);
 	const struct smb347_charger_platform_data *pdata = smb->pdata;
+	unsigned int v;
 	int ret;
 
 	ret = smb347_update_ps_status(smb);
@@ -1035,22 +943,22 @@ static int smb347_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		if (!smb347_is_ps_online(smb))
 			return -ENODATA;
-		ret = smb347_read(smb, STAT_A);
+		ret = regmap_read(smb->regmap, STAT_A, &v);
 		if (ret < 0)
 			return ret;
 
-		ret &= STAT_A_FLOAT_VOLTAGE_MASK;
-		if (ret > 0x3d)
-			ret = 0x3d;
+		v &= STAT_A_FLOAT_VOLTAGE_MASK;
+		if (v > 0x3d)
+			v = 0x3d;
 
-		val->intval = 3500000 + ret * 20000;
+		val->intval = 3500000 + v * 20000;
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		if (!smb347_is_ps_online(smb))
 			return -ENODATA;
 
-		ret = smb347_read(smb, STAT_B);
+		ret = regmap_read(smb->regmap, STAT_B, &v);
 		if (ret < 0)
 			return ret;
 
@@ -1058,15 +966,15 @@ static int smb347_battery_get_property(struct power_supply *psy,
 		 * The current value is composition of FCC and PCC values
 		 * and we can detect which table to use from bit 5.
 		 */
-		if (ret & 0x20) {
+		if (v & 0x20) {
 			val->intval = hw_to_current(fcc_tbl,
 						    ARRAY_SIZE(fcc_tbl),
-						    ret & 7);
+						    v & 7);
 		} else {
-			ret >>= 3;
+			v >>= 3;
 			val->intval = hw_to_current(pcc_tbl,
 						    ARRAY_SIZE(pcc_tbl),
-						    ret & 7);
+						    v & 7);
 		}
 		break;
 
@@ -1097,58 +1005,54 @@ static enum power_supply_property smb347_battery_properties[] = {
 	POWER_SUPPLY_PROP_MODEL_NAME,
 };
 
-static int smb347_debugfs_show(struct seq_file *s, void *data)
+static bool smb347_volatile_reg(struct device *dev, unsigned int reg)
 {
-	struct smb347_charger *smb = s->private;
-	int ret;
-	u8 reg;
-
-	seq_printf(s, "Control registers:\n");
-	seq_printf(s, "==================\n");
-	for (reg = CFG_CHARGE_CURRENT; reg <= CFG_ADDRESS; reg++) {
-		ret = smb347_read(smb, reg);
-		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
-	}
-	seq_printf(s, "\n");
-
-	seq_printf(s, "Command registers:\n");
-	seq_printf(s, "==================\n");
-	ret = smb347_read(smb, CMD_A);
-	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_A, ret);
-	ret = smb347_read(smb, CMD_B);
-	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_B, ret);
-	ret = smb347_read(smb, CMD_C);
-	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_C, ret);
-	seq_printf(s, "\n");
-
-	seq_printf(s, "Interrupt status registers:\n");
-	seq_printf(s, "===========================\n");
-	for (reg = IRQSTAT_A; reg <= IRQSTAT_F; reg++) {
-		ret = smb347_read(smb, reg);
-		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
-	}
-	seq_printf(s, "\n");
-
-	seq_printf(s, "Status registers:\n");
-	seq_printf(s, "=================\n");
-	for (reg = STAT_A; reg <= STAT_E; reg++) {
-		ret = smb347_read(smb, reg);
-		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
+	switch (reg) {
+	case IRQSTAT_A:
+	case IRQSTAT_C:
+	case IRQSTAT_E:
+	case IRQSTAT_F:
+	case STAT_A:
+	case STAT_B:
+	case STAT_C:
+	case STAT_E:
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
-static int smb347_debugfs_open(struct inode *inode, struct file *file)
+static bool smb347_readable_reg(struct device *dev, unsigned int reg)
 {
-	return single_open(file, smb347_debugfs_show, inode->i_private);
+	switch (reg) {
+	case CFG_CHARGE_CURRENT:
+	case CFG_CURRENT_LIMIT:
+	case CFG_FLOAT_VOLTAGE:
+	case CFG_STAT:
+	case CFG_PIN:
+	case CFG_THERM:
+	case CFG_SYSOK:
+	case CFG_OTHER:
+	case CFG_OTG:
+	case CFG_TEMP_LIMIT:
+	case CFG_FAULT_IRQ:
+	case CFG_STATUS_IRQ:
+	case CFG_ADDRESS:
+	case CMD_A:
+	case CMD_B:
+	case CMD_C:
+		return true;
+	}
+
+	return smb347_volatile_reg(dev, reg);
 }
 
-static const struct file_operations smb347_debugfs_fops = {
-	.open		= smb347_debugfs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct regmap_config smb347_regmap = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= SMB347_MAX_REGISTER,
+	.volatile_reg	= smb347_volatile_reg,
+	.readable_reg	= smb347_readable_reg,
 };
 
 static int smb347_probe(struct i2c_client *client,
@@ -1174,9 +1078,13 @@ static int smb347_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, smb);
 
 	mutex_init(&smb->lock);
-	smb->client = client;
+	smb->dev = &client->dev;
 	smb->pdata = pdata;
 
+	smb->regmap = devm_regmap_init_i2c(client, &smb347_regmap);
+	if (IS_ERR(smb->regmap))
+		return PTR_ERR(smb->regmap);
+
 	ret = smb347_hw_init(smb);
 	if (ret < 0)
 		return ret;
@@ -1225,7 +1133,7 @@ static int smb347_probe(struct i2c_client *client,
 	 * interrupt support here.
 	 */
 	if (pdata->irq_gpio >= 0) {
-		ret = smb347_irq_init(smb);
+		ret = smb347_irq_init(smb, client);
 		if (ret < 0) {
 			dev_warn(dev, "failed to initialize IRQ: %d\n", ret);
 			dev_warn(dev, "disabling IRQ support\n");
@@ -1234,8 +1142,6 @@ static int smb347_probe(struct i2c_client *client,
 		}
 	}
 
-	smb->dentry = debugfs_create_file("smb347-regs", S_IRUSR, NULL, smb,
-					  &smb347_debugfs_fops);
 	return 0;
 }
 
@@ -1243,9 +1149,6 @@ static int smb347_remove(struct i2c_client *client)
 {
 	struct smb347_charger *smb = i2c_get_clientdata(client);
 
-	if (!IS_ERR_OR_NULL(smb->dentry))
-		debugfs_remove(smb->dentry);
-
 	if (client->irq) {
 		smb347_irq_disable(smb);
 		free_irq(client->irq, smb);
-- 
1.7.9.1

