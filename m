Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1HYPZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:25:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34500 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1HYPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 060/118] drbd: Local variable renames: e -> peer_req
Date: Thu, 25 Aug 2011 17:07:56 +0200
Message-Id: <1314284934-17999-61-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    4 +-
 drivers/block/drbd/drbd_main.c     |   36 +++---
 drivers/block/drbd/drbd_nl.c       |   18 ++-
 drivers/block/drbd/drbd_receiver.c |  256 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_worker.c   |  197 ++++++++++++++--------------
 5 files changed, 259 insertions(+), 252 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2cebdd6..f934aa2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1701,9 +1701,9 @@ static inline int drbd_bio_has_active_page(struct bio *bio)
 	return 0;
 }
 
-static inline int drbd_ee_has_active_page(struct drbd_peer_request *e)
+static inline int drbd_ee_has_active_page(struct drbd_peer_request *peer_req)
 {
-	struct page *page = e->pages;
+	struct page *page = peer_req->pages;
 	page_chain_for_each(page) {
 		if (page_count(page) > 1)
 			return 1;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 964f76e..44be1f2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2429,17 +2429,17 @@ int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 /**
  * drbd_send_ack() - Sends an ack packet
- * @mdev:	DRBD device.
- * @cmd:	Packet command code.
- * @e:		Epoch entry.
+ * @mdev:	DRBD device
+ * @cmd:	packet command code
+ * @peer_req:	peer request
  */
 int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
-		  struct drbd_peer_request *e)
+		  struct drbd_peer_request *peer_req)
 {
 	return _drbd_send_ack(mdev, cmd,
-			      cpu_to_be64(e->i.sector),
-			      cpu_to_be32(e->i.size),
-			      e->block_id);
+			      cpu_to_be64(peer_req->i.sector),
+			      cpu_to_be32(peer_req->i.size),
+			      peer_req->block_id);
 }
 
 /* This function misuses the block_id field to signal if the blocks
@@ -2641,10 +2641,12 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 	return 1;
 }
 
-static int _drbd_send_zc_ee(struct drbd_conf *mdev, struct drbd_peer_request *e)
+static int _drbd_send_zc_ee(struct drbd_conf *mdev,
+			    struct drbd_peer_request *peer_req)
 {
-	struct page *page = e->pages;
-	unsigned len = e->i.size;
+	struct page *page = peer_req->pages;
+	unsigned len = peer_req->i.size;
+
 	/* hint all but last page with MSG_MORE */
 	page_chain_for_each(page) {
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
@@ -2747,7 +2749,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
 int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
-		    struct drbd_peer_request *e)
+		    struct drbd_peer_request *peer_req)
 {
 	int ok;
 	struct p_data p;
@@ -2757,9 +2759,11 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
-	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
-	p.sector   = cpu_to_be64(e->i.sector);
-	p.block_id = e->block_id;
+	prepare_header(mdev, &p.head, cmd, sizeof(p) -
+					   sizeof(struct p_header80) +
+					   dgs + peer_req->i.size);
+	p.sector   = cpu_to_be64(peer_req->i.sector);
+	p.block_id = peer_req->block_id;
 	p.seq_num = 0;  /* unused */
 
 	/* Only called by our kernel thread.
@@ -2772,11 +2776,11 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	ok = sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
 	if (ok && dgs) {
 		dgb = mdev->tconn->int_dig_out;
-		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, e, dgb);
+		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, peer_req, dgb);
 		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok)
-		ok = _drbd_send_zc_ee(mdev, e);
+		ok = _drbd_send_zc_ee(mdev, peer_req);
 
 	drbd_put_data_sock(mdev);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ee00ffa..e30d52b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2445,7 +2445,7 @@ void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name)
 
 void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
 		   const char *seen_hash, const char *calc_hash,
-			   const struct drbd_peer_request *e)
+			   const struct drbd_peer_request *peer_req)
 {
 	struct cn_msg *cn_reply;
 	struct drbd_nl_cfg_reply *reply;
@@ -2453,7 +2453,7 @@ void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
 	struct page *page;
 	unsigned len;
 
-	if (!e)
+	if (!peer_req)
 		return;
 	if (!reason || !reason[0])
 		return;
@@ -2472,8 +2472,10 @@ void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
 		GFP_NOIO);
 
 	if (!cn_reply) {
-		dev_err(DEV, "could not kmalloc buffer for drbd_bcast_ee, sector %llu, size %u\n",
-				(unsigned long long)e->i.sector, e->i.size);
+		dev_err(DEV, "could not kmalloc buffer for drbd_bcast_ee, "
+			     "sector %llu, size %u\n",
+			(unsigned long long)peer_req->i.sector,
+			peer_req->i.size);
 		return;
 	}
 
@@ -2483,15 +2485,15 @@ void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
 	tl = tl_add_str(tl, T_dump_ee_reason, reason);
 	tl = tl_add_blob(tl, T_seen_digest, seen_hash, dgs);
 	tl = tl_add_blob(tl, T_calc_digest, calc_hash, dgs);
-	tl = tl_add_int(tl, T_ee_sector, &e->i.sector);
-	tl = tl_add_int(tl, T_ee_block_id, &e->block_id);
+	tl = tl_add_int(tl, T_ee_sector, &peer_req->i.sector);
+	tl = tl_add_int(tl, T_ee_block_id, &peer_req->block_id);
 
 	/* dump the first 32k */
-	len = min_t(unsigned, e->i.size, 32 << 10);
+	len = min_t(unsigned, peer_req->i.size, 32 << 10);
 	put_unaligned(T_ee_data, tl++);
 	put_unaligned(len, tl++);
 
-	page = e->pages;
+	page = peer_req->pages;
 	page_chain_for_each(page) {
 		void *d = kmap_atomic(page, KM_USER0);
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5c4c260..3f0f41f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -189,7 +189,7 @@ static struct page *drbd_pp_first_pages_or_try_alloc(struct drbd_conf *mdev, int
 
 static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed)
 {
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 	struct list_head *le, *tle;
 
 	/* The EEs are always appended to the end of the list. Since
@@ -198,8 +198,8 @@ static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed
 	   stop to examine the list... */
 
 	list_for_each_safe(le, tle, &mdev->net_ee) {
-		e = list_entry(le, struct drbd_peer_request, w.list);
-		if (drbd_ee_has_active_page(e))
+		peer_req = list_entry(le, struct drbd_peer_request, w.list);
+		if (drbd_ee_has_active_page(peer_req))
 			break;
 		list_move(le, to_be_freed);
 	}
@@ -208,14 +208,14 @@ static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed
 static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 {
 	LIST_HEAD(reclaimed);
-	struct drbd_peer_request *e, *t;
+	struct drbd_peer_request *peer_req, *t;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	list_for_each_entry_safe(e, t, &reclaimed, w.list)
-		drbd_free_net_ee(mdev, e);
+	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
+		drbd_free_net_ee(mdev, peer_req);
 }
 
 /**
@@ -313,15 +313,15 @@ struct drbd_peer_request *
 drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
 	      unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 	struct page *page;
 	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
 
 	if (drbd_insert_fault(mdev, DRBD_FAULT_AL_EE))
 		return NULL;
 
-	e = mempool_alloc(drbd_ee_mempool, gfp_mask & ~__GFP_HIGHMEM);
-	if (!e) {
+	peer_req = mempool_alloc(drbd_ee_mempool, gfp_mask & ~__GFP_HIGHMEM);
+	if (!peer_req) {
 		if (!(gfp_mask & __GFP_NOWARN))
 			dev_err(DEV, "alloc_ee: Allocation of an EE failed\n");
 		return NULL;
@@ -331,45 +331,45 @@ drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
 	if (!page)
 		goto fail;
 
-	drbd_clear_interval(&e->i);
-	e->i.size = data_size;
-	e->i.sector = sector;
-	e->i.local = false;
-	e->i.waiting = false;
-
-	e->epoch = NULL;
-	e->mdev = mdev;
-	e->pages = page;
-	atomic_set(&e->pending_bios, 0);
-	e->flags = 0;
+	drbd_clear_interval(&peer_req->i);
+	peer_req->i.size = data_size;
+	peer_req->i.sector = sector;
+	peer_req->i.local = false;
+	peer_req->i.waiting = false;
+
+	peer_req->epoch = NULL;
+	peer_req->mdev = mdev;
+	peer_req->pages = page;
+	atomic_set(&peer_req->pending_bios, 0);
+	peer_req->flags = 0;
 	/*
 	 * The block_id is opaque to the receiver.  It is not endianness
 	 * converted, and sent back to the sender unchanged.
 	 */
-	e->block_id = id;
+	peer_req->block_id = id;
 
-	return e;
+	return peer_req;
 
  fail:
-	mempool_free(e, drbd_ee_mempool);
+	mempool_free(peer_req, drbd_ee_mempool);
 	return NULL;
 }
 
-void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_peer_request *e,
+void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_peer_request *peer_req,
 		       int is_net)
 {
-	if (e->flags & EE_HAS_DIGEST)
-		kfree(e->digest);
-	drbd_pp_free(mdev, e->pages, is_net);
-	D_ASSERT(atomic_read(&e->pending_bios) == 0);
-	D_ASSERT(drbd_interval_empty(&e->i));
-	mempool_free(e, drbd_ee_mempool);
+	if (peer_req->flags & EE_HAS_DIGEST)
+		kfree(peer_req->digest);
+	drbd_pp_free(mdev, peer_req->pages, is_net);
+	D_ASSERT(atomic_read(&peer_req->pending_bios) == 0);
+	D_ASSERT(drbd_interval_empty(&peer_req->i));
+	mempool_free(peer_req, drbd_ee_mempool);
 }
 
 int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 {
 	LIST_HEAD(work_list);
-	struct drbd_peer_request *e, *t;
+	struct drbd_peer_request *peer_req, *t;
 	int count = 0;
 	int is_net = list == &mdev->net_ee;
 
@@ -377,8 +377,8 @@ int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 	list_splice_init(list, &work_list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	list_for_each_entry_safe(e, t, &work_list, w.list) {
-		drbd_free_some_ee(mdev, e, is_net);
+	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
+		drbd_free_some_ee(mdev, peer_req, is_net);
 		count++;
 	}
 	return count;
@@ -398,7 +398,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 {
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
-	struct drbd_peer_request *e, *t;
+	struct drbd_peer_request *peer_req, *t;
 	int ok = (mdev->state.conn >= C_WF_REPORT_PARAMS);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -406,17 +406,17 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	list_splice_init(&mdev->done_ee, &work_list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	list_for_each_entry_safe(e, t, &reclaimed, w.list)
-		drbd_free_net_ee(mdev, e);
+	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
+		drbd_free_net_ee(mdev, peer_req);
 
 	/* possible callbacks here:
 	 * e_end_block, and e_end_resync_block, e_send_discard_ack.
 	 * all ignore the last argument.
 	 */
-	list_for_each_entry_safe(e, t, &work_list, w.list) {
+	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		/* list_del not necessary, next/prev members not touched */
-		ok = e->w.cb(mdev, &e->w, !ok) && ok;
-		drbd_free_ee(mdev, e);
+		ok = peer_req->w.cb(mdev, &peer_req->w, !ok) && ok;
+		drbd_free_ee(mdev, peer_req);
 	}
 	wake_up(&mdev->ee_wait);
 
@@ -1089,7 +1089,7 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
 /**
  * drbd_submit_ee()
  * @mdev:	DRBD device.
- * @e:		peer request
+ * @peer_req:	peer request
  * @rw:		flag field, see bio->bi_rw
  *
  * May spread the pages to multiple bios,
@@ -1103,14 +1103,14 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
  *  on certain Xen deployments.
  */
 /* TODO allocate from our own bio_set. */
-int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_peer_request *e,
+int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_peer_request *peer_req,
 		   const unsigned rw, const int fault_type)
 {
 	struct bio *bios = NULL;
 	struct bio *bio;
-	struct page *page = e->pages;
-	sector_t sector = e->i.sector;
-	unsigned ds = e->i.size;
+	struct page *page = peer_req->pages;
+	sector_t sector = peer_req->i.sector;
+	unsigned ds = peer_req->i.size;
 	unsigned n_bios = 0;
 	unsigned nr_pages = (ds + PAGE_SIZE -1) >> PAGE_SHIFT;
 	int err = -ENOMEM;
@@ -1125,11 +1125,11 @@ next_bio:
 		dev_err(DEV, "submit_ee: Allocation of a bio failed\n");
 		goto fail;
 	}
-	/* > e->i.sector, unless this is the first bio */
+	/* > peer_req->i.sector, unless this is the first bio */
 	bio->bi_sector = sector;
 	bio->bi_bdev = mdev->ldev->backing_bdev;
 	bio->bi_rw = rw;
-	bio->bi_private = e;
+	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_endio_sec;
 
 	bio->bi_next = bios;
@@ -1159,7 +1159,7 @@ next_bio:
 	D_ASSERT(page == NULL);
 	D_ASSERT(ds == 0);
 
-	atomic_set(&e->pending_bios, n_bios);
+	atomic_set(&peer_req->pending_bios, n_bios);
 	do {
 		bio = bios;
 		bios = bios->bi_next;
@@ -1179,9 +1179,9 @@ fail:
 }
 
 static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
-					     struct drbd_peer_request *e)
+					     struct drbd_peer_request *peer_req)
 {
-	struct drbd_interval *i = &e->i;
+	struct drbd_interval *i = &peer_req->i;
 
 	drbd_remove_interval(&mdev->write_requests, i);
 	drbd_clear_interval(i);
@@ -1270,7 +1270,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	      int data_size) __must_hold(local)
 {
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, rr;
 	void *dig_in = mdev->tconn->int_dig_in;
@@ -1313,12 +1313,12 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	e = drbd_alloc_ee(mdev, id, sector, data_size, GFP_NOIO);
-	if (!e)
+	peer_req = drbd_alloc_ee(mdev, id, sector, data_size, GFP_NOIO);
+	if (!peer_req)
 		return NULL;
 
 	ds = data_size;
-	page = e->pages;
+	page = peer_req->pages;
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
@@ -1329,7 +1329,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		}
 		kunmap(page);
 		if (rr != len) {
-			drbd_free_ee(mdev, e);
+			drbd_free_ee(mdev, peer_req);
 			if (!signal_pending(current))
 				dev_warn(DEV, "short read receiving data: read %d expected %d\n",
 				rr, len);
@@ -1339,18 +1339,18 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(mdev, mdev->tconn->integrity_r_tfm, e, dig_vv);
+		drbd_csum_ee(mdev, mdev->tconn->integrity_r_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
 			drbd_bcast_ee(mdev, "digest failed",
-					dgs, dig_in, dig_vv, e);
-			drbd_free_ee(mdev, e);
+					dgs, dig_in, dig_vv, peer_req);
+			drbd_free_ee(mdev, peer_req);
 			return NULL;
 		}
 	}
 	mdev->recv_cnt += data_size>>9;
-	return e;
+	return peer_req;
 }
 
 /* drbd_drain_block() just takes a data block
@@ -1449,20 +1449,20 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
  * drbd_process_done_ee() by asender only */
 static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 {
-	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
-	sector_t sector = e->i.sector;
+	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
+	sector_t sector = peer_req->i.sector;
 	int ok;
 
-	D_ASSERT(drbd_interval_empty(&e->i));
+	D_ASSERT(drbd_interval_empty(&peer_req->i));
 
-	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
-		drbd_set_in_sync(mdev, sector, e->i.size);
-		ok = drbd_send_ack(mdev, P_RS_WRITE_ACK, e);
+	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
+		drbd_set_in_sync(mdev, sector, peer_req->i.size);
+		ok = drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
-		drbd_rs_failed_io(mdev, sector, e->i.size);
+		drbd_rs_failed_io(mdev, sector, peer_req->i.size);
 
-		ok  = drbd_send_ack(mdev, P_NEG_ACK, e);
+		ok  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 	}
 	dec_unacked(mdev);
 
@@ -1471,10 +1471,10 @@ static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int u
 
 static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_size) __releases(local)
 {
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 
-	e = read_in_block(mdev, ID_SYNCER, sector, data_size);
-	if (!e)
+	peer_req = read_in_block(mdev, ID_SYNCER, sector, data_size);
+	if (!peer_req)
 		goto fail;
 
 	dec_rs_pending(mdev);
@@ -1483,23 +1483,23 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 	/* corresponding dec_unacked() in e_end_resync_block()
 	 * respective _drbd_clear_done_ee */
 
-	e->w.cb = e_end_resync_block;
+	peer_req->w.cb = e_end_resync_block;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add(&e->w.list, &mdev->sync_ee);
+	list_add(&peer_req->w.list, &mdev->sync_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	atomic_add(data_size >> 9, &mdev->rs_sect_ev);
-	if (drbd_submit_ee(mdev, e, WRITE, DRBD_FAULT_RS_WR) == 0)
+	if (drbd_submit_ee(mdev, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
 		return true;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_del(&e->w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	drbd_free_ee(mdev, e);
+	drbd_free_ee(mdev, peer_req);
 fail:
 	put_ldev(mdev);
 	return false;
@@ -1586,21 +1586,21 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
  */
 static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
-	sector_t sector = e->i.sector;
+	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
+	sector_t sector = peer_req->i.sector;
 	int ok = 1, pcmd;
 
 	if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C) {
-		if (likely((e->flags & EE_WAS_ERROR) == 0)) {
+		if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 			pcmd = (mdev->state.conn >= C_SYNC_SOURCE &&
 				mdev->state.conn <= C_PAUSED_SYNC_T &&
-				e->flags & EE_MAY_SET_IN_SYNC) ?
+				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			ok &= drbd_send_ack(mdev, pcmd, e);
+			ok &= drbd_send_ack(mdev, pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
-				drbd_set_in_sync(mdev, sector, e->i.size);
+				drbd_set_in_sync(mdev, sector, peer_req->i.size);
 		} else {
-			ok  = drbd_send_ack(mdev, P_NEG_ACK, e);
+			ok  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
@@ -1610,28 +1610,28 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (mdev->tconn->net_conf->two_primaries) {
 		spin_lock_irq(&mdev->tconn->req_lock);
-		D_ASSERT(!drbd_interval_empty(&e->i));
-		drbd_remove_epoch_entry_interval(mdev, e);
+		D_ASSERT(!drbd_interval_empty(&peer_req->i));
+		drbd_remove_epoch_entry_interval(mdev, peer_req);
 		spin_unlock_irq(&mdev->tconn->req_lock);
 	} else
-		D_ASSERT(drbd_interval_empty(&e->i));
+		D_ASSERT(drbd_interval_empty(&peer_req->i));
 
-	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
+	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
 	return ok;
 }
 
 static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 {
-	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
+	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
 	int ok = 1;
 
 	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
-	ok = drbd_send_ack(mdev, P_DISCARD_ACK, e);
+	ok = drbd_send_ack(mdev, P_DISCARD_ACK, peer_req);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	D_ASSERT(!drbd_interval_empty(&e->i));
-	drbd_remove_epoch_entry_interval(mdev, e);
+	D_ASSERT(!drbd_interval_empty(&peer_req->i));
+	drbd_remove_epoch_entry_interval(mdev, peer_req);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	dec_unacked(mdev);
@@ -1735,7 +1735,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			unsigned int data_size)
 {
 	sector_t sector;
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 	struct p_data *p = &mdev->tconn->data.rbuf.data;
 	int rw = WRITE;
 	u32 dp_flags;
@@ -1757,24 +1757,24 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	 * the end of this function. */
 
 	sector = be64_to_cpu(p->sector);
-	e = read_in_block(mdev, p->block_id, sector, data_size);
-	if (!e) {
+	peer_req = read_in_block(mdev, p->block_id, sector, data_size);
+	if (!peer_req) {
 		put_ldev(mdev);
 		return false;
 	}
 
-	e->w.cb = e_end_block;
+	peer_req->w.cb = e_end_block;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
 	rw |= wire_flags_to_bio(mdev, dp_flags);
 
 	if (dp_flags & DP_MAY_SET_IN_SYNC)
-		e->flags |= EE_MAY_SET_IN_SYNC;
+		peer_req->flags |= EE_MAY_SET_IN_SYNC;
 
 	spin_lock(&mdev->epoch_lock);
-	e->epoch = mdev->current_epoch;
-	atomic_inc(&e->epoch->epoch_size);
-	atomic_inc(&e->epoch->active);
+	peer_req->epoch = mdev->current_epoch;
+	atomic_inc(&peer_req->epoch->epoch_size);
+	atomic_inc(&peer_req->epoch->active);
 	spin_unlock(&mdev->epoch_lock);
 
 	/* I'm the receiver, I do hold a net_cnt reference. */
@@ -1783,7 +1783,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	} else {
 		/* don't get the req_lock yet,
 		 * we may sleep in drbd_wait_peer_seq */
-		const int size = e->i.size;
+		const int size = peer_req->i.size;
 		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->flags);
 		DEFINE_WAIT(wait);
 		int first;
@@ -1860,8 +1860,8 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 				dev_alert(DEV, "Concurrent write! [DISCARD BY FLAG] sec=%llus\n",
 				     (unsigned long long)sector);
 				inc_unacked(mdev);
-				e->w.cb = e_send_discard_ack;
-				list_add_tail(&e->w.list, &mdev->done_ee);
+				peer_req->w.cb = e_send_discard_ack;
+				list_add_tail(&peer_req->w.list, &mdev->done_ee);
 
 				spin_unlock_irq(&mdev->tconn->req_lock);
 
@@ -1898,10 +1898,10 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		}
 		finish_wait(&mdev->misc_wait, &wait);
 
-		drbd_insert_interval(&mdev->write_requests, &e->i);
+		drbd_insert_interval(&mdev->write_requests, &peer_req->i);
 	}
 
-	list_add(&e->w.list, &mdev->active_ee);
+	list_add(&peer_req->w.list, &mdev->active_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	switch (mdev->tconn->net_conf->wire_protocol) {
@@ -1913,7 +1913,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	case DRBD_PROT_B:
 		/* I really don't like it that the receiver thread
 		 * sends on the msock, but anyways */
-		drbd_send_ack(mdev, P_RECV_ACK, e);
+		drbd_send_ack(mdev, P_RECV_ACK, peer_req);
 		break;
 	case DRBD_PROT_A:
 		/* nothing to do */
@@ -1922,28 +1922,28 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	if (mdev->state.pdsk < D_INCONSISTENT) {
 		/* In case we have the only disk of the cluster, */
-		drbd_set_out_of_sync(mdev, e->i.sector, e->i.size);
-		e->flags |= EE_CALL_AL_COMPLETE_IO;
-		e->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(mdev, e->i.sector);
+		drbd_set_out_of_sync(mdev, peer_req->i.sector, peer_req->i.size);
+		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
+		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
+		drbd_al_begin_io(mdev, peer_req->i.sector);
 	}
 
-	if (drbd_submit_ee(mdev, e, rw, DRBD_FAULT_DT_WR) == 0)
+	if (drbd_submit_ee(mdev, peer_req, rw, DRBD_FAULT_DT_WR) == 0)
 		return true;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_del(&e->w.list);
-	drbd_remove_epoch_entry_interval(mdev, e);
+	list_del(&peer_req->w.list);
+	drbd_remove_epoch_entry_interval(mdev, peer_req);
 	spin_unlock_irq(&mdev->tconn->req_lock);
-	if (e->flags & EE_CALL_AL_COMPLETE_IO)
-		drbd_al_complete_io(mdev, e->i.sector);
+	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
+		drbd_al_complete_io(mdev, peer_req->i.sector);
 
 out_interrupted:
-	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + EV_CLEANUP);
+	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + EV_CLEANUP);
 	put_ldev(mdev);
-	drbd_free_ee(mdev, e);
+	drbd_free_ee(mdev, peer_req);
 	return false;
 }
 
@@ -2019,7 +2019,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
@@ -2070,21 +2070,21 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	e = drbd_alloc_ee(mdev, p->block_id, sector, size, GFP_NOIO);
-	if (!e) {
+	peer_req = drbd_alloc_ee(mdev, p->block_id, sector, size, GFP_NOIO);
+	if (!peer_req) {
 		put_ldev(mdev);
 		return false;
 	}
 
 	switch (cmd) {
 	case P_DATA_REQUEST:
-		e->w.cb = w_e_end_data_req;
+		peer_req->w.cb = w_e_end_data_req;
 		fault_type = DRBD_FAULT_DT_RD;
 		/* application IO, don't drbd_rs_begin_io */
 		goto submit;
 
 	case P_RS_DATA_REQUEST:
-		e->w.cb = w_e_end_rsdata_req;
+		peer_req->w.cb = w_e_end_rsdata_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		/* used in the sector offset progress display */
 		mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2100,21 +2100,21 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 		di->digest_size = digest_size;
 		di->digest = (((char *)di)+sizeof(struct digest_info));
 
-		e->digest = di;
-		e->flags |= EE_HAS_DIGEST;
+		peer_req->digest = di;
+		peer_req->flags |= EE_HAS_DIGEST;
 
 		if (drbd_recv(mdev, di->digest, digest_size) != digest_size)
 			goto out_free_e;
 
 		if (cmd == P_CSUM_RS_REQUEST) {
 			D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
-			e->w.cb = w_e_end_csum_rs_req;
+			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
 		} else if (cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
 			atomic_add(size >> 9, &mdev->rs_sect_in);
-			e->w.cb = w_e_end_ov_reply;
+			peer_req->w.cb = w_e_end_ov_reply;
 			dec_rs_pending(mdev);
 			/* drbd_rs_begin_io done when we sent this request,
 			 * but accounting still needs to be done. */
@@ -2138,7 +2138,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 			dev_info(DEV, "Online Verify start sector: %llu\n",
 					(unsigned long long)sector);
 		}
-		e->w.cb = w_e_end_ov_req;
+		peer_req->w.cb = w_e_end_ov_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		break;
 
@@ -2182,22 +2182,22 @@ submit_for_resync:
 submit:
 	inc_unacked(mdev);
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add_tail(&e->w.list, &mdev->read_ee);
+	list_add_tail(&peer_req->w.list, &mdev->read_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	if (drbd_submit_ee(mdev, e, READ, fault_type) == 0)
+	if (drbd_submit_ee(mdev, peer_req, READ, fault_type) == 0)
 		return true;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_del(&e->w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
 	put_ldev(mdev);
-	drbd_free_ee(mdev, e);
+	drbd_free_ee(mdev, peer_req);
 	return false;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 06628d1..f13d56c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -80,47 +80,47 @@ void drbd_md_io_complete(struct bio *bio, int error)
 /* reads on behalf of the partner,
  * "submitted" by the receiver
  */
-void drbd_endio_read_sec_final(struct drbd_peer_request *e) __releases(local)
+void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = e->mdev;
+	struct drbd_conf *mdev = peer_req->mdev;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	mdev->read_cnt += e->i.size >> 9;
-	list_del(&e->w.list);
+	mdev->read_cnt += peer_req->i.size >> 9;
+	list_del(&peer_req->w.list);
 	if (list_empty(&mdev->read_ee))
 		wake_up(&mdev->ee_wait);
-	if (test_bit(__EE_WAS_ERROR, &e->flags))
+	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(mdev, false);
 	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
-	drbd_queue_work(&mdev->tconn->data.work, &e->w);
+	drbd_queue_work(&mdev->tconn->data.work, &peer_req->w);
 	put_ldev(mdev);
 }
 
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver, final stage.  */
-static void drbd_endio_write_sec_final(struct drbd_peer_request *e) __releases(local)
+static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = e->mdev;
+	struct drbd_conf *mdev = peer_req->mdev;
 	sector_t e_sector;
 	int do_wake;
 	u64 block_id;
 	int do_al_complete_io;
 
-	/* after we moved e to done_ee,
+	/* after we moved peer_req to done_ee,
 	 * we may no longer access it,
 	 * it may be freed/reused already!
 	 * (as soon as we release the req_lock) */
-	e_sector = e->i.sector;
-	do_al_complete_io = e->flags & EE_CALL_AL_COMPLETE_IO;
-	block_id = e->block_id;
+	e_sector = peer_req->i.sector;
+	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
+	block_id = peer_req->block_id;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	mdev->writ_cnt += e->i.size >> 9;
-	list_del(&e->w.list); /* has been on active_ee or sync_ee */
-	list_add_tail(&e->w.list, &mdev->done_ee);
+	mdev->writ_cnt += peer_req->i.size >> 9;
+	list_del(&peer_req->w.list); /* has been on active_ee or sync_ee */
+	list_add_tail(&peer_req->w.list, &mdev->done_ee);
 
 	/*
 	 * Do not remove from the write_requests tree here: we did not send the
@@ -132,7 +132,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *e) __releases(l
 
 	do_wake = list_empty(block_id == ID_SYNCER ? &mdev->sync_ee : &mdev->active_ee);
 
-	if (test_bit(__EE_WAS_ERROR, &e->flags))
+	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(mdev, false);
 	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
@@ -154,20 +154,20 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *e) __releases(l
  */
 void drbd_endio_sec(struct bio *bio, int error)
 {
-	struct drbd_peer_request *e = bio->bi_private;
-	struct drbd_conf *mdev = e->mdev;
+	struct drbd_peer_request *peer_req = bio->bi_private;
+	struct drbd_conf *mdev = peer_req->mdev;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
 	if (error && __ratelimit(&drbd_ratelimit_state))
 		dev_warn(DEV, "%s: error=%d s=%llus\n",
 				is_write ? "write" : "read", error,
-				(unsigned long long)e->i.sector);
+				(unsigned long long)peer_req->i.sector);
 	if (!error && !uptodate) {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_warn(DEV, "%s: setting error to -EIO s=%llus\n",
 					is_write ? "write" : "read",
-					(unsigned long long)e->i.sector);
+					(unsigned long long)peer_req->i.sector);
 		/* strange behavior of some lower level drivers...
 		 * fail the request by clearing the uptodate flag,
 		 * but do not return any error?! */
@@ -175,14 +175,14 @@ void drbd_endio_sec(struct bio *bio, int error)
 	}
 
 	if (error)
-		set_bit(__EE_WAS_ERROR, &e->flags);
+		set_bit(__EE_WAS_ERROR, &peer_req->flags);
 
 	bio_put(bio); /* no need for the bio anymore */
-	if (atomic_dec_and_test(&e->pending_bios)) {
+	if (atomic_dec_and_test(&peer_req->pending_bios)) {
 		if (is_write)
-			drbd_endio_write_sec_final(e);
+			drbd_endio_write_sec_final(peer_req);
 		else
-			drbd_endio_read_sec_final(e);
+			drbd_endio_read_sec_final(peer_req);
 	}
 }
 
@@ -248,11 +248,11 @@ int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 }
 
 void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
-		  struct drbd_peer_request *e, void *digest)
+		  struct drbd_peer_request *peer_req, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
-	struct page *page = e->pages;
+	struct page *page = peer_req->pages;
 	struct page *tmp;
 	unsigned len;
 
@@ -269,7 +269,7 @@ void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
 		page = tmp;
 	}
 	/* and now the last, possibly only partially used page */
-	len = e->i.size & (PAGE_SIZE - 1);
+	len = peer_req->i.size & (PAGE_SIZE - 1);
 	sg_set_page(&sg, page, len ?: PAGE_SIZE, 0);
 	crypto_hash_update(&desc, &sg, sg.length);
 	crypto_hash_final(&desc, digest);
@@ -298,7 +298,8 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 /* TODO merge common code with w_e_end_ov_req */
 int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req =
+		container_of(w, struct drbd_peer_request, w);
 	int digest_size;
 	void *digest;
 	int ok = 1;
@@ -306,22 +307,22 @@ int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	if (likely((e->flags & EE_WAS_ERROR) != 0))
+	if (likely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
 	digest_size = crypto_hash_digestsize(mdev->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
-		sector_t sector = e->i.sector;
-		unsigned int size = e->i.size;
-		drbd_csum_ee(mdev, mdev->csums_tfm, e, digest);
+		sector_t sector = peer_req->i.sector;
+		unsigned int size = peer_req->i.size;
+		drbd_csum_ee(mdev, mdev->csums_tfm, peer_req, digest);
 		/* Free e and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
 		 * congestion as well, because our receiver blocks in
 		 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-		drbd_free_ee(mdev, e);
-		e = NULL;
+		drbd_free_ee(mdev, peer_req);
+		peer_req = NULL;
 		inc_rs_pending(mdev);
 		ok = drbd_send_drequest_csum(mdev, sector, size,
 					     digest, digest_size,
@@ -333,8 +334,8 @@ int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	}
 
 out:
-	if (e)
-		drbd_free_ee(mdev, e);
+	if (peer_req)
+		drbd_free_ee(mdev, peer_req);
 
 	if (unlikely(!ok))
 		dev_err(DEV, "drbd_send_drequest(..., csum) failed\n");
@@ -345,7 +346,7 @@ out:
 
 static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 {
-	struct drbd_peer_request *e;
+	struct drbd_peer_request *peer_req;
 
 	if (!get_ldev(mdev))
 		return -EIO;
@@ -355,17 +356,17 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
-	e = drbd_alloc_ee(mdev, ID_SYNCER /* unused */, sector, size, GFP_TRY);
-	if (!e)
+	peer_req = drbd_alloc_ee(mdev, ID_SYNCER /* unused */, sector, size, GFP_TRY);
+	if (!peer_req)
 		goto defer;
 
-	e->w.cb = w_e_send_csum;
+	peer_req->w.cb = w_e_send_csum;
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add(&e->w.list, &mdev->read_ee);
+	list_add(&peer_req->w.list, &mdev->read_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	atomic_add(size >> 9, &mdev->rs_sect_ev);
-	if (drbd_submit_ee(mdev, e, READ, DRBD_FAULT_RS_RD) == 0)
+	if (drbd_submit_ee(mdev, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
 		return 0;
 
 	/* If it failed because of ENOMEM, retry should help.  If it failed
@@ -373,10 +374,10 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
 	spin_lock_irq(&mdev->tconn->req_lock);
-	list_del(&e->w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	drbd_free_ee(mdev, e);
+	drbd_free_ee(mdev, peer_req);
 defer:
 	put_ldev(mdev);
 	return -EAGAIN;
@@ -901,19 +902,19 @@ out:
 }
 
 /* helper */
-static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_request *e)
+static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_request *peer_req)
 {
-	if (drbd_ee_has_active_page(e)) {
+	if (drbd_ee_has_active_page(peer_req)) {
 		/* This might happen if sendpage() has not finished */
-		int i = (e->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
+		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &mdev->pp_in_use_by_net);
 		atomic_sub(i, &mdev->pp_in_use);
 		spin_lock_irq(&mdev->tconn->req_lock);
-		list_add_tail(&e->w.list, &mdev->net_ee);
+		list_add_tail(&peer_req->w.list, &mdev->net_ee);
 		spin_unlock_irq(&mdev->tconn->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
-		drbd_free_ee(mdev, e);
+		drbd_free_ee(mdev, peer_req);
 }
 
 /**
@@ -924,28 +925,28 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
  */
 int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	int ok;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, e);
+		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
 		return 1;
 	}
 
-	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
-		ok = drbd_send_block(mdev, P_DATA_REPLY, e);
+	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
+		ok = drbd_send_block(mdev, P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
-			    (unsigned long long)e->i.sector);
+			    (unsigned long long)peer_req->i.sector);
 
-		ok = drbd_send_ack(mdev, P_NEG_DREPLY, e);
+		ok = drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
 	}
 
 	dec_unacked(mdev);
 
-	move_to_net_ee_or_free(mdev, e);
+	move_to_net_ee_or_free(mdev, peer_req);
 
 	if (unlikely(!ok))
 		dev_err(DEV, "drbd_send_block() failed\n");
@@ -960,26 +961,26 @@ int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
  */
 int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	int ok;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, e);
+		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
 		return 1;
 	}
 
 	if (get_ldev_if_state(mdev, D_FAILED)) {
-		drbd_rs_complete_io(mdev, e->i.sector);
+		drbd_rs_complete_io(mdev, peer_req->i.sector);
 		put_ldev(mdev);
 	}
 
 	if (mdev->state.conn == C_AHEAD) {
-		ok = drbd_send_ack(mdev, P_RS_CANCEL, e);
-	} else if (likely((e->flags & EE_WAS_ERROR) == 0)) {
+		ok = drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
+	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		if (likely(mdev->state.pdsk >= D_INCONSISTENT)) {
 			inc_rs_pending(mdev);
-			ok = drbd_send_block(mdev, P_RS_DATA_REPLY, e);
+			ok = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
 				dev_err(DEV, "Not sending RSDataReply, "
@@ -989,17 +990,17 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
-			    (unsigned long long)e->i.sector);
+			    (unsigned long long)peer_req->i.sector);
 
-		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, e);
+		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
-		drbd_rs_failed_io(mdev, e->i.sector, e->i.size);
+		drbd_rs_failed_io(mdev, peer_req->i.sector, peer_req->i.size);
 	}
 
 	dec_unacked(mdev);
 
-	move_to_net_ee_or_free(mdev, e);
+	move_to_net_ee_or_free(mdev, peer_req);
 
 	if (unlikely(!ok))
 		dev_err(DEV, "drbd_send_block() failed\n");
@@ -1008,26 +1009,26 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 
 int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
 	int ok, eq = 0;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, e);
+		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
 		return 1;
 	}
 
 	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, e->i.sector);
+		drbd_rs_complete_io(mdev, peer_req->i.sector);
 		put_ldev(mdev);
 	}
 
-	di = e->digest;
+	di = peer_req->digest;
 
-	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
+	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
@@ -1037,31 +1038,31 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->csums_tfm, e, digest);
+			drbd_csum_ee(mdev, mdev->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
 
 		if (eq) {
-			drbd_set_in_sync(mdev, e->i.sector, e->i.size);
+			drbd_set_in_sync(mdev, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
-			mdev->rs_same_csum += e->i.size >> BM_BLOCK_SHIFT;
-			ok = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, e);
+			mdev->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
+			ok = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
 		} else {
 			inc_rs_pending(mdev);
-			e->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
-			e->flags &= ~EE_HAS_DIGEST; /* This e no longer has a digest pointer */
+			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
+			peer_req->flags &= ~EE_HAS_DIGEST; /* This peer request no longer has a digest pointer */
 			kfree(di);
-			ok = drbd_send_block(mdev, P_RS_DATA_REPLY, e);
+			ok = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, e);
+		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. I guess it gets messy.\n");
 	}
 
 	dec_unacked(mdev);
-	move_to_net_ee_or_free(mdev, e);
+	move_to_net_ee_or_free(mdev, peer_req);
 
 	if (unlikely(!ok))
 		dev_err(DEV, "drbd_send_block/ack() failed\n");
@@ -1071,9 +1072,9 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 /* TODO merge common code with w_e_send_csum */
 int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
-	sector_t sector = e->i.sector;
-	unsigned int size = e->i.size;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	sector_t sector = peer_req->i.sector;
+	unsigned int size = peer_req->i.size;
 	int digest_size;
 	void *digest;
 	int ok = 1;
@@ -1088,8 +1089,8 @@ int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		goto out;
 	}
 
-	if (likely(!(e->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(mdev, mdev->verify_tfm, e, digest);
+	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
+		drbd_csum_ee(mdev, mdev->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1098,8 +1099,8 @@ int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * some distributed deadlock, if the other side blocks on
 	 * congestion as well, because our receiver blocks in
 	 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-	drbd_free_ee(mdev, e);
-	e = NULL;
+	drbd_free_ee(mdev, peer_req);
+	peer_req = NULL;
 	inc_rs_pending(mdev);
 	ok = drbd_send_drequest_csum(mdev, sector, size,
 				     digest, digest_size,
@@ -1109,8 +1110,8 @@ int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	kfree(digest);
 
 out:
-	if (e)
-		drbd_free_ee(mdev, e);
+	if (peer_req)
+		drbd_free_ee(mdev, peer_req);
 	dec_unacked(mdev);
 	return ok;
 }
@@ -1128,16 +1129,16 @@ void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
 
 int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct digest_info *di;
 	void *digest;
-	sector_t sector = e->i.sector;
-	unsigned int size = e->i.size;
+	sector_t sector = peer_req->i.sector;
+	unsigned int size = peer_req->i.size;
 	int digest_size;
 	int ok, eq = 0;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, e);
+		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
 		return 1;
 	}
@@ -1145,17 +1146,17 @@ int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	/* after "cancel", because after drbd_disconnect/drbd_rs_cancel_all
 	 * the resync lru has been cleaned up already */
 	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, e->i.sector);
+		drbd_rs_complete_io(mdev, peer_req->i.sector);
 		put_ldev(mdev);
 	}
 
-	di = e->digest;
+	di = peer_req->digest;
 
-	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
+	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		digest_size = crypto_hash_digestsize(mdev->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->verify_tfm, e, digest);
+			drbd_csum_ee(mdev, mdev->verify_tfm, peer_req, digest);
 
 			D_ASSERT(digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1168,7 +1169,7 @@ int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		 * some distributed deadlock, if the other side blocks on
 		 * congestion as well, because our receiver blocks in
 		 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-	drbd_free_ee(mdev, e);
+	drbd_free_ee(mdev, peer_req);
 	if (!eq)
 		drbd_ov_oos_found(mdev, sector, size);
 	else
-- 
1.7.4.1

