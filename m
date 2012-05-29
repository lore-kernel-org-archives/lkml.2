Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2E2Jhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:37:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61820 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2E2Jhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:37:53 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] test_power: add support for USB AC source
Date: Tue, 29 May 2012 13:37:43 +0400
Message-Id: <1338284264-6193-1-git-send-email-dmitry_eremin@mentor.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually a device has both AC plug and UDC plug usable for charging.
Provide both AC sources.

Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
---
 drivers/power/test_power.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index b527c93..a61b596 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -22,6 +22,7 @@
 #include <linux/vermagic.h>
 
 static int ac_online			= 1;
+static int usb_online			= 1;
 static int battery_status		= POWER_SUPPLY_STATUS_DISCHARGING;
 static int battery_health		= POWER_SUPPLY_HEALTH_GOOD;
 static int battery_present		= 1; /* true */
@@ -42,6 +43,20 @@ static int test_power_get_ac_property(struct power_supply *psy,
 	return 0;
 }
 
+static int test_power_get_usb_property(struct power_supply *psy,
+				      enum power_supply_property psp,
+				      union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = usb_online;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int test_power_get_battery_property(struct power_supply *psy,
 					   enum power_supply_property psp,
 					   union power_supply_propval *val)
@@ -135,6 +150,14 @@ static struct power_supply test_power_supplies[] = {
 		.properties = test_power_battery_props,
 		.num_properties = ARRAY_SIZE(test_power_battery_props),
 		.get_property = test_power_get_battery_property,
+	}, {
+		.name = "test_usb",
+		.type = POWER_SUPPLY_TYPE_USB,
+		.supplied_to = test_power_ac_supplied_to,
+		.num_supplicants = ARRAY_SIZE(test_power_ac_supplied_to),
+		.properties = test_power_ac_props,
+		.num_properties = ARRAY_SIZE(test_power_ac_props),
+		.get_property = test_power_get_usb_property,
 	},
 };
 
@@ -167,6 +190,7 @@ static void __exit test_power_exit(void)
 
 	/* Let's see how we handle changes... */
 	ac_online = 0;
+	usb_online = 0;
 	battery_status = POWER_SUPPLY_STATUS_DISCHARGING;
 	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
 		power_supply_changed(&test_power_supplies[i]);
@@ -275,6 +299,19 @@ static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 	return strlen(buffer);
 }
 
+static int param_set_usb_online(const char *key, const struct kernel_param *kp)
+{
+	usb_online = map_get_value(map_ac_online, key, usb_online);
+	power_supply_changed(&test_power_supplies[2]);
+	return 0;
+}
+
+static int param_get_usb_online(char *buffer, const struct kernel_param *kp)
+{
+	strcpy(buffer, map_get_key(map_ac_online, usb_online, "unknown"));
+	return strlen(buffer);
+}
+
 static int param_set_battery_status(const char *key,
 					const struct kernel_param *kp)
 {
@@ -350,13 +387,31 @@ static int param_set_battery_capacity(const char *key,
 
 #define param_get_battery_capacity param_get_int
 
+static int param_set_battery_voltage(const char *key,
+					const struct kernel_param *kp)
+{
+	int tmp;
 
+	if (1 != sscanf(key, "%d", &tmp))
+		return -EINVAL;
+
+	battery_voltage = tmp;
+	power_supply_changed(&test_power_supplies[1]);
+	return 0;
+}
+
+#define param_get_battery_voltage param_get_int
 
 static struct kernel_param_ops param_ops_ac_online = {
 	.set = param_set_ac_online,
 	.get = param_get_ac_online,
 };
 
+static struct kernel_param_ops param_ops_usb_online = {
+	.set = param_set_usb_online,
+	.get = param_get_usb_online,
+};
+
 static struct kernel_param_ops param_ops_battery_status = {
 	.set = param_set_battery_status,
 	.get = param_get_battery_status,
@@ -384,6 +439,7 @@ static struct kernel_param_ops param_ops_battery_capacity = {
 
 
 #define param_check_ac_online(name, p) __param_check(name, p, void);
+#define param_check_usb_online(name, p) __param_check(name, p, void);
 #define param_check_battery_status(name, p) __param_check(name, p, void);
 #define param_check_battery_present(name, p) __param_check(name, p, void);
 #define param_check_battery_technology(name, p) __param_check(name, p, void);
@@ -394,6 +450,9 @@ static struct kernel_param_ops param_ops_battery_capacity = {
 module_param(ac_online, ac_online, 0644);
 MODULE_PARM_DESC(ac_online, "AC charging state <on|off>");
 
+module_param(usb_online, usb_online, 0644);
+MODULE_PARM_DESC(usb_online, "USB charging state <on|off>");
+
 module_param(battery_status, battery_status, 0644);
 MODULE_PARM_DESC(battery_status,
 	"battery status <charging|discharging|not-charging|full>");
-- 
1.7.10

