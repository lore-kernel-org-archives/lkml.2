Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab2EQHVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:21:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18027 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188Ab2EQHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:21:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 May 2012 00:21:39 -0700
From: Syed Rafiuddin <srafiuddin@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Syed Rafiuddin <srafiuddin@nvidia.com>
Subject: [PATCH] power: bq27x00: power average and health properties
Date: Thu, 17 May 2012 12:51:15 +0530
Message-ID: <1337239275-15661-1-git-send-email-srafiuddin@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addition of power average and health properties

Signed-off-by: Syed Rafiuddin <srafiuddin@nvidia.com>
---
 drivers/power/bq27x00_battery.c |   71 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index f5d6d37..5657990 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -51,6 +51,7 @@
 #define BQ27x00_REG_LMD			0x12 /* Last measured discharge */
 #define BQ27x00_REG_CYCT		0x2A /* Cycle count total */
 #define BQ27x00_REG_AE			0x22 /* Available energy */
+#define BQ27x00_POWER_AVG		0x24
 
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
@@ -66,8 +67,10 @@
 #define BQ27500_FLAG_SOCF		BIT(1) /* State-of-Charge threshold final */
 #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
 #define BQ27500_FLAG_FC			BIT(9)
+#define BQ27500_FLAG_OTC		BIT(15)
 
 #define BQ27000_RS			20 /* Resistor sense */
+#define BQ27x00_POWER_CONSTANT		(256 * 29200 / 1000)
 
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
@@ -86,6 +89,8 @@ struct bq27x00_reg_cache {
 	int capacity;
 	int energy;
 	int flags;
+	int power_avg;
+	int health;
 };
 
 struct bq27x00_device_info {
@@ -123,6 +128,8 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_POWER_AVG,
+	POWER_SUPPLY_PROP_HEALTH,
 };
 
 static unsigned int poll_interval = 360;
@@ -306,6 +313,60 @@ static int bq27x00_battery_read_time(struct bq27x00_device_info *di, u8 reg)
 	return tval * 60;
 }
 
+/*
+ * Read a power avg register.
+ * Return < 0 if something fails.
+ */
+static int bq27x00_battery_read_pwr_avg(struct bq27x00_device_info *di, u8 reg)
+{
+	int tval;
+
+	tval = bq27x00_read(di, reg, false);
+	if (tval < 0) {
+		dev_err(di->dev, "error reading power avg rgister  %02x: %d\n",
+			reg, tval);
+		return tval;
+	}
+
+	if (di->chip == BQ27500)
+		return tval;
+	else
+		return (tval * BQ27x00_POWER_CONSTANT) / BQ27000_RS;
+}
+
+/*
+ * Read flag register.
+ * Return < 0 if something fails.
+ */
+static int bq27x00_battery_read_health(struct bq27x00_device_info *di)
+{
+	int tval;
+
+	tval = bq27x00_read(di, BQ27x00_REG_FLAGS, false);
+	if (tval < 0) {
+		dev_err(di->dev, "error reading flag register:%d\n", tval);
+		return tval;
+	}
+
+	if ((di->chip == BQ27500)) {
+		if (tval & BQ27500_FLAG_SOCF)
+			tval = POWER_SUPPLY_HEALTH_DEAD;
+		else if (tval & BQ27500_FLAG_OTC)
+			tval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else
+			tval = POWER_SUPPLY_HEALTH_GOOD;
+		return tval;
+	} else {
+		if (tval & BQ27000_FLAG_EDV1)
+			tval = POWER_SUPPLY_HEALTH_DEAD;
+		else
+			tval = POWER_SUPPLY_HEALTH_GOOD;
+		return tval;
+	}
+
+	return -1;
+}
+
 static void bq27x00_update(struct bq27x00_device_info *di)
 {
 	struct bq27x00_reg_cache cache = {0, };
@@ -321,6 +382,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			cache.time_to_empty_avg = -ENODATA;
 			cache.time_to_full = -ENODATA;
 			cache.charge_full = -ENODATA;
+			cache.health = -ENODATA;
 		} else {
 			cache.capacity = bq27x00_battery_read_rsoc(di);
 			cache.energy = bq27x00_battery_read_energy(di);
@@ -328,9 +390,12 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
 			cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
 			cache.charge_full = bq27x00_battery_read_lmd(di);
+			cache.health = bq27x00_battery_read_health(di);
 		}
 		cache.temperature = bq27x00_battery_read_temperature(di);
 		cache.cycle_count = bq27x00_battery_read_cyct(di);
+		cache.power_avg =
+			bq27x00_battery_read_pwr_avg(di, BQ27x00_POWER_AVG);
 
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
@@ -550,6 +615,12 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 		ret = bq27x00_simple_value(di->cache.energy, val);
 		break;
+	case POWER_SUPPLY_PROP_POWER_AVG:
+		ret = bq27x00_simple_value(di->cache.power_avg, val);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = bq27x00_simple_value(di->cache.health, val);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.0.4

