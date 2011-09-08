Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1IHMqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:46:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37555 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1IHMpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:45 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/16] drbd: preparation commit, pass drbd_interval to drbd_al_begin/complete_io
Date: Thu,  8 Sep 2011 14:45:34 +0200
Message-Id: <1315485937-18989-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We want to avoid bio_split for bios crossing activity log boundaries.
So we may need to activate two activity log extents "atomically".
drbd_al_begin_io() needs to know more than just the start sector.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    8 ++++----
 drivers/block/drbd/drbd_int.h      |    4 ++--
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_req.c      |   12 ++++++------
 drivers/block/drbd/drbd_worker.c   |   10 +++++-----
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 643a7bd..df78810 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -205,9 +205,9 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
 	return al_ext;
 }
 
-void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
+void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i)
 {
-	unsigned int enr = (sector >> (AL_EXTENT_SHIFT-9));
+	unsigned int enr = (i->sector >> (AL_EXTENT_SHIFT-9));
 	struct lc_element *al_ext;
 	struct update_al_work al_work;
 
@@ -254,9 +254,9 @@ void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
 	}
 }
 
-void drbd_al_complete_io(struct drbd_conf *mdev, sector_t sector)
+void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i)
 {
-	unsigned int enr = (sector >> (AL_EXTENT_SHIFT-9));
+	unsigned int enr = (i->sector >> (AL_EXTENT_SHIFT-9));
 	struct lc_element *extent;
 	unsigned long flags;
 
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7b4203c..218e2c3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1584,8 +1584,8 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
-extern void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector);
-extern void drbd_al_complete_io(struct drbd_conf *mdev, sector_t sector);
+extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i);
+extern void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i);
 extern void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector);
 extern int drbd_rs_begin_io(struct drbd_conf *mdev, sector_t sector);
 extern int drbd_try_rs_begin_io(struct drbd_conf *mdev, sector_t sector);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 619a172..0b51f29 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2064,7 +2064,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 		drbd_set_out_of_sync(mdev, peer_req->i.sector, peer_req->i.size);
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(mdev, peer_req->i.sector);
+		drbd_al_begin_io(mdev, &peer_req->i);
 	}
 
 	err = drbd_submit_peer_request(mdev, peer_req, rw, DRBD_FAULT_DT_WR);
@@ -2078,7 +2078,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	drbd_remove_epoch_entry_interval(mdev, peer_req);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
-		drbd_al_complete_io(mdev, peer_req->i.sector);
+		drbd_al_complete_io(mdev, &peer_req->i);
 
 out_interrupted:
 	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + EV_CLEANUP);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index e380ffb..4406d82 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -128,12 +128,12 @@ static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const
 		if (s & RQ_LOCAL_MASK) {
 			if (get_ldev_if_state(mdev, D_FAILED)) {
 				if (s & RQ_IN_ACT_LOG)
-					drbd_al_complete_io(mdev, req->i.sector);
+					drbd_al_complete_io(mdev, &req->i);
 				put_ldev(mdev);
 			} else if (__ratelimit(&drbd_ratelimit_state)) {
-				dev_warn(DEV, "Should have called drbd_al_complete_io(, %llu), "
-				     "but my Disk seems to have failed :(\n",
-				     (unsigned long long) req->i.sector);
+				dev_warn(DEV, "Should have called drbd_al_complete_io(, %llu, %u), "
+					 "but my Disk seems to have failed :(\n",
+					 (unsigned long long) req->i.sector, req->i.size);
 			}
 		}
 	}
@@ -782,7 +782,7 @@ int __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long s
 	 * of transactional on-disk meta data updates. */
 	if (rw == WRITE && local && !test_bit(AL_SUSPENDED, &mdev->flags)) {
 		req->rq_state |= RQ_IN_ACT_LOG;
-		drbd_al_begin_io(mdev, sector);
+		drbd_al_begin_io(mdev, &req->i);
 	}
 
 	remote = remote && drbd_should_do_remote(mdev->state);
@@ -979,7 +979,7 @@ allocate_barrier:
 
 fail_free_complete:
 	if (req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_complete_io(mdev, sector);
+		drbd_al_complete_io(mdev, &req->i);
 fail_and_free_req:
 	if (local) {
 		bio_put(req->private_bio);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3f7d27c..640d04a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -101,7 +101,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 {
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = peer_req->w.mdev;
-	sector_t e_sector;
+	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
 	int do_al_complete_io;
@@ -110,7 +110,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	 * we may no longer access it,
 	 * it may be freed/reused already!
 	 * (as soon as we release the req_lock) */
-	e_sector = peer_req->i.sector;
+	i = peer_req->i;
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
 
@@ -134,13 +134,13 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
-		drbd_rs_complete_io(mdev, e_sector);
+		drbd_rs_complete_io(mdev, i.sector);
 
 	if (do_wake)
 		wake_up(&mdev->ee_wait);
 
 	if (do_al_complete_io)
-		drbd_al_complete_io(mdev, e_sector);
+		drbd_al_complete_io(mdev, &i);
 
 	wake_asender(mdev->tconn);
 	put_ldev(mdev);
@@ -1303,7 +1303,7 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 	struct drbd_conf *mdev = w->mdev;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_begin_io(mdev, req->i.sector);
+		drbd_al_begin_io(mdev, &req->i);
 	/* Calling drbd_al_begin_io() out of the worker might deadlocks
 	   theoretically. Practically it can not deadlock, since this is
 	   only used when unfreezing IOs. All the extents of the requests
-- 
1.7.4.1

