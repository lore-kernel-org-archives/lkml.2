Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2IFWfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:35:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51551 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2IFWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:35:22 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v10 7/8] block: Consolidate bio_alloc_bioset(), bio_kmalloc()
Date: Thu,  6 Sep 2012 15:35:01 -0700
Message-Id: <1346970902-10931-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346970902-10931-1-git-send-email-koverstreet@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, bio_kmalloc() and bio_alloc_bioset() behaved slightly
different because there was some almost-duplicated code - this fixes
some of that.

The important change is that previously bio_kmalloc() always set
bi_io_vec = bi_inline_vecs, even if nr_iovecs == 0 - unlike
bio_alloc_bioset(). This would cause bio_has_data() to return true; I
don't know if this resulted in any actual bugs but it was certainly
wrong.

bio_kmalloc() and bio_alloc_bioset() also have different arbitrary
limits on nr_iovecs - 1024 (UIO_MAXIOV) for bio_kmalloc(), 256
(BIO_MAX_PAGES) for bio_alloc_bioset(). This patch doesn't fix that, but
at least they're enforced closer together and hopefully they will be
fixed in a later patch.

This'll also help with some future cleanups - there are a fair number of
functions that allocate bios (e.g. bio_clone()), and now they don't have
to be duplicated for bio_alloc(), bio_alloc_bioset(), and bio_kmalloc().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
v7: Re-add dropped comments, improv patch description
---
 fs/bio.c            | 110 ++++++++++++++++++----------------------------------
 include/linux/bio.h |  16 ++++++--
 2 files changed, 49 insertions(+), 77 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 736ef12..191b9b8 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -55,6 +55,7 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
  * IO code that does not need private memory pools.
  */
 struct bio_set *fs_bio_set;
+EXPORT_SYMBOL(fs_bio_set);
 
 /*
  * Our slab pool management
@@ -301,39 +302,58 @@ EXPORT_SYMBOL(bio_reset);
  * @bs:		the bio_set to allocate from.
  *
  * Description:
- *   bio_alloc_bioset will try its own mempool to satisfy the allocation.
- *   If %__GFP_WAIT is set then we will block on the internal pool waiting
- *   for a &struct bio to become free.
- **/
+ *   If @bs is NULL, uses kmalloc() to allocate the bio; else the allocation is
+ *   backed by the @bs's mempool.
+ *
+ *   When @bs is not NULL, if %__GFP_WAIT is set then bio_alloc will always be
+ *   able to allocate a bio. This is due to the mempool guarantees. To make this
+ *   work, callers must never allocate more than 1 bio at a time from this pool.
+ *   Callers that need to allocate more than 1 bio must always submit the
+ *   previously allocated bio for IO before attempting to allocate a new one.
+ *   Failure to do so can cause deadlocks under memory pressure.
+ *
+ *   RETURNS:
+ *   Pointer to new bio on success, NULL on failure.
+ */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	unsigned front_pad;
+	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
 	struct bio_vec *bvl = NULL;
 	struct bio *bio;
 	void *p;
 
-	p = mempool_alloc(bs->bio_pool, gfp_mask);
+	if (!bs) {
+		if (nr_iovecs > UIO_MAXIOV)
+			return NULL;
+
+		p = kmalloc(sizeof(struct bio) +
+			    nr_iovecs * sizeof(struct bio_vec),
+			    gfp_mask);
+		front_pad = 0;
+		inline_vecs = nr_iovecs;
+	} else {
+		p = mempool_alloc(bs->bio_pool, gfp_mask);
+		front_pad = bs->front_pad;
+		inline_vecs = BIO_INLINE_VECS;
+	}
+
 	if (unlikely(!p))
 		return NULL;
-	bio = p + bs->front_pad;
 
+	bio = p + front_pad;
 	bio_init(bio);
-	bio->bi_pool = bs;
-
-	if (unlikely(!nr_iovecs))
-		goto out_set;
 
-	if (nr_iovecs <= BIO_INLINE_VECS) {
-		bvl = bio->bi_inline_vecs;
-		nr_iovecs = BIO_INLINE_VECS;
-	} else {
+	if (nr_iovecs > inline_vecs) {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
 			goto err_free;
-
-		nr_iovecs = bvec_nr_vecs(idx);
+	} else if (nr_iovecs) {
+		bvl = bio->bi_inline_vecs;
 	}
-out_set:
+
+	bio->bi_pool = bs;
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bvl;
@@ -345,62 +365,6 @@ err_free:
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
-/**
- *	bio_alloc - allocate a new bio, memory pool backed
- *	@gfp_mask: allocation mask to use
- *	@nr_iovecs: number of iovecs
- *
- *	bio_alloc will allocate a bio and associated bio_vec array that can hold
- *	at least @nr_iovecs entries. Allocations will be done from the
- *	fs_bio_set. Also see @bio_alloc_bioset and @bio_kmalloc.
- *
- *	If %__GFP_WAIT is set, then bio_alloc will always be able to allocate
- *	a bio. This is due to the mempool guarantees. To make this work, callers
- *	must never allocate more than 1 bio at a time from this pool. Callers
- *	that need to allocate more than 1 bio must always submit the previously
- *	allocated bio for IO before attempting to allocate a new one. Failure to
- *	do so can cause livelocks under memory pressure.
- *
- *	RETURNS:
- *	Pointer to new bio on success, NULL on failure.
- */
-struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
-{
-	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
-}
-EXPORT_SYMBOL(bio_alloc);
-
-/**
- * bio_kmalloc - allocate a bio for I/O using kmalloc()
- * @gfp_mask:   the GFP_ mask given to the slab allocator
- * @nr_iovecs:	number of iovecs to pre-allocate
- *
- * Description:
- *   Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask contains
- *   %__GFP_WAIT, the allocation is guaranteed to succeed.
- *
- **/
-struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
-{
-	struct bio *bio;
-
-	if (nr_iovecs > UIO_MAXIOV)
-		return NULL;
-
-	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
-		      gfp_mask);
-	if (unlikely(!bio))
-		return NULL;
-
-	bio_init(bio);
-	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
-	bio->bi_max_vecs = nr_iovecs;
-	bio->bi_io_vec = bio->bi_inline_vecs;
-
-	return bio;
-}
-EXPORT_SYMBOL(bio_kmalloc);
-
 void zero_fill_bio(struct bio *bio)
 {
 	unsigned long flags;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 04944c9..fbe35b1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -212,11 +212,21 @@ extern void bio_pair_release(struct bio_pair *dbio);
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 
-extern struct bio *bio_alloc(gfp_t, unsigned int);
-extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 
+extern struct bio_set *fs_bio_set;
+
+static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+{
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
+}
+
+static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+{
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
+}
+
 extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
@@ -304,8 +314,6 @@ struct biovec_slab {
 	struct kmem_cache *slab;
 };
 
-extern struct bio_set *fs_bio_set;
-
 /*
  * a small number of entries is fine, not going to be performance critical.
  * basically we just need to survive
-- 
1.7.12

