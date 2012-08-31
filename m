Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2HaJXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37527 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2HaJXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:23:19 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/22] lp8727_charger: fix buggy code of NULL pdata
Thread-Topic: [PATCH 03/22] lp8727_charger: fix buggy code of NULL pdata
Thread-Index: Ac2HWj3v323rZybeQcCBArUvh9E7Mg==
Date: Fri, 31 Aug 2012 09:23:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E7D@DQHE02.ent.ti.com>
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

 LP8727 platform data is optional, so the driver should work even
 the platform data is NULL.

 To check the platform data, charging parameter data should be changed
 to the pointer type.

 Fix NULL point access problem when getting the battery properties.
 When the data is NULL, just return as invalid value.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |   28 +++++++++++++++++++++-------
 include/linux/platform_data/lp8727.h |    7 ++++---
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b2df114..7c19c09 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -170,20 +170,21 @@ static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
 
 static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
 {
+	struct lp8727_platform_data *pdata = pchg->pdata;
 	u8 devid = ID_NONE;
 	u8 swctrl = SW_DM1_HiZ | SW_DP2_HiZ;
 
 	switch (id) {
 	case 0x5:
 		devid = ID_TA;
-		pchg->chg_parm = &pchg->pdata->ac;
+		pchg->chg_parm = pdata ? pdata->ac : NULL;
 		break;
 	case 0xB:
 		if (lp8727_is_dedicated_charger(pchg)) {
-			pchg->chg_parm = &pchg->pdata->ac;
+			pchg->chg_parm = pdata ? pdata->ac : NULL;
 			devid = ID_DEDICATED_CHG;
 		} else if (lp8727_is_usb_charger(pchg)) {
-			pchg->chg_parm = &pchg->pdata->usb;
+			pchg->chg_parm = pdata ? pdata->usb : NULL;
 			devid = ID_USB_CHG;
 			swctrl = SW_DM1_DM | SW_DP2_DP;
 		} else if (vbusin) {
@@ -295,6 +296,7 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 				       union power_supply_propval *val)
 {
 	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
+	struct lp8727_platform_data *pdata = pchg->pdata;
 	u8 read;
 
 	switch (psp) {
@@ -318,19 +320,31 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 			val->intval = POWER_SUPPLY_HEALTH_GOOD;
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-		if (pchg->pdata->get_batt_present)
+		if (!pdata)
+			return -EINVAL;
+
+		if (pdata->get_batt_present)
 			val->intval = pchg->pdata->get_batt_present();
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		if (pchg->pdata->get_batt_level)
+		if (!pdata)
+			return -EINVAL;
+
+		if (pdata->get_batt_level)
 			val->intval = pchg->pdata->get_batt_level();
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (pchg->pdata->get_batt_capacity)
+		if (!pdata)
+			return -EINVAL;
+
+		if (pdata->get_batt_capacity)
 			val->intval = pchg->pdata->get_batt_capacity();
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		if (pchg->pdata->get_batt_temp)
+		if (!pdata)
+			return -EINVAL;
+
+		if (pdata->get_batt_temp)
 			val->intval = pchg->pdata->get_batt_temp();
 		break;
 	default:
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index ea98c61..f4bcdd5 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -51,15 +51,16 @@ struct lp8727_chg_param {
  * @get_batt_level : get battery voltage (mV)
  * @get_batt_capacity : get battery capacity (%)
  * @get_batt_temp : get battery temperature
- * @ac, @usb : charging parameters each charger type
+ * @ac                : charging parameters for AC type charger
+ * @usb               : charging parameters for USB type charger
  */
 struct lp8727_platform_data {
 	u8 (*get_batt_present)(void);
 	u16 (*get_batt_level)(void);
 	u8 (*get_batt_capacity)(void);
 	u8 (*get_batt_temp)(void);
-	struct lp8727_chg_param ac;
-	struct lp8727_chg_param usb;
+	struct lp8727_chg_param *ac;
+	struct lp8727_chg_param *usb;
 };
 
 #endif
-- 
1.7.9.5


Best Regards,
Milo


