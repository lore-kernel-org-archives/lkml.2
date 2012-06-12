Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2FLPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:40:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2FLPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:40:06 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 16/16] bcache: Debug and tracing code
Date: Tue, 12 Jun 2012 08:39:22 -0700
Message-Id: <1339515562-14638-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/bcache/debug.c |  578 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/debug.h |   54 +++++
 drivers/md/bcache/trace.c |   26 ++
 3 files changed, 658 insertions(+)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
new file mode 100644
index 0000000..9c8f15a
--- /dev/null
+++ b/drivers/md/bcache/debug.c
@@ -0,0 +1,578 @@
+
+#include "bcache.h"
+#include "btree.h"
+#include "debug.h"
+#include "request.h"
+
+#include <linux/console.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/seq_file.h>
+
+static struct dentry *debug;
+
+/* Various debug code */
+
+const char *bch_ptr_status(struct cache_set *c, const struct bkey *k)
+{
+	for (unsigned i = 0; i < KEY_PTRS(k); i++)
+		if (ptr_available(c, k, i)) {
+			struct cache *ca = PTR_CACHE(c, k, i);
+			size_t bucket = PTR_BUCKET_NR(c, k, i);
+			size_t r = bucket_remainder(c, PTR_OFFSET(k, i));
+
+			if (KEY_SIZE(k) + r > c->sb.bucket_size)
+				return "bad, length too big";
+			if (bucket <  ca->sb.first_bucket)
+				return "bad, short offset";
+			if (bucket >= ca->sb.nbuckets)
+				return "bad, offset past end of device";
+			if (ptr_stale(c, k, i))
+				return "stale";
+		}
+
+	if (!bkey_cmp(k, &ZERO_KEY))
+		return "bad, null key";
+	if (!KEY_PTRS(k))
+		return "bad, no pointers";
+	if (!KEY_SIZE(k))
+		return "zeroed key";
+	return "";
+}
+
+static bool skipped_backwards(struct btree *b, struct bkey *k)
+{
+	return bkey_cmp(k, (!b->level)
+			? &START_KEY(bkey_next(k))
+			: bkey_next(k)) > 0;
+}
+
+static void dump_bset(struct btree *b, struct bset *i)
+{
+	for (struct bkey *k = i->start; k < end(i); k = bkey_next(k)) {
+		printk(KERN_ERR "block %zu key %zu/%i: %s", index(i, b),
+		       (uint64_t *) k - i->d, i->keys, pkey(k));
+
+		for (unsigned j = 0; j < KEY_PTRS(k); j++) {
+			size_t n = PTR_BUCKET_NR(b->c, k, j);
+			printk(" bucket %zu", n);
+
+			if (n >= b->c->sb.first_bucket && n < b->c->sb.nbuckets)
+				printk(" prio %i",
+				       PTR_BUCKET(b->c, k, j)->prio);
+		}
+
+		printk(" %s\n", bch_ptr_status(b->c, k));
+
+		if (bkey_next(k) < end(i) &&
+		    skipped_backwards(b, k))
+			printk(KERN_ERR "Key skipped backwards\n");
+	}
+}
+
+static void vdump_bucket_and_panic(struct btree *b, const char *m, va_list args)
+{
+	struct bset *i;
+
+	console_lock();
+
+	for_each_sorted_set(b, i)
+		dump_bset(b, i);
+
+	vprintk(m, args);
+
+	console_unlock();
+
+	panic("at %s\n", pbtree(b));
+}
+
+static void dump_bucket_and_panic(struct btree *b, const char *m, ...)
+{
+	va_list args;
+	va_start(args, m);
+	vdump_bucket_and_panic(b, m, args);
+	va_end(args);
+}
+
+static void __maybe_unused
+dump_key_and_panic(struct btree *b, struct bset *i, int j)
+{
+	long bucket = PTR_BUCKET_NR(b->c, node(i, j), 0);
+	long r = PTR_OFFSET(node(i, j), 0) & ~(~0 << b->c->bucket_bits);
+
+	printk(KERN_ERR "level %i block %zu key %i/%i: %s "
+	       "bucket %llu offset %li into bucket\n",
+	       b->level, index(i, b), j, i->keys, pkey(node(i, j)),
+	       (uint64_t) bucket, r);
+	dump_bucket_and_panic(b, "");
+}
+
+struct keyprint_hack bch_pkey(const struct bkey *k)
+{
+	unsigned i = 0;
+	struct keyprint_hack r;
+	char *out = r.s, *end = r.s + KEYHACK_SIZE;
+
+#define p(...)	(out += scnprintf(out, end - out, __VA_ARGS__))
+
+	p("%llu:%llu len %llu -> [", KEY_INODE(k), KEY_OFFSET(k), KEY_SIZE(k));
+
+	if (KEY_PTRS(k))
+		while (1) {
+			p("%llu:%llu gen %llu",
+			  PTR_DEV(k, i), PTR_OFFSET(k, i), PTR_GEN(k, i));
+
+			if (++i == KEY_PTRS(k))
+				break;
+
+			p(", ");
+		}
+
+	p("]");
+
+	if (KEY_DIRTY(k))
+		p(" dirty");
+	if (KEY_CSUM(k))
+		p(" cs%llu %llx", KEY_CSUM(k), k->ptr[1]);
+#undef p
+	return r;
+}
+
+struct keyprint_hack bch_pbtree(const struct btree *b)
+{
+	struct keyprint_hack r;
+
+	snprintf(r.s, 40, "%li level %i/%i", PTR_BUCKET_NR(b->c, &b->key, 0),
+		 b->level, b->c->root ? b->c->root->level : -1);
+	return r;
+}
+
+#ifdef CONFIG_BCACHE_DEBUG
+
+void bch_btree_verify(struct btree *b, struct bset *new)
+{
+	struct btree *v = b->c->verify_data;
+	struct closure cl;
+	closure_init_stack(&cl);
+
+	if (!b->c->verify)
+		return;
+
+	closure_wait_event(&b->io.wait, &cl,
+			   atomic_read(&b->io.cl.remaining) == -1);
+
+	mutex_lock(&b->c->verify_lock);
+
+	bkey_copy(&v->key, &b->key);
+	v->written = 0;
+	v->level = b->level;
+
+	bch_btree_read(v);
+	closure_wait_event(&v->io.wait, &cl,
+			   atomic_read(&b->io.cl.remaining) == -1);
+
+	if (new->keys != v->sets[0].data->keys ||
+	    memcmp(new->start,
+		   v->sets[0].data->start,
+		   (void *) end(new) - (void *) new->start)) {
+		struct bset *i;
+		unsigned j;
+
+		console_lock();
+
+		printk(KERN_ERR "*** original memory node:\n");
+		for_each_sorted_set(b, i)
+			dump_bset(b, i);
+
+		printk(KERN_ERR "*** sorted memory node:\n");
+		dump_bset(b, new);
+
+		printk(KERN_ERR "*** on disk node:\n");
+		dump_bset(v, v->sets[0].data);
+
+		for (j = 0; j < new->keys; j++)
+			if (new->d[j] != v->sets[0].data->d[j])
+				break;
+
+		console_unlock();
+		panic("verify failed at %u\n", j);
+	}
+
+	mutex_unlock(&b->c->verify_lock);
+}
+
+static void data_verify_endio(struct bio *bio, int error)
+{
+	struct closure *cl = bio->bi_private;
+	closure_put(cl);
+}
+
+void bch_data_verify(struct search *s)
+{
+	char name[BDEVNAME_SIZE];
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
+	struct closure *cl = &s->cl;
+	struct bio *check;
+	struct bio_vec *bv;
+	int i;
+
+	if (!s->unaligned_bvec)
+		bio_for_each_segment(bv, s->orig_bio, i)
+			bv->bv_offset = 0, bv->bv_len = PAGE_SIZE;
+
+	check = bio_clone(s->orig_bio, GFP_NOIO);
+	if (!check)
+		return;
+
+	if (bio_alloc_pages(check, GFP_NOIO))
+		goto out_put;
+
+	check->bi_rw		= READ_SYNC;
+	check->bi_private	= cl;
+	check->bi_end_io	= data_verify_endio;
+
+	closure_bio_submit(check, cl);
+	closure_sync(cl);
+
+	bio_for_each_segment(bv, s->orig_bio, i) {
+		void *p1 = kmap(bv->bv_page);
+		void *p2 = kmap(check->bi_io_vec[i].bv_page);
+
+		if (memcmp(p1 + bv->bv_offset,
+			   p2 + bv->bv_offset,
+			   bv->bv_len))
+			printk(KERN_ERR "bcache (%s): verify failed"
+			       " at sector %llu\n",
+			       bdevname(dc->bdev, name),
+			       (uint64_t) s->orig_bio->bi_sector);
+
+		kunmap(bv->bv_page);
+		kunmap(check->bi_io_vec[i].bv_page);
+	}
+
+	__bio_for_each_segment(bv, check, i, 0)
+		__free_page(bv->bv_page);
+out_put:
+	bio_put(check);
+}
+
+#endif
+
+#ifdef CONFIG_BCACHE_EDEBUG
+
+unsigned bch_count_data(struct btree *b)
+{
+	unsigned ret = 0;
+	struct bkey *k;
+
+	if (!b->level)
+		for_each_key(b, k)
+			ret += KEY_SIZE(k);
+	return ret;
+}
+
+void bch_check_key_order_msg(struct btree *b, struct bset *i, const char *m, ...)
+{
+	if (!i->keys)
+		return;
+
+	for (struct bkey *k = i->start; bkey_next(k) < end(i); k = bkey_next(k))
+		if (skipped_backwards(b, k)) {
+			va_list args;
+			va_start(args, m);
+
+			vdump_bucket_and_panic(b, m, args);
+			va_end(args);
+		}
+}
+
+void bch_check_keys(struct btree *b, const char *m, ...)
+{
+	va_list args;
+	struct bkey *k, *p;
+	struct btree_iter iter;
+
+	if (b->level)
+		return;
+
+	bch_btree_iter_init(b, &iter, NULL);
+
+	do
+		p = bch_btree_iter_next(&iter);
+	while (p && bch_ptr_invalid(b, p));
+
+	while ((k = bch_btree_iter_next(&iter))) {
+		if (bkey_cmp(&START_KEY(p), &START_KEY(k)) > 0) {
+			printk(KERN_ERR "Keys out of order:\n");
+			goto bug;
+		}
+
+		if (bch_ptr_invalid(b, k))
+			continue;
+
+		if (bkey_cmp(p, &START_KEY(k)) > 0) {
+			printk(KERN_ERR "Overlapping keys:\n");
+			goto bug;
+		}
+		p = k;
+	}
+	return;
+bug:
+	va_start(args, m);
+	vdump_bucket_and_panic(b, m, args);
+	va_end(args);
+}
+
+#endif
+
+#ifdef CONFIG_DEBUG_FS
+
+static int bch_btree_dump(struct btree *b, struct btree_op *op, struct seq_file *f,
+		      const char *tabs, uint64_t *prev, uint64_t *sectors)
+{
+	struct bkey *k;
+	char buf[30];
+	uint64_t last, biggest = 0;
+
+	for_each_key(b, k) {
+		int j = (uint64_t *) k - _t->data->d;
+		if (!j)
+			last = *prev;
+
+		if (last > KEY_OFFSET(k))
+			seq_printf(f, "Key skipped backwards\n");
+
+		if (!b->level && j &&
+		    last != KEY_START(k))
+			seq_printf(f, "<hole>\n");
+		else if (b->level && !bch_ptr_bad(b, k))
+			btree(dump, k, b, op, f, tabs - 1, &last, sectors);
+
+		seq_printf(f, "%s%zi %4i: %s %s\n",
+			   tabs, _t - b->sets, j, pkey(k), buf);
+
+		if (!b->level && !buf[0])
+			*sectors += KEY_SIZE(k);
+
+		last = KEY_OFFSET(k);
+		biggest = max(biggest, last);
+	}
+	*prev = biggest;
+
+	return 0;
+}
+
+static int debug_seq_show(struct seq_file *f, void *data)
+{
+	static const char *tabs = "\t\t\t\t\t";
+	uint64_t last = 0, sectors = 0;
+	struct cache_set *c = f->private;
+
+	struct btree_op op;
+	bch_btree_op_init_stack(&op);
+
+	btree_root(dump, c, &op, f, &tabs[4], &last, &sectors);
+
+	seq_printf(f, "%s\n" "%llu Mb found\n",
+		   pkey(&c->root->key), sectors / 2048);
+
+	closure_sync(&op.cl);
+	return 0;
+}
+
+static int debug_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_seq_show, inode->i_private);
+}
+
+static const struct file_operations cache_set_debug_ops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_seq_open,
+	.read		= seq_read,
+	.release	= single_release
+};
+
+void bch_debug_init_cache_set(struct cache_set *c)
+{
+	if (!IS_ERR_OR_NULL(debug)) {
+		char name[50];
+		snprintf(name, 50, "bcache-%pU", c->sb.set_uuid);
+
+		c->debug = debugfs_create_file(name, 0400, debug, c,
+					       &cache_set_debug_ops);
+	}
+}
+
+#endif
+
+#ifdef CONFIG_BCACHE_DEBUG
+static ssize_t btree_fuzz(struct kobject *k, struct kobj_attribute *a,
+		      const char *buffer, size_t size)
+{
+	void dump(struct btree *b)
+	{
+		for (struct bset *i = b->sets[0].data;
+		     index(i, b) < btree_blocks(b) &&
+		     i->seq == b->sets[0].data->seq;
+		     i = ((void *) i) + set_blocks(i, b->c) * block_bytes(b->c))
+			dump_bset(b, i);
+	}
+
+	struct cache_sb *sb;
+	struct cache_set *c;
+	struct btree *all[3], *b, *fill, *orig;
+
+	struct btree_op op;
+	bch_btree_op_init_stack(&op);
+
+	sb = kzalloc(sizeof(struct cache_sb), GFP_KERNEL);
+	if (!sb)
+		return -ENOMEM;
+
+	sb->bucket_size = 128;
+	sb->block_size = 4;
+
+	c = bch_cache_set_alloc(sb);
+	if (!c)
+		return -ENOMEM;
+
+	for (int i = 0; i < 3; i++) {
+		BUG_ON(list_empty(&c->btree_cache));
+		all[i] = list_first_entry(&c->btree_cache, struct btree, list);
+		list_del_init(&all[i]->list);
+
+		all[i]->key = KEY(0, 0, c->sb.bucket_size);
+		bkey_copy_key(&all[i]->key, &MAX_KEY);
+	}
+
+	b = all[0];
+	fill = all[1];
+	orig = all[2];
+
+	while (1) {
+		for (int i = 0; i < 3; i++)
+			all[i]->written = all[i]->nsets = 0;
+
+		bch_bset_init_next(b);
+
+		while (1) {
+			struct bset *i = write_block(b);
+			struct bkey *k = op.keys.top;
+			unsigned rand;
+
+			bkey_init(k);
+			rand = get_random_int();
+
+			op.type = rand & 1
+				? BTREE_INSERT
+				: BTREE_REPLACE;
+			rand >>= 1;
+
+			SET_KEY_SIZE(k, bucket_remainder(c, rand));
+			rand >>= c->bucket_bits;
+			rand &= 1024 * 512 - 1;
+			rand += c->sb.bucket_size;
+			SET_KEY_OFFSET(k, rand);
+#if 0
+			SET_KEY_PTRS(k, 1);
+#endif
+			bch_keylist_push(&op.keys);
+			bch_btree_insert_keys(b, &op);
+
+			if (should_split(b) ||
+			    set_blocks(i, b->c) !=
+			    __set_blocks(i, i->keys + 15, b->c)) {
+				i->csum = csum_set(i);
+
+				memcpy(write_block(fill),
+				       i, set_bytes(i));
+
+				b->written += set_blocks(i, b->c);
+				fill->written = b->written;
+				if (b->written == btree_blocks(b))
+					break;
+
+				bch_btree_sort_lazy(b);
+				bch_bset_init_next(b);
+			}
+		}
+
+		memcpy(orig->sets[0].data,
+		       fill->sets[0].data,
+		       btree_bytes(c));
+
+		bch_btree_sort(b);
+		fill->written = 0;
+		bch_btree_read_done(&fill->io.cl);
+
+		if (b->sets[0].data->keys != fill->sets[0].data->keys ||
+		    memcmp(b->sets[0].data->start,
+			   fill->sets[0].data->start,
+			   b->sets[0].data->keys * sizeof(uint64_t))) {
+			struct bset *i = b->sets[0].data;
+
+			for (struct bkey *k = i->start,
+			     *j = fill->sets[0].data->start;
+			     k < end(i);
+			     k = bkey_next(k), j = bkey_next(j))
+				if (bkey_cmp(k, j) ||
+				    KEY_SIZE(k) != KEY_SIZE(j))
+					printk(KERN_ERR "key %zi differs: %s "
+					       "!= %s\n", (uint64_t *) k - i->d,
+					       pkey(k), pkey(j));
+
+			for (int i = 0; i < 3; i++) {
+				printk(KERN_ERR "**** Set %i ****\n", i);
+				dump(all[i]);
+			}
+			panic("\n");
+		}
+
+		printk(KERN_DEBUG "bcache: fuzz complete: %i keys\n",
+		       b->sets[0].data->keys);
+	}
+}
+
+kobj_attribute_write(fuzz, btree_fuzz);
+#endif
+
+#ifdef CONFIG_BCACHE_LATENCY_DEBUG
+static ssize_t show(struct kobject *k, struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%i\n", latency_warn_ms);
+}
+
+static ssize_t store(struct kobject *k, struct kobj_attribute *attr,
+		     const char *buffer, size_t size)
+{
+	return strtoul_safe(buffer, latency_warn_ms) ?: (ssize_t) size;
+}
+
+kobj_attribute_rw(latency_warn_ms, show, store);
+#endif
+
+void bch_debug_exit(void)
+{
+	if (!IS_ERR_OR_NULL(debug))
+		debugfs_remove_recursive(debug);
+}
+
+int __init bch_debug_init(struct kobject *kobj)
+{
+	int ret = 0;
+#ifdef CONFIG_BCACHE_DEBUG
+	ret = sysfs_create_file(kobj, &ksysfs_fuzz.attr);
+	if (ret)
+		return ret;
+#endif
+
+#ifdef CONFIG_BCACHE_LATENCY_DEBUG
+	ret = sysfs_create_file(kobj, &ksysfs_latency_warn_ms.attr);
+	if (ret)
+		return ret;
+#endif
+
+	debug = debugfs_create_dir("bcache", NULL);
+	return ret;
+}
diff --git a/drivers/md/bcache/debug.h b/drivers/md/bcache/debug.h
new file mode 100644
index 0000000..f9378a2
--- /dev/null
+++ b/drivers/md/bcache/debug.h
@@ -0,0 +1,54 @@
+#ifndef _BCACHE_DEBUG_H
+#define _BCACHE_DEBUG_H
+
+/* Btree/bkey debug printing */
+
+#define KEYHACK_SIZE 80
+struct keyprint_hack {
+	char s[KEYHACK_SIZE];
+};
+
+struct keyprint_hack bch_pkey(const struct bkey *k);
+struct keyprint_hack bch_pbtree(const struct btree *b);
+#define pkey(k)		(&bch_pkey(k).s[0])
+#define pbtree(b)	(&bch_pbtree(b).s[0])
+
+#ifdef CONFIG_BCACHE_EDEBUG
+
+unsigned bch_count_data(struct btree *);
+void bch_check_key_order_msg(struct btree *, struct bset *, const char *, ...);
+void bch_check_keys(struct btree *, const char *, ...);
+
+#define bch_check_key_order(b, i)			\
+	bch_check_key_order_msg(b, i, "keys out of order")
+#define EBUG_ON(cond)		BUG_ON(cond)
+
+#else /* EDEBUG */
+
+#define bch_count_data(b)				0
+#define bch_check_key_order(b, i)			do {} while (0)
+#define bch_check_key_order_msg(b, i, ...)		do {} while (0)
+#define bch_check_keys(b, ...)				do {} while (0)
+#define EBUG_ON(cond)					do {} while (0)
+
+#endif
+
+#ifdef CONFIG_BCACHE_DEBUG
+
+void bch_btree_verify(struct btree *, struct bset *);
+void bch_data_verify(struct search *);
+
+#else /* DEBUG */
+
+static inline void bch_btree_verify(struct btree *b, struct bset *i) {}
+static inline void bch_data_verify(struct search *s) {};
+
+#endif
+
+#ifdef CONFIG_DEBUG_FS
+void bch_debug_init_cache_set(struct cache_set *);
+#else
+static inline void bch_debug_init_cache_set(struct cache_set *c) {}
+#endif
+
+#endif
diff --git a/drivers/md/bcache/trace.c b/drivers/md/bcache/trace.c
new file mode 100644
index 0000000..983f9bb
--- /dev/null
+++ b/drivers/md/bcache/trace.c
@@ -0,0 +1,26 @@
+#include "bcache.h"
+#include "btree.h"
+#include "request.h"
+
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/bcache.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_start);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_end);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_passthrough);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_cache_hit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_cache_miss);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read_retry);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writethrough);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writeback);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_write_skip);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_read);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_write);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_write_dirty);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read_dirty);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_write);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_cache_insert);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_start);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_end);
-- 
1.7.9.3.327.g2980b

