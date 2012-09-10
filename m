Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2IJA2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:28:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36483 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2IJA2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:28:45 -0400
Date: Sun, 9 Sep 2012 17:28:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910002810.GA23241@moria.home.lan>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:36:41PM -0700, Tejun Heo wrote:
> (Restoring cc list from the previous discussion.  Please retain the cc
> list of the people who discussed in the previous postings.)
> 
> On Fri, Sep 07, 2012 at 03:12:53PM -0700, Kent Overstreet wrote:
> > But this is tricky and not a generic solution. This patch solves it for
> > all users by inverting the previously described technique. We allocate a
> > rescuer workqueue for each bio_set, and then in the allocation code if
> > there are bios on current->bio_list we would be blocking, we punt them
> > to the rescuer workqueue to be submitted.
> 
> It would be great if this explanation can be expanded a bit.  Why does
> it make the deadlock condition go away?  What are the restrictions -
> e.g. using other mempools for additional per-bio data structure
> wouldn't work, right?

Ok, I'll do that. New patch below.

> > +static void punt_bios_to_rescuer(struct bio_set *bs)
> > +{
> > +	struct bio_list punt, nopunt;
> > +	struct bio *bio;
> > +
> > +	bio_list_init(&punt);
> > +	bio_list_init(&nopunt);
> > +
> > +	while ((bio = bio_list_pop(current->bio_list)))
> > +		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> > +
> > +	*current->bio_list = nopunt;
> 
> Why this is necessary needs explanation and it's done in rather
> unusual way.  I suppose the weirdness is from bio_list API
> restriction?

It's because bio_lists are singly linked, so deleting an entry from the
middle of the list would be a real pain - just much cleaner/simpler to
do it this way.

> > +	spin_lock(&bs->rescue_lock);
> > +	bio_list_merge(&bs->rescue_list, &punt);
> > +	spin_unlock(&bs->rescue_lock);
> > +
> > +	queue_work(bs->rescue_workqueue, &bs->rescue_work);
> > +}
> > +
> >  /**
> >   * bio_alloc_bioset - allocate a bio for I/O
> >   * @gfp_mask:   the GFP_ mask given to the slab allocator
> > @@ -317,6 +354,7 @@ EXPORT_SYMBOL(bio_reset);
> >   */
> >  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  {
> > +	gfp_t saved_gfp = gfp_mask;
> >  	unsigned front_pad;
> >  	unsigned inline_vecs;
> >  	unsigned long idx = BIO_POOL_NONE;
> > @@ -334,13 +372,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  		front_pad = 0;
> >  		inline_vecs = nr_iovecs;
> >  	} else {
> > +		/*
> > +		 * generic_make_request() converts recursion to iteration; this
> > +		 * means if we're running beneath it, any bios we allocate and
> > +		 * submit will not be submitted (and thus freed) until after we
> > +		 * return.
> > +		 *
> > +		 * This exposes us to a potential deadlock if we allocate
> > +		 * multiple bios from the same bio_set() while running
> > +		 * underneath generic_make_request(). If we were to allocate
> > +		 * multiple bios (say a stacking block driver that was splitting
> > +		 * bios), we would deadlock if we exhausted the mempool's
> > +		 * reserve.
> > +		 *
> > +		 * We solve this, and guarantee forward progress, with a rescuer
> > +		 * workqueue per bio_set. If we go to allocate and there are
> > +		 * bios on current->bio_list, we first try the allocation
> > +		 * without __GFP_WAIT; if that fails, we punt those bios we
> > +		 * would be blocking to the rescuer workqueue before we retry
> > +		 * with the original gfp_flags.
> > +		 */
> > +
> > +		if (current->bio_list && !bio_list_empty(current->bio_list))
> > +			gfp_mask &= ~__GFP_WAIT;
> > +retry:
> >  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> >  		front_pad = bs->front_pad;
> >  		inline_vecs = BIO_INLINE_VECS;
> >  	}
> 
> Wouldn't the following be better?
> 
> 	p = mempool_alloc(bs->bi_pool, gfp_mask);
> 	if (unlikely(!p) && gfp_mask != saved_gfp) {
> 		punt_bios_to_rescuer(bs);
> 		p = mempool_alloc(bs->bi_pool, saved_gfp);
> 	}

That'd require duplicating the error handling in two different places -
once for the initial allocation, once for the bvec allocation. And I
really hate that writing code that does

alloc_something()
if (fail) {
	alloc_something_again()
}

it just screams ugly to me.

> I really hope the usage restriction (don't mix with mempool) for
> bioset is clearly documented somewhere appropriate.

Good point, I'm adding it to bio_alloc_bioset's documentation.


commit 4edb21e0b749fc098c72edcb4f9abdeca6fc62cd
Author: Kent Overstreet <koverstreet@google.com>
Date:   Sun Sep 9 17:23:29 2012 -0700

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
    
    This guarantees forward progress for bio allocations under
    generic_make_request() provided each bio is submitted before allocating
    the next, and provided the bios are freed after they complete.
    
    Note that this doesn't do anything for allocation from other mempools.
    Instead of allocating per bio data structures from a mempool, code
    should use bio_set's front_pad.
    
    Tested it by forcing the rescue codepath to be taken (by disabling the
    first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
    of arbitrary bio splitting) and verified that the rescuer was being
    invoked.
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>
    CC: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/bio.c b/fs/bio.c
index 13e9567..fa07e1f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -295,6 +295,53 @@ void bio_reset(struct bio *bio)
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
+static void punt_bios_to_rescuer(struct bio_set *bs)
+{
+	struct bio_list punt, nopunt;
+	struct bio *bio;
+
+	/*
+	 * Don't want to punt all bios on current->bio_list; if there was a bio
+	 * on there for a stacking driver higher up in the stack, processing it
+	 * could require allocating bios from this bio_set, and we don't want to
+	 * do that from our own rescuer.
+	 *
+	 * Since bio lists are singly linked, pop them all instead of trying to
+	 * remove from the middle of the list:
+	 */
+
+	bio_list_init(&punt);
+	bio_list_init(&nopunt);
+
+	while ((bio = bio_list_pop(current->bio_list)))
+		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
+
+	*current->bio_list = nopunt;
+
+	spin_lock(&bs->rescue_lock);
+	bio_list_merge(&bs->rescue_list, &punt);
+	spin_unlock(&bs->rescue_lock);
+
+	queue_work(bs->rescue_workqueue, &bs->rescue_work);
+}
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -312,11 +359,27 @@ EXPORT_SYMBOL(bio_reset);
  *   previously allocated bio for IO before attempting to allocate a new one.
  *   Failure to do so can cause deadlocks under memory pressure.
  *
+ *   Note that when running under generic_make_request() (i.e. any block
+ *   driver), bios are not submitted until after you return - see the code in
+ *   generic_make_request() that converts recursion into iteration, to prevent
+ *   stack overflows.
+ *
+ *   This would normally mean allocating multiple bios under
+ *   generic_make_request() would be susceptible to deadlocks, but we have
+ *   deadlock avoidance code that resubmits any blocked bios from a rescuer
+ *   thread.
+ *
+ *   However, we do not guarantee forward progress for allocations from other
+ *   mempools. Doing multiple allocations from the same mempool under
+ *   generic_make_request() should be avoided - instead, use bio_set's front_pad
+ *   for per bio allocations.
+ *
  *   RETURNS:
  *   Pointer to new bio on success, NULL on failure.
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -334,13 +397,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
+		if (current->bio_list && !bio_list_empty(current->bio_list))
+			gfp_mask &= ~__GFP_WAIT;
+retry:
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
 	}
 
 	if (unlikely(!p))
-		return NULL;
+		goto err;
 
 	bio = p + front_pad;
 	bio_init(bio);
@@ -361,6 +448,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 err_free:
 	mempool_free(p, bs->bio_pool);
+err:
+	if (gfp_mask != saved_gfp) {
+		punt_bios_to_rescuer(bs);
+		gfp_mask = saved_gfp;
+		goto retry;
+	}
+
 	return NULL;
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
@@ -1570,6 +1664,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1605,6 +1702,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1615,9 +1716,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
index a2bfe3a..c32ea0d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -491,6 +491,15 @@ struct bio_set {
 	mempool_t *bio_integrity_pool;
 #endif
 	mempool_t *bvec_pool;
+
+	/*
+	 * Deadlock avoidance for stacking block drivers: see comments in
+	 * bio_alloc_bioset() for details
+	 */
+	spinlock_t		rescue_lock;
+	struct bio_list		rescue_list;
+	struct work_struct	rescue_work;
+	struct workqueue_struct	*rescue_workqueue;
 };
 
 struct biovec_slab {
