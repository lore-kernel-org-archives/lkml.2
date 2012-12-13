Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2LMPWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39028 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2LMPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/18] power: ab8500_btemp: Ignore false btemp low interrupt
Date: Thu, 13 Dec 2012 15:21:32 +0000
Message-Id: <1355412102-14265-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Ignore the low btemp interrupts for ab8500 3.0 and 3.3

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/power/ab8500_btemp.c      |   20 ++++++++++----------
 include/linux/mfd/abx500/ab8500.h |    5 +++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index efeb6dd..6f6a715 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -622,9 +622,9 @@ static irqreturn_t ab8500_btemp_templow_handler(int irq, void *_di)
 {
 	struct ab8500_btemp *di = _di;
 
-	if (is_ab8500_2p0_or_earlier(di->parent)) {
+	if (is_ab8500_3p3_or_earlier(di->parent)) {
 		dev_dbg(di->dev, "Ignore false btemp low irq"
-			" for ABB cut 1.0, 1.1 and 2.0\n");
+			" for ABB cut 1.0, 1.1, 2.0 and 3.3\n");
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
@@ -1030,8 +1030,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		ab8500_btemp_periodic_work);
 
 	/* Set BTEMP thermal limits. Low and Med are fixed */
-	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
-	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
+	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT * 10;
+	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT * 10;
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_BTEMP_HIGH_TH, &val);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 1491044..46f5f62 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -335,6 +335,11 @@ static inline int is_ab8500_2p0_or_earlier(struct ab8500 *ab)
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
1.7.9.5

