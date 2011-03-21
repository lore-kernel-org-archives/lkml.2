Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1CUQ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:27:08 -0400
Received: from smtp.nokia.com ([147.243.128.26]:39292 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab1CUQ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:27:06 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH] input: tsc2005: fix locking issue
Date: Mon, 21 Mar 2011 18:24:10 +0200
Message-Id: <1300724650-6641-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0b950d3 (Input: tsc2005 - add open/close) introduced a
locking issue with the ESD watchdog: __tsc2005_disable() is calling
cancel_delayed_work_sync() with mutex held, and the work also needs the
same mutex.

Fix the problem by using cancel_delayed_work() on disable. If
the ESD work was running it will check if the device is closed
or suspended, and in that case it will do nothing and skip
re-arming. cancel_delayed_work_sync() is still needed when the module
is removed.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/input/touchscreen/tsc2005.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 8742061..3a15587 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -345,7 +345,7 @@ static void __tsc2005_disable(struct tsc2005 *ts)
 	disable_irq(ts->spi->irq);
 	del_timer_sync(&ts->penup_timer);
 
-	cancel_delayed_work_sync(&ts->esd_work);
+	cancel_delayed_work(&ts->esd_work);
 
 	enable_irq(ts->spi->irq);
 }
@@ -479,6 +479,12 @@ static void tsc2005_esd_work(struct work_struct *work)
 
 	mutex_lock(&ts->mutex);
 
+	/* The device has been just closed or suspended. */
+	if (!ts->opened || ts->suspended) {
+		mutex_unlock(&ts->mutex);
+		return;
+	}
+
 	if (time_is_after_jiffies(ts->last_valid_interrupt +
 				  msecs_to_jiffies(ts->esd_timeout)))
 		goto out;
@@ -685,6 +691,7 @@ static int __devexit tsc2005_remove(struct spi_device *spi)
 
 	free_irq(ts->spi->irq, ts);
 	input_unregister_device(ts->idev);
+	cancel_delayed_work_sync(&ts->esd_work);
 	kfree(ts);
 
 	spi_set_drvdata(spi, NULL);
-- 
1.5.6.5

