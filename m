Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1IELsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60932 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1IELqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 52/54] drbd: Rename various functions from *_oos_* to *_out_of_sync_* for clarity
Date: Mon,  5 Sep 2011 13:45:43 +0200
Message-Id: <1315223145-20640-53-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    8 ++++----
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 drivers/block/drbd/drbd_req.c      |    6 +++---
 drivers/block/drbd/drbd_req.h      |    2 +-
 drivers/block/drbd/drbd_worker.c   |   14 +++++++-------
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f2f3287..72835f8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1191,7 +1191,7 @@ extern void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 			     struct p_data *dp, int data_size);
 extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
-extern int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req);
+extern int drbd_send_out_of_sync(struct drbd_conf *, struct drbd_request *);
 extern int drbd_send_block(struct drbd_conf *, enum drbd_packet,
 			   struct drbd_peer_request *);
 extern int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req);
@@ -1528,10 +1528,10 @@ extern int drbd_resync_finished(struct drbd_conf *mdev);
 /* maybe rather drbd_main.c ? */
 extern int drbd_md_sync_page_io(struct drbd_conf *mdev,
 		struct drbd_backing_dev *bdev, sector_t sector, int rw);
-extern void drbd_ov_oos_found(struct drbd_conf*, sector_t, int);
+extern void drbd_ov_out_of_sync_found(struct drbd_conf *, sector_t, int);
 extern void drbd_rs_controller_reset(struct drbd_conf *mdev);
 
-static inline void ov_oos_print(struct drbd_conf *mdev)
+static inline void ov_out_of_sync_print(struct drbd_conf *mdev)
 {
 	if (mdev->ov_last_oos_size) {
 		dev_err(DEV, "Out of sync: start=%llu, size=%lu (sectors)\n",
@@ -1562,7 +1562,7 @@ extern int w_send_read_req(struct drbd_work *, int);
 extern int w_prev_work_done(struct drbd_work *, int);
 extern int w_e_reissue(struct drbd_work *, int);
 extern int w_restart_disk_io(struct drbd_work *, int);
-extern int w_send_oos(struct drbd_work *, int);
+extern int w_send_out_of_sync(struct drbd_work *, int);
 extern int w_start_resync(struct drbd_work *, int);
 
 extern void resync_timer_fn(unsigned long data);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4e25e50..0288aa9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1654,7 +1654,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return err;
 }
 
-int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
+int drbd_send_out_of_sync(struct drbd_conf *mdev, struct drbd_request *req)
 {
 	struct p_block_desc p;
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 795d86e..74b9428 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4696,9 +4696,9 @@ static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
 
 	if (be64_to_cpu(p->block_id) == ID_OUT_OF_SYNC)
-		drbd_ov_oos_found(mdev, sector, size);
+		drbd_ov_out_of_sync_found(mdev, sector, size);
 	else
-		ov_oos_print(mdev);
+		ov_out_of_sync_print(mdev);
 
 	if (!get_ldev(mdev))
 		return true;
@@ -4720,7 +4720,7 @@ static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 			drbd_queue_work_front(&mdev->tconn->data.work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
-			ov_oos_print(mdev);
+			ov_out_of_sync_print(mdev);
 			drbd_resync_finished(mdev);
 		}
 	}
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3430dab..e380ffb 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -477,7 +477,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case QUEUE_FOR_SEND_OOS:
 		req->rq_state |= RQ_NET_QUEUED;
-		req->w.cb =  w_send_oos;
+		req->w.cb =  w_send_out_of_sync;
 		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 		break;
 
@@ -786,7 +786,7 @@ int __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long s
 	}
 
 	remote = remote && drbd_should_do_remote(mdev->state);
-	send_oos = rw == WRITE && drbd_should_send_oos(mdev->state);
+	send_oos = rw == WRITE && drbd_should_send_out_of_sync(mdev->state);
 	D_ASSERT(!(remote && send_oos));
 
 	if (!(local || remote) && !is_susp(mdev->state)) {
@@ -842,7 +842,7 @@ allocate_barrier:
 
 	if (remote || send_oos) {
 		remote = drbd_should_do_remote(mdev->state);
-		send_oos = rw == WRITE && drbd_should_send_oos(mdev->state);
+		send_oos = rw == WRITE && drbd_should_send_out_of_sync(mdev->state);
 		D_ASSERT(!(remote && send_oos));
 
 		if (!(remote || send_oos))
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 7cfcf3d..4e1f129 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -304,7 +304,7 @@ static inline bool drbd_should_do_remote(union drbd_state s)
 	   That is equivalent since before 96 IO was frozen in the C_WF_BITMAP*
 	   states. */
 }
-static inline bool drbd_should_send_oos(union drbd_state s)
+static inline bool drbd_should_send_out_of_sync(union drbd_state s)
 {
 	return s.conn == C_AHEAD || s.conn == C_WF_BITMAP_S;
 	/* pdsk = D_INCONSISTENT as a consequence. Protocol 96 check not necessary
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index ae3cb57..e96a816 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -714,7 +714,7 @@ int w_ov_finished(struct drbd_work *w, int cancel)
 {
 	struct drbd_conf *mdev = w->mdev;
 	kfree(w);
-	ov_oos_print(mdev);
+	ov_out_of_sync_print(mdev);
 	drbd_resync_finished(mdev);
 
 	return 0;
@@ -1104,7 +1104,7 @@ out:
 	return err;
 }
 
-void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
+void drbd_ov_out_of_sync_found(struct drbd_conf *mdev, sector_t sector, int size)
 {
 	if (mdev->ov_last_oos_start + mdev->ov_last_oos_size == sector) {
 		mdev->ov_last_oos_size += size>>9;
@@ -1160,9 +1160,9 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	 * drbd_pp_alloc due to pp_in_use > max_buffers. */
 	drbd_free_ee(mdev, peer_req);
 	if (!eq)
-		drbd_ov_oos_found(mdev, sector, size);
+		drbd_ov_out_of_sync_found(mdev, sector, size);
 	else
-		ov_oos_print(mdev);
+		ov_out_of_sync_print(mdev);
 
 	err = drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
 			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
@@ -1176,7 +1176,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 		drbd_advance_rs_marks(mdev, mdev->ov_left);
 
 	if (mdev->ov_left == 0) {
-		ov_oos_print(mdev);
+		ov_out_of_sync_print(mdev);
 		drbd_resync_finished(mdev);
 	}
 
@@ -1232,7 +1232,7 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 	return drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
 }
 
-int w_send_oos(struct drbd_work *w, int cancel)
+int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
 	struct drbd_conf *mdev = w->mdev;
@@ -1243,7 +1243,7 @@ int w_send_oos(struct drbd_work *w, int cancel)
 		return 0;
 	}
 
-	err = drbd_send_oos(mdev, req);
+	err = drbd_send_out_of_sync(mdev, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return err;
-- 
1.7.4.1

