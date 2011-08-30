Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1H3JIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38183 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1H3JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/15] drbd: Rename drbd_endio_{pri,sec} -> drbd_{,peer_}request_endio
Date: Tue, 30 Aug 2011 11:05:35 +0200
Message-Id: <1314695149-387-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_receiver.c |   13 +++++++------
 drivers/block/drbd/drbd_req.c      |    4 ++--
 drivers/block/drbd/drbd_req.h      |    2 +-
 drivers/block/drbd/drbd_worker.c   |    8 ++++----
 drivers/block/drbd/drbd_wrappers.h |    4 ++--
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 29e32f7..de92e8b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -661,7 +661,7 @@ struct drbd_request {
 	/* if local IO is not allowed, will be NULL.
 	 * if local IO _is_ allowed, holds the locally submitted bio clone,
 	 * or, after local IO completion, the ERR_PTR(error).
-	 * see drbd_endio_pri(). */
+	 * see drbd_request_endio(). */
 	struct bio *private_bio;
 
 	struct drbd_interval i;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9b18cc9..deae7cb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1139,7 +1139,7 @@ next_bio:
 	bio->bi_bdev = mdev->ldev->backing_bdev;
 	bio->bi_rw = rw;
 	bio->bi_private = peer_req;
-	bio->bi_end_io = drbd_endio_sec;
+	bio->bi_end_io = drbd_peer_request_endio;
 
 	bio->bi_next = bios;
 	bios = bio;
@@ -1575,7 +1575,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (get_ldev(mdev)) {
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
-		 * or in drbd_endio_sec. */
+		 * or in drbd_peer_request_endio. */
 		ok = recv_resync_read(mdev, sector, data_size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1763,10 +1763,11 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		return drbd_drain_block(mdev, data_size);
 	}
 
-	/* get_ldev(mdev) successful.
-	 * Corresponding put_ldev done either below (on various errors),
-	 * or in drbd_endio_sec, if we successfully submit the data at
-	 * the end of this function. */
+	/*
+	 * Corresponding put_ldev done either below (on various errors), or in
+	 * drbd_peer_request_endio, if we successfully submit the data at the
+	 * end of this function.
+	 */
 
 	sector = be64_to_cpu(p->sector);
 	peer_req = read_in_block(mdev, p->block_id, sector, data_size);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 45a543e..18eb3d1 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -116,7 +116,7 @@ static void _req_is_done(struct drbd_conf *mdev, struct drbd_request *req, const
 			drbd_set_in_sync(mdev, req->i.sector, req->i.size);
 
 		/* one might be tempted to move the drbd_al_complete_io
-		 * to the local io completion callback drbd_endio_pri.
+		 * to the local io completion callback drbd_request_endio.
 		 * but, if this was a mirror write, we may only
 		 * drbd_al_complete_io after this is RQ_NET_DONE,
 		 * otherwise the extent could be dropped from the al
@@ -252,7 +252,7 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 		 * what we need to do here is just: complete the master_bio.
 		 *
 		 * local completion error, if any, has been stored as ERR_PTR
-		 * in private_bio within drbd_endio_pri.
+		 * in private_bio within drbd_request_endio.
 		 */
 		int ok = (s & RQ_LOCAL_OK) || (s & RQ_NET_OK);
 		int error = PTR_ERR(req->private_bio);
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index e6232ce..e6f2361 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -230,7 +230,7 @@ static inline void drbd_req_make_private_bio(struct drbd_request *req, struct bi
 	req->private_bio = bio;
 
 	bio->bi_private  = req;
-	bio->bi_end_io   = drbd_endio_pri;
+	bio->bi_end_io   = drbd_request_endio;
 	bio->bi_next     = NULL;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 2da2d23..01ab0bc 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -45,8 +45,8 @@ static int w_make_resync_request(struct drbd_work *w, int cancel);
 
 /* endio handlers:
  *   drbd_md_io_complete (defined here)
- *   drbd_endio_pri (defined here)
- *   drbd_endio_sec (defined here)
+ *   drbd_request_endio (defined here)
+ *   drbd_peer_request_endio (defined here)
  *   bm_async_io_complete (defined in drbd_bitmap.c)
  *
  * For all these callbacks, note the following:
@@ -151,7 +151,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_endio_sec(struct bio *bio, int error)
+void drbd_peer_request_endio(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -187,7 +187,7 @@ void drbd_endio_sec(struct bio *bio, int error)
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_endio_pri(struct bio *bio, int error)
+void drbd_request_endio(struct bio *bio, int error)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index 151f1a3..decf9b2 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -20,8 +20,8 @@ static inline void drbd_set_my_capacity(struct drbd_conf *mdev,
 
 /* bi_end_io handlers */
 extern void drbd_md_io_complete(struct bio *bio, int error);
-extern void drbd_endio_sec(struct bio *bio, int error);
-extern void drbd_endio_pri(struct bio *bio, int error);
+extern void drbd_peer_request_endio(struct bio *bio, int error);
+extern void drbd_request_endio(struct bio *bio, int error);
 
 /*
  * used to submit our private bio
-- 
1.7.4.1

