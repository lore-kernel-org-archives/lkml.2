Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1HYPQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:16:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35533 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1HYPJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 092/118] drbd: Converted drbd_calc_cpu_mask() and drbd_thread_current_set_cpu() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:28 +0200
Message-Id: <1314284934-17999-93-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 ++++----
 drivers/block/drbd/drbd_main.c     |   26 ++++++++++++++++----------
 drivers/block/drbd/drbd_nl.c       |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_worker.c   |    2 +-
 5 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4ececc3..ae482ed 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -945,6 +945,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct drbd_thread receiver;
 	struct drbd_thread worker;
 	struct drbd_thread asender;
+	cpumask_var_t cpu_mask;
 };
 
 struct drbd_conf {
@@ -1074,7 +1075,6 @@ struct drbd_conf {
 	spinlock_t peer_seq_lock;
 	unsigned int minor;
 	unsigned long comm_bm_set; /* communicated number of set bits. */
-	cpumask_var_t cpu_mask;
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
 	struct mutex state_mutex;
@@ -1148,10 +1148,10 @@ extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
 extern char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task);
 #ifdef CONFIG_SMP
-extern void drbd_thread_current_set_cpu(struct drbd_conf *mdev, struct drbd_thread *thi);
-extern void drbd_calc_cpu_mask(struct drbd_conf *mdev);
+extern void drbd_thread_current_set_cpu(struct drbd_thread *thi);
+extern void drbd_calc_cpu_mask(struct drbd_tconn *tconn);
 #else
-#define drbd_thread_current_set_cpu(A, B) ({})
+#define drbd_thread_current_set_cpu(A) ({})
 #define drbd_calc_cpu_mask(A) ({})
 #endif
 extern void drbd_free_resources(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d7421b6..7612394 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -618,6 +618,12 @@ char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task)
 }
 
 #ifdef CONFIG_SMP
+static int conn_lowest_minor(struct drbd_tconn *tconn)
+{
+	int minor = 0;
+	idr_get_next(&tconn->volumes, &minor);
+	return minor;
+}
 /**
  * drbd_calc_cpu_mask() - Generate CPU masks, spread over all CPUs
  * @mdev:	DRBD device.
@@ -625,23 +631,23 @@ char *drbd_task_to_thread_name(struct drbd_conf *mdev, struct task_struct *task)
  * Forces all threads of a device onto the same CPU. This is beneficial for
  * DRBD's performance. May be overwritten by user's configuration.
  */
-void drbd_calc_cpu_mask(struct drbd_conf *mdev)
+void drbd_calc_cpu_mask(struct drbd_tconn *tconn)
 {
 	int ord, cpu;
 
 	/* user override. */
-	if (cpumask_weight(mdev->cpu_mask))
+	if (cpumask_weight(tconn->cpu_mask))
 		return;
 
-	ord = mdev_to_minor(mdev) % cpumask_weight(cpu_online_mask);
+	ord = conn_lowest_minor(tconn) % cpumask_weight(cpu_online_mask);
 	for_each_online_cpu(cpu) {
 		if (ord-- == 0) {
-			cpumask_set_cpu(cpu, mdev->cpu_mask);
+			cpumask_set_cpu(cpu, tconn->cpu_mask);
 			return;
 		}
 	}
 	/* should not be reached */
-	cpumask_setall(mdev->cpu_mask);
+	cpumask_setall(tconn->cpu_mask);
 }
 
 /**
@@ -652,14 +658,14 @@ void drbd_calc_cpu_mask(struct drbd_conf *mdev)
  * call in the "main loop" of _all_ threads, no need for any mutex, current won't die
  * prematurely.
  */
-void drbd_thread_current_set_cpu(struct drbd_conf *mdev, struct drbd_thread *thi)
+void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 {
 	struct task_struct *p = current;
 
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, mdev->cpu_mask);
+	set_cpus_allowed_ptr(p, thi->mdev->tconn->cpu_mask);
 }
 #endif
 
@@ -2248,7 +2254,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 		dev_err(DEV, "vnr = %d\n", vnr);
 		goto out_no_cpumask;
 	}
-	if (!zalloc_cpumask_var(&mdev->cpu_mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mdev->tconn->cpu_mask, GFP_KERNEL))
 		goto out_no_cpumask;
 
 	mdev->tconn->volume0 = mdev;
@@ -2325,7 +2331,7 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	free_cpumask_var(mdev->cpu_mask);
+	free_cpumask_var(mdev->tconn->cpu_mask);
 out_no_cpumask:
 	drbd_free_tconn(mdev->tconn);
 out_no_tconn:
@@ -2344,7 +2350,7 @@ void drbd_free_mdev(struct drbd_conf *mdev)
 	__free_page(mdev->md_io_page);
 	put_disk(mdev->vdisk);
 	blk_cleanup_queue(mdev->rq_queue);
-	free_cpumask_var(mdev->cpu_mask);
+	free_cpumask_var(mdev->tconn->cpu_mask);
 	kfree(mdev);
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index df36a57..331495f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1884,9 +1884,9 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	if (mdev->state.conn >= C_CONNECTED)
 		drbd_send_sync_param(mdev, &sc);
 
-	if (!cpumask_equal(mdev->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(mdev->cpu_mask, new_cpu_mask);
-		drbd_calc_cpu_mask(mdev);
+	if (!cpumask_equal(mdev->tconn->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(mdev->tconn->cpu_mask, new_cpu_mask);
+		drbd_calc_cpu_mask(mdev->tconn);
 		mdev->tconn->receiver.reset_cpu_mask = 1;
 		mdev->tconn->asender.reset_cpu_mask = 1;
 		mdev->tconn->worker.reset_cpu_mask = 1;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b1eedd1..306532c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3782,7 +3782,7 @@ static void drbdd(struct drbd_conf *mdev)
 	int rv;
 
 	while (get_t_state(&mdev->tconn->receiver) == RUNNING) {
-		drbd_thread_current_set_cpu(mdev, &mdev->tconn->receiver);
+		drbd_thread_current_set_cpu(&mdev->tconn->receiver);
 		if (!drbd_recv_header(mdev->tconn, &pi))
 			goto err_out;
 
@@ -4571,7 +4571,7 @@ int drbd_asender(struct drbd_thread *thi)
 	current->rt_priority = 2;    /* more important than all other tasks */
 
 	while (get_t_state(thi) == RUNNING) {
-		drbd_thread_current_set_cpu(mdev, thi);
+		drbd_thread_current_set_cpu(thi);
 		if (test_and_clear_bit(SEND_PING, &mdev->tconn->flags)) {
 			if (!drbd_send_ping(mdev)) {
 				dev_err(DEV, "drbd_send_ping has failed\n");
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f5c27bb..16db1f4 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1634,7 +1634,7 @@ int drbd_worker(struct drbd_thread *thi)
 	sprintf(current->comm, "drbd%d_worker", mdev_to_minor(mdev));
 
 	while (get_t_state(thi) == RUNNING) {
-		drbd_thread_current_set_cpu(mdev, thi);
+		drbd_thread_current_set_cpu(thi);
 
 		if (down_trylock(&mdev->tconn->data.work.s)) {
 			mutex_lock(&mdev->tconn->data.mutex);
-- 
1.7.4.1

