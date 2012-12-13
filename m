Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2LMPWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36964 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab2LMPWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/18] power: ab8500_charger: Handle gpadc errors
Date: Thu, 13 Dec 2012 15:21:29 +0000
Message-Id: <1355412102-14265-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Gracefully handle gpadc conversion errors.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_charger.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 8c09444..6a78e31 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -160,6 +160,7 @@ struct ab8500_charger_info {
 	int charger_voltage;
 	int cv_active;
 	bool wd_expired;
+	int charger_current;
 };
 
 struct ab8500_charger_event_flags {
@@ -2361,6 +2362,7 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_ac_device_info(psy_to_ux500_charger(psy));
 
@@ -2382,7 +2384,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
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
@@ -2394,7 +2399,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
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
@@ -2421,6 +2429,7 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_usb_device_info(psy_to_ux500_charger(psy));
 
@@ -2444,7 +2453,9 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
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
@@ -2456,7 +2467,10 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
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
1.7.9.5

