Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1HYPJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32967 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1HYPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 034/118] drbd: moved req_lock and transfer log from mdev to tconn
Date: Thu, 25 Aug 2011 17:07:30 +0200
Message-Id: <1314284934-17999-35-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sed -i \
       -e 's/mdev->req_lock/mdev->tconn->req_lock/g' \
       -e 's/mdev->unused_spare_tle/mdev->tconn->unused_spare_tle/g' \
       -e 's/mdev->newest_tle/mdev->tconn->newest_tle/g' \
       -e 's/mdev->oldest_tle/mdev->tconn->oldest_tle/g' \
       -e 's/mdev->out_of_sequence_requests/mdev->tconn->out_of_sequence_requests/g' \
       *.[ch]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   20 ++++----
 drivers/block/drbd/drbd_main.c     |  100 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_nl.c       |   34 ++++++------
 drivers/block/drbd/drbd_receiver.c |   96 +++++++++++++++++-----------------
 drivers/block/drbd/drbd_req.c      |   48 +++++++++---------
 drivers/block/drbd/drbd_req.h      |    4 +-
 drivers/block/drbd/drbd_worker.c   |   38 +++++++-------
 7 files changed, 170 insertions(+), 170 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ffc8211..0e9debe 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -976,6 +976,12 @@ struct drbd_tconn {			/* is a resource from the config file */
 	unsigned long last_received;	/* in jiffies, either socket */
 	unsigned int ko_count;
 
+	spinlock_t req_lock;
+	struct drbd_tl_epoch *unused_spare_tle; /* for pre-allocation */
+	struct drbd_tl_epoch *newest_tle;
+	struct drbd_tl_epoch *oldest_tle;
+	struct list_head out_of_sequence_requests;
+
 	struct drbd_thread receiver;
 	struct drbd_thread worker;
 	struct drbd_thread asender;
@@ -1031,12 +1037,6 @@ struct drbd_conf {
 	atomic_t unacked_cnt;	 /* Need to send replys for */
 	atomic_t local_cnt;	 /* Waiting for local completion */
 
-	spinlock_t req_lock;
-	struct drbd_tl_epoch *unused_spare_tle; /* for pre-allocation */
-	struct drbd_tl_epoch *newest_tle;
-	struct drbd_tl_epoch *oldest_tle;
-	struct list_head out_of_sequence_requests;
-
 	/* Interval tree of pending local write requests */
 	struct rb_root read_requests;
 	struct rb_root write_requests;
@@ -1868,9 +1868,9 @@ static inline void drbd_chk_io_error_(struct drbd_conf *mdev,
 {
 	if (error) {
 		unsigned long flags;
-		spin_lock_irqsave(&mdev->req_lock, flags);
+		spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 		__drbd_chk_io_error_(mdev, forcedetach, where);
-		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 	}
 }
 
@@ -2366,11 +2366,11 @@ static inline bool inc_ap_bio_cond(struct drbd_conf *mdev, int count)
 {
 	bool rv = false;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	rv = may_inc_ap_bio(mdev);
 	if (rv)
 		atomic_add(count, &mdev->ap_bio_cnt);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e06ca4a..c063cd5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -185,7 +185,7 @@ int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins)
  * DOC: The transfer log
  *
  * The transfer log is a single linked list of &struct drbd_tl_epoch objects.
- * mdev->newest_tle points to the head, mdev->oldest_tle points to the tail
+ * mdev->tconn->newest_tle points to the head, mdev->tconn->oldest_tle points to the tail
  * of the list. There is always at least one &struct drbd_tl_epoch object.
  *
  * Each &struct drbd_tl_epoch has a circular double linked list of requests
@@ -206,21 +206,21 @@ static int tl_init(struct drbd_conf *mdev)
 	b->n_writes = 0;
 	b->w.cb = NULL; /* if this is != NULL, we need to dec_ap_pending in tl_clear */
 
-	mdev->oldest_tle = b;
-	mdev->newest_tle = b;
-	INIT_LIST_HEAD(&mdev->out_of_sequence_requests);
+	mdev->tconn->oldest_tle = b;
+	mdev->tconn->newest_tle = b;
+	INIT_LIST_HEAD(&mdev->tconn->out_of_sequence_requests);
 
 	return 1;
 }
 
 static void tl_cleanup(struct drbd_conf *mdev)
 {
-	D_ASSERT(mdev->oldest_tle == mdev->newest_tle);
-	D_ASSERT(list_empty(&mdev->out_of_sequence_requests));
-	kfree(mdev->oldest_tle);
-	mdev->oldest_tle = NULL;
-	kfree(mdev->unused_spare_tle);
-	mdev->unused_spare_tle = NULL;
+	D_ASSERT(mdev->tconn->oldest_tle == mdev->tconn->newest_tle);
+	D_ASSERT(list_empty(&mdev->tconn->out_of_sequence_requests));
+	kfree(mdev->tconn->oldest_tle);
+	mdev->tconn->oldest_tle = NULL;
+	kfree(mdev->tconn->unused_spare_tle);
+	mdev->tconn->unused_spare_tle = NULL;
 }
 
 /**
@@ -240,13 +240,13 @@ void _tl_add_barrier(struct drbd_conf *mdev, struct drbd_tl_epoch *new)
 	new->next = NULL;
 	new->n_writes = 0;
 
-	newest_before = mdev->newest_tle;
+	newest_before = mdev->tconn->newest_tle;
 	/* never send a barrier number == 0, because that is special-cased
 	 * when using TCQ for our write ordering code */
 	new->br_number = (newest_before->br_number+1) ?: 1;
-	if (mdev->newest_tle != new) {
-		mdev->newest_tle->next = new;
-		mdev->newest_tle = new;
+	if (mdev->tconn->newest_tle != new) {
+		mdev->tconn->newest_tle->next = new;
+		mdev->tconn->newest_tle = new;
 	}
 }
 
@@ -267,9 +267,9 @@ void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 	struct list_head *le, *tle;
 	struct drbd_request *r;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 
-	b = mdev->oldest_tle;
+	b = mdev->tconn->oldest_tle;
 
 	/* first some paranoia code */
 	if (b == NULL) {
@@ -312,22 +312,22 @@ void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 	if (test_and_clear_bit(CREATE_BARRIER, &mdev->flags)) {
 		_tl_add_barrier(mdev, b);
 		if (nob)
-			mdev->oldest_tle = nob;
+			mdev->tconn->oldest_tle = nob;
 		/* if nob == NULL b was the only barrier, and becomes the new
-		   barrier. Therefore mdev->oldest_tle points already to b */
+		   barrier. Therefore mdev->tconn->oldest_tle points already to b */
 	} else {
 		D_ASSERT(nob != NULL);
-		mdev->oldest_tle = nob;
+		mdev->tconn->oldest_tle = nob;
 		kfree(b);
 	}
 
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	dec_ap_pending(mdev);
 
 	return;
 
 bail:
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	drbd_force_state(mdev, NS(conn, C_PROTOCOL_ERROR));
 }
 
@@ -347,8 +347,8 @@ static void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 	struct drbd_request *req;
 	int rv, n_writes, n_reads;
 
-	b = mdev->oldest_tle;
-	pn = &mdev->oldest_tle;
+	b = mdev->tconn->oldest_tle;
+	pn = &mdev->tconn->oldest_tle;
 	while (b) {
 		n_writes = 0;
 		n_reads = 0;
@@ -387,7 +387,7 @@ static void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 			if (b->w.cb != NULL)
 				dec_ap_pending(mdev);
 
-			if (b == mdev->newest_tle) {
+			if (b == mdev->tconn->newest_tle) {
 				/* recycle, but reinit! */
 				D_ASSERT(tmp == NULL);
 				INIT_LIST_HEAD(&b->requests);
@@ -422,15 +422,15 @@ void tl_clear(struct drbd_conf *mdev)
 	struct list_head *le, *tle;
 	struct drbd_request *r;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 
 	_tl_restart(mdev, CONNECTION_LOST_WHILE_PENDING);
 
 	/* we expect this list to be empty. */
-	D_ASSERT(list_empty(&mdev->out_of_sequence_requests));
+	D_ASSERT(list_empty(&mdev->tconn->out_of_sequence_requests));
 
 	/* but just in case, clean it up anyways! */
-	list_for_each_safe(le, tle, &mdev->out_of_sequence_requests) {
+	list_for_each_safe(le, tle, &mdev->tconn->out_of_sequence_requests) {
 		r = list_entry(le, struct drbd_request, tl_requests);
 		/* It would be nice to complete outside of spinlock.
 		 * But this is easier for now. */
@@ -440,14 +440,14 @@ void tl_clear(struct drbd_conf *mdev)
 	/* ensure bit indicating barrier is required is clear */
 	clear_bit(CREATE_BARRIER, &mdev->flags);
 
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 }
 
 void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 {
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	_tl_restart(mdev, what);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 }
 
 /**
@@ -476,12 +476,12 @@ drbd_change_state(struct drbd_conf *mdev, enum chg_state_flags f,
 	union drbd_state os, ns;
 	enum drbd_state_rv rv;
 
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
 	rv = _drbd_set_state(mdev, ns, f, NULL);
 	ns = mdev->state;
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	return rv;
 }
@@ -522,7 +522,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 		return SS_CW_FAILED_BY_PEER;
 
 	rv = 0;
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
 	ns = sanitize_state(mdev, os, ns, NULL);
@@ -537,7 +537,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
 	}
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	return rv;
 }
@@ -566,7 +566,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	if (f & CS_SERIALIZE)
 		mutex_lock(&mdev->state_mutex);
 
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
 	ns = sanitize_state(mdev, os, ns, NULL);
@@ -575,7 +575,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 		rv = is_valid_state(mdev, ns);
 		if (rv == SS_SUCCESS)
 			rv = is_valid_state_transition(mdev, ns, os);
-		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
@@ -601,7 +601,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 				print_st_err(mdev, os, ns, rv);
 			goto abort;
 		}
-		spin_lock_irqsave(&mdev->req_lock, flags);
+		spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 		os = mdev->state;
 		ns.i = (os.i & ~mask.i) | val.i;
 		rv = _drbd_set_state(mdev, ns, f, &done);
@@ -610,7 +610,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 		rv = _drbd_set_state(mdev, ns, f, &done);
 	}
 
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
 		D_ASSERT(current != mdev->tconn->worker.task);
@@ -1367,9 +1367,9 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 				drbd_uuid_new_current(mdev);
 				clear_bit(NEW_CUR_UUID, &mdev->flags);
 			}
-			spin_lock_irq(&mdev->req_lock);
+			spin_lock_irq(&mdev->tconn->req_lock);
 			_drbd_set_state(_NS(mdev, susp_fen, 0), CS_VERBOSE, NULL);
-			spin_unlock_irq(&mdev->req_lock);
+			spin_unlock_irq(&mdev->tconn->req_lock);
 		}
 		/* case2: The connection was established again: */
 		if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
@@ -1380,11 +1380,11 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	}
 
 	if (what != NOTHING) {
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 		_tl_restart(mdev, what);
 		nsm.i &= mdev->state.i;
 		_drbd_set_state(mdev, nsm, CS_VERBOSE, NULL);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 	}
 
 	/* Became sync source.  With protocol >= 96, we still need to send out
@@ -2898,7 +2898,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	int rv = 0;
 
 	mutex_lock(&drbd_main_mutex);
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	/* to have a stable mdev->state.role
 	 * and no race with updating open_cnt */
 
@@ -2911,7 +2911,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 	if (!rv)
 		mdev->open_cnt++;
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
@@ -2990,7 +2990,7 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	spin_lock_init(&mdev->tconn->meta.work.q_lock);
 
 	spin_lock_init(&mdev->al_lock);
-	spin_lock_init(&mdev->req_lock);
+	spin_lock_init(&mdev->tconn->req_lock);
 	spin_lock_init(&mdev->peer_seq_lock);
 	spin_lock_init(&mdev->epoch_lock);
 
@@ -3451,7 +3451,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &mdev->req_lock;
+	q->queue_lock = &mdev->tconn->req_lock; /* needed since we use */
 
 	mdev->md_io_page = alloc_page(GFP_KERNEL);
 	if (!mdev->md_io_page)
@@ -3784,14 +3784,14 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	mdev->sync_conf.al_extents = be32_to_cpu(buffer->al_nr_extents);
 	bdev->md.device_uuid = be64_to_cpu(buffer->device_uuid);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->state.conn < C_CONNECTED) {
 		int peer;
 		peer = be32_to_cpu(buffer->la_peer_max_bio_size);
 		peer = max_t(int, peer, DRBD_MAX_BIO_SIZE_SAFE);
 		mdev->peer_max_bio_size = peer;
 	}
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (mdev->sync_conf.al_extents < 7)
 		mdev->sync_conf.al_extents = 127;
@@ -4046,13 +4046,13 @@ void drbd_queue_bitmap_io(struct drbd_conf *mdev,
 	mdev->bm_io_work.why = why;
 	mdev->bm_io_work.flags = flags;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	set_bit(BITMAP_IO, &mdev->flags);
 	if (atomic_read(&mdev->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &mdev->flags))
 			drbd_queue_work(&mdev->tconn->data.work, &mdev->bm_io_work.w);
 	}
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 }
 
 /**
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a9ede8fc..4eaf81a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -287,13 +287,13 @@ static int _try_outdate_peer_async(void *data)
 	   pdsk == D_INCONSISTENT while conn >= C_CONNECTED is valid,
 	   therefore we have to have the pre state change check here.
 	*/
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	ns = mdev->state;
 	if (ns.conn < C_WF_REPORT_PARAMS) {
 		ns.pdsk = nps;
 		_drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
 	}
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	return 0;
 }
@@ -884,7 +884,7 @@ static void drbd_reconfig_start(struct drbd_conf *mdev)
  * wakes potential waiters */
 static void drbd_reconfig_done(struct drbd_conf *mdev)
 {
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->state.disk == D_DISKLESS &&
 	    mdev->state.conn == C_STANDALONE &&
 	    mdev->state.role == R_SECONDARY) {
@@ -892,7 +892,7 @@ static void drbd_reconfig_done(struct drbd_conf *mdev)
 		drbd_thread_stop_nowait(&mdev->tconn->worker);
 	} else
 		clear_bit(CONFIG_PENDING, &mdev->flags);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	wake_up(&mdev->state_wait);
 }
 
@@ -909,11 +909,11 @@ static void drbd_suspend_al(struct drbd_conf *mdev)
 		return;
 	}
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->state.conn < C_CONNECTED)
 		s = !test_and_set_bit(AL_SUSPENDED, &mdev->flags);
 
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (s)
 		dev_info(DEV, "Suspended AL updates\n");
@@ -1240,7 +1240,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	if (_drbd_bm_total_weight(mdev) == drbd_bm_bits(mdev))
 		drbd_suspend_al(mdev); /* IO is still suspended here... */
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	os = mdev->state;
 	ns.i = os.i;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
@@ -1285,7 +1285,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 
 	rv = _drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
 	ns = mdev->state;
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
@@ -1521,10 +1521,10 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	}
 
 	drbd_flush_workqueue(mdev);
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->tconn->net_conf != NULL) {
 		retcode = ERR_NET_CONFIGURED;
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		goto fail;
 	}
 	mdev->tconn->net_conf = new_conf;
@@ -1548,7 +1548,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	mdev->int_dig_in=int_dig_in;
 	mdev->int_dig_vv=int_dig_vv;
 	retcode = _drbd_set_state(_NS(mdev, conn, C_UNCONNECTED), CS_VERBOSE, NULL);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	reply->ret_code = retcode;
@@ -1582,10 +1582,10 @@ static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	}
 
 	if (dc.force) {
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 		if (mdev->state.conn >= C_WF_CONNECTION)
 			_drbd_set_state(_NS(mdev, conn, C_DISCONNECTING), CS_HARD, NULL);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		goto done;
 	}
 
@@ -1917,10 +1917,10 @@ static int drbd_nl_invalidate(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
 
 	while (retcode == SS_NEED_CONNECTION) {
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 		if (mdev->state.conn < C_CONNECTED)
 			retcode = _drbd_set_state(_NS(mdev, disk, D_INCONSISTENT), CS_VERBOSE, NULL);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 
 		if (retcode != SS_NEED_CONNECTION)
 			break;
@@ -2193,10 +2193,10 @@ static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 			drbd_send_uuids_skip_initial_sync(mdev);
 			_drbd_uuid_set(mdev, UI_BITMAP, 0);
 			drbd_print_uuids(mdev, "cleared bitmap UUID");
-			spin_lock_irq(&mdev->req_lock);
+			spin_lock_irq(&mdev->tconn->req_lock);
 			_drbd_set_state(_NS2(mdev, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			spin_unlock_irq(&mdev->req_lock);
+			spin_unlock_irq(&mdev->tconn->req_lock);
 		}
 	}
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 27a8363..af968a0b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -210,9 +210,9 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 	LIST_HEAD(reclaimed);
 	struct drbd_epoch_entry *e, *t;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(e, t, &reclaimed, w.list)
 		drbd_free_net_ee(mdev, e);
@@ -269,7 +269,7 @@ static struct page *drbd_pp_alloc(struct drbd_conf *mdev, unsigned number, bool
 }
 
 /* Must not be used from irq, as that may deadlock: see drbd_pp_alloc.
- * Is also used from inside an other spin_lock_irq(&mdev->req_lock);
+ * Is also used from inside an other spin_lock_irq(&mdev->tconn->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
 static void drbd_pp_free(struct drbd_conf *mdev, struct page *page, int is_net)
@@ -371,9 +371,9 @@ int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 	int count = 0;
 	int is_net = list == &mdev->net_ee;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_splice_init(list, &work_list);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(e, t, &work_list, w.list) {
 		drbd_free_some_ee(mdev, e, is_net);
@@ -399,10 +399,10 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	struct drbd_epoch_entry *e, *t;
 	int ok = (mdev->state.conn >= C_WF_REPORT_PARAMS);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
 	list_splice_init(&mdev->done_ee, &work_list);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(e, t, &reclaimed, w.list)
 		drbd_free_net_ee(mdev, e);
@@ -429,18 +429,18 @@ void _drbd_wait_ee_list_empty(struct drbd_conf *mdev, struct list_head *head)
 	 * and calling prepare_to_wait in the fast path */
 	while (!list_empty(head)) {
 		prepare_to_wait(&mdev->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		io_schedule();
 		finish_wait(&mdev->ee_wait, &wait);
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 	}
 }
 
 void drbd_wait_ee_list_empty(struct drbd_conf *mdev, struct list_head *head)
 {
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	_drbd_wait_ee_list_empty(mdev, head);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 }
 
 /* see also kernel_accept; which is only present since 2.6.18.
@@ -1452,9 +1452,9 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 
 	e->w.cb = e_end_resync_block;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_add(&e->w.list, &mdev->sync_ee);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	atomic_add(data_size >> 9, &mdev->rs_sect_ev);
 	if (drbd_submit_ee(mdev, e, WRITE, DRBD_FAULT_RS_WR) == 0)
@@ -1462,9 +1462,9 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_del(&e->w.list);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	drbd_free_ee(mdev, e);
 fail:
@@ -1498,9 +1498,9 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 
 	sector = be64_to_cpu(p->sector);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	req = find_request(mdev, &mdev->read_requests, p->block_id, sector, false, __func__);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (unlikely(!req))
 		return false;
 
@@ -1574,11 +1574,11 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (mdev->tconn->net_conf->two_primaries) {
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 		D_ASSERT(!drbd_interval_empty(&e->i));
 		drbd_remove_interval(&mdev->epoch_entries, &e->i);
 		drbd_clear_interval(&e->i);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&e->i));
 
@@ -1595,11 +1595,11 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 	ok = drbd_send_ack(mdev, P_DISCARD_ACK, e);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	D_ASSERT(!drbd_interval_empty(&e->i));
 	drbd_remove_interval(&mdev->epoch_entries, &e->i);
 	drbd_clear_interval(&e->i);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	dec_unacked(mdev);
 
@@ -1718,7 +1718,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 	/* I'm the receiver, I do hold a net_cnt reference. */
 	if (!mdev->tconn->net_conf->two_primaries) {
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 	} else {
 		/* don't get the req_lock yet,
 		 * we may sleep in drbd_wait_peer_seq */
@@ -1765,7 +1765,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		if (drbd_wait_peer_seq(mdev, be32_to_cpu(p->seq_num)))
 			goto out_interrupted;
 
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 
 		drbd_insert_interval(&mdev->epoch_entries, &e->i);
 
@@ -1805,7 +1805,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 				e->w.cb = e_send_discard_ack;
 				list_add_tail(&e->w.list, &mdev->done_ee);
 
-				spin_unlock_irq(&mdev->req_lock);
+				spin_unlock_irq(&mdev->tconn->req_lock);
 
 				/* we could probably send that P_DISCARD_ACK ourselves,
 				 * but I don't like the receiver using the msock */
@@ -1820,13 +1820,13 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 				drbd_remove_interval(&mdev->epoch_entries, &e->i);
 				drbd_clear_interval(&e->i);
 
-				spin_unlock_irq(&mdev->req_lock);
+				spin_unlock_irq(&mdev->tconn->req_lock);
 
 				finish_wait(&mdev->misc_wait, &wait);
 				goto out_interrupted;
 			}
 
-			spin_unlock_irq(&mdev->req_lock);
+			spin_unlock_irq(&mdev->tconn->req_lock);
 			if (first) {
 				first = 0;
 				dev_alert(DEV, "Concurrent write! [W AFTERWARDS] "
@@ -1837,13 +1837,13 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 				D_ASSERT(have_unacked == 0);
 			}
 			schedule();
-			spin_lock_irq(&mdev->req_lock);
+			spin_lock_irq(&mdev->tconn->req_lock);
 		}
 		finish_wait(&mdev->misc_wait, &wait);
 	}
 
 	list_add(&e->w.list, &mdev->active_ee);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	switch (mdev->tconn->net_conf->wire_protocol) {
 	case DRBD_PROT_C:
@@ -1874,11 +1874,11 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_del(&e->w.list);
 	drbd_remove_interval(&mdev->epoch_entries, &e->i);
 	drbd_clear_interval(&e->i);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (e->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(mdev, e->i.sector);
 
@@ -2122,18 +2122,18 @@ submit_for_resync:
 
 submit:
 	inc_unacked(mdev);
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_add_tail(&e->w.list, &mdev->read_ee);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (drbd_submit_ee(mdev, e, READ, fault_type) == 0)
 		return true;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_del(&e->w.list);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
@@ -3183,10 +3183,10 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		dev_info(DEV, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
  retry:
 	os = ns = mdev->state;
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	/* peer says his disk is uptodate, while we think it is inconsistent,
 	 * and this happens while we think we have a sync going on. */
@@ -3270,7 +3270,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		}
 	}
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->state.i != os.i)
 		goto retry;
 	clear_bit(CONSIDER_RESYNC, &mdev->flags);
@@ -3284,7 +3284,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	    test_bit(NEW_CUR_UUID, &mdev->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
 		tl_clear(mdev);
 		drbd_uuid_new_current(mdev);
@@ -3294,7 +3294,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	}
 	rv = _drbd_set_state(mdev, ns, cs_flags, NULL);
 	ns = mdev->state;
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (rv < SS_SUCCESS) {
 		drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
@@ -3772,11 +3772,11 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	drbd_free_sock(mdev);
 
 	/* wait for current activity to cease. */
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	_drbd_wait_ee_list_empty(mdev, &mdev->active_ee);
 	_drbd_wait_ee_list_empty(mdev, &mdev->sync_ee);
 	_drbd_wait_ee_list_empty(mdev, &mdev->read_ee);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	/* We do not have data structures that would allow us to
 	 * get the rs_pending_cnt down to 0 again.
@@ -3828,7 +3828,7 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	if (mdev->state.role == R_PRIMARY && fp >= FP_RESOURCE && mdev->state.pdsk >= D_UNKNOWN)
 		drbd_try_outdate_peer_async(mdev);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	os = mdev->state;
 	if (os.conn >= C_UNCONNECTED) {
 		/* Do not restart in case we are C_DISCONNECTING */
@@ -3836,7 +3836,7 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 		ns.conn = C_UNCONNECTED;
 		rv = _drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
 	}
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (os.conn == C_DISCONNECTING) {
 		wait_event(mdev->tconn->net_cnt_wait, atomic_read(&mdev->tconn->net_cnt) == 0);
@@ -4245,14 +4245,14 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	struct drbd_request *req;
 	struct bio_and_error m;
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	req = find_request(mdev, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		return false;
 	}
 	__req_mod(req, what, &m);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (m.bio)
 		complete_master_bio(mdev, &m);
@@ -4518,9 +4518,9 @@ int drbd_asender(struct drbd_thread *thi)
 				goto reconnect;
 			/* to avoid race with newly queued ACKs */
 			set_bit(SIGNAL_ASENDER, &mdev->flags);
-			spin_lock_irq(&mdev->req_lock);
+			spin_lock_irq(&mdev->tconn->req_lock);
 			empty = list_empty(&mdev->done_ee);
-			spin_unlock_irq(&mdev->req_lock);
+			spin_unlock_irq(&mdev->tconn->req_lock);
 			/* new ack may have been queued right here,
 			 * but then there is also a signal pending,
 			 * and we start over... */
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c871ef2..74179f7 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -120,7 +120,7 @@ static void queue_barrier(struct drbd_conf *mdev)
 	if (test_bit(CREATE_BARRIER, &mdev->flags))
 		return;
 
-	b = mdev->newest_tle;
+	b = mdev->tconn->newest_tle;
 	b->w.cb = w_send_barrier;
 	/* inc_ap_pending done here, so we won't
 	 * get imbalanced on connection loss.
@@ -144,7 +144,7 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	 */
 	if (mdev->state.conn >= C_CONNECTED &&
 	    (s & RQ_NET_SENT) != 0 &&
-	    req->epoch == mdev->newest_tle->br_number)
+	    req->epoch == mdev->tconn->newest_tle->br_number)
 		queue_barrier(mdev);
 
 	/* we need to do the conflict detection stuff,
@@ -516,10 +516,10 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * just after it grabs the req_lock */
 		D_ASSERT(test_bit(CREATE_BARRIER, &mdev->flags) == 0);
 
-		req->epoch = mdev->newest_tle->br_number;
+		req->epoch = mdev->tconn->newest_tle->br_number;
 
 		/* increment size of current epoch */
-		mdev->newest_tle->n_writes++;
+		mdev->tconn->newest_tle->n_writes++;
 
 		/* queue work item to send data */
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
@@ -528,7 +528,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
-		if (mdev->newest_tle->n_writes >= mdev->tconn->net_conf->max_epoch_size)
+		if (mdev->tconn->newest_tle->n_writes >= mdev->tconn->net_conf->max_epoch_size)
 			queue_barrier(mdev);
 
 		break;
@@ -693,7 +693,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			 * this is bad, because if the connection is lost now,
 			 * we won't be able to clean them up... */
 			dev_err(DEV, "FIXME (BARRIER_ACKED but pending)\n");
-			list_move(&req->tl_requests, &mdev->out_of_sequence_requests);
+			list_move(&req->tl_requests, &mdev->tconn->out_of_sequence_requests);
 		}
 		if ((req->rq_state & RQ_NET_MASK) != 0) {
 			req->rq_state |= RQ_NET_DONE;
@@ -834,7 +834,7 @@ static int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio, uns
 	 * spinlock, and grabbing the spinlock.
 	 * if we lost that race, we retry.  */
 	if (rw == WRITE && (remote || send_oos) &&
-	    mdev->unused_spare_tle == NULL &&
+	    mdev->tconn->unused_spare_tle == NULL &&
 	    test_bit(CREATE_BARRIER, &mdev->flags)) {
 allocate_barrier:
 		b = kmalloc(sizeof(struct drbd_tl_epoch), GFP_NOIO);
@@ -846,7 +846,7 @@ allocate_barrier:
 	}
 
 	/* GOOD, everything prepared, grab the spin_lock */
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 
 	if (is_susp(mdev->state)) {
 		/* If we got suspended, use the retry mechanism of
@@ -854,7 +854,7 @@ allocate_barrier:
 		   bio. In the next call to drbd_make_request
 		   we sleep in inc_ap_bio() */
 		ret = 1;
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		goto fail_free_complete;
 	}
 
@@ -867,21 +867,21 @@ allocate_barrier:
 			dev_warn(DEV, "lost connection while grabbing the req_lock!\n");
 		if (!(local || remote)) {
 			dev_err(DEV, "IO ERROR: neither local nor remote disk\n");
-			spin_unlock_irq(&mdev->req_lock);
+			spin_unlock_irq(&mdev->tconn->req_lock);
 			goto fail_free_complete;
 		}
 	}
 
-	if (b && mdev->unused_spare_tle == NULL) {
-		mdev->unused_spare_tle = b;
+	if (b && mdev->tconn->unused_spare_tle == NULL) {
+		mdev->tconn->unused_spare_tle = b;
 		b = NULL;
 	}
 	if (rw == WRITE && (remote || send_oos) &&
-	    mdev->unused_spare_tle == NULL &&
+	    mdev->tconn->unused_spare_tle == NULL &&
 	    test_bit(CREATE_BARRIER, &mdev->flags)) {
 		/* someone closed the current epoch
 		 * while we were grabbing the spinlock */
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		goto allocate_barrier;
 	}
 
@@ -899,10 +899,10 @@ allocate_barrier:
 	 * barrier packet.  To get the write ordering right, we only have to
 	 * make sure that, if this is a write request and it triggered a
 	 * barrier packet, this request is queued within the same spinlock. */
-	if ((remote || send_oos) && mdev->unused_spare_tle &&
+	if ((remote || send_oos) && mdev->tconn->unused_spare_tle &&
 	    test_and_clear_bit(CREATE_BARRIER, &mdev->flags)) {
-		_tl_add_barrier(mdev, mdev->unused_spare_tle);
-		mdev->unused_spare_tle = NULL;
+		_tl_add_barrier(mdev, mdev->tconn->unused_spare_tle);
+		mdev->tconn->unused_spare_tle = NULL;
 	} else {
 		D_ASSERT(!(remote && rw == WRITE &&
 			   test_bit(CREATE_BARRIER, &mdev->flags)));
@@ -934,7 +934,7 @@ allocate_barrier:
 	if (rw == WRITE && _req_conflicts(req))
 		goto fail_conflicting;
 
-	list_add_tail(&req->tl_requests, &mdev->newest_tle->requests);
+	list_add_tail(&req->tl_requests, &mdev->tconn->newest_tle->requests);
 
 	/* NOTE remote first: to get the concurrent write detection right,
 	 * we must register the request before start of local IO.  */
@@ -975,7 +975,7 @@ allocate_barrier:
 		}
 	}
 
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	kfree(b); /* if someone else has beaten us to it... */
 
 	if (local) {
@@ -1008,7 +1008,7 @@ fail_conflicting:
 	 * pretend that it was successfully served right now.
 	 */
 	_drbd_end_io_acct(mdev, req);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (remote)
 		dec_ap_pending(mdev);
 	/* THINK: do we want to fail it (-EIO), or pretend success?
@@ -1188,10 +1188,10 @@ void request_timer_fn(unsigned long data)
 	if (!et || mdev->state.conn < C_WF_REPORT_PARAMS)
 		return; /* Recurring timer stopped */
 
-	spin_lock_irq(&mdev->req_lock);
-	le = &mdev->oldest_tle->requests;
+	spin_lock_irq(&mdev->tconn->req_lock);
+	le = &mdev->tconn->oldest_tle->requests;
 	if (list_empty(le)) {
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		mod_timer(&mdev->request_timer, jiffies + et);
 		return;
 	}
@@ -1210,5 +1210,5 @@ void request_timer_fn(unsigned long data)
 		mod_timer(&mdev->request_timer, req->start_time + et);
 	}
 
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 }
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 9d75647..4b0858b 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -305,9 +305,9 @@ static inline int req_mod(struct drbd_request *req,
 	struct bio_and_error m;
 	int rv;
 
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	rv = __req_mod(req, what, &m);
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	if (m.bio)
 		complete_master_bio(mdev, &m);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index ec26df3..671251a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -85,14 +85,14 @@ void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = e->mdev;
 
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	mdev->read_cnt += e->i.size >> 9;
 	list_del(&e->w.list);
 	if (list_empty(&mdev->read_ee))
 		wake_up(&mdev->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &e->flags))
 		__drbd_chk_io_error(mdev, false);
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	drbd_queue_work(&mdev->tconn->data.work, &e->w);
 	put_ldev(mdev);
@@ -117,7 +117,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	do_al_complete_io = e->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = e->block_id;
 
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	mdev->writ_cnt += e->i.size >> 9;
 	list_del(&e->w.list); /* has been on active_ee or sync_ee */
 	list_add_tail(&e->w.list, &mdev->done_ee);
@@ -134,7 +134,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 
 	if (test_bit(__EE_WAS_ERROR, &e->flags))
 		__drbd_chk_io_error(mdev, false);
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
 		drbd_rs_complete_io(mdev, e_sector);
@@ -220,9 +220,9 @@ void drbd_endio_pri(struct bio *bio, int error)
 	req->private_bio = ERR_PTR(error);
 
 	/* not req_mod(), we need irqsave here! */
-	spin_lock_irqsave(&mdev->req_lock, flags);
+	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	__req_mod(req, what, &m);
-	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	if (m.bio)
 		complete_master_bio(mdev, &m);
@@ -236,13 +236,13 @@ int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * but try to WRITE the P_DATA_REPLY to the failed location,
 	 * to give the disk the chance to relocate that block */
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (cancel || mdev->state.pdsk != D_UP_TO_DATE) {
 		_req_mod(req, READ_RETRY_REMOTE_CANCELED);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		return 1;
 	}
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	return w_send_read_req(mdev, w, 0);
 }
@@ -359,9 +359,9 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 		goto defer;
 
 	e->w.cb = w_e_send_csum;
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_add(&e->w.list, &mdev->read_ee);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	atomic_add(size >> 9, &mdev->rs_sect_ev);
 	if (drbd_submit_ee(mdev, e, READ, DRBD_FAULT_RS_RD) == 0)
@@ -371,9 +371,9 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 	 * because bio_add_page failed (probably broken lower level driver),
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	list_del(&e->w.list);
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	drbd_free_ee(mdev, e);
 defer:
@@ -793,7 +793,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 
 	ping_peer(mdev);
 
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	os = mdev->state;
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
@@ -882,7 +882,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 
 	_drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
 out_unlock:
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	put_ldev(mdev);
 out:
 	mdev->rs_total  = 0;
@@ -907,9 +907,9 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_epoch_ent
 		int i = (e->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &mdev->pp_in_use_by_net);
 		atomic_sub(i, &mdev->pp_in_use);
-		spin_lock_irq(&mdev->req_lock);
+		spin_lock_irq(&mdev->tconn->req_lock);
 		list_add_tail(&e->w.list, &mdev->net_ee);
-		spin_unlock_irq(&mdev->req_lock);
+		spin_unlock_irq(&mdev->tconn->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
 		drbd_free_ee(mdev, e);
@@ -1210,10 +1210,10 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * actually, this race was harmless, since we only try to send the
 	 * barrier packet here, and otherwise do nothing with the object.
 	 * but compare with the head of w_clear_epoch */
-	spin_lock_irq(&mdev->req_lock);
+	spin_lock_irq(&mdev->tconn->req_lock);
 	if (w->cb != w_send_barrier || mdev->state.conn < C_CONNECTED)
 		cancel = 1;
-	spin_unlock_irq(&mdev->req_lock);
+	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (cancel)
 		return 1;
 
-- 
1.7.4.1

