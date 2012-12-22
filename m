Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2LVB6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:00 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57653 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2LVB55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:57:57 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/25] ab8500_charger: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:52 -0800
Message-Id: <1356141435-17340-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from ab8500_charger.  Only compile
tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/power/ab8500_charger.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3be9c0e..40de240 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1319,8 +1319,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 		dev_dbg(di->dev, "%s Disabled USB charging\n", __func__);
 
 		/* Cancel any pending Vbat check work */
-		if (delayed_work_pending(&di->check_vbat_work))
-			cancel_delayed_work(&di->check_vbat_work);
+		cancel_delayed_work(&di->check_vbat_work);
 
 	}
 	ab8500_power_supply_changed(di, &di->usb_chg.psy);
@@ -2460,11 +2459,8 @@ static int ab8500_charger_resume(struct platform_device *pdev)
 			dev_err(di->dev, "Failed to kick WD!\n");
 
 		/* If not already pending start a new timer */
-		if (!delayed_work_pending(
-			&di->kick_wd_work)) {
-			queue_delayed_work(di->charger_wq, &di->kick_wd_work,
-				round_jiffies(WD_KICK_INTERVAL));
-		}
+		queue_delayed_work(di->charger_wq, &di->kick_wd_work,
+				   round_jiffies(WD_KICK_INTERVAL));
 	}
 
 	/* If we still have a HW failure, schedule a new check */
@@ -2482,8 +2478,7 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
 	struct ab8500_charger *di = platform_get_drvdata(pdev);
 
 	/* Cancel any pending HW failure check */
-	if (delayed_work_pending(&di->check_hw_failure_work))
-		cancel_delayed_work(&di->check_hw_failure_work);
+	cancel_delayed_work(&di->check_hw_failure_work);
 
 	return 0;
 }
-- 
1.8.0.2

