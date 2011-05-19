Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1ESCPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:15:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab1ESCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:56 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Aj9RJ-FzfYAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ZVsd1NeU2EmTh8aBLQIA:9 a=ghmneDb466ORluSCWHYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021255.504990995@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/13] ftrace: Separate hash allocation and assignment
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Separate-hash-allocation-and-assignment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When filtering, allocate a hash to insert the function records.
After the filtering is complete, assign it to the ftrace_ops structure.

This allows the ftrace_ops structure to have a much smaller array of
hash buckets instead of wasting a lot of memory.

A read only empty_hash is created to be the minimum size that any ftrace_ops
can point to.

When a new hash is created, it has the following steps:

o Allocate a default hash.
o Walk the function records assigning the filtered records to the hash
o Allocate a new hash with the appropriate size buckets
o Move the entries from the default hash to the new hash.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |  275 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 233 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a517a6c..46f0826 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -57,7 +57,8 @@
 /* hash bits for specific function selection */
 #define FTRACE_HASH_BITS 7
 #define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
-#define FTRACE_HASH_MAX_BITS 10
+#define FTRACE_HASH_DEFAULT_BITS 10
+#define FTRACE_HASH_MAX_BITS 12
 
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
@@ -877,22 +878,22 @@ struct ftrace_hash {
 	unsigned long		count;
 };
 
-static struct hlist_head notrace_buckets[1 << FTRACE_HASH_MAX_BITS];
-static struct ftrace_hash notrace_hash = {
-	.size_bits = FTRACE_HASH_MAX_BITS,
-	.buckets = notrace_buckets,
-};
-
-static struct hlist_head filter_buckets[1 << FTRACE_HASH_MAX_BITS];
-static struct ftrace_hash filter_hash = {
-	.size_bits = FTRACE_HASH_MAX_BITS,
-	.buckets = filter_buckets,
+/*
+ * We make these constant because no one should touch them,
+ * but they are used as the default "empty hash", to avoid allocating
+ * it all the time. These are in a read only section such that if
+ * anyone does try to modify it, it will cause an exception.
+ */
+static const struct hlist_head empty_buckets[1];
+static const struct ftrace_hash empty_hash = {
+	.buckets = (struct hlist_head *)empty_buckets,
 };
+#define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
 struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
-	.notrace_hash		= &notrace_hash,
-	.filter_hash		= &filter_hash,
+	.notrace_hash		= EMPTY_HASH,
+	.filter_hash		= EMPTY_HASH,
 };
 
 static struct dyn_ftrace *ftrace_new_addrs;
@@ -941,31 +942,38 @@ ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
 	return NULL;
 }
 
-static int add_hash_entry(struct ftrace_hash *hash, unsigned long ip)
+static void __add_hash_entry(struct ftrace_hash *hash,
+			     struct ftrace_func_entry *entry)
 {
-	struct ftrace_func_entry *entry;
 	struct hlist_head *hhd;
 	unsigned long key;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return -ENOMEM;
-
 	if (hash->size_bits)
-		key = hash_long(ip, hash->size_bits);
+		key = hash_long(entry->ip, hash->size_bits);
 	else
 		key = 0;
 
-	entry->ip = ip;
 	hhd = &hash->buckets[key];
 	hlist_add_head(&entry->hlist, hhd);
 	hash->count++;
+}
+
+static int add_hash_entry(struct ftrace_hash *hash, unsigned long ip)
+{
+	struct ftrace_func_entry *entry;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->ip = ip;
+	__add_hash_entry(hash, entry);
 
 	return 0;
 }
 
 static void
-remove_hash_entry(struct ftrace_hash *hash,
+free_hash_entry(struct ftrace_hash *hash,
 		  struct ftrace_func_entry *entry)
 {
 	hlist_del(&entry->hlist);
@@ -973,6 +981,14 @@ remove_hash_entry(struct ftrace_hash *hash,
 	hash->count--;
 }
 
+static void
+remove_hash_entry(struct ftrace_hash *hash,
+		  struct ftrace_func_entry *entry)
+{
+	hlist_del(&entry->hlist);
+	hash->count--;
+}
+
 static void ftrace_hash_clear(struct ftrace_hash *hash)
 {
 	struct hlist_head *hhd;
@@ -981,14 +997,156 @@ static void ftrace_hash_clear(struct ftrace_hash *hash)
 	int size = 1 << hash->size_bits;
 	int i;
 
+	if (!hash->count)
+		return;
+
 	for (i = 0; i < size; i++) {
 		hhd = &hash->buckets[i];
 		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist)
-			remove_hash_entry(hash, entry);
+			free_hash_entry(hash, entry);
 	}
 	FTRACE_WARN_ON(hash->count);
 }
 
+static void free_ftrace_hash(struct ftrace_hash *hash)
+{
+	if (!hash || hash == EMPTY_HASH)
+		return;
+	ftrace_hash_clear(hash);
+	kfree(hash->buckets);
+	kfree(hash);
+}
+
+static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
+{
+	struct ftrace_hash *hash;
+	int size;
+
+	hash = kzalloc(sizeof(*hash), GFP_KERNEL);
+	if (!hash)
+		return NULL;
+
+	size = 1 << size_bits;
+	hash->buckets = kzalloc(sizeof(*hash->buckets) * size, GFP_KERNEL);
+
+	if (!hash->buckets) {
+		kfree(hash);
+		return NULL;
+	}
+
+	hash->size_bits = size_bits;
+
+	return hash;
+}
+
+static struct ftrace_hash *
+alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *new_hash;
+	struct hlist_node *tp;
+	int size;
+	int ret;
+	int i;
+
+	new_hash = alloc_ftrace_hash(size_bits);
+	if (!new_hash)
+		return NULL;
+
+	/* Empty hash? */
+	if (!hash || !hash->count)
+		return new_hash;
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, tp, &hash->buckets[i], hlist) {
+			ret = add_hash_entry(new_hash, entry->ip);
+			if (ret < 0)
+				goto free_hash;
+		}
+	}
+
+	FTRACE_WARN_ON(new_hash->count != hash->count);
+
+	return new_hash;
+
+ free_hash:
+	free_ftrace_hash(new_hash);
+	return NULL;
+}
+
+static int
+ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
+{
+	struct ftrace_func_entry *entry;
+	struct hlist_node *tp, *tn;
+	struct hlist_head *hhd;
+	struct ftrace_hash *hash = *dst;
+	unsigned long key;
+	int size = src->count;
+	int bits = 0;
+	int i;
+
+	/*
+	 * If the new source is empty, just free dst and assign it
+	 * the empty_hash.
+	 */
+	if (!src->count) {
+		free_ftrace_hash(*dst);
+		*dst = EMPTY_HASH;
+		return 0;
+	}
+
+	ftrace_hash_clear(hash);
+
+	/*
+	 * Make the hash size about 1/2 the # found
+	 */
+	for (size /= 2; size; size >>= 1)
+		bits++;
+
+	/* Don't allocate too much */
+	if (bits > FTRACE_HASH_MAX_BITS)
+		bits = FTRACE_HASH_MAX_BITS;
+
+	/* We can't modify the empty_hash */
+	if (hash == EMPTY_HASH) {
+		/* Create a new hash */
+		*dst = alloc_ftrace_hash(bits);
+		if (!*dst) {
+			*dst = EMPTY_HASH;
+			return -ENOMEM;
+		}
+		hash = *dst;
+	} else {
+		size = 1 << bits;
+
+		/* Use the old hash, but create new buckets */
+		hhd = kzalloc(sizeof(*hhd) * size, GFP_KERNEL);
+		if (!hhd)
+			return -ENOMEM;
+
+		kfree(hash->buckets);
+		hash->buckets = hhd;
+		hash->size_bits = bits;
+	}
+
+	size = 1 << src->size_bits;
+	for (i = 0; i < size; i++) {
+		hhd = &src->buckets[i];
+		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
+			if (bits > 0)
+				key = hash_long(entry->ip, bits);
+			else
+				key = 0;
+			remove_hash_entry(src, entry);
+			__add_hash_entry(hash, entry);
+		}
+	}
+
+	return 0;
+}
+
 /*
  * This is a double for. Do not use 'break' to break out of the loop,
  * you must use a goto.
@@ -1443,6 +1601,7 @@ struct ftrace_iterator {
 	struct ftrace_func_probe	*probe;
 	struct trace_parser		parser;
 	struct ftrace_hash		*hash;
+	struct ftrace_ops		*ops;
 	int				hidx;
 	int				idx;
 	unsigned			flags;
@@ -1742,22 +1901,37 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	else
 		hash = ops->filter_hash;
 
-	iter->hash = hash;
+	iter->ops = ops;
+	iter->flags = flag;
+
+	if (file->f_mode & FMODE_WRITE) {
+		mutex_lock(&ftrace_lock);
+		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
+		mutex_unlock(&ftrace_lock);
+
+		if (!iter->hash) {
+			trace_parser_put(&iter->parser);
+			kfree(iter);
+			return -ENOMEM;
+		}
+	}
 
 	mutex_lock(&ftrace_regex_lock);
+
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		ftrace_filter_reset(hash);
+		ftrace_filter_reset(iter->hash);
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->flags = flag;
 
 		ret = seq_open(file, &show_ftrace_seq_ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = iter;
 		} else {
+			/* Failed */
+			free_ftrace_hash(iter->hash);
 			trace_parser_put(&iter->parser);
 			kfree(iter);
 		}
@@ -1835,7 +2009,7 @@ enter_record(struct ftrace_hash *hash, struct dyn_ftrace *rec, int not)
 		if (!entry)
 			return 0;
 
-		remove_hash_entry(hash, entry);
+		free_hash_entry(hash, entry);
 	} else {
 		/* Do nothing if it exists */
 		if (entry)
@@ -2259,19 +2433,13 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd)
 	return ret;
 }
 
-static int ftrace_process_regex(char *buff, int len, int enable)
+static int ftrace_process_regex(struct ftrace_hash *hash,
+				char *buff, int len, int enable)
 {
 	char *func, *command, *next = buff;
-	struct ftrace_ops *ops = &global_ops;
 	struct ftrace_func_command *p;
-	struct ftrace_hash *hash;
 	int ret;
 
-	if (enable)
-		hash = ops->filter_hash;
-	else
-		hash = ops->notrace_hash;
-
 	func = strsep(&next, ":");
 
 	if (!next) {
@@ -2328,7 +2496,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
 	    !trace_parser_cont(parser)) {
-		ret = ftrace_process_regex(parser->buffer,
+		ret = ftrace_process_regex(iter->hash, parser->buffer,
 					   parser->idx, enable);
 		trace_parser_clear(parser);
 		if (ret)
@@ -2356,26 +2524,40 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 	return ftrace_regex_write(file, ubuf, cnt, ppos, 0);
 }
 
-static void
+static int
 ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		 int reset, int enable)
 {
+	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *hash;
+	int ret;
 
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
 
 	if (enable)
-		hash = ops->filter_hash;
+		orig_hash = &ops->filter_hash;
 	else
-		hash = ops->notrace_hash;
+		orig_hash = &ops->notrace_hash;
+
+	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!hash)
+		return -ENOMEM;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf)
 		ftrace_match_records(hash, buf, len);
+
+	mutex_lock(&ftrace_lock);
+	ret = ftrace_hash_move(orig_hash, hash);
+	mutex_unlock(&ftrace_lock);
+
 	mutex_unlock(&ftrace_regex_lock);
+
+	free_ftrace_hash(hash);
+	return ret;
 }
 
 /**
@@ -2484,7 +2666,9 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
+	struct ftrace_hash **orig_hash;
 	struct trace_parser *parser;
+	int ret;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
@@ -2501,14 +2685,21 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 	}
 
 	trace_parser_put(parser);
-	kfree(iter);
 
 	if (file->f_mode & FMODE_WRITE) {
+		if (iter->flags & FTRACE_ITER_NOTRACE)
+			orig_hash = &iter->ops->notrace_hash;
+		else
+			orig_hash = &iter->ops->filter_hash;
+
 		mutex_lock(&ftrace_lock);
-		if (ftrace_start_up && ftrace_enabled)
+		ret = ftrace_hash_move(orig_hash, iter->hash);
+		if (!ret && ftrace_start_up && ftrace_enabled)
 			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 		mutex_unlock(&ftrace_lock);
 	}
+	free_ftrace_hash(iter->hash);
+	kfree(iter);
 
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
-- 
1.7.4.4


