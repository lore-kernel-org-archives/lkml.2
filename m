Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2JOUK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41070 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab2JOUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:18 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v4 21/24] block: Add bio_alloc_pages()
Date: Mon, 15 Oct 2012 13:08:55 -0700
Message-Id: <1350331769-14856-22-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More utility code to replace stuff that's getting open coded.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c  | 16 +++-------------
 fs/bio.c            | 28 ++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dff0473..97f80b9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -92,7 +92,6 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
-	struct page *page;
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int i, j;
@@ -122,14 +121,10 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		j = 1;
 	while(j--) {
 		bio = r1_bio->bios[j];
-		for (i = 0; i < RESYNC_PAGES; i++) {
-			page = alloc_page(gfp_flags);
-			if (unlikely(!page))
-				goto out_free_pages;
+		bio->bi_vcnt = RESYNC_PAGES;
 
-			bio->bi_io_vec[i].bv_page = page;
-			bio->bi_vcnt = i+1;
-		}
+		if (bio_alloc_pages(bio, gfp_flags))
+			goto out_free_bio;
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
@@ -143,11 +138,6 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 	return r1_bio;
 
-out_free_pages:
-	for (j=0 ; j < pi->raid_disks; j++)
-		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
-			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
-	j = -1;
 out_free_bio:
 	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
diff --git a/fs/bio.c b/fs/bio.c
index de4b0e2..b3dceff 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -828,6 +828,34 @@ void bio_advance(struct bio *bio, unsigned bytes)
 EXPORT_SYMBOL(bio_advance);
 
 /**
+ * bio_alloc_pages - allocates a single page for each bvec in a bio
+ * @bio: bio to allocate pages for
+ * @gfp_mask: flags for allocation
+ *
+ * Allocates pages up to @bio->bi_vcnt.
+ *
+ * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
+ * freed.
+ */
+int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
+{
+	int i;
+	struct bio_vec *bv;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		bv->bv_page = alloc_page(gfp_mask);
+		if (!bv->bv_page) {
+			while (--bv >= bio->bi_io_vec)
+				__free_page(bv->bv_page);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_alloc_pages);
+
+/**
  * bio_copy_data - copy contents of data buffers from one chain of bios to
  * another
  * @src: source bio list
diff --git a/include/linux/bio.h b/include/linux/bio.h
index be080d2..8c02317 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -289,6 +289,7 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 #endif
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
+extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
-- 
1.7.12

