Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2JOUT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:19:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37612 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2JOUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:22 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com, Alasdair Kergon <agk@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 24/24] block: Add BIO_SUBMITTED flag, kill BIO_CLONED
Date: Mon, 15 Oct 2012 13:08:58 -0700
Message-Id: <1350331769-14856-25-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIO_CLONED wasn't very useful, and didn't have very clear semantics, so
kill it.

Replace it with a more useful flag - BIO_SUBMITTED means the bio has
been passed to generic_make_request() and the bvec can no longer be
modified.

Roll both changes into the same patch so we can steal the old bit for
the new flag.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-core.c          | 2 ++
 drivers/md/dm.c           | 1 -
 fs/bio-integrity.c        | 1 -
 fs/bio.c                  | 8 +++++---
 include/linux/blk_types.h | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index df9bb5f..fcf4335 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1631,6 +1631,8 @@ generic_make_request_checks(struct bio *bio)
 
 	might_sleep();
 
+	bio->bi_flags |= 1 << BIO_SUBMITTED;
+
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8378797..777e70d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1065,7 +1065,6 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
-	clone->bi_flags |= 1 << BIO_CLONED;
 
 	if (bio_integrity(bio)) {
 		bio_integrity_clone(clone, bio, GFP_NOIO);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8fb4291..352eb0b 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -625,7 +625,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 
 	BUG_ON(bip == NULL);
 	BUG_ON(bi == NULL);
-	BUG_ON(!bio_flagged(bio, BIO_CLONED));
 
 	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
 	bip->bip_sector = bip->bip_sector + offset;
diff --git a/fs/bio.c b/fs/bio.c
index 5dc8441..e8625dc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -531,7 +531,7 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	 */
 	bio->bi_sector = bio_src->bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
-	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_flags |= (bio_src->bi_flags & (1 << BIO_SUBMITTED));
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
@@ -604,9 +604,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	struct bio_vec *bvec;
 
 	/*
-	 * cloned bio must not modify vec list
+	 * submitted bio must not modify vec list
 	 */
-	if (unlikely(bio_flagged(bio, BIO_CLONED)))
+	if (unlikely(bio_flagged(bio, BIO_SUBMITTED)))
 		return 0;
 
 	if (((bio->bi_size + len) >> 9) > max_sectors)
@@ -844,6 +844,8 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
 	int i;
 	struct bio_vec *bv;
 
+	BUG_ON(bio_flagged(bio, BIO_SUBMITTED));
+
 	bio_for_each_segment_all(bv, bio, i) {
 		bv->bv_page = alloc_page(gfp_mask);
 		if (!bv->bv_page) {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 538289f..edc5cb9 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -103,7 +103,7 @@ struct bio {
 #define BIO_RW_BLOCK	1	/* RW_AHEAD set, and read/write would block */
 #define BIO_EOF		2	/* out-out-bounds error */
 #define BIO_SEG_VALID	3	/* bi_phys_segments valid */
-#define BIO_CLONED	4	/* doesn't own data */
+#define BIO_SUBMITTED	4	/* bio has been submitted */
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
-- 
1.7.12

