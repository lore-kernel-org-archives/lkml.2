Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1HYPYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:24:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34594 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1HYPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 062/118] drbd: Moved the thread name into the data structure
Date: Thu, 25 Aug 2011 17:07:58 +0200
Message-Id: <1314284934-17999-63-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |   20 +++++-----------
 drivers/block/drbd/drbd_int.h    |    2 +
 drivers/block/drbd/drbd_main.c   |   46 +++++++++++++++++++++++--------------
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 4da4c32..e85221f 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -119,13 +119,9 @@ static void __bm_print_lock_info(struct drbd_conf *mdev, const char *func)
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-	    current == mdev->tconn->receiver.task ? "receiver" :
-	    current == mdev->tconn->asender.task  ? "asender"  :
-	    current == mdev->tconn->worker.task   ? "worker"   : current->comm,
-	    func, b->bm_why ?: "?",
-	    b->bm_task == mdev->tconn->receiver.task ? "receiver" :
-	    b->bm_task == mdev->tconn->asender.task  ? "asender"  :
-	    b->bm_task == mdev->tconn->worker.task   ? "worker"   : "?");
+		drbd_task_to_thread_name(mdev, current),
+		func, b->bm_why ?: "?",
+		drbd_task_to_thread_name(mdev, b->bm_task));
 }
 
 void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
@@ -142,13 +138,9 @@ void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-		    current == mdev->tconn->receiver.task ? "receiver" :
-		    current == mdev->tconn->asender.task  ? "asender"  :
-		    current == mdev->tconn->worker.task   ? "worker"   : current->comm,
-		    why, b->bm_why ?: "?",
-		    b->bm_task == mdev->tconn->receiver.task ? "receiver" :
-		    b->bm_task == mdev->tconn->asender.task  ? "asender"  :
-		    b->bm_task == mdev->tconn->worker.task   ? "worker"   : "?");
+			 drbd_task_to_thread_name(mdev, current),
+			 why, b->bm_why ?: "?",
+			 drbd_task_to_thread_name(mdev, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2c18cf3..fda9a4d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -616,6 +616,7 @@ struct drbd_thread {
 	int (*function) (struct drbd_thread *);
 	struct drbd_conf *mdev;
 	int reset_cpu_mask;
+	char name[9];
 };
 
 static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
@@ -1130,6 +1131,7 @@ enum dds_flags {
 extern void drbd_init_set_defaults(struct drbd_conf *mdev);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
+extern char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task);
 #ifdef CONFIG_SMP
 extern void drbd_thread_current_set_cpu(struct drbd_conf *mdev);
 extern void drbd_calc_cpu_mask(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ccd57a9..5e9e57d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -462,7 +462,7 @@ restart:
 	 */
 
 	if (thi->t_state == RESTARTING) {
-		dev_info(DEV, "Restarting %s\n", current->comm);
+		dev_info(DEV, "Restarting %s thread\n", thi->name);
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
@@ -482,13 +482,14 @@ restart:
 }
 
 static void drbd_thread_init(struct drbd_conf *mdev, struct drbd_thread *thi,
-		      int (*func) (struct drbd_thread *))
+			     int (*func) (struct drbd_thread *), char *name)
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
 	thi->t_state = NONE;
 	thi->function = func;
 	thi->mdev = mdev;
+	strncpy(thi->name, name, ARRAY_SIZE(thi->name));
 }
 
 int drbd_thread_start(struct drbd_thread *thi)
@@ -497,11 +498,6 @@ int drbd_thread_start(struct drbd_thread *thi)
 	struct task_struct *nt;
 	unsigned long flags;
 
-	const char *me =
-		thi == &mdev->tconn->receiver ? "receiver" :
-		thi == &mdev->tconn->asender  ? "asender"  :
-		thi == &mdev->tconn->worker   ? "worker"   : "NONSENSE";
-
 	/* is used from state engine doing drbd_thread_stop_nowait,
 	 * while holding the req lock irqsave */
 	spin_lock_irqsave(&thi->t_lock, flags);
@@ -509,7 +505,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 	switch (thi->t_state) {
 	case NONE:
 		dev_info(DEV, "Starting %s thread (from %s [%d])\n",
-				me, current->comm, current->pid);
+			 thi->name, current->comm, current->pid);
 
 		/* Get ref on module for thread - this is released when thread exits */
 		if (!try_module_get(THIS_MODULE)) {
@@ -526,7 +522,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
 		nt = kthread_create(drbd_thread_setup, (void *) thi,
-				    "drbd%d_%s", mdev_to_minor(mdev), me);
+				    "drbd%d_%s", mdev_to_minor(mdev), thi->name);
 
 		if (IS_ERR(nt)) {
 			dev_err(DEV, "Couldn't start thread\n");
@@ -543,7 +539,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 	case EXITING:
 		thi->t_state = RESTARTING;
 		dev_info(DEV, "Restarting %s thread (from %s [%d])\n",
-				me, current->comm, current->pid);
+				thi->name, current->comm, current->pid);
 		/* fall through */
 	case RUNNING:
 	case RESTARTING:
@@ -592,6 +588,23 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 		wait_for_completion(&thi->stop);
 }
 
+static struct drbd_thread *drbd_task_to_thread(struct drbd_conf *mdev, struct task_struct *task)
+{
+	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_thread *thi =
+		task == tconn->receiver.task ? &tconn->receiver :
+		task == tconn->asender.task  ? &tconn->asender :
+		task == tconn->worker.task   ? &tconn->worker : NULL;
+
+	return thi;
+}
+
+char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task)
+{
+	struct drbd_thread *thi = drbd_task_to_thread(mdev, task);
+	return thi ? thi->name : task->comm;
+}
+
 #ifdef CONFIG_SMP
 /**
  * drbd_calc_cpu_mask() - Generate CPU masks, spread over all CPUs
@@ -629,11 +642,8 @@ void drbd_calc_cpu_mask(struct drbd_conf *mdev)
 void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 {
 	struct task_struct *p = current;
-	struct drbd_thread *thi =
-		p == mdev->tconn->asender.task  ? &mdev->tconn->asender  :
-		p == mdev->tconn->receiver.task ? &mdev->tconn->receiver :
-		p == mdev->tconn->worker.task   ? &mdev->tconn->worker   :
-		NULL;
+	struct drbd_thread *thi = drbd_task_to_thread(mdev, p);
+
 	if (!expect(thi != NULL))
 		return;
 	if (!thi->reset_cpu_mask)
@@ -1848,9 +1858,9 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	init_waitqueue_head(&mdev->al_wait);
 	init_waitqueue_head(&mdev->seq_wait);
 
-	drbd_thread_init(mdev, &mdev->tconn->receiver, drbdd_init);
-	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker);
-	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender);
+	drbd_thread_init(mdev, &mdev->tconn->receiver, drbdd_init, "receiver");
+	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker, "worker");
+	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender, "asender");
 
 	/* mdev->tconn->agreed_pro_version gets initialized in drbd_connect() */
 	mdev->write_ordering = WO_bdev_flush;
-- 
1.7.4.1

