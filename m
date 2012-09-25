Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2IYQYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:24:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2IYQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:26 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 13/57] power: ab8500_bm: Ignore false btemp low interrupt
Date: Tue, 25 Sep 2012 10:12:10 -0600
Message-Id: <1348589574-25655-14-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Ignore the low btemp interrupts for ab8500 3.0 and 3.3

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_btemp.c      |   22 +++++++++++-----------
 include/linux/mfd/abx500/ab8500.h |    5 +++++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 45b10ad..04f9dec 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -622,9 +622,9 @@ static irqreturn_t ab8500_btemp_templow_handler(int irq, void *_di)
 {
 	struct ab8500_btemp *di = _di;
 
-	if (is_ab8500_2p0_or_earlier(di->parent)) {
-		dev_dbg(di->dev, "Ignore false btemp low irq"
-			" for ABB cut 1.0, 1.1 and 2.0\n");
+	if (is_ab8500_3p3_or_earlier(di->parent)) {
+		dev_dbg(di->dev, "Ignore false btemp low irq");
+		dev_dbg(di->dev, " for ABB cut 1.0, 1.1, 2.0 and 3.3\n");
 	} else {
 		dev_crit(di->dev, "Battery temperature lower than -10deg c\n");
 
@@ -738,30 +738,30 @@ static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 	int temp = 0;
 
 	/*
-	 * The BTEMP events are not reliabe on AB8500 cut2.0
+	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_2p0_or_earlier(di->parent)) {
+	if (is_ab8500_3p3_or_earlier(di->parent)) {
 		temp = di->bat_temp * 10;
 	} else {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit;
+				temp = di->btemp_ranges.btemp_low_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit;
+				temp = di->btemp_ranges.btemp_high_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit;
+				temp = di->btemp_ranges.btemp_med_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit;
+				temp = di->btemp_ranges.btemp_med_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else
@@ -1026,8 +1026,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		ab8500_btemp_periodic_work);
 
 	/* Set BTEMP thermal limits. Low and Med are fixed */
-	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
-	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
+	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT * 10;
+	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT * 10;
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_BTEMP_HIGH_TH, &val);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index db8a1e3..087b445 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -340,6 +340,11 @@ static inline int is_ab8500_2p0_or_earlier(struct ab8500 *ab)
 	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT2P0));
 }
 
+static inline int is_ab8500_3p3_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT3P3));
+}
+
 /* exclude also ab8505, ab9540... */
 static inline int is_ab8500_2p0(struct ab8500 *ab)
 {
-- 
1.7.5.4

