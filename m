Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2BJASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:18:06 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52293 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519Ab2BJASC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:18:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags
Date: Thu,  9 Feb 2012 16:16:33 -0800
Message-Id: <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021000-5930-0000-0000-000004F5B697
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
  After the valid critique that just dropping pages would poke holes
in volatile ranges, and instead we should zap an entire range if we
drop any of it, I changed the code to more closely mimic the ashmem
implementation, which zaps entire ranges via a shrinker using an lru
list that tracks which range has been marked volatile the longest.

v3:
  Reworked to use range tree implementation.

Known issues:
* Not sure how to nicely error out if we get ENOMEM while splitting
  a range.
* Lockdep doesn't like calling vmtruncate_range() from a shrinker.
  Any help here on how to address this would be appreciated.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/inode.c               |    5 +
 include/linux/fadvise.h  |    6 +
 include/linux/fs.h       |    3 +
 include/linux/volatile.h |   14 ++
 mm/Makefile              |    2 +-
 mm/fadvise.c             |   22 +++-
 mm/volatile.c            |  314 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 364 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

diff --git a/fs/inode.c b/fs/inode.c
index fb10d86..0675962 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,6 +27,7 @@
 #include <linux/cred.h>
 #include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
+#include <linux/volatile.h>
 #include "internal.h"
 
 /*
@@ -254,6 +255,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	mapping_clear_volatile_ranges(&inode->i_data);
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
@@ -360,6 +362,9 @@ void address_space_init_once(struct address_space *mapping)
 	spin_lock_init(&mapping->private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
 	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+	mapping->volatile_root = NULL;
+	mutex_init(&mapping->vlist_mutex);
+
 }
 EXPORT_SYMBOL(address_space_init_once);
 
diff --git a/include/linux/fadvise.h b/include/linux/fadvise.h
index e8e7471..988fb00 100644
--- a/include/linux/fadvise.h
+++ b/include/linux/fadvise.h
@@ -18,4 +18,10 @@
 #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
 #endif
 
+#define POSIX_FADV_VOLATILE	8  /* _can_ toss, but don't toss now */
+#define POSIX_FADV_NONVOLATILE	9  /* Remove VOLATILE flag */
+#define POSIX_FADV_ISVOLATILE	10 /* Returns volatile flag for region */
+
+
+
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..a784a9b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/rangetree.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -655,6 +656,8 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct range_tree_node	*volatile_root;	/* volatile range list */
+	struct mutex		vlist_mutex;	/* protect volatile_list */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/volatile.h b/include/linux/volatile.h
new file mode 100644
index 0000000..5460d7b
--- /dev/null
+++ b/include/linux/volatile.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_VOLATILE_H
+#define _LINUX_VOLATILE_H
+
+#include <linux/fs.h>
+
+extern long mapping_range_volatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long mapping_range_nonvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long mapping_range_isvolatile(struct address_space *mapping,
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
index 469491e0..732258b 100644
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
@@ -128,6 +129,25 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
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
+	case POSIX_FADV_ISVOLATILE:
+		/* First and last PARTIAL page! */
+		start_index = offset >> PAGE_CACHE_SHIFT;
+		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		ret = mapping_range_isvolatile(mapping, start_index, end_index);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/mm/volatile.c b/mm/volatile.c
new file mode 100644
index 0000000..7ac1afd
--- /dev/null
+++ b/mm/volatile.c
@@ -0,0 +1,314 @@
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/volatile.h>
+
+
+struct volatile_range {
+	struct list_head lru;
+	struct range_tree_node range_node;
+
+	unsigned int purged;
+	struct address_space *mapping;
+};
+
+
+/* LRU list of volatile page ranges */
+static LIST_HEAD(volatile_lru_list);
+static DEFINE_MUTEX(volatile_lru_mutex);
+
+/* Count of pages on our LRU list */
+static u64 lru_count;
+
+
+/* range helpers */
+
+static inline u64 range_size(struct volatile_range *range)
+{
+	return range->range_node.end - range->range_node.start + 1;
+}
+
+
+static inline void lru_add(struct volatile_range *range)
+{
+	mutex_lock(&volatile_lru_mutex);
+	list_add_tail(&range->lru, &volatile_lru_list);
+	lru_count += range_size(range);
+	mutex_unlock(&volatile_lru_mutex);
+}
+
+static inline void __lru_del(struct volatile_range *range)
+{
+	list_del(&range->lru);
+	lru_count -= range_size(range);
+}
+
+static inline void lru_del(struct volatile_range *range)
+{
+	mutex_lock(&volatile_lru_mutex);
+	__lru_del(range);
+	mutex_unlock(&volatile_lru_mutex);
+}
+
+#define range_on_lru(range) (!(range)->purged)
+
+
+static inline void volatile_range_shrink(struct volatile_range *range,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	size_t pre = range_size(range);
+
+	range->range_node.start = start_index;
+	range->range_node.end = end_index;
+
+	if (range_on_lru(range)) {
+		mutex_lock(&volatile_lru_mutex);
+		lru_count -= pre - range_size(range);
+		mutex_unlock(&volatile_lru_mutex);
+	}
+}
+
+static struct volatile_range *vrange_alloc(void)
+{
+	struct volatile_range *new;
+
+	new = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
+	if (!new)
+		return 0;
+
+	range_tree_node_init(&new->range_node);
+	return new;
+}
+
+static void vrange_del(struct volatile_range *vrange)
+{
+	struct address_space *mapping;
+	mapping = vrange->mapping;
+
+	mapping->volatile_root =
+		range_tree_remove(mapping->volatile_root, &vrange->range_node);
+	if (range_on_lru(vrange))
+		lru_del(vrange);
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
+
+	u64 start, end;
+	int purged = 0;
+	start = (u64)start_index;
+	end = (u64)end_index;
+
+	new = vrange_alloc();
+	if (!new)
+		return -ENOMEM;
+
+	mutex_lock(&mapping->vlist_mutex);
+
+	node = range_tree_in_range_adjacent(mapping->volatile_root, start, end);
+	while (node) {
+		struct volatile_range *vrange;
+
+		/* Already entirely marked volatile, so we're done */
+		if (node->start < start && node->end > end) {
+			/* don't need the allocated value */
+			kfree(new);
+			return 0;
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
+		vrange_del(vrange);
+
+		/* get the next possible overlap */
+		node = range_tree_in_range(mapping->volatile_root, start, end);
+	}
+
+	new->mapping = mapping;
+	new->range_node.start = start;
+	new->range_node.end = end;
+	new->purged = purged;
+	mapping->volatile_root = range_tree_add(mapping->volatile_root,
+						&new->range_node);
+	if (range_on_lru(new))
+		lru_add(new);
+	mutex_unlock(&mapping->vlist_mutex);
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
+	int ret  = 0;
+	u64 start, end;
+	start = (u64)start_index;
+	end = (u64)end_index;
+
+	mutex_lock(&mapping->vlist_mutex);
+	node = range_tree_in_range(mapping->volatile_root, start, end);
+	while (node) {
+		struct volatile_range *vrange;
+		vrange = container_of(node, struct volatile_range, range_node);
+
+		ret |= vrange->purged;
+
+		if (start <= node->start && end >= node->end) {
+			vrange_del(vrange);
+		} else if (node->start >= start) {
+			volatile_range_shrink(vrange, end+1, node->end);
+		} else if (node->end <= end) {
+			volatile_range_shrink(vrange, node->start, start-1);
+		} else {
+			/* create new node */
+			new = vrange_alloc(); /* XXX ENOMEM HERE? */
+
+			new->mapping = mapping;
+			new->range_node.start = end + 1;
+			new->range_node.end = node->end;
+			volatile_range_shrink(vrange, node->start, start-1);
+			mapping->volatile_root =
+				range_tree_add(mapping->volatile_root,
+						&new->range_node);
+			if (range_on_lru(new))
+				lru_add(new);
+			break;
+		}
+		node = range_tree_in_range(mapping->volatile_root, start, end);
+	}
+	mutex_unlock(&mapping->vlist_mutex);
+
+	return ret;
+}
+
+/*
+ * Returns if a region has been marked volatile or not.
+ * Does not return if the region has been purged.
+ */
+long mapping_range_isvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	long ret = 0;
+	u64 start, end;
+	start = (u64)start_index;
+	end = (u64)end_index;
+
+	mutex_lock(&mapping->vlist_mutex);
+	if (range_tree_in_range(mapping->volatile_root, start, end))
+		ret = 1;
+	mutex_unlock(&mapping->vlist_mutex);
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
+
+	mutex_lock(&mapping->vlist_mutex);
+	while (mapping->volatile_root) {
+		tozap = container_of(mapping->volatile_root,
+					struct volatile_range, range_node);
+		vrange_del(tozap);
+	}
+	mutex_unlock(&mapping->vlist_mutex);
+}
+
+
+static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
+{
+	struct volatile_range *range, *next;
+	unsigned long nr_to_scan = sc->nr_to_scan;
+	const gfp_t gfp_mask = sc->gfp_mask;
+
+	/* We might recurse into filesystem code, so bail out if necessary */
+	if (nr_to_scan && !(gfp_mask & __GFP_FS))
+		return -1;
+	if (!nr_to_scan)
+		return lru_count;
+
+	mutex_lock(&volatile_lru_mutex);
+	list_for_each_entry_safe(range, next, &volatile_lru_list, lru) {
+		struct inode *inode = range->mapping->host;
+		loff_t start, end;
+
+
+		start = range->range_node.start * PAGE_SIZE;
+		end = (range->range_node.end + 1) * PAGE_SIZE - 1;
+
+		/*
+		 * XXX - calling vmtruncate_range from a shrinker causes
+		 * lockdep warnings. Revisit this!
+		 */
+		vmtruncate_range(inode, start, end);
+		range->purged = 1;
+		__lru_del(range);
+
+		nr_to_scan -= range_size(range);
+		if (nr_to_scan <= 0)
+			break;
+	}
+	mutex_unlock(&volatile_lru_mutex);
+
+	return lru_count;
+}
+
+static struct shrinker volatile_shrinker = {
+	.shrink = volatile_shrink,
+	.seeks = DEFAULT_SEEKS * 4,
+};
+
+
+static int __init volatile_init(void)
+{
+	register_shrinker(&volatile_shrinker);
+	return 0;
+}
+
+arch_initcall(volatile_init);
-- 
1.7.3.2.146.gca209

