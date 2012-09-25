Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2IYQXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:23:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab2IYQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:32 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 17/57] power: ab8500_bm: Added support for BATT_OVV
Date: Tue, 25 Sep 2012 10:12:14 -0600
Message-Id: <1348589574-25655-18-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Add support for the battery over-voltage situation

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_fg.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c4d9307..8507254 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1842,24 +1842,26 @@ static void ab8500_fg_check_hw_failure_work(struct work_struct *work)
 	 * If we have had a battery over-voltage situation,
 	 * check ovv-bit to see if it should be reset.
 	 */
-	if (di->flags.bat_ovv) {
-		ret = abx500_get_register_interruptible(di->dev,
-			AB8500_CHARGER, AB8500_CH_STAT_REG,
-			&reg_value);
-		if (ret < 0) {
-			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
-			return;
-		}
-		if ((reg_value & BATT_OVV) != BATT_OVV) {
-			dev_dbg(di->dev, "Battery recovered from OVV\n");
-			di->flags.bat_ovv = false;
+	ret = abx500_get_register_interruptible(di->dev,
+		AB8500_CHARGER, AB8500_CH_STAT_REG,
+		&reg_value);
+	if (ret < 0) {
+		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
+		return;
+	}
+	if ((reg_value & BATT_OVV) == BATT_OVV) {
+		if (!di->flags.bat_ovv) {
+			dev_dbg(di->dev, "Battery OVV\n");
+			di->flags.bat_ovv = true;
 			power_supply_changed(&di->fg_psy);
-			return;
 		}
-
 		/* Not yet recovered from ovv, reschedule this test */
 		queue_delayed_work(di->fg_wq, &di->fg_check_hw_failure_work,
-				   round_jiffies(HZ));
+			HZ);
+		} else {
+			dev_dbg(di->dev, "Battery recovered from OVV\n");
+			di->flags.bat_ovv = false;
+			power_supply_changed(&di->fg_psy);
 	}
 }
 
@@ -2039,8 +2041,6 @@ static irqreturn_t ab8500_fg_batt_ovv_handler(int irq, void *_di)
 	struct ab8500_fg *di = _di;
 
 	dev_dbg(di->dev, "Battery OVV\n");
-	di->flags.bat_ovv = true;
-	power_supply_changed(&di->fg_psy);
 
 	/* Schedule a new HW failure check */
 	queue_delayed_work(di->fg_wq, &di->fg_check_hw_failure_work, 0);
-- 
1.7.5.4

