Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1IWOcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:32:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39539 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1IWObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/10] drbd: Remove some fixed header size assumptions
Date: Fri, 23 Sep 2011 16:31:21 +0200
Message-Id: <1316788285-17433-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   15 +++------------
 drivers/block/drbd/drbd_main.c     |   25 +++++++++++++++----------
 drivers/block/drbd/drbd_receiver.c |   29 +++++++++++++++++------------
 3 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c58b327..d8e63c4 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -543,19 +543,10 @@ struct p_delay_probe93 {
 	u32     offset;  /* usecs the probe got sent after the reference time point */
 } __packed;
 
-/* one bitmap packet, including the p_header,
- * should fit within one _architecture independend_ page.
- * so we need to use the fixed size 4KiB page size
- * most architectures have used for a long time.
+/*
+ * Bitmap packets need to fit within a single page on the sender and receiver,
+ * so we are limited to 4 KiB (and not to PAGE_SIZE, which can be bigger).
  */
-#define BM_PACKET_PAYLOAD_BYTES (4096 - sizeof(struct p_header))
-#define BM_PACKET_WORDS (BM_PACKET_PAYLOAD_BYTES/sizeof(long))
-#define BM_PACKET_VLI_BYTES_MAX (4096 - sizeof(struct p_compressed_bm))
-#if (PAGE_SIZE < 4096)
-/* drbd_send_bitmap / receive_bitmap would break horribly */
-#error "PAGE_SIZE too small"
-#endif
-
 #define DRBD_SOCKET_BUFFER_SIZE 4096
 
 /**********************************************************************/
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9e94ead..ee45370 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1082,8 +1082,9 @@ static void dcbp_set_pad_bits(struct p_compressed_bm *p, int n)
 }
 
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
-	struct p_compressed_bm *p,
-	struct bm_xfer_ctx *c)
+			 struct p_compressed_bm *p,
+			 unsigned int size,
+			 struct bm_xfer_ctx *c)
 {
 	struct bitstream bs;
 	unsigned long plain_bits;
@@ -1102,8 +1103,8 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 		return 0; /* nothing to do. */
 
 	/* use at most thus many bytes */
-	bitstream_init(&bs, p->code, BM_PACKET_VLI_BYTES_MAX, 0);
-	memset(p->code, 0, BM_PACKET_VLI_BYTES_MAX);
+	bitstream_init(&bs, p->code, size, 0);
+	memset(p->code, 0, size);
 	/* plain bits covered in this code string */
 	plain_bits = 0;
 
@@ -1185,11 +1186,11 @@ static int
 send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 {
 	struct drbd_socket *sock = &mdev->tconn->data;
+	unsigned int header_size = drbd_header_size(mdev->tconn);
 	struct p_compressed_bm *p = sock->sbuf;
-	unsigned long num_words;
 	int len, err;
 
-	len = fill_bitmap_rle_bits(mdev, p, c);
+	len = fill_bitmap_rle_bits(mdev, p, DRBD_SOCKET_BUFFER_SIZE - sizeof(*p) /* FIXME */, c);
 	if (len < 0)
 		return -EIO;
 
@@ -1206,9 +1207,14 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 	} else {
 		/* was not compressible.
 		 * send a buffer full of plain text bits instead. */
+		unsigned int data_size;
+		unsigned long num_words;
 		struct p_header *h = sock->sbuf;
-		num_words = min_t(size_t, BM_PACKET_WORDS, c->bm_words - c->word_offset);
-		len = num_words * sizeof(long);
+
+		data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
+		num_words = min_t(size_t, data_size / sizeof(unsigned long),
+				  c->bm_words - c->word_offset);
+		len = num_words * sizeof(unsigned long);
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words,
 					(unsigned long *)h->payload);
@@ -1218,7 +1224,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
 		c->packets[1]++;
-		c->bytes[1] += sizeof(struct p_header80) + len;
+		c->bytes[1] += header_size + len;
 
 		if (c->bit_offset > c->bm_bits)
 			c->bit_offset = c->bm_bits;
@@ -2526,7 +2532,6 @@ int __init drbd_init(void)
 {
 	int err;
 
-	BUILD_BUG_ON(sizeof(struct p_header80) != sizeof(struct p_header95));
 	BUILD_BUG_ON(sizeof(struct p_connection_features) != 80);
 
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1270af3..d0d1924 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3663,16 +3663,19 @@ static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
  * code upon failure.
  */
 static int
-receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
+receive_bitmap_plain(struct drbd_conf *mdev, unsigned int size,
 		     struct p_header *h, struct bm_xfer_ctx *c)
 {
 	unsigned long *buffer = (unsigned long *)h->payload;
-	unsigned num_words = min_t(size_t, BM_PACKET_WORDS, c->bm_words - c->word_offset);
-	unsigned want = num_words * sizeof(long);
+	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
+				 drbd_header_size(mdev->tconn);
+	unsigned int num_words = min_t(size_t, data_size / sizeof(unsigned long),
+				       c->bm_words - c->word_offset);
+	unsigned int want = num_words * sizeof(unsigned long);
 	int err;
 
-	if (want != data_size) {
-		dev_err(DEV, "%s:want (%u) != data_size (%u)\n", __func__, want, data_size);
+	if (want != size) {
+		dev_err(DEV, "%s:want (%u) != size (%u)\n", __func__, want, size);
 		return -EIO;
 	}
 	if (want == 0)
@@ -3799,11 +3802,13 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
-	unsigned plain = sizeof(struct p_header) *
-		((c->bm_words+BM_PACKET_WORDS-1)/BM_PACKET_WORDS+1)
-		+ c->bm_words * sizeof(long);
-	unsigned total = c->bytes[0] + c->bytes[1];
-	unsigned r;
+	unsigned int header_size = drbd_header_size(mdev->tconn);
+	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
+	unsigned int plain =
+		header_size * (DIV_ROUND_UP(c->bm_words, data_size) + 1) +
+		c->bm_words * sizeof(unsigned long);
+	unsigned int total = c->bytes[0] + c->bytes[1];
+	unsigned int r;
 
 	/* total can not be zero. but just in case: */
 	if (total == 0)
@@ -3865,7 +3870,7 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 			 * and the feature is enabled! */
 			struct p_compressed_bm *p;
 
-			if (pi->size > BM_PACKET_PAYLOAD_BYTES) {
+			if (pi->size > DRBD_SOCKET_BUFFER_SIZE - drbd_header_size(tconn)) {
 				dev_err(DEV, "ReportCBitmap packet too large\n");
 				err = -EIO;
 				goto out;
@@ -3888,7 +3893,7 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 
 		c.packets[pi->cmd == P_BITMAP]++;
-		c.bytes[pi->cmd == P_BITMAP] += sizeof(struct p_header) + pi->size;
+		c.bytes[pi->cmd == P_BITMAP] += drbd_header_size(tconn) + pi->size;
 
 		if (err <= 0) {
 			if (err < 0)
-- 
1.7.4.1

