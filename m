Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1IELtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60183 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1IELqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 35/54] drbd: Temporarily change the return type of all worker callbacks
Date: Mon,  5 Sep 2011 13:45:26 +0200
Message-Id: <1315223145-20640-36-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This helps to ensure that we don't miss one of them when changing their
return value semantics.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    6 ++--
 drivers/block/drbd/drbd_int.h      |   37 +++++++++++++++++----------------
 drivers/block/drbd/drbd_main.c     |   13 +++++------
 drivers/block/drbd/drbd_receiver.c |   12 +++++-----
 drivers/block/drbd/drbd_state.c    |    6 ++--
 drivers/block/drbd/drbd_worker.c   |   40 +++++++++++++++++------------------
 6 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 92a16ea..d0d52c4 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -106,7 +106,7 @@ struct drbd_atodb_wait {
 };
 
 
-int w_al_write_transaction(struct drbd_work *, int);
+static long w_al_write_transaction(struct drbd_work *, int);
 
 static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 				 struct drbd_backing_dev *bdev,
@@ -298,7 +298,7 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-int
+static long
 w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
@@ -688,7 +688,7 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	wake_up(&mdev->al_wait);
 }
 
-static int w_update_odbm(struct drbd_work *w, int unused)
+static long w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
 	struct drbd_conf *mdev = w->mdev;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 24d3202..bdc4f30 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -644,7 +644,7 @@ static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
 }
 
 struct drbd_work;
-typedef int (*drbd_work_cb)(struct drbd_work *, int cancel);
+typedef long (*drbd_work_cb)(struct drbd_work *, int cancel);
 struct drbd_work {
 	struct list_head list;
 	drbd_work_cb cb;
@@ -1546,23 +1546,24 @@ extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *
 extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
 			 struct drbd_peer_request *, void *);
 /* worker callbacks */
-extern int w_read_retry_remote(struct drbd_work *, int);
-extern int w_e_end_data_req(struct drbd_work *, int);
-extern int w_e_end_rsdata_req(struct drbd_work *, int);
-extern int w_e_end_csum_rs_req(struct drbd_work *, int);
-extern int w_e_end_ov_reply(struct drbd_work *, int);
-extern int w_e_end_ov_req(struct drbd_work *, int);
-extern int w_ov_finished(struct drbd_work *, int);
-extern int w_resync_timer(struct drbd_work *, int);
-extern int w_send_write_hint(struct drbd_work *, int);
-extern int w_send_dblock(struct drbd_work *, int);
-extern int w_send_barrier(struct drbd_work *, int);
-extern int w_send_read_req(struct drbd_work *, int);
-extern int w_prev_work_done(struct drbd_work *, int);
-extern int w_e_reissue(struct drbd_work *, int);
-extern int w_restart_disk_io(struct drbd_work *, int);
-extern int w_send_oos(struct drbd_work *, int);
-extern int w_start_resync(struct drbd_work *, int);
+extern long w_read_retry_remote(struct drbd_work *, int);
+extern long w_e_end_data_req(struct drbd_work *, int);
+extern long w_e_end_rsdata_req(struct drbd_work *, int);
+extern long w_e_end_csum_rs_req(struct drbd_work *, int);
+extern long w_e_end_ov_reply(struct drbd_work *, int);
+extern long w_e_end_ov_req(struct drbd_work *, int);
+extern long w_ov_finished(struct drbd_work *, int);
+extern long w_resync_timer(struct drbd_work *, int);
+extern long w_send_write_hint(struct drbd_work *, int);
+extern long w_make_resync_request(struct drbd_work *, int);
+extern long w_send_dblock(struct drbd_work *, int);
+extern long w_send_barrier(struct drbd_work *, int);
+extern long w_send_read_req(struct drbd_work *, int);
+extern long w_prev_work_done(struct drbd_work *, int);
+extern long w_e_reissue(struct drbd_work *, int);
+extern long w_restart_disk_io(struct drbd_work *, int);
+extern long w_send_oos(struct drbd_work *, int);
+extern long w_start_resync(struct drbd_work *, int);
 
 extern void resync_timer_fn(unsigned long data);
 extern void start_resync_timer_fn(unsigned long data);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 68baeea..5be218e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -64,10 +64,10 @@ int drbd_asender(struct drbd_thread *);
 int drbd_init(void);
 static int drbd_open(struct block_device *bdev, fmode_t mode);
 static int drbd_release(struct gendisk *gd, fmode_t mode);
-static int w_md_sync(struct drbd_work *w, int unused);
+static long w_md_sync(struct drbd_work *w, int unused);
 static void md_sync_timer_fn(unsigned long data);
-static int w_bitmap_io(struct drbd_work *w, int unused);
-static int w_go_diskless(struct drbd_work *w, int unused);
+static long w_bitmap_io(struct drbd_work *w, int unused);
+static long w_go_diskless(struct drbd_work *w, int unused);
 
 MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
 	      "Lars Ellenberg <lars@linbit.com>");
@@ -1830,7 +1830,6 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->rs_pending_cnt, 0);
 	atomic_set(&mdev->unacked_cnt, 0);
 	atomic_set(&mdev->local_cnt, 0);
-	atomic_set(&mdev->pp_in_use, 0);
 	atomic_set(&mdev->pp_in_use_by_net, 0);
 	atomic_set(&mdev->rs_sect_in, 0);
 	atomic_set(&mdev->rs_sect_ev, 0);
@@ -2886,7 +2885,7 @@ int drbd_bmio_clear_n_write(struct drbd_conf *mdev)
 	return rv;
 }
 
-static int w_bitmap_io(struct drbd_work *w, int unused)
+static long w_bitmap_io(struct drbd_work *w, int unused)
 {
 	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -2927,7 +2926,7 @@ void drbd_ldev_destroy(struct drbd_conf *mdev)
 	clear_bit(GO_DISKLESS, &mdev->flags);
 }
 
-static int w_go_diskless(struct drbd_work *w, int unused)
+static long w_go_diskless(struct drbd_work *w, int unused)
 {
 	struct drbd_conf *mdev = w->mdev;
 
@@ -3043,7 +3042,7 @@ static void md_sync_timer_fn(unsigned long data)
 	drbd_queue_work_front(&mdev->tconn->data.work, &mdev->md_sync_work);
 }
 
-static int w_md_sync(struct drbd_work *w, int unused)
+static long w_md_sync(struct drbd_work *w, int unused)
 {
 	struct drbd_conf *mdev = w->mdev;
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 572d9cc..e8a51be 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -70,7 +70,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn);
 static int drbd_disconnected(int vnr, void *p, void *data);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
-static int e_end_block(struct drbd_work *, int);
+static long e_end_block(struct drbd_work *, int);
 
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
@@ -1464,7 +1464,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 
 /* e_end_resync_block() is called via
  * drbd_process_done_ee() by asender only */
-static int e_end_resync_block(struct drbd_work *w, int unused)
+static long e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
@@ -1600,7 +1600,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return ok;
 }
 
-static int w_restart_write(struct drbd_work *w, int cancel)
+static long w_restart_write(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1648,7 +1648,7 @@ static void restart_conflicting_writes(struct drbd_conf *mdev,
 /* e_end_block() is called via drbd_process_done_ee().
  * this means this function only runs in the asender thread
  */
-static int e_end_block(struct drbd_work *w, int cancel)
+static long e_end_block(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
@@ -1702,12 +1702,12 @@ static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 	return ok;
 }
 
-static int e_send_discard_write(struct drbd_work *w, int unused)
+static long e_send_discard_write(struct drbd_work *w, int unused)
 {
 	return e_send_ack(w, P_DISCARD_WRITE);
 }
 
-static int e_send_retry_write(struct drbd_work *w, int unused)
+static long e_send_retry_write(struct drbd_work *w, int unused)
 {
 	struct drbd_tconn *tconn = w->mdev->tconn;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 46fee12..0bb95b0 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -38,7 +38,7 @@ struct after_state_chg_work {
 };
 
 extern void _tl_restart(struct drbd_tconn *, enum drbd_req_event what);
-static int w_after_state_ch(struct drbd_work *w, int unused);
+static long w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static void after_all_state_ch(struct drbd_tconn *tconn);
@@ -919,7 +919,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	return rv;
 }
 
-static int w_after_state_ch(struct drbd_work *w, int unused)
+static long w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
@@ -1290,7 +1290,7 @@ static void after_all_state_ch(struct drbd_tconn *tconn)
 	}
 }
 
-static int w_after_conn_state_ch(struct drbd_work *w, int unused)
+static long w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
 		container_of(w, struct after_conn_state_chg_work, w);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 81d71c7..2e09bfe 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -39,8 +39,6 @@
 #include "drbd_req.h"
 
 static int w_make_ov_request(struct drbd_work *w, int cancel);
-static int w_make_resync_request(struct drbd_work *w, int cancel);
-
 
 
 /* endio handlers:
@@ -227,7 +225,7 @@ void drbd_request_endio(struct bio *bio, int error)
 		complete_master_bio(mdev, &m);
 }
 
-int w_read_retry_remote(struct drbd_work *w, int cancel)
+long w_read_retry_remote(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -296,7 +294,7 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 }
 
 /* MAYBE merge common code with w_e_end_ov_req */
-static int w_e_send_csum(struct drbd_work *w, int cancel)
+static long w_e_send_csum(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -383,7 +381,7 @@ defer:
 	return -EAGAIN;
 }
 
-int w_resync_timer(struct drbd_work *w, int cancel)
+long w_resync_timer(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	switch (mdev->state.conn) {
@@ -505,7 +503,7 @@ static int drbd_rs_number_requests(struct drbd_conf *mdev)
 	return number;
 }
 
-static int w_make_resync_request(struct drbd_work *w, int cancel)
+long w_make_resync_request(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	unsigned long bit;
@@ -709,7 +707,7 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 	return 1;
 }
 
-int w_ov_finished(struct drbd_work *w, int cancel)
+long w_ov_finished(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
@@ -719,7 +717,7 @@ int w_ov_finished(struct drbd_work *w, int cancel)
 	return 1;
 }
 
-static int w_resync_finished(struct drbd_work *w, int cancel)
+static long w_resync_finished(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
@@ -907,7 +905,7 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_e_end_data_req(struct drbd_work *w, int cancel)
+long w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -944,7 +942,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
+long w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -993,7 +991,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
+long w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1056,7 +1054,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_e_end_ov_req(struct drbd_work *w, int cancel)
+long w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1114,7 +1112,7 @@ void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
 	drbd_set_out_of_sync(mdev, sector, size);
 }
 
-int w_e_end_ov_reply(struct drbd_work *w, int cancel)
+long w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1182,7 +1180,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_prev_work_done(struct drbd_work *w, int cancel)
+long w_prev_work_done(struct drbd_work *w, int cancel)
 {
 	struct drbd_wq_barrier *b = container_of(w, struct drbd_wq_barrier, w);
 
@@ -1190,7 +1188,7 @@ int w_prev_work_done(struct drbd_work *w, int cancel)
 	return 1;
 }
 
-int w_send_barrier(struct drbd_work *w, int cancel)
+long w_send_barrier(struct drbd_work *w, int cancel)
 {
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1222,7 +1220,7 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_send_write_hint(struct drbd_work *w, int cancel)
+long w_send_write_hint(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	if (cancel)
@@ -1230,7 +1228,7 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 	return !drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
 }
 
-int w_send_oos(struct drbd_work *w, int cancel)
+long w_send_oos(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1253,7 +1251,7 @@ int w_send_oos(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_send_dblock(struct drbd_work *w, int cancel)
+long w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1276,7 +1274,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
-int w_send_read_req(struct drbd_work *w, int cancel)
+long w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1295,7 +1293,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 	return ok;
 }
 
-int w_restart_disk_io(struct drbd_work *w, int cancel)
+long w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1452,7 +1450,7 @@ void start_resync_timer_fn(unsigned long data)
 	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
 }
 
-int w_start_resync(struct drbd_work *w, int cancel)
+long w_start_resync(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 
-- 
1.7.4.1

