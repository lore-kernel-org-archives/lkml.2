Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AYSH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:07:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51619 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1AYSH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=hJ2WI01AATsL0fkxqyalM9tj5AwZLqN/zsb1LicpgfywJstW6iVrryYgZ7woYFrD9g
         2Be52tY5m4jATVEttmz5l/qp0OwlADb1Av0vZFWRWS4EumAlttnXMPyaVGXCqbSnmcQN
         efYnP7Qz/peB72uFHCYWdT3PtgkwWfRb/GDrg=
MIME-Version: 1.0
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Tue, 25 Jan 2011 19:07:15 +0100
Message-ID: <AANLkTikZXR74B8so+1humvdenMXE6USZ76bmtR0Xsg57@mail.gmail.com>
Subject: [PATCH] bq27x00_battery
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for properties POWER_SUPPLY_PROP_CHARGE_NOW,
POWER_SUPPLY_PROP_CHARGE_FULL, POWER_SUPPLY_PROP_ENERGY_NOW,
POWER_SUPPLY_PROP_ONLINE in module bq27x00_battery. It also fix
reporting correct (devided by resistor sense) values on
bq27000/bq27200 batteries.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>

--- a/drivers/power/bq27x00_battery.c	2011-01-22 14:06:48.000000000 +0100
+++ b/drivers/power/bq27x00_battery.c	2011-01-23 04:06:04.000000000 +0100
@@ -3,9 +3,14 @@
  *
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
+ * Copyright (C) 2011 Pali Rohár <pali.rohar@gmail.com>
  *
  * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
  *
+ * Datasheets:
+ * http://focus.ti.com/docs/prod/folders/print/bq27000.html
+ * http://focus.ti.com/docs/prod/folders/print/bq27500.html
+ *
  * This package is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -27,8 +32,9 @@
 #include <linux/slab.h>
 #include <asm/unaligned.h>

-#define DRIVER_VERSION			"1.1.0"
+#define DRIVER_VERSION			"1.2.0"

+#define BQ27x00_REG_MODE		0x00
 #define BQ27x00_REG_TEMP		0x06
 #define BQ27x00_REG_VOLT		0x08
 #define BQ27x00_REG_AI			0x14
@@ -36,11 +42,16 @@
 #define BQ27x00_REG_TTE			0x16
 #define BQ27x00_REG_TTF			0x18
 #define BQ27x00_REG_TTECP		0x26
+#define BQ27x00_REG_NAC			0x0C /* Nominal available capaciy */
+#define BQ27x00_REG_LMD			0x12 /* Last measured discharge */
+#define BQ27x00_REG_AE			0x22 /* Available Enery */

+#define BQ27000_RS			20 /* Resistor sense */
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27000_FLAG_CHGS		BIT(7)
+#define BQ27000_FLAG_FC			BIT(5)

-#define BQ27500_REG_SOC			0x2c
+#define BQ27500_REG_SOC			0x2C
 #define BQ27500_FLAG_DSC		BIT(0)
 #define BQ27500_FLAG_FC			BIT(9)

@@ -74,7 +85,11 @@ static enum power_supply_property bq27x0
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
@@ -91,6 +106,24 @@ static int bq27x00_read(u8 reg, int *rt_
 }

 /*
+ * Return the GPIO status (0 or 1)
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_gpio(struct bq27x00_device_info *di)
+{
+	int ret;
+	int gpio = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_MODE, &gpio, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading GPIO status\n");
+		return ret;
+	}
+
+	return (gpio & 0x40) >> 6;
+}
+
+/*
  * Return the battery temperature in tenths of degree Celsius
  * Or < 0 if something fails.
  */
@@ -112,7 +145,7 @@ static int bq27x00_battery_temperature(s
 }

 /*
- * Return the battery Voltage in milivolts
+ * Return the battery Voltage in µV
  * Or < 0 if something fails.
  */
 static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
@@ -130,7 +163,7 @@ static int bq27x00_battery_voltage(struc
 }

 /*
- * Return the battery average current
+ * Return the battery average current in µA
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
@@ -149,6 +182,7 @@ static int bq27x00_battery_current(struc
 	if (di->chip == BQ27500) {
 		/* bq27500 returns signed value */
 		curr = (int)(s16)curr;
+		curr *= 1000;
 	} else {
 		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
 		if (ret < 0) {
@@ -159,9 +193,10 @@ static int bq27x00_battery_current(struc
 			dev_dbg(di->dev, "negative current!\n");
 			curr = -curr;
 		}
+		curr = curr * 3570 / BQ27000_RS;
 	}

-	return curr * 1000;
+	return curr;
 }

 /*
@@ -185,6 +220,75 @@ static int bq27x00_battery_rsoc(struct b
 	return rsoc;
 }

+/*
+ * Return the battery Nominal available capaciy in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_nac(struct bq27x00_device_info *di)
+{
+	int ret;
+	int nac = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_NAC, &nac, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading nominal available capaciy\n");
+		return ret;
+	}
+
+	if (di->chip == BQ27500)
+		nac *= 1000;
+	else
+		nac = nac * 3570 / BQ27000_RS;
+
+	return nac;
+}
+
+/*
+ * Return the battery Last measured discharge in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_lmd(struct bq27x00_device_info *di)
+{
+	int ret;
+	int lmd = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_LMD, &lmd, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading last measured discharge\n");
+		return ret;
+	}
+
+	if (di->chip == BQ27500)
+		lmd *= 1000;
+	else
+		lmd = lmd * 3570 / BQ27000_RS;
+
+	return lmd;
+}
+
+/*
+ * Return the battery Available energy in µWh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_energy(struct bq27x00_device_info *di)
+{
+	int ret;
+	int ae = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_LMD, &ae, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading available energy\n");
+		return ret;
+	}
+
+	if (di->chip == BQ27500)
+		ae *= 1000;
+	else
+		ae = ae * 29200 / BQ27000_RS;
+
+	return ae;
+}
+
 static int bq27x00_battery_status(struct bq27x00_device_info *di,
 				  union power_supply_propval *val)
 {
@@ -206,7 +310,9 @@ static int bq27x00_battery_status(struct
 		else
 			status = POWER_SUPPLY_STATUS_CHARGING;
 	} else {
-		if (flags & BQ27000_FLAG_CHGS)
+		if (flags & BQ27000_FLAG_FC)
+			status = POWER_SUPPLY_STATUS_FULL;
+		else if (flags & BQ27000_FLAG_CHGS)
 			status = POWER_SUPPLY_STATUS_CHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
@@ -233,7 +339,7 @@ static int bq27x00_battery_time(struct b
 	}

 	if (tval == 65535)
-		return -ENODATA;
+		tval = 0;

 	val->intval = tval * 60;
 	return 0;
@@ -253,6 +359,9 @@ static int bq27x00_battery_get_property(
 	case POWER_SUPPLY_PROP_STATUS:
 		ret = bq27x00_battery_status(di, val);
 		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = bq27x00_battery_gpio(di);
+		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = bq27x00_battery_voltage(di);
@@ -265,6 +374,15 @@ static int bq27x00_battery_get_property(
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = bq27x00_battery_rsoc(di);
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = bq27x00_battery_nac(di);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		val->intval = bq27x00_battery_lmd(di);
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+		val->intval = bq27x00_battery_energy(di);
+		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = bq27x00_battery_temperature(di);
 		break;
@@ -469,4 +587,7 @@ module_exit(bq27x00_battery_exit);

 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
 MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
+MODULE_ALIAS("i2c:bq27000");
+MODULE_ALIAS("i2c:bq27200");
+MODULE_ALIAS("i2c:bq27500");
 MODULE_LICENSE("GPL");
