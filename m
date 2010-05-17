Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0EQXPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:15:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0EQXO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:14:58 -0400
Date: Tue, 18 May 2010 01:14:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/pat changes for v2.6.35
Message-ID: <20100517231412.GA10987@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-pat-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pat-for-linus


out-of-topic modifications in x86-pat-for-linus:
------------------------------------------------
include/linux/rbtree.h             # 17d9ddc: rbtree: Add support for augmented
lib/rbtree.c                       # 17d9ddc: rbtree: Add support for augmented

 Thanks,

	Ingo

------------------>
Pallipadi, Venkatesh (3):
      rbtree: Add support for augmented rbtrees
      x86, pat: Migrate to rbtree only backend for pat memtype management
      x86, pat: In rbt_memtype_check_insert(), update new->type only if valid

Robin Holt (1):
      x86, pat: Update the page flags for memtype atomically instead of using memtype_lock

venkatesh.pallipadi@intel.com (1):
      x86, pat: Preparatory changes in pat.c for bigger rbtree change


 Documentation/rbtree.txt          |   58 ++++++++
 arch/x86/include/asm/cacheflush.h |   44 ++++---
 arch/x86/mm/Makefile              |    1 +
 arch/x86/mm/pat.c                 |  239 +++-----------------------------
 arch/x86/mm/pat_internal.h        |   46 ++++++
 arch/x86/mm/pat_rbtree.c          |  273 +++++++++++++++++++++++++++++++++++++
 include/linux/rbtree.h            |    5 +-
 lib/rbtree.c                      |   48 ++++++-
 8 files changed, 470 insertions(+), 244 deletions(-)
 create mode 100644 arch/x86/mm/pat_internal.h
 create mode 100644 arch/x86/mm/pat_rbtree.c

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index aae8355..221f38b 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,3 +190,61 @@ Example:
   for (node = rb_first(&mytree); node; node = rb_next(node))
 	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 
+Support for Augmented rbtrees
+-----------------------------
+
+Augmented rbtree is an rbtree with "some" additional data stored in each node.
+This data can be used to augment some new functionality to rbtree.
+Augmented rbtree is an optional feature built on top of basic rbtree
+infrastructure. rbtree user who wants this feature will have an augment
+callback function in rb_root initialized.
+
+This callback function will be called from rbtree core routines whenever
+a node has a change in one or both of its children. It is the responsibility
+of the callback function to recalculate the additional data that is in the
+rb node using new children information. Note that if this new additional
+data affects the parent node's additional data, then callback function has
+to handle it and do the recursive updates.
+
+
+Interval tree is an example of augmented rb tree. Reference -
+"Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
+More details about interval trees:
+
+Classical rbtree has a single key and it cannot be directly used to store
+interval ranges like [lo:hi] and do a quick lookup for any overlap with a new
+lo:hi or to find whether there is an exact match for a new lo:hi.
+
+However, rbtree can be augmented to store such interval ranges in a structured
+way making it possible to do efficient lookup and exact match.
+
+This "extra information" stored in each node is the maximum hi
+(max_hi) value among all the nodes that are its descendents. This
+information can be maintained at each node just be looking at the node
+and its immediate children. And this will be used in O(log n) lookup
+for lowest match (lowest start address among all possible matches)
+with something like:
+
+find_lowest_match(lo, hi, node)
+{
+	lowest_match = NULL;
+	while (node) {
+		if (max_hi(node->left) > lo) {
+			// Lowest overlap if any must be on left side
+			node = node->left;
+		} else if (overlap(lo, hi, node)) {
+			lowest_match = node;
+			break;
+		} else if (lo > node->lo) {
+			// Lowest overlap if any must be on right side
+			node = node->right;
+		} else {
+			break;
+		}
+	}
+	return lowest_match;
+}
+
+Finding exact match will be to first find lowest match and then to follow
+successor nodes looking for exact match, until the start of a node is beyond
+the hi value we are looking for.
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 634c40a..c70068d 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -44,9 +44,6 @@ static inline void copy_from_user_page(struct vm_area_struct *vma,
 	memcpy(dst, src, len);
 }
 
-#define PG_WC				PG_arch_1
-PAGEFLAG(WC, WC)
-
 #ifdef CONFIG_X86_PAT
 /*
  * X86 PAT uses page flags WC and Uncached together to keep track of
@@ -55,16 +52,24 @@ PAGEFLAG(WC, WC)
  * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
  * been changed from its default (value of -1 used to denote this).
  * Note we do not support _PAGE_CACHE_UC here.
- *
- * Caller must hold memtype_lock for atomicity.
  */
+
+#define _PGMT_DEFAULT		0
+#define _PGMT_WC		(1UL << PG_arch_1)
+#define _PGMT_UC_MINUS		(1UL << PG_uncached)
+#define _PGMT_WB		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
+
 static inline unsigned long get_page_memtype(struct page *pg)
 {
-	if (!PageUncached(pg) && !PageWC(pg))
+	unsigned long pg_flags = pg->flags & _PGMT_MASK;
+
+	if (pg_flags == _PGMT_DEFAULT)
 		return -1;
-	else if (!PageUncached(pg) && PageWC(pg))
+	else if (pg_flags == _PGMT_WC)
 		return _PAGE_CACHE_WC;
-	else if (PageUncached(pg) && !PageWC(pg))
+	else if (pg_flags == _PGMT_UC_MINUS)
 		return _PAGE_CACHE_UC_MINUS;
 	else
 		return _PAGE_CACHE_WB;
@@ -72,25 +77,26 @@ static inline unsigned long get_page_memtype(struct page *pg)
 
 static inline void set_page_memtype(struct page *pg, unsigned long memtype)
 {
+	unsigned long memtype_flags = _PGMT_DEFAULT;
+	unsigned long old_flags;
+	unsigned long new_flags;
+
 	switch (memtype) {
 	case _PAGE_CACHE_WC:
-		ClearPageUncached(pg);
-		SetPageWC(pg);
+		memtype_flags = _PGMT_WC;
 		break;
 	case _PAGE_CACHE_UC_MINUS:
-		SetPageUncached(pg);
-		ClearPageWC(pg);
+		memtype_flags = _PGMT_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WB:
-		SetPageUncached(pg);
-		SetPageWC(pg);
-		break;
-	default:
-	case -1:
-		ClearPageUncached(pg);
-		ClearPageWC(pg);
+		memtype_flags = _PGMT_WB;
 		break;
 	}
+
+	do {
+		old_flags = pg->flags;
+		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
+	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
 }
 #else
 static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 06630d2..a4c7683 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -6,6 +6,7 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
 CFLAGS_setup_nx.o		:= $(nostackp)
 
+obj-$(CONFIG_X86_PAT)		+= pat_rbtree.o
 obj-$(CONFIG_SMP)		+= tlb.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ae9648e..501fc60 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -30,6 +30,8 @@
 #include <asm/pat.h>
 #include <asm/io.h>
 
+#include "pat_internal.h"
+
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
@@ -53,19 +55,15 @@ static inline void pat_disable(const char *reason)
 #endif
 
 
-static int debug_enable;
+int pat_debug_enable;
 
 static int __init pat_debug_setup(char *str)
 {
-	debug_enable = 1;
+	pat_debug_enable = 1;
 	return 0;
 }
 __setup("debugpat", pat_debug_setup);
 
-#define dprintk(fmt, arg...) \
-	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
-
-
 static u64 __read_mostly boot_pat_state;
 
 enum {
@@ -132,84 +130,7 @@ void pat_init(void)
 
 #undef PAT
 
-static char *cattr_name(unsigned long flags)
-{
-	switch (flags & _PAGE_CACHE_MASK) {
-	case _PAGE_CACHE_UC:		return "uncached";
-	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
-	case _PAGE_CACHE_WB:		return "write-back";
-	case _PAGE_CACHE_WC:		return "write-combining";
-	default:			return "broken";
-	}
-}
-
-/*
- * The global memtype list keeps track of memory type for specific
- * physical memory areas. Conflicting memory types in different
- * mappings can cause CPU cache corruption. To avoid this we keep track.
- *
- * The list is sorted based on starting address and can contain multiple
- * entries for each address (this allows reference counting for overlapping
- * areas). All the aliases have the same cache attributes of course.
- * Zero attributes are represented as holes.
- *
- * The data structure is a list that is also organized as an rbtree
- * sorted on the start address of memtype range.
- *
- * memtype_lock protects both the linear list and rbtree.
- */
-
-struct memtype {
-	u64			start;
-	u64			end;
-	unsigned long		type;
-	struct list_head	nd;
-	struct rb_node		rb;
-};
-
-static struct rb_root memtype_rbroot = RB_ROOT;
-static LIST_HEAD(memtype_list);
-static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
-
-static struct memtype *memtype_rb_search(struct rb_root *root, u64 start)
-{
-	struct rb_node *node = root->rb_node;
-	struct memtype *last_lower = NULL;
-
-	while (node) {
-		struct memtype *data = container_of(node, struct memtype, rb);
-
-		if (data->start < start) {
-			last_lower = data;
-			node = node->rb_right;
-		} else if (data->start > start) {
-			node = node->rb_left;
-		} else
-			return data;
-	}
-
-	/* Will return NULL if there is no entry with its start <= start */
-	return last_lower;
-}
-
-static void memtype_rb_insert(struct rb_root *root, struct memtype *data)
-{
-	struct rb_node **new = &(root->rb_node);
-	struct rb_node *parent = NULL;
-
-	while (*new) {
-		struct memtype *this = container_of(*new, struct memtype, rb);
-
-		parent = *new;
-		if (data->start <= this->start)
-			new = &((*new)->rb_left);
-		else if (data->start > this->start)
-			new = &((*new)->rb_right);
-	}
-
-	rb_link_node(&data->rb, parent, new);
-	rb_insert_color(&data->rb, root);
-}
+static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype accesses */
 
 /*
  * Does intersection of PAT memory type and MTRR memory type and returns
@@ -237,33 +158,6 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
-static int
-chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
-{
-	if (new->type != entry->type) {
-		if (type) {
-			new->type = entry->type;
-			*type = entry->type;
-		} else
-			goto conflict;
-	}
-
-	 /* check overlaps with more than one entry in the list */
-	list_for_each_entry_continue(entry, &memtype_list, nd) {
-		if (new->end <= entry->start)
-			break;
-		else if (new->type != entry->type)
-			goto conflict;
-	}
-	return 0;
-
- conflict:
-	printk(KERN_INFO "%s:%d conflicting memory types "
-	       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, new->start,
-	       new->end, cattr_name(new->type), cattr_name(entry->type));
-	return -EBUSY;
-}
-
 static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
 {
 	int ram_page = 0, not_rampage = 0;
@@ -296,8 +190,6 @@ static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
  * - In case of no conflicts, set the new memtype for pages in the range
- *
- * Caller must hold memtype_lock for atomicity.
  */
 static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 				  unsigned long *new_type)
@@ -364,9 +256,8 @@ static int free_ram_pages_type(u64 start, u64 end)
 int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		    unsigned long *new_type)
 {
-	struct memtype *new, *entry;
+	struct memtype *new;
 	unsigned long actual_type;
-	struct list_head *where;
 	int is_range_ram;
 	int err = 0;
 
@@ -404,9 +295,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
 		err = reserve_ram_pages_type(start, end, req_type, new_type);
-		spin_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
@@ -423,42 +312,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
-	/* Search for existing mapping that overlaps the current range */
-	where = NULL;
-	list_for_each_entry(entry, &memtype_list, nd) {
-		if (end <= entry->start) {
-			where = entry->nd.prev;
-			break;
-		} else if (start <= entry->start) { /* end > entry->start */
-			err = chk_conflict(new, entry, new_type);
-			if (!err) {
-				dprintk("Overlap at 0x%Lx-0x%Lx\n",
-					entry->start, entry->end);
-				where = entry->nd.prev;
-			}
-			break;
-		} else if (start < entry->end) { /* start > entry->start */
-			err = chk_conflict(new, entry, new_type);
-			if (!err) {
-				dprintk("Overlap at 0x%Lx-0x%Lx\n",
-					entry->start, entry->end);
-
-				/*
-				 * Move to right position in the linked
-				 * list to add this new entry
-				 */
-				list_for_each_entry_continue(entry,
-							&memtype_list, nd) {
-					if (start <= entry->start) {
-						where = entry->nd.prev;
-						break;
-					}
-				}
-			}
-			break;
-		}
-	}
-
+	err = rbt_memtype_check_insert(new, new_type);
 	if (err) {
 		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
 		       "track %s, req %s\n",
@@ -469,13 +323,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return err;
 	}
 
-	if (where)
-		list_add(&new->nd, where);
-	else
-		list_add_tail(&new->nd, &memtype_list);
-
-	memtype_rb_insert(&memtype_rbroot, new);
-
 	spin_unlock(&memtype_lock);
 
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
@@ -487,7 +334,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 int free_memtype(u64 start, u64 end)
 {
-	struct memtype *entry, *saved_entry;
 	int err = -EINVAL;
 	int is_range_ram;
 
@@ -501,9 +347,7 @@ int free_memtype(u64 start, u64 end)
 	is_range_ram = pat_pagerange_is_ram(start, end);
 	if (is_range_ram == 1) {
 
-		spin_lock(&memtype_lock);
 		err = free_ram_pages_type(start, end);
-		spin_unlock(&memtype_lock);
 
 		return err;
 	} else if (is_range_ram < 0) {
@@ -511,46 +355,7 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	spin_lock(&memtype_lock);
-
-	entry = memtype_rb_search(&memtype_rbroot, start);
-	if (unlikely(entry == NULL))
-		goto unlock_ret;
-
-	/*
-	 * Saved entry points to an entry with start same or less than what
-	 * we searched for. Now go through the list in both directions to look
-	 * for the entry that matches with both start and end, with list stored
-	 * in sorted start address
-	 */
-	saved_entry = entry;
-	list_for_each_entry_from(entry, &memtype_list, nd) {
-		if (entry->start == start && entry->end == end) {
-			rb_erase(&entry->rb, &memtype_rbroot);
-			list_del(&entry->nd);
-			kfree(entry);
-			err = 0;
-			break;
-		} else if (entry->start > start) {
-			break;
-		}
-	}
-
-	if (!err)
-		goto unlock_ret;
-
-	entry = saved_entry;
-	list_for_each_entry_reverse(entry, &memtype_list, nd) {
-		if (entry->start == start && entry->end == end) {
-			rb_erase(&entry->rb, &memtype_rbroot);
-			list_del(&entry->nd);
-			kfree(entry);
-			err = 0;
-			break;
-		} else if (entry->start < start) {
-			break;
-		}
-	}
-unlock_ret:
+	err = rbt_memtype_erase(start, end);
 	spin_unlock(&memtype_lock);
 
 	if (err) {
@@ -583,10 +388,8 @@ static unsigned long lookup_memtype(u64 paddr)
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
 		struct page *page;
-		spin_lock(&memtype_lock);
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
 		rettype = get_page_memtype(page);
-		spin_unlock(&memtype_lock);
 		/*
 		 * -1 from get_page_memtype() implies RAM page is in its
 		 * default state and not reserved, and hence of type WB
@@ -599,7 +402,7 @@ static unsigned long lookup_memtype(u64 paddr)
 
 	spin_lock(&memtype_lock);
 
-	entry = memtype_rb_search(&memtype_rbroot, paddr);
+	entry = rbt_memtype_lookup(paddr);
 	if (entry != NULL)
 		rettype = entry->type;
 	else
@@ -936,29 +739,25 @@ EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
-/* get Nth element of the linked list */
 static struct memtype *memtype_get_idx(loff_t pos)
 {
-	struct memtype *list_node, *print_entry;
-	int i = 1;
+	struct memtype *print_entry;
+	int ret;
 
-	print_entry  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	print_entry  = kzalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!print_entry)
 		return NULL;
 
 	spin_lock(&memtype_lock);
-	list_for_each_entry(list_node, &memtype_list, nd) {
-		if (pos == i) {
-			*print_entry = *list_node;
-			spin_unlock(&memtype_lock);
-			return print_entry;
-		}
-		++i;
-	}
+	ret = rbt_memtype_copy_nth_element(print_entry, pos);
 	spin_unlock(&memtype_lock);
-	kfree(print_entry);
 
-	return NULL;
+	if (!ret) {
+		return print_entry;
+	} else {
+		kfree(print_entry);
+		return NULL;
+	}
 }
 
 static void *memtype_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
new file mode 100644
index 0000000..4f39eef
--- /dev/null
+++ b/arch/x86/mm/pat_internal.h
@@ -0,0 +1,46 @@
+#ifndef __PAT_INTERNAL_H_
+#define __PAT_INTERNAL_H_
+
+extern int pat_debug_enable;
+
+#define dprintk(fmt, arg...) \
+	do { if (pat_debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
+
+struct memtype {
+	u64			start;
+	u64			end;
+	u64			subtree_max_end;
+	unsigned long		type;
+	struct rb_node		rb;
+};
+
+static inline char *cattr_name(unsigned long flags)
+{
+	switch (flags & _PAGE_CACHE_MASK) {
+	case _PAGE_CACHE_UC:		return "uncached";
+	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
+	case _PAGE_CACHE_WB:		return "write-back";
+	case _PAGE_CACHE_WC:		return "write-combining";
+	default:			return "broken";
+	}
+}
+
+#ifdef CONFIG_X86_PAT
+extern int rbt_memtype_check_insert(struct memtype *new,
+					unsigned long *new_type);
+extern int rbt_memtype_erase(u64 start, u64 end);
+extern struct memtype *rbt_memtype_lookup(u64 addr);
+extern int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos);
+#else
+static inline int rbt_memtype_check_insert(struct memtype *new,
+					unsigned long *new_type)
+{ return 0; }
+static inline int rbt_memtype_erase(u64 start, u64 end)
+{ return 0; }
+static inline struct memtype *rbt_memtype_lookup(u64 addr)
+{ return NULL; }
+static inline int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
+{ return 0; }
+#endif
+
+#endif /* __PAT_INTERNAL_H_ */
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
new file mode 100644
index 0000000..07de4cb
--- /dev/null
+++ b/arch/x86/mm/pat_rbtree.c
@@ -0,0 +1,273 @@
+/*
+ * Handle caching attributes in page tables (PAT)
+ *
+ * Authors: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *          Suresh B Siddha <suresh.b.siddha@intel.com>
+ *
+ * Interval tree (augmented rbtree) used to store the PAT memory type
+ * reservations.
+ */
+
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/gfp.h>
+
+#include <asm/pgtable.h>
+#include <asm/pat.h>
+
+#include "pat_internal.h"
+
+/*
+ * The memtype tree keeps track of memory type for specific
+ * physical memory areas. Without proper tracking, conflicting memory
+ * types in different mappings can cause CPU cache corruption.
+ *
+ * The tree is an interval tree (augmented rbtree) with tree ordered
+ * on starting address. Tree can contain multiple entries for
+ * different regions which overlap. All the aliases have the same
+ * cache attributes of course.
+ *
+ * memtype_lock protects the rbtree.
+ */
+
+static void memtype_rb_augment_cb(struct rb_node *node);
+static struct rb_root memtype_rbroot = RB_AUGMENT_ROOT(&memtype_rb_augment_cb);
+
+static int is_node_overlap(struct memtype *node, u64 start, u64 end)
+{
+	if (node->start >= end || node->end <= start)
+		return 0;
+
+	return 1;
+}
+
+static u64 get_subtree_max_end(struct rb_node *node)
+{
+	u64 ret = 0;
+	if (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+		ret = data->subtree_max_end;
+	}
+	return ret;
+}
+
+/* Update 'subtree_max_end' for a node, based on node and its children */
+static void update_node_max_end(struct rb_node *node)
+{
+	struct memtype *data;
+	u64 max_end, child_max_end;
+
+	if (!node)
+		return;
+
+	data = container_of(node, struct memtype, rb);
+	max_end = data->end;
+
+	child_max_end = get_subtree_max_end(node->rb_right);
+	if (child_max_end > max_end)
+		max_end = child_max_end;
+
+	child_max_end = get_subtree_max_end(node->rb_left);
+	if (child_max_end > max_end)
+		max_end = child_max_end;
+
+	data->subtree_max_end = max_end;
+}
+
+/* Update 'subtree_max_end' for a node and all its ancestors */
+static void update_path_max_end(struct rb_node *node)
+{
+	u64 old_max_end, new_max_end;
+
+	while (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+
+		old_max_end = data->subtree_max_end;
+		update_node_max_end(node);
+		new_max_end = data->subtree_max_end;
+
+		if (new_max_end == old_max_end)
+			break;
+
+		node = rb_parent(node);
+	}
+}
+
+/* Find the first (lowest start addr) overlapping range from rb tree */
+static struct memtype *memtype_rb_lowest_match(struct rb_root *root,
+				u64 start, u64 end)
+{
+	struct rb_node *node = root->rb_node;
+	struct memtype *last_lower = NULL;
+
+	while (node) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+
+		if (get_subtree_max_end(node->rb_left) > start) {
+			/* Lowest overlap if any must be on left side */
+			node = node->rb_left;
+		} else if (is_node_overlap(data, start, end)) {
+			last_lower = data;
+			break;
+		} else if (start >= data->start) {
+			/* Lowest overlap if any must be on right side */
+			node = node->rb_right;
+		} else {
+			break;
+		}
+	}
+	return last_lower; /* Returns NULL if there is no overlap */
+}
+
+static struct memtype *memtype_rb_exact_match(struct rb_root *root,
+				u64 start, u64 end)
+{
+	struct memtype *match;
+
+	match = memtype_rb_lowest_match(root, start, end);
+	while (match != NULL && match->start < end) {
+		struct rb_node *node;
+
+		if (match->start == start && match->end == end)
+			return match;
+
+		node = rb_next(&match->rb);
+		if (node)
+			match = container_of(node, struct memtype, rb);
+		else
+			match = NULL;
+	}
+
+	return NULL; /* Returns NULL if there is no exact match */
+}
+
+static int memtype_rb_check_conflict(struct rb_root *root,
+				u64 start, u64 end,
+				unsigned long reqtype, unsigned long *newtype)
+{
+	struct rb_node *node;
+	struct memtype *match;
+	int found_type = reqtype;
+
+	match = memtype_rb_lowest_match(&memtype_rbroot, start, end);
+	if (match == NULL)
+		goto success;
+
+	if (match->type != found_type && newtype == NULL)
+		goto failure;
+
+	dprintk("Overlap at 0x%Lx-0x%Lx\n", match->start, match->end);
+	found_type = match->type;
+
+	node = rb_next(&match->rb);
+	while (node) {
+		match = container_of(node, struct memtype, rb);
+
+		if (match->start >= end) /* Checked all possible matches */
+			goto success;
+
+		if (is_node_overlap(match, start, end) &&
+		    match->type != found_type) {
+			goto failure;
+		}
+
+		node = rb_next(&match->rb);
+	}
+success:
+	if (newtype)
+		*newtype = found_type;
+
+	return 0;
+
+failure:
+	printk(KERN_INFO "%s:%d conflicting memory types "
+		"%Lx-%Lx %s<->%s\n", current->comm, current->pid, start,
+		end, cattr_name(found_type), cattr_name(match->type));
+	return -EBUSY;
+}
+
+static void memtype_rb_augment_cb(struct rb_node *node)
+{
+	if (node)
+		update_path_max_end(node);
+}
+
+static void memtype_rb_insert(struct rb_root *root, struct memtype *newdata)
+{
+	struct rb_node **node = &(root->rb_node);
+	struct rb_node *parent = NULL;
+
+	while (*node) {
+		struct memtype *data = container_of(*node, struct memtype, rb);
+
+		parent = *node;
+		if (newdata->start <= data->start)
+			node = &((*node)->rb_left);
+		else if (newdata->start > data->start)
+			node = &((*node)->rb_right);
+	}
+
+	rb_link_node(&newdata->rb, parent, node);
+	rb_insert_color(&newdata->rb, root);
+}
+
+int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
+{
+	int err = 0;
+
+	err = memtype_rb_check_conflict(&memtype_rbroot, new->start, new->end,
+						new->type, ret_type);
+
+	if (!err) {
+		if (ret_type)
+			new->type = *ret_type;
+
+		memtype_rb_insert(&memtype_rbroot, new);
+	}
+	return err;
+}
+
+int rbt_memtype_erase(u64 start, u64 end)
+{
+	struct memtype *data;
+
+	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
+	if (!data)
+		return -EINVAL;
+
+	rb_erase(&data->rb, &memtype_rbroot);
+	return 0;
+}
+
+struct memtype *rbt_memtype_lookup(u64 addr)
+{
+	struct memtype *data;
+	data = memtype_rb_lowest_match(&memtype_rbroot, addr, addr + PAGE_SIZE);
+	return data;
+}
+
+#if defined(CONFIG_DEBUG_FS)
+int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
+{
+	struct rb_node *node;
+	int i = 1;
+
+	node = rb_first(&memtype_rbroot);
+	while (node && pos != i) {
+		node = rb_next(node);
+		i++;
+	}
+
+	if (node) { /* pos == i */
+		struct memtype *this = container_of(node, struct memtype, rb);
+		*out = *this;
+		return 0;
+	} else {
+		return 1;
+	}
+}
+#endif
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 9c29541..8e33a25 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -110,6 +110,7 @@ struct rb_node
 struct rb_root
 {
 	struct rb_node *rb_node;
+	void (*augment_cb)(struct rb_node *node);
 };
 
 
@@ -129,7 +130,9 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
 
-#define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT	(struct rb_root) { NULL, NULL, }
+#define RB_AUGMENT_ROOT(x)	(struct rb_root) { NULL, x}
+
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
diff --git a/lib/rbtree.c b/lib/rbtree.c
index e2aa3be..15e10b1 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -44,6 +44,11 @@ static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = right;
 	rb_set_parent(node, right);
+
+	if (root->augment_cb) {
+		root->augment_cb(node);
+		root->augment_cb(right);
+	}
 }
 
 static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
@@ -67,12 +72,20 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = left;
 	rb_set_parent(node, left);
+
+	if (root->augment_cb) {
+		root->augment_cb(node);
+		root->augment_cb(left);
+	}
 }
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *parent, *gparent;
 
+	if (root->augment_cb)
+		root->augment_cb(node);
+
 	while ((parent = rb_parent(node)) && rb_is_red(parent))
 	{
 		gparent = rb_parent(parent);
@@ -227,12 +240,15 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 	else
 	{
 		struct rb_node *old = node, *left;
+		int old_parent_cb = 0;
+		int successor_parent_cb = 0;
 
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
 		if (rb_parent(old)) {
+			old_parent_cb = 1;
 			if (rb_parent(old)->rb_left == old)
 				rb_parent(old)->rb_left = node;
 			else
@@ -247,8 +263,10 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		if (parent == old) {
 			parent = node;
 		} else {
+			successor_parent_cb = 1;
 			if (child)
 				rb_set_parent(child, parent);
+
 			parent->rb_left = child;
 
 			node->rb_right = old->rb_right;
@@ -259,6 +277,24 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
 
+		if (root->augment_cb) {
+			/*
+			 * Here, three different nodes can have new children.
+			 * The parent of the successor node that was selected
+			 * to replace the node to be erased.
+			 * The node that is getting erased and is now replaced
+			 * by its successor.
+			 * The parent of the node getting erased-replaced.
+			 */
+			if (successor_parent_cb)
+				root->augment_cb(parent);
+
+			root->augment_cb(node);
+
+			if (old_parent_cb)
+				root->augment_cb(rb_parent(old));
+		}
+
 		goto color;
 	}
 
@@ -267,15 +303,19 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent)
-	{
+
+	if (parent) {
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-	}
-	else
+
+		if (root->augment_cb)
+			root->augment_cb(parent);
+
+	} else {
 		root->rb_node = child;
+	}
 
  color:
 	if (color == RB_BLACK)
