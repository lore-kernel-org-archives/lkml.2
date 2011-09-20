Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1ITPUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:20:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1ITPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:20:03 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=204/7=5D=20bq27x00=3A=20Cache=20energy=20property?=
Date: Tue, 20 Sep 2011 17:18:50 +0200
Message-Id: <1316531933-7159-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/power/bq27x00_battery.c |   53 +++++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 6c8dfdb..e9aeb53 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -84,6 +84,7 @@ struct bq27x00_reg_cache {
 	int charge_full;
 	int cycle_count;
 	int capacity;
+	int energy;
 	int flags;
 };
 
@@ -225,6 +226,28 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 }
 
 /*
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
  * Return the battery Cycle count total
  * Or < 0 if something fails.
  */
@@ -268,12 +291,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
 			cache.capacity = -ENODATA;
+			cache.energy = -ENODATA;
 			cache.time_to_empty = -ENODATA;
 			cache.time_to_empty_avg = -ENODATA;
 			cache.time_to_full = -ENODATA;
 			cache.charge_full = -ENODATA;
 		} else {
 			cache.capacity = bq27x00_battery_read_rsoc(di);
+			cache.energy = bq27x00_battery_read_energy(di);
 			cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
 			cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
 			cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
@@ -435,32 +460,6 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di,
 	return 0;
 }
 
-/*
- * Return the battery Available energy in µWh
- * Or < 0 if something fails.
- */
-static int bq27x00_battery_energy(struct bq27x00_device_info *di,
-	union power_supply_propval *val)
-{
-	int ae;
-
-	ae = bq27x00_read(di, BQ27x00_REG_AE, false);
-	if (ae < 0) {
-		dev_err(di->dev, "error reading available energy\n");
-		return ae;
-	}
-
-	if (di->chip == BQ27500)
-		ae *= 1000;
-	else
-		ae = ae * 29200 / BQ27000_RS;
-
-	val->intval = ae;
-
-	return 0;
-}
-
-
 static int bq27x00_simple_value(int value,
 	union power_supply_propval *val)
 {
@@ -539,7 +538,7 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 		ret = bq27x00_simple_value(di->cache.cycle_count, val);
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		ret = bq27x00_battery_energy(di, val);
+		ret = bq27x00_simple_value(di->cache.energy, val);
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.4.1

