Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1HYPe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:34:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32962 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1HYPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 020/118] drbd: Remove the unused hash tables
Date: Thu, 25 Aug 2011 17:07:16 +0200
Message-Id: <1314284934-17999-21-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   13 --------
 drivers/block/drbd/drbd_main.c     |   57 ------------------------------------
 drivers/block/drbd/drbd_nl.c       |   36 +----------------------
 drivers/block/drbd/drbd_receiver.c |   27 ++++-------------
 drivers/block/drbd/drbd_req.c      |   26 ++++------------
 drivers/block/drbd/drbd_req.h      |   27 -----------------
 drivers/block/drbd/drbd_worker.c   |   11 ++++--
 7 files changed, 20 insertions(+), 177 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 535339b..0ed97ac 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -694,7 +694,6 @@ struct drbd_request {
 	 * see drbd_endio_pri(). */
 	struct bio *private_bio;
 
-	struct hlist_node collision;
 	struct drbd_interval i;
 	unsigned int epoch; /* barrier_nr */
 
@@ -759,7 +758,6 @@ struct digest_info {
 
 struct drbd_epoch_entry {
 	struct drbd_work w;
-	struct hlist_node collision;
 	struct drbd_epoch *epoch; /* for writes */
 	struct drbd_conf *mdev;
 	struct page *pages;
@@ -1015,8 +1013,6 @@ struct drbd_conf {
 	struct drbd_tl_epoch *newest_tle;
 	struct drbd_tl_epoch *oldest_tle;
 	struct list_head out_of_sequence_requests;
-	struct hlist_head *tl_hash;
-	unsigned int tl_hash_s;
 
 	/* Interval tree of pending local write requests */
 	struct rb_root read_requests;
@@ -1077,8 +1073,6 @@ struct drbd_conf {
 	struct list_head done_ee;   /* send ack */
 	struct list_head read_ee;   /* IO in progress (any read) */
 	struct list_head net_ee;    /* zero-copy network send in progress */
-	struct hlist_head *ee_hash; /* is proteced by req_lock! */
-	unsigned int ee_hash_s;
 
 	/* Interval tree of pending remote write requests (struct drbd_epoch_entry) */
 	struct rb_root epoch_entries;
@@ -1087,7 +1081,6 @@ struct drbd_conf {
 	struct drbd_epoch_entry *last_write_w_barrier;
 
 	int next_barrier_nr;
-	struct hlist_head *app_reads_hash; /* is proteced by req_lock */
 	struct list_head resync_reads;
 	atomic_t pp_in_use;		/* allocated from page pool */
 	atomic_t pp_in_use_by_net;	/* sendpage()d, still referenced by tcp */
@@ -1428,18 +1421,12 @@ struct bm_extent {
 #endif
 #endif
 
-/* Sector shift value for the "hash" functions of tl_hash and ee_hash tables.
- * With a value of 8 all IO in one 128K block make it to the same slot of the
- * hash table. */
 #define HT_SHIFT 8
 #define DRBD_MAX_BIO_SIZE (1U<<(9+HT_SHIFT))
 #define DRBD_MAX_BIO_SIZE_SAFE (1 << 12)       /* Works always = 4k */
 
 #define DRBD_MAX_SIZE_H80_PACKET (1 << 15) /* The old header only allows packets up to 32Kib data */
 
-/* Number of elements in the app_reads_hash */
-#define APP_R_HSIZE 15
-
 extern int  drbd_bm_init(struct drbd_conf *mdev);
 extern int  drbd_bm_resize(struct drbd_conf *mdev, sector_t sectors, int set_new_bits);
 extern void drbd_bm_cleanup(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 18f27af..878f7d4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -209,9 +209,6 @@ static int tl_init(struct drbd_conf *mdev)
 	mdev->newest_tle = b;
 	INIT_LIST_HEAD(&mdev->out_of_sequence_requests);
 
-	mdev->tl_hash = NULL;
-	mdev->tl_hash_s = 0;
-
 	return 1;
 }
 
@@ -223,39 +220,6 @@ static void tl_cleanup(struct drbd_conf *mdev)
 	mdev->oldest_tle = NULL;
 	kfree(mdev->unused_spare_tle);
 	mdev->unused_spare_tle = NULL;
-	kfree(mdev->tl_hash);
-	mdev->tl_hash = NULL;
-	mdev->tl_hash_s = 0;
-}
-
-static void drbd_free_tl_hash(struct drbd_conf *mdev)
-{
-	struct hlist_head *h;
-
-	spin_lock_irq(&mdev->req_lock);
-
-	if (!mdev->tl_hash || mdev->state.conn != C_STANDALONE) {
-		spin_unlock_irq(&mdev->req_lock);
-		return;
-	}
-	/* paranoia code */
-	for (h = mdev->ee_hash; h < mdev->ee_hash + mdev->ee_hash_s; h++)
-		if (h->first)
-			dev_err(DEV, "ASSERT FAILED ee_hash[%u].first == %p, expected NULL\n",
-				(int)(h - mdev->ee_hash), h->first);
-	kfree(mdev->ee_hash);
-	mdev->ee_hash = NULL;
-	mdev->ee_hash_s = 0;
-
-	/* paranoia code */
-	for (h = mdev->tl_hash; h < mdev->tl_hash + mdev->tl_hash_s; h++)
-		if (h->first)
-			dev_err(DEV, "ASSERT FAILED tl_hash[%u] == %p, expected NULL\n",
-				(int)(h - mdev->tl_hash), h->first);
-	kfree(mdev->tl_hash);
-	mdev->tl_hash = NULL;
-	mdev->tl_hash_s = 0;
-	spin_unlock_irq(&mdev->req_lock);
 }
 
 /**
@@ -475,8 +439,6 @@ void tl_clear(struct drbd_conf *mdev)
 	/* ensure bit indicating barrier is required is clear */
 	clear_bit(CREATE_BARRIER, &mdev->flags);
 
-	memset(mdev->app_reads_hash, 0, APP_R_HSIZE*sizeof(void *));
-
 	spin_unlock_irq(&mdev->req_lock);
 }
 
@@ -1633,10 +1595,6 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		put_ldev(mdev);
 	}
 
-	/* free tl_hash if we Got thawed and are C_STANDALONE */
-	if (ns.conn == C_STANDALONE && !is_susp(ns) && mdev->tl_hash)
-		drbd_free_tl_hash(mdev);
-
 	/* Upon network connection, we need to start the receiver */
 	if (os.conn == C_STANDALONE && ns.conn == C_UNCONNECTED)
 		drbd_thread_start(&mdev->receiver);
@@ -3317,13 +3275,6 @@ static void drbd_delete_device(unsigned int minor)
 
 	drbd_release_ee_lists(mdev);
 
-	/* should be freed on disconnect? */
-	kfree(mdev->ee_hash);
-	/*
-	mdev->ee_hash_s = 0;
-	mdev->ee_hash = NULL;
-	*/
-
 	lc_destroy(mdev->act_log);
 	lc_destroy(mdev->resync);
 
@@ -3477,10 +3428,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	mdev->write_requests = RB_ROOT;
 	mdev->epoch_entries = RB_ROOT;
 
-	mdev->app_reads_hash = kzalloc(APP_R_HSIZE*sizeof(void *), GFP_KERNEL);
-	if (!mdev->app_reads_hash)
-		goto out_no_app_reads;
-
 	mdev->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
 	if (!mdev->current_epoch)
 		goto out_no_epoch;
@@ -3493,8 +3440,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 /* out_whatever_else:
 	kfree(mdev->current_epoch); */
 out_no_epoch:
-	kfree(mdev->app_reads_hash);
-out_no_app_reads:
 	tl_cleanup(mdev);
 out_no_tl:
 	drbd_bm_cleanup(mdev);
@@ -3516,7 +3461,6 @@ out_no_cpumask:
 void drbd_free_mdev(struct drbd_conf *mdev)
 {
 	kfree(mdev->current_epoch);
-	kfree(mdev->app_reads_hash);
 	tl_cleanup(mdev);
 	if (mdev->bitmap) /* should no longer be there. */
 		drbd_bm_cleanup(mdev);
@@ -3524,7 +3468,6 @@ void drbd_free_mdev(struct drbd_conf *mdev)
 	put_disk(mdev->vdisk);
 	blk_cleanup_queue(mdev->rq_queue);
 	free_cpumask_var(mdev->cpu_mask);
-	drbd_free_tl_hash(mdev);
 	kfree(mdev);
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 98c0e9b..5b8ebbe 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1353,14 +1353,12 @@ static int drbd_nl_detach(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 			    struct drbd_nl_cfg_reply *reply)
 {
-	int i, ns;
+	int i;
 	enum drbd_ret_code retcode;
 	struct net_conf *new_conf = NULL;
 	struct crypto_hash *tfm = NULL;
 	struct crypto_hash *integrity_w_tfm = NULL;
 	struct crypto_hash *integrity_r_tfm = NULL;
-	struct hlist_head *new_tl_hash = NULL;
-	struct hlist_head *new_ee_hash = NULL;
 	struct drbd_conf *odev;
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	void *int_dig_out = NULL;
@@ -1494,24 +1492,6 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		}
 	}
 
-	ns = new_conf->max_epoch_size/8;
-	if (mdev->tl_hash_s != ns) {
-		new_tl_hash = kzalloc(ns*sizeof(void *), GFP_KERNEL);
-		if (!new_tl_hash) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-	}
-
-	ns = new_conf->max_buffers/8;
-	if (new_conf->two_primaries && (mdev->ee_hash_s != ns)) {
-		new_ee_hash = kzalloc(ns*sizeof(void *), GFP_KERNEL);
-		if (!new_ee_hash) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-	}
-
 	((char *)new_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
 	if (integrity_w_tfm) {
@@ -1552,18 +1532,6 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	mdev->send_cnt = 0;
 	mdev->recv_cnt = 0;
 
-	if (new_tl_hash) {
-		kfree(mdev->tl_hash);
-		mdev->tl_hash_s = mdev->net_conf->max_epoch_size/8;
-		mdev->tl_hash = new_tl_hash;
-	}
-
-	if (new_ee_hash) {
-		kfree(mdev->ee_hash);
-		mdev->ee_hash_s = mdev->net_conf->max_buffers/8;
-		mdev->ee_hash = new_ee_hash;
-	}
-
 	crypto_free_hash(mdev->cram_hmac_tfm);
 	mdev->cram_hmac_tfm = tfm;
 
@@ -1594,8 +1562,6 @@ fail:
 	crypto_free_hash(tfm);
 	crypto_free_hash(integrity_w_tfm);
 	crypto_free_hash(integrity_r_tfm);
-	kfree(new_tl_hash);
-	kfree(new_ee_hash);
 	kfree(new_conf);
 
 	reply->ret_code = retcode;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a0fbbfc..566317b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -333,7 +333,6 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	if (!page)
 		goto fail;
 
-	INIT_HLIST_NODE(&e->collision);
 	drbd_clear_interval(&e->i);
 	e->epoch = NULL;
 	e->mdev = mdev;
@@ -361,7 +360,6 @@ void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e, int i
 		kfree(e->digest);
 	drbd_pp_free(mdev, e->pages, is_net);
 	D_ASSERT(atomic_read(&e->pending_bios) == 0);
-	D_ASSERT(hlist_unhashed(&e->collision));
 	D_ASSERT(drbd_interval_empty(&e->i));
 	mempool_free(e, drbd_ee_mempool);
 }
@@ -1419,7 +1417,6 @@ static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int u
 	sector_t sector = e->i.sector;
 	int ok;
 
-	D_ASSERT(hlist_unhashed(&e->collision));
 	D_ASSERT(drbd_interval_empty(&e->i));
 
 	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
@@ -1575,16 +1572,12 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (mdev->net_conf->two_primaries) {
 		spin_lock_irq(&mdev->req_lock);
-		D_ASSERT(!hlist_unhashed(&e->collision));
-		hlist_del_init(&e->collision);
 		D_ASSERT(!drbd_interval_empty(&e->i));
 		drbd_remove_interval(&mdev->epoch_entries, &e->i);
 		drbd_clear_interval(&e->i);
 		spin_unlock_irq(&mdev->req_lock);
-	} else {
-		D_ASSERT(hlist_unhashed(&e->collision));
+	} else
 		D_ASSERT(drbd_interval_empty(&e->i));
-	}
 
 	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
@@ -1600,8 +1593,6 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 	ok = drbd_send_ack(mdev, P_DISCARD_ACK, e);
 
 	spin_lock_irq(&mdev->req_lock);
-	D_ASSERT(!hlist_unhashed(&e->collision));
-	hlist_del_init(&e->collision);
 	D_ASSERT(!drbd_interval_empty(&e->i));
 	drbd_remove_interval(&mdev->epoch_entries, &e->i);
 	drbd_clear_interval(&e->i);
@@ -1734,23 +1725,20 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		int first;
 
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_C);
-		BUG_ON(mdev->ee_hash == NULL);
-		BUG_ON(mdev->tl_hash == NULL);
 
 		/* conflict detection and handling:
 		 * 1. wait on the sequence number,
 		 *    in case this data packet overtook ACK packets.
-		 * 2. check our hash tables for conflicting requests.
-		 *    we only need to walk the tl_hash, since an ee can not
-		 *    have a conflict with an other ee: on the submitting
-		 *    node, the corresponding req had already been conflicting,
-		 *    and a conflicting req is never sent.
+		 * 2. check our interval trees for conflicting requests:
+		 *    we only need to check the write_requests tree; the
+		 *    epoch_entries tree cannot contain any overlaps because
+		 *    they were already eliminated on the submitting node.
 		 *
 		 * Note: for two_primaries, we are protocol C,
 		 * so there cannot be any request that is DONE
 		 * but still on the transfer log.
 		 *
-		 * unconditionally add to the ee_hash.
+		 * unconditionally add to the epoch_entries tree.
 		 *
 		 * if no conflicting request is found:
 		 *    submit.
@@ -1776,7 +1764,6 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 		spin_lock_irq(&mdev->req_lock);
 
-		hlist_add_head(&e->collision, ee_hash_slot(mdev, sector));
 		drbd_insert_interval(&mdev->epoch_entries, &e->i);
 
 		first = 1;
@@ -1827,7 +1814,6 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 			}
 
 			if (signal_pending(current)) {
-				hlist_del_init(&e->collision);
 				drbd_remove_interval(&mdev->epoch_entries, &e->i);
 				drbd_clear_interval(&e->i);
 
@@ -1887,7 +1873,6 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->req_lock);
 	list_del(&e->w.list);
-	hlist_del_init(&e->collision);
 	drbd_remove_interval(&mdev->epoch_entries, &e->i);
 	drbd_clear_interval(&e->i);
 	spin_unlock_irq(&mdev->req_lock);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index b81ce82..8541b16 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -148,9 +148,9 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		queue_barrier(mdev);
 
 	/* we need to do the conflict detection stuff,
-	 * if we have the ee_hash (two_primaries) and
-	 * this has been on the network */
-	if ((s & RQ_NET_DONE) && mdev->ee_hash != NULL) {
+	 * if the epoch_entries tree is non-empty and
+	 * this request has completed on the network */
+	if ((s & RQ_NET_DONE) && !RB_EMPTY_ROOT(&mdev->epoch_entries)) {
 		const sector_t sector = req->i.sector;
 		const int size = req->i.size;
 		struct drbd_interval *i;
@@ -254,7 +254,6 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 		if (!drbd_interval_empty(&req->i)) {
 			struct rb_root *root;
 
-			hlist_del(&req->collision);
 			if (rw == WRITE)
 				root = &mdev->write_requests;
 			else
@@ -313,9 +312,7 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
  * conflicting requests with local origin, and why we have to do so regardless
  * of whether we allowed multiple primaries.
  *
- * BTW, in case we only have one primary, the ee_hash is empty anyways, and the
- * second hlist_for_each_entry becomes a noop. This is even simpler than to
- * grab a reference on the net_conf, and check for the two_primaries flag...
+ * In case we only have one primary, the epoch_entries tree is empty.
  */
 static int _req_conflicts(struct drbd_request *req)
 {
@@ -324,17 +321,11 @@ static int _req_conflicts(struct drbd_request *req)
 	const int size = req->i.size;
 	struct drbd_interval *i;
 
-	D_ASSERT(hlist_unhashed(&req->collision));
 	D_ASSERT(drbd_interval_empty(&req->i));
 
 	if (!get_net_conf(mdev))
 		return 0;
 
-	/* BUG_ON */
-	ERR_IF (mdev->tl_hash_s == 0)
-		goto out_no_conflict;
-	BUG_ON(mdev->tl_hash == NULL);
-
 	i = drbd_find_overlap(&mdev->write_requests, sector, size);
 	if (i) {
 		struct drbd_request *req2 =
@@ -349,10 +340,8 @@ static int _req_conflicts(struct drbd_request *req)
 		goto out_conflict;
 	}
 
-	if (mdev->ee_hash_s) {
-		/* now, check for overlapping requests with remote origin */
-		BUG_ON(mdev->ee_hash == NULL);
-
+	if (!RB_EMPTY_ROOT(&mdev->epoch_entries)) {
+		/* check for overlapping requests with remote origin */
 		i = drbd_find_overlap(&mdev->epoch_entries, sector, size);
 		if (i) {
 			struct drbd_epoch_entry *e =
@@ -368,7 +357,6 @@ static int _req_conflicts(struct drbd_request *req)
 		}
 	}
 
-out_no_conflict:
 	/* this is like it should be, and what we expected.
 	 * our users do behave after all... */
 	put_net_conf(mdev);
@@ -486,7 +474,6 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		/* so we can verify the handle in the answer packet
 		 * corresponding hlist_del is in _req_may_be_done() */
-		hlist_add_head(&req->collision, ar_hash_slot(mdev, req->i.sector));
 		drbd_insert_interval(&mdev->read_requests, &req->i);
 
 		set_bit(UNPLUG_REMOTE, &mdev->flags);
@@ -503,7 +490,6 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* assert something? */
 		/* from drbd_make_request_common only */
 
-		hlist_add_head(&req->collision, tl_hash_slot(mdev, req->i.sector));
 		/* corresponding hlist_del is in _req_may_be_done() */
 		drbd_insert_interval(&mdev->write_requests, &req->i);
 
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 6f11624..ee59174 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -222,32 +222,6 @@ enum drbd_req_state_bits {
 #define MR_READ_SHIFT  1
 #define MR_READ        (1 << MR_READ_SHIFT)
 
-/* epoch entries */
-static inline
-struct hlist_head *ee_hash_slot(struct drbd_conf *mdev, sector_t sector)
-{
-	BUG_ON(mdev->ee_hash_s == 0);
-	return mdev->ee_hash +
-		((unsigned int)(sector>>HT_SHIFT) % mdev->ee_hash_s);
-}
-
-/* transfer log (drbd_request objects) */
-static inline
-struct hlist_head *tl_hash_slot(struct drbd_conf *mdev, sector_t sector)
-{
-	BUG_ON(mdev->tl_hash_s == 0);
-	return mdev->tl_hash +
-		((unsigned int)(sector>>HT_SHIFT) % mdev->tl_hash_s);
-}
-
-/* application reads (drbd_request objects) */
-static inline
-struct hlist_head *ar_hash_slot(struct drbd_conf *mdev, sector_t sector)
-{
-	return mdev->app_reads_hash
-		+ ((unsigned int)(sector) % APP_R_HSIZE);
-}
-
 static inline void drbd_req_make_private_bio(struct drbd_request *req, struct bio *bio_src)
 {
 	struct bio *bio;
@@ -274,7 +248,6 @@ static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 		req->epoch       = 0;
 		req->i.sector     = bio_src->bi_sector;
 		req->i.size      = bio_src->bi_size;
-		INIT_HLIST_NODE(&req->collision);
 		drbd_clear_interval(&req->i);
 		INIT_LIST_HEAD(&req->tl_requests);
 		INIT_LIST_HEAD(&req->w.list);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 2b83aaf..1ddf6b6 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -122,10 +122,13 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	list_del(&e->w.list); /* has been on active_ee or sync_ee */
 	list_add_tail(&e->w.list, &mdev->done_ee);
 
-	/* No hlist_del_init(&e->collision) here, we did not send the Ack yet,
-	 * neither did we wake possibly waiting conflicting requests.
-	 * done from "drbd_process_done_ee" within the appropriate w.cb
-	 * (e_end_block/e_end_resync_block) or from _drbd_clear_done_ee */
+	/*
+	 * Do not remove from the epoch_entries tree here: we did not send the
+	 * Ack yet and did not wake possibly waiting conflicting requests.
+	 * Removed from the tree from "drbd_process_done_ee" within the
+	 * appropriate w.cb (e_end_block/e_end_resync_block) or from
+	 * _drbd_clear_done_ee.
+	 */
 
 	do_wake = list_empty(block_id == ID_SYNCER ? &mdev->sync_ee : &mdev->active_ee);
 
-- 
1.7.4.1

