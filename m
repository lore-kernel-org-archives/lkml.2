Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2H3Ljq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:39:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34097 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab2H3Ljp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:39:45 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 3/8] lp8727_charger: fix buggy code when the platform data
 is NULL
Thread-Topic: [PATCH 3/8] lp8727_charger: fix buggy code when the platform
 data is NULL
Thread-Index: Ac2GpCKY7Zu8ccJpTFmoMzEOHkb3Wg==
Date: Thu, 30 Aug 2012 11:39:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1C96@DQHE02.ent.ti.com>
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

Even the platform data is not defined, lp8727 driver should be run

(a) change charger platform data type to pointer
(b) name change: chg_parm -> chg_param
(c) fix NULL point access problem when getting the battery properties

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |   38 +++++++++++++++++++++++-----------
 include/linux/platform_data/lp8727.h |   13 ++++++------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 4d51909..975a4f2 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -88,7 +88,7 @@ struct lp8727_chg {
 	struct workqueue_struct *irqthread;
 	struct lp8727_platform_data *pdata;
 	struct lp8727_psy *psy;
-	struct lp8727_chg_param *chg_parm;
+	struct lp8727_chg_param *chg_param;
 	enum lp8727_dev_id devid;
 };
 
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
+		pchg->chg_param = pdata ? pdata->ac : NULL;
 		break;
 	case 0xB:
 		if (lp8727_is_dedicated_charger(pchg)) {
-			pchg->chg_parm = &pchg->pdata->ac;
+			pchg->chg_param = pdata ? pdata->ac : NULL;
 			devid = ID_DEDICATED_CHG;
 		} else if (lp8727_is_usb_charger(pchg)) {
-			pchg->chg_parm = &pchg->pdata->usb;
+			pchg->chg_param = pdata ? pdata->usb : NULL;
 			devid = ID_USB_CHG;
 			swctrl = SW_DM1_DM | SW_DP2_DP;
 		} else if (vbusin) {
@@ -193,7 +194,7 @@ static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
 		break;
 	default:
 		devid = ID_NONE;
-		pchg->chg_parm = NULL;
+		pchg->chg_param = NULL;
 		break;
 	}
 
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
@@ -347,9 +361,9 @@ static void lp8727_charger_changed(struct power_supply *psy)
 	u8 eoc_level, ichg;
 
 	if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-		if (pchg->chg_parm) {
-			eoc_level = pchg->chg_parm->eoc_level;
-			ichg = pchg->chg_parm->ichg;
+		if (pchg->chg_param) {
+			eoc_level = pchg->chg_param->eoc_level;
+			ichg = pchg->chg_param->ichg;
 			val = (ichg << 4) | eoc_level;
 			lp8727_write_byte(pchg, CHGCTRL2, val);
 		}
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index ea98c61..ff14591 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -47,19 +47,20 @@ struct lp8727_chg_param {
 
 /**
  * struct lp8727_platform_data
- * @get_batt_present : check battery status - exists or not
- * @get_batt_level : get battery voltage (mV)
+ * @get_batt_present  : check battery status - exists or not
+ * @get_batt_level    : get battery voltage (mV)
  * @get_batt_capacity : get battery capacity (%)
- * @get_batt_temp : get battery temperature
- * @ac, @usb : charging parameters each charger type
+ * @get_batt_temp     : get battery temperature
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


