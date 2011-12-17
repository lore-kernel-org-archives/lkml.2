Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1LQH4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:56:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1LQH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:56:33 -0500
Date: Fri, 16 Dec 2011 23:56:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] rtth: copy current radix_tree source
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112162355200.1981@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rtth's radix-tree.c and radix-tree.h with versions from 3.2 kernel
(omitting radix_tree_indirect_to_ptr() which will vanish soon after).
As before, just a very few differences for the build here, with more
hacks in types.h and now notifier.h to minimize those.

Similarly update regression1.c's find_get_pages() loop to match
that in mm/filemap.c (but we shouldn't see any exceptional entries),
and test.h's definitions and radix_tree_node (mostly just whitespace).

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 linux/notifier.h   |    4 +
 linux/radix-tree.h |   58 ++++++++++++++++--
 linux/types.h      |    7 +-
 radix-tree.c       |  137 ++++++++++++++++++++++++++++++++++++-------
 regression1.c      |   20 ++++--
 test.h             |   21 +++---
 6 files changed, 204 insertions(+), 43 deletions(-)

--- rtth2/linux/notifier.h	1969-12-31 16:00:00.000000000 -0800
+++ rtth3/linux/notifier.h	2011-12-16 18:44:04.551896997 -0800
@@ -0,0 +1,4 @@
+#ifndef _NOTIFIER_H
+#define _NOTIFIER_H
+
+#endif
--- rtth2/linux/radix-tree.h	2010-11-10 16:35:29.000000000 -0800
+++ rtth3/linux/radix-tree.h	2011-12-16 18:44:04.551896997 -0800
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
-#include <linux/gfp.h>
 
 /*
  * An indirect pointer (root->rnode pointing to a radix_tree_node, rather
@@ -40,7 +39,15 @@
  * when it is shrunk, before we rcu free the node. See shrink code for
  * details.
  */
-#define RADIX_TREE_INDIRECT_PTR	1
+#define RADIX_TREE_INDIRECT_PTR		1
+/*
+ * A common use of the radix tree is to store pointers to struct pages;
+ * but shmem/tmpfs needs also to store swap entries in the same tree:
+ * those are marked as exceptional entries to distinguish them.
+ * EXCEPTIONAL_ENTRY tests the bit, EXCEPTIONAL_SHIFT shifts content past it.
+ */
+#define RADIX_TREE_EXCEPTIONAL_ENTRY	2
+#define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
@@ -55,7 +62,7 @@ static inline int radix_tree_is_indirect
 struct radix_tree_root {
 	unsigned int		height;
 	gfp_t			gfp_mask;
-	struct radix_tree_node	*rnode;
+	struct radix_tree_node	__rcu *rnode;
 };
 
 #define RADIX_TREE_INIT(mask)	{					\
@@ -144,6 +151,24 @@ static inline void *radix_tree_deref_slo
 }
 
 /**
+ * radix_tree_deref_slot_protected	- dereference a slot without RCU lock but with tree lock held
+ * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
+ * Returns:	item that was stored in that slot with any direct pointer flag
+ *		removed.
+ *
+ * Similar to radix_tree_deref_slot but only used during migration when a pages
+ * mapping is being moved. The caller does not hold the RCU read lock but it
+ * must hold the tree lock to prevent parallel updates.
+ */
+#if 0
+static inline void *radix_tree_deref_slot_protected(void **pslot,
+							spinlock_t *treelock)
+{
+	return rcu_dereference_protected(*pslot, lockdep_is_held(treelock));
+}
+#endif
+
+/**
  * radix_tree_deref_retry	- check radix_tree_deref_slot
  * @arg:	pointer returned by radix_tree_deref_slot
  * Returns:	0 if retry is not required, otherwise retry is required
@@ -156,6 +181,28 @@ static inline int radix_tree_deref_retry
 }
 
 /**
+ * radix_tree_exceptional_entry	- radix_tree_deref_slot gave exceptional entry?
+ * @arg:	value returned by radix_tree_deref_slot
+ * Returns:	0 if well-aligned pointer, non-0 if exceptional entry.
+ */
+static inline int radix_tree_exceptional_entry(void *arg)
+{
+	/* Not unlikely because radix_tree_exception often tested first */
+	return (unsigned long)arg & RADIX_TREE_EXCEPTIONAL_ENTRY;
+}
+
+/**
+ * radix_tree_exception	- radix_tree_deref_slot returned either exception?
+ * @arg:	value returned by radix_tree_deref_slot
+ * Returns:	0 if well-aligned pointer, non-0 if either kind of exception.
+ */
+static inline int radix_tree_exception(void *arg)
+{
+	return unlikely((unsigned long)arg &
+		(RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
+}
+
+/**
  * radix_tree_replace_slot	- replace item in a slot
  * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
  * @item:	new item to store in the slot.
@@ -176,8 +223,8 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
-unsigned int
-radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
+unsigned int radix_tree_gang_lookup_slot(struct radix_tree_root *root,
+			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items);
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
@@ -204,6 +251,7 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int fromtag, unsigned int totag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
+unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item);
 
 static inline void radix_tree_preload_end(void)
 {
--- rtth2/linux/types.h	2011-12-16 18:44:03.515896619 -0800
+++ rtth3/linux/types.h	2011-12-16 18:44:04.551896997 -0800
@@ -1,11 +1,14 @@
 #ifndef _TYPES_H
 #define _TYPES_H
 
-#define __nocast
+#define __rcu
 #define __read_mostly
 
 #define BITS_PER_LONG (sizeof(long) * 8)
 
-typedef unsigned __nocast gfp_t;
+#define uninitialized_var(x) x = x
+
+typedef unsigned gfp_t;
+#include <linux/gfp.h>
 
 #endif
--- rtth2/radix-tree.c	2011-01-24 22:15:32.000000000 -0800
+++ rtth3/radix-tree.c	2011-12-16 18:44:04.551896997 -0800
@@ -26,7 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
-/* #include <linux/notifier.h> */
+#include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
@@ -49,7 +49,7 @@ struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
 	unsigned int	count;
 	struct rcu_head	rcu_head;
-	void		*slots[RADIX_TREE_MAP_SIZE];
+	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
@@ -576,7 +576,6 @@ int radix_tree_tag_get(struct radix_tree
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node;
-	int saw_unset_tag = 0;
 
 	/* check the root's tag bit */
 	if (!root_tag_get(root, tag))
@@ -603,15 +602,10 @@ int radix_tree_tag_get(struct radix_tree
 			return 0;
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-
-		/*
-		 * This is just a debug check.  Later, we can bale as soon as
-		 * we see an unset tag.
-		 */
 		if (!tag_get(node, tag, offset))
-			saw_unset_tag = 1;
+			return 0;
 		if (height == 1)
-			return !!tag_get(node, tag, offset);
+			return 1;
 		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
@@ -823,8 +817,8 @@ unsigned long radix_tree_prev_hole(struc
 EXPORT_SYMBOL(radix_tree_prev_hole);
 
 static unsigned int
-__lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index)
+__lookup(struct radix_tree_node *slot, void ***results, unsigned long *indices,
+	unsigned long index, unsigned int max_items, unsigned long *next_index)
 {
 	unsigned int nr_found = 0;
 	unsigned int shift, height;
@@ -857,12 +851,16 @@ __lookup(struct radix_tree_node *slot, v
 
 	/* Bottom level: grab some items */
 	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
-		index++;
 		if (slot->slots[i]) {
-			results[nr_found++] = &(slot->slots[i]);
-			if (nr_found == max_items)
+			results[nr_found] = &(slot->slots[i]);
+			if (indices)
+				indices[nr_found] = index;
+			if (++nr_found == max_items) {
+				index++;
 				goto out;
+			}
 		}
+		index++;
 	}
 out:
 	*next_index = index;
@@ -918,8 +916,8 @@ radix_tree_gang_lookup(struct radix_tree
 
 		if (cur_index > max_index)
 			break;
-		slots_found = __lookup(node, (void ***)results + ret, cur_index,
-					max_items - ret, &next_index);
+		slots_found = __lookup(node, (void ***)results + ret, NULL,
+				cur_index, max_items - ret, &next_index);
 		nr_found = 0;
 		for (i = 0; i < slots_found; i++) {
 			struct radix_tree_node *slot;
@@ -944,6 +942,7 @@ EXPORT_SYMBOL(radix_tree_gang_lookup);
  *	radix_tree_gang_lookup_slot - perform multiple slot lookup on radix tree
  *	@root:		radix tree root
  *	@results:	where the results of the lookup are placed
+ *	@indices:	where their indices should be placed (but usually NULL)
  *	@first_index:	start the lookup from this key
  *	@max_items:	place up to this many items at *results
  *
@@ -958,7 +957,8 @@ EXPORT_SYMBOL(radix_tree_gang_lookup);
  *	protection, radix_tree_deref_slot may fail requiring a retry.
  */
 unsigned int
-radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
+radix_tree_gang_lookup_slot(struct radix_tree_root *root,
+			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items)
 {
 	unsigned long max_index;
@@ -974,6 +974,8 @@ radix_tree_gang_lookup_slot(struct radix
 		if (first_index > 0)
 			return 0;
 		results[0] = (void **)&root->rnode;
+		if (indices)
+			indices[0] = 0;
 		return 1;
 	}
 	node = indirect_to_ptr(node);
@@ -987,8 +989,9 @@ radix_tree_gang_lookup_slot(struct radix
 
 		if (cur_index > max_index)
 			break;
-		slots_found = __lookup(node, results + ret, cur_index,
-					max_items - ret, &next_index);
+		slots_found = __lookup(node, results + ret,
+				indices ? indices + ret : NULL,
+				cur_index, max_items - ret, &next_index);
 		ret += slots_found;
 		if (next_index == 0)
 			break;
@@ -1194,6 +1197,98 @@ radix_tree_gang_lookup_tag_slot(struct r
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup_tag_slot);
 
+#if defined(CONFIG_SHMEM) && defined(CONFIG_SWAP)
+#include <linux/sched.h> /* for cond_resched() */
+
+/*
+ * This linear search is at present only useful to shmem_unuse_inode().
+ */
+static unsigned long __locate(struct radix_tree_node *slot, void *item,
+			      unsigned long index, unsigned long *found_index)
+{
+	unsigned int shift, height;
+	unsigned long i;
+
+	height = slot->height;
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+
+	for ( ; height > 1; height--) {
+		i = (index >> shift) & RADIX_TREE_MAP_MASK;
+		for (;;) {
+			if (slot->slots[i] != NULL)
+				break;
+			index &= ~((1UL << shift) - 1);
+			index += 1UL << shift;
+			if (index == 0)
+				goto out;	/* 32-bit wraparound */
+			i++;
+			if (i == RADIX_TREE_MAP_SIZE)
+				goto out;
+		}
+
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = rcu_dereference_raw(slot->slots[i]);
+		if (slot == NULL)
+			goto out;
+	}
+
+	/* Bottom level: check items */
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+		if (slot->slots[i] == item) {
+			*found_index = index + i;
+			index = 0;
+			goto out;
+		}
+	}
+	index += RADIX_TREE_MAP_SIZE;
+out:
+	return index;
+}
+
+/**
+ *	radix_tree_locate_item - search through radix tree for item
+ *	@root:		radix tree root
+ *	@item:		item to be found
+ *
+ *	Returns index where item was found, or -1 if not found.
+ *	Caller must hold no lock (since this time-consuming function needs
+ *	to be preemptible), and must check afterwards if item is still there.
+ */
+unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item)
+{
+	struct radix_tree_node *node;
+	unsigned long max_index;
+	unsigned long cur_index = 0;
+	unsigned long found_index = -1;
+
+	do {
+		rcu_read_lock();
+		node = rcu_dereference_raw(root->rnode);
+		if (!radix_tree_is_indirect_ptr(node)) {
+			rcu_read_unlock();
+			if (node == item)
+				found_index = 0;
+			break;
+		}
+
+		node = indirect_to_ptr(node);
+		max_index = radix_tree_maxindex(node->height);
+		if (cur_index > max_index)
+			break;
+
+		cur_index = __locate(node, item, cur_index, &found_index);
+		rcu_read_unlock();
+		cond_resched();
+	} while (cur_index != 0 && cur_index <= max_index);
+
+	return found_index;
+}
+#else
+unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item)
+{
+	return -1;
+}
+#endif /* CONFIG_SHMEM && CONFIG_SWAP */
 
 /**
  *	radix_tree_shrink    -    shrink height of a radix tree to minimal
@@ -1418,5 +1513,5 @@ void __init radix_tree_init(void)
 			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
 			radix_tree_node_ctor);
 	radix_tree_init_maxindex();
-	/* hotcpu_notifier(radix_tree_callback, 0); */
+	hotcpu_notifier(radix_tree_callback, 0);
 }
--- rtth2/regression1.c	2010-11-10 16:35:48.000000000 -0800
+++ rtth3/regression1.c	2011-12-16 18:44:04.551896997 -0800
@@ -86,7 +86,7 @@ static unsigned find_get_pages(unsigned
 	rcu_read_lock();
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mt_tree,
-				(void ***)pages, start, nr_pages);
+				(void ***)pages, NULL, start, nr_pages);
 	ret = 0;
 	for (i = 0; i < nr_found; i++) {
 		struct page *page;
@@ -95,10 +95,20 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		if (radix_tree_deref_retry(page)) {
-			if (ret)
-				start = pages[ret-1]->index;
-			goto restart;
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				assert((start | i) == 0);
+				goto restart;
+			}
+			/*
+			 * No exceptional entries are inserted in this test.
+			 */
+			assert(0);
 		}
 
 		pthread_mutex_lock(&page->lock);
--- rtth2/test.h	2011-12-16 18:44:02.475897094 -0800
+++ rtth3/test.h	2011-12-16 18:44:04.551896997 -0800
@@ -4,18 +4,19 @@
 #include <linux/rcupdate.h>
 
 /* hack: keep this in synch with radix-tree.c */
-#define RADIX_TREE_MAP_SHIFT 3
-#define RADIX_TREE_MAP_SIZE     (1UL << RADIX_TREE_MAP_SHIFT)
-#define RADIX_TREE_MAP_MASK     (RADIX_TREE_MAP_SIZE-1)
-#define RADIX_TREE_TAG_LONGS    \
-        ((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+#define RADIX_TREE_MAP_SHIFT	3	/* For more stressful testing */
+#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
+#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
+
+#define RADIX_TREE_TAG_LONGS	\
+	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
 
 struct radix_tree_node {
-        unsigned int    height;         /* Height from the bottom */
-        unsigned int    count;
-        struct rcu_head rcu_head;
-        void            *slots[RADIX_TREE_MAP_SIZE];
-        unsigned long   tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+	unsigned int	height;		/* Height from the bottom */
+	unsigned int	count;
+	struct rcu_head	rcu_head;
+	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
+	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
 static inline void *indirect_to_ptr(void *ptr)
