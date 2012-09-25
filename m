Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2IYQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:25:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2IYQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:16 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 06/57] power: ab8500_bm: Skip first CCEOC irq for instant current
Date: Tue, 25 Sep 2012 10:12:03 -0600
Message-Id: <1348589574-25655-7-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Bjornstedt <johan.bjornstedt@stericsson.com>

When enabling the CCEOC irq we might get false interrupt
from ab8500-driver due to the latched value will be saved
and interpreted as an IRQ when enabled

Signed-off-by: Johan Bjornstedt <johan.bjornstedt@stericsson.com>
Signed-off-by: Henrik Solver <henrik.solver@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_btemp.c         |   11 ++----
 drivers/power/ab8500_fg.c            |   63 +++++++++++++++++++++++++++++----
 include/linux/mfd/abx500/ab8500-bm.h |    6 +++
 3 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 41a8ce4..45b10ad 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -374,13 +374,10 @@ static int ab8500_btemp_get_batctrl_res(struct ab8500_btemp *di)
 		return ret;
 	}
 
-	/*
-	 * Since there is no interrupt when current measurement is done,
-	 * loop for over 250ms (250ms is one sample conversion time
-	 * with 32.768 Khz RTC clock). Note that a stop time must be set
-	 * since the ab8500_btemp_read_batctrl_voltage call can block and
-	 * take an unknown amount of time to complete.
-	 */
+	do {
+		msleep(20);
+	} while (!ab8500_fg_inst_curr_started(di->fg));
+
 	i = 0;
 
 	do {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c098ddd..342d118 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -159,6 +159,7 @@ struct inst_curr_result_list {
  * @recovery_cnt:	Counter for recovery mode
  * @high_curr_cnt:	Counter for high current mode
  * @init_cnt:		Counter for init mode
+ * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
  * @recovery_needed:	Indicate if recovery is needed
  * @high_curr_mode:	Indicate if we're in high current mode
  * @init_capacity:	Indicate if initial capacity measuring should be done
@@ -166,6 +167,7 @@ struct inst_curr_result_list {
  * @calib_state		State during offset calibration
  * @discharge_state:	Current discharge state
  * @charge_state:	Current charge state
+ * @ab8500_fg_started	Completion struct used for the instant current start
  * @ab8500_fg_complete	Completion struct used for the instant current reading
  * @flags:		Structure for information about events triggered
  * @bat_cap:		Structure for battery capacity specific parameters
@@ -199,6 +201,7 @@ struct ab8500_fg {
 	int recovery_cnt;
 	int high_curr_cnt;
 	int init_cnt;
+	int nbr_cceoc_irq_cnt;
 	bool recovery_needed;
 	bool high_curr_mode;
 	bool init_capacity;
@@ -206,6 +209,7 @@ struct ab8500_fg {
 	enum ab8500_fg_calibration_state calib_state;
 	enum ab8500_fg_discharge_state discharge_state;
 	enum ab8500_fg_charge_state charge_state;
+	struct completion ab8500_fg_started;
 	struct completion ab8500_fg_complete;
 	struct ab8500_fg_flags flags;
 	struct ab8500_fg_battery_capacity bat_cap;
@@ -525,13 +529,14 @@ cc_err:
  * Note: This is part "one" and has to be called before
  * ab8500_fg_inst_curr_finalize()
  */
- int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
+int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 {
 	u8 reg_val;
 	int ret;
 
 	mutex_lock(&di->cc_lock);
 
+	di->nbr_cceoc_irq_cnt = 0;
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
 		AB8500_RTC_CC_CONF_REG, &reg_val);
 	if (ret < 0)
@@ -559,6 +564,7 @@ cc_err:
 	}
 
 	/* Return and WFI */
+	INIT_COMPLETION(di->ab8500_fg_started);
 	INIT_COMPLETION(di->ab8500_fg_complete);
 	enable_irq(di->irq);
 
@@ -570,6 +576,17 @@ fail:
 }
 
 /**
+ * ab8500_fg_inst_curr_started() - check if fg conversion has started
+ * @di:         pointer to the ab8500_fg structure
+ *
+ * Returns 1 if conversion started, 0 if still waiting
+ */
+int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
+{
+	return completion_done(&di->ab8500_fg_started);
+}
+
+/**
  * ab8500_fg_inst_curr_done() - check if fg conversion is done
  * @di:         pointer to the ab8500_fg structure
  *
@@ -597,13 +614,15 @@ int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res)
 	int timeout;
 
 	if (!completion_done(&di->ab8500_fg_complete)) {
-		timeout = wait_for_completion_timeout(&di->ab8500_fg_complete,
+		timeout = wait_for_completion_timeout(
+			&di->ab8500_fg_complete,
 			INS_CURR_TIMEOUT);
 		dev_dbg(di->dev, "Finalize time: %d ms\n",
 			((INS_CURR_TIMEOUT - timeout) * 1000) / HZ);
 		if (!timeout) {
 			ret = -ETIME;
 			disable_irq(di->irq);
+			di->nbr_cceoc_irq_cnt = 0;
 			dev_err(di->dev, "completion timed out [%d]\n",
 				__LINE__);
 			goto fail;
@@ -611,6 +630,7 @@ int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res)
 	}
 
 	disable_irq(di->irq);
+	di->nbr_cceoc_irq_cnt = 0;
 
 	ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
@@ -685,6 +705,7 @@ fail:
 int ab8500_fg_inst_curr_blocking(struct ab8500_fg *di)
 {
 	int ret;
+	int timeout;
 	int res = 0;
 
 	ret = ab8500_fg_inst_curr_start(di);
@@ -693,13 +714,32 @@ int ab8500_fg_inst_curr_blocking(struct ab8500_fg *di)
 		return 0;
 	}
 
+	/* Wait for CC to actually start */
+	if (!completion_done(&di->ab8500_fg_started)) {
+		timeout = wait_for_completion_timeout(
+			&di->ab8500_fg_started,
+			INS_CURR_TIMEOUT);
+		dev_dbg(di->dev, "Start time: %d ms\n",
+			((INS_CURR_TIMEOUT - timeout) * 1000) / HZ);
+		if (!timeout) {
+			ret = -ETIME;
+			dev_err(di->dev, "completion timed out [%d]\n",
+				__LINE__);
+			goto fail;
+		}
+	}
+
 	ret = ab8500_fg_inst_curr_finalize(di, &res);
 	if (ret) {
 		dev_err(di->dev, "Failed to finalize fg_inst\n");
 		return 0;
 	}
 
+	dev_dbg(di->dev, "%s instant current: %d", __func__, res);
 	return res;
+fail:
+	mutex_unlock(&di->cc_lock);
+	return ret;
 }
 
 /**
@@ -1524,8 +1564,6 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 
 	case AB8500_FG_DISCHARGE_WAKEUP:
 		ab8500_fg_coulomb_counter(di, true);
-		di->inst_curr = ab8500_fg_inst_curr_blocking(di);
-
 		ab8500_fg_calc_cap_discharge_voltage(di, true);
 
 		di->fg_samples = SEC_TO_SAMPLE(
@@ -1642,8 +1680,6 @@ static void ab8500_fg_periodic_work(struct work_struct *work)
 		fg_periodic_work.work);
 
 	if (di->init_capacity) {
-		/* A dummy read that will return 0 */
-		di->inst_curr = ab8500_fg_inst_curr_blocking(di);
 		/* Get an initial capacity calculation */
 		ab8500_fg_calc_cap_discharge_voltage(di, true);
 		ab8500_fg_check_capacity_limits(di, true);
@@ -1829,7 +1865,13 @@ static void ab8500_fg_instant_work(struct work_struct *work)
 static irqreturn_t ab8500_fg_cc_data_end_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
-	complete(&di->ab8500_fg_complete);
+	if (!di->nbr_cceoc_irq_cnt) {
+		di->nbr_cceoc_irq_cnt++;
+		complete(&di->ab8500_fg_started);
+	} else {
+		di->nbr_cceoc_irq_cnt = 0;
+		complete(&di->ab8500_fg_complete);
+	}
 	return IRQ_HANDLED;
 }
 
@@ -2548,7 +2590,11 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_samples = SEC_TO_SAMPLE(di->bat->fg_params->init_timer);
 	ab8500_fg_coulomb_counter(di, true);
 
-	/* Initialize completion used to notify completion of inst current */
+	/*
+	 * Initialize completion used to notify completion and start
+	 * of inst current
+	 */
+	init_completion(&di->ab8500_fg_started);
 	init_completion(&di->ab8500_fg_complete);
 
 	/* Register interrupts */
@@ -2568,6 +2614,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	}
 	di->irq = platform_get_irq_byname(pdev, "CCEOC");
 	disable_irq(di->irq);
+	di->nbr_cceoc_irq_cnt = 0;
 
 	platform_set_drvdata(pdev, di);
 
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 44310c9..73479f0 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -431,11 +431,17 @@ struct ab8500_fg *ab8500_fg_get(void);
 int ab8500_fg_inst_curr_blocking(struct ab8500_fg *dev);
 int ab8500_fg_inst_curr_start(struct ab8500_fg *di);
 int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res);
+int ab8500_fg_inst_curr_started(struct ab8500_fg *di);
 int ab8500_fg_inst_curr_done(struct ab8500_fg *di);
 
 #else
+int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
+{
+	return 0;
+}
 int ab8500_fg_inst_curr_done(struct ab8500_fg *di)
 {
+	return 0;
 }
 static void ab8500_fg_reinit(void)
 {
-- 
1.7.5.4

