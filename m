Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0EQTqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:46:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56312 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab0EQTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RSG1w8CvYkRgL5zpCRb/JH8V1RUtqehNDmPLNQBgZmZbPGkKjekhZoCfyDIBI6O8jB
         3aWvSNzYyrdHLR6DmmpZBl1/OaRsGnfy56cT2pAXAaJGDQDxbour1Wz6ubkL5CWXRCRV
         ufuDl8RYt76CsVtmmkoPnkGjQf821JzbHh9So=
Date: Mon, 17 May 2010 23:46:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>
Subject: [PATCH] power_supply: Add test_power driver
Message-ID: <20100517194645.GA17322@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a handy driver that is used for testing purposes.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Just posting it for review. I'm going to apply it to battery-2.6.git.

 drivers/power/Kconfig      |    5 ++
 drivers/power/Makefile     |    1 +
 drivers/power/test_power.c |  163 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/test_power.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c59bcb7..8e9ba17 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -57,6 +57,11 @@ config WM8350_POWER
           Say Y here to enable support for the power management unit
 	  provided by the Wolfson Microelectronics WM8350 PMIC.
 
+config TEST_POWER
+	tristate "Test power driver"
+	help
+	  This driver is used for testing. It's safe to say M here.
+
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
 	select W1
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index a82f292..0005080 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_MAX8925_POWER)	+= max8925_power.o
 obj-$(CONFIG_WM831X_BACKUP)	+= wm831x_backup.o
 obj-$(CONFIG_WM831X_POWER)	+= wm831x_power.o
 obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
+obj-$(CONFIG_TEST_POWER)	+= test_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
new file mode 100644
index 0000000..0cd9f67
--- /dev/null
+++ b/drivers/power/test_power.c
@@ -0,0 +1,163 @@
+/*
+ * Power supply driver for testing.
+ *
+ * Copyright 2010  Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/power_supply.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/vermagic.h>
+
+static int test_power_ac_online = 1;
+static int test_power_battery_status = POWER_SUPPLY_STATUS_CHARGING;
+
+static int test_power_get_ac_property(struct power_supply *psy,
+				      enum power_supply_property psp,
+				      union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = test_power_ac_online;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int test_power_get_battery_property(struct power_supply *psy,
+					   enum power_supply_property psp,
+					   union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = "Test battery";
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = "Linux";
+		break;
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		val->strval = UTS_RELEASE;
+		break;
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = test_power_battery_status;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = 50;
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
+		val->intval = 3600;
+		break;
+	default:
+		pr_info("%s: some properties deliberately report errors.\n",
+			__func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static enum power_supply_property test_power_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static enum power_supply_property test_power_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_EMPTY,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+};
+
+static char *test_power_ac_supplied_to[] = {
+	"test_battery",
+};
+
+static struct power_supply test_power_supplies[] = {
+	{
+		.name = "test_ac",
+		.type = POWER_SUPPLY_TYPE_MAINS,
+		.supplied_to = test_power_ac_supplied_to,
+		.num_supplicants = ARRAY_SIZE(test_power_ac_supplied_to),
+		.properties = test_power_ac_props,
+		.num_properties = ARRAY_SIZE(test_power_ac_props),
+		.get_property = test_power_get_ac_property,
+	}, {
+		.name = "test_battery",
+		.type = POWER_SUPPLY_TYPE_BATTERY,
+		.properties = test_power_battery_props,
+		.num_properties = ARRAY_SIZE(test_power_battery_props),
+		.get_property = test_power_get_battery_property,
+	},
+};
+
+static int __init test_power_init(void)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++) {
+		ret = power_supply_register(NULL, &test_power_supplies[i]);
+		if (ret) {
+			pr_err("%s: failed to register %s\n", __func__,
+				test_power_supplies[i].name);
+			goto failed;
+		}
+	}
+
+	return 0;
+failed:
+	while (--i >= 0)
+		power_supply_unregister(&test_power_supplies[i]);
+	return ret;
+}
+module_init(test_power_init);
+
+static void __exit test_power_exit(void)
+{
+	int i;
+
+	/* Let's see how we handle changes... */
+	test_power_ac_online = 0;
+	test_power_battery_status = POWER_SUPPLY_STATUS_DISCHARGING;
+	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
+		power_supply_changed(&test_power_supplies[i]);
+	pr_info("%s: 'changed' event sent, sleeping for 10 seconds...\n",
+		__func__);
+	ssleep(10);
+
+	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++)
+		power_supply_unregister(&test_power_supplies[i]);
+}
+module_exit(test_power_exit);
+
+MODULE_DESCRIPTION("Power supply driver for testing");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.1
