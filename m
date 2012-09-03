Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2ICBev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:34:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2ICBet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:34:49 -0400
Date: Sun, 2 Sep 2012 18:34:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] block: Avoid deadlocks with bio allocation by stacking
 drivers
Message-ID: <20120903013415.GE20060@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 07:13:48PM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> > Here is one quick and dirty proof of concept patch. It checks for stack
> > depth and if remaining space is less than 20% of stack size, then it
> > defers the bio submission to per queue worker.
> 
> So, it removes breadth-first walking of bio construction by ensuring
> stack overflow never happens by bouncing to workqueue if stack usage
> seems too high.
> 
> I do like removal of breadth-first walking.  It makes failure
> scenarios a lot less mind-bending.  That said, Kent is right that this
> can incur significant overhead for certain configurations, and looking
> at stack usage in block layer is rather nasty both in design and
> implementation.
> 
> If we're gonna need rescuer anyway and can get it right and the
> mechanism can be contained in block proper relatively well, I think it
> would be better to make bread-first walking safe.  Both are nasty in
> their own ways after all.

I added that filtering I was talking about, and I like this version much
better.

To me at least, it's much clearer what it's actually doing; when we go
sleep in an allocation, we first unblock only the bios that were
allocated from this bio_set - i.e. only the bios that caused the
original deadlock.

It's still trickier than Vivek's approach but the performance impact
certainly lowers, since we're only using the workqueue thread on
allocation failure.

commit c61f9c16dc8c7ae833a73b857936106c71daab3f
Author: Kent Overstreet <koverstreet@google.com>
Date:   Fri Aug 31 20:52:41 2012 -0700

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
index 22d654f..076751f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -286,6 +286,43 @@ void bio_reset(struct bio *bio)
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
@@ -308,6 +345,7 @@ EXPORT_SYMBOL(bio_reset);
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -325,13 +363,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
@@ -352,6 +414,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
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
@@ -1561,6 +1630,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1596,6 +1668,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1606,9 +1682,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
index a7561b9..f329102 100644
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
