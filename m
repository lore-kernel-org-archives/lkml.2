Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2DNBIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:08:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53501 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab2DNBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:08:18 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags
Date: Fri, 13 Apr 2012 18:08:01 -0700
Message-Id: <1334365681-21586-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1334365681-21586-1-git-send-email-john.stultz@linaro.org>
References: <1334365681-21586-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041401-5112-0000-0000-0000070E9843
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides new fadvise flags that can be used to mark
file pages as volatile, which will allow it to be discarded if the
kernel wants to reclaim memory.

This is useful for userspace to allocate things like caches, and lets
the kernel destructively (but safely) reclaim them when there's memory
pressure.

It's different from FADV_DONTNEED since the pages are not immediately
discarded; they are only discarded under pressure.

This is very much influenced by the Android Ashmem interface by
Robert Love so credits to him and the Android developers.
In many cases the code & logic come directly from the ashmem patch.
The intent of this patch is to allow for ashmem-like behavior, but
embeds the idea a little deeper into the VM code, instead of isolating
it into a specific driver.

I'm very much a newbie at the VM code, so At this point, I just want
to try to get some input on the patch, so if you have another idea
for using something other then fadvise, or other thoughts on how the
volatile ranges are stored, I'd be really interested in hearing them.
So let me know if you have any comments for feedback!

Also many thanks to Dave Hansen who helped design and develop the
initial version of this patch, and has provided continued review and
mentoring for me in the VM code.

v2:
* After the valid critique that just dropping pages would poke holes
in volatile ranges, and instead we should zap an entire range if we
drop any of it, I changed the code to more closely mimic the ashmem
implementation, which zaps entire ranges via a shrinker using an lru
list that tracks which range has been marked volatile the longest.

v3:
* Reworked to use range tree implementation.

v4:
* Renamed functions to avoid confusion.
* More consistant PAGE_CACHE_SHIFT usage, suggested by Dmitry
  Adamushko
* Fixes exit without unlocking issue found by Dmitry Adamushko
* Migrate to rbtree based rangetree implementation
* Simplified locking to use global lock (we were grabbing global
  lru lock every time anyway).
* Avoid ENOMEM isses by allocating before we get into complicated
  code.
* Add some documentation to the volatile.c file from Neil Brown

v5:
* More fixes suggested by Dmitry Adamushko
* Improve range colescing so that we don't coalesce neighboring
  purged ranges.
* Utilize range_tree_next_in_range to avoid doing every lookup
  from the tree's root.

v6:
* Immediately zap range if we coalesce overlapping purged range.
* Use hash table to do mapping->rangetree lookup instead of
  bloating the address_space structure

v7:
* Race fix noted by Dmitry
* Clear volatile ranges on fput, so volatile ranges don't persist
  if no one has the file open
* Made it tmpfs only, using shmem_truncate_range() instead of
  vmtruncate_range(). This avoids the lockdep warnings caused
  by calling vmtruncate_range() from the shrinker. Seems to
  work ok, but I'd not be surprised if this isn't correct.
  Extra eyes would be appreciated here.

Known issues:
* None? I think this is getting close to dropping the RFC, and
  taking a stab at actually submitting this for inclusion.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/file_table.c          |    4 +
 include/linux/fadvise.h  |    5 +
 include/linux/volatile.h |   12 ++
 mm/Makefile              |    2 +-
 mm/fadvise.c             |   16 ++-
 mm/volatile.c            |  457 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 494 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

diff --git a/fs/file_table.c b/fs/file_table.c
index 70f2a0f..ada2c88 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -24,6 +24,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/percpu.h>
 #include <linux/ima.h>
+#include <linux/volatile.h>
 
 #include <linux/atomic.h>
 
@@ -238,6 +239,9 @@ static void __fput(struct file *file)
 	eventpoll_release(file);
 	locks_remove_flock(file);
 
+	/* Volatile ranges should not persist after all fds are closed */
+	mapping_clear_volatile_ranges(&inode->i_data);
+
 	if (unlikely(file->f_flags & FASYNC)) {
 		if (file->f_op && file->f_op->fasync)
 			file->f_op->fasync(-1, file, 0);
diff --git a/include/linux/fadvise.h b/include/linux/fadvise.h
index e8e7471..443951c 100644
--- a/include/linux/fadvise.h
+++ b/include/linux/fadvise.h
@@ -18,4 +18,9 @@
 #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
 #endif
 
+#define POSIX_FADV_VOLATILE	8  /* _can_ toss, but don't toss now */
+#define POSIX_FADV_NONVOLATILE	9  /* Remove VOLATILE flag */
+
+
+
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/include/linux/volatile.h b/include/linux/volatile.h
new file mode 100644
index 0000000..85a9249
--- /dev/null
+++ b/include/linux/volatile.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_VOLATILE_H
+#define _LINUX_VOLATILE_H
+
+#include <linux/fs.h>
+
+extern long mapping_range_volatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long mapping_range_nonvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern void mapping_clear_volatile_ranges(struct address_space *mapping);
+
+#endif /* _LINUX_VOLATILE_H */
diff --git a/mm/Makefile b/mm/Makefile
index 50ec00e..7b6c7a8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -13,7 +13,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o percpu.o \
-			   $(mmu-y)
+			   volatile.o $(mmu-y)
 obj-y += init-mm.o
 
 ifdef CONFIG_NO_BOOTMEM
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 469491e0..3e33845 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -17,6 +17,7 @@
 #include <linux/fadvise.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
+#include <linux/volatile.h>
 
 #include <asm/unistd.h>
 
@@ -106,7 +107,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
+
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
 				nrpages);
@@ -128,6 +129,19 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 			invalidate_mapping_pages(mapping, start_index,
 						end_index);
 		break;
+	case POSIX_FADV_VOLATILE:
+		/* First and last PARTIAL page! */
+		start_index = offset >> PAGE_CACHE_SHIFT;
+		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		ret = mapping_range_volatile(mapping, start_index, end_index);
+		break;
+	case POSIX_FADV_NONVOLATILE:
+		/* First and last PARTIAL page! */
+		start_index = offset >> PAGE_CACHE_SHIFT;
+		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		ret = mapping_range_nonvolatile(mapping, start_index,
+								end_index);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/mm/volatile.c b/mm/volatile.c
new file mode 100644
index 0000000..e94e980
--- /dev/null
+++ b/mm/volatile.c
@@ -0,0 +1,457 @@
+/* mm/volatile.c
+ *
+ * Volatile page range managment.
+ *      Copyright 2011 Linaro
+ *
+ * Based on mm/ashmem.c
+ *      by Robert Love <rlove@google.com>
+ *      Copyright (C) 2008 Google, Inc.
+ *
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * The goal behind volatile ranges is to allow applications to interact
+ * with the kernel's cache management infrastructure.  In particular an
+ * application can say "this memory contains data that might be useful in
+ * the future, but can be reconstructed if necessary, so if the kernel
+ * needs, it can zap and reclaim this memory without having to swap it out.
+ *
+ * The proposed mechanism - at a high level - is for user-space to be able
+ * to say "This memory is volatile" and then later "this memory is no longer
+ * volatile".  If the content of the memory is still available the second
+ * request succeeds.  If not, the memory is marked non-volatile and an
+ * error is returned to denote that the contents have been lost.
+ *
+ * Credits to Neil Brown for the above description.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/volatile.h>
+#include <linux/rangetree.h>
+#include <linux/hash.h>
+#include <linux/shmem_fs.h>
+
+static DEFINE_MUTEX(volatile_mutex);
+
+struct volatile_range {
+	struct list_head	lru;
+	struct range_tree_node	range_node;
+	unsigned int		purged;
+	struct address_space	*mapping;
+};
+
+/* LRU list of volatile page ranges */
+static LIST_HEAD(volatile_lru_list);
+
+/* Count of pages on our LRU list */
+static u64 lru_count;
+
+
+/*
+ * To avoid bloating the address_space structure, we use
+ * a hash structure to map from address_space mappings to
+ * the range_tree root that stores volatile ranges
+ */
+static struct hlist_head *mapping_hash;
+static long mapping_hash_shift = 8;
+
+struct mapping_hash_entry {
+	struct range_tree_root root;
+	struct address_space *mapping;
+	struct hlist_node hnode;
+};
+
+static inline
+struct range_tree_root *mapping_to_root(struct address_space *mapping)
+{
+	struct hlist_node *elem;
+	struct mapping_hash_entry *entry;
+
+	hlist_for_each_entry_rcu(entry, elem,
+			&mapping_hash[hash_ptr(mapping, mapping_hash_shift)],
+				hnode)
+		if (entry->mapping == mapping)
+			return &entry->root;
+
+	return NULL;
+}
+
+static inline
+struct range_tree_root *mapping_allocate_root(struct address_space *mapping)
+{
+	struct mapping_hash_entry *entry;
+	struct range_tree_root *dblchk;
+
+	/* Drop the volatile_mutex to avoid lockdep deadlock warnings */
+	mutex_unlock(&volatile_mutex);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	mutex_lock(&volatile_mutex);
+
+	/* Since we dropped the lock, double check that no one has
+	 * created the same hash entry.
+	 */
+	dblchk = mapping_to_root(mapping);
+	if (dblchk) {
+		kfree(entry);
+		return dblchk;
+	}
+
+	INIT_HLIST_NODE(&entry->hnode);
+	entry->mapping = mapping;
+	range_tree_init(&entry->root);
+
+	hlist_add_head_rcu(&entry->hnode,
+		&mapping_hash[hash_ptr(mapping, mapping_hash_shift)]);
+
+	return &entry->root;
+}
+
+static inline void mapping_free_root(struct range_tree_root *root)
+{
+	struct mapping_hash_entry *entry;
+
+	entry = container_of(root, struct mapping_hash_entry, root);
+
+	hlist_del_rcu(&entry->hnode);
+	kfree(entry);
+}
+
+
+/* Range tree helpers */
+static inline u64 range_size(struct volatile_range *range)
+{
+	return range->range_node.end - range->range_node.start + 1;
+}
+
+static inline void lru_add(struct volatile_range *range)
+{
+	list_add_tail(&range->lru, &volatile_lru_list);
+	lru_count += range_size(range);
+}
+
+static inline void lru_del(struct volatile_range *range)
+{
+	list_del(&range->lru);
+	lru_count -= range_size(range);
+}
+
+#define range_on_lru(range) (!(range)->purged)
+
+
+static inline void volatile_range_resize(struct volatile_range *range,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	size_t pre = range_size(range);
+
+	range->range_node.start = start_index;
+	range->range_node.end = end_index;
+
+	if (range_on_lru(range))
+		lru_count -= pre - range_size(range);
+}
+
+static struct volatile_range *vrange_alloc(void)
+{
+	struct volatile_range *new;
+
+	new = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
+	if (!new)
+		return 0;
+	range_tree_node_init(&new->range_node);
+	return new;
+}
+
+static void vrange_del(struct range_tree_root *root,
+				struct volatile_range *vrange)
+{
+	if (range_on_lru(vrange))
+		lru_del(vrange);
+	range_tree_remove(root, &vrange->range_node);
+	kfree(vrange);
+}
+
+
+
+/*
+ * Mark a region as volatile, allowing dirty pages to be purged
+ * under memory pressure
+ */
+long mapping_range_volatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *new;
+	struct range_tree_node *node;
+	struct volatile_range *vrange;
+	struct range_tree_root *root;
+	u64 start, end;
+	int purged = 0;
+	start = (u64)start_index;
+	end = (u64)end_index;
+
+	if (strncmp(mapping->host->i_sb->s_type->name, "tmpfs",
+			strlen("tmpfs")))
+		return -EINVAL;
+
+	new = vrange_alloc();
+	if (!new)
+		return -ENOMEM;
+
+	mutex_lock(&volatile_mutex);
+
+
+	root = mapping_to_root(mapping);
+	if (!root)
+		root = mapping_allocate_root(mapping);
+
+	/* Find any existing ranges that overlap */
+	node = range_tree_in_range(root, start, end);
+	while (node) {
+		/* Already entirely marked volatile, so we're done */
+		if (node->start < start && node->end > end) {
+			/* don't need the allocated value */
+			kfree(new);
+			goto out;
+		}
+
+		/* Grab containing volatile range */
+		vrange = container_of(node, struct volatile_range, range_node);
+
+		/* resize range */
+		start = min_t(u64, start, node->start);
+		end = max_t(u64, end, node->end);
+		purged |= vrange->purged;
+
+		node = range_tree_next_in_range(&vrange->range_node,
+								start, end);
+		vrange_del(root, vrange);
+	}
+
+	/* Coalesce left-adjacent ranges */
+	node = range_tree_in_range(root, start-1, start);
+	if (node) {
+		vrange = container_of(node, struct volatile_range, range_node);
+		/* Only coalesce if both are either purged or unpurged */
+		if (vrange->purged == purged) {
+			/* resize range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			vrange_del(root, vrange);
+		}
+	}
+
+	/* Coalesce right-adjacent ranges */
+	node = range_tree_in_range(root, end, end+1);
+	if (node) {
+		vrange = container_of(node, struct volatile_range, range_node);
+		/* Only coalesce if both are either purged or unpurged */
+		if (vrange->purged == purged) {
+			/* resize range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			vrange_del(root, vrange);
+		}
+	}
+
+	new->mapping = mapping;
+	new->range_node.start = start;
+	new->range_node.end = end;
+	new->purged = purged;
+
+	if (purged) {
+		struct inode *inode;
+		loff_t pstart, pend;
+
+		inode = mapping->host;
+		pstart = start << PAGE_CACHE_SHIFT;
+		pend = ((end + 1) << PAGE_CACHE_SHIFT) - 1;
+		vmtruncate_range(inode, pstart, pend);
+	}
+	range_tree_add(root, &new->range_node);
+	if (range_on_lru(new))
+		lru_add(new);
+
+out:
+	mutex_unlock(&volatile_mutex);
+
+	return 0;
+}
+
+/*
+ * Mark a region as nonvolatile, returns 1 if any pages in the region
+ * were purged.
+ */
+long mapping_range_nonvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *new;
+	struct range_tree_node *node;
+	struct range_tree_root *root;
+	int ret  = 0;
+	u64 start, end;
+	int used_new = 0;
+
+	start = (u64)start_index;
+	end = (u64)end_index;
+
+	if (strncmp(mapping->host->i_sb->s_type->name, "tmpfs",
+			strlen("tmpfs")))
+		return -EINVAL;
+
+	/* create new node */
+	new = vrange_alloc();
+	if (!new)
+		return -ENOMEM;
+
+	mutex_lock(&volatile_mutex);
+	root = mapping_to_root(mapping);
+	if (!root)
+		goto out; /* if no range tree root, there's nothing to unmark */
+
+	node = range_tree_in_range(root, start, end);
+	while (node) {
+		struct volatile_range *vrange;
+		vrange = container_of(node, struct volatile_range, range_node);
+
+		ret |= vrange->purged;
+
+		if (start <= node->start && end >= node->end) {
+			/* delete: volatile range is totally within range */
+			node = range_tree_next_in_range(&vrange->range_node,
+								start, end);
+			vrange_del(root, vrange);
+		} else if (node->start >= start) {
+			/* resize: volatile range right-overlaps range */
+			volatile_range_resize(vrange, end+1, node->end);
+			node = range_tree_next_in_range(&vrange->range_node,
+								start, end);
+
+		} else if (node->end <= end) {
+			/* resize: volatile range left-overlaps range */
+			volatile_range_resize(vrange, node->start, start-1);
+			node = range_tree_next_in_range(&vrange->range_node,
+								start, end);
+		} else {
+			/* split: range is totally within a volatile range */
+			used_new = 1; /* we only do this once */
+			new->mapping = mapping;
+			new->range_node.start = end + 1;
+			new->range_node.end = node->end;
+			new->purged = vrange->purged;
+			range_tree_add(root, &new->range_node);
+			if (range_on_lru(new))
+				lru_add(new);
+			volatile_range_resize(vrange, node->start, start-1);
+
+			break;
+		}
+	}
+
+out:
+	mutex_unlock(&volatile_mutex);
+
+	if (!used_new)
+		kfree(new);
+
+	return ret;
+}
+
+
+/*
+ * Cleans up any volatile ranges.
+ */
+void mapping_clear_volatile_ranges(struct address_space *mapping)
+{
+	struct volatile_range *tozap;
+	struct range_tree_root *root;
+
+	mutex_lock(&volatile_mutex);
+
+	root = mapping_to_root(mapping);
+	if (!root)
+		goto out;
+
+	while (!range_tree_empty(root)) {
+		struct range_tree_node *tmp;
+		tmp = range_tree_root_node(root);
+		tozap = container_of(tmp, struct volatile_range, range_node);
+		vrange_del(root, tozap);
+	}
+	mapping_free_root(root);
+out:
+	mutex_unlock(&volatile_mutex);
+}
+
+/*
+ * Purges volatile ranges when under memory pressure
+ */
+static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
+{
+	struct volatile_range *range, *next;
+	s64 nr_to_scan = sc->nr_to_scan;
+	const gfp_t gfp_mask = sc->gfp_mask;
+
+	if (nr_to_scan && !(gfp_mask & __GFP_FS))
+		return -1;
+	if (!nr_to_scan)
+		return lru_count;
+
+	mutex_lock(&volatile_mutex);
+	list_for_each_entry_safe(range, next, &volatile_lru_list, lru) {
+		struct inode *inode;
+		loff_t start, end;
+
+		inode = range->mapping->host;
+
+		start = range->range_node.start << PAGE_CACHE_SHIFT;
+		end = ((range->range_node.end + 1) << PAGE_CACHE_SHIFT) - 1;
+
+		shmem_truncate_range(inode, start, end);
+
+		lru_del(range);
+		range->purged = 1;
+		nr_to_scan -= range_size(range);
+
+		if (nr_to_scan <= 0)
+			break;
+	}
+	mutex_unlock(&volatile_mutex);
+
+	return lru_count;
+}
+
+static struct shrinker volatile_shrinker = {
+	.shrink = volatile_shrink,
+	.seeks = DEFAULT_SEEKS,
+};
+
+static int __init volatile_init(void)
+{
+	int i, size;
+
+	size = 1U << mapping_hash_shift;
+
+	mapping_hash = kzalloc(sizeof(mapping_hash)*size, GFP_KERNEL);
+
+	for (i = 0; i < size; i++)
+		INIT_HLIST_HEAD(&mapping_hash[i]);
+
+	register_shrinker(&volatile_shrinker);
+
+
+	return 0;
+}
+
+arch_initcall(volatile_init);
-- 
1.7.3.2.146.gca209

