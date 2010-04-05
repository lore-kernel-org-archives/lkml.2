Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0DENYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:24:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42102 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0DENXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k3Ud76C4iCkMoPK4qqZ3bHH3OrQBdAHUDEaIiYabZGsFSMEw8xJNZqr1qOuvWk7JAT
         g604zeLR44RcircR642gOkhfX6HdATTWqz9Hp1DS1wnqoFW92vKisiZUpVxVgLYWvfZl
         fya2SFquSkCskZb7cjnnhHvvvgmkZSMaClWEk=
Date: Mon, 5 Apr 2010 05:23:46 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] bcache: cache a block device with an ssd
Message-ID: <20100405132346.GB16527@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
nice if you could use them as cache...

Thus bcache (imaginative name, eh?). It's designed around the
performance characteristics of SSDs - it only allocates in erase block
sized buckets, and it uses a bare minimum btree to track cached extants
(which can be anywhere from a single sector to the bucket size). It's
also designed to be very lazy, and use garbage collection to clean stale
pointers.

The code is very rough and there's a number of things missing before it
can actually be useful (like garbage collection), but I've got it
working with an ext4 filesystem on top and it does successfully cache.
It doesn't yet even look at writes though, so read/write access would
quickly explode.

A goal of mine was that it be possible to add and remove a cache to an
existing block device at runtime; this should make it easier and more
practical to use than were it a stacking block device driver.

To that end, I'm hooking in to __generic_make_request, right before it
passes bios to the elevator. This has a number of implications (not
being able to wait on IO makes things tricky), but it seemed like the
least bad way to do it, at least for now. As far as I can tell the only
behavior that changes is that trace_block_remap gets run again if the
make_request_fn returns nonzero (in that case I just resubmit it via
generic_make_request; if part of the btree wasn't in the page cache I
can't simply return it to __generic_make_request). This obviously
requires more code in __generic_make_request - which I was hoping to
avoid or at least make generic, but hopefully one more conditional won't
get me tarred and feathered... or someone will have a better idea.

(There are definitely races here that I'm not pretending to deal with
yet. I don't think it'll be too bad, though. (There's a lot of locking
that needs to happen and isn't yet...))

As previously implied, cache hits are tracked on a per bucket basis.
Each bucket has a 16 bit priority, and I maintain a heap of all the
buckets by priority. Each bucket also has an 8 bit generation; each
pointer contains the generation of the bucket it points into. If they
don't match, it's a stale pointer. There's a small fifo of free buckets
kept in memory; to refill the fifo, it grabs the bucket with the
smallest priority, increments the generation, issues a BLK_DISCARD
request and sticks it on the end of the fifo. We just have to make sure
we garbage collect the entire btree every so often - that code isn't
written yet, but it just requires a second array (last_gc_generation of
every bucket), a heap of generation - last_gc_generation, and then you
know when you have to gc.

Btree buckets are only completely sorted after they've been garbage
collected; other times, there's multiple sorted sets. When we go to
insert a key, we look for a page that is dirty and not full, and insert
it there sorted into the appropriate location. We write only when a page
fills up, so the SSD doesn't have to do the erase/rewrite thing. Headers
contain a 64 bit random number; when we're looking for an open page in a
btree bucket, it has to match the first page's number or else it's an
empty page.

Devices we cache are referred to by an 8 bit integer, within the btree.
When a device is registered, a UUID is passed in too which is stored in
the superblock. That's done via a sysfs file, currently in
/sys/kernel/bcache (didn't really seem the place, but I couldn't decide
on anything better). I.e., you register a backing device with 'echo
"<uuid> /dev/foo > /sys/kernel/bcache/register_dev', and a cache device
with 'echo /dev/bar > /sys/kernel/bcache/register_cache'. It keeps some
statistics there too, and I plan to flesh that out soon.

On the list are journalling and write behind caching - with multiple
cache devices, it'll be straightforward to mirror writes and drop one
set when it's written to the backing device.

Also on the list - right now I insert items into the cache whenever
they're not found, by saving and replacing bio->bi_end_io, inserting
once the read returns and not returning it as finished until my writes
finish. This has obvious drawbacks, but I don't know under what if any
circumstances I could use those pages after the bio completes. It seems
to me the VM would be in a much better position to know what ought to be
cached, but for just getting something working this seemed easiest.

That's about all I can think of for now, look forward to any
commentary/questions/advice. This is the first kernel programming I've
gotten around to doing, I'm fairly happy with how far it's come in a
month but there are undeniably parts that are painful to look at...

At the bottom is nearly the shortest possible program to initialize a
cache device.

diff --git a/block/Kconfig b/block/Kconfig
index 62a5921..19529ad 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -99,6 +99,10 @@ config DEBUG_BLK_CGROUP
 	in the blk group which can be used by cfq for tracing various
 	group related activity.

+config BLK_CACHE
+	tristate "Block device as cache"
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
index 0000000..47c2bc4
--- /dev/null
+++ b/block/bcache.c
@@ -0,0 +1,1387 @@
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/random.h>
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
+};
+
+struct bucket {
+	uint32_t	heap;
+	uint16_t	priority;
+	uint8_t		generation;
+};
+
+struct bucket_disk {
+	uint16_t	priority;
+	uint8_t		generation;
+};
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
+	struct kobject		kobj;
+	struct list_head	list;
+	struct block_device	*bdev;
+	struct module		*owner;
+
+	long			heap_size;
+	long			*heap;
+	struct bucket		*buckets;
+	struct buffer_head	*priorities;
+
+	long			*freelist;
+	size_t			free_size;
+	size_t			free_front;
+	size_t			free_back;
+
+	struct block_device	*devices[256];
+	struct buffer_head	*uuids;
+
+	long			current_bucket;
+	int			sectors_free;
+};
+
+struct journal_header {
+	uint32_t csum;
+	uint32_t seq;
+	uint32_t last_open_entry;
+	uint32_t nr_entries;
+};
+
+struct search_context {
+	struct work_struct	w;
+	struct btree_key	k;
+	struct bio		*bio;
+	void 			*q;
+	int			error;
+	atomic_t		remaining;
+	struct search_context	*parent;
+	void (*end_fn)(void *, struct bio *, struct search_context *);
+	bio_end_io_t		*end_io;
+	sector_t		bi_sector;
+};
+
+static const char bcache_magic[] = { 0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca, 0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81 };
+
+static struct kobject		*bcache_kobj;
+static struct block_device	*devices[256];
+static char			uuids[PAGE_SIZE];
+
+static LIST_HEAD(cache_devices);
+
+static int request_hook(struct request_queue *q, struct bio *bio);
+static void btree_write_node_bh(struct bio *bio, int error);
+static void bio_insert(void *private, struct bio *bio, struct search_context *s);
+static void request_hook_read(void *p, struct bio *bio, struct search_context *t);
+static void submit_wait_bio(int rw, struct bio *bio, struct cache_device *c, struct search_context *s);
+
+#define pages_per_bucket	(c->sb.bucket_size >> (PAGE_SHIFT - 9))
+#define bucket_to_sector(b)	((uint64_t) ((b) + c->sb.first_bucket) * c->sb.bucket_size)
+#define sector_to_bucket(s)	((long) ((s) / c->sb.bucket_size) - c->sb.first_bucket)
+#define sector_to_gen(s)	c->buckets[sector_to_bucket(s)].generation
+
+/*
+ * 32 keys in a page
+ * key: 8 bit device, 56 bit offset
+ * value: 8 bit generation, 16 bit length, 40 bit offset
+ * All units are in sectors
+ * XXX: Need to take into account PAGE_SIZE...
+ */
+static inline uint64_t *tree_key(void *p[], int i)
+{	return p[i >> 5] + ((i & ~(~0 << 5)) << 7); }
+
+static inline uint64_t *tree_ptr(void *p[], int i)
+{ 	return p[i >> 5] + ((i & ~(~0 << 5)) << 7) + sizeof(uint64_t); }
+
+#define TREE_KEY(device, offset)	(((uint64_t) device) << 56 | (offset))
+#define TREE_KEY_OFFSET(page, i)	(*tree_key(page, i) & ~((uint64_t) ~0 << 56))
+
+#define TREE_PTR(gen, length, offset)	((gen) | (length) << 8 | (offset) << 24)
+#define TREE_PTR_GEN(page, i)		(*tree_ptr(page, i) & ~(~0 << 8))
+#define TREE_PTR_LENGTH(page, i)	((*tree_ptr(page, i) >> 8) & ~(~0 << 16))
+#define TREE_PTR_OFFSET(page, i)	((*tree_ptr(page, i) >> 24))
+/*#define TREE_PTR_BUCKET(page, i)	((*tree_ptr(page, i) >> 24)\
+					 / c->sb.bucket_size - c->sb.first_bucket) */
+
+static int lookup_dev(struct cache_device *c, struct bio *bio)
+{
+	int dev;
+	for (dev = 0; dev < 256 && c->devices[dev] != bio->bi_bdev; dev++)
+		;
+
+	if (dev == 256)
+		printk(KERN_DEBUG "bcache: unknown device\n");
+
+	return dev;
+}
+
+// called by heap location
+static int heap_swap(struct cache_device *c, long i, long j)
+{
+	if (c->buckets[c->heap[i]].priority >= c->buckets[c->heap[j]].priority)
+		return 0;
+
+	c->heap[i] = c->buckets[j].heap;
+	c->heap[j] = c->buckets[i].heap;
+
+	c->buckets[c->heap[i]].heap = i;
+	c->buckets[c->heap[j]].heap = j;
+	return 1;
+}
+
+static void heap_sort(struct cache_device *c, long h)
+{
+	while (h > 0) {
+		uint32_t p = ((h + 1) >> 1) - 1;
+		if (!heap_swap(c, h, p))
+			break;
+
+		h = p;
+	}
+
+	while (1) {
+		uint32_t r = ((h + 1) << 1) + 1;
+		uint32_t l = ((h + 1) << 1);
+
+		if (r < c->heap_size &&
+		    c->buckets[c->heap[r]].priority < c->buckets[c->heap[l]].priority &&
+		    heap_swap(c, h, r))
+			h = r;
+		else if	(l < c->heap_size && heap_swap(c, h, l))
+			h = l;
+		else
+			break;
+	}
+}
+
+static void heap_insert(struct cache_device *c, long b)
+{
+	c->buckets[b].heap = c->heap_size;
+	c->heap[c->heap_size++] = b;
+	heap_sort(c, c->buckets[b].heap);
+}
+
+/*static void heap_remove(struct cache_device *c, long b)
+{
+	long top = c->heap[--c->heap_size];
+
+	c->buckets[top].heap = c->buckets[b].heap;
+	c->heap[c->buckets[b].heap] = b;
+	heap_sort(c, c->buckets[b].heap);
+}*/
+
+static long heap_pop(struct cache_device *c)
+{
+	long ret, top;
+	ret = c->heap[0];
+	top = c->heap[--c->heap_size];
+
+	c->buckets[top].heap = 0;
+	c->heap[0] = top;
+	heap_sort(c, c->buckets[0].heap);
+
+	c->buckets[ret].priority = 0;
+	return ret;
+}
+
+static long __pop_bucket(struct cache_device *c)
+{
+	long r;
+	int free = c->free_front - c->free_back;
+
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
+		c->freelist[c->free_front++] = r;
+		c->free_front &= c->free_size;
+
+		blkdev_issue_discard(c->bdev, bucket_to_sector(r),
+				     c->sb.bucket_size, GFP_NOIO, 0);
+	}
+
+	r = c->freelist[c->free_back++];
+	c->free_back &= c->free_size;
+
+	return r;
+}
+
+static void pop_bucket(struct cache_device *c)
+{
+	c->sectors_free = c->sb.bucket_size;
+	c->current_bucket = bucket_to_sector(__pop_bucket(c));
+}
+
+static uint64_t alloc_bucket(struct cache_device *c, struct page *p[], void *data[])
+{
+	int i;
+	long b = __pop_bucket(c);
+
+	for (i = 0; i < pages_per_bucket; i++) {
+		p[i] = find_or_create_page(c->bdev->bd_inode->i_mapping,
+					   bucket_to_sector(b) + (i << 3), GFP_NOIO);
+		data[i] = kmap(p[i]);	
+	}
+	// page is locked...
+
+	return TREE_PTR(c->buckets[b].generation, 0, bucket_to_sector(b));
+}
+
+static void free_bucket(struct cache_device *c, uint64_t offset, struct page *p[])
+{
+	long b = sector_to_bucket(offset);
+	struct address_space *mapping = p[0]->mapping;
+
+	BUG_ON(!c);
+
+	c->buckets[b].generation++;
+
+	spin_lock_irq(&mapping->tree_lock);
+	/*for (i = 0; i < pages; i++)
+		__remove_from_page_cache(p[i]);*/
+	spin_unlock_irq(&mapping->tree_lock);
+
+	blkdev_issue_discard(c->bdev, bucket_to_sector(b),
+			     c->sb.bucket_size, GFP_NOIO, 0);
+	c->freelist[c->free_front++] = b;
+	c->free_front &= c->free_size;
+}
+
+static int get_bucket(struct cache_device *c, uint64_t offset, struct page *p[], void *data[], struct search_context **s)
+{
+	int i, nvecs, ret = 0;
+	struct bio *bio = NULL;
+
+	memset(&p[0], 0, pages_per_bucket * sizeof(void*));
+
+	if (sector_to_bucket(offset) >= c->sb.nbuckets) {
+		printk(KERN_DEBUG "bcache: bad bucket number\n");
+		return 0;
+	}
+
+	offset >>= PAGE_SHIFT - 9;
+
+	nvecs = find_get_pages(c->bdev->bd_inode->i_mapping, offset, pages_per_bucket, p);
+
+	if (nvecs != pages_per_bucket && *s == NULL) {
+		printk(KERN_DEBUG "bcache: Making a search context\n");
+		*s = kzalloc(sizeof(struct search_context), GFP_NOIO);
+		atomic_set(&(*s)->remaining, 0);
+	}
+
+	for (i = 0; i < pages_per_bucket; i++)
+		if (!p[i]) {
+			p[i] = __page_cache_alloc(GFP_NOIO);
+			p[i]->mapping = c->bdev->bd_inode->i_mapping;
+			if (add_to_page_cache_lru(p[i],
+					      c->bdev->bd_inode->i_mapping,
+					      offset + i,
+					      GFP_NOIO & GFP_RECLAIM_MASK)) {
+				__free_pages(p[i], 0);
+				goto wait;
+			}
+
+			if (!bio) {
+				bio = bio_kmalloc(GFP_NOIO, pages_per_bucket - nvecs);
+				bio->bi_sector = (offset + i) << (PAGE_SHIFT - 9);
+			}
+			++nvecs;
+
+			bio->bi_io_vec[bio->bi_vcnt].bv_len = PAGE_SIZE;
+			bio->bi_io_vec[bio->bi_vcnt].bv_offset = 0;
+			bio->bi_io_vec[bio->bi_vcnt].bv_page = p[i];
+			bio->bi_vcnt++;
+			bio->bi_size += PAGE_SIZE;
+		} else {
+wait:			wait_on_page_locked(p[i]);
+
+			if (bio)
+				submit_wait_bio(READ, bio, c, *s);
+			bio = NULL;
+			if (i == ret)
+				ret++;
+
+			data[i] = kmap(p[i]);
+		}
+
+	if (bio)
+		submit_wait_bio(READ, bio, c, *s);
+
+	//printk(KERN_DEBUG "bcache: get_bucket() return %i\n", ret);
+	return ret;
+}
+
+static void put_bucket(struct cache_device *c, long offset, struct page *p[])
+{
+	int i;
+	for (i = 0; i < pages_per_bucket; i++)
+		if (p[i]) {
+			kunmap(p[i]);
+			put_page(p[i]);
+		}
+}
+
+static void bio_run_work(struct work_struct *w)
+{
+	struct search_context *s = container_of(w, struct search_context, w);
+	s->end_fn(s->q, s->bio, s);
+	if (atomic_read(&s->remaining) == 0) {
+		if (s->parent)
+			if (atomic_dec_and_test(&s->parent->remaining))
+				bio_run_work(&s->parent->w);
+
+		kfree(s);
+	}
+}
+
+static void bio_add_work(struct bio *bio, int error)
+{
+	int i;
+	struct search_context *s = bio->bi_private;
+
+	if (s->end_fn == request_hook_read)
+		for (i = 0; i < bio->bi_vcnt; i++)
+			unlock_page(bio->bi_io_vec[i].bv_page);
+
+	bio_put(bio);
+
+	if (atomic_dec_and_test(&s->remaining)) {
+		if (!s->end_fn && s->bio) {
+			s->bio->bi_end_io(s->bio, 0);
+			bio_put(s->bio);
+			kfree(s);
+		} else if (s->q) {
+			s->error = error;
+			INIT_WORK(&s->w, bio_run_work);
+			schedule_work(&s->w);
+		} else {
+			if (s->parent)
+				if (atomic_dec_and_test(&s->parent->remaining)) {
+					INIT_WORK(&s->parent->w, bio_run_work);
+					schedule_work(&s->parent->w);
+				}
+			kfree(s);
+		}
+	}
+}
+
+static void submit_wait_bio(int rw, struct bio *bio, struct cache_device *c, struct search_context *s)
+{
+	BUG_ON(!bio->bi_vcnt);
+	bio->bi_bdev = c->bdev;
+	bio->bi_private = s;
+	if (!bio->bi_end_io)
+		bio->bi_end_io = bio_add_work;
+
+	atomic_inc(&s->remaining);
+	submit_bio(rw, bio);
+}
+
+static int btree_bsearch(void *data[], int nkeys, uint64_t search)
+{
+	int l = 1, r = nkeys + 1;
+
+	while (l < r) {
+		int m = (l + r) >> 1;
+		if (*tree_key(data, m) < search)
+			l = m + 1;
+		else
+			r = m;
+	}
+
+	return l;
+}
+
+static int node_compare(const void *l, const void *r)
+{
+	const struct btree_key *a = l, *b = r;
+	return a->key - b->key;
+}
+
+static bool ptr_checks(struct cache_device *c, uint64_t p)
+{
+	if (sector_to_bucket(p >> 24) < 0 ||
+	    sector_to_bucket(p >> 24) > c->sb.nbuckets ||
+	    ((p >> 8) & ~(~0 << 16)) > c->sb.bucket_size)
+		return true;
+	return false;
+}
+
+static int btree_clean(struct cache_device *c, struct page *p[])
+{
+	int l;
+	void *v;
+	struct btree_node_header *h, *i, *j;
+	struct btree_key *k;
+
+	k = v = vmap(p, pages_per_bucket, VM_MAP, PAGE_KERNEL);
+	if (!v) {
+		printk(KERN_DEBUG "bcache: vmap() error\n");
+		return 1;
+	}
+
+	while (1) {
+		for (h = i = j = v;
+		     (void*) j < v + PAGE_SIZE * pages_per_bucket;
+		     j = (void*) h + PAGE_SIZE * ((h->nkeys >> 5) + 1)) {
+			if (i->random != j->random)
+				break;
+			h = i;
+			i = j;
+		}
+		if (h == i)
+			break;
+
+		memmove(h + h->nkeys, i + 1, i->nkeys * sizeof(struct btree_node_header));
+		h->nkeys += i->nkeys;
+	}
+
+	for (l = 1; l <= h->nkeys; l++) {
+		if (ptr_checks(c, k[l].ptr)) {
+			printk(KERN_DEBUG "bcache: btree_clean removed bad ptr\n");
+			k[l].key = ~0;
+			continue;
+		}
+
+		if ((k[l].ptr & ~(~0 << 8)) != sector_to_gen(k[l].ptr >> 24))
+			k[l].key = ~0;
+	}
+
+	sort(&k[1], h->nkeys, sizeof(struct btree_key), node_compare, NULL);
+
+	for (; k[h->nkeys].key == ~0; h->nkeys--)
+		;
+
+	vunmap(v);
+	return 0;
+}
+
+// Iterate over the sorted sets of pages
+#define for_each_sorted_set(i, data, h, random)				\
+	for (h = data[0], i = data;					\
+	     i < data + pages_per_bucket &&				\
+	     h->random == ((struct btree_node_header*) data[0])->random;\
+	     i += (h->nkeys >> 5) + 1, h = *i)
+
+#define sorted_set_checks()							\
+	do {									\
+		if (h->nkeys + 1 > (pages_per_bucket - (i - data)) * 32) {	\
+			printk(KERN_DEBUG					\
+			       "bcache: Bad btree header: page %li h->nkeys %i\n",\
+			       i - data, h->nkeys);				\
+			if (i == data)						\
+				h->nkeys = 0;					\
+			else							\
+				h->random = 0;					\
+			break;							\
+		}								\
+		if (h->nkeys + 1 > (pagesread - (i - data)) * 32) {		\
+			ret = -1;						\
+			goto out;						\
+		}								\
+	} while (0)
+
+static int btree_search(struct cache_device *c, long root, int level, int device, struct bio *bio, struct search_context **s)
+{
+	int r, ret = 0, j, pagesread;
+	uint64_t search;
+	struct page *p[pages_per_bucket];
+	void *data[pages_per_bucket], **i;
+	struct btree_node_header *h;
+
+	if ((pagesread = get_bucket(c, root, p, data, s)) <= 0)
+		return -1 - pagesread;
+
+	search = TREE_KEY(device, bio->bi_sector);
+
+	for_each_sorted_set(i, data, h, random) {
+		sorted_set_checks();
+
+		for (j = btree_bsearch(i, h->nkeys, search);
+		     search < *tree_key(i, j) + (c->sb.bucket_size << 8) &&
+			     j <= h->nkeys;
+		     j++)
+			if (level) {
+				r = btree_search(c, TREE_PTR_OFFSET(i, j), level - 1, device, bio, s);
+				ret = r == 1 ? 1 : min(r, ret);
+			} else {
+				printk(KERN_DEBUG "bcache: btree_search() j %i key %llu ptr %llu", j,
+				       *tree_key(i, j), *tree_ptr(i, j));
+
+				if (ptr_checks(c, *tree_ptr(i, j))) {
+					printk(KERN_DEBUG "bad ptr\n");
+					continue;
+				}
+				if (TREE_PTR_GEN(i, j) != sector_to_gen(TREE_PTR_OFFSET(i, j))) {
+					printk(KERN_DEBUG "bad gen\n");
+					continue;
+				}
+				if (search > *tree_key(i, j) + TREE_PTR_LENGTH(i, j)) {
+					printk(KERN_DEBUG "early block \n");
+					continue;
+				}
+				if (search + bio_sectors(bio) < *tree_key(i, j)) {
+					printk(KERN_DEBUG "late block\n");
+					continue;
+				}
+
+				if (bio->bi_sector >= TREE_KEY_OFFSET(i, j) &&
+				    bio->bi_sector + bio_sectors(bio) <=
+				    TREE_KEY_OFFSET(i, j) + TREE_PTR_LENGTH(i, j)) {
+					// all the data we need is here
+					bio->bi_sector = TREE_PTR_OFFSET(i, j) + (bio->bi_sector - TREE_KEY_OFFSET(i, j));
+					bio->bi_bdev = c->bdev;
+					ret = 1;
+					goto out;
+				} else {
+					// got some, need more...
+				}
+			}
+	}
+out:
+	put_bucket(c, root, p);
+	return ret;
+}
+
+static void btree_write_node(struct cache_device *c, struct page *p[], int nkeys, int pages)
+{
+	int i, n = (nkeys >> 5) + 1;
+	struct bio *bio;
+
+	bio = bio_kmalloc(GFP_NOIO, n);
+
+	bio->bi_sector = page_index(p[0]) >> 3;
+	bio->bi_bdev = c->bdev;
+	bio->bi_size = n * PAGE_SIZE;
+	bio->bi_end_io = btree_write_node_bh;
+
+	bio->bi_vcnt = n;
+	for (i = 0; i < n; i++) {
+		bio->bi_io_vec[i].bv_page = p[i];
+		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[i].bv_offset = 0;
+
+		ClearPageDirty(p[i]);
+		get_page(p[i]);
+		unlock_page(p[i]);
+	}
+
+	for (; i < pages; i++)
+		unlock_page(p[i]);
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
+	printk(KERN_DEBUG "btree_insert() at %i h->nkeys %i key %llu ptr %llu\n", m, h->nkeys, k->key, k->ptr);
+
+	for (j = h->nkeys++; j >= m; --j)
+		memcpy(tree_key(i, j + 1), tree_key(i, j), sizeof(struct btree_key));
+
+	memcpy(tree_key(i, m), k, sizeof(struct btree_key));
+}
+
+static int btree_split(struct cache_device *c, long root, int level, struct btree_key *k, struct btree_key *new_keys,
+		       struct page *p[], void *data[], int nkeys)
+{
+	int j, ret;
+	struct page *p1[pages_per_bucket], *p2[pages_per_bucket];
+	void *d1[pages_per_bucket], *d2[pages_per_bucket];
+	struct btree_node_header *h, *h1, *h2;
+	struct btree_key t[2];
+
+	for (j = 0; j < pages_per_bucket; j++)
+		if (!trylock_page(p[j])) {
+			wait_on_page_locked(p[j]);
+
+			for (--j; j >= 0; --j)
+				unlock_page(p[j]);
+
+			return -1;
+		}
+
+	btree_clean(c, p);
+	h = data[0];
+
+	t[1].key = *tree_key(data, h->nkeys >> 1);
+	t[0].key = *tree_key(data, h->nkeys);
+	t[1].ptr = alloc_bucket(c, p1, d1);
+	t[0].ptr = alloc_bucket(c, p2, d2);
+	h1 = *d1;
+	h2 = *d2;
+
+	get_random_bytes(&h1->random, sizeof(uint64_t));
+	get_random_bytes(&h2->random, sizeof(uint64_t));
+	h1->nkeys = h->nkeys >> 1;
+	h2->nkeys = h->nkeys - h1->nkeys;
+
+	for (j = 1; j <= h1->nkeys; j++)
+		memcpy(tree_key(d1, j), tree_key(data, j), sizeof(struct btree_key));
+	for (j = 1; j <= h2->nkeys; j++)
+		memcpy(tree_key(d2, j), tree_key(data, j + h1->nkeys), sizeof(struct btree_key));
+
+	for (; nkeys > 0; --nkeys, ++k)
+		if (k->key < *tree_key(d1, h1->nkeys))
+			btree_insert_one_key(d1, k);
+		else
+			btree_insert_one_key(d2, k);
+
+	btree_write_node(c, p1, h1->nkeys, pages_per_bucket);
+	btree_write_node(c, p2, h2->nkeys, pages_per_bucket);
+	put_bucket(c, t[1].ptr, p1);
+	put_bucket(c, t[0].ptr, p2);
+	free_bucket(c, root, p);
+	
+	// move this into free_bucket?
+	for (j = 0; j < pages_per_bucket; j++)
+		unlock_page(p[j]);
+
+	if (c->sb.btree_level == level) {
+		// tree depth increases
+		c->sb.btree_root = alloc_bucket(c, p, data);
+		c->sb.btree_level++;
+		h = data[0];
+		get_random_bytes(&h->random, sizeof(uint64_t));
+		h->nkeys = 2;
+		memcpy(tree_key(data, 1), &t[0], sizeof(struct btree_key)); //eh? wrong
+		memcpy(tree_key(data, 2), &t[1], sizeof(struct btree_key));
+		btree_write_node(c, p, h->nkeys, pages_per_bucket);
+		ret = 0;
+	} else
+		ret = 2;
+
+	memcpy(&new_keys[0], &t[0], sizeof(struct btree_key) * 2);
+	return ret;
+}
+
+static int btree_insert(struct cache_device *c, long root, int level, struct btree_key *k, struct btree_key *new_keys, struct search_context **s)
+{
+	int j, nkeys = 1, ret = 0, pagesread;
+	uint64_t biggest_key = 0;
+	struct page *p[pages_per_bucket];
+	void *data[pages_per_bucket], **i;
+	struct btree_node_header *h;
+	struct btree_key recurse_key = { .key = ~0, .ptr = 0};
+
+	if ((pagesread = get_bucket(c, root, p, data, s)) <= 0)
+		return -1 - pagesread;
+
+	if (level) {
+		for_each_sorted_set(i, data, h, random) {
+			sorted_set_checks();
+
+			j = btree_bsearch(i, h->nkeys, k->key);
+
+			while (TREE_PTR_GEN(i, j) != sector_to_gen(TREE_PTR_OFFSET(i, j)))
+				if (++j > h->nkeys)
+					continue;
+
+			if (*tree_key(i, j) < recurse_key.key)
+				memcpy(&recurse_key, tree_key(i, j), sizeof(struct btree_key));
+		}
+
+		BUG_ON(recurse_key.key == ~0);
+
+		if ((nkeys = btree_insert(c, recurse_key.ptr >> 24, level - 1, k, new_keys, s)) == -1)
+			goto out;
+		k = new_keys;
+	}
+
+retry:
+	biggest_key = 0;
+	for (; nkeys > 0; --nkeys, ++k) {
+		for_each_sorted_set(i, data, h, random) {
+			sorted_set_checks();
+
+			biggest_key = max(biggest_key, *tree_key(i, h->nkeys));
+
+			if (PageDirty(p[i - data]) && h->nkeys < 32)
+				goto insert;
+		}
+		if (pagesread != pages_per_bucket) {
+			ret = -1;
+			goto out;
+		}
+		if (i == data + pages_per_bucket) {
+			printk(KERN_DEBUG "bcache: btree_insert() splitting\n");
+			if ((ret = btree_split(c, root, level, k, new_keys, p, data, nkeys)) == -1) {
+				ret = 0;
+				goto retry;
+			}
+			goto out;
+		}
+insert:
+		if (!trylock_page(p[i - data])) {
+			wait_on_page_locked(p[i - data]);
+			goto retry;
+		}
+		SetPageDirty(p[i - data]);
+
+		if (h->random != ((struct btree_node_header*) data[0])->random) {
+			h->random = ((struct btree_node_header*) data[0])->random;
+			h->nkeys = 0;
+		}
+
+		for (; nkeys && h->nkeys < 31; --nkeys, ++k) {
+			btree_insert_one_key(i, k);
+
+			if (k->key > biggest_key && c->sb.btree_level != level) {
+				new_keys[0].key = k->key;
+				new_keys[0].ptr = TREE_PTR(++sector_to_gen(root), 0, root);
+				ret = 1;
+			}
+
+			biggest_key = max(k->key, biggest_key);
+		}
+
+		if (h->nkeys == 31)
+			btree_write_node(c, &p[i - data], h->nkeys, 0);
+		else
+			unlock_page(p[i - data]);
+	}
+out:
+	put_bucket(c, root, p);
+	return ret;
+}
+
+static void bio_insert_finish(void *q, struct bio *bio, struct search_context *s)
+{
+	struct cache_device *c = q;
+	struct btree_key new_keys[2];
+
+	btree_insert(c, c->sb.btree_root, c->sb.btree_level, &s->k, new_keys, &s);
+}
+
+static void bio_insert(void *private, struct bio *bio, struct search_context *s)
+{
+	int dev, written = 0;
+	struct cache_device *c;
+	struct btree_key k, new_keys[2];
+	struct bio *n;
+	struct search_context *t = NULL;
+
+	s->end_fn = NULL;
+	bio->bi_end_io = s->end_io;
+	bio->bi_private = private;
+	bio->bi_sector = s->bi_sector;
+
+	if (s->error || list_empty(&cache_devices))
+		goto err;
+
+	list_rotate_left(&cache_devices);
+	c = list_first_entry(&cache_devices, struct cache_device, list);
+
+	if ((dev = lookup_dev(c, bio)) == 256)
+		goto err;
+
+	for (bio->bi_idx = bio->bi_size = 0; bio->bi_idx < bio->bi_vcnt; bio->bi_idx++)
+		bio->bi_size += bio->bi_io_vec[bio->bi_idx].bv_len;
+
+	for (bio->bi_idx = 0; bio->bi_idx < bio->bi_vcnt; ) {
+		if (c->sectors_free < min_t(unsigned, bio_sectors(bio), PAGE_SIZE >> 9))
+			pop_bucket(c);
+
+		if (!(n = bio_kmalloc(GFP_NOIO, 0)))
+			goto err;
+
+		n->bi_sector	= c->current_bucket + c->sb.bucket_size - c->sectors_free;
+		n->bi_size	= bio->bi_size;
+		n->bi_vcnt	= bio->bi_vcnt	 - bio->bi_idx;
+		n->bi_io_vec	= bio->bi_io_vec + bio->bi_idx;
+
+		while (bio_sectors(n) > c->sectors_free)
+			n->bi_size -= n->bi_io_vec[--n->bi_vcnt].bv_len;
+
+		n->bi_max_vecs	 = n->bi_vcnt;
+		bio->bi_idx	+= n->bi_vcnt;
+		bio->bi_size	-= n->bi_size;
+
+		k.key = TREE_KEY(dev, bio->bi_sector + written);
+		k.ptr = TREE_PTR(sector_to_gen(c->current_bucket), bio_sectors(n), n->bi_sector);
+
+		bio->bi_size	-= n->bi_size;
+		written		+= bio_sectors(n);
+		c->sectors_free -= bio_sectors(n);
+
+		submit_wait_bio(WRITE, n, c, s);
+
+		if (btree_insert(c, c->sb.btree_root, c->sb.btree_level, &k, new_keys, &t) == -1) {
+			t->q = c;
+			t->end_fn = bio_insert_finish;
+			memcpy(&s->k, &k, sizeof(struct btree_key));
+		}
+		t = NULL;
+	}
+
+	bio->bi_size = written << 9;
+	bio->bi_idx = 0;
+	return;
+err:
+	if (!atomic_read(&s->remaining)) {
+		bio->bi_end_io(bio, s->error);
+		bio_put(bio);
+	}
+}
+
+static void request_hook_read(void *p, struct bio *bio, struct search_context *s)
+{
+	struct list_head *l;
+	struct request_queue *q = p;
+
+	if (list_empty(&cache_devices))
+		goto out;
+
+	list_for_each(l, &cache_devices) {
+		int dev;
+		struct cache_device *c = list_entry(l, struct cache_device, list);
+
+		if ((dev = lookup_dev(c, bio)) == 256)
+			continue;
+
+		if (btree_search(c, c->sb.btree_root, c->sb.btree_level, dev, bio, &s) == 1) {
+			printk(KERN_DEBUG "bcache: cache hit\n");
+			generic_make_request(bio);
+			return;
+		}
+	}
+
+	if (s && atomic_read(&s->remaining)) {
+		s->bio = bio;
+		s->q = q;
+		s->end_fn = request_hook_read;
+		return;
+	}
+
+	if (!s)
+		s = kzalloc(sizeof(struct search_context), GFP_NOIO);
+
+	printk(KERN_DEBUG "bcache: cache miss, starting write\n");
+	atomic_set(&s->remaining, 1);
+	s->bio = bio;
+	s->q = bio->bi_private;
+	s->end_fn = bio_insert;
+	s->end_io = bio->bi_end_io;
+	s->bi_sector = bio->bi_sector;
+
+	bio->bi_private = s;
+	bio->bi_end_io = bio_add_work;
+	bio_get(bio);
+	bio_get(bio);
+
+out:
+	if (q->make_request_fn(q, bio))
+		generic_make_request(bio);
+}
+
+static void request_hook_write(struct request_queue *q, struct bio *bio, struct search_context *s)
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
+#define write_attribute(n)	static struct attribute sysfs_##n = { .name = #n, .mode = S_IWUSR }
+#define read_attribute(n)	static struct attribute sysfs_##n = { .name = #n, .mode = S_IRUSR }
+
+write_attribute(register_cache);
+write_attribute(register_dev);
+write_attribute(unregister);
+read_attribute(bucket_size);
+read_attribute(buckets_used);
+read_attribute(buckets_free);
+read_attribute(nbuckets);
+
+static void load_priorities(struct cache_device *c)
+{
+	uint32_t i = 0, per_page = PAGE_SIZE / sizeof(struct bucket_disk);
+	struct bucket_disk *b;
+	struct buffer_head *bh;
+	goto start;
+
+	for (; i < c->sb.first_free_bucket; i++, b++) {
+		if ((char*) (b + 1) > bh->b_data + PAGE_SIZE) {
+			put_bh(bh);
+start:			bh = __bread(c->bdev, i / per_page + 3, PAGE_SIZE);
+			b = (void*) bh->b_data;
+		}
+
+		c->buckets[i].priority = le16_to_cpu(b->priority);
+		c->buckets[i].generation = b->generation;
+
+		if (c->buckets[i].priority == 0 &&
+		    c->free_front != c->free_back) {
+			c->freelist[c->free_front++] = i;
+			c->free_front &= c->free_size;
+		} else if (c->buckets[i].priority != ~0)
+			heap_insert(c, i);
+	}
+	put_bh(bh);
+}
+
+static void save_priorities(struct cache_device *c)
+{
+	uint32_t i = 0, per_page = PAGE_SIZE / sizeof(struct bucket_disk);
+	struct bucket_disk *b;
+	struct buffer_head *bhv[(c->sb.nbuckets - 1) / per_page + 1], *bh = bhv[0];
+	goto start;
+
+	for (; i < c->sb.nbuckets; i++, b++) {
+		if ((char*) (b + 1) > bh->b_data + PAGE_SIZE) {
+			submit_bh(WRITE, bh++);
+start:			bh = __getblk(c->bdev, (i / per_page + 3), PAGE_SIZE);
+			b = (void*) bh->b_data;
+		}
+
+		b->priority = cpu_to_le16(c->buckets[i].priority);
+		b->generation = c->buckets[i].generation;
+	}
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
+	int i, j;
+
+	c->uuids = __bread(c->bdev, 2, PAGE_SIZE);
+
+	if (!devices[d]) {
+		printk(KERN_DEBUG "bcache: Tried to register nonexistant device/queue\n");
+		return;
+	}
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 16; j++)
+			if (c->uuids->b_data[i*16 + j])
+				break;
+
+		if (j == 16) {
+			printk(KERN_DEBUG "Inserted new uuid\n");
+			memcpy(c->uuids->b_data + i*16, &uuids[d*16], 16);
+			set_buffer_dirty(c->uuids);
+			break;
+		}
+
+		if    (!memcmp(c->uuids->b_data + i*16, &uuids[d*16], 16)) {
+			printk(KERN_DEBUG "Looked up uuid\n");
+			break;
+		}
+	}
+	put_bh(c->uuids);
+
+	if (i == 256) {
+		printk(KERN_DEBUG "Aiee! No room for the uuid\n");
+		return;
+	}
+
+	c->devices[i] = devices[d];
+}
+
+static int parse_uuid(const char *s, char *uuid)
+{
+	int i, j, x;
+	memset(uuid, 0, 16);
+
+	//for (i = 0, j = 0; i < strspn(s, "-0123456789:ABCDEFabcdef") && j < 32; i++) {
+	for (i = 0, j = 0; s[i] && j < 32; i++) {
+		x = s[i] | 32;
+
+		if (x == ':' || x == '-')
+			continue;
+
+		if (x > 'f' || x < '0')
+			return i;
+
+		if	(x <= '9')
+			x -= '0';
+		else if (x >= 'a')
+			x -= 'a' - 10;
+		else
+			return i;
+
+		x <<=  ((j & 1) << 2);
+		uuid[j++ >> 1] |= x;
+	}
+	return i;
+}
+
+static void register_dev(const char *buffer, size_t size)
+{
+	int i, j;
+	char *path;
+	unsigned char uuid[16];
+	struct block_device *bdev;
+	struct list_head *l;
+
+	i = parse_uuid(buffer, &uuid[0]);
+
+	if (i < 4) {
+		printk(KERN_DEBUG "bcache: Bad uuid\n");
+		return;
+	}
+
+	path = kmalloc(size + 1 - i, GFP_KERNEL);
+	if (!path) {
+		printk(KERN_DEBUG "bcache: kmalloc error\n");
+		return;
+	}
+	strcpy(path, skip_spaces(buffer + i));
+	bdev = lookup_bdev(strim(path));
+
+	if (IS_ERR(bdev)) {
+		printk(KERN_DEBUG "bcache: Failed to open %s\n", path);
+		kfree(path);
+		return;
+	}
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 16; j++)
+			if (uuids[i*16 + j])
+				break;
+
+		if (j == 16)
+			break;
+
+		if (!memcmp(&uuids[i*16], uuid, 16)) {
+			printk(KERN_DEBUG "bcache: %s already registered\n", path);
+			kfree(path);
+			return;
+		}
+	}
+	memcpy(&uuids[i*16], uuid, 16);
+	devices[i] = bdev;
+
+	list_for_each(l, &cache_devices)
+		register_dev_on_cache(list_entry(l, struct cache_device, list), i);
+
+	bdev->bd_cache_fn = request_hook;
+	printk(KERN_DEBUG "bcache: Caching %s\n", path);
+	kfree(path);
+}
+
+static ssize_t store_cache(struct kobject *kobj, struct attribute *attr, const char *buffer, size_t size)
+{
+	if (attr == &sysfs_unregister) {
+		// kobject_put(kobj);
+	}
+	return size;
+}
+
+static ssize_t show_cache(struct kobject *kobj, struct attribute *attr, char *buffer)
+{
+	struct cache_device *c = container_of(kobj, struct cache_device, kobj);
+	if (attr == &sysfs_bucket_size)
+		return snprintf(buffer, PAGE_SIZE, "%i\n", c->sb.bucket_size * 512);
+	if (attr == &sysfs_buckets_used)
+		return snprintf(buffer, PAGE_SIZE, "%lli\n", c->sb.first_free_bucket - c->sb.first_bucket);
+	if (attr == &sysfs_buckets_free)
+		return snprintf(buffer, PAGE_SIZE, "%lli\n", c->sb.nbuckets - c->sb.first_free_bucket + c->sb.first_bucket);
+	if (attr == &sysfs_nbuckets)
+		return snprintf(buffer, PAGE_SIZE, "%lli\n", c->sb.nbuckets);
+	return 0;
+}
+
+static void unregister_cache(struct kobject *k)
+{
+	struct cache_sb *s;
+	struct cache_device *c = container_of(k, struct cache_device, kobj);
+	struct buffer_head *bh = __getblk(c->bdev, 1, PAGE_SIZE);
+
+	list_del(&c->list);
+
+	save_priorities(c);
+	put_bh(c->uuids);
+	vfree(c->buckets);
+	vfree(c->heap);
+
+	s = (struct cache_sb*) bh->b_data;
+	s->version =		cpu_to_le32(c->sb.version);
+	s->block_size =		cpu_to_le16(c->sb.block_size);
+	s->bucket_size =	cpu_to_le16(c->sb.bucket_size);
+	s->journal_start =	cpu_to_le32(c->sb.journal_start);
+	s->first_bucket =	cpu_to_le32(c->sb.first_bucket);
+	s->nbuckets =		cpu_to_le64(c->sb.nbuckets);
+	s->first_free_bucket =	cpu_to_le64(c->sb.first_free_bucket);
+	s->btree_root = 	cpu_to_le64(c->sb.btree_root);
+	s->btree_level =	cpu_to_le16(c->sb.btree_level);
+
+	submit_bh(WRITE, bh);
+	put_bh(bh);
+
+	close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
+	module_put(c->owner);
+	kfree(c);
+}
+
+static void register_cache(const char *buffer, size_t size)
+{
+	char *err = NULL, *path, b[BDEVNAME_SIZE];
+	int i;
+	struct buffer_head *bh = NULL;
+	struct block_device *bdev;
+	struct cache_sb *s;
+	struct cache_device *c;
+	struct page *p;
+
+	static struct attribute *files[] = {
+		&sysfs_unregister,
+		&sysfs_bucket_size,
+		&sysfs_buckets_used,
+		&sysfs_buckets_free,
+		&sysfs_nbuckets,
+		NULL
+	};
+	const static struct sysfs_ops ops = {
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
+	bdev = open_bdev_exclusive(strim(path), FMODE_READ|FMODE_WRITE, NULL);
+	if (IS_ERR(bdev)) {
+		err = "Failed to open cache device";
+		goto err_no_alloc;
+	}
+	set_blocksize(bdev, PAGE_SIZE);
+
+	p = read_mapping_page_async(bdev->bd_inode->i_mapping, 1, NULL);
+
+	bh = __bread(bdev, 1, PAGE_SIZE);
+	err = "IO error";
+	if (!bh)
+		goto err_no_alloc;
+	s = (struct cache_sb*) bh->b_data;
+
+	err = "Insufficient memory";
+	if (!(c = kzalloc(sizeof(struct cache_device), GFP_KERNEL)))
+		goto err_no_alloc;
+
+	err = "IO error";
+	c->uuids = __bread(bdev, 2, PAGE_SIZE);
+	if (!c->uuids)
+		goto err;
+
+	err = "Not a bcache superblock";
+	if (memcmp(s->magic, bcache_magic, 16))
+		goto err;
+	
+	c->owner =		THIS_MODULE;
+	c->bdev =		bdev;
+	c->sb.version =		le32_to_cpu(s->version);
+	c->sb.block_size =	le16_to_cpu(s->block_size);
+	c->sb.bucket_size =	le16_to_cpu(s->bucket_size);
+	c->sb.journal_start =	le32_to_cpu(s->journal_start);
+	c->sb.first_bucket =	le32_to_cpu(s->first_bucket);
+	c->sb.nbuckets =	le64_to_cpu(s->nbuckets);
+	c->sb.first_free_bucket = le64_to_cpu(s->first_free_bucket);
+	c->sb.btree_root = 	le64_to_cpu(s->btree_root);
+	c->sb.btree_level = 	le16_to_cpu(s->btree_level);
+
+	err = "Unsupported superblock version";
+	if (c->sb.version > 0)
+		goto err;
+
+	// buckets must be multiple of page size, at least for now
+	err = "Bad block/bucket size";
+	if (!c->sb.block_size ||
+	    c->sb.bucket_size & 7 ||
+	    c->sb.bucket_size < c->sb.block_size)
+		goto err;
+
+	err = "Invalid superblock: journal overwrites superblock/priorities";
+	if (c->sb.journal_start * c->sb.bucket_size <
+	    24 + (c->sb.nbuckets * sizeof(struct bucket)) / 512)
+		goto err;
+
+	err = "Invalid superblock";
+	if (c->sb.first_bucket < c->sb.journal_start ||
+	    c->sb.first_free_bucket > c->sb.nbuckets ||
+	    get_capacity(bdev->bd_disk) < bucket_to_sector(c->sb.nbuckets))
+		goto err;
+
+	err = "Invalid superblock";
+	if (c->sb.btree_root < c->sb.first_bucket * c->sb.bucket_size ||
+	    c->sb.btree_root >= bucket_to_sector(c->sb.first_free_bucket))
+		goto err;
+
+	c->free_size = 1;
+	while (c->free_size << 6 < c->sb.nbuckets)
+		c->free_size <<= 1;
+
+	err = "vmalloc error";
+	c->heap =	vmalloc(c->sb.nbuckets * sizeof(long));
+	c->buckets =	vmalloc(c->sb.nbuckets * sizeof(struct bucket));
+	c->freelist = 	vmalloc(c->free_size-- * sizeof(long));
+	if (!c->heap || !c->buckets || !c->freelist)
+		goto err;
+
+	load_priorities(c);
+	put_bh(c->uuids);
+
+	for (i = 0; i < 256 && devices[i]; i++)
+		register_dev_on_cache(c, i);
+
+	err = "kobj create error";
+	bdevname(bdev, b);
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
+	printk(KERN_DEBUG "bcache: Loaded cache device %s\n", path);
+	kfree(path);
+	return;
+err:
+	if (c->kobj.state_initialized)
+		kobject_put(&c->kobj);
+	if (c->uuids)
+		put_bh(c->uuids);
+	if (c->buckets)
+		vfree(c->buckets);
+	if (c->heap)
+		vfree(c->heap);
+	kfree(c);
+err_no_alloc:
+	if (bh)
+		put_bh(bh);
+	if (!IS_ERR(bdev))
+		close_bdev_exclusive(bdev, FMODE_READ|FMODE_WRITE);
+	printk(KERN_DEBUG "bcache: error opening %s: %s\n", path, err);
+	kfree(path);
+	return;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr, const char *buffer, size_t size)
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
+	const static struct attribute *files[] = { &sysfs_register_cache, &sysfs_register_dev, NULL};
+	const static struct sysfs_ops ops = { .show = NULL, .store = store };
+
+	printk(KERN_DEBUG "bcache loading\n");
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
+	int i;
+	struct list_head *l;
+
+	sysfs_remove_file(bcache_kobj, &sysfs_register_cache);
+	sysfs_remove_file(bcache_kobj, &sysfs_register_dev);
+
+	for (i = 0; i < 256; i++)
+		if (devices[i] && devices[i])
+			devices[i]->bd_cache_fn = NULL;
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10b8ded..aca254c 100644
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
@@ -664,6 +666,8 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+
+	int (*bd_cache_fn)(struct request_queue *q, struct bio *bio);
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim


/* make-bcache.c - initialize a cache device */
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
};

struct bucket_disk {
	uint16_t	priority;
	uint8_t		generation;
};

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

	struct stat statbuf;
	if (fstat(fd, &statbuf)) {
		perror("stat error\n");
		return 0;
	}

	struct cache_sb sb;
	memcpy(sb.magic, bcache_magic, 16);
	sb.version = 0;
	sb.block_size = 8;
	sb.bucket_size = 256;
	sb.nbuckets = statbuf.st_size / (sb.bucket_size * 512);

	int priority_pages;
	do {
		priority_pages = --sb.nbuckets / (4096 / sizeof(struct bucket_disk)) + 4;

	} while (sb.nbuckets + (priority_pages - 1) / (sb.bucket_size / 8) + 1 >
		 statbuf.st_size / (sb.bucket_size * 512));
	
	sb.journal_start = (priority_pages - 1) / (sb.bucket_size / 8) + 1;
	sb.first_bucket = sb.journal_start;
	sb.first_free_bucket = 1;
	sb.btree_root = sb.first_bucket * sb.bucket_size;
	sb.btree_level = 0;

	printf("block_size:	%u\n"
	       "bucket_size:	%u\n"
	       "journal_start:	%u\n"
	       "first_bucket:	%u\n"
	       "nbuckets:	%llu\n"
	       "first_free_bucket: %llu\n",
	       sb.block_size,
	       sb.bucket_size,
	       sb.journal_start,
	       sb.first_bucket,
	       sb.nbuckets,
	       sb.first_free_bucket);

	lseek(fd, 4096, SEEK_SET);
	for (int i = 0; i < priority_pages; i++)
		for (int j = 0; j < 4096; j += ret)
			if ((ret = write(fd, &zero[0], 4096 - j)) < 0)
				goto err;

	lseek(fd, 4096, SEEK_SET);
	for (int i = 0; i < sizeof(struct cache_sb); i += ret)
		if ((ret = write(fd, &sb + i, sizeof(struct cache_sb) - i)) < 0)
			goto err;

	struct btree_node_header n;
	n.nkeys = 0;
	n.random = 42;

	lseek(fd, sb.bucket_size * 512 * sb.first_bucket, SEEK_SET);
	for (int i = 0; i < sizeof(struct btree_node_header); i += ret)
		if ((ret = write(fd, &sb + i, sizeof(struct btree_node_header) - i)) < 0)
			goto err;

	return 0;
err:
	perror("write error\n");
}
