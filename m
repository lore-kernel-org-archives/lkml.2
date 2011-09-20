Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1ITPUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:20:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1ITPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:19:57 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/7] bq27x00: Add support for property POWER_SUPPLY_PROP_CAPACITY_LEVEL
Date: Tue, 20 Sep 2011 17:18:48 +0200
Message-Id: <1316531933-7159-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/power/bq27x00_battery.c |   40 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index d238144..a531122 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -54,12 +54,16 @@
 
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
-#define BQ27000_FLAG_CHGS		BIT(7)
+#define BQ27000_FLAG_EDVF		BIT(0) /* Final End-of-Discharge-Voltage flag */
+#define BQ27000_FLAG_EDV1		BIT(1) /* First End-of-Discharge-Voltage flag */
 #define BQ27000_FLAG_FC			BIT(5)
+#define BQ27000_FLAG_CHGS		BIT(7) /* Charge state flag */
 
 #define BQ27500_REG_SOC			0x2C
 #define BQ27500_REG_DCAP		0x3C /* Design capacity */
 #define BQ27500_FLAG_DSC		BIT(0)
+#define BQ27500_FLAG_SOCF		BIT(1) /* State-of-Charge threshold final */
+#define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
 #define BQ27500_FLAG_FC			BIT(9)
 
 #define BQ27000_RS			20 /* Resistor sense */
@@ -106,6 +110,7 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
@@ -373,6 +378,36 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 	return 0;
 }
 
+static int bq27x00_battery_capacity_level(struct bq27x00_device_info *di,
+	union power_supply_propval *val)
+{
+	int level;
+
+	if (di->chip == BQ27500) {
+		if (di->cache.flags & BQ27500_FLAG_FC)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+		else if (di->cache.flags & BQ27500_FLAG_SOC1)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
+		else if (di->cache.flags & BQ27500_FLAG_SOCF)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
+		else
+			level = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+	} else {
+		if (di->cache.flags & BQ27000_FLAG_FC)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+		else if (di->cache.flags & BQ27000_FLAG_EDV1)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
+		else if (di->cache.flags & BQ27000_FLAG_EDVF)
+			level = POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
+		else
+			level = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+	}
+
+	val->intval = level;
+
+	return 0;
+}
+
 /*
  * Return the battery Voltage in milivolts
  * Or < 0 if something fails.
@@ -464,6 +499,9 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = bq27x00_simple_value(di->cache.capacity, val);
 		break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		ret = bq27x00_battery_capacity_level(di, val);
+		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = bq27x00_battery_temperature(di, val);
 		break;
-- 
1.7.4.1

