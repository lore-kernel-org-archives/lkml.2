Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2HOXHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:07:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58448 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HOXHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:07:20 -0400
Date: Wed, 15 Aug 2012 16:07:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Subject: Re: [PATCH] A possible deadlock with stacked devices (was: [PATCH v4
 08/12] block: Introduce new bio_split())
Message-ID: <20120815230715.GD2758@google.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-9-git-send-email-koverstreet@google.com>
 <500FDEBC.9050607@panasas.com>
 <20120725232611.GD8673@moria.home.lan>
 <Pine.LNX.4.64.1207262005450.28322@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207262005450.28322@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Both md and dm use __GFP_WAIT allocations from mempools in 
> generic_make_request.
> 
> I think you found an interesting bug here. Suppose that we have three 
> stacked devices: d1 depends on d2 and d2 depends on d3.
> 
> Now, a bio b1 comes to d1. d1 splits it to two bios: b2.1 and b2.2 and 
> sends them to the device d2 - these bios end up in current->bio_list. The 
> driver for d2 receives bio b2.1 and sends bio b3.1 to d3. Now, 
> current->bio_list contains bios b2.2, b3.1. Now, bio b2.2 is popped off 
> the bio list and the driver for d2 is called with b2.2 - suppose that for 
> some reason mempool in d2 is exhausted and the driver needs to wait until 
> b2.1 finishes. b2.1 never finishes, because b2.1 depends on b3.1 and b3.1 
> is still in current->bio_list. So it deadlocks.
> 
> Turning off __GFP_WAIT fixes nothing - it just turns one bug (a possible 
> deadlock) into another bug (a possible bio failure with -ENOMEM).
> 
> Increasing mempool sizes doesn't fix it either, the bio would just have to 
> be split to more pieces in the above example to make it deadlock.
> 
> I think the above possible deadlock scenario could be fixed by reversing 
> current->bio_list processing - i.e. when some device's make_request_fn 
> adds some bios to current->bio_list, these bios are processed before other 
> bios that were on the list before. This way, bio list would contain "b3.1, 
> b2.2" instead of "b2.2, b3.1" in the above example and the deadlock would 
> not happen.

Your patch isn't sufficient in the case where a bio may be split
multiple times (I'm not sure if it's sufficient in the case where bios
are only split once; trying to work it all out makes my head hurt).

You don't need multiple stacked drivers to see this; just the case where
a single driver is running that splits multiple times is sufficient, if
you have enough threads submitting at the same time.

Bcache works around this with the trick I mentioned previously, where it
masks out _GFP_WAIT if current->bio_list != NULL, and punts to workqueue
if the allocation fails.

This works but it'd have to be done in each stacking driver... it's not
a generic solution, and it's a pain in the ass.

I came up with another idea the other day. Conceptually, it inverts my
previous workaround - the punting to workqueue is done in the allocation
code when necessary, for the bios that would be blocked.

It's lightly tested, gonna rig up some kind of fault injection and test
it more thoroughly later.

commit d61bbb074cc8f2e089eb57e2bee8e84500f390a8
Author: Kent Overstreet <koverstreet@google.com>
Date:   Mon Aug 13 18:11:01 2012 -0700

    block: Avoid deadlocks with bio allocation by stacking drivers
    
    Previously, if we ever try to allocate more than once from the same bio
    set while running under generic_make_request(), we risk deadlock.
    
    This would happen if e.g. a bio ever needed to be split more than once,
    and it's difficult to handle correctly in the drivers - so in practice
    it's not.
    
    This patch fixes this issue by allocating a rescuer workqueue for each
    bio_set, and punting queued bios to said rescuer when necessary:

diff --git a/fs/bio.c b/fs/bio.c
index bc4265a..7b4f655 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -281,6 +281,23 @@ void bio_reset(struct bio *bio)
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
@@ -294,6 +311,7 @@ EXPORT_SYMBOL(bio_reset);
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -308,16 +326,39 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
@@ -338,6 +379,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
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
@@ -1546,6 +1600,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1581,6 +1638,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1591,9 +1652,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
