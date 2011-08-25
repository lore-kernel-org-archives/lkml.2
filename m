Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1HYPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:35:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33048 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1HYPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 015/118] drbd: Use interval tree for overlapping write request detection
Date: Thu, 25 Aug 2011 17:07:11 +0200
Message-Id: <1314284934-17999-16-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    3 ++
 drivers/block/drbd/drbd_main.c     |    1 +
 drivers/block/drbd/drbd_receiver.c |   38 +++++++++++-------------
 drivers/block/drbd/drbd_req.c      |   56 ++++++++++++++++++-----------------
 drivers/block/drbd/drbd_req.h      |    1 +
 5 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d7678e8..0583713 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1019,6 +1019,9 @@ struct drbd_conf {
 	struct hlist_head *tl_hash;
 	unsigned int tl_hash_s;
 
+	/* Interval tree of pending local write requests */
+	struct rb_root write_requests;
+
 	/* blocks to resync in this run [unit BM_BLOCK_SIZE] */
 	unsigned long rs_total;
 	/* number of resync blocks that failed in this run */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a77b4bf..4d85838 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3473,6 +3473,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	/* no need to lock access, we are still initializing this minor device. */
 	if (!tl_init(mdev))
 		goto out_no_tl;
+	mdev->write_requests = RB_ROOT;
 
 	mdev->app_reads_hash = kzalloc(APP_R_HSIZE*sizeof(void *), GFP_KERNEL);
 	if (!mdev->app_reads_hash)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6bb1a2f..6b072584 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1733,9 +1733,6 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		const int size = e->size;
 		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->flags);
 		DEFINE_WAIT(wait);
-		struct drbd_request *i;
-		struct hlist_node *n;
-		struct hlist_head *slot;
 		int first;
 
 		D_ASSERT(mdev->net_conf->wire_protocol == DRBD_PROT_C);
@@ -1783,30 +1780,31 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 		hlist_add_head(&e->collision, ee_hash_slot(mdev, sector));
 
-#define OVERLAPS overlaps(i->i.sector, i->i.size, sector, size)
-		slot = tl_hash_slot(mdev, sector);
 		first = 1;
 		for (;;) {
+			struct drbd_interval *i;
 			int have_unacked = 0;
 			int have_conflict = 0;
 			prepare_to_wait(&mdev->misc_wait, &wait,
 				TASK_INTERRUPTIBLE);
-			hlist_for_each_entry(i, n, slot, collision) {
-				if (OVERLAPS) {
-					/* only ALERT on first iteration,
-					 * we may be woken up early... */
-					if (first)
-						dev_alert(DEV, "%s[%u] Concurrent local write detected!"
-						      "	new: %llus +%u; pending: %llus +%u\n",
-						      current->comm, current->pid,
-						      (unsigned long long)sector, size,
-						      (unsigned long long)i->i.sector, i->i.size);
-					if (i->rq_state & RQ_NET_PENDING)
-						++have_unacked;
-					++have_conflict;
-				}
+
+			i = drbd_find_overlap(&mdev->write_requests, sector, size);
+			if (i) {
+				struct drbd_request *req2 =
+					container_of(i, struct drbd_request, i);
+
+				/* only ALERT on first iteration,
+				 * we may be woken up early... */
+				if (first)
+					dev_alert(DEV, "%s[%u] Concurrent local write detected!"
+					      "	new: %llus +%u; pending: %llus +%u\n",
+					      current->comm, current->pid,
+					      (unsigned long long)sector, size,
+					      (unsigned long long)req2->i.sector, req2->i.size);
+				if (req2->rq_state & RQ_NET_PENDING)
+					++have_unacked;
+				++have_conflict;
 			}
-#undef OVERLAPS
 			if (!have_conflict)
 				break;
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 1af11a1..593576f 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -135,7 +135,6 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	struct drbd_request *req)
 {
 	const unsigned long s = req->rq_state;
-	struct drbd_request *i;
 	struct drbd_epoch_entry *e;
 	struct hlist_node *n;
 	struct hlist_head *slot;
@@ -157,19 +156,21 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	if ((s & RQ_NET_DONE) && mdev->ee_hash != NULL) {
 		const sector_t sector = req->i.sector;
 		const int size = req->i.size;
+		struct drbd_interval *i;
 
 		/* ASSERT:
 		 * there must be no conflicting requests, since
 		 * they must have been failed on the spot */
-#define OVERLAPS overlaps(sector, size, i->i.sector, i->i.size)
-		slot = tl_hash_slot(mdev, sector);
-		hlist_for_each_entry(i, n, slot, collision) {
-			if (OVERLAPS) {
-				dev_alert(DEV, "LOGIC BUG: completed: %p %llus +%u; "
-				      "other: %p %llus +%u\n",
-				      req, (unsigned long long)sector, size,
-				      i, (unsigned long long)i->i.sector, i->i.size);
-			}
+
+		i = drbd_find_overlap(&mdev->write_requests, sector, size);
+		if (i) {
+			struct drbd_request *req2 =
+				container_of(i, struct drbd_request, i);
+
+			dev_alert(DEV, "LOGIC BUG: completed: %p %llus +%u; "
+			      "other: %p %llus +%u\n",
+			      req, (unsigned long long)sector, size,
+			      i, (unsigned long long)req2->i.sector, req2->i.size);
 		}
 
 		/* maybe "wake" those conflicting epoch entries
@@ -184,7 +185,6 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		 *
 		 * anyways, if we found one,
 		 * we just have to do a wake_up.  */
-#undef OVERLAPS
 #define OVERLAPS overlaps(sector, size, e->sector, e->size)
 		slot = ee_hash_slot(mdev, req->i.sector);
 		hlist_for_each_entry(e, n, slot, collision) {
@@ -260,9 +260,11 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 
 		/* remove the request from the conflict detection
 		 * respective block_id verification hash */
-		if (!hlist_unhashed(&req->collision))
+		if (!hlist_unhashed(&req->collision)) {
 			hlist_del(&req->collision);
-		else
+			if (!drbd_interval_empty(&req->i))
+				drbd_remove_interval(&mdev->write_requests, &req->i);
+		} else
 			D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
 
 		/* for writes we need to do some extra housekeeping */
@@ -324,7 +326,7 @@ static int _req_conflicts(struct drbd_request *req)
 	struct drbd_conf *mdev = req->mdev;
 	const sector_t sector = req->i.sector;
 	const int size = req->i.size;
-	struct drbd_request *i;
+	struct drbd_interval *i;
 	struct drbd_epoch_entry *e;
 	struct hlist_node *n;
 	struct hlist_head *slot;
@@ -339,24 +341,23 @@ static int _req_conflicts(struct drbd_request *req)
 		goto out_no_conflict;
 	BUG_ON(mdev->tl_hash == NULL);
 
-#define OVERLAPS overlaps(i->i.sector, i->i.size, sector, size)
-	slot = tl_hash_slot(mdev, sector);
-	hlist_for_each_entry(i, n, slot, collision) {
-		if (OVERLAPS) {
-			dev_alert(DEV, "%s[%u] Concurrent local write detected! "
-			      "[DISCARD L] new: %llus +%u; "
-			      "pending: %llus +%u\n",
-			      current->comm, current->pid,
-			      (unsigned long long)sector, size,
-			      (unsigned long long)i->i.sector, i->i.size);
-			goto out_conflict;
-		}
+	i = drbd_find_overlap(&mdev->write_requests, sector, size);
+	if (i) {
+		struct drbd_request *req2 =
+			container_of(i, struct drbd_request, i);
+
+		dev_alert(DEV, "%s[%u] Concurrent local write detected! "
+		      "[DISCARD L] new: %llus +%u; "
+		      "pending: %llus +%u\n",
+		      current->comm, current->pid,
+		      (unsigned long long)sector, size,
+		      (unsigned long long)req2->i.sector, req2->i.size);
+		goto out_conflict;
 	}
 
 	if (mdev->ee_hash_s) {
 		/* now, check for overlapping requests with remote origin */
 		BUG_ON(mdev->ee_hash == NULL);
-#undef OVERLAPS
 #define OVERLAPS overlaps(e->sector, e->size, sector, size)
 		slot = ee_hash_slot(mdev, sector);
 		hlist_for_each_entry(e, n, slot, collision) {
@@ -509,6 +510,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		hlist_add_head(&req->collision, tl_hash_slot(mdev, req->i.sector));
 		/* corresponding hlist_del is in _req_may_be_done() */
+		drbd_insert_interval(&mdev->write_requests, &req->i);
 
 		/* NOTE
 		 * In case the req ended up on the transfer log before being
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 2520186..6f11624 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -275,6 +275,7 @@ static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 		req->i.sector     = bio_src->bi_sector;
 		req->i.size      = bio_src->bi_size;
 		INIT_HLIST_NODE(&req->collision);
+		drbd_clear_interval(&req->i);
 		INIT_LIST_HEAD(&req->tl_requests);
 		INIT_LIST_HEAD(&req->w.list);
 	}
-- 
1.7.4.1

