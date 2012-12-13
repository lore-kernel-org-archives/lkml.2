Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2LMPYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:24:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2LMPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/18] power: ab8500_fg: Added support for BATT_OVV
Date: Thu, 13 Dec 2012 15:21:36 +0000
Message-Id: <1355412102-14265-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

Add support for the battery over-voltage situation

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_fg.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 5aa981e..f931bf8 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1840,24 +1840,26 @@ static void ab8500_fg_check_hw_failure_work(struct work_struct *work)
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
 
@@ -2037,8 +2039,6 @@ static irqreturn_t ab8500_fg_batt_ovv_handler(int irq, void *_di)
 	struct ab8500_fg *di = _di;
 
 	dev_dbg(di->dev, "Battery OVV\n");
-	di->flags.bat_ovv = true;
-	power_supply_changed(&di->fg_psy);
 
 	/* Schedule a new HW failure check */
 	queue_delayed_work(di->fg_wq, &di->fg_check_hw_failure_work, 0);
-- 
1.7.9.5

