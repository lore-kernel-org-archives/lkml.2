Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1HYP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:28:30 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34080 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1HYPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:27 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 047/118] drbd: Move some functions to where they are used
Date: Thu, 25 Aug 2011 17:07:43 +0200
Message-Id: <1314284934-17999-48-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Move drbd_update_congested() to drbd_main.c, and drbd_req_new() and
drbd_req_free() to drbd_req.c: those functions are not used anywhere
else.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    7 -------
 drivers/block/drbd/drbd_main.c |    7 +++++++
 drivers/block/drbd/drbd_req.c  |   29 +++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_req.h  |   26 --------------------------
 4 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index fafadb6..e917859 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2355,13 +2355,6 @@ static inline int drbd_set_ed_uuid(struct drbd_conf *mdev, u64 val)
 	return changed;
 }
 
-static inline void drbd_update_congested(struct drbd_conf *mdev)
-{
-	struct sock *sk = mdev->tconn->data.socket->sk;
-	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
-		set_bit(NET_CONGESTED, &mdev->flags);
-}
-
 static inline int drbd_queue_order_type(struct drbd_conf *mdev)
 {
 	/* sorry, we currently have no working implementation
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index fbd3f04..13aadca 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2528,6 +2528,13 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 	return drop_it; /* && (mdev->state == R_PRIMARY) */;
 }
 
+static void drbd_update_congested(struct drbd_conf *mdev)
+{
+	struct sock *sk = mdev->tconn->data.socket->sk;
+	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
+		set_bit(NET_CONGESTED, &mdev->flags);
+}
+
 /* The idea of sendpage seems to be to put some kind of reference
  * to the page into the skb, and to hand it over to the NIC. In
  * this process get_page() gets called.
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 74179f7..25fa87c 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -56,6 +56,35 @@ static void _drbd_end_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
 	part_stat_unlock();
 }
 
+static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
+					       struct bio *bio_src)
+{
+	struct drbd_request *req;
+
+	req = mempool_alloc(drbd_request_mempool, GFP_NOIO);
+	if (!req)
+		return NULL;
+
+	drbd_req_make_private_bio(req, bio_src);
+	req->rq_state    = bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0;
+	req->mdev        = mdev;
+	req->master_bio  = bio_src;
+	req->epoch       = 0;
+	drbd_clear_interval(&req->i);
+	req->i.sector     = bio_src->bi_sector;
+	req->i.size      = bio_src->bi_size;
+	INIT_LIST_HEAD(&req->tl_requests);
+	INIT_LIST_HEAD(&req->w.list);
+
+	return req;
+}
+
+static void drbd_req_free(struct drbd_request *req)
+{
+	mempool_free(req, drbd_request_mempool);
+}
+
+/* rw is bio_data_dir(), only READ or WRITE */
 static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const int rw)
 {
 	const unsigned long s = req->rq_state;
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 4b0858b..431e3f9 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -234,32 +234,6 @@ static inline void drbd_req_make_private_bio(struct drbd_request *req, struct bi
 	bio->bi_next     = NULL;
 }
 
-static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
-	struct bio *bio_src)
-{
-	struct drbd_request *req =
-		mempool_alloc(drbd_request_mempool, GFP_NOIO);
-	if (likely(req)) {
-		drbd_req_make_private_bio(req, bio_src);
-
-		req->rq_state    = bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0;
-		req->mdev        = mdev;
-		req->master_bio  = bio_src;
-		req->epoch       = 0;
-		req->i.sector     = bio_src->bi_sector;
-		req->i.size      = bio_src->bi_size;
-		drbd_clear_interval(&req->i);
-		INIT_LIST_HEAD(&req->tl_requests);
-		INIT_LIST_HEAD(&req->w.list);
-	}
-	return req;
-}
-
-static inline void drbd_req_free(struct drbd_request *req)
-{
-	mempool_free(req, drbd_request_mempool);
-}
-
 /* Short lived temporary struct on the stack.
  * We could squirrel the error to be returned into
  * bio->bi_size, or similar. But that would be too ugly. */
-- 
1.7.4.1

