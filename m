Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0L2TMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:12:12 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:16253 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559Ab0L2TMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:12:09 -0500
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: pgf@laptop.org
Subject: [PATCH] olpc_battery: Ambient temperature is not available on XO-1.5
Message-Id: <20101229191201.ED8019D401D@zog.reactivated.net>
Date: Wed, 29 Dec 2010 19:12:01 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=X0sWjjQ37bMP4yB/pNNinY3VxVB2n/hmdAjhihaCFGs= c=1 sm=0 a=yNWVPPRSaTsA:10 a=Op-mwl0xAAAA:8 a=0QMw9UIezUt00b1oUQkA:9 a=YT1_uhctfUj7owxLOr1DN_zmxBcA:4 a=d4CUUju0HPYA:10 a=lGdnjl07UuxZYpzI:21 a=k6nCzJAu7AWYXe-U:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XO-1.5 does not support the ambient temperature property.
Create a separate list of properties for that configuration where
ambient temperature is not included, and apply the correct property
list at runtime.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

Obsoletes earlier submissions:
[PATCH 1/2] power_supply: allow control of attribute visibility
[PATCH 2/2] olpc_battery: Hide ambient temperature attribute on XO-1.5

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 5bc1dcf..0cd4f15 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -331,7 +331,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	return ret;
 }
 
-static enum power_supply_property olpc_bat_props[] = {
+static enum power_supply_property olpc_xo1_bat_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -348,6 +348,23 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 };
 
+/* XO-1.5 does not have ambient temperature property */
+static enum power_supply_property olpc_xo15_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+};
+
 /* EEPROM reading goes completely around the power_supply API, sadly */
 
 #define EEPROM_START	0x20
@@ -419,8 +436,6 @@ static struct device_attribute olpc_bat_error = {
 static struct platform_device *bat_pdev;
 
 static struct power_supply olpc_bat = {
-	.properties = olpc_bat_props,
-	.num_properties = ARRAY_SIZE(olpc_bat_props),
 	.get_property = olpc_bat_get_property,
 	.use_for_apm = 1,
 };
@@ -466,6 +481,13 @@ static int __init olpc_bat_init(void)
 		goto ac_failed;
 
 	olpc_bat.name = bat_pdev->name;
+	if (olpc_board_at_least(olpc_board_pre(0xd0))) { /* XO-1.5 */
+		olpc_bat.properties = olpc_xo15_bat_props;
+		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo15_bat_props);
+	} else { /* XO-1 */
+		olpc_bat.properties = olpc_xo1_bat_props;
+		olpc_bat.num_properties = ARRAY_SIZE(olpc_xo1_bat_props);
+	}
 
 	ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
 	if (ret)
-- 
1.7.3.4

