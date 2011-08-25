Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1HYPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:35:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32954 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HYPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 018/118] drbd: Put sector and size in struct drbd_epoch_entry into struct drbd_interval
Date: Thu, 25 Aug 2011 17:07:14 +0200
Message-Id: <1314284934-17999-19-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    3 +-
 drivers/block/drbd/drbd_main.c     |   14 ++++++------
 drivers/block/drbd/drbd_nl.c       |    6 ++--
 drivers/block/drbd/drbd_receiver.c |   28 ++++++++++++------------
 drivers/block/drbd/drbd_req.c      |    6 ++--
 drivers/block/drbd/drbd_worker.c   |   42 ++++++++++++++++++------------------
 6 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index fe15319..94b4f6e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -764,10 +764,9 @@ struct drbd_epoch_entry {
 	struct drbd_conf *mdev;
 	struct page *pages;
 	atomic_t pending_bios;
-	unsigned int size;
+	struct drbd_interval i;
 	/* see comments on ee flag bits below */
 	unsigned long flags;
-	sector_t sector;
 	union {
 		u64 block_id;
 		struct digest_info *digest;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c0ea5ba..0033137 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2464,8 +2464,8 @@ int drbd_send_ack(struct drbd_conf *mdev,
 	enum drbd_packets cmd, struct drbd_epoch_entry *e)
 {
 	return _drbd_send_ack(mdev, cmd,
-			      cpu_to_be64(e->sector),
-			      cpu_to_be32(e->size),
+			      cpu_to_be64(e->i.sector),
+			      cpu_to_be32(e->i.size),
 			      e->block_id);
 }
 
@@ -2671,7 +2671,7 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 static int _drbd_send_zc_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e)
 {
 	struct page *page = e->pages;
-	unsigned len = e->size;
+	unsigned len = e->i.size;
 	/* hint all but last page with MSG_MORE */
 	page_chain_for_each(page) {
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
@@ -2796,19 +2796,19 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
-	if (e->size <= DRBD_MAX_SIZE_H80_PACKET) {
+	if (e->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
 		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
 		p.head.h80.command = cpu_to_be16(cmd);
 		p.head.h80.length  =
-			cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + dgs + e->size);
+			cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
 	} else {
 		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 		p.head.h95.command = cpu_to_be16(cmd);
 		p.head.h95.length  =
-			cpu_to_be32(sizeof(p) - sizeof(struct p_header80) + dgs + e->size);
+			cpu_to_be32(sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
 	}
 
-	p.sector   = cpu_to_be64(e->sector);
+	p.sector   = cpu_to_be64(e->i.sector);
 	p.block_id = e->block_id;
 	/* p.seq_num  = 0;    No sequence numbers here.. */
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 515bcd9..98c0e9b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2506,7 +2506,7 @@ void drbd_bcast_ee(struct drbd_conf *mdev,
 
 	if (!cn_reply) {
 		dev_err(DEV, "could not kmalloc buffer for drbd_bcast_ee, sector %llu, size %u\n",
-				(unsigned long long)e->sector, e->size);
+				(unsigned long long)e->i.sector, e->i.size);
 		return;
 	}
 
@@ -2516,11 +2516,11 @@ void drbd_bcast_ee(struct drbd_conf *mdev,
 	tl = tl_add_str(tl, T_dump_ee_reason, reason);
 	tl = tl_add_blob(tl, T_seen_digest, seen_hash, dgs);
 	tl = tl_add_blob(tl, T_calc_digest, calc_hash, dgs);
-	tl = tl_add_int(tl, T_ee_sector, &e->sector);
+	tl = tl_add_int(tl, T_ee_sector, &e->i.sector);
 	tl = tl_add_int(tl, T_ee_block_id, &e->block_id);
 
 	/* dump the first 32k */
-	len = min_t(unsigned, e->size, 32 << 10);
+	len = min_t(unsigned, e->i.size, 32 << 10);
 	put_unaligned(T_ee_data, tl++);
 	put_unaligned(len, tl++);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b148398..42c0ffa 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -338,9 +338,9 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	e->mdev = mdev;
 	e->pages = page;
 	atomic_set(&e->pending_bios, 0);
-	e->size = data_size;
+	e->i.size = data_size;
 	e->flags = 0;
-	e->sector = sector;
+	e->i.sector = sector;
 	/*
 	 * The block_id is opaque to the receiver.  It is not endianness
 	 * converted, and sent back to the sender unchanged.
@@ -1091,8 +1091,8 @@ int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e,
 	struct bio *bios = NULL;
 	struct bio *bio;
 	struct page *page = e->pages;
-	sector_t sector = e->sector;
-	unsigned ds = e->size;
+	sector_t sector = e->i.sector;
+	unsigned ds = e->i.size;
 	unsigned n_bios = 0;
 	unsigned nr_pages = (ds + PAGE_SIZE -1) >> PAGE_SHIFT;
 	int err = -ENOMEM;
@@ -1107,7 +1107,7 @@ next_bio:
 		dev_err(DEV, "submit_ee: Allocation of a bio failed\n");
 		goto fail;
 	}
-	/* > e->sector, unless this is the first bio */
+	/* > e->i.sector, unless this is the first bio */
 	bio->bi_sector = sector;
 	bio->bi_bdev = mdev->ldev->backing_bdev;
 	bio->bi_rw = rw;
@@ -1414,17 +1414,17 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 {
 	struct drbd_epoch_entry *e = (struct drbd_epoch_entry *)w;
-	sector_t sector = e->sector;
+	sector_t sector = e->i.sector;
 	int ok;
 
 	D_ASSERT(hlist_unhashed(&e->collision));
 
 	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
-		drbd_set_in_sync(mdev, sector, e->size);
+		drbd_set_in_sync(mdev, sector, e->i.size);
 		ok = drbd_send_ack(mdev, P_RS_WRITE_ACK, e);
 	} else {
 		/* Record failure to sync */
-		drbd_rs_failed_io(mdev, sector, e->size);
+		drbd_rs_failed_io(mdev, sector, e->i.size);
 
 		ok  = drbd_send_ack(mdev, P_NEG_ACK, e);
 	}
@@ -1549,7 +1549,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packets cmd, un
 static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
 	struct drbd_epoch_entry *e = (struct drbd_epoch_entry *)w;
-	sector_t sector = e->sector;
+	sector_t sector = e->i.sector;
 	int ok = 1, pcmd;
 
 	if (mdev->net_conf->wire_protocol == DRBD_PROT_C) {
@@ -1560,7 +1560,7 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 				P_RS_WRITE_ACK : P_WRITE_ACK;
 			ok &= drbd_send_ack(mdev, pcmd, e);
 			if (pcmd == P_RS_WRITE_ACK)
-				drbd_set_in_sync(mdev, sector, e->size);
+				drbd_set_in_sync(mdev, sector, e->i.size);
 		} else {
 			ok  = drbd_send_ack(mdev, P_NEG_ACK, e);
 			/* we expect it to be marked out of sync anyways...
@@ -1718,7 +1718,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	} else {
 		/* don't get the req_lock yet,
 		 * we may sleep in drbd_wait_peer_seq */
-		const int size = e->size;
+		const int size = e->i.size;
 		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->flags);
 		DEFINE_WAIT(wait);
 		int first;
@@ -1861,10 +1861,10 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 	if (mdev->state.pdsk < D_INCONSISTENT) {
 		/* In case we have the only disk of the cluster, */
-		drbd_set_out_of_sync(mdev, e->sector, e->size);
+		drbd_set_out_of_sync(mdev, e->i.sector, e->i.size);
 		e->flags |= EE_CALL_AL_COMPLETE_IO;
 		e->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(mdev, e->sector);
+		drbd_al_begin_io(mdev, e->i.sector);
 	}
 
 	if (drbd_submit_ee(mdev, e, rw, DRBD_FAULT_DT_WR) == 0)
@@ -1877,7 +1877,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	hlist_del_init(&e->collision);
 	spin_unlock_irq(&mdev->req_lock);
 	if (e->flags & EE_CALL_AL_COMPLETE_IO)
-		drbd_al_complete_io(mdev, e->sector);
+		drbd_al_complete_io(mdev, e->i.sector);
 
 out_interrupted:
 	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + EV_CLEANUP);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index d2a78c4..5bf93a7 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -185,7 +185,7 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		 *
 		 * anyways, if we found one,
 		 * we just have to do a wake_up.  */
-#define OVERLAPS overlaps(sector, size, e->sector, e->size)
+#define OVERLAPS overlaps(sector, size, e->i.sector, e->i.size)
 		slot = ee_hash_slot(mdev, req->i.sector);
 		hlist_for_each_entry(e, n, slot, collision) {
 			if (OVERLAPS) {
@@ -364,7 +364,7 @@ static int _req_conflicts(struct drbd_request *req)
 	if (mdev->ee_hash_s) {
 		/* now, check for overlapping requests with remote origin */
 		BUG_ON(mdev->ee_hash == NULL);
-#define OVERLAPS overlaps(e->sector, e->size, sector, size)
+#define OVERLAPS overlaps(e->i.sector, e->i.size, sector, size)
 		slot = ee_hash_slot(mdev, sector);
 		hlist_for_each_entry(e, n, slot, collision) {
 			if (OVERLAPS) {
@@ -373,7 +373,7 @@ static int _req_conflicts(struct drbd_request *req)
 				      "pending: %llus +%u\n",
 				      current->comm, current->pid,
 				      (unsigned long long)sector, size,
-				      (unsigned long long)e->sector, e->size);
+				      (unsigned long long)e->i.sector, e->i.size);
 				goto out_conflict;
 			}
 		}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a1eff6e..2b83aaf 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -86,7 +86,7 @@ void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
 	struct drbd_conf *mdev = e->mdev;
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
-	mdev->read_cnt += e->size >> 9;
+	mdev->read_cnt += e->i.size >> 9;
 	list_del(&e->w.list);
 	if (list_empty(&mdev->read_ee))
 		wake_up(&mdev->ee_wait);
@@ -113,12 +113,12 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	 * we may no longer access it,
 	 * it may be freed/reused already!
 	 * (as soon as we release the req_lock) */
-	e_sector = e->sector;
+	e_sector = e->i.sector;
 	do_al_complete_io = e->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = e->block_id;
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
-	mdev->writ_cnt += e->size >> 9;
+	mdev->writ_cnt += e->i.size >> 9;
 	list_del(&e->w.list); /* has been on active_ee or sync_ee */
 	list_add_tail(&e->w.list, &mdev->done_ee);
 
@@ -159,12 +159,12 @@ void drbd_endio_sec(struct bio *bio, int error)
 	if (error && __ratelimit(&drbd_ratelimit_state))
 		dev_warn(DEV, "%s: error=%d s=%llus\n",
 				is_write ? "write" : "read", error,
-				(unsigned long long)e->sector);
+				(unsigned long long)e->i.sector);
 	if (!error && !uptodate) {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_warn(DEV, "%s: setting error to -EIO s=%llus\n",
 					is_write ? "write" : "read",
-					(unsigned long long)e->sector);
+					(unsigned long long)e->i.sector);
 		/* strange behavior of some lower level drivers...
 		 * fail the request by clearing the uptodate flag,
 		 * but do not return any error?! */
@@ -265,7 +265,7 @@ void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm, struct drbd_e
 		page = tmp;
 	}
 	/* and now the last, possibly only partially used page */
-	len = e->size & (PAGE_SIZE - 1);
+	len = e->i.size & (PAGE_SIZE - 1);
 	sg_set_page(&sg, page, len ?: PAGE_SIZE, 0);
 	crypto_hash_update(&desc, &sg, sg.length);
 	crypto_hash_final(&desc, digest);
@@ -308,8 +308,8 @@ int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	digest_size = crypto_hash_digestsize(mdev->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
-		sector_t sector = e->sector;
-		unsigned int size = e->size;
+		sector_t sector = e->i.sector;
+		unsigned int size = e->i.size;
 		drbd_csum_ee(mdev, mdev->csums_tfm, e, digest);
 		/* Free e and pages before send.
 		 * In case we block on congestion, we could otherwise run into
@@ -901,7 +901,7 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_epoch_ent
 {
 	if (drbd_ee_has_active_page(e)) {
 		/* This might happen if sendpage() has not finished */
-		int i = (e->size + PAGE_SIZE -1) >> PAGE_SHIFT;
+		int i = (e->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &mdev->pp_in_use_by_net);
 		atomic_sub(i, &mdev->pp_in_use);
 		spin_lock_irq(&mdev->req_lock);
@@ -934,7 +934,7 @@ int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
-			    (unsigned long long)e->sector);
+			    (unsigned long long)e->i.sector);
 
 		ok = drbd_send_ack(mdev, P_NEG_DREPLY, e);
 	}
@@ -966,7 +966,7 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	}
 
 	if (get_ldev_if_state(mdev, D_FAILED)) {
-		drbd_rs_complete_io(mdev, e->sector);
+		drbd_rs_complete_io(mdev, e->i.sector);
 		put_ldev(mdev);
 	}
 
@@ -985,12 +985,12 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
-			    (unsigned long long)e->sector);
+			    (unsigned long long)e->i.sector);
 
 		ok = drbd_send_ack(mdev, P_NEG_RS_DREPLY, e);
 
 		/* update resync data with failure */
-		drbd_rs_failed_io(mdev, e->sector, e->size);
+		drbd_rs_failed_io(mdev, e->i.sector, e->i.size);
 	}
 
 	dec_unacked(mdev);
@@ -1017,7 +1017,7 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	}
 
 	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, e->sector);
+		drbd_rs_complete_io(mdev, e->i.sector);
 		put_ldev(mdev);
 	}
 
@@ -1039,9 +1039,9 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		}
 
 		if (eq) {
-			drbd_set_in_sync(mdev, e->sector, e->size);
+			drbd_set_in_sync(mdev, e->i.sector, e->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
-			mdev->rs_same_csum += e->size >> BM_BLOCK_SHIFT;
+			mdev->rs_same_csum += e->i.size >> BM_BLOCK_SHIFT;
 			ok = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, e);
 		} else {
 			inc_rs_pending(mdev);
@@ -1068,8 +1068,8 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
 	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
-	sector_t sector = e->sector;
-	unsigned int size = e->size;
+	sector_t sector = e->i.sector;
+	unsigned int size = e->i.size;
 	int digest_size;
 	void *digest;
 	int ok = 1;
@@ -1127,8 +1127,8 @@ int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
 	struct digest_info *di;
 	void *digest;
-	sector_t sector = e->sector;
-	unsigned int size = e->size;
+	sector_t sector = e->i.sector;
+	unsigned int size = e->i.size;
 	int digest_size;
 	int ok, eq = 0;
 
@@ -1141,7 +1141,7 @@ int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	/* after "cancel", because after drbd_disconnect/drbd_rs_cancel_all
 	 * the resync lru has been cleaned up already */
 	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, e->sector);
+		drbd_rs_complete_io(mdev, e->i.sector);
 		put_ldev(mdev);
 	}
 
-- 
1.7.4.1

