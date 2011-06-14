Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1FNKmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:42:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62301 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1FNKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kbU7E352alvMCy4K84GTbtx4XsC6tQmjrPJcF1M3alZrbHKj5MZDdFpD3D5eKYWWII
         F7CVBR7FaCQ4m9Mg4KyQ==
Date: Tue, 14 Jun 2011 03:42:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106140341070.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radix_tree is used by several subsystems for different purposes.
A major use is to store the struct page pointers of a file's pagecache
for memory management.  But what if mm wanted to store something other
than page pointers there too?

The low bit of a radix_tree entry is already used to denote an indirect
pointer, for internal use, and the unlikely radix_tree_deref_retry() case.
Define the next bit as denoting an exceptional entry, and supply inline
functions radix_tree_exception() to return non-0 in either unlikely case,
and radix_tree_exceptional_entry() to return non-0 in the second case.

If a subsystem already uses radix_tree with that bit set, no problem:
it does not affect internal workings at all, but is defined for the
convenience of those storing well-aligned pointers in the radix_tree.

The radix_tree_gang_lookups have an implicit assumption that the caller
can deduce the offset of each entry returned e.g. by the page->index of
a struct page.  But that may not be feasible for some kinds of item to
be stored there.

radix_tree_gang_lookup_slot() allow for an optional indices argument,
output array in which to return those offsets.  The same could be added
to other radix_tree_gang_lookups, but for now keep it to the only one
for which we need it.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/radix-tree.h |   36 ++++++++++++++++++++++++++++++++---
 lib/radix-tree.c           |   29 ++++++++++++++++++----------
 mm/filemap.c               |    4 +--
 3 files changed, 54 insertions(+), 15 deletions(-)

--- linux.orig/include/linux/radix-tree.h	2011-06-13 13:26:07.566101333 -0700
+++ linux/include/linux/radix-tree.h	2011-06-13 13:26:44.426284119 -0700
@@ -39,7 +39,15 @@
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
 
 #define radix_tree_indirect_to_ptr(ptr) \
 	radix_tree_indirect_to_ptr((void __force *)(ptr))
@@ -174,6 +182,28 @@ static inline int radix_tree_deref_retry
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
@@ -194,8 +224,8 @@ void *radix_tree_delete(struct radix_tre
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
--- linux.orig/lib/radix-tree.c	2011-06-13 13:26:07.566101333 -0700
+++ linux/lib/radix-tree.c	2011-06-13 13:26:44.426284119 -0700
@@ -823,8 +823,8 @@ unsigned long radix_tree_prev_hole(struc
 EXPORT_SYMBOL(radix_tree_prev_hole);
 
 static unsigned int
-__lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index)
+__lookup(struct radix_tree_node *slot, void ***results, unsigned long *indices,
+	unsigned long index, unsigned int max_items, unsigned long *next_index)
 {
 	unsigned int nr_found = 0;
 	unsigned int shift, height;
@@ -857,12 +857,16 @@ __lookup(struct radix_tree_node *slot, v
 
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
@@ -918,8 +922,8 @@ radix_tree_gang_lookup(struct radix_tree
 
 		if (cur_index > max_index)
 			break;
-		slots_found = __lookup(node, (void ***)results + ret, cur_index,
-					max_items - ret, &next_index);
+		slots_found = __lookup(node, (void ***)results + ret, NULL,
+				cur_index, max_items - ret, &next_index);
 		nr_found = 0;
 		for (i = 0; i < slots_found; i++) {
 			struct radix_tree_node *slot;
@@ -944,6 +948,7 @@ EXPORT_SYMBOL(radix_tree_gang_lookup);
  *	radix_tree_gang_lookup_slot - perform multiple slot lookup on radix tree
  *	@root:		radix tree root
  *	@results:	where the results of the lookup are placed
+ *	@indices:	where their indices should be placed (but usually NULL)
  *	@first_index:	start the lookup from this key
  *	@max_items:	place up to this many items at *results
  *
@@ -958,7 +963,8 @@ EXPORT_SYMBOL(radix_tree_gang_lookup);
  *	protection, radix_tree_deref_slot may fail requiring a retry.
  */
 unsigned int
-radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
+radix_tree_gang_lookup_slot(struct radix_tree_root *root,
+			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items)
 {
 	unsigned long max_index;
@@ -974,6 +980,8 @@ radix_tree_gang_lookup_slot(struct radix
 		if (first_index > 0)
 			return 0;
 		results[0] = (void **)&root->rnode;
+		if (indices)
+			indices[0] = 0;
 		return 1;
 	}
 	node = indirect_to_ptr(node);
@@ -987,8 +995,9 @@ radix_tree_gang_lookup_slot(struct radix
 
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
--- linux.orig/mm/filemap.c	2011-06-13 13:26:07.566101333 -0700
+++ linux/mm/filemap.c	2011-06-13 13:26:44.430284135 -0700
@@ -843,7 +843,7 @@ unsigned find_get_pages(struct address_s
 	rcu_read_lock();
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, start, nr_pages);
+				(void ***)pages, NULL, start, nr_pages);
 	ret = 0;
 	for (i = 0; i < nr_found; i++) {
 		struct page *page;
@@ -906,7 +906,7 @@ unsigned find_get_pages_contig(struct ad
 	rcu_read_lock();
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, index, nr_pages);
+				(void ***)pages, NULL, index, nr_pages);
 	ret = 0;
 	for (i = 0; i < nr_found; i++) {
 		struct page *page;
