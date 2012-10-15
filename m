Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2JOURh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:17:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41070 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2JOUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:30 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(), and a bugfix
Date: Mon, 15 Oct 2012 13:09:04 -0700
Message-Id: <1350331769-14856-31-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pointer to the bvec array to struct bio_integrity_payload,
instead of the bvecs always being inline; then the bvecs are allocated
with bvec_alloc_bs().

This is needed eventually for immutable bio vecs - immutable bvecs
aren't useful if we still have to copy them, hence the need for the
pointer. Less code is always nice too, though.

Also fix an amusing bug in bio_integrity_split() - struct bio_pair
doesn't have the integrity bvecs after the bio_integrity_payloads, so
there was a buffer overrun. The code was confusing pointers with arrays.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 124 +++++++++++++++++-----------------------------------
 include/linux/bio.h |   5 ++-
 2 files changed, 43 insertions(+), 86 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index a3f28f3..1d64f7f 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -27,48 +27,11 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 
-struct integrity_slab {
-	struct kmem_cache *slab;
-	unsigned short nr_vecs;
-	char name[8];
-};
-
-#define IS(x) { .nr_vecs = x, .name = "bip-"__stringify(x) }
-struct integrity_slab bip_slab[BIOVEC_NR_POOLS] __read_mostly = {
-	IS(1), IS(4), IS(16), IS(64), IS(128), IS(BIO_MAX_PAGES),
-};
-#undef IS
+#define BIP_INLINE_VECS	4
 
+static struct kmem_cache *bip_slab;
 static struct workqueue_struct *kintegrityd_wq;
 
-static inline unsigned int vecs_to_idx(unsigned int nr)
-{
-	switch (nr) {
-	case 1:
-		return 0;
-	case 2 ... 4:
-		return 1;
-	case 5 ... 16:
-		return 2;
-	case 17 ... 64:
-		return 3;
-	case 65 ... 128:
-		return 4;
-	case 129 ... BIO_MAX_PAGES:
-		return 5;
-	default:
-		BUG();
-	}
-}
-
-static inline int use_bip_pool(unsigned int idx)
-{
-	if (idx == BIOVEC_MAX_IDX)
-		return 1;
-
-	return 0;
-}
-
 /**
  * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
@@ -84,37 +47,38 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 						  unsigned int nr_vecs)
 {
 	struct bio_integrity_payload *bip;
-	unsigned int idx = vecs_to_idx(nr_vecs);
 	struct bio_set *bs = bio->bi_pool;
+	unsigned long idx = BIO_POOL_NONE;
+	unsigned inline_vecs;
+
+	if (!bs) {
+		bip = kmalloc(sizeof(struct bio_integrity_payload) +
+			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
+		inline_vecs = nr_vecs;
+	} else {
+		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
+		inline_vecs = BIP_INLINE_VECS;
+	}
 
-	if (!bs)
-		bs = fs_bio_set;
-
-	BUG_ON(bio == NULL);
-	bip = NULL;
+	if (unlikely(!bip))
+		return NULL;
 
-	/* Lower order allocations come straight from slab */
-	if (!use_bip_pool(idx))
-		bip = kmem_cache_alloc(bip_slab[idx].slab, gfp_mask);
+	memset(bip, 0, sizeof(struct bio_integrity_payload));
 
-	/* Use mempool if lower order alloc failed or max vecs were requested */
-	if (bip == NULL) {
-		idx = BIOVEC_MAX_IDX;  /* so we free the payload properly later */
-		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
-
-		if (unlikely(bip == NULL)) {
-			printk(KERN_ERR "%s: could not alloc bip\n", __func__);
-			return NULL;
-		}
+	if (nr_vecs > inline_vecs) {
+		bip->bip_vec = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, bs);
+		if (!bip->bip_vec)
+			goto err;
 	}
 
-	memset(bip, 0, sizeof(*bip));
-
 	bip->bip_slab = idx;
 	bip->bip_bio = bio;
 	bio->bi_integrity = bip;
 
 	return bip;
+err:
+	mempool_free(bip, bs->bio_integrity_pool);
+	return NULL;
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
 
@@ -130,20 +94,19 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_set *bs = bio->bi_pool;
 
-	if (!bs)
-		bs = fs_bio_set;
-
-	BUG_ON(bip == NULL);
-
 	/* A cloned bio doesn't own the integrity metadata */
 	if (!bio_flagged(bio, BIO_CLONED) && !bio_flagged(bio, BIO_FS_INTEGRITY)
 	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
-	if (use_bip_pool(bip->bip_slab))
+	if (bs) {
+		if (bip->bip_slab != BIO_POOL_NONE)
+			bvec_free_bs(bs, bip->bip_vec, bip->bip_slab);
+
 		mempool_free(bip, bs->bio_integrity_pool);
-	else
-		kmem_cache_free(bip_slab[bip->bip_slab].slab, bip);
+	} else {
+		kfree(bip);
+	}
 
 	bio->bi_integrity = NULL;
 }
@@ -697,8 +660,8 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv1 = bip->bip_vec[0];
 	bp->iv2 = bip->bip_vec[0];
 
-	bp->bip1.bip_vec[0] = bp->iv1;
-	bp->bip2.bip_vec[0] = bp->iv2;
+	bp->bip1.bip_vec = &bp->iv1;
+	bp->bip2.bip_vec = &bp->iv2;
 
 	bp->iv1.bv_len = sectors * bi->tuple_size;
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
@@ -746,13 +709,10 @@ EXPORT_SYMBOL(bio_integrity_clone);
 
 int bioset_integrity_create(struct bio_set *bs, int pool_size)
 {
-	unsigned int max_slab = vecs_to_idx(BIO_MAX_PAGES);
-
 	if (bs->bio_integrity_pool)
 		return 0;
 
-	bs->bio_integrity_pool =
-		mempool_create_slab_pool(pool_size, bip_slab[max_slab].slab);
+	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size, bip_slab);
 
 	if (!bs->bio_integrity_pool)
 		return -1;
@@ -770,8 +730,6 @@ EXPORT_SYMBOL(bioset_integrity_free);
 
 void __init bio_integrity_init(void)
 {
-	unsigned int i;
-
 	/*
 	 * kintegrityd won't block much but may burn a lot of CPU cycles.
 	 * Make it highpri CPU intensive wq with max concurrency of 1.
@@ -781,14 +739,10 @@ void __init bio_integrity_init(void)
 	if (!kintegrityd_wq)
 		panic("Failed to create kintegrityd\n");
 
-	for (i = 0 ; i < BIOVEC_NR_POOLS ; i++) {
-		unsigned int size;
-
-		size = sizeof(struct bio_integrity_payload)
-			+ bip_slab[i].nr_vecs * sizeof(struct bio_vec);
-
-		bip_slab[i].slab =
-			kmem_cache_create(bip_slab[i].name, size, 0,
-					  SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	}
+	bip_slab = kmem_cache_create("bio_integrity_payload",
+				     sizeof(struct bio_integrity_payload) +
+				     sizeof(struct bio_vec) * BIP_INLINE_VECS,
+				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	if (!bip_slab)
+		panic("Failed to create slab\n");
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index c32ea0d..7873465 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -182,7 +182,10 @@ struct bio_integrity_payload {
 	unsigned short		bip_idx;	/* current bip_vec index */
 
 	struct work_struct	bip_work;	/* I/O completion */
-	struct bio_vec		bip_vec[0];	/* embedded bvec array */
+
+	struct bio_vec		*bip_vec;
+	struct bio_vec		bip_inline_vecs[0];/* embedded bvec array */
+
 };
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-- 
1.7.12

