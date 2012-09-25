Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2IYQ00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:26:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab2IYQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:11 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 03/57] power: ab8500_btemp: Detect battery type in workqueue
Date: Tue, 25 Sep 2012 10:12:00 -0600
Message-Id: <1348589574-25655-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Detect battery type in work queue instead of probe.
This reduces the system boot time with 1.5s

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_btemp.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index bba3cca..94a3ee8 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -83,6 +83,7 @@ struct ab8500_btemp_ranges {
  * @btemp_ranges:	Battery temperature range structure
  * @btemp_wq:		Work queue for measuring the temperature periodically
  * @btemp_periodic_work:	Work for measuring the temperature periodically
+ * @initialized:	True if battery id read.
  */
 struct ab8500_btemp {
 	struct device *dev;
@@ -100,6 +101,7 @@ struct ab8500_btemp {
 	struct ab8500_btemp_ranges btemp_ranges;
 	struct workqueue_struct *btemp_wq;
 	struct delayed_work btemp_periodic_work;
+	bool initialized;
 };
 
 /* BTEMP power supply properties */
@@ -569,6 +571,13 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 	struct ab8500_btemp *di = container_of(work,
 		struct ab8500_btemp, btemp_periodic_work.work);
 
+	if (!di->initialized) {
+		di->initialized = true;
+		/* Identify the battery */
+		if (ab8500_btemp_id(di) < 0)
+			dev_warn(di->dev, "failed to identify the battery\n");
+	}
+
 	di->bat_temp = ab8500_btemp_measure_temp(di);
 
 	if (di->bat_temp != di->prev_bat_temp) {
@@ -981,6 +990,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
+	di->initialized = false;
+
 	/* get btemp specific platform data */
 	di->pdata = plat_data->btemp;
 	if (!di->pdata) {
@@ -1021,10 +1032,6 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK_DEFERRABLE(&di->btemp_periodic_work,
 		ab8500_btemp_periodic_work);
 
-	/* Identify the battery */
-	if (ab8500_btemp_id(di) < 0)
-		dev_warn(di->dev, "failed to identify the battery\n");
-
 	/* Set BTEMP thermal limits. Low and Med are fixed */
 	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
 	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
-- 
1.7.5.4

