Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2JOUSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:18:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2JOUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:26 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        vgoyal@redhat.com
Subject: [PATCH v4 2/2] block: Avoid deadlocks with bio allocation by stacking drivers
Date: Mon, 15 Oct 2012 13:09:00 -0700
Message-Id: <1350331769-14856-27-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Muthukumar Ratty <muthur@gmail.com>
---
 fs/bio.c            | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/bio.h |   9 ++++
 2 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 9298c65..9aa1938 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -295,6 +295,54 @@ void bio_reset(struct bio *bio)
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
+	 * In order to guarantee forward progress we must punt only bios that
+	 * were allocated from this bio_set; otherwise, if there was a bio on
+	 * there for a stacking driver higher up in the stack, processing it
+	 * could require allocating bios from this bio_set, and doing that from
+	 * our own rescuer would be bad.
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
@@ -312,11 +360,27 @@ EXPORT_SYMBOL(bio_reset);
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
@@ -334,7 +398,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
+
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
+		if (!p && gfp_mask != saved_gfp) {
+			punt_bios_to_rescuer(bs);
+			gfp_mask = saved_gfp;
+			p = mempool_alloc(bs->bio_pool, gfp_mask);
+		}
+
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
 	}
@@ -347,6 +441,12 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 	if (nr_iovecs > inline_vecs) {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+		if (!bvl && gfp_mask != saved_gfp) {
+			punt_bios_to_rescuer(bs);
+			gfp_mask = saved_gfp;
+			bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+		}
+
 		if (unlikely(!bvl))
 			goto err_free;
 	} else if (nr_iovecs) {
@@ -1575,6 +1675,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1610,6 +1713,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1620,9 +1727,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
index 93d3d17..b31036f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -513,6 +513,15 @@ struct bio_set {
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
-- 
1.7.12

