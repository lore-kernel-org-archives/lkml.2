Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1IELrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59870 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1IELqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 43/54] drbd: send_bitmap_rle_or_plain(): Error handling cleanup
Date: Mon,  5 Sep 2011 13:45:34 +0200
Message-Id: <1315223145-20640-44-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8b0cfe0..b995937 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1123,8 +1123,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 {
 	struct p_compressed_bm *p = (void*)h;
 	unsigned long num_words;
-	int len;
-	int ok;
+	int len, err;
 
 	len = fill_bitmap_rle_bits(mdev, p, c);
 
@@ -1133,7 +1132,8 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 
 	if (len) {
 		DCBP_set_code(p, RLE_VLI_Bits);
-		ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_COMPRESSED_BITMAP, h,
+		err = _drbd_send_cmd(mdev, mdev->tconn->data.socket,
+				     P_COMPRESSED_BITMAP, h,
 				     sizeof(*p) + len, 0);
 
 		c->packets[0]++;
@@ -1148,7 +1148,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 		len = num_words * sizeof(long);
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words, (unsigned long*)h->payload);
-		ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
+		err = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
 				     h, sizeof(struct p_header80) + len, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
@@ -1159,7 +1159,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 		if (c->bit_offset > c->bm_bits)
 			c->bit_offset = c->bm_bits;
 	}
-	if (ok) {
+	if (!err) {
 		if (len == 0) {
 			INFO_bm_xfer_stats(mdev, "send", c);
 			return 0;
-- 
1.7.4.1

