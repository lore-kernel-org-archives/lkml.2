Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2H3Lk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:40:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34128 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab2H3LkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:40:24 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 5/8] lp8727_charger: move the mutex code
Thread-Topic: [PATCH 5/8] lp8727_charger: move the mutex code
Thread-Index: Ac2GpDjicB38kohRToufyld/q14oGQ==
Date: Thu, 30 Aug 2012 11:40:16 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1CB3@DQHE02.ent.ti.com>
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

use the mutex only when the write access to the registers
in the delayed work.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 742c33a..0b0094a 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -84,7 +84,7 @@ struct lp8727_psy {
 struct lp8727_chg {
 	struct device *dev;
 	struct i2c_client *client;
-	struct mutex xfer_lock;
+	struct mutex lock;
 
 	/* interrupt handling */
 	int irq;
@@ -104,9 +104,7 @@ static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
 {
 	s32 ret;
 
-	mutex_lock(&pchg->xfer_lock);
 	ret = i2c_smbus_read_i2c_block_data(pchg->client, reg, len, data);
-	mutex_unlock(&pchg->xfer_lock);
 
 	return (ret != len) ? -EIO : 0;
 }
@@ -116,15 +114,9 @@ static inline int lp8727_read_byte(struct lp8727_chg *pchg, u8 reg, u8 *data)
 	return lp8727_read_bytes(pchg, reg, data, 1);
 }
 
-static int lp8727_write_byte(struct lp8727_chg *pchg, u8 reg, u8 data)
+static inline int lp8727_write_byte(struct lp8727_chg *pchg, u8 reg, u8 data)
 {
-	int ret;
-
-	mutex_lock(&pchg->xfer_lock);
-	ret = i2c_smbus_write_byte_data(pchg->client, reg, data);
-	mutex_unlock(&pchg->xfer_lock);
-
-	return ret;
+	return i2c_smbus_write_byte_data(pchg->client, reg, data);
 }
 
 static int lp8727_is_charger_attached(const char *name, int id)
@@ -239,8 +231,10 @@ static void lp8727_delayed_func(struct work_struct *_work)
 	idno = intstat[0] & IDNO;
 	vbus = intstat[0] & VBUS;
 
+	mutex_lock(&pchg->lock);
 	lp8727_id_detection(pchg, idno, vbus);
 	lp8727_enable_chgdet(pchg);
+	mutex_unlock(&pchg->lock);
 
 	power_supply_changed(&pchg->psy->ac);
 	power_supply_changed(&pchg->psy->usb);
@@ -479,7 +473,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	pchg->pdata = cl->dev.platform_data;
 	i2c_set_clientdata(cl, pchg);
 
-	mutex_init(&pchg->xfer_lock);
+	mutex_init(&pchg->lock);
 
 	ret = lp8727_init_device(pchg);
 	if (ret) {
-- 
1.7.9.5


Best Regards,
Milo


