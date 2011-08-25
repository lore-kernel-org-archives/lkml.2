Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1HYPfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:35:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32956 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1HYPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 014/118] drbd: Put sector and size in struct drbd_request into struct drbd_interval
Date: Thu, 25 Aug 2011 17:07:10 +0200
Message-Id: <1314284934-17999-15-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    5 ++-
 drivers/block/drbd/drbd_main.c     |   14 +++++-----
 drivers/block/drbd/drbd_receiver.c |    8 +++---
 drivers/block/drbd/drbd_req.c      |   48 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.h      |    4 +-
 drivers/block/drbd/drbd_worker.c   |    4 +-
 6 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c6d8200..d7678e8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -682,6 +682,8 @@ struct drbd_work {
 	drbd_work_cb cb;
 };
 
+#include "drbd_interval.h"
+
 struct drbd_request {
 	struct drbd_work w;
 	struct drbd_conf *mdev;
@@ -693,8 +695,7 @@ struct drbd_request {
 	struct bio *private_bio;
 
 	struct hlist_node collision;
-	sector_t sector;
-	unsigned int size;
+	struct drbd_interval i;
 	unsigned int epoch; /* barrier_nr */
 
 	/* barrier_nr: used to check on "completion" whether this req was in
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index eecbfc8..a77b4bf 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2711,19 +2711,19 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	dgs = (mdev->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
-	if (req->size <= DRBD_MAX_SIZE_H80_PACKET) {
+	if (req->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
 		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
 		p.head.h80.command = cpu_to_be16(P_DATA);
 		p.head.h80.length  =
-			cpu_to_be16(sizeof(p) - sizeof(union p_header) + dgs + req->size);
+			cpu_to_be16(sizeof(p) - sizeof(union p_header) + dgs + req->i.size);
 	} else {
 		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 		p.head.h95.command = cpu_to_be16(P_DATA);
 		p.head.h95.length  =
-			cpu_to_be32(sizeof(p) - sizeof(union p_header) + dgs + req->size);
+			cpu_to_be32(sizeof(p) - sizeof(union p_header) + dgs + req->i.size);
 	}
 
-	p.sector   = cpu_to_be64(req->sector);
+	p.sector   = cpu_to_be64(req->i.sector);
 	p.block_id = (unsigned long)req;
 	p.seq_num  = cpu_to_be32(req->seq_num =
 				 atomic_add_return(1, &mdev->packet_seq));
@@ -2769,7 +2769,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 			if (memcmp(mdev->int_dig_out, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
-					(unsigned long long)req->sector, req->size);
+					(unsigned long long)req->i.sector, req->i.size);
 			}
 		} /* else if (dgs > 64) {
 		     ... Be noisy about digest too large ...
@@ -2837,8 +2837,8 @@ int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
 {
 	struct p_block_desc p;
 
-	p.sector  = cpu_to_be64(req->sector);
-	p.blksize = cpu_to_be32(req->size);
+	p.sector  = cpu_to_be64(req->i.sector);
+	p.blksize = cpu_to_be32(req->i.size);
 
 	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OUT_OF_SYNC, &p.head, sizeof(p));
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8e7875e..6bb1a2f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1481,11 +1481,11 @@ find_request(struct drbd_conf *mdev,
 	hlist_for_each_entry(req, n, slot, collision) {
 		if ((unsigned long)req != (unsigned long)id)
 			continue;
-		if (req->sector != sector) {
+		if (req->i.sector != sector) {
 			dev_err(DEV, "%s: found request %lu but it has "
 				"wrong sector (%llus versus %llus)\n",
 				func, (unsigned long)req,
-				(unsigned long long)req->sector,
+				(unsigned long long)req->i.sector,
 				(unsigned long long)sector);
 			return NULL;
 		}
@@ -1783,7 +1783,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 		hlist_add_head(&e->collision, ee_hash_slot(mdev, sector));
 
-#define OVERLAPS overlaps(i->sector, i->size, sector, size)
+#define OVERLAPS overlaps(i->i.sector, i->i.size, sector, size)
 		slot = tl_hash_slot(mdev, sector);
 		first = 1;
 		for (;;) {
@@ -1800,7 +1800,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 						      "	new: %llus +%u; pending: %llus +%u\n",
 						      current->comm, current->pid,
 						      (unsigned long long)sector, size,
-						      (unsigned long long)i->sector, i->size);
+						      (unsigned long long)i->i.sector, i->i.size);
 					if (i->rq_state & RQ_NET_PENDING)
 						++have_unacked;
 					++have_conflict;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3424d67..1af11a1 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -77,10 +77,10 @@ static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const
 		 * Other places where we set out-of-sync:
 		 * READ with local io-error */
 		if (!(s & RQ_NET_OK) || !(s & RQ_LOCAL_OK))
-			drbd_set_out_of_sync(mdev, req->sector, req->size);
+			drbd_set_out_of_sync(mdev, req->i.sector, req->i.size);
 
 		if ((s & RQ_NET_OK) && (s & RQ_LOCAL_OK) && (s & RQ_NET_SIS))
-			drbd_set_in_sync(mdev, req->sector, req->size);
+			drbd_set_in_sync(mdev, req->i.sector, req->i.size);
 
 		/* one might be tempted to move the drbd_al_complete_io
 		 * to the local io completion callback drbd_endio_pri.
@@ -95,12 +95,12 @@ static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const
 		if (s & RQ_LOCAL_MASK) {
 			if (get_ldev_if_state(mdev, D_FAILED)) {
 				if (s & RQ_IN_ACT_LOG)
-					drbd_al_complete_io(mdev, req->sector);
+					drbd_al_complete_io(mdev, req->i.sector);
 				put_ldev(mdev);
 			} else if (__ratelimit(&drbd_ratelimit_state)) {
 				dev_warn(DEV, "Should have called drbd_al_complete_io(, %llu), "
 				     "but my Disk seems to have failed :(\n",
-				     (unsigned long long) req->sector);
+				     (unsigned long long) req->i.sector);
 			}
 		}
 	}
@@ -155,20 +155,20 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	 * if we have the ee_hash (two_primaries) and
 	 * this has been on the network */
 	if ((s & RQ_NET_DONE) && mdev->ee_hash != NULL) {
-		const sector_t sector = req->sector;
-		const int size = req->size;
+		const sector_t sector = req->i.sector;
+		const int size = req->i.size;
 
 		/* ASSERT:
 		 * there must be no conflicting requests, since
 		 * they must have been failed on the spot */
-#define OVERLAPS overlaps(sector, size, i->sector, i->size)
+#define OVERLAPS overlaps(sector, size, i->i.sector, i->i.size)
 		slot = tl_hash_slot(mdev, sector);
 		hlist_for_each_entry(i, n, slot, collision) {
 			if (OVERLAPS) {
 				dev_alert(DEV, "LOGIC BUG: completed: %p %llus +%u; "
 				      "other: %p %llus +%u\n",
 				      req, (unsigned long long)sector, size,
-				      i, (unsigned long long)i->sector, i->size);
+				      i, (unsigned long long)i->i.sector, i->i.size);
 			}
 		}
 
@@ -186,7 +186,7 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		 * we just have to do a wake_up.  */
 #undef OVERLAPS
 #define OVERLAPS overlaps(sector, size, e->sector, e->size)
-		slot = ee_hash_slot(mdev, req->sector);
+		slot = ee_hash_slot(mdev, req->i.sector);
 		hlist_for_each_entry(e, n, slot, collision) {
 			if (OVERLAPS) {
 				wake_up(&mdev->misc_wait);
@@ -322,8 +322,8 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
 static int _req_conflicts(struct drbd_request *req)
 {
 	struct drbd_conf *mdev = req->mdev;
-	const sector_t sector = req->sector;
-	const int size = req->size;
+	const sector_t sector = req->i.sector;
+	const int size = req->i.size;
 	struct drbd_request *i;
 	struct drbd_epoch_entry *e;
 	struct hlist_node *n;
@@ -339,7 +339,7 @@ static int _req_conflicts(struct drbd_request *req)
 		goto out_no_conflict;
 	BUG_ON(mdev->tl_hash == NULL);
 
-#define OVERLAPS overlaps(i->sector, i->size, sector, size)
+#define OVERLAPS overlaps(i->i.sector, i->i.size, sector, size)
 	slot = tl_hash_slot(mdev, sector);
 	hlist_for_each_entry(i, n, slot, collision) {
 		if (OVERLAPS) {
@@ -348,7 +348,7 @@ static int _req_conflicts(struct drbd_request *req)
 			      "pending: %llus +%u\n",
 			      current->comm, current->pid,
 			      (unsigned long long)sector, size,
-			      (unsigned long long)i->sector, i->size);
+			      (unsigned long long)i->i.sector, i->i.size);
 			goto out_conflict;
 		}
 	}
@@ -430,9 +430,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case completed_ok:
 		if (bio_data_dir(req->master_bio) == WRITE)
-			mdev->writ_cnt += req->size>>9;
+			mdev->writ_cnt += req->i.size >> 9;
 		else
-			mdev->read_cnt += req->size>>9;
+			mdev->read_cnt += req->i.size >> 9;
 
 		req->rq_state |= (RQ_LOCAL_COMPLETED|RQ_LOCAL_OK);
 		req->rq_state &= ~RQ_LOCAL_PENDING;
@@ -459,7 +459,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case read_completed_with_error:
-		drbd_set_out_of_sync(mdev, req->sector, req->size);
+		drbd_set_out_of_sync(mdev, req->i.sector, req->i.size);
 
 		req->rq_state |= RQ_LOCAL_COMPLETED;
 		req->rq_state &= ~RQ_LOCAL_PENDING;
@@ -491,7 +491,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		/* so we can verify the handle in the answer packet
 		 * corresponding hlist_del is in _req_may_be_done() */
-		hlist_add_head(&req->collision, ar_hash_slot(mdev, req->sector));
+		hlist_add_head(&req->collision, ar_hash_slot(mdev, req->i.sector));
 
 		set_bit(UNPLUG_REMOTE, &mdev->flags);
 
@@ -507,7 +507,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* assert something? */
 		/* from drbd_make_request_common only */
 
-		hlist_add_head(&req->collision, tl_hash_slot(mdev, req->sector));
+		hlist_add_head(&req->collision, tl_hash_slot(mdev, req->i.sector));
 		/* corresponding hlist_del is in _req_may_be_done() */
 
 		/* NOTE
@@ -572,7 +572,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 	case handed_over_to_network:
 		/* assert something? */
 		if (bio_data_dir(req->master_bio) == WRITE)
-			atomic_add(req->size>>9, &mdev->ap_in_flight);
+			atomic_add(req->i.size >> 9, &mdev->ap_in_flight);
 
 		if (bio_data_dir(req->master_bio) == WRITE &&
 		    mdev->net_conf->wire_protocol == DRBD_PROT_A) {
@@ -608,7 +608,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->rq_state &= ~(RQ_NET_OK|RQ_NET_PENDING);
 		req->rq_state |= RQ_NET_DONE;
 		if (req->rq_state & RQ_NET_SENT && req->rq_state & RQ_WRITE)
-			atomic_sub(req->size>>9, &mdev->ap_in_flight);
+			atomic_sub(req->i.size >> 9, &mdev->ap_in_flight);
 
 		/* if it is still queued, we may not complete it here.
 		 * it will be canceled soon. */
@@ -625,7 +625,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		if (what == conflict_discarded_by_peer)
 			dev_alert(DEV, "Got DiscardAck packet %llus +%u!"
 			      " DRBD is not a random data generator!\n",
-			      (unsigned long long)req->sector, req->size);
+			      (unsigned long long)req->i.sector, req->i.size);
 		req->rq_state |= RQ_NET_DONE;
 		/* fall through */
 	case write_acked_by_peer:
@@ -647,7 +647,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->rq_state |= RQ_NET_OK;
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		dec_ap_pending(mdev);
-		atomic_sub(req->size>>9, &mdev->ap_in_flight);
+		atomic_sub(req->i.size >> 9, &mdev->ap_in_flight);
 		req->rq_state &= ~RQ_NET_PENDING;
 		_req_may_be_done_not_susp(req, m);
 		break;
@@ -656,7 +656,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* assert something? */
 		if (req->rq_state & RQ_NET_PENDING) {
 			dec_ap_pending(mdev);
-			atomic_sub(req->size>>9, &mdev->ap_in_flight);
+			atomic_sub(req->i.size >> 9, &mdev->ap_in_flight);
 		}
 		req->rq_state &= ~(RQ_NET_OK|RQ_NET_PENDING);
 
@@ -715,7 +715,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		if ((req->rq_state & RQ_NET_MASK) != 0) {
 			req->rq_state |= RQ_NET_DONE;
 			if (mdev->net_conf->wire_protocol == DRBD_PROT_A)
-				atomic_sub(req->size>>9, &mdev->ap_in_flight);
+				atomic_sub(req->i.size >> 9, &mdev->ap_in_flight);
 		}
 		_req_may_be_done(req, m); /* Allowed while state.susp */
 		break;
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index a773636..2520186 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -272,8 +272,8 @@ static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 		req->mdev        = mdev;
 		req->master_bio  = bio_src;
 		req->epoch       = 0;
-		req->sector      = bio_src->bi_sector;
-		req->size        = bio_src->bi_size;
+		req->i.sector     = bio_src->bi_sector;
+		req->i.size      = bio_src->bi_size;
 		INIT_HLIST_NODE(&req->collision);
 		INIT_LIST_HEAD(&req->tl_requests);
 		INIT_LIST_HEAD(&req->w.list);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 43a9fef..a1eff6e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1288,7 +1288,7 @@ int w_send_read_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		return 1;
 	}
 
-	ok = drbd_send_drequest(mdev, P_DATA_REQUEST, req->sector, req->size,
+	ok = drbd_send_drequest(mdev, P_DATA_REQUEST, req->i.sector, req->i.size,
 				(unsigned long)req);
 
 	if (!ok) {
@@ -1307,7 +1307,7 @@ int w_restart_disk_io(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_begin_io(mdev, req->sector);
+		drbd_al_begin_io(mdev, req->i.sector);
 	/* Calling drbd_al_begin_io() out of the worker might deadlocks
 	   theoretically. Practically it can not deadlock, since this is
 	   only used when unfreezing IOs. All the extents of the requests
-- 
1.7.4.1

