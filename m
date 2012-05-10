Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2EJDLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:11:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59621 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab2EJDLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:11:31 -0400
Date: Wed, 9 May 2012 23:11:25 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/bcache/alloc.c   |  591 ++++++++++++++++
 drivers/block/bcache/io.c      |  198 ++++++
 drivers/block/bcache/request.c | 1470 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/bcache/request.h |   58 ++
 4 files changed, 2317 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/bcache/alloc.c
 create mode 100644 drivers/block/bcache/io.c
 create mode 100644 drivers/block/bcache/request.c
 create mode 100644 drivers/block/bcache/request.h

diff --git a/drivers/block/bcache/alloc.c b/drivers/block/bcache/alloc.c
new file mode 100644
index 0000000..b55392f
--- /dev/null
+++ b/drivers/block/bcache/alloc.c
@@ -0,0 +1,591 @@
+
+#include "bcache.h"
+#include "btree.h"
+
+#include <linux/random.h>
+
+/*
+ * Allocation in bcache is done in terms of buckets:
+ *
+ * Each bucket has associated an 8 bit gen; this gen corresponds to the gen in
+ * btree pointers - they must match for the pointer to be considered valid.
+ *
+ * Thus (assuming a bucket has no dirty data or metadata in it) we can reuse a
+ * bucket simply by incrementing its gen.
+ *
+ * The gens (along with the priorities; it's really the gens are important but
+ * the code is named as if it's the priorities) are written in an arbitrary list
+ * of buckets on disk, with a pointer to them in the journal header.
+ *
+ * When we invalidate a bucket, we have to write its new gen to disk and wait
+ * for that write to complete before we use it - otherwise after a crash we
+ * could have pointers that appeared to be good but pointed to data that had
+ * been overwritten.
+ *
+ * Since the gens and priorities are all stored contiguously on disk, we can
+ * batch this up: We fill up the free_inc list with freshly invalidated buckets,
+ * call prio_write() - and when prio_write() eventually finishes it toggles
+ * c->prio_written and the buckets in free_inc are now ready to be used. When
+ * the free_inc list empties, we toggle c->prio_written and the cycle repeats.
+ *
+ * free_inc isn't the only freelist - if it was, we'd often to sleep while
+ * priorities and gens were being written before we could allocate. c->free is a
+ * smaller freelist, and buckets on that list are always ready to be used.
+ *
+ * If we've got discards enabled, that happens when a bucket moves from the
+ * free_inc list to the free list.
+ *
+ * There is another freelist, because sometimes we have buckets that we know
+ * have nothing pointing into them - these we can reuse without waiting for
+ * priorities to be rewritten. These come from freed btree nodes and buckets
+ * that garbage collection discovered no longer had valid keys pointing into
+ * them (because they were overwritten). That's the unused list - buckets on the
+ * unused list move to the free list, optionally being discarded in the process.
+ *
+ * It's also important to ensure that gens don't wrap around - with respect to
+ * either the oldest gen in the btree or the gen on disk. This is quite
+ * difficult to do in practice, but we explicitly guard against it anyways - if
+ * a bucket is in danger of wrapping around we simply skip invalidating it that
+ * time around, and we garbage collect or rewrite the priorities sooner than we
+ * would have otherwise.
+ *
+ * pop_bucket() allocates a single bucket from a specific cache.
+ *
+ * pop_bucket_set() allocates one or more buckets from different caches out of a
+ * cache set.
+ *
+ * free_some_buckets() drives all the processes described above. It's called
+ * from pop_bucket() and a few other places that need to make sure free buckets
+ * are ready.
+ *
+ * invalidate_buckets_(lru|fifo)() find buckets that are available to be
+ * invalidated, and then invalidate them and stick them on the free_inc list -
+ * in either lru or fifo order.
+ */
+
+static void do_discard(struct cache *);
+
+/* Bucket heap / gen */
+
+uint8_t inc_gen(struct cache *c, struct bucket *b)
+{
+	uint8_t ret = ++b->gen;
+
+	c->set->need_gc = max(c->set->need_gc, bucket_gc_gen(b));
+	BUG_ON(c->set->need_gc > 97);
+
+	if (CACHE_SYNC(&c->set->sb)) {
+		c->need_save_prio = max(c->need_save_prio, bucket_disk_gen(b));
+		BUG_ON(c->need_save_prio > 96);
+	}
+
+	return ret;
+}
+
+void rescale_priorities(struct cache_set *c, int sectors)
+{
+	struct cache *ca;
+	struct bucket *b;
+	unsigned next = c->nbuckets * c->sb.bucket_size / 1024;
+	int r;
+
+	atomic_sub(sectors, &c->rescale);
+
+	do {
+		r = atomic_read(&c->rescale);
+
+		if (r >= 0)
+			return;
+	} while (atomic_cmpxchg(&c->rescale, r, r + next) != r);
+
+	mutex_lock(&c->bucket_lock);
+
+	for_each_cache(ca, c)
+		for_each_bucket(b, ca)
+			if (b->prio &&
+			    b->prio != btree_prio &&
+			    !atomic_read(&b->pin)) {
+				b->prio--;
+				c->min_prio = min(c->min_prio, b->prio);
+			}
+
+	mutex_unlock(&c->bucket_lock);
+}
+
+static long pop_freed(struct cache *c)
+{
+	long r;
+
+	if ((!CACHE_SYNC(&c->set->sb) ||
+	     !atomic_read(&c->set->prio_blocked)) &&
+	    fifo_pop(&c->unused, r))
+		return r;
+
+	if ((!CACHE_SYNC(&c->set->sb) ||
+	     atomic_read(&c->prio_written) > 0) &&
+	    fifo_pop(&c->free_inc, r))
+		return r;
+
+	return -1;
+}
+
+/* Discard/TRIM */
+
+struct discard {
+	struct list_head	list;
+	struct work_struct	work;
+	struct cache		*c;
+	long			bucket;
+
+	struct bio		bio;
+	struct bio_vec		bv;
+};
+
+static void discard_finish(struct work_struct *w)
+{
+	struct discard *d = container_of(w, struct discard, work);
+	struct cache *c = d->c;
+	char buf[BDEVNAME_SIZE];
+	bool run = false;
+
+	if (!test_bit(BIO_UPTODATE, &d->bio.bi_flags)) {
+		printk(KERN_NOTICE "bcache: discard error on %s, disabling\n",
+		       bdevname(c->bdev, buf));
+		d->c->discard = 0;
+	}
+
+	mutex_lock(&c->set->bucket_lock);
+	if (fifo_empty(&c->free) ||
+	    fifo_used(&c->free) == 8)
+		run = true;
+
+	fifo_push(&c->free, d->bucket);
+
+	list_add(&d->list, &c->discards);
+
+	do_discard(c);
+	mutex_unlock(&c->set->bucket_lock);
+
+	if (run)
+		closure_wake_up(&c->set->bucket_wait);
+
+	closure_put(&c->set->cl);
+}
+
+static void discard_endio(struct bio *bio, int error)
+{
+	struct discard *d = container_of(bio, struct discard, bio);
+
+	PREPARE_WORK(&d->work, discard_finish);
+	schedule_work(&d->work);
+}
+
+static void discard_work(struct work_struct *w)
+{
+	struct discard *d = container_of(w, struct discard, work);
+	submit_bio(0, &d->bio);
+}
+
+static void do_discard(struct cache *c)
+{
+	struct request_queue *q = bdev_get_queue(c->bdev);
+	int s = q->limits.logical_block_size;
+
+	while (c->discard &&
+	       !atomic_read(&c->set->closing) &&
+	       !list_empty(&c->discards) &&
+	       fifo_free(&c->free) >= 8) {
+		struct discard *d = list_first_entry(&c->discards,
+						     struct discard, list);
+
+		d->bucket = pop_freed(c);
+		if (d->bucket == -1)
+			break;
+
+		list_del(&d->list);
+		closure_get(&c->set->cl);
+
+		bio_init(&d->bio);
+		memset(&d->bv, 0, sizeof(struct bio_vec));
+		bio_set_prio(&d->bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+
+		d->bio.bi_sector	= bucket_to_sector(c->set, d->bucket);
+		d->bio.bi_bdev		= c->bdev;
+		d->bio.bi_rw		= REQ_WRITE|(1 << BIO_RW_DISCARD);
+		d->bio.bi_max_vecs	= 1;
+		d->bio.bi_io_vec	= d->bio.bi_inline_vecs;
+		d->bio.bi_end_io	= discard_endio;
+
+		if (bio_add_pc_page(q, &d->bio, c->discard_page, s, 0) < s) {
+			printk(KERN_DEBUG "bcache: bio_add_pc_page failed\n");
+			c->discard = 0;
+			fifo_push(&c->free, d->bucket);
+			list_add(&d->list, &c->discards);
+			break;
+		}
+
+		d->bio.bi_size = bucket_bytes(c);
+
+		schedule_work(&d->work);
+	}
+}
+
+void free_discards(struct cache *ca)
+{
+	struct discard *d;
+
+	while (!list_empty(&ca->discards)) {
+		d = list_first_entry(&ca->discards, struct discard, list);
+		cancel_work_sync(&d->work);
+		list_del(&d->list);
+		kfree(d);
+	}
+}
+
+int alloc_discards(struct cache *ca)
+{
+	for (int i = 0; i < 8; i++) {
+		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
+		if (!d)
+			return -ENOMEM;
+
+		d->c = ca;
+		INIT_WORK(&d->work, discard_work);
+		list_add(&d->list, &ca->discards);
+	}
+
+	return 0;
+}
+
+/* Allocation */
+
+bool bucket_add_unused(struct cache *c, struct bucket *b)
+{
+	if (c->prio_alloc == prio_buckets(c) &&
+	    CACHE_REPLACEMENT(&c->sb) == CACHE_REPLACEMENT_FIFO)
+		return false;
+
+	b->prio = 0;
+
+	if (bucket_gc_gen(b) < 96U &&
+	    bucket_disk_gen(b) < 64U &&
+	    fifo_push(&c->unused, b - c->buckets)) {
+		atomic_inc(&b->pin);
+		return true;
+	}
+
+	return false;
+}
+
+static bool can_invalidate_bucket(struct cache *c, struct bucket *b)
+{
+	return b->mark >= 0 &&
+		!atomic_read(&b->pin) &&
+		bucket_gc_gen(b) < 96U &&
+		bucket_disk_gen(b) < 64U;
+}
+
+static void invalidate_one_bucket(struct cache *c, struct bucket *b)
+{
+	inc_gen(c, b);
+	b->prio = initial_prio;
+	atomic_inc(&b->pin);
+	fifo_push(&c->free_inc, b - c->buckets);
+}
+
+static void invalidate_buckets_lru(struct cache *c)
+{
+	unsigned bucket_prio(struct bucket *b)
+	{
+		return ((unsigned) (b->prio - c->set->min_prio)) * b->mark;
+	}
+
+	bool bucket_max_cmp(struct bucket *l, struct bucket *r)
+	{
+		return bucket_prio(l) < bucket_prio(r);
+	}
+
+	bool bucket_min_cmp(struct bucket *l, struct bucket *r)
+	{
+		return bucket_prio(l) > bucket_prio(r);
+	}
+
+	struct bucket *b;
+
+	c->heap.used = 0;
+
+	for_each_bucket(b, c) {
+		if (!can_invalidate_bucket(c, b))
+			continue;
+
+		if (!b->mark) {
+			if (!bucket_add_unused(c, b))
+				return;
+		} else {
+			if (!heap_full(&c->heap))
+				heap_add(&c->heap, b, bucket_max_cmp);
+			else if (bucket_max_cmp(b, heap_peek(&c->heap))) {
+				c->heap.data[0] = b;
+				heap_sift(&c->heap, 0, bucket_max_cmp);
+			}
+		}
+	}
+
+	if (c->heap.used * 2 < c->heap.size)
+		bcache_queue_gc(c->set);
+
+	for (ssize_t i = c->heap.used / 2 - 1; i >= 0; --i)
+		heap_sift(&c->heap, i, bucket_min_cmp);
+
+	while (!fifo_full(&c->free_inc)) {
+		if (!heap_pop(&c->heap, b, bucket_min_cmp)) {
+			/* We don't want to be calling invalidate_buckets()
+			 * multiple times when it can't do anything
+			 */
+			c->invalidate_needs_gc = 1;
+			bcache_queue_gc(c->set);
+			return;
+		}
+
+		invalidate_one_bucket(c, b);
+	}
+}
+
+static void invalidate_buckets_fifo(struct cache *c)
+{
+	struct bucket *b;
+	size_t checked = 0;
+
+	while (!fifo_full(&c->free_inc)) {
+		if (c->fifo_last_bucket <  c->sb.first_bucket ||
+		    c->fifo_last_bucket >= c->sb.nbuckets)
+			c->fifo_last_bucket = c->sb.first_bucket;
+
+		b = c->buckets + c->fifo_last_bucket++;
+
+		if (can_invalidate_bucket(c, b))
+			invalidate_one_bucket(c, b);
+
+		if (++checked >= c->sb.nbuckets) {
+			c->invalidate_needs_gc = 1;
+			bcache_queue_gc(c->set);
+			return;
+		}
+	}
+}
+
+static void invalidate_buckets_random(struct cache *c)
+{
+	struct bucket *b;
+	size_t checked = 0;
+
+	while (!fifo_full(&c->free_inc)) {
+		size_t n;
+		get_random_bytes(&n, sizeof(n));
+
+		n %= (size_t) (c->sb.nbuckets - c->sb.first_bucket);
+		n += c->sb.first_bucket;
+
+		b = c->buckets + n;
+
+		if (can_invalidate_bucket(c, b))
+			invalidate_one_bucket(c, b);
+
+		if (++checked >= c->sb.nbuckets / 2) {
+			c->invalidate_needs_gc = 1;
+			bcache_queue_gc(c->set);
+			return;
+		}
+	}
+}
+
+static void invalidate_buckets(struct cache *c)
+{
+	/* free_some_buckets() may just need to write priorities to keep gens
+	 * from wrapping around
+	 */
+	if (!c->set->gc_mark_valid ||
+	    c->invalidate_needs_gc)
+		return;
+
+	switch (CACHE_REPLACEMENT(&c->sb)) {
+	case CACHE_REPLACEMENT_LRU:
+		invalidate_buckets_lru(c);
+		break;
+	case CACHE_REPLACEMENT_FIFO:
+		invalidate_buckets_fifo(c);
+		break;
+	case CACHE_REPLACEMENT_RANDOM:
+		invalidate_buckets_random(c);
+		break;
+	}
+}
+
+bool can_save_prios(struct cache *c)
+{
+	return ((c->need_save_prio > 64 ||
+		 (c->set->gc_mark_valid &&
+		  !c->invalidate_needs_gc)) &&
+		!atomic_read(&c->prio_written) &&
+		!atomic_read(&c->set->prio_blocked));
+}
+
+void free_some_buckets(struct cache *c)
+{
+	long r;
+
+	/*
+	 * XXX: do_discard(), prio_write() take refcounts on the cache set.  How
+	 * do we know that refcount is nonzero?
+	 */
+
+	do_discard(c);
+
+	while (!fifo_full(&c->free) &&
+	       (fifo_used(&c->free) <= 8 ||
+		!c->discard) &&
+	       (r = pop_freed(c)) != -1)
+		fifo_push(&c->free, r);
+
+	while (c->prio_alloc != prio_buckets(c) &&
+	       fifo_pop(&c->free, r)) {
+		struct bucket *b = c->buckets + r;
+		c->prio_next[c->prio_alloc++] = r;
+
+		b->mark = GC_MARK_BTREE;
+		atomic_dec_bug(&b->pin);
+	}
+
+	if (!CACHE_SYNC(&c->set->sb)) {
+		if (fifo_empty(&c->free_inc))
+			invalidate_buckets(c);
+		return;
+	}
+
+	/* XXX: tracepoint for when c->need_save_prio > 64 */
+
+	if (c->need_save_prio <= 64 &&
+	    fifo_used(&c->unused) > c->unused.size / 2)
+		return;
+
+	if (atomic_read(&c->prio_written) > 0 &&
+	    (fifo_empty(&c->free_inc) ||
+	     c->need_save_prio > 64))
+		atomic_set(&c->prio_written, 0);
+
+	if (!can_save_prios(c))
+		return;
+
+	invalidate_buckets(c);
+
+	if (!fifo_empty(&c->free_inc) ||
+	    c->need_save_prio > 64)
+		prio_write(c);
+}
+
+static long pop_bucket(struct cache *c, uint16_t priority, struct closure *cl)
+{
+	long r = -1;
+again:
+	free_some_buckets(c);
+
+	if ((priority == btree_prio ||
+	     fifo_used(&c->free) > 8) &&
+	    fifo_pop(&c->free, r)) {
+		struct bucket *b = c->buckets + r;
+#ifdef CONFIG_BCACHE_EDEBUG
+		long i;
+		for (unsigned j = 0; j < prio_buckets(c); j++)
+			BUG_ON(c->prio_buckets[j] == (uint64_t) r);
+		for (unsigned j = 0; j < c->prio_alloc; j++)
+			BUG_ON(c->prio_next[j] == (uint64_t) r);
+
+		fifo_for_each(i, &c->free)
+			BUG_ON(i == r);
+		fifo_for_each(i, &c->free_inc)
+			BUG_ON(i == r);
+		fifo_for_each(i, &c->unused)
+			BUG_ON(i == r);
+#endif
+		BUG_ON(atomic_read(&b->pin) != 1);
+
+		b->prio = priority;
+		b->mark = priority == btree_prio
+			? GC_MARK_BTREE
+			: c->sb.bucket_size;
+		return r;
+	}
+
+	pr_debug("no free buckets, prio_written %i, blocked %i, "
+		 "free %zu, free_inc %zu, unused %zu",
+		 atomic_read(&c->prio_written),
+		 atomic_read(&c->set->prio_blocked), fifo_used(&c->free),
+		 fifo_used(&c->free_inc), fifo_used(&c->unused));
+
+	if (cl) {
+		if (closure_blocking(cl))
+			mutex_unlock(&c->set->bucket_lock);
+
+		closure_wait_event(&c->set->bucket_wait, cl,
+				   atomic_read(&c->prio_written) > 0 ||
+				   can_save_prios(c));
+
+		if (closure_blocking(cl)) {
+			mutex_lock(&c->set->bucket_lock);
+			goto again;
+		}
+	}
+
+	return -1;
+}
+
+void unpop_bucket(struct cache_set *c, struct bkey *k)
+{
+	for (unsigned i = 0; i < KEY_PTRS(k); i++) {
+		struct bucket *b = PTR_BUCKET(c, k, i);
+
+		b->mark = 0;
+		bucket_add_unused(PTR_CACHE(c, k, i), b);
+	}
+}
+
+int __pop_bucket_set(struct cache_set *c, uint16_t prio,
+		     struct bkey *k, int n, struct closure *cl)
+{
+	lockdep_assert_held(&c->bucket_lock);
+	BUG_ON(!n || n > c->caches_loaded || n > 8);
+
+	k->header = KEY_HEADER(0, 0);
+
+	/* sort by free space/prio of oldest data in caches */
+
+	for (int i = 0; i < n; i++) {
+		struct cache *ca = c->cache_by_alloc[i];
+		long b = pop_bucket(ca, prio, cl);
+
+		if (b == -1)
+			goto err;
+
+		k->ptr[i] = PTR(ca->buckets[b].gen,
+				bucket_to_sector(c, b),
+				ca->sb.nr_this_dev);
+
+		SET_KEY_PTRS(k, i + 1);
+	}
+
+	return 0;
+err:
+	unpop_bucket(c, k);
+	__bkey_put(c, k);
+	return -1;
+}
+
+int pop_bucket_set(struct cache_set *c, uint16_t prio,
+		   struct bkey *k, int n, struct closure *cl)
+{
+	int ret;
+	mutex_lock(&c->bucket_lock);
+	ret = __pop_bucket_set(c, prio, k, n, cl);
+	mutex_unlock(&c->bucket_lock);
+	return ret;
+}
diff --git a/drivers/block/bcache/io.c b/drivers/block/bcache/io.c
new file mode 100644
index 0000000..736d996
--- /dev/null
+++ b/drivers/block/bcache/io.c
@@ -0,0 +1,198 @@
+
+#include "bcache.h"
+#include "bset.h"
+#include "debug.h"
+
+/* Bios with headers */
+
+void bbio_free(struct bio *bio, struct cache_set *c)
+{
+	struct bbio *b = container_of(bio, struct bbio, bio);
+	mempool_free(b, c->bio_meta);
+}
+
+struct bio *bbio_alloc(struct cache_set *c)
+{
+	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
+	struct bio *bio = &b->bio;
+
+	bio_init(bio);
+	bio->bi_flags		|= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs	 = bucket_pages(c);
+	bio->bi_io_vec		 = bio->bi_inline_vecs;
+
+	return bio;
+}
+
+static void bbio_destructor(struct bio *bio)
+{
+	struct bbio *b = container_of(bio, struct bbio, bio);
+	kfree(b);
+}
+
+struct bio *bbio_kmalloc(gfp_t gfp, int vecs)
+{
+	struct bio *bio;
+	struct bbio *b;
+
+	b = kmalloc(sizeof(struct bbio) + sizeof(struct bio_vec) * vecs, gfp);
+	if (!b)
+		return NULL;
+
+	bio = &b->bio;
+	bio_init(bio);
+	bio->bi_flags		|= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs	 = vecs;
+	bio->bi_io_vec		 = bio->bi_inline_vecs;
+	bio->bi_destructor	 = bbio_destructor;
+
+	return bio;
+}
+
+struct bio *__bio_split_get(struct bio *bio, int len, struct bio_set *bs)
+{
+	struct bio *ret = bio_split_front(bio, len, bbio_kmalloc, GFP_NOIO, bs);
+
+	if (ret && ret != bio) {
+		closure_get(ret->bi_private);
+		ret->bi_rw &= ~REQ_UNPLUG;
+	}
+
+	return ret;
+}
+
+void __submit_bbio(struct bio *bio, struct cache_set *c)
+{
+	struct bbio *b = container_of(bio, struct bbio, bio);
+
+	bio->bi_sector	= PTR_OFFSET(&b->key, 0);
+	bio->bi_bdev	= PTR_CACHE(c, &b->key, 0)->bdev;
+
+	b->submit_time_us = local_clock_us();
+	generic_make_request(bio);
+}
+
+void submit_bbio(struct bio *bio, struct cache_set *c,
+			struct bkey *k, unsigned ptr)
+{
+	struct bbio *b = container_of(bio, struct bbio, bio);
+	bkey_copy_single_ptr(&b->key, k, ptr);
+	__submit_bbio(bio, c);
+}
+
+int submit_bbio_split(struct bio *bio, struct cache_set *c,
+		      struct bkey *k, unsigned ptr)
+{
+	struct closure *cl = bio->bi_private;
+	struct bbio *b;
+	struct bio *n;
+	unsigned sectors_done = 0;
+
+	closure_get(cl);
+
+	bio->bi_sector	= PTR_OFFSET(k, ptr);
+	bio->bi_bdev	= PTR_CACHE(c, k, ptr)->bdev;
+
+	do {
+		n = bio_split_get(bio, bio_max_sectors(bio), c);
+		if (!n) {
+			closure_put(cl);
+			return -ENOMEM;
+		}
+
+		b = container_of(n, struct bbio, bio);
+
+		bkey_copy_single_ptr(&b->key, k, ptr);
+		SET_KEY_SIZE(&b->key, KEY_SIZE(k) - sectors_done);
+		SET_PTR_OFFSET(&b->key, 0, PTR_OFFSET(k, ptr) + sectors_done);
+
+		b->submit_time_us = local_clock_us();
+		generic_make_request(n);
+	} while (n != bio);
+
+	return 0;
+}
+
+/* IO errors */
+
+void count_io_errors(struct cache *c, int error, const char *m)
+{
+	/*
+	 * The halflife of an error is:
+	 * log2(1/2)/log2(127/128) * refresh ~= 88 * refresh
+	 */
+
+	if (c->set->error_decay) {
+		unsigned count = atomic_inc_return(&c->io_count);
+
+		while (count > c->set->error_decay) {
+			unsigned errors;
+			unsigned old = count;
+			unsigned new = count - c->set->error_decay;
+
+			/*
+			 * First we subtract refresh from count; each time we
+			 * succesfully do so, we rescale the errors once:
+			 */
+
+			count = atomic_cmpxchg(&c->io_count, old, new);
+
+			if (count == old) {
+				count = new;
+
+				errors = atomic_read(&c->io_errors);
+				do {
+					old = errors;
+					new = ((uint64_t) errors * 127) / 128;
+					errors = atomic_cmpxchg(&c->io_errors,
+								old, new);
+				} while (old != errors);
+			}
+		}
+	}
+
+	if (error) {
+		char buf[BDEVNAME_SIZE];
+		unsigned errors = atomic_add_return(1 << IO_ERROR_SHIFT,
+						    &c->io_errors);
+		errors >>= IO_ERROR_SHIFT;
+
+		if (errors < c->set->error_limit)
+			err_printk("IO error on %s %s, recovering\n",
+				   bdevname(c->bdev, buf), m);
+		else
+			cache_set_error(c->set, "too many IO errors", m);
+	}
+}
+
+void bcache_endio(struct cache_set *c, struct bio *bio,
+		  int error, const char *m)
+{
+	struct closure *cl = bio->bi_private;
+	struct bbio *b = container_of(bio, struct bbio, bio);
+	struct cache *ca = PTR_CACHE(c, &b->key, 0);
+
+	unsigned threshold = bio->bi_rw & REQ_WRITE
+		? c->congested_write_threshold_us
+		: c->congested_read_threshold_us;
+
+	if (threshold) {
+		unsigned t = local_clock_us();
+
+		int us = t - b->submit_time_us;
+		int congested = atomic_read(&c->congested);
+
+		if (us > (int) threshold) {
+			int ms = us / 1024;
+			c->congested_last_us = t;
+
+			ms = min(ms, CONGESTED_MAX + congested);
+			atomic_sub(ms, &c->congested);
+		} else if (congested < 0)
+			atomic_inc(&c->congested);
+	}
+
+	count_io_errors(ca, error, m);
+	bio_put(bio);
+	closure_put(cl);
+}
diff --git a/drivers/block/bcache/request.c b/drivers/block/bcache/request.c
new file mode 100644
index 0000000..691fe8d
--- /dev/null
+++ b/drivers/block/bcache/request.c
@@ -0,0 +1,1470 @@
+
+#include "bcache.h"
+#include "btree.h"
+#include "debug.h"
+#include "request.h"
+
+#include <linux/cgroup.h>
+#include <linux/module.h>
+#include <linux/hash.h>
+#include <linux/random.h>
+#include "blk-cgroup.h"
+
+#include <trace/events/bcache.h>
+
+#define CUTOFF_CACHE_ADD	95
+#define CUTOFF_CACHE_READA	90
+#define CUTOFF_WRITEBACK	50
+#define CUTOFF_WRITEBACK_SYNC	75
+
+struct bio_passthrough {
+	struct closure		cl;
+	struct cached_dev	*d;
+	struct bio		*bio;
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+};
+
+struct kmem_cache *passthrough_cache;
+struct kmem_cache *search_cache;
+
+static void check_should_skip(struct cached_dev *, struct search *);
+
+static const char *search_type(struct search *s)
+{
+	return s->writeback ? "writeback"
+		: s->write ? "write" : "read";
+}
+
+/* Cgroup interface */
+
+#ifdef CONFIG_CGROUP_BCACHE
+static struct bcache_cgroup bcache_default_cgroup = { .cache_mode = -1 };
+
+struct bcache_cgroup *cgroup_to_bcache(struct cgroup *cgroup)
+{
+	struct cgroup_subsys_state *css;
+	return cgroup &&
+		(css = cgroup_subsys_state(cgroup, bcache_subsys_id))
+		? container_of(css, struct bcache_cgroup, css)
+		: &bcache_default_cgroup;
+}
+
+struct bcache_cgroup *bio_to_cgroup(struct bio *bio)
+{
+	return cgroup_to_bcache(get_bio_cgroup(bio));
+}
+
+static ssize_t cache_mode_read(struct cgroup *cgrp, struct cftype *cft,
+			struct file *file,
+			char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	char tmp[1024];
+	int len = sprint_string_list(tmp, bcache_cache_modes,
+				     cgroup_to_bcache(cgrp)->cache_mode + 1);
+
+	if (len < 0)
+		return len;
+
+	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
+}
+
+static int cache_mode_write(struct cgroup *cgrp, struct cftype *cft,
+			    const char *buf)
+{
+	int v = read_string_list(buf, bcache_cache_modes);
+	if (v < 0)
+		return v;
+
+	cgroup_to_bcache(cgrp)->cache_mode = v - 1;
+	return 0;
+}
+
+static u64 bcache_verify_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return cgroup_to_bcache(cgrp)->verify;
+}
+
+static int bcache_verify_write(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	cgroup_to_bcache(cgrp)->verify = val;
+	return 0;
+}
+
+static u64 bcache_cache_hits_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct bcache_cgroup *bcachecg = cgroup_to_bcache(cgrp);
+	return atomic_read(&bcachecg->stats.cache_hits);
+}
+
+static u64 bcache_cache_misses_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct bcache_cgroup *bcachecg = cgroup_to_bcache(cgrp);
+	return atomic_read(&bcachecg->stats.cache_misses);
+}
+
+static u64 bcache_cache_bypass_hits_read(struct cgroup *cgrp,
+					 struct cftype *cft)
+{
+	struct bcache_cgroup *bcachecg = cgroup_to_bcache(cgrp);
+	return atomic_read(&bcachecg->stats.cache_bypass_hits);
+}
+
+static u64 bcache_cache_bypass_misses_read(struct cgroup *cgrp,
+					   struct cftype *cft)
+{
+	struct bcache_cgroup *bcachecg = cgroup_to_bcache(cgrp);
+	return atomic_read(&bcachecg->stats.cache_bypass_misses);
+}
+
+struct cftype bcache_files[] = {
+	{
+		.name		= "cache_mode",
+		.read		= cache_mode_read,
+		.write_string	= cache_mode_write,
+	},
+	{
+		.name		= "verify",
+		.read_u64	= bcache_verify_read,
+		.write_u64	= bcache_verify_write,
+	},
+	{
+		.name		= "cache_hits",
+		.read_u64	= bcache_cache_hits_read,
+	},
+	{
+		.name		= "cache_misses",
+		.read_u64	= bcache_cache_misses_read,
+	},
+	{
+		.name		= "cache_bypass_hits",
+		.read_u64	= bcache_cache_bypass_hits_read,
+	},
+	{
+		.name		= "cache_bypass_misses",
+		.read_u64	= bcache_cache_bypass_misses_read,
+	},
+};
+
+static void init_bcache_cgroup(struct bcache_cgroup *cg)
+{
+	cg->cache_mode = -1;
+}
+
+static struct cgroup_subsys_state *
+bcachecg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	struct bcache_cgroup *cg;
+
+	cg = kzalloc(sizeof(*cg), GFP_KERNEL);
+	if (!cg)
+		return ERR_PTR(-ENOMEM);
+	init_bcache_cgroup(cg);
+	return &cg->css;
+}
+
+static void bcachecg_destroy(struct cgroup_subsys *subsys,
+			     struct cgroup *cgroup)
+{
+	struct bcache_cgroup *cg = cgroup_to_bcache(cgroup);
+	free_css_id(&bcache_subsys, &cg->css);
+	kfree(cg);
+}
+
+static int bcachecg_populate(struct cgroup_subsys *subsys,
+			     struct cgroup *cgroup)
+{
+	return cgroup_add_files(cgroup, subsys, bcache_files,
+				ARRAY_SIZE(bcache_files));
+}
+
+struct cgroup_subsys bcache_subsys = {
+	.create		= bcachecg_create,
+	.destroy	= bcachecg_destroy,
+	.populate	= bcachecg_populate,
+	.subsys_id	= bcache_subsys_id,
+	.name		= "bcache",
+	.module		= THIS_MODULE,
+};
+EXPORT_SYMBOL_GPL(bcache_subsys);
+#endif
+
+static unsigned cache_mode(struct cached_dev *d, struct bio *bio)
+{
+#ifdef CONFIG_CGROUP_BCACHE
+	int r = bio_to_cgroup(bio)->cache_mode;
+	if (r >= 0)
+		return r;
+#endif
+	return BDEV_CACHE_MODE(&d->sb);
+}
+
+static bool verify(struct cached_dev *d, struct bio *bio)
+{
+#ifdef CONFIG_CGROUP_BCACHE
+	if (bio_to_cgroup(bio)->verify)
+		return true;
+#endif
+	return d->verify;
+}
+
+static void bio_csum(struct bio *bio, struct bkey *k)
+{
+	struct bio_vec *bv;
+	uint64_t csum = 0;
+	int i;
+
+	bio_for_each_segment(bv, bio, i) {
+		void *d = kmap(bv->bv_page) + bv->bv_offset;
+		csum = crc64_update(csum, d, bv->bv_len);
+		kunmap(bv->bv_page);
+	}
+
+	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
+}
+
+/* Insert data into cache */
+
+static void bio_invalidate(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = s->cache_bio;
+
+	pr_debug("invalidating %i sectors from %llu",
+		 bio_sectors(bio), (uint64_t) bio->bi_sector);
+
+	while (bio_sectors(bio)) {
+		unsigned len = min(bio_sectors(bio), 1U << 14);
+		if (keylist_realloc(&s->op.keys, 0, s->op.d->c))
+			goto out;
+
+		bio->bi_sector	+= len;
+		bio->bi_size	-= len << 9;
+
+		keylist_add(&s->op.keys,
+			    &KEY(s->op.d->id, bio->bi_sector, len));
+	}
+
+	s->bio_insert_done = true;
+out:
+	continue_at(cl, bcache_journal, bcache_wq);
+}
+
+struct open_bucket {
+	struct list_head	list;
+	struct task_struct	*last;
+	unsigned		sectors_free;
+	BKEY_PADDED(key);
+};
+
+void bcache_open_buckets_free(struct cache_set *c)
+{
+	struct open_bucket *b;
+
+	while (!list_empty(&c->data_buckets)) {
+		b = list_first_entry(&c->data_buckets,
+				     struct open_bucket, list);
+		list_del(&b->list);
+		kfree(b);
+	}
+}
+
+int bcache_open_buckets_alloc(struct cache_set *c)
+{
+	spin_lock_init(&c->data_bucket_lock);
+
+	for (int i = 0; i < 6; i++) {
+		struct open_bucket *b = kzalloc(sizeof(*b), GFP_KERNEL);
+		if (!b)
+			return -ENOMEM;
+
+		list_add(&b->list, &c->data_buckets);
+	}
+
+	return 0;
+}
+
+static void put_data_bucket(struct open_bucket *b, struct cache_set *c,
+			    struct bkey *k, struct bio *bio)
+{
+	unsigned split = min(bio_sectors(bio), b->sectors_free);
+
+	for (unsigned i = 0; i < KEY_PTRS(&b->key); i++)
+		split = min(split, __bio_max_sectors(bio,
+				      PTR_CACHE(c, &b->key, i)->bdev,
+				      PTR_OFFSET(&b->key, i)));
+
+	b->key.key += split;
+
+	bkey_copy(k, &b->key);
+	SET_KEY_SIZE(k, split);
+
+	b->sectors_free	-= split;
+
+	/* If we're closing this open bucket, get_data_bucket()'s refcount now
+	 * belongs to the key that's being inserted
+	 */
+	if (b->sectors_free < c->sb.block_size)
+		b->sectors_free = 0;
+	else
+		for (unsigned i = 0; i < KEY_PTRS(&b->key); i++)
+			atomic_inc(&PTR_BUCKET(c, &b->key, i)->pin);
+
+	for (unsigned i = 0; i < KEY_PTRS(&b->key); i++) {
+		atomic_long_add(split,
+				&PTR_CACHE(c, &b->key, i)->sectors_written);
+
+		SET_PTR_OFFSET(&b->key, i, PTR_OFFSET(&b->key, i) + split);
+	}
+
+	spin_unlock(&c->data_bucket_lock);
+}
+
+static struct open_bucket *get_data_bucket(struct bkey *search,
+					   struct search *s)
+{
+	struct closure cl, *w = NULL;
+	struct cache_set *c = s->op.d->c;
+	struct open_bucket *l, *ret, *ret_task;
+
+	BKEY_PADDED(key) alloc;
+	struct bkey *k = NULL;
+
+	if (s->writeback) {
+		closure_init_stack(&cl);
+		w = &cl;
+	}
+again:
+	ret = ret_task = NULL;
+
+	spin_lock(&c->data_bucket_lock);
+	list_for_each_entry_reverse(l, &c->data_buckets, list)
+		if (!bkey_cmp(&l->key, search)) {
+			ret = l;
+			goto found;
+		} else if (l->last == s->task)
+			ret_task = l;
+
+	ret = ret_task ?: list_first_entry(&c->data_buckets,
+					   struct open_bucket, list);
+found:
+	if (!ret->sectors_free) {
+		if (!k) {
+			spin_unlock(&c->data_bucket_lock);
+			k = &alloc.key;
+
+			if (pop_bucket_set(c, initial_prio, k, 1, w))
+				return NULL;
+
+			goto again;
+		}
+
+		bkey_copy(&ret->key, k);
+		k = NULL;
+
+		ret->sectors_free = c->sb.bucket_size;
+	} else
+		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
+			EBUG_ON(ptr_stale(c, &ret->key, i));
+
+	if (k)
+		__bkey_put(c, k);
+
+	if (w)
+		for (unsigned i = 0; i < KEY_PTRS(&ret->key); i++)
+			PTR_BUCKET(c, &ret->key, i)->mark = GC_MARK_DIRTY;
+
+	ret->last = s->task;
+	bkey_copy_key(&ret->key, search);
+
+	list_move_tail(&ret->list, &c->data_buckets);
+	return ret;
+}
+
+static void bio_insert_error(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+
+	/*
+	 * Our data write just errored, which means we've got a bunch of keys to
+	 * insert that point to data that wasn't succesfully written.
+	 *
+	 * We don't have to insert those keys but we still have to invalidate
+	 * that region of the cache - so, if we just strip off all the pointers
+	 * from the keys we'll accomplish just that.
+	 */
+
+	struct bkey *src = op->keys.bottom, *dst = op->keys.bottom;
+
+	while (src != op->keys.top) {
+		struct bkey *n = next(src);
+
+		SET_KEY_PTRS(src, 0);
+		bkey_copy(dst, src);
+
+		dst = next(dst);
+		src = n;
+	}
+
+	op->keys.top = dst;
+
+	bcache_journal(cl);
+}
+
+static void bio_insert_endio(struct bio *bio, int error)
+{
+	struct closure *cl = bio->bi_private;
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+
+	if (error) {
+		/* TODO: We could try to recover from this. */
+		if (s->writeback)
+			s->error = error;
+		else if (s->write)
+			set_closure_fn(cl, bio_insert_error, bcache_wq);
+		else
+			set_closure_fn(cl, NULL, NULL);
+	}
+
+	bcache_endio(op->d->c, bio, error, "writing data to cache");
+}
+
+static void bio_insert_loop(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = s->cache_bio, *n;
+	unsigned sectors = bio_sectors(bio);
+
+	if (s->skip)
+		return bio_invalidate(cl);
+
+	if (atomic_sub_return(bio_sectors(bio), &op->d->c->sectors_to_gc) < 0) {
+		set_gc_sectors(op->d->c);
+		bcache_queue_gc(op->d->c);
+	}
+
+	do {
+		struct open_bucket *b;
+		struct bkey *k;
+
+		/* 1 for the device pointer and 1 for the chksum */
+		if (keylist_realloc(&op->keys,
+				    1 + (op->d->data_csum ? 1 : 0),
+				    op->d->c))
+			continue_at(cl, bcache_journal, bcache_wq);
+
+		k = op->keys.top;
+
+		b = get_data_bucket(&KEY(op->d->id, bio->bi_sector, 0), s);
+		if (!b)
+			goto err;
+
+		put_data_bucket(b, op->d->c, k, bio);
+
+		n = bio_split_get(bio, KEY_SIZE(k), op->d);
+		if (!n) {
+			__bkey_put(op->d->c, k);
+			continue_at(cl, bio_insert_loop, bcache_wq);
+		}
+
+		if (s->writeback)
+			SET_KEY_DIRTY(k, true);
+
+		SET_KEY_CSUM(k, op->d->data_csum);
+		if (op->d->data_csum)
+			bio_csum(n, k);
+
+		pr_debug("%s", pkey(k));
+		keylist_push(&op->keys);
+
+		n->bi_rw |= REQ_WRITE;
+
+		if (n == bio)
+			closure_get(cl);
+
+		trace_bcache_cache_insert(n, n->bi_sector, n->bi_bdev);
+		submit_bbio(n, op->d->c, k, 0);
+	} while (n != bio);
+
+	s->bio_insert_done = true;
+	continue_at(cl, bcache_journal, bcache_wq);
+err:
+	/* IO never happened, so bbio key isn't set up, so we can't call
+	 * bio_endio()
+	 */
+	bio_put(bio);
+
+	pr_debug("error for %s, %i/%i sectors done, bi_sector %llu",
+		 search_type(s), sectors - bio_sectors(bio), sectors,
+		 (uint64_t) bio->bi_sector);
+
+	if (s->writeback) {
+		/* This is dead code now, since we handle all memory allocation
+		 * failures and block if we don't have free buckets
+		 */
+		BUG();
+		/* Lookup in in_writeback rb tree, wait on appropriate
+		 * closure, then invalidate in btree and do normal
+		 * write
+		 */
+		s->bio_insert_done	= true;
+		s->error		= -ENOMEM;
+	} else if (s->write) {
+		s->skip			= true;
+		return bio_invalidate(cl);
+	} else
+		s->bio_insert_done	= true;
+
+	if (!keylist_empty(&op->keys))
+		continue_at(cl, bcache_journal, bcache_wq);
+	else
+		closure_return(cl);
+}
+
+static void bio_insert(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = s->cache_bio;
+
+	if (!s->skip) {
+		bio->bi_end_io	= bio_insert_endio;
+		bio->bi_private = cl;
+		bio_get(bio);
+	}
+
+	keylist_init(&op->keys);
+	bio_insert_loop(cl);
+}
+
+void bcache_btree_insert_async(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+
+	if (bcache_btree_insert(op, op->d->c)) {
+		s->error		= -ENOMEM;
+		s->bio_insert_done	= true;
+	}
+
+	if (s->bio_insert_done) {
+		keylist_free(&op->keys);
+		closure_return(cl);
+	} else
+		continue_at(cl, bio_insert_loop, bcache_wq);
+}
+
+/* Common code for the make_request functions */
+
+static void __bio_complete(struct search *s)
+{
+	if (s->orig_bio) {
+		if (s->error)
+			clear_bit(BIO_UPTODATE, &s->orig_bio->bi_flags);
+
+		trace_bcache_request_end(&s->op, s->orig_bio);
+		bio_endio(s->orig_bio, s->error);
+		s->orig_bio = NULL;
+	}
+}
+
+static void request_endio(struct bio *bio, int error)
+{
+	struct closure *cl = bio->bi_private;
+
+	if (error) {
+		struct search *s = container_of(cl, struct search, cl);
+		s->error = error;
+		/* Only cache read errors are recoverable */
+		s->recoverable = false;
+	}
+
+	bio_put(bio);
+	closure_put(cl);
+}
+
+void cache_read_endio(struct bio *bio, int error)
+{
+	struct bbio *b = container_of(bio, struct bbio, bio);
+	struct closure *cl = bio->bi_private;
+	struct search *s = container_of(cl, struct search, cl);
+
+	/*
+	 * If the bucket was reused while our bio was in flight, we might have
+	 * read the wrong data. Set s->error but not error so it doesn't get
+	 * counted against the cache device, but we'll still reread the data
+	 * from the backing device.
+	 */
+
+	if (error)
+		s->error = error;
+	else if (ptr_stale(s->op.d->c, &b->key, 0)) {
+		atomic_long_inc(&s->op.d->c->cache_read_races);
+		s->error = -EINTR;
+	}
+
+	bcache_endio(s->op.d->c, bio, error, "reading from cache");
+}
+
+static void __do_bio_hook(struct search *s)
+{
+	struct bio *bio = &s->bio.bio;
+	memcpy(bio, s->orig_bio, sizeof(struct bio));
+
+#ifdef CONFIG_DISKMON
+	bio->bi_flowid		= NULL;
+#endif
+	bio->bi_end_io		= request_endio;
+	bio->bi_private		= &s->cl;
+	bio->bi_destructor	= NULL;
+	atomic_set(&bio->bi_cnt, 3);
+}
+
+static struct search *do_bio_hook(struct bio *bio, struct bcache_device *d)
+{
+	struct bio_vec *bv;
+	struct search *s = mempool_alloc(d->c->search, GFP_NOIO);
+	memset(s, 0, offsetof(struct search, op.keys));
+
+	__closure_init(&s->cl, NULL);
+	__closure_init(&s->op.cl, &s->cl);
+
+	s->op.d			= d;
+	s->op.lock		= -1;
+	s->task			= get_current();
+	s->orig_bio		= bio;
+	s->write		= bio->bi_rw & REQ_WRITE;
+	s->op.flush_journal	= bio->bi_rw & REQ_FLUSH;
+	s->recoverable		= 1;
+	__do_bio_hook(s);
+
+	if (bio->bi_size != bio_segments(bio) * PAGE_SIZE) {
+		bv = mempool_alloc(d->unaligned_bvec, GFP_NOIO);
+		memcpy(bv, bio_iovec(bio),
+		       sizeof(struct bio_vec) * bio_segments(bio));
+
+		s->bio.bio.bi_io_vec	= bv;
+		s->unaligned_bvec	= 1;
+	}
+
+	return s;
+}
+
+static void btree_read_async(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+
+	int ret = btree_root(search_recurse, op->d->c, op);
+
+	if (ret == -EAGAIN)
+		continue_at(cl, btree_read_async, bcache_wq);
+
+	closure_return(cl);
+}
+
+/* Cached devices */
+
+static void cached_dev_bio_complete(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *dc = container_of(s->op.d, struct cached_dev, disk);
+
+	if (s->cache_bio)
+		bio_put(s->cache_bio);
+
+	if (s->unaligned_bvec)
+		mempool_free(s->bio.bio.bi_io_vec, dc->disk.unaligned_bvec);
+
+	__bio_complete(s);
+
+	closure_debug_destroy(&s->cl);
+	mempool_free(s, dc->disk.c->search);
+	cached_dev_put(dc);
+}
+
+/* Process reads */
+
+static void cached_dev_read_complete(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+
+	if (s->cache_miss)
+		bio_put(s->cache_miss);
+
+	if (s->cache_bio) {
+		int i;
+		struct bio_vec *bv;
+
+		__bio_for_each_segment(bv, s->cache_bio, i, 0)
+			__free_page(bv->bv_page);
+	}
+
+	cached_dev_bio_complete(cl);
+}
+
+static void request_read_error(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct bio_vec *bv;
+	int i;
+
+	if (s->recoverable) {
+		/* The cache read failed, but we can retry from the backing
+		 * device.
+		 */
+		pr_debug("recovering at sector %llu",
+			 (uint64_t) s->orig_bio->bi_sector);
+
+		s->error = 0;
+		bv = s->bio.bio.bi_io_vec;
+		__do_bio_hook(s);
+		s->bio.bio.bi_io_vec = bv;
+
+		if (!s->unaligned_bvec)
+			bio_for_each_segment(bv, s->orig_bio, i)
+				bv->bv_offset = 0, bv->bv_len = PAGE_SIZE;
+		else
+			memcpy(s->bio.bio.bi_io_vec,
+			       bio_iovec(s->orig_bio),
+			       sizeof(struct bio_vec) *
+			       bio_segments(s->orig_bio));
+
+		/* XXX: invalidate cache */
+
+		trace_bcache_read_retry(&s->bio.bio);
+		closure_bio_submit(&s->bio.bio, &s->cl, s->op.d->c->bio_split);
+	}
+
+	continue_at(cl, cached_dev_read_complete, NULL);
+}
+
+static void request_read_done(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *d = container_of(s->op.d, struct cached_dev, disk);
+
+	/*
+	 * s->cache_bio != NULL implies that we had a cache miss; cache_bio now
+	 * contains data ready to be inserted into the cache.
+	 *
+	 * First, we copy the data we just read from cache_bio's bounce buffers
+	 * to the buffers the original bio pointed to:
+	 */
+
+	if (s->cache_bio) {
+		struct bio_vec *src, *dst;
+		unsigned src_offset, dst_offset, bytes;
+		void *dst_ptr;
+
+		bio_reset(s->cache_bio);
+		atomic_set(&s->cache_bio->bi_cnt, 1);
+		s->cache_bio->bi_sector	= s->cache_miss->bi_sector;
+		s->cache_bio->bi_bdev	= s->cache_miss->bi_bdev;
+		s->cache_bio->bi_size	= s->cache_bio_sectors << 9;
+		bio_map(s->cache_bio, NULL);
+
+		src = bio_iovec(s->cache_bio);
+		dst = bio_iovec(s->cache_miss);
+		src_offset = src->bv_offset;
+		dst_offset = dst->bv_offset;
+		dst_ptr = kmap(dst->bv_page);
+
+		while (1) {
+			if (dst_offset == dst->bv_offset + dst->bv_len) {
+				kunmap(dst->bv_page);
+				dst++;
+				if (dst == bio_iovec_idx(s->cache_miss,
+							 s->cache_miss->bi_vcnt))
+					break;
+
+				dst_offset = dst->bv_offset;
+				dst_ptr = kmap(dst->bv_page);
+			}
+
+			if (src_offset == src->bv_offset + src->bv_len) {
+				src++;
+				if (src == bio_iovec_idx(s->cache_bio,
+							 s->cache_bio->bi_vcnt))
+					BUG();
+
+				src_offset = src->bv_offset;
+			}
+
+			bytes = min(dst->bv_offset + dst->bv_len - dst_offset,
+				    src->bv_offset + src->bv_len - src_offset);
+
+			memcpy(dst_ptr + dst_offset,
+			       page_address(src->bv_page) + src_offset,
+			       bytes);
+
+			src_offset	+= bytes;
+			dst_offset	+= bytes;
+		}
+	}
+
+	if (verify(d, &s->bio.bio) && s->recoverable)
+		data_verify(s);
+
+	__bio_complete(s);
+
+	if (s->cache_bio && !atomic_read(&s->op.d->c->closing)) {
+		s->op.type = BTREE_REPLACE;
+		closure_init(&s->op.cl, &s->cl);
+		bio_insert(&s->op.cl);
+	}
+
+	continue_at(cl, cached_dev_read_complete, NULL);
+}
+
+static void request_read_done_bh(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *d = container_of(s->op.d, struct cached_dev, disk);
+
+	if (s->cache_miss && s->op.insert_collision)
+		mark_cache_miss_collision(&s->op);
+
+	mark_cache_accounting(s, !s->cache_miss, s->skip);
+
+	if (s->error)
+		set_closure_fn(cl, request_read_error, bcache_wq);
+	else if (s->cache_bio || verify(d, &s->bio.bio))
+		set_closure_fn(cl, request_read_done, bcache_wq);
+	else
+		set_closure_fn(cl, cached_dev_read_complete, NULL);
+
+	closure_queue(cl);
+}
+
+static int cached_dev_cache_miss(struct btree *b, struct search *s,
+				 struct bio *bio, unsigned sectors)
+{
+	int ret = 0;
+	unsigned reada;
+	struct cached_dev *d = container_of(s->op.d, struct cached_dev, disk);
+	struct bio *n;
+
+	sectors = min(sectors, bio_max_sectors(bio)),
+
+	n = bio_split_get(bio, sectors, s->op.d);
+	if (!n)
+		return -EAGAIN;
+
+	if (n == bio)
+		s->op.lookup_done = true;
+
+	if (s->cache_miss || s->skip)
+		goto out_submit;
+
+	if (n != bio ||
+	    (bio->bi_rw & REQ_RAHEAD) ||
+	    (bio->bi_rw & REQ_META) ||
+	    s->op.d->c->gc_stats.in_use >= CUTOFF_CACHE_READA)
+		reada = 0;
+	else
+		reada = min(d->readahead >> 9, sectors - bio_sectors(n));
+
+	s->cache_bio_sectors = bio_sectors(n) + reada;
+	s->cache_bio = bbio_kmalloc(GFP_NOIO,
+			DIV_ROUND_UP(s->cache_bio_sectors, PAGE_SECTORS));
+
+	if (!s->cache_bio)
+		goto out_submit;
+
+	s->cache_bio->bi_sector	= n->bi_sector;
+	s->cache_bio->bi_bdev	= n->bi_bdev;
+	s->cache_bio->bi_size	= s->cache_bio_sectors << 9;
+
+	s->cache_bio->bi_end_io	= request_endio;
+	s->cache_bio->bi_private = &s->cl;
+
+	/* btree_search_recurse()'s btree iterator is no good anymore */
+	ret = -EINTR;
+	if (!btree_insert_check_key(b, &s->op, s->cache_bio))
+		goto out_put;
+
+	bio_map(s->cache_bio, NULL);
+	if (bio_alloc_pages(s->cache_bio, __GFP_NOWARN|GFP_NOIO))
+		goto out_put;
+
+	s->cache_miss = n;
+	bio_get(s->cache_bio);
+
+	trace_bcache_cache_miss(s->orig_bio);
+	generic_make_request(s->cache_bio);
+
+	return ret;
+out_put:
+	bio_put(s->cache_bio);
+	s->cache_bio = NULL;
+out_submit:
+	generic_make_request(n);
+	return ret;
+}
+
+static void request_read(struct cached_dev *d, struct search *s)
+{
+	check_should_skip(d, s);
+
+	set_closure_fn(&s->cl, request_read_done_bh, NULL);
+	closure_set_stopped(&s->cl);
+
+	btree_read_async(&s->op.cl);
+}
+
+/* Process writes */
+
+static void cached_dev_write_complete(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *dc = container_of(s->op.d, struct cached_dev, disk);
+
+	up_read_non_owner(&dc->writeback_lock);
+	cached_dev_bio_complete(cl);
+}
+
+static bool should_writeback(struct cached_dev *d, struct bio *bio)
+{
+	return !atomic_read(&d->disk.detaching) &&
+		cache_mode(d, bio) == CACHE_MODE_WRITEBACK &&
+		(d->disk.c->gc_stats.in_use < (bio->bi_rw & REQ_SYNC)
+		 ? CUTOFF_WRITEBACK_SYNC
+		 : CUTOFF_WRITEBACK);
+}
+
+static void request_write_resubmit(struct closure *cl)
+{
+	struct btree_op *op = container_of(cl, struct btree_op, cl);
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = &s->bio.bio;
+
+	closure_bio_submit(bio, &s->cl, op->d->c->bio_split);
+
+	bio_insert(&s->op.cl);
+	continue_at(&s->cl, cached_dev_write_complete, NULL);
+}
+
+static void request_write(struct cached_dev *d, struct search *s)
+{
+	struct closure *cl = &s->cl;
+	struct bio *bio = &s->bio.bio;
+
+	check_should_skip(d, s);
+	down_read_non_owner(&d->writeback_lock);
+
+	if (bcache_in_writeback(d, bio->bi_sector, bio_sectors(bio))) {
+		s->skip		= false;
+		s->writeback	= true;
+	}
+
+	if (s->skip) {
+skip:		s->cache_bio = s->orig_bio;
+		bio_get(s->cache_bio);
+		trace_bcache_write_skip(s->orig_bio);
+
+		if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
+			closure_get(cl);
+
+			if (blk_queue_discard(bdev_get_queue(d->bdev)))
+				generic_make_request(bio);
+			else
+				bio_endio(bio, 0);
+
+			goto out;
+		} else
+			goto submit;
+	}
+
+	if (should_writeback(d, s->orig_bio))
+		s->writeback = true;
+
+	if (!s->writeback) {
+		s->cache_bio = bbio_kmalloc(GFP_NOIO, bio->bi_max_vecs);
+		if (!s->cache_bio) {
+			s->skip = true;
+			goto skip;
+		}
+
+		__bio_clone(s->cache_bio, bio);
+		trace_bcache_writethrough(s->orig_bio);
+submit:
+		if (closure_bio_submit(bio, cl, s->op.d->c->bio_split))
+			continue_at(&s->op.cl,
+				    request_write_resubmit,
+				    bcache_wq);
+	} else {
+		s->cache_bio = bio;
+		trace_bcache_writeback(s->orig_bio);
+		bcache_writeback_add(d, bio_sectors(bio));
+	}
+out:
+	bio_insert(&s->op.cl);
+	continue_at(cl, cached_dev_write_complete, NULL);
+}
+
+static void request_nodata(struct cached_dev *d, struct search *s)
+{
+	struct closure *cl = &s->cl;
+	struct bio *bio = &s->bio.bio;
+
+	if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
+		request_write(d, s);
+		return;
+	}
+
+	if (s->op.flush_journal)
+		bcache_journal_meta(s->op.d->c, cl);
+
+	closure_get(cl);
+	generic_make_request(bio);
+
+	closure_set_stopped(&s->op.cl);
+	closure_put(&s->op.cl);
+
+	continue_at(cl, cached_dev_bio_complete, NULL);
+}
+
+/* Split bios in passthrough mode */
+
+static void bio_passthrough_done(struct closure *cl)
+{
+	struct bio_passthrough *s = container_of(cl, struct bio_passthrough,
+						 cl);
+
+	s->bio->bi_end_io	= s->bi_end_io;
+	s->bio->bi_private	= s->bi_private;
+	bio_endio(s->bio, 0);
+
+	closure_debug_destroy(&s->cl);
+	mempool_free(s, s->d->bio_passthrough);
+}
+
+static void bio_passthrough_endio(struct bio *bio, int error)
+{
+	struct closure *cl = bio->bi_private;
+	struct bio_passthrough *s = container_of(cl, struct bio_passthrough,
+						 cl);
+
+	if (error)
+		clear_bit(BIO_UPTODATE, &s->bio->bi_flags);
+
+	bio_put(bio);
+	closure_put(cl);
+}
+
+static void bio_passthrough_submit(struct closure *cl)
+{
+	struct bio_passthrough *s = container_of(cl, struct bio_passthrough,
+						 cl);
+	struct bio *bio = s->bio, *n;
+
+	do {
+		n = bio_split_get(bio, bio_max_sectors(bio), &s->d->disk);
+		if (!n)
+			continue_at(cl, bio_passthrough_submit, bcache_wq);
+
+		if (n == bio) {
+			set_closure_fn(cl, bio_passthrough_done, NULL);
+			closure_set_stopped(cl);
+		}
+
+		trace_bcache_passthrough(n);
+		generic_make_request(n);
+	} while (n != bio);
+}
+
+static void bio_passthrough(struct cached_dev *d, struct bio *bio)
+{
+	struct bio_passthrough *s;
+
+	if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
+		if (!blk_queue_discard(bdev_get_queue(d->bdev)))
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
+
+		return;
+	}
+
+	if (!bio_has_data(bio) ||
+	    bio->bi_size <= bio_max_sectors(bio) << 9) {
+		generic_make_request(bio);
+		return;
+	}
+
+	s = mempool_alloc(d->bio_passthrough, GFP_NOIO);
+
+	closure_init(&s->cl, NULL);
+	s->d		= d;
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+
+	bio_get(bio);
+	bio->bi_end_io	= bio_passthrough_endio;
+	bio->bi_private	= &s->cl;
+
+	bio_passthrough_submit(&s->cl);
+}
+
+/* Cached devices - read & write stuff */
+
+int bcache_get_congested(struct cache_set *c)
+{
+	int i;
+
+	if (!c->congested_read_threshold_us &&
+	    !c->congested_write_threshold_us)
+		return 0;
+
+	i = (local_clock_us() - c->congested_last_us) / 1024;
+	if (i < 0)
+		return 0;
+
+	i += atomic_read(&c->congested);
+	if (i >= 0)
+		return 0;
+
+	i += CONGESTED_MAX;
+
+	return i <= 0 ? 1 : fract_exp_two(i, 6);
+}
+
+static void check_should_skip(struct cached_dev *d, struct search *s)
+{
+	void add_sequential(struct task_struct *t)
+	{
+		ewma_add(t->sequential_io_avg,
+			 t->sequential_io, 8, 0);
+
+		t->sequential_io = 0;
+	}
+
+	struct hlist_head *iohash(uint64_t k)
+	{ return &d->io_hash[hash_64(k, RECENT_IO_BITS)]; }
+
+	struct cache_set *c = s->op.d->c;
+	struct bio *bio = &s->bio.bio;
+
+	int cutoff = bcache_get_congested(c);
+	unsigned mode = cache_mode(d, bio);
+
+	if (atomic_read(&d->disk.detaching) ||
+	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
+	    (bio->bi_rw & (1 << BIO_RW_DISCARD)))
+		goto skip;
+
+	if (mode == CACHE_MODE_NONE ||
+	    (mode == CACHE_MODE_WRITEAROUND &&
+	     (bio->bi_rw & REQ_WRITE)))
+		goto skip;
+
+	if (bio->bi_sector   & (c->sb.block_size - 1) ||
+	    bio_sectors(bio) & (c->sb.block_size - 1)) {
+		pr_debug("skipping unaligned io");
+		goto skip;
+	}
+
+	if (!cutoff) {
+		cutoff = d->sequential_cutoff >> 9;
+
+		if (!cutoff)
+			goto rescale;
+
+		if (mode == CACHE_MODE_WRITEBACK &&
+		    (bio->bi_rw & REQ_WRITE) &&
+		    (bio->bi_rw & REQ_SYNC))
+			goto rescale;
+	}
+
+	if (d->sequential_merge) {
+		struct hlist_node *cursor;
+		struct io *i;
+
+		spin_lock(&d->io_lock);
+
+		hlist_for_each_entry(i, cursor, iohash(bio->bi_sector), hash)
+			if (i->last == bio->bi_sector &&
+			    time_before(jiffies, i->jiffies))
+				goto found;
+
+		i = list_first_entry(&d->io_lru, struct io, lru);
+
+		add_sequential(s->task);
+		i->sequential = 0;
+found:
+		if (i->sequential + bio->bi_size > i->sequential)
+			i->sequential	+= bio->bi_size;
+
+		i->last			 = bio_end(bio);
+		i->jiffies		 = jiffies + msecs_to_jiffies(5000);
+		s->task->sequential_io	 = i->sequential;
+
+		hlist_del(&i->hash);
+		hlist_add_head(&i->hash, iohash(i->last));
+		list_move_tail(&i->lru, &d->io_lru);
+
+		spin_unlock(&d->io_lock);
+	} else {
+		s->task->sequential_io = bio->bi_size;
+
+		add_sequential(s->task);
+	}
+
+	cutoff -= popcount_32(get_random_int());
+
+	if (cutoff <= (int) (max(s->task->sequential_io,
+				 s->task->sequential_io_avg) >> 9))
+		goto skip;
+
+rescale:
+	rescale_priorities(c, bio_sectors(bio));
+	return;
+skip:
+	mark_sectors_bypassed(s, bio_sectors(bio));
+	s->skip = true;
+}
+
+static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct search *s;
+	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+
+	bio->bi_bdev = dc->bdev;
+	bio->bi_sector += 16;
+
+	if (cached_dev_get(dc)) {
+		s = do_bio_hook(bio, d);
+		trace_bcache_request_start(&s->op, bio);
+
+		(!bio_has_data(bio)	? request_nodata :
+		 bio->bi_rw & REQ_WRITE ? request_write :
+					  request_read)(dc, s);
+	} else
+		bio_passthrough(dc, bio);
+}
+
+static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
+			    unsigned int cmd, unsigned long arg)
+{
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
+}
+
+static int cached_dev_congested(void *data, int bits)
+{
+	struct bcache_device *d = data;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	struct request_queue *q = bdev_get_queue(dc->bdev);
+	int ret = 0;
+
+	if (bdi_congested(&q->backing_dev_info, bits))
+		return 1;
+
+	if (cached_dev_get(dc)) {
+		struct cache *ca;
+
+		for_each_cache(ca, d->c) {
+			q = bdev_get_queue(ca->bdev);
+			ret |= bdi_congested(&q->backing_dev_info, bits);
+		}
+
+		cached_dev_put(dc);
+	}
+
+	return ret;
+}
+
+void cached_dev_request_init(struct cached_dev *d)
+{
+	struct gendisk *g = d->disk.disk;
+
+	g->queue->make_request_fn		= cached_dev_make_request;
+	g->queue->backing_dev_info.congested_fn = cached_dev_congested;
+	d->disk.cache_miss			= cached_dev_cache_miss;
+	d->disk.ioctl				= cached_dev_ioctl;
+}
+
+/* Flash backed devices */
+
+static void flash_dev_bio_complete(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct bcache_device *d = s->op.d;
+
+	__bio_complete(s);
+
+	if (s->cache_bio) {
+		int i;
+		struct bio_vec *bv;
+
+		if (!s->write)
+			__bio_for_each_segment(bv, s->cache_bio, i, 0)
+				__free_page(bv->bv_page);
+		bio_put(s->cache_bio);
+	}
+
+	if (s->unaligned_bvec)
+		mempool_free(s->bio.bio.bi_io_vec, d->unaligned_bvec);
+
+	closure_debug_destroy(&s->cl);
+	mempool_free(s, d->c->search);
+}
+
+static int flash_dev_cache_miss(struct btree *b, struct search *s,
+				struct bio *bio, unsigned sectors)
+{
+	sectors = min(sectors, bio_sectors(bio));
+
+	/* Zero fill bio */
+
+	while (sectors) {
+		struct bio_vec *bv = bio_iovec(bio);
+		unsigned j = min(bv->bv_len >> 9, sectors);
+
+		void *p = kmap(bv->bv_page);
+		memset(p + bv->bv_offset, 0, j << 9);
+		kunmap(bv->bv_page);
+
+		bv->bv_len	-= j << 9;
+		bv->bv_offset	+= j << 9;
+
+		bio->bi_sector	+= j;
+		bio->bi_size	-= j << 9;
+
+		bio->bi_idx++;
+		sectors		-= j;
+	}
+
+	if (sectors >= bio_sectors(bio)) {
+		s->op.lookup_done = true;
+		bio_endio(bio, 0);
+	}
+	return 0;
+}
+
+static void flash_dev_read(struct search *s)
+{
+	set_closure_fn(&s->cl, flash_dev_bio_complete, NULL);
+	closure_set_stopped(&s->cl);
+
+	btree_read_async(&s->op.cl);
+}
+
+static void flash_dev_write(struct search *s)
+{
+	struct closure *cl = &s->cl;
+	struct bio *bio = &s->bio.bio;
+
+	if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
+		s->cache_bio	= s->orig_bio;
+		s->skip		= true;
+
+		closure_get(cl);
+		bio_get(s->cache_bio);
+		bio_endio(bio, 0);
+	} else {
+		s->writeback	= true;
+		s->cache_bio	= bio;
+	}
+
+	bio_insert(&s->op.cl);
+	continue_at(&s->cl, flash_dev_bio_complete, NULL);
+}
+
+static void flash_dev_req_nodata(struct search *s)
+{
+	struct closure *cl = &s->cl;
+	struct bio *bio = &s->bio.bio;
+
+	if (bio->bi_rw & (1 << BIO_RW_DISCARD)) {
+		flash_dev_write(s);
+		return;
+	}
+
+	if (s->op.flush_journal)
+		bcache_journal_meta(s->op.d->c, cl);
+
+	closure_get(cl);
+	generic_make_request(bio);
+
+	closure_set_stopped(&s->op.cl);
+	closure_put(&s->op.cl);
+
+	continue_at(&s->cl, flash_dev_bio_complete, NULL);
+}
+
+static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct search *s;
+	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
+
+	s = do_bio_hook(bio, d);
+	trace_bcache_request_start(&s->op, bio);
+
+	(!bio_has_data(bio)	? flash_dev_req_nodata :
+	 bio->bi_rw & REQ_WRITE ? flash_dev_write :
+				  flash_dev_read)(s);
+}
+
+static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
+			   unsigned int cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
+
+static int flash_dev_congested(void *data, int bits)
+{
+	struct bcache_device *d = data;
+	struct request_queue *q;
+	struct cache *ca;
+	int ret = 0;
+
+	for_each_cache(ca, d->c) {
+		q = bdev_get_queue(ca->bdev);
+		ret |= bdi_congested(&q->backing_dev_info, bits);
+	}
+
+	return ret;
+}
+
+void flash_dev_request_init(struct bcache_device *d)
+{
+	struct gendisk *g = d->disk;
+
+	g->queue->make_request_fn		= flash_dev_make_request;
+	g->queue->backing_dev_info.congested_fn = flash_dev_congested;
+	d->cache_miss				= flash_dev_cache_miss;
+	d->ioctl				= flash_dev_ioctl;
+}
+
+void bcache_request_exit(void)
+{
+#ifdef CONFIG_CGROUP_BCACHE
+	cgroup_unload_subsys(&bcache_subsys);
+#endif
+	if (passthrough_cache)
+		kmem_cache_destroy(passthrough_cache);
+	if (search_cache)
+		kmem_cache_destroy(search_cache);
+}
+
+int __init bcache_request_init(void)
+{
+	if (!(search_cache = KMEM_CACHE(search, 0)) ||
+	    !(passthrough_cache = KMEM_CACHE(bio_passthrough, 0)))
+		goto err;
+
+#ifdef CONFIG_CGROUP_BCACHE
+	cgroup_load_subsys(&bcache_subsys);
+	init_bcache_cgroup(&bcache_default_cgroup);
+#endif
+	return 0;
+err:
+	bcache_request_exit();
+	return -ENOMEM;
+}
diff --git a/drivers/block/bcache/request.h b/drivers/block/bcache/request.h
new file mode 100644
index 0000000..7e1b11a
--- /dev/null
+++ b/drivers/block/bcache/request.h
@@ -0,0 +1,58 @@
+#ifndef _BCACHE_REQUEST_H_
+#define _BCACHE_REQUEST_H_
+#include <linux/cgroup.h>
+
+struct search {
+	/* Stack frame for bio_complete */
+	struct closure		cl;
+
+	struct task_struct	*task;
+
+	struct bbio		bio;
+	struct bio		*orig_bio;
+	struct bio		*cache_bio;
+	struct bio		*cache_miss;
+	unsigned		cache_bio_sectors;
+
+	unsigned		recoverable:1;
+	unsigned		unaligned_bvec:1;
+	unsigned		skip:1;
+	unsigned		write:1;
+	unsigned		writeback:1;
+
+	unsigned		bio_insert_done:1;
+
+	/* IO error returned to s->bio */
+	short			error;
+
+	/* Anything past op->keys won't get zeroed in do_bio_hook */
+	struct btree_op		op;
+};
+
+void cache_read_endio(struct bio *, int);
+int bcache_get_congested(struct cache_set *);
+void bcache_btree_insert_async(struct closure *);
+
+void bcache_open_buckets_free(struct cache_set *);
+int bcache_open_buckets_alloc(struct cache_set *);
+
+void cached_dev_request_init(struct cached_dev *d);
+void flash_dev_request_init(struct bcache_device *d);
+
+extern struct kmem_cache *search_cache, *passthrough_cache;
+
+struct bcache_cgroup {
+#ifdef CONFIG_CGROUP_BCACHE
+	struct cgroup_subsys_state	css;
+#endif
+	/*
+	 * We subtract one from the index into bcache_cache_modes[], so that
+	 * default == -1; this makes it so the rest match up with d->cache_mode,
+	 * and we use d->cache_mode if cgrp->cache_mode < 0
+	 */
+	short				cache_mode;
+	bool				verify;
+	struct cache_stat_collector	stats;
+};
+
+#endif /* _BCACHE_REQUEST_H_ */
-- 
1.7.9.rc2

