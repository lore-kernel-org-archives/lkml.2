Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2A0G7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:59:01 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33778 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751917Ab2A0G66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:58:58 -0500
X-WSS-ID: 0LYG3E6-0A-25N-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:58:39 -0800
Subject: [PATCH 3/6] lp8727_charger: change i2c functions
Thread-Topic: [PATCH 3/6] lp8727_charger: change i2c functions
Thread-Index: AczcwRkRiX9P6oX7Qy2aegugn7Et3Q==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB08@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94A81LS9965375-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On writing single byte via i2c, use i2c_smbus_write_byte_data()
rather than i2c_smbus_write_i2c_block_data().

Name changes :
lp8727_i2c_read() -> lp8727_read_bytes()
lp8727_i2c_write() -> removed
lp8727_i2c_read_byte() -> lp8727_read_byte()
lp8727_i2c_write_byte() -> lp8727_write_byte()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   48 ++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 42275cb..b333cdd 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -91,7 +91,7 @@ struct lp8727_chg {
 	enum lp8727_dev_id devid;
 };
 
-static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
+static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
 {
 	s32 ret;
 
@@ -102,29 +102,22 @@ static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
 	return (ret != len) ? -EIO : 0;
 }
 
-static int lp8727_i2c_write(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
+static inline int lp8727_read_byte(struct lp8727_chg *pchg, u8 reg, u8 *data)
 {
-	s32 ret;
+	return lp8727_read_bytes(pchg, reg, data, 1);
+}
+
+static int lp8727_write_byte(struct lp8727_chg *pchg, u8 reg, u8 data)
+{
+	int ret;
 
 	mutex_lock(&pchg->xfer_lock);
-	ret = i2c_smbus_write_i2c_block_data(pchg->client, reg, len, data);
+	ret = i2c_smbus_write_byte_data(pchg->client, reg, data);
 	mutex_unlock(&pchg->xfer_lock);
 
 	return ret;
 }
 
-static inline int lp8727_i2c_read_byte(struct lp8727_chg *pchg, u8 reg,
-				       u8 *data)
-{
-	return lp8727_i2c_read(pchg, reg, data, 1);
-}
-
-static inline int lp8727_i2c_write_byte(struct lp8727_chg *pchg, u8 reg,
-					u8 *data)
-{
-	return lp8727_i2c_write(pchg, reg, data, 1);
-}
-
 static int lp8727_is_charger_attached(const char *name, int id)
 {
 	if (name) {
@@ -143,12 +136,12 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 	int ret;
 
 	val = ID200_EN | ADC_EN | CP_EN;
-	ret = lp8727_i2c_write_byte(pchg, CTRL1, &val);
+	ret = lp8727_write_byte(pchg, CTRL1, val);
 	if (ret)
 		return ret;
 
 	val = INT_EN | CHGDET_EN;
-	ret = lp8727_i2c_write_byte(pchg, CTRL2, &val);
+	ret = lp8727_write_byte(pchg, CTRL2, val);
 	if (ret)
 		return ret;
 
@@ -158,21 +151,20 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	lp8727_i2c_read_byte(pchg, STATUS1, &val);
+	lp8727_read_byte(pchg, STATUS1, &val);
 	return (val & DCPORT);
 }
 
 static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 {
 	u8 val;
-	lp8727_i2c_read_byte(pchg, STATUS1, &val);
+	lp8727_read_byte(pchg, STATUS1, &val);
 	return (val & CHPORT);
 }
 
 static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
 {
-	u8 val = sw;
-	lp8727_i2c_write_byte(pchg, SWCTRL, &val);
+	lp8727_write_byte(pchg, SWCTRL, sw);
 }
 
 static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
@@ -212,9 +204,9 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
 {
 	u8 val;
 
-	lp8727_i2c_read_byte(pchg, CTRL2, &val);
+	lp8727_read_byte(pchg, CTRL2, &val);
 	val |= CHGDET_EN;
-	lp8727_i2c_write_byte(pchg, CTRL2, &val);
+	lp8727_write_byte(pchg, CTRL2, val);
 }
 
 static void lp8727_delayed_func(struct work_struct *_work)
@@ -223,7 +215,7 @@ static void lp8727_delayed_func(struct work_struct *_work)
 	struct lp8727_chg *pchg =
 	    container_of(_work, struct lp8727_chg, work.work);
 
-	if (lp8727_i2c_read(pchg, INT1, intstat, 2)) {
+	if (lp8727_read_bytes(pchg, INT1, intstat, 2)) {
 		dev_err(pchg->dev, "can not read INT registers\n");
 		return;
 	}
@@ -307,7 +299,7 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (lp8727_is_charger_attached(psy->name, pchg->devid)) {
-			lp8727_i2c_read_byte(pchg, STATUS1, &read);
+			lp8727_read_byte(pchg, STATUS1, &read);
 			if (((read & CHGSTAT) >> 4) == EOC)
 				val->intval = POWER_SUPPLY_STATUS_FULL;
 			else
@@ -317,7 +309,7 @@ static int lp8727_battery_get_property(struct power_supply *psy,
 		}
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
-		lp8727_i2c_read_byte(pchg, STATUS2, &read);
+		lp8727_read_byte(pchg, STATUS2, &read);
 		read = (read & TEMP_STAT) >> 5;
 		if (read >= 0x1 && read <= 0x3)
 			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
@@ -358,7 +350,7 @@ static void lp8727_charger_changed(struct power_supply *psy)
 			eoc_level = pchg->chg_parm->eoc_level;
 			ichg = pchg->chg_parm->ichg;
 			val = (ichg << 4) | eoc_level;
-			lp8727_i2c_write_byte(pchg, CHGCTRL2, &val);
+			lp8727_write_byte(pchg, CHGCTRL2, val);
 		}
 	}
 }
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




