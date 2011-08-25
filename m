Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1HYPbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:31:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1HYPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 032/118] drbd: moved receiver, worker and asender from mdev to tconn
Date: Thu, 25 Aug 2011 17:07:28 +0200
Message-Id: <1314284934-17999-33-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch mostly:
sed -i -e 's/mdev->receiver/mdev->tconn->receiver/g' \
       -e 's/mdev->worker/mdev->tconn->worker/g' \
       -e 's/mdev->asender/mdev->tconn->asender/g' \
       *.[ch]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c   |   24 +++++++++---------
 drivers/block/drbd/drbd_int.h      |    9 ++++---
 drivers/block/drbd/drbd_main.c     |   44 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_nl.c       |   10 ++++----
 drivers/block/drbd/drbd_receiver.c |   14 +++++-----
 drivers/block/drbd/drbd_worker.c   |    4 +-
 6 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index c756b4d..4da4c32 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -119,13 +119,13 @@ static void __bm_print_lock_info(struct drbd_conf *mdev, const char *func)
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-	    current == mdev->receiver.task ? "receiver" :
-	    current == mdev->asender.task  ? "asender"  :
-	    current == mdev->worker.task   ? "worker"   : current->comm,
+	    current == mdev->tconn->receiver.task ? "receiver" :
+	    current == mdev->tconn->asender.task  ? "asender"  :
+	    current == mdev->tconn->worker.task   ? "worker"   : current->comm,
 	    func, b->bm_why ?: "?",
-	    b->bm_task == mdev->receiver.task ? "receiver" :
-	    b->bm_task == mdev->asender.task  ? "asender"  :
-	    b->bm_task == mdev->worker.task   ? "worker"   : "?");
+	    b->bm_task == mdev->tconn->receiver.task ? "receiver" :
+	    b->bm_task == mdev->tconn->asender.task  ? "asender"  :
+	    b->bm_task == mdev->tconn->worker.task   ? "worker"   : "?");
 }
 
 void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
@@ -142,13 +142,13 @@ void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-		    current == mdev->receiver.task ? "receiver" :
-		    current == mdev->asender.task  ? "asender"  :
-		    current == mdev->worker.task   ? "worker"   : current->comm,
+		    current == mdev->tconn->receiver.task ? "receiver" :
+		    current == mdev->tconn->asender.task  ? "asender"  :
+		    current == mdev->tconn->worker.task   ? "worker"   : current->comm,
 		    why, b->bm_why ?: "?",
-		    b->bm_task == mdev->receiver.task ? "receiver" :
-		    b->bm_task == mdev->asender.task  ? "asender"  :
-		    b->bm_task == mdev->worker.task   ? "worker"   : "?");
+		    b->bm_task == mdev->tconn->receiver.task ? "receiver" :
+		    b->bm_task == mdev->tconn->asender.task  ? "asender"  :
+		    b->bm_task == mdev->tconn->worker.task   ? "worker"   : "?");
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 015ec05..6658dcb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -972,6 +972,10 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
 	struct drbd_socket meta;	/* ping/ack (metadata) packets */
+
+	struct drbd_thread receiver;
+	struct drbd_thread worker;
+	struct drbd_thread asender;
 };
 
 struct drbd_conf {
@@ -1068,9 +1072,6 @@ struct drbd_conf {
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
 
-	struct drbd_thread receiver;
-	struct drbd_thread worker;
-	struct drbd_thread asender;
 	struct drbd_bitmap *bitmap;
 	unsigned long bm_resync_fo; /* bit offset for drbd_bm_find_next */
 
@@ -2005,7 +2006,7 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 static inline void wake_asender(struct drbd_conf *mdev)
 {
 	if (test_bit(SIGNAL_ASENDER, &mdev->flags))
-		force_sig(DRBD_SIG, mdev->asender.task);
+		force_sig(DRBD_SIG, mdev->tconn->asender.task);
 }
 
 static inline void request_ping(struct drbd_conf *mdev)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 84e40fb..5d8a6e9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -613,7 +613,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
-		D_ASSERT(current != mdev->worker.task);
+		D_ASSERT(current != mdev->tconn->worker.task);
 		wait_for_completion(&done);
 	}
 
@@ -1229,16 +1229,16 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	/* Receiver should clean up itself */
 	if (os.conn != C_DISCONNECTING && ns.conn == C_DISCONNECTING)
-		drbd_thread_stop_nowait(&mdev->receiver);
+		drbd_thread_stop_nowait(&mdev->tconn->receiver);
 
 	/* Now the receiver finished cleaning up itself, it should die */
 	if (os.conn != C_STANDALONE && ns.conn == C_STANDALONE)
-		drbd_thread_stop_nowait(&mdev->receiver);
+		drbd_thread_stop_nowait(&mdev->tconn->receiver);
 
 	/* Upon network failure, we need to restart the receiver. */
 	if (os.conn > C_TEAR_DOWN &&
 	    ns.conn <= C_TEAR_DOWN && ns.conn >= C_TIMEOUT)
-		drbd_thread_restart_nowait(&mdev->receiver);
+		drbd_thread_restart_nowait(&mdev->tconn->receiver);
 
 	/* Resume AL writing if we get a connection */
 	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED)
@@ -1297,7 +1297,7 @@ int drbd_bitmap_io_from_worker(struct drbd_conf *mdev,
 {
 	int rv;
 
-	D_ASSERT(current == mdev->worker.task);
+	D_ASSERT(current == mdev->tconn->worker.task);
 
 	/* open coded non-blocking drbd_suspend_io(mdev); */
 	set_bit(SUSPEND_IO, &mdev->flags);
@@ -1598,7 +1598,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 
 	/* Upon network connection, we need to start the receiver */
 	if (os.conn == C_STANDALONE && ns.conn == C_UNCONNECTED)
-		drbd_thread_start(&mdev->receiver);
+		drbd_thread_start(&mdev->tconn->receiver);
 
 	/* Terminate worker thread if we are unconfigured - it will be
 	   restarted as needed... */
@@ -1609,7 +1609,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			resume_next_sg(mdev);
 		/* set in __drbd_set_state, unless CONFIG_PENDING was set */
 		if (test_bit(DEVICE_DYING, &mdev->flags))
-			drbd_thread_stop_nowait(&mdev->worker);
+			drbd_thread_stop_nowait(&mdev->tconn->worker);
 	}
 
 	drbd_md_sync(mdev);
@@ -1675,9 +1675,9 @@ int drbd_thread_start(struct drbd_thread *thi)
 	unsigned long flags;
 
 	const char *me =
-		thi == &mdev->receiver ? "receiver" :
-		thi == &mdev->asender  ? "asender"  :
-		thi == &mdev->worker   ? "worker"   : "NONSENSE";
+		thi == &mdev->tconn->receiver ? "receiver" :
+		thi == &mdev->tconn->asender  ? "asender"  :
+		thi == &mdev->tconn->worker   ? "worker"   : "NONSENSE";
 
 	/* is used from state engine doing drbd_thread_stop_nowait,
 	 * while holding the req lock irqsave */
@@ -1807,9 +1807,9 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 {
 	struct task_struct *p = current;
 	struct drbd_thread *thi =
-		p == mdev->asender.task  ? &mdev->asender  :
-		p == mdev->receiver.task ? &mdev->receiver :
-		p == mdev->worker.task   ? &mdev->worker   :
+		p == mdev->tconn->asender.task  ? &mdev->tconn->asender  :
+		p == mdev->tconn->receiver.task ? &mdev->tconn->receiver :
+		p == mdev->tconn->worker.task   ? &mdev->tconn->worker   :
 		NULL;
 	if (!expect(thi != NULL))
 		return;
@@ -2507,8 +2507,8 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 	/* long elapsed = (long)(jiffies - mdev->last_received); */
 
 	drop_it =   mdev->tconn->meta.socket == sock
-		|| !mdev->asender.task
-		|| get_t_state(&mdev->asender) != RUNNING
+		|| !mdev->tconn->asender.task
+		|| get_t_state(&mdev->tconn->asender) != RUNNING
 		|| mdev->state.conn < C_CONNECTED;
 
 	if (drop_it)
@@ -3034,9 +3034,9 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	init_waitqueue_head(&mdev->al_wait);
 	init_waitqueue_head(&mdev->seq_wait);
 
-	drbd_thread_init(mdev, &mdev->receiver, drbdd_init);
-	drbd_thread_init(mdev, &mdev->worker, drbd_worker);
-	drbd_thread_init(mdev, &mdev->asender, drbd_asender);
+	drbd_thread_init(mdev, &mdev->tconn->receiver, drbdd_init);
+	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker);
+	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender);
 
 	mdev->agreed_pro_version = PRO_VERSION_MAX;
 	mdev->write_ordering = WO_bdev_flush;
@@ -3048,9 +3048,9 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 void drbd_mdev_cleanup(struct drbd_conf *mdev)
 {
 	int i;
-	if (mdev->receiver.t_state != NONE)
+	if (mdev->tconn->receiver.t_state != NONE)
 		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
-				mdev->receiver.t_state);
+				mdev->tconn->receiver.t_state);
 
 	/* no need to lock it, I'm the only thread alive */
 	if (atomic_read(&mdev->current_epoch->epoch_size) !=  0)
@@ -4032,7 +4032,7 @@ void drbd_queue_bitmap_io(struct drbd_conf *mdev,
 			  void (*done)(struct drbd_conf *, int),
 			  char *why, enum bm_flag flags)
 {
-	D_ASSERT(current == mdev->worker.task);
+	D_ASSERT(current == mdev->tconn->worker.task);
 
 	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &mdev->flags));
 	D_ASSERT(!test_bit(BITMAP_IO, &mdev->flags));
@@ -4069,7 +4069,7 @@ int drbd_bitmap_io(struct drbd_conf *mdev, int (*io_fn)(struct drbd_conf *),
 {
 	int rv;
 
-	D_ASSERT(current != mdev->worker.task);
+	D_ASSERT(current != mdev->tconn->worker.task);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
 		drbd_suspend_io(mdev);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a936d61..59bb58c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -875,7 +875,7 @@ static void drbd_reconfig_start(struct drbd_conf *mdev)
 {
 	wait_event(mdev->state_wait, !test_and_set_bit(CONFIG_PENDING, &mdev->flags));
 	wait_event(mdev->state_wait, !test_bit(DEVICE_DYING, &mdev->flags));
-	drbd_thread_start(&mdev->worker);
+	drbd_thread_start(&mdev->tconn->worker);
 	drbd_flush_workqueue(mdev);
 }
 
@@ -889,7 +889,7 @@ static void drbd_reconfig_done(struct drbd_conf *mdev)
 	    mdev->state.conn == C_STANDALONE &&
 	    mdev->state.role == R_SECONDARY) {
 		set_bit(DEVICE_DYING, &mdev->flags);
-		drbd_thread_stop_nowait(&mdev->worker);
+		drbd_thread_stop_nowait(&mdev->tconn->worker);
 	} else
 		clear_bit(CONFIG_PENDING, &mdev->flags);
 	spin_unlock_irq(&mdev->req_lock);
@@ -1887,9 +1887,9 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	if (!cpumask_equal(mdev->cpu_mask, new_cpu_mask)) {
 		cpumask_copy(mdev->cpu_mask, new_cpu_mask);
 		drbd_calc_cpu_mask(mdev);
-		mdev->receiver.reset_cpu_mask = 1;
-		mdev->asender.reset_cpu_mask = 1;
-		mdev->worker.reset_cpu_mask = 1;
+		mdev->tconn->receiver.reset_cpu_mask = 1;
+		mdev->tconn->asender.reset_cpu_mask = 1;
+		mdev->tconn->worker.reset_cpu_mask = 1;
 	}
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 2636bcc..e9f670c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -833,7 +833,7 @@ retry:
 		if (signal_pending(current)) {
 			flush_signals(current);
 			smp_rmb();
-			if (get_t_state(&mdev->receiver) == EXITING)
+			if (get_t_state(&mdev->tconn->receiver) == EXITING)
 				goto out_release_sockets;
 		}
 
@@ -874,7 +874,7 @@ retry:
 	mdev->tconn->meta.socket = msock;
 	mdev->last_received = jiffies;
 
-	D_ASSERT(mdev->asender.task == NULL);
+	D_ASSERT(mdev->tconn->asender.task == NULL);
 
 	h = drbd_do_handshake(mdev);
 	if (h <= 0)
@@ -901,7 +901,7 @@ retry:
 	atomic_set(&mdev->packet_seq, 0);
 	mdev->peer_seq = 0;
 
-	drbd_thread_start(&mdev->asender);
+	drbd_thread_start(&mdev->tconn->asender);
 
 	if (drbd_send_protocol(mdev) == -1)
 		return -1;
@@ -3704,7 +3704,7 @@ static void drbdd(struct drbd_conf *mdev)
 	size_t shs; /* sub header size */
 	int rv;
 
-	while (get_t_state(&mdev->receiver) == RUNNING) {
+	while (get_t_state(&mdev->tconn->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 		if (!drbd_recv_header(mdev, &cmd, &packet_size))
 			goto err_out;
@@ -3768,7 +3768,7 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 		return;
 
 	/* asender does not clean up anything. it must not interfere, either */
-	drbd_thread_stop(&mdev->asender);
+	drbd_thread_stop(&mdev->tconn->asender);
 	drbd_free_sock(mdev);
 
 	/* wait for current activity to cease. */
@@ -3891,7 +3891,7 @@ static void drbd_disconnect(struct drbd_conf *mdev)
  */
 static int drbd_send_handshake(struct drbd_conf *mdev)
 {
-	/* ASSERT current == mdev->receiver ... */
+	/* ASSERT current == mdev->tconn->receiver ... */
 	struct p_handshake *p = &mdev->tconn->data.sbuf.handshake;
 	int ok;
 
@@ -3923,7 +3923,7 @@ static int drbd_send_handshake(struct drbd_conf *mdev)
  */
 static int drbd_do_handshake(struct drbd_conf *mdev)
 {
-	/* ASSERT current == mdev->receiver ... */
+	/* ASSERT current == mdev->tconn->receiver ... */
 	struct p_handshake *p = &mdev->tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	unsigned int length;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 9b1e2ba..1ca7856 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1705,8 +1705,8 @@ int drbd_worker(struct drbd_thread *thi)
 
 	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
 	/* _drbd_set_state only uses stop_nowait.
-	 * wait here for the EXITING receiver. */
-	drbd_thread_stop(&mdev->receiver);
+	 * wait here for the exiting receiver. */
+	drbd_thread_stop(&mdev->tconn->receiver);
 	drbd_mdev_cleanup(mdev);
 
 	dev_info(DEV, "worker terminated\n");
-- 
1.7.4.1

