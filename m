Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1HYPO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:14:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32935 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1HYPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 102/118] drbd: Generalized the work callbacks
Date: Thu, 25 Aug 2011 17:08:38 +0200
Message-Id: <1314284934-17999-103-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer work callbacks must operate on a mdev. From now on they
can also operate on a tconn.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    8 ++-
 drivers/block/drbd/drbd_int.h      |   45 ++++++++++---------
 drivers/block/drbd/drbd_main.c     |   17 +++++---
 drivers/block/drbd/drbd_receiver.c |   13 ++++--
 drivers/block/drbd/drbd_state.c    |    5 +-
 drivers/block/drbd/drbd_worker.c   |   82 +++++++++++++++++++++--------------
 6 files changed, 100 insertions(+), 70 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 637a937..0748871 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -63,7 +63,7 @@ struct drbd_atodb_wait {
 };
 
 
-int w_al_write_transaction(struct drbd_conf *, struct drbd_work *, int);
+int w_al_write_transaction(struct drbd_work *, int);
 
 static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 				 struct drbd_backing_dev *bdev,
@@ -291,9 +291,10 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 }
 
 int
-w_al_write_transaction(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
+	struct drbd_conf *mdev = w->mdev;
 	struct lc_element *updated = aw->al_ext;
 	const unsigned int new_enr = aw->enr;
 	const unsigned int evicted = aw->old_enr;
@@ -612,9 +613,10 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	wake_up(&mdev->al_wait);
 }
 
-static int w_update_odbm(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
+	struct drbd_conf *mdev = w->mdev;
 
 	if (!get_ldev(mdev)) {
 		if (__ratelimit(&drbd_ratelimit_state))
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ddbb3d2..12f0c5e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -640,11 +640,14 @@ static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
 }
 
 struct drbd_work;
-typedef int (*drbd_work_cb)(struct drbd_conf *, struct drbd_work *, int cancel);
+typedef int (*drbd_work_cb)(struct drbd_work *, int cancel);
 struct drbd_work {
 	struct list_head list;
 	drbd_work_cb cb;
-	struct drbd_conf *mdev;
+	union {
+		struct drbd_conf *mdev;
+		struct drbd_tconn *tconn;
+	};
 };
 
 #include "drbd_interval.h"
@@ -1494,25 +1497,25 @@ extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *
 extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
 			 struct drbd_peer_request *, void *);
 /* worker callbacks */
-extern int w_req_cancel_conflict(struct drbd_conf *, struct drbd_work *, int);
-extern int w_read_retry_remote(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_end_data_req(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_end_rsdata_req(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_end_csum_rs_req(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_end_ov_reply(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_end_ov_req(struct drbd_conf *, struct drbd_work *, int);
-extern int w_ov_finished(struct drbd_conf *, struct drbd_work *, int);
-extern int w_resync_timer(struct drbd_conf *, struct drbd_work *, int);
-extern int w_resume_next_sg(struct drbd_conf *, struct drbd_work *, int);
-extern int w_send_write_hint(struct drbd_conf *, struct drbd_work *, int);
-extern int w_send_dblock(struct drbd_conf *, struct drbd_work *, int);
-extern int w_send_barrier(struct drbd_conf *, struct drbd_work *, int);
-extern int w_send_read_req(struct drbd_conf *, struct drbd_work *, int);
-extern int w_prev_work_done(struct drbd_conf *, struct drbd_work *, int);
-extern int w_e_reissue(struct drbd_conf *, struct drbd_work *, int);
-extern int w_restart_disk_io(struct drbd_conf *, struct drbd_work *, int);
-extern int w_send_oos(struct drbd_conf *, struct drbd_work *, int);
-extern int w_start_resync(struct drbd_conf *, struct drbd_work *, int);
+extern int w_req_cancel_conflict(struct drbd_work *, int);
+extern int w_read_retry_remote(struct drbd_work *, int);
+extern int w_e_end_data_req(struct drbd_work *, int);
+extern int w_e_end_rsdata_req(struct drbd_work *, int);
+extern int w_e_end_csum_rs_req(struct drbd_work *, int);
+extern int w_e_end_ov_reply(struct drbd_work *, int);
+extern int w_e_end_ov_req(struct drbd_work *, int);
+extern int w_ov_finished(struct drbd_work *, int);
+extern int w_resync_timer(struct drbd_work *, int);
+extern int w_resume_next_sg(struct drbd_work *, int);
+extern int w_send_write_hint(struct drbd_work *, int);
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
index 8f04fd0..3b49d0e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -64,10 +64,10 @@ int drbd_asender(struct drbd_thread *);
 int drbd_init(void);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
 static int drbd_release(struct gendisk *gd, fmode_t mode);
-static int w_md_sync(struct drbd_conf *mdev, struct drbd_work *w, int unused);
+static int w_md_sync(struct drbd_work *w, int unused);
 static void md_sync_timer_fn(unsigned long data);
-static int w_bitmap_io(struct drbd_conf *mdev, struct drbd_work *w, int unused);
-static int w_go_diskless(struct drbd_conf *mdev, struct drbd_work *w, int unused);
+static int w_bitmap_io(struct drbd_work *w, int unused);
+static int w_go_diskless(struct drbd_work *w, int unused);
 
 MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
 	      "Lars Ellenberg <lars@linbit.com>");
@@ -2803,9 +2803,10 @@ int drbd_bmio_clear_n_write(struct drbd_conf *mdev)
 	return rv;
 }
 
-static int w_bitmap_io(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int w_bitmap_io(struct drbd_work *w, int unused)
 {
 	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
+	struct drbd_conf *mdev = w->mdev;
 	int rv = -EIO;
 
 	D_ASSERT(atomic_read(&mdev->ap_bio_cnt) == 0);
@@ -2848,8 +2849,10 @@ void drbd_ldev_destroy(struct drbd_conf *mdev)
 	clear_bit(GO_DISKLESS, &mdev->flags);
 }
 
-static int w_go_diskless(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int w_go_diskless(struct drbd_work *w, int unused)
 {
+	struct drbd_conf *mdev = w->mdev;
+
 	D_ASSERT(mdev->state.disk == D_FAILED);
 	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
 	 * inc/dec it frequently. Once we are D_DISKLESS, no one will touch
@@ -2962,8 +2965,10 @@ static void md_sync_timer_fn(unsigned long data)
 	drbd_queue_work_front(&mdev->tconn->data.work, &mdev->md_sync_work);
 }
 
-static int w_md_sync(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int w_md_sync(struct drbd_work *w, int unused)
 {
+	struct drbd_conf *mdev = w->mdev;
+
 	dev_warn(DEV, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
 #ifdef DEBUG
 	dev_warn(DEV, "last md_mark_dirty: %s:%u\n",
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 54eb53f..55fc243 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -65,7 +65,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn);
 static int drbd_disconnected(int vnr, void *p, void *data);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
-static int e_end_block(struct drbd_conf *, struct drbd_work *, int);
+static int e_end_block(struct drbd_work *, int);
 
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
@@ -420,7 +420,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	 */
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		/* list_del not necessary, next/prev members not touched */
-		ok = peer_req->w.cb(mdev, &peer_req->w, !ok) && ok;
+		ok = peer_req->w.cb(&peer_req->w, !ok) && ok;
 		drbd_free_ee(mdev, peer_req);
 	}
 	wake_up(&mdev->ee_wait);
@@ -1450,9 +1450,10 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 
 /* e_end_resync_block() is called via
  * drbd_process_done_ee() by asender only */
-static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
+	struct drbd_conf *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	int ok;
 
@@ -1587,9 +1588,10 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 /* e_end_block() is called via drbd_process_done_ee().
  * this means this function only runs in the asender thread
  */
-static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+static int e_end_block(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
+	struct drbd_conf *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	int ok = 1, pcmd;
 
@@ -1624,9 +1626,10 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int e_send_discard_ack(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req = (struct drbd_peer_request *)w;
+	struct drbd_conf *mdev = w->mdev;
 	int ok = 1;
 
 	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 3667984..30a3a1d 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -40,7 +40,7 @@ struct after_state_chg_work {
 
 extern void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
 int drbd_send_state_req(struct drbd_conf *, union drbd_state, union drbd_state);
-static int w_after_state_ch(struct drbd_conf *mdev, struct drbd_work *w, int unused);
+static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
@@ -853,10 +853,11 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	return rv;
 }
 
-static int w_after_state_ch(struct drbd_conf *mdev, struct drbd_work *w, int unused)
+static int w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
+	struct drbd_conf *mdev = w->mdev;
 
 	after_state_ch(mdev, ascw->os, ascw->ns, ascw->flags);
 	if (ascw->flags & CS_WAIT_COMPLETE) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3f0f84a..418f44a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -38,9 +38,8 @@
 #include "drbd_int.h"
 #include "drbd_req.h"
 
-static int w_make_ov_request(struct drbd_conf *mdev, struct drbd_work *w, int cancel);
-static int w_make_resync_request(struct drbd_conf *mdev,
-				 struct drbd_work *w, int cancel);
+static int w_make_ov_request(struct drbd_work *w, int cancel);
+static int w_make_resync_request(struct drbd_work *w, int cancel);
 
 
 
@@ -228,9 +227,10 @@ void drbd_endio_pri(struct bio *bio, int error)
 		complete_master_bio(mdev, &m);
 }
 
-int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_read_retry_remote(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
 
 	/* We should not detach for read io-error,
 	 * but try to WRITE the P_DATA_REPLY to the failed location,
@@ -244,7 +244,7 @@ int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	}
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	return w_send_read_req(mdev, w, 0);
+	return w_send_read_req(w, 0);
 }
 
 void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
@@ -295,11 +295,10 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 	crypto_hash_final(&desc, digest);
 }
 
-/* TODO merge common code with w_e_end_ov_req */
-int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req =
-		container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int digest_size;
 	void *digest;
 	int ok = 1;
@@ -383,14 +382,15 @@ defer:
 	return -EAGAIN;
 }
 
-int w_resync_timer(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_resync_timer(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	switch (mdev->state.conn) {
 	case C_VERIFY_S:
-		w_make_ov_request(mdev, w, cancel);
+		w_make_ov_request(w, cancel);
 		break;
 	case C_SYNC_TARGET:
-		w_make_resync_request(mdev, w, cancel);
+		w_make_resync_request(w, cancel);
 		break;
 	}
 
@@ -504,9 +504,9 @@ static int drbd_rs_number_requests(struct drbd_conf *mdev)
 	return number;
 }
 
-static int w_make_resync_request(struct drbd_conf *mdev,
-				 struct drbd_work *w, int cancel)
+static int w_make_resync_request(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	unsigned long bit;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -664,8 +664,9 @@ next_sector:
 	return 1;
 }
 
-static int w_make_ov_request(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+static int w_make_ov_request(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	int number, i, size;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -707,8 +708,9 @@ static int w_make_ov_request(struct drbd_conf *mdev, struct drbd_work *w, int ca
 	return 1;
 }
 
-int w_ov_finished(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_ov_finished(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
 	ov_oos_print(mdev);
 	drbd_resync_finished(mdev);
@@ -716,8 +718,9 @@ int w_ov_finished(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return 1;
 }
 
-static int w_resync_finished(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+static int w_resync_finished(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
 
 	drbd_resync_finished(mdev);
@@ -901,9 +904,10 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -937,9 +941,10 @@ int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -985,9 +990,10 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1047,10 +1053,10 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-/* TODO merge common code with w_e_send_csum */
-int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1105,9 +1111,10 @@ void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
 	drbd_set_out_of_sync(mdev, sector, size);
 }
 
-int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
@@ -1172,16 +1179,18 @@ int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_prev_work_done(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_prev_work_done(struct drbd_work *w, int cancel)
 {
 	struct drbd_wq_barrier *b = container_of(w, struct drbd_wq_barrier, w);
+
 	complete(&b->done);
 	return 1;
 }
 
-int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_send_barrier(struct drbd_work *w, int cancel)
 {
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
+	struct drbd_conf *mdev = w->mdev;
 	struct p_barrier *p = &mdev->tconn->data.sbuf.barrier;
 	int ok = 1;
 
@@ -1210,16 +1219,18 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_send_write_hint(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_send_write_hint(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
 	if (cancel)
 		return 1;
 	return drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
 }
 
-int w_send_oos(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_send_oos(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -1239,9 +1250,10 @@ int w_send_oos(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_send_dblock(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -1261,9 +1273,10 @@ int w_send_dblock(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_send_read_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -1285,9 +1298,10 @@ int w_send_read_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_restart_disk_io(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
+	struct drbd_conf *mdev = w->mdev;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
 		drbd_al_begin_io(mdev, req->i.sector);
@@ -1447,8 +1461,10 @@ void start_resync_timer_fn(unsigned long data)
 	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
 }
 
-int w_start_resync(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+int w_start_resync(struct drbd_work *w, int cancel)
 {
+	struct drbd_conf *mdev = w->mdev;
+
 	if (atomic_read(&mdev->unacked_cnt) || atomic_read(&mdev->rs_pending_cnt)) {
 		dev_warn(DEV, "w_start_resync later...\n");
 		mdev->start_resync_timer.expires = jiffies + HZ/10;
@@ -1702,7 +1718,7 @@ int drbd_worker(struct drbd_thread *thi)
 		list_del_init(&w->list);
 		spin_unlock_irq(&tconn->data.work.q_lock);
 
-		if (!w->cb(w->mdev, w, tconn->volume0->state.conn < C_CONNECTED)) {
+		if (!w->cb(w, tconn->volume0->state.conn < C_CONNECTED)) {
 			/* dev_warn(DEV, "worker: a callback failed! \n"); */
 			if (tconn->volume0->state.conn >= C_CONNECTED)
 				drbd_force_state(tconn->volume0,
@@ -1718,7 +1734,7 @@ int drbd_worker(struct drbd_thread *thi)
 		while (!list_empty(&work_list)) {
 			w = list_entry(work_list.next, struct drbd_work, list);
 			list_del_init(&w->list);
-			w->cb(w->mdev, w, 1);
+			w->cb(w, 1);
 		}
 
 		spin_lock_irq(&tconn->data.work.q_lock);
-- 
1.7.4.1

