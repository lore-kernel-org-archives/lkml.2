Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2EEKcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:32:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:61335 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2EEKcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139220797"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: Add support for max17047/50 chip
Date: Sat,  5 May 2012 14:34:26 +0530
Message-Id: <1336208666-17810-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max17047 is improved version of max17042 chip. It has few HW bug
fixes with minor changes in register set.

max17050 is same as max17047 chip except its silicon packging. So from
driver's point of view there is no difference btw max1047 and max1050.

This patch adds the support to dynamically detect the chip type and
adds steps to initialize the max17047 chip.

This patch is generated on top of the following patch:
[PATCH] max17042_battery: Handle irq request failure case

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/Kconfig                  |    5 +-
 drivers/power/max17042_battery.c       |   69 ++++++++++++++++++++++++++-----
 include/linux/power/max17042_battery.h |   17 ++++++++
 3 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0c52a40..947b3ed 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -181,14 +181,15 @@ config BATTERY_MAX17040
 	  to operate with a single lithium cell
 
 config BATTERY_MAX17042
-	tristate "Maxim MAX17042/8997/8966 Fuel Gauge"
+	tristate "Maxim MAX17042/17047/17050/8997/8966 Fuel Gauge"
 	depends on I2C
 	help
 	  MAX17042 is fuel-gauge systems for lithium-ion (Li+) batteries
 	  in handheld and portable equipment. The MAX17042 is configured
 	  to operate with a single lithium cell. MAX8997 and MAX8966 are
 	  multi-function devices that include fuel gauages that are compatible
-	  with MAX17042.
+	  with MAX17042. This driver also supports max17047/50 chips which are
+	  improved version of max17042.
 
 config BATTERY_Z2
 	tristate "Z2 battery driver"
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 8d28006..140788b 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -62,9 +62,13 @@
 #define dP_ACC_100	0x1900
 #define dP_ACC_200	0x3200
 
+#define MAX17042_IC_VERSION	0x0092
+#define MAX17047_IC_VERSION	0x00AC	/* same for max17050 */
+
 struct max17042_chip {
 	struct i2c_client *client;
 	struct power_supply battery;
+	enum max170xx_chip_type chip_type;
 	struct max17042_platform_data *pdata;
 	struct work_struct work;
 	int    init_complete;
@@ -152,7 +156,10 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval *= 20000; /* Units of LSB = 20mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		ret = max17042_read_reg(chip->client, MAX17042_V_empty);
+		if (chip->chip_type == MAX17042)
+			ret = max17042_read_reg(chip->client, MAX17042_V_empty);
+		else
+			ret = max17042_read_reg(chip->client, MAX17047_V_empty);
 		if (ret < 0)
 			return ret;
 
@@ -389,6 +396,9 @@ static void max17042_write_config_regs(struct max17042_chip *chip)
 	max17042_write_reg(chip->client, MAX17042_FilterCFG,
 			config->filter_cfg);
 	max17042_write_reg(chip->client, MAX17042_RelaxCFG, config->relax_cfg);
+	if (chip->chip_type == MAX17047)
+		max17042_write_reg(chip->client, MAX17047_FullSOCThr,
+						config->full_soc_thresh);
 }
 
 static void  max17042_write_custom_regs(struct max17042_chip *chip)
@@ -399,12 +409,23 @@ static void  max17042_write_custom_regs(struct max17042_chip *chip)
 				config->rcomp0);
 	max17042_write_verify_reg(chip->client, MAX17042_TempCo,
 				config->tcompc0);
-	max17042_write_reg(chip->client, MAX17042_EmptyTempCo,
-			config->empty_tempco);
-	max17042_write_verify_reg(chip->client, MAX17042_K_empty0,
-				config->kempty0);
 	max17042_write_verify_reg(chip->client, MAX17042_ICHGTerm,
 				config->ichgt_term);
+	if (chip->chip_type == MAX17042) {
+		max17042_write_reg(chip->client, MAX17042_EmptyTempCo,
+					config->empty_tempco);
+		max17042_write_verify_reg(chip->client, MAX17042_K_empty0,
+					config->kempty0);
+	} else {
+		max17042_write_verify_reg(chip->client, MAX17047_QRTbl00,
+						config->qrtbl00);
+		max17042_write_verify_reg(chip->client, MAX17047_QRTbl10,
+						config->qrtbl10);
+		max17042_write_verify_reg(chip->client, MAX17047_QRTbl20,
+						config->qrtbl20);
+		max17042_write_verify_reg(chip->client, MAX17047_QRTbl30,
+						config->qrtbl30);
+	}
 }
 
 static void max17042_update_capacity_regs(struct max17042_chip *chip)
@@ -460,6 +481,8 @@ static void max17042_load_new_capacity_params(struct max17042_chip *chip)
 			config->design_cap);
 	max17042_write_verify_reg(chip->client, MAX17042_FullCAPNom,
 			config->fullcapnom);
+	/* Update SOC register with new SOC */
+	max17042_write_reg(chip->client, MAX17042_RepSOC, vfSoc);
 }
 
 /*
@@ -496,20 +519,28 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 
 	max17042_override_por(client, MAX17042_FullCAP, config->fullcap);
 	max17042_override_por(client, MAX17042_FullCAPNom, config->fullcapnom);
-	max17042_override_por(client, MAX17042_SOC_empty, config->socempty);
+	if (chip->chip_type == MAX17042)
+		max17042_override_por(client, MAX17042_SOC_empty,
+						config->socempty);
 	max17042_override_por(client, MAX17042_LAvg_empty, config->lavg_empty);
 	max17042_override_por(client, MAX17042_dQacc, config->dqacc);
 	max17042_override_por(client, MAX17042_dPacc, config->dpacc);
 
-	max17042_override_por(client, MAX17042_V_empty, config->vempty);
+	if (chip->chip_type == MAX17042)
+		max17042_override_por(client, MAX17042_V_empty, config->vempty);
+	else
+		max17042_override_por(client, MAX17047_V_empty, config->vempty);
 	max17042_override_por(client, MAX17042_TempNom, config->temp_nom);
 	max17042_override_por(client, MAX17042_TempLim, config->temp_lim);
 	max17042_override_por(client, MAX17042_FCTC, config->fctc);
 	max17042_override_por(client, MAX17042_RCOMP0, config->rcomp0);
 	max17042_override_por(client, MAX17042_TempCo, config->tcompc0);
-	max17042_override_por(client, MAX17042_EmptyTempCo,
-			config->empty_tempco);
-	max17042_override_por(client, MAX17042_K_empty0, config->kempty0);
+	if (chip->chip_type) {
+		max17042_override_por(client, MAX17042_EmptyTempCo,
+					config->empty_tempco);
+		max17042_override_por(client, MAX17042_K_empty0,
+					config->kempty0);
+	}
 }
 
 static int max17042_init_chip(struct max17042_chip *chip)
@@ -666,7 +697,19 @@ static int __devinit max17042_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, chip);
 
-	chip->battery.name		= "max17042_battery";
+	ret = max17042_read_reg(chip->client, MAX17042_DevName);
+	if (ret == MAX17042_IC_VERSION) {
+		dev_dbg(&client->dev, "chip type max17042 detected\n");
+		chip->chip_type = MAX17042;
+	} else if (ret == MAX17047_IC_VERSION) {
+		dev_dbg(&client->dev, "chip type max17047/50 detected\n");
+		chip->chip_type = MAX17047;
+	} else {
+		dev_err(&client->dev, "device version mismatch: %x\n", ret);
+		return -EIO;
+	}
+
+	chip->battery.name		= "max170xx_battery";
 	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
 	chip->battery.get_property	= max17042_get_property;
 	chip->battery.properties	= max17042_battery_props;
@@ -778,6 +821,8 @@ static const struct dev_pm_ops max17042_pm_ops = {
 #ifdef CONFIG_OF
 static const struct of_device_id max17042_dt_match[] = {
 	{ .compatible = "maxim,max17042" },
+	{ .compatible = "maxim,max17047" },
+	{ .compatible = "maxim,max17050" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, max17042_dt_match);
@@ -785,6 +830,8 @@ MODULE_DEVICE_TABLE(of, max17042_dt_match);
 
 static const struct i2c_device_id max17042_id[] = {
 	{ "max17042", 0 },
+	{ "max17047", 1 },
+	{ "max17050", 2 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17042_id);
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index e01b167..89dd84f 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -116,6 +116,18 @@ enum max17042_register {
 	MAX17042_VFSOC		= 0xFF,
 };
 
+/* Registers specific to max17047/50 */
+enum max17047_register {
+	MAX17047_QRTbl00	= 0x12,
+	MAX17047_FullSOCThr	= 0x13,
+	MAX17047_QRTbl10	= 0x22,
+	MAX17047_QRTbl20	= 0x32,
+	MAX17047_V_empty	= 0x3A,
+	MAX17047_QRTbl30	= 0x42,
+};
+
+enum max170xx_chip_type {MAX17042, MAX17047};
+
 /*
  * used for setting a register to a desired value
  * addr : address for a register
@@ -144,6 +156,7 @@ struct max17042_config_data {
 	u16	shdntimer;	/* 0x03F */
 
 	/* App data */
+	u16	full_soc_thresh;	/* 0x13 */
 	u16	design_cap;	/* 0x18 */
 	u16	ichgt_term;	/* 0x1E */
 
@@ -162,6 +175,10 @@ struct max17042_config_data {
 	u16	lavg_empty;	/* 0x36 */
 	u16	dqacc;		/* 0x45 */
 	u16	dpacc;		/* 0x46 */
+	u16	qrtbl00;	/* 0x12 */
+	u16	qrtbl10;	/* 0x22 */
+	u16	qrtbl20;	/* 0x32 */
+	u16	qrtbl30;	/* 0x42 */
 
 	/* Cell technology from power_supply.h */
 	u16	cell_technology;
-- 
1.7.0.4

