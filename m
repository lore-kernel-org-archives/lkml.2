Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2HXF4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:56:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33643 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2HXF42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:56:28 -0400
Date: Thu, 23 Aug 2012 22:55:54 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 07/13] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120824055554.GC11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-8-git-send-email-koverstreet@google.com>
 <20120822203003.GJ19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822203003.GJ19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:30:03PM -0700, Tejun Heo wrote:
> This description needs to be several times more descriptive than it
> currently is.  The deadlock issue at hand is very unobvious.  Please
> explain it so that someone who isn't familiar with the problem can
> understand it by reading it.
> 
> Also, please describe how the patch was tested.

New patch below, tell me how the new description reads?

> > @@ -306,16 +324,39 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  		p = kmalloc(sizeof(struct bio) +
> >  			    nr_iovecs * sizeof(struct bio_vec),
> >  			    gfp_mask);
> > +
> >  		front_pad = 0;
> >  		inline_vecs = nr_iovecs;
> >  	} else {
> > -		p = mempool_alloc(bs->bio_pool, gfp_mask);
> > +		/*
> > +		 * If we're running under generic_make_request()
> > +		 * (current->bio_list != NULL), we risk deadlock if we sleep on
> > +		 * allocation and there's already bios on current->bio_list that
> > +		 * were allocated from the same bio_set; they won't be submitted
> > +		 * (and thus freed) as long as we're blocked here.
> > +		 *
> > +		 * To deal with this, we first try the allocation without using
> > +		 * the mempool; if that fails, we punt all the bios on
> > +		 * current->bio_list to a different thread and then retry the
> > +		 * allocation with the original gfp mask.
> > +		 */
> 
> Ditto here.

Ok, tell me if the new version below is better.

> 
> > +		if (current->bio_list &&
> > +		    !bio_list_empty(current->bio_list) &&
> > +		    (gfp_mask & __GFP_WAIT))
> > +			gfp_mask &= GFP_ATOMIC;
> 
> Why aren't we turning off __GFP_WAIT instead?  e.g. What if the caller
> has one of NUMA flags or __GFP_COLD specified?

Didn't think of that. The reason I did it that way is I wasn't sure if
just doing &= ~__GFP_WAIT would be correct, since that would leave
__GFP_IO|__GFP_FS set.

Look at how the mempool code uses the gfp flags, it's not clear to me
what happens in general if __GFP_WAIT isn't set but __GFP_IO is... but I
_think_ masking out __GFP_WAIT is sufficient and correct.

(The mempool code masks out __GFP_IO where it masks out __GFP_WAIT, but
it doesn't mask out __GFP_FS. Why would masking out __GFP_IO matter? And
if it does, why isn't __GFP_FS masked out? Inquiring minds want to know.

But at least for my purposes masking out __GFP_WAIT looks correct.

> > +retry:
> > +		if (gfp_mask & __GFP_WAIT)
> > +			p = mempool_alloc(bs->bio_pool, gfp_mask);
> > +		else
> > +			p = kmem_cache_alloc(bs->bio_slab, gfp_mask);
> 
> Why is it necessary to avoid using the mempool if __GFP_WAIT is
> already cleared?

Now that I think about it, avoiding the mempool shouldn't be necessary
at all (and it's better not to since the mempool code adds various
flags, so allocating without those flags is at least inconsistent).

> Plesae don't mix struct definition relocation (or any relocation
> really) with actual changes.  It buries the actual changes and makes
> reviewing difficult.

Make a new patch that does nothing more than reorder the definitions,
then?


commit d4351a8fc634d3ed95c27f633184f3f87ba5c754
Author: Kent Overstreet <koverstreet@google.com>
Date:   Thu Aug 23 22:54:17 2012 -0700

    block: Avoid deadlocks with bio allocation by stacking drivers
    
    Previously, if we ever try to allocate more than once from the same bio
    set while running under generic_make_request() (i.e. a stacking block
    driver), we risk deadlock.
    
    This is because of the code in generic_make_request() that converts
    recursion to iteration; any bios we submit won't actually be submitted
    (so they can complete and eventually be freed) until after we return -
    this means if we allocate a second bio, we're blocking the first one
    from ever being freed.
    
    Thus if enough threads call into a stacking block driver at the same
    time with bios that need multiple splits, and the bio_set's reserve gets
    used up, we deadlock.
    
    This can be worked around in the driver code - we could check if we're
    running under generic_make_request(), then mask out __GFP_WAIT when we
    go to allocate a bio, and if the allocation fails punt to workqueue and
    retry the allocation.
    
    But this is tricky and not a generic solution. This patch solves it for
    all users by inverting the previously described technique. We allocate a
    rescuer workqueue for each bio_set, and then in the allocation code if
    there are bios on current->bio_list we would be blocking, we punt them
    to the rescuer workqueue to be submitted.
    
    Tested it by forcing the rescue codepath to be taken (by disabling the
    first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
    of arbitrary bio splitting) and verified that the rescuer was being
    invoked.
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>
    CC: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/bio.c b/fs/bio.c
index ed34526..f9f87d7 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -282,6 +282,23 @@ void bio_reset(struct bio *bio)
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
@@ -304,6 +321,7 @@ EXPORT_SYMBOL(bio_reset);
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -318,16 +336,44 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		p = kmalloc(sizeof(struct bio) +
 			    nr_iovecs * sizeof(struct bio_vec),
 			    gfp_mask);
+
 		front_pad = 0;
 		inline_vecs = nr_iovecs;
 	} else {
+		/*
+		 * generic_make_request() converts recursion to iteration; this
+		 * means if we're running beneath it, any bios we allocate and
+		 * submit will not be submitted (and thus freed) until after we
+		 * return.
+		 *
+		 * This exposes us to a potential deadlock if we allocate
+		 * multiple bios from the same bio_set() while running
+		 * underneath generic_make_request(). If we were to allocate
+		 * multiple bios (say a stacking block driver that was splitting
+		 * bios), we would deadlock if we exhausted the mempool's
+		 * reserve.
+		 *
+		 * We solve this, and guarantee forward progress, with a rescuer
+		 * workqueue per bio_set. If we go to allocate and there are
+		 * bios on current->bio_list, we first try the allocation
+		 * without __GFP_WAIT; if that fails, we punt those bios we
+		 * would be blocking to the rescuer workqueue before we retry
+		 * with the original gfp_flags.
+		 */
+
+		if (current->bio_list &&
+		    !bio_list_empty(current->bio_list) &&
+		    (gfp_mask & __GFP_WAIT))
+			gfp_mask &= ~__GFP_WAIT;
+retry:
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
+
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
 	}
 
 	if (unlikely(!p))
-		return NULL;
+		goto err;
 
 	bio = p + front_pad;
 	bio_init(bio);
@@ -348,6 +394,19 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
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
@@ -1556,6 +1615,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1591,6 +1653,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1601,9 +1667,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
