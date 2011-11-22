Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1KVDeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:34:00 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47525 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1KVDd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:33:59 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags
Date: Mon, 21 Nov 2011 19:33:08 -0800
Message-Id: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11112203-5518-0000-0000-000000894B26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides new fadvise flags that can be used to mark
file pages as volatile, which will allow it to be discarded if the
kernel wants to reclaim memory.

This is useful for userspace to allocate things like caches, and lets
the kernel destructively (but safely) reclaim them when there's memory
pressure.

Right now, we can simply throw away pages if they are clean (backed
by a current on-disk copy).  That only happens for anonymous/tmpfs/shmfs
pages when they're swapped out.  This patch lets userspace select
dirty pages which can be simply thrown away instead of writing them
to disk first.  See the mm/shmem.c for this bit of code.  It's
different from FADV_DONTNEED since the pages are not immediately
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

CC: Robert Love <rlove@google.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Eric Anholt <eric@anholt.net>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/inode.c               |    2 +
 include/linux/fadvise.h  |    6 +
 include/linux/fs.h       |    2 +
 include/linux/volatile.h |   34 ++++++
 mm/Makefile              |    2 +-
 mm/fadvise.c             |   21 ++++-
 mm/shmem.c               |   14 +++
 mm/volatile.c            |  253 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 332 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

diff --git a/fs/inode.c b/fs/inode.c
index ee4e66b..78a7581 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -247,6 +247,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+	mapping_clear_volatile_ranges(&inode->i_data);
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
@@ -278,6 +279,7 @@ void address_space_init_once(struct address_space *mapping)
 	spin_lock_init(&mapping->private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
 	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+	INIT_LIST_HEAD(&mapping->volatile_list);
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
index e313022..4f15ade 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/volatile.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -650,6 +651,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct list_head	volatile_list;	/* volatile range list */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/volatile.h b/include/linux/volatile.h
new file mode 100644
index 0000000..11e8a3e
--- /dev/null
+++ b/include/linux/volatile.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_VOLATILE_H
+#define _LINUX_VOLATILE_H
+
+struct address_space;
+
+
+struct volatile_range {
+	/*
+	 * List is sorted, and no two ranges
+	 * on the same list should overlap.
+	 */
+	struct list_head unpinned;
+	pgoff_t start_page;
+	pgoff_t end_page;
+	unsigned int purged;
+};
+
+static inline bool page_in_range(struct volatile_range *range,
+					pgoff_t page_index)
+{
+	return (range->start_page <= page_index) &&
+					(range->end_page >= page_index);
+}
+
+extern long mapping_range_volatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long mapping_range_nonvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern long mapping_range_isvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index);
+extern void mapping_clear_volatile_ranges(struct address_space *mapping);
+
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
index 8d723c9..e4530c9 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -106,7 +106,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
+
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
 				nrpages);
@@ -127,6 +127,25 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
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
diff --git a/mm/shmem.c b/mm/shmem.c
index d672250..765cef2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -679,6 +679,20 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	index = page->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
+
+	/* Check if page is in volatile range */
+	if (!list_empty(&mapping->volatile_list)) {
+		struct volatile_range *range, *next;
+		list_for_each_entry_safe(range, next, &mapping->volatile_list,
+					unpinned) {
+			if (page_in_range(range, index)) {
+				range->purged = 1;
+				unlock_page(page);
+				return 0;
+			}
+		}
+	}
+
 	if (info->flags & VM_LOCKED)
 		goto redirty;
 	if (!total_swap_pages)
diff --git a/mm/volatile.c b/mm/volatile.c
new file mode 100644
index 0000000..c6a9c00
--- /dev/null
+++ b/mm/volatile.c
@@ -0,0 +1,253 @@
+/* mm/volatile.c
+ *
+ * Volatile page range managment.
+ *	Copyright 2011 Linaro
+ *
+ * Based on mm/ashmem.c 
+ * 	by Robert Love <rlove@google.com>
+ * 	Copyright (C) 2008 Google, Inc.
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
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/volatile.h>
+
+/* range helpers */
+static inline bool range_before_page(struct volatile_range *range,
+					pgoff_t page_index)
+{
+	return range->end_page < page_index;
+}
+
+static inline bool page_range_subsumes_range(struct volatile_range *range,
+					pgoff_t start_index, pgoff_t end_index)
+{
+
+	return (range->start_page >= start_index)
+			&& (range->end_page <= end_index);
+}
+
+static inline bool page_range_subsumed_by_range(
+					struct volatile_range *range,
+					pgoff_t start_index, pgoff_t end_index)
+{
+	return (range->start_page <= start_index)
+			&& (range->end_page >= end_index);
+}
+
+static inline bool page_range_in_range(struct volatile_range *range,
+					pgoff_t start_index, pgoff_t end_index)
+{
+	return page_in_range(range, start_index) ||
+		page_in_range(range, end_index) ||
+		page_range_subsumes_range(range, start_index, end_index);
+}
+
+
+
+/*
+ * Allocates a volatile_range, and adds it to the address_space's
+ * volatile list
+ */
+static int volatile_range_alloc(struct volatile_range *prev_range,
+                               unsigned int purged,
+			       pgoff_t start_index, pgoff_t end_index)
+{
+       struct volatile_range *range;
+
+       range = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
+       if (!range)
+               return -ENOMEM;
+
+       range->start_page = start_index;
+       range->end_page = end_index;
+       range->purged = purged;
+
+       list_add_tail(&range->unpinned, &prev_range->unpinned);
+
+       return 0;
+}
+
+/*
+ * Deletes a volatile_range, removing it from the address_space's
+ * unpinned list
+ */
+static void volatile_range_del(struct volatile_range *range)
+{
+       list_del(&range->unpinned);
+       kfree(range);
+}
+
+/*
+ * Resizes a volatile_range
+ */
+static inline void volatile_range_shrink(struct volatile_range *range,
+                               pgoff_t start_index, pgoff_t end_index)
+{
+       range->start_page = start_index;
+       range->end_page = end_index;
+}
+
+
+/*
+ * Mark a region as volatile, allowing dirty pages to be purged
+ * under memory pressure
+ */
+long mapping_range_volatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *range, *next;
+	unsigned int purged = 0;
+	int ret;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+restart:
+	/* Iterate through the sorted range list */
+	list_for_each_entry_safe(range, next, &mapping->volatile_list,
+					unpinned) {
+		/*
+		 * If the current existing range is before the start
+		 * of tnew range, then we're done, since the list is
+		 * sorted
+		 */
+		if (range_before_page(range, start_index))
+			break;
+		/*
+		 * If the new range is already covered by the existing
+		 * range, then there is nothing we need to do.
+		 */
+		if (page_range_subsumed_by_range(range, start_index,
+								end_index)) {
+			ret = 0;
+			goto out;
+		}
+		/*
+		 * Coalesce if the new range overlaps the existing range,
+		 * by growing the new range to cover the existing range,
+		 * deleting the existing range, and start over.
+		 * Starting over is necessary to make sure we also coalesce
+		 * any other ranges we overlap with.
+		 */
+		if (page_range_in_range(range, start_index, end_index)) {
+			start_index = min_t(size_t, range->start_page,
+						start_index);
+			end_index = max_t(size_t, range->end_page, end_index);
+			purged |= range->purged;
+			volatile_range_del(range);
+			goto restart;
+		}
+
+	}
+	/* Allocate the new range and add it to the list */
+	ret = volatile_range_alloc(range, purged, start_index, end_index);
+
+out:
+	mutex_unlock(&mapping->i_mmap_mutex);
+	return ret;
+}
+
+/*
+ * Mark a region as nonvolatile, returns 1 if any pages in the region
+ * were purged.
+ */
+long mapping_range_nonvolatile(struct address_space *mapping,
+				pgoff_t start_index, pgoff_t end_index)
+{
+	struct volatile_range *range, *next;
+	int ret  = 0;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+	list_for_each_entry_safe(range, next, &mapping->volatile_list,
+				unpinned) {
+		if (range_before_page(range, start_index))
+			break;
+
+		if (page_range_in_range(range, start_index, end_index)) {
+			ret |= range->purged;
+			/* Case #1: Easy. Just nuke the whole thing. */
+			if (page_range_subsumes_range(range, start_index,
+								end_index)) {
+				volatile_range_del(range);
+				continue;
+			}
+
+			/* Case #2: We overlap from the start, so adjust it */
+			if (range->start_page >= start_index) {
+				volatile_range_shrink(range, end_index + 1,
+							range->end_page);
+				continue;
+			}
+
+			/* Case #3: We overlap from the rear, so adjust it */
+			if (range->end_page <= end_index) {
+				volatile_range_shrink(range, range->start_page,
+							start_index - 1);
+				continue;
+			}
+
+			/*
+			 * Case #4: We eat a chunk out of the middle. A bit
+			 * more complicated, we allocate a new range for the
+			 * second half and adjust the first chunk's endpoint.
+			 */
+			volatile_range_alloc(range, range->purged,
+						end_index + 1, range->end_page);
+			volatile_range_shrink(range, range->start_page,
+						start_index - 1);
+		}
+	}
+	mutex_unlock(&mapping->i_mmap_mutex);
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
+	struct volatile_range *range;
+	long ret = 0;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+	list_for_each_entry(range, &mapping->volatile_list, unpinned) {
+		if (range_before_page(range, start_index))
+			break;
+		if (page_range_in_range(range, start_index, end_index)) {
+			ret = 1;
+			break;
+		}
+	}
+	mutex_unlock(&mapping->i_mmap_mutex);
+	return ret;
+}
+
+
+/*
+ * Cleans up any volatile ranges.
+ */
+void mapping_clear_volatile_ranges(struct address_space *mapping)
+{
+	struct volatile_range *range;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+	list_for_each_entry(range, &mapping->volatile_list, unpinned)
+		volatile_range_del(range);
+	mutex_unlock(&mapping->i_mmap_mutex);
+
+}
-- 
1.7.3.2.146.gca209

