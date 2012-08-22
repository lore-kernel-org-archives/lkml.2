Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab2HVRGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:06:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847Ab2HVREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:39 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v6 07/13] block: Avoid deadlocks with bio allocation by stacking drivers
Date: Wed, 22 Aug 2012 10:04:04 -0700
Message-Id: <1345655050-28199-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, if we ever try to allocate more than once from the same bio
set while running under generic_make_request(), we risk deadlock.

This would happen if e.g. a bio ever needed to be split more than once,
and it's difficult to handle correctly in the drivers - so in practice
it's not.

This patch fixes this issue by allocating a rescuer workqueue for each
bio_set, and punting queued bios to said rescuer when necessary:

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 74 +++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/bio.h | 75 ++++++++++++++++++++++++++++++-----------------------
 2 files changed, 112 insertions(+), 37 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index aa67bf3..a82a3c7 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -279,6 +279,23 @@ void bio_reset(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_reset);
 
+static void bio_alloc_rescue(struct work_struct *work)
+{
+	struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
+	struct bio *bio;
+
+	while (1) {
+		spin_lock(&bs->rescue_lock);
+		bio = bio_list_pop(&bs->rescue_list);
+		spin_unlock(&bs->rescue_lock);
+
+		if (!bio)
+			break;
+
+		generic_make_request(bio);
+	}
+}
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -292,6 +309,7 @@ EXPORT_SYMBOL(bio_reset);
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -306,16 +324,39 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		p = kmalloc(sizeof(struct bio) +
 			    nr_iovecs * sizeof(struct bio_vec),
 			    gfp_mask);
+
 		front_pad = 0;
 		inline_vecs = nr_iovecs;
 	} else {
-		p = mempool_alloc(bs->bio_pool, gfp_mask);
+		/*
+		 * If we're running under generic_make_request()
+		 * (current->bio_list != NULL), we risk deadlock if we sleep on
+		 * allocation and there's already bios on current->bio_list that
+		 * were allocated from the same bio_set; they won't be submitted
+		 * (and thus freed) as long as we're blocked here.
+		 *
+		 * To deal with this, we first try the allocation without using
+		 * the mempool; if that fails, we punt all the bios on
+		 * current->bio_list to a different thread and then retry the
+		 * allocation with the original gfp mask.
+		 */
+
+		if (current->bio_list &&
+		    !bio_list_empty(current->bio_list) &&
+		    (gfp_mask & __GFP_WAIT))
+			gfp_mask &= GFP_ATOMIC;
+retry:
+		if (gfp_mask & __GFP_WAIT)
+			p = mempool_alloc(bs->bio_pool, gfp_mask);
+		else
+			p = kmem_cache_alloc(bs->bio_slab, gfp_mask);
+
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
 	}
 
 	if (unlikely(!p))
-		return NULL;
+		goto err;
 
 	bio = p + front_pad;
 	bio_init(bio);
@@ -336,6 +377,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 err_free:
 	mempool_free(p, bs->bio_pool);
+err:
+	if (gfp_mask != saved_gfp) {
+		gfp_mask = saved_gfp;
+
+		spin_lock(&bs->rescue_lock);
+		bio_list_merge(&bs->rescue_list, current->bio_list);
+		bio_list_init(current->bio_list);
+		spin_unlock(&bs->rescue_lock);
+
+		queue_work(bs->rescue_workqueue, &bs->rescue_work);
+		goto retry;
+	}
+
 	return NULL;
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
@@ -1544,6 +1598,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1579,6 +1636,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1589,9 +1650,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (!biovec_create_pools(bs, pool_size))
-		return bs;
+	if (biovec_create_pools(bs, pool_size))
+		goto bad;
+
+	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
+	if (!bs->rescue_workqueue)
+		goto bad;
 
+	return bs;
 bad:
 	bioset_free(bs);
 	return NULL;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b22c22b..ba5b52e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -290,39 +290,6 @@ static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
 static inline void bio_disassociate_task(struct bio *bio) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
-/*
- * bio_set is used to allow other portions of the IO system to
- * allocate their own private memory pools for bio and iovec structures.
- * These memory pools in turn all allocate from the bio_slab
- * and the bvec_slabs[].
- */
-#define BIO_POOL_SIZE 2
-#define BIOVEC_NR_POOLS 6
-#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
-
-struct bio_set {
-	struct kmem_cache *bio_slab;
-	unsigned int front_pad;
-
-	mempool_t *bio_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t *bio_integrity_pool;
-#endif
-	mempool_t *bvec_pool;
-};
-
-struct biovec_slab {
-	int nr_vecs;
-	char *name;
-	struct kmem_cache *slab;
-};
-
-/*
- * a small number of entries is fine, not going to be performance critical.
- * basically we just need to survive
- */
-#define BIO_SPLIT_ENTRIES 2
-
 #ifdef CONFIG_HIGHMEM
 /*
  * remember never ever reenable interrupts between a bvec_kmap_irq and
@@ -497,6 +464,48 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+/*
+ * bio_set is used to allow other portions of the IO system to
+ * allocate their own private memory pools for bio and iovec structures.
+ * These memory pools in turn all allocate from the bio_slab
+ * and the bvec_slabs[].
+ */
+#define BIO_POOL_SIZE 2
+#define BIOVEC_NR_POOLS 6
+#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
+
+struct bio_set {
+	struct kmem_cache *bio_slab;
+	unsigned int front_pad;
+
+	mempool_t *bio_pool;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_t *bio_integrity_pool;
+#endif
+	mempool_t *bvec_pool;
+
+	/*
+	 * Deadlock avoidance for stacking block drivers: see comments in
+	 * bio_alloc_bioset() for details
+	 */
+	spinlock_t		rescue_lock;
+	struct bio_list		rescue_list;
+	struct work_struct	rescue_work;
+	struct workqueue_struct	*rescue_workqueue;
+};
+
+struct biovec_slab {
+	int nr_vecs;
+	char *name;
+	struct kmem_cache *slab;
+};
+
+/*
+ * a small number of entries is fine, not going to be performance critical.
+ * basically we just need to survive
+ */
+#define BIO_SPLIT_ENTRIES 2
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-- 
1.7.12

