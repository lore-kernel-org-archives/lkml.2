Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2IXWfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:35:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63509 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2IXWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:35:33 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 02/26] block: Convert integrity to bvec_alloc_bs()
Date: Mon, 24 Sep 2012 15:34:42 -0700
Message-Id: <1348526106-17074-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pointer to the bvec array to struct bio_integrity_payload,
instead of the bvecs always being inline; then the bvecs are allocated
with bvec_alloc_bs().

Changed bvec_alloc_bs() and bvec_free_bs() to take a pointer to a
mempool instead of the bioset, so that bio integrity can use a different
mempool for its bvecs, and thus avoid a potential deadlock.

This is eventually for immutable bio vecs - immutable bvecs aren't
useful if we still have to copy them, hence the need for the pointer.
Less code is always nice too, though.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 132 +++++++++++++++++++---------------------------------
 fs/bio.c            |  34 ++++++--------
 include/linux/bio.h |  13 ++++--
 3 files changed, 72 insertions(+), 107 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index c7b6b52..65b708d 100644
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
@@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
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
-
-	/* Lower order allocations come straight from slab */
-	if (!use_bip_pool(idx))
-		bip = kmem_cache_alloc(bip_slab[idx].slab, gfp_mask);
+	if (unlikely(!bip))
+		return NULL;
 
-	/* Use mempool if lower order alloc failed or max vecs were requested */
-	if (bip == NULL) {
-		idx = BIOVEC_MAX_IDX;  /* so we free the payload properly later */
-		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
+	memset(bip, 0, sizeof(struct bio_integrity_payload));
 
-		if (unlikely(bip == NULL)) {
-			printk(KERN_ERR "%s: could not alloc bip\n", __func__);
-			return NULL;
-		}
+	if (nr_vecs > inline_vecs) {
+		bip->bip_vec = bvec_alloc_bs(gfp_mask, nr_vecs, &idx,
+					     bs->bvec_integrity_pool);
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
 
@@ -130,20 +95,20 @@ void bio_integrity_free(struct bio *bio)
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
+			bvec_free_bs(bs->bvec_integrity_pool, bip->bip_vec,
+				     bip->bip_slab);
+
 		mempool_free(bip, bs->bio_integrity_pool);
-	else
-		kmem_cache_free(bip_slab[bip->bip_slab].slab, bip);
+	} else {
+		kfree(bip);
+	}
 
 	bio->bi_integrity = NULL;
 }
@@ -697,6 +662,9 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv1 = bip->bip_vec[0];
 	bp->iv2 = bip->bip_vec[0];
 
+	bp->bip1.bip_vec = &bp->iv1;
+	bp->bip2.bip_vec = &bp->iv2;
+
 	bp->iv1.bv_len = sectors * bi->tuple_size;
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
 	bp->iv2.bv_len -= sectors * bi->tuple_size;
@@ -743,13 +711,14 @@ EXPORT_SYMBOL(bio_integrity_clone);
 
 int bioset_integrity_create(struct bio_set *bs, int pool_size)
 {
-	unsigned int max_slab = vecs_to_idx(BIO_MAX_PAGES);
-
 	if (bs->bio_integrity_pool)
 		return 0;
 
-	bs->bio_integrity_pool =
-		mempool_create_slab_pool(pool_size, bip_slab[max_slab].slab);
+	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size, bip_slab);
+
+	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
+	if (!bs->bvec_integrity_pool)
+		return -1;
 
 	if (!bs->bio_integrity_pool)
 		return -1;
@@ -762,13 +731,14 @@ void bioset_integrity_free(struct bio_set *bs)
 {
 	if (bs->bio_integrity_pool)
 		mempool_destroy(bs->bio_integrity_pool);
+
+	if (bs->bvec_integrity_pool)
+		mempool_destroy(bs->bio_integrity_pool);
 }
 EXPORT_SYMBOL(bioset_integrity_free);
 
 void __init bio_integrity_init(void)
 {
-	unsigned int i;
-
 	/*
 	 * kintegrityd won't block much but may burn a lot of CPU cycles.
 	 * Make it highpri CPU intensive wq with max concurrency of 1.
@@ -778,14 +748,10 @@ void __init bio_integrity_init(void)
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
diff --git a/fs/bio.c b/fs/bio.c
index 63f05a9..ac8b443 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -158,12 +158,12 @@ unsigned int bvec_nr_vecs(unsigned short idx)
 	return bvec_slabs[idx].nr_vecs;
 }
 
-void bvec_free_bs(struct bio_set *bs, struct bio_vec *bv, unsigned int idx)
+void bvec_free_bs(mempool_t *pool, struct bio_vec *bv, unsigned int idx)
 {
 	BIO_BUG_ON(idx >= BIOVEC_NR_POOLS);
 
 	if (idx == BIOVEC_MAX_IDX)
-		mempool_free(bv, bs->bvec_pool);
+		mempool_free(bv, pool);
 	else {
 		struct biovec_slab *bvs = bvec_slabs + idx;
 
@@ -172,7 +172,7 @@ void bvec_free_bs(struct bio_set *bs, struct bio_vec *bv, unsigned int idx)
 }
 
 struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
-			      struct bio_set *bs)
+			      mempool_t *pool)
 {
 	struct bio_vec *bvl;
 
@@ -208,7 +208,7 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
 	 */
 	if (*idx == BIOVEC_MAX_IDX) {
 fallback:
-		bvl = mempool_alloc(bs->bvec_pool, gfp_mask);
+		bvl = mempool_alloc(pool, gfp_mask);
 	} else {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
 		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
@@ -251,7 +251,7 @@ static void bio_free(struct bio *bio)
 
 	if (bs) {
 		if (bio_has_allocated_vec(bio))
-			bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
+			bvec_free_bs(bs->bvec_pool, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 		/*
 		 * If we have front padding, adjust the bio pointer before freeing
@@ -440,11 +440,11 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 	bio_init(bio);
 
 	if (nr_iovecs > inline_vecs) {
-		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
 		if (!bvl && gfp_mask != saved_gfp) {
 			punt_bios_to_rescuer(bs);
 			gfp_mask = saved_gfp;
-			bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+			bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
 		}
 
 		if (unlikely(!bvl))
@@ -1655,20 +1655,11 @@ EXPORT_SYMBOL(bio_sector_offset);
  * create memory pools for biovec's in a bio_set.
  * use the global biovec slabs created for general use.
  */
-static int biovec_create_pools(struct bio_set *bs, int pool_entries)
+mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries)
 {
 	struct biovec_slab *bp = bvec_slabs + BIOVEC_MAX_IDX;
 
-	bs->bvec_pool = mempool_create_slab_pool(pool_entries, bp->slab);
-	if (!bs->bvec_pool)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void biovec_free_pools(struct bio_set *bs)
-{
-	mempool_destroy(bs->bvec_pool);
+	return mempool_create_slab_pool(pool_entries, bp->slab);
 }
 
 void bioset_free(struct bio_set *bs)
@@ -1679,8 +1670,10 @@ void bioset_free(struct bio_set *bs)
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
+	if (bs->bvec_pool)
+		mempool_destroy(bs->bvec_pool);
+
 	bioset_integrity_free(bs);
-	biovec_free_pools(bs);
 	bio_put_slab(bs);
 
 	kfree(bs);
@@ -1725,7 +1718,8 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (biovec_create_pools(bs, pool_size))
+	bs->bvec_pool = biovec_create_pool(bs, pool_size);
+	if (!bs->bvec_pool)
 		goto bad;
 
 	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e2d108..a7c021d 100644
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
 
@@ -213,6 +216,7 @@ extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
+mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
 
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
@@ -288,8 +292,8 @@ extern struct bio *bio_copy_user_iov(struct request_queue *,
 				     int, int, gfp_t);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
-extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
-extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
+extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, mempool_t *);
+extern void bvec_free_bs(mempool_t *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 #ifdef CONFIG_BLK_CGROUP
@@ -511,10 +515,11 @@ struct bio_set {
 	unsigned int front_pad;
 
 	mempool_t *bio_pool;
+	mempool_t *bvec_pool;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	mempool_t *bio_integrity_pool;
+	mempool_t *bvec_integrity_pool;
 #endif
-	mempool_t *bvec_pool;
 
 	/*
 	 * Deadlock avoidance for stacking block drivers: see comments in
-- 
1.7.12

