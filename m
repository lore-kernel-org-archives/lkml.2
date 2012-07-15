Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2GOVtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:49:43 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:35598 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab2GOVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:49:39 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2012 17:49:39 EDT
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, pgf@laptop.org, richard@laptop.org
Subject: [PATCH 1/2] olpc-battery: Add VOLTAGE_MAX_DESIGN property
Message-Id: <20120715214325.3DEC09D401E@zog.reactivated.net>
Date: Sun, 15 Jul 2012 22:43:25 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=4l2lPXjyb3oA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=CNzbD-HaJSfO482hSYMA:9 a=d4CUUju0HPYA:10 a=SG2FxpaC7LzQys-V:21 a=Jf-KtALunSfsqeib:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard A. Smith <richard@laptop.org>

upowerd wants to compute the energy in the battery by looking at this
property.  If it's not present then it falls back on using the reported
voltage of the battery at time upowerd loads.  That's close but also
means that every time you boot you get a slightly different energy
capacity.

Adding the VOLTAGE_MAX_DESIGN property allows upowerd to compute the
same energy every time.

Signed-off-by: Richard A. Smith <richard@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 7385092..b98f531 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -267,6 +267,53 @@ static int olpc_bat_get_charge_now(union power_supply_propval *val)
 	return 0;
 }
 
+static int olpc_bat_get_voltage_max_design(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	union power_supply_propval tech;
+	int ret, mfr;
+
+	ret = olpc_bat_get_tech(&tech);
+	if (ret)
+		return ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	mfr = ec_byte >> 4;
+
+	switch (tech.intval) {
+	case POWER_SUPPLY_TECHNOLOGY_NiMH:
+		switch (mfr) {
+		case 1: /* Gold Peak */
+			val->intval = 6000000;
+			break;
+		default:
+			return -EIO;
+		}
+		break;
+
+	case POWER_SUPPLY_TECHNOLOGY_LiFe:
+		switch (mfr) {
+		case 1: /* Gold Peak */
+			val->intval = 6400000;
+			break;
+		case 2: /* BYD */
+			val->intval = 6500000;
+			break;
+		default:
+			return -EIO;
+		}
+		break;
+
+	default:
+		return -EIO;
+	}
+
+	return ret;
+}
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
@@ -401,6 +448,11 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		sprintf(bat_serial, "%016llx", (long long)be64_to_cpu(ser_buf));
 		val->strval = bat_serial;
 		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		ret = olpc_bat_get_voltage_max_design(val);
+		if (ret)
+			return ret;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -428,6 +480,7 @@ static enum power_supply_property olpc_xo1_bat_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 };
 
 /* XO-1.5 does not have ambient temperature property */
@@ -449,6 +502,7 @@ static enum power_supply_property olpc_xo15_bat_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 };
 
 /* EEPROM reading goes completely around the power_supply API, sadly */
-- 
1.7.10.4

