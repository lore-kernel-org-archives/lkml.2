Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2EJDLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:11:05 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55431 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2EJDKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:10:54 -0400
Date: Wed, 9 May 2012 23:10:48 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
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
 drivers/block/bcache/bcache.h |  839 +++++++++++++++
 drivers/block/bcache/btree.c  | 2249 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/bcache/btree.h  |  272 +++++
 3 files changed, 3360 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/bcache/bcache.h
 create mode 100644 drivers/block/bcache/btree.c
 create mode 100644 drivers/block/bcache/btree.h

diff --git a/drivers/block/bcache/bcache.h b/drivers/block/bcache/bcache.h
new file mode 100644
index 0000000..aad9c48
--- /dev/null
+++ b/drivers/block/bcache/bcache.h
@@ -0,0 +1,839 @@
+
+#define pr_fmt(fmt) "bcache: %s() " fmt "\n", __func__
+
+#include <linux/bio.h>
+#include <linux/blktrace_api.h>
+#include <linux/closure.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#include "util.h"
+
+struct bucket {
+	atomic_t	pin;
+	uint16_t	prio;
+	uint8_t		gen;
+	uint8_t		disk_gen;
+	uint8_t		last_gc; /* Most out of date gen in the btree */
+	uint8_t		gc_gen;
+
+#define GC_MARK_DIRTY	-1
+#define GC_MARK_BTREE	-2
+	short		mark;
+};
+
+struct bkey {
+	uint64_t	header;
+	uint64_t	key;
+	uint64_t	ptr[];
+};
+
+#define BKEY_PADDED(key)					\
+	union { struct bkey key; uint64_t key ## _pad[8]; }
+
+/* Version 1: Backing device
+ * Version 2: Seed pointer into btree node checksum
+ * Version 3: New UUID format
+ */
+#define BCACHE_SB_VERSION	3
+
+#define SB_SECTOR		8
+#define SB_SIZE			4096
+#define SB_LABEL_SIZE		32
+#define SB_JOURNAL_BUCKETS	256
+/* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
+#define MAX_CACHES_PER_SET	8
+
+struct cache_sb {
+	uint64_t		csum;
+	uint64_t		offset;	/* sector where this sb was written */
+	uint64_t		version;
+#define CACHE_BACKING_DEV	1
+
+	uint8_t			magic[16];
+
+	uint8_t			uuid[16];
+	union {
+		uint8_t		set_uuid[16];
+		uint64_t	set_magic;
+	};
+	uint8_t			label[SB_LABEL_SIZE];
+
+	uint64_t		flags;
+	uint64_t		seq;
+	uint64_t		pad[8];
+
+	uint64_t		nbuckets;	/* device size */
+	uint16_t		block_size;	/* sectors */
+	uint16_t		bucket_size;	/* sectors */
+
+	uint16_t		nr_in_set;
+	uint16_t		nr_this_dev;
+
+	uint32_t		last_mount;	/* time_t */
+
+	uint16_t		first_bucket;
+	union {
+		uint16_t	njournal_buckets;
+		uint16_t	keys;
+	};
+	uint64_t		d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+};
+
+BITMASK(CACHE_SYNC,		struct cache_sb, flags, 0, 1);
+BITMASK(CACHE_DISCARD,		struct cache_sb, flags, 1, 1);
+BITMASK(CACHE_REPLACEMENT,	struct cache_sb, flags, 2, 3);
+#define CACHE_REPLACEMENT_LRU	0U
+#define CACHE_REPLACEMENT_FIFO	1U
+#define CACHE_REPLACEMENT_RANDOM 2U
+
+BITMASK(BDEV_CACHE_MODE,	struct cache_sb, flags, 0, 4);
+#define CACHE_MODE_WRITETHROUGH	0U
+#define CACHE_MODE_WRITEBACK	1U
+#define CACHE_MODE_WRITEAROUND	2U
+#define CACHE_MODE_NONE		3U
+BITMASK(BDEV_STATE,		struct cache_sb, flags, 61, 2);
+#define BDEV_STATE_NONE		0U
+#define BDEV_STATE_CLEAN	1U
+#define BDEV_STATE_DIRTY	2U
+#define BDEV_STATE_STALE	3U
+
+/* Version 1: Seed pointer into btree node checksum
+ */
+#define BCACHE_BSET_VERSION	1
+
+/*
+ * This is the on disk format for btree nodes - a btree node on disk is a list
+ * of these; within each set the keys are sorted
+ */
+struct bset {
+	uint64_t		csum;
+	uint64_t		magic;
+	uint64_t		seq;
+	uint32_t		version;
+	uint32_t		keys;
+
+	union {
+		struct bkey	start[0];
+		uint64_t	d[0];
+	};
+};
+
+/*
+ * On disk format for priorities and gens - see super.c near prio_write() for
+ * more.
+ */
+struct prio_set {
+	uint64_t		csum;
+	uint64_t		magic;
+	uint64_t		seq;
+	uint32_t		version;
+	uint32_t		pad;
+
+	uint64_t		next_bucket;
+
+	struct bucket_disk {
+		uint16_t	prio;
+		uint8_t		gen;
+	} __attribute((packed)) data[];
+};
+
+#include "journal.h"
+#include "stats.h"
+struct search;
+struct btree;
+
+struct bcache_device {
+	struct closure		cl;
+
+	struct kobject		kobj;
+
+	struct cache_set	*c;
+	unsigned		id;
+#define BCACHEDEVNAME_SIZE	12
+	char			name[BCACHEDEVNAME_SIZE];
+
+	struct gendisk		*disk;
+
+	/* If nonzero, we're closing */
+	atomic_t		closing;
+
+	/* If nonzero, we're detaching/unregistering from cache set */
+	atomic_t		detaching;
+
+	atomic_long_t		sectors_dirty;
+	unsigned long		sectors_dirty_gc;
+	unsigned long		sectors_dirty_last;
+	long			sectors_dirty_derivative;
+
+	mempool_t		*unaligned_bvec;
+	struct bio_set		*bio_split;
+
+	unsigned		data_csum:1;
+
+	int (*cache_miss)(struct btree *, struct search *, struct bio *, unsigned);
+	int (*ioctl) (struct bcache_device *, fmode_t, unsigned, unsigned long);
+};
+
+struct io {
+	/* Used to track sequential IO so it can be skipped */
+	struct hlist_node	hash;
+	struct list_head	lru;
+
+	unsigned long		jiffies;
+	unsigned		sequential;
+	sector_t		last;
+};
+
+struct dirty_io {
+	struct closure		cl;
+	struct cached_dev	*d;
+	struct bio		bio;
+};
+
+struct dirty {
+	struct rb_node		node;
+	BKEY_PADDED(key);
+	struct dirty_io		*io;
+};
+
+struct cached_dev {
+	struct list_head	list;
+	struct bcache_device	disk;
+	struct block_device	*bdev;
+
+	struct cache_sb		sb;
+	struct bio		sb_bio;
+	struct bio_vec		sb_bv[1];
+	struct closure_with_waitlist sb_write;
+
+	/* Refcount on the cache set. Always nonzero when we're caching. */
+	atomic_t		count;
+	struct work_struct	detach;
+
+	/*
+	 * Device might not be running if it's dirty and the cache set hasn't
+	 * showed up yet.
+	 */
+	atomic_t		running;
+
+	mempool_t		*bio_passthrough;
+
+	/*
+	 * Writes take a shared lock from start to finish; scanning for dirty
+	 * data to refill the rb tree requires an exclusive lock.
+	 */
+	struct rw_semaphore	writeback_lock;
+
+	/*
+	 * Beginning and end of range in dirty rb tree - so that we can skip
+	 * taking dirty_lock and checking the rb tree. Protected by
+	 * writeback_lock.
+	 */
+	sector_t		writeback_start;
+	sector_t		writeback_end;
+
+	struct rb_root		dirty;
+	spinlock_t		dirty_lock;
+
+	/*
+	 * Nonzero, and writeback has a refcount (d->count), iff there is dirty
+	 * data in the cache. Protected by writeback_lock; must have an
+	 * shared lock to set and exclusive lock to clear.
+	 */
+	atomic_t		has_dirty;
+
+	uint64_t		next_writeback_io;
+	struct delayed_work	writeback_rate_update;
+
+	/*
+	 * Internal to the writeback code, so refill_dirty() and read_dirty()
+	 * can keep track of where they're at.
+	 */
+	sector_t		last_found;
+	sector_t		last_read;
+
+	/* Number of writeback bios in flight */
+	atomic_t		in_flight;
+	struct delayed_work	refill_dirty;
+	struct delayed_work	read_dirty;
+
+#define WRITEBACK_SLURP	100
+	DECLARE_ARRAY_ALLOCATOR(struct dirty, dirty_freelist, WRITEBACK_SLURP);
+
+	/* For tracking sequential IO */
+#define RECENT_IO_BITS	7
+#define RECENT_IO	(1 << RECENT_IO_BITS)
+	struct io		io[RECENT_IO];
+	struct hlist_head	io_hash[RECENT_IO + 1];
+	struct list_head	io_lru;
+	spinlock_t		io_lock;
+
+	struct cache_accounting	accounting;
+
+	/* The rest of this all shows up in sysfs */
+	unsigned		sequential_cutoff;
+	unsigned		readahead;
+
+	unsigned		sequential_merge:1;
+	unsigned		verify:1;
+
+	unsigned		writeback_metadata:1;
+	unsigned		writeback_running:1;
+	unsigned char		writeback_percent;
+	unsigned		writeback_delay;
+
+	unsigned		writeback_rate;
+	int			writeback_rate_change;
+	int64_t			writeback_rate_derivative;
+	uint64_t		writeback_rate_target;
+
+	unsigned		writeback_rate_update_seconds;
+	unsigned		writeback_rate_d_term;
+	unsigned		writeback_rate_p_term_inverse;
+	unsigned		writeback_rate_d_smooth;
+};
+
+struct cache {
+	struct cache_set	*set;
+	struct cache_sb		sb;
+	struct bio		sb_bio;
+	struct bio_vec		sb_bv[1];
+
+	struct kobject		kobj;
+	struct block_device	*bdev;
+
+	/* XXX: move to cache_set */
+	struct dentry		*debug;
+
+	/* XXX: replace with bios allocated from bio_meta mempool */
+	struct bio		*uuid_bio;
+
+	struct closure		prio;
+	/* XXX: replace with bios allocated from bio_meta mempool */
+	struct bio		*prio_bio;
+	struct prio_set		*disk_buckets;
+
+	/*
+	 * When allocating new buckets, prio_write() gets first dibs - since we
+	 * may not be allocate at all without writing priorities and gens.
+	 * prio_buckets[] contains the last buckets we wrote priorities to (so
+	 * gc can mark them as metadata), prio_next[] contains the buckets
+	 * allocated for the next prio write.
+	 */
+	uint64_t		*prio_buckets;
+	uint64_t		*prio_next;
+	unsigned		prio_write;
+	unsigned		prio_alloc;
+
+	/* > 0: buckets in free_inc have been marked as free
+	 * = 0: buckets in free_inc can't be used until priorities are written
+	 * < 0: priority write in progress
+	 */
+	atomic_t		prio_written;
+
+	/* Allocation stuff: */
+	struct bucket		*buckets;
+
+	DECLARE_HEAP(struct bucket *, heap);
+
+	/*
+	 * max(gen - disk_gen) for all buckets. When it gets too big we have to
+	 * call prio_write() to keep gens from wrapping.
+	 */
+	uint8_t			need_save_prio;
+
+	/*
+	 * If nonzero, we know we aren't going to find any buckets to invalidate
+	 * until a gc finishes - otherwise we could pointlessly burn a ton of
+	 * cpu
+	 */
+	unsigned		invalidate_needs_gc:1;
+
+	size_t			fifo_last_bucket;
+
+	DECLARE_FIFO(long, free);
+	DECLARE_FIFO(long, free_inc);
+	DECLARE_FIFO(long, unused);
+
+	bool			discard; /* Get rid of? */
+	struct list_head	discards;
+	struct page		*discard_page;
+
+	struct journal_device	journal;
+
+	/* The rest of this all shows up in sysfs */
+#define IO_ERROR_SHIFT		20
+	atomic_t		io_errors;
+	atomic_t		io_count;
+
+	atomic_long_t		meta_sectors_written;
+	atomic_long_t		btree_sectors_written;
+	atomic_long_t		sectors_written;
+};
+
+struct gc_stat {
+	size_t			nodes;
+	size_t			key_bytes;
+
+	size_t			nkeys;
+	uint64_t		data;	/* sectors */
+	uint64_t		dirty;	/* sectors */
+	unsigned		in_use; /* percent */
+};
+
+struct cache_set {
+	struct closure		cl;
+
+	struct list_head	list;
+	struct kobject		kobj;
+	struct kobject		internal;
+	struct cache_accounting accounting;
+
+	/*
+	 * If nonzero, we're trying to detach from all the devices we're
+	 * caching; otherwise we're merely closing
+	 */
+	atomic_t		unregistering;
+	atomic_t		closing;
+
+	struct cache_sb		sb;
+
+	struct cache		*cache[MAX_CACHES_PER_SET];
+	struct cache		*cache_by_alloc[MAX_CACHES_PER_SET];
+	int			caches_loaded;
+
+	struct bcache_device	**devices;
+	struct list_head	cached_devs;
+	uint64_t		cached_dev_sectors;
+	struct closure		caching;
+
+	struct closure_with_waitlist sb_write;
+
+	mempool_t		*search;
+	mempool_t		*bio_meta;
+	struct bio_set		*bio_split;
+
+	/* For the btree cache */
+	struct shrinker		shrink;
+
+	/* For the btree cache and anything allocation related */
+	struct mutex		bucket_lock;
+
+	/* log2(bucket_size), in sectors */
+	unsigned short		bucket_bits;
+
+	/* log2(block_size), in sectors */
+	unsigned short		block_bits;
+
+	/*
+	 * Default number of pages for a new btree node - may be less than a
+	 * full bucket
+	 */
+	unsigned		btree_pages;
+
+	/*
+	 * Lists of struct btrees; lru is the list for structs that have memory
+	 * allocated for actual btree node, freed is for structs that do not.
+	 */
+	struct list_head	btree_cache;
+	struct list_head	btree_cache_freeable;
+	struct list_head	btree_cache_freed;
+
+	/* Number of elements in btree_cache + btree_cache_freeable lists */
+	unsigned		bucket_cache_used;
+
+	/*
+	 * If we need to allocate memory for a new btree node and that
+	 * allocation fails, we can cannibalize another node in the btree cache
+	 * to satisfy the allocation. However, only one thread can be doing this
+	 * at a time, for obvious reasons - try_harder and try_wait are
+	 * basically a lock for this that we can wait on asynchronously. The
+	 * btree_root() macro releases the lock when it returns.
+	 */
+	struct closure		*try_harder;
+	closure_list_t		try_wait;
+	uint64_t		try_harder_start;
+
+	/*
+	 * When we free a btree node, we increment the gen of the bucket the
+	 * node is in - but we can't rewrite the prios and gens until we
+	 * finished whatever it is we were doing, otherwise after a crash the
+	 * btree node would be freed but for say a split, we might not have the
+	 * pointers to the new nodes inserted into the btree yet.
+	 *
+	 * This is a refcount that blocks prio_write() until the new keys are
+	 * written.
+	 */
+	atomic_t		prio_blocked;
+	closure_list_t		bucket_wait;
+
+	/*
+	 * For any bio we don't skip we subtract the number of sectors from
+	 * rescale; when it hits 0 we rescale all the bucket priorities.
+	 */
+	atomic_t		rescale;
+	/*
+	 * When we invalidate buckets, we use both the priority and the amount
+	 * of good data to determine which buckets to reuse first - to weight
+	 * those together consistently we keep track of the smallest nonzero
+	 * priority of any bucket.
+	 */
+	uint16_t		min_prio;
+
+	/*
+	 * max(gen - gc_gen) for all buckets. When it gets too big we have to gc
+	 * to keep gens from wrapping around.
+	 */
+	uint8_t			need_gc;
+	struct gc_stat		gc_stats;
+	size_t			nbuckets;
+
+	struct closure_with_waitlist gc;
+	/* Where in the btree gc currently is */
+	struct bkey		gc_done;
+
+	/*
+	 * The allocation code needs gc_mark in struct bucket to be correct, but
+	 * it's not while a gc is in progress. Protected by bucket_lock.
+	 */
+	int			gc_mark_valid;
+
+	/* Counts how many sectors bio_insert has added to the cache */
+	atomic_t		sectors_to_gc;
+
+	struct btree		*root;
+
+#ifdef CONFIG_BCACHE_DEBUG
+	struct btree		*verify_data;
+	struct mutex		verify_lock;
+#endif
+
+	unsigned		nr_uuids;
+	struct uuid_entry	*uuids;
+	BKEY_PADDED(uuid_bucket);
+	struct closure_with_waitlist uuid_write;
+
+	/*
+	 * A btree node on disk could have too many bsets for an iterator to fit
+	 * on the stack - this is a single element mempool for btree_read_work()
+	 */
+	struct mutex		fill_lock;
+	struct btree_iter	*fill_iter;
+
+	/*
+	 * btree_sort() is a merge sort and requires temporary space - single
+	 * element mempool
+	 */
+	struct mutex		sort_lock;
+	struct bset		*sort;
+
+	/* List of buckets we're currently writing data to */
+	struct list_head	data_buckets;
+	spinlock_t		data_bucket_lock;
+
+	struct journal		journal;
+
+#define CONGESTED_MAX		1024
+	unsigned		congested_last_us;
+	atomic_t		congested;
+
+	/* The rest of this all shows up in sysfs */
+	unsigned		congested_read_threshold_us;
+	unsigned		congested_write_threshold_us;
+
+	spinlock_t		sort_time_lock;
+	struct time_stats	sort_time;
+	struct time_stats	btree_gc_time;
+	struct time_stats	btree_split_time;
+	spinlock_t		btree_read_time_lock;
+	struct time_stats	btree_read_time;
+	struct time_stats	try_harder_time;
+
+	atomic_long_t		cache_read_races;
+	atomic_long_t		writeback_keys_done;
+	atomic_long_t		writeback_keys_failed;
+	unsigned		error_limit;
+	unsigned		error_decay;
+	unsigned short		journal_delay_ms;
+	unsigned		verify:1;
+	unsigned		key_merging_disabled:1;
+	unsigned		gc_always_rewrite:1;
+	unsigned		shrinker_disabled:1;
+
+#define BUCKET_HASH_BITS	12
+	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
+};
+
+static inline bool key_merging_disabled(struct cache_set *c)
+{
+#ifdef CONFIG_BCACHE_DEBUG
+	return c->key_merging_disabled;
+#else
+	return 0;
+#endif
+}
+
+struct bbio {
+	unsigned		submit_time_us;
+	union {
+		struct bkey	key;
+		uint64_t	_pad[3];
+	};
+	struct bio		bio;
+};
+
+static inline unsigned local_clock_us(void)
+{
+	return local_clock() >> 10;
+}
+
+#define MAX_BSETS		4
+
+#define btree_prio		USHRT_MAX
+#define initial_prio		32768
+
+#define btree_bytes(c)		((c)->btree_pages * PAGE_SIZE)
+#define btree_blocks(b)							\
+	((unsigned) (KEY_SIZE(&b->key) >> (b)->c->block_bits))
+
+#define btree_default_blocks(c)						\
+	((unsigned) ((PAGE_SECTORS * (c)->btree_pages) >> (c)->block_bits))
+
+#define bucket_pages(c)		((c)->sb.bucket_size / PAGE_SECTORS)
+#define bucket_bytes(c)		((c)->sb.bucket_size << 9)
+#define block_bytes(c)		((c)->sb.block_size << 9)
+
+#define __set_bytes(i, k)	(sizeof(*(i)) + (k) * sizeof(uint64_t))
+#define set_bytes(i)		__set_bytes(i, i->keys)
+
+#define __set_blocks(i, k, c)	DIV_ROUND_UP(__set_bytes(i, k), block_bytes(c))
+#define set_blocks(i, c)	__set_blocks(i, (i)->keys, c)
+
+#define node(i, j)		((struct bkey *) ((i)->d + (j)))
+#define end(i)			node(i, (i)->keys)
+
+#define index(i, b)							\
+	((size_t) (((void *) i - (void *) (b)->sets[0].data) /		\
+		   block_bytes(b->c)))
+
+#define btree_data_space(b)	(PAGE_SIZE << (b)->page_order)
+
+#define prios_per_bucket(c)				\
+	((bucket_bytes(c) - sizeof(struct prio_set)) /	\
+	 sizeof(struct bucket_disk))
+#define prio_buckets(c)					\
+	DIV_ROUND_UP((size_t) (c)->sb.nbuckets, prios_per_bucket(c))
+
+#define JSET_MAGIC		0x245235c1a3625032
+#define PSET_MAGIC		0x6750e15f87337f91
+#define BSET_MAGIC		0x90135c78b99e07f5
+
+#define jset_magic(c)		((c)->sb.set_magic ^ JSET_MAGIC)
+#define pset_magic(c)		((c)->sb.set_magic ^ PSET_MAGIC)
+#define bset_magic(c)		((c)->sb.set_magic ^ BSET_MAGIC)
+
+/* Bkey fields: all units are in sectors */
+
+#define KEY_FIELD(name, field, offset, size)				\
+	BITMASK(name, struct bkey, field, offset, size)
+
+#define PTR_FIELD(name, offset, size)					\
+	static inline uint64_t name(const struct bkey *k, unsigned i)	\
+	{ return (k->ptr[i] >> offset) & ~(((uint64_t) ~0) << size); }	\
+									\
+	static inline void SET_##name(struct bkey *k, unsigned i, uint64_t v)\
+	{								\
+		k->ptr[i] &= ~(~((uint64_t) ~0 << size) << offset);	\
+		k->ptr[i] |= v << offset;				\
+	}
+
+KEY_FIELD(KEY_PTRS,	header, 60, 3)
+KEY_FIELD(HEADER_SIZE,	header, 58, 2)
+KEY_FIELD(KEY_CSUM,	header, 56, 2)
+KEY_FIELD(KEY_PINNED,	header, 55, 1)
+KEY_FIELD(KEY_DIRTY,	header, 36, 1)
+
+KEY_FIELD(KEY_SIZE,	header, 20, 16)
+KEY_FIELD(KEY_DEV,	header, 0,  20)
+
+KEY_FIELD(KEY_SECTOR,	key,	16, 47)
+KEY_FIELD(KEY_SNAPSHOT,	key,	0,  16)
+
+PTR_FIELD(PTR_DEV,		51, 12)
+PTR_FIELD(PTR_OFFSET,		8,  43)
+PTR_FIELD(PTR_GEN,		0,  8)
+
+#define PTR_CHECK_DEV		((1 << 12) - 1)
+
+#define PTR(gen, offset, dev)						\
+	((((uint64_t) dev) << 51) | ((uint64_t) offset) << 8 | gen)
+
+#define sector_to_bucket(c, s)	((long) ((s) >> (c)->bucket_bits))
+#define bucket_to_sector(c, b)	(((sector_t) (b)) << (c)->bucket_bits)
+#define bucket_remainder(c, b)	((b) & ((c)->sb.bucket_size - 1))
+
+#define PTR_CACHE(c, k, n)	((c)->cache[PTR_DEV(k, n)])
+#define PTR_BUCKET_NR(c, k, n)	sector_to_bucket(c, PTR_OFFSET(k, n))
+
+#define PTR_BUCKET(c, k, n)						\
+	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))
+
+/* Btree key macros */
+
+#define KEY_HEADER(len, dev)						\
+	(((uint64_t) 1 << 63) | ((uint64_t) (len) << 20) | (dev))
+
+#define KEY(dev, sector, len)	(struct bkey)				\
+	{ .header = KEY_HEADER(len, dev), .key = (sector) }
+
+#define KEY_START(k)		((k)->key - KEY_SIZE(k))
+#define START_KEY(k)		KEY(KEY_DEV(k), KEY_START(k), 0)
+#define MAX_KEY			KEY(~(~0 << 20), ((uint64_t) ~0) >> 1, 0)
+#define ZERO_KEY		KEY(0, 0, 0)
+
+#define csum_set(i)							\
+	crc64(((void *) (i)) + 8, ((void *) end(i)) - (((void *) (i)) + 8))
+
+/* Error handling macros */
+
+#define btree_bug(b, ...)						\
+	({ if (cache_set_error((b)->c, __VA_ARGS__)) dump_stack(); })
+
+#define cache_bug(c, ...)						\
+	({ if (cache_set_error(c, __VA_ARGS__)) dump_stack(); })
+
+#define btree_bug_on(cond, b, ...)					\
+	({ if (cond) btree_bug(b, __VA_ARGS__); })
+
+#define cache_bug_on(cond, c, ...)					\
+	({ if (cond) cache_bug(c, __VA_ARGS__); })
+
+#define cache_set_err_on(cond, c, ...)					\
+	({ if (cond) cache_set_error(c, __VA_ARGS__); })
+
+/* Looping macros */
+
+#define for_each_cache(ca, cs)						\
+	for (int _i = 0; ca = cs->cache[_i], _i < (cs)->sb.nr_in_set; _i++)
+
+#define for_each_bucket(b, ca)						\
+	for (b = (ca)->buckets + (ca)->sb.first_bucket;			\
+	     b < (ca)->buckets + (ca)->sb.nbuckets; b++)
+
+static inline void __bkey_put(struct cache_set *c, struct bkey *k)
+{
+	for (unsigned i = 0; i < KEY_PTRS(k); i++)
+		atomic_dec_bug(&PTR_BUCKET(c, k, i)->pin);
+}
+
+/* Blktrace macros */
+
+#define blktrace_msg(c, fmt, ...)					\
+do {									\
+	struct request_queue *q = bdev_get_queue(c->bdev);		\
+	if (q)								\
+		blk_add_trace_msg(q, fmt, ##__VA_ARGS__);		\
+} while (0)
+
+#define blktrace_msg_all(s, fmt, ...)					\
+do {									\
+	struct cache *_c;						\
+	for_each_cache(_c, (s))						\
+		blktrace_msg(_c, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define err_printk(...)	printk(KERN_ERR "bcache: " __VA_ARGS__)
+
+static inline void cached_dev_put(struct cached_dev *d)
+{
+	if (atomic_dec_and_test(&d->count))
+		schedule_work(&d->detach);
+}
+
+static inline bool cached_dev_get(struct cached_dev *d)
+{
+	if (!atomic_inc_not_zero(&d->count))
+		return false;
+
+	smp_mb__after_atomic_inc();
+	return true;
+}
+
+#define bucket_gc_gen(b)	((uint8_t) ((b)->gen - (b)->last_gc))
+#define bucket_disk_gen(b)	((uint8_t) ((b)->gen - (b)->disk_gen))
+
+#define kobj_attribute_write(n, fn)					\
+	static struct kobj_attribute ksysfs_##n = __ATTR(n, S_IWUSR, NULL, fn)
+
+#define kobj_attribute_rw(n, show, store)				\
+	static struct kobj_attribute ksysfs_##n =			\
+		__ATTR(n, S_IWUSR|S_IRUSR, show, store)
+
+#define bio_split_get(bio, len, c)					\
+	__bio_split_get(bio, len, (c)->bio_split)
+
+/* Forward declarations */
+
+bool bcache_in_writeback(struct cached_dev *, sector_t, unsigned);
+void bcache_writeback_queue(struct cached_dev *);
+void bcache_writeback_add(struct cached_dev *, unsigned);
+
+void count_io_errors(struct cache *, int, const char *);
+void bcache_endio(struct cache_set *, struct bio *, int, const char *);
+void bbio_free(struct bio *, struct cache_set *);
+struct bio *bbio_alloc(struct cache_set *);
+struct bio *bbio_kmalloc(gfp_t, int);
+struct bio *__bio_split_get(struct bio *, int, struct bio_set *);
+
+void __submit_bbio(struct bio *, struct cache_set *);
+void submit_bbio(struct bio *, struct cache_set *, struct bkey *, unsigned);
+int submit_bbio_split(struct bio *, struct cache_set *,
+		      struct bkey *, unsigned);
+
+void cache_read_endio(struct bio *, int);
+
+struct bcache_cgroup;
+struct cgroup;
+struct bcache_cgroup *cgroup_to_bcache(struct cgroup *cgroup);
+struct bcache_cgroup *bio_to_cgroup(struct bio *bio);
+
+uint8_t inc_gen(struct cache *, struct bucket *);
+void rescale_priorities(struct cache_set *, int);
+bool bucket_add_unused(struct cache *, struct bucket *);
+bool can_save_prios(struct cache *);
+void free_some_buckets(struct cache *);
+void unpop_bucket(struct cache_set *, struct bkey *);
+int __pop_bucket_set(struct cache_set *, uint16_t,
+		     struct bkey *, int, struct closure *);
+int pop_bucket_set(struct cache_set *, uint16_t,
+		   struct bkey *, int, struct closure *);
+
+bool cache_set_error(struct cache_set *, const char *, ...);
+
+void prio_write(struct cache *);
+void write_bdev_super(struct cached_dev *, struct closure *);
+
+extern struct workqueue_struct *bcache_wq;
+extern const char * const bcache_cache_modes[];
+
+struct cache_set *cache_set_alloc(struct cache_sb *);
+void free_discards(struct cache *);
+int alloc_discards(struct cache *);
+void bcache_btree_cache_free(struct cache_set *);
+int bcache_btree_cache_alloc(struct cache_set *);
+void bcache_writeback_init_cached_dev(struct cached_dev *);
+
+void bcache_debug_exit(void);
+int bcache_debug_init(struct kobject *);
+void bcache_writeback_exit(void);
+int bcache_writeback_init(void);
+void bcache_request_exit(void);
+int bcache_request_init(void);
+void bcache_btree_exit(void);
+int bcache_btree_init(void);
diff --git a/drivers/block/bcache/btree.c b/drivers/block/bcache/btree.c
new file mode 100644
index 0000000..7e9975f
--- /dev/null
+++ b/drivers/block/bcache/btree.c
@@ -0,0 +1,2249 @@
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
+#include "bcache.h"
+#include "btree.h"
+#include "debug.h"
+#include "request.h"
+
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/hash.h>
+#include <linux/random.h>
+#include <linux/rcupdate.h>
+#include <trace/events/bcache.h>
+
+/*
+ * Todo:
+ * register_bcache: Return errors out to userspace correctly
+ *
+ * Writeback: don't undirty key until after a cache flush
+ *
+ * Create an iterator for key pointers
+ *
+ * On btree write error, mark bucket such that it won't be freed from the cache
+ *
+ * Journalling:
+ *   Check for bad keys in replay
+ *   Propagate barriers
+ *   Refcount journal entries in journal_replay
+ *
+ * Garbage collection:
+ *   Finish incremental gc
+ *   Gc should free old UUIDs, data for invalid UUIDs
+ *
+ * Provide a way to list backing device UUIDs we have data cached for, and
+ * probably how long it's been since we've seen them, and a way to invalidate
+ * dirty data for devices that will never be attached again
+ *
+ * Keep 1 min/5 min/15 min statistics of how busy a block device has been, so
+ * that based on that and how much dirty data we have we can keep writeback
+ * from being starved
+ *
+ * Add a tracepoint or somesuch to watch for writeback starvation
+ *
+ * When btree depth > 1 and splitting an interior node, we have to make sure
+ * alloc_bucket() cannot fail. This should be true but is not completely
+ * obvious.
+ *
+ * Make sure all allocations get charged to the root cgroup
+ *
+ * Plugging?
+ *
+ * If data write is less than hard sector size of ssd, round up offset in open
+ * bucket to the next whole sector
+ *
+ * Also lookup by cgroup in get_open_bucket()
+ *
+ * Superblock needs to be fleshed out for multiple cache devices
+ *
+ * Add a sysfs tunable for the number of writeback IOs in flight
+ *
+ * Add a sysfs tunable for the number of open data buckets
+ *
+ * IO tracking: Can we track when one process is doing io on behalf of another?
+ * IO tracking: Don't use just an average, weigh more recent stuff higher
+ *
+ * Test module load/unload
+ */
+
+static const char * const op_types[] = {
+	"insert", "replace"
+};
+
+static const char *op_type(struct btree_op *op)
+{
+	return op_types[op->type];
+}
+
+#define MAX_NEED_GC		64
+#define MAX_SAVE_PRIO		72
+
+#define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
+
+#define PTR_HASH(c, k)							\
+	(((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
+
+static struct workqueue_struct *btree_wq;
+
+void btree_op_init_stack(struct btree_op *op)
+{
+	memset(op, 0, sizeof(struct btree_op));
+	closure_init_stack(&op->cl);
+	op->lock = -1;
+	keylist_init(&op->keys);
+}
+
+/* Btree key manipulation */
+
+static void bkey_put(struct cache_set *c, struct bkey *k, int level)
+{
+	if ((level && k->key) || !level)
+		__bkey_put(c, k);
+}
+
+/* Btree IO */
+
+static uint64_t btree_csum_set(struct btree *b, struct bset *i)
+{
+	uint64_t crc = b->key.ptr[0];
+	void *data = (void *) i + 8, *end = end(i);
+
+	crc = crc64_update(crc, data, end - data);
+	return crc ^ 0xffffffffffffffff;
+}
+
+static void btree_bio_endio(struct bio *bio, int error)
+{
+	struct btree *b = container_of(bio->bi_private, struct btree, io.cl);
+
+	if (error)
+		set_btree_node_io_error(b);
+
+	bcache_endio(b->c, bio, error, (bio->bi_rw & WRITE)
+		     ? "writing btree" : "reading btree");
+}
+
+static void btree_bio_init(struct btree *b)
+{
+	BUG_ON(b->bio);
+	b->bio = bbio_alloc(b->c);
+
+	bio_get(b->bio);
+	b->bio->bi_end_io	= btree_bio_endio;
+	b->bio->bi_private	= &b->io.cl;
+}
+
+void btree_read_done(struct closure *cl)
+{
+	struct btree *b = container_of(cl, struct btree, io.cl);
+	struct bset *i = b->sets[0].data;
+	struct btree_iter *iter = b->c->fill_iter;
+	const char *err = "bad btree header";
+	BUG_ON(b->nsets || b->written);
+
+	bbio_free(b->bio, b->c);
+	b->bio = NULL;
+
+	mutex_lock(&b->c->fill_lock);
+	iter->used = 0;
+
+	if (btree_node_io_error(b) ||
+	    !i->seq)
+		goto err;
+
+	for (;
+	     b->written < btree_blocks(b) && i->seq == b->sets[0].data->seq;
+	     i = write_block(b)) {
+		err = "unsupported bset version";
+		if (i->version > BCACHE_BSET_VERSION)
+			goto err;
+
+		err = "bad btree header";
+		if (b->written + set_blocks(i, b->c) > btree_blocks(b))
+			goto err;
+
+		err = "bad magic";
+		if (i->magic != bset_magic(b->c))
+			goto err;
+
+		err = "bad checksum";
+		switch (i->version) {
+		case 0:
+			if (i->csum != csum_set(i))
+				goto err;
+			break;
+		case BCACHE_BSET_VERSION:
+			if (i->csum != btree_csum_set(b, i))
+				goto err;
+			break;
+		}
+
+		err = "empty set";
+		if (i != b->sets[0].data && !i->keys)
+			goto err;
+
+		btree_iter_push(iter, i->start, end(i));
+
+		b->written += set_blocks(i, b->c);
+	}
+
+	err = "corrupted btree";
+	for (i = write_block(b);
+	     index(i, b) < btree_blocks(b);
+	     i = ((void *) i) + block_bytes(b->c))
+		if (i->seq == b->sets[0].data->seq)
+			goto err;
+
+	btree_sort_and_fix_extents(b, iter);
+
+	i = b->sets[0].data;
+	err = "short btree key";
+	if (b->sets[0].size &&
+	    bkey_cmp(&b->key, &b->sets[0].end) < 0)
+		goto err;
+
+	if (b->written < btree_blocks(b))
+		bset_init_next(b);
+
+	if (0) {
+err:		set_btree_node_io_error(b);
+		cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
+				err, PTR_BUCKET_NR(b->c, &b->key, 0),
+				index(i, b), i->keys);
+	}
+
+	mutex_unlock(&b->c->fill_lock);
+
+	spin_lock(&b->c->btree_read_time_lock);
+	time_stats_update(&b->c->btree_read_time, b->io_start_time);
+	spin_unlock(&b->c->btree_read_time_lock);
+
+	smp_wmb(); /* read_done is our write lock */
+	set_btree_node_read_done(b);
+
+	closure_return(cl);
+}
+
+static void btree_read_resubmit(struct closure *cl)
+{
+	struct btree *b = container_of(cl, struct btree, io.cl);
+
+	submit_bbio_split(b->bio, b->c, &b->key, 0);
+	continue_at(&b->io.cl, btree_read_done, system_wq);
+}
+
+void btree_read(struct btree *b)
+{
+	BUG_ON(b->nsets || b->written);
+
+	if (!closure_trylock(&b->io.cl, &b->c->cl))
+		BUG();
+
+	b->io_start_time = local_clock();
+
+	btree_bio_init(b);
+	b->bio->bi_rw	= REQ_META|READ_SYNC;
+	b->bio->bi_size	= KEY_SIZE(&b->key) << 9;
+
+	bio_map(b->bio, b->sets[0].data);
+
+	pr_debug("%s", pbtree(b));
+	trace_bcache_btree_read(b->bio);
+
+	if (submit_bbio_split(b->bio, b->c, &b->key, 0))
+		continue_at(&b->io.cl, btree_read_resubmit, system_wq);
+
+	continue_at(&b->io.cl, btree_read_done, system_wq);
+}
+
+static void btree_complete_write(struct btree *b, struct btree_write *w)
+{
+	if (w->prio_blocked &&
+	    !atomic_sub_return(w->prio_blocked, &b->c->prio_blocked))
+		closure_wake_up(&b->c->bucket_wait);
+
+	if (w->journal) {
+		atomic_dec_bug(w->journal);
+		__closure_wake_up(&b->c->journal.wait);
+	}
+
+	if (w->owner)
+		closure_put(w->owner);
+
+	w->prio_blocked	= 0;
+	w->journal	= NULL;
+	w->owner	= NULL;
+}
+
+static void __btree_write_done(struct closure *cl)
+{
+	struct btree *b = container_of(cl, struct btree, io.cl);
+	struct btree_write *w = btree_prev_write(b);
+
+	bbio_free(b->bio, b->c);
+	b->bio = NULL;
+	btree_complete_write(b, w);
+
+	if (btree_node_dirty(b))
+		queue_delayed_work(btree_wq, &b->work,
+				   msecs_to_jiffies(30000));
+
+	closure_return(cl);
+}
+
+static void btree_write_done(struct closure *cl)
+{
+	struct btree *b = container_of(cl, struct btree, io.cl);
+	struct bio_vec *bv;
+	int n;
+
+	__bio_for_each_segment(bv, b->bio, n, 0)
+		__free_page(bv->bv_page);
+
+	__btree_write_done(cl);
+}
+
+static void do_btree_write(struct btree *b)
+{
+	struct closure *cl = &b->io.cl;
+	struct bset *i = b->sets[b->nsets].data;
+	BKEY_PADDED(key) k;
+
+	i->version	= BCACHE_BSET_VERSION;
+	i->csum		= btree_csum_set(b, i);
+
+	btree_bio_init(b);
+	b->bio->bi_rw	= REQ_META|WRITE_SYNC;
+	b->bio->bi_size	= set_blocks(i, b->c) * block_bytes(b->c);
+	bio_map(b->bio, i);
+
+	bkey_copy(&k.key, &b->key);
+	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) + bset_offset(b, i));
+
+	if (!bio_alloc_pages(b->bio, GFP_NOIO)) {
+		int j;
+		struct bio_vec *bv;
+		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
+
+		bio_for_each_segment(bv, b->bio, j)
+			memcpy(page_address(bv->bv_page),
+			       base + j * PAGE_SIZE, PAGE_SIZE);
+
+		trace_bcache_btree_write(b->bio);
+		submit_bbio_split(b->bio, b->c, &k.key, 0);
+
+		continue_at(cl, btree_write_done, NULL);
+	} else {
+		bio_map(b->bio, i);
+
+		trace_bcache_btree_write(b->bio);
+		submit_bbio_split(b->bio, b->c, &k.key, 0);
+
+		closure_sync(cl);
+		__btree_write_done(cl);
+	}
+}
+
+static void __btree_write(struct btree *b)
+{
+	struct bset *i = b->sets[b->nsets].data;
+
+	BUG_ON(current->bio_list);
+
+	closure_lock(&b->io, &b->c->cl);
+	__cancel_delayed_work(&b->work);
+
+	clear_bit(BTREE_NODE_dirty,	 &b->flags);
+	change_bit(BTREE_NODE_write_idx, &b->flags);
+
+	check_key_order(b, i);
+	BUG_ON(b->written && !i->keys);
+
+	do_btree_write(b);
+
+	pr_debug("%s block %i keys %i", pbtree(b), b->written, i->keys);
+
+	b->written += set_blocks(i, b->c);
+	atomic_long_add(set_blocks(i, b->c) * b->c->sb.block_size,
+			&PTR_CACHE(b->c, &b->key, 0)->btree_sectors_written);
+
+	btree_sort_lazy(b);
+
+	if (b->written < btree_blocks(b))
+		bset_init_next(b);
+}
+
+static void btree_write_work(struct work_struct *w)
+{
+	struct btree *b = container_of(to_delayed_work(w), struct btree, work);
+
+	down_write(&b->lock);
+
+	if (btree_node_dirty(b))
+		__btree_write(b);
+	up_write(&b->lock);
+}
+
+void btree_write(struct btree *b, bool now, struct btree_op *op)
+{
+	struct bset *i = b->sets[b->nsets].data;
+	struct btree_write *w = btree_current_write(b);
+
+	BUG_ON(b->written &&
+	       (b->written >= btree_blocks(b) ||
+		i->seq != b->sets[0].data->seq ||
+		!i->keys));
+
+	if (!btree_node_dirty(b)) {
+		set_btree_node_dirty(b);
+		queue_delayed_work(btree_wq, &b->work,
+				   msecs_to_jiffies(30000));
+	}
+
+	w->prio_blocked += b->prio_blocked;
+	b->prio_blocked = 0;
+
+	if (op && op->journal && !b->level) {
+		if (w->journal &&
+		    journal_pin_cmp(b->c, w, op)) {
+			atomic_dec_bug(w->journal);
+			w->journal = NULL;
+		}
+
+		if (!w->journal) {
+			w->journal = op->journal;
+			atomic_inc(w->journal);
+		}
+	}
+
+	if (current->bio_list)
+		return;
+
+	/* Force write if set is too big */
+	if (now ||
+	    b->level ||
+	    set_bytes(i) > PAGE_SIZE - 48) {
+		if (op && now) {
+			/* Must wait on multiple writes */
+			BUG_ON(w->owner);
+			w->owner = &op->cl;
+			closure_get(&op->cl);
+		}
+
+		__btree_write(b);
+	}
+	BUG_ON(!b->written);
+}
+
+/*
+ * Btree in memory cache - allocation/freeing
+ * mca -> memory cache
+ */
+
+#define mca_reserve(c)	((c->root ? c->root->level : 1) * 8 + 16)
+#define mca_can_free(c)						\
+	max_t(int, 0, c->bucket_cache_used - mca_reserve(c))
+
+static void mca_data_free(struct btree *b)
+{
+	struct bset_tree *t = b->sets;
+	BUG_ON(!closure_is_unlocked(&b->io.cl));
+
+	if (bset_prev_bytes(b) < PAGE_SIZE)
+		kfree(t->prev);
+	else
+		free_pages((unsigned long) t->prev,
+			   get_order(bset_prev_bytes(b)));
+
+	if (bset_tree_bytes(b) < PAGE_SIZE)
+		kfree(t->tree);
+	else
+		free_pages((unsigned long) t->tree,
+			   get_order(bset_tree_bytes(b)));
+
+	free_pages((unsigned long) t->data, b->page_order);
+
+	t->prev = NULL;
+	t->tree = NULL;
+	t->data = NULL;
+	list_move(&b->list, &b->c->btree_cache_freed);
+	b->c->bucket_cache_used--;
+}
+
+static void mca_bucket_free(struct btree *b)
+{
+	BUG_ON(btree_node_dirty(b));
+
+	b->key.ptr[0] = 0;
+	hlist_del_init_rcu(&b->hash);
+	list_move(&b->list, &b->c->btree_cache_freeable);
+}
+
+static void mca_data_alloc(struct btree *b, struct bkey *k, gfp_t gfp)
+{
+	struct bset_tree *t = b->sets;
+	BUG_ON(t->data);
+
+	b->page_order = ilog2(max_t(unsigned, b->c->btree_pages,
+				    KEY_SIZE(k) / PAGE_SECTORS ?: 1));
+
+	t->data = (void *) __get_free_pages(gfp, b->page_order);
+	if (!t->data)
+		goto err;
+
+	t->tree = bset_tree_bytes(b) < PAGE_SIZE
+		? kmalloc(bset_tree_bytes(b), gfp)
+		: (void *) __get_free_pages(gfp, get_order(bset_tree_bytes(b)));
+	if (!t->tree)
+		goto err;
+
+	t->prev = bset_prev_bytes(b) < PAGE_SIZE
+		? kmalloc(bset_prev_bytes(b), gfp)
+		: (void *) __get_free_pages(gfp, get_order(bset_prev_bytes(b)));
+	if (!t->prev)
+		goto err;
+
+	list_move(&b->list, &b->c->btree_cache);
+	b->c->bucket_cache_used++;
+	return;
+err:
+	mca_data_free(b);
+}
+
+static struct btree *mca_bucket_alloc(struct cache_set *c,
+				      struct bkey *k, gfp_t gfp)
+{
+	struct btree *b = kzalloc(sizeof(struct btree), gfp);
+	if (!b)
+		return NULL;
+
+	init_rwsem(&b->lock);
+	INIT_LIST_HEAD(&b->list);
+	INIT_DELAYED_WORK(&b->work, btree_write_work);
+	b->c = c;
+	closure_init_unlocked(&b->io);
+
+	mca_data_alloc(b, k, gfp);
+	return b->sets[0].data ? b : NULL;
+}
+
+static int mca_reap(struct btree *b, struct closure *cl)
+{
+	lockdep_assert_held(&b->c->bucket_lock);
+
+	if (!down_write_trylock(&b->lock))
+		return -1;
+
+	BUG_ON(btree_node_dirty(b) && !b->sets[0].data);
+
+	if (cl && btree_node_dirty(b))
+		btree_write(b, true, NULL);
+
+	if (cl)
+		closure_wait_event_async(&b->io.wait, cl,
+			 atomic_read(&b->io.cl.remaining) == -1);
+
+	if (btree_node_dirty(b) ||
+	    atomic_read(&b->io.cl.remaining) != -1 ||
+	    work_pending(&b->work.work)) {
+		rw_unlock(true, b);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static int bcache_shrink_buckets(struct shrinker *shrink,
+				 struct shrink_control *sc)
+{
+	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
+	struct btree *b, *t;
+	unsigned i;
+	int nr, orig_nr = sc->nr_to_scan;
+
+	if (c->shrinker_disabled)
+		return 0;
+
+	/*
+	 * If nr == 0, we're supposed to return the number of items we have
+	 * cached. Not allowed to return -1.
+	 */
+	if (!orig_nr)
+		goto out;
+
+	/* Return -1 if we can't do anything right now */
+	if (!mutex_trylock(&c->bucket_lock))
+		return -1;
+
+	if (c->try_harder) {
+		mutex_unlock(&c->bucket_lock);
+		return -1;
+	}
+
+	if (list_empty(&c->btree_cache)) {
+		/*
+		 * Can happen right when we first start up, before we've read in
+		 * any btree nodes
+		 */
+		mutex_unlock(&c->bucket_lock);
+		return 0;
+	}
+
+	orig_nr /= c->btree_pages;
+	nr = orig_nr = min_t(int, orig_nr, mca_can_free(c));
+
+	i = 0;
+	list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
+		if (!nr)
+			break;
+
+		if (++i > 3 &&
+		    !mca_reap(b, NULL)) {
+			mca_data_free(b);
+			rw_unlock(true, b);
+			--nr;
+		}
+	}
+
+	for (i = c->bucket_cache_used;
+	     i && nr;
+	     --i) {
+		b = list_first_entry(&c->btree_cache, struct btree, list);
+		list_rotate_left(&c->btree_cache);
+
+		if (!b->accessed &&
+		    !mca_reap(b, NULL)) {
+			mca_bucket_free(b);
+			mca_data_free(b);
+			rw_unlock(true, b);
+			--nr;
+		} else
+			b->accessed = 0;
+	}
+
+	mutex_unlock(&c->bucket_lock);
+out:
+	return mca_can_free(c) * c->btree_pages;
+}
+
+void bcache_btree_cache_free(struct cache_set *c)
+{
+	struct btree *b;
+	struct closure cl;
+	closure_init_stack(&cl);
+
+	if (c->shrink.list.next)
+		unregister_shrinker(&c->shrink);
+
+	mutex_lock(&c->bucket_lock);
+
+#ifdef CONFIG_BCACHE_DEBUG
+	if (c->verify_data)
+		list_move(&c->verify_data->list, &c->btree_cache);
+#endif
+
+	list_splice(&c->btree_cache_freeable,
+		    &c->btree_cache);
+
+	while (!list_empty(&c->btree_cache)) {
+		b = list_first_entry(&c->btree_cache, struct btree, list);
+
+		if (btree_node_dirty(b))
+			btree_complete_write(b, btree_current_write(b));
+		clear_bit(BTREE_NODE_dirty, &b->flags);
+
+		mca_data_free(b);
+	}
+
+	while (!list_empty(&c->btree_cache_freed)) {
+		b = list_first_entry(&c->btree_cache_freed,
+				     struct btree, list);
+		list_del(&b->list);
+		cancel_delayed_work_sync(&b->work);
+		kfree(b);
+	}
+
+	mutex_unlock(&c->bucket_lock);
+}
+
+int bcache_btree_cache_alloc(struct cache_set *c)
+{
+	/* XXX: doesn't check for errors */
+
+	closure_init_unlocked(&c->gc);
+
+	for (int i = 0; i < mca_reserve(c); i++)
+		mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL);
+
+	list_splice_init(&c->btree_cache,
+			 &c->btree_cache_freeable);
+
+#ifdef CONFIG_BCACHE_DEBUG
+	mutex_init(&c->verify_lock);
+
+	c->verify_data = mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL);
+
+	if (c->verify_data &&
+	    c->verify_data->sets[0].data)
+		list_del_init(&c->verify_data->list);
+	else
+		c->verify_data = NULL;
+#endif
+
+	c->shrink.shrink = bcache_shrink_buckets;
+	c->shrink.seeks = 3;
+	register_shrinker(&c->shrink);
+
+	return 0;
+}
+
+/* Btree in memory cache - hash table */
+
+static struct hlist_head *hash_bucket(struct cache_set *c, struct bkey *k)
+{
+	return &c->bucket_hash[hash_32(PTR_HASH(c, k), BUCKET_HASH_BITS)];
+}
+
+static struct btree *find_bucket(struct cache_set *c, struct bkey *k)
+{
+	struct hlist_node *cursor;
+	struct btree *b;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(b, cursor, hash_bucket(c, k), hash)
+		if (PTR_HASH(c, &b->key) == PTR_HASH(c, k))
+			goto out;
+	b = NULL;
+out:
+	rcu_read_unlock();
+	return b;
+}
+
+static struct btree *alloc_bucket(struct cache_set *c, struct bkey *k,
+				  int level, struct closure *cl)
+{
+	struct btree *b, *i;
+	unsigned page_order = ilog2(KEY_SIZE(k) / PAGE_SECTORS ?: 1);
+
+	lockdep_assert_held(&c->bucket_lock);
+retry:
+	if (find_bucket(c, k))
+		return NULL;
+
+	/* btree_free() doesn't free memory; it sticks the node on the end of
+	 * the list. Check if there's any freed nodes there:
+	 */
+	list_for_each_entry(b, &c->btree_cache_freeable, list)
+		if (page_order <= b->page_order &&
+		    !b->key.ptr[0] &&
+		    !mca_reap(b, NULL))
+			goto out;
+
+	/* We never free struct btree itself, just the memory that holds the on
+	 * disk node. Check the freed list before allocating a new one:
+	 */
+	list_for_each_entry(b, &c->btree_cache_freed, list)
+		if (!mca_reap(b, NULL)) {
+			mca_data_alloc(b, k, __GFP_NOWARN|GFP_NOIO);
+			if (!b->sets[0].data) {
+				rw_unlock(true, b);
+				goto err;
+			} else
+				goto out;
+		}
+
+	b = mca_bucket_alloc(c, k, __GFP_NOWARN|GFP_NOIO);
+	if (!b)
+		goto err;
+
+	BUG_ON(!down_write_trylock(&b->lock));
+out:
+	BUG_ON(!closure_is_unlocked(&b->io.cl));
+
+	bkey_copy(&b->key, k);
+	list_move(&b->list, &c->btree_cache);
+	hlist_del_init_rcu(&b->hash);
+	hlist_add_head_rcu(&b->hash, hash_bucket(c, k));
+	lock_set_subclass(&b->lock.dep_map, level + 1, _THIS_IP_);
+
+	b->flags	= 0;
+	b->level	= level;
+	b->written	= 0;
+	b->nsets	= 0;
+	for (int i = 0; i < MAX_BSETS; i++)
+		b->sets[i].size = 0;
+	for (int i = 1; i < MAX_BSETS; i++)
+		b->sets[i].data = NULL;
+
+	return b;
+err:
+	if (current->bio_list)
+		return ERR_PTR(-EAGAIN);
+
+	if (!cl)
+		return ERR_PTR(-ENOMEM);
+
+	if (c->try_harder && c->try_harder != cl) {
+		closure_wait_event_async(&c->try_wait, cl, !c->try_harder);
+		return ERR_PTR(-EAGAIN);
+	}
+
+	/* XXX: tracepoint */
+	c->try_harder = cl;
+	c->try_harder_start = local_clock();
+	b = ERR_PTR(-ENOMEM);
+
+	list_for_each_entry_reverse(i, &c->btree_cache, list)
+		if (page_order <= i->page_order) {
+			int e = mca_reap(i, cl);
+			if (e == -EAGAIN)
+				b = ERR_PTR(-EAGAIN);
+			if (!e) {
+				b = i;
+				goto out;
+			}
+		}
+
+	if (b == ERR_PTR(-EAGAIN) &&
+	    closure_blocking(cl)) {
+		mutex_unlock(&c->bucket_lock);
+		closure_sync(cl);
+		mutex_lock(&c->bucket_lock);
+		goto retry;
+	}
+
+	return b;
+}
+
+struct btree *get_bucket(struct cache_set *c, struct bkey *k,
+			 int level, struct btree_op *op)
+{
+	int i = 0;
+	bool write = level <= op->lock;
+	struct btree *b;
+
+	BUG_ON(level < 0);
+retry:
+	b = find_bucket(c, k);
+
+	if (!b) {
+		mutex_lock(&c->bucket_lock);
+		b = alloc_bucket(c, k, level, &op->cl);
+		mutex_unlock(&c->bucket_lock);
+
+		if (!b)
+			goto retry;
+		if (IS_ERR(b))
+			return b;
+
+		btree_read(b);
+
+		if (!write)
+			downgrade_write(&b->lock);
+	} else {
+		rw_lock(write, b, level);
+		if (PTR_HASH(c, &b->key) != PTR_HASH(c, k)) {
+			rw_unlock(write, b);
+			goto retry;
+		}
+		BUG_ON(b->level != level);
+	}
+
+	b->accessed = 1;
+
+	for (; i <= b->nsets && b->sets[i].size; i++) {
+		prefetch(b->sets[i].tree);
+		prefetch(b->sets[i].data);
+	}
+
+	for (; i <= b->nsets; i++)
+		prefetch(b->sets[i].data);
+
+	if (!closure_wait_event(&b->io.wait, &op->cl,
+				btree_node_read_done(b))) {
+		rw_unlock(write, b);
+		b = ERR_PTR(-EAGAIN);
+	} else if (btree_node_io_error(b)) {
+		rw_unlock(write, b);
+		b = ERR_PTR(-EIO);
+	} else
+		BUG_ON(!b->written);
+
+	return b;
+}
+
+static void prefetch_bucket(struct cache_set *c, struct bkey *k, int level)
+{
+	struct btree *b;
+
+	mutex_lock(&c->bucket_lock);
+	b = alloc_bucket(c, k, level, NULL);
+	mutex_unlock(&c->bucket_lock);
+
+	if (!IS_ERR_OR_NULL(b)) {
+		btree_read(b);
+		rw_unlock(true, b);
+	}
+}
+
+/* Btree alloc */
+
+static void btree_free(struct btree *b, struct btree_op *op)
+{
+	/* The BUG_ON() in get_bucket() implies that we must have a write lock
+	 * on parent to free or even invalidate a node
+	 */
+	BUG_ON(op->lock <= b->level);
+	BUG_ON(b == b->c->root);
+	pr_debug("bucket %s", pbtree(b));
+
+	if (btree_node_dirty(b))
+		btree_complete_write(b, btree_current_write(b));
+	clear_bit(BTREE_NODE_dirty, &b->flags);
+
+	if (b->prio_blocked &&
+	    !atomic_sub_return(b->prio_blocked, &b->c->prio_blocked))
+		closure_wake_up(&b->c->bucket_wait);
+
+	b->prio_blocked = 0;
+
+	__cancel_delayed_work(&b->work);
+
+	mutex_lock(&b->c->bucket_lock);
+
+	for (unsigned i = 0; i < KEY_PTRS(&b->key); i++) {
+		BUG_ON(atomic_read(&PTR_BUCKET(b->c, &b->key, i)->pin));
+
+		inc_gen(PTR_CACHE(b->c, &b->key, i),
+			PTR_BUCKET(b->c, &b->key, i));
+	}
+
+	unpop_bucket(b->c, &b->key);
+	mca_bucket_free(b);
+	mutex_unlock(&b->c->bucket_lock);
+}
+
+struct btree *bcache_btree_alloc(struct cache_set *c, int level,
+				 struct closure *cl)
+{
+	BKEY_PADDED(key) k;
+	struct btree *b = ERR_PTR(-EAGAIN);
+
+	mutex_lock(&c->bucket_lock);
+retry:
+	if (__pop_bucket_set(c, btree_prio, &k.key, 1, cl))
+		goto err;
+
+	SET_KEY_SIZE(&k.key, c->btree_pages * PAGE_SECTORS);
+
+	b = alloc_bucket(c, &k.key, level, cl);
+	if (IS_ERR(b))
+		goto err_free;
+
+	if (!b) {
+		cache_bug(c, "Tried to allocate bucket"
+			  " that was in btree cache");
+		__bkey_put(c, &k.key);
+		goto retry;
+	}
+
+	set_btree_node_read_done(b);
+	b->accessed = 1;
+	bset_init_next(b);
+
+	mutex_unlock(&c->bucket_lock);
+	return b;
+err_free:
+	unpop_bucket(c, &k.key);
+	__bkey_put(c, &k.key);
+err:
+	mutex_unlock(&c->bucket_lock);
+	return b;
+}
+
+static struct btree *btree_alloc_replacement(struct btree *b,
+					     struct closure *cl)
+{
+	struct btree *n = bcache_btree_alloc(b->c, b->level, cl);
+	if (!IS_ERR_OR_NULL(n))
+		btree_sort_into(b, n);
+
+	return n;
+}
+
+/* Garbage collection */
+
+void __btree_mark_key(struct cache_set *c, int level, struct bkey *k)
+{
+	struct bucket *g;
+
+	if (!k->key || !KEY_SIZE(k))
+		return;
+
+	for (unsigned i = 0; i < KEY_PTRS(k); i++) {
+		if (!ptr_available(c, k, i))
+			continue;
+
+		g = PTR_BUCKET(c, k, i);
+
+		if (gen_after(g->gc_gen, PTR_GEN(k, i)))
+			g->gc_gen = PTR_GEN(k, i);
+
+		if (ptr_stale(c, k, i))
+			continue;
+
+		cache_bug_on(level
+			     ? g->mark && g->mark != GC_MARK_BTREE
+			     : g->mark < GC_MARK_DIRTY, c,
+			     "inconsistent pointers: mark = %i, "
+			     "level = %i", g->mark, level);
+
+		if (level)
+			g->mark = GC_MARK_BTREE;
+		else if (KEY_DIRTY(k))
+			g->mark = GC_MARK_DIRTY;
+		else if (g->mark >= 0 &&
+			 ((int) g->mark) + KEY_SIZE(k) < SHRT_MAX)
+			g->mark += KEY_SIZE(k);
+	}
+}
+
+#define btree_mark_key(b, k)	__btree_mark_key(b->c, b->level, k)
+
+static int btree_gc_mark(struct btree *b, unsigned *keys, struct gc_stat *gc)
+{
+	uint8_t stale = 0;
+	unsigned last_dev = -1;
+	struct bcache_device *d = NULL;
+
+	struct btree_iter iter;
+	btree_iter_init(b, &iter, NULL);
+
+	gc->nodes++;
+
+	while (1) {
+		struct bkey *k = btree_iter_next(&iter);
+		if (!k)
+			break;
+
+		if (last_dev != KEY_DEV(k)) {
+			last_dev = KEY_DEV(k);
+
+			d = b->c->devices[last_dev];
+		}
+
+		if (ptr_invalid(b, k))
+			continue;
+
+		for (unsigned i = 0; i < KEY_PTRS(k); i++) {
+			if (!ptr_available(b->c, k, i))
+				continue;
+
+			stale = max(stale, ptr_stale(b->c, k, i));
+
+			btree_bug_on(gen_after(PTR_BUCKET(b->c, k, i)->last_gc,
+					       PTR_GEN(k, i)),
+				     b, "found old gen %u > %u in gc: %s",
+				     PTR_BUCKET(b->c, k, i)->last_gc,
+				     PTR_GEN(k, i), pkey(k));
+		}
+
+		btree_mark_key(b, k);
+
+		if (ptr_bad(b, k))
+			continue;
+
+		*keys += bkey_u64s(k);
+
+		gc->key_bytes += bkey_u64s(k);
+		gc->nkeys++;
+
+		gc->data += KEY_SIZE(k);
+		if (KEY_DIRTY(k)) {
+			gc->dirty += KEY_SIZE(k);
+			if (d)
+				d->sectors_dirty_gc += KEY_SIZE(k);
+		}
+	}
+
+	for (struct bset_tree *t = b->sets; t <= &b->sets[b->nsets]; t++)
+		btree_bug_on(t->size &&
+			     bset_written(b, t) &&
+			     bkey_cmp(&b->key, &t->end) < 0,
+			     b, "found short btree key in gc");
+
+	return stale;
+}
+
+static struct btree *btree_gc_alloc(struct btree *b, struct bkey *k,
+				    struct btree_op *op)
+{
+	/*
+	 * We block priorities from being written for the duration of garbage
+	 * collection, so we can't sleep in btree_alloc() -> pop_bucket(), or
+	 * we'd risk deadlock - so we don't pass it our closure.
+	 */
+	struct btree *n = btree_alloc_replacement(b, NULL);
+
+	if (!IS_ERR_OR_NULL(n)) {
+		swap(b, n);
+
+		memcpy(k->ptr, b->key.ptr,
+		       sizeof(uint64_t) * KEY_PTRS(&b->key));
+
+		__bkey_put(b->c, &b->key);
+		atomic_inc(&b->c->prio_blocked);
+		b->prio_blocked++;
+
+		btree_free(n, op);
+		__up_write(&n->lock);
+
+		rwsem_release(&b->lock.dep_map, 1, _THIS_IP_);
+	}
+
+	return b;
+}
+
+/*
+ * Leaving this at 2 until we've got incremental garbage collection done; it
+ * could be higher (and has been tested with 4) except that garbage collection
+ * could take much longer, adversely affecting latency.
+ */
+#define GC_MERGE_NODES	2
+
+struct gc_merge_info {
+	struct btree	*b;
+	struct bkey	*k;
+	unsigned	keys;
+};
+
+static void btree_gc_coalesce(struct btree *b, struct btree_op *op,
+			      struct gc_stat *gc, struct gc_merge_info *r)
+{
+	unsigned nodes = 0, keys = 0, blocks;
+
+	while (nodes < GC_MERGE_NODES && r[nodes].b)
+		keys += r[nodes++].keys;
+
+	blocks = btree_default_blocks(b->c) * 2 / 3;
+
+	if (nodes < 2 ||
+	    __set_blocks(b->sets[0].data, keys, b->c) > blocks * (nodes - 1))
+		return;
+
+	for (int i = nodes - 1; i >= 0; --i) {
+		if (r[i].b->written)
+			r[i].b = btree_gc_alloc(r[i].b, r[i].k, op);
+
+		if (r[i].b->written)
+			return;
+	}
+
+	for (int i = nodes - 1; i > 0; --i) {
+		struct bset *n1 = r[i].b->sets->data;
+		struct bset *n2 = r[i - 1].b->sets->data;
+		struct bkey *last = NULL;
+
+		keys = 0;
+
+		if (i == 1) {
+			/*
+			 * Last node we're not getting rid of - we're getting
+			 * rid of the node at r[0]. Have to try and fit all of
+			 * the remaining keys into this node; we can't ensure
+			 * they will always fit due to rounding and variable
+			 * length keys (shouldn't be possible in practice,
+			 * though)
+			 */
+			if (__set_blocks(n1, n1->keys + r->keys,
+					 b->c) > btree_blocks(r[i].b))
+				return;
+
+			keys = n2->keys;
+			last = &r->b->key;
+		} else
+			for (struct bkey *k = n2->start;
+			     k < end(n2);
+			     k = next(k)) {
+				if (__set_blocks(n1, n1->keys + keys +
+						 bkey_u64s(k), b->c) > blocks)
+					break;
+
+				last = k;
+				keys += bkey_u64s(k);
+			}
+
+		BUG_ON(__set_blocks(n1, n1->keys + keys,
+				    b->c) > btree_blocks(r[i].b));
+
+		if (last) {
+			bkey_copy_key(&r[i].b->key, last);
+			bkey_copy_key(r[i].k, last);
+		}
+
+		memcpy(end(n1),
+		       n2->start,
+		       (void *) node(n2, keys) - (void *) n2->start);
+
+		n1->keys += keys;
+
+		memmove(n2->start,
+			node(n2, keys),
+			(void *) end(n2) - (void *) node(n2, keys));
+
+		n2->keys -= keys;
+
+		r[i].keys	= n1->keys;
+		r[i - 1].keys	= n2->keys;
+	}
+
+	btree_free(r->b, op);
+	__up_write(&r->b->lock);
+
+	pr_debug("coalesced %u nodes", nodes);
+
+	gc->nodes--;
+	nodes--;
+
+	memmove(&r[0], &r[1], sizeof(struct gc_merge_info) * nodes);
+	memset(&r[nodes], 0, sizeof(struct gc_merge_info));
+}
+
+static int btree_gc_recurse(struct btree *b, struct btree_op *op,
+			    struct closure *writes, struct gc_stat *gc)
+{
+	void write(struct btree *r)
+	{
+		if (!r->written)
+			btree_write(r, true, op);
+		else if (btree_node_dirty(r)) {
+			BUG_ON(btree_current_write(r)->owner);
+			btree_current_write(r)->owner = writes;
+			closure_get(writes);
+
+			btree_write(r, true, NULL);
+		}
+
+		__up_write(&r->lock);
+	}
+
+	int ret = 0, stale;
+	struct gc_merge_info r[GC_MERGE_NODES];
+
+	memset(r, 0, sizeof(r));
+
+	while ((r->k = next_recurse_key(b, &b->c->gc_done))) {
+		r->b = get_bucket(b->c, r->k, b->level - 1, op);
+
+		if (IS_ERR(r->b)) {
+			ret = PTR_ERR(r->b);
+			break;
+		}
+
+		/*
+		 * Fake out lockdep, because I'm a terrible person: it's just
+		 * not possible to express our lock ordering to lockdep, because
+		 * lockdep works at most in terms of a small fixed number of
+		 * subclasses, and we're just iterating through all of them in a
+		 * fixed order.
+		 */
+		rwsem_release(&r->b->lock.dep_map, 1, _THIS_IP_);
+
+		r->keys	= 0;
+		stale = btree_gc_mark(r->b, &r->keys, gc);
+
+		if (!b->written &&
+		    (r->b->level || stale > 10 ||
+		     b->c->gc_always_rewrite))
+			r->b = btree_gc_alloc(r->b, r->k, op);
+
+		if (r->b->level)
+			ret = btree_gc_recurse(r->b, op, writes, gc);
+
+		if (ret) {
+			write(r->b);
+			break;
+		}
+
+		bkey_copy_key(&b->c->gc_done, r->k);
+
+		if (!b->written)
+			btree_gc_coalesce(b, op, gc, r);
+
+		if (r[GC_MERGE_NODES - 1].b)
+			write(r[GC_MERGE_NODES - 1].b);
+
+		memmove(&r[1], &r[0],
+			sizeof(struct gc_merge_info) * (GC_MERGE_NODES - 1));
+
+		/* When we've got incremental GC working, we'll want to do
+		 * if (should_resched())
+		 *	return -EAGAIN;
+		 */
+		cond_resched();
+#if 0
+		if (need_resched()) {
+			ret = -EAGAIN;
+			break;
+		}
+#endif
+	}
+
+	for (unsigned i = 1; i < GC_MERGE_NODES && r[i].b; i++)
+		write(r[i].b);
+
+	/* Might have freed some children, must remove their keys */
+	if (!b->written)
+		btree_sort(b);
+
+	return ret;
+}
+
+static int btree_gc_root(struct btree *b, struct btree_op *op,
+			 struct closure *writes, struct gc_stat *gc)
+{
+	struct btree *n = NULL;
+	unsigned keys = 0;
+	int ret = 0, stale = btree_gc_mark(b, &keys, gc);
+
+	if (b->level || stale > 10)
+		n = btree_alloc_replacement(b, NULL);
+
+	if (!IS_ERR_OR_NULL(n))
+		swap(b, n);
+
+	if (b->level)
+		ret = btree_gc_recurse(b, op, writes, gc);
+
+	if (!b->written || btree_node_dirty(b)) {
+		atomic_inc(&b->c->prio_blocked);
+		b->prio_blocked++;
+		btree_write(b, true, n ? op : NULL);
+	}
+
+	if (!IS_ERR_OR_NULL(n)) {
+		closure_sync(&op->cl);
+		bcache_btree_set_root(b);
+		btree_free(n, op);
+		rw_unlock(true, b);
+	}
+
+	return ret;
+}
+
+size_t btree_gc_finish(struct cache_set *c)
+{
+	void mark_key(struct bkey *k)
+	{
+		for (unsigned i = 0; i < KEY_PTRS(k); i++)
+			PTR_BUCKET(c, k, i)->mark = GC_MARK_BTREE;
+	}
+
+	size_t available = 0;
+	struct bucket *b;
+	struct cache *ca;
+	uint64_t *i;
+
+	mutex_lock(&c->bucket_lock);
+
+	set_gc_sectors(c);
+	c->gc_mark_valid = 1;
+	c->need_gc	= 0;
+	c->min_prio	= initial_prio;
+
+	if (c->root)
+		mark_key(&c->root->key);
+
+	mark_key(&c->uuid_bucket);
+
+	for_each_cache(ca, c) {
+		ca->invalidate_needs_gc = 0;
+
+		for (i = ca->sb.d; i < ca->sb.d + ca->sb.keys; i++)
+			ca->buckets[*i].mark = GC_MARK_BTREE;
+
+		for (i = ca->prio_buckets;
+		     i < ca->prio_buckets + prio_buckets(ca) * 2; i++)
+			ca->buckets[*i].mark = GC_MARK_BTREE;
+
+		for_each_bucket(b, ca) {
+			/*
+			 * the c->journal.cur check is a hack because when we're
+			 * called from run_cache_set() gc_gen isn't going to be
+			 * correct
+			 */
+			cache_bug_on(c->journal.cur &&
+				     gen_after(b->last_gc, b->gc_gen), c,
+				     "found old gen in gc");
+
+			b->last_gc	= b->gc_gen;
+			b->gc_gen	= b->gen;
+			c->need_gc	= max(c->need_gc, bucket_gc_gen(b));
+
+			if (!atomic_read(&b->pin) &&
+			    b->mark >= 0) {
+				available++;
+				if (!b->mark)
+					bucket_add_unused(ca, b);
+			}
+
+			if (b->prio)
+				c->min_prio = min(c->min_prio, b->prio);
+		}
+	}
+
+	for (struct bcache_device **d = c->devices;
+	     d < c->devices + c->nr_uuids;
+	     d++)
+		if (*d) {
+			unsigned long last =
+				atomic_long_read(&((*d)->sectors_dirty));
+			long difference = (*d)->sectors_dirty_gc - last;
+
+			pr_debug("sectors dirty off by %li", difference);
+
+			(*d)->sectors_dirty_last += difference;
+
+			atomic_long_set(&((*d)->sectors_dirty),
+					(*d)->sectors_dirty_gc);
+		}
+
+	mutex_unlock(&c->bucket_lock);
+	return available;
+}
+
+static void btree_gc(struct closure *cl)
+{
+	struct cache_set *c = container_of(cl, struct cache_set, gc.cl);
+	int ret;
+	unsigned long available;
+	struct bucket *b;
+	struct cache *ca;
+
+	struct gc_stat stats;
+	struct closure writes;
+	struct btree_op op;
+
+	uint64_t start_time = local_clock();
+	trace_bcache_gc_start(c->sb.set_uuid);
+
+	memset(&stats, 0, sizeof(struct gc_stat));
+	closure_init_stack(&writes);
+	btree_op_init_stack(&op);
+	op.lock = SHRT_MAX;
+
+	blktrace_msg_all(c, "Starting gc");
+
+	mutex_lock(&c->bucket_lock);
+	for_each_cache(ca, c)
+		free_some_buckets(ca);
+
+	if (c->gc_mark_valid) {
+		c->gc_mark_valid = 0;
+		c->gc_done = ZERO_KEY;
+
+		for_each_cache(ca, c)
+			for_each_bucket(b, ca)
+				if (!atomic_read(&b->pin))
+					b->mark = 0;
+
+		for (struct bcache_device **d = c->devices;
+		     d < c->devices + c->nr_uuids;
+		     d++)
+			if (*d)
+				(*d)->sectors_dirty_gc = 0;
+	}
+	mutex_unlock(&c->bucket_lock);
+
+	ret = btree_root(gc_root, c, &op, &writes, &stats);
+	closure_sync(&op.cl);
+	closure_sync(&writes);
+
+	if (ret) {
+		blktrace_msg_all(c, "Stopped gc");
+		printk(KERN_WARNING "bcache: gc failed!\n");
+
+		continue_at(cl, btree_gc, bcache_wq);
+	}
+
+	/* Possibly wait for new UUIDs or whatever to hit disk */
+	bcache_journal_meta(c, &op.cl);
+	closure_sync(&op.cl);
+
+	available = btree_gc_finish(c);
+
+	time_stats_update(&c->btree_gc_time, start_time);
+
+	stats.key_bytes *= sizeof(uint64_t);
+	stats.dirty	<<= 9;
+	stats.data	<<= 9;
+	stats.in_use	= (c->nbuckets - available) * 100 / c->nbuckets;
+	memcpy(&c->gc_stats, &stats, sizeof(struct gc_stat));
+	blktrace_msg_all(c, "Finished gc");
+
+	trace_bcache_gc_end(c->sb.set_uuid);
+	closure_wake_up(&c->bucket_wait);
+
+	closure_return(cl);
+}
+
+void bcache_queue_gc(struct cache_set *c)
+{
+	if (closure_trylock(&c->gc.cl, &c->cl))
+		continue_at(&c->gc.cl, btree_gc, bcache_wq);
+}
+
+/* Initial partial gc */
+
+static int btree_check_recurse(struct btree *b, struct btree_op *op,
+			       unsigned long **seen)
+{
+	int ret;
+	struct bkey *k;
+	struct bucket *g;
+
+	for_each_key_filter(b, k, ptr_invalid) {
+		for (unsigned i = 0; i < KEY_PTRS(k); i++) {
+			if (!ptr_available(b->c, k, i))
+				continue;
+
+			g = PTR_BUCKET(b->c, k, i);
+
+			if (!__test_and_set_bit(PTR_BUCKET_NR(b->c, k, i),
+						seen[PTR_DEV(k, i)]) ||
+			    !ptr_stale(b->c, k, i)) {
+				g->gen = PTR_GEN(k, i);
+
+				if (b->level)
+					g->prio = btree_prio;
+				else if (g->prio == btree_prio)
+					g->prio = initial_prio;
+			}
+		}
+
+		btree_mark_key(b, k);
+	}
+
+	if (b->level) {
+		k = next_recurse_key(b, &ZERO_KEY);
+
+		while (k) {
+			struct bkey *p = next_recurse_key(b, k);
+			if (p)
+				prefetch_bucket(b->c, p, b->level - 1);
+
+			ret = btree(check_recurse, k, b, op, seen);
+			if (ret)
+				return ret;
+
+			k = p;
+		}
+	}
+
+	return 0;
+}
+
+int btree_check(struct cache_set *c, struct btree_op *op)
+{
+	int ret = -ENOMEM;
+	unsigned long *seen[MAX_CACHES_PER_SET];
+
+	memset(seen, 0, sizeof(seen));
+
+	for (int i = 0; c->cache[i]; i++) {
+		size_t n = DIV_ROUND_UP(c->cache[i]->sb.nbuckets, 8);
+		seen[i] = kmalloc(n, GFP_KERNEL);
+		if (!seen[i])
+			goto err;
+
+		/* Disables the seen array until prio_read() uses it too */
+		memset(seen[i], 0xFF, n);
+	}
+
+	ret = btree_root(check_recurse, c, op, seen);
+err:
+	for (int i = 0; i < MAX_CACHES_PER_SET; i++)
+		kfree(seen[i]);
+	return ret;
+}
+
+/* Btree insertion */
+
+static void shift_keys(struct btree *b, struct bkey *where, struct bkey *insert)
+{
+	struct bset *i = b->sets[b->nsets].data;
+
+	memmove((uint64_t *) where + bkey_u64s(insert),
+		where,
+		(void *) end(i) - (void *) where);
+
+	i->keys += bkey_u64s(insert);
+	bkey_copy(where, insert);
+	bset_fix_lookup_table(b, where);
+}
+
+static bool fix_overlapping_extents(struct btree *b,
+				    struct bkey *insert,
+				    struct btree_iter *iter,
+				    struct btree_op *op)
+{
+	void subtract_dirty(struct bkey *k, int sectors)
+	{
+		struct bcache_device *d = b->c->devices[KEY_DEV(k)];
+
+		if (KEY_DIRTY(k) && d)
+			atomic_long_sub(sectors, &d->sectors_dirty);
+	}
+
+	unsigned sectors_found = 0;
+
+	while (1) {
+		struct bkey *k = btree_iter_next(iter);
+		if (!k ||
+		    bkey_cmp(insert, &START_KEY(k)) <= 0)
+			break;
+
+		if (bkey_cmp(k, &START_KEY(insert)) <= 0)
+			continue;
+
+		if (op->type == BTREE_REPLACE) {
+			uint64_t offset = k->key - op->replace.key;
+			offset <<= 8;
+
+			BUG_ON(!KEY_PTRS(&op->replace));
+
+			if (KEY_START(k) > KEY_START(insert) + sectors_found)
+				goto check_failed;
+
+			if (KEY_PTRS(&op->replace) != KEY_PTRS(k))
+				goto check_failed;
+
+			for (unsigned i = 0; i < KEY_PTRS(&op->replace); i++)
+				if (k->ptr[i] + offset != op->replace.ptr[i])
+					goto check_failed;
+
+			sectors_found = k->key - KEY_START(insert);
+		}
+
+		if (bkey_cmp(insert, k) < 0 &&
+		    bkey_cmp(&START_KEY(insert), &START_KEY(k)) > 0) {
+			/*
+			 * We overlapped in the middle of an existing key: that
+			 * means we have to split the old key. But we have to do
+			 * slightly different things depending on whether the
+			 * old key has been written out yet.
+			 */
+
+			struct bkey *top;
+
+			subtract_dirty(k, KEY_SIZE(insert));
+
+			if (bkey_written(b, k)) {
+				/*
+				 * We insert a new key to cover the top of the
+				 * old key, and the old key is modified in place
+				 * to represent the bottom split.
+				 *
+				 * It's completely arbitrary whether the new key
+				 * is the top or the bottom, but it has to match
+				 * up with what btree_sort_fixup() does - it
+				 * doesn't check for this kind of overlap, it
+				 * depends on us inserting a new key for the top
+				 * here.
+				 */
+				top = bset_search(b, &b->sets[b->nsets],
+						  insert);
+				shift_keys(b, top, k);
+			} else {
+				BKEY_PADDED(key) temp;
+				bkey_copy(&temp.key, k);
+				shift_keys(b, k, &temp.key);
+				top = next(k);
+			}
+
+			cut_front(insert, top);
+			cut_back(&START_KEY(insert), k);
+			bset_fix_invalidated_key(b, k);
+			return false;
+		}
+
+		if (bkey_cmp(insert, k) < 0) {
+			if (bkey_cmp(insert, &START_KEY(k)) > 0)
+				subtract_dirty(k, insert->key - KEY_START(k));
+
+			cut_front(insert, k);
+		} else {
+			if (bkey_cmp(k, &START_KEY(insert)) > 0)
+				subtract_dirty(k, k->key - KEY_START(insert));
+
+			if (bkey_written(b, k) &&
+			    bkey_cmp(&START_KEY(insert), &START_KEY(k)) <= 0)
+				/*
+				 * Completely overwrote, so we don't have to
+				 * invalidate the binary search tree
+				 */
+				cut_front(k, k);
+			else {
+				__cut_back(&START_KEY(insert), k);
+				bset_fix_invalidated_key(b, k);
+			}
+		}
+	}
+
+check_failed:
+	if (op->type == BTREE_REPLACE &&
+	    sectors_found < KEY_SIZE(insert)) {
+		insert->key -= KEY_SIZE(insert) - sectors_found;
+		SET_KEY_SIZE(insert, sectors_found);
+
+		if (!sectors_found) {
+			op->insert_collision = true;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool btree_insert_key(struct btree *b, struct btree_op *op,
+			     struct bkey *k)
+{
+	struct bset *i = b->sets[b->nsets].data;
+	struct bkey *m, *prev;
+	const char *status = "insert";
+
+	BUG_ON(bkey_cmp(k, &b->key) > 0);
+	BUG_ON(b->level && !KEY_PTRS(k));
+	BUG_ON(!b->level && !k->key);
+
+	if (!b->level) {
+		struct btree_iter iter;
+		struct bkey search = KEY(KEY_DEV(k), KEY_START(k), 0);
+
+		/*
+		 * bset_search() returns the first key that is strictly greater
+		 * than the search key - but for back merging, we want to find
+		 * the first key that is greater than or equal to KEY_START(k) -
+		 * unless KEY_START(k) is 0.
+		 */
+		if (search.key)
+			search.key--;
+
+		prev = NULL;
+		m = btree_iter_init(b, &iter, &search);
+
+		if (fix_overlapping_extents(b, k, &iter, op))
+			return false;
+
+		while (m != end(i) &&
+		       bkey_cmp(k, &START_KEY(m)) > 0)
+			prev = m, m = next(m);
+
+		if (key_merging_disabled(b->c))
+			goto insert;
+
+		/* prev is in the tree, if we merge we're done */
+		status = "back merging";
+		if (prev &&
+		    bkey_try_merge(b, prev, k))
+			goto merged;
+
+		status = "overwrote front";
+		if (m != end(i) &&
+		    KEY_PTRS(m) == KEY_PTRS(k) && !KEY_SIZE(m))
+			goto copy;
+
+		status = "front merge";
+		if (m != end(i) &&
+		    bkey_try_merge(b, k, m))
+			goto copy;
+	} else
+		m = bset_search(b, &b->sets[b->nsets], k);
+
+insert:	shift_keys(b, m, k);
+copy:	bkey_copy(m, k);
+merged:
+	check_keys(b, "%s for %s at %s: %s", status,
+		   op_type(op), pbtree(b), pkey(k));
+	check_key_order_msg(b, i, "%s for %s at %s: %s", status,
+			    op_type(op), pbtree(b), pkey(k));
+
+	if (b->level && !k->key)
+		b->prio_blocked++;
+
+	pr_debug("%s for %s at %s: %s", status,
+		 op_type(op), pbtree(b), pkey(k));
+
+	return true;
+}
+
+bool bcache_btree_insert_keys(struct btree *b, struct btree_op *op)
+{
+	/* If a read generates a cache miss, and a write to the same location
+	 * finishes before the new data is added to the cache, the write will
+	 * be overwritten with stale data. We can catch this by never
+	 * overwriting good data if it came from a read.
+	 */
+	bool ret = false;
+	struct bkey *k;
+	unsigned oldsize = count_data(b);
+
+	while ((k = keylist_pop(&op->keys))) {
+		bkey_put(b->c, k, b->level);
+		ret |= btree_insert_key(b, op, k);
+	}
+
+	BUG_ON(count_data(b) < oldsize);
+	return ret;
+}
+
+bool btree_insert_check_key(struct btree *b, struct btree_op *op,
+			    struct bio *bio)
+{
+	bool ret = false;
+	uint64_t btree_ptr = b->key.ptr[0];
+	unsigned long seq = b->seq;
+	BKEY_PADDED(k) tmp;
+
+	rw_unlock(false, b);
+	rw_lock(true, b, b->level);
+
+	if (b->key.ptr[0] != btree_ptr ||
+	    b->seq != seq + 1 ||
+	    should_split(b))
+		goto out;
+
+	op->replace = KEY(op->d->id, bio_end(bio), bio_sectors(bio));
+
+	SET_KEY_PTRS(&op->replace, 1);
+	get_random_bytes(&op->replace.ptr[0], sizeof(uint64_t));
+
+	SET_PTR_DEV(&op->replace, 0, PTR_CHECK_DEV);
+
+	bkey_copy(&tmp.k, &op->replace);
+
+	BUG_ON(op->type != BTREE_INSERT);
+	BUG_ON(!btree_insert_key(b, op, &tmp.k));
+	btree_write(b, false, NULL);
+	ret = true;
+out:
+	downgrade_write(&b->lock);
+	return ret;
+}
+
+static int btree_split(struct btree *b, struct btree_op *op)
+{
+	bool split, root = b == b->c->root;
+	struct btree *n1, *n2 = NULL, *n3 = NULL;
+	uint64_t start_time = local_clock();
+
+	if (b->level)
+		set_closure_blocking(&op->cl);
+
+	n1 = btree_alloc_replacement(b, &op->cl);
+	if (IS_ERR(n1))
+		goto err;
+
+	split = set_blocks(n1->sets[0].data, n1->c) > (btree_blocks(b) * 4) / 5;
+
+	pr_debug("%ssplitting at %s keys %i", split ? "" : "not ",
+		 pbtree(b), n1->sets[0].data->keys);
+
+	if (split) {
+		unsigned keys = 0;
+
+		n2 = bcache_btree_alloc(b->c, b->level, &op->cl);
+		if (IS_ERR(n2))
+			goto err_free1;
+
+		if (root) {
+			n3 = bcache_btree_alloc(b->c, b->level + 1, &op->cl);
+			if (IS_ERR(n3))
+				goto err_free2;
+		}
+
+		bcache_btree_insert_keys(n1, op);
+
+		/* Has to be a linear search because we don't have an auxiliary
+		 * search tree yet
+		 */
+
+		while (keys < (n1->sets[0].data->keys * 3) / 5)
+			keys += bkey_u64s(node(n1->sets[0].data, keys));
+
+		bkey_copy_key(&n1->key, node(n1->sets[0].data, keys));
+		keys += bkey_u64s(node(n1->sets[0].data, keys));
+
+		n2->sets[0].data->keys = n1->sets[0].data->keys - keys;
+		n1->sets[0].data->keys = keys;
+
+		memcpy(n2->sets[0].data->start,
+		       end(n1->sets[0].data),
+		       n2->sets[0].data->keys * sizeof(uint64_t));
+
+		bkey_copy_key(&n2->key, &b->key);
+
+		keylist_add(&op->keys, &n2->key);
+		btree_write(n2, true, op);
+		rw_unlock(true, n2);
+	} else
+		bcache_btree_insert_keys(n1, op);
+
+	keylist_add(&op->keys, &n1->key);
+	btree_write(n1, true, op);
+
+	if (n3) {
+		bkey_copy_key(&n3->key, &MAX_KEY);
+		bcache_btree_insert_keys(n3, op);
+		btree_write(n3, true, op);
+
+		closure_sync(&op->cl);
+		bcache_btree_set_root(n3);
+		rw_unlock(true, n3);
+	} else if (root) {
+		op->keys.top = op->keys.bottom;
+		closure_sync(&op->cl);
+		bcache_btree_set_root(n1);
+	} else {
+		bkey_copy(op->keys.top, &b->key);
+		bkey_copy_key(op->keys.top, &ZERO_KEY);
+
+		for (unsigned i = 0; i < KEY_PTRS(&b->key); i++) {
+			uint8_t g = PTR_BUCKET(b->c, &b->key, i)->gen + 1;
+
+			SET_PTR_GEN(op->keys.top, i, g);
+		}
+
+		keylist_push(&op->keys);
+		closure_sync(&op->cl);
+		atomic_inc(&b->c->prio_blocked);
+	}
+
+	rw_unlock(true, n1);
+	btree_free(b, op);
+
+	time_stats_update(&b->c->btree_split_time, start_time);
+
+	return 0;
+err_free2:
+	__bkey_put(n2->c, &n2->key);
+	btree_free(n2, op);
+	rw_unlock(true, n2);
+err_free1:
+	__bkey_put(n1->c, &n1->key);
+	btree_free(n1, op);
+	rw_unlock(true, n1);
+err:
+	if (n3 == ERR_PTR(-EAGAIN) ||
+	    n2 == ERR_PTR(-EAGAIN) ||
+	    n1 == ERR_PTR(-EAGAIN))
+		return -EAGAIN;
+
+	printk(KERN_WARNING "bcache: couldn't split");
+	return -ENOMEM;
+}
+
+static int btree_insert_recurse(struct btree *b, struct btree_op *op,
+				struct keylist *stack_keys)
+{
+	if (b->level) {
+		int ret;
+		struct bkey *insert = op->keys.bottom;
+		struct bkey *k = next_recurse_key(b, &START_KEY(insert));
+
+		if (!k) {
+			btree_bug(b, "no key to recurse on at level %i/%i",
+				  b->level, b->c->root->level);
+
+			op->keys.top = op->keys.bottom;
+			return -EIO;
+		}
+
+		if (bkey_cmp(insert, k) > 0) {
+			if (op->type == BTREE_REPLACE) {
+				__bkey_put(b->c, insert);
+				op->keys.top = op->keys.bottom;
+				op->insert_collision = true;
+				return 0;
+			}
+
+			for (unsigned i = 0; i < KEY_PTRS(insert); i++)
+				atomic_inc(&PTR_BUCKET(b->c, insert, i)->pin);
+
+			bkey_copy(stack_keys->top, insert);
+
+			cut_back(k, insert);
+			cut_front(k, stack_keys->top);
+
+			keylist_push(stack_keys);
+		}
+
+		ret = btree(insert_recurse, k, b, op, stack_keys);
+		if (ret)
+			return ret;
+	}
+
+	if (!keylist_empty(&op->keys)) {
+		BUG_ON(!current_is_writer(&b->lock));
+
+		if (should_split(b)) {
+			if (op->lock <= b->c->root->level) {
+				BUG_ON(b->level);
+				op->lock = b->c->root->level + 1;
+				return -EINTR;
+			}
+			return btree_split(b, op);
+		}
+
+		BUG_ON(write_block(b) != b->sets[b->nsets].data);
+
+		if (bcache_btree_insert_keys(b, op))
+			btree_write(b, false, op);
+	}
+
+	return 0;
+}
+
+int bcache_btree_insert(struct btree_op *op, struct cache_set *c)
+{
+	int ret = 0;
+	struct cache *ca;
+	struct keylist stack_keys;
+
+	/*
+	 * Don't want to block with the btree locked unless we have to,
+	 * otherwise we get deadlocks with try_harder and between split/gc
+	 */
+	clear_closure_blocking(&op->cl);
+
+	BUG_ON(keylist_empty(&op->keys));
+	keylist_copy(&stack_keys, &op->keys);
+	keylist_init(&op->keys);
+
+	while (c->need_gc > MAX_NEED_GC) {
+		closure_lock(&c->gc, &c->cl);
+		btree_gc(&c->gc.cl);
+	}
+
+	for_each_cache(ca, c)
+		while (ca->need_save_prio > MAX_SAVE_PRIO) {
+			mutex_lock(&c->bucket_lock);
+			free_some_buckets(ca);
+			mutex_unlock(&c->bucket_lock);
+
+			closure_wait_event_sync(&c->bucket_wait, &op->cl,
+				ca->need_save_prio <= MAX_SAVE_PRIO ||
+				can_save_prios(ca));
+		}
+
+	while (!keylist_empty(&stack_keys) ||
+	       !keylist_empty(&op->keys)) {
+		if (keylist_empty(&op->keys)) {
+			keylist_add(&op->keys, keylist_pop(&stack_keys));
+			op->lock = 0;
+		}
+
+		ret = btree_root(insert_recurse, c, op, &stack_keys);
+
+		if (ret == -EAGAIN) {
+			ret = 0;
+			closure_sync(&op->cl);
+		} else if (ret) {
+			struct bkey *k;
+
+			printk(KERN_WARNING "bcache: error %i trying to "
+			       "insert key for %s\n", ret, op_type(op));
+
+			while ((k = keylist_pop(&stack_keys) ?:
+				    keylist_pop(&op->keys)))
+				bkey_put(c, k, 0);
+		}
+	}
+
+	keylist_free(&stack_keys);
+
+	if (op->journal)
+		atomic_dec_bug(op->journal);
+	op->journal = NULL;
+	return ret;
+}
+
+void bcache_btree_set_root(struct btree *b)
+{
+	BUG_ON(!b->written);
+	BUG_ON(!current_is_writer(&b->c->root->lock));
+
+	for (unsigned i = 0; i < KEY_PTRS(&b->key); i++)
+		BUG_ON(PTR_BUCKET(b->c, &b->key, i)->prio != btree_prio);
+
+	mutex_lock(&b->c->bucket_lock);
+	list_del_init(&b->list);
+	mutex_unlock(&b->c->bucket_lock);
+
+	b->c->root = b;
+	__bkey_put(b->c, &b->key);
+
+	bcache_journal_meta(b->c, NULL);
+	pr_debug("%s for %pf", pbtree(b), __builtin_return_address(0));
+}
+
+/* Cache lookup */
+
+static int submit_partial_cache_miss(struct btree *b, struct btree_op *op,
+				     struct bkey *k)
+{
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = &s->bio.bio;
+	int ret = 0;
+
+	while (!ret &&
+	       !op->lookup_done) {
+		unsigned sectors = INT_MAX;
+
+		if (KEY_DEV(k) == s->op.d->id) {
+			if (KEY_START(k) <= bio->bi_sector)
+				break;
+
+			sectors = min_t(uint64_t, sectors,
+					KEY_START(k) - bio->bi_sector);
+		}
+
+		ret = s->op.d->cache_miss(b, s, bio, sectors);
+	}
+
+	return ret;
+}
+
+/*
+ * Read from a single key, handling the initial cache miss if the key starts in
+ * the middle of the bio
+ */
+static int submit_partial_cache_hit(struct btree *b, struct btree_op *op,
+				    struct bkey *k)
+{
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = &s->bio.bio;
+
+	unsigned sectors, ptr;
+	struct bio *n;
+
+	int ret = submit_partial_cache_miss(b, op, k);
+	if (ret || op->lookup_done)
+		return ret;
+
+	/* XXX: figure out best pointer - for multiple cache devices */
+	ptr = 0;
+
+	PTR_BUCKET(b->c, k, ptr)->prio = initial_prio;
+
+	while (!op->lookup_done &&
+	       KEY_DEV(k) == s->op.d->id &&
+	       bio->bi_sector < k->key) {
+		struct bkey *bio_key;
+		struct block_device *bdev = PTR_CACHE(b->c, k, ptr)->bdev;
+
+		sector_t sector = PTR_OFFSET(k, ptr) +
+			(bio->bi_sector - KEY_START(k));
+
+		sectors = min_t(unsigned, k->key - bio->bi_sector,
+				__bio_max_sectors(bio, bdev, sector));
+
+		n = bio_split_get(bio, sectors, op->d);
+		if (!n)
+			return -EAGAIN;
+
+		if (n == bio)
+			op->lookup_done = true;
+
+		bio_key = &container_of(n, struct bbio, bio)->key;
+
+		/*
+		 * The bucket we're reading from might be reused while our bio
+		 * is in flight, and we could then end up reading the wrong
+		 * data.
+		 *
+		 * We guard against this by checking (in cache_read_endio()) if
+		 * the pointer is stale again; if so, we treat it as an error
+		 * and reread from the backing device (but we don't pass that
+		 * error up anywhere).
+		 */
+
+		bkey_copy_single_ptr(bio_key, k, ptr);
+		SET_PTR_OFFSET(bio_key, 0, sector);
+
+		n->bi_end_io = cache_read_endio;
+
+		trace_bcache_cache_hit(n);
+		__submit_bbio(n, b->c);
+	}
+
+	return 0;
+}
+
+int btree_search_recurse(struct btree *b, struct btree_op *op)
+{
+	struct search *s = container_of(op, struct search, op);
+	struct bio *bio = &s->bio.bio;
+
+	int ret = 0;
+	struct bkey *k;
+	struct btree_iter iter;
+	btree_iter_init(b, &iter, &KEY(op->d->id, bio->bi_sector, 0));
+
+	pr_debug("at %s searching for %u:%llu", pbtree(b), op->d->id,
+		 (uint64_t) bio->bi_sector);
+
+	do {
+		k = btree_iter_next(&iter);
+		if (!k) {
+			ret = submit_partial_cache_miss(b, op,
+					&KEY(KEY_DEV(&b->key), b->key.key, 0));
+			break;
+		}
+
+		if (ptr_bad(b, k))
+			continue;
+
+		ret = b->level
+			? btree(search_recurse, k, b, op)
+			: submit_partial_cache_hit(b, op, k);
+	} while (!ret &&
+		 !op->lookup_done);
+
+	return ret;
+}
+
+void bcache_btree_exit(void)
+{
+	if (btree_wq)
+		destroy_workqueue(btree_wq);
+}
+
+int __init bcache_btree_init(void)
+{
+	btree_wq = create_singlethread_workqueue("bcache_btree_io");
+	if (!btree_wq)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/drivers/block/bcache/btree.h b/drivers/block/bcache/btree.h
new file mode 100644
index 0000000..8fa9b57
--- /dev/null
+++ b/drivers/block/bcache/btree.h
@@ -0,0 +1,272 @@
+#ifndef _BCACHE_BTREE_H
+#define _BCACHE_BTREE_H
+
+#include "bset.h"
+#include "debug.h"
+
+struct btree_write {
+	struct closure		*owner;
+	atomic_t		*journal;
+
+	/* If btree_split() frees a btree node, it writes a new pointer to that
+	 * btree node indicating it was freed; it takes a refcount on
+	 * c->prio_blocked because we can't write the gens until the new
+	 * pointer is on disk. This allows btree_write_endio() to release the
+	 * refcount that btree_split() took.
+	 */
+	int			prio_blocked;
+};
+
+struct btree {
+	/* Hottest entries first */
+	struct hlist_node	hash;
+
+	/* Key/pointer for this btree node */
+	BKEY_PADDED(key);
+
+	/* Single bit - set when accessed, cleared by shrinker */
+	unsigned long		accessed;
+	unsigned long		seq;
+	struct rw_semaphore	lock;
+	struct cache_set	*c;
+
+	unsigned long		flags;
+	uint16_t		written;	/* would be nice to kill */
+	uint8_t			level;
+	uint8_t			nsets;
+	uint8_t			page_order;
+
+	/*
+	 * Set of sorted keys - the real btree node - plus a binary search tree
+	 *
+	 * sets[0] is special; set[0]->tree, set[0]->prev and set[0]->data point
+	 * to the memory we have allocated for this btree node. Additionally,
+	 * set[0]->data points to the entire btree node as it exists on disk.
+	 */
+	struct bset_tree	sets[MAX_BSETS];
+
+	/* Used to refcount bio splits, also protects b->bio */
+	struct closure_with_waitlist	io;
+
+	/* Gets transferred to w->prio_blocked - see the comment there */
+	int			prio_blocked;
+
+	struct list_head	list;
+	struct delayed_work	work;
+
+	uint64_t		io_start_time;
+	struct btree_write	writes[2];
+	struct bio		*bio;
+};
+
+#define BTREE_FLAG(flag)						\
+static inline bool btree_node_ ## flag(struct btree *b)			\
+{	return test_bit(BTREE_NODE_ ## flag, &b->flags); }		\
+									\
+static inline void set_btree_node_ ## flag(struct btree *b)		\
+{	set_bit(BTREE_NODE_ ## flag, &b->flags); }			\
+
+enum btree_flags {
+	BTREE_NODE_read_done,
+	BTREE_NODE_io_error,
+	BTREE_NODE_dirty,
+	BTREE_NODE_write_idx,
+};
+
+BTREE_FLAG(read_done);
+BTREE_FLAG(io_error);
+BTREE_FLAG(dirty);
+BTREE_FLAG(write_idx);
+
+static inline struct btree_write *btree_current_write(struct btree *b)
+{
+	return b->writes + btree_node_write_idx(b);
+}
+
+static inline struct btree_write *btree_prev_write(struct btree *b)
+{
+	return b->writes + (btree_node_write_idx(b) ^ 1);
+}
+
+static inline unsigned bset_offset(struct btree *b, struct bset *i)
+{
+	return (((size_t) i) - ((size_t) b->sets->data)) >> 9;
+}
+
+static inline struct bset *write_block(struct btree *b)
+{
+	return ((void *) b->sets[0].data) + b->written * block_bytes(b->c);
+}
+
+static inline bool bset_written(struct btree *b, struct bset_tree *t)
+{
+	return t->data < write_block(b);
+}
+
+static inline bool bkey_written(struct btree *b, struct bkey *k)
+{
+	return k < write_block(b)->start;
+}
+
+static inline void set_gc_sectors(struct cache_set *c)
+{
+	atomic_set(&c->sectors_to_gc, c->sb.bucket_size * c->nbuckets / 8);
+}
+
+/* Looping macros */
+
+#define for_each_sorted_set_start(b, i, start)				\
+	for (int _i = start; i = (b)->sets[_i].data, _i <= (b)->nsets; _i++)
+
+#define for_each_sorted_set(b, i)	for_each_sorted_set_start(b, i, 0)
+
+#define bkey_filter(b, i, k, filter)					\
+({									\
+	while (k < end(i) && filter(b, k))				\
+		k = next(k);						\
+	k;								\
+})
+
+#define all_keys(b, k)		0
+
+#define for_each_key_filter(b, k, filter)				\
+	for (struct bset_tree *_t = (b)->sets;				\
+	     _t <= &(b)->sets[(b)->nsets];				\
+	     _t++)							\
+		for (k = _t->data->start;				\
+		     (k = bkey_filter(b, _t->data, k, filter))		\
+			< end(_t->data);				\
+		     k = next(k))
+
+#define for_each_key(b, k)	for_each_key_filter(b, k, all_keys)
+
+/* Recursing down the btree */
+
+struct btree_op {
+	struct closure		cl;
+	struct bcache_device	*d;
+
+	/* Journal entry we have a refcount on */
+	atomic_t		*journal;
+
+	/* Btree level at which we start taking write locks */
+	short			lock;
+
+	/* Btree insertion type */
+	enum {
+		BTREE_INSERT,
+		BTREE_REPLACE
+	} type:8;
+
+	unsigned		lookup_done:1;
+	unsigned		insert_collision:1;
+	unsigned		flush_journal:1;
+
+	/* Anything after this point won't get zeroed in do_bio_hook() */
+
+	/* Keys to be inserted */
+	struct keylist		keys;
+	BKEY_PADDED(replace);
+};
+
+void btree_op_init_stack(struct btree_op *);
+
+static inline void rw_lock(bool w, struct btree *b, int level)
+{
+	w ? down_write_nested(&b->lock, level + 1)
+	  : down_read_nested(&b->lock, level + 1);
+	if (w)
+		b->seq++;
+}
+
+static inline void rw_unlock(bool w, struct btree *b)
+{
+#ifdef CONFIG_BCACHE_EDEBUG
+	if (w &&
+	    b->key.ptr[0] &&
+	    btree_node_read_done(b))
+		for (unsigned i = 0; i <= b->nsets; i++)
+			check_key_order(b, b->sets[i].data);
+#endif
+
+	if (w)
+		b->seq++;
+	(w ? up_write : up_read)(&b->lock);
+}
+
+#define insert_lock(s, b)	((b)->level <= (s)->lock)
+
+/*
+ * These macros are for recursing down the btree - they handle the details of
+ * locking and looking up nodes in the cache for you. They're best treated as
+ * mere syntax when reading code that uses them.
+ *
+ * op->lock determines whether we take a read or a write lock at a given depth.
+ * If you've got a read lock and find that you need a write lock (i.e. you're
+ * going to have to split), set op->lock and return -EINTR; btree_root() will
+ * call you again and you'll have the correct lock.
+ */
+#define btree(f, k, b, op, ...)						\
+({									\
+	int _r, l = (b)->level - 1;					\
+	bool _w = l <= (op)->lock;					\
+	struct btree *_b = get_bucket((b)->c, k, l, op);		\
+	if (!IS_ERR(_b)) {						\
+		_r = btree_ ## f(_b, op, ##__VA_ARGS__);		\
+		rw_unlock(_w, _b);					\
+	} else								\
+		_r = PTR_ERR(_b);					\
+	_r;								\
+})
+
+#define btree_root(f, c, op, ...)					\
+({									\
+	int _r = -EINTR;						\
+	do {								\
+		struct btree *_b = (c)->root;				\
+		bool _w = insert_lock(op, _b);				\
+		rw_lock(_w, _b, _b->level);				\
+		if (_b == (c)->root &&					\
+		    _w == insert_lock(op, _b))				\
+			_r = btree_ ## f(_b, op, ##__VA_ARGS__);	\
+		rw_unlock(_w, _b);					\
+	} while (_r == -EINTR);						\
+									\
+	if ((c)->try_harder == &(op)->cl) {				\
+		time_stats_update(&(c)->try_harder_time,		\
+				  (c)->try_harder_start);		\
+		(c)->try_harder = NULL;					\
+		__closure_wake_up(&(c)->try_wait);			\
+	}								\
+	_r;								\
+})
+
+static inline bool should_split(struct btree *b)
+{
+	struct bset *i = write_block(b);
+	return b->written >= btree_blocks(b) ||
+		(i->seq == b->sets[0].data->seq &&
+		 b->written + __set_blocks(i, i->keys + 15, b->c)
+		 > btree_blocks(b));
+}
+
+void btree_read_done(struct closure *);
+void btree_read(struct btree *);
+void btree_write(struct btree *b, bool now, struct btree_op *op);
+
+void bcache_btree_set_root(struct btree *);
+struct btree *bcache_btree_alloc(struct cache_set *, int, struct closure *);
+struct btree *get_bucket(struct cache_set *, struct bkey *,
+			 int, struct btree_op *);
+
+bool bcache_btree_insert_keys(struct btree *, struct btree_op *);
+bool btree_insert_check_key(struct btree *, struct btree_op *, struct bio *);
+int bcache_btree_insert(struct btree_op *, struct cache_set *);
+int btree_search_recurse(struct btree *, struct btree_op *);
+
+void bcache_queue_gc(struct cache_set *);
+size_t btree_gc_finish(struct cache_set *);
+int btree_check(struct cache_set *, struct btree_op *);
+void __btree_mark_key(struct cache_set *, int, struct bkey *);
+
+#endif
-- 
1.7.9.rc2

