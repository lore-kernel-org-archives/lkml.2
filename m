Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2IFWhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:37:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2IFWfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:35:16 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 2/8] block: Ues bi_pool for bio_integrity_alloc()
Date: Thu,  6 Sep 2012 15:34:56 -0700
Message-Id: <1346970902-10931-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346970902-10931-1-git-send-email-koverstreet@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that bios keep track of where they were allocated from,
bio_integrity_alloc_bioset() becomes redundant.

Remove bio_integrity_alloc_bioset() and drop bio_set argument from the
related functions and make them use bio->bi_pool.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c    |  2 +-
 drivers/md/dm.c     |  4 ++--
 drivers/md/md.c     |  2 +-
 fs/bio-integrity.c  | 44 +++++++++++++++-----------------------------
 fs/bio.c            |  6 +++---
 include/linux/bio.h |  9 ++++-----
 6 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..95c4935 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2788,7 +2788,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		__bio_clone(bio, bio_src);
 
 		if (bio_integrity(bio_src) &&
-		    bio_integrity_clone(bio, bio_src, gfp_mask, bs))
+		    bio_integrity_clone(bio, bio_src, gfp_mask))
 			goto free_and_out;
 
 		if (bio_ctr && bio_ctr(bio, bio_src, data))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0c3d6dd..f43aaf6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1068,7 +1068,7 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	clone->bi_flags |= 1 << BIO_CLONED;
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
+		bio_integrity_clone(clone, bio, GFP_NOIO);
 		bio_integrity_trim(clone,
 				   bio_sector_offset(bio, idx, offset), len);
 	}
@@ -1094,7 +1094,7 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
+		bio_integrity_clone(clone, bio, GFP_NOIO);
 
 		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
 			bio_integrity_trim(clone,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b8eebe3..457ca84 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -186,7 +186,7 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask);
 
 		if (ret < 0) {
 			bio_put(b);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index e85c04b..a3f28f3 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -70,23 +70,25 @@ static inline int use_bip_pool(unsigned int idx)
 }
 
 /**
- * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
+ * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
  * @gfp_mask:	Memory allocation mask
  * @nr_vecs:	Number of integrity metadata scatter-gather elements
- * @bs:		bio_set to allocate from
  *
  * Description: This function prepares a bio for attaching integrity
  * metadata.  nr_vecs specifies the maximum number of pages containing
  * integrity metadata that can be attached.
  */
-struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
-							 gfp_t gfp_mask,
-							 unsigned int nr_vecs,
-							 struct bio_set *bs)
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+						  gfp_t gfp_mask,
+						  unsigned int nr_vecs)
 {
 	struct bio_integrity_payload *bip;
 	unsigned int idx = vecs_to_idx(nr_vecs);
+	struct bio_set *bs = bio->bi_pool;
+
+	if (!bs)
+		bs = fs_bio_set;
 
 	BUG_ON(bio == NULL);
 	bip = NULL;
@@ -114,37 +116,22 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	return bip;
 }
-EXPORT_SYMBOL(bio_integrity_alloc_bioset);
-
-/**
- * bio_integrity_alloc - Allocate integrity payload and attach it to bio
- * @bio:	bio to attach integrity metadata to
- * @gfp_mask:	Memory allocation mask
- * @nr_vecs:	Number of integrity metadata scatter-gather elements
- *
- * Description: This function prepares a bio for attaching integrity
- * metadata.  nr_vecs specifies the maximum number of pages containing
- * integrity metadata that can be attached.
- */
-struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-						  gfp_t gfp_mask,
-						  unsigned int nr_vecs)
-{
-	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
-}
 EXPORT_SYMBOL(bio_integrity_alloc);
 
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
- * @bs:		bio_set this bio was allocated from
  *
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+void bio_integrity_free(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_set *bs = bio->bi_pool;
+
+	if (!bs)
+		bs = fs_bio_set;
 
 	BUG_ON(bip == NULL);
 
@@ -730,19 +717,18 @@ EXPORT_SYMBOL(bio_integrity_split);
  * @bio:	New bio
  * @bio_src:	Original bio
  * @gfp_mask:	Memory allocation mask
- * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
 int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-			gfp_t gfp_mask, struct bio_set *bs)
+			gfp_t gfp_mask)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
+	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
 
 	if (bip == NULL)
 		return -EIO;
diff --git a/fs/bio.c b/fs/bio.c
index e017f7a..b14f71a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -241,7 +241,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
-		bio_integrity_free(bio, bs);
+		bio_integrity_free(bio);
 
 	/*
 	 * If we have front padding, adjust the bio pointer before freeing
@@ -341,7 +341,7 @@ EXPORT_SYMBOL(bio_alloc);
 static void bio_kmalloc_destructor(struct bio *bio)
 {
 	if (bio_integrity(bio))
-		bio_integrity_free(bio, fs_bio_set);
+		bio_integrity_free(bio);
 	kfree(bio);
 }
 
@@ -480,7 +480,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask);
 
 		if (ret < 0) {
 			bio_put(b);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2643589..a11f74b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -505,9 +505,8 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *, struct bio_set *);
+extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
@@ -517,7 +516,7 @@ extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
 extern void bio_integrity_init(void);
@@ -549,13 +548,13 @@ static inline int bio_integrity_prep(struct bio *bio)
 	return 0;
 }
 
-static inline void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+static inline void bio_integrity_free(struct bio *bio)
 {
 	return;
 }
 
 static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-				      gfp_t gfp_mask, struct bio_set *bs)
+				      gfp_t gfp_mask)
 {
 	return 0;
 }
-- 
1.7.12

