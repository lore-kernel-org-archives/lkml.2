Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1I2IRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:17:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43441 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1I2IPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/12] drbd: Rename drbd_free_ee() and variants to *_peer_req()
Date: Thu, 29 Sep 2011 10:15:24 +0200
Message-Id: <1317284131-17464-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
References: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 ++++----
 drivers/block/drbd/drbd_receiver.c |   22 +++++++++++-----------
 drivers/block/drbd/drbd_worker.c   |   22 +++++++++++-----------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3198eb1..d94c6756 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1459,10 +1459,10 @@ extern int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list);
 extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_conf *, u64,
 						     sector_t, unsigned int,
 						     gfp_t) __must_hold(local);
-extern void drbd_free_some_ee(struct drbd_conf *, struct drbd_peer_request *,
-			      int);
-#define drbd_free_ee(m,e)	drbd_free_some_ee(m, e, 0)
-#define drbd_free_net_ee(m,e)	drbd_free_some_ee(m, e, 1)
+extern void __drbd_free_peer_req(struct drbd_conf *, struct drbd_peer_request *,
+				 int);
+#define drbd_free_peer_req(m,e) __drbd_free_peer_req(m, e, 0)
+#define drbd_free_net_peer_req(m,e) __drbd_free_peer_req(m, e, 1)
 extern void drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 		struct list_head *head);
 extern void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0187426..a8c5c76 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -223,7 +223,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
-		drbd_free_net_ee(mdev, peer_req);
+		drbd_free_net_peer_req(mdev, peer_req);
 }
 
 /**
@@ -307,7 +307,7 @@ You need to hold the req_lock:
  _drbd_wait_ee_list_empty()
 
 You must not have the req_lock:
- drbd_free_ee()
+ drbd_free_peer_req()
  drbd_alloc_peer_req()
  drbd_release_ee()
  drbd_ee_fix_bhs()
@@ -362,7 +362,7 @@ drbd_alloc_peer_req(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return NULL;
 }
 
-void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_peer_request *peer_req,
+void __drbd_free_peer_req(struct drbd_conf *mdev, struct drbd_peer_request *peer_req,
 		       int is_net)
 {
 	if (peer_req->flags & EE_HAS_DIGEST)
@@ -385,7 +385,7 @@ int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
-		drbd_free_some_ee(mdev, peer_req, is_net);
+		__drbd_free_peer_req(mdev, peer_req, is_net);
 		count++;
 	}
 	return count;
@@ -412,7 +412,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
-		drbd_free_net_ee(mdev, peer_req);
+		drbd_free_net_peer_req(mdev, peer_req);
 
 	/* possible callbacks here:
 	 * e_end_block, and e_end_resync_block, e_send_discard_write.
@@ -425,7 +425,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 		err2 = peer_req->w.cb(&peer_req->w, !!err);
 		if (!err)
 			err = err2;
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 	}
 	wake_up(&mdev->ee_wait);
 
@@ -1395,7 +1395,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		}
 		kunmap(page);
 		if (err) {
-			drbd_free_ee(mdev, peer_req);
+			drbd_free_peer_req(mdev, peer_req);
 			return NULL;
 		}
 		ds -= len;
@@ -1406,7 +1406,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
-			drbd_free_ee(mdev, peer_req);
+			drbd_free_peer_req(mdev, peer_req);
 			return NULL;
 		}
 	}
@@ -1547,7 +1547,7 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 	list_del(&peer_req->w.list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 fail:
 	put_ldev(mdev);
 	return -EIO;
@@ -2109,7 +2109,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 out_interrupted:
 	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + EV_CLEANUP);
 	put_ldev(mdev);
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 	return err;
 }
 
@@ -2364,7 +2364,7 @@ submit:
 
 out_free_e:
 	put_ldev(mdev);
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 	return -EIO;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index dfdfb5a..d2317c7 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -319,7 +319,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 		 * some distributed deadlock, if the other side blocks on
 		 * congestion as well, because our receiver blocks in
 		 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 		peer_req = NULL;
 		inc_rs_pending(mdev);
 		err = drbd_send_drequest_csum(mdev, sector, size,
@@ -333,7 +333,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 
 out:
 	if (peer_req)
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 
 	if (unlikely(err))
 		dev_err(DEV, "drbd_send_drequest(..., csum) failed\n");
@@ -376,7 +376,7 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 	list_del(&peer_req->w.list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 defer:
 	put_ldev(mdev);
 	return -EAGAIN;
@@ -900,7 +900,7 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
 		spin_unlock_irq(&mdev->tconn->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 }
 
 /**
@@ -916,7 +916,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 	int err;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 		dec_unacked(mdev);
 		return 0;
 	}
@@ -953,7 +953,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	int err;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 		dec_unacked(mdev);
 		return 0;
 	}
@@ -1005,7 +1005,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 	int err, eq = 0;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 		dec_unacked(mdev);
 		return 0;
 	}
@@ -1088,7 +1088,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	 * some distributed deadlock, if the other side blocks on
 	 * congestion as well, because our receiver blocks in
 	 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 	peer_req = NULL;
 	inc_rs_pending(mdev);
 	err = drbd_send_drequest_csum(mdev, sector, size,
@@ -1100,7 +1100,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 
 out:
 	if (peer_req)
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 	dec_unacked(mdev);
 	return err;
 }
@@ -1128,7 +1128,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	int err, eq = 0;
 
 	if (unlikely(cancel)) {
-		drbd_free_ee(mdev, peer_req);
+		drbd_free_peer_req(mdev, peer_req);
 		dec_unacked(mdev);
 		return 0;
 	}
@@ -1159,7 +1159,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	 * some distributed deadlock, if the other side blocks on
 	 * congestion as well, because our receiver blocks in
 	 * drbd_pp_alloc due to pp_in_use > max_buffers. */
-	drbd_free_ee(mdev, peer_req);
+	drbd_free_peer_req(mdev, peer_req);
 	if (!eq)
 		drbd_ov_out_of_sync_found(mdev, sector, size);
 	else
-- 
1.7.4.1

