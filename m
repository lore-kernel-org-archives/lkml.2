Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966062Ab2FAXj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:39:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40910 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966015Ab2FAXjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:39:05 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH 2/3] [RFC] Add volatile range management code
Date: Fri,  1 Jun 2012 16:38:45 -0700
Message-Id: <1338593926-17344-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1338593926-17344-1-git-send-email-john.stultz@linaro.org>
References: <1338593926-17344-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060123-1976-0000-0000-00000DBF3C05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the volatile range management code
that filesystems can utilize when implementing
FALLOC_FL_MARK_VOLATILE.

It tracks a collection of page ranges against a mapping
stored in an interval-tree. This code handles coalescing
overlapping and adjacent ranges, as well as splitting
ranges when sub-chunks are removed.

The ranges can be marked purged or unpurged. And there is
a per-fs lru list that tracks all the unpurged ranges for
that fs.

v2:
* Fix bug in volatile_ranges_get_last_used returning bad
  start,end values
* Rework for intervaltree renaming
* Optimize volatile_range_lru_size to avoid running through
  lru list each time.

v3:
* Improve function name to make it clear what the
  volatile_ranges_pluck_lru() code does.
* Drop volatile_range_lru_size and unpurged_page_count
  mangement as its now unused

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
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/volatile.h |   41 ++++
 mm/Makefile              |    2 +-
 mm/volatile.c            |  486 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 528 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

diff --git a/include/linux/volatile.h b/include/linux/volatile.h
new file mode 100644
index 0000000..8deee06
--- /dev/null
+++ b/include/linux/volatile.h
@@ -0,0 +1,41 @@
+#ifndef _LINUX_VOLATILE_H
+#define _LINUX_VOLATILE_H
+
+#include <linux/fs.h>
+
+struct volatile_fs_head {
+	struct mutex lock;
+	struct list_head lru_head;
+};
+
+
+#define DEFINE_VOLATILE_FS_HEAD(name) struct volatile_fs_head name = {	\
+	.lock = __MUTEX_INITIALIZER(name.lock),				\
+	.lru_head = LIST_HEAD_INIT(name.lru_head),			\
+}
+
+
+static inline void volatile_range_lock(struct volatile_fs_head *head)
+{
+	mutex_lock(&head->lock);
+}
+
+static inline void volatile_range_unlock(struct volatile_fs_head *head)
+{
+	mutex_unlock(&head->lock);
+}
+
+extern long volatile_range_add(struct volatile_fs_head *head,
+				struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long volatile_range_remove(struct volatile_fs_head *head,
+				struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+
+extern void volatile_range_clear(struct volatile_fs_head *head,
+					struct address_space *mapping);
+
+extern s64 volatile_ranges_pluck_lru(struct volatile_fs_head *head,
+				struct address_space **mapping,
+				loff_t *start, loff_t *end);
+#endif /* _LINUX_VOLATILE_H */
diff --git a/mm/Makefile b/mm/Makefile
index a156285..dc79eb8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -16,7 +16,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o percpu.o \
-			   compaction.o $(mmu-y)
+			   compaction.o volatile.o $(mmu-y)
 obj-y += init-mm.o
 
 ifdef CONFIG_NO_BOOTMEM
diff --git a/mm/volatile.c b/mm/volatile.c
new file mode 100644
index 0000000..7d6dc9b
--- /dev/null
+++ b/mm/volatile.c
@@ -0,0 +1,486 @@
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
+ * The volatile range management is a helper layer on top of the range tree
+ * code, which is used to help filesystems manage page ranges that are volatile.
+ *
+ * These ranges are stored in a per-mapping range tree. Storing both purged and
+ * unpurged ranges connected to that address_space. Unpurged ranges are also
+ * linked together in an lru list that is per-volatile-fs-head (basically
+ * per-filesystem).
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
+#include <linux/intervaltree.h>
+#include <linux/hash.h>
+#include <linux/shmem_fs.h>
+
+
+struct volatile_range {
+	struct list_head		lru;
+	struct interval_tree_node	interval_node;
+	unsigned int			purged;
+	struct address_space		*mapping;
+};
+
+
+/*
+ * To avoid bloating the address_space structure, we use
+ * a hash structure to map from address_space mappings to
+ * the interval_tree root that stores volatile ranges
+ */
+static DEFINE_MUTEX(hash_mutex);
+static struct hlist_head *mapping_hash;
+static long mapping_hash_shift = 8;
+struct mapping_hash_entry {
+	struct interval_tree_root	root;
+	struct address_space		*mapping;
+	struct hlist_node		hnode;
+};
+
+
+static inline
+struct interval_tree_root *__mapping_to_root(struct address_space *mapping)
+{
+	struct hlist_node *elem;
+	struct mapping_hash_entry *entry;
+	struct interval_tree_root *ret = NULL;
+
+	hlist_for_each_entry_rcu(entry, elem,
+			&mapping_hash[hash_ptr(mapping, mapping_hash_shift)],
+				hnode)
+		if (entry->mapping == mapping)
+			ret =  &entry->root;
+
+	return ret;
+}
+
+
+static inline
+struct interval_tree_root *mapping_to_root(struct address_space *mapping)
+{
+	struct interval_tree_root *ret;
+
+	mutex_lock(&hash_mutex);
+	ret =  __mapping_to_root(mapping);
+	mutex_unlock(&hash_mutex);
+	return ret;
+}
+
+
+static inline
+struct interval_tree_root *mapping_allocate_root(struct address_space *mapping)
+{
+	struct mapping_hash_entry *entry;
+	struct interval_tree_root *dblchk;
+	struct interval_tree_root *ret = NULL;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+
+	mutex_lock(&hash_mutex);
+	/* Since we dropped the lock, double check that no one has
+	 * created the same hash entry.
+	 */
+	dblchk = __mapping_to_root(mapping);
+	if (dblchk) {
+		kfree(entry);
+		ret = dblchk;
+		goto out;
+	}
+
+	INIT_HLIST_NODE(&entry->hnode);
+	entry->mapping = mapping;
+	interval_tree_init(&entry->root);
+
+	hlist_add_head_rcu(&entry->hnode,
+		&mapping_hash[hash_ptr(mapping, mapping_hash_shift)]);
+
+	ret = &entry->root;
+out:
+	mutex_unlock(&hash_mutex);
+	return ret;
+}
+
+
+static inline void mapping_free_root(struct interval_tree_root *root)
+{
+	struct mapping_hash_entry *entry;
+
+	mutex_lock(&hash_mutex);
+	entry = container_of(root, struct mapping_hash_entry, root);
+
+	hlist_del_rcu(&entry->hnode);
+	kfree(entry);
+	mutex_unlock(&hash_mutex);
+}
+
+
+/* volatile range helpers */
+static inline void vrange_resize(struct volatile_fs_head *head,
+				struct volatile_range *range,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	s64 old_size, new_size;
+
+	old_size = range->interval_node.end - range->interval_node.start;
+	new_size = end_index-start_index;
+
+	range->interval_node.start = start_index;
+	range->interval_node.end = end_index;
+}
+
+static struct volatile_range *vrange_alloc(void)
+{
+	struct volatile_range *new;
+
+	new = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
+	if (!new)
+		return 0;
+	interval_tree_node_init(&new->interval_node);
+	return new;
+}
+
+static void vrange_del(struct volatile_fs_head *head,
+				struct interval_tree_root *root,
+				struct volatile_range *vrange)
+{
+	if (!vrange->purged)
+		list_del(&vrange->lru);
+	interval_tree_remove(root, &vrange->interval_node);
+	kfree(vrange);
+}
+
+
+/**
+ * volatile_range_add: Marks a page interval as volatile
+ * @head: per-fs volatile head
+ * @mapping: address space who's range is being marked volatile
+ * @start_index: Starting page in range to be marked volatile
+ * @end_index: Ending page in range to be marked volatile
+ *
+ * Mark a region as volatile. Coalesces overlapping and neighboring regions.
+ *
+ * Must lock the volatile_fs_head before calling!
+ *
+ * Returns 1 if the range was coalesced with any purged ranges.
+ * Returns 0 on success.
+ */
+long volatile_range_add(struct volatile_fs_head *head,
+				struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *new;
+	struct interval_tree_node *node;
+	struct volatile_range *vrange;
+	struct interval_tree_root *root;
+	int purged = 0;
+	u64 start = (u64)start_index;
+	u64 end = (u64)end_index;
+
+	/* Make sure we're properly locked */
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	/*
+	 * Because the lock might be held in a shrinker, release
+	 * it during allocation.
+	 */
+	mutex_unlock(&head->lock);
+	new = vrange_alloc();
+	mutex_lock(&head->lock);
+	if (!new)
+		return -ENOMEM;
+
+	root = mapping_to_root(mapping);
+	if (!root) {
+		mutex_unlock(&head->lock);
+		root = mapping_allocate_root(mapping);
+		mutex_lock(&head->lock);
+		if (!root) {
+			kfree(new);
+			return -ENOMEM;
+		}
+	}
+
+	/* First, find any existing intervals that overlap */
+	node = interval_tree_in_interval(root, start, end);
+	while (node) {
+		/* Already entirely marked volatile, so we're done */
+		if (node->start < start && node->end > end) {
+			/* don't need the allocated value */
+			kfree(new);
+			return purged;
+		}
+
+		/* Grab containing volatile range */
+		vrange = container_of(node, struct volatile_range,
+								interval_node);
+
+		/* Resize the new range to cover all overlapping ranges */
+		start = min_t(u64, start, node->start);
+		end = max_t(u64, end, node->end);
+
+		/* Inherit purged state from overlapping ranges */
+		purged |= vrange->purged;
+
+
+		node = interval_tree_next_in_interval(&vrange->interval_node,
+								start, end);
+		/* Delete the old range, as we consume it */
+		vrange_del(head, root, vrange);
+	}
+
+	/* Coalesce left-adjacent ranges */
+	node = interval_tree_in_interval(root, start-1, start);
+	if (node) {
+		vrange = container_of(node, struct volatile_range,
+								interval_node);
+		/* Only coalesce if both are either purged or unpurged */
+		if (vrange->purged == purged) {
+			/* resize new range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			/* delete old range */
+			vrange_del(head, root, vrange);
+		}
+	}
+
+	/* Coalesce right-adjacent ranges */
+	node = interval_tree_in_interval(root, end, end+1);
+	if (node) {
+		vrange = container_of(node, struct volatile_range,
+								interval_node);
+		/* Only coalesce if both are either purged or unpurged */
+		if (vrange->purged == purged) {
+			/* resize new range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			/* delete old range */
+			vrange_del(head, root, vrange);
+		}
+	}
+	/* Assign and store the new range in the range tree */
+	new->mapping = mapping;
+	new->interval_node.start = start;
+	new->interval_node.end = end;
+	new->purged = purged;
+	interval_tree_add(root, &new->interval_node);
+
+	/* Only add unpurged ranges to LRU */
+	if (!purged)
+		list_add_tail(&new->lru, &head->lru_head);
+
+	return purged;
+}
+
+
+/**
+ * volatile_range_remove: Marks a page interval as nonvolatile
+ * @head: per-fs volatile head
+ * @mapping: address space who's range is being marked nonvolatile
+ * @start_index: Starting page in range to be marked nonvolatile
+ * @end_index: Ending page in range to be marked nonvolatile
+ *
+ * Mark a region as nonvolatile. And remove any contained pages
+ * from the volatile range tree.
+ *
+ * Must lock the volatile_fs_head before calling!
+ *
+ * Returns 1 if any portion of the range was purged.
+ * Returns 0 on success.
+ */
+long volatile_range_remove(struct volatile_fs_head *head,
+				struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *new;
+	struct interval_tree_node *node;
+	struct interval_tree_root *root;
+	int ret		= 0;
+	int used_new	= 0;
+	u64 start	= (u64)start_index;
+	u64 end		= (u64)end_index;
+
+	/* Make sure we're properly locked */
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	/*
+	 * Because the lock might be held in a shrinker, release
+	 * it during allocation.
+	 */
+	mutex_unlock(&head->lock);
+	new = vrange_alloc();
+	mutex_lock(&head->lock);
+	if (!new)
+		return -ENOMEM;
+
+	root = mapping_to_root(mapping);
+	if (!root)
+		goto out;
+
+
+	/* Find any overlapping ranges */
+	node = interval_tree_in_interval(root, start, end);
+	while (node) {
+		struct volatile_range *vrange;
+		vrange = container_of(node, struct volatile_range,
+								interval_node);
+
+		ret |= vrange->purged;
+
+		if (start <= node->start && end >= node->end) {
+			/* delete: volatile range is totally within range */
+			node = interval_tree_next_in_interval(
+							&vrange->interval_node,
+							start, end);
+			vrange_del(head, root, vrange);
+		} else if (node->start >= start) {
+			/* resize: volatile range right-overlaps range */
+			vrange_resize(head, vrange, end+1, node->end);
+			node = interval_tree_next_in_interval(
+							&vrange->interval_node,
+							start, end);
+
+		} else if (node->end <= end) {
+			/* resize: volatile range left-overlaps range */
+			vrange_resize(head, vrange, node->start, start-1);
+			node = interval_tree_next_in_interval(
+							&vrange->interval_node,
+							start, end);
+		} else {
+			/* split: range is totally within a volatile range */
+			used_new = 1; /* we only do this once */
+			new->mapping = mapping;
+			new->interval_node.start = end + 1;
+			new->interval_node.end = node->end;
+			new->purged = vrange->purged;
+			interval_tree_add(root, &new->interval_node);
+			if (!new->purged)
+				list_add_tail(&new->lru, &head->lru_head);
+			vrange_resize(head, vrange, node->start, start-1);
+
+			break;
+		}
+	}
+
+out:
+	if (!used_new)
+		kfree(new);
+
+	return ret;
+}
+
+
+/**
+ * volatile_ranges_pluck_lru: Returns mapping and size of lru unpurged range
+ * @head: per-fs volatile head
+ * @mapping: dbl pointer to mapping who's range is being purged
+ * @start: Pointer to starting address of range being purged
+ * @end: Pointer to ending address of range being purged
+ *
+ * Returns the mapping, start and end values of the least recently used
+ * range. Marks the range as purged and removes it from the LRU.
+ *
+ * Must lock the volatile_fs_head before calling!
+ *
+ * Returns 1 on success if a range was returned
+ * Return 0 if no ranges were found.
+ */
+s64 volatile_ranges_pluck_lru(struct volatile_fs_head *head,
+				struct address_space **mapping,
+				loff_t *start, loff_t *end)
+{
+	struct volatile_range *range;
+
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	if (list_empty(&head->lru_head))
+		return 0;
+
+	range = list_first_entry(&head->lru_head, struct volatile_range, lru);
+
+	*start = range->interval_node.start;
+	*end = range->interval_node.end;
+	*mapping = range->mapping;
+
+	list_del(&range->lru);
+	range->purged = 1;
+
+	return 1;
+}
+
+
+/*
+ * Cleans up any volatile ranges.
+ */
+void volatile_range_clear(struct volatile_fs_head *head,
+				struct address_space *mapping)
+{
+	struct volatile_range *tozap;
+	struct interval_tree_root *root;
+
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	root = mapping_to_root(mapping);
+	if (!root)
+		return;
+
+	while (!interval_tree_empty(root)) {
+		struct interval_tree_node *tmp;
+		tmp = interval_tree_root_node(root);
+		tozap = container_of(tmp, struct volatile_range, interval_node);
+		vrange_del(head, root, tozap);
+	}
+	mapping_free_root(root);
+}
+
+
+static int __init volatile_init(void)
+{
+	int i, size;
+
+	size = 1U << mapping_hash_shift;
+	mapping_hash = kzalloc(sizeof(mapping_hash)*size, GFP_KERNEL);
+	for (i = 0; i < size; i++)
+		INIT_HLIST_HEAD(&mapping_hash[i]);
+
+	return 0;
+}
+arch_initcall(volatile_init);
-- 
1.7.3.2.146.gca209

