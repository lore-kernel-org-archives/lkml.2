Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1IELr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60521 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1IELqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 36/54] drbd: Make all worker callbacks return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:27 +0200
Message-Id: <1315223145-20640-37-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   16 ++--
 drivers/block/drbd/drbd_int.h      |   38 ++++----
 drivers/block/drbd/drbd_main.c     |   18 ++--
 drivers/block/drbd/drbd_receiver.c |   40 ++++----
 drivers/block/drbd/drbd_state.c    |   10 +-
 drivers/block/drbd/drbd_worker.c   |  194 ++++++++++++++++++------------------
 6 files changed, 160 insertions(+), 156 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index d0d52c4..285dd74 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -106,7 +106,7 @@ struct drbd_atodb_wait {
 };
 
 
-static long w_al_write_transaction(struct drbd_work *, int);
+static int w_al_write_transaction(struct drbd_work *, int);
 
 static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 				 struct drbd_backing_dev *bdev,
@@ -298,7 +298,7 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-static long
+static int
 w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
@@ -315,7 +315,7 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 			drbd_disk_str(mdev->state.disk));
 		aw->err = -EIO;
 		complete(&((struct update_al_work *)w)->event);
-		return 1;
+		return 0;
 	}
 
 	/* The bitmap write may have failed, causing a state change. */
@@ -326,7 +326,7 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 		aw->err = -EIO;
 		complete(&((struct update_al_work *)w)->event);
 		put_ldev(mdev);
-		return 1;
+		return 0;
 	}
 
 	mutex_lock(&mdev->md_io_mutex); /* protects md_io_buffer, al_tr_cycle, ... */
@@ -394,7 +394,7 @@ w_al_write_transaction(struct drbd_work *w, int unused)
 	complete(&((struct update_al_work *)w)->event);
 	put_ldev(mdev);
 
-	return 1;
+	return 0;
 }
 
 /* FIXME
@@ -688,7 +688,7 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	wake_up(&mdev->al_wait);
 }
 
-static long w_update_odbm(struct drbd_work *w, int unused)
+static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -698,7 +698,7 @@ static long w_update_odbm(struct drbd_work *w, int unused)
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_warn(DEV, "Can not update on disk bitmap, local IO disabled.\n");
 		kfree(udw);
-		return 1;
+		return 0;
 	}
 
 	drbd_bm_write_page(mdev, rs_extent_to_bm_page(udw->enr));
@@ -718,7 +718,7 @@ static long w_update_odbm(struct drbd_work *w, int unused)
 	}
 	drbd_bcast_event(mdev, &sib);
 
-	return 1;
+	return 0;
 }
 
 
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index bdc4f30..f2f3287 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -644,7 +644,7 @@ static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
 }
 
 struct drbd_work;
-typedef long (*drbd_work_cb)(struct drbd_work *, int cancel);
+typedef int (*drbd_work_cb)(struct drbd_work *, int cancel);
 struct drbd_work {
 	struct list_head list;
 	drbd_work_cb cb;
@@ -1546,24 +1546,24 @@ extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *
 extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
 			 struct drbd_peer_request *, void *);
 /* worker callbacks */
-extern long w_read_retry_remote(struct drbd_work *, int);
-extern long w_e_end_data_req(struct drbd_work *, int);
-extern long w_e_end_rsdata_req(struct drbd_work *, int);
-extern long w_e_end_csum_rs_req(struct drbd_work *, int);
-extern long w_e_end_ov_reply(struct drbd_work *, int);
-extern long w_e_end_ov_req(struct drbd_work *, int);
-extern long w_ov_finished(struct drbd_work *, int);
-extern long w_resync_timer(struct drbd_work *, int);
-extern long w_send_write_hint(struct drbd_work *, int);
-extern long w_make_resync_request(struct drbd_work *, int);
-extern long w_send_dblock(struct drbd_work *, int);
-extern long w_send_barrier(struct drbd_work *, int);
-extern long w_send_read_req(struct drbd_work *, int);
-extern long w_prev_work_done(struct drbd_work *, int);
-extern long w_e_reissue(struct drbd_work *, int);
-extern long w_restart_disk_io(struct drbd_work *, int);
-extern long w_send_oos(struct drbd_work *, int);
-extern long w_start_resync(struct drbd_work *, int);
+extern int w_read_retry_remote(struct drbd_work *, int);
+extern int w_e_end_data_req(struct drbd_work *, int);
+extern int w_e_end_rsdata_req(struct drbd_work *, int);
+extern int w_e_end_csum_rs_req(struct drbd_work *, int);
+extern int w_e_end_ov_reply(struct drbd_work *, int);
+extern int w_e_end_ov_req(struct drbd_work *, int);
+extern int w_ov_finished(struct drbd_work *, int);
+extern int w_resync_timer(struct drbd_work *, int);
+extern int w_send_write_hint(struct drbd_work *, int);
+extern int w_make_resync_request(struct drbd_work *, int);
+extern int w_send_dblock(struct drbd_work *, int);
+extern int w_send_barrier(struct drbd_work *, int);
+extern int w_send_read_req(struct drbd_work *, int);
+extern int w_prev_work_done(struct drbd_work *, int);
+extern int w_e_reissue(struct drbd_work *, int);
+extern int w_restart_disk_io(struct drbd_work *, int);
+extern int w_send_oos(struct drbd_work *, int);
+extern int w_start_resync(struct drbd_work *, int);
 
 extern void resync_timer_fn(unsigned long data);
 extern void start_resync_timer_fn(unsigned long data);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5be218e..8b0cfe0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -64,10 +64,10 @@ int drbd_asender(struct drbd_thread *);
 int drbd_init(void);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
 static int drbd_release(struct gendisk *gd, fmode_t mode);
-static long w_md_sync(struct drbd_work *w, int unused);
+static int w_md_sync(struct drbd_work *w, int unused);
 static void md_sync_timer_fn(unsigned long data);
-static long w_bitmap_io(struct drbd_work *w, int unused);
-static long w_go_diskless(struct drbd_work *w, int unused);
+static int w_bitmap_io(struct drbd_work *w, int unused);
+static int w_go_diskless(struct drbd_work *w, int unused);
 
 MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
 	      "Lars Ellenberg <lars@linbit.com>");
@@ -2885,7 +2885,7 @@ int drbd_bmio_clear_n_write(struct drbd_conf *mdev)
 	return rv;
 }
 
-static long w_bitmap_io(struct drbd_work *w, int unused)
+static int w_bitmap_io(struct drbd_work *w, int unused)
 {
 	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -2910,7 +2910,7 @@ static long w_bitmap_io(struct drbd_work *w, int unused)
 	work->why = NULL;
 	work->flags = 0;
 
-	return 1;
+	return 0;
 }
 
 void drbd_ldev_destroy(struct drbd_conf *mdev)
@@ -2926,7 +2926,7 @@ void drbd_ldev_destroy(struct drbd_conf *mdev)
 	clear_bit(GO_DISKLESS, &mdev->flags);
 }
 
-static long w_go_diskless(struct drbd_work *w, int unused)
+static int w_go_diskless(struct drbd_work *w, int unused)
 {
 	struct drbd_conf *mdev = w->mdev;
 
@@ -2936,7 +2936,7 @@ static long w_go_diskless(struct drbd_work *w, int unused)
 	 * the protected members anymore, though, so once put_ldev reaches zero
 	 * again, it will be safe to free them. */
 	drbd_force_state(mdev, NS(disk, D_DISKLESS));
-	return 1;
+	return 0;
 }
 
 void drbd_go_diskless(struct drbd_conf *mdev)
@@ -3042,7 +3042,7 @@ static void md_sync_timer_fn(unsigned long data)
 	drbd_queue_work_front(&mdev->tconn->data.work, &mdev->md_sync_work);
 }
 
-static long w_md_sync(struct drbd_work *w, int unused)
+static int w_md_sync(struct drbd_work *w, int unused)
 {
 	struct drbd_conf *mdev = w->mdev;
 
@@ -3052,7 +3052,7 @@ static long w_md_sync(struct drbd_work *w, int unused)
 		mdev->last_md_mark_dirty.func, mdev->last_md_mark_dirty.line);
 #endif
 	drbd_md_sync(mdev);
-	return 1;
+	return 0;
 }
 
 const char *cmdname(enum drbd_packet cmd)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e8a51be..9048c00e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -70,7 +70,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn);
 static int drbd_disconnected(int vnr, void *p, void *data);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
-static long e_end_block(struct drbd_work *, int);
+static int e_end_block(struct drbd_work *, int);
 
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
@@ -425,7 +425,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	 */
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		/* list_del not necessary, next/prev members not touched */
-		ok = peer_req->w.cb(&peer_req->w, !ok) && ok;
+		ok = !peer_req->w.cb(&peer_req->w, !ok) && ok;
 		drbd_free_ee(mdev, peer_req);
 	}
 	wake_up(&mdev->ee_wait);
@@ -1464,28 +1464,28 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 
 /* e_end_resync_block() is called via
  * drbd_process_done_ee() by asender only */
-static long e_end_resync_block(struct drbd_work *w, int unused)
+static int e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
-	int ok;
+	int err;
 
 	D_ASSERT(drbd_interval_empty(&peer_req->i));
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(mdev, sector, peer_req->i.size);
-		ok = !drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
+		err = drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
 		drbd_rs_failed_io(mdev, sector, peer_req->i.size);
 
-		ok  = !drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+		err  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 	}
 	dec_unacked(mdev);
 
-	return ok;
+	return err;
 }
 
 static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_size) __releases(local)
@@ -1600,7 +1600,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return ok;
 }
 
-static long w_restart_write(struct drbd_work *w, int cancel)
+static int w_restart_write(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1611,7 +1611,7 @@ static long w_restart_write(struct drbd_work *w, int cancel)
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	if (!expect(req->rq_state & RQ_POSTPONED)) {
 		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
-		return 0;
+		return -EIO;
 	}
 	bio = req->master_bio;
 	start_time = req->start_time;
@@ -1621,7 +1621,7 @@ static long w_restart_write(struct drbd_work *w, int cancel)
 
 	while (__drbd_make_request(mdev, bio, start_time))
 		/* retry */ ;
-	return 1;
+	return 0;
 }
 
 static void restart_conflicting_writes(struct drbd_conf *mdev,
@@ -1648,13 +1648,13 @@ static void restart_conflicting_writes(struct drbd_conf *mdev,
 /* e_end_block() is called via drbd_process_done_ee().
  * this means this function only runs in the asender thread
  */
-static long e_end_block(struct drbd_work *w, int cancel)
+static int e_end_block(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
-	int ok = 1, pcmd;
+	int err = 0, pcmd;
 
 	if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C) {
 		if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
@@ -1662,11 +1662,11 @@ static long e_end_block(struct drbd_work *w, int cancel)
 				mdev->state.conn <= C_PAUSED_SYNC_T &&
 				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			ok &= !drbd_send_ack(mdev, pcmd, peer_req);
+			err = drbd_send_ack(mdev, pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
 				drbd_set_in_sync(mdev, sector, peer_req->i.size);
 		} else {
-			ok  = !drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+			err = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
@@ -1686,7 +1686,7 @@ static long e_end_block(struct drbd_work *w, int cancel)
 
 	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
-	return ok;
+	return err;
 }
 
 static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
@@ -1694,20 +1694,20 @@ static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 	struct drbd_conf *mdev = w->mdev;
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	int ok;
+	int err;
 
-	ok = !drbd_send_ack(mdev, ack, peer_req);
+	err = drbd_send_ack(mdev, ack, peer_req);
 	dec_unacked(mdev);
 
-	return ok;
+	return err;
 }
 
-static long e_send_discard_write(struct drbd_work *w, int unused)
+static int e_send_discard_write(struct drbd_work *w, int unused)
 {
 	return e_send_ack(w, P_DISCARD_WRITE);
 }
 
-static long e_send_retry_write(struct drbd_work *w, int unused)
+static int e_send_retry_write(struct drbd_work *w, int unused)
 {
 	struct drbd_tconn *tconn = w->mdev->tconn;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0bb95b0..c2b2f49 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -38,7 +38,7 @@ struct after_state_chg_work {
 };
 
 extern void _tl_restart(struct drbd_tconn *, enum drbd_req_event what);
-static long w_after_state_ch(struct drbd_work *w, int unused);
+static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static void after_all_state_ch(struct drbd_tconn *tconn);
@@ -919,7 +919,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	return rv;
 }
 
-static long w_after_state_ch(struct drbd_work *w, int unused)
+static int w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
@@ -932,7 +932,7 @@ static long w_after_state_ch(struct drbd_work *w, int unused)
 	}
 	kfree(ascw);
 
-	return 1;
+	return 0;
 }
 
 static void abw_start_sync(struct drbd_conf *mdev, int rv)
@@ -1290,7 +1290,7 @@ static void after_all_state_ch(struct drbd_tconn *tconn)
 	}
 }
 
-static long w_after_conn_state_ch(struct drbd_work *w, int unused)
+static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
 		container_of(w, struct after_conn_state_chg_work, w);
@@ -1307,7 +1307,7 @@ static long w_after_conn_state_ch(struct drbd_work *w, int unused)
 	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
 	after_all_state_ch(tconn);
 
-	return 1;
+	return 0;
 }
 
 static void print_conn_state_change(struct drbd_tconn *tconn, enum drbd_conns oc, enum drbd_conns nc)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 2e09bfe..ae3cb57 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -225,7 +225,7 @@ void drbd_request_endio(struct bio *bio, int error)
 		complete_master_bio(mdev, &m);
 }
 
-long w_read_retry_remote(struct drbd_work *w, int cancel)
+int w_read_retry_remote(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -238,7 +238,7 @@ long w_read_retry_remote(struct drbd_work *w, int cancel)
 	if (cancel || mdev->state.pdsk != D_UP_TO_DATE) {
 		_req_mod(req, READ_RETRY_REMOTE_CANCELED);
 		spin_unlock_irq(&mdev->tconn->req_lock);
-		return 1;
+		return 0;
 	}
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
@@ -294,13 +294,13 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 }
 
 /* MAYBE merge common code with w_e_end_ov_req */
-static long w_e_send_csum(struct drbd_work *w, int cancel)
+static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
 	int digest_size;
 	void *digest;
-	int ok = 1;
+	int err = 0;
 
 	if (unlikely(cancel))
 		goto out;
@@ -322,22 +322,22 @@ static long w_e_send_csum(struct drbd_work *w, int cancel)
 		drbd_free_ee(mdev, peer_req);
 		peer_req = NULL;
 		inc_rs_pending(mdev);
-		ok = !drbd_send_drequest_csum(mdev, sector, size,
+		err = drbd_send_drequest_csum(mdev, sector, size,
 					      digest, digest_size,
 					      P_CSUM_RS_REQUEST);
 		kfree(digest);
 	} else {
 		dev_err(DEV, "kmalloc() of digest failed.\n");
-		ok = 0;
+		err = -ENOMEM;
 	}
 
 out:
 	if (peer_req)
 		drbd_free_ee(mdev, peer_req);
 
-	if (unlikely(!ok))
+	if (unlikely(err))
 		dev_err(DEV, "drbd_send_drequest(..., csum) failed\n");
-	return ok;
+	return err;
 }
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
@@ -381,7 +381,7 @@ defer:
 	return -EAGAIN;
 }
 
-long w_resync_timer(struct drbd_work *w, int cancel)
+int w_resync_timer(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	switch (mdev->state.conn) {
@@ -393,7 +393,7 @@ long w_resync_timer(struct drbd_work *w, int cancel)
 		break;
 	}
 
-	return 1;
+	return 0;
 }
 
 void resync_timer_fn(unsigned long data)
@@ -503,7 +503,7 @@ static int drbd_rs_number_requests(struct drbd_conf *mdev)
 	return number;
 }
 
-long w_make_resync_request(struct drbd_work *w, int cancel)
+int w_make_resync_request(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	unsigned long bit;
@@ -515,12 +515,12 @@ long w_make_resync_request(struct drbd_work *w, int cancel)
 	int i = 0;
 
 	if (unlikely(cancel))
-		return 1;
+		return 0;
 
 	if (mdev->rs_total == 0) {
 		/* empty resync? */
 		drbd_resync_finished(mdev);
-		return 1;
+		return 0;
 	}
 
 	if (!get_ldev(mdev)) {
@@ -529,7 +529,7 @@ long w_make_resync_request(struct drbd_work *w, int cancel)
 		   to continue resync with a broken disk makes no sense at
 		   all */
 		dev_err(DEV, "Disk broke down during resync!\n");
-		return 1;
+		return 0;
 	}
 
 	max_bio_size = queue_max_hw_sectors(mdev->rq_queue) << 9;
@@ -558,7 +558,7 @@ next_sector:
 		if (bit == DRBD_END_OF_BITMAP) {
 			mdev->bm_resync_fo = drbd_bm_bits(mdev);
 			put_ldev(mdev);
-			return 1;
+			return 0;
 		}
 
 		sector = BM_BIT_TO_SECT(bit);
@@ -621,7 +621,7 @@ next_sector:
 			switch (read_for_csum(mdev, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(mdev);
-				return 0;
+				return -EIO;
 			case -EAGAIN: /* allocation failed, or ldev busy */
 				drbd_rs_complete_io(mdev, sector);
 				mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -634,13 +634,16 @@ next_sector:
 				BUG();
 			}
 		} else {
+			int err;
+
 			inc_rs_pending(mdev);
-			if (drbd_send_drequest(mdev, P_RS_DATA_REQUEST,
-					       sector, size, ID_SYNCER)) {
+			err = drbd_send_drequest(mdev, P_RS_DATA_REQUEST,
+						 sector, size, ID_SYNCER);
+			if (err) {
 				dev_err(DEV, "drbd_send_drequest() failed, aborting...\n");
 				dec_rs_pending(mdev);
 				put_ldev(mdev);
-				return 0;
+				return err;
 			}
 		}
 	}
@@ -653,14 +656,14 @@ next_sector:
 		 * until then resync "work" is "inactive" ...
 		 */
 		put_ldev(mdev);
-		return 1;
+		return 0;
 	}
 
  requeue:
 	mdev->rs_in_flight += (i << (BM_BLOCK_SHIFT - 9));
 	mod_timer(&mdev->resync_timer, jiffies + SLEEP_TIME);
 	put_ldev(mdev);
-	return 1;
+	return 0;
 }
 
 static int w_make_ov_request(struct drbd_work *w, int cancel)
@@ -707,24 +710,24 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 	return 1;
 }
 
-long w_ov_finished(struct drbd_work *w, int cancel)
+int w_ov_finished(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
 	ov_oos_print(mdev);
 	drbd_resync_finished(mdev);
 
-	return 1;
+	return 0;
 }
 
-static long w_resync_finished(struct drbd_work *w, int cancel)
+static int w_resync_finished(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
 
 	drbd_resync_finished(mdev);
 
-	return 1;
+	return 0;
 }
 
 static void ping_peer(struct drbd_conf *mdev)
@@ -905,35 +908,35 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-long w_e_end_data_req(struct drbd_work *w, int cancel)
+int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok;
+	int err;
 
 	if (unlikely(cancel)) {
 		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
-		return 1;
+		return 0;
 	}
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		ok = !drbd_send_block(mdev, P_DATA_REPLY, peer_req);
+		err = drbd_send_block(mdev, P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		ok = !drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
+		err = drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
 	}
 
 	dec_unacked(mdev);
 
 	move_to_net_ee_or_free(mdev, peer_req);
 
-	if (unlikely(!ok))
+	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block() failed\n");
-	return ok;
+	return err;
 }
 
 /**
@@ -942,16 +945,16 @@ long w_e_end_data_req(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-long w_e_end_rsdata_req(struct drbd_work *w, int cancel)
+int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok;
+	int err;
 
 	if (unlikely(cancel)) {
 		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
-		return 1;
+		return 0;
 	}
 
 	if (get_ldev_if_state(mdev, D_FAILED)) {
@@ -960,23 +963,23 @@ long w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	}
 
 	if (mdev->state.conn == C_AHEAD) {
-		ok = !drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
+		err = drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
 	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		if (likely(mdev->state.pdsk >= D_INCONSISTENT)) {
 			inc_rs_pending(mdev);
-			ok = !drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
 				dev_err(DEV, "Not sending RSDataReply, "
 				    "partner DISKLESS!\n");
-			ok = 1;
+			err = 0;
 		}
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		ok = !drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
 		drbd_rs_failed_io(mdev, peer_req->i.sector, peer_req->i.size);
@@ -986,24 +989,24 @@ long w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 
 	move_to_net_ee_or_free(mdev, peer_req);
 
-	if (unlikely(!ok))
+	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block() failed\n");
-	return ok;
+	return err;
 }
 
-long w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
+int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
-	int ok, eq = 0;
+	int err, eq = 0;
 
 	if (unlikely(cancel)) {
 		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
-		return 1;
+		return 0;
 	}
 
 	if (get_ldev(mdev)) {
@@ -1032,16 +1035,16 @@ long w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			drbd_set_in_sync(mdev, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
 			mdev->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
-			ok = !drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
+			err = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
 		} else {
 			inc_rs_pending(mdev);
 			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
 			peer_req->flags &= ~EE_HAS_DIGEST; /* This peer request no longer has a digest pointer */
 			kfree(di);
-			ok = !drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		ok = !drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. I guess it gets messy.\n");
 	}
@@ -1049,12 +1052,12 @@ long w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 	dec_unacked(mdev);
 	move_to_net_ee_or_free(mdev, peer_req);
 
-	if (unlikely(!ok))
+	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block/ack() failed\n");
-	return ok;
+	return err;
 }
 
-long w_e_end_ov_req(struct drbd_work *w, int cancel)
+int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1062,7 +1065,7 @@ long w_e_end_ov_req(struct drbd_work *w, int cancel)
 	unsigned int size = peer_req->i.size;
 	int digest_size;
 	void *digest;
-	int ok = 1;
+	int err = 0;
 
 	if (unlikely(cancel))
 		goto out;
@@ -1070,7 +1073,7 @@ long w_e_end_ov_req(struct drbd_work *w, int cancel)
 	digest_size = crypto_hash_digestsize(mdev->tconn->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
-		ok = 0;	/* terminate the connection in case the allocation failed */
+		err = 1;	/* terminate the connection in case the allocation failed */
 		goto out;
 	}
 
@@ -1087,10 +1090,10 @@ long w_e_end_ov_req(struct drbd_work *w, int cancel)
 	drbd_free_ee(mdev, peer_req);
 	peer_req = NULL;
 	inc_rs_pending(mdev);
-	ok = !drbd_send_drequest_csum(mdev, sector, size,
+	err = drbd_send_drequest_csum(mdev, sector, size,
 				      digest, digest_size,
 				      P_OV_REPLY);
-	if (!ok)
+	if (err)
 		dec_rs_pending(mdev);
 	kfree(digest);
 
@@ -1098,7 +1101,7 @@ out:
 	if (peer_req)
 		drbd_free_ee(mdev, peer_req);
 	dec_unacked(mdev);
-	return ok;
+	return err;
 }
 
 void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
@@ -1112,7 +1115,7 @@ void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
 	drbd_set_out_of_sync(mdev, sector, size);
 }
 
-long w_e_end_ov_reply(struct drbd_work *w, int cancel)
+int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1121,12 +1124,12 @@ long w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
-	int ok, eq = 0;
+	int err, eq = 0;
 
 	if (unlikely(cancel)) {
 		drbd_free_ee(mdev, peer_req);
 		dec_unacked(mdev);
-		return 1;
+		return 0;
 	}
 
 	/* after "cancel", because after drbd_disconnect/drbd_rs_cancel_all
@@ -1161,7 +1164,7 @@ long w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	else
 		ov_oos_print(mdev);
 
-	ok = !drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
+	err = drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
 			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
 
 	dec_unacked(mdev);
@@ -1177,23 +1180,23 @@ long w_e_end_ov_reply(struct drbd_work *w, int cancel)
 		drbd_resync_finished(mdev);
 	}
 
-	return ok;
+	return err;
 }
 
-long w_prev_work_done(struct drbd_work *w, int cancel)
+int w_prev_work_done(struct drbd_work *w, int cancel)
 {
 	struct drbd_wq_barrier *b = container_of(w, struct drbd_wq_barrier, w);
 
 	complete(&b->done);
-	return 1;
+	return 0;
 }
 
-long w_send_barrier(struct drbd_work *w, int cancel)
+int w_send_barrier(struct drbd_work *w, int cancel)
 {
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
 	struct drbd_conf *mdev = w->mdev;
 	struct p_barrier *p = &mdev->tconn->data.sbuf.barrier;
-	int ok = 1;
+	int err = 0;
 
 	/* really avoid racing with tl_clear.  w.cb may have been referenced
 	 * just before it was reassigned and re-queued, so double check that.
@@ -1205,44 +1208,45 @@ long w_send_barrier(struct drbd_work *w, int cancel)
 		cancel = 1;
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (cancel)
-		return 1;
-
-	if (drbd_get_data_sock(mdev->tconn))
 		return 0;
+
+	err = drbd_get_data_sock(mdev->tconn);
+	if (err)
+		return err;
 	p->barrier = b->br_number;
 	/* inc_ap_pending was done where this was queued.
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
-	ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
+	err = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
 			     &p->head, sizeof(*p), 0);
 	drbd_put_data_sock(mdev->tconn);
 
-	return ok;
+	return err;
 }
 
-long w_send_write_hint(struct drbd_work *w, int cancel)
+int w_send_write_hint(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	if (cancel)
-		return 1;
-	return !drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
+		return 0;
+	return drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
 }
 
-long w_send_oos(struct drbd_work *w, int cancel)
+int w_send_oos(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok;
+	int err;
 
 	if (unlikely(cancel)) {
 		req_mod(req, SEND_CANCELED);
-		return 1;
+		return 0;
 	}
 
-	ok = !drbd_send_oos(mdev, req);
+	err = drbd_send_oos(mdev, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
-	return ok;
+	return err;
 }
 
 /**
@@ -1251,21 +1255,21 @@ long w_send_oos(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-long w_send_dblock(struct drbd_work *w, int cancel)
+int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok;
+	int err;
 
 	if (unlikely(cancel)) {
 		req_mod(req, SEND_CANCELED);
-		return 1;
+		return 0;
 	}
 
-	ok = !drbd_send_dblock(mdev, req);
-	req_mod(req, ok ? HANDED_OVER_TO_NETWORK : SEND_FAILED);
+	err = drbd_send_dblock(mdev, req);
+	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
 
-	return ok;
+	return err;
 }
 
 /**
@@ -1274,26 +1278,26 @@ long w_send_dblock(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-long w_send_read_req(struct drbd_work *w, int cancel)
+int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok;
+	int err;
 
 	if (unlikely(cancel)) {
 		req_mod(req, SEND_CANCELED);
-		return 1;
+		return 0;
 	}
 
-	ok = !drbd_send_drequest(mdev, P_DATA_REQUEST, req->i.sector, req->i.size,
+	err = drbd_send_drequest(mdev, P_DATA_REQUEST, req->i.sector, req->i.size,
 				 (unsigned long)req);
 
-	req_mod(req, ok ? HANDED_OVER_TO_NETWORK : SEND_FAILED);
+	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
 
-	return ok;
+	return err;
 }
 
-long w_restart_disk_io(struct drbd_work *w, int cancel)
+int w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1309,7 +1313,7 @@ long w_restart_disk_io(struct drbd_work *w, int cancel)
 	req->private_bio->bi_bdev = mdev->ldev->backing_bdev;
 	generic_make_request(req->private_bio);
 
-	return 1;
+	return 0;
 }
 
 static int _drbd_may_sync_now(struct drbd_conf *mdev)
@@ -1450,7 +1454,7 @@ void start_resync_timer_fn(unsigned long data)
 	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
 }
 
-long w_start_resync(struct drbd_work *w, int cancel)
+int w_start_resync(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 
@@ -1458,12 +1462,12 @@ long w_start_resync(struct drbd_work *w, int cancel)
 		dev_warn(DEV, "w_start_resync later...\n");
 		mdev->start_resync_timer.expires = jiffies + HZ/10;
 		add_timer(&mdev->start_resync_timer);
-		return 1;
+		return 0;
 	}
 
 	drbd_start_resync(mdev, C_SYNC_SOURCE);
 	clear_bit(AHEAD_TO_SYNC_SOURCE, &mdev->current_epoch->flags);
-	return 1;
+	return 0;
 }
 
 /**
@@ -1691,7 +1695,7 @@ int drbd_worker(struct drbd_thread *thi)
 		list_del_init(&w->list);
 		spin_unlock_irq(&tconn->data.work.q_lock);
 
-		if (!w->cb(w, tconn->cstate < C_WF_REPORT_PARAMS)) {
+		if (w->cb(w, tconn->cstate < C_WF_REPORT_PARAMS)) {
 			/* dev_warn(DEV, "worker: a callback failed! \n"); */
 			if (tconn->cstate >= C_WF_REPORT_PARAMS)
 				conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
-- 
1.7.4.1

