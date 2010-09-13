Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0IMNV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:21:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42446 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0IMNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l08NGTgbV5B2dw02NJ4YuEDBpIAsjoTGLVF24VS6d1vxf3Pk/tZmvcpaznz6jN/tJ7
         cyvMZ+978jRIMCTqUsC0qV/S7O3zOKRkYKMIT588/vst4AGGtajHkIkEGZYUsqCBDO01
         CqIC1VM2RbmRDnBE+3IhVhL+Np7HakX0wcP94=
Date: Mon, 13 Sep 2010 06:21:35 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] Bcache: Version 7 (Code)
Message-ID: <20100913132135.GA18787@moria>
References: <20100913131523.GA18615@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913131523.GA18615@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/block/bcache.c b/block/bcache.c
new file mode 100644
index 0000000..b2ad5e1
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,4907 @@
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
+#define pr_fmt(fmt) "bcache: %s() " fmt "\n", __func__
+
+#include "bcache_util.h"
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/page-flags.h>
+#include <linux/random.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/swap.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+/*
+ * Todo:
+ * Garbage collection should free old UUIDs
+ *
+ * btree_write doesn't need to wait if inserting a null key and
+ * btree_insert_key didn't do anything
+ *
+ * Calculate sizes of free lists more intelligently?
+ *
+ * IO tracking: Can we track when one process is doing io on behalf of another?
+ * IO tracking: Don't use just an average, weigh more recent stuff higher
+ *
+ * echo "`blkid /dev/loop0 -s UUID -o value` /dev/loop0"
+ *
+ * Error handling in fill_bucket... and everywhere else
+ *
+ * Fix cache hit counting, split cache hits shouldn't count for each split
+ *
+ * Make registering partitions to cache work
+ *
+ * Test module load/unload
+ *
+ * Check if a device is opened read/write when caching is turned on or off for
+ * it, and invalidate cached data (Idea: pin the first 4k? 8k? in the cache,
+ * verify it against the cached copy when caching's turned on)
+ *
+ * IO error handling
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
+struct search;
+struct btree;
+
+typedef void (search_fn) (struct search *);
+
+static const char bcache_magic[] = {
+	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
+	0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };
+
+struct cache_sb {
+	uint8_t		magic[16];
+#define CACHE_CLEAN	1
+#define CACHE_SYNC	2
+	uint32_t	version;
+	uint16_t	block_size;	/* sectors */
+	uint16_t	bucket_size;	/* sectors */
+	uint32_t	journal_start;	/* buckets */
+	uint32_t	first_bucket;	/* start of data */
+	uint64_t	nbuckets;	/* device size */
+	uint64_t	btree_root;
+	uint16_t	btree_level;
+};
+
+struct bucket {
+	long		heap;
+	atomic_t	pin;
+	uint16_t	priority;
+	uint8_t		gen;
+	uint8_t		last_gc;
+	bool		dirty;
+	void		*f;
+};
+
+struct bucket_gc {
+#define GC_MARK_DIRTY	-1
+#define GC_MARK_BTREE	-2
+	short		mark;
+	uint8_t		gen;
+};
+
+struct bucket_disk {
+	uint16_t	priority;
+	uint8_t		gen;
+} __attribute((packed));
+
+struct btree_node_header {
+	uint32_t	csum;
+	uint32_t	nkeys;
+	uint64_t	random;
+};
+
+struct bkey {
+	uint64_t	key;
+	uint64_t	ptr;
+};
+
+#define bucket_cmp(i, j)	(i->priority >= j->priority)
+
+struct cache {
+	struct list_head	list;
+	struct cache_sb		sb;
+	struct page		*sb_page;
+	struct bio		*sb_bio;
+	struct search		*sb_wait;
+
+	struct kobject		kobj;
+	struct block_device	*bdev;
+	struct module		*owner;
+	struct dentry		*debug;
+	struct work_struct	work;
+
+	/*
+	 * Buckets used for cached data go on the heap. The heap is ordered by
+	 * bucket->priority; a priority of ~0 indicates a btree bucket. Priority
+	 * is increased on cache hit, and periodically all the buckets on the
+	 * heap have their priority scaled down by a linear function.
+	 */
+	int			bucket_size_bits;
+	spinlock_t		bucket_lock;
+	struct bucket		*buckets;
+	struct bucket_disk	*disk_buckets;
+	DECLARE_HEAP(struct bucket *, heap);
+	long			rescale;
+	uint8_t			need_gc;
+	struct search		*bucket_wait;
+
+	struct work_struct	priority_work;
+	struct bio		*priority_bio;
+	atomic_t		prio_written;
+	int			pops_pinned;
+	bool			free_resized;
+
+	DECLARE_FIFO(long, free);
+	DECLARE_FIFO(long, btree);
+	DECLARE_FIFO(long, free_inc);
+	DECLARE_FIFO(long, btree_inc);
+
+	struct semaphore	gc_lock;
+	struct bucket_gc	*garbage;
+	long			sectors_to_gc;
+
+	int			btree_buckets_cached;
+	struct list_head	lru;
+
+	/*struct gendisk	*devices[UUIDS_PER_SB];*/
+	short			devices[UUIDS_PER_SB];
+	struct buffer_head	*uuids;
+
+	struct btree		*root;
+
+	unsigned long		cache_hits;
+	unsigned long		sectors_written;
+	unsigned long		btree_sectors_written;
+	unsigned long		writeback_keys_done;
+	unsigned long		writeback_keys_failed;
+
+	bool			discard;
+	struct list_head	discards;
+};
+
+struct open_bucket {
+	struct list_head	list;
+	struct cache		*cache;
+	struct task_struct	*last;
+
+	struct bkey		key;
+	sector_t		offset;
+	unsigned		sectors_free;
+	uint8_t			gen;
+};
+
+struct dirty {
+	struct rb_node		node;
+	struct work_struct	work;
+	struct bkey		key;
+	struct cache		*c;
+	struct cached_dev	*d;
+	struct bio		*bio;
+};
+
+struct cached_dev {
+	struct kobject		kobj;
+	struct block_device	*bdev;
+	struct module		*owner;
+	struct work_struct	work;
+
+	struct list_head	barrier;
+
+	bool			writeback;
+	bool			writeback_running;
+	struct mutex		dirty_lock;
+	struct bkey		last_written;
+	sector_t		last_found;
+	atomic_t		in_flight;
+	atomic_long_t		last_refilled;
+
+	struct rb_root		dirty;
+};
+
+struct btree_write {
+	struct work_struct	w;
+	unsigned long		wait_time;
+	struct search		*wait;
+	struct btree		*b;
+	struct bio		bio;
+};
+
+struct btree {
+	struct list_head	lru;
+	struct rw_semaphore	lock;
+	struct search		*wait;
+	struct cache		*c;
+	unsigned long		jiffies;
+
+	unsigned long		expires;
+	struct btree_write	*write;
+	struct delayed_work	w;
+	atomic_t		writes_outstanding;
+
+	struct work_struct	fill;
+	atomic_t		nread;
+	sector_t		offset;
+	uint16_t		level;
+	uint16_t		written;
+
+	struct page		*pages[];
+};
+
+struct closure {
+	struct work_struct	w;
+	struct search		*next;
+	search_fn		*end_fn;
+	struct closure		*parent;
+	atomic_t		remaining;
+#define	SEARCH_BLOCK		1
+#define	SEARCH_WAITING		2
+	int			flags;
+};
+
+struct insert {
+	struct closure		s;
+	struct bkey		new_keys[2];
+	uint16_t		nkeys;
+	uint16_t		level;
+	uint16_t		lock;
+	uint16_t		nkeylist;
+	struct bkey		*keylist;
+	struct cache		*cur;
+};
+
+struct bio_hook {
+	struct closure		s;
+	int			error;
+	void			*q;
+	struct bio		*bio;
+
+	struct bio		*cache_bio;
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+};
+
+struct search {
+#ifdef DEBUG_SEARCH
+	struct list_head	all;
+	const char		*waiting_on;
+#define SET_WAITING(s, f)	((s)->waiting_on = f)
+#else
+#define SET_WAITING(s, f)	do {} while (0)
+#endif
+	/* What's a stack frame?
+	 * This really needs to be broken up; doing this without losing
+	 * functionality and/or ending up with something even more ugly
+	 * is hard.
+	 */
+	struct work_struct	w;
+	struct search		*next;
+	struct search		*parent;
+	search_fn		*end_fn;
+	atomic_t		remaining;
+#define	SEARCH_BLOCK		1
+#define	SEARCH_WAITING		2
+	unsigned		flags;
+
+	struct search		*barrier_wait;
+	struct list_head	barrier;
+	uint64_t		key;
+	uint16_t		size;
+
+	int			error;
+	void			*q;
+	struct bio		*bio;
+
+	struct bio_list		misses;
+	struct bio		*cache_bio;
+	bio_end_io_t		*bi_end_io;
+	void			*bi_private;
+
+	/* btree_insert_async */
+	struct bkey		new_keys[3];
+	uint16_t		nkeys;
+	uint16_t		level;
+	uint16_t		lock;
+	uint16_t		nkeylist;
+	struct bkey		*keylist;
+	struct cache		*cur;
+	struct cached_dev	*d;
+	short			delay;
+	enum {
+		INSERT_READ,
+		INSERT_WRITE,
+		INSERT_WRITEBACK,
+		INSERT_UNDIRTY,
+		INSERT_FILL
+	} write;
+	unsigned long		wait_time;
+};
+
+static LIST_HEAD(searches);
+static spinlock_t search_lock;
+
+#define blocking_search	(struct search) {	\
+	.flags = SEARCH_BLOCK,			\
+	.wait_time = jiffies,			\
+	.remaining = { 1 }			\
+}
+
+/* Will be moved to struct cached_dev
+ */
+
+#define RECENT_IO_BITS	7
+#define RECENT_IO	(1 << RECENT_IO_BITS)
+
+static struct io {
+	struct hlist_node	hash;
+	struct list_head	lru;
+
+	uint64_t		key;
+	unsigned		sequential;
+} recent_io[RECENT_IO];
+
+static struct hlist_head recent_io_hash[RECENT_IO + 1];
+static LIST_HEAD(recent_io_lru);
+static spinlock_t recent_io_lock;
+static spinlock_t barrier_lock;
+
+static struct kobject		*bcache_kobj;
+/*
+ * We need a real search key, or something
+ * static struct gendisk	*devices[UUIDS_PER_SB];
+ */
+static char			uuids[UUIDS_PER_SB*16];
+static struct cached_dev	*devices[UUIDS_PER_SB];
+
+static LIST_HEAD(cache_devices);
+static LIST_HEAD(open_buckets);
+/*
+ * want c99
+static DEFINE_SPINLOCK(open_bucket_lock);
+static DECLARE_WAIT_QUEUE_HEAD(pending);
+*/
+static spinlock_t open_bucket_lock;
+static wait_queue_head_t pending;
+
+static struct workqueue_struct *delayed;
+
+/*
+ * Sysfs vars / tunables
+ */
+static unsigned long cache_hits, cache_misses;
+static uint16_t	initial_priority = 32768;
+static uint16_t cache_hit_priority = 100, cache_hit_seek = 100;
+static unsigned long sequential_cutoff = 1 << 20, sectors_bypassed;
+static unsigned flush_delay_ms = 10, flush_delay_ms_sync = 4;
+static unsigned latency_warn_ms = 500, writeback_delay = 30;
+static bool synchronous = true;
+
+static DEFINE_PER_CPU(unsigned long, btree_write_count);
+static DEFINE_PER_CPU(unsigned long, keys_write_count);
+
+static struct kmem_cache *search_cache, *dirty_cache;
+
+static void submit_bio_list(int rw, struct bio *bio);
+static void check_bio(struct bio *bio);
+static struct bio *__btree_write(struct btree *b);
+static int btree_bsearch(struct bkey **, uint64_t);
+static void btree_clean(struct btree *, struct bkey **, uint64_t);
+static bool do_fixup(bool, uint64_t, struct bkey *);
+static bool fixup_old_keys(struct btree *b, struct bkey *k, int write);
+static void btree_gc(struct work_struct *);
+static bool in_writeback(struct cached_dev *, struct bkey *);
+static void read_dirty(struct cached_dev *);
+static void bio_complete(struct search *);
+static struct bio *save_priorities(struct cache *);
+static struct bio *write_super(struct cache *, struct search *);
+static void unregister_cache(struct kobject *);
+static int request_read(struct request_queue *, struct bio *,
+			bool, struct search *);
+
+#define label(l, foo)	if (0) { l: foo; }
+
+#define PAGE_SECTORS		(PAGE_SIZE / 512)
+#define pages(c, s)							\
+	(((sizeof(s) * c->sb.nbuckets) - 1) / PAGE_SIZE + 1)
+
+#define pages_per_bucket(b)	((b)->c->sb.bucket_size / PAGE_SECTORS)
+#define pages_per_btree		(c->sb.bucket_size / PAGE_SECTORS)
+#define keys_per_page		(PAGE_SIZE / sizeof(struct bkey))
+#define btree_prio		((uint16_t) ~0)
+
+#define bucket(c, s)		((c)->buckets + sector_to_bucket(c, s))
+
+#define bucket_to_sector(c, b)						\
+	(((sector_t) (b) + c->sb.first_bucket) << c->bucket_size_bits)
+
+#define sector_to_bucket(c, s)						\
+	((long) (s >> c->bucket_size_bits) - c->sb.first_bucket)
+
+#define data(b)		((struct bkey **) (b)->pages + pages_per_bucket(b))
+#define keys(i)		(((struct btree_node_header *) *(i))->nkeys)
+#define rand(i)		(((struct btree_node_header *) *(i))->random)
+#define index(i, b)	((int) (i - data(b)))
+#define last_key(i)	(node(i, keys(i))->key)
+
+#define keys_can_fit(i, b)						\
+	((pages_per_bucket(b) - index(i, b)) * keys_per_page - 1)
+
+/*
+ * key: 8 bit device, 56 bit offset
+ * value: 40 bit offset, 1 bit dirty, 15 bit len, 8 bit gen
+ * All units are in sectors
+ */
+
+#define _KEY_DEV(k)		((int) ((k) >> 56))
+#define KEY_DEV(k)		((int) ((k)->key >> 56))
+#define KEY_OFFSET(k)		((k)->key & ~((int64_t) ~0 << 56))
+#define TREE_KEY(dev, offset)	(((uint64_t) dev) << 56 | (offset))
+#define KEY_START(k)		((k)->key - PTR_SIZE(k))
+
+#define PTR_OFFSET(k)		((int64_t) (((k)->ptr) >> 24))
+#define PTR_SIZE(k)		((unsigned) ((k)->ptr >> 8) & ~(~0 << 15))
+#define PTR_GEN(k)		((uint8_t) ((k)->ptr & ~(~0 << 8)))
+
+#define PTR_DIRTY_BIT		((uint64_t) (1 << 23))
+#define PTR_DIRTY(k)		((k)->ptr &   PTR_DIRTY_BIT)
+#define PTR_SET_DIRTY(k)	((k)->ptr |=  PTR_DIRTY_BIT)
+#define PTR_CLEAR_DIRTY(k)	((k)->ptr &= ~PTR_DIRTY_BIT)
+
+#define TREE_PTR(gen, length, offset)					\
+	((uint64_t) (offset) << 24 | (length) << 8 | (gen))
+
+#define PTR_BUCKET(b, ptr)	bucket(b->c, PTR_OFFSET(ptr))
+#define bucket_to_ptr(b)						\
+	TREE_PTR(bucket(b->c, b->offset)->gen, 0, b->offset)
+
+#define bucket_key(b)							\
+	(struct bkey) { .key = last_key(data(b)), .ptr = bucket_to_ptr(b) }
+
+static void ptr_set_dirty(struct cache *c, struct bkey *k)
+{
+	long b = sector_to_bucket(c, PTR_OFFSET(k));
+
+	spin_lock(&c->bucket_lock);
+	BUG_ON(c->buckets[b].heap != -1);
+	c->buckets[b].dirty = true;
+	c->garbage[b].mark = GC_MARK_DIRTY;
+	spin_unlock(&c->bucket_lock);
+}
+
+static inline struct bkey *node(struct bkey *d[], int i)
+{
+	return d[i / keys_per_page] + (i % keys_per_page);
+}
+
+static inline void rw_lock(bool w, struct btree *b)
+{
+	w ? down_write_nested(&b->lock, b->level + 1)
+	  : down_read_nested(&b->lock, b->level + 1);
+	smp_rmb();
+}
+
+static inline void rw_unlock(bool w, struct btree *b)
+{
+	if (b->write) {
+		long delay = b->expires - jiffies;
+		if (delay > 0)
+			queue_delayed_work(delayed, &b->w, delay);
+		else if (!atomic_xchg(&b->writes_outstanding, 1))
+			submit_bio_list(WRITE, __btree_write(b));
+	}
+
+	smp_wmb();
+	w ? up_write(&b->lock) : up_read(&b->lock);
+}
+
+struct keyprint_hack {
+	char s[40];
+};
+
+static struct keyprint_hack _pkey(const struct bkey *k)
+{
+	struct keyprint_hack r;
+	snprintf(r.s, 40, "%llu -> %llu len %i gen %i%s",
+		KEY_OFFSET(k), PTR_OFFSET(k), PTR_SIZE(k), PTR_GEN(k),
+		PTR_DIRTY(k) ? " dirty" : "");
+	return r;
+}
+
+#define pkey(k)		(_pkey(k).s)
+
+static bool bio_reinit(struct bio *bio)
+{
+	if (atomic_cmpxchg(&bio->bi_remaining, 0, 1))
+		return false;
+
+	bio_get(bio);
+	bio->bi_next		= NULL;
+	bio->bi_flags		= 1 << BIO_UPTODATE;
+	bio->bi_rw		= 0;
+	bio->bi_idx		= 0;
+	bio->bi_phys_segments	= 0;
+	bio->bi_size		= 0;
+	bio->bi_seg_front_size	= 0;
+	bio->bi_seg_back_size	= 0;
+	bio->bi_comp_cpu	= -1;
+	return true;
+}
+
+static void submit_bio_list(int rw, struct bio *bio)
+{
+	while (bio) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+		struct bio *split, *next = bio->bi_next;
+		bio->bi_next = NULL;
+
+		do {
+			int n = bio_get_nr_vecs(bio->bi_bdev) * PAGE_SECTORS;
+			struct bio_vec *bv = bio->bi_io_vec + bio->bi_idx;
+
+			struct bvec_merge_data bvm = {
+				.bi_bdev = bio->bi_bdev,
+				.bi_sector = bio->bi_sector,
+				.bi_size = bio->bi_size,
+				.bi_rw = bio->bi_rw,
+			};
+			WARN_ON(n <= 0);
+
+			if (q->merge_bvec_fn)
+				n = min(n, q->merge_bvec_fn(q, &bvm, bv) << 9);
+			n = max_t(int, n, bv->bv_len >> 9);
+
+			if (!(split = bio_split_front(bio, n, NULL))) {
+				bio_endio(bio, -ENOMEM);
+				return;
+			}
+			check_bio(split);
+			submit_bio(rw, split);
+		} while (split != bio);
+
+		bio = next;
+	}
+}
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
+static int lookup_id(struct cache *c, int id)
+{
+	int dev;
+	for (dev = 0; dev < UUIDS_PER_SB; dev++)
+		if (c->devices[dev] == id)
+			break;
+
+	if (dev == UUIDS_PER_SB)
+		printk(KERN_DEBUG "bcache: unknown device %i\n", id);
+
+	return dev;
+}
+
+static int lookup_dev(struct cache *c, struct bio *bio)
+{	return lookup_id(c, bio->bi_bdev->bd_cache_identifier); }
+
+static void run_search(struct work_struct *w)
+{
+	struct search *s = container_of(w, struct search, w);
+	search_fn *f = NULL;
+	swap(f, s->end_fn);
+	atomic_set(&s->remaining, 1);
+	s->wait_time = jiffies;
+	f(s);
+}
+
+static void put_search(struct search *s, bool noqueue)
+{
+	int ms = jiffies_to_msecs(jiffies - s->wait_time);
+	if (ms > latency_warn_ms && printk_ratelimit())
+		printk(KERN_DEBUG "bcache: %pf was waiting for %pf for %i ms\n",
+		       s->end_fn, __builtin_return_address(0), ms);
+again:
+	if (!atomic_dec_and_test(&s->remaining))
+		return;
+
+	BUG_ON(object_is_on_stack(s));
+	BUG_ON(s->flags & SEARCH_WAITING);
+
+	if (!s->end_fn) {
+		struct search *p = s->parent;
+#ifdef DEBUG_SEARCH
+		unsigned long flags;
+		spin_lock_irqsave(&search_lock, flags);
+		list_del(&s->all);
+		spin_unlock_irqrestore(&search_lock, flags);
+#endif
+		kmem_cache_free(search_cache, s);
+		s = p;
+		if (s)
+			goto again;
+	} else if (noqueue || s->end_fn == bio_complete)
+		run_search(&s->w);
+	else
+		BUG_ON(!queue_work(delayed, &s->w));
+}
+
+#define return_f(s, f, ...) do {				\
+	if ((s) && !object_is_on_stack(s)) {			\
+		(s)->end_fn = f;				\
+		put_search(s, !current->bio_list);		\
+	}							\
+	return __VA_ARGS__;					\
+} while (0)
+
+#define run_wait_list(condition, list) do {			\
+	smp_mb();						\
+	if (condition) {					\
+		struct search *_s, *_next;			\
+		for (_s = xchg(&(list), NULL); _s; _s = _next) {\
+			_next = _s->next;			\
+			_s->flags &= ~SEARCH_WAITING;		\
+			SET_WAITING(_s, NULL);			\
+			put_search(_s, false);			\
+			if (_s->flags & SEARCH_BLOCK)		\
+				wake_up(&pending);		\
+		}						\
+	}							\
+} while (0)
+
+#define wait_search(list, s) do {				\
+	BUG_ON(((s)->flags & SEARCH_BLOCK));			\
+	BUG_ON(object_is_on_stack(s));				\
+	if (!((s)->flags & SEARCH_WAITING)) {			\
+		atomic_inc(&(s)->remaining);			\
+		smp_mb__after_atomic_inc();			\
+		(s)->flags |= SEARCH_WAITING;			\
+		SET_WAITING(s, __func__);			\
+		lockless_list_push(s, list, next);		\
+	}							\
+} while (0)
+
+#define wait_on_search(condition, list, s) ({			\
+	if (!(condition) &&					\
+	    !IS_ERR(s = alloc_search(s)) &&			\
+	    !((s)->flags & SEARCH_WAITING)) {			\
+		atomic_inc(&(s)->remaining);			\
+		smp_mb__after_atomic_inc();			\
+		(s)->flags |= SEARCH_WAITING;			\
+		SET_WAITING(s, __func__);			\
+		lockless_list_push(s, list, next);		\
+		if ((s)->flags & SEARCH_BLOCK)			\
+			wait_event(pending, condition);		\
+		run_wait_list(condition, list);			\
+	}							\
+	s; })
+
+static struct search *alloc_search(struct search *s)
+{
+	struct search *r = s;
+	if (!s ||
+	    (object_is_on_stack(s) && !(s->flags & SEARCH_BLOCK))) {
+		r = kmem_cache_alloc(search_cache, __GFP_ZERO|GFP_NOIO);
+		if (!r)
+			return ERR_PTR(-ENOMEM);
+
+		if (s)
+			*r = *s;
+
+		atomic_set(&r->remaining, 1);
+		r->wait_time = jiffies;
+		INIT_WORK(&r->w, run_search);
+		INIT_LIST_HEAD(&r->barrier);
+#ifdef DEBUG_SEARCH
+		spin_lock_irq(&search_lock);
+		list_add(&r->all, &searches);
+		spin_unlock_irq(&search_lock);
+#endif
+	} else if (s && !(s->flags & SEARCH_BLOCK))
+		BUG_ON(!atomic_read(&(s)->remaining));
+	return r;
+}
+
+static struct search *alloc_child_search(struct search *s)
+{
+	struct search *r = alloc_search(NULL);
+	if (!IS_ERR(r)) {
+		atomic_inc(&s->remaining);
+		r->parent = s;
+	}
+	return r;
+}
+
+static int realloc_keys(struct search *s)
+{
+	if (s->nkeylist == 3)
+		s->keylist = kmalloc(sizeof(*s->keylist) * 8, GFP_NOIO);
+	else if (s->nkeylist > 4 &&
+		 is_power_of_2(s->nkeylist))
+		s->keylist = krealloc(s->keylist,
+				      sizeof(*s->keylist) * s->nkeylist * 2,
+				      GFP_NOIO);
+
+	if (!s->keylist)
+		return -ENOMEM;
+
+	if (s->nkeylist == 3)
+		memcpy(s->keylist, s->new_keys, sizeof(*s->keylist) * 3);
+
+	return 0;
+}
+
+static void push_key(struct search *s, struct bkey k)
+{
+	s->new_keys[s->nkeys++] = k;
+}
+
+static void queue_gc(struct cache *c)
+{
+	if (down_trylock(&c->gc_lock))
+		return;
+
+	c->sectors_to_gc = c->sb.bucket_size * c->sb.nbuckets / 8;
+
+	pr_debug("starting gc, need_gc %i", c->need_gc);
+	PREPARE_WORK(&c->work, btree_gc);
+	queue_work(delayed, &c->work);
+}
+
+static uint8_t __inc_bucket_gen(struct cache *c, long i)
+{
+	struct bucket *b = c->buckets + i;
+	uint8_t ret = ++b->gen;
+	BUG_ON(b->dirty);
+
+	c->need_gc = max_t(uint8_t, c->need_gc, ret - b->last_gc);
+	if (c->need_gc > 64)
+		queue_gc(c);
+
+	return ret;
+}
+
+static uint8_t inc_bucket_gen(struct cache *c, long b)
+{
+	uint8_t ret;
+	spin_lock(&c->bucket_lock);
+	ret = __inc_bucket_gen(c, b);
+	spin_unlock(&c->bucket_lock);
+	return ret;
+}
+
+#define inc_gen(b, o)	inc_bucket_gen((b)->c, sector_to_bucket((b)->c, o))
+
+static void rescale_heap(struct cache *c, int sectors)
+{
+	spin_lock(&c->bucket_lock);
+	c->rescale -= sectors;
+	if (c->rescale <= 0) {
+		struct bucket *b;
+		for (b = c->buckets; b < c->buckets + c->sb.nbuckets; b++)
+			if (b->priority &&
+			    b->priority != btree_prio &&
+			    !atomic_read(&b->pin))
+				b->priority--;
+
+		c->rescale += c->sb.bucket_size * c->sb.nbuckets / 128;
+	}
+	spin_unlock(&c->bucket_lock);
+}
+
+static void bucket_add_heap(struct cache *c, long i)
+{
+	struct bucket *b = c->buckets + i;
+
+	if (b->priority != btree_prio &&
+	    !b->dirty &&
+	    !atomic_read(&b->pin)) {
+		BUG_ON(c->garbage[i].mark < GC_MARK_DIRTY);
+		BUG_ON(i == sector_to_bucket(c, c->sb.btree_root));
+		heap_add(&c->heap, b, heap, bucket_cmp);
+	}
+}
+
+static void free_some_buckets(struct cache *c)
+{
+	long pop(uint16_t p)
+	{
+		struct bucket *b;
+		long r;
+
+		if (!c->heap.size) {
+			queue_gc(c);
+			printk(KERN_WARNING "bcache: heap empty!\n");
+			return -1;
+		}
+
+		/* On cache hit, priority is increased but we don't readjust
+		 * the heap so as not to take the lock there - hence the heap
+		 * isn't necessarily a heap. This mostly works provided priority
+		 * only goes up - later we won't keep the full heap around
+		 * which will be better.
+		 */
+		heap_sift(&c->heap, 0, heap, bucket_cmp);
+		b = heap_peek(&c->heap);
+		r = b - c->buckets;
+
+		__inc_bucket_gen(c, r);
+
+		smp_mb();
+		if (atomic_read(&b->pin)) {
+			c->pops_pinned++;
+			return -1;
+		}
+
+		c->pops_pinned = 0;
+		heap_pop(&c->heap, heap, bucket_cmp);
+		b->priority = p;
+		atomic_inc(&b->pin);
+
+		if (c->discard) {
+			spin_unlock(&c->bucket_lock);
+			/* should do this asynchronously */
+			blkdev_issue_discard(c->bdev, bucket_to_sector(c, r),
+					     c->sb.bucket_size, GFP_NOIO, 0);
+			spin_lock(&c->bucket_lock);
+		}
+		return r;
+	}
+
+	long r;
+
+	if (!synchronous ||
+	    atomic_read(&c->prio_written)) {
+		c->free_resized = false;
+		fifo_move(&c->btree, &c->btree_inc);
+		fifo_move(&c->free, &c->free_inc);
+
+		if (fifo_empty(&c->free_inc) ||
+		    fifo_empty(&c->btree_inc))
+			atomic_set(&c->prio_written, 0);
+	}
+
+	if (synchronous &&
+	    (atomic_read(&c->prio_written) ||
+	     atomic_read(&c->priority_bio->bi_remaining)))
+		return;
+
+	if (fifo_used(&c->free) < c->free.size / 2 ||
+	    fifo_used(&c->btree) < c->btree.size / 2) {
+		while (!fifo_full(&c->btree_inc) &&
+		       ((r = pop(btree_prio)) != -1))
+			fifo_push(&c->btree_inc, r);
+
+		while (!fifo_full(&c->free_inc) &&
+		       ((r = pop(initial_priority)) != -1))
+			fifo_push(&c->free_inc, r);
+
+		if (c->heap.size * 8 < c->sb.nbuckets)
+			queue_gc(c);
+
+		if (synchronous &&
+		    fifo_full(&c->btree_inc) &&
+		    fifo_full(&c->free_inc)) {
+			struct bio *bio = save_priorities(c);
+			if (bio && !current->bio_list) {
+				spin_unlock(&c->bucket_lock);
+				submit_bio_list(WRITE, bio);
+				spin_lock(&c->bucket_lock);
+			} else if (bio)
+				schedule_work(&c->priority_work);
+		}
+	}
+}
+
+static void resize_free_buckets(struct cache *c, uint64_t priority)
+{
+	DECLARE_FIFO(long, free) = { 0, 0, 0, NULL };
+	DECLARE_FIFO(long, inc) = { 0, 0, 0, NULL };
+	size_t size = priority == btree_prio
+		? c->btree.size
+		: c->free.size;
+
+	if (!c->free_resized && size < c->sb.nbuckets >> 7) {
+		spin_unlock(&c->bucket_lock);
+		init_fifo(&free, size * 2, GFP_NOIO);
+		init_fifo(&inc, size * 2, GFP_NOIO);
+		spin_lock(&c->bucket_lock);
+	}
+
+	if (free.data && inc.data) {
+		if (priority == btree_prio &&
+		    size == c->btree.size) {
+			fifo_move(&free, &c->btree);
+			fifo_swap(&free, &c->btree);
+
+			fifo_move(&inc, &c->btree_inc);
+			fifo_swap(&inc, &c->btree_inc);
+		} else if (priority != btree_prio &&
+			   size == c->free.size) {
+			fifo_move(&free, &c->free);
+			fifo_swap(&free, &c->free);
+
+			fifo_move(&inc, &c->free_inc);
+			fifo_swap(&inc, &c->free_inc);
+		}
+		c->free_resized = true;
+	}
+	free_fifo(&free);
+	free_fifo(&inc);
+}
+
+static long pop_bucket(struct cache *c, uint16_t priority, struct search *s)
+{
+	long r = -1;
+again:
+	free_some_buckets(c);
+
+	if ((priority == btree_prio)
+	    ? fifo_pop(&c->btree, r)
+	    : fifo_pop(&c->free, r)) {
+		struct bucket *b = c->buckets + r;
+#ifdef EDEBUG
+		long i;
+		fifo_for_each(i, &c->free)
+			BUG_ON(i == r);
+		fifo_for_each(i, &c->btree)
+			BUG_ON(i == r);
+#endif
+		BUG_ON(atomic_read(&b->pin) != 1);
+		BUG_ON(b->heap != -1);
+		BUG_ON(b->priority != priority);
+		BUG_ON(b->dirty);
+
+		c->garbage[r].mark = priority == btree_prio
+			? GC_MARK_BTREE
+			: c->sb.bucket_size;
+		return r;
+	}
+
+	pr_debug("no free buckets available for %s, "
+		 "pops_pinned %i, in flight %i",
+		 priority == btree_prio ? "btree" : "data",
+		 c->pops_pinned,
+		 atomic_read(&c->priority_bio->bi_remaining));
+
+	resize_free_buckets(c, priority);
+
+	if (s && s->flags & SEARCH_BLOCK) {
+		spin_unlock(&c->bucket_lock);
+		wait_on_search(!atomic_read(&c->priority_bio->bi_remaining),
+			       c->bucket_wait, s);
+		spin_lock(&c->bucket_lock);
+		goto again;
+	} else if (s)
+		wait_search(c->bucket_wait, s);
+
+	return -1;
+}
+
+#define run_on_root(write, c, f, ...)					\
+({									\
+	int _r = -2;							\
+	do {								\
+		struct btree *_b = c->root;				\
+		bool _w = (write);					\
+		rw_lock(_w, _b);					\
+		if (_b->offset == c->sb.btree_root &&			\
+		    _w == (write))					\
+			_r = f(_b, __VA_ARGS__);			\
+		else							\
+			rw_unlock(_w, _b);				\
+		cpu_relax();						\
+	} while (_r == -2);						\
+	_r;								\
+})
+
+#define sorted_set_checks(i, b)						\
+({									\
+	bool _cont = true;						\
+	if (index(i, b) >= pages_per_bucket(b))				\
+		_cont = false;						\
+	else if (rand(i) != rand(data(b)))				\
+		_cont = false;						\
+	else if (keys(i) > keys_can_fit(i, b)) {			\
+		printk(KERN_WARNING "bcache: %s() "			\
+		       "bad btree header: bucket %lu, page %i, %i keys\n",\
+		       __func__, sector_to_bucket((b)->c, (b)->offset),	\
+		       index(i, b), keys(i));				\
+		keys(i) = 0;						\
+		if (i != data(b)) {					\
+			_cont = false;					\
+			rand(i) = 0;					\
+		}							\
+	}								\
+	_cont;								\
+})
+
+#define next_set(i)	(keys(i) / keys_per_page + 1)
+
+#define __for_each_sorted_set(_init, start, _i, b)			\
+	for (_init = data(b) + start;					\
+	     sorted_set_checks(_i, b);					\
+	     _i += next_set(_i))
+
+#define for_each_sorted_set(i, b)					\
+	__for_each_sorted_set(i, 0, i, b)
+
+#define for_each_key(b, iter)						\
+	__for_each_sorted_set(struct bkey **_i, 0, _i, b)		\
+		for (int _j = 1; iter = node(_i, _j), _j < keys(_i) + 1; _j++)
+
+#define __for_good_keys(b, i, iter, start, end)				\
+	for (int _j = start;						\
+	     ({ _j = next_good_key(i, _j, b); iter = node(i, _j);	\
+	      _j <= end; });						\
+	     _j++)
+
+#define for_each_good_key(b, iter)					\
+	__for_each_sorted_set(struct bkey **_i, 0, _i, b)		\
+		__for_good_keys(b, _i, iter, 1, keys(_i))
+
+#define for_good_keys_after(b, i, iter,  _search)			\
+	__for_good_keys(b, i, iter, btree_bsearch(i, _search), keys(i))
+
+#define for_each_good_key_after(b, iter, _search)			\
+	__for_each_sorted_set(struct bkey **_i, 0, _i, b)		\
+		for_good_keys_after(b, _i, iter, _search)
+
+static bool ptr_status(struct btree *b, struct bkey *k, char *buf)
+{
+	sector_t bucket = PTR_OFFSET(k) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(k) & ~(~0 << b->c->bucket_size_bits);
+	uint8_t stale = 0;
+
+	*buf = 0;
+	if (!k->key || !PTR_OFFSET(k))
+		strcpy(buf, "bad, null key");
+	if (bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets)
+		strcpy(buf, "bad, offset past end of device");
+	if (bucket <  b->c->sb.first_bucket)
+		strcpy(buf, "bad, short offset");
+	if (b->level && (PTR_SIZE(k) || r))
+		strcpy(buf, "bad, nonzero size/offset into bucket");
+	if (PTR_SIZE(k) + r > b->c->sb.bucket_size)
+		strcpy(buf, "bad, length too big");
+	if (!b->level && !PTR_SIZE(k))
+		strcpy(buf, "zeroed key");
+
+	if (!*buf)
+		stale = PTR_BUCKET(b, k)->gen - PTR_GEN(k);
+	if (stale)
+		sprintf(buf, "stale %i", stale);
+	return *buf;
+}
+
+static bool __ptr_bad(struct btree *b, struct bkey *k)
+{
+	sector_t bucket = PTR_OFFSET(k) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(k) & ~(~0 << b->c->bucket_size_bits);
+
+	if ((b->level && r) ||
+	    (!b->level == !PTR_SIZE(k)) ||
+	    bucket <  b->c->sb.first_bucket ||
+	    bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets ||
+	    PTR_SIZE(k) + r > b->c->sb.bucket_size) {
+		if (PTR_SIZE(k)) {
+			char buf[30];
+			ptr_status(b, k, buf);
+			printk(KERN_WARNING "bad key %s: %s\n", pkey(k), buf);
+		}
+		return true;
+	}
+	return false;
+}
+
+static bool ptr_bad(struct btree *b, struct bkey *k)
+{
+	if (!k->key || __ptr_bad(b, k))
+		return true;
+
+	if ((int8_t) (PTR_GEN(k) - PTR_BUCKET(b, k)->gen) < 0) {
+		BUG_ON(PTR_DIRTY(k) && PTR_SIZE(k));
+		return true;
+	}
+
+	if (b->level) {
+		BUG_ON(PTR_BUCKET(b, k)->priority != btree_prio);
+		BUG_ON(PTR_BUCKET(b, k)->heap != -1);
+	} else if (PTR_DIRTY(k)) {
+		BUG_ON(!PTR_BUCKET(b, k)->dirty);
+		BUG_ON(PTR_BUCKET(b, k)->heap != -1);
+	}
+	return false;
+}
+
+static int next_good_key(struct bkey *i[], int j, struct btree *b)
+{
+	while (j <= keys(i) && ptr_bad(b, node(i, j)))
+		j++;
+	return j;
+}
+
+static void dump_bucket_and_panic(struct btree *b)
+{
+	struct bkey *k, *prev = NULL;
+
+	for_each_key(b, k) {
+		char buf[30];
+		int priority = -1;
+		long bucket = sector_to_bucket(b->c, PTR_OFFSET(k));
+
+		if (bucket >= 0 && bucket < b->c->sb.nbuckets)
+			priority = b->c->buckets[bucket].priority;
+
+		if (_j > 1 && prev->key > KEY_START(k))
+			printk(KERN_ERR "Key skipped backwards\n");
+
+		ptr_status(b, k, buf);
+		printk(KERN_ERR
+		       "page %i key %i/%i: key %s bucket %li prio %i %s\n",
+		       index(_i, b), _j, keys(_i), pkey(k),
+		       sector_to_bucket(b->c, PTR_OFFSET(k)), priority, buf);
+		prev = k;
+	}
+	panic("at offset %llu bucket %li",
+	      (uint64_t) b->offset, sector_to_bucket(b->c, b->offset));
+}
+
+static void dump_key_and_panic(struct btree *b, struct bkey *i[], int j)
+{
+	sector_t bucket = PTR_OFFSET(node(i, j)) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(node(i, j)) & ~(~0 << b->c->bucket_size_bits);
+
+	printk(KERN_ERR "level %i page %i key %i/%i: %s "
+	       "bucket %llu offset %li into bucket\n",
+	       b->level, index(i, b), j, keys(i), pkey(node(i, j)),
+	       (uint64_t) bucket, r);
+	dump_bucket_and_panic(b);
+}
+
+#ifdef EDEBUG
+
+static void check_bio(struct bio *bio)
+{
+	int i, size = 0;
+	struct bio_vec *bv;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	BUG_ON(!bio->bi_vcnt);
+	BUG_ON(!bio->bi_size);
+
+	bio_for_each_segment(bv, bio, i)
+		size += bv->bv_len;
+
+	BUG_ON(size != bio->bi_size);
+	BUG_ON(size > queue_max_sectors(q) << 9);
+
+	blk_recount_segments(q, bio);
+	BUG_ON(bio->bi_phys_segments > queue_max_segments(q));
+}
+
+static int count_data(struct btree *b)
+{
+	int ret = 0;
+	struct bkey *k;
+
+	for_each_good_key(b, k)
+		ret += PTR_SIZE(k);
+	return ret;
+}
+
+#define DUMP_KEY_BUG_ON(condition, b, i, j, ...) do {	\
+	if (condition) {				\
+		printk(KERN_ERR __VA_ARGS__);		\
+		dump_key_and_panic(b, i, j);		\
+	}						\
+} while (0)
+
+static void check_key_order(struct btree *b, struct bkey *i[])
+{
+	for (int j = 2; j <= keys(i); j++)
+		if (node(i, j - 1)->key > KEY_START(node(i, j)))
+			dump_bucket_and_panic(b);
+}
+
+static void check_overlapping_keys(struct btree *b, struct bkey *i[])
+{
+	struct bkey **c;
+	check_key_order(b, i);
+
+	for (int m = 1; m < keys(i); m++)
+		for_each_sorted_set(c, b) {
+			if (c >= i)
+				break;
+
+			for (int j = 1; j < keys(c); j++)
+				if (PTR_SIZE(node(c, j)) &&
+				    PTR_SIZE(node(i, m)) &&
+				    ((node(i, m)->key >= node(c, j)->key &&
+				      KEY_START(node(i, m)) < node(c, j)->key)
+				     || (node(c, j)->key >= node(i, m)->key &&
+				      KEY_START(node(c, j)) < node(i, m)->key)))
+					dump_key_and_panic(b, i, j);
+		}
+}
+
+#define atomic_dec_bug(i)	BUG_ON(atomic_dec_return(i) < 0)
+
+#else /* EDEBUG */
+
+static void check_bio(struct bio *bio)
+{ }
+
+#define count_data(b)					0
+#define check_overlapping_keys(b, i)			do {} while (0)
+#define check_overlapping_key(b, k)			do {} while (0)
+#define DUMP_KEY_BUG_ON(condition, b, i, j, ...)	BUG_ON(condition)
+#define check_key_order(b, i)				do {} while (0)
+#define atomic_dec_bug(i)				atomic_dec(i)
+
+#endif
+
+static bool should_split(struct btree *b, struct bkey *i[])
+{
+	return index(i, b) >= pages_per_bucket(b) ||
+		(rand(i) == rand(data(b)) &&
+		 keys(i) + 3 > keys_can_fit(i, b));
+}
+
+static void free_bucket_contents(struct btree *b, bool alive)
+{
+	BUG_ON(b->wait || b->write);
+	b->written = 0;
+
+	if (!b->pages[0])
+		return;
+#if 0
+	if (!alive) {
+		struct address_space *mapping = b->pages[0]->mapping;
+
+		spin_lock_irq(&mapping->tree_lock);
+		for (int i = 0; i < pages_per_bucket(b); i++)
+			__remove_from_page_cache(b->pages[i]);
+		spin_unlock_irq(&mapping->tree_lock);
+	}
+#endif
+	for (int i = 0; i < pages_per_bucket(b); i++) {
+		if (alive)
+			mark_page_accessed(b->pages[i]);
+
+		put_page(b->pages[i]);
+		b->pages[i] = NULL;
+		b->pages[i + pages_per_bucket(b)] = NULL;
+	}
+}
+
+static void fill_bucket_work(struct work_struct *w)
+{
+	struct btree *b = container_of(w, struct btree, fill);
+	struct bkey **i;
+	int sets = 0, ms;
+
+	for_each_sorted_set(i, b)
+		check_key_order(b, i);
+
+	for_each_sorted_set(i, b) {
+		if (keys(i))
+			sets++;
+
+		if (i != data(b))
+			for (int j = 1; j <= keys(i); j++)
+				fixup_old_keys(b, node(i, j), INSERT_FILL);
+
+		b->written = index(i, b);
+	}
+	b->written = index(i, b);
+
+	for_each_sorted_set(i, b)
+		check_key_order(b, i);
+
+	for (i = data(b) + b->written; index(i, b) < pages_per_bucket(b); i++)
+		BUG_ON(rand(i) == rand(data(b)));
+
+	if (sets > 5)
+		btree_clean(b, data(b), 0);
+
+	ms = jiffies_to_msecs(jiffies - b->jiffies);
+	if (ms > 1000)
+		printk(KERN_WARNING "bcache: fill_bucket took %i ms", ms);
+
+	smp_wmb(); /* b->nread is our write lock */
+	atomic_set(&b->nread, pages_per_bucket(b));
+	run_wait_list(1, b->wait);
+}
+
+static void fill_bucket_endio(struct bio *bio, int error)
+{
+	/* XXX: flag error here
+	 */
+	struct btree *b = bio->bi_private;
+
+	BUG_ON(error);
+
+	bio_put(bio);
+	BUG_ON(!schedule_work(&b->fill));
+}
+
+static int fill_bucket(struct btree *b, struct search **s)
+{
+	struct cache *c = b->c;
+	int i, nread = 0;
+
+	/*nread = find_get_pages(c->bdev->bd_inode->i_mapping,
+			       (b->offset >> (PAGE_SHIFT - 9)),
+			       pages_per_bucket(b), b->pages);*/
+
+	for (i = 0; i < pages_per_bucket(b); i++) {
+		b->pages[i] = find_get_page(c->bdev->bd_inode->i_mapping,
+					    b->offset / PAGE_SECTORS + i);
+
+		if (!b->pages[i]) {
+			b->pages[i] = __page_cache_alloc(GFP_NOIO);
+			b->pages[i]->mapping = c->bdev->bd_inode->i_mapping;
+			if (add_to_page_cache_lru(b->pages[i],
+						  c->bdev->bd_inode->i_mapping,
+						  b->offset / PAGE_SECTORS + i,
+						  GFP_NOIO)) {
+				/* This code path should never happen anymore
+				 * since fill_bucket is now called with write
+				 * lock held on bucket
+				 */
+				WARN(1, "fill_bucket race");
+				page_cache_release(b->pages[i]);
+				goto err;
+			}
+
+			unlock_page(b->pages[i]);
+		} else
+			nread++;
+
+		data(b)[i] = page_address(b->pages[i]);
+		BUG_ON(b->offset + i * PAGE_SECTORS
+		       != page_index(b->pages[i]) * PAGE_SECTORS);
+	}
+
+	if (nread != pages_per_bucket(b)) {
+		struct bio_vec *bv;
+		struct bio *bio = bio_kmalloc(GFP_NOIO, pages_per_bucket(b));
+		if (!bio)
+			goto err;
+
+		b->jiffies	= jiffies;
+		bio->bi_sector	= b->offset;
+		bio->bi_bdev	= c->bdev;
+		bio->bi_vcnt	= pages_per_bucket(b);
+		bio->bi_size	= pages_per_bucket(b) * PAGE_SIZE;
+		bio->bi_private = b;
+		bio->bi_end_io	= fill_bucket_endio;
+
+		bio_for_each_segment(bv, bio, i) {
+			bv->bv_page = b->pages[i];
+			bv->bv_len = PAGE_SIZE;
+			bv->bv_offset = 0;
+		}
+
+		submit_bio_list(READ_SYNC|BIO_RW_META, bio);
+	} else {
+		struct bkey **j;
+		for_each_sorted_set(j, b)
+			check_key_order(b, j);
+		b->written = index(j, b);
+
+		atomic_set(&b->nread, nread);
+	}
+
+	return 0;
+err:
+	/* XXX: flag error on this bucket here */
+	return -1;
+}
+
+static void btree_write_endio(struct bio *bio, int error)
+{
+	int n, ms;
+	struct btree_write *w = bio->bi_private;
+	struct bio_vec *bv;
+
+	ms = jiffies_to_msecs(jiffies - w->wait_time);
+	if (w->wait_time && ms > latency_warn_ms && printk_ratelimit())
+		printk(KERN_DEBUG "bcache: btree write finished in %i ms\n", ms);
+
+	BUG_ON(error);
+	run_wait_list(1, w->wait);
+
+	__bio_for_each_segment(bv, bio, n, 0)
+		put_page(bv->bv_page);
+
+	if (w->b) {
+		long delay = w->b->expires - jiffies;
+		atomic_set(&w->b->writes_outstanding, 0);
+		if (w->b->write)
+			queue_delayed_work(delayed, &w->b->w,
+					   delay > 0 ? delay : 0);
+	}
+	kfree(w);
+}
+
+static struct bio *__btree_write(struct btree *b)
+{
+	int n, ms, keys = 0;
+	struct bio *bio;
+	struct bio_vec *bv;
+	struct btree_write *w = xchg(&b->write, NULL);
+
+	if (!w) {
+		/* We raced, first saw b->write before the write was
+		 * started, but the write has already completed.
+		 */
+		atomic_set(&b->writes_outstanding, 0);
+		return NULL;
+	}
+
+	__cancel_delayed_work(&b->w);
+	ms = jiffies_to_msecs(jiffies - w->wait_time);
+	if (w->wait_time && ms > latency_warn_ms && printk_ratelimit())
+		printk(KERN_DEBUG "bcache: btree write was waiting for "
+		       "%pf for %i ms before started\n",
+		       __builtin_return_address(0), ms);
+	w->wait_time = jiffies;
+
+	check_key_order(b, data(b) + b->written);
+	bio = &w->bio;
+
+	pr_debug("bucket %li level %i pages %i-%i %i keys",
+		 sector_to_bucket(b->c, b->offset), b->level,
+		 bio->bi_idx, bio->bi_vcnt, keys(data(b) + b->written));
+
+	bio_for_each_segment(bv, bio, n)
+		memcpy(page_address(bv->bv_page),
+		       b->pages[n + b->written], PAGE_SIZE);
+
+	__for_each_sorted_set(struct bkey **i, b->written, i, b)
+		keys += keys(i);
+
+	if (b->written) {
+		percpu_inc(btree_write_count);
+		percpu_add(keys_write_count, keys);
+	}
+
+	n = bio->bi_vcnt - bio->bi_idx;
+	b->c->btree_sectors_written += n * PAGE_SECTORS;
+	b->written += n;
+
+	return bio;
+}
+
+static void btree_write_work(struct work_struct *w)
+{
+	struct btree *b = container_of(to_delayed_work(w), struct btree, w);
+	int ms;
+
+	if (!down_read_trylock(&b->lock))
+		return;
+
+	if (!b->write)
+		goto out;
+
+	if (time_before(jiffies, b->expires)) {
+		queue_delayed_work(delayed, &b->w, b->expires - jiffies);
+		goto out;
+	}
+
+	ms = jiffies_to_msecs(jiffies - b->expires);
+	if (ms > latency_warn_ms && printk_ratelimit())
+		printk(KERN_DEBUG
+		       "bcache: btree_write_work was waiting for %i ms\n", ms);
+
+	if (!atomic_xchg(&b->writes_outstanding, 1))
+		submit_bio_list(WRITE, __btree_write(b));
+out:
+	up_read(&b->lock);
+}
+
+static void btree_write(struct btree *b, int skip, struct search *s)
+{
+	/* XXX: make when an explicit parameter, get rid of skip?  */
+	int j, n = 0, when = s && s->delay ? s->delay : 0;
+	struct bio_vec *bv;
+	struct bio *bio;
+
+	BUG_ON(!b->pages[0]);
+	BUG_ON(b->written == pages_per_bucket(b) && b->write);
+
+	if (skip == -1 ||
+	    (keys(&data(b)[skip]) + 1) % keys_per_page == 0)
+		when = 0;
+
+	__for_each_sorted_set(struct bkey **i, b->written, i, b)
+		n = index(i, b) + next_set(i);
+
+	if (!n)
+		return;
+
+	if (!b->write) {
+		b->write = kzalloc(sizeof(struct btree_write) +
+				   sizeof(struct bio_vec) *
+				   pages_per_bucket(b) * 2, GFP_NOIO);
+		if (!b->write)
+			goto err;
+
+		b->expires = jiffies + msecs_to_jiffies(30000);
+		b->write->b = b;
+
+		bio = &b->write->bio;
+		bio_init(bio);
+
+		bio->bi_sector	   = b->offset + b->written * PAGE_SECTORS;
+		bio->bi_bdev	   = b->c->bdev;
+		bio->bi_flags	  |= BIO_POOL_NONE << BIO_POOL_OFFSET;
+		bio->bi_rw	   = WRITE_SYNC|BIO_RW_META;
+
+		bio->bi_idx	   = pages_per_bucket(b);
+		bio->bi_max_vecs   = pages_per_bucket(b) * 2;
+		bio->bi_io_vec	   = bio->bi_inline_vecs;
+
+		bio->bi_end_io	   = btree_write_endio;
+		bio->bi_private	   = b->write;
+
+		if (b->level)
+			bio->bi_rw |= (1 << BIO_RW_BARRIER);
+
+		for (j = 0; j < pages_per_bucket(b); j++) {
+			get_page(b->pages[j]);
+			bio->bi_io_vec[j].bv_page = b->pages[j];
+			bio->bi_io_vec[j].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[j].bv_offset = 0;
+		}
+
+		for (; j < pages_per_bucket(b) * 2; j++) {
+			bio->bi_io_vec[j].bv_page = NULL;
+			bio->bi_io_vec[j].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[j].bv_offset = 0;
+		}
+	}
+
+	b->write->bio.bi_vcnt = pages_per_bucket(b) + n - b->written;
+	b->write->bio.bi_size = PAGE_SIZE * (n - b->written);
+
+	bio_for_each_segment(bv, &b->write->bio, n)
+		if (!bv->bv_page)
+			bv->bv_page = alloc_page(GFP_NOIO);
+
+	bio_for_each_segment(bv, &b->write->bio, n)
+		if (!bv->bv_page)
+			goto err;
+
+	if ((when > 0 && !synchronous) || when == -1)
+		return;
+
+	if (!b->write->wait_time)
+		b->write->wait_time = jiffies;
+
+	when = msecs_to_jiffies(when);
+	if (time_before(jiffies + when, b->expires))
+		b->expires = jiffies + when;
+
+	if (when > 0)
+		wait_search(b->write->wait, s->parent);
+
+	if (!when &&
+	    !atomic_xchg(&b->writes_outstanding, 1))
+		submit_bio_list(WRITE, __btree_write(b));
+	else if (timer_pending(&b->w.timer))
+		mod_timer_pending(&b->w.timer, b->expires);
+	else
+		queue_delayed_work(delayed, &b->w, when);
+	return;
+err:
+	BUG();
+}
+
+static struct btree *alloc_bucket(struct cache *c, struct btree **n, int level,
+				  sector_t offset, int count)
+{
+	struct btree *b;
+	struct bio *bio = NULL;
+
+	list_for_each_entry_reverse(b, &c->lru, lru)
+		if (count-- < c->btree_buckets_cached)
+			break;
+		else if (atomic_read(&b->nread) == pages_per_btree &&
+			 down_write_trylock(&b->lock)) {
+			smp_rmb();
+			if (atomic_read(&b->writes_outstanding)) {
+				up_write(&b->lock);
+				continue;
+			}
+			BUG_ON(b->wait);
+			list_del(&b->lru);
+			goto found;
+		}
+
+	if (n && *n)
+		b = *n, *n = NULL;
+	else {
+		spin_unlock(&c->bucket_lock);
+		b = kzalloc(sizeof(*b) + sizeof(void *) *
+			    pages_per_btree * 2, GFP_NOIO);
+		if (!b)
+			return ERR_PTR(-ENOMEM);
+
+		init_rwsem(&b->lock);
+		INIT_WORK(&b->fill, fill_bucket_work);
+		INIT_DELAYED_WORK(&b->w, btree_write_work);
+		b->c = c;
+
+		if (n) {
+			*n = b;
+			return NULL;
+		}
+		spin_lock(&c->bucket_lock);
+	}
+	BUG_ON(!down_write_trylock(&b->lock));
+found:
+	if (b->write) {
+		b->write->b = NULL;
+		bio = __btree_write(b);
+	}
+
+	if (b->pages[0])
+		__for_each_sorted_set(struct bkey **i, b->written, i, b)
+			BUG();
+
+	b->offset = offset;
+	b->level = level;
+
+	list_add(&b->lru, &c->lru);
+
+	atomic_set(&b->nread, 0);
+	free_bucket_contents(b, true);
+	spin_unlock(&c->bucket_lock);
+
+	submit_bio_list(WRITE, bio);
+
+	return b;
+}
+
+static struct btree *__get_bucket(struct cache *c, sector_t offset, int level,
+				  bool write, struct search **s)
+{
+	int i;
+	struct btree *b, *n = NULL;
+retry:
+	if (bucket(c, offset)->priority != btree_prio)
+		goto freed;
+
+	i = 0;
+	spin_lock(&c->bucket_lock);
+	list_for_each_entry(b, &c->lru, lru) {
+		if (offset == b->offset) {
+			list_move(&b->lru, &c->lru);
+			spin_unlock(&c->bucket_lock);
+
+			rw_lock(write, b);
+
+			if (offset == b->offset)
+				goto out;
+
+			rw_unlock(write, b);
+			goto retry;
+		}
+		i++;
+	}
+
+	b = alloc_bucket(c, &n, level, offset, i);
+	if (!b)
+		goto retry;
+	if (IS_ERR(b))
+		goto err;
+
+	if (fill_bucket(b, s)) {
+		/* pages don't point to the right place */
+		free_bucket_contents(b, false);
+		rw_unlock(true, b);
+		run_wait_list(1, b->wait);
+		goto err;
+	}
+
+	if (!write)
+		downgrade_write(&b->lock);
+out:
+	if (IS_ERR(wait_on_search(atomic_read(&b->nread) == pages_per_bucket(b),
+				  b->wait, *s))) {
+		rw_unlock(write, b);
+		goto err;
+	}
+
+	if (bucket(c, offset)->priority == btree_prio) {
+		BUG_ON(bucket(c, offset)->heap != -1);
+		if (atomic_read(&b->nread) != pages_per_bucket(b)) {
+			rw_unlock(write, b);
+			b = ERR_PTR(-EAGAIN);
+		}
+		goto real_out;
+	}
+
+	rw_unlock(write, b);
+freed:
+	pr_debug("bucket %llu has been freed, gen %i, called from %pf",
+		 (uint64_t) offset, bucket(c, offset)->gen,
+		 __builtin_return_address(1));
+	b = NULL;
+	goto real_out;
+err:
+	printk(KERN_WARNING "bcache: error allocating memory\n");
+	b = ERR_PTR(-ENOMEM);
+real_out:
+	kfree(n);
+	return b;
+}
+
+static struct btree *get_bucket(struct btree *b, struct bkey *k,
+				bool write, struct search **s)
+{
+	struct btree *r;
+	BUG_ON(!b->level);
+	r = __get_bucket(b->c, PTR_OFFSET(k), b->level - 1, write, s);
+	if (!IS_ERR_OR_NULL(r)) {
+		if (ptr_bad(b, k)) {
+			pr_debug("pointer now bad");
+			rw_unlock(write, r);
+			return NULL;
+		}
+
+		BUG_ON(r->level + 1 != b->level);
+	}
+	return r;
+}
+
+static void btree_free(struct btree *b)
+{
+	struct cache *c = b->c;
+	long n = sector_to_bucket(c, b->offset);
+	BUG_ON(n < 0 || n > c->sb.nbuckets);
+	BUG_ON(c->buckets[n].priority != btree_prio);
+	BUG_ON(b == c->root);
+
+	pr_debug("bucket %li gen %i sector %llu", n,
+		 c->buckets[n].gen, (uint64_t) b->offset);
+
+	spin_lock(&c->bucket_lock);
+	__inc_bucket_gen(c, n);
+
+	/* This isn't correct, the caller needs to add the wait list
+	 * to the wait list for the new bucket's write.
+	 */
+	if (b->write) {
+		run_wait_list(1, b->write->wait);
+		kfree(b->write);
+		b->write = NULL;
+	}
+
+	//if (!fifo_push(&c->btree, n))
+	{
+		c->buckets[n].priority = 0;
+		c->garbage[n].mark = 0;
+		bucket_add_heap(c, n);
+	}
+
+	free_bucket_contents(b, false);
+
+	if (list_empty(&b->lru))
+		list_add_tail(&b->lru, &c->lru);
+
+	spin_unlock(&c->bucket_lock);
+	run_wait_list(1, b->wait);
+
+	if (b->written && b->c->discard)
+		blkdev_issue_discard(c->bdev, b->offset,
+				     c->sb.bucket_size, GFP_NOIO, 0);
+}
+
+static struct btree *btree_alloc(struct cache *c, int level, struct search *s)
+{
+	long i = 0, bucket;
+	struct btree *b = NULL;
+	const char *err = "unable to alloc bucket";
+
+	spin_lock(&c->bucket_lock);
+	bucket = pop_bucket(c, btree_prio, s);
+	if (bucket == -1) {
+		spin_unlock(&c->bucket_lock);
+		return ERR_PTR(-EAGAIN);
+	}
+	BUG_ON(c->buckets[bucket].priority != btree_prio);
+
+	list_for_each_entry(b, &c->lru, lru)
+		i++;
+
+	b = alloc_bucket(c, NULL, level, bucket_to_sector(c, bucket), i);
+	if (IS_ERR_OR_NULL(b))
+		goto err;
+	BUG_ON(b->written);
+
+	err = "error adding new pages";
+	for (i = 0; i < pages_per_btree; i++) {
+		b->pages[i] = find_or_create_page(c->bdev->bd_inode->i_mapping,
+						  b->offset / PAGE_SECTORS + i,
+						  GFP_NOIO);
+		if (!b->pages[i])
+			goto err;
+
+		unlock_page(b->pages[i]);
+		b->pages[i + pages_per_btree] = page_address(b->pages[i]);
+
+		BUG_ON(b->offset / PAGE_SECTORS + i != page_index(b->pages[i]));
+	}
+
+	atomic_set(&b->nread, pages_per_btree);
+
+	get_random_bytes(&rand(data(b)), sizeof(uint64_t));
+	keys(data(b)) = 0;
+
+	pr_debug("bucket %li gen %i sector %llu for %pf",
+		 bucket, c->buckets[bucket].gen, (uint64_t) b->offset,
+		 __builtin_return_address(0));
+
+	return b;
+err:
+	printk(KERN_WARNING "bcache: btree_alloc: %s\n", err);
+	if (!IS_ERR_OR_NULL(b)) {
+		btree_free(b);
+		up_write(&b->lock);
+	} else {
+		spin_lock(&c->bucket_lock);
+		//if (!fifo_push(&c->btree, bucket))
+		{
+			c->buckets[bucket].priority = 0;
+			c->garbage[bucket].mark = 0;
+			bucket_add_heap(c, bucket);
+		}
+		spin_unlock(&c->bucket_lock);
+	}
+	atomic_dec_bug(&c->buckets[bucket].pin);
+	return NULL;
+}
+
+static void set_new_root(struct btree *b, struct search *s, bool nowrite)
+{
+	struct bio *bio = NULL;
+	struct cache *c = b->c;
+	BUG_ON(bucket(c, b->offset)->priority != btree_prio);
+	BUG_ON(!rand(data(b)));
+
+	spin_lock(&c->bucket_lock);
+	list_del_init(&b->lru);
+	c->sb.btree_level = b->level;
+	c->sb.btree_root = b->offset;
+	c->root = b;
+	atomic_dec_bug(&bucket(c, c->root->offset)->pin);
+
+	if (!nowrite)
+		bio = write_super(c, s);
+	spin_unlock(&c->bucket_lock);
+	submit_bio_list(WRITE, bio);
+
+	pr_debug("new root %lli called from %pf", c->sb.btree_root,
+		 __builtin_return_address(0));
+}
+
+static void cache_hit(struct cache *c, struct bio *list)
+{
+	long b;
+	struct bio *bio;
+
+	if (!list)
+		return;
+
+	spin_lock(&c->bucket_lock);
+	for (bio = list; bio; bio = bio->bi_next) {
+		bio->bi_bdev = c->bdev;
+		if (bio->bi_next)
+			bio->bi_rw &= ~(1 << BIO_RW_UNPLUG);
+
+		b = sector_to_bucket(c, bio->bi_sector);
+		BUG_ON(c->buckets[b].priority == btree_prio);
+		c->buckets[b].priority = (long) initial_priority;
+			/* * (cache_hit_seek + cache_hit_priority
+			 * bio_sectors(bio) / c->sb.bucket_size)
+			/ (cache_hit_seek + cache_hit_priority);*/
+#if 0
+		if (c->buckets[b].heap != -1)
+			bucket_add_heap(c, b);
+#endif
+		c->rescale -= bio_sectors(bio);
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
+		smp_mb__before_atomic_dec();
+		atomic_dec_bug(&bucket(c, s)->pin);
+	}
+
+	if (c->rescale < 0)
+		rescale_heap(c, 0);
+}
+
+static int btree_bsearch(struct bkey *i[], uint64_t search)
+{
+	/* Returns the smallest key greater than the search key.
+	 * This is because we index by the end, not the beginning
+	 */
+	int l = 1, r = keys(i) + 1;
+
+	while (l < r) {
+		int m = (l + r) >> 1;
+		if (node(i, m)->key > search)
+			r = m;
+		else
+			l = m + 1;
+	}
+
+	return l;
+}
+
+static int btree_search(struct btree *b, int dev, struct bio_list *hits,
+			uint64_t after, struct search *s)
+{
+	int ret = -1;
+	struct bkey *k, **i, **reverse;
+	struct bio *bio, *split;
+	struct bio_list done = { NULL, NULL };
+
+	for_each_sorted_set(reverse, b)
+		;
+	do {
+		for (i = data(b);
+		     i + next_set(i) < reverse;
+		     i += next_set(i))
+			;
+		reverse = i;
+
+		bio_list_init(&done);
+		while ((bio = bio_list_pop(&s->misses))) {
+			uint64_t search = TREE_KEY(dev, bio->bi_sector);
+			uint64_t a = max(after, search);
+
+			if (search + bio_sectors(bio) <= after) {
+				bio_list_add(&done, bio);
+				continue;
+			}
+
+			for_good_keys_after(b, i, k, a) {
+				int len = max(KEY_START(k), a) - search;
+				if (k->key <= a)
+					continue;
+
+				if (search + bio_sectors(bio) <= KEY_START(k))
+					break;
+
+				if (len > 0) {
+					split = bio_split_front(bio, len, NULL);
+					if (!split)
+						goto err;
+					bio_list_add(&done, split);
+					search = TREE_KEY(dev, bio->bi_sector);
+				}
+
+				pr_debug("page %i: key %s",
+					 index(i, b), pkey(k));
+
+				atomic_inc(&PTR_BUCKET(b, k)->pin);
+				smp_mb__after_atomic_inc();
+
+				if (PTR_BUCKET(b, k)->gen != PTR_GEN(k)) {
+					atomic_dec_bug(&PTR_BUCKET(b, k)->pin);
+					continue;
+				}
+
+				DUMP_KEY_BUG_ON(PTR_BUCKET(b, k)->priority ==
+						btree_prio, b, i, _j);
+
+				split = bio_split_front(bio, k->key - search,
+							NULL);
+				if (!split) {
+					atomic_dec_bug(&PTR_BUCKET(b, k)->pin);
+					goto err;
+				}
+
+				split->bi_sector += PTR_SIZE(k)
+					- KEY_OFFSET(k) + PTR_OFFSET(k);
+
+				bio_list_add(hits, split);
+
+				pr_debug("cache hit of %i sectors from %llu, "
+					 "need %i sectors", bio_sectors(split),
+					 (uint64_t) split->bi_sector,
+					 split == bio ? 0 : bio_sectors(bio));
+
+				if (split == bio)
+					goto next;
+				a = search = TREE_KEY(dev, bio->bi_sector);
+			}
+			bio_list_add(&done, bio);
+next:			bio = bio;
+		}
+		swap(s->misses, done);
+	} while (i != data(b));
+
+	label(err,	ret = -1);
+	rw_unlock(false, b);
+
+	while ((bio = bio_list_pop(&done)))
+		bio_list_add(&s->misses, bio);
+
+	return ret;
+}
+
+static int btree_search_recurse(struct btree *b, int dev, struct bio_list *hits,
+				uint64_t after, struct search *s)
+{
+	int ret = -1;
+
+	if (!b->level)
+		return btree_search(b, dev, hits, after, s);
+
+	do {
+		struct btree *r;
+		struct bkey *k, recurse = { .key = ~0, .ptr = 0 };
+		struct bio *bio = bio_list_peek(&s->misses);
+		uint64_t search = max(after, TREE_KEY(dev, bio->bi_sector));
+
+		pr_debug("level %i bucket %li searching for %llu",
+			 b->level, sector_to_bucket(b->c, b->offset), search);
+
+		for_each_good_key_after(b, k, search) {
+			if (recurse.key > k->key)
+				recurse = *k;
+			break;
+		}
+
+		if (recurse.key == ~0)
+			break;
+
+		r = get_bucket(b, &recurse, false, &s);
+		if (r == ERR_PTR(-EAGAIN))
+			goto again;
+		if (!r)
+			goto retry;
+		if (IS_ERR_OR_NULL(r))
+			goto err;
+
+		if (recurse.key >= search + bio_sectors(bio)) {
+			rw_unlock(false, b);
+			b = NULL;
+		}
+
+		ret = max(ret, btree_search_recurse(r, dev, hits, after, s));
+		after = recurse.key;
+	} while (b);
+
+	label(retry,	ret = -2);
+	label(err,	ret = -1);
+	label(again,	ret = 0);
+	if (b)
+		rw_unlock(false, b);
+	return ret;
+}
+
+static void btree_sort(struct bkey **d, size_t num)
+{
+	size_t i;
+
+	inline int64_t cmp(struct bkey *l, struct bkey *r)
+	{
+		return l->key == r->key
+			? !PTR_SIZE(l) - !PTR_SIZE(r)
+			: l->key - r->key;
+	}
+
+	inline void sift(size_t r, size_t n)
+	{
+		int c = r * 2;
+		for (; c <= n; r = c, c *= 2) {
+			if (c < n &&
+			    cmp(node(d, c), node(d, c + 1)) < 0)
+				c++;
+			if (cmp(node(d, c), node(d, r)) < 0)
+				break;
+			swap(*node(d, r), *node(d, c));
+		}
+	}
+
+	for (i = num / 2 + 1; i > 0; --i)
+		sift(i, num);
+
+	for (i = num; i > 1; sift(1, --i))
+		swap(*node(d, 1), *node(d, i));
+}
+
+static void btree_clean(struct btree *b, struct bkey **start, uint64_t smallest)
+{
+	size_t j, n, orig = 0;
+	struct bkey **i;
+	int oldsize, newsize;
+	uint64_t biggest = 0;
+
+	bool bad(struct bkey *k)
+	{
+		if (b->written)
+			return __ptr_bad(b, k);
+
+		if (smallest >= k->key)
+			return true;
+
+		if (smallest > KEY_START(k))
+			do_fixup(true, smallest, k);
+
+		return ptr_bad(b, k);
+	}
+
+	BUG_ON(b->written && smallest);
+	if (b->level)
+		smallest = 0;
+
+	oldsize = count_data(b);
+
+	for (j = 0; j < b->written; j++)
+		if (PageChecked(b->pages[j]))
+			return;
+
+	for (i = start;
+	     sorted_set_checks(i, b);
+	     i += (n / keys_per_page) + 1) {
+		if (b->written && index(i, b) >= b->written)
+			break;
+
+		biggest = max(biggest, last_key(i));
+
+		orig += n = keys(i);
+
+		if (i == start)
+			for (j = 1; j <= keys(i); j++)
+				while ((bad(node(i, j))) && j <= --keys(i))
+					*node(i, j) = *node(i, keys(i) + 1);
+		else
+			for (j = 1; j < n + 1; j++)
+				if (!bad(node(i, j)))
+					*node(start, ++keys(start)) =
+						*node(i, j);
+	}
+
+	btree_sort(start, keys(start));
+
+	if (b->written)
+		for (i = start + next_set(start);
+		     index(i, b) < b->written;
+		     i++) {
+			rand(i) = rand(start);
+			keys(i) = 0;
+		}
+	else
+		get_random_bytes(&rand(data(b)), sizeof(uint64_t));
+
+	newsize = count_data(b);
+	if (newsize < oldsize)
+		pr_debug("was %i now %i, smallest %llu, biggest %llu",
+			 oldsize, newsize, smallest, biggest);
+
+	check_key_order(b, data(b));
+	pr_debug("merged %i keys from %zu keys",
+		 keys(data(b)), orig);
+}
+
+static int btree_gc_recurse(struct btree *b, struct bkey *root,
+			    uint64_t smallest, struct search *s)
+{
+	int ret = 0, nkeys = 0;
+	long bucket;
+	struct bkey *k;
+	struct btree *n = NULL, *r;
+	struct bucket_gc *g;
+
+	for_each_key(b, k)
+		if (!__ptr_bad(b, k)) {
+			int8_t g = PTR_BUCKET(b, k)->gen - PTR_GEN(k);
+			if (g > 0)
+				ret = max_t(int, ret, g);
+			nkeys++;
+		}
+
+	if (b->written &&
+	    (b->level || ret > 10) &&
+	    (n = btree_alloc(b->c, b->level, s))) {
+		for (int j = 0; j < pages_per_bucket(b); j++)
+			memcpy(data(n)[j], data(b)[j], PAGE_SIZE);
+		swap(b, n);
+	}
+
+	if (!b->written) {
+		btree_clean(b, data(b), smallest);
+		ret = 0;
+	} else if (b->level)
+		goto err;
+
+	if (b->level) {
+		int j, need_gc;
+		struct bkey **i = data(b);
+		for (j = keys(i); j; j--) {
+			bucket = sector_to_bucket(b->c, PTR_OFFSET(node(i, j)));
+			g = &b->c->garbage[bucket];
+
+			if (ptr_bad(b, node(i, j)))
+				continue;
+
+			r = get_bucket(b, node(i, j), true, &s);
+			if (IS_ERR_OR_NULL(r))
+				goto err;
+
+			need_gc = btree_gc_recurse(r, node(i, j), j > 1
+						   ? node(i, j - 1)->key
+						   : 0, s);
+
+			if (need_gc < 0)
+				goto err;
+
+			ret = max(ret, need_gc);
+			spin_lock(&b->c->bucket_lock);
+			g->mark = GC_MARK_BTREE;
+			spin_unlock(&b->c->bucket_lock);
+		}
+
+		btree_clean(b, data(b), 0);
+	} else {
+		spin_lock(&b->c->bucket_lock);
+		for_each_good_key(b, k) {
+			bucket = sector_to_bucket(b->c, PTR_OFFSET(k));
+			g = &b->c->garbage[bucket];
+
+			if (PTR_DIRTY(k))
+				g->mark = GC_MARK_DIRTY;
+			else if (g->mark != GC_MARK_DIRTY &&
+				 (short) (g->mark + PTR_SIZE(k)) > 0)
+				g->mark += PTR_SIZE(k);
+		}
+		spin_unlock(&b->c->bucket_lock);
+	}
+
+	label(err,	ret = -1);
+
+	if (keys(data(b)) || b->written || b->c->sb.btree_level == b->level) {
+		btree_write(b, -1, NULL);
+		root->ptr = bucket_to_ptr(b);
+	} else {
+		btree_free(b);
+		root->ptr = 0;
+	}
+
+	if (n) {
+		if (b->c->sb.btree_level == b->level) {
+			BUG_ON(n != b->c->root);
+			set_new_root(b, NULL, false);
+		} else
+			atomic_dec_bug(&bucket(b->c, b->offset)->pin);
+
+		btree_free(n);
+		rw_unlock(true, n);
+	}
+	rw_unlock(true, b);
+	return ret;
+}
+
+static void btree_gc(struct work_struct *w)
+{
+	unsigned long start = jiffies;
+	long i, freed = 0, pinned = 0;
+	struct bkey root;
+	struct cache *c = container_of(w, struct cache, work);
+	struct search s = blocking_search;
+
+	for (i = 0; i < c->sb.nbuckets; i++)
+		c->garbage[i].gen = c->buckets[i].gen;
+
+	i = run_on_root(true, c, btree_gc_recurse, &root, 0, &s);
+	if (i < 0)
+		goto out;
+
+	spin_lock(&c->bucket_lock);
+	c->need_gc = i;
+	c->garbage[sector_to_bucket(c, c->root->offset)].mark = GC_MARK_BTREE;
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		struct bucket *b = c->buckets + i;
+
+		if (!atomic_read(&b->pin)) {
+			int m = c->garbage[i].mark;
+			c->garbage[i].mark = 0;
+
+			if (m != GC_MARK_DIRTY)
+				b->dirty = false;
+
+			if (m >= 0 && m < c->sb.bucket_size / 4)
+				m = 0;
+
+			if (!m && b->priority) {
+				freed++;
+				b->gen++;
+				b->priority = 0;
+				b->f = btree_gc;
+			}
+
+			if (m >= 0)
+				bucket_add_heap(c, i);
+		} else
+			pinned++;
+
+		b->last_gc = c->garbage[i].gen;
+		c->need_gc = max_t(uint8_t, c->need_gc, b->gen - b->last_gc);
+	}
+
+	spin_unlock(&c->bucket_lock);
+	pr_debug("garbage collect done in %u ms, freed %li, %li pinned, new need_gc %i",
+		 jiffies_to_msecs(jiffies - start), freed, pinned, c->need_gc);
+out:
+	up(&c->gc_lock);
+}
+
+static void shift_keys(struct bkey *i[], size_t j)
+{
+	for (int k = keys(i)++; k >= j; --k)
+		*node(i, k + 1) = *node(i, k);
+}
+
+static bool do_fixup(bool front, uint64_t where, struct bkey *k)
+{
+	struct bkey old = *k;
+	unsigned len;
+
+	if (front) {
+		if (where <= KEY_START(k))
+			return false;
+
+		BUG_ON(where > k->key);
+
+		len = where - KEY_START(k);
+		k->ptr += TREE_PTR(0, 0, len);
+	} else {
+		if (where >= k->key)
+			return false;
+
+		len = k->key - where;
+		k->key = where;
+	}
+	k->ptr -= TREE_PTR(0, min(len, PTR_SIZE(k)), 0);
+
+	pr_debug("fixing up %s of %s by %i sectors: now %s",
+		 front ? "front" : "back", pkey(&old), len, pkey(k));
+	return true;
+}
+
+static bool check_old_keys(struct btree *b, struct bkey *k, int write)
+{
+	bool bad(struct bkey *key)
+	{
+		return ptr_bad(b, key) ||
+			(write == INSERT_UNDIRTY &&
+			 key->ptr == (k->ptr | PTR_DIRTY_BIT));
+	}
+
+	int j;
+	struct bkey **i;
+
+	if (b->level ||
+	    (write != INSERT_READ &&
+	     write != INSERT_UNDIRTY))
+		return false;
+
+	for_each_sorted_set(i, b) {
+		j = btree_bsearch(i, k->key);
+
+		if (j > 1 && j <= keys(i) &&
+		    node(i, j - 1)->key > KEY_START(node(i, j)))
+			dump_key_and_panic(b, i, j);
+
+		if (j <= keys(i) && !bad(node(i, j)))
+			do_fixup(false, KEY_START(node(i, j)), k);
+
+		while (--j && node(i, j)->key > KEY_START(k))
+			if (!bad(node(i, j)))
+				do_fixup(true, node(i, j)->key, k);
+	}
+
+	return !PTR_SIZE(k);
+}
+
+static bool fixup_old_keys(struct btree *b, struct bkey *k, int write)
+{
+	bool fixup_and_dirty(bool front, struct bkey *f)
+	{
+		struct bkey old = *f;
+		uint64_t where = k->key;
+
+		if (!front)
+			where -= PTR_SIZE(k);
+
+		if (do_fixup(front, where, f)) {
+			if (write == INSERT_WRITE &&
+			    !PTR_DIRTY(k) &&
+			    PTR_OFFSET(k) &&
+			    PTR_DIRTY(&old) &&
+			    !ptr_bad(b, &old))
+				PTR_SET_DIRTY(k);
+
+			return true;
+		}
+		return false;
+	}
+
+	struct bkey **i;
+	bool ret = false;
+
+	if (b->level)
+		return false;
+
+	for_each_sorted_set(i, b) {
+		int j = btree_bsearch(i, k->key);
+
+		if (j <= keys(i)) {
+			if (write != INSERT_FILL &&
+			    KEY_START(k) > KEY_START(node(i, j))) {
+				struct bkey **e = data(b) + b->written;
+				if (i != e) {
+					int m = btree_bsearch(e, KEY_START(k));
+					shift_keys(e, m);
+
+					*node(e, m) = *node(i, j);
+					do_fixup(false, KEY_START(k),
+						 node(e, m));
+				} else
+					shift_keys(i, j++);
+			}
+
+			if (fixup_and_dirty(true, node(i, j)))
+				ret = true;
+		}
+
+		while (--j && fixup_and_dirty(false, node(i, j)))
+			ret = true;
+
+		check_key_order(b, i);
+		if (index(i, b) == b->written)
+			break;
+	}
+
+	return ret;
+}
+
+static bool btree_merge_key(struct btree *b, struct bkey *i[],
+			    size_t *j, struct bkey *k)
+{
+	bool try_merge(struct bkey *l, struct bkey *r)
+	{
+		if (l->key == KEY_START(k) &&
+		    PTR_OFFSET(l) + PTR_SIZE(l) == PTR_OFFSET(r) &&
+		    PTR_GEN(l) == PTR_GEN(r) &&
+		    PTR_DIRTY(l) == PTR_DIRTY(r) &&
+		    sector_to_bucket(b->c, PTR_OFFSET(l)) ==
+		    sector_to_bucket(b->c, PTR_OFFSET(r))) {
+			l->key += PTR_SIZE(r);
+			l->ptr += TREE_PTR(0, PTR_SIZE(r), 0);
+			*r = *l;
+			return true;
+		}
+		return false;
+	}
+
+	if (*j <= keys(i) &&
+	    !b->level &&
+	    (ptr_bad(b, node(i, *j)) ||
+	     try_merge(k, node(i, *j))))
+		return true;
+
+	if (--(*j)) {
+		if (!b->level &&
+		    (ptr_bad(b, node(i, *j)) ||
+		     try_merge(node(i, *j), k)))
+			return true;
+
+		if (b->level && k->key &&
+		    !ptr_bad(b, node(i, *j)) &&
+		    node(i, *j)->ptr == k->ptr) {
+			node(i, *j)->key = max(node(i, *j)->key, k->key);
+			return true;
+		}
+	}
+	(*j)++;
+
+	if (*j <= keys(i) && !b->level && !PTR_SIZE(node(i, *j)))
+		return true;
+	return false;
+}
+
+static bool btree_insert_keys(struct btree *b, struct search *s)
+{
+	/* There's a couple races that are best handled here.
+	 *
+	 * If a read generates a cache miss, and a write to the same location
+	 * finishes before the new data is added to the cache, the write will
+	 * be overwritten with stale data. We can catch this by never
+	 * overwriting good data if it came from a read.
+	 *
+	 * Dirty data in the cache may be queued to write out; if we do a
+	 * writethrough write to a location that has dirty data, the queued
+	 * write could finish after the writethrough write, thus overwriting
+	 * good data with stale on the cached device. This we can handle easiest
+	 * by marking keys as dirty if they came from a write, and they
+	 * overwrite dirty data.
+	 *
+	 * When we write out dirty data, we have to mark it as no longer dirty.
+	 * The easy way to do this would be just clearing the dirty flag on the
+	 * original key and reinserting it, and the old version will no longer
+	 * be used, the same way a key that points to stale data would be.
+	 *
+	 * However, the data may have been redirtied, so when called from
+	 * write_dirty_finish we must only insert if we can still find the
+	 * original dirty key.
+	 */
+	bool ret = false;
+	struct bkey **i = data(b) + b->written;
+	for_each_sorted_set(i, b)
+		BUG_ON(index(i, b) > b->written);
+	i = data(b) + b->written;
+
+	while (s->nkeys) {
+		size_t m;
+		const char *status = "replacing";
+		struct bkey *k = &s->new_keys[--s->nkeys];
+		char buf[30];
+
+		BUG_ON(!b->level && !k->key);
+		BUG_ON(index(i, b) < b->written);
+
+		if (check_old_keys(b, k, s->write)) {
+			if (s->write == INSERT_UNDIRTY)
+				b->c->writeback_keys_failed++;
+			continue;
+		} else if (s->write == INSERT_UNDIRTY)
+			b->c->writeback_keys_done++;
+
+		if (!fixup_old_keys(b, k, s->write) && !PTR_OFFSET(k))
+			continue;
+
+		m = btree_bsearch(i, k->key);
+
+		if (!btree_merge_key(b, i, &m, k)) {
+			status = "inserting";
+			if (b->level)
+				k->ptr = TREE_PTR(inc_gen(b, PTR_OFFSET(k)),
+						  0, PTR_OFFSET(k));
+
+			shift_keys(i, m);
+		}
+
+		*node(i, m) = *k;
+		ret = true;
+
+		if (PTR_DIRTY(k))
+			ptr_set_dirty(b->c, k);
+
+		BUG_ON(!ptr_bad(b, k) &&
+		       !b->level == (PTR_BUCKET(b, k)->priority == btree_prio));
+
+		if ((b->level && k->key) ||
+		    (!b->level && PTR_OFFSET(k) &&
+		     s->write != INSERT_UNDIRTY))
+			atomic_dec_bug(&PTR_BUCKET(b, k)->pin);
+
+		if ((!b->level || k->key) &&
+		    PTR_OFFSET(k) &&
+		    ptr_status(b, k, buf))
+			printk(KERN_DEBUG
+			       "%s bad key: write %i level %i key %s %s\n",
+			       status, s->write, b->level, pkey(k), buf);
+
+		if (s->write != INSERT_READ)
+			pr_debug("%s at %llu level %i page %i key %zu/%i: %s",
+				 status, (uint64_t) b->offset, b->level,
+				 index(i, b), m, keys(i), pkey(k));
+	}
+	check_overlapping_keys(b, i);
+	return ret;
+}
+
+static int btree_split(struct btree *b, struct search *s)
+{
+	struct btree *n1, *n2 = NULL, *n3 = NULL;
+
+	n1 = btree_alloc(b->c, b->level, s);
+	if (IS_ERR_OR_NULL(n1))
+		goto err;
+
+	for (int i = 0; i < pages_per_bucket(b); i++)
+		memcpy(data(n1)[i], data(b)[i], PAGE_SIZE);
+
+	btree_clean(n1, data(n1), 0);
+
+	if (keys(data(n1)) < keys_per_page * pages_per_bucket(b) / 2) {
+		pr_debug("not splitting: %i keys", keys(data(n1)));
+
+		btree_insert_keys(n1, s);
+
+		if (b == b->c->root)
+			set_new_root(n1, s->parent, false);
+	} else {
+		pr_debug("splitting at level %i of %i sector %llu nkeys %i",
+			 b->level, b->c->sb.btree_level,
+			 (uint64_t) b->offset, keys(data(n1)));
+
+		n2 = btree_alloc(b->c, b->level, s);
+		if (IS_ERR_OR_NULL(n2))
+			goto err;
+
+		if (b == b->c->root) {
+			n3 = btree_alloc(b->c, b->level + 1, s);
+			if (IS_ERR_OR_NULL(n3))
+				goto err;
+		}
+
+		btree_insert_keys(n1, s);
+
+		keys(data(n2)) = keys(data(n1)) >> 1;
+		keys(data(n1)) -= keys(data(n2));
+
+		for (int i = 1; i <= keys(data(n2)); i++)
+			*node(data(n2), i) =
+				*node(data(n1), keys(data(n1)) + i);
+
+		push_key(s, bucket_key(n2));
+		btree_write(n2, -1, NULL);
+		BUG_ON(!n2->written);
+		rw_unlock(true, n2);
+	}
+
+	push_key(s, bucket_key(n1));
+	btree_write(n1, -1, NULL);
+	BUG_ON(!n1->written);
+	rw_unlock(true, n1);
+
+	if (n3) {
+		btree_insert_keys(n3, s);
+		btree_write(n3, -1, NULL);
+
+		BUG_ON(!n3->written);
+		set_new_root(n3, s->parent, false);
+		rw_unlock(true, n3);
+	}
+
+	push_key(s, (struct bkey) { .key = 0, .ptr = bucket_to_ptr(b)});
+	btree_free(b);
+	return 0;
+err:
+	if (!IS_ERR_OR_NULL(n2)) {
+		atomic_dec_bug(&bucket(b->c, n2->offset)->pin);
+		btree_free(n2);
+		rw_unlock(true, n2);
+	}
+	if (!IS_ERR_OR_NULL(n1)) {
+		atomic_dec_bug(&bucket(b->c, n1->offset)->pin);
+		btree_free(n1);
+		rw_unlock(true, n1);
+	}
+
+	if (n3 == ERR_PTR(-EAGAIN) ||
+	    n2 == ERR_PTR(-EAGAIN) ||
+	    n1 == ERR_PTR(-EAGAIN))
+		return -1;
+	printk(KERN_WARNING "bcache: couldn't split");
+	return -3;
+}
+
+static int btree_insert(struct btree *b, struct search *s)
+{
+	bool must_sort = false;
+	int sets = 0, keys = 0;
+	struct bkey **i = data(b) + b->written;
+
+	if (should_split(b, i)) {
+		if (s->lock < b->c->sb.btree_level) {
+			s->lock = b->c->sb.btree_level;
+			return -2;
+		}
+		return btree_split(b, s);
+	}
+
+	if (rand(i) != rand(data(b))) {
+		rand(i) = rand(data(b));
+		keys(i) = 0;
+	}
+
+	if (btree_insert_keys(b, s))
+		btree_write(b, index(i, b), s);
+	else
+		btree_write(b, index(i, b), NULL);
+
+	for_each_sorted_set(i, b) {
+		keys += keys(i);
+		if (keys(i))
+			sets++;
+	}
+
+	if (sets > 5)
+		must_sort = true;
+
+	if (sets > 3)
+		for_each_sorted_set(i, b) {
+			if (--sets < 2)
+				break;
+
+			if (keys(i) * 2 < keys || keys < 100) {
+				btree_clean(b, i, 0);
+				return 0;
+			}
+			keys -= keys(i);
+		}
+
+	if (must_sort)
+		btree_clean(b, data(b), 0);
+
+	return 0;
+}
+
+#define insert_lock(s, l)	((l) <= max((s)->level, (s)->lock))
+
+static int btree_insert_recurse(struct btree *b, struct search *s)
+{
+	int j, ret = 0;
+	struct btree *r;
+	bool write = insert_lock(s, b->level), embiggening = false;
+
+	if (!rand(data(b))) {
+		printk(KERN_WARNING "bcache: btree was trashed, "
+		       "bucket %li gen %i level %i/%i, h->nkeys %i\n",
+		       sector_to_bucket(b->c, b->offset),
+		       bucket(b->c, b->offset)->gen,
+		       b->level, b->c->sb.btree_level, keys(data(b)));
+trashed:
+		if (write && b->c->sb.btree_level == b->level) {
+			r = btree_alloc(b->c, 0, s);
+			if (r == ERR_PTR(-EAGAIN))
+				goto again;
+			if (!r)
+				goto err;
+			set_new_root(r, NULL, false);
+			rw_unlock(true, r);
+		}
+
+		if (write)
+			btree_free(b);
+		else
+			s->lock = b->level;
+		goto retry;
+	}
+
+	if (b->level > s->level) {
+		uint64_t search = KEY_START(s->new_keys);
+		struct bkey **i, *k, recurse = { .key = 0, .ptr = 0 };
+
+		for_each_sorted_set(i, b) {
+			j = btree_bsearch(i, search);
+			j = next_good_key(i, j, b);
+
+			while (j &&
+			       (j > keys(i) || ptr_bad(b, node(i, j))))
+				--j;
+
+			/* Pick the smallest key to recurse on that's bigger
+			 * than the key we're inserting, or failing that,
+			 * the biggest key.
+			 */
+			if (j &&
+			    ((node(i, j)->key > recurse.key &&
+			      recurse.key <= search) ||
+			     (node(i, j)->key < recurse.key &&
+			      node(i, j)->key > search)))
+				recurse = *node(i, j);
+		}
+
+		if (!recurse.ptr) {
+			printk(KERN_DEBUG "no key to recurse on trying to "
+			       "insert %llu at level %i of %i for %i\n",
+			       s->new_keys->key, b->level,
+			       b->c->sb.btree_level, s->write);
+			goto trashed;
+		}
+
+		if (s->new_keys->key > recurse.key) {
+			if (s->write == INSERT_UNDIRTY)
+				goto done;
+
+			if (s->write == INSERT_READ)
+				for_each_good_key_after(b, k, recurse.key) {
+					do_fixup(false,
+						 recurse.key, s->new_keys);
+					goto get;
+				}
+
+			if (should_split(b, data(b) + b->written) &&
+			    s->lock < b->c->sb.btree_level) {
+				s->lock = b->c->sb.btree_level;
+				goto retry;
+			}
+
+			s->lock = max(s->lock, b->level);
+			if (!write)
+				goto retry;
+
+			for_each_good_key_after(b, k, recurse.key)
+				if (k->key <= s->new_keys->key)
+					inc_gen(b, PTR_OFFSET(k));
+				else {
+					if (s->write == INSERT_WRITE &&
+					    in_writeback(s->d, s->new_keys))
+						PTR_SET_DIRTY(s->new_keys);
+					break;
+				}
+
+			recurse.key = s->new_keys->key;
+			embiggening = true;
+		}
+get:
+		r = get_bucket(b, &recurse, insert_lock(s, b->level - 1), &s);
+		if (r == ERR_PTR(-EAGAIN))
+			goto again;
+		if (IS_ERR(r))
+			goto err;
+		if (!r) {
+			pr_debug("retrying because got no bucket");
+			goto retry;
+		}
+
+		ret = btree_insert_recurse(r, s);
+
+		if (ret >= 0) {
+			s->level = b->level;
+			/* Set the new key from btree_split correctly */
+			s->new_keys[0].key = recurse.key;
+			if (!s->nkeys && embiggening) {
+				atomic_inc(&PTR_BUCKET(b, &recurse)->pin);
+				push_key(s, recurse);
+			}
+		}
+	}
+
+	if (b->level == s->level && s->nkeys) {
+		BUG_ON(!write);
+		ret = btree_insert(b, s);
+	}
+
+done:
+	label(err,	ret = -3);
+	label(retry,	ret = -2);
+	label(again,	ret = -1);
+	if (!IS_ERR_OR_NULL(b))
+		rw_unlock(write, b);
+	return ret;
+}
+
+static void btree_insert_async(struct search *s)
+{
+	int ret;
+	struct bkey stack_keylist[3];
+
+	s->flags |= SEARCH_BLOCK;
+	if (s->keylist == s->new_keys) {
+		s->keylist = stack_keylist;
+		memcpy(s->keylist, s->new_keys, sizeof(struct bkey) * 3);
+	}
+
+	while (1) {
+		if (!s->nkeys) {
+			struct list_head *n = &s->cur->list;
+			if (!s->cur ||
+			    list_is_last(&s->cur->list, &cache_devices)) {
+				if (!s->nkeylist--)
+					break;
+
+				n = &cache_devices;
+			}
+			s->cur = list_first_entry(n, struct cache, list);
+
+			s->new_keys[0] = s->keylist[s->nkeylist];
+			s->nkeys = 1;
+			s->level = 0;
+			s->lock  = 0;
+
+			if (s->cur != s->q)
+				s->new_keys->ptr =
+					TREE_PTR(0, PTR_SIZE(s->new_keys), 0);
+		}
+
+		ret = run_on_root(insert_lock(s, _b->level),
+				  s->cur, btree_insert_recurse, s);
+
+		if (ret == -3)
+			printk(KERN_WARNING
+			       "bcache: out of memory trying to insert key\n");
+
+		BUG_ON(ret == -1);
+		if (ret == -1)
+			return_f(s, btree_insert_async);
+		s->nkeys = 0;
+	}
+
+	if (s->keylist != stack_keylist)
+		kfree(s->keylist);
+
+	return_f(s, NULL);
+}
+
+static int btree_invalidate(struct bio *bio, struct search *t)
+{
+	int size = bio_sectors(bio);
+	uint64_t key = TREE_KEY(bio->bi_bdev->bd_cache_identifier,
+				bio->bi_sector);
+	struct search *s = alloc_child_search(t);
+
+	if (IS_ERR(s))
+		goto err;
+
+	pr_debug("invalidating %i sectors from %llu, bi_idx %i, bio %p",
+	       bio_sectors(bio), (uint64_t) bio->bi_sector, bio->bi_idx, bio);
+
+	s->delay = t->delay;
+	s->write = INSERT_WRITE;
+	s->keylist = s->new_keys;
+
+	while (size) {
+		int len = min(size, 1 << 14);
+		if (realloc_keys(s))
+			goto err;
+
+		key	+= len;
+		size	-= len;
+		s->keylist[s->nkeylist++] = (struct bkey)
+		{ .key = key, .ptr = TREE_PTR(0, len, 0) };
+	}
+
+	return_f(s, btree_insert_async, 1);
+err:
+	return_f(s, NULL, 0);
+}
+
+static void dirty_bio_alloc(struct dirty *w)
+{
+	struct bio_vec *bv;
+	int i = (PTR_SIZE(&w->key) - 1) / PAGE_SECTORS + 1;
+
+	w->bio = bio_kmalloc(GFP_KERNEL, i);
+	bio_set_prio(w->bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
+	w->bio->bi_vcnt		= i;
+	w->bio->bi_size		= PTR_SIZE(&w->key) << 9;
+	w->bio->bi_private	= w;
+
+	bio_for_each_segment(bv, w->bio, i) {
+		bv->bv_len = PAGE_SIZE;
+		bv->bv_offset = 0;
+	}
+
+	w->bio->bi_io_vec[w->bio->bi_vcnt - 1].bv_len =
+		((PTR_SIZE(&w->key) - 1) % PAGE_SECTORS + 1) << 9;
+}
+
+static int dirty_cmp(struct dirty *r, struct dirty *l)
+{
+	/* Overlapping keys must compare equal */
+	if (KEY_START(&r->key) >= l->key.key)
+		return 1;
+	if (KEY_START(&l->key) >= r->key.key)
+		return -1;
+	return 0;
+}
+
+static bool insert_dirty(struct cached_dev *d, struct dirty *i)
+{
+	if (RB_INSERT(&d->dirty, i, node, dirty_cmp)) {
+		kmem_cache_free(dirty_cache, i);
+		return false;
+	}
+	return true;
+}
+
+static int refill_dirty(struct btree *b, struct cached_dev *d, uint64_t search,
+			sector_t *upto, int *count, struct search *s)
+{
+	int ret = 1;
+	struct bkey *k;
+	struct btree *r;
+	struct dirty *i;
+
+	if (b->level)
+		while (ret == 1) {
+			struct bkey recurse = { ~0, 0 };
+			for_each_good_key_after(b, k, search)
+				if (k->key < recurse.key)
+					recurse = *k;
+
+			if (!recurse.ptr ||
+			    KEY_DEV(&recurse) != _KEY_DEV(search))
+				break;
+
+			r = get_bucket(b, &recurse, false, &s);
+			if (IS_ERR_OR_NULL(r))
+				goto err;
+
+			ret = refill_dirty(r, d, search, upto, count, s);
+
+			search = recurse.key;
+			if (*count > 500)
+				ret = 0;
+		}
+	else
+		for_each_good_key_after(b, k, search) {
+			if (KEY_DEV(k) != _KEY_DEV(search))
+				break;
+
+			if (!PTR_DIRTY(k))
+				continue;
+
+			i = kmem_cache_alloc(dirty_cache, GFP_NOIO);
+			if (!i)
+				goto err;
+
+			pr_debug("%s", pkey(k));
+			i->key = *k;
+			i->c = b->c;
+			i->d = d;
+			i->bio = NULL;
+
+			if (insert_dirty(d, i)) {
+				*upto = max_t(sector_t, *upto, KEY_OFFSET(k));
+				(*count)++;
+			}
+		}
+
+	label(err,	ret = -1);
+	rw_unlock(false, b);
+	return ret;
+}
+
+static bool do_refill_dirty(struct cached_dev *d)
+{
+	int total = 0, id = d->bdev->bd_cache_identifier;
+	sector_t last_found = ~0;
+	struct cache *c;
+	bool wrap = true;
+again:
+	list_for_each_entry(c, &cache_devices, list) {
+		struct search s = blocking_search;
+		uint64_t search = TREE_KEY(lookup_id(c, id), d->last_found);
+		int used, count = 0;
+		sector_t upto = 0;
+
+		if (run_on_root(false, c, refill_dirty, d, search,
+				&upto, &count, &s) != 1 && upto) {
+			last_found = min(last_found, upto);
+			wrap = false;
+		}
+
+		total += count;
+		used = div64_u64((c->sb.nbuckets - c->heap.size) * 100,
+				 c->sb.nbuckets);
+
+		pr_debug("found %i keys searching from %llu to %llu,"
+			 " wrap = %i, %i%% used",
+			 count, (uint64_t) d->last_found,
+			 (uint64_t) upto, wrap, used);
+	}
+
+	if (wrap) {
+		sector_t l = 0;
+		swap(d->last_found, l);
+
+		if (!l) {
+			atomic_long_set(&d->last_refilled, 0);
+			goto out;
+		} else if (total <= 500)
+			goto again;
+	} else
+		d->last_found = last_found;
+
+	atomic_long_set(&d->last_refilled, jiffies);
+out:
+	return total > 500;
+}
+
+static bool in_writeback(struct cached_dev *d, struct bkey *k)
+{
+	return d->writeback ||
+		atomic_read(&d->in_flight) ||
+		atomic_long_read(&d->last_refilled);
+}
+
+static bool should_refill_dirty(struct cached_dev *d, bool restart)
+{
+	long t = atomic_long_read(&d->last_refilled);
+	if (t && jiffies_to_msecs(jiffies - t) > 20000)
+		return true;
+	else if (!t && restart)
+		atomic_long_set(&d->last_refilled, jiffies);
+	return false;
+}
+
+static void write_dirty_finish(struct work_struct *work)
+{
+	struct dirty *w = container_of(work, struct dirty, work);
+	struct cached_dev *d = w->d;
+	struct search s = blocking_search;
+
+	if (!PTR_DIRTY(&w->key)) {
+		s.q = w->c;
+		s.write = INSERT_UNDIRTY;
+		s.keylist = s.new_keys;
+		s.new_keys[s.nkeylist++] = w->key;
+
+		pr_debug("clearing %s", pkey(&w->key));
+		btree_insert_async(&s);
+	}
+
+	mutex_lock(&d->dirty_lock);
+	rb_erase(&w->node, &d->dirty);
+	atomic_dec(&w->d->in_flight);
+
+	kmem_cache_free(dirty_cache, w);
+	read_dirty(d);
+}
+
+static void write_dirty_endio(struct bio *bio, int error)
+{
+	struct dirty *w = bio->bi_private;
+	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
+
+	while (bv-- != w->bio->bi_io_vec)
+		__free_page(bv->bv_page);
+	bio_put(bio);
+
+	if (!error)
+		PTR_CLEAR_DIRTY(&w->key);
+	else if (error != -EINTR)
+		printk(KERN_WARNING "bcache: writeback io error %i for %s\n",
+		       error, pkey(&w->key));
+
+	PREPARE_WORK(&w->work, write_dirty_finish);
+	queue_work(delayed, &w->work);
+}
+
+static void write_dirty(struct work_struct *work)
+{
+	struct dirty *w = container_of(work, struct dirty, work);
+	struct bio *bio = w->bio;
+	struct bio_vec *bv;
+	int i;
+
+	if (!w->d->bdev->bd_disk)
+		return write_dirty_endio(bio, -EINTR);
+
+	dirty_bio_alloc(w);
+	w->bio->bi_flags       |= 1 << BIO_CACHE_RECURSE;
+	w->bio->bi_sector	= KEY_OFFSET(&w->key) - PTR_SIZE(&w->key);
+	w->bio->bi_bdev		= w->d->bdev;
+	w->bio->bi_end_io	= write_dirty_endio;
+
+	bio_for_each_segment(bv, w->bio, i)
+		bv->bv_page = bio->bi_io_vec[i].bv_page;
+	bio_put(bio);
+
+	pr_debug("sector %llu, len %i: %s", (uint64_t) w->bio->bi_sector,
+		 PTR_SIZE(&w->key), pkey(&w->key));
+	submit_bio_list(WRITE, w->bio);
+}
+
+static void read_dirty_endio(struct bio *bio, int error)
+{
+	struct dirty *w = bio->bi_private;
+
+	if (error)
+		return write_dirty_endio(w->bio, error);
+
+	INIT_WORK(&w->work, write_dirty);
+	queue_work(delayed, &w->work);
+}
+
+static void read_dirty_work(struct work_struct *work)
+{
+	struct cached_dev *d = container_of(work, struct cached_dev, work);
+	mutex_lock(&d->dirty_lock);
+	read_dirty(d);
+}
+
+static void read_dirty(struct cached_dev *d)
+{
+	struct dirty *e;
+	struct bio_vec *bv;
+	int i;
+
+	while (d->bdev->bd_disk && /* hack */
+	       d->writeback_running) {
+		e = RB_SEARCH_GREATER(&d->dirty,
+				      (struct dirty) { .key = d->last_written },
+				      node, dirty_cmp);
+
+		if (!e)
+			e = RB_FIRST(&d->dirty, struct dirty, node);
+
+		if (!e || e->bio) {
+			if (atomic_long_read(&d->last_refilled) &&
+			    do_refill_dirty(d))
+				continue;
+			break;
+		}
+
+		if (PTR_GEN(&e->key) != PTR_BUCKET(e, &e->key)->gen) {
+			rb_erase(&e->node, &d->dirty);
+			kmem_cache_free(dirty_cache, e);
+			continue;
+		}
+
+		dirty_bio_alloc(e);
+		e->bio->bi_sector	= PTR_OFFSET(&e->key);
+		e->bio->bi_bdev		= e->c->bdev;
+		e->bio->bi_end_io	= read_dirty_endio;
+
+		bio_for_each_segment(bv, e->bio, i)
+			if (!(bv->bv_page = alloc_page(GFP_NOIO)))
+				goto err;
+
+		d->last_written = e->key;
+		pr_debug("%s", pkey(&e->key));
+		submit_bio_list(READ, e->bio);
+		if (atomic_inc_return(&d->in_flight) >= 8)
+			break;
+	}
+
+	if (0) {
+err:		while (bv-- != e->bio->bi_io_vec)
+			__free_page(bv->bv_page);
+		kfree(e->bio);
+		e->bio = NULL;
+	}
+	mutex_unlock(&d->dirty_lock);
+}
+
+static void close_open_bucket(struct open_bucket *b, struct bkey *k, int split)
+{
+	b->key.key += TREE_KEY(0, split);
+
+	k->key = TREE_KEY(lookup_id(b->cache, KEY_DEV(&b->key)),
+			  KEY_OFFSET(&b->key));
+	k->ptr = TREE_PTR(b->gen, split,
+			  b->offset + b->cache->sb.bucket_size -
+			  b->sectors_free);
+
+	b->sectors_free	-= split;
+	b->cache->sectors_written += split;
+
+	if (b->sectors_free < PAGE_SECTORS) {
+		atomic_dec_bug(&bucket(b->cache, b->offset)->pin);
+		b->cache->rescale -= b->cache->sb.bucket_size;
+		b->cache = NULL;
+	}
+}
+
+static struct open_bucket *get_open_bucket(uint64_t key, struct task_struct *t,
+					   struct cache *c, struct search *s)
+{
+	int count = 0;
+	struct open_bucket *l, *b = NULL;
+
+	spin_lock(&open_bucket_lock);
+	list_for_each_entry_reverse(l, &open_buckets, list) {
+		count++;
+
+		if (c && l->cache != c)
+			continue;
+
+		if (l->key.key == key) {
+			b = l;
+			break;
+		} else if (l->last == t)
+			b = l;
+	}
+
+	if (b)
+		goto found;
+
+	if (count < 8) {
+		spin_unlock(&open_bucket_lock);
+		if (!(b = kzalloc(sizeof(struct open_bucket), GFP_NOIO)))
+			return NULL;
+		spin_lock(&open_bucket_lock);
+
+		INIT_LIST_HEAD(&b->list);
+	} else {
+		struct bkey unused;
+		list_for_each_entry(b, &open_buckets, list)
+			if (!c || !b->cache || c == b->cache)
+				goto found;
+
+		b = list_first_entry(&open_buckets, struct open_bucket, list);
+		b->sectors_free = 0;
+		close_open_bucket(b, &unused, 0);
+	}
+
+found:
+	if (!b->cache ||
+	    b->gen != bucket(b->cache, b->offset)->gen) {
+		long bucket;
+
+		list_del_init(&b->list);
+
+		if (!c) {
+			list_for_each_entry(c, &cache_devices, list)
+				if (!b->cache ||
+				    !heap_peek(&b->cache->heap) ||
+				    (heap_peek(&c->heap) &&
+				     heap_peek(&b->cache->heap)->priority >
+				     heap_peek(&c->heap)->priority))
+					b->cache = c;
+		} else
+			b->cache = c;
+
+		if (!b->cache)
+			goto err;
+
+		/* slightly grotesque - pop bucket does io */
+		spin_unlock(&open_bucket_lock);
+		spin_lock(&b->cache->bucket_lock);
+
+		bucket = pop_bucket(b->cache, initial_priority, s);
+
+		spin_unlock(&b->cache->bucket_lock);
+		spin_lock(&open_bucket_lock);
+
+		if (bucket == -1)
+			goto err;
+
+		b->offset	= bucket_to_sector(b->cache, bucket);
+		b->gen		= bucket(b->cache, b->offset)->gen;
+		b->sectors_free = b->cache->sb.bucket_size;
+	}
+
+	b->last		= t;
+	b->key.key	= key;
+
+	BUG_ON(!b->sectors_free);
+	list_move_tail(&b->list, &open_buckets);
+	return b;
+err:
+	b->cache = NULL;
+	list_move(&b->list, &open_buckets);
+	spin_unlock(&open_bucket_lock);
+	return NULL;
+}
+
+static void bio_insert_endio(struct bio *bio, int error)
+{
+	struct search *s = bio->bi_private;
+	BUG_ON(atomic_read(&s->remaining) != 1);
+
+	BUG_ON(error);
+	if (s->write == INSERT_READ) {
+		put_search(s->parent, false);
+		s->parent = NULL;
+	}
+
+	put_search(s, false);
+}
+
+static int bio_insert(struct task_struct *task, struct bio *bio,
+			      struct search *t)
+{
+	int split, id = bio->bi_bdev->bd_cache_identifier;
+	struct cached_dev *d = devices[id];
+	struct cache *c = NULL;
+	struct bio *n = NULL;
+	struct search *s = alloc_child_search(t);
+	int sectors = bio_sectors(bio);
+
+	BUG_ON(IS_ERR(s));
+	if (IS_ERR(s))
+		return -1;
+
+	s->end_fn = btree_insert_async;
+	s->delay = t->delay;
+	s->write = t->write;
+	s->keylist = s->new_keys;
+	s->flags |= SEARCH_BLOCK;
+	s->d = d;
+
+	bio->bi_end_io	 = bio_insert_endio;
+	bio->bi_private	 = s;
+
+	do {
+		struct open_bucket *b;
+		struct bkey k;
+
+		if (realloc_keys(s))
+			goto err;
+
+		b = get_open_bucket(TREE_KEY(id, bio->bi_sector), task, c,
+				    d->writeback && s->write != INSERT_READ
+				    ? s : NULL);
+		if (!b)
+			goto err;
+
+		s->q = c = b->cache;
+		split = min(min(bio_sectors(bio), b->sectors_free),
+			    queue_max_sectors(bdev_get_queue(c->bdev)));
+
+		atomic_inc(&bucket(c, b->offset)->pin);
+		c->sectors_to_gc -= split;
+
+		close_open_bucket(b, &k, split);
+		spin_unlock(&open_bucket_lock);
+
+		if (s->write == INSERT_WRITEBACK)
+			PTR_SET_DIRTY(&k);
+
+		if (c->sectors_to_gc < 0)
+			queue_gc(c);
+
+		if (!(n = bio_split_front(bio, split, NULL)))
+			goto err;
+
+		pr_debug("adding to cache key %s", pkey(&k));
+		s->keylist[s->nkeylist++] = k;
+
+		n->bi_rw	|= WRITE;
+		n->bi_sector	 = PTR_OFFSET(&k);
+		n->bi_bdev	 = c->bdev;
+		generic_make_request(n);
+
+		if (c->rescale < 0)
+			rescale_heap(c, 0);
+	} while (n != bio);
+
+	if (s->write != INSERT_READ &&
+	    d->writeback_running &&
+	    !atomic_read(&d->in_flight) &&
+	    should_refill_dirty(d, s->write == INSERT_WRITEBACK)) {
+		PREPARE_WORK(&d->work, read_dirty_work);
+		queue_work(delayed, &d->work);
+	}
+
+	return 0;
+err:
+	BUG_ON(!n && s->nkeylist);
+	if (s->write != INSERT_READ)
+		pr_debug("error, %i/%i sectors done, bi_sector %llu",
+			 (sectors - bio_sectors(bio)), sectors,
+			 (uint64_t) bio->bi_sector);
+	return -1;
+}
+
+static void bio_complete(struct search *s)
+{
+	if (s->cache_bio)
+		bio_put(s->cache_bio);
+#if 0
+	if (!list_empty(&s->barrier)) {
+		spin_lock(&barrier_lock);
+		list_del(&s->barrier);
+		spin_unlock(&barrier_lock);
+		run_wait_list(1, s->barrier_wait);
+	}
+#endif
+	if (s->error)
+		pr_debug("error %i", s->error);
+
+	s->bio->bi_private = s->bi_private;
+	s->bio->bi_end_io = s->bi_end_io;
+	if (s->bi_end_io)
+		s->bi_end_io(s->bio, s->error);
+	put_search(s, false);
+}
+
+static void cache_miss(struct search *s)
+{
+	if (!s->error && s->cache_bio)
+		if (bio_insert(s->q, s->cache_bio, s))
+			bio_endio(s->cache_bio, 0);
+
+	return_f(s, bio_complete);
+}
+
+#if 0
+static void bio_complete_bounce(struct search *s)
+{
+	int i;
+	struct bio_vec *bv;
+	bio_for_each_segment(bv, s->bio, i)
+		__free_page(bv->bv_page);
+	bio_put(s->bio);
+	return_f(s, NULL);
+}
+
+static void cache_miss_bounce(struct search *s)
+{
+	int i;
+	struct bio_vec *bv;
+
+	bio_for_each_segment(bv, s->cache_bio, i)
+		if (s->error)
+			__free_page(bv->bv_page);
+		else {
+			void *dst = kmap(bv->bv_page);
+			void *src = kmap(s->bio->bi_io_vec[i].bv_page);
+			memcpy(dst, src, PAGE_SIZE);
+			kunmap(dst);
+			kunmap(src);
+		}
+
+	s->bio->bi_private = s->bi_private;
+	s->bi_end_io(s->bio, s->error);
+	s->bi_end_io = NULL;
+
+	if (s->error ||
+	    !(s->bio = bio_kmalloc(GFP_NOIO, s->cache_bio->bi_max_vecs))) {
+		bio_put(s->cache_bio);
+		return_f(s, NULL);
+	}
+
+	__bio_clone(s->bio, s->cache_bio);
+
+	if (bio_insert(s->q, s->cache_bio, false, s))
+		bio_endio(s->cache_bio, -EIO);
+}
+#endif
+
+static void request_endio(struct bio *bio, int error)
+{
+	struct search *s = bio->bi_private;
+	s->error = error;
+	put_search(s, false);
+}
+
+static void do_bio_hook(struct bio *bio, struct search *s)
+{
+	s->q		= get_current();
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+
+	bio->bi_end_io	= request_endio;
+	bio->bi_private = s;
+}
+
+static void __request_read(struct search *s)
+{
+	request_read(s->q, s->bio, false, s);
+}
+
+static int request_read(struct request_queue *q, struct bio *bio,
+			bool skip, struct search *s)
+{
+	int ret = -1;
+	struct cache *c;
+
+	if (!s) {
+		s = alloc_search(NULL);
+		s->bio = bio;
+		s->q = q;
+		bio_list_add(&s->misses, bio);
+	}
+
+	pr_debug("searching for %i sectors at %llu",
+		 bio_sectors(bio), (uint64_t) bio->bi_sector);
+
+	list_for_each_entry(c, &cache_devices, list) {
+		struct bio_list hits = { NULL, NULL };
+		int dev = lookup_dev(c, s->bio);
+
+		if (dev == UUIDS_PER_SB)
+			return_f(s, NULL, 1);
+
+		if (!run_on_root(false, c, btree_search_recurse,
+				 dev, &hits, 0, s))
+			ret = 0;
+
+		cache_hit(c, hits.head);
+		if (bio_list_empty(&s->misses))
+			return_f(s, NULL, 0);
+	}
+
+	if (!ret)
+		return_f(s, __request_read, 0);
+
+	if (skip) {
+		while ((bio = bio_list_pop(&s->misses)))
+			if (q->make_request_fn(q, bio))
+				generic_make_request(bio);
+
+		return_f(s, NULL, 0);
+	}
+
+	pr_debug("cache miss for %llu, starting write",
+		 (uint64_t) s->bio->bi_sector);
+	cache_misses++;
+
+	s->end_fn = cache_miss;
+	s->write = INSERT_READ;
+	s->delay = -1;
+	do_bio_hook(s->bio, s);
+
+	s->cache_bio = bio_kmalloc(GFP_NOIO, s->misses.head->bi_max_vecs);
+	if (s->cache_bio)
+		__bio_clone(s->cache_bio, s->misses.head);
+#if 0
+	for (i = bio->bi_idx; i < bio->bi_vcnt; i++)
+		if (!(s->cache_bio->bi_io_vec[i].bv_page =
+		      alloc_page(GFP_NOIO)))
+			break;
+
+	if (i != bio->bi_vcnt) {
+		while (i > bio->bi_idx)
+			__free_page(s->cache_bio->bi_io_vec[i].bv_page);
+
+		memcpy(s->cache_bio->bi_io_vec, bio->bi_io_vec,
+		       bio->bi_max_vecs * sizeof(struct bio_vec));
+
+	} else
+		s->end_fn	= cache_miss_bounce;
+#endif
+	do {
+		bio = bio_list_pop(&s->misses);
+		ret = bio_list_empty(&s->misses);
+
+		if (q->make_request_fn(q, bio))
+			generic_make_request(bio);
+	} while (!ret);
+
+	return 0;
+}
+
+static int request_write(struct request_queue *q, struct bio *bio, bool skip)
+{
+	int ret;
+	const char *err = "couldn't allocate memory";
+	struct cached_dev *d = devices[bio->bi_bdev->bd_cache_identifier];
+	struct search *s = alloc_search(NULL);
+
+	if (IS_ERR(s))
+		goto err;
+
+	do_bio_hook(bio, s);
+	s->end_fn = bio_complete;
+	s->write = INSERT_WRITE;
+	s->delay = bio_rw_flagged(bio, BIO_RW_SYNCIO)
+		? flush_delay_ms_sync
+		: flush_delay_ms;
+
+	if (skip && !d->writeback) {
+		ret = btree_invalidate(bio, s);
+		if (!ret)
+			goto err;
+		return ret;
+	}
+
+	if (d->writeback) {
+		unsigned long free = 0, total = 0;
+		struct cache *c;
+		list_for_each_entry(c, &cache_devices, list)
+			free += c->heap.size, total += c->sb.nbuckets;
+
+		if (free * 2 > total ||
+		    (bio_rw_flagged(bio, BIO_RW_SYNCIO) &&
+		     free * 4 > total))
+			s->write = INSERT_WRITEBACK;
+	}
+
+	if (s->write == INSERT_WRITEBACK) {
+		s->cache_bio = bio;
+		bio_get(bio);
+	} else {
+		if (!(s->cache_bio = bio_kmalloc(GFP_NOIO, bio->bi_max_vecs)))
+			goto err;
+
+		__bio_clone(s->cache_bio, bio);
+	}
+#if 0
+	if (!list_empty(&d->barrier) ||
+	    bio_rw_flagged(bio, BIO_RW_BARRIER)) {
+		spin_lock(&barrier_lock);
+		if (!list_empty(&d->barrier)) {
+			b = list_first_entry(&d->barrier, struct search,
+					     barrier);
+			wait_search(b->barrier_wait, i);
+		}
+
+		if (bio_rw_flagged(bio, BIO_RW_BARRIER))
+			list_add(&i->barrier, &d->barrier);
+		spin_unlock(&barrier_lock);
+	}
+#endif
+	ret = s->write == INSERT_WRITE;
+	if (bio_insert(s->q, s->cache_bio, s)) {
+		BUG_ON(d->writeback);
+		ret = btree_invalidate(s->cache_bio, s);
+
+		if (s->write == INSERT_WRITE)
+			bio_endio(s->cache_bio, 0);
+
+		if (!ret)
+			goto err;
+	}
+
+	if (s->write == INSERT_WRITEBACK)
+		put_search(s, false);
+
+	return ret;
+err:
+	printk(KERN_WARNING "bcache: write error: %s\n", err);
+
+	bio_endio(bio, -ENOMEM);
+	return 0;
+}
+
+static void unplug_hook(struct request_queue *q)
+{
+	struct cache *c;
+	list_for_each_entry(c, &cache_devices, list)
+		blk_unplug(bdev_get_queue(c->bdev));
+	q->cache_unplug_fn(q);
+}
+
+static int request(struct request_queue *q, struct bio *bio)
+{
+	bool skip = false;
+	struct io *i;
+	struct hlist_node *cursor;
+	struct task_struct *task = get_current();
+	uint64_t key = TREE_KEY(bio->bi_bdev->bd_cache_identifier,
+				bio->bi_sector);
+
+	struct hlist_head *iohash(uint64_t k)
+	{ return &recent_io_hash[hash_64(k, RECENT_IO_BITS)]; }
+
+	if (!bio_has_data(bio) ||
+	    list_empty(&cache_devices))
+		return 1;
+
+	/* paper over some stuff */
+	if (bio_flagged(bio, BIO_CACHE_RECURSE))
+		return 1;
+
+	devices[bio->bi_bdev->bd_cache_identifier]->bdev = bio->bi_bdev;
+
+	spin_lock(&recent_io_lock);
+	if (q->unplug_fn != unplug_hook) {
+		q->cache_unplug_fn = q->unplug_fn;
+		q->unplug_fn = unplug_hook;
+	}
+
+	hlist_for_each_entry(i, cursor, iohash(key), hash)
+		if (i->key == key)
+			goto found;
+
+	i = list_first_entry(&recent_io_lru, struct io, lru);
+	i->sequential = 0;
+	task->nr_ios++;
+found:
+	i->key = key + bio_sectors(bio);
+	i->sequential += bio_sectors(bio);
+	task->sequential_io += bio_sectors(bio);
+
+	if (max(i->sequential, task->sequential_io / (task->nr_ios + 1))
+	    >= sequential_cutoff >> 9) {
+		sectors_bypassed += bio_sectors(bio);
+		skip = true;
+	}
+
+	list_move_tail(&i->lru, &recent_io_lru);
+
+	hlist_del(&i->hash);
+	hlist_add_head(&i->hash, iohash(i->key));
+	spin_unlock(&recent_io_lock);
+
+	return bio_rw_flagged(bio, BIO_RW)
+		? request_write(q, bio, skip)
+		: request_read(q, bio, skip, NULL);
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
+		return snprintf(buf, PAGE_SIZE, __VA_ARGS__)
+
+#define sysfs_hprint(file, val)						\
+	if (attr == &sysfs_ ## file) {					\
+		int ret = hprint(buf, val);				\
+		strcat(buf, "\n");					\
+		return ret + 1;						\
+	}
+
+#define sysfs_atoi(file, var)						\
+	if (attr == &sysfs_ ## file) {					\
+		unsigned long _v, _r = strict_strtoul(buffer, 10, &_v);	\
+		if (_r)							\
+			return _r;					\
+		var = _v;						\
+	}
+
+#define sysfs_hatoi(file, var)						\
+	if (attr == &sysfs_ ## file)					\
+		return strtoi_h(buffer, &var) ? : size;			\
+
+write_attribute(register_cache);
+write_attribute(register_dev);
+write_attribute(unregister);
+write_attribute(clear_stats);
+
+read_attribute(bucket_size);
+read_attribute(nbuckets);
+read_attribute(cache_hits);
+read_attribute(cache_hit_ratio);
+read_attribute(cache_misses);
+read_attribute(tree_depth);
+read_attribute(min_priority);
+read_attribute(pinned_buckets);
+read_attribute(lru_end);
+read_attribute(heap_size);
+read_attribute(written);
+read_attribute(btree_written);
+read_attribute(bypassed);
+read_attribute(btree_avg_keys_written);
+read_attribute(writeback_keys_failed);
+read_attribute(writeback_keys_done);
+
+rw_attribute(cache_priority_initial);
+rw_attribute(cache_priority_hit);
+rw_attribute(cache_priority_seek);
+rw_attribute(sequential_cutoff);
+rw_attribute(writeback);
+rw_attribute(writeback_running);
+rw_attribute(flush_delay_ms);
+rw_attribute(flush_delay_ms_sync);
+rw_attribute(synchronous);
+rw_attribute(discard);
+rw_attribute(latency_warn_ms);
+rw_attribute(writeback_delay);
+
+static int sync_btree_check(struct btree *b, struct search *s)
+{
+	struct bkey *k;
+
+	for_each_key(b, k)
+		if (!__ptr_bad(b, k)) {
+			int8_t g = PTR_BUCKET(b, k)->gen - PTR_GEN(k);
+
+			if (g <= 0) {
+				PTR_BUCKET(b, k)->gen = PTR_GEN(k);
+				if (b->level || PTR_DIRTY(k))
+					heap_remove(&b->c->heap,
+						    PTR_BUCKET(b, k),
+						    heap, bucket_cmp);
+
+				if (b->level)
+					PTR_BUCKET(b, k)->priority = btree_prio;
+				else if (PTR_DIRTY(k))
+					ptr_set_dirty(b->c, k);
+			} else if (g > b->c->need_gc)
+				b->c->need_gc = g;
+		}
+
+	if (b->level)
+		for_each_good_key(b, k) {
+			struct btree *r = get_bucket(b, k, false, &s);
+			BUG_ON(IS_ERR(r));
+
+			if (r)
+				sync_btree_check(r, s);
+			else
+				inc_gen(b, PTR_OFFSET(k));
+		}
+
+	rw_unlock(false, b);
+	return 0;
+}
+
+static struct dentry *debug;
+
+static int dump_tree(struct btree *b, struct seq_file *f, const char *tabs,
+		     uint64_t *prev, uint64_t *sectors, struct search *s)
+{
+	struct bkey *k;
+	char buf[30];
+	uint64_t last, biggest = 0;
+
+	seq_printf(f, "%s     page  key: dev        key ->"
+		   "    offset  len gen bucket\n", tabs - 1);
+
+	for_each_key(b, k) {
+		if (_j == 1)
+			last = *prev;
+
+		if (last > k->key)
+			seq_printf(f, "Key skipped backwards\n");
+
+		if (!b->level &&
+		    _j > 1 &&
+		    last != KEY_START(k))
+			seq_printf(f, "<hole>\n");
+		else if (b->level && !ptr_bad(b, k)) {
+			struct btree *r = get_bucket(b, k, false, &s);
+			if (!IS_ERR_OR_NULL(r))
+				dump_tree(r, f, tabs - 1, &last, sectors, s);
+		}
+
+		if (!ptr_status(b, k, buf) && PTR_DIRTY(k))
+			strcpy(buf, "dirty");
+
+		seq_printf(f,
+			   "%s%i %4i: %3i %10llu -> %9lli %4i %3i %6li %s\n",
+			   tabs, index(_i, b), _j, KEY_DEV(k), KEY_OFFSET(k),
+			   PTR_OFFSET(k), PTR_SIZE(k), PTR_GEN(k),
+			   sector_to_bucket(b->c, PTR_OFFSET(k)), buf);
+
+		if (!b->level && !buf[0])
+			*sectors += PTR_SIZE(k);
+
+		last = k->key;
+		biggest = max(biggest, last);
+	}
+	*prev = biggest;
+
+	rw_unlock(false, b);
+	return 0;
+}
+
+static int debug_seq_show(struct seq_file *f, void *data)
+{
+	static const char *tabs = "\t\t\t\t\t";
+	uint64_t last = 0, sectors = 0;
+	struct cache *c = f->private;
+	struct search s = blocking_search;
+
+	run_on_root(false, c, dump_tree, f, &tabs[4], &last, &sectors, &s);
+
+	seq_printf(f,
+		   "root: (null) -> bucket %6li\n"
+		   "%llu Mb found\n",
+		   sector_to_bucket(c, c->root->offset), sectors / 2048);
+
+	return 0;
+}
+
+static int debug_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_seq_show, inode->i_private);
+}
+
+static void load_priorities_endio(struct bio *bio, int error)
+{
+	for (int i = 0; i < bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	if (error)
+		printk(KERN_ERR "bcache: Error reading priorities");
+	wake_up(&pending);
+	bio_put(bio);
+}
+
+static void load_priorities(struct cache *c)
+{
+	long i;
+	struct bio *bio = c->priority_bio;
+	struct bio_vec *bv;
+
+	bio_get(bio);
+	bio->bi_sector	= PRIO_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= pages(c, struct bucket_disk);
+	bio->bi_size	= pages(c, struct bucket_disk) * PAGE_SIZE;
+
+	bio->bi_end_io	= load_priorities_endio;
+	bio->bi_private = c;
+
+	bio_for_each_segment(bv, bio, i) {
+		bv->bv_page = vmalloc_to_page((void *) c->disk_buckets
+					      + PAGE_SIZE * i);
+		bv->bv_len = PAGE_SIZE;
+		bv->bv_offset = 0;
+		get_page(bv->bv_page);
+	}
+
+	submit_bio_list(READ, bio);
+
+	wait_event(pending, atomic_read(&bio->bi_remaining) == 0);
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		struct bucket *b = c->buckets + i;
+
+		atomic_set(&b->pin, 0);
+		b->heap = -1;
+
+		b->priority = le16_to_cpu(c->disk_buckets[i].priority);
+		b->last_gc = b->gen = c->disk_buckets[i].gen;
+
+		if (i != sector_to_bucket(c, c->sb.btree_root))
+			bucket_add_heap(c, i);
+	}
+}
+
+static void save_priorities_endio(struct bio *bio, int error)
+{
+	int i;
+	struct cache *c = bio->bi_private;
+	BUG_ON(error);
+
+	atomic_set(&c->prio_written, 1);
+
+	wake_up(&pending);
+	run_wait_list(1, c->bucket_wait);
+
+	for (i = 0; i < bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+}
+
+static void save_priorities_work(struct work_struct *w)
+{
+	struct cache *c = container_of(w, struct cache, priority_work);
+	submit_bio_list(WRITE, c->priority_bio);
+}
+
+static struct bio *save_priorities(struct cache *c)
+{
+	long i;
+	struct bio *bio = c->priority_bio;
+	struct bio_vec *bv;
+
+	if (!bio_reinit(bio))
+		return NULL;
+
+	bio->bi_sector	= PRIO_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= pages(c, struct bucket_disk);
+	bio->bi_size	= pages(c, struct bucket_disk) * PAGE_SIZE;
+
+	bio->bi_end_io	= save_priorities_endio;
+	bio->bi_private = c;
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		struct bucket *b = c->buckets + i;
+
+		c->disk_buckets[i].priority = cpu_to_le16(b->priority);
+		c->disk_buckets[i].gen = b->gen;
+	}
+
+	bio_for_each_segment(bv, bio, i) {
+		bv->bv_page = vmalloc_to_page((void *) c->disk_buckets
+					      + PAGE_SIZE * i);
+		bv->bv_len = PAGE_SIZE;
+		bv->bv_offset = 0;
+		get_page(bv->bv_page);
+	}
+
+	pr_debug("done");
+	return bio;
+}
+
+static void register_dev_on_cache(struct cache *c, int d)
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
+			/* Need to check if device was already opened
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
+static ssize_t show_dev(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct cached_dev *d = container_of(kobj, struct cached_dev, kobj);
+	sysfs_print(writeback, "%i\n", d->writeback);
+	sysfs_print(writeback_running, "%i\n", d->writeback_running);
+	return 0;
+}
+
+static ssize_t store_dev(struct kobject *kobj, struct attribute *attr,
+			 const char *buffer, size_t size)
+{
+	struct cached_dev *d = container_of(kobj, struct cached_dev, kobj);
+	sysfs_atoi(writeback, d->writeback);
+	sysfs_atoi(writeback_running, d->writeback_running);
+	if (attr == &sysfs_writeback_running &&
+	    d->writeback_running && mutex_trylock(&d->dirty_lock))
+		read_dirty(d);
+	if (attr == &sysfs_unregister)
+		kobject_put(kobj);
+	return size;
+}
+
+static void unregister_dev(struct kobject *k)
+{
+}
+
+static void register_dev(const char *buffer, size_t size)
+{
+	int i;
+	const char *err = NULL;
+	char *path = NULL;
+	unsigned char uuid[16];
+	struct block_device *bdev = NULL;
+	struct cached_dev *d = NULL;
+	struct cache *c;
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_writeback,
+		&sysfs_writeback_running,
+		NULL
+	};
+	static const struct sysfs_ops ops = {
+		.show = show_dev,
+		.store = store_dev
+	};
+	static struct kobj_type dev_obj = {
+		.release = unregister_dev,
+		.sysfs_ops = &ops,
+		.default_attrs = files
+	};
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
+	if (!(path = kmalloc(size + 1 - i, GFP_KERNEL)))
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
+	if (!(d = kzalloc(sizeof(*d) + sizeof(struct dirty) * 1024,
+			  GFP_KERNEL)))
+		goto err;
+
+	INIT_WORK(&d->work, NULL);
+	INIT_LIST_HEAD(&d->barrier);
+	mutex_init(&d->dirty_lock);
+	d->dirty = RB_ROOT;
+	d->bdev = bdev;
+	d->writeback_running = true;
+#if 0
+	blkdev_get(bdev, FMODE_READ|FMODE_WRITE))
+	bdevname(bdev, b);
+#endif
+	err = "Error creating kobject";
+	if (!kobject_get(bcache_kobj) ||
+	    kobject_init_and_add(&d->kobj, &dev_obj,
+				 bcache_kobj,
+				 "%s", strim(path)))
+		goto err;
+
+	memcpy(&uuids[i*16], uuid, 16);
+	bdev->bd_cache_identifier = i;
+	devices[i] = d;
+
+	list_for_each_entry(c, &cache_devices, list)
+		register_dev_on_cache(c, i);
+
+	bdev->bd_cache_fn = request;
+	printk(KERN_DEBUG "bcache: Caching %s index %i", path, i);
+
+	if (0) {
+err:		printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
+		if (!IS_ERR_OR_NULL(bdev))
+			bdput(bdev);
+		kfree(d);
+	}
+	kfree(path);
+}
+
+static void unregister_cache_kobj(struct work_struct *w)
+{
+	struct cache *c = container_of(w, struct cache, work);
+	list_del(&c->list);
+	INIT_LIST_HEAD(&c->list);
+	kobject_put(&c->kobj);
+}
+
+static ssize_t store_cache(struct kobject *kobj, struct attribute *attr,
+			   const char *buffer, size_t size)
+{
+	struct cache *c = container_of(kobj, struct cache, kobj);
+	if (attr == &sysfs_unregister) {
+		PREPARE_WORK(&c->work, unregister_cache_kobj);
+		schedule_work(&c->work);
+	}
+	if (blk_queue_discard(bdev_get_queue(c->bdev)))
+		sysfs_atoi(discard, c->discard);
+	return size;
+}
+
+static ssize_t show_cache(struct kobject *kobj, struct attribute *attr,
+			  char *buf)
+{
+	struct cache *c = container_of(kobj, struct cache, kobj);
+	struct btree *b;
+
+	sysfs_hprint(bucket_size, c->sb.bucket_size << 9);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
+	sysfs_print(min_priority, "%u\n",
+		    c->heap.data[0] ? c->heap.data[0]->priority : 0);
+	sysfs_print(heap_size, "%zu\n", c->heap.size);
+	sysfs_hprint(written, c->sectors_written << 9);
+	sysfs_hprint(btree_written, c->btree_sectors_written << 9);
+	sysfs_print(discard, "%i\n", c->discard);
+	sysfs_print(writeback_keys_failed, "%lu\n", c->writeback_keys_failed);
+	sysfs_print(writeback_keys_done, "%lu\n", c->writeback_keys_done);
+
+	if (attr == &sysfs_pinned_buckets) {
+		struct list_head *l;
+		int i = 0;
+		spin_lock(&c->bucket_lock);
+		list_for_each(l, &c->lru)
+			i++;
+		spin_unlock(&c->bucket_lock);
+		return snprintf(buf, PAGE_SIZE, "%i\n", i);
+	}
+
+	if (attr == &sysfs_lru_end) {
+		b = list_entry(c->lru.prev, struct btree, lru);
+		return snprintf(buf, PAGE_SIZE, "%li\n",
+				sector_to_bucket(c, b->offset));
+	}
+	return 0;
+}
+
+static const char *read_super(struct cache *c)
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
+	if (c->sb.version > (CACHE_CLEAN|CACHE_SYNC))
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
+	err = "Invalid superblock: journal overwrites bucket priorites";
+	if (c->sb.journal_start * c->sb.bucket_size <
+	    24 + ((c->sb.nbuckets * sizeof(struct bucket_disk)) >> 9))
+		goto err;
+
+	err = "Invalid superblock: first bucket comes before journal start";
+	if (c->sb.first_bucket < c->sb.journal_start)
+		goto err;
+
+	err = "Invalid superblock: device too small";
+	if (get_capacity(c->bdev->bd_disk) <
+	    bucket_to_sector(c, c->sb.nbuckets))
+		goto err;
+
+	err = "Bucket size must be a power of two";
+	if (c->sb.bucket_size < PAGE_SECTORS ||
+	    !is_power_of_2(c->sb.bucket_size))
+		goto err;
+
+	c->bucket_size_bits = ilog2(c->sb.bucket_size);
+
+	if (c->sb.btree_root <  bucket_to_sector(c, 0) ||
+	    c->sb.btree_root >= bucket_to_sector(c, c->sb.nbuckets))
+		c->sb.version &= ~CACHE_CLEAN;
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
+static void write_super_endio(struct bio *bio, int error)
+{
+	int i;
+	struct cache *c = bio->bi_private;
+	BUG_ON(error);
+
+	run_wait_list(1, c->sb_wait);
+
+	for (i = 0; i < bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+}
+
+static struct bio *write_super(struct cache *c, struct search *s)
+{
+	struct bio *bio = c->sb_bio;
+	struct cache_sb *sb = page_address(bio->bi_io_vec[0].bv_page);
+
+	if (!bio_reinit(bio))
+		return NULL;
+
+	get_page(bio->bi_io_vec[0].bv_page);
+
+	BUG_ON(list_empty(&c->list) != (c->sb.version & CACHE_CLEAN));
+
+	bio->bi_sector	= SB_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= 1;
+	bio->bi_size	= 4096;
+
+	bio->bi_end_io	= write_super_endio;
+	bio->bi_private = c;
+
+	if (synchronous)
+		c->sb.version |= CACHE_SYNC;
+	else
+		c->sb.version &= ~CACHE_SYNC;
+
+	pr_debug("ver %i, root %llu, level %i",
+		 c->sb.version, c->sb.btree_root, c->sb.btree_level);
+
+	sb->version		= cpu_to_le32(c->sb.version);
+	sb->block_size		= cpu_to_le16(c->sb.block_size);
+	sb->bucket_size		= cpu_to_le16(c->sb.bucket_size);
+	sb->journal_start	= cpu_to_le32(c->sb.journal_start);
+	sb->first_bucket	= cpu_to_le32(c->sb.first_bucket);
+	sb->nbuckets		= cpu_to_le64(c->sb.nbuckets);
+	sb->btree_root		= cpu_to_le64(c->sb.btree_root);
+	sb->btree_level		= cpu_to_le16(c->sb.btree_level);
+
+	if (s)
+		wait_search(c->sb_wait, s);
+	return bio;
+}
+
+static void free_cache(struct cache *c)
+{
+	struct btree *b;
+
+	while (!list_empty(&c->lru)) {
+		b = list_first_entry(&c->lru, struct btree, lru);
+		list_del(&b->lru);
+		free_bucket_contents(b, false);
+		kfree(b);
+	}
+
+	if (!IS_ERR_OR_NULL(c->debug))
+		debugfs_remove(c->debug);
+
+	if (c->kobj.state_initialized) {
+		kobject_put(bcache_kobj);
+		kobject_put(&c->kobj);
+	}
+
+	if (c->sb_bio)
+		bio_put(c->sb_bio);
+	if (c->priority_bio)
+		bio_put(c->priority_bio);
+
+	vfree(c->garbage);
+	vfree(c->disk_buckets);
+	vfree(c->buckets);
+
+	free_heap(&c->heap);
+	free_fifo(&c->free);
+	free_fifo(&c->free_inc);
+	free_fifo(&c->btree);
+	free_fifo(&c->btree_inc);
+
+	if (c->uuids)
+		put_bh(c->uuids);
+	if (c->sb_page)
+		put_page(c->sb_page);
+	if (!IS_ERR_OR_NULL(c->bdev))
+		close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
+
+	module_put(c->owner);
+	kfree(c);
+}
+
+static int alloc_cache(struct cache *c)
+{
+#define SIZE(s)	(c->sb.nbuckets * sizeof(s))
+	if (!init_fifo(&c->btree,	c->sb.nbuckets >> 9, GFP_KERNEL) ||
+	    !init_fifo(&c->free,	c->sb.nbuckets >> 7, GFP_KERNEL) ||
+	    !init_fifo(&c->btree_inc,	c->sb.nbuckets >> 9, GFP_KERNEL) ||
+	    !init_fifo(&c->free_inc,	c->sb.nbuckets >> 7, GFP_KERNEL) ||
+	    !init_heap(&c->heap,	c->sb.nbuckets, GFP_KERNEL) ||
+	    !(c->buckets	= vmalloc(SIZE(struct bucket))) ||
+	    !(c->disk_buckets	= vmalloc(SIZE(struct bucket_disk))) ||
+	    !(c->garbage	= vmalloc(SIZE(struct bucket_gc))) ||
+	    !(c->sb_bio		= bio_kmalloc(GFP_KERNEL, 1)) ||
+	    !(c->priority_bio	= bio_kmalloc(GFP_KERNEL,
+					      pages(c, struct bucket_disk))))
+		return 1;
+
+	atomic_set(&c->sb_bio->bi_remaining, 0);
+	c->sb_bio->bi_io_vec[0].bv_page = c->sb_page;
+	c->sb_bio->bi_io_vec[0].bv_len = 4096;
+	c->sb_bio->bi_io_vec[0].bv_offset = 0;
+
+	memset(c->buckets, 0, c->sb.nbuckets * sizeof(struct bucket));
+	memset(c->garbage, 0, c->sb.nbuckets * sizeof(struct bucket_gc));
+	memset(&c->devices, ~0, sizeof(c->devices[0] * UUIDS_PER_SB));
+
+	c->sectors_to_gc	= c->sb.bucket_size * c->sb.nbuckets / 4;
+	c->rescale		= c->sb.bucket_size * c->sb.nbuckets / 128;
+	c->btree_buckets_cached = 8;
+	return 0;
+}
+
+static void register_cache(const char *buffer, size_t size)
+{
+	const char *err = NULL;
+	char *path = NULL, b[BDEVNAME_SIZE];
+	struct cache *c = NULL;
+	struct search s = blocking_search, *sp = &s;
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_bucket_size,
+		&sysfs_nbuckets,
+		&sysfs_cache_hits,
+		&sysfs_tree_depth,
+		&sysfs_min_priority,
+		&sysfs_pinned_buckets,
+		&sysfs_lru_end,
+		&sysfs_heap_size,
+		&sysfs_written,
+		&sysfs_btree_written,
+		&sysfs_discard,
+		&sysfs_writeback_keys_failed,
+		&sysfs_writeback_keys_done,
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
+	INIT_WORK(&c->work, NULL);
+	spin_lock_init(&c->bucket_lock);
+	init_MUTEX(&c->gc_lock);
+	INIT_WORK(&c->priority_work, save_priorities_work);
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
+	if (c->sb.nbuckets < 1 << 11)
+		goto err;
+
+	err = "Insufficient memory";
+	if (alloc_cache(c))
+		goto err;
+
+	load_priorities(c);
+
+	if (c->sb.version & (CACHE_SYNC|CACHE_CLEAN)) {
+		c->root = __get_bucket(c, c->sb.btree_root,
+				       c->sb.btree_level, true, &sp);
+		if (!c->root)
+			goto invalidate;
+		list_del_init(&c->root->lru);
+	} else {
+invalidate:	printk(KERN_NOTICE "bcache: %s was dirty, "
+		       "invalidating existing data\n", path);
+
+		if (!(c->root = btree_alloc(c, 0, &s)))
+			goto err;
+
+		set_new_root(c->root, NULL, true);
+	}
+
+	rw_unlock(true, c->root);
+
+	if (c->sb.version & CACHE_SYNC && !(c->sb.version & CACHE_CLEAN)) {
+		printk(KERN_NOTICE "bcache: Recovery needed on %s\n", path);
+		run_on_root(false, c, sync_btree_check, &s);
+	}
+
+	c->sb.version &= ~CACHE_CLEAN;
+
+	if (synchronous)
+		submit_bio_list(WRITE, write_super(c, NULL));
+
+	for (int i = 0; i < UUIDS_PER_SB && !is_zero(&uuids[i*16], 16); i++)
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
+	if (!IS_ERR_OR_NULL(debug)) {
+		static const struct file_operations treeops = {
+			.owner		= THIS_MODULE,
+			.open		= debug_seq_open,
+			.read		= seq_read,
+			.release	= single_release };
+
+		c->debug = debugfs_create_file(b, 0400, debug, c, &treeops);
+	}
+
+	list_add(&c->list, &cache_devices);
+
+	printk(KERN_DEBUG "bcache: Loaded cache device %s", path);
+	pr_debug("btree root at %llu", (uint64_t) c->root->offset);
+
+	if (0) {
+err:		printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
+		if (c) {
+			if (c->bdev == ERR_PTR(-EBUSY))
+				err = "Device busy";
+			if (c->root)
+				list_add(&c->root->lru, &c->lru);
+			free_cache(c);
+		}
+	}
+	kfree(path);
+}
+
+static void unregister_cache(struct kobject *k)
+{
+	struct cache *c = container_of(k, struct cache, kobj);
+	struct btree *b;
+	struct open_bucket *o;
+
+	spin_lock(&open_bucket_lock);
+	list_for_each_entry(o, &open_buckets, list)
+		if (o->cache == c)
+			o->cache = NULL;
+	spin_unlock(&open_bucket_lock);
+
+	list_add(&c->root->lru, &c->lru);
+	list_for_each_entry(b, &c->lru, lru)
+		btree_write(b, -1, NULL);
+
+	c->sb.version |= CACHE_CLEAN;
+
+	submit_bio_list(WRITE, save_priorities(c));
+	submit_bio_list(WRITE, write_super(c, NULL));
+	free_cache(c);
+}
+
+static unsigned avg_keys_written(void)
+{
+	int cpu;
+	unsigned long keys = 0, writes = 0;
+
+	for_each_online_cpu(cpu) {
+		writes += per_cpu(btree_write_count, cpu);
+		keys += per_cpu(keys_write_count, cpu);
+	}
+	return writes ? keys / writes : 0;
+}
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	sysfs_print(cache_hits, "%lu\n", cache_hits);
+	sysfs_print(cache_hit_ratio, "%lu%%\n",
+		    cache_hits + cache_misses ?
+		    cache_hits * 100 / (cache_hits + cache_misses) : 0);
+	sysfs_print(cache_misses, "%lu\n", cache_misses);
+	sysfs_print(cache_priority_initial, "%i\n", initial_priority);
+	sysfs_print(cache_priority_hit, "%i\n", cache_hit_priority);
+	sysfs_print(cache_priority_seek, "%i\n", cache_hit_seek);
+	sysfs_hprint(sequential_cutoff, sequential_cutoff);
+	sysfs_hprint(bypassed, sectors_bypassed << 9);
+	sysfs_print(btree_avg_keys_written, "%u\n", avg_keys_written());
+	sysfs_print(flush_delay_ms, "%i\n", flush_delay_ms);
+	sysfs_print(flush_delay_ms_sync, "%i\n", flush_delay_ms_sync);
+	sysfs_print(synchronous, "%i\n", synchronous);
+	sysfs_print(latency_warn_ms, "%i\n", latency_warn_ms);
+	sysfs_print(writeback_delay, "%i\n", writeback_delay);
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
+	sysfs_hatoi(sequential_cutoff, sequential_cutoff);
+	sysfs_atoi(flush_delay_ms, flush_delay_ms);
+	sysfs_atoi(flush_delay_ms_sync, flush_delay_ms_sync);
+	sysfs_atoi(synchronous, synchronous);
+	sysfs_atoi(latency_warn_ms, latency_warn_ms);
+	sysfs_atoi(writeback_delay, writeback_delay);
+	if (attr == &sysfs_clear_stats) {
+		struct cache *c;
+		list_for_each_entry(c, &cache_devices, list)
+			c->cache_hits = 0;
+
+		cache_hits = cache_misses = 0;
+	}
+
+	return size;
+}
+
+static int __init bcache_init(void)
+{
+	static const struct sysfs_ops ops = { .show = show, .store = store };
+	static const struct attribute *files[] = {
+		&sysfs_register_cache,
+		&sysfs_register_dev,
+		&sysfs_cache_hits,
+		&sysfs_cache_hit_ratio,
+		&sysfs_cache_misses,
+		&sysfs_cache_priority_initial,
+		&sysfs_cache_priority_hit,
+		&sysfs_cache_priority_seek,
+		&sysfs_clear_stats,
+		&sysfs_sequential_cutoff,
+		&sysfs_bypassed,
+		&sysfs_btree_avg_keys_written,
+		&sysfs_flush_delay_ms,
+		&sysfs_flush_delay_ms_sync,
+		&sysfs_synchronous,
+		&sysfs_latency_warn_ms,
+		&sysfs_writeback_delay,
+		NULL};
+
+	printk(KERN_DEBUG "bcache loading");
+
+	search_cache = kmem_cache_create("bcache_search",
+					 sizeof(struct search),
+					 0, 0, NULL);
+	dirty_cache = kmem_cache_create("bcache_dirty",
+					sizeof(struct dirty),
+					0, 0, NULL);
+
+	for (struct io *i = recent_io; i < recent_io + RECENT_IO; i++) {
+		list_add(&i->lru, &recent_io_lru);
+		hlist_add_head(&i->hash, recent_io_hash + RECENT_IO);
+	}
+
+	spin_lock_init(&search_lock);
+	spin_lock_init(&barrier_lock);
+	spin_lock_init(&recent_io_lock);
+	spin_lock_init(&open_bucket_lock);
+	init_waitqueue_head(&pending);
+
+	delayed = create_workqueue("bcache");
+	if (!delayed)
+		goto err;
+
+	bcache_kobj = kobject_create_and_add("bcache", kernel_kobj);
+	if (!bcache_kobj)
+		goto err;
+
+	debug = debugfs_create_dir("bcache", NULL);
+
+	bcache_kobj->ktype->sysfs_ops = &ops;
+	return sysfs_create_files(bcache_kobj, files);
+err:
+	if (delayed)
+		destroy_workqueue(delayed);
+	return -ENOMEM;
+}
+
+static void bcache_exit(void)
+{
+	struct cache *c;
+
+	if (!IS_ERR_OR_NULL(debug))
+		debugfs_remove_recursive(debug);
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
+
+	kmem_cache_destroy(dirty_cache);
+	kmem_cache_destroy(search_cache);
+}
+
+module_init(bcache_init);
+module_exit(bcache_exit);
diff --git a/block/Makefile b/block/Makefile
index 0bb499a..9f8394d 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -15,3 +15,7 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+
+obj-$(CONFIG_BLK_CACHE)		+= bcache.o bcache_util.o
+CFLAGS_bcache.o			+= -std=gnu99
+CFLAGS_bcache_util.o		+= -std=gnu99
diff --git a/block/bcache_util.c b/block/bcache_util.c
new file mode 100644
index 0000000..85a3291
--- /dev/null
+++ b/block/bcache_util.c
@@ -0,0 +1,140 @@
+#include <linux/bio.h>
+#include <linux/module.h>
+#include "bcache_util.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
+
+struct bio *bio_split_front(struct bio *bio, int sectors,
+			    struct bio *(alloc_fn)(int))
+{
+	int idx, vcnt = 0, nbytes = sectors << 9;
+	struct bio_vec *bv;
+	struct bio *ret = NULL;
+
+	struct bio *alloc(int n)
+	{	return bio_kmalloc(GFP_NOIO, n); }
+
+	alloc_fn = alloc_fn ? : alloc;
+
+	BUG_ON(sectors <= 0);
+
+	if (nbytes >= bio->bi_size)
+		return bio;
+
+	bio_for_each_segment(bv, bio, idx) {
+		vcnt = idx - bio->bi_idx;
+
+		if (!nbytes &&
+		    (ret = alloc_fn(0))) {
+			ret->bi_io_vec = bio->bi_io_vec + bio->bi_idx;
+			ret->bi_flags |= 1 << BIO_CLONED;
+			break;
+		} else if (nbytes && nbytes < bv->bv_len &&
+			   (ret = alloc_fn(++vcnt))) {
+			memcpy(ret->bi_io_vec,
+			       bio->bi_io_vec + bio->bi_idx,
+			       sizeof(struct bio_vec) * vcnt);
+
+			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
+			bv->bv_offset	+= nbytes;
+			bv->bv_len	-= nbytes;
+			break;
+		}
+
+		nbytes -= bv->bv_len;
+	}
+
+	if (ret) {
+		ret->bi_bdev	= bio->bi_bdev;
+		ret->bi_sector	= bio->bi_sector;
+		ret->bi_size	= sectors << 9;
+		ret->bi_flags  |= bio->bi_flags & (1 << BIO_CACHE_RECURSE);
+		ret->bi_rw	= bio->bi_rw;
+		ret->bi_vcnt	= vcnt;
+		ret->bi_max_vecs = vcnt;
+
+		bio->bi_sector	+= sectors;
+		bio->bi_size	-= sectors << 9;
+		bio->bi_idx	 = idx;
+
+		ret->bi_private = bio;
+		ret->bi_end_io	= bio_split_endio;
+		atomic_inc(&bio->bi_remaining);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bio_split_front);
+
+#define STRTO_H(name, type)					\
+int name ## _h(const char *cp, type *res)		        \
+{								\
+	int u = 0;						\
+	char *e;						\
+	type i = simple_ ## name(cp, &e, 10);			\
+								\
+	switch (tolower(*e)) {					\
+	default:						\
+		return -EINVAL;					\
+	case 'y':						\
+	case 'z':						\
+		u++;						\
+	case 'e':						\
+		u++;						\
+	case 'p':						\
+		u++;						\
+	case 't':						\
+		u++;						\
+	case 'g':						\
+		u++;						\
+	case 'm':						\
+		u++;						\
+	case 'k':						\
+		u++;						\
+		if (e++ == cp)					\
+			return -EINVAL;				\
+	case '\n':						\
+	case '\0':						\
+		if (*e == '\n')					\
+			e++;					\
+	}							\
+								\
+	if (*e)							\
+		return -EINVAL;					\
+								\
+	while (u--) {						\
+		if ((type) ~0 > 0 &&				\
+		    (type) ~0 / 1024 <= i)			\
+			return -EINVAL;				\
+		if ((i > 0 && ANYSINT_MAX(type) / 1024 < i) ||	\
+		    (i < 0 && -ANYSINT_MAX(type) / 1024 > i))	\
+			return -EINVAL;				\
+		i *= 1024;					\
+	}							\
+								\
+	*res = i;						\
+	return 0;						\
+}                                                               \
+EXPORT_SYMBOL_GPL(name ## _h);
+
+STRTO_H(strtol, long)
+STRTO_H(strtoll, long long)
+STRTO_H(strtoul, unsigned long)
+STRTO_H(strtoull, unsigned long long)
+
+ssize_t hprint(char *buf, int64_t v)
+{
+	static const char units[] = "\0kMGTPEZY";
+	char dec[3] = "";
+	int u, t = 0;
+
+	for (u = 0; v >= 1024 || v <= -1024; u++)
+		t = do_div(v, 1024);
+
+	if (u && v < 100 && v > -100)
+		sprintf(dec, ".%i", t / 100);
+
+	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
+}
+EXPORT_SYMBOL_GPL(hprint);
diff --git a/block/bcache_util.h b/block/bcache_util.h
new file mode 100644
index 0000000..d8585b0
--- /dev/null
+++ b/block/bcache_util.h
@@ -0,0 +1,297 @@
+
+#include <linux/errno.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+
+#define DECLARE_HEAP(type, name)					\
+	struct {							\
+		size_t size, heap_size;					\
+		type *data;						\
+	} name
+
+#define DEFINE_HEAP(type, name, s)					\
+	struct {							\
+		size_t size;						\
+		const size_t heap_size;					\
+		type data[s];						\
+	} name = { .size = 0, .heap_size = s }
+
+#define heap_for_each(c, heap)						\
+	for (size_t _i = 0; c = (heap)->data[_i], _i < (heap)->size; _i++)
+
+#define init_heap(h, s, gfp)						\
+({									\
+	(h)->size = 0;							\
+	(h)->heap_size = s;						\
+	if ((h)->heap_size * sizeof(*(h)->data) >= KMALLOC_MAX_SIZE)	\
+		(h)->data = vmalloc(s * sizeof(*(h)->data));		\
+	else if (s > 0)							\
+		(h)->data = kmalloc(s * sizeof(*(h)->data), gfp);	\
+	(h)->data;							\
+})
+
+#define free_heap(h)							\
+do {									\
+	if ((h)->heap_size * sizeof(*(h)->data) >= KMALLOC_MAX_SIZE)	\
+		vfree((h)->data);					\
+	else								\
+		kfree((h)->data);					\
+} while (0)
+
+#define heap_swap(h, i, j, member)					\
+do {									\
+	swap((h)->data[i], (h)->data[j]);				\
+	(h)->data[i]->member = i;					\
+	(h)->data[j]->member = j;					\
+} while (0)
+
+#define heap_sift(h, i, member, cmp)					\
+do {									\
+	long _r, _i = i;						\
+									\
+	for (; _i * 2 + 1 < (h)->size; _i = _r) {			\
+		_r = _i * 2 + 1;					\
+		if (_r + 1 < (h)->size &&				\
+		    cmp((h)->data[_r], (h)->data[_r + 1]))		\
+			_r++;						\
+									\
+		if (cmp((h)->data[_r], (h)->data[_i]))			\
+			break;						\
+		heap_swap(h, _r, _i, member);				\
+	}								\
+} while (0)
+
+#define heap_sift_down(h, i, member, cmp)				\
+do {									\
+	while (i) {							\
+		long p = (i - 1) / 2;					\
+		if (cmp((h)->data[i], (h)->data[p]))			\
+			break;						\
+		heap_swap(h, i, p, member);				\
+		i = p;							\
+	}								\
+} while (0)
+
+#define heap_add(h, d, member, cmp)					\
+do {									\
+	long _i = (d)->member;						\
+									\
+	if (_i == -1) {							\
+		_i = (h)->size++;					\
+		(h)->data[_i]  = d;					\
+		(d)->member = _i;					\
+	}								\
+									\
+	heap_sift_down(h, _i, member, cmp);				\
+	heap_sift(h, _i, member, cmp);					\
+} while (0)
+
+#define heap_pop(h, member, cmp)					\
+({									\
+	typeof ((h)->data[0]) _r = (h)->data[0];			\
+									\
+	if ((h)->size) {						\
+		(h)->size--;						\
+		heap_swap(h, 0, (h)->size, member);			\
+		heap_sift(h, 0, member, cmp);				\
+		(h)->data[(h)->size] = NULL;				\
+		_r->member = -1;					\
+	} else								\
+		_r = NULL;						\
+	_r;								\
+})
+
+#define heap_remove(h, d, member, cmp)					\
+do {									\
+	long _i = (d)->member;						\
+									\
+	if (_i == -1)							\
+		break;							\
+									\
+	if (_i != --((h)->size)) {					\
+		heap_swap(h, _i, (h)->size, member);			\
+		heap_sift_down(h, _i, member, cmp);			\
+		heap_sift(h, _i, member, cmp);				\
+	}								\
+									\
+	(h)->data[(h)->size] = NULL;					\
+	(d)->member = -1;						\
+} while (0)
+
+#define heap_peek(h)	((h)->size ? (h)->data[0] : NULL)
+
+#define DECLARE_FIFO(type, name)					\
+	struct {							\
+		size_t front, back, size;				\
+		type *data;						\
+	} name
+
+#define fifo_for_each(c, fifo)						\
+	for (size_t _i = (fifo)->front;					\
+	     c = (fifo)->data[_i], _i != (fifo)->back;			\
+	     _i = (_i + 1) & (fifo)->size)
+
+#define init_fifo(f, s, gfp)						\
+({									\
+	BUG_ON(!s);							\
+	(f)->front = (f)->back = 0;					\
+	(f)->size = roundup_pow_of_two(s);				\
+	(f)->data = ((f)->size * sizeof(*(f)->data) >= KMALLOC_MAX_SIZE)\
+		? vmalloc((f)->size-- * sizeof(*(f)->data))		\
+		: kmalloc((f)->size-- * sizeof(*(f)->data), gfp);	\
+	(f)->data;							\
+})
+
+#define free_fifo(fifo)							\
+do {									\
+	if ((fifo)->size * sizeof(*(fifo)->data) >= KMALLOC_MAX_SIZE)	\
+		vfree((fifo)->data);					\
+	else								\
+		kfree((fifo)->data);					\
+	(fifo)->data = NULL;						\
+} while (0)
+
+#define fifo_used(fifo)		(((fifo)->back - (fifo)->front) & (fifo)->size)
+#define fifo_free(fifo)		((fifo)->size - fifo_used(fifo))
+#define fifo_full(fifo)		(fifo_free(fifo) == 0)
+#define fifo_empty(fifo)	((fifo)->front == (fifo)->back)
+
+#define fifo_push(fifo, i)						\
+({									\
+	bool _r = false;						\
+	if (!fifo_full(fifo)) {						\
+		_r = true;						\
+		(fifo)->data[(fifo)->back++] = i;			\
+		(fifo)->back &= (fifo)->size;				\
+	}								\
+	_r;								\
+})
+
+#define fifo_pop(fifo, i)						\
+({									\
+	bool _r = false;						\
+	if (!fifo_empty(fifo)) {					\
+		_r = true;						\
+		i = (fifo)->data[(fifo)->front++];			\
+		(fifo)->front &= (fifo)->size;				\
+	}								\
+	_r;								\
+})
+
+#define fifo_swap(l, r)							\
+do {									\
+	swap((l)->front, (r)->front);					\
+	swap((l)->back, (r)->back);					\
+	swap((l)->size, (r)->size);					\
+	swap((l)->data, (r)->data);					\
+} while (0)
+
+#define fifo_move(dest, src)						\
+do {									\
+	typeof (*((dest)->data)) t;					\
+	while (!fifo_full(dest) &&					\
+	       fifo_pop(src, t))					\
+		fifo_push(dest, t);					\
+} while (0)
+
+/*
+ * These are subject to the infamous aba problem...
+ */
+
+#define lockless_list_push(new, list, member)				\
+	do {								\
+		(new)->member = list;					\
+	} while (cmpxchg(&(list), (new)->member, new) != (new)->member)	\
+
+#define lockless_list_pop(list, member) ({				\
+	typeof(list) _r;						\
+	do {								\
+		_r = list;						\
+	} while (_r && cmpxchg(&(list), _r, _r->member) != _r);		\
+	_r; })
+
+#define ANYSINT_MAX(t)						\
+	((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
+
+int strtol_h(const char *, long *);
+int strtoll_h(const char *, long long *);
+int strtoul_h(const char *, unsigned long *);
+int strtoull_h(const char *, unsigned long long *);
+
+#define strtoi_h(cp, res)						\
+	(__builtin_types_compatible_p(typeof(*res), long)		\
+	? strtol_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), long long)		\
+	? strtoll_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), unsigned long)	\
+	? strtoul_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), unsigned long long)\
+	? strtoull_h(cp, (void *) res) : -EINVAL)
+
+ssize_t hprint(char *buf, int64_t v);
+
+struct bio *bio_split_front(struct bio *, int, struct bio *(alloc_fn)(int));
+
+#define RB_INSERT(root, new, member, cmp)				\
+({									\
+	__label__ dup;							\
+	struct rb_node **n = &(root)->rb_node, *parent = NULL;		\
+	int res, ret = -1;						\
+									\
+	while (*n) {							\
+		parent = *n;						\
+		res = cmp(new, container_of(*n, typeof(*(new)), member));\
+		if (!res)						\
+			goto dup;					\
+		n = res < 0						\
+			? &(*n)->rb_left				\
+			: &(*n)->rb_right;				\
+	}								\
+									\
+	rb_link_node(&(new)->member, parent, n);			\
+	rb_insert_color(&(new)->member, root);				\
+	ret = 0;							\
+dup:									\
+	ret;								\
+})
+
+#define RB_SEARCH(root, search, member, cmp)				\
+{									\
+	struct rb_node *n = (root)->rb_node;				\
+	typeof(&(search)) r, ret = NULL;				\
+	int res;							\
+									\
+	while (n) {							\
+		r = container_of(n, typeof(search), member);		\
+		res = cmp(r, &(search));				\
+		if (!r) {						\
+			ret = r;					\
+			break;						\
+		}							\
+		n = res < 0						\
+			? n->rb_left					\
+			: n->rb_right;					\
+	}								\
+	ret;								\
+}
+
+#define RB_SEARCH_GREATER(root, search, member, cmp)			\
+({									\
+	struct rb_node *n = (root)->rb_node;				\
+	typeof(&(search)) r, ret = NULL;				\
+	int res;							\
+									\
+	while (n) {							\
+		r = container_of(n, typeof(search), member);		\
+		res = cmp(r, &(search));				\
+		if (res > 0) {						\
+			ret = r;					\
+			n = n->rb_left;					\
+		} else							\
+			n = n->rb_right;				\
+	}								\
+	ret;								\
+})
+
+#define RB_FIRST(root, type, member)					\
+	(root ? container_of(rb_first(root), type, member) : NULL)
diff --git a/block/blk-core.c b/block/blk-core.c
index f0640d7..4d54e9e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1428,11 +1428,11 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
  * bi_sector for remaps as it sees fit.  So the values of these fields
  * should NOT be depended on after the call to generic_make_request.
  */
-static inline void __generic_make_request(struct bio *bio)
+inline void __generic_make_request(struct bio *bio)
 {
 	struct request_queue *q;
 	sector_t old_sector;
-	int ret, nr_sectors = bio_sectors(bio);
+	int ret = 1, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 	int err = -EIO;
 
@@ -1505,7 +1505,10 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
-		ret = q->make_request_fn(q, bio);
+		if (bio->bi_bdev->bd_cache_fn)
+			ret = bio->bi_bdev->bd_cache_fn(q, bio);
+		if (ret)
+			ret = q->make_request_fn(q, bio);
 	} while (ret);
 
 	return;
@@ -1513,6 +1516,7 @@ static inline void __generic_make_request(struct bio *bio)
 end_io:
 	bio_endio(bio, err);
 }
+EXPORT_SYMBOL_GPL(__generic_make_request);
 
 /*
  * We only want one ->make_request_fn to be active at a time,
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..aeec1e6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -257,6 +257,7 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_comp_cpu = -1;
 	atomic_set(&bio->bi_cnt, 1);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_init);
 
@@ -452,10 +453,12 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_sector = bio_src->bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_flags |= bio_src->bi_flags & (1 << BIO_CACHE_RECURSE);
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
 	bio->bi_idx = bio_src->bi_idx;
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -1422,16 +1425,28 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	int r;
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (bio->bi_end_io)
+	r = atomic_dec_return(&bio->bi_remaining);
+	BUG_ON(r < 0);
+
+	if (!r && bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
 EXPORT_SYMBOL(bio_endio);
 
+void bio_split_endio(struct bio *bio, int error)
+{
+	struct bio *p = bio->bi_private;
+	bio_put(bio);
+	bio_endio(p, error);
+}
+EXPORT_SYMBOL(bio_split_endio);
+
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..5bf7e9a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -94,6 +94,8 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
+	atomic_t		bi_remaining;	/* split count */
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
@@ -126,6 +128,7 @@ struct bio {
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
+#define BIO_CACHE_RECURSE 12	/* Bcache recursion hack for writeback */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -364,6 +367,7 @@ extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
 
 extern void bio_endio(struct bio *, int);
+extern void bio_split_endio(struct bio *bio, int error);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..8978c29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -347,6 +347,7 @@ struct request_queue
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
+	unplug_fn		*cache_unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
@@ -772,6 +773,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
+extern void __generic_make_request(struct bio *bio);
 extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..489413b 100644
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
@@ -665,6 +667,9 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+
+	int (*bd_cache_fn)(struct request_queue *q, struct bio *bio);
+	unsigned char		bd_cache_identifier;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0478888..e37b9c5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1504,6 +1504,10 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#if defined(CONFIG_BLK_CACHE) || defined(CONFIG_BLK_CACHE_MODULE)
+	unsigned int	nr_ios;
+	unsigned int	sequential_io;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/fork.c b/kernel/fork.c
index b6cce14..1de14a7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1118,6 +1118,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
+#ifdef CONFIG_BLK_CACHE
+	p->sequential_io = p->nr_ios = 0;
+#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
