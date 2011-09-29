Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1I2IRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:17:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43452 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab1I2IPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/12] drbd: Rename reclaim_net_ee(), drbd_process_done_ee(), drbd_process_done_ee(), tconn_process_done_ee() to *_peer_reqs
Date: Thu, 29 Sep 2011 10:15:26 +0200
Message-Id: <1317284131-17464-8-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   42 ++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b59d2f8..0eda1f0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -195,7 +195,8 @@ static struct page *drbd_pp_first_pages_or_try_alloc(struct drbd_conf *mdev, int
 	return NULL;
 }
 
-static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed)
+static void reclaim_finished_net_peer_reqs(struct drbd_conf *mdev,
+					   struct list_head *to_be_freed)
 {
 	struct drbd_peer_request *peer_req;
 	struct list_head *le, *tle;
@@ -219,7 +220,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 	struct drbd_peer_request *peer_req, *t;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	reclaim_net_ee(mdev, &reclaimed);
+	reclaim_finished_net_peer_reqs(mdev, &reclaimed);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
@@ -311,7 +312,7 @@ You must not have the req_lock:
  drbd_alloc_peer_req()
  drbd_free_peer_reqs()
  drbd_ee_fix_bhs()
- drbd_process_done_ee()
+ drbd_finish_peer_reqs()
  drbd_clear_done_ee()
  drbd_wait_ee_list_empty()
 */
@@ -391,15 +392,10 @@ int drbd_free_peer_reqs(struct drbd_conf *mdev, struct list_head *list)
 	return count;
 }
 
-
-/* See also comments in _req_mod(,BARRIER_ACKED)
- * and receive_Barrier.
- *
- * Move entries from net_ee to done_ee, if ready.
- * Grab done_ee, call all callbacks, free the entries.
- * The callbacks typically send out ACKs.
+/*
+ * See also comments in _req_mod(,BARRIER_ACKED) and receive_Barrier.
  */
-static int drbd_process_done_ee(struct drbd_conf *mdev)
+static int drbd_finish_peer_reqs(struct drbd_conf *mdev)
 {
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
@@ -407,7 +403,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	int err = 0;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	reclaim_net_ee(mdev, &reclaimed);
+	reclaim_finished_net_peer_reqs(mdev, &reclaimed);
 	list_splice_init(&mdev->done_ee, &work_list);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
@@ -1491,8 +1487,10 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	return 0;
 }
 
-/* e_end_resync_block() is called via
- * drbd_process_done_ee() by asender only */
+/*
+ * e_end_resync_block() is called in asender context via
+ * drbd_finish_peer_reqs().
+ */
 static int e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req =
@@ -1681,8 +1679,8 @@ static void restart_conflicting_writes(struct drbd_conf *mdev,
 	}
 }
 
-/* e_end_block() is called via drbd_process_done_ee().
- * this means this function only runs in the asender thread
+/*
+ * e_end_block() is called in asender context via drbd_finish_peer_reqs().
  */
 static int e_end_block(struct drbd_work *w, int cancel)
 {
@@ -4146,9 +4144,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 	 * to be "canceled" */
 	drbd_flush_workqueue(mdev);
 
-	/* This also does reclaim_net_ee().  If we do this too early, we might
-	 * miss some resync ee and pages.*/
-	drbd_process_done_ee(mdev);
+	drbd_finish_peer_reqs(mdev);
 
 	kfree(mdev->p_uuid);
 	mdev->p_uuid = NULL;
@@ -4813,7 +4809,7 @@ static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 }
 
-static int tconn_process_done_ee(struct drbd_tconn *tconn)
+static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
 	int i, not_empty = 0;
@@ -4822,7 +4818,7 @@ static int tconn_process_done_ee(struct drbd_tconn *tconn)
 		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 		flush_signals(current);
 		idr_for_each_entry(&tconn->volumes, mdev, i) {
-			if (drbd_process_done_ee(mdev))
+			if (drbd_finish_peer_reqs(mdev))
 				return 1; /* error */
 		}
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
@@ -4895,8 +4891,8 @@ int drbd_asender(struct drbd_thread *thi)
 		   much to send */
 		if (!tconn->net_conf->no_cork)
 			drbd_tcp_cork(tconn->meta.socket);
-		if (tconn_process_done_ee(tconn)) {
-			conn_err(tconn, "tconn_process_done_ee() failed\n");
+		if (tconn_finish_peer_reqs(tconn)) {
+			conn_err(tconn, "tconn_finish_peer_reqs() failed\n");
 			goto reconnect;
 		}
 		/* but unconditionally uncork unless disabled */
-- 
1.7.4.1

