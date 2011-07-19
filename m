Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1GSWyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:54:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1GSWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:54:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=RHf2Zd8Vo3IFfdwiZTAD7F/VcaYlMEdndpF898YF7Jb4ARQZrCy2uYB0tvSNX8Mr0
	fp/rVJLhq67sWn/mRaDxg==
Date: Tue, 19 Jul 2011 15:54:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3] tmpfs radix_tree: locate_item to speed up swapoff
In-Reply-To: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107191553040.1593@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already acknowledged that swapoff of a tmpfs file is slower
than it was before conversion to the generic radix_tree: a little
slower there will be acceptable, if the hotter paths are faster.

But it was a shock to find swapoff of a 500MB file 20 times slower
on my laptop, taking 10 minutes; and at that rate it significantly
slows down my testing.

Now, most of that turned out to be overhead from PROVE_LOCKING and
PROVE_RCU: without those it was only 4 times slower than before;
and more realistic tests on other machines don't fare as badly.

I've tried a number of things to improve it, including tagging the
swap entries, then doing lookup by tag: I'd expected that to halve
the time, but in practice it's erratic, and often counter-productive.

The only change I've so far found to make a consistent improvement,
is to short-circuit the way we go back and forth, gang lookup packing
entries into the array supplied, then shmem scanning that array for the
target entry.  Scanning in place doubles the speed, so it's now only
twice as slow as before (or three times slower when the PROVEs are on).

So, add radix_tree_locate_item() as an expedient, once-off, single-caller
hack to do the lookup directly in place.  #ifdef it on CONFIG_SHMEM and
CONFIG_SWAP, as much to document its limited applicability as save space
in other configurations.  And, sadly, #include sched.h for cond_resched().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/radix-tree.h |    1 
 lib/radix-tree.c           |   92 +++++++++++++++++++++++++++++++++++
 mm/shmem.c                 |   38 --------------
 3 files changed, 94 insertions(+), 37 deletions(-)

--- mmotm.orig/include/linux/radix-tree.h	2011-07-08 18:57:14.810702665 -0700
+++ mmotm/include/linux/radix-tree.h	2011-07-19 11:11:33.705295709 -0700
@@ -252,6 +252,7 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int fromtag, unsigned int totag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
+unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item);
 
 static inline void radix_tree_preload_end(void)
 {
--- mmotm.orig/lib/radix-tree.c	2011-07-19 11:11:21.285234139 -0700
+++ mmotm/lib/radix-tree.c	2011-07-19 11:13:20.249824040 -0700
@@ -1197,6 +1197,98 @@ radix_tree_gang_lookup_tag_slot(struct r
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
--- mmotm.orig/mm/shmem.c	2011-07-08 18:57:15.114704171 -0700
+++ mmotm/mm/shmem.c	2011-07-19 11:11:33.709295729 -0700
@@ -357,42 +357,6 @@ export:
 }
 
 /*
- * Lockless lookup of swap entry in radix tree, avoiding refcount on pages.
- */
-static pgoff_t shmem_find_swap(struct address_space *mapping, void *radswap)
-{
-	void  **slots[PAGEVEC_SIZE];
-	pgoff_t indices[PAGEVEC_SIZE];
-	unsigned int nr_found;
-
-restart:
-	nr_found = 1;
-	indices[0] = -1;
-	while (nr_found) {
-		pgoff_t index = indices[nr_found - 1] + 1;
-		unsigned int i;
-
-		rcu_read_lock();
-		nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-					slots, indices, index, PAGEVEC_SIZE);
-		for (i = 0; i < nr_found; i++) {
-			void *item = radix_tree_deref_slot(slots[i]);
-			if (radix_tree_deref_retry(item)) {
-				rcu_read_unlock();
-				goto restart;
-			}
-			if (item == radswap) {
-				rcu_read_unlock();
-				return indices[i];
-			}
-		}
-		rcu_read_unlock();
-		cond_resched();
-	}
-	return -1;
-}
-
-/*
  * Remove swap entry from radix tree, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
@@ -612,7 +576,7 @@ static int shmem_unuse_inode(struct shme
 	int error;
 
 	radswap = swp_to_radix_entry(swap);
-	index = shmem_find_swap(mapping, radswap);
+	index = radix_tree_locate_item(&mapping->page_tree, radswap);
 	if (index == -1)
 		return 0;
 
