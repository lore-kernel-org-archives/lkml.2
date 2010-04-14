Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0DNFSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:18:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59811 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab0DNFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Fs31eeIIDuy6mRW2aHamMCtvCmytObgNYJ3QXJINdlawDzmBpcR/5begkURt9JGklm
         sJf0ltpGhVaAxJnW0ToK/rJdjBc/RyhyTj/iynxvjq6peQkr8KPUCz/55WnhZpn6kALU
         hICli24Q1g57grNaGNPMxFA+Xd5qDmcbwVXCE=
Date: Tue, 13 Apr 2010 21:18:29 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] bcache: cache a block device with an ssd (now with
 fewer bugs!)
Message-ID: <20100414051829.GA28949@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those who missed the first version, I outlined the general
architecture: http://lkml.indiana.edu/hypermail//linux/kernel/1004.0/01051.html

For those who did read it, my apologies, this version is slightly less
likely to make your eyes bleed. I've put a lot of effort into getting
the code cleaned up and debugged; it's definitely taking shape. I'd
really welcome any and all comments on the design and such at this
point, including pointing out all the things I've done horribly wrong.

In this version the only real bug I know of (vs. stuff that's broken
because it's unimplemented) is a deadlock caused by waiting on pages to
be unlocked - in certain circumstances, it's possible to wait before the
io has been submitted, and since the btree code is usually called from
__generic_make_request it'll never get issued. The ideal way for me to
handle this would be to get a callback when a page is unlocked, but I
don't see a good way of doing this. The alternate solution would be not
relying on page locking at all - having a per btree bucket struct that
holds references to all its pages. It seems to me that this may be the
way to go anyways to avoid the overhead of find_get_pages() on every
bio, but I'm hoping to get some input before I go off and code that.

Locking is currently mostly unimplemented, waiting on the solution to
the previous problem to be determined.

I'm also still missing some error handling, but it should now tolerate
any on disk corruption and I think I may have the btrees just about
worked out; splitting and such works reliably now, vs. the last one
where it was horribly broken.

My other main unresolved issue is, given a bio how to determine which
device it goes to. Originally I was using bio->bi_bdev, strictly as a
hack to get it working, then I found it changing back and forth between
the original value and a different one for no apparant reason. It looks
like struct gendisk or something inside it might be what I want, except
that previous to the device being opened bdev->block_device is null.
Presumably it could be frobbed somehow to make it non null, but I have
yet to discover how this is accomplished. Any pointers would be much
appreciated.

As always, any review/input greatly appreciated. The make a cache device
program is again at the bottom:

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
index 0000000..389e343
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,1833 @@
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
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
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
+	long		heap;
+	int16_t		priority;
+	uint8_t		generation;
+};
+
+struct bucket_disk {
+	int16_t		priority;
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
+	struct cache_sb		sb;
+	struct buffer_head	*sb_bh;
+	struct kobject		kobj;
+	struct list_head	list;
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
+	spinlock_t		heap_lock;
+	long			*heap;
+	struct bucket		*buckets;
+	struct buffer_head	*priorities;
+	long			heap_size;
+
+	long			*freelist;
+	size_t			free_size;
+	size_t			free_front;
+	size_t			free_back;
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
+};
+
+struct journal_header {
+	uint32_t csum;
+	uint32_t seq;
+	uint32_t last_open_entry;
+	uint32_t nr_entries;
+};
+
+struct search_context;
+typedef void (search_fn) (void *, struct bio *, struct search_context *);
+
+struct search_context {
+	struct work_struct	w;
+	struct btree_key	new_keys[2];
+	void			*q;
+	struct bio		*bio;
+	int			error;
+	atomic_t		remaining;
+	bool			clone;
+	struct search_context	*parent;
+	search_fn		*end_fn;
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
+static unsigned long cache_hits, cache_misses;
+static uint16_t	initial_priority = 100, cache_hit_priority = 50;
+
+static struct search_context *alloc_search(struct search_context *s);
+static int request_hook(struct request_queue *q, struct bio *bio);
+static void __heap_insert(struct cache_device *c, long b);
+static void btree_write_node_bh(struct bio *bio, int error);
+static void unregister_cache(struct kobject *k);
+static void write_super(struct cache_device *c);
+static void run_search(struct work_struct *w);
+static void bio_complete(void *p, struct bio *bio, struct search_context *s);
+static void bio_insert(void *private, struct bio *bio,
+		       struct search_context *s);
+
+static void request_hook_read(void *p, struct bio *bio,
+			      struct search_context *s);
+
+static void submit_wait_bio(int rw, struct bio *bio, struct cache_device *c,
+			    struct search_context *s, int unlock);
+
+
+#define pages_per_btree		(c->sb.btree_bucket_size >> (PAGE_SHIFT - 9))
+#define keys_per_page		(PAGE_SIZE / sizeof(struct btree_key))
+#define bucket_to_sector(b)	((uint64_t) ((b) + c->sb.first_bucket) * c->sb.bucket_size)
+#define sector_to_bucket(s)	(((s) / c->sb.bucket_size) - c->sb.first_bucket)
+#define sector_to_gen(s)	(c->buckets[sector_to_bucket(s)].generation)
+#define ptr_to_bucket(p)	sector_to_bucket(PTR_OFFSET(p))
+
+#define label(l, foo)	if (0) { l: foo; }
+
+/*
+ * key: 8 bit device, 56 bit offset
+ * value: 8 bit generation, 16 bit length, 40 bit offset
+ * All units are in sectors
+ */
+
+static inline struct btree_key *node(void *d[], int i)
+{
+	return d[i / keys_per_page] + (i % keys_per_page) *
+		sizeof(struct btree_key);
+}
+
+#define TREE_KEY(device, offset)	((offset) | ((uint64_t) device) << 56)
+#define TREE_KEY_DEV(device, offset)	(node(page, i)->key >> 56)
+#define TREE_KEY_OFFSET(page, i)	(node(page, i)->key & ~((uint64_t) ~0 << 56))
+
+#define TREE_PTR(gen, length, offset)	((gen) | (length) << 8 | (uint64_t) (offset) << 24)
+#define PTR_GEN(p)			(p & ~(~0 << 8))
+#define PTR_LENGTH(p)			((p >> 8) & ~(~0 << 16))
+#define PTR_OFFSET(p)			(p >> 24)
+#define TREE_PTR_GEN(page, i)		PTR_GEN(node(page, i)->ptr)
+#define TREE_PTR_LENGTH(page, i)	PTR_LENGTH(node(page, i)->ptr)
+#define TREE_PTR_OFFSET(page, i)	PTR_OFFSET(node(page, i)->ptr)
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
+static bool trylock_pages(struct page *p[], size_t n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (!trylock_page(p[i])) {
+			wait_on_page_locked(p[i]);
+
+			for (--i; i >= 0; --i)
+				unlock_page(p[i]);
+
+			return false;
+		}
+
+	return true;
+}
+
+static void run_search(struct work_struct *w)
+{
+	struct search_context *s = container_of(w, struct search_context, w);
+	atomic_set(&s->remaining, 1);
+	s->end_fn(s->q, s->bio, s);
+}
+
+static void put_search(struct search_context *s)
+{
+	if (atomic_dec_and_test(&((s)->remaining))) {
+		mb();
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
+		if (s && !s->clone) {				\
+			s->end_fn = f;				\
+			mb();					\
+			put_search(s);				\
+		}						\
+		return;						\
+	} while (0)
+
+static struct search_context *alloc_search(struct search_context *s)
+{
+	struct search_context *r = s;
+	if (!s || s->clone) {
+		r = kzalloc(sizeof(*s), GFP_NOIO);
+		if (s)
+			*r = *s;
+		atomic_set(&r->remaining, 1);
+		r->clone = false;
+		INIT_WORK(&r->w, run_search);
+	}
+	return r;
+}
+
+#define heap_cmp(i, j)	(c->buckets[c->heap[i]].priority >=	\
+			 c->buckets[c->heap[j]].priority)
+
+static int heap_swap(struct cache_device *c, long i, long j)
+{
+	if (heap_cmp(i, j))
+		return 0;
+
+	c->heap[i] = c->buckets[c->heap[j]].heap;
+	c->heap[j] = c->buckets[c->heap[i]].heap;
+
+	c->buckets[c->heap[i]].heap = i;
+	c->buckets[c->heap[j]].heap = j;
+	return 1;
+}
+
+/*
+ * Priority is only increased (on cache hit)
+ */
+static void __heap_sift(struct cache_device *c, long b)
+{
+	long r, h = c->buckets[b].heap;
+
+	for (; h * 2 + 1 < c->heap_size; h = r) {
+		r = h * 2 + 1;
+		if (r + 1 < c->heap_size &&
+		    heap_cmp(r, r + 1))
+			r++;
+
+		if (!heap_swap(c, h, r))
+			break;
+	}
+}
+
+static void __heap_insert(struct cache_device *c, long b)
+{
+	long p, h = c->heap_size;
+
+	c->buckets[b].priority = initial_priority;
+	c->buckets[b].heap = h;
+	c->heap[h] = b;
+	c->heap_size++;
+
+	for (p = (h - 1) / 2; p; h = p, p = (h - 1) / 2)
+		if (!heap_swap(c, p, h))
+			break;
+
+	__heap_sift(c, c->heap[h]);
+
+	pr_debug("inserted bucket %li, new heap size %li, heap location %li, heap pointer %li",
+		 b, c->heap_size, c->buckets[b].heap, c->heap[c->buckets[b].heap]);
+}
+
+static void heap_insert(struct cache_device *c, long b)
+{
+	spin_lock(&c->heap_lock);
+	if (c->buckets[b].heap == -1)
+		__heap_insert(c, b);
+	else
+		__heap_sift(c, b);
+	spin_unlock(&c->heap_lock);
+}
+
+static long heap_pop(struct cache_device *c)
+{
+	long ret;
+
+	spin_lock(&c->heap_lock);
+	ret = c->heap[0];
+	c->buckets[ret].priority = 0;
+	c->buckets[ret].heap = -1;
+
+	c->heap[0] = c->heap[--c->heap_size];
+	c->buckets[c->heap[0]].heap = 0;
+	__heap_sift(c, c->heap[0]);
+	spin_unlock(&c->heap_lock);
+
+	return ret;
+}
+
+static long __pop_bucket(struct cache_device *c)
+{
+	long r, first_free_bucket;
+	int free = c->free_front - c->free_back;
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
+			r = heap_pop(c);
+
+		c->buckets[r].generation++;
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
+static int get_bucket(struct cache_device *c, uint64_t offset,
+		      struct page *p[], void *data[], struct search_context **s)
+{
+	int i, nread, ret = 0;
+	struct bio *bio = NULL;
+
+	memset(&p[0], 0, pages_per_btree * sizeof(void *));
+
+	nread = find_get_pages(c->bdev->bd_inode->i_mapping,
+			       offset >> (PAGE_SHIFT - 9), pages_per_btree, p);
+
+	if (nread != pages_per_btree)
+		*s = alloc_search(*s);
+
+	for (i = 0; i < pages_per_btree; i++)
+		if (!p[i]) {
+			p[i] = __page_cache_alloc(GFP_NOIO);
+			p[i]->mapping = c->bdev->bd_inode->i_mapping;
+			if (add_to_page_cache_lru(p[i],
+						  c->bdev->bd_inode->i_mapping,
+						  (offset >> (PAGE_SHIFT - 9)) + i,
+						  GFP_NOIO & GFP_RECLAIM_MASK)) {
+				/* XXX: need to check for actual errors */
+				page_cache_release(p[i]);
+				p[i] = find_get_page(c->bdev->bd_inode->i_mapping,
+						     (offset >> (PAGE_SHIFT - 9)) + i);
+				BUG_ON(!p[i]);
+				goto wait;
+			}
+
+			if (!bio) {
+				bio = bio_kmalloc(GFP_NOIO, pages_per_btree - nread);
+				bio->bi_sector = offset + (i << (PAGE_SHIFT - 9));
+				pr_debug("reading at sector %li, page_index %li",
+					 bio->bi_sector, page_index(p[i]));
+			}
+			nread++;
+
+			bio->bi_io_vec[bio->bi_vcnt].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[bio->bi_vcnt].bv_offset = 0;
+			bio->bi_io_vec[bio->bi_vcnt].bv_page = p[i];
+			bio->bi_vcnt++;
+			bio->bi_size += PAGE_SIZE;
+			p[i] = data[i] = NULL;
+		} else {
+wait:			wait_on_page_locked(p[i]);
+
+			if (bio)
+				submit_wait_bio(READ, bio, c, *s, 1);
+			bio = NULL;
+			if (i == ret)
+				ret++;
+
+			data[i] = kmap(p[i]);
+		}
+
+	if (bio)
+		submit_wait_bio(READ, bio, c, *s, 1);
+
+	return ret;
+}
+
+static void put_bucket(struct cache_device *c, long offset, struct page *p[])
+{
+	int i;
+	for (i = 0; i < pages_per_btree; i++)
+		if (p[i]) {
+			kunmap(p[i]);
+			put_page(p[i]);
+		}
+}
+
+static uint64_t btree_alloc(struct cache_device *c, struct page *p[],
+			    void *data[], void *olddata[], int nkeys, int skip)
+{
+	int i;
+	uint64_t offset;
+	struct btree_node_header *h;
+       
+	if (c->btree_sectors_free < c->sb.btree_bucket_size) {
+		long b = __pop_bucket(c);
+		c->buckets[b].priority = -1;
+		c->current_btree_bucket = bucket_to_sector(b);
+		c->btree_sectors_free = c->sb.bucket_size;
+	}
+
+	offset = c->current_btree_bucket + c->sb.bucket_size - c->btree_sectors_free;
+	c->btree_sectors_free -= c->sb.btree_bucket_size;
+
+	memset(&p[0], 0, pages_per_btree * sizeof(void *));
+	BUG_ON(!pages_per_btree);
+
+	for (i = 0; i < pages_per_btree; i++) {
+		p[i] = find_or_create_page(c->bdev->bd_inode->i_mapping,
+					   (offset >> (PAGE_SHIFT - 9)) + i,
+					   GFP_NOIO);
+		if (!p[i]) {
+			for (; i >= 0; --i) {
+				kunmap(p[i]);
+				page_cache_release(p[i]);
+				p[i] = data[i] = NULL;
+			}
+			printk(KERN_WARNING "bcache: btree_alloc: error adding new pages");
+			return 0;
+		}
+
+		data[i] = kmap(p[i]);
+	}
+
+	h = data[0];
+	get_random_bytes(&h->random, sizeof(uint64_t));
+	h->nkeys = nkeys - skip;
+
+	if (olddata)
+		for (i = 1; i <= h->nkeys; i++)
+			*node(data, i) = *node(olddata, i + skip);
+
+	for (i = 0; i < h->nkeys / keys_per_page + 1; i++)
+		SetPageDirty(p[i]);
+
+	pr_debug("sector %llu, page_index %li", offset, page_index(p[0]));
+
+	return TREE_PTR(sector_to_gen(offset), 0, offset);
+}
+
+static void free_bucket(struct cache_device *c, uint64_t offset, struct page *p[])
+{
+	int i;
+	long b = sector_to_bucket(offset);
+
+	/*struct address_space *mapping = p[0]->mapping;
+
+	spin_lock_irq(&mapping->tree_lock);
+	for (i = 0; i < pages; i++)
+		__remove_from_page_cache(p[i]);
+	spin_unlock_irq(&mapping->tree_lock);*/
+
+	c->buckets[b].generation++;
+	c->buckets[b].priority = 0;
+
+	if (c->free_front != c->free_back) {
+		c->freelist[c->free_front++] = b;
+		c->free_front &= c->free_size;
+	} else
+		heap_insert(c, b);
+
+	blkdev_issue_discard(c->bdev, offset,
+			     c->sb.bucket_size, GFP_NOIO, 0);
+
+	for (i = 0; i < pages_per_btree; i++)
+		unlock_page(p[i]);
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
+static void bio_add_work_unlock(struct bio *bio, int error)
+{
+	int i;
+	for (i = 0; i < bio->bi_vcnt; i++)
+		unlock_page(bio->bi_io_vec[i].bv_page);
+
+	bio_add_work(bio, error);
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
+	} else
+		pr_debug("failed");
+
+	return ret;
+}
+
+static void submit_wait_bio(int rw, struct bio *bio, struct cache_device *c,
+			    struct search_context *s, int unlock)
+{
+	BUG_ON(!bio->bi_vcnt || !bio->bi_size || bio->bi_idx);
+	bio->bi_bdev = c->bdev;
+	bio->bi_private = s;
+	bio->bi_next = NULL;
+	bio->bi_end_io = unlock ? bio_add_work_unlock : bio_add_work;
+
+	atomic_inc(&s->remaining);
+	submit_bio(rw, bio);
+}
+
+static void submit_bio_list(struct bio *bio)
+{
+	while (bio) {
+		struct bio *t = bio->bi_next;
+		bio->bi_next = NULL;
+		generic_make_request(bio);
+		bio = t;
+	}
+}
+
+static bool __ptr_checks(struct cache_device *c, uint64_t p)
+{
+	if (PTR_OFFSET(p) < bucket_to_sector(0) ||
+	    PTR_OFFSET(p) > bucket_to_sector(c->sb.first_free_bucket - 1)) {
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
+#define ptr_checks(c, p)	__ptr_checks(c, p->ptr)
+
+/* Iterate over the sorted sets of pages
+ */
+#define for_each_sorted_set(i, data, h)					\
+	for (h = data[0], i = data;					\
+	     i < data + pagesread &&					\
+	     h->random == ((struct btree_node_header *) data[0])->random;\
+	     i += (h->nkeys / keys_per_page) + 1, h = *i)
+
+#define sorted_set_checks()						\
+	if (h->nkeys >= (pages_per_btree - (i - data)) * keys_per_page) {\
+		pr_debug("bad btree header: page %li h->nkeys %i",	\
+			 i - data, h->nkeys);				\
+		h->nkeys = 0;						\
+		if (i != data)						\
+			break;						\
+	}								\
+	if (h->nkeys >= (pagesread - (i - data)) * keys_per_page)	\
+		goto again;
+
+/*
+ * Returns the smallest key greater than the search key.
+ * This is because we index by the end, not the beginning
+ */
+static int btree_bsearch(void *data[], int nkeys, uint64_t search)
+{
+	int l = 1, r = nkeys + 1;
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
+static int btree_search(struct cache_device *c, long root, int level, int device,
+			struct bio *bio, struct search_context **s)
+{
+	int ret = -1, j, last, pagesread;
+	struct page *p[pages_per_btree];
+	void *data[pages_per_btree], **i;
+	struct btree_node_header *h;
+	struct bio *split;
+
+	uint64_t search = TREE_KEY(device, bio->bi_sector);
+	pr_debug("at %lu searching for %llu", root, search);
+
+	pagesread = get_bucket(c, root, p, data, s);
+	if (pagesread <= 0)
+		return pagesread;
+
+	for_each_sorted_set(i, data, h) {
+		sorted_set_checks();
+
+		for (j = btree_bsearch(i, h->nkeys, search), last = 0;
+		     j <= h->nkeys && ret != 1; j++) {
+			if (ptr_checks(c, node(i, j)))
+				continue;
+
+			BUG_ON(node(i, j)->key <= search);
+
+			if (last && search + bio_sectors(bio) <= node(i, last)->key)
+				break;
+
+			last = j;
+
+			pr_debug("loop %i of %i page %li level %i key %llu ptr %llu", j,
+				 h->nkeys, i - data, level, node(i, j)->key, node(i, j)->ptr);
+
+			if (level)
+				ret = max(ret, btree_search(c, TREE_PTR_OFFSET(i, j),
+							    level - 1, device, bio, s));
+			else
+				if (search >= node(i, j)->key - TREE_PTR_LENGTH(i, j)) {
+					split = bio_split_front(bio, node(i, j)->key - search);
+					if (!split)
+						goto err;
+
+					split->bi_bdev = c->bdev;
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
+	}
+	label(again,	ret = 0);
+	label(err,	ret = -1);
+	put_bucket(c, root, p);
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
+static int btree_clean(struct cache_device *c, struct page *p[], void *data[])
+{
+	int j, nkeys, n;
+	void **i;
+	struct btree_node_header *h = data[0];
+
+	nkeys = h->nkeys;
+	for (j = 1; j <= nkeys; j++)
+		while (j <= nkeys && ptr_checks(c, node(data, j)))
+			if (j <= --nkeys)
+				*node(data, j) = *node(data, nkeys + 1);
+
+	for (h = data[0], i = data;
+	     i < data + pages_per_btree &&
+	     h->random == ((struct btree_node_header *) data[0])->random;
+	     i += (n / keys_per_page) + 1, h = *i) {
+
+		if (h->nkeys >= (pages_per_btree - (i - data)) * keys_per_page) {
+			pr_debug("bad btree header: page %li h->nkeys %i",
+				 i - data, h->nkeys);
+			h->nkeys = h->random = 0;
+			break;
+		}
+
+		if (data == i)
+			continue;
+
+		n = h->nkeys;
+		for (j = 1; j <= n; j++)
+			if (!ptr_checks(c, node(i, j)))
+				*node(data, ++nkeys) = *node(i, j);
+	}
+	h = data[0];
+	h->nkeys = nkeys;
+
+	for (j = 1; j <= h->nkeys; j++)
+		if (ptr_checks(c, node(data, j)))
+			pr_debug("bad key %i got through! (before sort)", j);
+
+	pr_debug("merged %i keys", h->nkeys);
+	btree_sort(data, h->nkeys);
+
+	for (j = 1; j <= h->nkeys; j++)
+		if (ptr_checks(c, node(data, j)))
+			pr_debug("bad key %i got through!", j);
+
+	for (j = 1; j < h->nkeys; j++)
+		if (node(data, j)->key > node(data, j + 1)->key)
+			pr_debug("bad sort!");
+
+	return 0;
+}
+
+static void btree_write_node(struct cache_device *c, struct page *p[],
+			     int nkeys, int pages)
+{
+	int i, n = (nkeys + 1) / keys_per_page;
+	struct bio *bio;
+
+	BUG_ON(n > pages);
+
+	for (i = 0; i < nkeys / keys_per_page + 1; i++)
+		SetPageDirty(p[i]);
+
+	for (i = 0; i < pages; i++)
+		unlock_page(p[i]);
+
+	if (!n)
+		return;
+
+	bio = bio_kmalloc(GFP_NOIO, n);
+	if (!bio) {
+		pr_debug("couldn't allocate bio!");
+		return;
+	}
+
+	bio->bi_sector = page_index(p[0]) << (PAGE_SHIFT - 9);
+	bio->bi_bdev = c->bdev;
+	bio->bi_size = n * PAGE_SIZE;
+	bio->bi_end_io = btree_write_node_bh;
+	bio->bi_vcnt = n;
+
+	for (i = 0; i < n; i++) {
+		BUG_ON(!p[i]);
+
+		bio->bi_io_vec[i].bv_page = p[i];
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+
+		ClearPageDirty(p[i]);
+		get_page(p[i]);
+	}
+
+	pr_debug("sector %li pages %i", bio->bi_sector, n);
+
+	submit_bio(WRITE, bio);
+}
+
+static void btree_write_node_bh(struct bio *bio, int error)
+{
+	int i;
+	for (i = 0; i > bio->bi_vcnt; i++)
+		put_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+}
+
+static void btree_insert_one_key(void *i[], struct btree_key *k)
+{
+	int j, m;
+	struct btree_node_header *h = i[0];
+
+	m = btree_bsearch(i, h->nkeys, k->key);
+
+	pr_debug("at %i h->nkeys %i key %llu ptr %llu",
+		 m, h->nkeys, k->key, k->ptr);
+
+	for (j = h->nkeys++; j >= m; --j)
+		*node(i, j+1) = *node(i, j);
+
+	*node(i, m) = *k;
+}
+
+static int btree_split(struct cache_device *c, long root, int level,
+		       struct btree_key *new_keys, struct page *p[],
+		       void *data[], int nkeys)
+{
+	int j, ret = 2;
+	uint64_t n1, n2;
+	struct page *p1[pages_per_btree], *p2[pages_per_btree];
+	void *d1[pages_per_btree], *d2[pages_per_btree];
+	struct btree_node_header *h, *h1, *h2;
+
+	if (!trylock_pages(p, pages_per_btree))
+		return -1;
+
+	h = data[0];
+	pr_debug("splitting at level %i sector %lu nkeys %i",
+		 level, root, h->nkeys);
+	btree_clean(c, p, data);
+
+	pr_debug("btree_clean done");
+
+	if (h->nkeys < c->sb.btree_bucket_size * 16) {
+		pr_debug("not splitting: h->nkeys %i", h->nkeys);
+		for (j = 0; j < nkeys; j++)
+			btree_insert_one_key(data, &new_keys[j]);
+
+		if (!(n1 = btree_alloc(c, p1, d1, data, h->nkeys, 0))) {
+			printk(KERN_WARNING "bcache: btree_split: couldn't alloc");
+			goto err;
+		}
+		btree_write_node(c, p1, h->nkeys, pages_per_btree);
+
+		if (c->sb.btree_level == level) {
+			c->sb.btree_root = PTR_OFFSET(n1);
+			write_super(c);
+			pr_debug("new root %lli", c->sb.btree_root);
+			ret = 0;
+		} else {
+			new_keys[0].ptr = n1;
+			new_keys[0].key = node(d1, h->nkeys)->key;
+			ret = 1;
+		}
+		put_bucket(c, PTR_OFFSET(n1), p1);
+		goto out;
+	}
+
+	if (!(n1 = btree_alloc(c, p1, d1, data, h->nkeys >> 1, 0)) ||
+	    !(n2 = btree_alloc(c, p2, d2, data, h->nkeys, h->nkeys >> 1))) {
+		printk(KERN_WARNING "bcache: btree_split: couldn't alloc");
+		goto err;
+	}
+	h1 = d1[0];
+	h2 = d2[0];
+
+	for (j = 0; j < nkeys; j++)
+		if (new_keys[j].key <= node(d1, h1->nkeys)->key)
+			btree_insert_one_key(d1, &new_keys[j]);
+		else
+			btree_insert_one_key(d2, &new_keys[j]);
+
+	new_keys[0].ptr = n1;
+	new_keys[0].key = node(d1, h1->nkeys)->key;
+	new_keys[1].ptr = n2;
+	new_keys[1].key = node(d2, h2->nkeys)->key;
+
+	pr_debug("writing new nodes");
+
+	btree_write_node(c, p1, h1->nkeys, pages_per_btree);
+	btree_write_node(c, p2, h2->nkeys, pages_per_btree);
+	put_bucket(c, PTR_OFFSET(n1), p1);
+	put_bucket(c, PTR_OFFSET(n2), p2);
+
+	if (c->sb.btree_level == level) {
+		if (!(n1 = btree_alloc(c, p1, d1, NULL, 0, 0))) {
+			printk(KERN_WARNING
+			       "bcache: btree_split: couldn't alloc new root");
+			goto err;
+		}
+
+		btree_insert_one_key(d1, &new_keys[0]);
+		btree_insert_one_key(d1, &new_keys[1]);
+		btree_write_node(c, p1, 2, pages_per_btree);
+		c->sb.btree_root = PTR_OFFSET(n1);
+		c->sb.btree_level++;
+		pr_debug("tree depth increases: new root %llu",
+			 c->sb.btree_root);
+
+		put_bucket(c, c->sb.btree_root, p1);
+		write_super(c);
+		ret = 0;
+	}
+
+out:
+	free_bucket(c, root, p);
+	return ret;
+err:
+	if (n1)
+		free_bucket(c, PTR_OFFSET(n1), p1);
+	btree_write_node(c, p, h->nkeys, pages_per_btree);
+	return 0;
+}
+
+static int btree_insert(struct cache_device *c, long root, int level,
+			struct btree_key *new_keys, struct search_context **s)
+{
+	int j, k = 0, nkeys = 1, ret = 0, pagesread;
+	uint64_t biggest;
+	struct page *p[pages_per_btree];
+	void *data[pages_per_btree], **i;
+	struct btree_node_header *h, *g;
+
+	pagesread = get_bucket(c, root, p, data, s);
+	if (pagesread <= 0)
+		return -1 - pagesread;
+
+	g = data[0];
+	if (!g->random) {
+trashed:	while (!trylock_pages(p, pages_per_btree))
+			;
+
+		if (c->sb.btree_level != level) {
+			free_bucket(c, root, p);
+			goto done;
+		} else {
+			printk(KERN_WARNING "bcache: btree was trashed, h->nkeys %i", g->nkeys);
+			free_bucket(c, root, p);
+			put_bucket(c, root, p);
+
+			c->sb.btree_root = root = PTR_OFFSET(btree_alloc(c, p, data, NULL, 0, 0));
+			c->sb.btree_level = level = 0;
+		}
+	}
+
+	if (level) {
+		struct btree_key recurse_key = { .key = 0, .ptr = 0 };
+
+		for_each_sorted_set(i, data, h) {
+			sorted_set_checks();
+
+			for (j = btree_bsearch(i, h->nkeys, new_keys[0].key);
+			     j <= h->nkeys && ptr_checks(c, node(i, j));
+			     j++)
+				;
+
+			if (j > h->nkeys)
+				for (j = h->nkeys; j && ptr_checks(c, node(i, j)); j--)
+					;
+
+			/*
+			 * Pick the smallest key to recurse on that's bigger
+			 * than the key we're inserting, or failing that,
+			 * the biggest key.
+			 */
+			if (j &&
+			    ((node(i, j)->key > recurse_key.key && recurse_key.key < new_keys[0].key) ||
+			     (node(i, j)->key < recurse_key.key && node(i, j)->key > new_keys[0].key)))
+				recurse_key = *node(i, j);
+		}
+		if (!recurse_key.ptr) {
+			pr_debug("no key to recurse on!");
+			goto trashed;
+		}
+
+		nkeys = btree_insert(c, PTR_OFFSET(recurse_key.ptr), level - 1, new_keys, s);
+		if (nkeys == -1)
+			goto again;
+	}
+
+retry:
+	biggest = 0;
+	while (k < nkeys) {
+		for_each_sorted_set(i, data, h) {
+			sorted_set_checks();
+
+			if (h->nkeys)
+				biggest = max(biggest, node(i, h->nkeys)->key);
+
+			if (PageDirty(p[i - data]))
+				break;
+		}
+
+		if (i >= data + pages_per_btree) {
+			ret = btree_split(c, root, level, new_keys, p, data, nkeys);
+			if (ret == -1)
+				goto done;
+			ret = 0;
+			goto retry;
+		}
+
+		if (i >= data + pagesread)
+			goto again;
+
+		if (!trylock_pages(&p[i - data], 1))
+			goto retry;
+
+		if (h->random != g->random) {
+			h->random = g->random;
+			h->nkeys = 0;
+		}
+
+		pr_debug("inserting at %lu level %i page %li h->nkeys %i",
+			 root, level, i - data, h->nkeys);
+
+		for (; k < nkeys && (h->nkeys + 1) % keys_per_page; k++) {
+			btree_insert_one_key(i, &new_keys[k]);
+
+			if (new_keys[k].key > biggest && c->sb.btree_level != level) {
+				new_keys[0].key = new_keys[k].key;
+				new_keys[0].ptr = TREE_PTR(++sector_to_gen(root), 0, root);
+				ret = 1;
+			}
+
+			biggest = max(new_keys[k].key, biggest);
+		}
+
+		btree_write_node(c, &p[i - data], h->nkeys, 1);
+	}
+done:
+	label(again, ret = -1);
+	put_bucket(c, root, p);
+	return ret;
+}
+
+static void btree_insert_async(void *q, struct bio *bio,
+			       struct search_context *s)
+{
+	struct cache_device *c = q;
+
+	if (btree_insert(c, c->sb.btree_root, c->sb.btree_level, s->new_keys, &s) == -1)
+		return_f(s, btree_insert_async);
+	return_f(s, NULL);
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
+		struct search_context t = { .q = c, .clone = true };
+
+		if (c->sectors_free < min_t(int, bio_sectors(bio), PAGE_SIZE >> 9)) {
+			pop_bucket(c);
+
+			t.new_keys[0] = c->current_key;
+			c->current_key = (struct btree_key) {0, 0};
+			if (t.new_keys[0].ptr)
+				btree_insert_async(c, NULL, &t);
+		}
+
+		n = bio_split_front(bio, c->sectors_free);
+		if (!n)
+			goto err;
+
+		n->bi_sector	 = c->current_bucket + c->sb.bucket_size - c->sectors_free;
+		c->sectors_free -= bio_sectors(n);
+		s->bi_sector	+= bio_sectors(n);
+
+		if (c->current_key.ptr &&
+		    c->current_key.key + bio_sectors(n) == TREE_KEY(dev, s->bi_sector)) {
+			c->current_key.key += TREE_KEY(0, bio_sectors(n));
+			c->current_key.ptr += TREE_PTR(0, bio_sectors(n), 0);
+		} else {
+			t.new_keys[0] = c->current_key;
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
+		submit_wait_bio(WRITE, n, c, s, 0);
+	}
+
+err:
+	return_f(s, bio_complete);
+}
+
+static void request_hook_read(void *p, struct bio *bio,
+			      struct search_context *s)
+{
+	int ret = -1;
+	long dev, b;
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
+		ret = max(ret, btree_search(c, c->sb.btree_root,
+					    c->sb.btree_level, dev, bio, &s));
+		if (ret == 1) {
+			struct bio *i;
+			pr_debug("cache hit");
+
+			for (i = bio; i; i = i->bi_next) {
+				b = sector_to_bucket(i->bi_sector);
+				c->buckets[b].priority += cache_hit_priority;
+				heap_insert(c, b);
+				c->cache_hits++;
+				cache_hits++;
+			}
+
+			submit_bio_list(bio);
+			return_f(s, NULL);
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
+	submit_bio_list(bio->bi_next);
+	bio->bi_next = NULL;
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
+	if (bio->bi_size) {
+		if (bio_rw_flagged(bio, BIO_RW))
+			request_hook_write(q, bio, NULL);
+		else
+			request_hook_read(q, bio, NULL);
+		return 0;
+	} else
+		return 1;
+}
+
+#define write_attribute(n)	\
+	static struct attribute sysfs_##n = { .name = #n, .mode = S_IWUSR }
+#define read_attribute(n)	\
+	static struct attribute sysfs_##n = { .name = #n, .mode = S_IRUSR }
+
+#define sysfs_print(file, ...)					\
+	if (attr == &sysfs_ ## file)				\
+		return snprintf(buffer, PAGE_SIZE, __VA_ARGS__)
+
+write_attribute(register_cache);
+write_attribute(register_dev);
+write_attribute(unregister);
+read_attribute(bucket_size);
+read_attribute(buckets_used);
+read_attribute(buckets_free);
+read_attribute(nbuckets);
+read_attribute(cache_hits);
+read_attribute(cache_hit_ratio);
+read_attribute(cache_misses);
+read_attribute(tree_depth);
+
+static void load_priorities(struct cache_device *c)
+{
+	long i, per_page = 4096 / sizeof(struct bucket_disk);
+	struct bucket_disk *b;
+	struct buffer_head *bh;
+
+	for (i = 0; i < c->sb.nbuckets; i++)
+		c->buckets[i].heap = -1;
+	i = 0;
+
+	goto start;
+	for (; i < c->sb.first_free_bucket; i++, b++) {
+		if ((char *) (b + 1) > bh->b_data + 4006) {
+			put_bh(bh);
+start:			bh = __bread(c->bdev, i / per_page + 3, 4096);
+			b = (void *) bh->b_data;
+		}
+
+		c->buckets[i].priority = le16_to_cpu(b->priority);
+		c->buckets[i].generation = b->generation;
+
+		if (c->buckets[i].priority == 0 &&
+		    c->free_front != c->free_back) {
+			c->freelist[c->free_front++] = i;
+			c->free_front &= c->free_size;
+		} else if (c->buckets[i].priority != -1)
+			heap_insert(c, i);
+	}
+	put_bh(bh);
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
+	sysfs_print(buckets_used, "%lli\n", c->sb.first_free_bucket -
+		    c->sb.first_bucket);
+	sysfs_print(buckets_free, "%lli\n", c->sb.nbuckets -
+		    c->sb.first_free_bucket + c->sb.first_bucket);
+	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
+	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
+	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
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
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_bucket_size,
+		&sysfs_buckets_used,
+		&sysfs_buckets_free,
+		&sysfs_nbuckets,
+		&sysfs_cache_hits,
+		&sysfs_tree_depth,
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
+	c->heap		= vmalloc(c->sb.nbuckets * sizeof(long));
+	c->buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket));
+	c->freelist	= vmalloc(c->free_size-- * sizeof(long));
+	if (!c->heap || !c->buckets || !c->freelist)
+		goto err;
+
+	spin_lock_init(&c->heap_lock);
+
+	load_priorities(c);
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
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index a7c540f..75f4933 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -412,7 +412,7 @@ struct os_cookie {
 #define PRINT_MAC(addr)	\
 	addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]
 
-#ifdef DBG
+#if 0
 extern unsigned long RTDebugLevel;
 
 #define DBGPRINT_RAW(Level, Fmt)    \
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

/*
 * make-bcache.c - set up a file/block device as a cache device
 */
#define _XOPEN_SOURCE 500

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

const char bcache_magic[] = { 0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca, 0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };

struct cache_sb {
	uint8_t  magic[16];
	uint32_t version;
	uint16_t block_size;		/* sectors */
	uint16_t bucket_size;		/* sectors */
	uint32_t journal_start;		/* buckets */
	uint32_t first_bucket;		/* start of data */
	uint64_t nbuckets;		/* device size */
	uint64_t first_free_bucket;	/* buckets that have never been used, only increments */
	uint64_t btree_root;
	uint16_t btree_level;
	uint16_t btree_bucket_size;
};

struct bucket_disk {
	uint16_t	priority;
	uint8_t		generation;
} __attribute((packed));

struct btree_node_header {
	uint32_t	csum;
	uint32_t	nkeys;
	uint64_t	random;
};

char zero[4096];

int main(int argc, char **argv)
{
	int ret;
	if (argc < 2) {
		printf("Please supply a device\n");
		return 0;
	}

	int fd = open(argv[1], O_RDWR);
	if (!fd) {
		perror("Can't open dev\n");
		return 0;
	}

	int random = open("/dev/urandom", O_RDONLY);
	if (!random) {
		perror("Can't open urandom\n");
		return 0;
	}

	struct stat statbuf;
	if (fstat(fd, &statbuf)) {
		perror("stat error\n");
		return 0;
	}

	struct cache_sb sb;
	memcpy(sb.magic, bcache_magic, 16);
	sb.version = 0;
	sb.block_size = 8;
	sb.bucket_size = 32;
	sb.nbuckets = statbuf.st_size / (sb.bucket_size * 512);

	do {
		sb.first_bucket = ((--sb.nbuckets * sizeof(struct bucket_disk)) + 4096 * 3)
			/ (sb.bucket_size * 512) + 1;

	} while ((sb.nbuckets + sb.first_bucket) * sb.bucket_size * 512 > statbuf.st_size);

	sb.journal_start = sb.first_bucket;
	sb.first_free_bucket = 1;

	sb.btree_root = sb.first_bucket * sb.bucket_size;
	sb.btree_level = 0;
	sb.btree_bucket_size = 32;

	printf("block_size:		%u\n"
	       "bucket_size:		%u\n"
	       "journal_start:		%u\n"
	       "first_bucket:		%u\n"
	       "nbuckets:		%ju\n"
	       "first_free_bucket:	%ju\n"
	       "btree_bucket_size:	%u\n",
	       sb.block_size,
	       sb.bucket_size,
	       sb.journal_start,
	       sb.first_bucket,
	       sb.nbuckets,
	       sb.first_free_bucket,
	       sb.btree_bucket_size);

	lseek(fd, 4096, SEEK_SET);
	for (int i = 0; i < sb.first_bucket * sb.bucket_size - 8; i++)
		for (int j = 0; j < 512; j += ret)
			if ((ret = write(fd, &zero[0], 512 - j)) < 0)
				goto err;

	if (pwrite(fd, &sb, sizeof(sb), 4096) != sizeof(sb))
		goto err;

	struct bucket_disk b;
	b.priority = ~0;
	b.generation = 1;
	if (pwrite(fd, &b, sizeof(b), 4096 * 3) != sizeof(b))
		goto err;

	struct btree_node_header n = { .nkeys = 0, };
	if (read(random, &n.random, 8) != 8)
		goto err;

	if (pwrite(fd, &n, sizeof(n), sb.btree_root * 512) != sizeof(n))
		goto err;

	return 0;
err:
	perror("write error\n");
}
