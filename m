Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0IFMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:47:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:50752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0IFMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:37 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] backing-dev: replace sync_supers_tsk/timer with a delayed_work
Date: Mon,  6 Sep 2010 14:46:22 +0200
Message-Id: <1283777182-11426-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_supers_task/timer can trivially replaced with a delayed_work.  As
it's not on the allocation path, run it on the system_wq.

NOTE: Both before and after this patch, sync_supers is not freezeable.
      This might need to be changed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/backing-dev.c |   49 ++++++++++++++-----------------------------------
 1 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 3b2a657..4fb8095 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -45,11 +45,8 @@ LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
 struct workqueue_struct *bdi_wq;
 
-static struct task_struct *sync_supers_tsk;
-static struct timer_list sync_supers_timer;
-
-static int bdi_sync_supers(void *);
-static void sync_supers_timer_fn(unsigned long);
+static void bdi_sync_supers_work_fn(struct work_struct *work);
+static DECLARE_DELAYED_WORK(bdi_sync_supers_work, bdi_sync_supers_work_fn);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -239,10 +236,6 @@ static int __init default_bdi_init(void)
 				 WQ_UNBOUND | WQ_FREEZEABLE | WQ_RESCUER, 0);
 	BUG_ON(!bdi_wq);
 
-	sync_supers_tsk = kthread_run(bdi_sync_supers, NULL, "sync_supers");
-	BUG_ON(IS_ERR(sync_supers_tsk));
-
-	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
 	bdi_arm_supers_timer();
 
 	err = bdi_init(&default_backing_dev_info);
@@ -271,43 +264,29 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 }
 
 /*
- * kupdated() used to do this. We cannot do it from the bdi_forker_thread()
- * or we risk deadlocking on ->s_umount. The longer term solution would be
- * to implement sync_supers_bdi() or similar and simply do it from the
- * bdi writeback thread individually.
+ * kupdated() used to do this.  Don't do it from bdi_wq as we might
+ * deadlock on ->s_umount.
  */
-static int bdi_sync_supers(void *unused)
+static void bdi_sync_supers_work_fn(struct work_struct *work)
 {
-	set_user_nice(current, 0);
-
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-
-		/*
-		 * Do this periodically, like kupdated() did before.
-		 */
-		sync_supers();
-	}
+	/* Do this periodically, like kupdated() did before */
+	sync_supers();
 
-	return 0;
+	if (dirty_writeback_interval)
+		schedule_delayed_work(&bdi_sync_supers_work,
+			msecs_to_jiffies(dirty_writeback_interval * 10));
 }
 
 void bdi_arm_supers_timer(void)
 {
-	unsigned long next;
+	/* Interval might have decreased, cancel delayed work first */
+	cancel_delayed_work(&bdi_sync_supers_work);
 
 	if (!dirty_writeback_interval)
 		return;
 
-	next = msecs_to_jiffies(dirty_writeback_interval * 10) + jiffies;
-	mod_timer(&sync_supers_timer, round_jiffies_up(next));
-}
-
-static void sync_supers_timer_fn(unsigned long unused)
-{
-	wake_up_process(sync_supers_tsk);
-	bdi_arm_supers_timer();
+	schedule_delayed_work(&bdi_sync_supers_work,
+			      msecs_to_jiffies(dirty_writeback_interval * 10));
 }
 
 static void bdi_timer_fn(unsigned long data)
-- 
1.7.1

