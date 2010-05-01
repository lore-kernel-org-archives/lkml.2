Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0EAAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:14:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58449 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab0EAANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dL+6G7UvFJC1sW3bwZs04K8JKj4J6YDH5u7DTtKqzQ/RbupkQ9BOm4rAj7ce+JngNh
         rqRcHnW1Jp20saNzh0tvYCXTUgDAg8iVbhjaQAXVl+tpijDuse7j9aZynEDJHCBuurFF
         m0TIXvJCZpHSe/64kR4E6OOQ9JfuN2oF5w404=
Date: Fri, 30 Apr 2010 16:13:44 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Bcache: version 4
Message-ID: <20100501001344.GD31135@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 block/Makefile |    2 +
 block/bcache.c | 2624 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 2626 insertions(+), 0 deletions(-)

diff --git a/block/Makefile b/block/Makefile
index cb2d515..e9b5fc0 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+
+obj-$(CONFIG_BLK_CACHE)		+= bcache.o
diff --git a/block/bcache.c b/block/bcache.c
new file mode 100644
index 0000000..0f26277
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,2624 @@
+/*
+ * Copyright (C) 2010 Kent Overstreet <kent.overstreet@gmail.com>
+ *
+ * Uses a block device as cache for other block devices; optimized for SSDs.
+ * All allocation is done in buckets, which should match the erase block size
+ * of the device.
+ *
+ * Buckets containing cached data are kept on a heap sorted by priority;
+ * bucket priority is increased on cache hit, and periodically all the buckets
+ * on the heap have their priority scaled down. This currently is just used as
+ * an LRU but in the future should allow for more intelligent heuristics.
+ *
+ * Buckets have an 8 bit counter; freeing is accomplished by incrementing the
+ * counter. Garbage collection is used to remove stale pointers.
+ *
+ * Indexing is done via a btree; nodes are not necessarily fully sorted, rather
+ * as keys are inserted we only sort the pages that have not yet been written.
+ * When garbage collection is run, we resort the entire node.
+ *
+ * All configuration is done via sysfs; see Documentation/bcache.txt.
+ */
+
+#define pr_fmt(fmt) "bcache: %s() " fmt, __func__
+
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+/*
+ * Todo:
+ * Collect buckets that are marked as btree buckets but aren't in use anymore
+ * during garbage collection
+ * Need to flag cache devices that are dirty and invalidate the contents if it
+ * wasn't clean on register, as the priorities/gens will be out of sync.
+ * IO error handling
+ * Need to wait somehow till issued bio is on the request queue before we drop
+ * the reference on the bucket, or there's still a race between that and free's
+ * blkdev_issue_discard
+ * Need refcounting of data buckets to prevent a race between use and reuse
+ * Make btree_clean check for pointers to btree buckets that aren't in use
+ * Complete bios that were split correctly - done, untested
+ * Make btree_clean handle duplicate keys
+ * Multiple open data buckets so as to not fragment multiple streams of
+ * contiguous IO; also use pid or hash of pid to make random IO from a process
+ * go into the same bucket.
+ *
+ * Future:
+ * Journalling
+ * Write behind
+ * Checksumming
+ * SSDs that don't support trim would probably benefit from batching up writes
+ * to a full erase block.
+ *
+ * Stuff that should be made generic and taken out:
+ * fifos
+ * heap code
+ * bio_split_front()
+ * maybe eventually the search context stuff
+ */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
+
+#define UUIDS_PER_SB		256
+#define SB_SECTOR		8
+#define UUID_SECTOR		16
+#define PRIO_SECTOR		24
+
+/*
+ * Page 0: unused
+ * Page 1: superblock
+ * Page 2: device UUIDs
+ * Page 3+: bucket priorities
+ */
+
+#define DECLARE_FIFO(type, name)				\
+	struct {						\
+		size_t front, back, size;			\
+		type *data;					\
+	} name;
+
+#define init_fifo(f, s, gfp) ({					\
+	(f)->data = NULL;					\
+	(f)->front = (f)->back = 0;				\
+	(f)->size = roundup_pow_of_two(s) - 1;			\
+	if ((f)->size * sizeof(*(f)->data) >= KMALLOC_MAX_SIZE)	\
+		(f)->data = vmalloc((f)->size * sizeof(*(f)->data));\
+	else if ((f)->size > 0)					\
+		(f)->data = kmalloc((f)->size * sizeof(*(f)->data), gfp);\
+	(f)->data; })
+
+#define free_fifo(f) do {					\
+	if ((f)->size * sizeof(*(f)->data) >= KMALLOC_MAX_SIZE)	\
+		vfree((f)->data);				\
+	else if ((f)->size > 0)					\
+		kfree((f)->data);				\
+} while (0)
+
+#define fifo_push(f, i) ({					\
+	bool _r = false;					\
+	if ((((f)->front + 1) & (f)->size) != (f)->back) {	\
+		_r = true;					\
+		(f)->data[(f)->front++] = i;			\
+		(f)->front &= (f)->size;			\
+	} _r; })
+
+#define fifo_pop(f, i) ({					\
+	bool _r = false;					\
+	if ((f)->front != (f)->back) {				\
+		_r = true;					\
+		i = (f)->data[(f)->back++];			\
+		(f)->back &= (f)->size;				\
+	} _r; })
+
+#define fifo_full(f)	((((f)->front + 1) & (f)->size) == (f)->back)
+
+#define DECLARE_HEAP(type, name)				\
+	struct {						\
+		size_t size;					\
+		type *data;					\
+	} name;
+
+#define init_heap(h, s, gfp) ({					\
+	(h)->data = NULL;					\
+	(h)->size = 0;						\
+	if (s * sizeof(*(h)->data) >= KMALLOC_MAX_SIZE)		\
+		(h)->data = vmalloc(s * sizeof(*(h)->data));	\
+	else if (s > 0)						\
+		(h)->data = kmalloc(s * sizeof(*(h)->data), gfp);\
+	(h)->data; })
+
+struct search_context;
+struct cached_bucket;
+
+typedef void (search_fn) (void *, struct bio *, struct search_context *);
+
+#define CACHE_CLEAN	1
+
+struct cache_sb {
+	uint8_t  magic[16];
+	uint32_t version;
+	uint16_t block_size;		/* sectors */
+	uint16_t bucket_size;		/* sectors */
+	uint32_t journal_start;		/* buckets */
+	uint32_t first_bucket;		/* start of data */
+	uint64_t nbuckets;		/* device size */
+	uint64_t btree_root;
+	uint16_t btree_level;
+};
+
+struct bucket {
+	size_t		heap;
+	atomic_t	pin;
+	uint16_t	priority;
+	uint8_t		generation;
+	uint8_t		last_gc;
+};
+
+struct bucket_disk {
+	uint16_t	priority;
+	uint8_t		generation;
+} __attribute((packed));
+
+struct btree_node_header {
+	uint32_t	csum;
+	uint32_t	nkeys;
+	uint64_t	random;
+};
+
+struct btree_key {
+	uint64_t	key;
+	uint64_t	ptr;
+};
+
+struct cache_device {
+	struct list_head	list;
+	struct cache_sb		sb;
+	struct page		*sb_page;
+	spinlock_t		sb_lock;
+
+	struct kobject		kobj;
+	struct block_device	*bdev;
+	struct module		*owner;
+	struct work_struct	work;
+
+	/*
+	 * Buckets used for cached data go on the heap. The heap is ordered by
+	 * bucket->priority; a priority of ~0 indicates a btree bucket. Priority
+	 * is increased on cache hit, and periodically all the buckets on the
+	 * heap have their priority scaled down by a linear function.
+	 */
+	spinlock_t		bucket_lock;
+	struct bucket		**heap;
+	struct bucket		*buckets;
+	struct bucket_disk	*disk_buckets;
+	unsigned long		heap_size;
+	long			rescale;
+
+	uint8_t			need_gc;
+	uint8_t			*gc_in_progress;
+	struct rw_semaphore	gc_lock;
+
+	int			btree_buckets_cached;
+	struct list_head	lru;
+
+	DECLARE_FIFO(long, free);
+
+	/*struct gendisk	*devices[UUIDS_PER_SB];*/
+	short			devices[UUIDS_PER_SB];
+	struct buffer_head	*uuids;
+
+	long			current_bucket;
+	struct btree_key	current_key;
+	int			sectors_free;
+	unsigned long		last_used;
+
+	unsigned long		cache_hits;
+
+	struct cached_bucket	*root;
+};
+
+struct open_bucket {
+	struct list_head	list;
+	struct cache_device	*cache;
+
+	char			identifier;
+	long			bucket;
+	struct btree_key	key;
+	int			sectors_free;
+};
+
+struct cached_dev {
+	struct kobject		kobj;
+	struct block_device	*bdev;
+	struct module		*owner;
+	struct work_struct	work;
+};
+
+struct journal_header {
+	uint32_t csum;
+	uint32_t seq;
+	uint32_t last_open_entry;
+	uint32_t nr_entries;
+};
+
+struct cached_bucket {
+	struct rw_semaphore	lock;
+	struct list_head	lru;
+	struct search_context	*wait;
+	struct cache_device	*c;	/* for bio_add_work_unlock */
+
+	atomic_t		nread;
+	sector_t		offset;
+	int			level;
+
+	struct page		*pages[];
+};
+
+struct search_context {
+	struct work_struct	w;
+	atomic_t		remaining;
+	struct search_context	*parent;
+	struct search_context	*next;
+	search_fn		*end_fn;
+
+	struct btree_key	new_keys[2];
+	void			*q;
+	struct bio		*bio;
+	int			error;
+
+	sector_t		bi_sector;
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+};
+
+static const char bcache_magic[] = {
+	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
+	0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };
+
+static struct kobject		*bcache_kobj;
+/*
+ * We need a real search key
+ * static struct gendisk	*devices[UUIDS_PER_SB];
+ */
+static char			uuids[UUIDS_PER_SB*16];
+
+static LIST_HEAD(cache_devices);
+static LIST_HEAD(open_buckets);
+
+static struct workqueue_struct *delayed;
+
+/*
+ * Sysfs vars / tunables
+ */
+static unsigned long cache_hits, cache_misses, rescale = 20480; /* sectors */
+static uint16_t	initial_priority = SHORT_MAX
+static uint16_t cache_hit_priority = 100, cache_hit_seek = 100;
+
+static void do_btree_gc(struct work_struct *w);
+static void unregister_cache(struct kobject *k);
+static void write_super(struct cache_device *c);
+static void run_search(struct work_struct *w);
+static void save_priorities(struct cache_device *c);
+static void __btree_write_node(struct cache_device *c, struct cached_bucket *b,
+			     int skip, int n);
+
+#define pages_per_btree		(c->sb.bucket_size >> (PAGE_SHIFT - 9))
+#define keys_per_page		(PAGE_SIZE / sizeof(struct btree_key))
+#define bucket_to_sector(b)	(((sector_t) (b) + c->sb.first_bucket) * c->sb.bucket_size)
+#define sector_to_bucket(s)	((long) ((s) / c->sb.bucket_size) - c->sb.first_bucket)
+#define sector_to_gen(s)	({ smp_rmb(); c->buckets[sector_to_bucket(s)].generation; })
+#define sector_to_priority(s)	({ smp_rmb(); c->buckets[sector_to_bucket(s)].priority; })
+#define ptr_to_bucket(p)	sector_to_bucket(PTR_OFFSET(p))
+#define bucket_to_ptr(b)	TREE_PTR(sector_to_gen(b->offset), 0, b->offset)
+#define data(b)			((struct btree_key **) &(b)->pages[pages_per_btree])
+#define keys(i)			(((struct btree_node_header *) *(i))->nkeys)
+#define rand(i)			(((struct btree_node_header *) *(i))->random)
+#define header(b)		((struct btree_node_header *) data(b)[0])
+#define index(i, b)		(i - data(b))
+#define last_key(i)		(node(i, keys(i))->key)
+#define bucket_key(b)		((struct btree_key) {			\
+				 .key = node(data(b), header(b)->nkeys)->key,\
+				 .ptr = bucket_to_ptr(b) })
+
+#define label(l, foo)	if (0) { l: foo; }
+
+/*
+ * key: 8 bit device, 56 bit offset
+ * value: 8 bit generation, 16 bit length, 40 bit offset
+ * All units are in sectors
+ */
+
+static inline struct btree_key *node(struct btree_key *d[], int i)
+{
+	return d[i / keys_per_page] + (i % keys_per_page);
+}
+
+#define TREE_KEY(device, offset)	((offset) | ((uint64_t) device) << 56)
+#define KEY_DEV(p)			(p >> 56)
+#define KEY_OFFSET(p)			(p & ~((uint64_t) ~0 << 56))
+#define TREE_KEY_DEV(page, i)		KEY_DEV(node(page, i)->key)
+#define TREE_KEY_OFFSET(page, i)	KEY_OFFSET(node(page, i)->key)
+
+#define TREE_PTR(gen, length, offset)	((gen) | (length) << 8 | (uint64_t) (offset) << 24)
+#define PTR_GEN(p)			((uint8_t) ((p) & ~(~0 << 8)))
+#define PTR_LENGTH(p)			(((p) >> 8) & ~(~0 << 16))
+#define PTR_OFFSET(p)			((p) >> 24)
+#define TREE_PTR_GEN(page, i)		PTR_GEN(node(page, i)->ptr)
+#define TREE_PTR_LENGTH(page, i)	PTR_LENGTH(node(page, i)->ptr)
+#define TREE_PTR_OFFSET(page, i)	PTR_OFFSET(node(page, i)->ptr)
+
+static inline void rw_lock(bool write, struct rw_semaphore *lock, int class)
+{	write ? down_write_nested(lock, class) : down_read_nested(lock, class); }
+
+static inline void rw_unlock(bool write, struct rw_semaphore *lock)
+{	write ? up_write(lock) : up_read(lock); }
+
+static int is_zero(void *p, size_t n)
+{
+	int i;
+	for (i = 0; i < n; i++)
+		if (((char *) p)[i])
+			return 0;
+	return 1;
+}
+
+static int lookup_dev(struct cache_device *c, struct bio *bio)
+{
+	int dev;
+	for (dev = 0; dev < UUIDS_PER_SB; dev++)
+		if (c->devices[dev] == bio->bi_bdev->bd_cache_identifier)
+			break;
+
+	if (dev == UUIDS_PER_SB)
+		printk(KERN_DEBUG "bcache: unknown device %i",
+		       bio->bi_bdev->bd_cache_identifier);
+
+	return dev;
+}
+
+static void run_search(struct work_struct *w)
+{
+	struct search_context *s = container_of(w, struct search_context, w);
+	s->end_fn(s->q, s->bio, s);
+}
+
+static void put_search(struct search_context *s)
+{
+	if (atomic_dec_and_test(&s->remaining)) {
+		smp_rmb();
+		atomic_set(&s->remaining, 1);
+		if (!s->end_fn)
+			kzfree(s);
+		else
+			BUG_ON(!queue_work(delayed, &s->w));
+	}
+}
+
+#define return_f(s, f)						\
+	do {							\
+		if (!object_is_on_stack(s)) {			\
+			s->end_fn = f;				\
+			smp_wmb();				\
+			put_search(s);				\
+		}						\
+		return;						\
+	} while (0)
+
+#define add_wait_list(s, l) do {				\
+	s = alloc_search(s);					\
+	atomic_inc(&(s)->remaining);				\
+	do							\
+		(s)->next = l;					\
+	while (cmpxchg(&(l), (s)->next, s) != (s)->next);	\
+} while (0)
+
+#define run_wait_list(s) do {					\
+	struct search_context *t = s;				\
+	if (!t)							\
+		break;						\
+	s = t->next;						\
+	put_search(t);						\
+} while (1)
+
+static struct search_context *alloc_search(struct search_context *s)
+{
+	struct search_context *r = s;
+	if (object_is_on_stack(s)) {
+		r = kzalloc(sizeof(*s), GFP_NOIO);
+		*r = *s;
+		atomic_set(&r->remaining, 1);
+		INIT_WORK(&r->w, run_search);
+	}
+	return r;
+}
+
+static void __inc_bucket_gen(struct cache_device *c, long b)
+{
+
+	c->need_gc = max_t(uint8_t, c->need_gc,
+			   ++c->buckets[b].generation - c->buckets[b].last_gc);
+
+	if (c->need_gc > 64 &&
+	    !c->gc_in_progress) {
+		long i;
+		uint8_t *gc_in_progress;
+
+		spin_unlock(&c->bucket_lock);
+		gc_in_progress = kmalloc(c->sb.nbuckets, GFP_NOIO);
+		spin_lock(&c->bucket_lock);
+
+		if (!gc_in_progress)
+			return;
+
+		if (c->gc_in_progress) {
+			kfree(gc_in_progress);
+			return;
+		}
+
+		c->gc_in_progress = gc_in_progress;
+
+		for (i = 0; i < c->sb.nbuckets; i++)
+			c->gc_in_progress[i] = c->buckets[i].generation;
+
+		INIT_WORK(&c->work, do_btree_gc);
+		queue_work(delayed, &c->work);
+	}
+}
+
+static inline void inc_bucket_gen(struct cache_device *c, long b)
+{
+	spin_lock(&c->bucket_lock);
+	__inc_bucket_gen(c, b);
+	spin_unlock(&c->bucket_lock);
+}
+
+#define inc_gen(c, o)	inc_bucket_gen(c, sector_to_bucket(o))
+
+static void __rescale_heap(struct cache_device *c, int sectors)
+{
+	long i;
+	c->rescale -= sectors;
+	if (c->rescale <= 0) {
+		for (i = 0; i < c->heap_size; i++) {
+			BUG_ON(c->heap[i]->priority == (uint16_t) ~0);
+			c->heap[i]->priority =
+				((long) c->heap[i]->priority * 7) / 8;
+		}
+		c->rescale += rescale;
+
+		save_priorities(c);
+	}
+}
+
+static void rescale_heap(struct cache_device *c, int sectors)
+{
+	spin_lock(&c->bucket_lock);
+	__rescale_heap(c, sectors);
+	spin_unlock(&c->bucket_lock);
+}
+
+#define heap_cmp(i, j)	(c->heap[i]->priority >= c->heap[j]->priority)
+
+static int heap_swap(struct cache_device *c, long i, long j)
+{
+	if (heap_cmp(i, j))
+		return 1;
+
+	swap(c->heap[i], c->heap[j]);
+
+	c->heap[i]->heap = i;
+	c->heap[j]->heap = j;
+	return 0;
+}
+
+static void __heap_sift(struct cache_device *c, long h)
+{
+	long r;
+
+	for (; h * 2 + 1 < c->heap_size; h = r) {
+		r = h * 2 + 1;
+		if (r + 1 < c->heap_size &&
+		    heap_cmp(r, r + 1))
+			r++;
+
+		if (heap_swap(c, r, h))
+			break;
+	}
+}
+
+static void __heap_insert(struct cache_device *c, long b)
+{
+	if (c->buckets[b].heap == -1) {
+		long p, h = c->heap_size++;
+
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+		c->buckets[b].priority = initial_priority;
+		c->buckets[b].heap = h;
+		c->heap[h] = &c->buckets[b];
+
+		for (p = (h - 1) / 2; p; h = p, p = (h - 1) / 2)
+			if (heap_swap(c, h, p))
+				break;
+
+		__heap_sift(c, h);
+
+		pr_debug("inserted bucket %li, new heap size %li, heap location %li",
+			 b, c->heap_size, c->buckets[b].heap);
+	} else
+		__heap_sift(c, c->buckets[b].heap);
+}
+
+static void heap_insert(struct cache_device *c, long b)
+{
+	spin_lock(&c->bucket_lock);
+	__heap_insert(c, b);
+	spin_unlock(&c->bucket_lock);
+}
+
+static long __heap_pop(struct cache_device *c)
+{
+	long ret = c->heap[0] - c->buckets;
+
+	if (!c->heap_size) {
+		WARN(!c->heap_size, "bcache: empty heap!");
+		return -1;
+	}
+
+	__inc_bucket_gen(c, ret);
+	smp_mb();
+	if (atomic_read(&c->heap[0]->pin))
+		return -1;
+
+	heap_swap(c, 0, --c->heap_size);
+
+	__heap_sift(c, 0);
+	c->heap[c->heap_size] = NULL;
+
+	pr_debug("priority %i sector %lu", c->buckets[ret].priority,
+		 bucket_to_sector(ret));
+
+	c->buckets[ret].priority = 0;
+	c->buckets[ret].heap = -1;
+	return ret;
+}
+
+static long __pop_bucket(struct cache_device *c)
+{
+	long r;
+	while (!fifo_full(&c->free)) {
+		r = __heap_pop(c);
+
+		if (r == -1)
+			break;
+
+		fifo_push(&c->free, r);
+
+		if (blk_queue_discard(bdev_get_queue(c->bdev))) {
+			spin_unlock(&c->bucket_lock);
+			blkdev_issue_discard(c->bdev, bucket_to_sector(r),
+					     c->sb.bucket_size, GFP_NOIO, 0);
+			spin_lock(&c->bucket_lock);
+		}
+	}
+
+	if (!fifo_pop(&c->free, r))
+		r = -1;
+
+	return r;
+}
+
+static bool pop_bucket(struct cache_device *c)
+{
+	long b = __pop_bucket(c);
+
+	if (c->current_bucket)
+		__heap_insert(c, sector_to_bucket(c->current_bucket));
+
+	if (b == -1) {
+		c->sectors_free = 0;
+		c->current_bucket = 0;
+		return false;
+	}
+
+	c->current_bucket = bucket_to_sector(b);
+	c->sectors_free = c->sb.bucket_size;
+	return true;
+}
+
+static void free_bucket_contents(struct cache_device *c,
+				 struct cached_bucket *b)
+{
+	int i;
+	/* XXX: check for dirty pages */
+	for (i = 0; i < pages_per_btree; i++)
+		if (b->pages[i]) {
+			kunmap(b->pages[i]);
+			put_page(b->pages[i]);
+			b->pages[i] = NULL;
+		}
+
+	/*struct address_space *mapping = p[0]->mapping;
+
+	spin_lock_irq(&mapping->tree_lock);
+	for (i = 0; i < pages; i++)
+		__remove_from_page_cache(p[i]);
+	spin_unlock_irq(&mapping->tree_lock);*/
+}
+
+static void fill_bucket_endio(struct bio *bio, int error)
+{
+	int i, n;
+	struct cached_bucket *b = bio->bi_private;
+	struct cache_device *c = b->c;
+
+	for (i = 0; i < bio->bi_vcnt; i++)
+		unlock_page(bio->bi_io_vec[i].bv_page);
+
+	do {
+		n = atomic_read(&b->nread);
+		for (i = n; i < pages_per_btree; i++)
+			if (PageLocked(b->pages[i]))
+				break;
+	} while (atomic_cmpxchg(&b->nread, n, i) != i);
+
+	if (i == pages_per_btree)
+		run_wait_list(b->wait);
+
+	bio_put(bio);
+}
+
+static int fill_bucket(struct cache_device *c, struct cached_bucket *b,
+		       struct search_context **s)
+{
+	int i, nread, ret = 0;
+	struct bio *bio = NULL;
+
+	nread = find_get_pages(c->bdev->bd_inode->i_mapping,
+			       (b->offset >> (PAGE_SHIFT - 9)),
+			       pages_per_btree, b->pages);
+
+	for (i = 0; i < pages_per_btree; i++)
+		if (!b->pages[i]) {
+			b->pages[i] = __page_cache_alloc(GFP_NOIO);
+			b->pages[i]->mapping = c->bdev->bd_inode->i_mapping;
+			if (add_to_page_cache_lru(b->pages[i],
+						  c->bdev->bd_inode->i_mapping,
+						  (b->offset >> (PAGE_SHIFT - 9)) + i,
+						  GFP_NOIO & GFP_RECLAIM_MASK)) {
+				/* XXX: need to check for actual errors */
+				page_cache_release(b->pages[i]);
+				b->pages[i] = find_get_page(c->bdev->bd_inode->i_mapping,
+						     (b->offset >> (PAGE_SHIFT - 9)) + i);
+				BUG_ON(!b->pages[i]);
+				goto wait;
+			}
+
+			if (!bio) {
+				bio = bio_kmalloc(GFP_NOIO, pages_per_btree - nread);
+				bio->bi_bdev = c->bdev;
+				bio->bi_sector = b->offset + (i << (PAGE_SHIFT - 9));
+
+				bio->bi_private = b;
+				bio->bi_end_io = fill_bucket_endio;
+				atomic_inc(&c->buckets[sector_to_bucket(b->offset)].pin); /* wrong */
+
+				pr_debug("reading at sector %li, page_index %li",
+					 bio->bi_sector, page_index(b->pages[i]));
+			}
+			nread++;
+
+			bio->bi_io_vec[bio->bi_vcnt].bv_page = b->pages[i];
+			bio->bi_io_vec[bio->bi_vcnt].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[bio->bi_vcnt].bv_offset = 0;
+			bio->bi_vcnt++;
+			bio->bi_size += PAGE_SIZE;
+			data(b)[i] = kmap(b->pages[i]);
+		} else {
+wait:			wait_on_page_locked(b->pages[i]);
+
+			if (bio)
+				submit_bio(READ, bio);
+			bio = NULL;
+			if (i == ret)
+				ret++;
+			data(b)[i] = kmap(b->pages[i]);
+		}
+
+	if (bio)
+		submit_bio(READ, bio);
+
+	return ret;
+}
+
+static struct cached_bucket *get_bucket(struct cache_device *c, sector_t offset,
+					int level, bool write,
+					struct search_context **s)
+{
+	bool f = false;
+	int i;
+	struct cached_bucket *b, *n = NULL;
+retry:
+	if (sector_to_priority(offset) != (uint16_t) ~0)
+		return NULL;
+
+	i = 0;
+	spin_lock(&c->bucket_lock);
+	list_for_each_entry(b, &c->lru, lru) {
+		if (offset == b->offset) {
+			list_move(&b->lru, &c->lru);
+			spin_unlock(&c->bucket_lock);
+
+			rw_lock(write, &b->lock, level);
+
+			if (offset == b->offset)
+				goto out;
+
+			rw_unlock(write, &b->lock);
+			goto retry;
+		}
+		i++;
+	}
+
+	b = list_entry(c->lru.prev, struct cached_bucket, lru);
+	if (i >= c->btree_buckets_cached && down_write_trylock(&b->lock)) {
+		list_del(&b->lru);
+
+		if (!write)
+			downgrade_write(&b->lock);
+		f = true;
+	} else if (n) {
+		b = n;
+		n = NULL;
+		b->c = c;
+		init_rwsem(&b->lock);
+		BUG_ON(write /* lockdep */
+		       ? !down_write_trylock(&b->lock)
+		       : !down_read_trylock(&b->lock));
+	} else {
+		spin_unlock(&c->bucket_lock);
+		n = kzalloc(sizeof(*n) + sizeof(void *) * pages_per_btree * 2,
+			    GFP_NOIO);
+		if (!n)
+			return NULL;
+
+		goto retry;
+	}
+
+	i = atomic_read(&b->nread);
+	atomic_set(&b->nread, 0);
+	b->offset = offset;
+	b->level = level;
+	list_add(&b->lru, &c->lru);
+	spin_unlock(&c->bucket_lock);
+
+	if (f) {
+		__btree_write_node(c, b, 0, i);
+		free_bucket_contents(c, b);
+	}
+
+	i = fill_bucket(c, b, s);
+	atomic_set(&b->nread, i);
+out:
+	if (i == pages_per_btree)
+		run_wait_list(b->wait);
+	else
+		add_wait_list(*s, b->wait);
+
+	kzfree(n);
+	if (sector_to_priority(offset) == (uint16_t) ~0)
+		return b;
+
+	rw_unlock(write, &b->lock);
+	pr_debug("bucket %lu has been freed, gen %i",
+		 offset, sector_to_gen(offset));
+	inc_gen(c, offset);
+	return NULL;
+}
+
+static struct cached_bucket *upgrade_bucket(struct cache_device *c,
+					    struct cached_bucket *b,
+					    struct search_context **s)
+{
+	int level = b->level;
+	sector_t offset = b->offset;
+
+	rw_unlock(false, &b->lock);
+	rw_lock(true, &b->lock, level);
+
+	if (b->offset != offset) {
+		rw_unlock(true, &b->lock);
+		return get_bucket(c, offset, level, true, s);
+	}
+
+	if (sector_to_priority(b->offset) != (uint16_t) ~0) {
+		rw_unlock(true, &b->lock);
+		return NULL;
+	}
+	return b;
+}
+
+#define upgrade_or_retry(c, b, write, s) ({		\
+	if (!write)					\
+		b = upgrade_bucket(c, b, s);		\
+	write = true;					\
+	if (!b)						\
+		goto retry;				\
+	b; })
+
+static struct cached_bucket *btree_alloc(struct cache_device *c, int level,
+					 struct btree_key *old[],
+					 int nkeys, int skip, bool lru)
+{
+	long i = 0;
+	struct btree_node_header *h;
+	struct cached_bucket *b;
+	const char *err;
+
+	spin_lock(&c->bucket_lock);
+	list_for_each_entry(b, &c->lru, lru)
+		i++;
+
+	b = list_entry(c->lru.prev, struct cached_bucket, lru);
+	if (i >= c->btree_buckets_cached && down_write_trylock(&b->lock)) {
+		list_del(&b->lru);
+		free_bucket_contents(c, b);
+		/* parallel to get_bucket, need to __write */
+
+		b->offset = 0;
+		spin_unlock(&c->bucket_lock);
+	} else {
+		spin_unlock(&c->bucket_lock);
+		err = "bcache: btree_alloc: no mem allocating bucket";
+		b = kzalloc(sizeof(*b) + sizeof(void *) * pages_per_btree * 2,
+			    GFP_NOIO);
+		if (!b)
+			goto err;
+
+		init_rwsem(&b->lock);
+		BUG_ON(!down_write_trylock(&b->lock)); /* lockdep */
+	}
+	b->c = c;
+	b->level = level;
+	atomic_set(&b->nread, pages_per_btree);
+
+	err = "bcache: btree_alloc: unable to alloc bucket";
+
+	spin_lock(&c->bucket_lock);
+	i = __pop_bucket(c);
+	if (i == -1) {
+		spin_unlock(&c->bucket_lock);
+		goto err;
+	}
+	c->buckets[i].priority = ~0;
+	b->offset = bucket_to_sector(i);
+	spin_unlock(&c->bucket_lock);
+
+	for (i = 0; i < pages_per_btree; i++) {
+		b->pages[i] = find_or_create_page(c->bdev->bd_inode->i_mapping,
+						 (b->offset >> (PAGE_SHIFT - 9)) + i,
+						 GFP_NOIO);
+		err = "bcache: btree_alloc: error adding new pages";
+		if (!b->pages[i]) {
+			free_bucket_contents(c, b);
+			goto err;
+		}
+
+		unlock_page(b->pages[i]);
+		b->pages[i + pages_per_btree] = kmap(b->pages[i]);
+	}
+
+	h = header(b);
+	get_random_bytes(&h->random, sizeof(uint64_t));
+	h->nkeys = nkeys - skip;
+
+	if (old)
+		for (i = 1; i <= h->nkeys; i++)
+			*node(data(b), i) = *node(old, i + skip);
+
+	for (i = 0; i < h->nkeys / keys_per_page + 1; i++)
+		SetPageDirty(b->pages[i]);
+
+	if (lru) {
+		spin_lock(&c->bucket_lock);
+		list_add(&b->lru, &c->lru);
+		spin_unlock(&c->bucket_lock);
+	}
+
+	pr_debug("sector %lu", b->offset);
+
+	return b;
+err:
+	if (b) {
+		/* Just let it be reused */
+		b->offset = 0;
+		up_write(&b->lock);
+		spin_lock(&c->bucket_lock);
+		list_add(&b->lru, &c->lru);
+		spin_unlock(&c->bucket_lock);
+	}
+	printk(KERN_WARNING "%s", err);
+	return NULL;
+}
+
+static void btree_free(struct cache_device *c, struct cached_bucket *b)
+{
+	long n = sector_to_bucket(b->offset);
+	BUG_ON(n < 0 || n > c->sb.nbuckets);
+	BUG_ON(b == c->root);
+
+	spin_lock(&c->bucket_lock);
+
+	__inc_bucket_gen(c, n);
+	c->buckets[n].priority = 0;
+
+	if (!fifo_push(&c->free, n))
+		__heap_insert(c, n);
+
+	spin_unlock(&c->bucket_lock);
+
+	/*
+	 * Need to check if b->nread != pages_per_btree...
+	 */
+
+	if (c->sb.btree_level == b->level) {
+		spin_lock(&c->bucket_lock);
+		list_add(&b->lru, &c->lru);
+		spin_unlock(&c->bucket_lock);
+	}
+
+	blkdev_issue_discard(c->bdev, b->offset,
+			     c->sb.bucket_size, GFP_NOIO, 0);
+
+	pr_debug("bucket %li, sector %lu", n, b->offset);
+}
+
+static void set_new_root(struct cache_device *c, struct cached_bucket *b)
+{
+	BUG_ON(sector_to_priority(b->offset) != (uint16_t) ~0);
+	spin_lock(&c->sb_lock);
+	c->sb.btree_level = b->level;
+	c->sb.btree_root = b->offset;
+	c->root = b;
+	write_super(c);
+	spin_unlock(&c->sb_lock);
+	pr_debug("new root %lli", c->sb.btree_root);
+}
+
+static void btree_write_node_endio(struct bio *bio, int error)
+{
+	int i;
+	for (i = 0; i > bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+}
+
+static void __btree_write_node(struct cache_device *c, struct cached_bucket *b,
+			     int skip, int n)
+{
+	int i;
+	struct bio *bio = NULL;
+
+	BUG_ON(n > pages_per_btree);
+
+	for (i = skip; i < n; i++) {
+		BUG_ON(!b->pages[i]);
+
+		if (!PageDirty(b->pages[i])) {
+			if (bio) {
+				submit_bio(WRITE, bio);
+				bio = NULL;
+			}
+			continue;
+		}
+
+		if (!bio) {
+			bio = bio_kmalloc(GFP_NOIO, n - i);
+			if (!bio) {
+				pr_debug("couldn't allocate bio!");
+				return;
+			}
+
+			bio->bi_bdev = c->bdev;
+			bio->bi_sector = page_index(b->pages[i])
+				<< (PAGE_SHIFT - 9);
+			bio->bi_end_io = btree_write_node_endio;
+		}
+
+		bio->bi_io_vec[bio->bi_vcnt].bv_page = b->pages[i];
+		bio->bi_io_vec[bio->bi_vcnt].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[bio->bi_vcnt].bv_offset = 0;
+
+		bio->bi_size += PAGE_SIZE;
+		bio->bi_vcnt++;
+
+		get_page(b->pages[i]);
+		ClearPageDirty(b->pages[i]);
+	}
+
+	pr_debug("sector %li pages %i", bio->bi_sector, n);
+	if (bio)
+		submit_bio(WRITE, bio);
+}
+
+static void btree_write_node(struct cache_device *c, struct cached_bucket *b,
+			     int skip)
+{
+	int n = keys(&data(b)[skip]) / keys_per_page + 1;
+
+	if (((keys(&data(b)[skip]) + 1) % keys_per_page) == 0 &&
+	    PageDirty(b->pages[skip]))
+		__btree_write_node(c, b, skip, n + skip);
+}
+
+static struct bio *bio_split_front(struct bio *bio, sector_t sectors)
+{
+	int idx = 0, nbytes = sectors << 9;
+	struct bio_vec *bv;
+	struct bio *ret = NULL;
+
+	if (sectors >= bio_sectors(bio)) {
+		bio->bi_vcnt	 -= bio->bi_idx;
+		bio->bi_max_vecs -= bio->bi_idx;
+		bio->bi_io_vec	 += bio->bi_idx;
+		bio->bi_idx	  = 0;
+		return bio;
+	}
+	pr_debug("splitting");
+
+	bio_for_each_segment(bv, bio, idx) {
+		if (!nbytes) {
+			if (!(ret = bio_kmalloc(GFP_NOIO, 0)))
+				break;
+
+			ret->bi_vcnt	= idx - bio->bi_idx;
+			ret->bi_io_vec	= &bio->bi_io_vec[bio->bi_idx];
+			break;
+		} else if (nbytes < bv->bv_len) {
+			int vcnt = idx - bio->bi_idx + 1;
+			if (!(ret = bio_kmalloc(GFP_NOIO, vcnt)))
+				break;
+
+			ret->bi_vcnt = vcnt;
+			memcpy(ret->bi_io_vec,
+			       &bio->bi_io_vec[bio->bi_idx],
+			       sizeof(struct bio_vec) * vcnt);
+
+			ret->bi_io_vec[vcnt-1].bv_len = nbytes;
+			bv->bv_offset += nbytes;
+			break;
+		}
+
+		nbytes -= bv->bv_len;
+	}
+
+	if (ret) {
+		ret->bi_sector	= bio->bi_sector;
+		ret->bi_size	= sectors << 9;
+		ret->bi_bdev	= bio->bi_bdev;
+		ret->bi_flags  |= 1 << BIO_SPLIT;
+		ret->bi_rw	= bio->bi_rw;
+		ret->bi_size	= bio->bi_size;
+		ret->bi_idx	= 0;
+
+		bio->bi_sector	+= sectors;
+		bio->bi_size	-= sectors << 9;
+		bio->bi_idx	+= idx;
+
+		ret->bi_private = bio;
+		ret->bi_end_io	= NULL;
+		atomic_inc(&bio->bi_remaining);
+	} else
+		pr_debug("failed");
+
+	return ret;
+}
+
+static void bio_add_work(struct bio *bio, int error)
+{
+	struct search_context *s = bio->bi_private;
+
+	s->error = error;
+	bio_put(bio);
+	put_search(s);
+}
+
+static void cache_hit(struct cache_device *c, struct bio *list)
+{
+	long b;
+	struct bio *bio;
+	if (!list)
+		return;
+
+	spin_lock(&c->bucket_lock);
+	for (bio = list; bio; bio = bio->bi_next) {
+		bio->bi_bdev = c->bdev;
+
+		b = sector_to_bucket(bio->bi_sector);
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+		c->buckets[b].priority = (long) initial_priority;
+			/* * (cache_hit_seek + cache_hit_priority
+			 * bio_sectors(bio) / c->sb.bucket_size)
+			/ (cache_hit_seek + cache_hit_priority);*/
+
+		__heap_insert(c, b);
+
+		__rescale_heap(c, bio_sectors(bio));
+		c->cache_hits++;
+		cache_hits++;
+	}
+	spin_unlock(&c->bucket_lock);
+
+	while (list) {
+		sector_t s = list->bi_sector;
+		bio = list;
+		list = bio->bi_next;
+		bio->bi_next = NULL;
+
+		__generic_make_request(bio);
+		atomic_dec(&c->buckets[sector_to_bucket(s)].pin);
+	}
+}
+
+static bool __ptr_bad(struct cache_device *c, uint64_t p)
+{
+	sector_t o = PTR_OFFSET(p), l = PTR_LENGTH(p);
+	if (sector_to_bucket(o) < 0 ||
+	    sector_to_bucket(o) >= c->sb.nbuckets ||
+	    l + o % c->sb.bucket_size > c->sb.bucket_size) {
+		pr_debug("bad ptr %llu: offset %lu len %lu", p, o, l);
+		return true;
+	}
+	return PTR_GEN(p) != sector_to_gen(PTR_OFFSET(p));
+}
+
+#define ptr_bad(c, p)	__ptr_bad(c, p->ptr)
+
+#define run_on_root(write, f, ...) ({					\
+	int _r = -2;							\
+	do {								\
+		bool _w = (write);					\
+		rw_lock(_w, &c->root->lock, c->root->level);		\
+		if (sector_to_priority(c->root->offset) == (uint16_t) ~0\
+		    && _w == (write))					\
+			_r = f(c, c->root, __VA_ARGS__);		\
+		else {							\
+			rw_unlock(_w, &c->root->lock);			\
+			cpu_relax();					\
+		}							\
+	} while (_r == -2);						\
+	_r; })
+
+#define sorted_set_checks(i, b) ({					\
+	bool _cont = true;						\
+	if (index(i, b) >= nread)					\
+		goto again;						\
+	if (rand(i) != header(b)->random)				\
+		_cont = false;						\
+	else if (keys(i) >= (pages_per_btree - index(i, b)) * keys_per_page) {\
+		pr_debug("bad btree header: page %li h->nkeys %i",	\
+			 index(i, b), keys(i));				\
+		keys(i) = 0;						\
+		if (i != data(b))					\
+			_cont = false;					\
+	} else if (keys(i) >= (nread - index(i, b)) * keys_per_page)	\
+		goto again;						\
+	_cont; })
+
+/* Iterate over the sorted sets of pages
+ */
+#define for_each_sorted_set(i, b)					\
+	for (i = data(b), nread = atomic_read(&b->nread);		\
+	     index(i, b) < pages_per_btree && sorted_set_checks(i, b);	\
+	     i += (keys(i) / keys_per_page) + 1)
+
+#define for_each_key(i, j, b)						\
+	for_each_sorted_set(i, b)					\
+		for (j = 1; j <= keys(i); j++)
+
+/*
+ * Returns the smallest key greater than the search key.
+ * This is because we index by the end, not the beginning
+ */
+static int btree_bsearch(struct btree_key *data[], uint64_t search)
+{
+	int l = 1, r = keys(data) + 1;
+
+	while (l < r) {
+		int m = (l + r) >> 1;
+		if (node(data, m)->key > search)
+			r = m;
+		else
+			l = m + 1;
+	}
+
+	return l;
+}
+
+static int btree_search(struct cache_device *c, struct cached_bucket *b,
+			int device, struct bio *bio, struct search_context **s)
+{
+	int ret = -1, j, last, nread;
+	struct btree_key **i;
+	struct bio *split;
+	struct cached_bucket *recurse;
+
+	uint64_t search = TREE_KEY(device, bio->bi_sector);
+
+	pr_debug("at %lu searching for %llu, nread %i",
+		 b->offset, search, atomic_read(&b->nread));
+
+	for_each_sorted_set(i, b)
+		for (j = btree_bsearch(i, search), last = 0;
+		     j <= keys(i) && ret < 1;
+		     j++) {
+			if (ptr_bad(c, node(i, j)))
+				continue;
+
+			BUG_ON(node(i, j)->key <= search);
+
+			if (device != TREE_KEY_DEV(i, j) ||
+			    (last && search + bio_sectors(bio) <= node(i, last)->key))
+				break;
+
+			last = j;
+
+			pr_debug("loop %i of %i page %li level %i key %llu ptr %llu", j,
+				 keys(i), i - data(b), b->level, node(i, j)->key, node(i, j)->ptr);
+
+			if (b->level) {
+				recurse = get_bucket(c, TREE_PTR_OFFSET(i, j), b->level - 1, false, s);
+				if (recurse)
+					ret = max(ret, btree_search(c, recurse, device, bio, s));
+			} else
+				if (search >= node(i, j)->key - TREE_PTR_LENGTH(i, j)) {
+					long bucket = sector_to_bucket(TREE_PTR_OFFSET(i, j));
+					atomic_inc(&c->buckets[bucket].pin);
+					smp_mb__after_atomic_inc();
+					if (sector_to_gen(TREE_PTR_OFFSET(i, j)) !=
+					    TREE_PTR_GEN(i, j)) {
+						atomic_dec(&c->buckets[bucket].pin);
+						continue;
+					}
+
+					split = bio_split_front(bio, node(i, j)->key - search);
+					if (!split)
+						goto err;
+
+					split->bi_sector = TREE_PTR_OFFSET(i, j) + (split->bi_sector -
+						 (TREE_KEY_OFFSET(i, j) - TREE_PTR_LENGTH(i, j)));
+
+
+					if (split != bio) {
+						pr_debug("partial cache hit");
+						split->bi_next = bio->bi_next;
+						bio->bi_next = split;
+					} else
+						ret = 1;
+				}
+			search = TREE_KEY(device, bio->bi_sector);
+		}
+
+	label(err,	ret = -1);
+	label(again,	ret = 0);
+	rw_unlock(false, &b->lock);
+	return ret;
+}
+
+static void btree_sort(void *base, size_t num)
+{
+	size_t i;
+
+	void sift(size_t r, size_t n)
+	{
+		int c = r * 2;
+		for (; c <= n; r = c, c *= 2) {
+			if (c < n &&
+			    node(base, c)->key < node(base, c + 1)->key)
+				c++;
+			if (node(base, r)->key >= node(base, c)->key)
+				return;
+			swap(*node(base, r), *node(base, c));
+		}
+	}
+
+	for (i = num / 2 + 1; i > 0; --i)
+		sift(i, num);
+
+	for (i = num; i > 1; sift(1, --i))
+		swap(*node(base, 1), *node(base, i));
+}
+
+static void btree_clean(struct cache_device *c, struct cached_bucket *b)
+{
+	size_t j, n, orig;
+	int nkeys;
+	struct btree_node_header *h = header(b);
+	struct btree_key **i;
+
+	orig = nkeys = h->nkeys;
+	for (j = 1; j <= nkeys; j++)
+		while (j <= nkeys && ptr_bad(c, node(data(b), j)))
+			if (j <= --nkeys)
+				*node(data(b), j) = *node(data(b), nkeys + 1);
+
+	for (h = header(b), i = data(b);
+	     i < data(b) + pages_per_btree &&
+	     h->random == header(b)->random;
+	     i += (n / keys_per_page) + 1, h = (struct btree_node_header *) *i) {
+
+		if (h->nkeys >= (pages_per_btree - (i - data(b))) * keys_per_page) {
+			pr_debug("bad btree header: page %li h->nkeys %i",
+				 i - data(b), h->nkeys);
+			h->nkeys = h->random = 0;
+			break;
+		}
+
+		n = h->nkeys;
+		if (data(b) == i)
+			continue;
+		orig += h->nkeys;
+
+		for (j = 1; j <= n; j++)
+			if (!ptr_bad(c, node(i, j)))
+				*node(data(b), ++nkeys) = *node(i, j);
+	}
+	h = header(b);
+	h->nkeys = nkeys;
+
+	pr_debug("merged %i keys from %lu keys", h->nkeys, orig);
+	btree_sort(data(b), h->nkeys);
+}
+
+static int btree_gc(struct cache_device *c, struct cached_bucket *b,
+		    struct btree_key *root, struct search_context *s)
+{
+	int j, r, ret = 0, nread;
+	uint64_t rand;
+	bool write = false;
+	struct btree_key **i;
+	struct cached_bucket *n = NULL, *recurse;
+
+	for_each_key(i, j, b)
+		ret = max_t(uint8_t, ret,
+			    sector_to_gen(TREE_PTR_OFFSET(i, j)) -
+			    TREE_PTR_GEN(i, j));
+
+	if (ret > 10 && PageDirty(b->pages[0])) {
+		write = true;
+		b = upgrade_bucket(c, b, &s);
+		if (!b)
+			return 0;
+	}
+
+	if (ret > 10 && !write) {
+		n = btree_alloc(c, b->level, NULL, 0,
+				0, c->sb.btree_level != b->level);
+		if (n) {
+			rand = header(n)->random;
+			for (j = 0; j < pages_per_btree; j++)
+				memcpy(data(n)[j], data(b)[j], PAGE_SIZE);
+			header(n)->random = rand;
+			swap(b, n);
+			write = true;
+		}
+	}
+
+	if (write) {
+		btree_clean(c, b);
+		*root = bucket_key(b);
+		ret = 0;
+	}
+
+	if (b->level)
+		for_each_key(i, j, b)
+			if (!ptr_bad(c, node(i, j)))
+				if ((recurse = get_bucket(c, TREE_PTR_OFFSET(i, j),
+						    b->level - 1, false, &s))) {
+					struct btree_key k = *node(i, j);
+					r = btree_gc(c, recurse, write ? node(i, j) : &k, s);
+					if (r < 0)
+						goto again;
+					ret = max_t(uint8_t, ret, r);
+				}
+
+	btree_write_node(c, b, 0);
+
+	label(again, ret = -1);
+	rw_unlock(write, &b->lock);
+
+	if (n) {
+		if (c->sb.btree_level == b->level)
+			set_new_root(c, b);
+
+		btree_free(c, n);
+		rw_unlock(false, &n->lock);
+	}
+
+	pr_debug("ret %i", ret);
+	return ret;
+}
+
+static void do_btree_gc(struct work_struct *w)
+{
+	uint8_t *t;
+	long i, r;
+	struct btree_key root;
+	struct cache_device *c = container_of(w, struct cache_device, work);
+	struct search_context s = { .q = c, .end_fn = NULL };
+
+	pr_debug("collecting garbage, need_gc %i", c->need_gc);
+
+	down_write(&c->gc_lock);
+	r = run_on_root(false, btree_gc, &root, &s);
+	up_write(&c->gc_lock);
+
+	spin_lock(&c->bucket_lock);
+
+	if (r >= 0) {
+		c->need_gc = r;
+
+		for (i = 0; i < c->sb.nbuckets; i++) {
+			c->buckets[i].last_gc = c->gc_in_progress[i];
+			c->need_gc = max_t(uint8_t, c->need_gc,
+					   c->buckets[i].generation - c->buckets[i].last_gc);
+		}
+
+		pr_debug("garbage collect done, new need_gc %i", c->need_gc);
+	}
+
+	t = c->gc_in_progress;
+	c->gc_in_progress = NULL;
+	spin_unlock(&c->bucket_lock);
+
+	kfree(t);
+}
+
+static void btree_insert_one_key(struct cache_device *c, struct btree_key *i[],
+				 struct btree_key *k)
+{
+	int j;
+	size_t m, n;
+	BUG_ON(!PageDirty(virt_to_page(*i)));
+
+	n = m = btree_bsearch(i, k->key);
+
+	if (m > 1) {
+		if (TREE_PTR_OFFSET(i, m - 1) == PTR_OFFSET(k->ptr) &&
+		    !PTR_LENGTH(k->ptr)) {
+			/* Replacing a stale pointer to a btree bucket */
+			m--;
+			k->ptr--;
+			spin_lock(&c->bucket_lock);
+			c->buckets[sector_to_bucket(PTR_OFFSET(k->ptr))].generation--;
+			spin_unlock(&c->bucket_lock);
+		}
+#if 0
+		else if (k->key - PTR_LENGTH(k->ptr) <=
+			 node(i, m - 1)->key - TREE_PTR_LENGTH(i, m - 1))
+			/* Replacing a stale key */
+			m--;
+		else if (k->key - PTR_LENGTH(k->ptr) < node(i, m - 1)->key) {
+			/* Key partially overwrites an existing key */
+			node(i, m - 1)->key -= k->key - node(i, m - 1)->key;
+			node(i, m - 1)->ptr -= PTR_LENGTH(k->key - node(i, m - 1)->key);
+		}
+#endif
+	}
+
+	pr_debug("%s at %lu h->nkeys %i key %llu ptr %llu",
+		 m == n ? "inserting" : "replacing",
+		 m, keys(i), k->key, k->ptr);
+
+	if (m == n) {
+		for (j = keys(i)++; j >= m; --j)
+			*node(i, j+1) = *node(i, j);
+
+		/* necessary for btree_split */
+		if (!(keys(i) & keys_per_page))
+			SetPageDirty(virt_to_page(i[keys(i) / keys_per_page]));
+	}
+
+	*node(i, m) = *k;
+}
+
+static int btree_split(struct cache_device *c, struct cached_bucket *b,
+		       struct btree_key *new_keys, int *n)
+{
+	int ret = 0;
+	struct cached_bucket *n1, *n2 = NULL, *n3 = NULL;
+	struct btree_node_header *h;
+
+	h = header(b);
+	pr_debug("splitting at level %i sector %lu nkeys %i",
+		 b->level, b->offset, h->nkeys);
+	btree_clean(c, b);
+
+	if (h->nkeys < keys_per_page * pages_per_btree / 2) {
+		bool lru = c->sb.btree_level != b->level;
+		pr_debug("not splitting: %i keys", h->nkeys);
+
+		while (*n)
+			btree_insert_one_key(c, data(b), &new_keys[--(*n)]);
+
+		if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys, 0, lru)))
+			goto err;
+
+		btree_write_node(c, n1, 0);
+
+		if (lru)
+			new_keys[(*n)++] = bucket_key(n1);
+		else
+			set_new_root(c, n1);
+		goto out;
+	}
+
+	if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys >> 1, 0, true)) ||
+	    !(n2 = btree_alloc(c, b->level, data(b), h->nkeys, h->nkeys >> 1, true)))
+		goto err;
+
+	while (*n)
+		if (new_keys[--(*n)].key <= last_key(data(n1)))
+			btree_insert_one_key(c, data(n1), &new_keys[*n]);
+		else
+			btree_insert_one_key(c, data(n2), &new_keys[*n]);
+
+	new_keys[(*n)++] = bucket_key(n2);
+	new_keys[(*n)++] = bucket_key(n1);
+
+	btree_write_node(c, n1, 0);
+	btree_write_node(c, n2, 0);
+
+	if (c->sb.btree_level == b->level) {
+		if (!(n3 = btree_alloc(c, b->level + 1, NULL, 0, 0, false)))
+			goto err;
+
+		while (*n)
+			btree_insert_one_key(c, data(n3), &new_keys[--(*n)]);
+		btree_write_node(c, n3, 0);
+
+		rw_unlock(true, &n3->lock);
+		set_new_root(c, n3);
+	}
+
+	rw_unlock(true, &n2->lock);
+out:
+	rw_unlock(true, &n1->lock);
+	btree_free(c, b);
+	return ret;
+err:
+	printk(KERN_WARNING "bcache: couldn't split");
+	if (n2) {
+		btree_free(c, n2);
+		rw_unlock(true, &n2->lock);
+	}
+	if (n1) {
+		btree_free(c, n1);
+		rw_unlock(true, &n1->lock);
+	}
+	btree_write_node(c, b, 0);
+	return 0;
+}
+
+static int btree_insert(struct cache_device *c, struct cached_bucket *b,
+			struct btree_key *new_keys, int *n,
+			struct search_context **s)
+{
+	int ret = 0, nread;
+	uint64_t biggest = 0;
+	struct btree_key **i;
+
+	while (*n) {
+		for_each_sorted_set(i, b) {
+			if (keys(i))
+				biggest = max(biggest, last_key(i));
+
+			if (PageDirty(b->pages[index(i, b)]))
+				break;
+		}
+
+		if (index(i, b) >= pages_per_btree)
+			return btree_split(c, b, new_keys, n);
+
+		if (rand(i) != header(b)->random) {
+			rand(i) = header(b)->random;
+			keys(i) = 0;
+			SetPageDirty(b->pages[index(i, b)]);
+		}
+
+		pr_debug("inserting %i keys %llu at %lu level %i page %li h->nkeys %i",
+			 *n, new_keys[*n - 1].key, b->offset, b->level, index(i, b), keys(i));
+
+		while (*n && (keys(i) + 1) % keys_per_page) {
+			btree_insert_one_key(c, i, &new_keys[--(*n)]);
+
+			if (new_keys[*n].key > biggest) {
+				new_keys[0].key = new_keys[*n].key;
+				ret = 1;
+			}
+
+			biggest = max(new_keys[*n].key, biggest);
+		}
+
+		btree_write_node(c, b, index(i, b));
+	}
+
+	if (ret == 1 && b->level != c->sb.btree_level) {
+		inc_gen(c, b->offset);
+		new_keys[(*n)++].ptr = bucket_to_ptr(b);
+	}
+
+	label(again, ret = -1);
+	return ret;
+}
+
+static int btree_insert_recurse(struct cache_device *c, struct cached_bucket *b,
+				int *level, struct btree_key *new_keys, int *n,
+				struct search_context **s)
+{
+	int j, ret = 0, nread;
+	struct btree_key **i;
+	struct cached_bucket *r;
+	bool write = !(b->level - *level);
+
+	if (!atomic_read(&b->nread))
+		goto again;
+
+	if (!header(b)->random) {
+trashed:	if (c->sb.btree_level != b->level) {
+			btree_free(c, b);
+			goto done;
+		}
+
+		printk(KERN_WARNING "bcache: btree was trashed, h->nkeys %i", header(b)->nkeys);
+		r = btree_alloc(c, 0, NULL, 0, 0, false);
+		set_new_root(c, r);
+
+		btree_free(c, b);
+		rw_unlock(write, &b->lock);
+
+		b = r;
+		write = true;
+	}
+
+	if (b->level - *level) {
+		struct btree_key recurse_key = { .key = 0, .ptr = 0 };
+
+		for_each_sorted_set(i, b) {
+			for (j = btree_bsearch(i, new_keys[0].key);
+			     j <= keys(i) && ptr_bad(c, node(i, j));
+			     j++)
+				;
+
+			if (j > keys(i))
+				for (j = keys(i); j > 0 && ptr_bad(c, node(i, j)); j--)
+					;
+
+			/* Pick the smallest key to recurse on that's bigger
+			 * than the key we're inserting, or failing that,
+			 * the biggest key.
+			 */
+			if (j &&
+			    ((node(i, j)->key > recurse_key.key && recurse_key.key < new_keys[0].key) ||
+			     (node(i, j)->key < recurse_key.key && node(i, j)->key > new_keys[0].key)))
+				recurse_key = *node(i, j);
+		}
+
+		/* No key to recurse on */
+		if (!recurse_key.ptr)
+			goto trashed;
+
+		r = get_bucket(c, PTR_OFFSET(recurse_key.ptr),
+			       b->level - 1, !(b->level - *level - 1), s);
+		if (!r)
+			goto retry;
+
+		ret = btree_insert_recurse(c, r, level, new_keys, n, s);
+	}
+
+	if (*n && ret >= 0) {
+		*level = b->level;
+		upgrade_or_retry(c, b, write, s);
+		ret = btree_insert(c, b, new_keys, n, s);
+	}
+done:
+	label(retry, ret = -2);
+	label(again, ret = -1);
+	rw_unlock(write, &b->lock);
+	return ret;
+}
+
+static void btree_insert_async(void *q, struct bio *bio,
+			       struct search_context *s)
+{
+	struct cache_device *c = q;
+	int ret, keys = 1, level = 0;
+
+	down_read(&c->gc_lock);
+	ret = run_on_root(!(c->root->level - level),
+			  btree_insert_recurse, &level, s->new_keys, &keys, &s);
+	up_read(&c->gc_lock);
+
+	return_f(s, ret == -1 ? btree_insert_async : NULL);
+}
+
+static void bio_insert(void *private, struct bio *bio,
+		       struct search_context *s)
+{
+	int dev, idx;
+	struct cache_device *c = NULL, *i;
+	struct bio_vec *bv;
+	struct bio *n = NULL;
+
+	atomic_set(&bio->bi_remaining, 1);
+	bio->bi_bdev	= c->bdev;
+	bio->bi_private	= s->bi_private;
+	bio->bi_end_io	= s->bi_end_io;
+	bio->bi_next	= NULL;
+	bio->bi_idx	= 0;
+	bio->bi_size	= 0;
+	bio_for_each_segment(bv, bio, idx)
+		bio->bi_size += bv->bv_len;
+
+	if (!bio->bi_size || s->error || list_empty(&cache_devices))
+		goto err;
+
+	/*struct open_bucket *b;
+	list_for_each_entry(b, &open_buckets, list)
+		if (bio->bi_bdev->bd_cache_identifier == b->identifier &&
+		    KEY_OFFSET(b->key.key) + (len >> 9) == s->bi_sector) {
+			c = b->cache;
+			c->last_used = jiffies;
+			list_move(&b->list, &open_buckets);
+			goto found;
+		}*/
+
+	list_for_each_entry(i, &cache_devices, list)
+		if (!c || c->last_used > i->last_used)
+			c = i;
+	c->last_used = jiffies;
+
+	dev = lookup_dev(c, bio);
+	if (dev == UUIDS_PER_SB)
+		goto err;
+
+	while (n != bio) {
+		struct search_context t = { .q = c, .new_keys[0] = { 0, 0 } };
+		sector_t split, offset;
+
+		spin_lock(&c->bucket_lock);
+		if (c->sectors_free < min_t(int, bio_sectors(bio), PAGE_SIZE >> 9)) {
+			if (!pop_bucket(c)) {
+				spin_unlock(&c->bucket_lock);
+				goto err;
+			}
+
+			t.new_keys[0] = c->current_key;
+			c->current_key = (struct btree_key) {0, 0};
+		}
+
+		split = min_t(int, bio_sectors(bio), c->sectors_free);
+
+		offset		 = c->current_bucket + c->sb.bucket_size - c->sectors_free;
+		c->sectors_free -= split;
+		s->bi_sector	+= split;
+		spin_unlock(&c->bucket_lock);
+
+		n = bio_split_front(bio, split);
+		if (!n)
+			goto err;
+
+		n->bi_sector = offset;
+
+		if (c->current_key.ptr &&
+		    c->current_key.key + bio_sectors(n) == TREE_KEY(dev, s->bi_sector)) {
+			c->current_key.key += TREE_KEY(0, bio_sectors(n));
+			c->current_key.ptr += TREE_PTR(0, bio_sectors(n), 0);
+		} else {
+			if (c->current_key.ptr)
+				t.new_keys[0] = c->current_key;
+
+			if (t.new_keys[0].ptr) {
+				heap_insert(c, sector_to_bucket(c->current_bucket));
+				btree_insert_async(c, NULL, &t);
+			}
+
+			c->current_key.key = TREE_KEY(dev, s->bi_sector);
+			c->current_key.ptr = TREE_PTR(sector_to_gen(c->current_bucket),
+						      bio_sectors(n), n->bi_sector);
+		}
+
+		pr_debug("adding to cache %u sectors at %lu key %llu",
+			 bio_sectors(n), n->bi_sector, c->current_key.key);
+		submit_bio(WRITE, n);
+	}
+
+	/* refcounting problem when error and bio's been split?
+	 */
+err:
+	return_f(s, NULL);
+}
+
+static void request_hook_read(void *p, struct bio *bio,
+			      struct search_context *s)
+{
+	int ret = -1, dev;
+	struct request_queue *q = p;
+	struct cache_device *c;
+
+	if (list_empty(&cache_devices))
+		goto out;
+
+	list_for_each_entry(c, &cache_devices, list) {
+		dev = lookup_dev(c, bio);
+		if (dev == UUIDS_PER_SB)
+			goto out;
+
+		ret = max(ret, run_on_root(false, btree_search, dev, bio, &s));
+
+		if (ret == 1) {
+			cache_hit(c, bio);
+			return_f(s, NULL);
+		} else {
+			cache_hit(c, bio->bi_next);
+			bio->bi_next = NULL;
+		}
+	}
+
+	s = alloc_search(s);
+	s->bio = bio;
+	s->q = q;
+
+	if (!ret)
+		return_f(s, request_hook_read);
+
+	pr_debug("cache miss for %lu, starting write", bio->bi_sector);
+	cache_misses++;
+
+	list_for_each_entry(c, &cache_devices, list)
+		rescale_heap(c, bio_sectors(bio));
+
+	s->end_fn	= bio_insert;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+	s->bi_sector	= bio->bi_sector;
+
+	bio->bi_private = s;
+	bio->bi_end_io  = bio_add_work;
+	bio_get(bio);
+
+out:
+	if (q->make_request_fn(q, bio))
+		generic_make_request(bio);
+}
+
+static void request_hook_write(struct request_queue *q, struct bio *bio,
+			       struct search_context *s)
+{
+	if (q->make_request_fn(q, bio))
+		generic_make_request(bio);
+}
+
+static int request_hook(struct request_queue *q, struct bio *bio)
+{
+	struct search_context s;
+	memset(&s, 0, sizeof(s));
+	if (bio->bi_size) {
+		if (bio_rw_flagged(bio, BIO_RW))
+			request_hook_write(q, bio, &s);
+		else
+			request_hook_read(q, bio, &s);
+		return 0;
+	} else
+		return 1;
+}
+
+#define write_attribute(n)	\
+	static struct attribute sysfs_##n = { .name = #n, .mode = S_IWUSR }
+#define read_attribute(n)	\
+	static struct attribute sysfs_##n = { .name = #n, .mode = S_IRUSR }
+#define rw_attribute(n)	\
+	static struct attribute sysfs_##n =				\
+		{ .name = #n, .mode = S_IWUSR|S_IRUSR }
+
+#define sysfs_print(file, ...)						\
+	if (attr == &sysfs_ ## file)					\
+		return snprintf(buffer, PAGE_SIZE, __VA_ARGS__)
+
+#define sysfs_atoi(file, var)						\
+	if (attr == &sysfs_ ## file) {					\
+		unsigned long _v, _r = strict_strtoul(buffer, 10, &_v);	\
+		if (_r)							\
+			return _r;					\
+		var = _v;						\
+	}
+
+write_attribute(register_cache);
+write_attribute(register_dev);
+write_attribute(unregister);
+
+read_attribute(bucket_size);
+read_attribute(nbuckets);
+read_attribute(cache_hits);
+read_attribute(cache_hit_ratio);
+read_attribute(cache_misses);
+read_attribute(tree_depth);
+read_attribute(min_priority);
+
+rw_attribute(cache_priority_initial);
+rw_attribute(cache_priority_hit);
+rw_attribute(cache_priority_seek);
+rw_attribute(cache_priority_rescale);
+
+DECLARE_WAIT_QUEUE_HEAD(pending);
+
+static void write_super_endio(struct bio *bio, int error)
+{
+	if (error)
+		pr_debug("io error writing superblock %i", error);
+	bio_put(bio);
+}
+
+static void load_priorites_endio(struct bio *bio, int error)
+{
+	atomic_t *wait = bio->bi_private;
+	if (error)
+		printk(KERN_ERR "bcache: Error reading priorities");
+	atomic_dec(wait);
+	wake_up(&pending);
+	bio_put(bio);
+}
+
+static void load_priorities(struct cache_device *c)
+{
+	atomic_t wait;
+	long i = 0, used = 0, vecs = bio_get_nr_vecs(c->bdev);
+	int n = (sizeof(struct bucket_disk) * c->sb.nbuckets) / PAGE_SIZE + 1;
+	struct bio *bio = bio_kmalloc(GFP_KERNEL, n);
+
+	if (!bio)
+		return;
+
+	bio->bi_sector = PRIO_SECTOR;
+	bio->bi_bdev = c->bdev;
+	bio->bi_vcnt = n;
+	bio->bi_size = PAGE_SIZE * n;
+
+	bio->bi_private = &wait;
+	bio->bi_end_io = load_priorites_endio;
+
+	for (i = 0; i < n; i++) {
+		bio->bi_io_vec[i].bv_page =
+			vmalloc_to_page((void *) c->disk_buckets
+					+ PAGE_SIZE * i);
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+	}
+
+	while (bio->bi_vcnt > vecs)
+		submit_bio(READ, bio_split_front(bio, vecs * PAGE_SIZE << 9));
+
+	atomic_set(&wait, 1);
+	submit_bio(READ, bio);
+	wait_event(pending, atomic_read(&wait) == 0);
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		atomic_set(&c->buckets[i].pin, 0);
+		c->buckets[i].heap = -1;
+		c->buckets[i].priority = le16_to_cpu(c->disk_buckets[i].priority);
+		c->buckets[i].generation = c->disk_buckets[i].generation;
+
+		if (c->buckets[i].priority != (uint16_t) ~0 &&
+		    c->buckets[i].priority)
+			used++;
+
+		if (c->buckets[i].priority != (uint16_t) ~0)
+			if (c->buckets[i].priority != 0 || !fifo_push(&c->free, i))
+				__heap_insert(c, i);
+	}
+	pr_debug("Cache loaded, %li buckets in use", used);
+}
+
+static void save_priorities(struct cache_device *c)
+{
+	long i, n = (sizeof(struct bucket_disk) * c->sb.nbuckets) / PAGE_SIZE + 1;
+	struct bio *bio = bio_kmalloc(GFP_NOIO, n);
+
+	if (!bio)
+		return;
+
+	bio->bi_sector = PRIO_SECTOR;
+	bio->bi_bdev = c->bdev;
+	bio->bi_vcnt = n;
+	bio->bi_size = PAGE_SIZE * n;
+
+	bio->bi_private = c;
+	bio->bi_end_io = write_super_endio;
+
+	for (i = 0; i < n; i++) {
+		bio->bi_io_vec[i].bv_page =
+			vmalloc_to_page((void *) c->disk_buckets
+					+ PAGE_SIZE * i);
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+	}
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		c->disk_buckets[i].priority = cpu_to_le16(c->buckets[i].priority);
+		c->disk_buckets[i].generation = c->buckets[i].generation;
+	}
+
+	submit_bio(WRITE, bio);
+}
+
+static void register_dev_on_cache(struct cache_device *c, int d)
+{
+	int i;
+
+	for (i = 0; i < UUIDS_PER_SB; i++) {
+		if (is_zero(&c->uuids->b_data[i*16], 16)) {
+			pr_debug("inserted new uuid at %i", i);
+			memcpy(c->uuids->b_data + i*16, &uuids[d*16], 16);
+			set_buffer_dirty(c->uuids);
+			sync_dirty_buffer(c->uuids);
+			break;
+		}
+
+		if (!memcmp(&c->uuids->b_data[i*16], &uuids[d*16], 16)) {
+			/*
+			 * Need to check if device was already opened
+			 * read/write and invalidate previous data if it was.
+			 */
+			pr_debug("looked up uuid at %i", i);
+			break;
+		}
+	}
+
+	if (i == UUIDS_PER_SB) {
+		printk(KERN_DEBUG "Aiee! No room for the uuid");
+		return;
+	}
+
+	c->devices[i] = d;
+}
+
+static int parse_uuid(const char *s, char *uuid)
+{
+	int i, j, x;
+	memset(uuid, 0, 16);
+
+	for (i = 0, j = 0;
+	     i < strspn(s, "-0123456789:ABCDEFabcdef") && j < 32;
+	     i++) {
+		x = s[i] | 32;
+
+		switch (x) {
+		case '0'...'9':
+			x -= '0';
+			break;
+		case 'a'...'f':
+			x -= 'a' - 10;
+			break;
+		default:
+			continue;
+		}
+
+		x <<= ((j & 1) << 2);
+		uuid[j++ >> 1] |= x;
+	}
+	return i;
+}
+
+/*static ssize_t store_dev(struct kobject *kobj, struct attribute *attr,
+			   const char *buffer, size_t size)
+{
+	if (attr == &sysfs_unregister) {
+	}
+	return size;
+}
+
+static void unregister_dev(struct kobject *k)
+{
+
+}*/
+
+static void register_dev(const char *buffer, size_t size)
+{
+	int i;
+	const char *err = NULL;
+	char *path = NULL;
+	unsigned char uuid[16];
+	struct block_device *bdev = NULL;
+	struct cached_dev *d;
+	struct cache_device *c;
+
+	/*static struct attribute *files[] = {
+		&sysfs_unregister,
+		NULL
+	};
+	static const struct sysfs_ops ops = {
+		.show = NULL,
+		.store = store_dev
+	};
+	static struct kobj_type dev_obj = {
+		.release = unregister_dev,
+		.sysfs_ops = &ops,
+		.default_attrs = files
+	};*/
+
+	if (!try_module_get(THIS_MODULE))
+		return;
+
+	err = "Bad uuid";
+	i = parse_uuid(buffer, &uuid[0]);
+	if (i < 4)
+		goto err;
+
+	err = "Insufficient memory";
+	if (!(path = kmalloc(size + 1 - i, GFP_KERNEL)) ||
+	    !(d = kzalloc(sizeof(*d), GFP_KERNEL)))
+		goto err;
+
+	strcpy(path, skip_spaces(buffer + i));
+	bdev = lookup_bdev(strim(path));
+
+	err = "Failed to open device";
+	if (IS_ERR(bdev))
+		goto err;
+
+	err = "Aready registered";
+	for (i = 0;
+	     i < UUIDS_PER_SB && !is_zero(&uuids[i*16], 16);
+	     i++)
+		if (!memcmp(&uuids[i*16], uuid, 16))
+			goto err;
+
+	err = "Max devices already open";
+	if (i == UUIDS_PER_SB)
+		goto err;
+
+#if 0
+	    blkdev_get(bdev, FMODE_READ|FMODE_WRITE))
+	bdevname(bdev, b);
+	err = "Error creating kobject";
+	if (!kobject_get(bcache_kobj) ||
+	    kobject_init_and_add(&d->kobj, &dev_obj,
+				 bcache_kobj,
+				 "%s", b))
+		goto err;
+#endif
+
+	memcpy(&uuids[i*16], uuid, 16);
+	bdev->bd_cache_identifier = i;
+	/*devices[i] = bdev->bd_disk;*/
+
+	list_for_each_entry(c, &cache_devices, list)
+		register_dev_on_cache(c, i);
+
+	bdev->bd_cache_fn = request_hook;
+	printk(KERN_DEBUG "bcache: Caching %s index %i", path, i);
+
+	if (0) {
+err:		printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
+		if (bdev)
+			bdput(bdev);
+		kzfree(d);
+	}
+	kfree(path);
+}
+
+static void unregister_cache_kobj(struct work_struct *w)
+{
+	struct cache_device *c = container_of(w, struct cache_device, work);
+	list_del(&c->list);
+	INIT_LIST_HEAD(&c->list);
+	kobject_put(&c->kobj);
+}
+
+static ssize_t store_cache(struct kobject *kobj, struct attribute *attr,
+			   const char *buffer, size_t size)
+{
+	struct cache_device *c = container_of(kobj, struct cache_device, kobj);
+	if (attr == &sysfs_unregister) {
+		INIT_WORK(&c->work, unregister_cache_kobj);
+		schedule_work(&c->work);
+	}
+	return size;
+}
+
+static ssize_t show_cache(struct kobject *kobj, struct attribute *attr,
+			  char *buffer)
+{
+	struct cache_device *c = container_of(kobj, struct cache_device, kobj);
+
+	sysfs_print(bucket_size, "%i\n", c->sb.bucket_size << 9);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
+	sysfs_print(min_priority, "%u\n", c->heap[0] ? c->heap[0]->priority : 0);
+	return 0;
+}
+
+static const char *read_super(struct cache_device *c)
+{
+	const char *err;
+	struct cache_sb *s;
+	struct buffer_head *bh;
+
+	if (!(bh = __bread(c->bdev, 1, 4096)))
+		return "IO error";
+
+	err = "Not a bcache superblock";
+	s = (struct cache_sb *) bh->b_data;
+	if (memcmp(s->magic, bcache_magic, 16))
+		goto err;
+
+	c->sb.version		= le32_to_cpu(s->version);
+	c->sb.block_size	= le16_to_cpu(s->block_size);
+	c->sb.bucket_size	= le16_to_cpu(s->bucket_size);
+	c->sb.journal_start	= le32_to_cpu(s->journal_start);
+	c->sb.first_bucket	= le32_to_cpu(s->first_bucket);
+	c->sb.nbuckets		= le64_to_cpu(s->nbuckets);
+	c->sb.btree_root	= le64_to_cpu(s->btree_root);
+	c->sb.btree_level	= le16_to_cpu(s->btree_level);
+
+	err = "Unsupported superblock version";
+	if (c->sb.version > CACHE_CLEAN)
+		goto err;
+
+	err = "Bad block/bucket size";
+	if (!c->sb.block_size ||
+	    c->sb.bucket_size & (PAGE_SIZE / 512 - 1) ||
+	    c->sb.bucket_size < c->sb.block_size)
+		goto err;
+
+	err = "Too many buckets";
+	if (c->sb.nbuckets > LONG_MAX)
+		goto err;
+
+	err = "Invalid superblock";
+	if (c->sb.journal_start * c->sb.bucket_size <
+	    24 + (c->sb.nbuckets * sizeof(struct bucket_disk)) / 512)
+		goto err;
+
+	if (c->sb.first_bucket < c->sb.journal_start ||
+	    get_capacity(c->bdev->bd_disk) < bucket_to_sector(c->sb.nbuckets))
+		goto err;
+
+	if (c->sb.btree_root < c->sb.first_bucket * c->sb.bucket_size ||
+	    c->sb.btree_root >= bucket_to_sector(c->sb.nbuckets))
+		goto err;
+
+	err = "Bucket size must be multiple of page size";
+	 if (!pages_per_btree ||
+	     c->sb.bucket_size & ((PAGE_SIZE >> 9) - 1))
+		goto err;
+
+	err = NULL;
+
+	get_page(bh->b_page);
+	c->sb_page = bh->b_page;
+err:
+	put_bh(bh);
+	return err;
+}
+
+static void write_super(struct cache_device *c)
+{
+	struct cache_sb *s;
+	struct bio *bio = bio_kmalloc(GFP_NOIO, 1);
+
+	if (!bio)
+		return;
+
+	BUG_ON(list_empty(&c->list) != (c->sb.version & CACHE_CLEAN));
+
+	pr_debug("ver %i, root %llu, level %i",
+		 c->sb.version, c->sb.btree_root, c->sb.btree_level);
+
+	bio->bi_sector = SB_SECTOR;
+	bio->bi_bdev = c->bdev;
+	bio->bi_vcnt = 1;
+	bio->bi_size = 4096;
+
+	bio->bi_private = c;
+	bio->bi_end_io = write_super_endio;
+
+	bio->bi_io_vec[0].bv_page = c->sb_page;
+	bio->bi_io_vec[0].bv_len = 4096;
+	bio->bi_io_vec[0].bv_offset = 0;
+
+	s = kmap(c->sb_page);
+
+	memcpy(s->magic, bcache_magic, 16);
+	s->version		= cpu_to_le32(c->sb.version);
+	s->block_size		= cpu_to_le16(c->sb.block_size);
+	s->bucket_size		= cpu_to_le16(c->sb.bucket_size);
+	s->journal_start	= cpu_to_le32(c->sb.journal_start);
+	s->first_bucket		= cpu_to_le32(c->sb.first_bucket);
+	s->nbuckets		= cpu_to_le64(c->sb.nbuckets);
+	s->btree_root		= cpu_to_le64(c->sb.btree_root);
+	s->btree_level		= cpu_to_le16(c->sb.btree_level);
+
+	kunmap(c->sb_page);
+	submit_bio(WRITE, bio);
+}
+
+static void free_cache(struct cache_device *c)
+{
+	struct cached_bucket *b;
+
+	while (!list_empty(&c->lru)) {
+		b = list_first_entry(&c->lru, struct cached_bucket, lru);
+		list_del(&b->lru);
+		free_bucket_contents(c, b);
+		kzfree(b);
+	}
+
+	kfree(c->gc_in_progress);
+
+	if (c->kobj.state_initialized) {
+		kobject_put(bcache_kobj);
+		kobject_put(&c->kobj);
+	}
+
+	if (c->root) {
+		free_bucket_contents(c, c->root);
+		kzfree(c->root);
+	}
+
+	free_fifo(&c->free);
+
+	vfree(c->disk_buckets);
+	vfree(c->buckets);
+	vfree(c->heap);
+	if (c->uuids)
+		put_bh(c->uuids);
+	if (c->sb_page)
+		put_page(c->sb_page);
+	if (!IS_ERR_OR_NULL(c->bdev))
+		close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
+
+	module_put(c->owner);
+	kzfree(c);
+}
+
+static void register_cache(const char *buffer, size_t size)
+{
+	int i, n;
+	const char *err = NULL;
+	char *path = NULL, b[BDEVNAME_SIZE];
+	struct cache_device *c = NULL;
+	struct search_context s, *sp = &s;
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_bucket_size,
+		&sysfs_nbuckets,
+		&sysfs_cache_hits,
+		&sysfs_tree_depth,
+		&sysfs_min_priority,
+		NULL
+	};
+	static const struct sysfs_ops ops = {
+		.show = show_cache,
+		.store = store_cache
+	};
+	static struct kobj_type cache_obj = {
+		.release = unregister_cache,
+		.sysfs_ops = &ops,
+		.default_attrs = files
+	};
+
+	if (!try_module_get(THIS_MODULE))
+		return;
+
+	err = "Insufficient memory";
+	if (!(path = kmalloc(size + 1, GFP_KERNEL)) ||
+	    !(c = kzalloc(sizeof(*c), GFP_KERNEL)))
+		goto err;
+
+	c->owner = THIS_MODULE;
+	INIT_LIST_HEAD(&c->lru);
+
+	strcpy(path, skip_spaces(buffer));
+
+	err = "Failed to open cache device";
+	c->bdev = open_bdev_exclusive(strim(path), FMODE_READ|FMODE_WRITE, c);
+	if (IS_ERR(c->bdev))
+		goto err;
+
+	set_blocksize(c->bdev, 4096);
+
+	if ((err = read_super(c)))
+		goto err;
+
+	err = "IO error reading UUIDs";
+	if (!(c->uuids = __bread(c->bdev, 2, PAGE_SIZE)))
+		goto err;
+
+	err = "Not enough buckets";
+	if (c->sb.nbuckets >> 7 <= 1)
+		goto err;
+
+	n = (c->sb.nbuckets - 1) / (PAGE_SIZE / sizeof(struct bucket_disk)) + 1;
+
+	err = "Insufficient memory";
+	if (!(c->heap		= vmalloc(c->sb.nbuckets * sizeof(struct bucket *))) ||
+	    !(c->buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket))) ||
+	    !(c->disk_buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket_disk))) ||
+	    !init_fifo(&c->free, c->sb.nbuckets >> 7, GFP_KERNEL))
+		goto err;
+
+	memset(c->heap,	   0, c->sb.nbuckets * sizeof(struct bucket *));
+	memset(c->buckets, 0, c->sb.nbuckets * sizeof(struct bucket));
+
+	spin_lock_init(&c->sb_lock);
+	spin_lock_init(&c->bucket_lock);
+	init_rwsem(&c->gc_lock);
+
+	c->btree_buckets_cached = 10;
+
+	load_priorities(c);
+
+	memset(&s, 0, sizeof(s));
+	if (c->sb.version & CACHE_CLEAN)
+		c->root = get_bucket(c, c->sb.btree_root, c->sb.btree_level, true, &sp);
+	else
+		printk(KERN_DEBUG "bcache: Cache device %s was dirty, invalidating existing data", path);
+
+	c->sb.version &= ~CACHE_CLEAN;
+	if (!c->root) {
+		c->root = btree_alloc(c, 0, NULL, 0, 0, false);
+		if (!c->root)
+			goto err;
+		set_new_root(c, c->root);
+	} else
+		list_del(&c->root->lru);
+
+	rw_unlock(true, &c->root->lock);
+	BUG_ON(sector_to_priority(c->root->offset) != (uint16_t) ~0);
+
+	if (!(c->gc_in_progress = kmalloc(c->sb.nbuckets, GFP_KERNEL)))
+		goto err;
+
+	for (i = 0; i < c->sb.nbuckets; i++)
+		c->gc_in_progress[i] = c->buckets[i].generation;
+	do_btree_gc(&c->work);
+
+	for (i = 0; i < UUIDS_PER_SB; i++)
+		c->devices[i] = ~0;
+
+	for (i = 0; i < UUIDS_PER_SB && !is_zero(&uuids[i*16], 16); i++)
+		register_dev_on_cache(c, i);
+
+	err = "Error creating kobject";
+	bdevname(c->bdev, b);
+	if (!kobject_get(bcache_kobj) ||
+	    kobject_init_and_add(&c->kobj, &cache_obj,
+				 bcache_kobj,
+				 "%s", b))
+		goto err;
+
+	list_add(&c->list, &cache_devices);
+
+	printk(KERN_DEBUG "bcache: Loaded cache device %s", path);
+	pr_debug("btree root at %li", c->root->offset);
+
+	if (0) {
+err:		printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
+		if (c) {
+			if (c->bdev == ERR_PTR(EBUSY))
+				err = "Device busy";
+			free_cache(c);
+		}
+	}
+	kfree(path);
+}
+
+static void unregister_cache(struct kobject *k)
+{
+	struct cache_device *c = container_of(k, struct cache_device, kobj);
+	struct cached_bucket *b;
+
+	/*
+	 * need to write out current key
+	 */
+
+	list_for_each_entry(b, &c->lru, lru)
+		__btree_write_node(c, b, 0, pages_per_btree);
+
+	c->sb.version |= CACHE_CLEAN;
+	save_priorities(c);
+	write_super(c);
+	free_cache(c);
+}
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buffer)
+{
+	sysfs_print(cache_hits, "%lu\n", cache_hits);
+	sysfs_print(cache_hit_ratio, "%lu%%\n",
+		    cache_hits * 100 / (cache_hits + cache_misses));
+	sysfs_print(cache_misses, "%lu\n", cache_misses);
+	sysfs_print(cache_priority_initial, "%i\n", initial_priority);
+	sysfs_print(cache_priority_hit, "%i\n", cache_hit_priority);
+	sysfs_print(cache_priority_seek, "%i\n", cache_hit_seek);
+	sysfs_print(cache_priority_rescale, "%li\n", rescale);
+	return 0;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buffer, size_t size)
+{
+	if (attr == &sysfs_register_cache)
+		register_cache(buffer, size);
+	if (attr == &sysfs_register_dev)
+		register_dev(buffer, size);
+	sysfs_atoi(cache_priority_initial, initial_priority);
+	sysfs_atoi(cache_priority_hit, cache_hit_priority);
+	sysfs_atoi(cache_priority_seek, cache_hit_seek);
+	sysfs_atoi(cache_priority_rescale, rescale);
+
+	return size;
+}
+
+static int __init bcache_init(void)
+{
+	static const struct sysfs_ops ops = { .show = show, .store = store };
+	static const struct attribute *files[] = { &sysfs_register_cache,
+		&sysfs_register_dev,
+		&sysfs_cache_hits,
+		&sysfs_cache_hit_ratio,
+		&sysfs_cache_misses,
+		&sysfs_cache_priority_initial,
+		&sysfs_cache_priority_hit,
+		&sysfs_cache_priority_seek,
+		&sysfs_cache_priority_rescale,
+		NULL};
+
+	printk(KERN_DEBUG "bcache loading");
+
+	delayed = create_workqueue("bcache");
+	if (!delayed)
+		return -ENOMEM;
+
+	bcache_kobj = kobject_create_and_add("bcache", kernel_kobj);
+	if (!bcache_kobj)
+		return -ENOMEM;
+
+	bcache_kobj->ktype->sysfs_ops = &ops;
+	return sysfs_create_files(bcache_kobj, files);
+}
+
+static void bcache_exit(void)
+{
+	struct cache_device *c;
+
+	sysfs_remove_file(bcache_kobj, &sysfs_register_cache);
+	sysfs_remove_file(bcache_kobj, &sysfs_register_dev);
+
+	/*for (i = 0; i < UUIDS_PER_SB; i++)
+		if (devices[i] && devices[i])
+			devices[i]->bd_cache_fn = NULL;*/
+
+	list_for_each_entry(c, &cache_devices, list)
+		kobject_put(&c->kobj);
+}
+
+module_init(bcache_init);
+module_exit(bcache_exit);
