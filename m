Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0DWTlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:41:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38769 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab0DWTlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IPmDzfGxjDz8wndG2/7q76tTifQrT9tApC78sGuxiaQuSNj4rSPBf0/XtibjcjODRJ
         t/EEqaNN0UDhVYEC+G1VbgD+wcL5iq32qvf6LvgEbgjTSzH3e+ewviZkWNp4MZ4lcBqc
         tws2P4euH5bWbixEkdBgqEkuFzebHmPs8U3HQ=
Date: Fri, 23 Apr 2010 11:41:07 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] bcache: ver 3
Message-ID: <20100423194107.GA20322@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core code is getting close to stable and feature complete. Garbage
collection is done, and locking is mostly done (I'm not refcounting data
buckets yet, and it does need to be stared at a whole lot more but it
passes lockdep and seems to be working).

Basic bucket priority calculation is done (right now it acts as an LRU);
you can fill the cache up and everything works like it ought to. And,
I've yet to see it return bad data; I think it's not all that far off
from being useful.

The one thing that has me at a loss right now is the performance isn't
where it should be, and for no obvious reason. The problem is most
succinctly demonstrated thusly:

With cache, no cache misses:
root@utumno:~# mount -o ro /dev/sdb /mnt/
root@utumno:~# cd /mnt/
root@utumno:/mnt# time find > /dev/null 
 
 real	0m29.618s
 user	0m0.000s
 sys	0m0.840s

No cache device:
root@utumno:~# mount -o ro /dev/sdb /mnt/
root@utumno:~# cd /mnt/
root@utumno:/mnt# time find > /dev/null 

real	0m1.597s
user	0m0.050s
sys	0m1.240s

This is a vm, so the wall clock time in the latter case doesn't mean
much, it's all in the hosts's cache. But the former case is bewildering;
the cache device lives on a tmpfs so it shouldn't be waiting on IO, and
cpu time is less than the uncached case. Clearly it's waiting on
something, but I haven't been able to figure out what the heck to trace;
there's no lock contention, blktrace shows nothing unexpected, I keep
running into dead ends. Any pointers here would be much appreciated.

Besides that, there shouldn't be anything complex left before I add
write support, and that should be pretty straightforward too. 

This patch does have some changes to the generic bio code for completion
of split bios, I'm going to split it out and submit it seperately after
I've gone over it more and it's actually been tested.

Any comments/review much appreciated.

 block/Kconfig       |    5 +
 block/Makefile      |    2 +
 block/bcache.c      | 2337 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-core.c    |    7 +-
 fs/bio.c            |   32 +-
 include/linux/bio.h |    2 +
 include/linux/fs.h  |    5 +
 7 files changed, 2386 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index f9e89f4..85adf8d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -100,6 +100,11 @@ config DEBUG_BLK_CGROUP
 	in the blk group which can be used by cfq for tracing various
 	group related activity.
 
+config BLK_CACHE
+	tristate "Block device as cache"
+	select SLOW_WORK
+	default m
+
 endif # BLOCK
 
 config BLOCK_COMPAT
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
index 0000000..3bf3fff
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,2337 @@
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
+#include <linux/slow-work.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+/*
+ * Todo:
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
+ */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
+
+struct search_context;
+struct cached_bucket;
+
+typedef void (search_fn) (void *, struct bio *, struct search_context *);
+
+/*
+ * Page 0: unused
+ * Page 1: superblock
+ * Page 2: device UUIDs
+ * Page 3+: bucket priorities
+ *
+ */
+
+struct cache_sb {
+	uint8_t  magic[16];
+	uint32_t version;
+	uint16_t block_size;		/* sectors */
+	uint16_t bucket_size;		/* sectors */
+	uint32_t journal_start;		/* buckets */
+	uint32_t first_bucket;		/* start of data */
+	uint64_t nbuckets;		/* device size */
+	uint64_t first_free_bucket;	/* buckets that have never been used, only increments */
+	uint64_t btree_root;
+	uint16_t btree_level;
+	uint16_t btree_bucket_size;
+};
+
+struct bucket {
+	size_t		heap;
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
+	struct buffer_head	*sb_bh;
+	struct kobject		kobj;
+	struct block_device	*bdev;
+	struct module		*owner;
+	struct work_struct	work;
+
+	/*
+	 * Buckets used for cached data go on the heap. The heap is ordered by
+	 * bucket->priority; a priority of ~0 indicates a btree bucket. Priority
+	 * is increased on cache hit, and periodically all the buckets on the heap
+	 * have their priority scaled down by a linear function.
+	 */
+	spinlock_t		bucket_lock;
+	struct bucket		**heap;
+	struct bucket		*buckets;
+	struct buffer_head	*priorities;
+	unsigned long		heap_size;
+	long			rescale;
+
+	uint8_t			need_gc;
+	uint8_t			*gc_in_progress;
+	unsigned long		gc_buckets;
+	struct rw_semaphore	gc_lock;
+
+	int			btree_buckets_cached;
+	struct list_head	lru;
+
+	long			*freelist;
+	int			free_size;
+	int			free_front;
+	int			free_back;
+	spinlock_t		alloc_lock;
+
+	/*struct gendisk	*devices[256];*/
+	short			devices[256];
+	struct buffer_head	*uuids;
+
+	long			current_btree_bucket;
+	int			btree_sectors_free;
+
+	long			current_bucket;
+	struct btree_key	current_key;
+	int			sectors_free;
+
+	unsigned long		cache_hits;
+
+	struct cached_bucket	*root;
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
+	search_fn		*end_fn;
+	struct search_context	*next;
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
+static const char bcache_magic[] = { 0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca, 0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };
+
+static struct kobject		*bcache_kobj;
+/*
+ * We need a real search key
+ * static struct gendisk	*devices[256];
+ */
+static char			uuids[256*16];
+
+static LIST_HEAD(cache_devices);
+static DEFINE_SPINLOCK(cache_list_lock);
+
+static struct workqueue_struct *delayed;
+
+/*
+ * Sysfs vars / tunables
+ */
+static unsigned long cache_hits, cache_misses, rescale = 20480; /* sectors */
+static uint16_t	initial_priority = SHORT_MAX, cache_hit_priority = 100, cache_hit_seek = 100;
+
+static void do_btree_gc(struct work_struct *w);
+static void unregister_cache(struct kobject *k);
+static void write_super(struct cache_device *c);
+static void run_search(struct work_struct *w);
+static void bio_complete(void *p, struct bio *bio, struct search_context *s);
+
+#define pages_per_btree		(c->sb.btree_bucket_size >> (PAGE_SHIFT - 9))
+#define keys_per_page		(PAGE_SIZE / sizeof(struct btree_key))
+#define bucket_to_sector(b)	(((sector_t) (b) + c->sb.first_bucket) * c->sb.bucket_size)
+#define sector_to_bucket(s)	(((s) / c->sb.bucket_size) - c->sb.first_bucket)
+#define sector_to_gen(s)	({ smp_rmb(); c->buckets[sector_to_bucket(s)].generation; })
+#define sector_to_priority(s)	({ smp_rmb(); c->buckets[sector_to_bucket(s)].priority; })
+#define ptr_to_bucket(p)	sector_to_bucket(PTR_OFFSET(p))
+#define bucket_to_ptr(b)	TREE_PTR(sector_to_gen(b->offset), 0, b->offset)
+#define data(b)			((struct btree_key **) &b->pages[pages_per_btree])
+#define keys(i)			((struct btree_node_header *) *(i))->nkeys
+#define rand(i)			((struct btree_node_header *) *(i))->random
+#define header(b)		((struct btree_node_header *) data(b)[0])
+#define index(i, b)		(i - data(b))
+#define bucket_key(b)		((struct btree_key) { 				\
+				 .key = node(data(b), header(b)->nkeys)->key,	\
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
+#define TREE_KEY_DEV(page, i)		(node(page, i)->key >> 56)
+#define TREE_KEY_OFFSET(page, i)	(node(page, i)->key & ~((uint64_t) ~0 << 56))
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
+	for (dev = 0; dev < 256; dev++)
+		if (c->devices[dev] == bio->bi_bdev->bd_cache_identifier)
+			break;
+
+	if (dev == 256)
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
+		else if (s->end_fn == bio_complete)
+			run_search(&s->w);
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
+	(s)->next = l;						\
+	l = (s);						\
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
+		long i, gc_buckets;
+		uint8_t *gc_in_progress;
+		/*const static struct slow_work_ops gc_ops = {
+			.owner = THIS_MODULE,
+			.execute = do_btree_gc };*/
+
+		gc_buckets = c->sb.first_free_bucket;
+
+		spin_unlock(&c->bucket_lock);
+		gc_in_progress = kmalloc(gc_buckets, GFP_NOIO);
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
+		c->gc_buckets = gc_buckets;
+
+		for (i = 0; i < c->gc_buckets; i++)
+			c->gc_in_progress[i] = c->buckets[i].generation;
+
+		INIT_WORK(&c->work, do_btree_gc);
+		queue_work(delayed, &c->work);
+		/*slow_work_init(&c->gc, &gc_ops);
+		slow_work_enqueue(&c->gc);*/
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
+		for (i = 0; i < c->heap_size; i++)
+			c->heap[i]->priority = ((long) c->heap[i]->priority * 7) / 8;
+		c->rescale += rescale;
+	}
+}
+
+#define rescale_heap(c, s)	({		\
+	spin_lock(&c->bucket_lock);		\
+	__rescale_heap(c, s);			\
+	spin_unlock(&c->bucket_lock); })	\
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
+	long p, h = c->heap_size++;
+
+	c->buckets[b].priority = initial_priority;
+	c->buckets[b].heap = h;
+	c->heap[h] = &c->buckets[b];
+
+	for (p = (h - 1) / 2; p; h = p, p = (h - 1) / 2)
+		if (heap_swap(c, h, p))
+			break;
+
+	__heap_sift(c, h);
+
+	pr_debug("inserted bucket %li, new heap size %li, heap location %li",
+		 b, c->heap_size, c->buckets[b].heap);
+}
+
+static void heap_insert(struct cache_device *c, long b)
+{
+	spin_lock(&c->bucket_lock);
+	if (c->buckets[b].heap == -1)
+		__heap_insert(c, b);
+	else
+		__heap_sift(c, c->buckets[b].heap);
+	spin_unlock(&c->bucket_lock);
+}
+
+static long __heap_pop(struct cache_device *c)
+{
+	long ret = c->heap[0] - c->buckets;
+
+	BUG_ON(heap_swap(c, 0, --c->heap_size));
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
+	long r, first_free_bucket;
+	int free;
+	
+	spin_lock(&c->bucket_lock);
+	free = c->free_front - c->free_back;
+
+	first_free_bucket = c->sb.first_free_bucket;
+
+	/*
+	 * Try to keep the freelist half full
+	 */
+	if (free < 0)
+		free += c->free_size;
+
+	for (; free < c->free_size >> 1; free++) {
+		if (c->sb.first_free_bucket < c->sb.nbuckets)
+			r = c->sb.first_free_bucket++;
+		else
+			r = __heap_pop(c);
+
+		__inc_bucket_gen(c, r);
+
+		c->freelist[c->free_front++] = r;
+		c->free_front &= c->free_size;
+
+		blkdev_issue_discard(c->bdev, bucket_to_sector(r),
+				     c->sb.bucket_size, GFP_NOIO, 0);
+	}
+
+	if (first_free_bucket != c->sb.first_free_bucket)
+		write_super(c);
+
+	r = c->freelist[c->free_back++];
+	c->free_back &= c->free_size;
+
+	spin_unlock(&c->bucket_lock);
+	return r;
+}
+
+static void pop_bucket(struct cache_device *c)
+{
+	if (c->current_bucket)
+		heap_insert(c, sector_to_bucket(c->current_bucket));
+
+	c->sectors_free = c->sb.bucket_size;
+	c->current_bucket = bucket_to_sector(__pop_bucket(c));
+}
+
+static void free_bucket_contents(struct cache_device *c, struct cached_bucket *b)
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
+				bio->bi_private = b;
+				bio->bi_end_io = fill_bucket_endio;
+				pr_debug("reading at sector %li, page_index %li",
+					 bio->bi_sector, page_index(b->pages[i]));
+			}
+			nread++;
+
+			bio->bi_io_vec[bio->bi_vcnt].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[bio->bi_vcnt].bv_offset = 0;
+			bio->bi_io_vec[bio->bi_vcnt].bv_page = b->pages[i];
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
+	if (bio) {
+		submit_bio(READ, bio);
+		add_wait_list(*s, b->wait);
+	}
+
+	return ret;
+}
+
+static struct cached_bucket *get_bucket(struct cache_device *c, sector_t offset,
+					int level, bool write, struct search_context **s)
+{
+	int i;
+	struct list_head *l;
+	struct cached_bucket *b, *n = NULL;
+
+retry:
+	i = 0;
+	spin_lock(&c->bucket_lock);
+	list_for_each(l, &c->lru) {
+		b = list_entry(l, struct cached_bucket, lru);
+		if (offset == b->offset) {
+			list_move(&b->lru, &c->lru);
+			spin_unlock(&c->bucket_lock);
+
+			rw_lock(write, &b->lock, level);
+
+			if (offset != b->offset) {
+				rw_unlock(write, &b->lock);
+				goto retry;
+			}
+
+			/* has been freed */
+			if (sector_to_priority(offset) != (uint16_t) ~0) {
+				rw_unlock(write, &b->lock);
+				inc_gen(c, offset);
+				pr_debug("bucket %lu has been freed, gen %i", offset, sector_to_gen(offset));
+				return NULL;
+			}
+
+			if (atomic_read(&b->nread) != pages_per_btree)
+				add_wait_list(*s, b->wait); /* needs lock */
+
+			return b;
+		}
+		i++;
+	}
+
+	b = list_entry(c->lru.prev, struct cached_bucket, lru);
+	if (i >= c->btree_buckets_cached && down_write_trylock(&b->lock)) {
+		list_del(&b->lru);
+		free_bucket_contents(c, b);
+
+		if (!write)
+			downgrade_write(&b->lock);
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
+		n = kzalloc(sizeof(*n) + sizeof(void *) * pages_per_btree * 2, GFP_NOIO);
+		if (!n)
+			return NULL;
+
+		goto retry;
+	}
+
+	atomic_set(&b->nread, 0);
+	b->offset = offset;
+	b->level = level;
+	list_add(&b->lru, &c->lru);
+	spin_unlock(&c->bucket_lock);
+
+	i = fill_bucket(c, b, s);
+	atomic_set(&b->nread, i);
+
+	if (i == pages_per_btree)
+		run_wait_list(b->wait);
+
+	if (n)
+		kzfree(n);
+
+	return b;
+}
+
+static struct cached_bucket *upgrade_bucket(struct cache_device *c, struct cached_bucket *b,
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
+	struct list_head *l;
+	struct btree_node_header *h;
+	struct cached_bucket *b;
+
+	spin_lock(&c->bucket_lock);
+	list_for_each(l, &c->lru)
+		i++;
+
+	b = list_entry(c->lru.prev, struct cached_bucket, lru);
+	if (i >= c->btree_buckets_cached && down_write_trylock(&b->lock)) {
+		list_del(&b->lru);
+		free_bucket_contents(c, b);
+
+		b->offset = 0;
+		spin_unlock(&c->bucket_lock);
+	} else {
+		spin_unlock(&c->bucket_lock);
+		b = kzalloc(sizeof(*b) + sizeof(void *) * pages_per_btree * 2, GFP_NOIO);
+		if (!b) {
+			printk(KERN_WARNING "bcache: btree_alloc: no mem allocating bucket");
+			return NULL;
+		}
+
+		init_rwsem(&b->lock);
+		BUG_ON(!down_write_trylock(&b->lock)); /* lockdep */
+	}
+	b->c = c;
+	b->level = level;
+	atomic_set(&b->nread, pages_per_btree);
+
+	spin_lock(&c->alloc_lock);
+	if (c->btree_sectors_free < c->sb.btree_bucket_size) {
+		i = __pop_bucket(c);
+		c->buckets[i].priority = ~0;
+		c->current_btree_bucket = bucket_to_sector(i);
+		c->btree_sectors_free = c->sb.bucket_size;
+	}
+
+	b->offset = c->current_btree_bucket + c->sb.bucket_size - c->btree_sectors_free;
+	c->btree_sectors_free -= c->sb.btree_bucket_size;
+	spin_unlock(&c->alloc_lock);
+
+	for (i = 0; i < pages_per_btree; i++) {
+		b->pages[i] = find_or_create_page(c->bdev->bd_inode->i_mapping,
+						 (b->offset >> (PAGE_SHIFT - 9)) + i,
+						 GFP_NOIO);
+		if (!b->pages[i]) {
+			for (; i >= 0; --i) {
+				kunmap(b->pages[i]);
+				page_cache_release(b->pages[i]);
+			}
+			printk(KERN_WARNING "bcache: btree_alloc: error adding new pages");
+			kzfree(b);
+			return NULL;
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
+}
+
+static void free_bucket(struct cache_device *c, struct cached_bucket *b)
+{
+	long n = sector_to_bucket(b->offset);
+	BUG_ON(n < 0 || n > c->sb.first_free_bucket);
+
+	spin_lock(&c->bucket_lock);
+
+	__inc_bucket_gen(c, n);
+	c->buckets[n].priority = 0;
+
+	if (c->free_front != c->free_back) {
+		c->freelist[c->free_front++] = n;
+		c->free_front &= c->free_size;
+	} else
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
+	c->sb.btree_root = b->offset;
+	c->root = b;
+	write_super(c);
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
+static void btree_write_node(struct cache_device *c, struct cached_bucket *b,
+			     int skip)
+{
+	int i, n;
+	struct bio *bio;
+	struct btree_node_header *h = (void *) data(b)[skip];
+	n = h->nkeys / keys_per_page + 1;
+
+	BUG_ON(skip + n > pages_per_btree);
+
+	if ((h->nkeys + 1) % keys_per_page ||
+	    !PageDirty(b->pages[skip]))
+		return;
+
+	bio = bio_kmalloc(GFP_NOIO, n);
+	if (!bio) {
+		pr_debug("couldn't allocate bio!");
+		return;
+	}
+
+	bio->bi_sector = page_index(b->pages[skip]) << (PAGE_SHIFT - 9);
+	bio->bi_bdev = c->bdev;
+	bio->bi_size = n * PAGE_SIZE;
+	bio->bi_end_io = btree_write_node_endio;
+	bio->bi_vcnt = n;
+
+	for (i = 0; i < n; i++) {
+		BUG_ON(!b->pages[skip + i]);
+
+		bio->bi_io_vec[i].bv_page = b->pages[skip + i];
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+
+		get_page(b->pages[skip + i]);
+		ClearPageDirty(b->pages[skip + i]);
+	}
+
+	pr_debug("sector %li pages %i", bio->bi_sector, n);
+
+	submit_bio(WRITE, bio);
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
+		ret->bi_flags  |= 1 << BIO_CLONED;
+		ret->bi_rw	= bio->bi_rw;
+		ret->bi_size	= bio->bi_size;
+		ret->bi_idx	= 0;
+
+		bio->bi_sector	+= sectors;
+		bio->bi_size	-= sectors << 9;
+		bio->bi_idx	+= idx;
+
+		ret->bi_private = bio;
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
+static void submit_wait_bio(int rw, struct bio *bio, struct cache_device *c,
+			    struct search_context *s)
+{
+	BUG_ON(!bio->bi_vcnt || !bio->bi_size || bio->bi_idx);
+	bio->bi_bdev = c->bdev;
+	bio->bi_next = NULL;
+	bio->bi_end_io = bio_add_work;
+	bio->bi_private = s;
+
+	atomic_inc(&s->remaining);
+	submit_bio(rw, bio);
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
+		c->buckets[b].priority = (long) initial_priority;
+			/* * (cache_hit_seek + cache_hit_priority * bio_sectors(bio) / c->sb.bucket_size)
+			/ (cache_hit_seek + cache_hit_priority);*/
+
+		if (c->buckets[b].heap == -1)
+			__heap_insert(c, b);
+		else
+			__heap_sift(c, c->buckets[b].heap);
+
+		__rescale_heap(c, bio_sectors(bio));
+		c->cache_hits++;
+		cache_hits++;
+	}
+
+	spin_unlock(&c->bucket_lock);
+
+	while (list) {
+		bio = list;
+		list = bio->bi_next;
+		bio->bi_next = NULL;
+
+		generic_make_request(bio);
+	}
+}
+
+static bool __ptr_bad(struct cache_device *c, uint64_t p)
+{
+	if (PTR_OFFSET(p) <  bucket_to_sector(0) ||
+	    PTR_OFFSET(p) >= bucket_to_sector(c->sb.first_free_bucket)) {
+		pr_debug("bad ptr %lu: not a bucket", (unsigned long) p);
+		return true;
+	}
+	if ((PTR_LENGTH(p) + PTR_OFFSET(p) - 1) % c->sb.bucket_size > c->sb.bucket_size) {
+		pr_debug("bad ptr %lu: bad len %llu offset %llu", (unsigned long) p,
+			 PTR_LENGTH(p), PTR_OFFSET(p));
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
+		int _level = c->sb.btree_level;				\
+		rw_lock(_w, &c->root->lock, _level);			\
+		if (c->root->level == _level &&				\
+		    sector_to_priority(c->root->offset) == (uint16_t) ~0)\
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
+		_cont = false;				   		\
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
+					split = bio_split_front(bio, node(i, j)->key - search);
+					if (!split)
+						goto err;
+
+					split->bi_sector = TREE_PTR_OFFSET(i, j) + (split->bi_sector -
+						 (TREE_KEY_OFFSET(i, j) - TREE_PTR_LENGTH(i, j)));
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
+static void btree_sort(void *base, size_t n)
+{
+	int i;
+
+	void sift(int r, int n)
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
+	for (i = n / 2 + 1; i > 0; --i)
+		sift(i, n);
+
+	for (i = n; i > 1; sift(1, --i))
+		swap(*node(base, 1), *node(base, i));
+}
+
+static void btree_clean(struct cache_device *c, struct cached_bucket *b)
+{
+	int j, nkeys, n, orig;
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
+	pr_debug("merged %i keys from %i keys", h->nkeys, orig);
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
+	label(again, ret = -1);
+	btree_write_node(c, b, 0);
+
+	rw_unlock(write, &b->lock);
+
+	if (n) {
+		if (c->sb.btree_level == b->level)
+			set_new_root(c, b);
+
+		free_bucket(c, n);
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
+	pr_debug("collecting garbage for %li buckets, need_gc %i", c->gc_buckets, c->need_gc);
+
+	down_write(&c->gc_lock);
+	r = run_on_root(false, btree_gc, &root, &s);
+	up_write(&c->gc_lock);
+
+	spin_lock(&c->bucket_lock);
+
+	if (r >= 0) {
+		for (i = 0; i < c->gc_buckets; i++)
+			c->buckets[i].last_gc = c->gc_in_progress[i];
+
+		c->need_gc = r;
+		for (i = 0; i < c->sb.first_free_bucket; i++)
+			c->need_gc = max_t(uint8_t, c->need_gc,
+					   c->buckets[i].generation - c->buckets[i].last_gc);
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
+	int j, m, n;
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
+	pr_debug("%s at %i h->nkeys %i key %llu ptr %llu",
+		 m == n ? "inserting" : "replacing",
+		 m, keys(i), k->key, k->ptr);
+
+	if (m == n)
+		for (j = keys(i)++; j >= m; --j)
+			*node(i, j+1) = *node(i, j);
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
+	pr_debug("btree_clean done");
+
+	if (h->nkeys < c->sb.btree_bucket_size * (256 / sizeof(struct btree_key))) {
+		bool lru = c->sb.btree_level != b->level;
+		pr_debug("not splitting: %i keys", h->nkeys);
+
+		while (*n)
+			btree_insert_one_key(c, data(b), &new_keys[--(*n)]);
+
+		if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys, 0, lru)))
+			goto err;
+
+		new_keys[(*n)++] = bucket_key(n1);
+
+		btree_write_node(c, n1, 0);
+
+		if (c->sb.btree_level == b->level) {
+			c->root = n1;
+			c->sb.btree_root = n1->offset;
+			write_super(c);
+			pr_debug("new root %lli", c->sb.btree_root);
+		}
+		goto out;
+	}
+
+	if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys >> 1, 0, true)) ||
+	    !(n2 = btree_alloc(c, b->level, data(b), h->nkeys, h->nkeys >> 1, true)))
+		goto err;
+
+	while (*n)
+		if (new_keys[--(*n)].key <= node(data(n1), header(n1)->nkeys)->key)
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
+		c->sb.btree_level++;
+		set_new_root(c, n3);
+
+		pr_debug("tree depth increases: new root %llu",
+			 c->sb.btree_root);
+	}
+
+	rw_unlock(true, &n2->lock);
+out:
+	rw_unlock(true, &n1->lock);
+	free_bucket(c, b);
+	return ret;
+err:
+	printk(KERN_WARNING "bcache: couldn't split");
+	if (n2) {
+		free_bucket(c, n2);
+		rw_unlock(true, &n2->lock);
+	}
+	if (n1) {
+		free_bucket(c, n1);
+		rw_unlock(true, &n1->lock);
+	}
+	btree_write_node(c, b, 0);
+	return 0;
+}
+
+static int btree_insert(struct cache_device *c, struct cached_bucket *b,
+			struct btree_key *new_keys, int *n, struct search_context **s)
+{
+	int ret = 0, nread;
+	uint64_t biggest = 0;
+	struct btree_key **i;
+
+	while (*n) {
+		for_each_sorted_set(i, b) {
+			if (keys(i))
+				biggest = max(biggest, node(i, keys(i))->key);
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
+	struct cached_bucket *recurse;
+	bool write = !(b->level - *level);
+
+	if (!atomic_read(&b->nread))
+		goto again;
+
+	if (!header(b)->random) {
+trashed:	free_bucket(c, b);
+		if (c->sb.btree_level == b->level) {
+			printk(KERN_WARNING "bcache: btree was trashed, h->nkeys %i", header(b)->nkeys);
+			free_bucket(c, b);
+			rw_unlock(write, &b->lock);
+
+			b = btree_alloc(c, 0, NULL, 0, 0, false);
+			write = true;
+			c->sb.btree_level = 0;
+			set_new_root(c, b);
+		} else
+			goto done;
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
+		recurse = get_bucket(c, PTR_OFFSET(recurse_key.ptr),
+				     b->level - 1, !(b->level - *level - 1), s);
+		if (!recurse)
+			goto retry;
+
+		ret = btree_insert_recurse(c, recurse, level, new_keys, n, s);
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
+static void bio_complete(void *p, struct bio *bio,
+			 struct search_context *s)
+{
+	s->bio->bi_private = s->bi_private;
+	s->bio->bi_end_io  = s->bi_end_io;
+	s->bio->bi_end_io(s->bio, s->error);
+	return_f(s, NULL);
+}
+
+static void bio_insert(void *private, struct bio *bio,
+		       struct search_context *s)
+{
+	int dev, idx;
+	struct cache_device *c;
+	struct bio_vec *bv;
+	struct bio *n = NULL;
+
+	if (s->error || list_empty(&cache_devices))
+		goto err;
+
+	/*
+	 * Replace with percpu pointer
+	 */
+	spin_lock(&cache_list_lock);
+	list_rotate_left(&cache_devices);
+	c = list_first_entry(&cache_devices, struct cache_device, list);
+	spin_unlock(&cache_list_lock);
+
+	dev = lookup_dev(c, bio);
+	if (dev == 256)
+		goto err;
+
+	bio = bio_kmalloc(GFP_NOIO, 0);
+	bio->bi_io_vec	 = s->bio->bi_io_vec;
+	bio->bi_vcnt	 = s->bio->bi_vcnt;
+	bio->bi_max_vecs = s->bio->bi_max_vecs;
+
+	bio_for_each_segment(bv, bio, idx)
+		bio->bi_size += bv->bv_len;
+
+	if (!bio_sectors(bio)) {
+		bio_put(bio);
+		goto err;
+	}
+
+	while (n != bio) {
+		struct search_context t = { .q = c, .new_keys[0] = { 0, 0 } };
+		sector_t split, offset;
+
+		spin_lock(&c->alloc_lock);
+		if (c->sectors_free < min_t(int, bio_sectors(bio), PAGE_SIZE >> 9)) {
+			pop_bucket(c);
+			t.new_keys[0] = c->current_key;
+			c->current_key = (struct btree_key) {0, 0};
+		}
+
+		split = min_t(int, bio_sectors(bio), c->sectors_free);
+
+		offset		 = c->current_bucket + c->sb.bucket_size - c->sectors_free;
+		c->sectors_free -= split;
+		s->bi_sector	+= split;
+		spin_unlock(&c->alloc_lock);
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
+		submit_wait_bio(WRITE, n, c, s);
+	}
+
+err:
+	return_f(s, bio_complete);
+}
+
+static void request_hook_read(void *p, struct bio *bio,
+			      struct search_context *s)
+{
+	int ret = -1, dev;
+	struct list_head *l;
+	struct request_queue *q = p;
+
+	if (list_empty(&cache_devices))
+		goto out;
+
+	list_for_each(l, &cache_devices) {
+		struct cache_device *c = list_entry(l, struct cache_device, list);
+
+		dev = lookup_dev(c, bio);
+		if (dev == 256)
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
+	list_for_each(l, &cache_devices) {
+		struct cache_device *c = list_entry(l, struct cache_device, list);
+		rescale_heap(c, bio_sectors(bio));
+	}
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
+	static struct attribute sysfs_##n = { .name = #n, .mode = S_IWUSR|S_IRUSR }
+
+#define sysfs_print(file, ...)					\
+	if (attr == &sysfs_ ## file)				\
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
+read_attribute(buckets_used);
+read_attribute(buckets_free);
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
+static void load_priorities(struct cache_device *c)
+{
+	long i = 0, per_page = 4096 / sizeof(struct bucket_disk);
+	struct bucket_disk *b;
+	struct buffer_head *bh;
+
+	goto start;
+
+	for (; i < c->sb.first_free_bucket; i++, b++) {
+		if ((char *) (b + 1) > bh->b_data + 4006) {
+			put_bh(bh);
+start:			bh = __bread(c->bdev, i / per_page + 3, 4096);
+			b = (void *) bh->b_data;
+		}
+
+		c->buckets[i].heap = -1;
+		c->buckets[i].priority = le16_to_cpu(b->priority);
+		c->buckets[i].generation = b->generation;
+
+		if (c->buckets[i].priority == 0 &&
+		    c->free_front != c->free_back) {
+			c->freelist[c->free_front++] = i;
+			c->free_front &= c->free_size;
+		} else if (c->buckets[i].priority != (uint16_t) ~0)
+			heap_insert(c, i);
+	}
+	put_bh(bh);
+
+	for (; i < c->sb.nbuckets; i++)
+		c->buckets[i].heap = -1;
+}
+
+static void save_priorities(struct cache_device *c)
+{
+	long i = 0, per_page = PAGE_SIZE / sizeof(struct bucket_disk);
+	struct bucket_disk *b;
+	struct buffer_head *bhv[(c->sb.nbuckets - 1) / per_page + 1];
+	struct buffer_head *bh = bhv[0];
+	goto start;
+
+	for (; i < c->sb.nbuckets; i++, b++) {
+		if ((char *) (b + 1) > bh->b_data + PAGE_SIZE) {
+			lock_buffer(bh);
+			bh->b_end_io = end_buffer_write_sync;
+			submit_bh(WRITE, bh++);
+start:			bh = __getblk(c->bdev, (i / per_page + 3), PAGE_SIZE);
+			b = (void *) bh->b_data;
+		}
+
+		b->priority = cpu_to_le16(c->buckets[i].priority);
+		b->generation = c->buckets[i].generation;
+	}
+	lock_buffer(bh);
+	bh->b_end_io = end_buffer_write_sync;
+	submit_bh(WRITE, bh);
+
+	for (i = 0; i < (c->sb.nbuckets - 1) / per_page + 1; i++) {
+		wait_on_buffer(bhv[i]);
+		put_bh(bhv[i]);
+	}
+}
+
+static void register_dev_on_cache(struct cache_device *c, int d)
+{
+	int i;
+
+	for (i = 0; i < 256; i++) {
+		if (is_zero(&c->uuids->b_data[i*16], 16)) {
+			printk(KERN_DEBUG "Inserted new uuid at %i", i);
+			memcpy(c->uuids->b_data + i*16, &uuids[d*16], 16);
+			set_buffer_dirty(c->uuids);
+			sync_dirty_buffer(c->uuids);
+			break;
+		}
+
+		if (!memcmp(&c->uuids->b_data[i*16], &uuids[d*16], 16)) {
+			printk(KERN_DEBUG "Looked up uuid at %i", i);
+			break;
+		}
+	}
+
+	if (i == 256) {
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
+static void register_dev(const char *buffer, size_t size)
+{
+	int i;
+	char *path;
+	unsigned char uuid[16];
+	struct block_device *bdev;
+	struct list_head *l;
+
+	i = parse_uuid(buffer, &uuid[0]);
+
+	if (i < 4) {
+		printk(KERN_DEBUG "bcache: Bad uuid");
+		return;
+	}
+
+	path = kmalloc(size + 1 - i, GFP_KERNEL);
+	if (!path) {
+		printk(KERN_DEBUG "bcache: kmalloc error");
+		return;
+	}
+	strcpy(path, skip_spaces(buffer + i));
+	bdev = lookup_bdev(strim(path));
+
+	if (IS_ERR(bdev)) {
+		printk(KERN_DEBUG "bcache: Failed to open %s", path);
+		goto out;
+	}
+
+	for (i = 0; i < 256; i++) {
+		if (is_zero(&uuids[i*16], 16))
+			break;
+
+		if (!memcmp(&uuids[i*16], uuid, 16)) {
+			printk(KERN_DEBUG "bcache: %s already registered", path);
+			bdput(bdev);
+			goto out;
+		}
+	}
+	memcpy(&uuids[i*16], uuid, 16);
+	bdev->bd_cache_identifier = i;
+	/*devices[i] = bdev->bd_disk;*/
+
+	list_for_each(l, &cache_devices)
+		register_dev_on_cache(list_entry(l, struct cache_device, list), i);
+
+	bdev->bd_cache_fn = request_hook;
+	printk(KERN_DEBUG "bcache: Caching %s index %i", path, i);
+out:
+	kfree(path);
+}
+
+static void unregister_cache_kobj(struct work_struct *w)
+{
+	struct cache_device *c = container_of(w, struct cache_device, work);
+
+	list_del(&c->list);
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
+	sysfs_print(buckets_used, "%lli\n", c->sb.first_free_bucket);
+	sysfs_print(buckets_free, "%lli\n", c->sb.nbuckets -
+		    c->sb.first_free_bucket);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
+	sysfs_print(min_priority, "%u\n", c->heap[0] ? c->heap[0]->priority : 0);
+	return 0;
+}
+
+static char *read_super(struct cache_device *c)
+{
+	char *err;
+	struct cache_sb *s;
+
+	err = "Not a bcache superblock";
+	s = (struct cache_sb *) c->sb_bh->b_data;
+	if (memcmp(s->magic, bcache_magic, 16))
+		goto err;
+
+	c->owner		= THIS_MODULE;
+	c->sb.version		= le32_to_cpu(s->version);
+	c->sb.block_size	= le16_to_cpu(s->block_size);
+	c->sb.bucket_size	= le16_to_cpu(s->bucket_size);
+	c->sb.journal_start	= le32_to_cpu(s->journal_start);
+	c->sb.first_bucket	= le32_to_cpu(s->first_bucket);
+	c->sb.nbuckets		= le64_to_cpu(s->nbuckets);
+	c->sb.first_free_bucket = le64_to_cpu(s->first_free_bucket);
+	c->sb.btree_root	= le64_to_cpu(s->btree_root);
+	c->sb.btree_level	= le16_to_cpu(s->btree_level);
+	c->sb.btree_bucket_size	= le16_to_cpu(s->btree_bucket_size);
+
+	err = "Unsupported superblock version";
+	if (c->sb.version > 0)
+		goto err;
+
+	err = "Bad block/bucket size";
+	if (!c->sb.block_size ||
+	    c->sb.bucket_size & (PAGE_SIZE / 512 - 1) ||
+	    c->sb.bucket_size < c->sb.block_size)
+		goto err;
+
+	err = "Invalid superblock";
+	if (c->sb.journal_start * c->sb.bucket_size <
+	    24 + (c->sb.nbuckets * sizeof(struct bucket_disk)) / 512)
+		goto err;
+
+	if (c->sb.first_bucket < c->sb.journal_start ||
+	    c->sb.first_free_bucket > c->sb.nbuckets ||
+	    get_capacity(c->bdev->bd_disk) < bucket_to_sector(c->sb.nbuckets))
+		goto err;
+
+	if (c->sb.btree_root < c->sb.first_bucket * c->sb.bucket_size ||
+	    c->sb.btree_root >= bucket_to_sector(c->sb.first_free_bucket))
+		goto err;
+
+	err = "Btree bucket size must be multiple of page size and not greater than bucket size";
+	 if (!pages_per_btree ||
+	    c->sb.btree_bucket_size & ((PAGE_SIZE >> 9) - 1) ||
+	    c->sb.btree_bucket_size > c->sb.bucket_size)
+		goto err;
+
+	err = NULL;
+err:
+	return err;
+}
+
+static void write_super(struct cache_device *c)
+{
+#if 0
+	struct cache_sb *s;
+
+	s = (struct cache_sb *) c->sb_bh->b_data;
+	s->version		= cpu_to_le32(c->sb.version);
+	s->block_size		= cpu_to_le16(c->sb.block_size);
+	s->bucket_size		= cpu_to_le16(c->sb.bucket_size);
+	s->journal_start	= cpu_to_le32(c->sb.journal_start);
+	s->first_bucket		= cpu_to_le32(c->sb.first_bucket);
+	s->nbuckets		= cpu_to_le64(c->sb.nbuckets);
+	s->first_free_bucket	= cpu_to_le64(c->sb.first_free_bucket);
+	s->btree_root		= cpu_to_le64(c->sb.btree_root);
+	s->btree_level		= cpu_to_le16(c->sb.btree_level);
+	s->btree_bucket_size	= cpu_to_le16(c->sb.btree_level);
+
+	/*lock_buffer(c->sb_bh);
+	  c->sb_bh->b_end_io = end_buffer_write_sync;
+	  submit_bh(WRITE, c->sb_bh);*/
+#endif
+}
+
+static void register_cache(const char *buffer, size_t size)
+{
+	char *err = NULL, *path, b[BDEVNAME_SIZE];
+	int i;
+	struct cache_device *c;
+	struct search_context s, *sp = &s;
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_bucket_size,
+		&sysfs_buckets_used,
+		&sysfs_buckets_free,
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
+	path = kmalloc(size + 1, GFP_KERNEL);
+	strcpy(path, skip_spaces(buffer));
+
+	err = "Insufficient memory";
+	if (!(c = kzalloc(sizeof(*c), GFP_KERNEL)))
+		goto err;
+
+	err = "Failed to open cache device";
+	c->bdev = open_bdev_exclusive(strim(path), FMODE_READ|FMODE_WRITE, c);
+	if (IS_ERR(c->bdev)) {
+		if (c->bdev == ERR_PTR(EBUSY))
+			err = "Device busy";
+		goto err;
+	}
+
+	set_blocksize(c->bdev, 4096);
+
+	err = "IO error";
+	if (!(c->sb_bh = __bread(c->bdev, 1, PAGE_SIZE)))
+		goto err;
+
+	if (!(c->uuids = __bread(c->bdev, 2, PAGE_SIZE)))
+		goto err;
+
+	if ((err = read_super(c)))
+		goto err;
+
+	c->free_size = 1;
+	while (c->free_size << 7 < c->sb.nbuckets)
+		c->free_size <<= 1;
+
+	err = "vmalloc error";
+	c->heap		= vmalloc(c->sb.nbuckets * sizeof(struct bucket *));
+	c->buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket));
+	c->freelist	= vmalloc(c->free_size-- * sizeof(long));
+	if (!c->heap || !c->buckets || !c->freelist)
+		goto err;
+
+	memset(c->heap,	   0, c->sb.nbuckets * sizeof(struct bucket *));
+	memset(c->buckets, 0, c->sb.nbuckets * sizeof(struct bucket));
+
+	spin_lock_init(&c->bucket_lock);
+	spin_lock_init(&c->alloc_lock);
+	init_rwsem(&c->gc_lock);
+
+	INIT_LIST_HEAD(&c->lru);
+	c->btree_buckets_cached = 10;
+
+	load_priorities(c);
+
+	memset(&s, 0, sizeof(s));
+	c->root = get_bucket(c, c->sb.btree_root, c->sb.btree_level, false, &sp);
+	c->buckets[sector_to_bucket(c->root->offset)].priority = ~0;
+
+	list_del(&c->root->lru);
+	rw_unlock(false, &c->root->lock);
+
+	/*for (i = 0; i < 256 && devices[i]; i++)
+		register_dev_on_cache(c, i);*/
+
+	for (i = 0; i < 256; i++)
+		c->devices[i] = ~0;
+
+	for (i = 0; i < 256 && !is_zero(&uuids[i*16], 16); i++)
+		register_dev_on_cache(c, i);
+
+	err = "kobject create error";
+	bdevname(c->bdev, b);
+	if (!kobject_get(bcache_kobj))
+		goto err;
+
+	if (kobject_init_and_add(&c->kobj, &cache_obj,
+				 bcache_kobj,
+				 "%s", b))
+		goto err;
+
+	list_add(&c->list, &cache_devices);
+
+	printk(KERN_DEBUG "bcache: Loaded cache device %s, pages_per_btree %i, keys_per_page %li",
+	       path, pages_per_btree, keys_per_page);
+	kfree(path);
+	return;
+err:
+	if (c) {
+		if (c->sb_bh)
+			put_bh(c->sb_bh);
+		if (c->uuids)
+			put_bh(c->uuids);
+		if (c->kobj.state_initialized)
+			kobject_put(&c->kobj);
+		if (c->freelist)
+			vfree(c->freelist);
+		if (c->buckets)
+			vfree(c->buckets);
+		if (c->heap)
+			vfree(c->heap);
+		if (!IS_ERR_OR_NULL(c->bdev))
+			close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
+		kzfree(c);
+	}
+	printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
+	kfree(path);
+	return;
+}
+
+static void unregister_cache(struct kobject *k)
+{
+	struct cache_device *c = container_of(k, struct cache_device, kobj);
+
+	save_priorities(c);
+
+	vfree(c->freelist);
+	vfree(c->buckets);
+	vfree(c->heap);
+
+	write_super(c);
+
+	put_bh(c->sb_bh);
+	put_bh(c->uuids);
+
+	close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
+	module_put(c->owner);
+	kzfree(c);
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
+	if (slow_work_register_user(THIS_MODULE))
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
+	struct list_head *l;
+
+	sysfs_remove_file(bcache_kobj, &sysfs_register_cache);
+	sysfs_remove_file(bcache_kobj, &sysfs_register_dev);
+
+	/*for (i = 0; i < 256; i++)
+		if (devices[i] && devices[i])
+			devices[i]->bd_cache_fn = NULL;*/
+
+	list_for_each(l, &cache_devices)
+		kobject_put(&list_entry(l, struct cache_device, list)->kobj);
+}
+
+module_init(bcache_init);
+module_exit(bcache_exit);
diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..41b4d21 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1405,7 +1405,7 @@ static inline void __generic_make_request(struct bio *bio)
 {
 	struct request_queue *q;
 	sector_t old_sector;
-	int ret, nr_sectors = bio_sectors(bio);
+	int ret = 1, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 	int err = -EIO;
 
@@ -1478,7 +1478,10 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
-		ret = q->make_request_fn(q, bio);
+		if (bio->bi_bdev->bd_cache_fn)
+			ret = bio->bi_bdev->bd_cache_fn(q, bio);
+		if (ret)
+			ret = q->make_request_fn(q, bio);
 	} while (ret);
 
 	return;
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..5ad2403 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -257,6 +257,7 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_init);
 
@@ -1422,13 +1423,40 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	bool put = true;
+	struct bio *p;
+	bio_end_io_t *f = bio->bi_end_io;
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	if (atomic_dec_and_test(&bio->bi_remaining))
+		goto end_io;
+
+	if (atomic_read(&bio->bi_remaining) < 0) {
+		WARN(1, "bio incorrectly initialized");
+		goto end_io;
+	}
+
+	if (error) {
+		do
+			f = bio->bi_end_io;
+		while (cmpxchg(&bio->bi_end_io, f, NULL) != f);
+		put = false;
+		goto end_io;
+	}
+
+	return;
+end_io:
+	if (f)
+		f(bio, error);
+	else if (test_bit(BIO_CLONED, &bio->bi_flags)) {
+		p = bio->bi_private;
+		bio_put(bio);
+		bio_endio(p, error);
+	}
 }
 EXPORT_SYMBOL(bio_endio);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..c3ee4c3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -94,6 +94,8 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
+	atomic_t		bi_remaining;	/* split count */
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39d57bc..8aba38c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -514,6 +514,8 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct bio;
+struct request_queue;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -664,6 +666,9 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+
+	int (*bd_cache_fn)(struct request_queue *q, struct bio *bio);
+	char			bd_cache_identifier;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim
