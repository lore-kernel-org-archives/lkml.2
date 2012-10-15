Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2JOUKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2JOUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:34 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 04/26] md: Convert md_trim_bio() to use bio_advance()
Date: Mon, 15 Oct 2012 13:09:07 -0700
Message-Id: <1350331769-14856-34-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7a2b079..51ce48c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	struct bio_vec *bvec;
 	int sofar = 0;
 
-	size <<= 9;
 	if (offset == 0 && size == bio->bi_size)
 		return;
 
-	bio->bi_sector += offset;
-	bio->bi_size = size;
-	offset <<= 9;
 	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
 
-	while (bio->bi_idx < bio->bi_vcnt &&
-	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
-		/* remove this whole bio_vec */
-		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
-		bio->bi_idx++;
-	}
-	if (bio->bi_idx < bio->bi_vcnt) {
-		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
-		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
-	}
+	bio_advance(bio, offset << 9);
+
+	size <<= 9;
+	bio->bi_size = size;
+
 	/* avoid any complications with bi_idx being non-zero*/
 	if (bio->bi_idx) {
 		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-- 
1.7.12

