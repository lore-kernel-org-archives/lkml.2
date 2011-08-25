Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1HYPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:16:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35604 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1HYPKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 095/118] drbd: Moved the mdev member into drbd_work (from drbd_request and drbd_peer_request)
Date: Thu, 25 Aug 2011 17:08:31 +0200
Message-Id: <1314284934-17999-96-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    2 ++
 drivers/block/drbd/drbd_int.h      |    5 ++---
 drivers/block/drbd/drbd_main.c     |    8 ++++++++
 drivers/block/drbd/drbd_nl.c       |    6 +++---
 drivers/block/drbd/drbd_receiver.c |   10 ++++++----
 drivers/block/drbd/drbd_req.c      |   11 ++++++-----
 drivers/block/drbd/drbd_req.h      |    4 ++--
 drivers/block/drbd/drbd_state.c    |    1 +
 drivers/block/drbd/drbd_worker.c   |    8 ++++----
 9 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 7943177..637a937 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -228,6 +228,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
 		al_work.enr = enr;
 		al_work.old_enr = al_ext->lc_number;
 		al_work.w.cb = w_al_write_transaction;
+		al_work.w.mdev = mdev;
 		drbd_queue_work_front(&mdev->tconn->data.work, &al_work.w);
 		wait_for_completion(&al_work.event);
 
@@ -717,6 +718,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_conf *mdev, sector_t sector,
 			if (udw) {
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
+				udw->w.mdev = mdev;
 				drbd_queue_work_front(&mdev->tconn->data.work, &udw->w);
 			} else {
 				dev_warn(DEV, "Could not kmalloc an udw\n");
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 388dc1d..5be0ae8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -644,13 +644,13 @@ typedef int (*drbd_work_cb)(struct drbd_conf *, struct drbd_work *, int cancel);
 struct drbd_work {
 	struct list_head list;
 	drbd_work_cb cb;
+	struct drbd_conf *mdev;
 };
 
 #include "drbd_interval.h"
 
 struct drbd_request {
 	struct drbd_work w;
-	struct drbd_conf *mdev;
 
 	/* if local IO is not allowed, will be NULL.
 	 * if local IO _is_ allowed, holds the locally submitted bio clone,
@@ -714,7 +714,6 @@ struct digest_info {
 struct drbd_peer_request {
 	struct drbd_work w;
 	struct drbd_epoch *epoch; /* for writes */
-	struct drbd_conf *mdev;
 	struct page *pages;
 	atomic_t pending_bios;
 	struct drbd_interval i;
@@ -1536,7 +1535,7 @@ extern void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 		struct list_head *head);
 extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
-extern void drbd_flush_workqueue(struct drbd_tconn *tconn);
+extern void drbd_flush_workqueue(struct drbd_conf *mdev);
 
 /* yes, there is kernel_setsockopt, but only since 2.6.18. we don't need to
  * mess with get_fs/set_fs, we know we are KERNEL_DS always. */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b427c1a..b054b7b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1848,6 +1848,14 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	mdev->md_sync_work.cb = w_md_sync;
 	mdev->bm_io_work.w.cb = w_bitmap_io;
 	mdev->start_resync_work.cb = w_start_resync;
+
+	mdev->resync_work.mdev  = mdev;
+	mdev->unplug_work.mdev  = mdev;
+	mdev->go_diskless.mdev  = mdev;
+	mdev->md_sync_work.mdev = mdev;
+	mdev->bm_io_work.w.mdev = mdev;
+	mdev->start_resync_work.mdev = mdev;
+
 	init_timer(&mdev->resync_timer);
 	init_timer(&mdev->md_sync_timer);
 	init_timer(&mdev->start_resync_timer);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 331495f..0debe58 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -876,7 +876,7 @@ static void drbd_reconfig_start(struct drbd_conf *mdev)
 	wait_event(mdev->state_wait, !test_and_set_bit(CONFIG_PENDING, &mdev->flags));
 	wait_event(mdev->state_wait, !test_bit(DEVICE_DYING, &mdev->flags));
 	drbd_thread_start(&mdev->tconn->worker);
-	drbd_flush_workqueue(mdev->tconn);
+	drbd_flush_workqueue(mdev);
 }
 
 /* if still unconfigured, stops worker again.
@@ -1076,7 +1076,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	/* also wait for the last barrier ack. */
 	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_pending_cnt) || is_susp(mdev->state));
 	/* and for any other previously queued work */
-	drbd_flush_workqueue(mdev->tconn);
+	drbd_flush_workqueue(mdev);
 
 	rv = _drbd_request_state(mdev, NS(disk, D_ATTACHING), CS_VERBOSE);
 	retcode = rv;  /* FIXME: Type mismatch. */
@@ -1520,7 +1520,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		}
 	}
 
-	drbd_flush_workqueue(mdev->tconn);
+	drbd_flush_workqueue(mdev);
 	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->tconn->net_conf != NULL) {
 		retcode = ERR_NET_CONFIGURED;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c280fa8..183e533 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -345,7 +345,7 @@ drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
 	peer_req->i.waiting = false;
 
 	peer_req->epoch = NULL;
-	peer_req->mdev = mdev;
+	peer_req->w.mdev = mdev;
 	peer_req->pages = page;
 	atomic_set(&peer_req->pending_bios, 0);
 	peer_req->flags = 0;
@@ -3823,13 +3823,14 @@ static void drbdd(struct drbd_tconn *tconn)
 	}
 }
 
-void drbd_flush_workqueue(struct drbd_tconn *tconn)
+void drbd_flush_workqueue(struct drbd_conf *mdev)
 {
 	struct drbd_wq_barrier barr;
 
 	barr.w.cb = w_prev_work_done;
+	barr.w.mdev = mdev;
 	init_completion(&barr.done);
-	drbd_queue_work(&tconn->data.work, &barr.w);
+	drbd_queue_work(&mdev->tconn->data.work, &barr.w);
 	wait_for_completion(&barr.done);
 }
 
@@ -3909,7 +3910,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 	/* wait for all w_e_end_data_req, w_e_end_rsdata_req, w_send_barrier,
 	 * w_make_resync_request etc. which may still be on the worker queue
 	 * to be "canceled" */
-	drbd_flush_workqueue(mdev->tconn);
+	drbd_flush_workqueue(mdev);
 
 	/* This also does reclaim_net_ee().  If we do this too early, we might
 	 * miss some resync ee and pages.*/
@@ -4510,6 +4511,7 @@ static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 		w = kmalloc(sizeof(*w), GFP_NOIO);
 		if (w) {
 			w->cb = w_ov_finished;
+			w->mdev = mdev;
 			drbd_queue_work_front(&mdev->tconn->data.work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 6bcf417..45a543e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -67,7 +67,7 @@ static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 
 	drbd_req_make_private_bio(req, bio_src);
 	req->rq_state    = bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0;
-	req->mdev        = mdev;
+	req->w.mdev      = mdev;
 	req->master_bio  = bio_src;
 	req->epoch       = 0;
 
@@ -155,6 +155,7 @@ static void queue_barrier(struct drbd_conf *mdev)
 
 	b = mdev->tconn->newest_tle;
 	b->w.cb = w_send_barrier;
+	b->w.mdev = mdev;
 	/* inc_ap_pending done here, so we won't
 	 * get imbalanced on connection loss.
 	 * dec_ap_pending will be done in got_BarrierAck
@@ -192,7 +193,7 @@ void complete_master_bio(struct drbd_conf *mdev,
 static void drbd_remove_request_interval(struct rb_root *root,
 					 struct drbd_request *req)
 {
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	struct drbd_interval *i = &req->i;
 
 	drbd_remove_interval(root, i);
@@ -211,7 +212,7 @@ static void drbd_remove_request_interval(struct rb_root *root,
 void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 {
 	const unsigned long s = req->rq_state;
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	/* only WRITES may end up here without a master bio (on barrier ack) */
 	int rw = req->master_bio ? bio_data_dir(req->master_bio) : WRITE;
 
@@ -294,7 +295,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 
 static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_error *m)
 {
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 
 	if (!is_susp(mdev->state))
 		_req_may_be_done(req, m);
@@ -315,7 +316,7 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
 int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	int rv = 0;
 	m->bio = NULL;
 
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 431e3f9..e6232ce 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -255,7 +255,7 @@ extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
  * outside the spinlock, e.g. when walking some list on cleanup. */
 static inline int _req_mod(struct drbd_request *req, enum drbd_req_event what)
 {
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	struct bio_and_error m;
 	int rv;
 
@@ -275,7 +275,7 @@ static inline int req_mod(struct drbd_request *req,
 		enum drbd_req_event what)
 {
 	unsigned long flags;
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	struct bio_and_error m;
 	int rv;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 38d330b..3667984 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -843,6 +843,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 		ascw->ns = ns;
 		ascw->flags = flags;
 		ascw->w.cb = w_after_state_ch;
+		ascw->w.mdev = mdev;
 		ascw->done = done;
 		drbd_queue_work(&mdev->tconn->data.work, &ascw->w);
 	} else {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 16db1f4..cac65f6 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -83,7 +83,7 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = peer_req->mdev;
+	struct drbd_conf *mdev = peer_req->w.mdev;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	mdev->read_cnt += peer_req->i.size >> 9;
@@ -103,7 +103,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = peer_req->mdev;
+	struct drbd_conf *mdev = peer_req->w.mdev;
 	sector_t e_sector;
 	int do_wake;
 	u64 block_id;
@@ -155,7 +155,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 void drbd_endio_sec(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
-	struct drbd_conf *mdev = peer_req->mdev;
+	struct drbd_conf *mdev = peer_req->w.mdev;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
@@ -192,7 +192,7 @@ void drbd_endio_pri(struct bio *bio, int error)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
-	struct drbd_conf *mdev = req->mdev;
+	struct drbd_conf *mdev = req->w.mdev;
 	struct bio_and_error m;
 	enum drbd_req_event what;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
-- 
1.7.4.1

