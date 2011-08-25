Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1HYPKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32935 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1HYPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 099/118] drbd: Converted drbd_worker() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:35 +0200
Message-Id: <1314284934-17999-100-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c |   97 ++++++++++++++++++++------------------
 1 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 6f70962..c9b10d6 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1624,35 +1624,53 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 	drbd_state_unlock(mdev);
 }
 
+static int _worker_dying(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+
+	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
+	/* _drbd_set_state only uses stop_nowait.
+	 * wait here for the exiting receiver. */
+	drbd_thread_stop(&mdev->tconn->receiver);
+	drbd_mdev_cleanup(mdev);
+
+	clear_bit(DEVICE_DYING, &mdev->flags);
+	clear_bit(CONFIG_PENDING, &mdev->flags);
+	wake_up(&mdev->state_wait);
+
+	return 0;
+}
+
 int drbd_worker(struct drbd_thread *thi)
 {
-	struct drbd_conf *mdev = thi->mdev;
+	struct drbd_tconn *tconn = thi->mdev->tconn;
 	struct drbd_work *w = NULL;
 	LIST_HEAD(work_list);
-	int intr = 0, i;
+	int intr = 0;
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
-		if (down_trylock(&mdev->tconn->data.work.s)) {
-			mutex_lock(&mdev->tconn->data.mutex);
-			if (mdev->tconn->data.socket && !mdev->tconn->net_conf->no_cork)
-				drbd_tcp_uncork(mdev->tconn->data.socket);
-			mutex_unlock(&mdev->tconn->data.mutex);
+		if (down_trylock(&tconn->data.work.s)) {
+			mutex_lock(&tconn->data.mutex);
+			if (tconn->data.socket && !tconn->net_conf->no_cork)
+				drbd_tcp_uncork(tconn->data.socket);
+			mutex_unlock(&tconn->data.mutex);
 
-			intr = down_interruptible(&mdev->tconn->data.work.s);
+			intr = down_interruptible(&tconn->data.work.s);
 
-			mutex_lock(&mdev->tconn->data.mutex);
-			if (mdev->tconn->data.socket  && !mdev->tconn->net_conf->no_cork)
-				drbd_tcp_cork(mdev->tconn->data.socket);
-			mutex_unlock(&mdev->tconn->data.mutex);
+			mutex_lock(&tconn->data.mutex);
+			if (tconn->data.socket  && !tconn->net_conf->no_cork)
+				drbd_tcp_cork(tconn->data.socket);
+			mutex_unlock(&tconn->data.mutex);
 		}
 
 		if (intr) {
-			D_ASSERT(intr == -EINTR);
 			flush_signals(current);
-			if (!expect(get_t_state(thi) != RUNNING))
+			if (get_t_state(thi) == RUNNING) {
+				conn_warn(tconn, "Worker got an unexpected signal\n");
 				continue;
+			}
 			break;
 		}
 
@@ -1663,8 +1681,8 @@ int drbd_worker(struct drbd_thread *thi)
 		   this...   */
 
 		w = NULL;
-		spin_lock_irq(&mdev->tconn->data.work.q_lock);
-		if (!expect(!list_empty(&mdev->tconn->data.work.q))) {
+		spin_lock_irq(&tconn->data.work.q_lock);
+		if (list_empty(&tconn->data.work.q)) {
 			/* something terribly wrong in our logic.
 			 * we were able to down() the semaphore,
 			 * but the list is empty... doh.
@@ -1676,57 +1694,44 @@ int drbd_worker(struct drbd_thread *thi)
 			 *
 			 * I'll try to get away just starting over this loop.
 			 */
-			spin_unlock_irq(&mdev->tconn->data.work.q_lock);
+			conn_warn(tconn, "Work list unexpectedly empty\n");
+			spin_unlock_irq(&tconn->data.work.q_lock);
 			continue;
 		}
-		w = list_entry(mdev->tconn->data.work.q.next, struct drbd_work, list);
+		w = list_entry(tconn->data.work.q.next, struct drbd_work, list);
 		list_del_init(&w->list);
-		spin_unlock_irq(&mdev->tconn->data.work.q_lock);
+		spin_unlock_irq(&tconn->data.work.q_lock);
 
-		if (!w->cb(mdev, w, mdev->state.conn < C_CONNECTED)) {
+		if (!w->cb(w->mdev, w, tconn->volume0->state.conn < C_CONNECTED)) {
 			/* dev_warn(DEV, "worker: a callback failed! \n"); */
-			if (mdev->state.conn >= C_CONNECTED)
-				drbd_force_state(mdev,
-						NS(conn, C_NETWORK_FAILURE));
+			if (tconn->volume0->state.conn >= C_CONNECTED)
+				drbd_force_state(tconn->volume0,
+						 NS(conn, C_NETWORK_FAILURE));
 		}
 	}
-	D_ASSERT(test_bit(DEVICE_DYING, &mdev->flags));
-	D_ASSERT(test_bit(CONFIG_PENDING, &mdev->flags));
 
-	spin_lock_irq(&mdev->tconn->data.work.q_lock);
-	i = 0;
-	while (!list_empty(&mdev->tconn->data.work.q)) {
-		list_splice_init(&mdev->tconn->data.work.q, &work_list);
-		spin_unlock_irq(&mdev->tconn->data.work.q_lock);
+	spin_lock_irq(&tconn->data.work.q_lock);
+	while (!list_empty(&tconn->data.work.q)) {
+		list_splice_init(&tconn->data.work.q, &work_list);
+		spin_unlock_irq(&tconn->data.work.q_lock);
 
 		while (!list_empty(&work_list)) {
 			w = list_entry(work_list.next, struct drbd_work, list);
 			list_del_init(&w->list);
-			w->cb(mdev, w, 1);
-			i++; /* dead debugging code */
+			w->cb(w->mdev, w, 1);
 		}
 
-		spin_lock_irq(&mdev->tconn->data.work.q_lock);
+		spin_lock_irq(&tconn->data.work.q_lock);
 	}
-	sema_init(&mdev->tconn->data.work.s, 0);
+	sema_init(&tconn->data.work.s, 0);
 	/* DANGEROUS race: if someone did queue his work within the spinlock,
 	 * but up() ed outside the spinlock, we could get an up() on the
 	 * semaphore without corresponding list entry.
 	 * So don't do that.
 	 */
-	spin_unlock_irq(&mdev->tconn->data.work.q_lock);
+	spin_unlock_irq(&tconn->data.work.q_lock);
 
-	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
-	/* _drbd_set_state only uses stop_nowait.
-	 * wait here for the exiting receiver. */
-	drbd_thread_stop(&mdev->tconn->receiver);
-	drbd_mdev_cleanup(mdev);
-
-	dev_info(DEV, "worker terminated\n");
-
-	clear_bit(DEVICE_DYING, &mdev->flags);
-	clear_bit(CONFIG_PENDING, &mdev->flags);
-	wake_up(&mdev->state_wait);
+	idr_for_each(&tconn->volumes, _worker_dying, NULL);
 
 	return 0;
 }
-- 
1.7.4.1

