Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2LVCBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:01:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48614 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2LVB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:31 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 17/25] wm97xx: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:07 -0800
Message-Id: <1356141435-17340-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from wm97xx.  Instead of testing
work_pending(), use the return value of queue_work() to decide whether
to disable IRQ or not.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/input/touchscreen/wm97xx-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 5dbe73a..fd16c63 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -363,10 +363,8 @@ static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
 {
 	struct wm97xx *wm = dev_id;
 
-	if (!work_pending(&wm->pen_event_work)) {
+	if (queue_work(wm->ts_workq, &wm->pen_event_work))
 		wm->mach_ops->irq_enable(wm, 0);
-		queue_work(wm->ts_workq, &wm->pen_event_work);
-	}
 
 	return IRQ_HANDLED;
 }
-- 
1.8.0.2

