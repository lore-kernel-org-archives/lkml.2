Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0GIDR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0GIDR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:17:57 -0400
Message-ID: <4C369452.2070103@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:15:30 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 02/11] blkiocg async: The main part of iotrack
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iotrack is a functionality to record who dirtied the
page.  This is needed for block IO controller cgroup
to support async (cached) write.

This patch is based on a patch posted from Ryo Tsuruta
on Oct 2, 2009 titled as "The body of blkio-cgroup".
The patch added a new member on struct page_cgroup to
record cgroup ID, but this was given a negative opinion
from Kame, a maintainer of memory controller cgroup,
because this bloats the size of struct page_cgroup.

Instead, this patch takes an approach proposed by
Andrea Righi, which records cgroup ID in flags
of struct page_cgroup with bit encoding.

ToDo:
Cgroup ID of deleted cgroup will be recycled.  Further
consideration is needed.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/Kconfig.iosched       |    8 +++
 block/Makefile              |    1 +
 block/blk-iotrack.c         |  129 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-iotrack.h |   62 +++++++++++++++++++++
 include/linux/page_cgroup.h |   25 ++++++++
 init/Kconfig                |    2 +-
 mm/page_cgroup.c            |   91 +++++++++++++++++++++++++++---
 7 files changed, 309 insertions(+), 9 deletions(-)
 create mode 100644 block/blk-iotrack.c
 create mode 100644 include/linux/blk-iotrack.h

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 3199b76..3ab712d 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -43,6 +43,14 @@ config CFQ_GROUP_IOSCHED
 	---help---
 	  Enable group IO scheduling in CFQ.
 
+config GROUP_IOSCHED_ASYNC
+	bool "CFQ Group Scheduling for async IOs (EXPERIMENTAL)"
+	depends on CFQ_GROUP_IOSCHED && EXPERIMENTAL
+	select MM_OWNER
+	default n
+	help
+	  Enable group IO scheduling for async IOs.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/Makefile b/block/Makefile
index 0bb499a..441858d 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
+obj-$(CONFIG_GROUP_IOSCHED_ASYNC) += blk-iotrack.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
diff --git a/block/blk-iotrack.c b/block/blk-iotrack.c
new file mode 100644
index 0000000..d98a09a
--- /dev/null
+++ b/block/blk-iotrack.c
@@ -0,0 +1,129 @@
+/* blk-iotrack.c - Block I/O Tracking
+ *
+ * Copyright (C) VA Linux Systems Japan, 2008-2009
+ * Developed by Hirokazu Takahashi <taka@valinux.co.jp>
+ *
+ * Copyright (C) 2010 Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/memcontrol.h>
+#include <linux/mm_inline.h>
+#include <linux/rcupdate.h>
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/blk-iotrack.h>
+#include "blk-cgroup.h"
+
+/*
+ * The block I/O tracking mechanism is implemented on the cgroup memory
+ * controller framework. It helps to find the the owner of an I/O request
+ * because every I/O request has a target page and the owner of the page
+ * can be easily determined on the framework.
+ */
+
+/* Return the blkio_cgroup that associates with a process. */
+static inline struct blkio_cgroup *task_to_blkio_cgroup(struct task_struct *p)
+{
+	return cgroup_to_blkio_cgroup(task_cgroup(p, blkio_subsys_id));
+}
+
+/**
+ * blk_iotrack_set_owner() - set the owner ID of a page.
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Make a given page have the blkio-cgroup ID of the owner of this page.
+ */
+int blk_iotrack_set_owner(struct page *page, struct mm_struct *mm)
+{
+	struct blkio_cgroup *blkcg;
+	unsigned short id = 0;	/* 0: default blkio_cgroup id */
+
+	if (blk_iotrack_disabled())
+		return 0;
+	if (!mm)
+		goto out;
+
+	rcu_read_lock();
+	blkcg = task_to_blkio_cgroup(rcu_dereference(mm->owner));
+	if (likely(blkcg))
+		id = css_id(&blkcg->css);
+	rcu_read_unlock();
+out:
+	return page_cgroup_set_owner(page, id);
+}
+
+/**
+ * blk_iotrack_reset_owner() - reset the owner ID of a page
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Change the owner of a given page if necessary.
+ */
+int blk_iotrack_reset_owner(struct page *page, struct mm_struct *mm)
+{
+	return blk_iotrack_set_owner(page, mm);
+}
+
+/**
+ * blk_iotrack_reset_owner_pagedirty() - reset the owner ID of a pagecache page
+ * @page:	the page we want to tag
+ * @mm:		the mm_struct of a page owner
+ *
+ * Change the owner of a given page if the page is in the pagecache.
+ */
+int blk_iotrack_reset_owner_pagedirty(struct page *page, struct mm_struct *mm)
+{
+	if (!page_is_file_cache(page))
+		return 0;
+	if (current->flags & PF_MEMALLOC)
+		return 0;
+
+	return blk_iotrack_reset_owner(page, mm);
+}
+
+/**
+ * blk_iotrack_copy_owner() - copy the owner ID of a page into another page
+ * @npage:	the page where we want to copy the owner
+ * @opage:	the page from which we want to copy the ID
+ *
+ * Copy the owner ID of @opage into @npage.
+ */
+int blk_iotrack_copy_owner(struct page *npage, struct page *opage)
+{
+	if (blk_iotrack_disabled())
+		return 0;
+	return page_cgroup_copy_owner(npage, opage);
+}
+
+/**
+ * blk_iotrack_cgroup_id() - determine the blkio-cgroup ID
+ * @bio:	the &struct bio which describes the I/O
+ *
+ * Returns the blkio-cgroup ID of a given bio. A return value zero
+ * means that the page associated with the bio belongs to root blkio_cgroup.
+ */
+unsigned long blk_iotrack_cgroup_id(struct bio *bio)
+{
+	struct page *page;
+
+	if (!bio->bi_vcnt)
+		return 0;
+
+	page = bio_iovec_idx(bio, 0)->bv_page;
+	return page_cgroup_get_owner(page);
+}
+EXPORT_SYMBOL(blk_iotrack_cgroup_id);
+
diff --git a/include/linux/blk-iotrack.h b/include/linux/blk-iotrack.h
new file mode 100644
index 0000000..8021c2b
--- /dev/null
+++ b/include/linux/blk-iotrack.h
@@ -0,0 +1,62 @@
+#include <linux/cgroup.h>
+#include <linux/mm.h>
+#include <linux/page_cgroup.h>
+
+#ifndef _LINUX_BLK_IOTRACK_H
+#define _LINUX_BLK_IOTRACK_H
+
+#ifdef CONFIG_GROUP_IOSCHED_ASYNC
+
+/**
+ * blk_iotrack_disabled() - check whether block IO tracking is disabled
+ * Returns true if disabled, false if not.
+ */
+static inline bool blk_iotrack_disabled(void)
+{
+	if (blkio_subsys.disabled)
+		return true;
+	return false;
+}
+
+extern int blk_iotrack_set_owner(struct page *page, struct mm_struct *mm);
+extern int blk_iotrack_reset_owner(struct page *page, struct mm_struct *mm);
+extern int blk_iotrack_reset_owner_pagedirty(struct page *page,
+						 struct mm_struct *mm);
+extern int blk_iotrack_copy_owner(struct page *page, struct page *opage);
+extern unsigned long blk_iotrack_cgroup_id(struct bio *bio);
+
+#else /* !CONFIG_GROUP_IOSCHED_ASYNC */
+
+static inline bool blk_iotrack_disabled(void)
+{
+	return true;
+}
+
+static inline int blk_iotrack_set_owner(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline int blk_iotrack_reset_owner(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline int blk_iotrack_reset_owner_pagedirty(struct page *page,
+						struct mm_struct *mm)
+{
+}
+
+static inline int blk_iotrack_copy_owner(struct page *page,
+						struct page *opage)
+{
+}
+
+static inline unsigned long blk_iotrack_cgroup_id(struct bio *bio)
+{
+	return 0;
+}
+
+#endif /* CONFIG_GROUP_IOSCHED_ASYNC */
+
+#endif /* _LINUX_BLK_IOTRACK_H */
diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 6a21b0d..473b79a 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -17,6 +17,31 @@ struct page_cgroup {
 	struct list_head lru;		/* per cgroup LRU list */
 };
 
+/*
+ * use lower 16 bits for flags and reserve the rest for the page tracking id
+ */
+#define PAGE_TRACKING_ID_SHIFT	(16)
+#define PAGE_TRACKING_ID_BITS \
+		(8 * sizeof(unsigned long) - PAGE_TRACKING_ID_SHIFT)
+
+/* NOTE: must be called with page_cgroup() lock held */
+static inline unsigned long page_cgroup_get_id(struct page_cgroup *pc)
+{
+	return pc->flags >> PAGE_TRACKING_ID_SHIFT;
+}
+
+/* NOTE: must be called with page_cgroup() lock held */
+static inline void page_cgroup_set_id(struct page_cgroup *pc, unsigned long id)
+{
+	WARN_ON(id >= (1UL << PAGE_TRACKING_ID_BITS));
+	pc->flags &= (1UL << PAGE_TRACKING_ID_SHIFT) - 1;
+	pc->flags |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
+}
+
+unsigned long page_cgroup_get_owner(struct page *page);
+int page_cgroup_set_owner(struct page *page, unsigned long id);
+int page_cgroup_copy_owner(struct page *npage, struct page *opage);
+
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
 
 #ifdef CONFIG_SPARSEMEM
diff --git a/init/Kconfig b/init/Kconfig
index 2e40f2f..337ee01 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -650,7 +650,7 @@ endif # CGROUPS
 
 config CGROUP_PAGE
 	def_bool y
-	depends on CGROUP_MEM_RES_CTLR
+	depends on CGROUP_MEM_RES_CTLR || GROUP_IOSCHED_ASYNC
 
 config MM_OWNER
 	bool
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6c00814..69e080c 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
+#include <linux/blk-iotrack.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -74,7 +75,7 @@ void __init page_cgroup_init_flatmem(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() && blk_iotrack_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -83,12 +84,13 @@ void __init page_cgroup_init_flatmem(void)
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
 
@@ -251,7 +253,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() && blk_iotrack_disabled())
 		return;
 
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
@@ -260,14 +262,15 @@ void __init page_cgroup_init(void)
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
@@ -277,6 +280,78 @@ void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
 
 #endif
 
+/**
+ * page_cgroup_get_owner() - get the owner ID of a page
+ * @page:	the page we want to find the owner
+ *
+ * Returns the owner ID of the page, 0 means that the owner cannot be
+ * retrieved.
+ **/
+unsigned long page_cgroup_get_owner(struct page *page)
+{
+	struct page_cgroup *pc;
+	unsigned long ret;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return 0;
+
+	lock_page_cgroup(pc);
+	ret = page_cgroup_get_id(pc);
+	unlock_page_cgroup(pc);
+	return ret;
+}
+
+/**
+ * page_cgroup_set_owner() - set the owner ID of a page
+ * @page:	the page we want to tag
+ * @id:		the ID number that will be associated to page
+ *
+ * Returns 0 if the owner is correctly associated to the page. Returns a
+ * negative value in case of failure.
+ **/
+int page_cgroup_set_owner(struct page *page, unsigned long id)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+	if (unlikely(!pc))
+		return -ENOENT;
+
+	lock_page_cgroup(pc);
+	page_cgroup_set_id(pc, id);
+	unlock_page_cgroup(pc);
+	return 0;
+}
+
+/**
+ * page_cgroup_copy_owner() - copy the owner ID of a page into another page
+ * @npage:	the page where we want to copy the owner
+ * @opage:	the page from which we want to copy the ID
+ *
+ * Returns 0 if the owner is correctly associated to npage. Returns a negative
+ * value in case of failure.
+ **/
+int page_cgroup_copy_owner(struct page *npage, struct page *opage)
+{
+	struct page_cgroup *npc, *opc;
+	unsigned long id;
+
+	npc = lookup_page_cgroup(npage);
+	if (unlikely(!npc))
+		return -ENOENT;
+	opc = lookup_page_cgroup(opage);
+	if (unlikely(!opc))
+		return -ENOENT;
+	lock_page_cgroup(opc);
+	lock_page_cgroup(npc);
+	id = page_cgroup_get_id(opc);
+	page_cgroup_set_id(npc, id);
+	unlock_page_cgroup(npc);
+	unlock_page_cgroup(opc);
+
+	return 0;
+}
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 
-- 
1.6.2.5
