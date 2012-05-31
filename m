Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2EaAwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:52:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51980 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2EaAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:52:28 -0400
Date: Wed, 30 May 2012 17:52:25 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tejun@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120531005224.GA5645@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
 <20120530072358.GB4854@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530072358.GB4854@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:23:58PM +0900, Tejun Heo wrote:
> Hello, Kent.
> 
> I followed the control from cached_dev_make_request() this time.
> 
> On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
> > + * Since the gens and priorities are all stored contiguously on disk, we can
> > + * batch this up: We fill up the free_inc list with freshly invalidated buckets,
> 
> What does "inc" in free_inc stand for?

Incoming:

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b20c49b..8ce9758 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -342,6 +342,25 @@ struct cache {
 	 */
 	atomic_t		prio_written;
 
+	/*
+	 * free: Buckets that are ready to be used
+	 *
+	 * free_inc: Incoming buckets - these are buckets that currently have
+	 * cached data in them, and we can't reuse them until after we write
+	 * their new gen to disk. After prio_write() finishes writing the new
+	 * gens/prios, they'll be moved to the free list (and possibly discarded
+	 * in the process)
+	 *
+	 * unused: GC found nothing pointing into these buckets (possibly
+	 * because all the data they contained was overwritten), so we only
+	 * need to discard them before they can be moved to the free list.
+	 */
+	DECLARE_FIFO(long, free);
+	DECLARE_FIFO(long, free_inc);
+	DECLARE_FIFO(long, unused);
+
+	size_t			fifo_last_bucket;
+
 	/* Allocation stuff: */
 	struct bucket		*buckets;
 
@@ -360,12 +379,6 @@ struct cache {
 	 */
 	unsigned		invalidate_needs_gc:1;
 
-	size_t			fifo_last_bucket;
-
-	DECLARE_FIFO(long, free);
-	DECLARE_FIFO(long, free_inc);
-	DECLARE_FIFO(long, unused);
-
 	bool			discard; /* Get rid of? */
 	struct list_head	discards;
 	struct page		*discard_page;

> 
> > +static void discard_finish(struct work_struct *w)
> > +{
> > +	struct discard *d = container_of(w, struct discard, work);
> > +	struct cache *c = d->c;
> > +	char buf[BDEVNAME_SIZE];
> > +	bool run = false;
> > +
> > +	if (!test_bit(BIO_UPTODATE, &d->bio.bi_flags)) {
> > +		printk(KERN_NOTICE "bcache: discard error on %s, disabling\n",
> > +		       bdevname(c->bdev, buf));
> > +		d->c->discard = 0;
> > +	}
> > +
> > +	mutex_lock(&c->set->bucket_lock);
> > +	if (fifo_empty(&c->free) ||
> > +	    fifo_used(&c->free) == 8)

Oh, ugh. That isn't even right - at _least_ the second check should be
fifo_used() >= 8, not ==. It should probably be deleted entirely and
just always do the wakeup, but the allocation code is prone to spinning
and burning 100% cpu if stuff like that is wrong - I'll have to test it
carefully.

> I'm getting scared of the number 8.  What does this mean?  Is it the
> new 666?  Oh, now I think about it, it's 2^3 thus 2*2*2.  It's 3 of
> 2s.  I think I can see the connection now.  Oh devil!

It's a reserve, for btree bucket allocation - enough buckets for a btree
split to succeed and for garbage collection to get some work done.

I have code in my copying gc branch that gets rid of that magic number -
copying gc requires another reserve, and there's yet another reserve for
writing priorities - the new code consolidates all that.

> 
> > +		run = true;
> > +
> > +	fifo_push(&c->free, d->bucket);
> > +
> > +	list_add(&d->list, &c->discards);
> > +
> > +	do_discard(c);
> 
> So, this chains discard issuing.  Wouldn't some explanation be nice?

Yeah. Does this help?

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ce9758..ccf4060 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -380,6 +380,13 @@ struct cache {
 	unsigned		invalidate_needs_gc:1;
 
 	bool			discard; /* Get rid of? */
+
+	/*
+	 * We preallocate structs for issuing discards to buckets, and keep them
+	 * on this list when they're not in use; do_discard() issues discards
+	 * whenever there's work to do and is called by free_some_buckets() and
+	 * when a discard finishes.
+	 */
 	struct list_head	discards;
 	struct page		*discard_page;

> 
> > +	mutex_unlock(&c->set->bucket_lock);
> > +
> > +	if (run)
> > +		closure_wake_up(&c->set->bucket_wait);
> > +
> > +	closure_put(&c->set->cl);
> > +}
> > +
> > +static void discard_endio(struct bio *bio, int error)
> > +{
> > +	struct discard *d = container_of(bio, struct discard, bio);
> > +
> > +	PREPARE_WORK(&d->work, discard_finish);
> > +	schedule_work(&d->work);
> > +}
> 
> Why is a work item used here?  Why not closure?  What's the
> difference?  This pattern of bouncing completion processing to process
> context is also something common in bio sequencing.  I keep thinking
> what we want is bio sequencer.

That's a good question, I hadn't quite thought about explaining closures
from that angle.

The main thing about closures, and the thing that separates them from a
lot of other existing constructs is they have a well defined lifetime.
That's IMO kind of natural if you think of a closure as a refcount on
steroids, and it's very useful - it's why the parent makes sense (and
using that well is what made a lot of tricky refcounting and other
issues go away).

The end result - the way I think about it, anyways - is that closures
are more threadlike and work_structs make more sense in the context of
state machines.

Anyways, from that angle it probably would make sense to use closures
here - the discard has a well defined lifetime, and it holds a refcount
on the cache_set while it exists (i.e. the cache_set would be the parent
closure).

I thought about it a bit when I originally wrote that code, and IIRC I
ended up not using closures just because it wasn't necessary and
wouldn't have made the code any smaller - the discard itself doesn't
need a refcount for anything.

But I've also been trying to get rid of bare closure_puts() wherever
reasonably possible - the idea being that things are more consistent and
harder to screw up if closure_put() is only ever called on something
that code logically owns (e.g. how it's used in most of the endio
functions). Switching it to use a closure instead of a work_struct would
mean the closure_put() on the cache_set's closure would go away, it
would instead be done by the final closure_return().

> > +
> > +static void discard_work(struct work_struct *w)
> > +{
> > +	struct discard *d = container_of(w, struct discard, work);
> > +	submit_bio(0, &d->bio);
> > +}
> > +
> > +static void do_discard(struct cache *c)
> > +{
> > +	struct request_queue *q = bdev_get_queue(c->bdev);
> > +	int s = q->limits.logical_block_size;
> > +
> 
> Prolly can use lockdep_assert_held().

Yeah, good idea.

> 
> > +	while (c->discard &&
> > +	       !atomic_read(&c->set->closing) &&
> > +	       !list_empty(&c->discards) &&
> > +	       fifo_free(&c->free) >= 8) {
> 
> What's the magic 8?  Is this 8 someway related to other 8s in this
> file?  How is one supposed to know what they mean or the rationale
> behind it?

This one is making sure there'll be room to stick the bucket on the free
list - the 8 is the maximum number of discards that could be in flight.

I'm fixing that now. Didn't realize how many bare 8s there were in this
file that meant different things.

> 
> > +		struct discard *d = list_first_entry(&c->discards,
> > +						     struct discard, list);
> > +
> > +		d->bucket = pop_freed(c);
> > +		if (d->bucket == -1)
> > +			break;
> > +
> > +		list_del(&d->list);
> > +		closure_get(&c->set->cl);
> > +
> > +		bio_init(&d->bio);
> > +		memset(&d->bv, 0, sizeof(struct bio_vec));
> > +		bio_set_prio(&d->bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
> > +
> > +		d->bio.bi_sector	= bucket_to_sector(c->set, d->bucket);
> > +		d->bio.bi_bdev		= c->bdev;
> > +		d->bio.bi_rw		= REQ_WRITE|(1 << BIO_RW_DISCARD);
> > +		d->bio.bi_max_vecs	= 1;
> > +		d->bio.bi_io_vec	= d->bio.bi_inline_vecs;
> > +		d->bio.bi_end_io	= discard_endio;
> > +
> > +		if (bio_add_pc_page(q, &d->bio, c->discard_page, s, 0) < s) {
> > +			printk(KERN_DEBUG "bcache: bio_add_pc_page failed\n");
> > +			c->discard = 0;
> > +			fifo_push(&c->free, d->bucket);
> > +			list_add(&d->list, &c->discards);
> > +			break;
> > +		}
> > +
> > +		d->bio.bi_size = bucket_bytes(c);
> > +
> > +		schedule_work(&d->work);
> > +	}
> > +}
> ...
> > +int alloc_discards(struct cache *ca)
> > +{
> > +	for (int i = 0; i < 8; i++) {
> > +		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
> > +		if (!d)
> > +			return -ENOMEM;
> > +
> > +		d->c = ca;
> > +		INIT_WORK(&d->work, discard_work);
> > +		list_add(&d->list, &ca->discards);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Why maintain separate pool of discards?  It it to throttle discard
> commands?  And another evil number!

Yeah, it's just a mempool that also throttles. I don't particularly care
for doing it that way, any suggestions? (Just fixed the magic number, at
least).

> 
> > +static bool can_invalidate_bucket(struct cache *c, struct bucket *b)
> > +{
> > +	return b->mark >= 0 &&
> > +		!atomic_read(&b->pin) &&
> > +		bucket_gc_gen(b) < 96U &&
> > +		bucket_disk_gen(b) < 64U;
> 
> Ahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

b->mark >= 0 is pretty terrible (and it's also something fixed in my
copy gc branch, heh).

In this code if mark is >= 0 it means there's only clean cached data in
this bucket (the values for btree data and dirty data are negative), and
if it's positive it's also the number of sectors gc found in this bucket
(so that invalidate_buckets_lru() can preferentially invalidate buckets
with less data in them).

The latest code splits out mark and sectors_used.

The !atomic_read() should be fairly self explanatory. I'm going to get
rid of the per bucket refcount eventually, right now it's just used when
we allocate a bucket so we can ensure it's not garbage collected until
we insert a pointer to it into the btree.

bucket_gc_gen(), bucket_disk_gen() are the differences between the
bucket's gen and the oldest gen in the btree (gc gen), and the gen on
disk - those checks ensure the gen doesn't wrap around.

This improve things?

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index c37f73f..eb44b1d 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -74,11 +74,11 @@ uint8_t inc_gen(struct cache *c, struct bucket *b)
 	uint8_t ret = ++b->gen;
 
 	c->set->need_gc = max(c->set->need_gc, bucket_gc_gen(b));
-	BUG_ON(c->set->need_gc > 97);
+	WARN_ON_ONCE(c->set->need_gc > BUCKET_GC_GEN_MAX);
 
 	if (CACHE_SYNC(&c->set->sb)) {
 		c->need_save_prio = max(c->need_save_prio, bucket_disk_gen(b));
-		BUG_ON(c->need_save_prio > 96);
+		WARN_ON_ONCE(c->need_save_prio > BUCKET_DISK_GEN_MAX);
 	}
 
 	return ret;
@@ -263,6 +263,12 @@ int alloc_discards(struct cache *ca)
 
 /* Allocation */
 
+static inline bool can_inc_bucket_gen(struct bucket *b)
+{
+	return bucket_gc_gen(b) < BUCKET_GC_GEN_MAX &&
+		bucket_disk_gen(b) < BUCKET_DISK_GEN_MAX;
+}
+
 bool bucket_add_unused(struct cache *c, struct bucket *b)
 {
 	if (c->prio_alloc == prio_buckets(c) &&
@@ -271,8 +277,7 @@ bool bucket_add_unused(struct cache *c, struct bucket *b)
 
 	b->prio = 0;
 
-	if (bucket_gc_gen(b) < 96U &&
-	    bucket_disk_gen(b) < 64U &&
+	if (can_inc_bucket_gen(b) &&
 	    fifo_push(&c->unused, b - c->buckets)) {
 		atomic_inc(&b->pin);
 		return true;
@@ -285,8 +290,7 @@ static bool can_invalidate_bucket(struct cache *c, struct bucket *b)
 {
 	return b->mark >= 0 &&
 		!atomic_read(&b->pin) &&
-		bucket_gc_gen(b) < 96U &&
-		bucket_disk_gen(b) < 64U;
+		can_inc_bucket_gen(b);
 }
 
 static void invalidate_one_bucket(struct cache *c, struct bucket *b)
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ccf4060..f505168 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -821,8 +821,26 @@ static inline bool cached_dev_get(struct cached_dev *d)
 	return true;
 }
 
-#define bucket_gc_gen(b)	((uint8_t) ((b)->gen - (b)->last_gc))
-#define bucket_disk_gen(b)	((uint8_t) ((b)->gen - (b)->disk_gen))
+/*
+ * bucket_gc_gen() returns the difference between the bucket's current gen and
+ * the oldest gen of any pointer into that bucket in the btree (last_gc).
+ *
+ * bucket_disk_gen() returns the difference between the current gen and the gen
+ * on disk; they're both used to make sure gens don't wrap around.
+ */
+
+static inline uint8_t bucket_gc_gen(struct bucket *b)
+{
+	return b->gen - b->last_gc;
+}
+
+static inline uint8_t bucket_disk_gen(struct bucket *b)
+{
+	return b->gen - b->disk_gc;
+}
+
+#define BUCKET_GC_GEN_MAX	96U
+#define BUCKET_DISK_GEN_MAX	64U
 
 #define kobj_attribute_write(n, fn)					\
 	static struct kobj_attribute ksysfs_##n = __ATTR(n, S_IWUSR, NULL, fn)

> 
> > +static void invalidate_buckets_lru(struct cache *c)
> > +{
> > +	unsigned bucket_prio(struct bucket *b)
> > +	{
> > +		return ((unsigned) (b->prio - c->set->min_prio)) * b->mark;
> > +	}
> > +
> > +	bool bucket_max_cmp(struct bucket *l, struct bucket *r)
> > +	{
> > +		return bucket_prio(l) < bucket_prio(r);
> > +	}
> > +
> > +	bool bucket_min_cmp(struct bucket *l, struct bucket *r)
> > +	{
> > +		return bucket_prio(l) > bucket_prio(r);
> > +	}
> > +
> > +	struct bucket *b;
> > +
> > +	c->heap.used = 0;
> > +
> > +	for_each_bucket(b, c) {
> 
> So, this iterates all buckets in the cache, right?  Maybe it warrants
> cond_resched()?

This is probably on the order of ~1 ms but - it can't hurt, and I
haven't actually measured it.

> 
> > +		if (!can_invalidate_bucket(c, b))
> > +			continue;
> > +
> > +		if (!b->mark) {
> > +			if (!bucket_add_unused(c, b))
> > +				return;
> > +		} else {
> > +			if (!heap_full(&c->heap))
> > +				heap_add(&c->heap, b, bucket_max_cmp);
> > +			else if (bucket_max_cmp(b, heap_peek(&c->heap))) {
> > +				c->heap.data[0] = b;
> > +				heap_sift(&c->heap, 0, bucket_max_cmp);
> > +			}
> > +		}
> > +	}
> > +
> > +	if (c->heap.used * 2 < c->heap.size)
> > +		bcache_queue_gc(c->set);
> > +
> > +	for (ssize_t i = c->heap.used / 2 - 1; i >= 0; --i)
> > +		heap_sift(&c->heap, i, bucket_min_cmp);
> > +
> > +	while (!fifo_full(&c->free_inc)) {
> > +		if (!heap_pop(&c->heap, b, bucket_min_cmp)) {
> > +			/* We don't want to be calling invalidate_buckets()
> > +			 * multiple times when it can't do anything
> > +			 */
> > +			c->invalidate_needs_gc = 1;
> > +			bcache_queue_gc(c->set);
> > +			return;
> > +		}
> > +
> > +		invalidate_one_bucket(c, b);
> > +	}
> > +}
> > +void free_some_buckets(struct cache *c)
> > +{
> > +	long r;
> > +
> > +	/*
> > +	 * XXX: do_discard(), prio_write() take refcounts on the cache set.  How
> > +	 * do we know that refcount is nonzero?
> > +	 */
> > +
> > +	do_discard(c);
> > +
> > +	while (!fifo_full(&c->free) &&
> > +	       (fifo_used(&c->free) <= 8 ||
> 
> Ooh, devil!

I'm deleting that fifo_free() <= 8 check. The idea is that if we're
under our reserve we'll skip the discard and just allocate the bucket
immediately, but there's no real need for it and it's going to
complicate things later.


> 
> > +		!c->discard) &&
> > +	       (r = pop_freed(c)) != -1)
> > +		fifo_push(&c->free, r);
> > +
> > +	while (c->prio_alloc != prio_buckets(c) &&
> > +	       fifo_pop(&c->free, r)) {
> > +		struct bucket *b = c->buckets + r;
> > +		c->prio_next[c->prio_alloc++] = r;
> > +
> > +		b->mark = GC_MARK_BTREE;
> > +		atomic_dec_bug(&b->pin);
> > +	}
> > +
> > +	if (!CACHE_SYNC(&c->set->sb)) {
> > +		if (fifo_empty(&c->free_inc))
> > +			invalidate_buckets(c);
> > +		return;
> > +	}
> > +
> > +	/* XXX: tracepoint for when c->need_save_prio > 64 */
> > +
> > +	if (c->need_save_prio <= 64 &&
> 
> Ooh, devil * devil!
> 
> > +	    fifo_used(&c->unused) > c->unused.size / 2)
> > +		return;
> > +
> > +	if (atomic_read(&c->prio_written) > 0 &&
> > +	    (fifo_empty(&c->free_inc) ||
> > +	     c->need_save_prio > 64))
> > +		atomic_set(&c->prio_written, 0);
> > +
> > +	if (!can_save_prios(c))
> > +		return;
> > +
> > +	invalidate_buckets(c);
> > +
> > +	if (!fifo_empty(&c->free_inc) ||
> > +	    c->need_save_prio > 64)
> > +		prio_write(c);
> > +}
> > +
> > +static long pop_bucket(struct cache *c, uint16_t priority, struct closure *cl)
> > +{
> > +	long r = -1;
> > +again:
> > +	free_some_buckets(c);
> > +
> > +	if ((priority == btree_prio ||
> > +	     fifo_used(&c->free) > 8) &&
> > +	    fifo_pop(&c->free, r)) {
> 
> This is unconventional and more difficult to read than
> 
> 	if ((priority == btree_prio || fifo_used(&c->free) > 8) &&
> 	    fifo_pop(&c->free, r)) {
> 
> It harms readability by both being unnecessarily different and
> visually less distinguishible.  Why do this?

I prefer extra linebreaks in complicated if statements as the
indentation makes the way the parentheses group things clearer, but for
this one I'm fine with your version.

This is again the btree reserve. I'm gonna see if I can pull the
improved reserve code out of my copying gc branch (I haven't worked on
it awhile and some of the code could use more testing).

> 
> > +		struct bucket *b = c->buckets + r;
> > +#ifdef CONFIG_BCACHE_EDEBUG
> > +		long i;
> > +		for (unsigned j = 0; j < prio_buckets(c); j++)
> > +			BUG_ON(c->prio_buckets[j] == (uint64_t) r);
> > +		for (unsigned j = 0; j < c->prio_alloc; j++)
> > +			BUG_ON(c->prio_next[j] == (uint64_t) r);
> > +
> > +		fifo_for_each(i, &c->free)
> > +			BUG_ON(i == r);
> > +		fifo_for_each(i, &c->free_inc)
> > +			BUG_ON(i == r);
> > +		fifo_for_each(i, &c->unused)
> > +			BUG_ON(i == r);
> > +#endif
> > +		BUG_ON(atomic_read(&b->pin) != 1);
> > +
> > +		b->prio = priority;
> > +		b->mark = priority == btree_prio
> > +			? GC_MARK_BTREE
> > +			: c->sb.bucket_size;
> > +		return r;
> > +	}
> > +
> > +	pr_debug("no free buckets, prio_written %i, blocked %i, "
> > +		 "free %zu, free_inc %zu, unused %zu",
> > +		 atomic_read(&c->prio_written),
> > +		 atomic_read(&c->set->prio_blocked), fifo_used(&c->free),
> > +		 fifo_used(&c->free_inc), fifo_used(&c->unused));
> > +
> > +	if (cl) {
> > +		if (closure_blocking(cl))
> > +			mutex_unlock(&c->set->bucket_lock);
> > +
> > +		closure_wait_event(&c->set->bucket_wait, cl,
> > +				   atomic_read(&c->prio_written) > 0 ||
> > +				   can_save_prios(c));
> > +
> > +		if (closure_blocking(cl)) {
> > +			mutex_lock(&c->set->bucket_lock);
> > +			goto again;
> > +		}
> > +	}
> 
> How is this different from using @gfp_flags (for %__GFP_WAIT) or bool
> @may_block + -EAGAIN return?

It's not fundamentally different. The reason I originally added it was
for the closure_wait_event() in get_bucket() - for cache lookups (i.e.
handling a read, which at least starts out running under
generic_make_request()) it's critical that the wait be asynchronous, but
for insertions that code doesn't want to wait asynchronously (and drop
locks). The closure_blocking() flag means that get_bucket() doesn't have
to care, as long as it handles async sync will also work.

But I'm thinking it probably was a mistake and should be ripped out, in
favor of some kind of explicit parameter like you suggest.

> 
> > +	return -1;
> > +}
> > +
> > +void unpop_bucket(struct cache_set *c, struct bkey *k)
> > +{
> > +	for (unsigned i = 0; i < KEY_PTRS(k); i++) {
> > +		struct bucket *b = PTR_BUCKET(c, k, i);
> > +
> > +		b->mark = 0;
> > +		bucket_add_unused(PTR_CACHE(c, k, i), b);
> > +	}
> > +}
> > +
> > +int __pop_bucket_set(struct cache_set *c, uint16_t prio,
> > +		     struct bkey *k, int n, struct closure *cl)
> > +{
> > +	lockdep_assert_held(&c->bucket_lock);
> > +	BUG_ON(!n || n > c->caches_loaded || n > 8);
> > +
> > +	k->header = KEY_HEADER(0, 0);
> > +
> > +	/* sort by free space/prio of oldest data in caches */
> > +
> > +	for (int i = 0; i < n; i++) {
> > +		struct cache *ca = c->cache_by_alloc[i];
> > +		long b = pop_bucket(ca, prio, cl);
> > +
> > +		if (b == -1)
> > +			goto err;
> > +
> > +		k->ptr[i] = PTR(ca->buckets[b].gen,
> > +				bucket_to_sector(c, b),
> > +				ca->sb.nr_this_dev);
> > +
> > +		SET_KEY_PTRS(k, i + 1);
> > +	}
> > +
> > +	return 0;
> > +err:
> > +	unpop_bucket(c, k);
> > +	__bkey_put(c, k);
> > +	return -1;
> > +}
> ...
> > +static void bio_invalidate(struct closure *cl)
> > +{
> > +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> > +	struct search *s = container_of(op, struct search, op);
> > +	struct bio *bio = s->cache_bio;
> > +
> > +	pr_debug("invalidating %i sectors from %llu",
> > +		 bio_sectors(bio), (uint64_t) bio->bi_sector);
> > +
> > +	while (bio_sectors(bio)) {
> > +		unsigned len = min(bio_sectors(bio), 1U << 14);
> 
> New line missing.  Again, I'm not gonna complain about this more but
> please follow the usual formatting.  There are cases where deviating
> can be beneficial / tolerated but IMHO you're deviating way too often
> for no good reasons (well, they're not apparent to me anyway).

I'll argue about some of the newlines you consider extra but I won't
argue about any missing newlines - fixed.

> 
> > +		if (keylist_realloc(&s->op.keys, 0, s->op.d->c))
> > +			goto out;
> > +
> > +		bio->bi_sector	+= len;
> > +		bio->bi_size	-= len << 9;
> > +
> > +		keylist_add(&s->op.keys,
> > +			    &KEY(s->op.d->id, bio->bi_sector, len));
> > +	}
> > +
> > +	s->bio_insert_done = true;
> > +out:
> > +	continue_at(cl, bcache_journal, bcache_wq);
> > +}
> ...
> > +static struct open_bucket *get_data_bucket(struct bkey *search,
> > +					   struct search *s)
> > +{
> > +	struct closure cl, *w = NULL;
> > +	struct cache_set *c = s->op.d->c;
> > +	struct open_bucket *l, *ret, *ret_task;
> > +
> 
> Unnecessary new line.

That one serves no purpose, fixed.

> > +	BKEY_PADDED(key) alloc;
> 
> Why BKEY_PADDED()?  What does it do?  Can we not do this?

Just a bare struct bkey on the stack won't be big enough for any
pointers.

I _suppose_ I could do something like:

struct bkey_padded alloc_pad;
struct bkey *alloc = &alloc_pad.key;

I like that marginally better. Any better ideas?

> > +	struct bkey *k = NULL;
> > +
> > +	if (s->writeback) {
> > +		closure_init_stack(&cl);
> > +		w = &cl;
> > +	}
> > +again:
> > +	ret = ret_task = NULL;
> > +
> > +	spin_lock(&c->data_bucket_lock);
> > +	list_for_each_entry_reverse(l, &c->data_buckets, list)
> > +		if (!bkey_cmp(&l->key, search)) {
> > +			ret = l;
> > +			goto found;
> > +		} else if (l->last == s->task)
> > +			ret_task = l;
> 
>  if () {
>  } else if () {
>  }

Wasn't aware of that convention when I wrote most of this code - fixed.

> Also, it's better to always use braces in outer constructs if inner
> needs one.
> 
> And, it seems the bucket allocations follow the task.  What's the
> benefit of doing so?  Why isn't there any explanation?

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 5e00e2b..16185ef 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -322,6 +322,28 @@ static void put_data_bucket(struct open_bucket *b, struct cache_set *c,
 	spin_unlock(&c->data_bucket_lock);
 }
 
+/**
+ * get_data_bucket - pick out a bucket to write some data to, possibly
+ * allocating a new one.
+ *
+ * We keep multiple buckets open for writes, and try to segregate different
+ * write streams for better cache utilization: first we look for a bucket where
+ * the last write to it was sequential with the current write, and failing that
+ * we look for a bucket that was last used by the same task.
+ *
+ * The ideas is if you've got multiple tasks pulling data into the cache at the
+ * same time, you'll get better cache utilization if you try to segregate their
+ * data and preserve locality.
+ *
+ * For example, say you've starting Firefox at the same time you're copying a
+ * bunch of files. Firefox will likely end up being fairly hot and stay in the
+ * cache awhile, but the data you copied might not be; if you wrote all that
+ * data to the same buckets it'd get invalidated at the same time.
+ *
+ * Both of those tasks will be doing fairly random IO so we can't rely on
+ * detecting sequential IO to segregate their data, but going off of the task
+ * should be a sane heuristic.
+ */
 static struct open_bucket *get_data_bucket(struct bkey *search,
 					   struct search *s)
 {

> 
> > +
> > +	ret = ret_task ?: list_first_entry(&c->data_buckets,
> > +					   struct open_bucket, list);
> > +found:
> > +	if (!ret->sectors_free) {
> > +		if (!k) {
> > +			spin_unlock(&c->data_bucket_lock);
> > +			k = &alloc.key;
> > +
> > +			if (pop_bucket_set(c, initial_prio, k, 1, w))
> > +				return NULL;
> > +
> > +			goto again;
> 
> So, this is "try-locked-first, on failure, unlock-alloc-retry"
> dancing.  Constructs like this aren't too atypical but they still
> warrant short explanation.  Please be nice to people trying to read
> your code.

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 28f4ef4..20485b2 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -357,6 +357,11 @@ static struct open_bucket *get_data_bucket(struct bkey *search,
 		closure_init_stack(&cl);
 		w = &cl;
 	}
+	/*
+	 * We might have to allocate a new bucket, which we can't do with a
+	 * spinlock held. So if we have to allocate, we drop the lock, allocate
+	 * and then retry.
+	 */
 again:
 	ret = ret_task = NULL;
 
@@ -393,6 +398,11 @@ found:
 			EBUG_ON(ptr_stale(c, &ret->key, i));
 	}
 
+	/*
+	 * If we had to allocate and then retry, we might discover that we raced
+	 * and no longer need to allocate. Therefore, if we allocated a bucket
+	 * but didn't use it, drop the refcount pop_bucket_set() took:
+	 */
 	if (k)
 		__bkey_put(c, k);
 
> > +		}
> > +
> > +		bkey_copy(&ret->key, k);
> > +		k = NULL;
> > +
> > +		ret->sectors_free = c->sb.bucket_size;
> > +	} else
> > +		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
> > +			EBUG_ON(ptr_stale(c, &ret->key, i));
> > +
> > +	if (k)
> > +		__bkey_put(c, k);
> > +
> > +	if (w)
> > +		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
> > +			PTR_BUCKET(c, &ret->key, i)->mark = GC_MARK_DIRTY;
> > +
> > +	ret->last = s->task;
> > +	bkey_copy_key(&ret->key, search);
> > +
> > +	list_move_tail(&ret->list, &c->data_buckets);
> 
> This too.  It's a rather common pattern and people would be able to
> just read through without thinking if it had one line comment saying
> something like /* @ret is hot now, put it at the head of queue */.

Done.

> 
> > +	return ret;
> > +}
> ...
> > +static void bio_insert(struct closure *cl)
> 
> Too generic name.  This and a lot of others.  Note that there are
> issues other than direct compile time symbol collision - it makes the
> code difficult to grep for and stack traces difficult to decipher.
> I'm not gonna complain more about too generic names but please review
> the code and fix other instances too.

I'm pretty terrible at naming, so if at some point you could help me
come up with names that are descriptive _to you_, it'd be a big help.

> 
> Another thing is that why this function and its friends take @cl when
> they always expect @cl contained inside search->op.  Why not take
> @search instead?  Using @cl is more dangerous and less readable.  Why
> do it?

bio_insert() used to be the closure function, but after breaking out
bio_insert_loop() that's no longer true - so yeah, it should've been
changed.

I've also been trying to get rid of all of bio_insert()'s dependencies
on struct search. Not quite done.

> 
> > +{
> > +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> > +	struct search *s = container_of(op, struct search, op);
> > +	struct bio *bio = s->cache_bio;
> > +
> > +	if (!s->skip) {
> > +		bio->bi_end_io	= bio_insert_endio;
> > +		bio->bi_private = cl;
> > +		bio_get(bio);
> > +	}
> > +
> > +	keylist_init(&op->keys);
> > +	bio_insert_loop(cl);
> > +}
> ...
> > +static void __do_bio_hook(struct search *s)
> > +{
> > +	struct bio *bio = &s->bio.bio;
> > +	memcpy(bio, s->orig_bio, sizeof(struct bio));
> > +
> > +#ifdef CONFIG_DISKMON
> 
> Contamination.

Ugh, yep.

> 
> > +	bio->bi_flowid		= NULL;
> > +#endif
> > +	bio->bi_end_io		= request_endio;
> > +	bio->bi_private		= &s->cl;
> > +	bio->bi_destructor	= NULL;
> > +	atomic_set(&bio->bi_cnt, 3);
> > +}
> > +
> > +static struct search *do_bio_hook(struct bio *bio, struct bcache_device *d)
> > +{
> > +	struct bio_vec *bv;
> > +	struct search *s = mempool_alloc(d->c->search, GFP_NOIO);
> > +	memset(s, 0, offsetof(struct search, op.keys));
> > +
> > +	__closure_init(&s->cl, NULL);
> > +	__closure_init(&s->op.cl, &s->cl);
> > +
> > +	s->op.d			= d;
> > +	s->op.lock		= -1;
> > +	s->task			= get_current();
> 
> Please use current instead of get_current().

Done.

> 
> > +	s->orig_bio		= bio;
> > +	s->write		= bio->bi_rw & REQ_WRITE;
> > +	s->op.flush_journal	= bio->bi_rw & REQ_FLUSH;
> > +	s->recoverable		= 1;
> > +	__do_bio_hook(s);
> > +
> > +	if (bio->bi_size != bio_segments(bio) * PAGE_SIZE) {
> > +		bv = mempool_alloc(d->unaligned_bvec, GFP_NOIO);
> > +		memcpy(bv, bio_iovec(bio),
> > +		       sizeof(struct bio_vec) * bio_segments(bio));
> > +
> > +		s->bio.bio.bi_io_vec	= bv;
> > +		s->unaligned_bvec	= 1;
> > +	}
> > +
> > +	return s;
> > +}
> ...
> > +static bool should_writeback(struct cached_dev *d, struct bio *bio)
> > +{
> > +	return !atomic_read(&d->disk.detaching) &&
> > +		cache_mode(d, bio) == CACHE_MODE_WRITEBACK &&
> > +		(d->disk.c->gc_stats.in_use < (bio->bi_rw & REQ_SYNC)
> > +		 ? CUTOFF_WRITEBACK_SYNC
> > +		 : CUTOFF_WRITEBACK);
> 
> The formatting of the CUTOFF_WRITEBACK* test is atrocious.  It almost
> looks like it's trying to mislead the reader.  For $DIETY's sake, use
> a local variable for the threshold value or split the condition into a
> few "if () return;" clauses.

I clearly have different tastes than you here (it parses easily to me),
but the local variable for the threshold is a great idea - doing that.

> 
> > +}
> > +
> > +static void request_write_resubmit(struct closure *cl)
> > +{
> > +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> > +	struct search *s = container_of(op, struct search, op);
> > +	struct bio *bio = &s->bio.bio;
> > +
> > +	closure_bio_submit(bio, &s->cl, op->d->c->bio_split);
> > +
> > +	bio_insert(&s->op.cl);
> > +	continue_at(&s->cl, cached_dev_write_complete, NULL);
> > +}
> 
> I'm kinda turned off by closure here too.  It doesn't really seem to
> simplify the actual painful points of async programming.  The user
> still has to compose separate paths for sync and async paths.  I keep
> thinking domain-specific sequencer would be much better.

Not really following your complaint. The resubmit path is required when
allocating a bio split fails because we're running under
generic_make_request() - it's ugly, but I'm not sure how you're going to
make it any cleaner.

I need to rebase this code onto my block cleanup patch series, the patch
to make generic_make_request() handle arbitrary sized bios makes this go
away.

> > +
> > +static void request_write(struct cached_dev *d, struct search *s)
> > +{
> > +	struct closure *cl = &s->cl;
> > +	struct bio *bio = &s->bio.bio;
> > +
> > +	check_should_skip(d, s);
> > +	down_read_non_owner(&d->writeback_lock);
> > +
> > +	if (bcache_in_writeback(d, bio->bi_sector, bio_sectors(bio))) {
> > +		s->skip		= false;
> > +		s->writeback	= true;
> > +	}
> > +
> > +	if (s->skip) {
> > +skip:		s->cache_bio = s->orig_bio;
> > +		bio_get(s->cache_bio);
> > +		trace_bcache_write_skip(s->orig_bio);
> > +
> > +		if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
> 
> This isn't bcache's problem but it probably would be better to make
> block layer handle this in generic manner.  blk_queue_discard()
> already indicates whether a queue supports discard or not.
> generic_make_request() can simply treat discards as no-op if
> unsupported.

Good idea (especially since a no-op is a valid implementation of trim).

> 
> > +			closure_get(cl);
> > +
> > +			if (blk_queue_discard(bdev_get_queue(d->bdev)))
> > +				generic_make_request(bio);
> > +			else
> > +				bio_endio(bio, 0);
> > +
> > +			goto out;
> > +		} else
> > +			goto submit;
> > +	}
> > +
> > +	if (should_writeback(d, s->orig_bio))
> > +		s->writeback = true;
> > +
> > +	if (!s->writeback) {
> > +		s->cache_bio = bbio_kmalloc(GFP_NOIO, bio->bi_max_vecs);
> > +		if (!s->cache_bio) {
> > +			s->skip = true;
> > +			goto skip;
> > +		}
> > +
> > +		__bio_clone(s->cache_bio, bio);
> > +		trace_bcache_writethrough(s->orig_bio);
> > +submit:
> > +		if (closure_bio_submit(bio, cl, s->op.d->c->bio_split))
> > +			continue_at(&s->op.cl,
> > +				    request_write_resubmit,
> > +				    bcache_wq);
> > +	} else {
> > +		s->cache_bio = bio;
> > +		trace_bcache_writeback(s->orig_bio);
> > +		bcache_writeback_add(d, bio_sectors(bio));
> > +	}
> > +out:
> > +	bio_insert(&s->op.cl);
> > +	continue_at(cl, cached_dev_write_complete, NULL);
> > +}
> 
> I hate how gotos are being abused in this function.  This ain't 80s
> and we don't build complex control flow using gotos. 

It is a nasty piece of code (but 10x better than it used to be).

> If common logic
> is used in different parts of the control flow in a way that the usual
> control constructs don't really yield pretty code, factor out the
> common part into a function.  Are you not doing that because you don't
> wanna put continue_at() inside another function which may obscure the
> closure control flow?  If that's the case, I think it just shows how
> retarded wrapping return in macros is.  :(

That is a major downside (that's one reason I liked your idea of
returning an opaque cookie).

But making generic_make_request() handle arbitrary size bios is going to
make a lot of the pain in this function go away (there'll only be a
single continue_at() in request_write() after that) - with that and your
discard idea the skip path boils down to almost nothing.

I'm just gonna rebase this code onto my block cleanup branch.

> 
> > +static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
> > +{
> > +	struct search *s;
> > +	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
> > +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> > +
> > +	bio->bi_bdev = dc->bdev;
> > +	bio->bi_sector += 16;
>                          ^^^^
> 
> Please don't do this.  Use of magic numbers seems pretty common
> throughout the code base.  This is error-prone and cryptic.  Use enums
> or macros (this is what macros are for, actually) to give them
> meaningful names.  If applicable, explain why the specific number is
> chosen on constant definition.  I assume this is the size of
> superblock but I can't ask cscope about it or grep for it.

Just added BDEV_DATA_START.

> 
> > +
> > +	if (cached_dev_get(dc)) {
> > +		s = do_bio_hook(bio, d);
> > +		trace_bcache_request_start(&s->op, bio);
> > +
> > +		(!bio_has_data(bio)	? request_nodata :
> > +		 bio->bi_rw & REQ_WRITE ? request_write :
> > +					  request_read)(dc, s);
> 
> Don't do this.  Among other things, it should be possible to search /
> grep for "FUNCTION_NAME(" and find all the direct invocations.  Just
> use if/else.  You're not gaining anything from doing things like the
> above while basically aggravating other developers trying to
> understand your code.

I don't buy the argument about finding direct invocations (tons of stuff
is indirectly invoked today and i can't remember ever caring about
direct invocations vs. calls via a pointer, and worse for grepping is
all the set wrappers for things like merge_bvec_fn (it's inconsistent
and what is this, C++?)

But I give up, changed it :P
