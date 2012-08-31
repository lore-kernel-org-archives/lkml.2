Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2HaJXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44407 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2HaJXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:23:46 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/22] lp8727_charger: remove unnecessary workqueue thread
Thread-Topic: [PATCH 05/22] lp8727_charger: remove unnecessary workqueue
 thread
Thread-Index: Ac2HWk76olCN2nfmRZqjuoa/YoEQzA==
Date: Fri, 31 Aug 2012 09:23:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E8D@DQHE02.ent.ti.com>
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

 LP8727 has two IRQ threads.
 One is the I2C HW IRQ pin, the other is for delayed interrupt processing.
 But this delayed processing can be handled without additional single thread
 by using schedule_delayed_work() with jiffies time value.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 1907b1f..c33532b 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -85,7 +85,6 @@ struct lp8727_chg {
 	struct i2c_client *client;
 	struct mutex xfer_lock;
 	struct delayed_work work;
-	struct workqueue_struct *irqthread;
 	struct lp8727_platform_data *pdata;
 	struct lp8727_psy *psy;
 	struct lp8727_chg_param *chg_parm;
@@ -238,9 +237,7 @@ static irqreturn_t lp8727_isr_func(int irq, void *ptr)
 {
 	struct lp8727_chg *pchg = ptr;
 
-	queue_delayed_work(pchg->irqthread, &pchg->work,
-					pchg->debounce_jiffies);
-
+	schedule_delayed_work(&pchg->work, pchg->debounce_jiffies);
 	return IRQ_HANDLED;
 }
 
@@ -251,12 +248,6 @@ static int lp8727_intr_config(struct lp8727_chg *pchg)
 
 	INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
 
-	pchg->irqthread = create_singlethread_workqueue("lp8727-irqthd");
-	if (!pchg->irqthread) {
-		dev_err(pchg->dev, "can not create thread for lp8727\n");
-		return -ENOMEM;
-	}
-
 	pchg->debounce_jiffies = msecs_to_jiffies(delay_msec);
 
 	return request_threaded_irq(pchg->client->irq,
@@ -486,8 +477,6 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
 
 	free_irq(pchg->client->irq, pchg);
-	flush_workqueue(pchg->irqthread);
-	destroy_workqueue(pchg->irqthread);
 	lp8727_unregister_psy(pchg);
 	return 0;
 }
-- 
1.7.9.5


Best Regards,
Milo


