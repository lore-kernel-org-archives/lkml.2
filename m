Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0ERTvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:51:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35015 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab0ERTu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:50:58 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, gregkh@suse.de, dwmw2@infradead.org,
       broonie@opensource.wolfsonmicro.com, len.brown@intel.com,
       astarikovskiy@suse.de, mreimer@vpop.net, zbr@ioremap.net, tj@kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 3/3] power/ds2760_battery: make charge_now and charge_full writeable
Date: Tue, 18 May 2010 21:49:53 +0200
Message-Id: <1274212193-16669-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
References: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For userspace tools and daemons, it might be necessary to adjust
the charge_now and charge_full properties of the ds2760 battery monitor,
for example for unavoidable corrections due to aging batteries.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/ds2760_battery.c |   64 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 3bf8d1f..4d3b272 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -304,6 +304,28 @@ static void ds2760_battery_write_rated_capacity(struct ds2760_device_info *di,
 	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
 }
 
+static void ds2760_battery_write_active_full(struct ds2760_device_info *di,
+					     int active_full)
+{
+	unsigned char tmp[2] = {
+		active_full >> 8,
+		active_full & 0xff
+	};
+
+	if (tmp[0] == di->raw[DS2760_ACTIVE_FULL] &&
+	    tmp[1] == di->raw[DS2760_ACTIVE_FULL + 1])
+		return;
+
+	w1_ds2760_write(di->w1_dev, tmp, DS2760_ACTIVE_FULL, sizeof(tmp));
+	w1_ds2760_store_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK0);
+	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK0);
+
+	/* Write to the di->raw[] buffer directly - the DS2760_ACTIVE_FULL
+	 * values won't be read back by ds2760_battery_read_status() */
+	di->raw[DS2760_ACTIVE_FULL] = tmp[0];
+	di->raw[DS2760_ACTIVE_FULL + 1] = tmp[1];
+}
+
 static void ds2760_battery_work(struct work_struct *work)
 {
 	struct ds2760_device_info *di = container_of(work,
@@ -426,6 +448,45 @@ static int ds2760_battery_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static int ds2760_battery_set_property(struct power_supply *psy,
+				       enum power_supply_property psp,
+				       const union power_supply_propval *val)
+{
+	struct ds2760_device_info *di = to_ds2760_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		/* the interface counts in uAh, convert the value */
+		ds2760_battery_write_active_full(di, val->intval / 1000L);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		/* ds2760_battery_set_current_accum() does the conversion */
+		ds2760_battery_set_current_accum(di, val->intval);
+		break;
+
+	default:
+		return -EPERM;
+	}
+
+	return 0;
+}
+
+static int ds2760_battery_property_is_writeable(struct power_supply *psy,
+						enum power_supply_property psp)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		return 1;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static enum power_supply_property ds2760_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
@@ -460,6 +521,9 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	di->bat.properties	= ds2760_battery_props;
 	di->bat.num_properties	= ARRAY_SIZE(ds2760_battery_props);
 	di->bat.get_property	= ds2760_battery_get_property;
+	di->bat.set_property	= ds2760_battery_set_property;
+	di->bat.property_is_writeable =
+				  ds2760_battery_property_is_writeable;
 	di->bat.set_charged	= ds2760_battery_set_charged;
 	di->bat.external_power_changed =
 				  ds2760_battery_external_power_changed;
-- 
1.7.1

