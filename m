Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1IGQrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:47:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48577 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1IGQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/14] drbd: receive_bitmap(): Use the pre-allocated receive buffer
Date: Wed,  7 Sep 2011 16:17:35 +0200
Message-Id: <1315405061-1473-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3738d56..e5099db 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3572,8 +3572,9 @@ static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
  */
 static int
 receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
-		     unsigned long *buffer, struct bm_xfer_ctx *c)
+		     struct p_header *h, struct bm_xfer_ctx *c)
 {
+	unsigned long *buffer = (unsigned long *)h->payload;
 	unsigned num_words = min_t(size_t, BM_PACKET_WORDS, c->bm_words - c->word_offset);
 	unsigned want = num_words * sizeof(long);
 	int err;
@@ -3748,7 +3749,6 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 			  unsigned int data_size)
 {
 	struct bm_xfer_ctx c;
-	void *buffer;
 	int err;
 	struct p_header *h = mdev->tconn->data.rbuf;
 	struct packet_info pi;
@@ -3757,15 +3757,6 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	/* you are supposed to send additional out-of-sync information
 	 * if you actually set bits during this phase */
 
-	/* maybe we should use some per thread scratch page,
-	 * and allocate that during initial device creation? */
-	buffer	 = (unsigned long *) __get_free_page(GFP_NOIO);
-	if (!buffer) {
-		dev_err(DEV, "failed to allocate one page buffer in %s\n", __func__);
-		err = -ENOMEM;
-		goto out;
-	}
-
 	c = (struct bm_xfer_ctx) {
 		.bm_bits = drbd_bm_bits(mdev),
 		.bm_words = drbd_bm_words(mdev),
@@ -3773,7 +3764,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	for(;;) {
 		if (cmd == P_BITMAP) {
-			err = receive_bitmap_plain(mdev, data_size, buffer, &c);
+			err = receive_bitmap_plain(mdev, data_size, h, &c);
 		} else if (cmd == P_COMPRESSED_BITMAP) {
 			/* MAYBE: sanity check that we speak proto >= 90,
 			 * and the feature is enabled! */
@@ -3784,9 +3775,8 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 				err = -EIO;
 				goto out;
 			}
-			/* use the page buff */
-			p = buffer;
-			memcpy(p, h, sizeof(*h));
+
+			p = mdev->tconn->data.rbuf;
 			err = drbd_recv_all(mdev->tconn, p->head.payload, data_size);
 			if (err)
 			       goto out;
@@ -3840,7 +3830,6 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	drbd_bm_unlock(mdev);
 	if (!err && mdev->state.conn == C_WF_BITMAP_S)
 		drbd_start_resync(mdev, C_SYNC_SOURCE);
-	free_page((unsigned long) buffer);
 	return err;
 }
 
-- 
1.7.4.1

