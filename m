Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2JOULA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:11:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44843 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2JOUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:53 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce to not use bi_io_vec
Date: Mon, 15 Oct 2012 13:09:22 -0700
Message-Id: <1350331769-14856-49-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of what __blk_queue_bounce() was doing was problematic for the
immutable bvec work; this cleans that up and the code is quite a bit
smaller, too.

The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
because that one's looping over the original bio, not the bounce bio -
since the bounce code doesn't own that bio the __ version wasn't
correct.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 mm/bounce.c | 73 ++++++++++++++++---------------------------------------------
 1 file changed, 19 insertions(+), 54 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 0420867..3068300 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -101,7 +101,7 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 	struct bio_vec *tovec, *fromvec;
 	int i;
 
-	__bio_for_each_segment(tovec, to, i, 0) {
+	bio_for_each_segment(tovec, to, i) {
 		fromvec = from->bi_io_vec + i;
 
 		/*
@@ -181,78 +181,43 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool)
 {
-	struct page *page;
-	struct bio *bio = NULL;
-	int i, rw = bio_data_dir(*bio_orig);
+	struct bio *bio;
+	int rw = bio_data_dir(*bio_orig);
 	struct bio_vec *to, *from;
+	unsigned i;
 
-	bio_for_each_segment(from, *bio_orig, i) {
-		page = from->bv_page;
+	bio_for_each_segment(from, *bio_orig, i)
+		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
+			goto bounce;
 
-		/*
-		 * is destination page below bounce pfn?
-		 */
-		if (page_to_pfn(page) <= queue_bounce_pfn(q))
-			continue;
-
-		/*
-		 * irk, bounce it
-		 */
-		if (!bio) {
-			unsigned int cnt = (*bio_orig)->bi_vcnt;
+	return;
+bounce:
+	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
 
-			bio = bio_alloc(GFP_NOIO, cnt);
-			memset(bio->bi_io_vec, 0, cnt * sizeof(struct bio_vec));
-		}
-			
+	bio_for_each_segment(to, bio, i) {
+		struct page *page = to->bv_page;
 
-		to = bio->bi_io_vec + i;
+		if (page_to_pfn(page) <= queue_bounce_pfn(q))
+			continue;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
-		to->bv_len = from->bv_len;
-		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
 
-			flush_dcache_page(from->bv_page);
+			flush_dcache_page(page);
+
 			vto = page_address(to->bv_page) + to->bv_offset;
-			vfrom = kmap(from->bv_page) + from->bv_offset;
+			vfrom = kmap_atomic(page) + to->bv_offset;
 			memcpy(vto, vfrom, to->bv_len);
-			kunmap(from->bv_page);
+			kunmap_atomic(vfrom);
 		}
 	}
 
-	/*
-	 * no pages bounced
-	 */
-	if (!bio)
-		return;
-
 	trace_block_bio_bounce(q, *bio_orig);
 
-	/*
-	 * at least one page was bounced, fill in possible non-highmem
-	 * pages
-	 */
-	__bio_for_each_segment(from, *bio_orig, i, 0) {
-		to = bio_iovec_idx(bio, i);
-		if (!to->bv_page) {
-			to->bv_page = from->bv_page;
-			to->bv_len = from->bv_len;
-			to->bv_offset = from->bv_offset;
-		}
-	}
-
-	bio->bi_bdev = (*bio_orig)->bi_bdev;
 	bio->bi_flags |= (1 << BIO_BOUNCED);
-	bio->bi_sector = (*bio_orig)->bi_sector;
-	bio->bi_rw = (*bio_orig)->bi_rw;
-
-	bio->bi_vcnt = (*bio_orig)->bi_vcnt;
-	bio->bi_idx = (*bio_orig)->bi_idx;
-	bio->bi_size = (*bio_orig)->bi_size;
 
 	if (pool == page_pool) {
 		bio->bi_end_io = bounce_end_io_write;
-- 
1.7.12

