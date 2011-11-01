Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861Ab1KAAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:48:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab1KAArU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:47:20 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 5/9] bq27x00: Cache temperature value in converted unit
Date: Tue,  1 Nov 2011 01:43:07 +0100
Message-Id: <1320108191-6647-5-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c |   45 ++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index e9aeb53..a22124a 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -248,6 +248,28 @@ static int bq27x00_battery_read_energy(struct bq27x00_device_info *di)
 }
 
 /*
+ * Return the battery temperature in tenths of degree Celsius
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
+{
+	int temp;
+
+	temp = bq27x00_read(di, BQ27x00_REG_TEMP, false);
+	if (temp < 0) {
+		dev_err(di->dev, "error reading temperature\n");
+		return temp;
+	}
+
+	if (di->chip == BQ27500)
+		temp -= 2731;
+	else
+		temp = ((temp * 5) - 5463) / 2;
+
+	return temp;
+}
+
+/*
  * Return the battery Cycle count total
  * Or < 0 if something fails.
  */
@@ -304,7 +326,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
 			cache.charge_full = bq27x00_battery_read_lmd(di);
 		}
-		cache.temperature = bq27x00_read(di, BQ27x00_REG_TEMP, false);
+		cache.temperature = bq27x00_battery_read_temperature(di);
 		cache.cycle_count = bq27x00_battery_read_cyct(di);
 
 		/* We only have to read charge design full once */
@@ -334,25 +356,6 @@ static void bq27x00_battery_poll(struct work_struct *work)
 	}
 }
 
-
-/*
- * Return the battery temperature in tenths of degree Celsius
- * Or < 0 if something fails.
- */
-static int bq27x00_battery_temperature(struct bq27x00_device_info *di,
-	union power_supply_propval *val)
-{
-	if (di->cache.temperature < 0)
-		return di->cache.temperature;
-
-	if (di->chip == BQ27500)
-		val->intval = di->cache.temperature - 2731;
-	else
-		val->intval = ((di->cache.temperature * 5) - 5463) / 2;
-
-	return 0;
-}
-
 /*
  * Return the battery average current in µA
  * Note that current can be negative signed as well
@@ -511,7 +514,7 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 		ret = bq27x00_battery_capacity_level(di, val);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		ret = bq27x00_battery_temperature(di, val);
+		ret = bq27x00_simple_value(di->cache.temperature, val);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		ret = bq27x00_simple_value(di->cache.time_to_empty, val);
-- 
1.7.5.4

