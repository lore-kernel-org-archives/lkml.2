Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1HYPe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:34:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32953 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1HYPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 019/118] drbd: Use interval tree for overlapping epoch entry detection
Date: Thu, 25 Aug 2011 17:07:15 +0200
Message-Id: <1314284934-17999-20-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   15 ++++++++++++
 drivers/block/drbd/drbd_req.c      |   44 +++++++++++++----------------------
 4 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 94b4f6e..535339b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1080,6 +1080,9 @@ struct drbd_conf {
 	struct hlist_head *ee_hash; /* is proteced by req_lock! */
 	unsigned int ee_hash_s;
 
+	/* Interval tree of pending remote write requests (struct drbd_epoch_entry) */
+	struct rb_root epoch_entries;
+
 	/* this one is protected by ee_lock, single thread */
 	struct drbd_epoch_entry *last_write_w_barrier;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0033137..18f27af 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3475,6 +3475,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 		goto out_no_tl;
 	mdev->read_requests = RB_ROOT;
 	mdev->write_requests = RB_ROOT;
+	mdev->epoch_entries = RB_ROOT;
 
 	mdev->app_reads_hash = kzalloc(APP_R_HSIZE*sizeof(void *), GFP_KERNEL);
 	if (!mdev->app_reads_hash)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 42c0ffa..a0fbbfc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -334,6 +334,7 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 		goto fail;
 
 	INIT_HLIST_NODE(&e->collision);
+	drbd_clear_interval(&e->i);
 	e->epoch = NULL;
 	e->mdev = mdev;
 	e->pages = page;
@@ -361,6 +362,7 @@ void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e, int i
 	drbd_pp_free(mdev, e->pages, is_net);
 	D_ASSERT(atomic_read(&e->pending_bios) == 0);
 	D_ASSERT(hlist_unhashed(&e->collision));
+	D_ASSERT(drbd_interval_empty(&e->i));
 	mempool_free(e, drbd_ee_mempool);
 }
 
@@ -1418,6 +1420,7 @@ static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int u
 	int ok;
 
 	D_ASSERT(hlist_unhashed(&e->collision));
+	D_ASSERT(drbd_interval_empty(&e->i));
 
 	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(mdev, sector, e->i.size);
@@ -1574,9 +1577,13 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 		spin_lock_irq(&mdev->req_lock);
 		D_ASSERT(!hlist_unhashed(&e->collision));
 		hlist_del_init(&e->collision);
+		D_ASSERT(!drbd_interval_empty(&e->i));
+		drbd_remove_interval(&mdev->epoch_entries, &e->i);
+		drbd_clear_interval(&e->i);
 		spin_unlock_irq(&mdev->req_lock);
 	} else {
 		D_ASSERT(hlist_unhashed(&e->collision));
+		D_ASSERT(drbd_interval_empty(&e->i));
 	}
 
 	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
@@ -1595,6 +1602,9 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 	spin_lock_irq(&mdev->req_lock);
 	D_ASSERT(!hlist_unhashed(&e->collision));
 	hlist_del_init(&e->collision);
+	D_ASSERT(!drbd_interval_empty(&e->i));
+	drbd_remove_interval(&mdev->epoch_entries, &e->i);
+	drbd_clear_interval(&e->i);
 	spin_unlock_irq(&mdev->req_lock);
 
 	dec_unacked(mdev);
@@ -1767,6 +1777,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 		spin_lock_irq(&mdev->req_lock);
 
 		hlist_add_head(&e->collision, ee_hash_slot(mdev, sector));
+		drbd_insert_interval(&mdev->epoch_entries, &e->i);
 
 		first = 1;
 		for (;;) {
@@ -1817,6 +1828,8 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 			if (signal_pending(current)) {
 				hlist_del_init(&e->collision);
+				drbd_remove_interval(&mdev->epoch_entries, &e->i);
+				drbd_clear_interval(&e->i);
 
 				spin_unlock_irq(&mdev->req_lock);
 
@@ -1875,6 +1888,8 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	spin_lock_irq(&mdev->req_lock);
 	list_del(&e->w.list);
 	hlist_del_init(&e->collision);
+	drbd_remove_interval(&mdev->epoch_entries, &e->i);
+	drbd_clear_interval(&e->i);
 	spin_unlock_irq(&mdev->req_lock);
 	if (e->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(mdev, e->i.sector);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 5bf93a7..b81ce82 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -135,9 +135,6 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	struct drbd_request *req)
 {
 	const unsigned long s = req->rq_state;
-	struct drbd_epoch_entry *e;
-	struct hlist_node *n;
-	struct hlist_head *slot;
 
 	/* Before we can signal completion to the upper layers,
 	 * we may need to close the current epoch.
@@ -185,16 +182,10 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		 *
 		 * anyways, if we found one,
 		 * we just have to do a wake_up.  */
-#define OVERLAPS overlaps(sector, size, e->i.sector, e->i.size)
-		slot = ee_hash_slot(mdev, req->i.sector);
-		hlist_for_each_entry(e, n, slot, collision) {
-			if (OVERLAPS) {
-				wake_up(&mdev->misc_wait);
-				break;
-			}
-		}
+		i = drbd_find_overlap(&mdev->epoch_entries, sector, size);
+		if (i)
+			wake_up(&mdev->misc_wait);
 	}
-#undef OVERLAPS
 }
 
 void complete_master_bio(struct drbd_conf *mdev,
@@ -332,9 +323,6 @@ static int _req_conflicts(struct drbd_request *req)
 	const sector_t sector = req->i.sector;
 	const int size = req->i.size;
 	struct drbd_interval *i;
-	struct drbd_epoch_entry *e;
-	struct hlist_node *n;
-	struct hlist_head *slot;
 
 	D_ASSERT(hlist_unhashed(&req->collision));
 	D_ASSERT(drbd_interval_empty(&req->i));
@@ -364,21 +352,21 @@ static int _req_conflicts(struct drbd_request *req)
 	if (mdev->ee_hash_s) {
 		/* now, check for overlapping requests with remote origin */
 		BUG_ON(mdev->ee_hash == NULL);
-#define OVERLAPS overlaps(e->i.sector, e->i.size, sector, size)
-		slot = ee_hash_slot(mdev, sector);
-		hlist_for_each_entry(e, n, slot, collision) {
-			if (OVERLAPS) {
-				dev_alert(DEV, "%s[%u] Concurrent remote write detected!"
-				      " [DISCARD L] new: %llus +%u; "
-				      "pending: %llus +%u\n",
-				      current->comm, current->pid,
-				      (unsigned long long)sector, size,
-				      (unsigned long long)e->i.sector, e->i.size);
-				goto out_conflict;
-			}
+
+		i = drbd_find_overlap(&mdev->epoch_entries, sector, size);
+		if (i) {
+			struct drbd_epoch_entry *e =
+				container_of(i, struct drbd_epoch_entry, i);
+
+			dev_alert(DEV, "%s[%u] Concurrent remote write detected!"
+			      " [DISCARD L] new: %llus +%u; "
+			      "pending: %llus +%u\n",
+			      current->comm, current->pid,
+			      (unsigned long long)sector, size,
+			      (unsigned long long)e->i.sector, e->i.size);
+			goto out_conflict;
 		}
 	}
-#undef OVERLAPS
 
 out_no_conflict:
 	/* this is like it should be, and what we expected.
-- 
1.7.4.1

