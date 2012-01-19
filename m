Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2ASQwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:52:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2ASQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:51:58 -0500
From: Rabin Vincent <rabin@rab.in>
To: fengguang.wu@intel.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chanho0207@gmail.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCHv2] backing-dev: fix wakeup timer races with bdi_unregister()
Date: Thu, 19 Jan 2012 22:20:20 +0530
Message-Id: <1326991820-31393-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20120116025331.GA16516@localhost>
References: <20120116025331.GA16516@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 7a401a972df8e18 ("backing-dev: ensure wakeup_timer is deleted")
addressed the problem of the bdi being freed with a queued wakeup
timer, there are other races that could happen if the wakeup timer
expires after/during bdi_unregister(), before bdi_destroy() is called.

wakeup_timer_fn() could attempt to wakeup a task which has already has
been freed, or could access a NULL bdi->dev via the wake_forker_thread
tracepoint.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---

v2:
 - rebase onto the latest kernel which removed the thaw()
 - don't unnecessarily initialize task
 - unregister device after setting bdi->dev to NULL, not before

 mm/backing-dev.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7ba8fea..dd8e2aa 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -318,7 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
 	if (bdi->wb.task) {
 		trace_writeback_wake_thread(bdi);
 		wake_up_process(bdi->wb.task);
-	} else {
+	} else if (bdi->dev) {
 		/*
 		 * When bdi tasks are inactive for long time, they are killed.
 		 * In this case we have to wake-up the forker thread which
@@ -584,6 +584,8 @@ EXPORT_SYMBOL(bdi_register_dev);
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	struct task_struct *task;
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
@@ -602,8 +604,13 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * Finally, kill the kernel thread. We don't need to be RCU
 	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	if (bdi->wb.task)
-		kthread_stop(bdi->wb.task);
+	spin_lock_bh(&bdi->wb_lock);
+	task = bdi->wb.task;
+	bdi->wb.task = NULL;
+	spin_unlock_bh(&bdi->wb_lock);
+
+	if (task)
+		kthread_stop(task);
 }
 
 /*
@@ -623,7 +630,9 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
-	if (bdi->dev) {
+	struct device *dev = bdi->dev;
+
+	if (dev) {
 		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
@@ -632,8 +641,12 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
-		device_unregister(bdi->dev);
+
+		spin_lock_bh(&bdi->wb_lock);
 		bdi->dev = NULL;
+		spin_unlock_bh(&bdi->wb_lock);
+
+		device_unregister(dev);
 	}
 }
 EXPORT_SYMBOL(bdi_unregister);
-- 
1.7.7.3

