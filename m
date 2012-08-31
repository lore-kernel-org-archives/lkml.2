Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2HaJYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:24:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44468 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2HaJYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:24:34 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/22] lp8727_charger: fix code for getting battery temp
Thread-Topic: [PATCH 08/22] lp8727_charger: fix code for getting battery temp
Thread-Index: Ac2HWmhH9VLxESg+QByQBW1wlNN2Rg==
Date: Fri, 31 Aug 2012 09:24:28 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1EC6@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 For better understanding, use specific function and definitions
 rather than magic numbers.
 New enum type for die temperature is matched with hex codes.
 Specific temperature names are better than 0x1, 0x2 and 0x3.

 And lp8727_is_high_temperature() function has better readability than
 comparing raw register values.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b5567bc..1a5f4b2 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -58,6 +58,7 @@
 
 /* STATUS2 register */
 #define TEMP_STAT	(3 << 5)
+#define TEMP_SHIFT	5
 
 enum lp8727_dev_id {
 	ID_NONE,
@@ -75,6 +76,13 @@ enum lp8727_chg_stat {
 	EOC,
 };
 
+enum lp8727_die_temp {
+	LP8788_TEMP_75C,
+	LP8788_TEMP_95C,
+	LP8788_TEMP_115C,
+	LP8788_TEMP_135C,
+};
+
 struct lp8727_psy {
 	struct power_supply ac;
 	struct power_supply usb;
@@ -315,12 +323,25 @@ static int lp8727_charger_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static bool lp8727_is_high_temperature(enum lp8727_die_temp temp)
+{
+	switch (temp) {
+	case LP8788_TEMP_95C:
+	case LP8788_TEMP_115C:
+	case LP8788_TEMP_135C:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int lp8727_battery_get_property(struct power_supply *psy,
 				       enum power_supply_property psp,
 				       union power_supply_propval *val)
 {
 	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
 	struct lp8727_platform_data *pdata = pchg->pdata;
+	enum lp8727_die_temp temp;
 	u8 read;
 
 	switch (psp) {
@@ -337,11 +358,11 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
 		lp8727_read_byte(pchg, STATUS2, &read);
-		read = (read & TEMP_STAT) >> 5;
-		if (read >= 0x1 && read <= 0x3)
-			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
-		else
-			val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		temp = (read & TEMP_STAT) >> TEMP_SHIFT;
+
+		val->intval = lp8727_is_high_temperature(temp) ?
+			POWER_SUPPLY_HEALTH_OVERHEAT :
+			POWER_SUPPLY_HEALTH_GOOD;
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		if (!pdata)
-- 
1.7.9.5


Best Regards,
Milo


