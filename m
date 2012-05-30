Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2E3Hco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:32:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab2E3Hcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:32:41 -0400
Date: Wed, 30 May 2012 16:32:27 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120530073227.GC4854@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

I followed the control from cached_dev_make_request() this time.

On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
> + * Since the gens and priorities are all stored contiguously on disk, we can
> + * batch this up: We fill up the free_inc list with freshly invalidated buckets,

What does "inc" in free_inc stand for?

> +static void discard_finish(struct work_struct *w)
> +{
> +	struct discard *d = container_of(w, struct discard, work);
> +	struct cache *c = d->c;
> +	char buf[BDEVNAME_SIZE];
> +	bool run = false;
> +
> +	if (!test_bit(BIO_UPTODATE, &d->bio.bi_flags)) {
> +		printk(KERN_NOTICE "bcache: discard error on %s, disabling\n",
> +		       bdevname(c->bdev, buf));
> +		d->c->discard = 0;
> +	}
> +
> +	mutex_lock(&c->set->bucket_lock);
> +	if (fifo_empty(&c->free) ||
> +	    fifo_used(&c->free) == 8)

I'm getting scared of the number 8.  What does this mean?  Is it the
new 666?  Oh, now I think about it, it's 2^3 thus 2*2*2.  It's 3 of
2s.  I think I can see the connection now.  Oh devil!

> +		run = true;
> +
> +	fifo_push(&c->free, d->bucket);
> +
> +	list_add(&d->list, &c->discards);
> +
> +	do_discard(c);

So, this chains discard issuing.  Wouldn't some explanation be nice?

> +	mutex_unlock(&c->set->bucket_lock);
> +
> +	if (run)
> +		closure_wake_up(&c->set->bucket_wait);
> +
> +	closure_put(&c->set->cl);
> +}
> +
> +static void discard_endio(struct bio *bio, int error)
> +{
> +	struct discard *d = container_of(bio, struct discard, bio);
> +
> +	PREPARE_WORK(&d->work, discard_finish);
> +	schedule_work(&d->work);
> +}

Why is a work item used here?  Why not closure?  What's the
difference?  This pattern of bouncing completion processing to process
context is also something common in bio sequencing.  I keep thinking
what we want is bio sequencer.

> +
> +static void discard_work(struct work_struct *w)
> +{
> +	struct discard *d = container_of(w, struct discard, work);
> +	submit_bio(0, &d->bio);
> +}
> +
> +static void do_discard(struct cache *c)
> +{
> +	struct request_queue *q = bdev_get_queue(c->bdev);
> +	int s = q->limits.logical_block_size;
> +

Prolly can use lockdep_assert_held().

> +	while (c->discard &&
> +	       !atomic_read(&c->set->closing) &&
> +	       !list_empty(&c->discards) &&
> +	       fifo_free(&c->free) >= 8) {

What's the magic 8?  Is this 8 someway related to other 8s in this
file?  How is one supposed to know what they mean or the rationale
behind it?

> +		struct discard *d = list_first_entry(&c->discards,
> +						     struct discard, list);
> +
> +		d->bucket = pop_freed(c);
> +		if (d->bucket == -1)
> +			break;
> +
> +		list_del(&d->list);
> +		closure_get(&c->set->cl);
> +
> +		bio_init(&d->bio);
> +		memset(&d->bv, 0, sizeof(struct bio_vec));
> +		bio_set_prio(&d->bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
> +
> +		d->bio.bi_sector	= bucket_to_sector(c->set, d->bucket);
> +		d->bio.bi_bdev		= c->bdev;
> +		d->bio.bi_rw		= REQ_WRITE|(1 << BIO_RW_DISCARD);
> +		d->bio.bi_max_vecs	= 1;
> +		d->bio.bi_io_vec	= d->bio.bi_inline_vecs;
> +		d->bio.bi_end_io	= discard_endio;
> +
> +		if (bio_add_pc_page(q, &d->bio, c->discard_page, s, 0) < s) {
> +			printk(KERN_DEBUG "bcache: bio_add_pc_page failed\n");
> +			c->discard = 0;
> +			fifo_push(&c->free, d->bucket);
> +			list_add(&d->list, &c->discards);
> +			break;
> +		}
> +
> +		d->bio.bi_size = bucket_bytes(c);
> +
> +		schedule_work(&d->work);
> +	}
> +}
...
> +int alloc_discards(struct cache *ca)
> +{
> +	for (int i = 0; i < 8; i++) {
> +		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
> +		if (!d)
> +			return -ENOMEM;
> +
> +		d->c = ca;
> +		INIT_WORK(&d->work, discard_work);
> +		list_add(&d->list, &ca->discards);
> +	}
> +
> +	return 0;
> +}

Why maintain separate pool of discards?  It it to throttle discard
commands?  And another evil number!

> +static bool can_invalidate_bucket(struct cache *c, struct bucket *b)
> +{
> +	return b->mark >= 0 &&
> +		!atomic_read(&b->pin) &&
> +		bucket_gc_gen(b) < 96U &&
> +		bucket_disk_gen(b) < 64U;

Ahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

> +static void invalidate_buckets_lru(struct cache *c)
> +{
> +	unsigned bucket_prio(struct bucket *b)
> +	{
> +		return ((unsigned) (b->prio - c->set->min_prio)) * b->mark;
> +	}
> +
> +	bool bucket_max_cmp(struct bucket *l, struct bucket *r)
> +	{
> +		return bucket_prio(l) < bucket_prio(r);
> +	}
> +
> +	bool bucket_min_cmp(struct bucket *l, struct bucket *r)
> +	{
> +		return bucket_prio(l) > bucket_prio(r);
> +	}
> +
> +	struct bucket *b;
> +
> +	c->heap.used = 0;
> +
> +	for_each_bucket(b, c) {

So, this iterates all buckets in the cache, right?  Maybe it warrants
cond_resched()?

> +		if (!can_invalidate_bucket(c, b))
> +			continue;
> +
> +		if (!b->mark) {
> +			if (!bucket_add_unused(c, b))
> +				return;
> +		} else {
> +			if (!heap_full(&c->heap))
> +				heap_add(&c->heap, b, bucket_max_cmp);
> +			else if (bucket_max_cmp(b, heap_peek(&c->heap))) {
> +				c->heap.data[0] = b;
> +				heap_sift(&c->heap, 0, bucket_max_cmp);
> +			}
> +		}
> +	}
> +
> +	if (c->heap.used * 2 < c->heap.size)
> +		bcache_queue_gc(c->set);
> +
> +	for (ssize_t i = c->heap.used / 2 - 1; i >= 0; --i)
> +		heap_sift(&c->heap, i, bucket_min_cmp);
> +
> +	while (!fifo_full(&c->free_inc)) {
> +		if (!heap_pop(&c->heap, b, bucket_min_cmp)) {
> +			/* We don't want to be calling invalidate_buckets()
> +			 * multiple times when it can't do anything
> +			 */
> +			c->invalidate_needs_gc = 1;
> +			bcache_queue_gc(c->set);
> +			return;
> +		}
> +
> +		invalidate_one_bucket(c, b);
> +	}
> +}
> +void free_some_buckets(struct cache *c)
> +{
> +	long r;
> +
> +	/*
> +	 * XXX: do_discard(), prio_write() take refcounts on the cache set.  How
> +	 * do we know that refcount is nonzero?
> +	 */
> +
> +	do_discard(c);
> +
> +	while (!fifo_full(&c->free) &&
> +	       (fifo_used(&c->free) <= 8 ||

Ooh, devil!

> +		!c->discard) &&
> +	       (r = pop_freed(c)) != -1)
> +		fifo_push(&c->free, r);
> +
> +	while (c->prio_alloc != prio_buckets(c) &&
> +	       fifo_pop(&c->free, r)) {
> +		struct bucket *b = c->buckets + r;
> +		c->prio_next[c->prio_alloc++] = r;
> +
> +		b->mark = GC_MARK_BTREE;
> +		atomic_dec_bug(&b->pin);
> +	}
> +
> +	if (!CACHE_SYNC(&c->set->sb)) {
> +		if (fifo_empty(&c->free_inc))
> +			invalidate_buckets(c);
> +		return;
> +	}
> +
> +	/* XXX: tracepoint for when c->need_save_prio > 64 */
> +
> +	if (c->need_save_prio <= 64 &&

Ooh, devil * devil!

> +	    fifo_used(&c->unused) > c->unused.size / 2)
> +		return;
> +
> +	if (atomic_read(&c->prio_written) > 0 &&
> +	    (fifo_empty(&c->free_inc) ||
> +	     c->need_save_prio > 64))
> +		atomic_set(&c->prio_written, 0);
> +
> +	if (!can_save_prios(c))
> +		return;
> +
> +	invalidate_buckets(c);
> +
> +	if (!fifo_empty(&c->free_inc) ||
> +	    c->need_save_prio > 64)
> +		prio_write(c);
> +}
> +
> +static long pop_bucket(struct cache *c, uint16_t priority, struct closure *cl)
> +{
> +	long r = -1;
> +again:
> +	free_some_buckets(c);
> +
> +	if ((priority == btree_prio ||
> +	     fifo_used(&c->free) > 8) &&
> +	    fifo_pop(&c->free, r)) {

This is unconventional and more difficult to read than

	if ((priority == btree_prio || fifo_used(&c->free) > 8) &&
	    fifo_pop(&c->free, r)) {

It harms readability by both being unnecessarily different and
visually less distinguishible.  Why do this?

> +		struct bucket *b = c->buckets + r;
> +#ifdef CONFIG_BCACHE_EDEBUG
> +		long i;
> +		for (unsigned j = 0; j < prio_buckets(c); j++)
> +			BUG_ON(c->prio_buckets[j] == (uint64_t) r);
> +		for (unsigned j = 0; j < c->prio_alloc; j++)
> +			BUG_ON(c->prio_next[j] == (uint64_t) r);
> +
> +		fifo_for_each(i, &c->free)
> +			BUG_ON(i == r);
> +		fifo_for_each(i, &c->free_inc)
> +			BUG_ON(i == r);
> +		fifo_for_each(i, &c->unused)
> +			BUG_ON(i == r);
> +#endif
> +		BUG_ON(atomic_read(&b->pin) != 1);
> +
> +		b->prio = priority;
> +		b->mark = priority == btree_prio
> +			? GC_MARK_BTREE
> +			: c->sb.bucket_size;
> +		return r;
> +	}
> +
> +	pr_debug("no free buckets, prio_written %i, blocked %i, "
> +		 "free %zu, free_inc %zu, unused %zu",
> +		 atomic_read(&c->prio_written),
> +		 atomic_read(&c->set->prio_blocked), fifo_used(&c->free),
> +		 fifo_used(&c->free_inc), fifo_used(&c->unused));
> +
> +	if (cl) {
> +		if (closure_blocking(cl))
> +			mutex_unlock(&c->set->bucket_lock);
> +
> +		closure_wait_event(&c->set->bucket_wait, cl,
> +				   atomic_read(&c->prio_written) > 0 ||
> +				   can_save_prios(c));
> +
> +		if (closure_blocking(cl)) {
> +			mutex_lock(&c->set->bucket_lock);
> +			goto again;
> +		}
> +	}

How is this different from using @gfp_flags (for %__GFP_WAIT) or bool
@may_block + -EAGAIN return?

> +	return -1;
> +}
> +
> +void unpop_bucket(struct cache_set *c, struct bkey *k)
> +{
> +	for (unsigned i = 0; i < KEY_PTRS(k); i++) {
> +		struct bucket *b = PTR_BUCKET(c, k, i);
> +
> +		b->mark = 0;
> +		bucket_add_unused(PTR_CACHE(c, k, i), b);
> +	}
> +}
> +
> +int __pop_bucket_set(struct cache_set *c, uint16_t prio,
> +		     struct bkey *k, int n, struct closure *cl)
> +{
> +	lockdep_assert_held(&c->bucket_lock);
> +	BUG_ON(!n || n > c->caches_loaded || n > 8);
> +
> +	k->header = KEY_HEADER(0, 0);
> +
> +	/* sort by free space/prio of oldest data in caches */
> +
> +	for (int i = 0; i < n; i++) {
> +		struct cache *ca = c->cache_by_alloc[i];
> +		long b = pop_bucket(ca, prio, cl);
> +
> +		if (b == -1)
> +			goto err;
> +
> +		k->ptr[i] = PTR(ca->buckets[b].gen,
> +				bucket_to_sector(c, b),
> +				ca->sb.nr_this_dev);
> +
> +		SET_KEY_PTRS(k, i + 1);
> +	}
> +
> +	return 0;
> +err:
> +	unpop_bucket(c, k);
> +	__bkey_put(c, k);
> +	return -1;
> +}
...
> +static void bio_invalidate(struct closure *cl)
> +{
> +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> +	struct search *s = container_of(op, struct search, op);
> +	struct bio *bio = s->cache_bio;
> +
> +	pr_debug("invalidating %i sectors from %llu",
> +		 bio_sectors(bio), (uint64_t) bio->bi_sector);
> +
> +	while (bio_sectors(bio)) {
> +		unsigned len = min(bio_sectors(bio), 1U << 14);

New line missing.  Again, I'm not gonna complain about this more but
please follow the usual formatting.  There are cases where deviating
can be beneficial / tolerated but IMHO you're deviating way too often
for no good reasons (well, they're not apparent to me anyway).

> +		if (keylist_realloc(&s->op.keys, 0, s->op.d->c))
> +			goto out;
> +
> +		bio->bi_sector	+= len;
> +		bio->bi_size	-= len << 9;
> +
> +		keylist_add(&s->op.keys,
> +			    &KEY(s->op.d->id, bio->bi_sector, len));
> +	}
> +
> +	s->bio_insert_done = true;
> +out:
> +	continue_at(cl, bcache_journal, bcache_wq);
> +}
...
> +static struct open_bucket *get_data_bucket(struct bkey *search,
> +					   struct search *s)
> +{
> +	struct closure cl, *w = NULL;
> +	struct cache_set *c = s->op.d->c;
> +	struct open_bucket *l, *ret, *ret_task;
> +

Unnecessary new line.

> +	BKEY_PADDED(key) alloc;

Why BKEY_PADDED()?  What does it do?  Can we not do this?

> +	struct bkey *k = NULL;
> +
> +	if (s->writeback) {
> +		closure_init_stack(&cl);
> +		w = &cl;
> +	}
> +again:
> +	ret = ret_task = NULL;
> +
> +	spin_lock(&c->data_bucket_lock);
> +	list_for_each_entry_reverse(l, &c->data_buckets, list)
> +		if (!bkey_cmp(&l->key, search)) {
> +			ret = l;
> +			goto found;
> +		} else if (l->last == s->task)
> +			ret_task = l;

 if () {
 } else if () {
 }

Also, it's better to always use braces in outer constructs if inner
needs one.

And, it seems the bucket allocations follow the task.  What's the
benefit of doing so?  Why isn't there any explanation?

> +
> +	ret = ret_task ?: list_first_entry(&c->data_buckets,
> +					   struct open_bucket, list);
> +found:
> +	if (!ret->sectors_free) {
> +		if (!k) {
> +			spin_unlock(&c->data_bucket_lock);
> +			k = &alloc.key;
> +
> +			if (pop_bucket_set(c, initial_prio, k, 1, w))
> +				return NULL;
> +
> +			goto again;

So, this is "try-locked-first, on failure, unlock-alloc-retry"
dancing.  Constructs like this aren't too atypical but they still
warrant short explanation.  Please be nice to people trying to read
your code.

> +		}
> +
> +		bkey_copy(&ret->key, k);
> +		k = NULL;
> +
> +		ret->sectors_free = c->sb.bucket_size;
> +	} else
> +		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
> +			EBUG_ON(ptr_stale(c, &ret->key, i));
> +
> +	if (k)
> +		__bkey_put(c, k);
> +
> +	if (w)
> +		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
> +			PTR_BUCKET(c, &ret->key, i)->mark = GC_MARK_DIRTY;
> +
> +	ret->last = s->task;
> +	bkey_copy_key(&ret->key, search);
> +
> +	list_move_tail(&ret->list, &c->data_buckets);

This too.  It's a rather common pattern and people would be able to
just read through without thinking if it had one line comment saying
something like /* @ret is hot now, put it at the head of queue */.

> +	return ret;
> +}
...
> +static void bio_insert(struct closure *cl)

Too generic name.  This and a lot of others.  Note that there are
issues other than direct compile time symbol collision - it makes the
code difficult to grep for and stack traces difficult to decipher.
I'm not gonna complain more about too generic names but please review
the code and fix other instances too.

Another thing is that why this function and its friends take @cl when
they always expect @cl contained inside search->op.  Why not take
@search instead?  Using @cl is more dangerous and less readable.  Why
do it?

> +{
> +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> +	struct search *s = container_of(op, struct search, op);
> +	struct bio *bio = s->cache_bio;
> +
> +	if (!s->skip) {
> +		bio->bi_end_io	= bio_insert_endio;
> +		bio->bi_private = cl;
> +		bio_get(bio);
> +	}
> +
> +	keylist_init(&op->keys);
> +	bio_insert_loop(cl);
> +}
...
> +static void __do_bio_hook(struct search *s)
> +{
> +	struct bio *bio = &s->bio.bio;
> +	memcpy(bio, s->orig_bio, sizeof(struct bio));
> +
> +#ifdef CONFIG_DISKMON

Contamination.

> +	bio->bi_flowid		= NULL;
> +#endif
> +	bio->bi_end_io		= request_endio;
> +	bio->bi_private		= &s->cl;
> +	bio->bi_destructor	= NULL;
> +	atomic_set(&bio->bi_cnt, 3);
> +}
> +
> +static struct search *do_bio_hook(struct bio *bio, struct bcache_device *d)
> +{
> +	struct bio_vec *bv;
> +	struct search *s = mempool_alloc(d->c->search, GFP_NOIO);
> +	memset(s, 0, offsetof(struct search, op.keys));
> +
> +	__closure_init(&s->cl, NULL);
> +	__closure_init(&s->op.cl, &s->cl);
> +
> +	s->op.d			= d;
> +	s->op.lock		= -1;
> +	s->task			= get_current();

Please use current instead of get_current().

> +	s->orig_bio		= bio;
> +	s->write		= bio->bi_rw & REQ_WRITE;
> +	s->op.flush_journal	= bio->bi_rw & REQ_FLUSH;
> +	s->recoverable		= 1;
> +	__do_bio_hook(s);
> +
> +	if (bio->bi_size != bio_segments(bio) * PAGE_SIZE) {
> +		bv = mempool_alloc(d->unaligned_bvec, GFP_NOIO);
> +		memcpy(bv, bio_iovec(bio),
> +		       sizeof(struct bio_vec) * bio_segments(bio));
> +
> +		s->bio.bio.bi_io_vec	= bv;
> +		s->unaligned_bvec	= 1;
> +	}
> +
> +	return s;
> +}
...
> +static bool should_writeback(struct cached_dev *d, struct bio *bio)
> +{
> +	return !atomic_read(&d->disk.detaching) &&
> +		cache_mode(d, bio) == CACHE_MODE_WRITEBACK &&
> +		(d->disk.c->gc_stats.in_use < (bio->bi_rw & REQ_SYNC)
> +		 ? CUTOFF_WRITEBACK_SYNC
> +		 : CUTOFF_WRITEBACK);

The formatting of the CUTOFF_WRITEBACK* test is atrocious.  It almost
looks like it's trying to mislead the reader.  For $DIETY's sake, use
a local variable for the threshold value or split the condition into a
few "if () return;" clauses.

> +}
> +
> +static void request_write_resubmit(struct closure *cl)
> +{
> +	struct btree_op *op = container_of(cl, struct btree_op, cl);
> +	struct search *s = container_of(op, struct search, op);
> +	struct bio *bio = &s->bio.bio;
> +
> +	closure_bio_submit(bio, &s->cl, op->d->c->bio_split);
> +
> +	bio_insert(&s->op.cl);
> +	continue_at(&s->cl, cached_dev_write_complete, NULL);
> +}

I'm kinda turned off by closure here too.  It doesn't really seem to
simplify the actual painful points of async programming.  The user
still has to compose separate paths for sync and async paths.  I keep
thinking domain-specific sequencer would be much better.

> +
> +static void request_write(struct cached_dev *d, struct search *s)
> +{
> +	struct closure *cl = &s->cl;
> +	struct bio *bio = &s->bio.bio;
> +
> +	check_should_skip(d, s);
> +	down_read_non_owner(&d->writeback_lock);
> +
> +	if (bcache_in_writeback(d, bio->bi_sector, bio_sectors(bio))) {
> +		s->skip		= false;
> +		s->writeback	= true;
> +	}
> +
> +	if (s->skip) {
> +skip:		s->cache_bio = s->orig_bio;
> +		bio_get(s->cache_bio);
> +		trace_bcache_write_skip(s->orig_bio);
> +
> +		if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {

This isn't bcache's problem but it probably would be better to make
block layer handle this in generic manner.  blk_queue_discard()
already indicates whether a queue supports discard or not.
generic_make_request() can simply treat discards as no-op if
unsupported.

> +			closure_get(cl);
> +
> +			if (blk_queue_discard(bdev_get_queue(d->bdev)))
> +				generic_make_request(bio);
> +			else
> +				bio_endio(bio, 0);
> +
> +			goto out;
> +		} else
> +			goto submit;
> +	}
> +
> +	if (should_writeback(d, s->orig_bio))
> +		s->writeback = true;
> +
> +	if (!s->writeback) {
> +		s->cache_bio = bbio_kmalloc(GFP_NOIO, bio->bi_max_vecs);
> +		if (!s->cache_bio) {
> +			s->skip = true;
> +			goto skip;
> +		}
> +
> +		__bio_clone(s->cache_bio, bio);
> +		trace_bcache_writethrough(s->orig_bio);
> +submit:
> +		if (closure_bio_submit(bio, cl, s->op.d->c->bio_split))
> +			continue_at(&s->op.cl,
> +				    request_write_resubmit,
> +				    bcache_wq);
> +	} else {
> +		s->cache_bio = bio;
> +		trace_bcache_writeback(s->orig_bio);
> +		bcache_writeback_add(d, bio_sectors(bio));
> +	}
> +out:
> +	bio_insert(&s->op.cl);
> +	continue_at(cl, cached_dev_write_complete, NULL);
> +}

I hate how gotos are being abused in this function.  This ain't 80s
and we don't build complex control flow using gotos.  If common logic
is used in different parts of the control flow in a way that the usual
control constructs don't really yield pretty code, factor out the
common part into a function.  Are you not doing that because you don't
wanna put continue_at() inside another function which may obscure the
closure control flow?  If that's the case, I think it just shows how
retarded wrapping return in macros is.  :(

> +static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
> +{
> +	struct search *s;
> +	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
> +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> +
> +	bio->bi_bdev = dc->bdev;
> +	bio->bi_sector += 16;
                         ^^^^

Please don't do this.  Use of magic numbers seems pretty common
throughout the code base.  This is error-prone and cryptic.  Use enums
or macros (this is what macros are for, actually) to give them
meaningful names.  If applicable, explain why the specific number is
chosen on constant definition.  I assume this is the size of
superblock but I can't ask cscope about it or grep for it.

> +
> +	if (cached_dev_get(dc)) {
> +		s = do_bio_hook(bio, d);
> +		trace_bcache_request_start(&s->op, bio);
> +
> +		(!bio_has_data(bio)	? request_nodata :
> +		 bio->bi_rw & REQ_WRITE ? request_write :
> +					  request_read)(dc, s);

Don't do this.  Among other things, it should be possible to search /
grep for "FUNCTION_NAME(" and find all the direct invocations.  Just
use if/else.  You're not gaining anything from doing things like the
above while basically aggravating other developers trying to
understand your code.

> +	} else
> +		bio_passthrough(dc, bio);
> +}

Thanks.

-- 
tejun
