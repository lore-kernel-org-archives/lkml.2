Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1HYPJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32953 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1HYPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 037/118] drbd: Preparing to use p_header96 for all packets
Date: Thu, 25 Aug 2011 17:07:33 +0200
Message-Id: <1314284934-17999-38-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

recv_bm_rle_bits() should not make any assumptions abou the layout
of the packet header

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index fbf9382..12fdd73 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3393,7 +3393,8 @@ receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
 static int
 recv_bm_rle_bits(struct drbd_conf *mdev,
 		struct p_compressed_bm *p,
-		struct bm_xfer_ctx *c)
+		 struct bm_xfer_ctx *c,
+		 unsigned int len)
 {
 	struct bitstream bs;
 	u64 look_ahead;
@@ -3401,7 +3402,6 @@ recv_bm_rle_bits(struct drbd_conf *mdev,
 	u64 tmp;
 	unsigned long s = c->bit_offset;
 	unsigned long e;
-	int len = be16_to_cpu(p->head.length) - (sizeof(*p) - sizeof(p->head));
 	int toggle = DCBP_get_start(p);
 	int have;
 	int bits;
@@ -3458,10 +3458,11 @@ recv_bm_rle_bits(struct drbd_conf *mdev,
 static int
 decode_bitmap_c(struct drbd_conf *mdev,
 		struct p_compressed_bm *p,
-		struct bm_xfer_ctx *c)
+		struct bm_xfer_ctx *c,
+		unsigned int len)
 {
 	if (DCBP_get_code(p) == RLE_VLI_Bits)
-		return recv_bm_rle_bits(mdev, p, c);
+		return recv_bm_rle_bits(mdev, p, c, len);
 
 	/* other variants had been implemented for evaluation,
 	 * but have been dropped as this one turned out to be "best"
@@ -3560,7 +3561,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigne
 				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", data_size);
 				goto out;
 			}
-			err = decode_bitmap_c(mdev, p, &c);
+			err = decode_bitmap_c(mdev, p, &c, data_size);
 		} else {
 			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", cmd);
 			goto out;
-- 
1.7.4.1

