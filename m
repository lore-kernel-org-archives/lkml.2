Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0EGRxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:53:08 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39156 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0EGRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:53:05 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] power/ds2760_battery: make charge_now and charge_full_design writeable
Date: Fri,  7 May 2010 19:52:12 +0200
Message-Id: <1273254733-7010-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
References: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For userspace tools and daemons, it might be necessary to adjust
the charge_now and charge_full_design properties of the ds2760 battery
monitor, for example for unavoidable corrections due to aging batteries.

For better readbility and to avoid magic numbers in conversion
calculations, RATED_CAPACITY_FACTOR was introduced.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/ds2760_battery.c |   57 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 3bf8d1f..14df424 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -78,6 +78,7 @@ MODULE_PARM_DESC(current_accum, "current accumulator value");
 
 /* Some batteries have their rated capacity stored a N * 10 mAh, while
  * others use an index into this table. */
+#define RATED_CAPACITY_FACTOR 10
 static int rated_capacities[] = {
 	0,
 	920,	/* Samsung */
@@ -170,7 +171,8 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 		di->rated_capacity = rated_capacities[
 			(unsigned int)di->raw[DS2760_RATED_CAPACITY]];
 	else
-		di->rated_capacity = di->raw[DS2760_RATED_CAPACITY] * 10;
+		di->rated_capacity = di->raw[DS2760_RATED_CAPACITY] *
+						RATED_CAPACITY_FACTOR;
 
 	di->rated_capacity *= 1000; /* convert to µAh */
 
@@ -426,6 +428,51 @@ static int ds2760_battery_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static int ds2760_battery_set_property(struct power_supply *psy,
+				       enum power_supply_property psp,
+				       const union power_supply_propval *val)
+{
+	unsigned char tmp;
+	struct ds2760_device_info *di = to_ds2760_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		/* the interface counts in uAh, convert the value */
+		ds2760_battery_write_rated_capacity(di, (val->intval / 1000L) /
+							RATED_CAPACITY_FACTOR);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		tmp = val->intval & 0xff;
+		w1_ds2760_write(di->w1_dev, &tmp, DS2760_CURRENT_ACCUM_LSB, 1);
+
+		tmp = val->intval >> 8;
+		w1_ds2760_write(di->w1_dev, &tmp, DS2760_CURRENT_ACCUM_MSB, 1);
+
+		break;
+
+	default:
+		return -EPERM;
+	}
+
+	return -EINVAL;
+}
+
+static int ds2760_battery_property_is_writeable(struct power_supply *psy,
+						enum power_supply_property psp)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		return 1;
+
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 static enum power_supply_property ds2760_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
@@ -460,6 +507,9 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	di->bat.properties	= ds2760_battery_props;
 	di->bat.num_properties	= ARRAY_SIZE(ds2760_battery_props);
 	di->bat.get_property	= ds2760_battery_get_property;
+	di->bat.set_property	= ds2760_battery_set_property;
+	di->bat.property_is_writeable =
+				  ds2760_battery_property_is_writeable;
 	di->bat.set_charged	= ds2760_battery_set_charged;
 	di->bat.external_power_changed =
 				  ds2760_battery_external_power_changed;
@@ -476,9 +526,10 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 
 	ds2760_battery_write_status(di, status);
 
-	/* set rated capacity from module param */
+	/* set rated capacity from module param (given in 10 * mAh) */
 	if (rated_capacity)
-		ds2760_battery_write_rated_capacity(di, rated_capacity);
+		ds2760_battery_write_rated_capacity(di,
+			(rated_capacity * 10) / RATED_CAPACITY_FACTOR);
 
 	/* set current accumulator if given as parameter.
 	 * this should only be done for bootstrapping the value */
-- 
1.6.3.3

