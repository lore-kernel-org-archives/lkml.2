Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1HYP1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:27:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33981 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1HYPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 050/118] drbd: Allow to wait for the completion of an epoch entry as well
Date: Thu, 25 Aug 2011 17:07:46 +0200
Message-Id: <1314284934-17999-51-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_interval.h |    1 +
 drivers/block/drbd/drbd_receiver.c |   35 ++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_req.c      |   23 ++++++++++++++++++-----
 drivers/block/drbd/drbd_req.h      |    7 -------
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index a847b4a..9d1e5eb 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -9,6 +9,7 @@ struct drbd_interval {
 	sector_t sector;	/* start sector of the interval */
 	unsigned int size;	/* size in bytes */
 	sector_t end;		/* highest interval end in subtree */
+	int waiting:1;
 };
 
 static inline void drbd_clear_interval(struct drbd_interval *i)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ed24dc3..558c630 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -334,13 +334,15 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 		goto fail;
 
 	drbd_clear_interval(&e->i);
+	e->i.size = data_size;
+	e->i.sector = sector;
+	e->i.waiting = false;
+
 	e->epoch = NULL;
 	e->mdev = mdev;
 	e->pages = page;
 	atomic_set(&e->pending_bios, 0);
-	e->i.size = data_size;
 	e->flags = 0;
-	e->i.sector = sector;
 	/*
 	 * The block_id is opaque to the receiver.  It is not endianness
 	 * converted, and sent back to the sender unchanged.
@@ -1176,6 +1178,19 @@ fail:
 	return err;
 }
 
+static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
+					     struct drbd_epoch_entry *e)
+{
+	struct drbd_interval *i = &e->i;
+
+	drbd_remove_interval(&mdev->write_requests, i);
+	drbd_clear_interval(i);
+
+	/* Wake up any processes waiting for this epoch entry to complete.  */
+	if (i->waiting)
+		wake_up(&mdev->misc_wait);
+}
+
 static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 			   unsigned int data_size)
 {
@@ -1595,8 +1610,7 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	if (mdev->tconn->net_conf->two_primaries) {
 		spin_lock_irq(&mdev->tconn->req_lock);
 		D_ASSERT(!drbd_interval_empty(&e->i));
-		drbd_remove_interval(&mdev->epoch_entries, &e->i);
-		drbd_clear_interval(&e->i);
+		drbd_remove_epoch_entry_interval(mdev, e);
 		spin_unlock_irq(&mdev->tconn->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&e->i));
@@ -1616,8 +1630,7 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	D_ASSERT(!drbd_interval_empty(&e->i));
-	drbd_remove_interval(&mdev->epoch_entries, &e->i);
-	drbd_clear_interval(&e->i);
+	drbd_remove_epoch_entry_interval(mdev, e);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	dec_unacked(mdev);
@@ -1864,17 +1877,14 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			}
 
 			if (signal_pending(current)) {
-				drbd_remove_interval(&mdev->epoch_entries, &e->i);
-				drbd_clear_interval(&e->i);
-
+				drbd_remove_epoch_entry_interval(mdev, e);
 				spin_unlock_irq(&mdev->tconn->req_lock);
-
 				finish_wait(&mdev->misc_wait, &wait);
 				goto out_interrupted;
 			}
 
 			/* Indicate to wake up mdev->misc_wait upon completion.  */
-			req2->rq_state |= RQ_COLLISION;
+			i->waiting = true;
 
 			spin_unlock_irq(&mdev->tconn->req_lock);
 			if (first) {
@@ -1926,8 +1936,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->tconn->req_lock);
 	list_del(&e->w.list);
-	drbd_remove_interval(&mdev->epoch_entries, &e->i);
-	drbd_clear_interval(&e->i);
+	drbd_remove_epoch_entry_interval(mdev, e);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (e->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(mdev, e->i.sector);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 8b4ba94..078f77b 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -70,9 +70,12 @@ static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 	req->mdev        = mdev;
 	req->master_bio  = bio_src;
 	req->epoch       = 0;
+
 	drbd_clear_interval(&req->i);
 	req->i.sector     = bio_src->bi_sector;
 	req->i.size      = bio_src->bi_size;
+	req->i.waiting = false;
+
 	INIT_LIST_HEAD(&req->tl_requests);
 	INIT_LIST_HEAD(&req->w.list);
 
@@ -175,10 +178,6 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 	    (s & RQ_NET_SENT) != 0 &&
 	    req->epoch == mdev->tconn->newest_tle->br_number)
 		queue_barrier(mdev);
-
-	/* Wake up any processes waiting for this request to complete.  */
-	if ((s & RQ_NET_DONE) && (s & RQ_COLLISION))
-		wake_up(&mdev->misc_wait);
 }
 
 void complete_master_bio(struct drbd_conf *mdev,
@@ -188,6 +187,20 @@ void complete_master_bio(struct drbd_conf *mdev,
 	dec_ap_bio(mdev);
 }
 
+
+static void drbd_remove_request_interval(struct rb_root *root,
+					 struct drbd_request *req)
+{
+	struct drbd_conf *mdev = req->mdev;
+	struct drbd_interval *i = &req->i;
+
+	drbd_remove_interval(root, i);
+
+	/* Wake up any processes waiting for this request to complete.  */
+	if (i->waiting)
+		wake_up(&mdev->misc_wait);
+}
+
 /* Helper for __req_mod().
  * Set m->bio to the master bio, if it is fit to be completed,
  * or leave it alone (it is initialized to NULL in __req_mod),
@@ -251,7 +264,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 				root = &mdev->write_requests;
 			else
 				root = &mdev->read_requests;
-			drbd_remove_interval(root, &req->i);
+			drbd_remove_request_interval(root, req);
 		} else
 			D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
 
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 7a7464a..431e3f9 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -194,12 +194,6 @@ enum drbd_req_state_bits {
 
 	/* Should call drbd_al_complete_io() for this request... */
 	__RQ_IN_ACT_LOG,
-
-	/*
-	 * Set when a processes puts itself to sleep to wait for this request
-	 * to complete.
-	 */
-	__RQ_COLLISION,
 };
 
 #define RQ_LOCAL_PENDING   (1UL << __RQ_LOCAL_PENDING)
@@ -220,7 +214,6 @@ enum drbd_req_state_bits {
 
 #define RQ_WRITE           (1UL << __RQ_WRITE)
 #define RQ_IN_ACT_LOG      (1UL << __RQ_IN_ACT_LOG)
-#define RQ_COLLISION	   (1UL << __RQ_COLLISION)
 
 /* For waking up the frozen transfer log mod_req() has to return if the request
    should be counted in the epoch object*/
-- 
1.7.4.1

