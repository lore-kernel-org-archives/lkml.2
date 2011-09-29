Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1I2ITP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:19:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43421 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1I2IPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/12] drbd: Rename drbd_alloc_ee() to drbd_alloc_peer_req()
Date: Thu, 29 Sep 2011 10:15:23 +0200
Message-Id: <1317284131-17464-5-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    6 +++---
 drivers/block/drbd/drbd_receiver.c |   12 ++++++------
 drivers/block/drbd/drbd_worker.c   |    3 ++-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8f67093..3198eb1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1456,9 +1456,9 @@ extern int drbd_submit_peer_request(struct drbd_conf *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
 extern int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list);
-extern struct drbd_peer_request *drbd_alloc_ee(struct drbd_conf *,
-					       u64, sector_t, unsigned int,
-					       gfp_t) __must_hold(local);
+extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_conf *, u64,
+						     sector_t, unsigned int,
+						     gfp_t) __must_hold(local);
 extern void drbd_free_some_ee(struct drbd_conf *, struct drbd_peer_request *,
 			      int);
 #define drbd_free_ee(m,e)	drbd_free_some_ee(m, e, 0)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b4ab05e..0187426 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -308,7 +308,7 @@ You need to hold the req_lock:
 
 You must not have the req_lock:
  drbd_free_ee()
- drbd_alloc_ee()
+ drbd_alloc_peer_req()
  drbd_release_ee()
  drbd_ee_fix_bhs()
  drbd_process_done_ee()
@@ -317,8 +317,8 @@ You must not have the req_lock:
 */
 
 struct drbd_peer_request *
-drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
-	      unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
+drbd_alloc_peer_req(struct drbd_conf *mdev, u64 id, sector_t sector,
+		    unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
 	struct drbd_peer_request *peer_req;
 	struct page *page;
@@ -330,7 +330,7 @@ drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
 	peer_req = mempool_alloc(drbd_ee_mempool, gfp_mask & ~__GFP_HIGHMEM);
 	if (!peer_req) {
 		if (!(gfp_mask & __GFP_NOWARN))
-			dev_err(DEV, "alloc_ee: Allocation of an EE failed\n");
+			dev_err(DEV, "%s: allocation failed\n", __func__);
 		return NULL;
 	}
 
@@ -1379,7 +1379,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_ee(mdev, id, sector, data_size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(mdev, id, sector, data_size, GFP_NOIO);
 	if (!peer_req)
 		return NULL;
 
@@ -2240,7 +2240,7 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_ee(mdev, p->block_id, sector, size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(mdev, p->block_id, sector, size, GFP_NOIO);
 	if (!peer_req) {
 		put_ldev(mdev);
 		return -ENOMEM;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3c7b6d7..dfdfb5a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -354,7 +354,8 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
-	peer_req = drbd_alloc_ee(mdev, ID_SYNCER /* unused */, sector, size, GFP_TRY);
+	peer_req = drbd_alloc_peer_req(mdev, ID_SYNCER /* unused */, sector,
+				       size, GFP_TRY);
 	if (!peer_req)
 		goto defer;
 
-- 
1.7.4.1

