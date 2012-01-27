Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2A0G6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:58:46 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33763 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755870Ab2A0G6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:58:43 -0500
X-WSS-ID: 0LYG3DQ-0A-25J-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:58:30 -0800
Subject: [PATCH 2/6] lp8727_charger: add error check routine on probe()
Thread-Topic: [PATCH 2/6] lp8727_charger: add error check routine on
 probe()
Thread-Index: AczcwRQChmwuNF/bTzixYkqysooWFg==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB07@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94931LS9965372-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error checking on initializing registers and interrupt handler.

Initializing registers - lp8727_init_device()
: check i2c error during probing the driver.

Initializing interrupt handler - lp8727_intr_config()
: check an error on creating the irq thread.

If an error occurs on probing lp8727 driver, allocated lp8727 driver memory is freed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   57 +++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 97be22e..42275cb 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -137,17 +137,22 @@ static int lp8727_is_charger_attached(const char *name, int id)
 	return (id >= ID_TA && id <= ID_USB_CHG) ? 1 : 0;
 }
 
-static void lp8727_init_device(struct lp8727_chg *pchg)
+static int lp8727_init_device(struct lp8727_chg *pchg)
 {
 	u8 val;
+	int ret;
 
 	val = ID200_EN | ADC_EN | CP_EN;
-	if (lp8727_i2c_write_byte(pchg, CTRL1, &val))
-		dev_err(pchg->dev, "i2c write err : addr=0x%.2x\n", CTRL1);
+	ret = lp8727_i2c_write_byte(pchg, CTRL1, &val);
+	if (ret)
+		return ret;
 
 	val = INT_EN | CHGDET_EN;
-	if (lp8727_i2c_write_byte(pchg, CTRL2, &val))
-		dev_err(pchg->dev, "i2c write err : addr=0x%.2x\n", CTRL2);
+	ret = lp8727_i2c_write_byte(pchg, CTRL2, &val);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
@@ -244,20 +249,22 @@ static irqreturn_t lp8727_isr_func(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static void lp8727_intr_config(struct lp8727_chg *pchg)
+static int lp8727_intr_config(struct lp8727_chg *pchg)
 {
 	INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
 
 	pchg->irqthread = create_singlethread_workqueue("lp8727-irqthd");
-	if (!pchg->irqthread)
+	if (!pchg->irqthread) {
 		dev_err(pchg->dev, "can not create thread for lp8727\n");
-
-	if (request_threaded_irq(pchg->client->irq,
-				 NULL,
-				 lp8727_isr_func,
-				 IRQF_TRIGGER_FALLING, "lp8727_irq", pchg)) {
-		dev_err(pchg->dev, "lp8727 irq can not be registered\n");
+		return -ENOMEM;
 	}
+
+	return request_threaded_irq(pchg->client->irq,
+				NULL,
+				lp8727_isr_func,
+				IRQF_TRIGGER_FALLING,
+				"lp8727_irq",
+				pchg);
 }
 
 static enum power_supply_property lp8727_charger_prop[] = {
@@ -439,15 +446,29 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 
 	mutex_init(&pchg->xfer_lock);
 
-	lp8727_init_device(pchg);
-	lp8727_intr_config(pchg);
+	ret = lp8727_init_device(pchg);
+	if (ret) {
+		dev_err(pchg->dev, "i2c communication err: %d", ret);
+		goto error;
+	}
+
+	ret = lp8727_intr_config(pchg);
+	if (ret) {
+		dev_err(pchg->dev, "irq handler err: %d", ret);
+		goto error;
+	}
 
 	ret = lp8727_register_psy(pchg);
-	if (ret)
-		dev_err(pchg->dev,
-			"can not register power supplies. err=%d", ret);
+	if (ret) {
+		dev_err(pchg->dev, "power supplies register err: %d", ret);
+		goto error;
+	}
 
 	return 0;
+
+error:
+	kfree(pchg);
+	return ret;
 }
 
 static int __devexit lp8727_remove(struct i2c_client *cl)
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




