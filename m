Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab1DZDZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:25:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54674 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935Ab1DZDZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:25:34 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Akihiro MAEDA <sola.1980.a@gmail.com>,
        Masashi YOKOTA <yokota@pylone.jp>
Subject: [PATCH] power: Make test_power driver more dynamic.
Date: Mon, 25 Apr 2011 20:25:24 -0700
Message-Id: <1303788324-26084-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2008 Masashi YOKOTA <yokota@pylone.jp> created the virtual
battery driver found here:
http://downloads.pylone.jp/src/virtual_battery/virtual_battery-0.0.1.tar.bz2

It found use out of tree, but was never merged upstream.
Since then the test_power driver has been merged, which provides
very similar functionality.

This patch extends the test_power driver to be more dynamic
at runtime, by merging portions of the Virtual Battery Driver
by Masashi YOKOTA.

With this patch, I can tweak the values in:
/sys/module/test_power/parameters/* and watch the behavior of
the gnome power managment daemon or other battery UI software.

CC: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Akihiro MAEDA <sola.1980.a@gmail.com>
CC: Masashi YOKOTA <yokota@pylone.jp>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/power/test_power.c |  276 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 266 insertions(+), 10 deletions(-)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index 0cd9f67..b527c93 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -3,6 +3,12 @@
  *
  * Copyright 2010  Anton Vorontsov <cbouatmailru@gmail.com>
  *
+ * Dynamic module parameter code from the Virtual Battery Driver
+ * Copyright (C) 2008 Pylone, Inc.
+ * By: Masashi YOKOTA <yokota@pylone.jp>
+ * Originally found here:
+ * http://downloads.pylone.jp/src/virtual_battery/virtual_battery-0.0.1.tar.bz2
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -15,8 +21,12 @@
 #include <linux/delay.h>
 #include <linux/vermagic.h>
 
-static int test_power_ac_online = 1;
-static int test_power_battery_status = POWER_SUPPLY_STATUS_CHARGING;
+static int ac_online			= 1;
+static int battery_status		= POWER_SUPPLY_STATUS_DISCHARGING;
+static int battery_health		= POWER_SUPPLY_HEALTH_GOOD;
+static int battery_present		= 1; /* true */
+static int battery_technology		= POWER_SUPPLY_TECHNOLOGY_LION;
+static int battery_capacity		= 50;
 
 static int test_power_get_ac_property(struct power_supply *psy,
 				      enum power_supply_property psp,
@@ -24,7 +34,7 @@ static int test_power_get_ac_property(struct power_supply *psy,
 {
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-		val->intval = test_power_ac_online;
+		val->intval = ac_online;
 		break;
 	default:
 		return -EINVAL;
@@ -47,22 +57,30 @@ static int test_power_get_battery_property(struct power_supply *psy,
 		val->strval = UTS_RELEASE;
 		break;
 	case POWER_SUPPLY_PROP_STATUS:
-		val->intval = test_power_battery_status;
+		val->intval = battery_status;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
 		val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
-		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		val->intval = battery_health;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = battery_present;
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		val->intval = battery_technology;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
 		val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = 50;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = battery_capacity;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		val->intval = 100;
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
@@ -84,9 +102,11 @@ static enum power_supply_property test_power_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
-	POWER_SUPPLY_PROP_CHARGE_EMPTY,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
@@ -118,6 +138,7 @@ static struct power_supply test_power_supplies[] = {
 	},
 };
 
+
 static int __init test_power_init(void)
 {
 	int i;
@@ -145,8 +166,8 @@ static void __exit test_power_exit(void)
 	int i;
 
 	/* Let's see how we handle changes... */
-	test_power_ac_online = 0;
-	test_power_battery_status = POWER_SUPPLY_STATUS_DISCHARGING;
+	ac_online = 0;
+	battery_status = POWER_SUPPLY_STATUS_DISCHARGING;
 	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
 		power_supply_changed(&test_power_supplies[i]);
 	pr_info("%s: 'changed' event sent, sleeping for 10 seconds...\n",
@@ -158,6 +179,241 @@ static void __exit test_power_exit(void)
 }
 module_exit(test_power_exit);
 
+
+
+#define MAX_KEYLENGTH 256
+struct battery_property_map {
+	int value;
+	char const *key;
+};
+
+static struct battery_property_map map_ac_online[] = {
+	{ 0,  "on"  },
+	{ 1,  "off" },
+	{ -1, NULL  },
+};
+
+static struct battery_property_map map_status[] = {
+	{ POWER_SUPPLY_STATUS_CHARGING,     "charging"     },
+	{ POWER_SUPPLY_STATUS_DISCHARGING,  "discharging"  },
+	{ POWER_SUPPLY_STATUS_NOT_CHARGING, "not-charging" },
+	{ POWER_SUPPLY_STATUS_FULL,         "full"         },
+	{ -1,                               NULL           },
+};
+
+static struct battery_property_map map_health[] = {
+	{ POWER_SUPPLY_HEALTH_GOOD,           "good"        },
+	{ POWER_SUPPLY_HEALTH_OVERHEAT,       "overheat"    },
+	{ POWER_SUPPLY_HEALTH_DEAD,           "dead"        },
+	{ POWER_SUPPLY_HEALTH_OVERVOLTAGE,    "overvoltage" },
+	{ POWER_SUPPLY_HEALTH_UNSPEC_FAILURE, "failure"     },
+	{ -1,                                 NULL          },
+};
+
+static struct battery_property_map map_present[] = {
+	{ 0,  "false" },
+	{ 1,  "true"  },
+	{ -1, NULL    },
+};
+
+static struct battery_property_map map_technology[] = {
+	{ POWER_SUPPLY_TECHNOLOGY_NiMH, "NiMH" },
+	{ POWER_SUPPLY_TECHNOLOGY_LION, "LION" },
+	{ POWER_SUPPLY_TECHNOLOGY_LIPO, "LIPO" },
+	{ POWER_SUPPLY_TECHNOLOGY_LiFe, "LiFe" },
+	{ POWER_SUPPLY_TECHNOLOGY_NiCd, "NiCd" },
+	{ POWER_SUPPLY_TECHNOLOGY_LiMn, "LiMn" },
+	{ -1,				NULL   },
+};
+
+
+static int map_get_value(struct battery_property_map *map, const char *key,
+				int def_val)
+{
+	char buf[MAX_KEYLENGTH];
+	int cr;
+
+	strncpy(buf, key, MAX_KEYLENGTH);
+	buf[MAX_KEYLENGTH-1] = '\0';
+
+	cr = strnlen(buf, MAX_KEYLENGTH) - 1;
+	if (buf[cr] == '\n')
+		buf[cr] = '\0';
+
+	while (map->key) {
+		if (strncasecmp(map->key, buf, MAX_KEYLENGTH) == 0)
+			return map->value;
+		map++;
+	}
+
+	return def_val;
+}
+
+
+static const char *map_get_key(struct battery_property_map *map, int value,
+				const char *def_key)
+{
+	while (map->key) {
+		if (map->value == value)
+			return map->key;
+		map++;
+	}
+
+	return def_key;
+}
+
+static int param_set_ac_online(const char *key, const struct kernel_param *kp)
+{
+	ac_online = map_get_value(map_ac_online, key, ac_online);
+	power_supply_changed(&test_power_supplies[0]);
+	return 0;
+}
+
+static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
+{
+	strcpy(buffer, map_get_key(map_ac_online, ac_online, "unknown"));
+	return strlen(buffer);
+}
+
+static int param_set_battery_status(const char *key,
+					const struct kernel_param *kp)
+{
+	battery_status = map_get_value(map_status, key, battery_status);
+	power_supply_changed(&test_power_supplies[1]);
+	return 0;
+}
+
+static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
+{
+	strcpy(buffer, map_get_key(map_status, battery_status, "unknown"));
+	return strlen(buffer);
+}
+
+static int param_set_battery_health(const char *key,
+					const struct kernel_param *kp)
+{
+	battery_health = map_get_value(map_health, key, battery_health);
+	power_supply_changed(&test_power_supplies[1]);
+	return 0;
+}
+
+static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
+{
+	strcpy(buffer, map_get_key(map_health, battery_health, "unknown"));
+	return strlen(buffer);
+}
+
+static int param_set_battery_present(const char *key,
+					const struct kernel_param *kp)
+{
+	battery_present = map_get_value(map_present, key, battery_present);
+	power_supply_changed(&test_power_supplies[0]);
+	return 0;
+}
+
+static int param_get_battery_present(char *buffer,
+					const struct kernel_param *kp)
+{
+	strcpy(buffer, map_get_key(map_present, battery_present, "unknown"));
+	return strlen(buffer);
+}
+
+static int param_set_battery_technology(const char *key,
+					const struct kernel_param *kp)
+{
+	battery_technology = map_get_value(map_technology, key,
+						battery_technology);
+	power_supply_changed(&test_power_supplies[1]);
+	return 0;
+}
+
+static int param_get_battery_technology(char *buffer,
+					const struct kernel_param *kp)
+{
+	strcpy(buffer,
+		map_get_key(map_technology, battery_technology, "unknown"));
+	return strlen(buffer);
+}
+
+static int param_set_battery_capacity(const char *key,
+					const struct kernel_param *kp)
+{
+	int tmp;
+
+	if (1 != sscanf(key, "%d", &tmp))
+		return -EINVAL;
+
+	battery_capacity = tmp;
+	power_supply_changed(&test_power_supplies[1]);
+	return 0;
+}
+
+#define param_get_battery_capacity param_get_int
+
+
+
+static struct kernel_param_ops param_ops_ac_online = {
+	.set = param_set_ac_online,
+	.get = param_get_ac_online,
+};
+
+static struct kernel_param_ops param_ops_battery_status = {
+	.set = param_set_battery_status,
+	.get = param_get_battery_status,
+};
+
+static struct kernel_param_ops param_ops_battery_present = {
+	.set = param_set_battery_present,
+	.get = param_get_battery_present,
+};
+
+static struct kernel_param_ops param_ops_battery_technology = {
+	.set = param_set_battery_technology,
+	.get = param_get_battery_technology,
+};
+
+static struct kernel_param_ops param_ops_battery_health = {
+	.set = param_set_battery_health,
+	.get = param_get_battery_health,
+};
+
+static struct kernel_param_ops param_ops_battery_capacity = {
+	.set = param_set_battery_capacity,
+	.get = param_get_battery_capacity,
+};
+
+
+#define param_check_ac_online(name, p) __param_check(name, p, void);
+#define param_check_battery_status(name, p) __param_check(name, p, void);
+#define param_check_battery_present(name, p) __param_check(name, p, void);
+#define param_check_battery_technology(name, p) __param_check(name, p, void);
+#define param_check_battery_health(name, p) __param_check(name, p, void);
+#define param_check_battery_capacity(name, p) __param_check(name, p, void);
+
+
+module_param(ac_online, ac_online, 0644);
+MODULE_PARM_DESC(ac_online, "AC charging state <on|off>");
+
+module_param(battery_status, battery_status, 0644);
+MODULE_PARM_DESC(battery_status,
+	"battery status <charging|discharging|not-charging|full>");
+
+module_param(battery_present, battery_present, 0644);
+MODULE_PARM_DESC(battery_present,
+	"battery presence state <good|overheat|dead|overvoltage|failure>");
+
+module_param(battery_technology, battery_technology, 0644);
+MODULE_PARM_DESC(battery_technology,
+	"battery technology <NiMH|LION|LIPO|LiFe|NiCd|LiMn>");
+
+module_param(battery_health, battery_health, 0644);
+MODULE_PARM_DESC(battery_health,
+	"battery health state <good|overheat|dead|overvoltage|failure>");
+
+module_param(battery_capacity, battery_capacity, 0644);
+MODULE_PARM_DESC(battery_capacity, "battery capacity (percentage)");
+
+
 MODULE_DESCRIPTION("Power supply driver for testing");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.3.2.146.gca209

