Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1I2IRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:17:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43442 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1I2IPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/12] drbd: Rename drbd_release_ee() to drbd_free_peer_reqs()
Date: Thu, 29 Sep 2011 10:15:25 +0200
Message-Id: <1317284131-17464-7-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |   14 +++++++-------
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d94c6756..53d6dc3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1455,7 +1455,7 @@ extern int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector);
 extern int drbd_submit_peer_request(struct drbd_conf *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
-extern int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list);
+extern int drbd_free_peer_reqs(struct drbd_conf *, struct list_head *);
 extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_conf *, u64,
 						     sector_t, unsigned int,
 						     gfp_t) __must_hold(local);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f759a7e..5149755 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2153,27 +2153,27 @@ static struct notifier_block drbd_notifier = {
 	.notifier_call = drbd_notify_sys,
 };
 
-static void drbd_release_ee_lists(struct drbd_conf *mdev)
+static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
 {
 	int rr;
 
-	rr = drbd_release_ee(mdev, &mdev->active_ee);
+	rr = drbd_free_peer_reqs(mdev, &mdev->active_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in active list found!\n", rr);
 
-	rr = drbd_release_ee(mdev, &mdev->sync_ee);
+	rr = drbd_free_peer_reqs(mdev, &mdev->sync_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in sync list found!\n", rr);
 
-	rr = drbd_release_ee(mdev, &mdev->read_ee);
+	rr = drbd_free_peer_reqs(mdev, &mdev->read_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in read list found!\n", rr);
 
-	rr = drbd_release_ee(mdev, &mdev->done_ee);
+	rr = drbd_free_peer_reqs(mdev, &mdev->done_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in done list found!\n", rr);
 
-	rr = drbd_release_ee(mdev, &mdev->net_ee);
+	rr = drbd_free_peer_reqs(mdev, &mdev->net_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in net list found!\n", rr);
 }
@@ -2205,7 +2205,7 @@ void drbd_delete_device(unsigned int minor)
 
 	drbd_free_resources(mdev);
 
-	drbd_release_ee_lists(mdev);
+	drbd_release_all_peer_reqs(mdev);
 
 	lc_destroy(mdev->act_log);
 	lc_destroy(mdev->resync);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a8c5c76..b59d2f8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -309,7 +309,7 @@ You need to hold the req_lock:
 You must not have the req_lock:
  drbd_free_peer_req()
  drbd_alloc_peer_req()
- drbd_release_ee()
+ drbd_free_peer_reqs()
  drbd_ee_fix_bhs()
  drbd_process_done_ee()
  drbd_clear_done_ee()
@@ -373,7 +373,7 @@ void __drbd_free_peer_req(struct drbd_conf *mdev, struct drbd_peer_request *peer
 	mempool_free(peer_req, drbd_ee_mempool);
 }
 
-int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
+int drbd_free_peer_reqs(struct drbd_conf *mdev, struct list_head *list)
 {
 	LIST_HEAD(work_list);
 	struct drbd_peer_request *peer_req, *t;
@@ -4175,7 +4175,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 	 * Actually we don't care for exactly when the network stack does its
 	 * put_page(), but release our reference on these pages right here.
 	 */
-	i = drbd_release_ee(mdev, &mdev->net_ee);
+	i = drbd_free_peer_reqs(mdev, &mdev->net_ee);
 	if (i)
 		dev_info(DEV, "net_ee not empty, killed %u entries\n", i);
 	i = atomic_read(&mdev->pp_in_use_by_net);
-- 
1.7.4.1

