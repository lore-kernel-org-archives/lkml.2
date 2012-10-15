Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2JOUK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37612 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:54 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 20/26] block: Add bio_for_each_segment_all()
Date: Mon, 15 Oct 2012 13:09:23 -0700
Message-Id: <1350331769-14856-50-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of the immutable bvec prep work; bio_for_each_segment() is
going to have a different implementation so these need to be split
apart.

This change is also to better document the intent of code that's using
it - bio_for_each_segment_all() is only legal to use for code that owns
the bio.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/raid1.c  |  2 +-
 fs/bio.c            | 12 ++++++------
 fs/exofs/ore.c      |  2 +-
 fs/exofs/ore_raid.c |  2 +-
 include/linux/bio.h | 16 +++++++++-------
 mm/bounce.c         |  2 +-
 6 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6cd1fb2..ade95ac 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1283,7 +1283,7 @@ read_again:
 			 * know the original bi_idx, so we just free
 			 * them all
 			 */
-			__bio_for_each_segment(bvec, mbio, j, 0)
+			bio_for_each_segment_all(bvec, mbio, j)
 				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
diff --git a/fs/bio.c b/fs/bio.c
index 7fb9f4e..efdc437 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -959,7 +959,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 	int iov_idx = 0;
 	unsigned int iov_off = 0;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
 		unsigned int bv_len = iovecs[i].bv_len;
 
@@ -1141,7 +1141,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	return bio;
 cleanup:
 	if (!map_data)
-		bio_for_each_segment(bvec, bio, i)
+		bio_for_each_segment_all(bvec, bio, i)
 			__free_page(bvec->bv_page);
 
 	bio_put(bio);
@@ -1355,7 +1355,7 @@ static void __bio_unmap_user(struct bio *bio)
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
 			set_page_dirty_lock(bvec->bv_page);
 
@@ -1461,7 +1461,7 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 	int i;
 	char *p = bmd->sgvecs[0].iov_base;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
@@ -1501,7 +1501,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	if (!reading) {
 		void *p = data;
 
-		bio_for_each_segment(bvec, bio, i) {
+		bio_for_each_segment_all(bvec, bio, i) {
 			char *addr = page_address(bvec->bv_page);
 
 			memcpy(addr, p, bvec->bv_len);
@@ -1780,7 +1780,7 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 	if (index >= bio->bi_idx)
 		index = bio->bi_vcnt - 1;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		if (i == index) {
 			if (offset > bv->bv_offset)
 				sectors += (offset - bv->bv_offset) / sector_sz;
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index f936cb5..b744228 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -401,7 +401,7 @@ static void _clear_bio(struct bio *bio)
 	struct bio_vec *bv;
 	unsigned i;
 
-	__bio_for_each_segment(bv, bio, i, 0) {
+	bio_for_each_segment_all(bv, bio, i) {
 		unsigned this_count = bv->bv_len;
 
 		if (likely(PAGE_SIZE == this_count))
diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 5f376d1..4dec928 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -432,7 +432,7 @@ static void _mark_read4write_pages_uptodate(struct ore_io_state *ios, int ret)
 		if (!bio)
 			continue;
 
-		__bio_for_each_segment(bv, bio, i, 0) {
+		bio_for_each_segment_all(bv, bio, i) {
 			struct page *page = bv->bv_page;
 
 			SetPageUptodate(page);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 92015ce..b433ff8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -137,16 +137,18 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
 /*
- * drivers should not use the __ version unless they _really_ want to
- * run through the entire bio and not just pending pieces
+ * drivers should _never_ use the all version - the bio may have been split
+ * before it got to the driver and the driver won't own all of it
  */
-#define __bio_for_each_segment(bvl, bio, i, start_idx)			\
-	for (bvl = bio_iovec_idx((bio), (start_idx)), i = (start_idx);	\
-	     i < (bio)->bi_vcnt;					\
-	     bvl++, i++)
+#define bio_for_each_segment_all(bvl, bio, i)				\
+	for (i = 0;							\
+	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
+	     i++)
 
 #define bio_for_each_segment(bvl, bio, i)				\
-	__bio_for_each_segment(bvl, bio, i, (bio)->bi_idx)
+	for (i = (bio)->bi_idx;						\
+	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
+	     i++)
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
diff --git a/mm/bounce.c b/mm/bounce.c
index 3068300..89324e2 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -134,7 +134,7 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 	/*
 	 * free up bounce indirect pages used
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i;
 		if (bvec->bv_page == org_vec->bv_page)
 			continue;
-- 
1.7.12

