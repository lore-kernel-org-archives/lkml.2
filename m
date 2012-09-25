Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2IYQZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:25:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab2IYQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:22 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 10/57] power: ab8500_charger: Handle gpadc errors
Date: Tue, 25 Sep 2012 10:12:07 -0600
Message-Id: <1348589574-25655-11-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Gracefully handle gpadc conversion errors.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_charger.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index f7bba07..06a7c8b 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -157,6 +157,7 @@ struct ab8500_charger_info {
 	int charger_voltage;
 	int cv_active;
 	bool wd_expired;
+	int charger_current;
 };
 
 struct ab8500_charger_event_flags {
@@ -2341,6 +2342,7 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_ac_device_info(psy_to_ux500_charger(psy));
 
@@ -2362,7 +2364,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 		val->intval = di->ac.charger_connected;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		di->ac.charger_voltage = ab8500_charger_get_ac_voltage(di);
+		ret = ab8500_charger_get_ac_voltage(di);
+		if (ret >= 0)
+			di->ac.charger_voltage = ret;
+		/* On error, use previous value */
 		val->intval = di->ac.charger_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
@@ -2374,7 +2379,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 		val->intval = di->ac.cv_active;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = ab8500_charger_get_ac_current(di) * 1000;
+		ret = ab8500_charger_get_ac_current(di);
+		if (ret >= 0)
+			di->ac.charger_current = ret;
+		val->intval = di->ac.charger_current * 1000;
 		break;
 	default:
 		return -EINVAL;
@@ -2401,6 +2409,7 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_usb_device_info(psy_to_ux500_charger(psy));
 
@@ -2424,7 +2433,9 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 		val->intval = di->usb.charger_connected;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		di->usb.charger_voltage = ab8500_charger_get_vbus_voltage(di);
+		ret = ab8500_charger_get_vbus_voltage(di);
+		if (ret >= 0)
+			di->usb.charger_voltage = ret;
 		val->intval = di->usb.charger_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
@@ -2436,7 +2447,10 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 		val->intval = di->usb.cv_active;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = ab8500_charger_get_usb_current(di) * 1000;
+		ret = ab8500_charger_get_usb_current(di);
+		if (ret >= 0)
+			di->usb.charger_current = ret;
+		val->intval = di->usb.charger_current * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		/*
-- 
1.7.5.4

