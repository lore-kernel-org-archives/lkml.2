Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1HaPMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:12:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59966 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab1HaPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/16] drbd: Converted the transfer log from mdev to tconn
Date: Wed, 31 Aug 2011 17:11:04 +0200
Message-Id: <1314803468-1201-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    6 +-
 drivers/block/drbd/drbd_main.c     |  125 +++++++++++++++++++-----------------
 drivers/block/drbd/drbd_nl.c       |    4 +-
 drivers/block/drbd/drbd_receiver.c |    6 +-
 drivers/block/drbd/drbd_req.c      |    2 +-
 drivers/block/drbd/drbd_req.h      |    2 +-
 drivers/block/drbd/drbd_state.c    |    6 +-
 7 files changed, 79 insertions(+), 72 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 004419e..fe3c2d2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1173,10 +1173,10 @@ extern void drbd_calc_cpu_mask(struct drbd_tconn *tconn);
 #define drbd_calc_cpu_mask(A) ({})
 #endif
 extern void drbd_free_resources(struct drbd_conf *mdev);
-extern void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
+extern void tl_release(struct drbd_tconn *, unsigned int barrier_nr,
 		       unsigned int set_size);
-extern void tl_clear(struct drbd_conf *mdev);
-extern void _tl_add_barrier(struct drbd_conf *, struct drbd_tl_epoch *);
+extern void tl_clear(struct drbd_tconn *);
+extern void _tl_add_barrier(struct drbd_tconn *, struct drbd_tl_epoch *);
 extern void drbd_free_sock(struct drbd_tconn *tconn);
 extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 		     void *buf, size_t size, unsigned msg_flags);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index eb51650..860ed18 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -180,7 +180,7 @@ int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins)
  * Each &struct drbd_tl_epoch has a circular double linked list of requests
  * attached.
  */
-static int tl_init(struct drbd_conf *mdev)
+static int tl_init(struct drbd_tconn *tconn)
 {
 	struct drbd_tl_epoch *b;
 
@@ -195,21 +195,23 @@ static int tl_init(struct drbd_conf *mdev)
 	b->n_writes = 0;
 	b->w.cb = NULL; /* if this is != NULL, we need to dec_ap_pending in tl_clear */
 
-	mdev->tconn->oldest_tle = b;
-	mdev->tconn->newest_tle = b;
-	INIT_LIST_HEAD(&mdev->tconn->out_of_sequence_requests);
+	tconn->oldest_tle = b;
+	tconn->newest_tle = b;
+	INIT_LIST_HEAD(&tconn->out_of_sequence_requests);
 
 	return 1;
 }
 
-static void tl_cleanup(struct drbd_conf *mdev)
+static void tl_cleanup(struct drbd_tconn *tconn)
 {
-	D_ASSERT(mdev->tconn->oldest_tle == mdev->tconn->newest_tle);
-	D_ASSERT(list_empty(&mdev->tconn->out_of_sequence_requests));
-	kfree(mdev->tconn->oldest_tle);
-	mdev->tconn->oldest_tle = NULL;
-	kfree(mdev->tconn->unused_spare_tle);
-	mdev->tconn->unused_spare_tle = NULL;
+	if (tconn->oldest_tle != tconn->newest_tle)
+		conn_err(tconn, "ASSERT FAILED: oldest_tle == newest_tle\n");
+	if (!list_empty(&tconn->out_of_sequence_requests))
+		conn_err(tconn, "ASSERT FAILED: list_mepty(out_of_sequence_requests)\n");
+	kfree(tconn->oldest_tle);
+	tconn->oldest_tle = NULL;
+	kfree(tconn->unused_spare_tle);
+	tconn->unused_spare_tle = NULL;
 }
 
 /**
@@ -219,7 +221,7 @@ static void tl_cleanup(struct drbd_conf *mdev)
  *
  * The caller must hold the req_lock.
  */
-void _tl_add_barrier(struct drbd_conf *mdev, struct drbd_tl_epoch *new)
+void _tl_add_barrier(struct drbd_tconn *tconn, struct drbd_tl_epoch *new)
 {
 	struct drbd_tl_epoch *newest_before;
 
@@ -229,13 +231,13 @@ void _tl_add_barrier(struct drbd_conf *mdev, struct drbd_tl_epoch *new)
 	new->next = NULL;
 	new->n_writes = 0;
 
-	newest_before = mdev->tconn->newest_tle;
+	newest_before = tconn->newest_tle;
 	/* never send a barrier number == 0, because that is special-cased
 	 * when using TCQ for our write ordering code */
 	new->br_number = (newest_before->br_number+1) ?: 1;
-	if (mdev->tconn->newest_tle != new) {
-		mdev->tconn->newest_tle->next = new;
-		mdev->tconn->newest_tle = new;
+	if (tconn->newest_tle != new) {
+		tconn->newest_tle->next = new;
+		tconn->newest_tle = new;
 	}
 }
 
@@ -249,31 +251,32 @@ void _tl_add_barrier(struct drbd_conf *mdev, struct drbd_tl_epoch *new)
  * &struct drbd_tl_epoch objects this function will cause a termination
  * of the connection.
  */
-void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
-		       unsigned int set_size)
+void tl_release(struct drbd_tconn *tconn, unsigned int barrier_nr,
+		unsigned int set_size)
 {
+	struct drbd_conf *mdev;
 	struct drbd_tl_epoch *b, *nob; /* next old barrier */
 	struct list_head *le, *tle;
 	struct drbd_request *r;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&tconn->req_lock);
 
-	b = mdev->tconn->oldest_tle;
+	b = tconn->oldest_tle;
 
 	/* first some paranoia code */
 	if (b == NULL) {
-		dev_err(DEV, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
-			barrier_nr);
+		conn_err(tconn, "BAD! BarrierAck #%u received, but no epoch in tl!?\n",
+			 barrier_nr);
 		goto bail;
 	}
 	if (b->br_number != barrier_nr) {
-		dev_err(DEV, "BAD! BarrierAck #%u received, expected #%u!\n",
-			barrier_nr, b->br_number);
+		conn_err(tconn, "BAD! BarrierAck #%u received, expected #%u!\n",
+			 barrier_nr, b->br_number);
 		goto bail;
 	}
 	if (b->n_writes != set_size) {
-		dev_err(DEV, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
-			barrier_nr, set_size, b->n_writes);
+		conn_err(tconn, "BAD! BarrierAck #%u received with n_writes=%u, expected n_writes=%u!\n",
+			 barrier_nr, set_size, b->n_writes);
 		goto bail;
 	}
 
@@ -296,28 +299,29 @@ void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 	   _req_mod(, BARRIER_ACKED) above.
 	   */
 	list_del_init(&b->requests);
+	mdev = b->w.mdev;
 
 	nob = b->next;
 	if (test_and_clear_bit(CREATE_BARRIER, &mdev->flags)) {
-		_tl_add_barrier(mdev, b);
+		_tl_add_barrier(tconn, b);
 		if (nob)
-			mdev->tconn->oldest_tle = nob;
+			tconn->oldest_tle = nob;
 		/* if nob == NULL b was the only barrier, and becomes the new
-		   barrier. Therefore mdev->tconn->oldest_tle points already to b */
+		   barrier. Therefore tconn->oldest_tle points already to b */
 	} else {
 		D_ASSERT(nob != NULL);
-		mdev->tconn->oldest_tle = nob;
+		tconn->oldest_tle = nob;
 		kfree(b);
 	}
 
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&tconn->req_lock);
 	dec_ap_pending(mdev);
 
 	return;
 
 bail:
-	spin_unlock_irq(&mdev->tconn->req_lock);
-	drbd_force_state(mdev, NS(conn, C_PROTOCOL_ERROR));
+	spin_unlock_irq(&tconn->req_lock);
+	conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
 
@@ -329,15 +333,15 @@ bail:
  * @what might be one of CONNECTION_LOST_WHILE_PENDING, RESEND, FAIL_FROZEN_DISK_IO,
  * RESTART_FROZEN_DISK_IO.
  */
-void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
+void _tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
 {
 	struct drbd_tl_epoch *b, *tmp, **pn;
 	struct list_head *le, *tle, carry_reads;
 	struct drbd_request *req;
 	int rv, n_writes, n_reads;
 
-	b = mdev->tconn->oldest_tle;
-	pn = &mdev->tconn->oldest_tle;
+	b = tconn->oldest_tle;
+	pn = &tconn->oldest_tle;
 	while (b) {
 		n_writes = 0;
 		n_reads = 0;
@@ -356,11 +360,11 @@ void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 				b->n_writes = n_writes;
 				if (b->w.cb == NULL) {
 					b->w.cb = w_send_barrier;
-					inc_ap_pending(mdev);
-					set_bit(CREATE_BARRIER, &mdev->flags);
+					inc_ap_pending(b->w.mdev);
+					set_bit(CREATE_BARRIER, &b->w.mdev->flags);
 				}
 
-				drbd_queue_work(&mdev->tconn->data.work, &b->w);
+				drbd_queue_work(&tconn->data.work, &b->w);
 			}
 			pn = &b->next;
 		} else {
@@ -374,11 +378,12 @@ void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 			 * the newest barrier may not have been queued yet,
 			 * in which case w.cb is still NULL. */
 			if (b->w.cb != NULL)
-				dec_ap_pending(mdev);
+				dec_ap_pending(b->w.mdev);
 
-			if (b == mdev->tconn->newest_tle) {
+			if (b == tconn->newest_tle) {
 				/* recycle, but reinit! */
-				D_ASSERT(tmp == NULL);
+				if (tmp != NULL)
+					conn_err(tconn, "ASSERT FAILED tmp == NULL");
 				INIT_LIST_HEAD(&b->requests);
 				list_splice(&carry_reads, &b->requests);
 				INIT_LIST_HEAD(&b->w.list);
@@ -406,20 +411,23 @@ void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
  * by the requests on the transfer gets marked as our of sync. Called from the
  * receiver thread and the worker thread.
  */
-void tl_clear(struct drbd_conf *mdev)
+void tl_clear(struct drbd_tconn *tconn)
 {
+	struct drbd_conf *mdev;
 	struct list_head *le, *tle;
 	struct drbd_request *r;
+	int minor;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&tconn->req_lock);
 
-	_tl_restart(mdev, CONNECTION_LOST_WHILE_PENDING);
+	_tl_restart(tconn, CONNECTION_LOST_WHILE_PENDING);
 
 	/* we expect this list to be empty. */
-	D_ASSERT(list_empty(&mdev->tconn->out_of_sequence_requests));
+	if (!list_empty(&tconn->out_of_sequence_requests))
+		conn_err(tconn, "ASSERT FAILED list_empty(&out_of_sequence_requests)\n");
 
 	/* but just in case, clean it up anyways! */
-	list_for_each_safe(le, tle, &mdev->tconn->out_of_sequence_requests) {
+	list_for_each_safe(le, tle, &tconn->out_of_sequence_requests) {
 		r = list_entry(le, struct drbd_request, tl_requests);
 		/* It would be nice to complete outside of spinlock.
 		 * But this is easier for now. */
@@ -427,16 +435,17 @@ void tl_clear(struct drbd_conf *mdev)
 	}
 
 	/* ensure bit indicating barrier is required is clear */
-	clear_bit(CREATE_BARRIER, &mdev->flags);
+	idr_for_each_entry(&tconn->volumes, mdev, minor)
+		clear_bit(CREATE_BARRIER, &mdev->flags);
 
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&tconn->req_lock);
 }
 
-void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
+void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
 {
-	spin_lock_irq(&mdev->tconn->req_lock);
-	_tl_restart(mdev, what);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&tconn->req_lock);
+	_tl_restart(tconn, what);
+	spin_unlock_irq(&tconn->req_lock);
 }
 
 static int drbd_thread_setup(void *arg)
@@ -2199,6 +2208,9 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	if (!tconn->name)
 		goto fail;
 
+	if (!tl_init(tconn))
+		goto fail;
+
 	tconn->cstate = C_STANDALONE;
 	mutex_init(&tconn->cstate_mutex);
 	spin_lock_init(&tconn->req_lock);
@@ -2224,6 +2236,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	return tconn;
 
 fail:
+	tl_cleanup(tconn);
 	kfree(tconn->name);
 	kfree(tconn);
 
@@ -2316,9 +2329,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 
 	if (drbd_bm_init(mdev))
 		goto out_no_bitmap;
-	/* no need to lock access, we are still initializing this minor device. */
-	if (!tl_init(mdev))
-		goto out_no_tl;
 	mdev->read_requests = RB_ROOT;
 	mdev->write_requests = RB_ROOT;
 
@@ -2334,8 +2344,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 /* out_whatever_else:
 	kfree(mdev->current_epoch); */
 out_no_epoch:
-	tl_cleanup(mdev);
-out_no_tl:
 	drbd_bm_cleanup(mdev);
 out_no_bitmap:
 	__free_page(mdev->md_io_page);
@@ -2357,7 +2365,6 @@ out_no_tconn:
 void drbd_free_mdev(struct drbd_conf *mdev)
 {
 	kfree(mdev->current_epoch);
-	tl_cleanup(mdev);
 	if (mdev->bitmap) /* should no longer be there. */
 		drbd_bm_cleanup(mdev);
 	__free_page(mdev->md_io_page);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 33159e4..b141f89 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1996,9 +1996,9 @@ static int drbd_nl_resume_io(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	reply->ret_code = drbd_request_state(mdev, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
 	if (reply->ret_code == SS_SUCCESS) {
 		if (mdev->state.conn < C_CONNECTED)
-			tl_clear(mdev);
+			tl_clear(mdev->tconn);
 		if (mdev->state.disk == D_DISKLESS || mdev->state.disk == D_FAILED)
-			tl_restart(mdev, FAIL_FROZEN_DISK_IO);
+			tl_restart(mdev->tconn, FAIL_FROZEN_DISK_IO);
 	}
 	drbd_resume_io(mdev);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b58dc16..e607503 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3469,7 +3469,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 		   for temporal network outages! */
 		spin_unlock_irq(&mdev->tconn->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
-		tl_clear(mdev);
+		tl_clear(mdev->tconn);
 		drbd_uuid_new_current(mdev);
 		clear_bit(NEW_CUR_UUID, &mdev->flags);
 		drbd_force_state(mdev, NS2(conn, C_PROTOCOL_ERROR, susp, 0));
@@ -4028,7 +4028,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 	mdev->p_uuid = NULL;
 
 	if (!is_susp(mdev->state))
-		tl_clear(mdev);
+		tl_clear(mdev->tconn);
 
 	drbd_md_sync(mdev);
 
@@ -4588,7 +4588,7 @@ static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_barrier_ack *p = &mdev->tconn->meta.rbuf.barrier_ack;
 
-	tl_release(mdev, p->barrier, be32_to_cpu(p->set_size));
+	tl_release(mdev->tconn, p->barrier, be32_to_cpu(p->set_size));
 
 	if (mdev->state.conn == C_AHEAD &&
 	    atomic_read(&mdev->ap_in_flight) == 0 &&
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index cfa5fba..fa799e3 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -885,7 +885,7 @@ allocate_barrier:
 	 * barrier packet, this request is queued within the same spinlock. */
 	if ((remote || send_oos) && mdev->tconn->unused_spare_tle &&
 	    test_and_clear_bit(CREATE_BARRIER, &mdev->flags)) {
-		_tl_add_barrier(mdev, mdev->tconn->unused_spare_tle);
+		_tl_add_barrier(mdev->tconn, mdev->tconn->unused_spare_tle);
 		mdev->tconn->unused_spare_tle = NULL;
 	} else {
 		D_ASSERT(!(remote && rw == WRITE &&
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 0b3cd41..7cfcf3d 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -254,7 +254,7 @@ extern int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 extern void complete_master_bio(struct drbd_conf *mdev,
 		struct bio_and_error *m);
 extern void request_timer_fn(unsigned long data);
-extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
+extern void tl_restart(struct drbd_tconn *, enum drbd_req_event what);
 
 /* use this if you don't want to deal with calling complete_master_bio()
  * outside the spinlock, e.g. when walking some list on cleanup. */
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index febefcc..100d48b 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -37,7 +37,7 @@ struct after_state_chg_work {
 	struct completion *done;
 };
 
-extern void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
+extern void _tl_restart(struct drbd_tconn *, enum drbd_req_event what);
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
@@ -1009,7 +1009,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	if (ns.susp_fen) {
 		/* case1: The outdate peer handler is successful: */
 		if (os.pdsk > D_OUTDATED  && ns.pdsk <= D_OUTDATED) {
-			tl_clear(mdev);
+			tl_clear(mdev->tconn);
 			if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
 				drbd_uuid_new_current(mdev);
 				clear_bit(NEW_CUR_UUID, &mdev->flags);
@@ -1028,7 +1028,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 
 	if (what != NOTHING) {
 		spin_lock_irq(&mdev->tconn->req_lock);
-		_tl_restart(mdev, what);
+		_tl_restart(mdev->tconn, what);
 		nsm.i &= mdev->state.i;
 		_drbd_set_state(mdev, nsm, CS_VERBOSE, NULL);
 		spin_unlock_irq(&mdev->tconn->req_lock);
-- 
1.7.4.1

