Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1HYP1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:27:44 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1HYPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 051/118] drbd: _req_conflicts(): Get rid of the epoch_entries tree
Date: Thu, 25 Aug 2011 17:07:47 +0200
Message-Id: <1314284934-17999-52-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Instead of keeping a separate tree for local and remote write requests
for finding requests and for conflict detection, use the same tree for
both purposes.  Introduce a flag to allow distinguishing the two
possible types of entries in this tree.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    3 ---
 drivers/block/drbd/drbd_interval.h |    1 +
 drivers/block/drbd/drbd_main.c     |    1 -
 drivers/block/drbd/drbd_receiver.c |   33 ++++++++++++++++-----------------
 drivers/block/drbd/drbd_req.c      |   28 ++++------------------------
 drivers/block/drbd/drbd_worker.c   |    2 +-
 6 files changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e917859..faa7cbd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1045,9 +1045,6 @@ struct drbd_conf {
 	struct list_head read_ee;   /* IO in progress (any read) */
 	struct list_head net_ee;    /* zero-copy network send in progress */
 
-	/* Interval tree of pending remote write requests (struct drbd_epoch_entry) */
-	struct rb_root epoch_entries;
-
 	/* this one is protected by ee_lock, single thread */
 	struct drbd_epoch_entry *last_write_w_barrier;
 
diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index 9d1e5eb..4010ad9 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -9,6 +9,7 @@ struct drbd_interval {
 	sector_t sector;	/* start sector of the interval */
 	unsigned int size;	/* size in bytes */
 	sector_t end;		/* highest interval end in subtree */
+	int local:1		/* local or remote request? */;
 	int waiting:1;
 };
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 13aadca..a2417e4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3450,7 +3450,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 		goto out_no_tl;
 	mdev->read_requests = RB_ROOT;
 	mdev->write_requests = RB_ROOT;
-	mdev->epoch_entries = RB_ROOT;
 
 	mdev->current_epoch = kzalloc(sizeof(struct drbd_epoch), GFP_KERNEL);
 	if (!mdev->current_epoch)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 558c630..cde48f3 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -336,6 +336,7 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	drbd_clear_interval(&e->i);
 	e->i.size = data_size;
 	e->i.sector = sector;
+	e->i.local = false;
 	e->i.waiting = false;
 
 	e->epoch = NULL;
@@ -1512,7 +1513,7 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 
 	/* Request object according to our peer */
 	req = (struct drbd_request *)(unsigned long)id;
-	if (drbd_contains_interval(root, sector, &req->i))
+	if (drbd_contains_interval(root, sector, &req->i) && req->i.local)
 		return req;
 	if (!missing_ok) {
 		dev_err(DEV, "%s: failed to find request %lu, sector %llus\n", func,
@@ -1792,17 +1793,12 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		/* conflict detection and handling:
 		 * 1. wait on the sequence number,
 		 *    in case this data packet overtook ACK packets.
-		 * 2. check our interval trees for conflicting requests:
-		 *    we only need to check the write_requests tree; the
-		 *    epoch_entries tree cannot contain any overlaps because
-		 *    they were already eliminated on the submitting node.
+		 * 2. check for conflicting write requests.
 		 *
 		 * Note: for two_primaries, we are protocol C,
 		 * so there cannot be any request that is DONE
 		 * but still on the transfer log.
 		 *
-		 * unconditionally add to the epoch_entries tree.
-		 *
 		 * if no conflicting request is found:
 		 *    submit.
 		 *
@@ -1827,12 +1823,9 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 		spin_lock_irq(&mdev->tconn->req_lock);
 
-		drbd_insert_interval(&mdev->epoch_entries, &e->i);
-
 		first = 1;
 		for (;;) {
 			struct drbd_interval *i;
-			struct drbd_request *req2;
 			int have_unacked = 0;
 			int have_conflict = 0;
 			prepare_to_wait(&mdev->misc_wait, &wait,
@@ -1840,18 +1833,23 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 			i = drbd_find_overlap(&mdev->write_requests, sector, size);
 			if (i) {
-				req2 = container_of(i, struct drbd_request, i);
-
 				/* only ALERT on first iteration,
 				 * we may be woken up early... */
 				if (first)
-					dev_alert(DEV, "%s[%u] Concurrent local write detected!"
+					dev_alert(DEV, "%s[%u] Concurrent %s write detected!"
 					      "	new: %llus +%u; pending: %llus +%u\n",
 					      current->comm, current->pid,
+					      i->local ? "local" : "remote",
 					      (unsigned long long)sector, size,
-					      (unsigned long long)req2->i.sector, req2->i.size);
-				if (req2->rq_state & RQ_NET_PENDING)
-					++have_unacked;
+					      (unsigned long long)i->sector, i->size);
+
+				if (i->local) {
+					struct drbd_request *req2;
+
+					req2 = container_of(i, struct drbd_request, i);
+					if (req2->rq_state & RQ_NET_PENDING)
+						++have_unacked;
+				}
 				++have_conflict;
 			}
 			if (!have_conflict)
@@ -1877,7 +1875,6 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			}
 
 			if (signal_pending(current)) {
-				drbd_remove_epoch_entry_interval(mdev, e);
 				spin_unlock_irq(&mdev->tconn->req_lock);
 				finish_wait(&mdev->misc_wait, &wait);
 				goto out_interrupted;
@@ -1900,6 +1897,8 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			spin_lock_irq(&mdev->tconn->req_lock);
 		}
 		finish_wait(&mdev->misc_wait, &wait);
+
+		drbd_insert_interval(&mdev->write_requests, &e->i);
 	}
 
 	list_add(&e->w.list, &mdev->active_ee);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 078f77b..df5f106 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -74,6 +74,7 @@ static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 	drbd_clear_interval(&req->i);
 	req->i.sector     = bio_src->bi_sector;
 	req->i.size      = bio_src->bi_size;
+	req->i.local = true;
 	req->i.waiting = false;
 
 	INIT_LIST_HEAD(&req->tl_requests);
@@ -317,8 +318,6 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
  * to happen, but this is the rationale why we also have to check for
  * conflicting requests with local origin, and why we have to do so regardless
  * of whether we allowed multiple primaries.
- *
- * In case we only have one primary, the epoch_entries tree is empty.
  */
 static int _req_conflicts(struct drbd_request *req)
 {
@@ -334,35 +333,16 @@ static int _req_conflicts(struct drbd_request *req)
 
 	i = drbd_find_overlap(&mdev->write_requests, sector, size);
 	if (i) {
-		struct drbd_request *req2 =
-			container_of(i, struct drbd_request, i);
-
-		dev_alert(DEV, "%s[%u] Concurrent local write detected! "
+		dev_alert(DEV, "%s[%u] Concurrent %s write detected! "
 		      "[DISCARD L] new: %llus +%u; "
 		      "pending: %llus +%u\n",
 		      current->comm, current->pid,
+		      i->local ? "local" : "remote",
 		      (unsigned long long)sector, size,
-		      (unsigned long long)req2->i.sector, req2->i.size);
+		      (unsigned long long)i->sector, i->size);
 		goto out_conflict;
 	}
 
-	if (!RB_EMPTY_ROOT(&mdev->epoch_entries)) {
-		/* check for overlapping requests with remote origin */
-		i = drbd_find_overlap(&mdev->epoch_entries, sector, size);
-		if (i) {
-			struct drbd_epoch_entry *e =
-				container_of(i, struct drbd_epoch_entry, i);
-
-			dev_alert(DEV, "%s[%u] Concurrent remote write detected!"
-			      " [DISCARD L] new: %llus +%u; "
-			      "pending: %llus +%u\n",
-			      current->comm, current->pid,
-			      (unsigned long long)sector, size,
-			      (unsigned long long)e->i.sector, e->i.size);
-			goto out_conflict;
-		}
-	}
-
 	/* this is like it should be, and what we expected.
 	 * our users do behave after all... */
 	put_net_conf(mdev->tconn);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index afad8ea..0359600 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -123,7 +123,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	list_add_tail(&e->w.list, &mdev->done_ee);
 
 	/*
-	 * Do not remove from the epoch_entries tree here: we did not send the
+	 * Do not remove from the write_requests tree here: we did not send the
 	 * Ack yet and did not wake possibly waiting conflicting requests.
 	 * Removed from the tree from "drbd_process_done_ee" within the
 	 * appropriate w.cb (e_end_block/e_end_resync_block) or from
-- 
1.7.4.1

