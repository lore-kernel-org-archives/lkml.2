Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2DJS5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:57:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:24289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2DJS5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127429646"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add voltage_ocv property and use it for max17042 driver
Date: Tue, 10 Apr 2012 16:21:20 +0530
Message-Id: <1334055080-19521-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new sysfs file called 'voltage_ocv' which gives the
Open Circuit Voltage of the battery.

This property can be used for platform shutdown policies and
can be useful for initial capacity estimations.

Note: This patch is generated against linux-next branch.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    2 ++
 drivers/power/max17042_battery.c           |    8 ++++++++
 drivers/power/power_supply_sysfs.c         |    1 +
 include/linux/power_supply.h               |    2 ++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 9f16c51..211831d 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -84,6 +84,8 @@ are already charged or discharging, 'n/a' can be displayed (or
 HEALTH - represents health of the battery, values corresponds to
 POWER_SUPPLY_HEALTH_*, defined in battery.h.
 
+VOLTAGE_OCV - open circuit voltage of the battery.
+
 VOLTAGE_MAX_DESIGN, VOLTAGE_MIN_DESIGN - design values for maximal and
 minimal power supply voltages. Maximal/minimal means values of voltages
 when battery considered "full"/"empty" at normal conditions. Yes, there is
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 04620c2..915767d 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -105,6 +105,7 @@ static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_OCV,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_TEMP,
@@ -171,6 +172,13 @@ static int max17042_get_property(struct power_supply *psy,
 
 		val->intval = ret * 625 / 8;
 		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+		ret = max17042_read_reg(chip->client, MAX17042_OCVInternal);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 625 / 8;
+		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = max17042_read_reg(chip->client, MAX17042_RepSOC);
 		if (ret < 0)
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 4368e7d..4150747 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -146,6 +146,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(voltage_min_design),
 	POWER_SUPPLY_ATTR(voltage_now),
 	POWER_SUPPLY_ATTR(voltage_avg),
+	POWER_SUPPLY_ATTR(voltage_ocv),
 	POWER_SUPPLY_ATTR(current_max),
 	POWER_SUPPLY_ATTR(current_now),
 	POWER_SUPPLY_ATTR(current_avg),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c38c13d..fd17ae0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -96,6 +96,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_OCV,
 	POWER_SUPPLY_PROP_CURRENT_MAX,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
@@ -261,6 +262,7 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
 	case POWER_SUPPLY_PROP_POWER_NOW:
 		return 1;
 	default:
-- 
1.7.0.4

