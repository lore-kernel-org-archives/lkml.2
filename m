Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab0GDHos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:44:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45921 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab0GDHop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dg13Jmn54WdoqjAigHsDOh2TvLHgAeKERImhLfWdb2mUAMxIJ2JyQrNr61ODis+Get
         WLoFACPxLf84CC0UOwcZTSql5cXKiStSMe7786qDF1KqIwIRaz4tFFfhfFNlfnfDsemx
         wdsl6Zbb3gBI1hqB5d9d09KckGwEGF55cKitg=
Date: Sun, 4 Jul 2010 00:44:34 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kent.overstreet@gmail.com
Subject: [RFC][PATCH 2/3] Bcache: Version 6 - The code
Message-ID: <f71c2693027f73e90b693ca5a8c2b8a06ba116cb.1278227772.git.kent.overstreet@gmail.com>
References: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0bdf4c5c6b14d429900cc58c28795bd5b6b8e85.1278227772.git.kent.overstreet@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 block/Makefile |    3 +
 block/bcache.c | 3830 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 3833 insertions(+), 0 deletions(-)
 create mode 100644 block/bcache.c

diff --git a/block/Makefile b/block/Makefile
index 0bb499a..383625f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -15,3 +15,6 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+
+obj-$(CONFIG_BLK_CACHE)		+= bcache.o
+CFLAGS_bcache.o			+= -std=gnu99
diff --git a/block/bcache.c b/block/bcache.c
new file mode 100644
index 0000000..0dbe757
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,3830 @@
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
+#include <linux/ctype.h>
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
+#include <linux/swap.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+/*
+ * Todo:
+ * IO tracking: Can we track when one process is doing io on behalf of another?
+ * IO tracking: Don't use just an average, weigh more recent stuff higher
+ *
+ * Disable barriers on backing device, or handle them
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
+ * get_bucket should be checking the gen, not priority
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
+	if ((((f)->back + 1) & (f)->size) != (f)->front) {	\
+		_r = true;					\
+		(f)->data[(f)->back++] = i;			\
+		(f)->back &= (f)->size;				\
+	} _r; })
+
+#define fifo_pop(f, i) ({					\
+	bool _r = false;					\
+	if ((f)->front != (f)->back) {				\
+		_r = true;					\
+		i = (f)->data[(f)->front++];			\
+		(f)->front &= (f)->size;			\
+	} _r; })
+
+#define fifo_used(f)	((((f)->back - (f)->front) & (f)->size))
+
+#define fifo_full(f)	((((f)->back + 1) & (f)->size) == (f)->front)
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
+#define DECLARE_HEAP(type, name)					\
+	struct {							\
+		size_t size;						\
+		type *data;						\
+	} name;
+
+#define init_heap(h, s, gfp) ({						\
+	(h)->data = NULL;						\
+	(h)->size = 0;							\
+	if (s * sizeof(*(h)->data) >= KMALLOC_MAX_SIZE)			\
+		(h)->data = vmalloc(s * sizeof(*(h)->data));		\
+	else if (s > 0)							\
+		(h)->data = kmalloc(s * sizeof(*(h)->data), gfp);	\
+	(h)->data; })
+
+#define heap_insert(h, b)	heap_add(h, b)
+
+struct search;
+struct btree;
+
+typedef void (search_fn) (struct search *);
+
+struct cache_sb {
+	uint8_t		magic[16];
+#define CACHE_CLEAN	1
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
+	size_t		heap;
+	atomic_t	pin;
+	uint16_t	priority;
+	uint8_t		gen;
+	uint8_t		last_gc;
+};
+
+struct bucket_gc {
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
+struct key {
+	uint64_t	key;
+	uint64_t	ptr;
+};
+
+struct cache {
+	struct list_head	list;
+	struct cache_sb		sb;
+	struct page		*sb_page;
+	struct bio		*sb_bio;
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
+	long			sectors_to_gc;
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
+	struct btree		*root;
+};
+
+struct open_bucket {
+	struct list_head	list;
+	struct cache		*cache;
+	struct task_struct	*last;
+
+	struct key		key;
+	sector_t		offset;
+	unsigned		sectors_free;
+	unsigned		sequential;
+	unsigned		task_nr_ios;
+	unsigned		task_io;
+	uint8_t			gen;
+};
+
+/*static struct io {
+	struct rb_node		node;
+	struct io		*heap;
+	long			jiffies;
+	uint64_t		key;
+	struct task_struct	*task;
+} recent_io[100];*/
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
+struct btree {
+	struct list_head	lru;
+	struct rw_semaphore	lock;
+	struct search		*wait;
+	struct cache		*c;
+
+	atomic_t		nread;
+	sector_t		offset;
+	uint16_t		level;
+	uint16_t		written;
+
+	struct page		*pages[];
+};
+
+struct search {
+	struct work_struct	w;
+	struct search		*next;
+	search_fn		*end_fn;
+	search_fn		*parent;
+	atomic_t		remaining;
+#define	SEARCH_BLOCK		1
+#define	SEARCH_WAITING		2
+	int			flags;
+
+	struct key		new_keys[2];
+	uint16_t		nkeys;
+	uint16_t		level;
+	uint16_t		lock;
+	uint16_t		nkeylist;
+	struct key		*keylist;
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
+
+static struct bio *write_super(struct cache *);
+static struct bio *save_priorities(struct cache *);
+static void do_btree_gc(struct work_struct *);
+static void unregister_cache(struct kobject *);
+static void fill_bucket_endio(struct bio *bio, int error);
+static void check_bio(struct bio *bio);
+static int request_read(struct request_queue *q, struct bio *bio,
+			struct search *s);
+
+#define label(l, foo)	if (0) { l: foo; }
+
+#define PAGE_SECTORS		(PAGE_SIZE / 512)
+#define pages(c, s)							\
+	(((sizeof(s) * c->sb.nbuckets) - 1) / PAGE_SIZE + 1)
+
+#define pages_per_bucket(b)	(b->c->sb.bucket_size / PAGE_SECTORS)
+#define pages_per_btree		(c->sb.bucket_size / PAGE_SECTORS)
+#define keys_per_page		(PAGE_SIZE / sizeof(struct key))
+
+#define bucket(c, s)							\
+	({ smp_rmb(); c->buckets + sector_to_bucket(c, s); })
+
+#define bucket_to_sector(c, b)						\
+	(((sector_t) (b) + c->sb.first_bucket) << c->bucket_size_bits)
+
+#define sector_to_bucket(c, s)						\
+	((long) (s >> c->bucket_size_bits) - c->sb.first_bucket)
+
+#define data(b)		((struct key **) (b)->pages + pages_per_bucket(b))
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
+ * value: 8 bit generation, 16 bit length, 40 bit offset
+ * All units are in sectors
+ */
+
+#define TREE_KEY(device, offset)	(((uint64_t) device) << 56 | (offset))
+#define KEY_DEV(k)			((int) ((k)->key >> 56))
+#define KEY_OFFSET(k)			((k)->key & ~((int64_t) ~0 << 56))
+
+#define PTR_GEN(k)			((uint8_t) ((k)->ptr & ~(~0 << 8)))
+#define PTR_SIZE(k)			((int) ((k)->ptr >> 8) & ~(~0 << 16))
+#define PTR_OFFSET(k)			((int64_t) (((k)->ptr) >> 24))
+#define TREE_PTR(gen, length, offset)	((uint64_t) (offset) << 24 |	\
+						(length) << 8 | (gen))
+
+#define PTR_BUCKET(b, ptr)	bucket(b->c, PTR_OFFSET(ptr))
+#define bucket_to_ptr(b)						\
+	TREE_PTR(bucket(b->c, b->offset)->gen, 0, b->offset)
+
+#define bucket_key(b)							\
+	(struct key) { .key = last_key(data(b)), .ptr = bucket_to_ptr(b) }
+
+static inline struct key *node(struct key *d[], int i)
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
+#define ANYSINT_MAX(t)						\
+	((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
+
+static ssize_t hprint(char *buf, int64_t v)
+{
+	static const char units[] = "\0kMGTPEZY";
+	char dec[3] = "";
+	int u, t;
+
+	for (u = 0; v >= 1024 || v <= -1024; u++)
+		t = do_div(v, 1024);
+
+	if (u && v < 100 && v > -100)
+		sprintf(dec, ".%i", t / 100);
+
+	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
+}
+
+#define STRTO_H(name, type)					\
+static int name ## _h(const char *cp, type *res)		\
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
+}
+
+STRTO_H(strtol, long)
+STRTO_H(strtoll, long long)
+STRTO_H(strtoul, unsigned long)
+STRTO_H(strtoull, unsigned long long)
+
+#define strtoi_h(cp, res)						\
+	(__builtin_types_compatible_p(typeof(*res), long)		\
+	? strtol_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), long long)		\
+	? strtoll_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), unsigned long)	\
+	? strtoul_h(cp, (void *) res)					\
+	: __builtin_types_compatible_p(typeof(*res), unsigned long long)\
+	? strtoull_h(cp, (void *) res) : -EINVAL)			\
+
+static int lookup_id(struct cache *c, int id)
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
+static int lookup_dev(struct cache *c, struct bio *bio)
+{	return lookup_id(c, bio->bi_bdev->bd_cache_identifier); }
+
+static void run_search(struct work_struct *w)
+{
+	struct search *s = container_of(w, struct search, w);
+	search_fn *f = NULL;
+	swap(f, s->end_fn);
+	atomic_set(&s->remaining, 1);
+	f(s);
+}
+
+static void put_search(struct search *s)
+{
+	BUG_ON(object_is_on_stack(s));
+	if (atomic_dec_and_test(&s->remaining)) {
+		BUG_ON(s->flags & SEARCH_WAITING);
+		smp_rmb();
+		if (!s->end_fn)
+			kfree(s);
+		else
+			BUG_ON(!queue_work(delayed, &s->w));
+	} else if (atomic_read(&s->remaining) < 0)
+		panic("end_fn %p", s->end_fn);
+}
+
+#define return_f(s, f, ...) do {					\
+	if ((s) && !object_is_on_stack(s)) {				\
+		(s)->end_fn = f;					\
+		smp_wmb();						\
+		put_search(s);						\
+	}								\
+	return __VA_ARGS__;						\
+} while (0)
+
+#define run_wait_list(condition, list) do {				\
+	smp_mb();							\
+	if (condition) {						\
+		struct search *_s, *_next;			\
+		for (_s = xchg(&(list), NULL); _s; _s = _next) {	\
+			_next = _s->next;				\
+			_s->flags &= ~SEARCH_WAITING;			\
+			if (_s->flags & SEARCH_BLOCK)			\
+				wake_up(&pending);			\
+			else						\
+				put_search(_s);				\
+		}							\
+	}								\
+} while (0)
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
+static struct search *alloc_search(struct search *s)
+{
+	struct search *r = s;
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
+static void queue_gc(struct cache *c)
+{
+	long i;
+	if (down_trylock(&c->gc_lock))
+		return;
+
+	c->sectors_to_gc = c->sb.bucket_size * c->sb.nbuckets / 4;
+
+	memset(c->garbage, 0,
+	       c->sb.nbuckets * sizeof(struct bucket_gc));
+
+	for (i = 0; i < c->sb.nbuckets; i++)
+		c->garbage[i].gen = c->buckets[i].gen;
+
+	pr_debug("starting gc, need_gc %i", c->need_gc);
+	INIT_WORK(&c->work, do_btree_gc);
+	queue_work(delayed, &c->work);
+}
+
+static uint8_t __inc_bucket_gen(struct cache *c, long b)
+{
+	uint8_t ret = ++c->buckets[b].gen;
+	if (c->buckets[b].priority == (uint16_t) ~0)
+		pr_debug("bucket %li: %p %p %p", b,
+			 __builtin_return_address(0),
+			 __builtin_return_address(1),
+			 __builtin_return_address(2));
+
+	c->need_gc = max_t(uint8_t, c->need_gc,
+			   ret - c->buckets[b].last_gc);
+
+	if (c->need_gc > 64)
+		queue_gc(c);
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
+#define inc_gen(c, o)	inc_bucket_gen(c, sector_to_bucket(c, o))
+
+static void rescale_heap(struct cache *c, int sectors)
+{
+	spin_lock(&c->bucket_lock);
+	c->rescale -= sectors;
+	if (c->rescale <= 0) {
+		long i;
+		for (i = 0; i < c->heap_size; i++) {
+			uint16_t t = c->heap[i]->priority - 10;
+
+			BUG_ON(c->heap[i]->priority == (uint16_t) ~0);
+			c->heap[i]->priority = t < c->heap[i]->priority ? t : 0;
+		}
+		c->rescale += c->sb.bucket_size * c->sb.nbuckets / 128;
+	}
+	spin_unlock(&c->bucket_lock);
+}
+
+#define heap_cmp(i, j)	(c->heap[i]->priority >= c->heap[j]->priority)
+
+static void heap_swap(struct cache *c, long i, long j)
+{
+	swap(c->heap[i], c->heap[j]);
+	c->heap[i]->heap = i;
+	c->heap[j]->heap = j;
+}
+
+static void heap_sift(struct cache *c, long h)
+{
+	long r;
+
+	for (; h * 2 + 1 < c->heap_size; h = r) {
+		r = h * 2 + 1;
+		if (r + 1 < c->heap_size &&
+		    heap_cmp(r, r + 1))
+			r++;
+
+		if (heap_cmp(r, h))
+			break;
+		heap_swap(c, r, h);
+	}
+}
+
+static void heap_insert(struct cache *c, long b)
+{
+	long p, h = c->buckets[b].heap;
+	BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+
+	if (h == -1) {
+		h = c->heap_size++;
+		c->heap[h] = &c->buckets[b];
+		c->heap[h]->heap = h;
+	}
+
+	while (h) {
+		p = (h - 1) / 2;
+		if (heap_cmp(h, p))
+			break;
+		heap_swap(c, h, p);
+		h = p;
+	}
+
+	heap_sift(c, h);
+}
+
+static long heap_pop(struct cache *c)
+{
+	long ret = c->heap[0] - c->buckets;
+
+	if (!c->heap_size) {
+		printk(KERN_ERR "bcache: empty heap!");
+		return -1;
+	}
+
+	BUG_ON(c->buckets[ret].priority == (uint16_t) ~0);
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
+static long pop_bucket(struct cache *c, uint16_t priority)
+{
+	long r;
+
+	if (fifo_used(&c->free) < c->free.size / 2) {
+		while (!fifo_full(&c->free)) {
+			r = heap_pop(c);
+
+			if (r == -1)
+				break;
+
+			fifo_push(&c->free, r);
+
+			if (blk_queue_discard(bdev_get_queue(c->bdev))) {
+				spin_unlock(&c->bucket_lock);
+				/* should do this asynchronously */
+				blkdev_issue_discard(c->bdev,
+						     bucket_to_sector(c, r),
+						     c->sb.bucket_size,
+						     GFP_NOIO, 0);
+				spin_lock(&c->bucket_lock);
+			}
+		}
+
+		spin_unlock(&c->bucket_lock);
+		submit_bio_list(WRITE, save_priorities(c));
+		spin_lock(&c->bucket_lock);
+	}
+
+	if (fifo_pop(&c->free, r)) {
+		__inc_bucket_gen(c, r);
+		c->buckets[r].priority = priority;
+		BUG_ON(c->buckets[r].heap != -1);
+	} else
+		r = -1;
+
+	pr_debug("popping bucket %li prio %u", r, priority);
+	return r;
+}
+
+#define run_on_root(write, f, ...) ({					\
+	int _r = -2;							\
+	do {								\
+		struct btree *_b = c->root;				\
+		bool _w = (write);					\
+		rw_lock(_w, _b);					\
+		if (bucket(c, _b->offset)->priority == (uint16_t) ~0 &&	\
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
+	else if (rand(i) != rand(data(b)))				\
+		_cont = false;						\
+	else if (keys(i) > keys_can_fit(i, b)) {			\
+		printk(KERN_WARNING "bcache: %s() "			\
+		       "bad btree header: page %i, %i keys",		\
+		       __func__, index(i, b), keys(i));			\
+		keys(i) = 0;						\
+		if (i != data(b))					\
+			_cont = false;					\
+	}								\
+	_cont; })
+
+#define next_set(i)	(keys(i) / keys_per_page + 1)
+
+#define __for_each_sorted_set(_init, _i, b)				\
+	for (_init = data(b); sorted_set_checks(_i, b); _i += next_set(_i))
+
+#define for_each_sorted_set(i, b)					\
+	__for_each_sorted_set(i, i, b)
+
+#define for_each_key(b, iter)						\
+	__for_each_sorted_set(struct key **_i, _i, b)			\
+		for (int _j = 1; iter = node(_i, _j), _j <= keys(_i); _j++)
+
+#define __for_good_keys(b, i, iter, start, end)				\
+	for (int _j = start;						\
+	     ({ _j = next_good_key(i, _j, b); iter = node(i, _j);	\
+	      _j <= end; });						\
+	     _j++)
+
+#define for_each_good_key(b, iter)					\
+	__for_each_sorted_set(struct key **_i, _i, b)			\
+		__for_good_keys(b, _i, iter, 1, keys(_i))
+
+#define for_good_keys_after(b, i, iter,  _search)			\
+	__for_good_keys(b, i, iter, btree_bsearch(i, _search), keys(i))
+
+#define for_each_good_key_after(b, iter, _search)			\
+	__for_each_sorted_set(struct key **_i, _i, b)			\
+		for_good_keys_after(b, _i, iter, _search)
+
+static bool should_split(struct btree *b, struct key *i[])
+{
+	return index(i, b) >= pages_per_bucket(b) ||
+		(rand(i) == rand(data(b)) &&
+		 keys(i) + 2 > keys_can_fit(i, b));
+}
+
+static void free_bucket_contents(struct btree *b, bool alive)
+{
+	int i;
+
+	b->written = 0;
+	for (i = 0; i < pages_per_bucket(b); i++)
+		if (b->pages[i]) {
+			if (alive)
+				mark_page_accessed(b->pages[i]);
+
+			kunmap(b->pages[i]);
+			put_page(b->pages[i]);
+			b->pages[i] = NULL;
+		}
+#if 0
+	if (!alive) {
+		struct address_space *mapping = p[0]->mapping;
+
+		spin_lock_irq(&mapping->tree_lock);
+		for (i = 0; i < pages; i++)
+			__remove_from_page_cache(p[i]);
+		spin_unlock_irq(&mapping->tree_lock);
+	}
+#endif
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
+		} else if (i == nread)
+			nread++;
+
+		data(b)[i] = kmap(b->pages[i]);
+		BUG_ON(b->offset + i * PAGE_SECTORS
+		       != page_index(b->pages[i]) * PAGE_SECTORS);
+	}
+
+	if (nread != pages_per_bucket(b)) {
+		struct bio_vec *bv;
+		struct bio *bio = bio_kmalloc(GFP_NOIO,
+					      pages_per_bucket(b));
+		if (!bio)
+			goto err;
+
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
+		submit_bio_list(READ, bio);
+	} else {
+		struct key **j;
+		for (j = data(b) + b->written;
+		     sorted_set_checks(j, b);
+		     j += keys(j) / keys_per_page + 1)
+			b->written = index(j, b) + keys(j) / keys_per_page + 1;
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
+static void write_endio(struct bio *bio, int error)
+{
+	int i;
+	struct cache *c = bio->bi_private;
+	BUG_ON(error);
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
+static void btree_write_endio(struct bio *bio, int error)
+{
+	int i;
+	struct bio_vec *bv;
+
+	BUG_ON(error);
+	__bio_for_each_segment(bv, bio, i, 0)
+		__free_page(bv->bv_page);
+	bio_put(bio);
+}
+
+static void __btree_write(struct btree *b, sector_t offset)
+{
+	int n = 0;
+	struct bio *bio;
+	struct bio_vec *bv;
+	struct key **i;
+
+	for (i = data(b) + b->written;
+	     sorted_set_checks(i, b);
+	     i += keys(i) / keys_per_page + 1)
+		n = index(i, b) + keys(i) / keys_per_page + 1;
+
+	if (n <= b->written)
+		return;
+
+	if (!(bio = bio_kmalloc(GFP_NOIO, n - b->written)))
+		goto err;
+
+	bio->bi_sector	= page_index(b->pages[b->written]) * PAGE_SECTORS;
+	bio->bi_bdev	= b->c->bdev;
+	bio->bi_vcnt	= n - b->written;
+	bio->bi_size	= PAGE_SIZE * bio->bi_vcnt;
+
+	bio->bi_end_io	= btree_write_endio;
+	bio->bi_private	= b->c;
+
+	bio_for_each_segment(bv, bio, n) {
+		bv->bv_page	= alloc_page(GFP_NOIO);
+		bv->bv_len	= PAGE_SIZE;
+		bv->bv_offset	= 0;
+		if (!bv->bv_page)
+			goto err;
+
+		memcpy(kmap(bv->bv_page), data(b)[b->written + n], PAGE_SIZE);
+		kunmap(bv->bv_page);
+	}
+	b->written += n;
+
+	submit_bio_list(WRITE, bio);
+	return;
+err:
+	bio_put(bio);
+	BUG();
+}
+
+static void btree_write(struct btree *b, int skip)
+{
+	if (((keys(&data(b)[skip]) + 1) % keys_per_page) == 0)
+		__btree_write(b, b->offset);
+}
+
+__pure
+static bool __ptr_bad(struct btree *b, struct key *k)
+{
+	sector_t bucket = PTR_OFFSET(k) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(k) & ~(~0 << b->c->bucket_size_bits);
+
+	return (!k->key ||
+		(b->level && (PTR_SIZE(k) || r)) ||
+		(!b->level && !PTR_SIZE(k)) ||
+		bucket <  b->c->sb.first_bucket ||
+		bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets ||
+		PTR_SIZE(k) + r > b->c->sb.bucket_size);
+}
+
+static bool ptr_bad(struct btree *b, struct key *k)
+{
+	return __ptr_bad(b, k) || PTR_GEN(k) != PTR_BUCKET(b, k)->gen;
+}
+
+static bool ptr_status(struct btree *b, struct key *k, char *buf)
+{
+	sector_t bucket = PTR_OFFSET(k) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(k) & ~(~0 << b->c->bucket_size_bits);
+	uint8_t stale = 0;
+
+	*buf = 0;
+	if (!k->key || !PTR_OFFSET(k))
+		sprintf(buf, "bad, null key");
+	if (bucket >= b->c->sb.first_bucket + b->c->sb.nbuckets)
+		sprintf(buf, "bad, offset past end of device");
+	if (bucket <  b->c->sb.first_bucket)
+		sprintf(buf, "bad, short offset");
+	if (b->level && (PTR_SIZE(k) || r))
+		sprintf(buf, "bad, nonzero size/offset into bucket");
+	if (PTR_SIZE(k) + r > b->c->sb.bucket_size)
+		sprintf(buf, "bad, length too big");
+	if (!b->level && !PTR_SIZE(k))
+		sprintf(buf, "zeroed key");
+
+	if (!*buf)
+		stale = PTR_BUCKET(b, k)->gen - PTR_GEN(k);
+	if (stale)
+		sprintf(buf, "stale %i", stale);
+	return *buf;
+}
+
+static struct btree *alloc_bucket(struct cache *c, struct btree **n, int level,
+				  sector_t offset, int count, bool lru)
+{
+	struct btree *b;
+	sector_t old_offset = 0;
+
+	list_for_each_entry_reverse(b, &c->lru, lru)
+		if (count-- < c->btree_buckets_cached)
+			break;
+		else if (atomic_read(&b->nread) == pages_per_btree &&
+			 down_write_trylock(&b->lock)) {
+			BUG_ON(b->wait);
+			list_del(&b->lru);
+			old_offset = b->offset;
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
+
+		if (n) {
+			*n = b;
+			return NULL;
+		}
+		spin_lock(&c->bucket_lock);
+	}
+	BUG_ON(!down_write_trylock(&b->lock));
+found:
+	b->offset	= offset;
+	b->c		= c;
+	b->level	= level;
+
+	if (lru)
+		list_add(&b->lru, &c->lru);
+	else
+		INIT_LIST_HEAD(&b->lru);
+
+	spin_unlock(&c->bucket_lock);
+
+	if (b->pages[0])
+		__btree_write(b, old_offset);
+	atomic_set(&b->nread, 0);
+	free_bucket_contents(b, true);
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
+	if (bucket(c, offset)->priority != (uint16_t) ~0)
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
+	b = alloc_bucket(c, &n, level, offset, i, true);
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
+	if (IS_ERR(wait_search(atomic_read(&b->nread) == pages_per_bucket(b),
+			       b->wait, *s))) {
+		rw_unlock(write, b);
+		goto err;
+	}
+
+	if (bucket(c, offset)->priority == (uint16_t) ~0) {
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
+	pr_debug("bucket %llu has been freed, gen %i, called from %p",
+		 (uint64_t) offset, bucket(c, offset)->gen,
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
+static struct btree *get_bucket(struct btree *b, struct key *k,
+				bool write, struct search **s)
+{
+	struct btree *r;
+	BUG_ON(!b->level);
+	r = __get_bucket(b->c, PTR_OFFSET(k), b->level - 1, write, s);
+	if (!r && !ptr_bad(b, k))
+		inc_gen(b->c, PTR_OFFSET(k));
+	if (!IS_ERR_OR_NULL(r) && PTR_GEN(k) != PTR_BUCKET(r, k)->gen) {
+		rw_unlock(write, r);
+		r = NULL;
+	}
+	return r;
+}
+
+static void btree_free(struct btree *b, bool discard)
+{
+	struct cache *c = b->c;
+	long n = sector_to_bucket(c, b->offset);
+	BUG_ON(n < 0 || n > c->sb.nbuckets);
+	BUG_ON(b == c->root);
+
+	spin_lock(&c->bucket_lock);
+
+	__inc_bucket_gen(c, n);
+	c->buckets[n].priority = 0;
+
+	if (!fifo_push(&c->free, n))
+		heap_insert(c, n);
+
+	free_bucket_contents(b, false);
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
+static struct btree *btree_alloc(struct cache *c, int level, struct key *old[],
+				 int nkeys, int skip, bool lru)
+{
+	long i = 0, bucket;
+	struct btree *b = NULL;
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
+	b = alloc_bucket(c, NULL, level, bucket_to_sector(c, bucket), i, lru);
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
+	get_random_bytes(&rand(data(b)), sizeof(uint64_t));
+	keys(data(b)) = nkeys - skip;
+
+	if (old)
+		for (i = 1; i <= keys(data(b)); i++)
+			*node(data(b), i) = *node(old, i + skip);
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
+static void set_new_root(struct btree *b)
+{
+	struct bio *bio;
+	struct cache *c = b->c;
+	BUG_ON(bucket(c, b->offset)->priority != (uint16_t) ~0);
+	BUG_ON(!rand(data(b)));
+
+	spin_lock(&c->bucket_lock);
+	c->sb.btree_level = b->level;
+	c->sb.btree_root = b->offset;
+	c->root = b;
+
+	bio = write_super(c);
+	spin_unlock(&c->bucket_lock);
+	submit_bio_list(WRITE, bio);
+
+	pr_debug("new root %lli called from %p", c->sb.btree_root,
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
+
+		b = sector_to_bucket(c, bio->bi_sector);
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+		c->buckets[b].priority = (long) initial_priority;
+			/* * (cache_hit_seek + cache_hit_priority
+			 * bio_sectors(bio) / c->sb.bucket_size)
+			/ (cache_hit_seek + cache_hit_priority);*/
+		BUG_ON(c->buckets[b].priority == (uint16_t) ~0);
+
+		if (c->buckets[b].heap != -1)
+			heap_sift(c, c->buckets[b].heap);
+
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
+		atomic_dec(&bucket(c, s)->pin);
+	}
+
+	if (c->rescale < 0)
+		rescale_heap(c, 0);
+}
+
+static int next_good_key(struct key *i[], int j, struct btree *b)
+{
+	while (j <= keys(i) && ptr_bad(b, node(i, j)))
+		j++;
+	return j;
+}
+
+#ifdef EDEBUG
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
+static int count_data(struct btree *b)
+{
+	int ret = 0;
+	struct key *k;
+
+	for_each_good_key(b, k)
+		ret += PTR_SIZE(k);
+	return ret;
+}
+
+static void dump_bucket_and_panic(struct btree *b)
+{
+	struct key *k, *prev = NULL;
+	printk(KERN_ERR "\n");
+
+	for_each_key(b, k) {
+		char buf[30];
+		int priority = -1;
+		long bucket = sector_to_bucket(b->c, PTR_OFFSET(k));
+
+		if (bucket >= 0 && bucket < b->c->sb.nbuckets)
+			priority = b->c->buckets[bucket].priority;
+
+		if (_j > 1 && prev->key > k->key - PTR_SIZE(k))
+			printk(KERN_ERR "Key skipped backwards\n");
+
+		ptr_status(b, k, buf);
+		printk(KERN_ERR "page %i key %i/%i: key %llu -> "
+		       "offset %llu len %i gen %i bucket %li prio %i %s",
+		       index(_i, b), _j, keys(_i), k->key,
+		       PTR_OFFSET(k), PTR_SIZE(k), PTR_GEN(k),
+		       sector_to_bucket(b->c, PTR_OFFSET(k)),
+		       priority, buf);
+		prev = k;
+	}
+	panic("at offset %llu", (uint64_t) b->offset);
+}
+
+static void dump_key_and_panic(struct btree *b, struct key *i[], int j)
+{
+	sector_t bucket = PTR_OFFSET(k) >> b->c->bucket_size_bits;
+	long r = PTR_OFFSET(k) & ~(~0 << b->c->bucket_size_bits);
+
+	printk(KERN_ERR "\nlevel %i page %i key %i/%i: %llu -> "
+	       "%llu len %i bucket %llu offset %li into bucket",
+	       b->level, index(i, b), j, keys(i),
+	       KEY_OFFSET(node(i, j)), PTR_OFFSET(node(i, j)),
+	       PTR_SIZE(node(i, j)), (uint64_t) bucket, r);
+	dump_bucket_and_panic(b);
+}
+
+#define DUMP_KEY_BUG_ON(condition, b, i, j, ...) do {	\
+	if (condition) {				\
+		printk(KERN_ERR __VA_ARGS__);		\
+		dump_key_and_panic(b, i, j);		\
+	}						\
+} while (0)
+
+static void check_overlapping_keys(struct btree *b, struct key *i[])
+{
+	int m, j;
+	struct key **c;
+
+	for (m = 1; m < keys(i); m++)
+		for_each_sorted_set(c, b) {
+			if (c >= i)
+				break;
+
+			for (j = 1; j < keys(c); j++)
+				if (PTR_SIZE(node(c, j)) &&
+				    PTR_SIZE(node(i, m)) &&
+				    ((node(i, m)->key >= node(c, j)->key &&
+				      node(i, m)->key - PTR_SIZE(node(i, m))
+				      < node(c, j)->key) ||
+				     (node(c, j)->key >= node(i, m)->key &&
+				      node(c, j)->key - PTR_SIZE(node(c, j))
+				      < node(i, m)->key)))
+					dump_key_and_panic(b, i, j);
+		}
+}
+
+static void check_key_order(struct btree *b, struct key *i[])
+{
+	int j;
+	for (j = 2; j <= keys(i); j++)
+		if (node(i, j - 1)->key >
+		    node(i, j)->key - PTR_SIZE(node(i, j)))
+			panic("key skipped backwards, page %i key %i/%i: "
+			      "%llu -> %llu len %i\n"
+			      "prev %llu -> %llu len %i\n",
+			      index(i, b), j, keys(i), node(i, j)->key,
+			      PTR_OFFSET(node(i, j)), PTR_SIZE(node(i, j)),
+			      node(i, j - 1)->key,
+			      PTR_OFFSET(node(i, j - 1)),
+			      PTR_SIZE(node(i, j - 1)));
+}
+
+#else /* EDEBUG */
+
+static void check_bio(struct bio *bio)
+{ }
+
+#define count_data(b)	0
+#define dump_bucket_and_panic(b)			do {} while (0)
+#define dump_key_and_panic(b, i, j)			do {} while (0)
+#define check_overlapping_keys(b, i)			do {} while (0)
+#define DUMP_KEY_BUG_ON(condition, b, i, j, ...)	do {} while (0)
+#define check_key_order(b, i)				do {} while (0)
+
+#endif
+
+/*
+ * Returns the smallest key greater than the search key.
+ * This is because we index by the end, not the beginning
+ */
+static int btree_bsearch(struct key *i[], uint64_t search)
+{
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
+static bool do_fixup(bool front, uint64_t key, struct key *k)
+{
+	struct key old = *k;
+	int len;
+
+	if (front) {
+		if (key <= k->key - PTR_SIZE(k))
+			return false;
+
+		BUG_ON(key > k->key);
+
+		len = key - (k->key - PTR_SIZE(k));
+		k->ptr += TREE_PTR(0, 0, len);
+	} else {
+		if (key >= k->key)
+			return false;
+
+		len = k->key - key;
+		k->key -= len;
+	}
+	k->ptr -= TREE_PTR(0, min(len, PTR_SIZE(k)), 0);
+
+	pr_debug("fixing up %s of %llu -> %llu len %i by %i sectors: "
+		 "now %llu -> %llu len %i", front ? "front" : "back",
+		 old.key, PTR_OFFSET(&old), PTR_SIZE(&old), len,
+		 k->key, PTR_OFFSET(k), PTR_SIZE(k));
+	return true;
+}
+
+static void shift_keys(struct key *i[], size_t j)
+{
+	int k;
+	for (k = keys(i)++; k >= j; --k)
+		*node(i, k + 1) = *node(i, k);
+}
+
+static bool fixup_old_keys(struct btree *b, struct key *end[],
+			   struct key *k, bool insert)
+{
+	bool ret = false;
+	struct key **i;
+	int j;
+
+	if (b->level)
+		return false;
+
+	for_each_sorted_set(i, b) {
+		if (i >= end)
+			break;
+
+		j = btree_bsearch(i, k->key);
+
+		if (j <= keys(i)) {
+			if (insert &&
+			    k->key - PTR_SIZE(k) >
+			    node(i, j)->key - PTR_SIZE(node(i, j))) {
+				int m = btree_bsearch(end, node(i, j)->key);
+				shift_keys(end, m);
+
+				*node(end, m) = *node(i, j);
+				do_fixup(false, k->key - PTR_SIZE(k),
+					 node(end, m));
+			}
+
+			if (do_fixup(true, k->key, node(i, j)))
+				ret = true;
+		}
+
+		while (--j)
+			if (!do_fixup(false, k->key - PTR_SIZE(k), node(i, j)))
+				break;
+			else
+				ret = true;
+	}
+	return ret;
+}
+
+static void fill_bucket_endio(struct bio *bio, int error)
+{
+	/* XXX: flag error here
+	 */
+	struct btree *b = bio->bi_private;
+	struct key **i;
+
+	BUG_ON(error);
+
+	for_each_sorted_set(i, b) {
+		check_key_order(b, i);
+		b->written = index(i, b) + next_set(i);
+
+		if (i != data(b))
+			for (int j = 1; j <= keys(i); j++)
+				fixup_old_keys(b, i, node(i, j), false);
+	}
+
+	//btree_clean(b, 0);
+
+	smp_wmb();
+	atomic_set(&b->nread, pages_per_bucket(b));
+	run_wait_list(1, b->wait);
+	bio_put(bio);
+}
+
+static int btree_search(struct btree *b, int dev, struct bio *bio,
+			struct bio_list *l)
+{
+	int ret = -1;
+	struct key *k, **i, **reverse;
+	struct bio *split;
+	uint64_t search = TREE_KEY(dev, bio->bi_sector);
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
+		for_good_keys_after(b, i, k, search) {
+			if (search < k->key - PTR_SIZE(k))
+				break;
+
+			BUG_ON(search >= k->key);
+
+			pr_debug("page %i: key %llu -> %llu len %i gen %i",
+				 index(i, b), k->key,
+				 PTR_OFFSET(k), PTR_SIZE(k), PTR_GEN(k));
+
+			atomic_inc(&PTR_BUCKET(b, k)->pin);
+			smp_mb__after_atomic_inc();
+
+			if (PTR_BUCKET(b, k)->gen != PTR_GEN(k)) {
+				atomic_dec(&PTR_BUCKET(b, k)->pin);
+				continue;
+			}
+
+			DUMP_KEY_BUG_ON(PTR_BUCKET(b, k)->priority ==
+					(uint16_t) ~0, b, i, _j);
+
+			if (!(split = bio_split_front(bio, k->key - search, NULL))) {
+				atomic_dec(&PTR_BUCKET(b, k)->pin);
+				goto err;
+			}
+
+			split->bi_sector += PTR_SIZE(k)
+				- KEY_OFFSET(k) + PTR_OFFSET(k);
+
+			bio_list_add(l, split);
+
+			pr_debug("cache hit of %i sectors from %llu, "
+				 "need %i sectors", bio_sectors(split),
+				 (uint64_t) split->bi_sector,
+				 split == bio ? 0 : bio_sectors(bio));
+
+			if (split == bio)
+				return 1;
+
+			search = TREE_KEY(dev, bio->bi_sector);
+		}
+	} while (i != data(b));
+
+	label(err,	ret = -1);
+	return ret;
+}
+
+static int btree_search_recurse(struct btree *b, int dev, struct bio *bio,
+				struct bio_list *l, struct search **s)
+{
+	int ret = -1;
+	struct btree *r;
+	uint64_t search;
+
+	do {
+		struct key *k, recurse = { .key = ~0, .ptr = 0 };
+		search = TREE_KEY(dev, bio->bi_sector);
+
+		pr_debug("level %i bucket %li searching for %llu",
+			 b->level, sector_to_bucket(b->c, b->offset), search);
+
+		if (b->level) {
+			for_each_good_key_after(b, k, search) {
+				if (recurse.key > k->key)
+					recurse = *k;
+				break;
+			}
+
+			if (recurse.key == ~0)
+				break;
+
+			r = get_bucket(b, &recurse, false, s);
+			if (r == ERR_PTR(-EAGAIN))
+				goto again;
+			if (IS_ERR_OR_NULL(r))
+				goto err;
+
+			search = recurse.key;
+			ret = max(ret, btree_search_recurse(r, dev, bio, l, s));
+		} else
+			ret = max(ret, btree_search(b, dev, bio, l));
+	} while (ret < 1 &&
+		 ((!b->level) ^ (search == TREE_KEY(dev, bio->bi_sector))));
+
+	label(err,	ret = -1);
+	label(again,	ret = 0);
+	rw_unlock(false, b);
+	return ret;
+}
+
+static void btree_sort(struct key **d, size_t num)
+{
+	size_t i;
+
+	void sift(size_t r, size_t n)
+	{
+		int c = r * 2;
+		for (; c <= n; r = c, c *= 2) {
+			if (c < n &&
+			    node(d, c)->key < node(d, c + 1)->key)
+				c++;
+			if (node(d, c)->key < node(d, r)->key)
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
+static bool btree_merge_key(struct btree *b, struct key *i[],
+			    size_t *j, struct key *k)
+{
+	bool try_merge(struct key *l, struct key *r)
+	{
+		if (l->key == r->key - PTR_SIZE(r) &&
+		    PTR_OFFSET(l) + PTR_SIZE(l) == PTR_OFFSET(r) &&
+		    PTR_GEN(l) == PTR_GEN(r) &&
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
+	BUG_ON(!k->key);
+
+	if (*j <= keys(i) && !b->level) {
+		if (k->key - PTR_SIZE(k) >
+		    node(i, *j)->key - PTR_SIZE(node(i, *j)))
+			shift_keys(i, (*j)++);
+
+		try_merge(k, node(i, *j));
+		do_fixup(true, k->key, node(i, *j));
+	}
+
+	if (--(*j) && !b->level) {
+		if (try_merge(node(i, *j), k))
+			return true;
+
+		for (int m = *j; m; --m)
+			if (!do_fixup(false, k->key - PTR_SIZE(k), node(i, m)))
+				break;
+
+		if (!PTR_SIZE(node(i, *j)))
+			return true;
+	} else if (*j && b->level &&
+		   !ptr_bad(b, node(i, *j)) &&
+		   node(i, *j)->ptr == k->ptr) {
+		node(i, *j)->key = max(node(i, *j)->key, k->key);
+		return true;
+	}
+	(*j)++;
+
+	if (*j <= keys(i) && !b->level && !PTR_SIZE(node(i, *j)))
+		return true;
+	return false;
+}
+
+static void btree_clean(struct btree *b, uint64_t smallest)
+{
+	size_t j, n, orig = 0;
+	struct key **i;
+	int oldsize, newsize;
+	uint64_t biggest = 0;
+
+	bool bad(struct key *k)
+	{
+		if (smallest > k->key - PTR_SIZE(k)) {
+			int len = smallest - (k->key - PTR_SIZE(k));
+			if (len >= PTR_SIZE(k))
+				return true;
+			if (len > 0)
+				do_fixup(true, len, k);
+		}
+		return b->written
+			? __ptr_bad(b, k)
+			: ptr_bad(b, k);
+	}
+
+	oldsize = count_data(b);
+
+	for (i = data(b);
+	     sorted_set_checks(i, b);
+	     i += (n / keys_per_page) + 1) {
+		if (b->written && index(i, b) >= b->written)
+			break;
+
+		biggest = max(biggest, last_key(i));
+
+		orig += n = keys(i);
+
+		if (data(b) == i)
+			for (j = 1; j <= keys(i); j++)
+				while ((bad(node(i, j))) && j <= --keys(i))
+					*node(i, j) = *node(i, keys(i) + 1);
+		else
+			for (j = 1; j <= n; j++)
+				if (!bad(node(i, j)))
+					*node(data(b), ++keys(data(b))) =
+						*node(i, j);
+	}
+
+	btree_sort(data(b), keys(data(b)));
+
+	if (b->written)
+		for (i = data(b) + next_set(data(b));
+		     index(i, b) < b->written;
+		     i++) {
+			rand(i) = rand(data(b));
+			keys(i) = 0;
+		}
+	else
+		get_random_bytes(&rand(data(b)), sizeof(uint64_t));
+
+	for (j = 1, n = 0; j <= keys(data(b)); j++)
+		if (ptr_bad(b, node(data(b), j)))
+			n++;
+
+	newsize = count_data(b);
+	if (newsize < oldsize)
+		pr_debug("was %i now %i, smallest %llu, biggest %llu",
+			 oldsize, newsize, smallest, biggest);
+
+	check_key_order(b, data(b));
+	pr_debug("merged %i keys from %zu keys, %zu now bad",
+		 keys(data(b)), orig, n);
+}
+
+static int btree_gc(struct btree *b, struct key *root,
+		    uint64_t smallest, struct search **s)
+{
+	int ret = 0;
+	long bucket;
+	struct key *k;
+	struct btree *n = NULL, *r;
+	struct bucket_gc *g;
+
+#define mark_bad(k)							\
+	printk(KERN_WARNING "bcache: btree and data pointers to "	\
+	       "same bucket %li, priority %i: "				\
+	       "level %i key %llu -> offset %llu len %i",		\
+	       bucket, b->c->buckets[bucket].priority,			\
+	       b->level, k->key, PTR_OFFSET(k), PTR_SIZE(k));
+
+	for_each_key(b, k)
+		if (!__ptr_bad(b, k))
+			ret = max_t(uint8_t, ret,
+				    PTR_BUCKET(b, k)->gen - PTR_GEN(k));
+
+	if (b->written &&
+	    (b->level || ret > 10) &&
+	    (n = btree_alloc(b->c, b->level, NULL, 0, 0,
+			     b->c->sb.btree_level != b->level))) {
+		for (int j = 0; j < pages_per_bucket(b); j++)
+			memcpy(data(n)[j], data(b)[j], PAGE_SIZE);
+		swap(b, n);
+	}
+
+	if (!b->written) {
+		btree_clean(b, smallest);
+		ret = 0;
+	} else if (b->level)
+		goto err;
+
+	if (b->level) {
+		int j, k;
+		struct key **i;
+		for (i = data(b), j = keys(i); j; j--) {
+			bucket = sector_to_bucket(b->c, PTR_OFFSET(node(i, j)));
+			g = &b->c->garbage[bucket];
+
+			if (g->mark && g->mark != -1) {
+				mark_bad(node(i, j));
+				g->mark = -2;
+				continue;
+			}
+
+			if (!(r = get_bucket(b, node(i, j), true, s)))
+				continue;
+
+			if (IS_ERR(r))
+				goto err;
+
+			k = btree_gc(r, node(i, j),
+				     j > 1 ? node(i, j - 1)->key : 0, s);
+
+			if (k < 0)
+				goto err;
+
+			ret = max_t(uint8_t, ret, k);
+			g->mark = -1;
+		}
+
+		btree_clean(b, 0);
+	} else
+		for_each_good_key(b, k) {
+			bucket = sector_to_bucket(b->c, PTR_OFFSET(k));
+			g = &b->c->garbage[bucket];
+
+			if (g->mark < 0) {
+				mark_bad(k);
+				g->mark = -2;
+			} else
+				g->mark += PTR_SIZE(k);
+		}
+
+	root->ptr = bucket_to_ptr(b);
+	btree_write(b, 0);
+
+	label(err,	ret = -1);
+	if (n) {
+		if (b->c->sb.btree_level == b->level)
+			set_new_root(b);
+
+		btree_free(n, true);
+		rw_unlock(true, n);
+	}
+	rw_unlock(true, b);
+	return ret;
+}
+
+static void do_btree_gc(struct work_struct *w)
+{
+	unsigned long start = jiffies;
+	long i, j, freed = 0;
+	struct key root;
+	struct cache *c = container_of(w, struct cache, work);
+	struct sched_param param = { .sched_priority = 5 };
+	struct search s, *sp = &s;
+	memset(&s, 0, sizeof(s));
+	s.flags |= SEARCH_BLOCK;
+
+	if (sched_setscheduler(get_current(), SCHED_FIFO, &param))
+		pr_debug("sched_setscheduler error");
+
+	param.sched_priority = 0;
+
+	i = run_on_root(true, btree_gc, &root, 0, &sp);
+	if (i < 0)
+		goto out;
+
+	spin_lock(&c->bucket_lock);
+	c->sectors_to_gc = c->sb.bucket_size * c->sb.nbuckets / 4;
+	c->garbage[sector_to_bucket(c, c->root->offset)].mark = -1;
+	c->need_gc = i;
+
+	for (i = 0; i < c->sb.nbuckets; i++) {
+		int m = c->garbage[i].mark;
+
+		if ((c->buckets[i].priority == (uint16_t) ~0) ^ (m == -1))
+			m = -2;
+
+		if (m > 0 && m < c->sb.bucket_size / 4)
+			m = 0;
+
+		if ((!m || m == -2) &&
+		    c->buckets[i].gen == c->buckets[i].last_gc) {
+			for (j = c->free.front;
+			     j != c->free.back;
+			     j = (j + 1) & c->free.size)
+				if (c->free.data[j] == i)
+					goto next;
+
+			c->buckets[i].priority = 0;
+			c->buckets[i].gen = c->buckets[i].last_gc + 1;
+			heap_insert(c, i);
+			freed++;
+		}
+next:
+		c->buckets[i].last_gc = c->garbage[i].gen;
+		c->need_gc = max_t(uint8_t, c->need_gc,
+				   c->buckets[i].gen -
+				   c->buckets[i].last_gc);
+	}
+
+	spin_unlock(&c->bucket_lock);
+	pr_debug("garbage collect done in %u ms, freed %li buckets, new need_gc %i",
+		 jiffies_to_msecs(jiffies - start), freed, c->need_gc);
+out:
+	if (sched_setscheduler_nocheck(get_current(), SCHED_NORMAL, &param))
+		pr_debug("sched_setscheduler error");
+	up(&c->gc_lock);
+}
+
+static void btree_insert_key(struct btree *b, struct key *i[], struct key *k)
+{
+	size_t m;
+	const char *s = "replacing";
+	char buf[30];
+	bool need_insert = fixup_old_keys(b, i, k, true) || PTR_OFFSET(k);
+
+	m = btree_bsearch(i, k->key);
+
+	if (!btree_merge_key(b, i, &m, k)) {
+		s = "inserting";
+		if (b->level)
+			k->ptr = TREE_PTR(inc_gen(b->c, PTR_OFFSET(k)),
+					  0, PTR_OFFSET(k));
+
+		if (need_insert)
+			shift_keys(i, m);
+	}
+
+	if (need_insert)
+		*node(i, m) = *k;
+
+	if (ptr_status(b, k, buf))
+		printk(KERN_DEBUG
+		       "%s bad key: level %i key %llu -> %llu len %i %s",
+		       s, b->level, KEY_OFFSET(k),
+		       PTR_OFFSET(k), PTR_SIZE(k), buf);
+#if 0
+	int oldsize = count_data(b);
+	oldsize -= count_data(b);
+	DUMP_KEY_BUG_ON(oldsize > 0, b, i, m,
+			"%s lost %i sectors: level %i key %llu -> %llu len %i\n"
+			"was %llu -> %llu len %i\n",
+			s, oldsize, b->level,
+			KEY_OFFSET(k), PTR_OFFSET(k), PTR_SIZE(k),
+			KEY_OFFSET(&old), PTR_OFFSET(&old), PTR_SIZE(&old));
+#endif
+	pr_debug("%s at %llu level %i page %i key %zu/%i: "
+		 "key %llu -> offset %llu len %i",
+		 s, (uint64_t) b->offset, b->level, index(i, b), m, keys(i),
+		 KEY_OFFSET(k), PTR_OFFSET(k), PTR_SIZE(k));
+
+	BUG_ON(index(i, b) < b->written);
+
+	check_key_order(b, i);
+	i = i;
+}
+
+static int btree_split(struct btree *b, struct key *keys, uint16_t *n)
+{
+	int j;
+	struct cache *c = b->c;
+	struct btree *n1, *n2 = NULL, *n3 = NULL;
+	bool root = (c->sb.btree_level == b->level);
+
+	if (!(n1 = btree_alloc(c, b->level, data(b), 0, 0, true)))
+		goto err;
+
+	for (j = 0; j < pages_per_bucket(b); j++)
+		memcpy(data(n1)[j], data(b)[j], PAGE_SIZE);
+
+	btree_clean(n1, 0);
+
+	if (keys(data(n1)) < keys_per_page * pages_per_bucket(b) / 2) {
+		pr_debug("not splitting: %i keys", keys(data(n1)));
+
+		while (*n)
+			btree_insert_key(n1, data(n1), &keys[--(*n)]);
+
+		if (root)
+			set_new_root(n1);
+	} else {
+		pr_debug("splitting at level %i of %i sector %llu nkeys %i",
+			 b->level, c->sb.btree_level,
+			 (uint64_t) b->offset, keys(data(n1)));
+
+		if (!(n2 = btree_alloc(c, b->level, data(n1), keys(data(n1)),
+				       keys(data(n1)) >> 1, true)))
+			goto err;
+
+		/* should allocate new root here for better error handling */
+
+		keys(data(n1)) -= keys(data(n1)) >> 1;
+
+		while (*n)
+			if (keys[--(*n)].key <= last_key(data(n1)))
+				btree_insert_key(n1, data(n1), &keys[*n]);
+			else
+				btree_insert_key(n2, data(n2), &keys[*n]);
+
+		keys[(*n)++] = bucket_key(n2);
+		btree_write(n2, 0);
+		rw_unlock(true, n2);
+	}
+
+	keys[(*n)++] = bucket_key(n1);
+
+	btree_write(n1, 0);
+	rw_unlock(true, n1);
+	n1 = NULL;
+
+	if (root && n2) {
+		if (!(n3 = btree_alloc(c, b->level + 1, NULL, 0, 0, false)))
+			goto err;
+
+		while (*n)
+			btree_insert_key(n3, data(n3), &keys[--(*n)]);
+		btree_write(n3, 0);
+
+		rw_unlock(true, n3);
+		set_new_root(n3);
+	}
+
+	btree_free(b, true);
+	return 0;
+err:
+	printk(KERN_WARNING "bcache: couldn't split");
+	if (n1) {
+		btree_free(n1, false);
+		rw_unlock(true, n1);
+	}
+	return -2;
+}
+
+static int btree_insert(struct btree *b, struct key *new_keys,
+			uint16_t *n, struct search *s)
+{
+	int sets = 0, ret = 0;
+	struct key **i;
+
+	while (*n) {
+		sets = 0;
+		for_each_sorted_set(i, b) {
+			if (keys(i))
+				sets++;
+
+			if (index(i, b) >= b->written)
+				break;
+		}
+
+		if (should_split(b, i)) {
+			if (s->lock < b->c->sb.btree_level) {
+				s->lock = b->c->sb.btree_level;
+				return -2;
+			}
+			return btree_split(b, new_keys, n);
+		}
+
+		if (rand(i) != rand(data(b))) {
+			rand(i) = rand(data(b));
+			keys(i) = 0;
+		}
+
+		while (*n && (keys(i) + 1) % keys_per_page)
+			btree_insert_key(b, i, &new_keys[--(*n)]);
+
+		btree_write(b, index(i, b));
+	}
+
+	if (sets > 2)
+		btree_clean(b, 0);
+
+	return ret;
+}
+
+#define insert_lock(_s, _l)	((_l) - max((_s)->level, (_s)->lock) <= 0)
+
+static int btree_insert_recurse(struct btree *b, struct key *new_keys,
+				uint16_t *n, struct search **s)
+{
+	int j, ret = 0;
+	struct btree *r;
+	bool write = insert_lock(*s, b->level), embiggening = false;
+
+	if (!rand(data(b))) {
+		printk(KERN_WARNING "bcache: btree was trashed, "
+		       "bucket %li, level %i, h->nkeys %i\n",
+		       sector_to_bucket(b->c, b->offset),
+		       b->level, keys(data(b)));
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
+	if (b->level > (*s)->level) {
+		uint64_t search = new_keys->key - PTR_SIZE(new_keys);
+		struct key **i, *k, recurse = { .key = 0, .ptr = 0 };
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
+			printk(KERN_WARNING "no key to recurse on trying to "
+					    "insert %llu at level %i of %i\n",
+			       new_keys->key, b->level, b->c->sb.btree_level);
+			goto trashed;
+		}
+
+		if (new_keys->key > recurse.key) {
+			if (should_split(b, data(b) + b->written))
+				if ((*s)->lock < b->c->sb.btree_level) {
+					(*s)->lock = b->c->sb.btree_level;
+					goto retry;
+				}
+
+			(*s)->lock = max((*s)->lock, b->level);
+			if (!write)
+				goto retry;
+
+			for_each_good_key_after(b, k, recurse.key)
+				if (k->key <= new_keys->key)
+					inc_gen(b->c, PTR_OFFSET(k));
+				else
+					break;
+
+			recurse.key = new_keys->key;
+			embiggening = true;
+		}
+
+		r = get_bucket(b, &recurse, insert_lock(*s, b->level - 1), s);
+		if (r == ERR_PTR(-EAGAIN))
+			goto again;
+		if (IS_ERR(r))
+			goto err;
+		if (!r)
+			goto retry;
+
+		ret = btree_insert_recurse(r, new_keys, n, s);
+
+		if (ret >= 0) {
+			new_keys[0].key = recurse.key;
+			if (!*n && embiggening)
+				new_keys[(*n)++] = recurse;
+		}
+	}
+
+	if (*n && ret >= 0) {
+		BUG_ON(!write);
+		(*s)->level = b->level;
+		ret = btree_insert(b, new_keys, n, *s);
+	}
+
+done:
+	label(err,   ret = -3);
+	label(retry, ret = -2);
+	label(again, ret = -1);
+	if (!IS_ERR_OR_NULL(b))
+		rw_unlock(write, b);
+	return ret;
+}
+
+static void btree_insert_async(struct search *s)
+{
+	struct cache *c = s->q;
+	int ret;
+
+	while (s->nkeylist) {
+		if (!s->nkeys) {
+			s->new_keys[0] = s->keylist[--s->nkeylist];
+			s->nkeys = 1;
+			s->level = 0;
+			s->lock  = 0;
+
+			s->bio->bi_sector = KEY_OFFSET(s->keylist);
+			s->bio->bi_size = PTR_SIZE(s->keylist) << 9;
+		}
+
+		ret = run_on_root(insert_lock(s, _b->level),
+				  btree_insert_recurse,
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
+static struct open_bucket *lookup_bucket(int *count, uint64_t key,
+					 struct task_struct *task)
+{
+	struct open_bucket *b, *r = NULL;
+
+	spin_lock(&open_bucket_lock);
+	list_for_each_entry(b, &open_buckets, list) {
+		if (count)
+			(*count)++;
+
+		if (b->key.key == key) {
+			r = b;
+			break;
+		} else if (b->last == task)
+			r = b;
+	}
+
+	return r;
+}
+
+static void add_open_bucket(struct open_bucket *b, int sectors,
+			    uint64_t key, struct task_struct *task)
+{
+	if (b->last != task)
+		b->task_nr_ios = b->task_io = 0;
+	if (b->key.key != key)
+		b->sequential = 0;
+
+	b->last		= task;
+	b->key.key	= key;
+
+	b->task_nr_ios++;
+	b->task_io     += sectors;
+	b->sequential  += sectors;
+	b->key.key     += TREE_KEY(0, sectors);
+
+	list_move(&b->list, &open_buckets);
+}
+
+static struct open_bucket *get_open_bucket(uint64_t key, struct task_struct *t)
+{
+	int i = 0;
+	struct open_bucket *b = lookup_bucket(&i, key, t);
+
+	if (!b && i < 8) {
+		spin_unlock(&open_bucket_lock);
+		if (!(b = kzalloc(sizeof(struct open_bucket), GFP_NOIO)))
+			return NULL;
+		spin_lock(&open_bucket_lock);
+
+		INIT_LIST_HEAD(&b->list);
+	} else if (!b)
+		b = list_entry(open_buckets.prev, struct open_bucket, list);
+
+	if (!b->cache ||
+	    b->gen != bucket(b->cache, b->offset)->gen) {
+		struct cache *c;
+		long bucket;
+
+		list_del_init(&b->list);
+
+		list_for_each_entry(c, &cache_devices, list)
+			if (!b->cache ||
+			    (b->cache->heap[0] && c->heap[0] &&
+			     b->cache->heap[0]->priority >
+			     c->heap[0]->priority))
+				b->cache = c;
+
+		/* slightly grotesque */
+		spin_unlock(&open_bucket_lock);
+		if (!b->cache)
+			goto err;
+
+		spin_lock(&b->cache->bucket_lock);
+		bucket = pop_bucket(b->cache, initial_priority);
+		spin_unlock(&b->cache->bucket_lock);
+
+		if (bucket == -1) {
+			b->cache = NULL;
+			goto err;
+		}
+
+		spin_lock(&open_bucket_lock);
+
+		b->offset	= bucket_to_sector(b->cache, bucket);
+		b->gen		= bucket(b->cache, b->offset)->gen;
+		b->sectors_free = b->cache->sb.bucket_size;
+	}
+
+	add_open_bucket(b, 0, key, t);
+	BUG_ON(!b->sectors_free);
+	return b;
+err:
+	kfree(b);
+	return NULL;
+}
+
+static void close_open_bucket(struct open_bucket *b, struct key *k, int split)
+{
+	BUG_ON(!split);
+
+	b->task_io     += split;
+	b->sequential  += split;
+	b->key.key     += TREE_KEY(0, split);
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
+		spin_lock(&b->cache->bucket_lock);
+		heap_insert(b->cache, sector_to_bucket(b->cache, b->offset));
+		b->cache->rescale -= b->cache->sb.bucket_size;
+		spin_unlock(&b->cache->bucket_lock);
+
+		b->cache = NULL;
+		list_move_tail(&b->list, &open_buckets);
+	}
+	spin_unlock(&open_bucket_lock);
+}
+
+static void bio_insert_endio(struct bio *bio, int error)
+{
+	struct search *s = bio->bi_private;
+	bio_put(bio);
+
+	if (error)
+		BUG();
+	else
+		return_f(s, btree_insert_async);
+}
+
+static const char *bio_insert(struct task_struct *task, struct bio *bio,
+			      bool write, struct search *s)
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
+		struct cache *c;
+		struct open_bucket *b;
+		struct key *k;
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
+				memcpy(s->keylist, s->new_keys,
+				       sizeof(*s->keylist) * 2);
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
+
+		if (write)
+			c->sectors_to_gc -= split;
+
+		if (c->sectors_to_gc < 0)
+			queue_gc(c);
+
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
+
+		if (c->rescale < 0)
+			rescale_heap(c, 0);
+	} while (n != bio);
+
+	ret = NULL;
+err:
+	return ret;
+}
+
+static void bio_complete(struct search *s)
+{
+	s->bio->bi_private = s->bi_private;
+	if (s->bi_end_io)
+		s->bi_end_io(s->bio, s->error);
+	pr_debug("completed %llu len %i",
+		 (uint64_t) s->bio->bi_sector, bio_sectors(s->bio));
+	return_f(s, NULL);
+}
+
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
+static void cache_miss(struct search *s)
+{
+	BUG_ON(s->error);
+	if (bio_insert(s->q, s->cache_bio, false, s))
+		bio_endio(s->cache_bio, -EIO);
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
+
+static void request_endio(struct bio *bio, int error)
+{
+	struct search *s = bio->bi_private;
+	s->error = error;
+	BUG_ON(error);
+	put_search(s);
+}
+
+static void __request_read(struct search *s)
+{
+	struct request_queue *q = s->q;
+	if (request_read(s->q, s->bio, s))
+		if (q->make_request_fn(q, s->bio))
+			generic_make_request(s->bio);
+}
+
+static int request_read(struct request_queue *q, struct bio *bio,
+			struct search *s)
+{
+	int ret = -1;
+	struct cache *c;
+	struct task_struct *task = get_current();
+	struct bio_list l = { .head = NULL, .tail = NULL };
+
+	pr_debug("searching for %i sectors at %llu",
+		 bio_sectors(bio), (uint64_t) bio->bi_sector);
+
+	list_for_each_entry(c, &cache_devices, list) {
+		int dev = lookup_dev(c, bio);
+		if (dev == UUIDS_PER_SB)
+			return_f(s, NULL, 1);
+
+		ret = max(ret, run_on_root(false, btree_search_recurse,
+					   dev, bio, &l, &s));
+
+		cache_hit(c, l.head);
+		bio_list_init(&l);
+
+		if (ret == 1)
+			return_f(s, NULL, 0);
+	}
+
+	if (!ret) {
+		s->q = q;
+		s->bio = bio;
+		return_f(s, __request_read, 0);
+	}
+#if 0
+	key = TREE_KEY(bio->bi_bdev->bd_cache_identifier, bio->bi_sector);
+	if ((b = lookup_bucket(NULL, key, task)) &&
+	    ((b->key.key == key &&
+	      b->sequential > sequential_cutoff >> 9) ||
+	     (b->last == task &&
+	      b->task_io * 2 / b->task_nr_ios > sequential_cutoff >> 9))) {
+		add_open_bucket(b, bio_sectors(bio), key, task);
+		sectors_bypassed += bio_sectors(bio);
+		spin_unlock(&open_bucket_lock);
+		return_f(s, NULL, ret != 1);
+	}
+	spin_unlock(&open_bucket_lock);
+
+	if (ret == 1)
+		return_f(s, NULL, 0);
+#endif
+	pr_debug("cache miss for %llu, starting write",
+		 (uint64_t) bio->bi_sector);
+	cache_misses++;
+
+	if (IS_ERR(s = alloc_search(s)) ||
+	    !(s->cache_bio = bio_kmalloc(GFP_NOIO, bio->bi_max_vecs)))
+		return_f(s, NULL, 1);
+
+	s->parent	= bio_complete_bounce;
+	s->end_fn	= cache_miss_bounce;
+	s->q		= task;
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+
+	bio->bi_end_io	= request_endio;
+	bio->bi_private = s;
+
+	__bio_clone(s->cache_bio, bio);
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
+	}
+#endif
+	s->parent	= bio_complete;
+	s->end_fn	= cache_miss;
+	return 1;
+}
+
+static void __request_write(struct work_struct *w)
+{
+	struct search *s = container_of(w, struct search, w);
+	const char *err;
+	PREPARE_WORK(&s->w, run_search);
+
+	err = bio_insert(s->q, s->cache_bio, true, s);
+	if (err) {
+		printk(KERN_WARNING "bcache: write error: %s\n", err);
+		/* XXX: write a null key or invalidate cache or fail write */
+
+		bio_endio(s->cache_bio, 0);
+		return_f(s, NULL);
+	}
+}
+
+static int request_write(struct request_queue *q, struct bio *bio)
+{
+	struct search *s;
+	const char *err = "couldn't allocate memory";
+
+	if (IS_ERR(s = alloc_search(NULL)))
+		goto err;
+
+	s->bio		= bio;
+	s->bi_end_io	= bio->bi_end_io;
+	s->bi_private	= bio->bi_private;
+	s->parent	= bio_complete;
+	s->q		= get_current();
+
+	if (!(s->cache_bio = bio_kmalloc(GFP_NOIO, bio->bi_max_vecs)))
+		goto err;
+
+	bio->bi_end_io  = request_endio;
+	bio->bi_private = s;
+
+	__bio_clone(s->cache_bio, bio);
+	atomic_inc(&s->remaining);
+
+	if (0) {
+		/* writeback caching */
+		err = bio_insert(s->q, s->cache_bio, true, s);
+	} else {
+		PREPARE_WORK(&s->w, __request_write);
+		queue_work(delayed, &s->w);
+		err = NULL;
+	}
+
+	if (err) {
+err:		printk(KERN_WARNING "bcache: write error: %s\n", err);
+		/* XXX: write a null key or invalidate cache or fail write */
+
+		if (!IS_ERR(s)) {
+			if (s->cache_bio)
+				bio_endio(s->cache_bio, 0);
+			put_search(s);
+		}
+	}
+	return 1;
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
+		return request_write(q, bio);
+	else
+		return request_read(q, bio, NULL);
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
+#define sysfs_hprint(file, val)						\
+	if (attr == &sysfs_ ## file) {					\
+		int ret = hprint(buffer, val);				\
+		strcat(buffer, "\n");					\
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
+read_attribute(bypassed);
+
+rw_attribute(cache_priority_initial);
+rw_attribute(cache_priority_hit);
+rw_attribute(cache_priority_seek);
+rw_attribute(sequential_cutoff);
+
+static struct dentry *debug;
+
+static int dump_tree(struct btree *b, struct seq_file *f, const char *tabs,
+		     uint64_t *prev, uint64_t *sectors, struct search *s)
+{
+	struct key *k;
+	char buf[30];
+	uint64_t last, biggest = 0;
+
+	seq_printf(f, "%spage  key: dev        key ->"
+		   "    offset  len gen bucket\n", tabs);
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
+		    last != k->key - PTR_SIZE(k))
+			seq_printf(f, "<hole>\n");
+		else if (b->level && !ptr_bad(b, k)) {
+			struct btree *r = get_bucket(b, k, false, &s);
+			if (!IS_ERR_OR_NULL(r))
+				dump_tree(r, f, tabs - 1, &last, sectors, s);
+		}
+
+		ptr_status(b, k, buf);
+		seq_printf(f,
+			   "%s%i %4i: %3i %10llu -> %9lli %4i %3i %6li %s\n",
+			   tabs, index(_i, b), _j, KEY_DEV(k),
+			   KEY_OFFSET(k), PTR_OFFSET(k),
+			   PTR_SIZE(k), PTR_GEN(k),
+			   sector_to_bucket(b->c, PTR_OFFSET(k)),
+			   buf);
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
+	struct search s;
+	memset(&s, 0, sizeof(s));
+	s.flags |= SEARCH_BLOCK;
+
+	run_on_root(false, dump_tree, f, &tabs[4], &last, &sectors, &s);
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
+static void load_priorities(struct cache *c, bool zero)
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
+static struct bio *save_priorities(struct cache *c)
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
+	struct cache *c;
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
+#if 0
+	if (!(d = kzalloc(sizeof(*d), GFP_KERNEL)))
+		goto err;
+
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
+		INIT_WORK(&c->work, unregister_cache_kobj);
+		schedule_work(&c->work);
+	}
+	return size;
+}
+
+static ssize_t show_cache(struct kobject *kobj, struct attribute *attr,
+			  char *buffer)
+{
+	struct cache *c = container_of(kobj, struct cache, kobj);
+	struct btree *b;
+
+	sysfs_hprint(bucket_size, c->sb.bucket_size << 9);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
+	sysfs_print(min_priority, "%u\n",
+		    c->heap[0] ? c->heap[0]->priority : 0);
+	sysfs_print(heap_size, "%zu\n", c->heap_size);
+	sysfs_hprint(written, c->sectors_written << 9);
+
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
+		b = list_entry(c->lru.prev, struct btree, lru);
+		return snprintf(buffer, PAGE_SIZE, "%li\n",
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
+static struct bio *write_super(struct cache *c)
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
+	struct cache *c = NULL;
+	struct search s, *sp = &s;
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
+#define SIZE(s)	(c->sb.nbuckets * sizeof(s))
+	err = "Insufficient memory";
+	if (!init_fifo(&c->free, c->sb.nbuckets >> 7, GFP_KERNEL) ||
+	    !(c->heap		= vmalloc(SIZE(struct bucket *))) ||
+	    !(c->buckets	= vmalloc(SIZE(struct bucket))) ||
+	    !(c->disk_buckets	= vmalloc(SIZE(struct bucket_disk))) ||
+	    !(c->garbage	= vmalloc(SIZE(struct bucket_gc))) ||
+	    !(c->sb_bio		= bio_kmalloc(GFP_KERNEL, 1)) ||
+	    !(c->priority_bio	= bio_kmalloc(GFP_KERNEL,
+					      pages(c, struct bucket_disk))))
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
+	spin_lock_init(&c->bucket_lock);
+	init_MUTEX(&c->gc_lock);
+
+	c->sectors_to_gc	= c->sb.bucket_size * c->sb.nbuckets / 4;
+	c->rescale		= c->sb.bucket_size * c->sb.nbuckets / 128;
+	c->btree_buckets_cached = 8;
+
+	load_priorities(c, !(c->sb.version & CACHE_CLEAN));
+
+	memset(&s, 0, sizeof(s));
+	s.flags = SEARCH_BLOCK;
+	if (c->sb.version & CACHE_CLEAN)
+		c->root = __get_bucket(c, c->sb.btree_root,
+				       c->sb.btree_level, true, &sp);
+	else
+		printk(KERN_NOTICE "bcache: Cache device %s was dirty, "
+				   "invalidating existing data", path);
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
+	BUG_ON(bucket(c, c->root->offset)->priority != (uint16_t) ~0);
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
+		__btree_write(b, b->offset);
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
+	sysfs_hprint(sequential_cutoff, sequential_cutoff);
+	sysfs_hprint(bypassed, sectors_bypassed << 9);
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
+	static const struct attribute *files[] = { &sysfs_register_cache,
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
+		NULL};
+
+	printk(KERN_DEBUG "bcache loading");
+
+	spin_lock_init(&open_bucket_lock);
+	init_waitqueue_head(&pending);
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
+}
+
+module_init(bcache_init);
+module_exit(bcache_exit);
-- 
1.7.0.4

