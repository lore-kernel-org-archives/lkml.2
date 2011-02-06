Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1BFUoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:44:06 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1240 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753896Ab1BFUoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:44:03 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 09/14] POWER: bq27x00: Add new properties
Date: Sun,  6 Feb 2011 01:48:06 +0100
Message-Id: <1296953291-10373-10-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

This patch add support for reporting properties
POWER_SUPPLY_PROP_CHARGE_NOW, POWER_SUPPLY_PROP_CHARGE_FULL,
POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
POWER_SUPPLY_PROP_CHARGE_COUNTER, POWER_SUPPLY_PROP_ENERGY_NOW in
module bq27x00_battery.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |  158 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 0dc7771..49affd6 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -16,6 +16,13 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  *
  */
+
+/*
+ * Datasheets:
+ * http://focus.ti.com/docs/prod/folders/print/bq27000.html
+ * http://focus.ti.com/docs/prod/folders/print/bq27500.html
+ */
+
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/jiffies.h>
@@ -30,7 +37,7 @@
 
 #include <linux/power/bq27x00_battery.h>
 
-#define DRIVER_VERSION			"1.1.0"
+#define DRIVER_VERSION			"1.2.0"
 
 #define BQ27x00_REG_TEMP		0x06
 #define BQ27x00_REG_VOLT		0x08
@@ -39,11 +46,17 @@
 #define BQ27x00_REG_TTE			0x16
 #define BQ27x00_REG_TTF			0x18
 #define BQ27x00_REG_TTECP		0x26
+#define BQ27x00_REG_NAC			0x0C /* Nominal available capaciy */
+#define BQ27x00_REG_LMD			0x12 /* Last measured discharge */
+#define BQ27x00_REG_CYCT		0x2A /* Cycle count total */
+#define BQ27x00_REG_AE			0x22 /* Available enery */
 
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
 #define BQ27000_FLAG_CHGS		BIT(7)
 
 #define BQ27500_REG_SOC			0x2c
+#define BQ27500_REG_DCAP		0x3C /* Design capacity */
 #define BQ27500_FLAG_DSC		BIT(0)
 #define BQ27500_FLAG_FC			BIT(9)
 
@@ -61,11 +74,15 @@ struct bq27x00_reg_cache {
 	int time_to_empty;
 	int time_to_empty_avg;
 	int time_to_full;
+	int charge_full;
+	int charge_counter;
 	int capacity;
 	int flags;
 
 	int voltage;
+	int charge_now;
 	int current_now;
+	int energy_now;
 };
 
 struct bq27x00_device_info {
@@ -74,6 +91,8 @@ struct bq27x00_device_info {
 	enum bq27x00_chip	chip;
 
 	struct bq27x00_reg_cache cache;
+	int charge_design_full;
+
 	unsigned long last_update;
 	struct delayed_work work;
 
@@ -93,6 +112,11 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
 };
 
 static unsigned int poll_interval = 360;
@@ -145,6 +169,113 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 }
 
 /*
+ * Return the battery Nominal available capaciy in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
+{
+	int nac;
+
+	nac = bq27x00_read(di, BQ27x00_REG_NAC, false);
+	if (nac < 0) {
+		dev_err(di->dev, "error reading nominal available capacity\n");
+		return nac;
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
+static int bq27x00_battery_read_lmd(struct bq27x00_device_info *di)
+{
+	int lmd;
+
+	lmd = bq27x00_read(di, BQ27x00_REG_LMD, false);
+	if (lmd < 0) {
+		dev_err(di->dev, "error reading last measured discharge\n");
+		return lmd;
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
+ * Return the battery Initial last measured discharge in µAh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
+{
+	int ilmd;
+
+	if (di->chip == BQ27500)
+		ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
+	else
+		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
+
+	if (ilmd < 0) {
+		dev_err(di->dev, "error reading initial last measured discharge\n");
+		return ilmd;
+	}
+
+	if (di->chip == BQ27500)
+		ilmd *= 1000;
+	else
+		ilmd = ilmd * 256 * 3570 / BQ27000_RS;
+
+	return ilmd;
+}
+
+/*
+ * Return the battery Cycle count total
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_read_cyct(struct bq27x00_device_info *di)
+{
+	int cyct;
+
+	cyct = bq27x00_read(di, BQ27x00_REG_CYCT, false);
+	if (cyct < 0)
+		dev_err(di->dev, "error reading cycle count total\n");
+
+	return cyct;
+}
+
+/*
+ * Return the battery Available energy in µWh
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_read_energy(struct bq27x00_device_info *di)
+{
+	int ae;
+
+	ae = bq27x00_read(di, BQ27x00_REG_AE, false);
+	if (ae < 0) {
+		dev_err(di->dev, "error reading available energy\n");
+		return ae;
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
+/*
  * Read a time register.
  * Return < 0 if something fails.
  */
@@ -178,11 +309,19 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 		cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
 		cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
 		cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
+		cache.charge_now = bq27x00_battery_read_nac(di);
+		cache.charge_full = bq27x00_battery_read_lmd(di);
+		cache.charge_counter = bq27x00_battery_read_cyct(di);
+		cache.energy_now = bq27x00_battery_read_energy(di);
+
+		/* We only have to read charge design full once */
+		if (di->charge_design_full <= 0)
+			di->charge_design_full = bq27x00_battery_read_ilmd(di);
 	}
 
 	/* Ignore those values which are snapshots of the current battery state
 	 * and are likely to be different even between two consecutive reads */
-	if (memcmp(&di->cache, &cache, sizeof(cache) - 2*sizeof(int)) != 0) {
+	if (memcmp(&di->cache, &cache, sizeof(cache) - 4*sizeof(int)) != 0) {
 		di->cache = cache;
 		power_supply_changed(&di->bat);
 	}
@@ -325,6 +464,21 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		ret = bq27x00_simple_value(di->cache.charge_now, val);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		ret = bq27x00_simple_value(di->cache.charge_full, val);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		ret = bq27x00_simple_value(di->charge_design_full, val);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret = bq27x00_simple_value(di->cache.charge_counter, val);
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+		ret = bq27x00_simple_value(di->cache.energy_now, val);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.2.3

