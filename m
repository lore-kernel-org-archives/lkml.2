Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0FNQRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:17:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46326 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab0FNQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w6btzJAsYAkm4m82/vdKkfJxNqACZ36ALYSIlB7IANy06NjGJIdAZii+ODWlS9SGLa
         yP47eXabAis99SHl7ou54m3H/6hFk+A+2O8dmwVNDE4YzSMQPVpF7G+jOpKcWsAvVUr2
         b322eOytgPtC1l3B56gn/+XXdke9J2jQcPTgk=
Date: Mon, 14 Jun 2010 09:16:59 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/3] Bcache: Version 5 - The code
Message-ID: <20100614161658.GB945@moria>
References: <20100614153706.GA31477@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614153706.GA31477@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 block/Makefile |    2 +
 block/bcache.c | 3485 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 3487 insertions(+), 0 deletions(-)

diff --git a/block/Makefile b/block/Makefile
index 0bb499a..617845c 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+
+obj-$(CONFIG_BLK_CACHE)		+= bcache.o
diff --git a/block/bcache.c b/block/bcache.c
new file mode 100644
index 0000000..b41f64a
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,3485 @@
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
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+/*
+ * Todo:
+ * garbage collection: in non root nodes pointers are invalidated if previous
+ * bucket overwrites, need to remove them.
+ *
+ * echo "`blkid /dev/loop0 -s UUID -o value` /dev/loop0"
+ *
+ * Error handling in fill_bucket
+ *
+ * If btree_insert_recurse can't recurse, it's critical that it tries harder
+ * and/or returns the error all the way up if it came from a write - verify
+ *
+ * Fix cache hit counting, split cache hits shouldn't count for each split
+ *
+ * Need to insert null keys on write if there's multiple cache devices, and on
+ * error
+ *
+ * bio_split_front: can't modify io_vec if original bio was cloned
+ *	no, it's more complicated than that
+ *
+ * Fix mark and sweep garbage collection, check key merging in insert_one_key
+ *
+ * get_bucket should be checking the gen, not priority
+ *
+ * Make registering partitions to cache work
+ *
+ * Test module load/unload
+ *
+ * bio_insert: don't insert keys until write completes successfully
+ *
+ * Check if a device is opened read/write when caching is turned on or off for
+ * it, and invalidate cached data (Idea: pin the first 4k? 8k? in the cache,
+ * verify it against the cached copy when caching's turned on)
+ *
+ * Need to make sure the page cache writes out our dirty pages either not at
+ * all, or preferably correctly; if the latter get_bucket won't need to write
+ * anymore.
+ *
+ * IO error handling
+ *
+ * Future:
+ * Journaling
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
+	else							\
+		kfree((f)->data);				\
+	(f)->data = NULL;					\
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
+/*
+ * These are subject to the infamous aba problem...
+ */
+
+#define lockless_list_push(new, list, member) 				\
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
+typedef void (search_fn) (struct search_context *);
+
+struct cache_sb {
+	uint8_t  magic[16];
+#define CACHE_CLEAN	1
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
+	uint8_t		gen;
+	uint8_t		last_gc;
+};
+
+struct bucket_gc {
+	uint8_t		gen;
+	uint8_t		mark;
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
+struct btree_key {
+	uint64_t	key;
+	uint64_t	ptr;
+};
+
+struct cache_device {
+	struct list_head	list;
+	struct cache_sb		sb;
+	struct page		*sb_page;
+	struct bio		*sb_bio;
+	spinlock_t		sb_lock;
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
+	spinlock_t		bucket_lock;
+	struct bucket		**heap;
+	struct bucket		*buckets;
+	struct bucket_disk	*disk_buckets;
+	size_t			heap_size;
+	long			rescale;
+	uint8_t			need_gc;
+
+	struct bio		*priority_bio;
+
+	struct semaphore	gc_lock;
+	struct bucket_gc	*garbage;
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
+	unsigned long		cache_hits;
+	unsigned long		sectors_written;
+
+	struct cached_bucket	*root;
+};
+
+struct open_bucket {
+	struct list_head	list;
+	struct cache_device	*cache;
+	struct task_struct	*last;
+
+	struct btree_key	key;
+	sector_t		offset;
+	unsigned		sectors_free;
+	uint8_t			gen;
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
+	struct search_context	*next;
+	search_fn		*end_fn;
+	search_fn		*parent;
+	atomic_t		remaining;
+#define	SEARCH_BLOCK		1
+#define	SEARCH_WAITING		2
+	int			flags;
+
+	struct btree_key	new_keys[2];
+	int 			nkeys;
+	int 			level;
+	struct btree_key	*keylist;
+	int			nkeylist;
+
+	int			error;
+	void			*q;
+	struct bio		*bio;
+
+	struct bio		*cache_bio;
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
+static DEFINE_SPINLOCK(open_bucket_lock);
+
+static DECLARE_WAIT_QUEUE_HEAD(pending);
+
+static struct workqueue_struct *delayed;
+
+/*
+ * Sysfs vars / tunables
+ */
+static unsigned long cache_hits, cache_misses, rescale = 204800; /* sectors */
+static uint16_t	initial_priority = 32768;
+static uint16_t cache_hit_priority = 100, cache_hit_seek = 100;
+
+static struct bio *write_super(struct cache_device *);
+static struct bio *save_priorities(struct cache_device *);
+static void do_btree_gc(struct work_struct *);
+static void unregister_cache(struct kobject *);
+static void run_search(struct work_struct *);
+static void fill_bucket_endio(struct bio *bio, int error);
+static int request_hook_read(struct request_queue *q, struct bio *bio,
+			     struct search_context *s);
+
+#define label(l, foo)	if (0) { l: foo; }
+
+#define PAGE_SECTORS		(PAGE_SIZE / 512)
+#define pages(c, s)		(((sizeof(s) * c->sb.nbuckets) - 1) / PAGE_SIZE + 1)
+#define pages_per_bucket(b)	(b->c->sb.bucket_size / PAGE_SECTORS)
+#define pages_per_btree		(c->sb.bucket_size / PAGE_SECTORS)
+#define keys_per_page		(PAGE_SIZE / sizeof(struct btree_key))
+
+#define bucket_to_sector(c, b)	(((sector_t) (b) + c->sb.first_bucket) * c->sb.bucket_size)
+#define sector_to_struct(c, s)	(c->buckets + sector_to_bucket(c, s))
+#define sector_to_gen(c, s)	({ smp_rmb(); sector_to_struct(c, s)->gen; })
+#define sector_to_priority(c, s) ({ smp_rmb(); sector_to_struct(c, s)->priority; })
+#define bucket_to_ptr(b)	TREE_PTR(sector_to_gen(b->c, b->offset), 0, b->offset)
+
+#define sector_to_bucket(c, s)	({					\
+	uint64_t _s = (s);						\
+	do_div(_s, c->sb.bucket_size);					\
+	(long) _s - c->sb.first_bucket; })
+
+#define bucket_key(b)		((struct btree_key) {			\
+				 .key = node(data(b), header(b)->nkeys)->key,\
+				 .ptr = bucket_to_ptr(b) })
+
+#define data(b)			((struct btree_key **) &(b)->pages[pages_per_bucket(b)])
+#define keys(i)			(((struct btree_node_header *) *(i))->nkeys)
+#define rand(i)			(((struct btree_node_header *) *(i))->random)
+#define header(b)		((struct btree_node_header *) data(b)[0])
+#define index(i, b)		((int) (i - data(b)))
+#define last_key(i)		(node(i, keys(i))->key)
+
+/*
+ * key: 8 bit device, 56 bit offset
+ * value: 8 bit generation, 16 bit length, 40 bit offset
+ * All units are in sectors
+ */
+
+#define TREE_KEY(device, offset)	(((uint64_t) device) << 56 | (offset))
+#define KEY_DEV(k)			((int) ((k)->key >> 56))
+#define KEY_OFFSET(k)			((k)->key & ~((int64_t) ~0 << 56))
+
+#define TREE_PTR(gen, length, offset)	((uint64_t) ((gen) | ((length) << 8) | ((uint64_t) (offset) << 24)))
+#define PTR_GEN(k)			((uint8_t) ((k)->ptr & ~(~0 << 8)))
+#define PTR_SIZE(k)			((int) ((k)->ptr >> 8) & ~(~0 << 16))
+#define PTR_OFFSET(k)			((int64_t) (((k)->ptr) >> 24))
+
+#define PTR_BUCKET(c, ptr)		sector_to_struct(c, PTR_OFFSET(ptr))
+#define KEY_OVERLAP(i, j)		((int64_t) (i)->key - ((j)->key - PTR_SIZE(j)))
+
+static inline struct btree_key *node(struct btree_key *d[], int i)
+{
+	return d[i / keys_per_page] + (i % keys_per_page);
+}
+
+#define rw_lock(_w, _b)						\
+	(_w ? down_write_nested(&(_b)->lock, (_b)->level + 1)	\
+	    : down_read_nested(&(_b)->lock, (_b)->level + 1))
+
+#define rw_unlock(_w, _b)					\
+	(_w ? up_write(&(_b)->lock) : up_read(&(_b)->lock))
+
+static void check_bio(struct bio *bio)
+{
+	int i, size = 0;
+	struct bio_vec *bv;
+	BUG_ON(!bio->bi_vcnt);
+	BUG_ON(!bio->bi_size);
+
+	bio_for_each_segment(bv, bio, i)
+		size += bv->bv_len;
+
+	BUG_ON(size != bio->bi_size);
+	BUG_ON(size > queue_max_sectors(bdev_get_queue(bio->bi_bdev)) << 9);
+}
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
+static struct bio *bio_split_front(struct bio *bio, int sectors,
+				   struct bio *(alloc_fn)(int))
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
+		pr_debug("split %i sectors from %u %s, idx was %i now %i",
+			 sectors, bio_sectors(bio),
+			 nbytes ? "mid bio_vec" : "cleanly",
+			 bio->bi_idx, idx);
+
+		ret->bi_bdev	= bio->bi_bdev;
+		ret->bi_sector	= bio->bi_sector;
+		ret->bi_size	= sectors << 9;
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
+
+		check_bio(ret);
+	}
+
+	return ret;
+}
+
+static void submit_bio_list(int rw, struct bio *bio)
+{
+	while (bio) {
+		int max = queue_max_sectors(bdev_get_queue(bio->bi_bdev));
+		struct bio *split, *n = bio->bi_next;
+		bio->bi_next = NULL;
+		do {
+			if (!(split = bio_split_front(bio, max, NULL))) {
+				bio_endio(bio, -ENOMEM);
+				return;
+			}
+			submit_bio(rw, split);
+		} while (split != bio);
+
+		bio = n;
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
+static int lookup_id(struct cache_device *c, int id)
+{
+	int dev;
+	for (dev = 0; dev < UUIDS_PER_SB; dev++)
+		if (c->devices[dev] == id)
+			break;
+
+	if (dev == UUIDS_PER_SB)
+		printk(KERN_DEBUG "bcache: unknown device %i", id);
+
+	return dev;
+}
+
+static int lookup_dev(struct cache_device *c, struct bio *bio)
+{	return lookup_id(c, bio->bi_bdev->bd_cache_identifier); }
+
+static void run_search(struct work_struct *w)
+{
+	struct search_context *s = container_of(w, struct search_context, w);
+	search_fn *f = NULL;
+	swap(f, s->end_fn);
+	atomic_set(&s->remaining, 1);
+	f(s);
+}
+
+static void put_search(struct search_context *s)
+{
+	BUG_ON(object_is_on_stack(s));
+	if (atomic_dec_and_test(&s->remaining)) {
+		BUG_ON(s->flags & SEARCH_WAITING);
+		smp_rmb();
+		if (!s->end_fn)
+			kfree(s);
+		else
+			BUG_ON(!queue_work(delayed, &s->w));
+	} else
+		BUG_ON(atomic_read(&s->remaining) < 0);
+}
+
+#define return_f(s, f, ...)						\
+	do {								\
+		if ((s) && !object_is_on_stack(s)) {			\
+			(s)->end_fn = f;				\
+			smp_wmb();					\
+			put_search(s);					\
+		}							\
+		return __VA_ARGS__;					\
+	} while (0)
+
+#define run_wait_list(condition, list) ({				\
+	smp_mb();							\
+	if (condition) {						\
+		struct search_context *_s, *_next;			\
+		for (_s = xchg(&(list), NULL); _s; _s = _next) {	\
+			_next = _s->next;				\
+			_s->flags &= ~SEARCH_WAITING;			\
+			if (_s->flags & SEARCH_BLOCK)			\
+				wake_up(&pending);			\
+			else						\
+				put_search(_s);				\
+		}							\
+	} })
+
+#define wait_search(condition, list, s) ({				\
+	if (!(condition) &&						\
+	    !IS_ERR(s = alloc_search(s)) &&				\
+	    !((s)->flags & SEARCH_WAITING)) {				\
+		(s)->flags |= SEARCH_WAITING;				\
+		atomic_inc(&(s)->remaining);				\
+		smp_mb__after_atomic_inc();				\
+		lockless_list_push(s, list, next);			\
+		if ((s)->flags & SEARCH_BLOCK)				\
+			wait_event(pending, condition);			\
+		run_wait_list(condition, list);				\
+	}								\
+	s; })
+
+static struct search_context *alloc_search(struct search_context *s)
+{
+	struct search_context *r = s;
+	if (!s || (object_is_on_stack(s) &&
+		   !(s->flags & SEARCH_BLOCK))) {
+		if (!(r = kzalloc(sizeof(*r), GFP_NOIO)))
+			return ERR_PTR(-ENOMEM);
+
+		if (s)
+			*r = *s;
+
+		atomic_set(&r->remaining, 1);
+		INIT_WORK(&r->w, run_search);
+	} else if (s && !(s->flags & SEARCH_BLOCK))
+		BUG_ON(!atomic_read(&(s)->remaining));
+	return r;
+}
+
+static uint8_t __inc_bucket_gen(struct cache_device *c, long b)
+{
+	uint8_t ret = ++c->buckets[b].gen;
+	pr_debug("bucket %li: %p %p %p", b,
+		 __builtin_return_address(0),
+		 __builtin_return_address(1),
+		 __builtin_return_address(2));
+	c->need_gc = max_t(uint8_t, c->need_gc,
+			   ret - c->buckets[b].last_gc);
+
+	if (c->need_gc > 64 && !down_trylock(&c->gc_lock)) {
+		long i;
+		memset(c->garbage, 0,
+		       c->sb.nbuckets * sizeof(struct bucket_gc));
+
+		for (i = 0; i < c->sb.nbuckets; i++)
+			c->garbage[i].gen = c->buckets[i].gen;
+
+		pr_debug("starting gc");
+		INIT_WORK(&c->work, do_btree_gc);
+		queue_work(delayed, &c->work);
+	}
+	return ret;
+}
+
+static uint8_t inc_bucket_gen(struct cache_device *c, long b)
+{
+	uint8_t ret;
+	spin_lock(&c->bucket_lock);
+	ret = __inc_bucket_gen(c, b);
+	spin_unlock(&c->bucket_lock);
+	return ret;
+}
+
+#define inc_gen(c, o)	inc_bucket_gen(c, sector_to_bucket(c, o))
+
+static struct bio *__rescale_heap(struct cache_device *c, int sectors)
+{
+	long i;
+	c->rescale -= sectors;
+	if (c->rescale <= 0) {
+		pr_debug("");
+		for (i = 0; i < c->heap_size; i++) {
+			uint16_t t = c->heap[i]->priority - 10;
+			BUG_ON(c->heap[i]->priority == (uint16_t) ~0);
+
+			c->heap[i]->priority =
+				t > c->heap[i]->priority ? 0 : t;
+		}
+		c->rescale += rescale;
+
+		return save_priorities(c);
+	}
+	return NULL;
+}
+
+static void rescale_heap(struct cache_device *c, int sectors)
+{
+	struct bio *bio;
+	spin_lock(&c->bucket_lock);
+	bio = __rescale_heap(c, sectors);
+	spin_unlock(&c->bucket_lock);
+	submit_bio_list(WRITE, bio);
+}
+
+#define heap_cmp(i, j)	(c->heap[i]->priority >= c->heap[j]->priority)
+
+static void heap_swap(struct cache_device *c, long i, long j)
+{
+	swap(c->heap[i], c->heap[j]);
+	c->heap[i]->heap = i;
+	c->heap[j]->heap = j;
+}
+
+static int heap_cmp_swap(struct cache_device *c, long i, long j)
+{
+	if (heap_cmp(i, j))
+		return 1;
+	heap_swap(c, i, j);
+	return 0;
+}
+
+static void heap_sift(struct cache_device *c, long h)
+{
+	long r;
+
+	for (; h * 2 + 1 < c->heap_size; h = r) {
+		r = h * 2 + 1;
+		if (r + 1 < c->heap_size &&
+		    heap_cmp(r, r + 1))
+			r++;
+
+		if (heap_cmp_swap(c, r, h))
+			break;
+	}
+}
+
+static void heap_insert(struct cache_device *c, long b)
+{
+	if (c->buckets[b].heap == -1) {
+		long p, h = c->heap_size++;
+
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+		c->buckets[b].heap = h;
+		c->heap[h] = &c->buckets[b];
+
+		for (p = (h - 1) / 2; p; h = p, p = (h - 1) / 2)
+			if (heap_cmp_swap(c, h, p))
+				break;
+
+		heap_sift(c, h);
+
+		pr_debug("inserted bucket %li, new heap size %zu, heap location %zu",
+			 b, c->heap_size, c->buckets[b].heap);
+	} else
+		heap_sift(c, c->buckets[b].heap);
+}
+
+static long heap_pop(struct cache_device *c)
+{
+	long ret = c->heap[0] - c->buckets;
+
+	if (!c->heap_size) {
+		printk(KERN_ERR "bcache: empty heap!");
+		return -1;
+	}
+
+	__inc_bucket_gen(c, ret);
+	smp_mb();
+	if (atomic_read(&c->heap[0]->pin)) {
+		pr_debug("priority %i bucket %li: not popping, pinned",
+			 c->buckets[ret].priority, ret);
+		return -1;
+	}
+
+	heap_swap(c, 0, --c->heap_size);
+	heap_sift(c, 0);
+
+	c->heap[c->heap_size] = NULL;
+
+	pr_debug("priority %i bucket %li",
+		 c->buckets[ret].priority, ret);
+
+	c->buckets[ret].priority = 0;
+	c->buckets[ret].heap = -1;
+	return ret;
+}
+
+static long pop_bucket(struct cache_device *c, uint16_t priority)
+{
+	long r;
+
+	while (!fifo_full(&c->free)) {
+		r = heap_pop(c);
+
+		if (r == -1)
+			break;
+
+		fifo_push(&c->free, r);
+
+		if (blk_queue_discard(bdev_get_queue(c->bdev))) {
+			spin_unlock(&c->bucket_lock);
+			/* should do this asynchronously */
+			blkdev_issue_discard(c->bdev, bucket_to_sector(c, r),
+					     c->sb.bucket_size, GFP_NOIO, 0);
+			spin_lock(&c->bucket_lock);
+		}
+	}
+
+	if (!fifo_pop(&c->free, r))
+		r = -1;
+
+	if (r != -1)
+		c->buckets[r].priority = priority;
+
+	pr_debug("popping bucket %li prio %u", r, priority);
+	return r;
+}
+
+static void free_bucket_contents(struct cached_bucket *b)
+{
+	int i;
+
+	for (i = 0; i < pages_per_bucket(b); i++)
+		if (b->pages[i]) {
+			ClearPageDirty(b->pages[i]);
+			kunmap(b->pages[i]);
+			put_page(b->pages[i]);
+			b->pages[i] = NULL;
+		}
+#if 0
+	struct address_space *mapping = p[0]->mapping;
+
+	spin_lock_irq(&mapping->tree_lock);
+	for (i = 0; i < pages; i++)
+		__remove_from_page_cache(p[i]);
+	spin_unlock_irq(&mapping->tree_lock);
+#endif
+}
+
+static int fill_bucket(struct cached_bucket *b, struct search_context **s)
+{
+	struct cache_device *c = b->c;
+	int i, nread = 0, ret = 0;
+	struct bio *bio = NULL;
+	struct bio_list list;
+	bio_list_init(&list);
+
+	/*nread = find_get_pages(c->bdev->bd_inode->i_mapping,
+			       (b->offset >> (PAGE_SHIFT - 9)),
+			       pages_per_bucket(b), b->pages);*/
+
+	for (i = 0; i < pages_per_bucket(b); i++)
+		b->pages[i] = find_get_page(c->bdev->bd_inode->i_mapping,
+					    b->offset / PAGE_SECTORS + i);
+
+	for (i = 0; i < pages_per_bucket(b); i++)
+		if (!b->pages[i]) {
+			b->pages[i] = __page_cache_alloc(GFP_NOIO);
+			b->pages[i]->mapping = c->bdev->bd_inode->i_mapping;
+			if (add_to_page_cache_lru(b->pages[i],
+						  c->bdev->bd_inode->i_mapping,
+						  b->offset / PAGE_SECTORS + i,
+						  GFP_NOIO)) {
+				/* XXX: need to check for actual errors
+				 * This code path should never happen anyways
+				 * since fill_bucket is now called with write
+				 * lock held on bucket
+				 */
+				page_cache_release(b->pages[i]);
+				b->pages[i] = find_get_page(c->bdev->bd_inode->i_mapping,
+							    b->offset / PAGE_SECTORS + i);
+				BUG_ON(!b->pages[i]);
+				goto wait;
+			}
+
+			unlock_page(b->pages[i]);
+
+			if (!bio) {
+				if (!(bio = bio_kmalloc(GFP_NOIO,
+						  pages_per_bucket(b) - nread)))
+					goto err;
+
+				if (bio_list_empty(&list)) {
+					bio->bi_private = b;
+					bio->bi_end_io = fill_bucket_endio;
+				} else {
+					bio->bi_private = list.head;
+					bio->bi_end_io = bio_split_endio;
+					atomic_inc(&list.head->bi_remaining);
+				}
+				bio_list_add(&list, bio);
+
+				bio->bi_bdev = c->bdev;
+				bio->bi_sector = b->offset + i * PAGE_SECTORS;
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
+wait:			bio = NULL;
+			if (i == ret)
+				ret++;
+			data(b)[i] = kmap(b->pages[i]);
+		}
+
+	for (i = 0; i < pages_per_bucket(b); i++)
+		BUG_ON(b->offset + i * PAGE_SECTORS
+		       != page_index(b->pages[i]) * PAGE_SECTORS);
+
+	atomic_set(&b->nread, ret);
+	submit_bio_list(READ, list.head);
+	return 0;
+err:
+	/* XXX: flag error on this bucket here */
+	return -1;
+}
+
+static void write_endio(struct bio *bio, int error)
+{
+	int i;
+	struct cache_device *c = bio->bi_private;
+	if (error) {
+		printk(KERN_ERR "bcache: write error");
+		c = c; /* flag error here */
+	}
+
+	for (i = 0; i < bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+}
+
+static void __btree_write(struct cached_bucket *b, int skip,
+			  int n, sector_t offset)
+{
+	int i;
+	struct cache_device *c = b->c;
+	struct bio *bio = NULL;
+
+	BUG_ON(n > pages_per_bucket(b));
+
+	for (i = skip; i < n; i++) {
+		if (!b->pages[i])
+			continue;
+
+		if (!b->pages[i] || !PageDirty(b->pages[i])) {
+			submit_bio_list(WRITE, bio);
+			bio = NULL;
+			continue;
+		}
+
+		BUG_ON(offset + i * PAGE_SECTORS
+		       != page_index(b->pages[i]) * PAGE_SECTORS);
+
+		if (bio && bio->bi_vcnt >= 4) {
+			submit_bio_list(WRITE, bio);
+			bio = NULL;
+		}
+
+		if (!bio) {
+			if (!(bio = bio_kmalloc(GFP_NOIO, n - i))) {
+				pr_debug("couldn't allocate bio!");
+				return;
+			}
+
+			bio->bi_sector	= page_index(b->pages[i]) * PAGE_SECTORS;
+			bio->bi_bdev	= c->bdev;
+
+			bio->bi_end_io	= write_endio;
+			bio->bi_private	= c;
+			pr_debug("sector %llu pages %i",
+				 (uint64_t) bio->bi_sector, n - i);
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
+	submit_bio_list(WRITE, bio);
+}
+
+static void btree_write(struct cached_bucket *b, int skip)
+{
+	int n = keys(&data(b)[skip]) / keys_per_page + 1;
+
+	if (((keys(&data(b)[skip]) + 1) % keys_per_page) == 0 &&
+	    PageDirty(b->pages[skip]))
+		__btree_write(b, skip, n + skip, b->offset);
+}
+
+static bool ptr_bad(struct cached_bucket *b, struct btree_key *k)
+{
+	sector_t bucket = PTR_OFFSET(k);
+	long r = do_div(bucket, b->c->sb.bucket_size);
+
+	if (!k->key ||
+	    (b->level && (PTR_SIZE(k) || r)) ||
+	    (!b->level && !PTR_SIZE(k)))
+		return true;
+
+	if (bucket <  b->c->sb.first_bucket ||
+	    bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets ||
+	    PTR_SIZE(k) + r > b->c->sb.bucket_size)
+		return true;
+
+	return PTR_GEN(k) != sector_to_gen(b->c, PTR_OFFSET(k));
+}
+
+static void ptr_status(struct cached_bucket *b, struct btree_key *k, char *buf)
+{
+	sector_t bucket = PTR_OFFSET(k);
+	long r = do_div(bucket, b->c->sb.bucket_size);
+	uint8_t stale = 0;
+
+	*buf = 0;
+	if (bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets)
+		sprintf(buf, "bad, offset past end of device");
+	if (bucket <  b->c->sb.first_bucket)
+		sprintf(buf, "bad, short offset");
+	if (!PTR_OFFSET(k) ||
+	    (!b->level && !PTR_SIZE(k)))
+		sprintf(buf, "zeroed key");
+	if (PTR_SIZE(k) + r > b->c->sb.bucket_size)
+		sprintf(buf, "bad, length too big");
+
+	if (!*buf)
+		stale = sector_to_gen(b->c, PTR_OFFSET(k)) - PTR_GEN(k);
+	if (stale)
+		sprintf(buf, "stale %i", stale);
+}
+
+struct cached_bucket *get_last_bucket_or_alloc(struct cache_device *c,
+					       struct cached_bucket **n,
+					       sector_t offset, int level,
+					       int count, bool lru)
+{
+	struct cached_bucket *b;
+	sector_t old_offset = 0;
+
+	b = list_entry(c->lru.prev, struct cached_bucket, lru);
+	if (count >= c->btree_buckets_cached &&
+	    atomic_read(&b->nread) == pages_per_btree &&
+	    down_write_trylock(&b->lock)) {
+		BUG_ON(b->wait);
+		list_del(&b->lru);
+		old_offset = b->offset;
+	} else if (n && *n) {
+		b = *n, *n = NULL;
+		down_write_trylock(&b->lock);
+	} else {
+		spin_unlock(&c->bucket_lock);
+		b = kzalloc(sizeof(*b) + sizeof(void *) *
+			     pages_per_btree * 2, GFP_NOIO);
+		if (!b)
+			return ERR_PTR(-ENOMEM);
+		init_rwsem(&b->lock);
+
+		if (n) {
+			*n = b;
+			return NULL;
+		}
+		spin_lock(&c->bucket_lock);
+		down_write_trylock(&b->lock);
+	}
+
+	b->offset = offset;
+	b->c = c;
+	b->level = level;
+	atomic_set(&b->nread, 0);
+
+	if (lru)
+		list_add(&b->lru, &c->lru);
+	else
+		INIT_LIST_HEAD(&b->lru);
+
+	spin_unlock(&c->bucket_lock);
+
+	if (old_offset)
+		__btree_write(b, 0, pages_per_btree, old_offset);
+	free_bucket_contents(b);
+
+	return b;
+}
+
+static struct cached_bucket *__get_bucket(struct cache_device *c,
+					  sector_t offset, int level,
+					  bool write, struct search_context **s)
+{
+	int i;
+	struct cached_bucket *b, *n = NULL;
+retry:
+	if (sector_to_priority(c, offset) != (uint16_t) ~0)
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
+	b = get_last_bucket_or_alloc(c, &n, offset, level, i, true);
+	if (!b)
+		goto retry;
+	if (IS_ERR(b))
+		goto err;
+
+	if (fill_bucket(b, s)) {
+		/* fill bucket errors, those pages don't point to the right place */
+		rw_unlock(true, b);
+		run_wait_list(1, b->wait);
+		goto err;
+	}
+
+	if (!write)
+		downgrade_write(&b->lock);
+out:
+	if (IS_ERR(wait_search(atomic_read(&b->nread) == pages_per_bucket(b),
+			       b->wait, *s))) {
+		rw_unlock(write, b);
+		goto err;
+	}
+
+	if (sector_to_priority(c, offset) == (uint16_t) ~0)
+		goto real_out;
+
+	rw_unlock(write, b);
+freed:
+	pr_debug("bucket %llu has been freed, gen %i, called from %p",
+		 (uint64_t) offset, sector_to_gen(c, offset),
+		 __builtin_return_address(1));
+	b = NULL;
+	goto real_out;
+err:
+	printk(KERN_WARNING "bcache: error allocating memory");
+	b = ERR_PTR(-ENOMEM);
+real_out:
+	kfree(n);
+	return b;
+}
+
+static struct cached_bucket *get_bucket(struct cached_bucket *b,
+					struct btree_key *k,
+					bool write, struct search_context **s)
+{
+	struct cached_bucket *r;
+	BUG_ON(!b->level);
+	r = __get_bucket(b->c, PTR_OFFSET(k), b->level - 1, write, s);
+	if (!r && !ptr_bad(b, k))
+		inc_gen(b->c, PTR_OFFSET(k));
+	return r;
+}
+
+static struct cached_bucket *upgrade_bucket(bool *w, struct cached_bucket *b,
+					    struct search_context **s)
+{
+	int level = b->level;
+	sector_t offset = b->offset;
+
+	if (*w)
+		return b;
+	*w = true;
+
+	rw_unlock(false, b);
+	rw_lock(true, b);
+
+	if (sector_to_priority(b->c, b->offset) != (uint16_t) ~0) {
+		rw_unlock(true, b);
+		return NULL;
+	}
+
+	if (b->offset != offset) {
+		rw_unlock(true, b);
+		return __get_bucket(b->c, offset, level, true, s);
+	}
+	return b;
+}
+
+static void btree_free(struct cached_bucket *b, bool discard)
+{
+	struct cache_device *c = b->c;
+	long n = sector_to_bucket(c, b->offset);
+	BUG_ON(n < 0 || n > c->sb.nbuckets);
+	BUG_ON(b == c->root);
+
+	spin_lock(&c->bucket_lock);
+
+	__inc_bucket_gen(c, n);
+	smp_wmb();
+	c->buckets[n].priority = 0;
+
+	if (!fifo_push(&c->free, n))
+		heap_insert(c, n);
+
+	free_bucket_contents(b);
+
+	if (list_empty(&b->lru))
+		list_add(&b->lru, &c->lru);
+
+	spin_unlock(&c->bucket_lock);
+	run_wait_list(1, b->wait);
+
+	if (discard)
+		blkdev_issue_discard(c->bdev, b->offset,
+				     c->sb.bucket_size, GFP_NOIO, 0);
+
+	pr_debug("bucket %li, sector %llu called from %p %p",
+		 n, (uint64_t) b->offset,
+		 __builtin_return_address(0),
+		 __builtin_return_address(1));
+}
+
+static struct cached_bucket *btree_alloc(struct cache_device *c, int level,
+					 struct btree_key *old[],
+					 int nkeys, int skip, bool lru)
+{
+	long i = 0, bucket;
+	struct btree_node_header *h;
+	struct cached_bucket *b = NULL;
+	const char *err = "unable to alloc bucket";
+
+	spin_lock(&c->bucket_lock);
+	if ((bucket = pop_bucket(c, ~0)) == -1) {
+		spin_unlock(&c->bucket_lock);
+		goto err;
+	}
+
+	list_for_each_entry(b, &c->lru, lru)
+		i++;
+
+	b = get_last_bucket_or_alloc(c, NULL, bucket_to_sector(c, bucket),
+				     level, i, lru);
+	if (IS_ERR_OR_NULL(b))
+		goto err;
+
+	err = "error adding new pages";
+	for (i = 0; i < pages_per_btree; i++) {
+		if (!(b->pages[i] =
+		      find_or_create_page(c->bdev->bd_inode->i_mapping,
+					  b->offset / PAGE_SECTORS + i,
+					  GFP_NOIO)))
+			goto err;
+
+		unlock_page(b->pages[i]);
+		b->pages[i + pages_per_btree] = kmap(b->pages[i]);
+	}
+
+	atomic_set(&b->nread, pages_per_btree);
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
+	pr_debug("bucket %li, lru = %s, called from %p",
+		 sector_to_bucket(c, b->offset),
+		 lru ? "true" : "false",
+		 __builtin_return_address(0));
+	return b;
+err:
+	printk(KERN_WARNING "bcache: btree_alloc: %s\n", err);
+	if (b) {
+		btree_free(b, false);
+		up_write(&b->lock);
+	} else if (bucket != -1) {
+		spin_lock(&c->bucket_lock);
+		c->buckets[bucket].priority = 0;
+		if (!fifo_push(&c->free, bucket))
+			heap_insert(c, bucket);
+		spin_unlock(&c->bucket_lock);
+	}
+	return NULL;
+}
+
+static void set_new_root(struct cached_bucket *b)
+{
+	struct bio *bio;
+	struct cache_device *c = b->c;
+	BUG_ON(sector_to_priority(c, b->offset) != (uint16_t) ~0);
+	BUG_ON(!header(b)->random);
+
+	spin_lock(&c->sb_lock);
+	c->sb.btree_level = b->level;
+	c->sb.btree_root = b->offset;
+	c->root = b;
+
+	bio = write_super(c);
+	spin_unlock(&c->sb_lock);
+	submit_bio_list(WRITE, bio);
+
+	pr_debug("new root %lli called from %p", c->sb.btree_root,
+		 __builtin_return_address(0));
+}
+
+static void cache_hit(struct cache_device *c, struct bio *list)
+{
+	long b;
+	struct bio *bio, *p = NULL;
+
+	if (!list)
+		return;
+
+	spin_lock(&c->bucket_lock);
+	for (bio = list; bio; bio = bio->bi_next) {
+		bio->bi_bdev = c->bdev;
+
+		b = sector_to_bucket(c, bio->bi_sector);
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+		c->buckets[b].priority = (long) initial_priority;
+			/* * (cache_hit_seek + cache_hit_priority
+			 * bio_sectors(bio) / c->sb.bucket_size)
+			/ (cache_hit_seek + cache_hit_priority);*/
+
+		if (c->buckets[b].heap != -1)
+			heap_sift(c, c->buckets[b].heap);
+
+		p = max(p, __rescale_heap(c, bio_sectors(bio)));
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
+		atomic_dec(&sector_to_struct(c, s)->pin);
+	}
+	submit_bio_list(WRITE, p);
+}
+
+static int next_good_key(struct btree_key **i, int j, struct cached_bucket *b)
+{
+	while (j <= keys(i) && ptr_bad(b, node(i, j)))
+		j++;
+	return j;
+}
+
+#define run_on_root(write, f, ...) ({					\
+	int _r = -2;							\
+	do {								\
+		struct cached_bucket *_b = c->root;			\
+		bool _w = (write);					\
+		rw_lock(_w, _b);					\
+		if (sector_to_priority(c, _b->offset) == (uint16_t) ~0 &&\
+		    _b->level == c->sb.btree_level &&			\
+		    _w == (write)) {					\
+			_r = f(_b, __VA_ARGS__);			\
+			smp_mb();					\
+		} else {						\
+			rw_unlock(_w, _b);				\
+			cpu_relax();					\
+		}							\
+	} while (_r == -2);						\
+	_r; })
+
+#define sorted_set_checks(i, b) ({					\
+	bool _cont = true;						\
+	if (index(i, b) >= pages_per_bucket(b))				\
+		_cont = false;						\
+	else if (index(i, b) >= nread)					\
+		goto again;						\
+	else if (rand(i) != header(b)->random)				\
+		_cont = false;						\
+	else if (keys(i) >= (pages_per_bucket(b) - index(i, b)) * keys_per_page) {\
+		printk(KERN_DEBUG "bcache: bad btree header: page %i, %i keys",\
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
+	     sorted_set_checks(i, b);					\
+	     i += keys(i) / keys_per_page + 1)
+
+#define for_each_key(i, j, b)						\
+	for_each_sorted_set(i, b)					\
+		for (j = 1; j <= keys(i); j++)
+
+void dump_bucket_and_panic(struct cached_bucket *b)
+{
+	int j, nread;
+	struct btree_key **i;
+
+	for_each_key(i, j, b) {
+		char buf[30];
+		ptr_status(b, node(i, j), buf);
+		printk(KERN_ERR "page %i key %i/%i: "
+		       "key %llu -> offset %llu len %i gen %i bucket %li %s",
+		       index(i, b), j, keys(i), node(i, j)->key,
+		       PTR_OFFSET(node(i, j)), PTR_SIZE(node(i, j)),
+		       PTR_GEN(node(i, j)),
+		       sector_to_bucket(b->c, PTR_OFFSET(node(i, j))),
+		       buf);
+	}
+again:
+	panic("at offset %llu", (uint64_t) b->offset);
+}
+
+/*
+ * Returns the smallest key greater than the search key.
+ * This is because we index by the end, not the beginning
+ */
+static int btree_bsearch(struct btree_key *i[], uint64_t search)
+{
+	int l = 1, r = keys(i) + 1;
+
+	while (l < r) {
+		int j = (l + r) >> 1;
+		if (node(i, j)->key > search)
+			r = j;
+		else
+			l = j + 1;
+	}
+
+	BUG_ON(l <= keys(i) && search >= node(i, l)->key);
+	return l;
+}
+
+#define do_fixup(_front, _len, _key) ({					\
+	struct btree_key _old = *_key;					\
+	if (_front)							\
+		_key->ptr += TREE_PTR(0, 0, _len);			\
+	else								\
+		_key->key -= _len;					\
+	_key->ptr -= TREE_PTR(0, min(_len, PTR_SIZE(_key)), 0);		\
+									\
+	pr_debug("fixing up %s of %llu -> %llu len %i by %i sectors: "	\
+		 "now %llu -> %llu len %i", _front ? "front" : "back",	\
+		 _old.key, PTR_OFFSET(&_old), PTR_SIZE(&_old), _len,	\
+		 _key->key, PTR_OFFSET(_key), PTR_SIZE(_key)); })
+
+static void fixup_old_keys(struct cached_bucket *b, struct btree_key *end[], struct btree_key *k)
+{
+	struct btree_key **i;
+	int nread = pages_per_bucket(b);
+
+	if (b->level)
+		return;
+
+	for (i = data(b);
+	     i < end && sorted_set_checks(i, b);
+	     i += keys(i) / keys_per_page + 1) {
+		int m = btree_bsearch(i, k->key);
+
+		do {
+			int front = KEY_OVERLAP(k, node(i, m));
+			int back = KEY_OVERLAP(node(i, m), k);
+
+			if (m > keys(i))
+				continue;
+
+			if (node(i, m)->key <= k->key - PTR_SIZE(k))
+				break;
+
+			if (k->key - PTR_SIZE(k) < node(i, m)->key &&
+			    front > 0)
+				do_fixup(true, front, node(i, m));
+			else if (node(i, m)->key - PTR_SIZE(node(i, m)) < k->key &&
+				 back > 0)
+				do_fixup(false, back, node(i, m));
+		} while (--m);
+	}
+	label(again, BUG());
+}
+
+static void fill_bucket_endio(struct bio *bio, int error)
+{
+	/* XXX: flag error here
+	 */
+	struct cached_bucket *b = bio->bi_private;
+	struct btree_key **i;
+	int j, nread = pages_per_bucket(b);
+
+	BUG_ON(error);
+
+	for (i = data(b);
+	     sorted_set_checks(i, b);
+	     i += keys(i) / keys_per_page + 1)
+		if (i != data(b))
+			for (j = 1; j <= keys(i); j++)
+				fixup_old_keys(b, i, node(i, j));
+
+	label(again, BUG());
+	atomic_set(&b->nread, pages_per_bucket(b));
+	run_wait_list(1, b->wait);
+	bio_put(bio);
+}
+
+static int btree_search(struct cached_bucket *b, int device, struct bio *bio,
+			struct search_context **s)
+{
+	int ret = -1, j, nread;
+	struct btree_key **i, **reverse;
+	uint64_t orig, search = TREE_KEY(device, bio->bi_sector);
+
+	do {
+		orig = search;
+		for_each_sorted_set(reverse, b)
+			;
+		do {
+			for_each_sorted_set(i, b)
+				if (i + keys(i) / keys_per_page + 1 == reverse)
+					break;
+			reverse = i;
+
+			for (j = btree_bsearch(i, search); j <= keys(i); j++) {
+				int len = node(i, j)->key - search;
+				struct bio *split;
+
+				if (ptr_bad(b, node(i, j)) ||
+				    search >= node(i, j)->key)
+					continue;
+
+				pr_debug("page %i key %i/%i: "
+					 "key %llu -> offset %llu len %i gen %i",
+					 index(i, b), j, keys(i), node(i, j)->key,
+					 PTR_OFFSET(node(i, j)), PTR_SIZE(node(i, j)),
+					 PTR_GEN(node(i, j)));
+
+				if (search < node(i, j)->key - PTR_SIZE(node(i, j)))
+					break;
+
+				atomic_inc(&PTR_BUCKET(b->c, node(i, j))->pin);
+				smp_mb__after_atomic_inc();
+
+				if (sector_to_gen(b->c, PTR_OFFSET(node(i, j)))
+				    != PTR_GEN(node(i, j))) {
+					atomic_dec(&PTR_BUCKET(b->c, node(i, j))->pin);
+					continue;
+				}
+
+				if (sector_to_priority(b->c, PTR_OFFSET(node(i, j))) == (uint16_t) ~0) {
+					printk(KERN_ERR "\nBad priority! page %i key %i:\n", index(i, b), j);
+					dump_bucket_and_panic(b);
+				}
+
+				if (!(split = bio_split_front(bio, len, NULL)))
+					goto err;
+
+				split->bi_sector += PTR_SIZE(node(i, j))
+					- KEY_OFFSET(node(i, j))
+					+ PTR_OFFSET(node(i, j));
+
+				pr_debug("cache hit of %i sectors from %llu, need %i sectors",
+					 bio_sectors(split), (uint64_t) split->bi_sector,
+					 split == bio ? 0 : bio_sectors(bio));
+
+				if (split != bio) {
+					split->bi_next = bio->bi_next;
+					bio->bi_next = split;
+				} else
+					goto done;
+
+				search = TREE_KEY(device, bio->bi_sector);
+			}
+		} while (i != data(b));
+	} while (search != orig);
+
+	label(err,	ret = -1);
+	label(again,	ret = 0);
+	label(done,	ret = 1);
+	rw_unlock(false, b);
+	return ret;
+}
+
+static int btree_search_recurse(struct cached_bucket *b, int device,
+				struct bio *bio, struct search_context **s)
+{
+	int ret = -1, j, nread;
+	struct btree_key **i, recurse_key;
+
+	do {
+		uint64_t search = TREE_KEY(device, bio->bi_sector);
+		struct cached_bucket *r;
+		recurse_key.key = ~0;
+
+		pr_debug("level %i bucket %li searching for %llu",
+			 b->level, sector_to_bucket(b->c, b->offset), search);
+
+		if (!b->level)
+			return btree_search(b, device, bio, s);
+
+		for_each_sorted_set(i, b) {
+			j = btree_bsearch(i, search);
+
+			while (j <= keys(i) &&
+			       (ptr_bad(b, node(i, j)) ||
+				search >= node(i, j)->key))
+				j++;
+
+			if (j <= keys(i) &&
+			    recurse_key.key > node(i, j)->key)
+				recurse_key = *node(i, j);
+		}
+
+		if (recurse_key.key == ~0)
+			break;
+
+		r = get_bucket(b, &recurse_key, false, s);
+		if (IS_ERR_OR_NULL(r))
+			goto err;
+
+		ret = max(ret, btree_search_recurse(r, device, bio, s));
+	} while (ret < 1 && recurse_key.key == TREE_KEY(device, bio->bi_sector));
+
+	label(err,	ret = -1);
+	label(again,	ret = 0);
+	rw_unlock(false, b);
+	return ret;
+}
+
+static void btree_sort(struct btree_key **base, size_t num)
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
+static bool btree_merge_key(struct cached_bucket *b, struct btree_key *i[],
+			    size_t *j, struct btree_key *k)
+{
+	bool ret = false;
+	BUG_ON(!k->key);
+
+	while (1) {
+		if (*j <= keys(i) &&
+		    !b->level &&
+		    !ptr_bad(b, node(i, *j))) {
+			int len = KEY_OVERLAP(k, node(i, *j));
+
+			if (len == 0 && PTR_OFFSET(node(i, *j)) ==
+			    PTR_OFFSET(k) + PTR_SIZE(k) &&
+			    sector_to_bucket(b->c, PTR_OFFSET(k)) ==
+			    sector_to_bucket(b->c, PTR_OFFSET(node(i, *j)))) {
+				k->key += PTR_SIZE(node(i, *j));
+				k->ptr += TREE_PTR(0, PTR_SIZE(node(i, *j)), 0);
+				goto merge;
+			}
+
+			if (len > 0)
+				do_fixup(true, len, node(i, *j));
+		}
+
+		if (--(*j) && !b->level) {
+			int len = KEY_OVERLAP(node(i, *j), k);
+
+			if (ptr_bad(b, node(i, *j)) ||
+			    len >= PTR_SIZE(node(i, *j)))
+				goto merge;
+
+			if (len == 0 && PTR_OFFSET(k) ==
+			    PTR_OFFSET(node(i, *j)) + PTR_SIZE(node(i, *j)) &&
+			    sector_to_bucket(b->c, PTR_OFFSET(k)) ==
+			    sector_to_bucket(b->c, PTR_OFFSET(node(i, *j)))) {
+				k->ptr += TREE_PTR(0, PTR_SIZE(node(i, *j)), 0);
+				k->ptr -= TREE_PTR(0, 0, PTR_SIZE(node(i, *j)));
+				goto merge;
+			}
+
+			if (len > 0)
+				do_fixup(false, len, node(i, *j));
+		} else if (*j)
+			if (PTR_OFFSET(node(i, *j)) == PTR_OFFSET(k))
+				goto merge;
+		(*j)++;
+		return ret;
+merge:
+		node(i, *j)->ptr -= TREE_PTR(0, PTR_SIZE(node(i, *j)), 0);
+		node(i, *j)->key = k->key;
+
+		pr_debug("new key %llu len %i old key %llu len %i",
+			 KEY_OFFSET(k), PTR_SIZE(k), KEY_OFFSET(node(i, *j)), PTR_SIZE(node(i, *j)));
+		ret = true;
+	}
+}
+
+static void btree_clean(struct cached_bucket *b, uint64_t smallest)
+{
+	size_t j, k, n, nread;
+	int orig = 0, nkeys = header(b)->nkeys;
+	struct btree_node_header *h;
+	struct btree_key **i;
+
+	bool bad(struct btree_key *k)
+	{
+		int len = smallest - (k->key - PTR_SIZE(k));
+		if (len > 0)
+			do_fixup(true, len, k);
+		return ptr_bad(b, k);
+	}
+
+	for (h = header(b), i = data(b);
+	     i < data(b) + pages_per_bucket(b) &&
+	     h->random == header(b)->random;
+	     i += (n / keys_per_page) + 1,
+	     h = (struct btree_node_header *) *i) {
+		if (h->nkeys >= (pages_per_bucket(b) - index(i, b)) * keys_per_page) {
+			printk(KERN_DEBUG "bcache: bad btree header: page %i, %i keys",
+			       index(i, b), keys(i));
+			keys(i) = 0;
+			break;
+		}
+
+		orig += n = h->nkeys;
+
+		if (data(b) == i)
+			for (j = 1; j <= nkeys; j++)
+				while ((bad(node(i, j))) && j <= --nkeys)
+					*node(data(b), j) = *node(i, nkeys + 1);
+		else
+			for (j = 1, k = 1; j <= n; j++) {
+				if (bad(node(i, j)))
+					continue;
+
+				while (k <= header(b)->nkeys &&
+				       node(data(b), k)->key <= node(i, j)->key)
+					k++;
+
+				if (btree_merge_key(b, data(b), &k, node(i, j)))
+					*node(data(b), k) = *node(i, j);
+				else
+					*node(data(b), ++nkeys) = *node(i, j);
+			}
+
+		header(b)->nkeys = nkeys;
+		btree_sort(data(b), nkeys);
+	}
+
+	get_random_bytes(&header(b)->random, sizeof(uint64_t));
+	n = 0;
+	for_each_key(i, j, b)
+		if (ptr_bad(b, node(i, j)))
+			n++;
+again:
+	pr_debug("merged %i keys from %i keys, %zu now bad",
+		 header(b)->nkeys, orig, n);
+}
+
+static int btree_gc(struct cached_bucket *b, struct btree_key *root,
+		    uint64_t smallest, struct search_context **s)
+{
+	int j, ret = 0, nread;
+	struct cache_device *c = b->c;
+	struct btree_key **i;
+	struct cached_bucket *n = NULL, *r;
+	uint64_t last = 0;
+
+	for_each_key(i, j, b)
+		if (PTR_OFFSET(node(i, j)) >=
+		    c->sb.bucket_size * c->sb.first_bucket &&
+		    PTR_OFFSET(node(i, j)) <
+		    c->sb.bucket_size * (c->sb.first_bucket + c->sb.nbuckets))
+			ret = max_t(uint8_t, ret,
+				    sector_to_gen(c, PTR_OFFSET(node(i, j))) -
+				    PTR_GEN(node(i, j)));
+
+	if (!PageDirty(b->pages[0]) && ret > 10)
+		n = btree_alloc(c, b->level, NULL, 0, 0,
+				c->sb.btree_level != b->level);
+
+	if (n) {
+		for (j = 0; j < pages_per_bucket(b); j++)
+			memcpy(data(n)[j], data(b)[j], PAGE_SIZE);
+		swap(b, n);
+	}
+
+	if (PageDirty(b->pages[0])) {
+		btree_clean(b, smallest);
+		*root = bucket_key(b);
+		ret = 0;
+	} else if (b->level)
+		goto again;
+
+	for_each_key(i, j, b) {
+		long bucket;
+		struct bucket_gc *g;
+		if (ptr_bad(b, node(i, j)))
+			continue;
+
+		bucket = sector_to_bucket(c, PTR_OFFSET(node(i, j)));
+		g = &c->garbage[bucket];
+
+		if (g->mark == 3)
+			continue;
+
+		if (g->mark == (b->level ? 1 : 2)) {
+			printk(KERN_WARNING "bcache: btree and data pointers to same bucket %li, priority %i: "
+			       "level %i key %llu -> offset %llu len %i",
+			       bucket, c->buckets[bucket].priority, b->level, node(i, j)->key,
+			       PTR_OFFSET(node(i, j)), PTR_SIZE(node(i, j)));
+			g->mark = 3;
+		} else if (b->level) {
+			uint64_t t = node(i, j)->key;
+			r = get_bucket(b, node(i, j), true, s);
+
+			if (IS_ERR_OR_NULL(r))
+				continue;
+
+			ret = max_t(uint8_t, ret,
+				    btree_gc(r, node(i, j), last, s));
+			last = t;
+			g->mark = 2;
+		} else
+			g->mark = 1;
+	}
+
+	if (b->level)
+		btree_clean(b, 0);
+
+	__btree_write(b, 0, atomic_read(&b->nread), b->offset);
+
+again:
+	rw_unlock(true, b);
+	if (n) {
+		if (c->sb.btree_level == b->level)
+			set_new_root(b);
+
+		btree_free(n, true);
+		rw_unlock(true, n);
+	}
+	return ret;
+}
+
+static void do_btree_gc(struct work_struct *w)
+{
+	long i;
+	struct btree_key root;
+	struct cache_device *c = container_of(w, struct cache_device, work);
+	struct search_context s, *sp = &s;
+	memset(&s, 0, sizeof(s));
+	s.flags |= SEARCH_BLOCK;
+
+	i = run_on_root(true, btree_gc, &root, 0, &sp);
+
+	spin_lock(&c->bucket_lock);
+	c->garbage[sector_to_bucket(c, c->root->offset)].mark = 2;
+	c->need_gc = i;
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		c->buckets[i].last_gc = c->garbage[i].gen;
+		c->need_gc = max_t(uint8_t, c->need_gc,
+				   c->buckets[i].gen -
+				   c->buckets[i].last_gc);
+		switch (c->garbage[i].mark) {
+#if 0
+		case 2:
+			if (c->buckets[i].priority == (uint16_t) ~0)
+				break;
+		case 1:
+			if (c->buckets[i].priority != (uint16_t) ~0)
+				break;
+			__inc_bucket_gen(c, i);
+		case 0:
+#endif
+		case 3:
+			pr_debug("mark and sweep found free bucket %li", i);
+			c->buckets[i].priority = 0;
+			c->buckets[i].gen++;
+			heap_insert(c, i);
+		}
+	}
+
+	pr_debug("garbage collect done, new need_gc %i", c->need_gc);
+	spin_unlock(&c->bucket_lock);
+	up(&c->gc_lock);
+}
+
+static void btree_insert_one_key(struct cached_bucket *b, struct btree_key *i[],
+				 struct btree_key *k)
+{
+	size_t j, m;
+	const char *s = "replacing";
+
+	BUG_ON(PTR_GEN(k) == sector_to_gen(b->c, PTR_OFFSET(k)) &&
+	       ((b->level != 0) ^
+		(sector_to_priority(b->c, PTR_OFFSET(k)) == (uint16_t) ~0)));
+	BUG_ON((b->level != 0) ^ !PTR_SIZE(k));
+
+	fixup_old_keys(b, i, k);
+	m = btree_bsearch(i, k->key);
+
+	if (!btree_merge_key(b, i, &m, k)) {
+		s = "inserting";
+		if (b->level)
+			k->ptr = TREE_PTR(inc_gen(b->c, PTR_OFFSET(k)),
+					  0, PTR_OFFSET(k));
+
+		for (j = keys(i)++; j >= m; --j)
+			*node(i, j + 1) = *node(i, j);
+	}
+
+	*node(i, m) = *k;
+
+	pr_debug("%s at %llu level %i page %i key %zu/%i: "
+		 "key %llu ptr %llu len %i",
+		 s, (uint64_t) b->offset, b->level, index(i, b), m, keys(i),
+		 KEY_OFFSET(k), PTR_OFFSET(k), PTR_SIZE(k));
+
+	SetPageDirty(virt_to_page(i[keys(i) / keys_per_page]));
+}
+
+static int btree_split(struct cached_bucket *b,
+		       struct btree_key *new_keys, int *n)
+{
+	int ret = 0;
+	struct cache_device *c = b->c;
+	struct cached_bucket *n1, *n2 = NULL, *n3 = NULL;
+	struct btree_node_header *h;
+	bool root = (c->sb.btree_level == b->level);
+
+	h = header(b);
+	pr_debug("splitting at level %i of %i sector %llu nkeys %i",
+		 b->level, c->sb.btree_level, (uint64_t) b->offset, h->nkeys);
+	btree_clean(b, 0);
+
+	if (h->nkeys < keys_per_page * pages_per_bucket(b) / 2) {
+		pr_debug("not splitting: %i keys", h->nkeys);
+
+		if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys, 0, !root)))
+			goto err;
+
+		while (*n)
+			btree_insert_one_key(n1, data(n1), &new_keys[--(*n)]);
+
+		btree_write(n1, 0);
+
+		rw_unlock(true, n1);
+		if (root)
+			set_new_root(n1);
+		else
+			new_keys[(*n)++] = bucket_key(n1);
+		goto out;
+	}
+
+	if (!(n1 = btree_alloc(c, b->level, data(b), h->nkeys >> 1, 0, true)) ||
+	    !(n2 = btree_alloc(c, b->level, data(b), h->nkeys, h->nkeys >> 1, true)))
+		goto err;
+
+	while (*n)
+		if (new_keys[--(*n)].key <= last_key(data(n1)))
+			btree_insert_one_key(n1, data(n1), &new_keys[*n]);
+		else
+			btree_insert_one_key(n1, data(n2), &new_keys[*n]);
+
+	new_keys[(*n)++] = bucket_key(n2);
+	new_keys[(*n)++] = bucket_key(n1);
+
+	btree_write(n1, 0);
+	btree_write(n2, 0);
+
+	rw_unlock(true, n2);
+	rw_unlock(true, n1);
+	n1 = n2 = NULL;
+
+	if (root) {
+		if (!(n3 = btree_alloc(c, b->level + 1, NULL, 0, 0, false)))
+			goto err;
+
+		while (*n)
+			btree_insert_one_key(n3, data(n3), &new_keys[--(*n)]);
+		btree_write(n3, 0);
+
+		rw_unlock(true, n3);
+		set_new_root(n3);
+	}
+out:
+	btree_free(b, true);
+	return ret;
+err:
+	printk(KERN_WARNING "bcache: couldn't split");
+	if (n2) {
+		btree_free(n2, false);
+		rw_unlock(true, n2);
+	}
+	if (n1) {
+		btree_free(n1, false);
+		rw_unlock(true, n1);
+	}
+	btree_write(b, 0);
+	return 0;
+}
+
+static int btree_insert(struct cached_bucket *b, struct btree_key *new_keys,
+			int *n, struct search_context **s)
+{
+	int ret = 0, sets = 0, nread;
+	uint64_t biggest = 0;
+	struct btree_key **i;
+
+	while (*n) {
+		sets = 0;
+		for_each_sorted_set(i, b) {
+			sets++;
+			if (keys(i))
+				biggest = max(biggest, last_key(i));
+
+			if (PageDirty(b->pages[index(i, b)]))
+				break;
+		}
+
+		if (index(i, b) >= pages_per_bucket(b) ||
+		    (rand(i) == header(b)->random &&
+		     keys(i) + 1 >= (pages_per_bucket(b) - index(i, b)) * keys_per_page))
+			return btree_split(b, new_keys, n);
+
+		if (rand(i) != header(b)->random) {
+			rand(i) = header(b)->random;
+			keys(i) = 0;
+			SetPageDirty(b->pages[index(i, b)]);
+		}
+
+		while (*n && (keys(i) + 1) % keys_per_page) {
+			btree_insert_one_key(b, i, &new_keys[--(*n)]);
+
+			if (new_keys[*n].key > biggest)
+				ret = 1;
+
+			biggest = max(new_keys[*n].key, biggest);
+		}
+
+		btree_write(b, index(i, b));
+	}
+	new_keys[0].ptr = bucket_to_ptr(b);
+	new_keys[0].key = biggest;
+	*n = ret;
+
+	if (sets > 3) {
+		struct cached_bucket *clean =
+			btree_alloc(b->c, b->level, NULL, 0, 0,
+				    b->c->sb.btree_level != b->level);
+		if (clean) {
+			int j;
+			*n = 1;
+			for (j = 0; j < pages_per_bucket(b); j++)
+				memcpy(data(clean)[j], data(b)[j], PAGE_SIZE);
+
+			btree_clean(clean, 0);
+
+			if (b->c->sb.btree_level == b->level)
+				set_new_root(clean);
+			new_keys[0] = bucket_key(clean);
+			rw_unlock(true, clean);
+
+			btree_free(b, true);
+		}
+	}
+
+	label(again, ret = -1);
+	return ret;
+}
+
+static int btree_insert_recurse(struct cached_bucket *b, int *level,
+				struct btree_key *new_keys, int *n,
+				struct search_context **s)
+{
+	int j, ret = 0, nread;
+	struct cached_bucket *r;
+	bool write = !(b->level - *level);
+
+	if (!atomic_read(&b->nread))
+		goto again;
+
+	if (!header(b)->random) {
+		printk(KERN_WARNING "bcache: btree was trashed, bucket %li, level %i, h->nkeys %i\n",
+		       sector_to_bucket(b->c, b->offset), b->level, header(b)->nkeys);
+trashed:
+		if (b->c->sb.btree_level == b->level) {
+			dump_bucket_and_panic(b);
+
+			if (!(r = btree_alloc(b->c, 0, NULL, 0, 0, false)))
+				goto done;
+			set_new_root(r);
+
+			btree_free(b, true);
+			rw_unlock(write, b);
+
+			b = r;
+			write = true;
+		} else
+			btree_free(b, true);
+
+		goto retry;
+	}
+
+	if (b->level > *level) {
+		uint64_t search = new_keys->key - PTR_SIZE(new_keys);
+		struct btree_key **i, recurse_key = { .key = 0, .ptr = 0 };
+
+		for_each_sorted_set(i, b) {
+			j = btree_bsearch(i, search);
+			j = next_good_key(i, j, b);
+
+			while (j && (j > keys(i) || ptr_bad(b, node(i, j))))
+				--j;
+
+			/* Pick the smallest key to recurse on that's bigger
+			 * than the key we're inserting, or failing that,
+			 * the biggest key.
+			 */
+			if (j &&
+			    ((node(i, j)->key > recurse_key.key &&
+			      (recurse_key.key < search || !search)) ||
+			     (node(i, j)->key < recurse_key.key &&
+			      node(i, j)->key > search)))
+				recurse_key = *node(i, j);
+		}
+
+		/* No key to recurse on */
+		if (!recurse_key.ptr) {
+			printk(KERN_WARNING "no key to recurse on trying to insert %llu at level %i of %i\n",
+			       new_keys->key, b->level, b->c->sb.btree_level);
+			goto trashed;
+		}
+
+		r = get_bucket(b, &recurse_key, !(b->level - *level - 1), s);
+		if (!r)
+			goto retry;
+		if (IS_ERR(r))
+			goto err;
+
+		pr_debug("recursing on %llu to insert %llu %s",
+			 recurse_key.key, new_keys->key,
+			 new_keys->key > recurse_key.key ? "embiggening" : "");
+
+		BUG_ON(!*n);
+		BUG_ON((*level != 0) ^ !PTR_SIZE(new_keys));
+		BUG_ON(PTR_GEN(new_keys) == sector_to_gen(b->c, PTR_OFFSET(new_keys)) &&
+		       ((*level != 0) ^ (sector_to_priority(b->c, PTR_OFFSET(new_keys)) == (uint16_t) ~0)));
+
+		ret = btree_insert_recurse(r, level, new_keys, n, s);
+
+		if (*n && ret >= 0) {
+			BUG_ON(PTR_SIZE(new_keys));
+			BUG_ON(PTR_GEN(new_keys) == sector_to_gen(b->c, PTR_OFFSET(new_keys)) &&
+			       sector_to_priority(b->c, PTR_OFFSET(new_keys)) != (uint16_t) ~0);
+		}
+	}
+
+	if (*n && ret >= 0) {
+		*level = b->level;
+		if (!(b = upgrade_bucket(&write, b, s))) {
+			printk(KERN_DEBUG "retrying upgrade\n");
+			goto retry;
+		}
+		if (IS_ERR(b))
+			goto err;
+		ret = btree_insert(b, new_keys, n, s);
+	}
+
+	if (*n && ret >= 0) {
+		BUG_ON(PTR_SIZE(new_keys));
+		BUG_ON(PTR_GEN(new_keys) == sector_to_gen(b->c, PTR_OFFSET(new_keys)) &&
+		       sector_to_priority(b->c, PTR_OFFSET(new_keys)) != (uint16_t) ~0);
+	}
+done:
+	label(err,   ret = -3);
+	label(retry, ret = -2);
+	label(again, ret = -1);
+	if (!IS_ERR_OR_NULL(b))
+		rw_unlock(write, b);
+	return ret;
+}
+
+static void btree_insert_async(struct search_context *s)
+{
+	struct cache_device *c = s->q;
+	int ret;
+
+	while (s->nkeylist) {
+		if (!s->nkeys) {
+			s->new_keys[0] = s->keylist[--s->nkeylist];
+			s->level = 0;
+			s->nkeys = 1;
+		}
+
+		ret = run_on_root(!(_b->level - s->level),
+				  btree_insert_recurse, &s->level,
+				  s->new_keys, &s->nkeys, &s);
+
+		if (ret == -3)
+			printk(KERN_WARNING "bcache: out of memory trying to insert key\n");
+
+		if (ret == -1)
+			return_f(s, btree_insert_async);
+		s->nkeys = 0;
+	}
+
+	if (s->keylist != &s->new_keys[0])
+		kfree(s->keylist);
+
+	return_f(s, s->parent);
+}
+
+static struct open_bucket *get_open_bucket(uint64_t key,
+					   struct task_struct *task)
+{
+	long i = 0;
+	struct open_bucket *b;
+
+	spin_lock(&open_bucket_lock);
+	list_for_each_entry(b, &open_buckets, list) {
+		if (b->cache &&
+		    (b->key.key == key || b->last == task))
+			goto out;
+		i++;
+	}
+
+	if (i < 8) {
+		spin_unlock(&open_bucket_lock);
+		b = kzalloc(sizeof(struct open_bucket), GFP_NOIO);
+		spin_lock(&open_bucket_lock);
+
+		if (!b)
+			goto err;
+		INIT_LIST_HEAD(&b->list);
+	} else
+		b = list_entry(open_buckets.prev, struct open_bucket, list);
+
+out:
+	if (!b->cache ||
+	    b->gen != sector_to_gen(b->cache, b->offset)) {
+		struct cache_device *c;
+		list_for_each_entry(c, &cache_devices, list)
+			if (!b->cache ||
+			    (b->cache->heap[0] && c->heap[0] &&
+			     b->cache->heap[0]->priority > c->heap[0]->priority))
+				b->cache = c;
+
+		if (!b->cache)
+			goto err;
+
+		spin_lock(&b->cache->bucket_lock);
+		i = pop_bucket(b->cache, initial_priority);
+		if (i == -1) {
+			b->cache = NULL;
+			spin_unlock(&b->cache->bucket_lock);
+			goto err;
+		}
+
+		spin_unlock(&b->cache->bucket_lock);
+
+		b->offset	= bucket_to_sector(b->cache, i);
+		b->sectors_free = b->cache->sb.bucket_size;
+		b->gen = sector_to_gen(b->cache, b->offset);
+	}
+
+	b->last = task;
+	b->key.key = key;
+
+	list_move(&b->list, &open_buckets);
+	return b;
+err:
+	spin_unlock(&open_bucket_lock);
+	return NULL;
+}
+
+static void close_open_bucket(struct open_bucket *b,
+			      struct btree_key *insert_key, int split)
+{
+	struct bio *bio = NULL;
+	BUG_ON(!split);
+
+	b->key.key     += TREE_KEY(0, split);
+
+	insert_key->key = TREE_KEY(lookup_id(b->cache, KEY_DEV(&b->key)),
+				   KEY_OFFSET(&b->key)),
+	insert_key->ptr = TREE_PTR(b->gen, split,
+				   b->offset + b->cache->sb.bucket_size -
+				   b->sectors_free);
+
+	b->sectors_free	-= split;
+	b->cache->sectors_written += split;
+
+	if (b->sectors_free < PAGE_SECTORS) {
+		spin_lock(&b->cache->bucket_lock);
+		heap_insert(b->cache, sector_to_bucket(b->cache, b->offset));
+		bio = __rescale_heap(b->cache, b->cache->sb.bucket_size);
+		spin_unlock(&b->cache->bucket_lock);
+
+		b->cache = NULL;
+		list_move_tail(&b->list, &open_buckets);
+	}
+	spin_unlock(&open_bucket_lock);
+	submit_bio_list(WRITE, bio);
+}
+
+static void bio_insert_endio(struct bio *bio, int error)
+{
+	struct search_context *s = bio->bi_private;
+	bio_put(bio);
+
+	if (error)
+		BUG();
+	else
+		return_f(s, btree_insert_async);
+}
+
+static const char *bio_insert(struct task_struct *task, struct bio *bio,
+			      struct search_context *s)
+{
+	int split, id = bio->bi_bdev->bd_cache_identifier;
+	struct bio *n;
+	const char *ret;
+	s->keylist = &s->new_keys[0];
+
+	bio->bi_private	= s;
+	bio->bi_end_io	= bio_insert_endio;
+
+	do {
+		struct cache_device *c;
+		struct open_bucket *b;
+		struct btree_key *k;
+
+		if (is_power_of_2(s->nkeylist)) {
+			ret = "out of memory";
+			if (!(s->keylist =
+			      krealloc(s->nkeylist == 1 ? NULL : s->keylist,
+				       sizeof(*s->keylist) * s->nkeylist << 1,
+				       GFP_NOIO)))
+				goto err;
+
+			if (s->nkeylist == 1)
+				memcpy(s->keylist, s->new_keys, sizeof(*s->keylist) * 2);
+		}
+
+		ret = "get_open_bucket error";
+		if (!(b = get_open_bucket(TREE_KEY(id, bio->bi_sector), task)))
+			goto err;
+
+		s->q = c = b->cache;
+		split = min(min(bio_sectors(bio), b->sectors_free),
+			    queue_max_sectors(bdev_get_queue(c->bdev)));
+
+		k = &s->keylist[s->nkeylist++];
+		close_open_bucket(b, k, split);
+
+		ret = "bio_split_front error";
+		if (!(n = bio_split_front(bio, split, NULL)))
+			goto err;
+
+		pr_debug("adding to cache key %llu -> offset %llu len %u",
+			 KEY_OFFSET(k), PTR_OFFSET(k), PTR_SIZE(k));
+
+		n->bi_sector	= PTR_OFFSET(k);
+		n->bi_bdev	= c->bdev;
+		submit_bio(WRITE, n);
+	} while (n != bio);
+
+	ret = NULL;
+err:
+	return ret;
+}
+
+static void bio_complete(struct search_context *s)
+{
+	s->bio->bi_private = s->bi_private;
+	if (s->bi_end_io)
+		s->bi_end_io(s->bio, s->error);
+	return_f(s, NULL);
+}
+
+static void bio_complete_bounce(struct search_context *s)
+{
+	int i;
+	struct bio_vec *bv;
+	bio_for_each_segment(bv, s->bio, i)
+		__free_page(bv->bv_page);
+	bio_put(s->bio);
+	return_f(s, NULL);
+}
+
+static void cache_miss(struct search_context *s)
+{
+	BUG_ON(s->error);
+	if (bio_insert(s->q, s->cache_bio, s))
+		bio_endio(s->cache_bio, -EIO);
+}
+
+static void cache_miss_bounce(struct search_context *s)
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
+	if (bio_insert(s->q, s->cache_bio, s))
+		bio_endio(s->cache_bio, -EIO);
+}
+
+static void request_hook_endio(struct bio *bio, int error)
+{
+	struct search_context *s = bio->bi_private;
+	s->error = error;
+	BUG_ON(error);
+	put_search(s);
+}
+
+static void __request_hook_read(struct search_context *s)
+{
+	struct request_queue *q = s->q;
+	if (request_hook_read(s->q, s->bio, s))
+		if (q->make_request_fn(q, s->bio))
+			generic_make_request(s->bio);
+}
+
+static int request_hook_read(struct request_queue *q, struct bio *bio,
+			     struct search_context *s)
+{
+	int ret = -1, i;
+	struct cache_device *c;
+
+	pr_debug("searching for %i sectors at %llu",
+		 bio_sectors(bio), (uint64_t) bio->bi_sector);
+
+	list_for_each_entry(c, &cache_devices, list) {
+		int dev = lookup_dev(c, bio);
+		if (dev == UUIDS_PER_SB)
+			return_f(s, NULL, 1);
+
+		ret = max(ret, run_on_root(false, btree_search_recurse, dev, bio, &s));
+
+		if (ret == 1) {
+			cache_hit(c, bio);
+			return_f(s, NULL, 0);
+		} else {
+			cache_hit(c, bio->bi_next);
+			bio->bi_next = NULL;
+		}
+	}
+
+	if (!ret) {
+		s->q = q;
+		s->bio = bio;
+		return_f(s, __request_hook_read, 0);
+	}
+
+	pr_debug("cache miss for %llu, starting write",
+		 (uint64_t) bio->bi_sector);
+	cache_misses++;
+
+	list_for_each_entry(c, &cache_devices, list)
+		rescale_heap(c, bio_sectors(bio));
+
+	if (IS_ERR(s = alloc_search(s)) ||
+	    !(s->cache_bio = bio_kmalloc(GFP_NOIO, bio->bi_max_vecs)))
+		return_f(s, NULL, 1);
+
+	s->parent	= bio_complete_bounce;
+	s->end_fn	= cache_miss_bounce;
+	s->q		= get_current();
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+
+	bio->bi_end_io	= request_hook_endio;
+	bio->bi_private = s;
+
+	__bio_clone(s->cache_bio, bio);
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
+		s->parent	= bio_complete;
+		s->end_fn	= cache_miss;
+	}
+	return 1;
+}
+
+static int request_hook_write(struct request_queue *q, struct bio *bio)
+{
+	struct search_context *s;
+	struct bio *n = NULL;
+	const char *err = "couldn't allocate memory";
+
+	if (IS_ERR(s = alloc_search(NULL)))
+		goto err;
+
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+	s->parent	= bio_complete;
+
+	if (!(n = bio_kmalloc(GFP_NOIO, bio->bi_max_vecs)))
+		goto err;
+
+	bio->bi_end_io  = request_hook_endio;
+	bio->bi_private = s;
+
+	__bio_clone(n, bio);
+	atomic_inc(&s->remaining);
+
+	if ((err = bio_insert(get_current(), n, s)))
+		goto err;
+
+	return 1;
+err:		
+	printk(KERN_WARNING "bcache: write error: %s\n", err);
+	/* XXX: write a null key or invalidate cache or fail write */
+
+	if (s)
+		put_search(s);
+
+	if (n)
+		bio_endio(n, 0);
+	return 1;
+}
+
+static void unplug_hook(struct request_queue *q)
+{
+	struct cache_device *c;
+	list_for_each_entry(c, &cache_devices, list)
+		blk_unplug(bdev_get_queue(c->bdev));
+	q->cache_unplug_fn(q);
+}
+
+static int request_hook(struct request_queue *q, struct bio *bio)
+{
+	if (!bio_has_data(bio) ||
+	    list_empty(&cache_devices))
+		return 1;
+
+	if (q->unplug_fn != unplug_hook) {
+		q->cache_unplug_fn = q->unplug_fn;
+		q->unplug_fn = unplug_hook;
+	}
+
+	if (bio_rw_flagged(bio, BIO_RW))
+		return request_hook_write(q, bio);
+	else
+		return request_hook_read(q, bio, NULL);
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
+read_attribute(kb_written);
+
+rw_attribute(cache_priority_initial);
+rw_attribute(cache_priority_hit);
+rw_attribute(cache_priority_seek);
+rw_attribute(cache_priority_rescale);
+
+static struct dentry *debug;
+
+static int dump_tree(struct cached_bucket *b, struct seq_file *f, char *space,
+		     uint64_t *prev, uint64_t *sectors, struct search_context *s)
+{
+	int j, nread;
+	struct btree_key **i;
+	char buf[30];
+	uint64_t biggest = 0;
+	struct cached_bucket *r;
+
+	seq_printf(f, "%spage  key: dev        key ->    offset  len gen bucket\n", space + 3);
+
+	for_each_sorted_set(i, b) {
+		uint64_t last = *prev;
+		for (j = 1; j <= keys(i); j++) {
+			if (last > node(i, j)->key)
+				seq_printf(f, "Key skipped backwards\n");
+
+			if (!b->level &&
+			    j > 1 &&
+			    last != node(i, j)->key - PTR_SIZE(node(i, j)))
+					seq_printf(f, "<hole>\n");
+			else if (b->level &&
+				 !ptr_bad(b, node(i, j))) {
+				r = get_bucket(b, node(i, j), false, &s);
+				if (!IS_ERR_OR_NULL(r))
+					dump_tree(r, f, space - 4, &last, sectors, s);
+			}
+
+			ptr_status(b, node(i, j), buf);
+			seq_printf(f,
+				   "%s%i %4i: %3i %10llu -> %9lli %4i %3i %6li %s\n",
+				   space,
+				   index(i, b), j,
+				   KEY_DEV(node(i, j)), KEY_OFFSET(node(i, j)),
+				   PTR_OFFSET(node(i, j)),
+				   PTR_SIZE(node(i, j)),
+				   PTR_GEN(node(i, j)),
+				   sector_to_bucket(b->c, PTR_OFFSET(node(i, j))),
+				   buf);
+
+			if (!b->level || !buf[0]) {
+				last = node(i, j)->key;
+				biggest = max(biggest, last);
+			}
+
+			if (!b->level && !buf[0])
+				*sectors += PTR_SIZE(node(i, j));
+		}
+	}
+	*prev = biggest;
+
+	label(again, BUG());
+	rw_unlock(false, b);
+	return 0;
+}
+
+static int debug_seq_show(struct seq_file *f, void *data)
+{
+	char space[31];
+	uint64_t last = 0, sectors = 0;
+	struct cache_device *c = f->private;
+	struct search_context s;
+	memset(&s, 0, sizeof(s));
+	s.flags |= SEARCH_BLOCK;
+
+	memset(space, ' ', 30);
+	space[30] = '\0';
+
+	run_on_root(false, dump_tree, f, &space[26], &last, &sectors, &s);
+
+	seq_printf(f,
+		   "root: (null) -> bucket %6li\n"
+		   "%llu kb found\n",
+		   sector_to_bucket(c, c->root->offset), sectors / 2);
+
+	return 0;
+}
+
+static int debug_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_seq_show, inode->i_private);
+}
+
+static void load_priorites_endio(struct bio *bio, int error)
+{
+	int i;
+	for (i = 0; i < bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	if (error)
+		printk(KERN_ERR "bcache: Error reading priorities");
+	wake_up(&pending);
+	bio_put(bio);
+}
+
+static void load_priorities(struct cache_device *c, bool zero)
+{
+	long i = 0, used = 0;
+	struct bio *bio = c->priority_bio, *split;
+
+	bio_get(bio);
+	bio->bi_sector	= PRIO_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= pages(c, struct bucket_disk);
+	bio->bi_size	= pages(c, struct bucket_disk) * PAGE_SIZE;
+
+	bio->bi_end_io	= load_priorites_endio;
+	bio->bi_private = c;
+
+	for (i = 0; i < pages(c, struct bucket_disk); i++) {
+		bio->bi_io_vec[i].bv_page =
+			vmalloc_to_page((void *) c->disk_buckets
+					+ PAGE_SIZE * i);
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+		get_page(bio->bi_io_vec[i].bv_page);
+	}
+
+	pr_debug("max vecs %i\n", bio_get_nr_vecs(c->bdev));
+	mdelay(10);
+
+	do {
+		if (!(split = bio_split_front(bio, bio_get_nr_vecs(c->bdev)
+					      * PAGE_SECTORS, NULL)))
+			return;
+		submit_bio(READ, split);
+	} while (split != bio);
+
+	wait_event(pending, atomic_read(&bio->bi_remaining) == 0);
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		atomic_set(&c->buckets[i].pin, 0);
+		c->buckets[i].heap = -1;
+
+		c->buckets[i].priority =
+			le16_to_cpu(c->disk_buckets[i].priority);
+		c->buckets[i].gen = c->disk_buckets[i].gen;
+
+		if (zero)
+			c->buckets[i].priority = c->buckets[i].gen = 0;
+
+		c->buckets[i].last_gc = c->buckets[i].gen;
+
+		if (c->buckets[i].priority != (uint16_t) ~0 &&
+		    c->buckets[i].priority)
+			used++;
+
+		if (c->buckets[i].priority != (uint16_t) ~0)
+			if (c->buckets[i].priority != 0 ||
+			    !fifo_push(&c->free, i))
+				heap_insert(c, i);
+	}
+	pr_debug("Cache loaded, %li buckets in use", used);
+}
+
+static struct bio *save_priorities(struct cache_device *c)
+{
+	long i = 0, used = 0;
+	struct bio *bio = c->priority_bio;
+
+	if (!bio_reinit(bio))
+		return NULL;
+
+	bio->bi_sector	= PRIO_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= pages(c, struct bucket_disk);
+	bio->bi_size	= pages(c, struct bucket_disk) * PAGE_SIZE;
+
+	bio->bi_end_io	= write_endio;
+	bio->bi_private = c;
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		c->disk_buckets[i].priority =
+			cpu_to_le16(c->buckets[i].priority);
+		c->disk_buckets[i].gen = c->buckets[i].gen;
+
+		if (c->buckets[i].priority != (uint16_t) ~0 &&
+		    c->buckets[i].priority)
+			used++;
+	}
+
+	for (i = 0; i < pages(c, struct bucket_disk); i++) {
+		bio->bi_io_vec[i].bv_page =
+			vmalloc_to_page((void *) c->disk_buckets
+					+ PAGE_SIZE * i);
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+		get_page(bio->bi_io_vec[i].bv_page);
+	}
+
+	pr_debug("Cache written, %li buckets in use", used);
+	return bio;
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
+	struct cached_dev *d = NULL;
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
+		if (!IS_ERR_OR_NULL(bdev))
+			bdput(bdev);
+		kfree(d);
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
+	struct cached_bucket *b;
+
+	sysfs_print(bucket_size, "%i\n", c->sb.bucket_size << 9);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
+	sysfs_print(min_priority, "%u\n", c->heap[0] ? c->heap[0]->priority : 0);
+	sysfs_print(heap_size, "%zu\n", c->heap_size);
+	sysfs_print(kb_written, "%lu\n", c->sectors_written / 2);
+	if (attr == &sysfs_pinned_buckets) {
+		struct list_head *l;
+		int i = 0;
+		spin_lock(&c->bucket_lock);
+		list_for_each(l, &c->lru)
+			i++;
+		spin_unlock(&c->bucket_lock);
+		return snprintf(buffer, PAGE_SIZE, "%i\n", i);
+	}
+	if (attr == &sysfs_lru_end) {
+		b = list_entry(c->lru.prev, struct cached_bucket, lru);
+		return snprintf(buffer, PAGE_SIZE, "%li\n",
+				sector_to_bucket(c, b->offset));
+	}
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
+	err = "Bucket size must be multiple of page size";
+	 if (!pages_per_btree ||
+	     c->sb.bucket_size & ((PAGE_SIZE >> 9) - 1))
+		goto err;
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
+static struct bio *write_super(struct cache_device *c)
+{
+	struct bio *bio = c->sb_bio;
+	struct cache_sb *s = page_address(bio->bi_io_vec[0].bv_page);
+
+	if (!bio_reinit(bio))
+		return NULL;
+
+	get_page(bio->bi_io_vec[0].bv_page);
+
+	BUG_ON(list_empty(&c->list) != (c->sb.version & CACHE_CLEAN));
+	pr_debug("ver %i, root %llu, level %i",
+		 c->sb.version, c->sb.btree_root, c->sb.btree_level);
+
+	bio->bi_sector	= SB_SECTOR;
+	bio->bi_bdev	= c->bdev;
+	bio->bi_vcnt	= 1;
+	bio->bi_size	= 4096;
+
+	bio->bi_end_io	= write_endio;
+	bio->bi_private = c;
+
+	s->version		= cpu_to_le32(c->sb.version);
+	s->block_size		= cpu_to_le16(c->sb.block_size);
+	s->bucket_size		= cpu_to_le16(c->sb.bucket_size);
+	s->journal_start	= cpu_to_le32(c->sb.journal_start);
+	s->first_bucket		= cpu_to_le32(c->sb.first_bucket);
+	s->nbuckets		= cpu_to_le64(c->sb.nbuckets);
+	s->btree_root		= cpu_to_le64(c->sb.btree_root);
+	s->btree_level		= cpu_to_le16(c->sb.btree_level);
+	return bio;
+}
+
+static void free_cache(struct cache_device *c)
+{
+	struct cached_bucket *b;
+
+	while (!list_empty(&c->lru)) {
+		b = list_first_entry(&c->lru, struct cached_bucket, lru);
+		list_del(&b->lru);
+		free_bucket_contents(b);
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
+	free_fifo(&c->free);
+	if (c->sb_bio)
+		bio_put(c->sb_bio);
+	if (c->priority_bio)
+		bio_put(c->priority_bio);
+
+	vfree(c->garbage);
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
+	kfree(c);
+}
+
+static void register_cache(const char *buffer, size_t size)
+{
+	int i;
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
+		&sysfs_pinned_buckets,
+		&sysfs_lru_end,
+		&sysfs_heap_size,
+		&sysfs_kb_written,
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
+	err = "Insufficient memory";
+	if (!(c->heap		= vmalloc(c->sb.nbuckets * sizeof(struct bucket *))) ||
+	    !(c->buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket))) ||
+	    !(c->disk_buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket_disk))) ||
+	    !(c->garbage	= vmalloc(c->sb.nbuckets * sizeof(struct bucket_gc))) ||
+	    !(c->sb_bio		= bio_kmalloc(GFP_KERNEL, 1)) ||
+	    !(c->priority_bio	= bio_kmalloc(GFP_KERNEL, pages(c, struct bucket_disk))) ||
+	    !init_fifo(&c->free, c->sb.nbuckets >> 7, GFP_KERNEL))
+		goto err;
+
+	atomic_set(&c->sb_bio->bi_remaining, 0);
+	c->sb_bio->bi_io_vec[0].bv_page = c->sb_page;
+	c->sb_bio->bi_io_vec[0].bv_len = 4096;
+	c->sb_bio->bi_io_vec[0].bv_offset = 0;
+
+	memset(c->heap,	   0, c->sb.nbuckets * sizeof(struct bucket *));
+	memset(c->buckets, 0, c->sb.nbuckets * sizeof(struct bucket));
+
+	spin_lock_init(&c->sb_lock);
+	spin_lock_init(&c->bucket_lock);
+	init_MUTEX(&c->gc_lock);
+
+	c->rescale = rescale;
+	c->btree_buckets_cached = 8;
+
+	load_priorities(c, !(c->sb.version & CACHE_CLEAN));
+
+	memset(&s, 0, sizeof(s));
+	if (c->sb.version & CACHE_CLEAN)
+		c->root = __get_bucket(c, c->sb.btree_root,
+				       c->sb.btree_level, true, &sp);
+	else
+		printk(KERN_DEBUG "bcache: Cache device %s was dirty, invalidating existing data", path);
+
+	c->sb.version &= ~CACHE_CLEAN;
+	if (!c->root) {
+		if (!(c->root = btree_alloc(c, 0, NULL, 0, 0, false)))
+			goto err;
+
+		set_new_root(c->root);
+	} else
+		list_del_init(&c->root->lru);
+
+	rw_unlock(true, c->root);
+	BUG_ON(sector_to_priority(c, c->root->offset) != (uint16_t) ~0);
+
+#if 0
+	memset(c->garbage, 0, c->sb.nbuckets * sizeof(struct bucket_gc));
+	for (i = 0; i < c->sb.nbuckets; i++)
+		c->garbage[i].gen = c->buckets[i].gen;
+
+	down(&c->gc_lock);
+	do_btree_gc(&c->work);
+#endif
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
+	struct cache_device *c = container_of(k, struct cache_device, kobj);
+	struct cached_bucket *b;
+
+	/* should write out current key
+	 */
+
+	list_add(&c->root->lru, &c->lru);
+	list_for_each_entry(b, &c->lru, lru)
+		__btree_write(b, 0, atomic_read(&b->nread), b->offset);
+
+	c->sb.version |= CACHE_CLEAN;
+
+	submit_bio_list(WRITE, save_priorities(c));
+	submit_bio_list(WRITE, write_super(c));
+	free_cache(c);
+}
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buffer)
+{
+	sysfs_print(cache_hits, "%lu\n", cache_hits);
+	sysfs_print(cache_hit_ratio, "%lu%%\n",
+		    cache_hits + cache_misses ?
+		    cache_hits * 100 / (cache_hits + cache_misses) : 0);
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
+	if (attr == &sysfs_clear_stats) {
+		struct cache_device *c;
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
+	static const struct attribute *files[] = { &sysfs_register_cache,
+		&sysfs_register_dev,
+		&sysfs_cache_hits,
+		&sysfs_cache_hit_ratio,
+		&sysfs_cache_misses,
+		&sysfs_cache_priority_initial,
+		&sysfs_cache_priority_hit,
+		&sysfs_cache_priority_seek,
+		&sysfs_cache_priority_rescale,
+		&sysfs_clear_stats,
+		NULL};
+
+	printk(KERN_DEBUG "bcache loading");
+
+	delayed = create_workqueue("bcache");
+	if (!delayed)
+		return -ENOMEM;
+
+	debug = debugfs_create_dir("bcache", NULL);
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
+}
+
+module_init(bcache_init);
+module_exit(bcache_exit);
