Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2HaJXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44397 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2HaJXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:23:32 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/22] lp8727_charger: add configurable debouce timer
Thread-Topic: [PATCH 04/22] lp8727_charger: add configurable debouce timer
Thread-Index: Ac2HWkV8gk4MkhebRxaYsLnPRatW7A==
Date: Fri, 31 Aug 2012 09:23:25 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E85@DQHE02.ent.ti.com>
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

 Debounce time is configurable in the platform side.
 If it is not defined, the default value is 270ms.

 Platform data is msec unit, and this time is converted to jiffies internally.
 The workqueue uses this jiffies time in the interrupt handling.
 So debounce_jiffies is added in the private data.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |   12 +++++++++---
 include/linux/platform_data/lp8727.h |    2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 7c19c09..1907b1f 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -17,7 +17,7 @@
 #include <linux/power_supply.h>
 #include <linux/platform_data/lp8727.h>
 
-#define DEBOUNCE_MSEC	270
+#define DEFAULT_DEBOUNCE_MSEC	270
 
 /* Registers */
 #define CTRL1		0x1
@@ -90,6 +90,7 @@ struct lp8727_chg {
 	struct lp8727_psy *psy;
 	struct lp8727_chg_param *chg_parm;
 	enum lp8727_dev_id devid;
+	unsigned long debounce_jiffies;
 };
 
 static int lp8727_read_bytes(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
@@ -236,15 +237,18 @@ static void lp8727_delayed_func(struct work_struct *_work)
 static irqreturn_t lp8727_isr_func(int irq, void *ptr)
 {
 	struct lp8727_chg *pchg = ptr;
-	unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
 
-	queue_delayed_work(pchg->irqthread, &pchg->work, delay);
+	queue_delayed_work(pchg->irqthread, &pchg->work,
+					pchg->debounce_jiffies);
 
 	return IRQ_HANDLED;
 }
 
 static int lp8727_intr_config(struct lp8727_chg *pchg)
 {
+	unsigned delay_msec = pchg->pdata ? pchg->pdata->debounce_msec :
+						DEFAULT_DEBOUNCE_MSEC;
+
 	INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
 
 	pchg->irqthread = create_singlethread_workqueue("lp8727-irqthd");
@@ -253,6 +257,8 @@ static int lp8727_intr_config(struct lp8727_chg *pchg)
 		return -ENOMEM;
 	}
 
+	pchg->debounce_jiffies = msecs_to_jiffies(delay_msec);
+
 	return request_threaded_irq(pchg->client->irq,
 				NULL,
 				lp8727_isr_func,
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index f4bcdd5..54b7788 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -53,6 +53,7 @@ struct lp8727_chg_param {
  * @get_batt_temp : get battery temperature
  * @ac                : charging parameters for AC type charger
  * @usb               : charging parameters for USB type charger
+ * @debounce_msec     : interrupt debounce time
  */
 struct lp8727_platform_data {
 	u8 (*get_batt_present)(void);
@@ -61,6 +62,7 @@ struct lp8727_platform_data {
 	u8 (*get_batt_temp)(void);
 	struct lp8727_chg_param *ac;
 	struct lp8727_chg_param *usb;
+	unsigned int debounce_msec;
 };
 
 #endif
-- 
1.7.9.5


Best Regards,
Milo


