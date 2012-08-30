Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2H3Lkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:40:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab2H3Lks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:40:48 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 6/8] lp8727_charger: fix code for getting battery temperature
Thread-Topic: [PATCH 6/8] lp8727_charger: fix code for getting battery
 temperature
Thread-Index: Ac2GpEW18hTNzrVQQjOJK78qSAn0gQ==
Date: Thu, 30 Aug 2012 11:40:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1CC7@DQHE02.ent.ti.com>
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

For better understanding, use specific function and name
rather than magic number

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 0b0094a..78cec53 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -55,6 +55,7 @@
 
 /* STATUS2 register */
 #define TEMP_STAT	(3 << 5)
+#define TEMP_SHIFT	5
 
 #define LP8788_NUM_INTREGS		2
 #define DEFAULT_DEBOUNCE_MSEC		270
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
@@ -313,12 +321,25 @@ static int lp8727_charger_get_property(struct power_supply *psy,
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
@@ -335,11 +356,11 @@ static int lp8727_battery_get_property(struct power_supply *psy,
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


