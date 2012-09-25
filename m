Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2IYQNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2IYQNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:41 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 24/57] power: ab8500_fg: Adjust for RF bursts voltage drops.
Date: Tue, 25 Sep 2012 10:12:21 -0600
Message-Id: <1348589574-25655-25-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Changed conditions for restarting low battery measurements counter
and adjusted the interval between measurements to avoid RF burst
induced voltage drops, and to shorten time to decide to shut down.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_fg.c |   44 ++++++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7c42150..861927d 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -42,7 +42,7 @@
 
 #define NBR_AVG_SAMPLES			20
 
-#define LOW_BAT_CHECK_INTERVAL		(2 * HZ)
+#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
 
 #define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
 #define BATT_OK_MIN			2360 /* mV */
@@ -168,6 +168,7 @@ struct inst_curr_result_list {
  * @recovery_cnt:	Counter for recovery mode
  * @high_curr_cnt:	Counter for high current mode
  * @init_cnt:		Counter for init mode
+ * @low_bat_cnt		Counter for number of consecutive low battery measures
  * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
  * @recovery_needed:	Indicate if recovery is needed
  * @high_curr_mode:	Indicate if we're in high current mode
@@ -210,6 +211,7 @@ struct ab8500_fg {
 	int recovery_cnt;
 	int high_curr_cnt;
 	int init_cnt;
+	int low_bat_cnt;
 	int nbr_cceoc_irq_cnt;
 	bool recovery_needed;
 	bool high_curr_mode;
@@ -1882,25 +1884,29 @@ static void ab8500_fg_low_bat_work(struct work_struct *work)
 
 	/* Check if LOW_BAT still fulfilled */
 	if (vbat < di->bat->fg_params->lowbat_threshold) {
-		di->flags.low_bat = true;
-		dev_warn(di->dev, "Battery voltage still LOW\n");
-
-		/*
-		 * We need to re-schedule this check to be able to detect
-		 * if the voltage increases again during charging
-		 */
-		queue_delayed_work(di->fg_wq, &di->fg_low_bat_work,
-			round_jiffies(LOW_BAT_CHECK_INTERVAL));
+		/* Is it time to shut down? */
+		if (di->low_bat_cnt < 1) {
+			di->flags.low_bat = true;
+			dev_warn(di->dev, "Shut down pending...\n");
+		} else {
+			/*
+			* Else we need to re-schedule this check to be able
+			* to detect if the voltage increases again during
+			* charging or due to decreasing load.
+			*/
+			di->low_bat_cnt--;
+			dev_warn(di->dev, "Battery voltage still LOW\n");
+			queue_delayed_work(di->fg_wq, &di->fg_low_bat_work,
+				round_jiffies(LOW_BAT_CHECK_INTERVAL));
+		}
 	} else {
-		di->flags.low_bat = false;
+		di->flags.low_bat_delay = false;
+		di->low_bat_cnt = 10;
 		dev_warn(di->dev, "Battery voltage OK again\n");
 	}
 
 	/* This is needed to dispatch LOW_BAT */
 	ab8500_fg_check_capacity_limits(di, false);
-
-	/* Set this flag to check if LOW_BAT IRQ still occurs */
-	di->flags.low_bat_delay = false;
 }
 
 /**
@@ -2059,6 +2065,10 @@ static irqreturn_t ab8500_fg_lowbatf_handler(int irq, void *_di)
 {
 	struct ab8500_fg *di = _di;
 
+	/*
+	 * Initiate handling in ab8500_fg_low_bat_work() if not already
+	 * initiated.
+	 */
 	if (!di->flags.low_bat_delay) {
 		dev_warn(di->dev, "Battery voltage is below LOW threshold\n");
 		di->flags.low_bat_delay = true;
@@ -2748,6 +2758,12 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK_DEFERRABLE(&di->fg_check_hw_failure_work,
 		ab8500_fg_check_hw_failure_work);
 
+	/* Reset battery low voltage flag */
+	di->flags.low_bat = false;
+
+	/* Initialize low battery counter */
+	di->low_bat_cnt = 10;
+
 	/* Initialize OVV, and other registers */
 	ret = ab8500_fg_init_hw_registers(di);
 	if (ret) {
-- 
1.7.5.4

