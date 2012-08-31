Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2HaJYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:24:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43918 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2HaJYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:24:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/22] lp8727_charger: clean up the interrupt handler
Thread-Topic: [PATCH 06/22] lp8727_charger: clean up the interrupt handler
Thread-Index: Ac2HWlWwCbgY+ufUTbKrGjIuWpthow==
Date: Fri, 31 Aug 2012 09:23:57 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1EAE@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: APa3 CUfF CqO7 DRTp EAiV FViF GppX Lmz7 O8gP P98o QFaQ
 Qmsp SXST f0lC h3t4
 jRF+;3;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{0634822F-5006-4725-93BA-1BB0129AF75F};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 31 Aug 2012 09:23:51
 GMT;WwBQAEEAVABDAEgAIAAwADYALwAyADIAXQAgAGwAcAA4ADcAMgA3AF8AYwBoAGEAcgBnAGUAcgA6ACAAYwBsAGUAYQBuACAAdQBwACAAdABoAGUAIABpAG4AdABlAHIAcgB1AHAAdAAgAGgAYQBuAGQAbABlAHIA
x-cr-puzzleid: {0634822F-5006-4725-93BA-1BB0129AF75F}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 For better understanding, function name is changed.
 (lp8727_intr_config() is replaced with lp8727_setup_irq().)

 The private IRQ number is set when the IRQ is allocated successfully.
 This data is used for releasing the IRQ on unloading the driver.
 Even the IRQ number is not defined, the driver should be operated.
 In this case, just return as 0.

 In additional function lp8727_release_irq(), the workqueue is canceled and
 the allocated IRQ is released.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index c33532b..134ed5c 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -90,6 +90,7 @@ struct lp8727_chg {
 	struct lp8727_chg_param *chg_parm;
 	enum lp8727_dev_id devid;
 	unsigned long debounce_jiffies;
+	int irq;
 };
 
 static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
@@ -241,21 +242,39 @@ static irqreturn_t lp8727_isr_func(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static int lp8727_intr_config(struct lp8727_chg *pchg)
+static int lp8727_setup_irq(struct lp8727_chg *pchg)
 {
+	int ret;
+	int irq = pchg->client->irq;
 	unsigned delay_msec = pchg->pdata ? pchg->pdata->debounce_msec :
 						DEFAULT_DEBOUNCE_MSEC;
 
 	INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
 
-	pchg->debounce_jiffies = msecs_to_jiffies(delay_msec);
+	if (irq <= 0) {
+		dev_warn(pchg->dev, "invalid irq number: %d\n", irq);
+		return 0;
+	}
 
-	return request_threaded_irq(pchg->client->irq,
-				NULL,
-				lp8727_isr_func,
+	ret = request_threaded_irq(irq,	NULL, lp8727_isr_func,
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				"lp8727_irq",
-				pchg);
+				"lp8727_irq", pchg);
+
+	if (ret)
+		return ret;
+
+	pchg->irq = irq;
+	pchg->debounce_jiffies = msecs_to_jiffies(delay_msec);
+
+	return 0;
+}
+
+static void lp8727_release_irq(struct lp8727_chg *pchg)
+{
+	cancel_delayed_work_sync(&pchg->work);
+
+	if (pchg->irq)
+		free_irq(pchg->irq, pchg);
 }
 
 static enum power_supply_property lp8727_charger_prop[] = {
@@ -462,7 +481,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		return ret;
 	}
 
-	ret = lp8727_intr_config(pchg);
+	ret = lp8727_setup_irq(pchg);
 	if (ret) {
 		dev_err(pchg->dev, "irq handler err: %d", ret);
 		lp8727_unregister_psy(pchg);
@@ -476,7 +495,7 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 {
 	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
 
-	free_irq(pchg->client->irq, pchg);
+	lp8727_release_irq(pchg);
 	lp8727_unregister_psy(pchg);
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


