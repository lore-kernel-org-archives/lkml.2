Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2JOUMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:12:40 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42248 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2JOUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:56 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 21/26] block: Convert some code to bio_for_each_segment_all()
Date: Mon, 15 Oct 2012 13:09:24 -0700
Message-Id: <1350331769-14856-51-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few places in the code were either open coding or using the wrong
version - fix.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-crypt.c |  3 +--
 drivers/md/raid1.c    | 10 +++-------
 fs/bio.c              | 20 ++++++++++----------
 fs/direct-io.c        |  8 ++++----
 4 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bbf459b..f50798e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -858,8 +858,7 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 	unsigned int i;
 	struct bio_vec *bv;
 
-	for (i = 0; i < clone->bi_vcnt; i++) {
-		bv = bio_iovec_idx(clone, i);
+	bio_for_each_segment_all(bv, clone, i) {
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, cc->page_pool);
 		bv->bv_page = NULL;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ade95ac..d30b4cb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -921,7 +921,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 	if (unlikely(!bvecs))
 		return;
 
-	bio_for_each_segment(bvec, bio, i) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		bvecs[i] = *bvec;
 		bvecs[i].bv_page = alloc_page(GFP_NOIO);
 		if (unlikely(!bvecs[i].bv_page))
@@ -1276,12 +1276,8 @@ read_again:
 			struct bio_vec *bvec;
 			int j;
 
-			/* Yes, I really want the '__' version so that
-			 * we clear any unused pointer in the io_vec, rather
-			 * than leave them unchanged.  This is important
-			 * because when we come to free the pages, we won't
-			 * know the original bi_idx, so we just free
-			 * them all
+			/*
+			 * We trimmed the bio, so _all is legit
 			 */
 			bio_for_each_segment_all(bvec, mbio, j)
 				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
diff --git a/fs/bio.c b/fs/bio.c
index efdc437..d88ad77 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1546,11 +1546,11 @@ EXPORT_SYMBOL(bio_copy_kern);
  */
 void bio_set_pages_dirty(struct bio *bio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec;
 	int i;
 
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		struct page *page = bvec[i].bv_page;
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
 
 		if (page && !PageCompound(page))
 			set_page_dirty_lock(page);
@@ -1559,11 +1559,11 @@ void bio_set_pages_dirty(struct bio *bio)
 
 static void bio_release_pages(struct bio *bio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec;
 	int i;
 
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		struct page *page = bvec[i].bv_page;
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
 
 		if (page)
 			put_page(page);
@@ -1612,16 +1612,16 @@ static void bio_dirty_fn(struct work_struct *work)
 
 void bio_check_pages_dirty(struct bio *bio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec;
 	int nr_clean_pages = 0;
 	int i;
 
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		struct page *page = bvec[i].bv_page;
+	bio_for_each_segment_all(bvec, bio, i) {
+		struct page *page = bvec->bv_page;
 
 		if (PageDirty(page) || PageCompound(page)) {
 			page_cache_release(page);
-			bvec[i].bv_page = NULL;
+			bvec->bv_page = NULL;
 		} else {
 			nr_clean_pages++;
 		}
diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..6089916 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -441,8 +441,8 @@ static struct bio *dio_await_one(struct dio *dio)
 static int dio_bio_complete(struct dio *dio, struct bio *bio)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec;
-	int page_no;
+	struct bio_vec *bvec;
+	unsigned i;
 
 	if (!uptodate)
 		dio->io_error = -EIO;
@@ -450,8 +450,8 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (dio->is_async && dio->rw == READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
-		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
-			struct page *page = bvec[page_no].bv_page;
+		bio_for_each_segment_all(bvec, bio, i) {
+			struct page *page = bvec->bv_page;
 
 			if (dio->rw == READ && !PageCompound(page))
 				set_page_dirty_lock(page);
-- 
1.7.12

