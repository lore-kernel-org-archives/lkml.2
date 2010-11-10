Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0KJX4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:56:08 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15606 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757116Ab0KJX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:56:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAC+2kx5LcZK/2dsb2JhbACiO3K/d4J0glYE
Date: Thu, 11 Nov 2010 10:55:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [patch] radix-tree: fix RCU bug
Message-ID: <20101110235557.GC3164@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, I've triggered this bug and verified the fix in Andrew's radix
tree test harness, Salman also reported that the fix worked, so I would
like to get it merged soon.

Note, this should be applicable to all stable kernels since lockless
pagecache was merged, 2.6.27 IIRC.

--
Salman Qazi describes the following radix-tree bug:

In the following case, we get can get a deadlock:                            

0.  The radix tree contains two items, one has the index 0.              
1.  The reader (in this case find_get_pages) takes the rcu_read_lock.    
2.  The reader acquires slot(s) for item(s) including the index 0 item.  
3.  The non-zero index item is deleted, and as a consequence the other item is
    moved to the root of the tree. The place where it used to be is queued for
    deletion after the readers finish.                        
3b. The zero item is deleted, removing it from the direct slot, it remains in
    the rcu-delayed indirect node.                         
4.  The reader looks at the index 0 slot, and finds that the page has 0 ref
    count                                                                      
5.  The reader looks at it again, hoping that the item will either be freed or
    the ref count will increase. This never happens, as the slot it is looking
    at will never be updated. Also, this slot can never be reclaimed because
    the reader is holding rcu_read_lock and is in an infinite loop.

The fix is to re-use the same "indirect" pointer case that requires a slot
lookup retry into a general "retry the lookup" bit.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/radix-tree.h |   40 ++++++++++++---------
 lib/radix-tree.c           |   83 +++++++++++++++++++++++++++++++--------------
 mm/filemap.c               |   26 +++++---------
 3 files changed, 91 insertions(+), 58 deletions(-)

Index: linux-2.6/include/linux/radix-tree.h
===================================================================
--- linux-2.6.orig/include/linux/radix-tree.h	2010-11-10 21:54:46.000000000 +1100
+++ linux-2.6/include/linux/radix-tree.h	2010-11-10 21:57:09.000000000 +1100
@@ -34,19 +34,13 @@
  * needed for RCU lookups (because root->height is unreliable). The only
  * time callers need worry about this is when doing a lookup_slot under
  * RCU.
+ *
+ * Indirect pointer in fact is also used to tag the last pointer of a node
+ * when it is shrunk, before we rcu free the node. See shrink code for
+ * details.
  */
 #define RADIX_TREE_INDIRECT_PTR	1
-#define RADIX_TREE_RETRY ((void *)-1UL)
-
-static inline void *radix_tree_ptr_to_indirect(void *ptr)
-{
-	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
-}
 
-static inline void *radix_tree_indirect_to_ptr(void *ptr)
-{
-	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
-}
 #define radix_tree_indirect_to_ptr(ptr) \
 	radix_tree_indirect_to_ptr((void __force *)(ptr))
 
@@ -140,16 +134,29 @@ do {									\
  *		removed.
  *
  * For use with radix_tree_lookup_slot().  Caller must hold tree at least read
- * locked across slot lookup and dereference.  More likely, will be used with
- * radix_tree_replace_slot(), as well, so caller will hold tree write locked.
+ * locked across slot lookup and dereference. Not required if write lock is
+ * held (ie. items cannot be concurrently inserted).
+ *
+ * radix_tree_deref_retry must be used to confirm validity of the pointer if
+ * only the read lock is held.
  */
 static inline void *radix_tree_deref_slot(void **pslot)
 {
-	void *ret = rcu_dereference(*pslot);
-	if (unlikely(radix_tree_is_indirect_ptr(ret)))
-		ret = RADIX_TREE_RETRY;
-	return ret;
+	return rcu_dereference(*pslot);
 }
+
+/**
+ * radix_tree_deref_retry	- check radix_tree_deref_slot
+ * @arg:	pointer returned by radix_tree_deref_slot
+ * Returns:	0 if retry is not required, otherwise retry is required
+ *
+ * radix_tree_deref_retry must be used with radix_tree_deref_slot.
+ */
+static inline int radix_tree_deref_retry(void *arg)
+{
+	return unlikely((unsigned long)arg & RADIX_TREE_INDIRECT_PTR);
+}
+
 /**
  * radix_tree_replace_slot	- replace item in a slot
  * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
Index: linux-2.6/lib/radix-tree.c
===================================================================
--- linux-2.6.orig/lib/radix-tree.c	2010-11-10 21:54:46.000000000 +1100
+++ linux-2.6/lib/radix-tree.c	2010-11-10 21:55:42.000000000 +1100
@@ -82,6 +82,16 @@ struct radix_tree_preload {
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
+static inline void *ptr_to_indirect(void *ptr)
+{
+	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
+}
+
+static inline void *indirect_to_ptr(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
+}
+
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
 	return root->gfp_mask & __GFP_BITS_MASK;
@@ -265,7 +275,7 @@ static int radix_tree_extend(struct radi
 			return -ENOMEM;
 
 		/* Increase the height.  */
-		node->slots[0] = radix_tree_indirect_to_ptr(root->rnode);
+		node->slots[0] = indirect_to_ptr(root->rnode);
 
 		/* Propagate the aggregated tag info into the new root */
 		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
@@ -276,7 +286,7 @@ static int radix_tree_extend(struct radi
 		newheight = root->height+1;
 		node->height = newheight;
 		node->count = 1;
-		node = radix_tree_ptr_to_indirect(node);
+		node = ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
 		root->height = newheight;
 	} while (height > root->height);
@@ -309,7 +319,7 @@ int radix_tree_insert(struct radix_tree_
 			return error;
 	}
 
-	slot = radix_tree_indirect_to_ptr(root->rnode);
+	slot = indirect_to_ptr(root->rnode);
 
 	height = root->height;
 	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
@@ -325,8 +335,7 @@ int radix_tree_insert(struct radix_tree_
 				rcu_assign_pointer(node->slots[offset], slot);
 				node->count++;
 			} else
-				rcu_assign_pointer(root->rnode,
-					radix_tree_ptr_to_indirect(slot));
+				rcu_assign_pointer(root->rnode, ptr_to_indirect(slot));
 		}
 
 		/* Go a level down */
@@ -374,7 +383,7 @@ static void *radix_tree_lookup_element(s
 			return NULL;
 		return is_slot ? (void *)&root->rnode : node;
 	}
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	height = node->height;
 	if (index > radix_tree_maxindex(height))
@@ -393,7 +402,7 @@ static void *radix_tree_lookup_element(s
 		height--;
 	} while (height > 0);
 
-	return is_slot ? (void *)slot:node;
+	return is_slot ? (void *)slot : indirect_to_ptr(node);
 }
 
 /**
@@ -455,7 +464,7 @@ void *radix_tree_tag_set(struct radix_tr
 	height = root->height;
 	BUG_ON(index > radix_tree_maxindex(height));
 
-	slot = radix_tree_indirect_to_ptr(root->rnode);
+	slot = indirect_to_ptr(root->rnode);
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 
 	while (height > 0) {
@@ -509,7 +518,7 @@ void *radix_tree_tag_clear(struct radix_
 
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node = NULL;
-	slot = radix_tree_indirect_to_ptr(root->rnode);
+	slot = indirect_to_ptr(root->rnode);
 
 	while (height > 0) {
 		int offset;
@@ -579,7 +588,7 @@ int radix_tree_tag_get(struct radix_tree
 
 	if (!radix_tree_is_indirect_ptr(node))
 		return (index == 0);
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	height = node->height;
 	if (index > radix_tree_maxindex(height))
@@ -666,7 +675,7 @@ unsigned long radix_tree_range_tag_if_ta
 	}
 
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	slot = radix_tree_indirect_to_ptr(root->rnode);
+	slot = indirect_to_ptr(root->rnode);
 
 	/*
 	 * we fill the path from (root->height - 2) to 0, leaving the index at
@@ -897,7 +906,7 @@ radix_tree_gang_lookup(struct radix_tree
 		results[0] = node;
 		return 1;
 	}
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -916,7 +925,8 @@ radix_tree_gang_lookup(struct radix_tree
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference_raw(slot);
+			results[ret + nr_found] =
+				indirect_to_ptr(rcu_dereference_raw(slot));
 			nr_found++;
 		}
 		ret += nr_found;
@@ -965,7 +975,7 @@ radix_tree_gang_lookup_slot(struct radix
 		results[0] = (void **)&root->rnode;
 		return 1;
 	}
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -1090,7 +1100,7 @@ radix_tree_gang_lookup_tag(struct radix_
 		results[0] = node;
 		return 1;
 	}
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -1109,7 +1119,8 @@ radix_tree_gang_lookup_tag(struct radix_
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference_raw(slot);
+			results[ret + nr_found] =
+				indirect_to_ptr(rcu_dereference_raw(slot));
 			nr_found++;
 		}
 		ret += nr_found;
@@ -1159,7 +1170,7 @@ radix_tree_gang_lookup_tag_slot(struct r
 		results[0] = (void **)&root->rnode;
 		return 1;
 	}
-	node = radix_tree_indirect_to_ptr(node);
+	node = indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -1195,7 +1206,7 @@ static inline void radix_tree_shrink(str
 		void *newptr;
 
 		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
-		to_free = radix_tree_indirect_to_ptr(to_free);
+		to_free = indirect_to_ptr(to_free);
 
 		/*
 		 * The candidate node has more than one child, or its child
@@ -1208,16 +1219,39 @@ static inline void radix_tree_shrink(str
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
-		 * moving the node from one part of the tree to another. If
-		 * it was safe to dereference the old pointer to it
+		 * moving the node from one part of the tree to another: if it
+		 * was safe to dereference the old pointer to it
 		 * (to_free->slots[0]), it will be safe to dereference the new
-		 * one (root->rnode).
+		 * one (root->rnode) as far as dependent read barriers go.
 		 */
 		newptr = to_free->slots[0];
 		if (root->height > 1)
-			newptr = radix_tree_ptr_to_indirect(newptr);
+			newptr = ptr_to_indirect(newptr);
 		root->rnode = newptr;
 		root->height--;
+
+		/*
+		 * We have a dilemma here. The node's slot[0] must not be
+		 * NULLed in case there are concurrent lookups expecting to
+		 * find the item. However if this was a bottom-level node,
+		 * then it may be subject to the slot pointer being visible
+		 * to callers dereferencing it. If item corresponding to
+		 * slot[0] is subsequently deleted, these callers would expect
+		 * their slot to become empty sooner or later.
+		 *
+		 * For example, lockless pagecache will look up a slot, deref
+		 * the page pointer, and if the page is 0 refcount it means it
+		 * was concurrently deleted from pagecache so try the deref
+		 * again. Fortunately there is already a requirement for logic
+		 * to retry the entire slot lookup -- the indirect pointer
+		 * problem (replacing direct root node with an indirect pointer
+		 * also results in a stale slot). So tag the slot as indirect
+		 * to force callers to retry.
+		 */
+		if (root->height == 0)
+			*((unsigned long *)&to_free->slots[0]) |=
+						RADIX_TREE_INDIRECT_PTR;
+
 		radix_tree_node_free(to_free);
 	}
 }
@@ -1254,7 +1288,7 @@ void *radix_tree_delete(struct radix_tre
 		root->rnode = NULL;
 		goto out;
 	}
-	slot = radix_tree_indirect_to_ptr(slot);
+	slot = indirect_to_ptr(slot);
 
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node = NULL;
@@ -1296,8 +1330,7 @@ void *radix_tree_delete(struct radix_tre
 			radix_tree_node_free(to_free);
 
 		if (pathp->node->count) {
-			if (pathp->node ==
-					radix_tree_indirect_to_ptr(root->rnode))
+			if (pathp->node == indirect_to_ptr(root->rnode))
 				radix_tree_shrink(root);
 			goto out;
 		}
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2010-11-10 21:54:46.000000000 +1100
+++ linux-2.6/mm/filemap.c	2010-11-10 21:55:42.000000000 +1100
@@ -644,7 +644,9 @@ struct page *find_get_page(struct addres
 	pagep = radix_tree_lookup_slot(&mapping->page_tree, offset);
 	if (pagep) {
 		page = radix_tree_deref_slot(pagep);
-		if (unlikely(!page || page == RADIX_TREE_RETRY))
+		if (unlikely(!page))
+			goto out;
+		if (radix_tree_deref_retry(page))
 			goto repeat;
 
 		if (!page_cache_get_speculative(page))
@@ -660,6 +662,7 @@ struct page *find_get_page(struct addres
 			goto repeat;
 		}
 	}
+out:
 	rcu_read_unlock();
 
 	return page;
@@ -777,12 +780,11 @@ unsigned find_get_pages(struct address_s
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found == 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page == RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page)) {
+			if (ret)
+				start = pages[ret-1]->index;
 			goto restart;
+		}
 
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -830,11 +832,7 @@ unsigned find_get_pages_contig(struct ad
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found == 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page == RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page))
 			goto restart;
 
 		if (page->mapping == NULL || page->index != index)
@@ -887,11 +885,7 @@ unsigned find_get_pages_tag(struct addre
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found == 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page == RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page))
 			goto restart;
 
 		if (!page_cache_get_speculative(page))
