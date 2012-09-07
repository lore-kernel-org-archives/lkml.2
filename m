Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab2IGWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:13:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63630 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab2IGWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:13:07 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk
Subject: [PATCH 2/2] block: Avoid deadlocks with bio allocation by stacking drivers
Date: Fri,  7 Sep 2012 15:12:53 -0700
Message-Id: <1347055973-11581-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347055973-11581-1-git-send-email-koverstreet@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
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

Tested it by forcing the rescue codepath to be taken (by disabling the
first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
of arbitrary bio splitting) and verified that the rescuer was being
invoked.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/bio.h |  9 ++++++
 2 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 13e9567..244007f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -295,6 +295,43 @@ void bio_reset(struct bio *bio)
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
@@ -317,6 +354,7 @@ EXPORT_SYMBOL(bio_reset);
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
@@ -334,13 +372,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
@@ -361,6 +423,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
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
@@ -1570,6 +1639,9 @@ static void biovec_free_pools(struct bio_set *bs)
 
 void bioset_free(struct bio_set *bs)
 {
+	if (bs->rescue_workqueue)
+		destroy_workqueue(bs->rescue_workqueue);
+
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1605,6 +1677,10 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
+	spin_lock_init(&bs->rescue_lock);
+	bio_list_init(&bs->rescue_list);
+	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
+
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1615,9 +1691,14 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
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
-- 
1.7.12

