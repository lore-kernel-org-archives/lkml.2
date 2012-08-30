Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2H3LkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:40:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57516 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2H3LkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:40:05 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 4/8] lp8727_charger: cleanup the interrupt handler code
Thread-Topic: [PATCH 4/8] lp8727_charger: cleanup the interrupt handler code
Thread-Index: Ac2GpC2My7UxHXuHRIm0ydHFzp/YMg==
Date: Thu, 30 Aug 2012 11:39:57 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1CA4@DQHE02.ent.ti.com>
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

(a) add configurable debounce timer in the platform data
    : if it is not defined, default time(270ms) is set.
(b) use schedule_delay_work() and remove unnecessary workqueue resource
    : for delayed interrupt handling, use the schedule_delay_work()
(c) add lp8727_release_irq() for clearing the irq
(c) clear interrupts while loading the driver

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c       |   70 +++++++++++++++++++++++-----------
 include/linux/platform_data/lp8727.h |    2 +
 2 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 975a4f2..742c33a 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -17,8 +17,6 @@
 #include <linux/power_supply.h>
 #include <linux/platform_data/lp8727.h>
 
-#define DEBOUNCE_MSEC	270
-
 /* Registers */
 #define CTRL1		0x1
 #define CTRL2		0x2
@@ -58,6 +56,9 @@
 /* STATUS2 register */
 #define TEMP_STAT	(3 << 5)
 
+#define LP8788_NUM_INTREGS		2
+#define DEFAULT_DEBOUNCE_MSEC		270
+
 enum lp8727_dev_id {
 	ID_NONE,
 	ID_TA,
@@ -84,10 +85,17 @@ struct lp8727_chg {
 	struct device *dev;
 	struct i2c_client *client;
 	struct mutex xfer_lock;
+
+	/* interrupt handling */
+	int irq;
 	struct delayed_work work;
-	struct workqueue_struct *irqthread;
-	struct lp8727_platform_data *pdata;
+	unsigned long debounce_jiffies;
+
+	/* power supplies */
 	struct lp8727_psy *psy;
+
+	/* charging parameters */
+	struct lp8727_platform_data *pdata;
 	struct lp8727_chg_param *chg_param;
 	enum lp8727_dev_id devid;
 };
@@ -135,6 +143,12 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
 {
 	u8 val;
 	int ret;
+	u8 intstat[LP8788_NUM_INTREGS];
+
+	/* clear interrupts */
+	ret = lp8727_read_bytes(pchg, INT1, intstat, LP8788_NUM_INTREGS);
+	if (ret)
+		return ret;
 
 	val = ID200_EN | ADC_EN | CP_EN;
 	ret = lp8727_write_byte(pchg, CTRL1, val);
@@ -236,29 +250,43 @@ static void lp8727_delayed_func(struct work_struct *_work)
 static irqreturn_t lp8727_isr_func(int irq, void *ptr)
 {
 	struct lp8727_chg *pchg = ptr;
-	unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
-
-	queue_delayed_work(pchg->irqthread, &pchg->work, delay);
 
+	schedule_delayed_work(&pchg->work, pchg->debounce_jiffies);
 	return IRQ_HANDLED;
 }
 
-static int lp8727_intr_config(struct lp8727_chg *pchg)
+static int lp8727_setup_irq(struct lp8727_chg *pchg)
 {
+	int ret;
+	int irq = pchg->client->irq;
+	unsigned delay_msec = pchg->pdata ? pchg->pdata->debounce_msec :
+						DEFAULT_DEBOUNCE_MSEC;
+
 	INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
 
-	pchg->irqthread = create_singlethread_workqueue("lp8727-irqthd");
-	if (!pchg->irqthread) {
-		dev_err(pchg->dev, "can not create thread for lp8727\n");
-		return -ENOMEM;
+	if (irq <= 0) {
+		dev_warn(pchg->dev, "invalid irq number: %d\n", irq);
+		return 0;
 	}
 
-	return request_threaded_irq(pchg->client->irq,
-				NULL,
-				lp8727_isr_func,
-				IRQF_TRIGGER_FALLING,
-				"lp8727_irq",
-				pchg);
+	ret = request_threaded_irq(irq, NULL, lp8727_isr_func,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				"lp8727_irq", pchg);
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
@@ -465,7 +493,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		return ret;
 	}
 
-	ret = lp8727_intr_config(pchg);
+	ret = lp8727_setup_irq(pchg);
 	if (ret) {
 		dev_err(pchg->dev, "irq handler err: %d", ret);
 		lp8727_unregister_psy(pchg);
@@ -479,9 +507,7 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 {
 	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
 
-	free_irq(pchg->client->irq, pchg);
-	flush_workqueue(pchg->irqthread);
-	destroy_workqueue(pchg->irqthread);
+	lp8727_release_irq(pchg);
 	lp8727_unregister_psy(pchg);
 	return 0;
 }
diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
index ff14591..81edbd6 100644
--- a/include/linux/platform_data/lp8727.h
+++ b/include/linux/platform_data/lp8727.h
@@ -53,6 +53,7 @@ struct lp8727_chg_param {
  * @get_batt_temp     : get battery temperature
  * @ac                : charging parameters for AC type charger
  * @usb               : charging parameters for USB type charger
+ * @debounce_msec     : interrupt debouce time
  */
 struct lp8727_platform_data {
 	u8 (*get_batt_present)(void);
@@ -61,6 +62,7 @@ struct lp8727_platform_data {
 	u8 (*get_batt_temp)(void);
 	struct lp8727_chg_param *ac;
 	struct lp8727_chg_param *usb;
+	unsigned debounce_msec;
 };
 
 #endif
-- 
1.7.9.5


Best Regards,
Milo


