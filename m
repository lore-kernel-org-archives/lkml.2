Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1IGQqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:46:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48579 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1IGQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/14] drbd: Rename the DCBP_* functions to dcbp_* and move them to where they are used
Date: Wed,  7 Sep 2011 16:17:32 +0200
Message-Id: <1315405061-1473-6-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |   39 ------------------------------------
 drivers/block/drbd/drbd_main.c     |   25 +++++++++++++++++++---
 drivers/block/drbd/drbd_receiver.c |   21 ++++++++++++++++--
 3 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 077aa0c..04716df 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -541,45 +541,6 @@ struct p_delay_probe93 {
 	u32     offset;  /* usecs the probe got sent after the reference time point */
 } __packed;
 
-/* DCBP: Drbd Compressed Bitmap Packet ... */
-static inline enum drbd_bitmap_code
-DCBP_get_code(struct p_compressed_bm *p)
-{
-	return (enum drbd_bitmap_code)(p->encoding & 0x0f);
-}
-
-static inline void
-DCBP_set_code(struct p_compressed_bm *p, enum drbd_bitmap_code code)
-{
-	BUG_ON(code & ~0xf);
-	p->encoding = (p->encoding & ~0xf) | code;
-}
-
-static inline int
-DCBP_get_start(struct p_compressed_bm *p)
-{
-	return (p->encoding & 0x80) != 0;
-}
-
-static inline void
-DCBP_set_start(struct p_compressed_bm *p, int set)
-{
-	p->encoding = (p->encoding & ~0x80) | (set ? 0x80 : 0);
-}
-
-static inline int
-DCBP_get_pad_bits(struct p_compressed_bm *p)
-{
-	return (p->encoding >> 4) & 0x7;
-}
-
-static inline void
-DCBP_set_pad_bits(struct p_compressed_bm *p, int n)
-{
-	BUG_ON(n & ~0x7);
-	p->encoding = (p->encoding & (~0x7 << 4)) | (n << 4);
-}
-
 /* one bitmap packet, including the p_header,
  * should fit within one _architecture independend_ page.
  * so we need to use the fixed size 4KiB page size
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 53e887d..54778e9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1029,6 +1029,23 @@ int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
 	return !conn_send_cmd(tconn, 0, &tconn->meta, cmd, &p.head, sizeof(p));
 }
 
+static void dcbp_set_code(struct p_compressed_bm *p, enum drbd_bitmap_code code)
+{
+	BUG_ON(code & ~0xf);
+	p->encoding = (p->encoding & ~0xf) | code;
+}
+
+static void dcbp_set_start(struct p_compressed_bm *p, int set)
+{
+	p->encoding = (p->encoding & ~0x80) | (set ? 0x80 : 0);
+}
+
+static void dcbp_set_pad_bits(struct p_compressed_bm *p, int n)
+{
+	BUG_ON(n & ~0x7);
+	p->encoding = (p->encoding & (~0x7 << 4)) | (n << 4);
+}
+
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 	struct p_compressed_bm *p,
 	struct bm_xfer_ctx *c)
@@ -1073,12 +1090,12 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 			if (rl == 0) {
 				/* the first checked bit was set,
 				 * store start value, */
-				DCBP_set_start(p, 1);
+				dcbp_set_start(p, 1);
 				/* but skip encoding of zero run length */
 				toggle = !toggle;
 				continue;
 			}
-			DCBP_set_start(p, 0);
+			dcbp_set_start(p, 0);
 		}
 
 		/* paranoia: catch zero runlength.
@@ -1118,7 +1135,7 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 	bm_xfer_ctx_bit_to_word_offset(c);
 
 	/* store pad_bits */
-	DCBP_set_pad_bits(p, (8 - bs.cur.bit) & 0x7);
+	dcbp_set_pad_bits(p, (8 - bs.cur.bit) & 0x7);
 
 	return len;
 }
@@ -1143,7 +1160,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 		return -EIO;
 
 	if (len) {
-		DCBP_set_code(p, RLE_VLI_Bits);
+		dcbp_set_code(p, RLE_VLI_Bits);
 		err = _drbd_send_cmd(mdev, mdev->tconn->data.socket,
 				     P_COMPRESSED_BITMAP, h,
 				     sizeof(*p) + len, 0);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 48e073a..449637f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3598,6 +3598,21 @@ receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
 	return 1;
 }
 
+static enum drbd_bitmap_code dcbp_get_code(struct p_compressed_bm *p)
+{
+	return (enum drbd_bitmap_code)(p->encoding & 0x0f);
+}
+
+static int dcbp_get_start(struct p_compressed_bm *p)
+{
+	return (p->encoding & 0x80) != 0;
+}
+
+static int dcbp_get_pad_bits(struct p_compressed_bm *p)
+{
+	return (p->encoding >> 4) & 0x7;
+}
+
 /**
  * recv_bm_rle_bits
  *
@@ -3616,11 +3631,11 @@ recv_bm_rle_bits(struct drbd_conf *mdev,
 	u64 tmp;
 	unsigned long s = c->bit_offset;
 	unsigned long e;
-	int toggle = DCBP_get_start(p);
+	int toggle = dcbp_get_start(p);
 	int have;
 	int bits;
 
-	bitstream_init(&bs, p->code, len, DCBP_get_pad_bits(p));
+	bitstream_init(&bs, p->code, len, dcbp_get_pad_bits(p));
 
 	bits = bitstream_get_bits(&bs, &look_ahead, 64);
 	if (bits < 0)
@@ -3675,7 +3690,7 @@ decode_bitmap_c(struct drbd_conf *mdev,
 		struct bm_xfer_ctx *c,
 		unsigned int len)
 {
-	if (DCBP_get_code(p) == RLE_VLI_Bits)
+	if (dcbp_get_code(p) == RLE_VLI_Bits)
 		return recv_bm_rle_bits(mdev, p, c, len);
 
 	/* other variants had been implemented for evaluation,
-- 
1.7.4.1

