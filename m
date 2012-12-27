Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2L0CCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:02:11 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43639 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2L0CBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:01:03 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 30/32] virtio-blk: Convert to batch completion
Date: Wed, 26 Dec 2012 18:00:09 -0800
Message-Id: <1356573611-18590-33-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/virtio_blk.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0bdde8f..6b659d1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -210,7 +210,8 @@ static void virtblk_bio_send_flush_work(struct work_struct *work)
 	virtblk_bio_send_flush(vbr);
 }
 
-static inline void virtblk_request_done(struct virtblk_req *vbr)
+static inline void virtblk_request_done(struct virtblk_req *vbr,
+					struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	struct request *req = vbr->req;
@@ -224,11 +225,12 @@ static inline void virtblk_request_done(struct virtblk_req *vbr)
 		req->errors = (error != 0);
 	}
 
-	__blk_end_request_all(req, error);
+	blk_end_request_all_batch(req, error, batch);
 	mempool_free(vbr, vblk->pool);
 }
 
-static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_flush_done(struct virtblk_req *vbr,
+					  struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -237,12 +239,13 @@ static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
 		INIT_WORK(&vbr->work, virtblk_bio_send_data_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_data_done(struct virtblk_req *vbr,
+					 struct batch_complete *batch)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
@@ -252,17 +255,18 @@ static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
 		INIT_WORK(&vbr->work, virtblk_bio_send_flush_work);
 		queue_work(virtblk_wq, &vbr->work);
 	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
+		bio_endio_batch(vbr->bio, virtblk_result(vbr), batch);
 		mempool_free(vbr, vblk->pool);
 	}
 }
 
-static inline void virtblk_bio_done(struct virtblk_req *vbr)
+static inline void virtblk_bio_done(struct virtblk_req *vbr,
+				    struct batch_complete *batch)
 {
 	if (unlikely(vbr->flags & VBLK_IS_FLUSH))
-		virtblk_bio_flush_done(vbr);
+		virtblk_bio_flush_done(vbr, batch);
 	else
-		virtblk_bio_data_done(vbr);
+		virtblk_bio_data_done(vbr, batch);
 }
 
 static void virtblk_done(struct virtqueue *vq)
@@ -272,16 +276,19 @@ static void virtblk_done(struct virtqueue *vq)
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 			if (vbr->bio) {
-				virtblk_bio_done(vbr);
+				virtblk_bio_done(vbr, &batch);
 				bio_done = true;
 			} else {
-				virtblk_request_done(vbr);
+				virtblk_request_done(vbr, &batch);
 				req_done = true;
 			}
 		}
@@ -291,6 +298,8 @@ static void virtblk_done(struct virtqueue *vq)
 		blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 
+	batch_complete(&batch);
+
 	if (bio_done)
 		wake_up(&vblk->queue_wait);
 }
-- 
1.7.12

