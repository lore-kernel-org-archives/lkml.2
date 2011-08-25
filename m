Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1HYPO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:14:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32998 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab1HYPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 100/118] drbd: drbd_thread has now a pointer to a tconn instead of to a mdev
Date: Thu, 25 Aug 2011 17:08:36 +0200
Message-Id: <1314284934-17999-101-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c   |    8 +++---
 drivers/block/drbd/drbd_int.h      |    4 +-
 drivers/block/drbd/drbd_main.c     |   43 ++++++++++++++++-------------------
 drivers/block/drbd/drbd_receiver.c |    4 +-
 drivers/block/drbd/drbd_worker.c   |    2 +-
 5 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e85221f..e8d652f 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -119,9 +119,9 @@ static void __bm_print_lock_info(struct drbd_conf *mdev, const char *func)
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-		drbd_task_to_thread_name(mdev, current),
+		drbd_task_to_thread_name(mdev->tconn, current),
 		func, b->bm_why ?: "?",
-		drbd_task_to_thread_name(mdev, b->bm_task));
+		drbd_task_to_thread_name(mdev->tconn, b->bm_task));
 }
 
 void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
@@ -138,9 +138,9 @@ void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-			 drbd_task_to_thread_name(mdev, current),
+			 drbd_task_to_thread_name(mdev->tconn, current),
 			 why, b->bm_why ?: "?",
-			 drbd_task_to_thread_name(mdev, b->bm_task));
+			 drbd_task_to_thread_name(mdev->tconn, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5be0ae8..ddbb3d2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -624,7 +624,7 @@ struct drbd_thread {
 	struct completion stop;
 	enum drbd_thread_state t_state;
 	int (*function) (struct drbd_thread *);
-	struct drbd_conf *mdev;
+	struct drbd_tconn *tconn;
 	int reset_cpu_mask;
 	char name[9];
 };
@@ -1150,7 +1150,7 @@ enum dds_flags {
 extern void drbd_init_set_defaults(struct drbd_conf *mdev);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
-extern char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task);
+extern char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task);
 #ifdef CONFIG_SMP
 extern void drbd_thread_current_set_cpu(struct drbd_thread *thi);
 extern void drbd_calc_cpu_mask(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4589be4..dca4832 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -454,12 +454,12 @@ void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 static int drbd_thread_setup(void *arg)
 {
 	struct drbd_thread *thi = (struct drbd_thread *) arg;
-	struct drbd_conf *mdev = thi->mdev;
+	struct drbd_tconn *tconn = thi->tconn;
 	unsigned long flags;
 	int retval;
 
 	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
-		 thi->name[0], thi->mdev->tconn->name);
+		 thi->name[0], thi->tconn->name);
 
 restart:
 	retval = thi->function(thi);
@@ -477,7 +477,7 @@ restart:
 	 */
 
 	if (thi->t_state == RESTARTING) {
-		dev_info(DEV, "Restarting %s thread\n", thi->name);
+		conn_info(tconn, "Restarting %s thread\n", thi->name);
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
@@ -489,27 +489,27 @@ restart:
 	complete(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
 
-	dev_info(DEV, "Terminating %s\n", current->comm);
+	conn_info(tconn, "Terminating %s\n", current->comm);
 
 	/* Release mod reference taken when thread was started */
 	module_put(THIS_MODULE);
 	return retval;
 }
 
-static void drbd_thread_init(struct drbd_conf *mdev, struct drbd_thread *thi,
+static void drbd_thread_init(struct drbd_tconn *tconn, struct drbd_thread *thi,
 			     int (*func) (struct drbd_thread *), char *name)
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
 	thi->t_state = NONE;
 	thi->function = func;
-	thi->mdev = mdev;
+	thi->tconn = tconn;
 	strncpy(thi->name, name, ARRAY_SIZE(thi->name));
 }
 
 int drbd_thread_start(struct drbd_thread *thi)
 {
-	struct drbd_conf *mdev = thi->mdev;
+	struct drbd_tconn *tconn = thi->tconn;
 	struct task_struct *nt;
 	unsigned long flags;
 
@@ -519,28 +519,27 @@ int drbd_thread_start(struct drbd_thread *thi)
 
 	switch (thi->t_state) {
 	case NONE:
-		dev_info(DEV, "Starting %s thread (from %s [%d])\n",
+		conn_info(tconn, "Starting %s thread (from %s [%d])\n",
 			 thi->name, current->comm, current->pid);
 
 		/* Get ref on module for thread - this is released when thread exits */
 		if (!try_module_get(THIS_MODULE)) {
-			dev_err(DEV, "Failed to get module reference in drbd_thread_start\n");
+			conn_err(tconn, "Failed to get module reference in drbd_thread_start\n");
 			spin_unlock_irqrestore(&thi->t_lock, flags);
 			return false;
 		}
 
 		init_completion(&thi->stop);
-		D_ASSERT(thi->task == NULL);
 		thi->reset_cpu_mask = 1;
 		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
 		nt = kthread_create(drbd_thread_setup, (void *) thi,
-				    "drbd%d_%s", mdev_to_minor(mdev), thi->name);
+				    "drbd_%c_%s", thi->name[0], thi->tconn->name);
 
 		if (IS_ERR(nt)) {
-			dev_err(DEV, "Couldn't start thread\n");
+			conn_err(tconn, "Couldn't start thread\n");
 
 			module_put(THIS_MODULE);
 			return false;
@@ -553,7 +552,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		break;
 	case EXITING:
 		thi->t_state = RESTARTING;
-		dev_info(DEV, "Restarting %s thread (from %s [%d])\n",
+		conn_info(tconn, "Restarting %s thread (from %s [%d])\n",
 				thi->name, current->comm, current->pid);
 		/* fall through */
 	case RUNNING:
@@ -594,7 +593,6 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 		init_completion(&thi->stop);
 		if (thi->task != current)
 			force_sig(DRBD_SIGKILL, thi->task);
-
 	}
 
 	spin_unlock_irqrestore(&thi->t_lock, flags);
@@ -603,9 +601,8 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 		wait_for_completion(&thi->stop);
 }
 
-static struct drbd_thread *drbd_task_to_thread(struct drbd_conf *mdev, struct task_struct *task)
+static struct drbd_thread *drbd_task_to_thread(struct drbd_tconn *tconn, struct task_struct *task)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
 	struct drbd_thread *thi =
 		task == tconn->receiver.task ? &tconn->receiver :
 		task == tconn->asender.task  ? &tconn->asender :
@@ -614,9 +611,9 @@ static struct drbd_thread *drbd_task_to_thread(struct drbd_conf *mdev, struct ta
 	return thi;
 }
 
-char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task)
+char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task)
 {
-	struct drbd_thread *thi = drbd_task_to_thread(mdev, task);
+	struct drbd_thread *thi = drbd_task_to_thread(tconn, task);
 	return thi ? thi->name : task->comm;
 }
 
@@ -668,7 +665,7 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, thi->mdev->tconn->cpu_mask);
+	set_cpus_allowed_ptr(p, thi->tconn->cpu_mask);
 }
 #endif
 
@@ -1878,10 +1875,6 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	init_waitqueue_head(&mdev->al_wait);
 	init_waitqueue_head(&mdev->seq_wait);
 
-	drbd_thread_init(mdev, &mdev->tconn->receiver, drbdd_init, "receiver");
-	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker, "worker");
-	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender, "asender");
-
 	/* mdev->tconn->agreed_pro_version gets initialized in drbd_connect() */
 	mdev->write_ordering = WO_bdev_flush;
 	mdev->resync_wenr = LC_FREE;
@@ -2214,6 +2207,10 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	init_waitqueue_head(&tconn->net_cnt_wait);
 	idr_init(&tconn->volumes);
 
+	drbd_thread_init(tconn, &tconn->receiver, drbdd_init, "receiver");
+	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
+	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
+
 	write_lock_irq(&global_state_lock);
 	list_add(&tconn->all_tconn, &drbd_tconns);
 	write_unlock_irq(&global_state_lock);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3434ca9..54eb53f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4227,7 +4227,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 int drbdd_init(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->mdev->tconn;
+	struct drbd_tconn *tconn = thi->tconn;
 	int h;
 
 	conn_info(tconn, "receiver (re)started\n");
@@ -4594,7 +4594,7 @@ static int tconn_process_done_ee(struct drbd_tconn *tconn)
 
 int drbd_asender(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->mdev->tconn;
+	struct drbd_tconn *tconn = thi->tconn;
 	struct p_header *h = &tconn->meta.rbuf.header;
 	struct asender_cmd *cmd = NULL;
 	struct packet_info pi;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index c9b10d6..3f0f84a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1643,7 +1643,7 @@ static int _worker_dying(int vnr, void *p, void *data)
 
 int drbd_worker(struct drbd_thread *thi)
 {
-	struct drbd_tconn *tconn = thi->mdev->tconn;
+	struct drbd_tconn *tconn = thi->tconn;
 	struct drbd_work *w = NULL;
 	LIST_HEAD(work_list);
 	int intr = 0;
-- 
1.7.4.1

