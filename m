Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0FZT5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0FZT5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:57:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: [PATCH 2/2] block: defer the use of inline biovecs for discard requests
Date: Sat, 26 Jun 2010 15:56:51 -0400
Message-Id: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
In-Reply-To: <20100622180029.GA15950@redhat.com>
References: <20100622180029.GA15950@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
means bio_has_data() will not be true until the SCSI layer adds the
payload to the discard request via blk_add_request_payload.

bio_{enable,disable}_inline_vecs are not expected to be widely used so
they were exported using EXPORT_SYMBOL_GPL.

This patch avoids the need for the following VM accounting fix for
discards: http://lkml.org/lkml/2010/6/23/361
NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
it in this patch.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c    |    2 ++
 block/blk-lib.c     |    2 +-
 fs/bio.c            |   19 +++++++++++++++++--
 include/linux/bio.h |    3 +++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 07925aa..457fc29 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1153,6 +1153,7 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 {
 	struct bio *bio = rq->bio;
 
+	bio_enable_inline_vecs(bio);
 	bio->bi_io_vec->bv_page = page;
 	bio->bi_io_vec->bv_offset = 0;
 	bio->bi_io_vec->bv_len = len;
@@ -1187,6 +1188,7 @@ void blk_clear_request_payload(struct request *rq)
 
 	bio->bi_io_vec->bv_page = NULL;
 	bio->bi_io_vec->bv_len = 0;
+	bio_disable_inline_vecs(bio);
 }
 EXPORT_SYMBOL_GPL(blk_clear_request_payload);
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index e16185b..345a4b6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -54,7 +54,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		unsigned int max_discard_sectors =
 			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-		bio = bio_alloc(gfp_mask, 1);
+		bio = bio_alloc(gfp_mask, 0);
 		if (!bio) {
 			ret = -ENOMEM;
 			break;
diff --git a/fs/bio.c b/fs/bio.c
index 8abb2df..e47d0a6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -260,6 +260,21 @@ void bio_init(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_init);
 
+void bio_enable_inline_vecs(struct bio *bio)
+{
+	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs = BIO_INLINE_VECS;
+	bio->bi_io_vec = bio->bi_inline_vecs;;
+}
+EXPORT_SYMBOL_GPL(bio_enable_inline_vecs);
+
+void bio_disable_inline_vecs(struct bio *bio)
+{
+	bio->bi_max_vecs = 0;
+	bio->bi_io_vec = NULL;
+}
+EXPORT_SYMBOL_GPL(bio_disable_inline_vecs);
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -293,8 +308,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		goto out_set;
 
 	if (nr_iovecs <= BIO_INLINE_VECS) {
-		bvl = bio->bi_inline_vecs;
-		nr_iovecs = BIO_INLINE_VECS;
+		bio_enable_inline_vecs(bio);
+		return bio;
 	} else {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d379c8..3135631 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -403,6 +403,9 @@ extern struct bio *bio_clone(struct bio *, gfp_t);
 
 extern void bio_init(struct bio *);
 
+extern void bio_enable_inline_vecs(struct bio *);
+extern void bio_disable_inline_vecs(struct bio *);
+
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-- 
1.6.5.rc2

