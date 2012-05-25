Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab2EYTSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:18:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45494 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab2EYTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:18:14 -0400
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
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>
Subject: [PATCH 3/4] [RFC] Add volatile range management code
Date: Fri, 25 May 2012 12:17:35 -0700
Message-Id: <1337973456-19533-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052519-3270-0000-0000-000006A60F18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the volatile range management code
that filesystems can utilize when implementing
FALLOC_FL_MARK_VOLATILE.

It tracks a collection of page ranges against a mapping
stored in a range-tree. This code handles coalescing
overlapping and adjacent ranges, as well as splitting
ranges when sub-chunks are removed.

The ranges can be marked purged or unpurged. And there is
a per-fs lru list that tracks all the unpurged ranges for
that fs.

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

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/volatile.h |   43 ++++
 mm/Makefile              |    2 +-
 mm/volatile.c            |  493 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 537 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

diff --git a/include/linux/volatile.h b/include/linux/volatile.h
new file mode 100644
index 0000000..69148d0
--- /dev/null
+++ b/include/linux/volatile.h
@@ -0,0 +1,43 @@
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
+	.lru_head = LIST_HEAD_INIT(name.lru_head)			\
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
+extern s64 volatile_range_lru_size(struct volatile_fs_head *head);
+
+extern void volatile_range_clear(struct volatile_fs_head *head,
+					struct address_space *mapping);
+
+extern s64 volatile_ranges_get_last_used(struct volatile_fs_head *head,
+				struct address_space **mapping,
+				loff_t *start, loff_t *end);
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
diff --git a/mm/volatile.c b/mm/volatile.c
new file mode 100644
index 0000000..13f6a88
--- /dev/null
+++ b/mm/volatile.c
@@ -0,0 +1,493 @@
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
+#include <linux/rangetree.h>
+#include <linux/hash.h>
+#include <linux/shmem_fs.h>
+
+
+struct volatile_range {
+	struct list_head	lru;
+	struct range_tree_node	range_node;
+	unsigned int		purged;
+	struct address_space	*mapping;
+};
+
+
+/*
+ * To avoid bloating the address_space structure, we use
+ * a hash structure to map from address_space mappings to
+ * the range_tree root that stores volatile ranges
+ */
+static DEFINE_MUTEX(hash_mutex);
+static struct hlist_head *mapping_hash;
+static long mapping_hash_shift = 8;
+struct mapping_hash_entry {
+	struct range_tree_root root;
+	struct address_space *mapping;
+	struct hlist_node hnode;
+};
+
+
+static inline
+struct range_tree_root *__mapping_to_root(struct address_space *mapping)
+{
+	struct hlist_node *elem;
+	struct mapping_hash_entry *entry;
+	struct range_tree_root *ret = NULL;
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
+struct range_tree_root *mapping_to_root(struct address_space *mapping)
+{
+	struct range_tree_root *ret;
+
+	mutex_lock(&hash_mutex);
+	ret =  __mapping_to_root(mapping);
+	mutex_unlock(&hash_mutex);
+	return ret;
+}
+
+
+static inline
+struct range_tree_root *mapping_allocate_root(struct address_space *mapping)
+{
+	struct mapping_hash_entry *entry;
+	struct range_tree_root *dblchk;
+	struct range_tree_root *ret = NULL;
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
+	range_tree_init(&entry->root);
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
+static inline void mapping_free_root(struct range_tree_root *root)
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
+static inline void volatile_range_resize(struct volatile_range *range,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	range->range_node.start = start_index;
+	range->range_node.end = end_index;
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
+	if (!vrange->purged)
+		list_del(&vrange->lru);
+	range_tree_remove(root, &vrange->range_node);
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
+	struct range_tree_node *node;
+	struct volatile_range *vrange;
+	struct range_tree_root *root;
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
+	/* First, find any existing ranges that overlap */
+	node = range_tree_in_range(root, start, end);
+	while (node) {
+		/* Already entirely marked volatile, so we're done */
+		if (node->start < start && node->end > end) {
+			/* don't need the allocated value */
+			kfree(new);
+			return purged;
+		}
+
+		/* Grab containing volatile range */
+		vrange = container_of(node, struct volatile_range, range_node);
+
+		/* Resize the new range to cover all overlapping ranges */
+		start = min_t(u64, start, node->start);
+		end = max_t(u64, end, node->end);
+
+		/* Inherit purged state from overlapping ranges */
+		purged |= vrange->purged;
+
+		node = range_tree_next_in_range(&vrange->range_node,
+								start, end);
+		/* Delete the old range, as we consume it */
+		vrange_del(root, vrange);
+	}
+
+	/* Coalesce left-adjacent ranges */
+	node = range_tree_in_range(root, start-1, start);
+	if (node) {
+		vrange = container_of(node, struct volatile_range, range_node);
+		/* Only coalesce if both are either purged or unpurged */
+		if (vrange->purged == purged) {
+			/* resize new range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			/* delete old range */
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
+			/* resize new range */
+			start = min_t(u64, start, node->start);
+			end = max_t(u64, end, node->end);
+			/* delete old range */
+			vrange_del(root, vrange);
+		}
+	}
+	/* Assign and store the new range in the range tree */
+	new->mapping = mapping;
+	new->range_node.start = start;
+	new->range_node.end = end;
+	new->purged = purged;
+	range_tree_add(root, &new->range_node);
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
+	struct range_tree_node *node;
+	struct range_tree_root *root;
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
+		goto out; /* if no range tree root, there's nothing to unmark */
+
+
+	/* Find any overlapping ranges */
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
+			if (!new->purged)
+				list_add_tail(&new->lru, &head->lru_head);
+			volatile_range_resize(vrange, node->start, start-1);
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
+/**
+ * volatile_range_lru_size: Returns the number of unpurged pages on the lru
+ * @head: per-fs volatile head
+ *
+ * Returns the number of unpurged pages on the LRU
+ *
+ * Must lock the volatile_fs_head before calling!
+ *
+ */
+s64 volatile_range_lru_size(struct volatile_fs_head *head)
+{
+	struct volatile_range *range, *next;
+	s64 size = 0;
+
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	list_for_each_entry_safe(range, next, &head->lru_head, lru) {
+		size += range->range_node.end - range->range_node.start;
+	}
+	return size;
+}
+
+
+/**
+ * volatile_ranges_get_last_used: Returns mapping and size of lru unpurged range
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
+s64 volatile_ranges_get_last_used(struct volatile_fs_head *head,
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
+	*start = range->range_node.start << PAGE_CACHE_SHIFT;
+	*end = ((range->range_node.end + 1) << PAGE_CACHE_SHIFT) - 1;
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
+	struct range_tree_root *root;
+
+	WARN_ON(!mutex_is_locked(&head->lock));
+
+	root = mapping_to_root(mapping);
+	if (!root)
+		return;
+
+	while (!range_tree_empty(root)) {
+		struct range_tree_node *tmp;
+		tmp = range_tree_root_node(root);
+		tozap = container_of(tmp, struct volatile_range, range_node);
+		vrange_del(root, tozap);
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

