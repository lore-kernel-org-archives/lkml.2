Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1CVXKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:10:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab1CVXJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=kGdc9R78f0CpQZWjWxPK5JVQ4QxUW1poJo98ZsEdME0ylvtS+tYj4gg2f/4pMMUUd
	JRTL7vbgMvQNl2wptfskg==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 2/8] block,fs,mm: IO cgroup tracking for buffered write
Date: Tue, 22 Mar 2011 16:08:49 -0700
Message-Id: <1300835335-2777-3-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IO tracking code in the fs/ and mm/ trees so that
the block layer can provide isolation for buffered writes.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/blk-cgroup.c          |  183 +++++++++++++++++++++++++++++++++++++++++++
 fs/buffer.c                 |    2 +
 fs/direct-io.c              |    2 +
 include/linux/blkio-track.h |   89 +++++++++++++++++++++
 include/linux/iocontext.h   |    1 +
 include/linux/memcontrol.h  |    6 ++
 include/linux/mmzone.h      |    4 +-
 include/linux/page_cgroup.h |   38 +++++++++-
 init/Kconfig                |   16 ++++
 mm/Makefile                 |    3 +-
 mm/bounce.c                 |    2 +
 mm/filemap.c                |    2 +
 mm/memcontrol.c             |    6 ++
 mm/memory.c                 |    6 ++
 mm/page-writeback.c         |   14 +++-
 mm/page_cgroup.c            |   29 +++++---
 mm/swap_state.c             |    2 +
 17 files changed, 388 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/blkio-track.h

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 77ee3c1..f626c65 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -19,6 +19,8 @@
 #include <linux/slab.h>
 #include "blk-cgroup.h"
 #include <linux/genhd.h>
+#include <linux/blkio-track.h>
+#include <linux/mm_inline.h>
 
 #define MAX_KEY_LEN 100
 
@@ -175,6 +177,12 @@ static inline void blkio_update_group_iops(struct blkio_group *blkg,
 	}
 }
 
+static inline struct blkio_cgroup *blkio_cgroup_from_task(struct task_struct *p)
+{
+	return container_of(task_subsys_state(p, blkio_subsys_id),
+					struct blkio_cgroup, css);
+}
+
 /*
  * Add to the appropriate stat variable depending on the request type.
  * This should be called with the blkg->stats_lock held.
@@ -1241,8 +1249,20 @@ blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	return 0;
 }
 
+/* Read the ID of the specified blkio cgroup. */
+static u64 blkio_id_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	return (u64)css_id(&blkcg->css);
+}
+
 struct cftype blkio_files[] = {
 	{
+		.name = "id",
+		.read_u64 = blkio_id_read,
+	},
+	{
 		.name = "weight_device",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_weight_device),
@@ -1399,6 +1419,169 @@ struct cftype blkio_files[] = {
 #endif
 };
 
+/* Block IO tracking related functions */
+
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+
+/*
+ * The block I/O tracking mechanism is implemented on the cgroup memory
+ * controller framework. It helps to find the the owner of an I/O request
+ * because every I/O request has a target page and the owner of the page
+ * can be easily determined on the framework.
+ */
+
+/**
+ * blkio_cgroup_set_owner() - set the owner ID of a page.
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Make a given page have the blkio-cgroup ID of the owner of this page.
+ */
+void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
+{
+	struct blkio_cgroup *blkcg;
+	struct page_cgroup *pc;
+
+	if (blkio_cgroup_disabled())
+		return;
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return;
+
+	page_cgroup_set_blkio_id(pc, 0);	/* 0: default blkio_cgroup id */
+	if (!mm)
+		return;
+	/*
+	 * Locking "pc" isn't necessary here since the current process is
+	 * the only one that can access the members related to blkio_cgroup.
+	 */
+	rcu_read_lock();
+	blkcg = blkio_cgroup_from_task(rcu_dereference(mm->owner));
+	if (unlikely(!blkcg))
+		goto out;
+	/*
+	 * css_get(&bio->css) isn't called to increment the reference
+	 * count of this blkio_cgroup "blkcg" so pc's blkio_cgroup_id
+	 * might turn invalid even if this page is still active.
+	 * This approach is chosen to minimize the overhead.
+	 */
+	page_cgroup_set_blkio_id(pc, css_id(&blkcg->css));
+out:
+	rcu_read_unlock();
+}
+
+/**
+ * blkio_cgroup_reset_owner() - reset the owner ID of a page
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Change the owner of a given page if necessary.
+ */
+void blkio_cgroup_reset_owner(struct page *page, struct mm_struct *mm)
+{
+	/*
+	 * A little trick:
+	 * Just call blkio_cgroup_set_owner() for pages which are already
+	 * active since the blkio_cgroup_id member of page_cgroup can be
+	 * updated without any locks.
+	 */
+	blkio_cgroup_set_owner(page, mm);
+}
+
+/**
+ * blkio_cgroup_reset_owner_pagedirty() - reset the owner ID of a pagecache page
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Change the owner of a given page if the page is in the pagecache.
+ */
+void blkio_cgroup_reset_owner_pagedirty(struct page *page, struct mm_struct *mm)
+{
+	if (!page_is_file_cache(page))
+		return;
+	if (current->flags & PF_MEMALLOC)
+		return;
+
+	blkio_cgroup_reset_owner(page, mm);
+}
+
+/**
+ * blkio_cgroup_copy_owner() - copy the owner ID of a page into another page
+ * @npage:	the page where we want to copy the owner
+ * @opage:	the page from which we want to copy the ID
+ *
+ * Copy the owner ID of @opage into @npage.
+ */
+void blkio_cgroup_copy_owner(struct page *npage, struct page *opage)
+{
+	struct page_cgroup *npc, *opc;
+
+	if (blkio_cgroup_disabled())
+		return;
+	npc = lookup_page_cgroup(npage);
+	if (unlikely(!npc))
+		return;
+	opc = lookup_page_cgroup(opage);
+	if (unlikely(!opc))
+		return;
+
+	/*
+	 * Do this without any locks. The reason is the same as
+	 * blkio_cgroup_reset_owner().
+	 */
+	page_cgroup_set_blkio_id(npc, page_cgroup_get_blkio_id(opc));
+}
+
+/**
+ * get_blkio_cgroup_id() - determine the blkio-cgroup ID
+ * @bio:	the &struct bio which describes the I/O
+ *
+ * Returns the blkio-cgroup ID of a given bio. A return value zero
+ * means that the page associated with the bio belongs to default_blkio_cgroup.
+ */
+unsigned long get_blkio_cgroup_id(struct bio *bio)
+{
+	struct page_cgroup *pc;
+	struct page *page = bio_iovec_idx(bio, 0)->bv_page;
+	unsigned long id = 0;
+
+	pc = lookup_page_cgroup(page);
+	if (pc)
+		id = page_cgroup_get_blkio_id(pc);
+	return id;
+}
+
+/**
+ * get_cgroup_from_page() - determine the cgroup from a page.
+ * @page:	the page to be tracked
+ *
+ * Returns the cgroup of a given page. A return value zero means that
+ * the page associated with the page belongs to default_blkio_cgroup.
+ *
+ * Note:
+ * This function must be called under rcu_read_lock().
+ */
+struct cgroup *get_cgroup_from_page(struct page *page)
+{
+	struct page_cgroup *pc;
+	struct cgroup_subsys_state *css;
+
+	pc = lookup_page_cgroup(page);
+	if (!pc)
+		return NULL;
+
+	css = css_lookup(&blkio_subsys, page_cgroup_get_blkio_id(pc));
+	if (!css)
+		return NULL;
+
+	return css->cgroup;
+}
+
+EXPORT_SYMBOL(get_blkio_cgroup_id);
+EXPORT_SYMBOL(get_cgroup_from_page);
+
+#endif /* CONFIG_CGROUP_BLKIOTRACK */
+
 static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 {
 	return cgroup_add_files(cgroup, subsys, blkio_files,
diff --git a/fs/buffer.c b/fs/buffer.c
index 2e6b1a3..f344929 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -36,6 +36,7 @@
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
+#include <linux/blkio-track.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
@@ -659,6 +660,7 @@ static void __set_page_dirty(struct page *page,
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
+		blkio_cgroup_reset_owner_pagedirty(page, current->mm);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4260831..7c684fa 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -33,6 +33,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/blkio-track.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <asm/atomic.h>
@@ -852,6 +853,7 @@ static int do_direct_IO(struct dio *dio)
 			ret = PTR_ERR(page);
 			goto out;
 		}
+		blkio_cgroup_reset_owner(page, current->mm);
 
 		while (block_in_page < blocks_per_page) {
 			unsigned offset_in_page = block_in_page << blkbits;
diff --git a/include/linux/blkio-track.h b/include/linux/blkio-track.h
new file mode 100644
index 0000000..4a49c57
--- /dev/null
+++ b/include/linux/blkio-track.h
@@ -0,0 +1,89 @@
+#include <linux/cgroup.h>
+#include <linux/mm.h>
+#include <linux/page_cgroup.h>
+
+#ifndef _LINUX_BIOTRACK_H
+#define _LINUX_BIOTRACK_H
+
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+
+struct block_device;
+
+/**
+ * __init_blkio_page_cgroup() - initialize a blkio_page_cgroup
+ * @pc:		page_cgroup of the page
+ *
+ * Reset the owner ID of a page.
+ */
+static inline void __init_blkio_page_cgroup(struct page_cgroup *pc)
+{
+	page_cgroup_set_blkio_id(pc, 0);
+}
+
+/**
+ * blkio_cgroup_disabled() - check whether blkio_cgroup is disabled
+ *
+ * Returns true if disabled, false if not.
+ */
+static inline bool blkio_cgroup_disabled(void)
+{
+	if (blkio_subsys.disabled)
+		return true;
+	return false;
+}
+
+extern void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm);
+extern void blkio_cgroup_reset_owner(struct page *page, struct mm_struct *mm);
+extern void blkio_cgroup_reset_owner_pagedirty(struct page *page,
+						 struct mm_struct *mm);
+extern void blkio_cgroup_copy_owner(struct page *page, struct page *opage);
+
+extern unsigned long get_blkio_cgroup_id(struct bio *bio);
+extern struct cgroup *get_cgroup_from_page(struct page *page);
+
+#else /* !CONFIG_CGROUP_BLKIOTRACK */
+
+struct blkiotrack_cgroup;
+
+static inline void __init_blkio_page_cgroup(struct page_cgroup *pc)
+{
+}
+
+static inline bool blkio_cgroup_disabled(void)
+{
+	return true;
+}
+
+static inline void blkio_cgroup_set_owner(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline void blkio_cgroup_reset_owner(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline void blkio_cgroup_reset_owner_pagedirty(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline void blkio_cgroup_copy_owner(struct page *page,
+						struct page *opage)
+{
+}
+
+static inline unsigned long get_blkio_cgroup_id(struct bio *bio)
+{
+	return 0;
+}
+
+static inline struct cgroup *get_cgroup_from_page(struct page *page)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CGROUP_BLKIOTRACK */
+
+#endif /* _LINUX_BIOTRACK_H */
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index b2eee89..3e70b21 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -76,6 +76,7 @@ int put_io_context(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(struct task_struct *task)
 {
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f512e18..a8a7cf0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -49,6 +49,8 @@ extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
  * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
  */
 
+extern void __init_mem_page_cgroup(struct page_cgroup *pc);
+
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
@@ -153,6 +155,10 @@ void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
+static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+}
+
 static inline int mem_cgroup_newpage_charge(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
 {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 02ecb01..a04c37a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -615,7 +615,7 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	struct page_cgroup *node_page_cgroup;
 #endif
 #endif
@@ -975,7 +975,7 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 6d6cb7a..6a86c0d 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+#ifdef CONFIG_CGROUP_PAGE
 #include <linux/bit_spinlock.h>
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -11,12 +11,43 @@
  * then the page cgroup for pfn always exists.
  */
 struct page_cgroup {
+#ifdef CONFIG_CGROUP_PAGE
 	unsigned long flags;
+#endif
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
 	struct page *page;
 	struct list_head lru;		/* per cgroup LRU list */
+#endif
 };
 
+#ifdef CONFIG_CGROUP_BLKIOTRACK
+#define PAGE_TRACKING_ID_SHIFT (16)
+#define PAGE_TRACKING_ID_BITS \
+		(8 * sizeof(unsigned long) - PAGE_TRACKING_ID_SHIFT)
+
+static inline void page_cgroup_set_blkio_id(struct page_cgroup *pc,
+				unsigned long id)
+{
+	unsigned long old, new, prev;
+
+	/* pc->flags isn't lock protected, so we must cmpxchg. */
+	WARN_ON(id >= (1UL << PAGE_TRACKING_ID_BITS));
+	do {
+		new = old = pc->flags;
+		new &= (1UL << PAGE_TRACKING_ID_SHIFT) - 1;
+		new |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
+		prev = cmpxchg(&pc->flags, old, new);
+	} while (prev != old);
+}
+
+static inline unsigned long page_cgroup_get_blkio_id(struct page_cgroup *pc)
+{
+	return pc->flags >> PAGE_TRACKING_ID_SHIFT;
+}
+#endif
+
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
 
 #ifdef CONFIG_SPARSEMEM
@@ -33,6 +64,8 @@ static inline void __init page_cgroup_init(void)
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
@@ -131,8 +164,9 @@ static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
 	bit_spin_unlock(PCG_MOVE_LOCK, &pc->flags);
 	local_irq_restore(*flags);
 }
+#endif
 
-#else /* CONFIG_CGROUP_MEM_RES_CTLR */
+#else /* CONFIG_CGROUP_PAGE */
 struct page_cgroup;
 
 static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
diff --git a/init/Kconfig b/init/Kconfig
index be788c0..ce1cbba 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -742,6 +742,22 @@ config DEBUG_BLK_CGROUP
 	Enable some debugging help. Currently it exports additional stat
 	files in a cgroup which can be useful for debugging.
 
+config CGROUP_BLKIOTRACK
+	bool "Track async request block io"
+	depends on CGROUPS && BLOCK
+	select MM_OWNER
+	default n
+	---help---
+	  Provides a Resource Controller which enables to track the onwner
+	  of every Block I/O requests.
+	  The information this subsystem provides can be used from any
+	  kind of module such as dm-ioband device mapper modules or
+	  the cfq-scheduler.
+
+config CGROUP_PAGE
+	def_bool y
+	depends on CGROUP_MEM_RES_CTLR || CGROUP_BLKIOTRACK
+
 endif # CGROUPS
 
 menuconfig NAMESPACES
diff --git a/mm/Makefile b/mm/Makefile
index 2b1b575..7da3bc8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -38,7 +38,8 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_PAGE) += page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
diff --git a/mm/bounce.c b/mm/bounce.c
index 1481de6..64980fb 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
+#include <linux/blkio-track.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
@@ -211,6 +212,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		blkio_cgroup_copy_owner(to->bv_page, page);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
diff --git a/mm/filemap.c b/mm/filemap.c
index f9a29c8..263a3f6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include <linux/blkio-track.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include "internal.h"
 
@@ -377,6 +378,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
+	blkio_cgroup_set_owner(page, current->mm);
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index da53a25..e11c2cd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -359,6 +359,12 @@ static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 static void drain_all_stock_async(void);
 
+void __meminit __init_mem_page_cgroup(struct page_cgroup *pc)
+{
+	pc->mem_cgroup = NULL;
+	INIT_LIST_HEAD(&pc->lru);
+}
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 5823698..385bb54 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -52,6 +52,7 @@
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
+#include <linux/blkio-track.h>
 #include <linux/mmu_notifier.h>
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
@@ -2391,6 +2392,7 @@ gotten:
 		 */
 		ptep_clear_flush(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
+		blkio_cgroup_set_owner(new_page, mm);
 		/*
 		 * We call the notify macro here because, when using secondary
 		 * mmu page tables (such as kvm shadow page tables), we want the
@@ -2828,6 +2830,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	do_page_add_anon_rmap(page, vma, address, exclusive);
+	blkio_cgroup_reset_owner(page, mm);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -2959,6 +2962,8 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
+	/* Not setting the owner for special pages */
+	blkio_cgroup_set_owner(page, mm);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
 
@@ -3108,6 +3113,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (anon) {
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
+			blkio_cgroup_set_owner(page, mm);
 		} else {
 			inc_mm_counter_fast(mm, MM_FILEPAGES);
 			page_add_file_rmap(page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 24b7ac2..d49b398 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blkio-track.h>
 #include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
@@ -1159,7 +1160,8 @@ EXPORT_SYMBOL(account_page_writeback);
  * We take care to handle the case where the page was truncated from the
  * mapping by re-checking page_mapping() inside tree_lock.
  */
-int __set_page_dirty_nobuffers(struct page *page)
+int __set_page_dirty_nobuffers_track_owner(struct page *page,
+					   int update_owner)
 {
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
@@ -1174,6 +1176,9 @@ int __set_page_dirty_nobuffers(struct page *page)
 			BUG_ON(mapping2 != mapping);
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			account_page_dirtied(page, mapping);
+			if (update_owner)
+				blkio_cgroup_reset_owner_pagedirty(page,
+								current->mm);
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
@@ -1186,6 +1191,11 @@ int __set_page_dirty_nobuffers(struct page *page)
 	}
 	return 0;
 }
+
+int __set_page_dirty_nobuffers(struct page *page)
+{
+	return __set_page_dirty_nobuffers_track_owner(page, 1);
+}
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
@@ -1196,7 +1206,7 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
 	wbc->pages_skipped++;
-	return __set_page_dirty_nobuffers(page);
+	return __set_page_dirty_nobuffers_track_owner(page, 0);
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..78f5425 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -10,14 +10,17 @@
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
+#include <linux/blkio-track.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
 {
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	pc->flags = 0;
-	pc->mem_cgroup = NULL;
 	pc->page = pfn_to_page(pfn);
-	INIT_LIST_HEAD(&pc->lru);
+#endif
+	__init_mem_page_cgroup(pc);
+	__init_blkio_page_cgroup(pc);
 }
 static unsigned long total_usage;
 
@@ -75,7 +78,7 @@ void __init page_cgroup_init_flatmem(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() && blkio_cgroup_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -84,12 +87,13 @@ void __init page_cgroup_init_flatmem(void)
 			goto fail;
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
-	" don't want memory cgroups\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory,blkio' option"
+	" if you don't want memory and blkio cgroups\n");
 	return;
 fail:
 	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
-	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
+	printk(KERN_CRIT
+		"please try 'cgroup_disable=memory,blkio' boot option\n");
 	panic("Out of memory");
 }
 
@@ -134,6 +138,7 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 		 */
 		kmemleak_not_leak(base);
 	} else {
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 		/*
  		 * We don't have to allocate page_cgroup again, but
 		 * address of memmap may be changed. So, we have to initialize
@@ -144,6 +149,9 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 		/* check address of memmap is changed or not. */
 		if (base->page == pfn_to_page(pfn))
 			return 0;
+#else
+		return 0;
+#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
 	}
 
 	if (!base) {
@@ -258,7 +266,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() && blkio_cgroup_disabled())
 		return;
 
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
@@ -267,14 +275,15 @@ void __init page_cgroup_init(void)
 		fail = init_section_page_cgroup(pfn);
 	}
 	if (fail) {
-		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
+		printk(KERN_CRIT
+			"try 'cgroup_disable=memory,blkio' boot option\n");
 		panic("Out of memory");
 	} else {
 		hotplug_memory_notifier(page_cgroup_callback, 0);
 	}
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
-	" want memory cgroups\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory,blkio' option"
+	" if you don't want memory and blkio cgroups\n");
 }
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4668046..5c7c910 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -19,6 +19,7 @@
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/page_cgroup.h>
+#include <linux/blkio-track.h>
 
 #include <asm/pgtable.h>
 
@@ -327,6 +328,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
+		blkio_cgroup_set_owner(new_page, current->mm);
 		err = __add_to_swap_cache(new_page, entry);
 		if (likely(!err)) {
 			radix_tree_preload_end();
-- 
1.7.3.1

