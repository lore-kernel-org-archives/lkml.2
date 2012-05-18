Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031010Ab2ERDAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:00:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030713Ab2ERDAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:24 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 13/13] Gut bio_add_page()
Date: Thu, 17 May 2012 23:00:00 -0400
Message-Id: <564f36de1a3185480395ca0449821b3529d122a5.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Since generic_make_request() can now handle arbitrary size bios, all we
have to do is make sure the bvec array doesn't overflow.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c |  133 ++++++++++++-------------------------------------------------
 1 files changed, 26 insertions(+), 107 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 360ac93..e3276bd 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -568,12 +568,22 @@ int bio_get_nr_vecs(struct block_device *bdev)
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 
-static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset,
-			  unsigned short max_sectors)
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
 {
-	int retried_segments = 0;
-	struct bio_vec *bvec;
+	struct bio_vec *bv;
 
 	/*
 	 * cloned bio must not modify vec list
@@ -581,40 +591,17 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_size + len) >> 9) > max_sectors)
-		return 0;
-
 	/*
 	 * For filesystems with a blocksize smaller than the pagesize
 	 * we will often be called with the same page as last time and
 	 * a consecutive offset.  Optimize this special case.
 	 */
 	if (bio->bi_vcnt > 0) {
-		struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == prev->bv_page &&
-		    offset == prev->bv_offset + prev->bv_len) {
-			unsigned int prev_bv_len = prev->bv_len;
-			prev->bv_len += len;
-
-			if (q->merge_bvec_fn) {
-				struct bvec_merge_data bvm = {
-					/* prev_bvec is already charged in
-					   bi_size, discharge it in order to
-					   simulate merging updated prev_bvec
-					   as new bvec. */
-					.bi_bdev = bio->bi_bdev,
-					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size - prev_bv_len,
-					.bi_rw = bio->bi_rw,
-				};
-
-				if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
-					prev->bv_len -= len;
-					return 0;
-				}
-			}
+		bv = bio_iovec_idx(bio, bio->bi_vcnt - 1);
 
+		if (page == bv->bv_page &&
+		    offset == bv->bv_offset + bv->bv_len) {
+			bv->bv_len += len;
 			goto done;
 		}
 	}
@@ -622,64 +609,17 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
-	 */
-
-	while (bio->bi_phys_segments >= queue_max_segments(q)) {
-
-		if (retried_segments)
-			return 0;
-
-		retried_segments = 1;
-		blk_recount_segments(q, bio);
-	}
-
-	/*
-	 * setup the new entry, we might clear it again later if we
-	 * cannot add the page
-	 */
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
-
-	/*
-	 * if queue has other restrictions (eg varying max sector size
-	 * depending on offset), it can specify a merge_bvec_fn in the
-	 * queue to get further control
-	 */
-	if (q->merge_bvec_fn) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev = bio->bi_bdev,
-			.bi_sector = bio->bi_sector,
-			.bi_size = bio->bi_size,
-			.bi_rw = bio->bi_rw,
-		};
-
-		/*
-		 * merge_bvec_fn() returns number of bytes it can accept
-		 * at this offset
-		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
-	}
-
-	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
-		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+	bv		= bio_iovec_idx(bio, bio->bi_vcnt);
+	bv->bv_page	= page;
+	bv->bv_len	= len;
+	bv->bv_offset	= offset;
 
 	bio->bi_vcnt++;
-	bio->bi_phys_segments++;
- done:
+done:
 	bio->bi_size += len;
 	return len;
 }
+EXPORT_SYMBOL(bio_add_page);
 
 /**
  *	bio_add_pc_page	-	attempt to add page to bio
@@ -699,31 +639,10 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
 {
-	return __bio_add_page(q, bio, page, len, offset,
-			      queue_max_hw_sectors(q));
+	return bio_add_page(bio, page, len, offset);
 }
 EXPORT_SYMBOL(bio_add_pc_page);
 
-/**
- *	bio_add_page	-	attempt to add page to bio
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
- */
-int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
-		 unsigned int offset)
-{
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	return __bio_add_page(q, bio, page, len, offset, queue_max_sectors(q));
-}
-EXPORT_SYMBOL(bio_add_page);
-
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
-- 
1.7.9.rc2

