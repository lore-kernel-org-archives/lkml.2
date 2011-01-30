Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1A3DQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 22:16:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:22257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1A3DP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 22:15:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,398,1291622400"; 
   d="scan'208";a="597720039"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
        Tony Luck <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Roland Dreier <roland@kernel.org>,
        Ralph Campbell <infinipath@qlogic.com>
Subject: [PATCH -v2 1/3] mm, export __get_user_pages
Date: Sun, 30 Jan 2011 11:15:47 +0800
Message-Id: <1296357349-18022-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
References: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most cases, get_user_pages and get_user_pages_fast should be used
to pin user pages in memory.  But sometimes, some special flags except
FOLL_GET, FOLL_WRITE and FOLL_FORCE are needed, for example in
following patch, KVM needs FOLL_HWPOISON.  To support these users,
__get_user_pages is exported directly.

There are some symbol name conflicts in infiniband driver, fixed them too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>
CC: Roland Dreier <roland@kernel.org>
CC: Ralph Campbell <infinipath@qlogic.com>
---
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    6 +--
 drivers/infiniband/hw/qib/qib_user_pages.c     |    6 +--
 include/linux/mm.h                             |    4 ++
 mm/internal.h                                  |    5 --
 mm/memory.c                                    |   50 +++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -53,8 +53,8 @@ static void __ipath_release_user_pages(s
 }
 
 /* call with current->mm->mmap_sem held */
-static int __get_user_pages(unsigned long start_page, size_t num_pages,
-			struct page **p, struct vm_area_struct **vma)
+static int __ipath_get_user_pages(unsigned long start_page, size_t num_pages,
+				  struct page **p, struct vm_area_struct **vma)
 {
 	unsigned long lock_limit;
 	size_t got;
@@ -165,7 +165,7 @@ int ipath_get_user_pages(unsigned long s
 
 	down_write(&current->mm->mmap_sem);
 
-	ret = __get_user_pages(start_page, num_pages, p, NULL);
+	ret = __ipath_get_user_pages(start_page, num_pages, p, NULL);
 
 	up_write(&current->mm->mmap_sem);
 
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -51,8 +51,8 @@ static void __qib_release_user_pages(str
 /*
  * Call with current->mm->mmap_sem held.
  */
-static int __get_user_pages(unsigned long start_page, size_t num_pages,
-			    struct page **p, struct vm_area_struct **vma)
+static int __qib_get_user_pages(unsigned long start_page, size_t num_pages,
+				struct page **p, struct vm_area_struct **vma)
 {
 	unsigned long lock_limit;
 	size_t got;
@@ -136,7 +136,7 @@ int qib_get_user_pages(unsigned long sta
 
 	down_write(&current->mm->mmap_sem);
 
-	ret = __get_user_pages(start_page, num_pages, p, NULL);
+	ret = __qib_get_user_pages(start_page, num_pages, p, NULL);
 
 	up_write(&current->mm->mmap_sem);
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -965,6 +965,10 @@ static inline int handle_mm_fault(struct
 extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, unsigned int foll_flags,
+		     struct page **pages, struct vm_area_struct **vmas,
+		     int *nonblocking);
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			unsigned long start, int nr_pages, int write, int force,
 			struct page **pages, struct vm_area_struct **vmas);
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -245,11 +245,6 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
-int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int len, unsigned int foll_flags,
-		     struct page **pages, struct vm_area_struct **vmas,
-		     int *nonblocking);
-
 #define ZONE_RECLAIM_NOSCAN	-2
 #define ZONE_RECLAIM_FULL	-1
 #define ZONE_RECLAIM_SOME	0
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1410,6 +1410,55 @@ no_page_table:
 	return page;
 }
 
+/**
+ * __get_user_pages() - pin user pages in memory
+ * @tsk:	task_struct of target task
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @gup_flags:	flags modifying pin behaviour
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ * @nonblocking: whether waiting for disk IO or mmap_sem contention
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno. Each page returned must be released
+ * with a put_page() call when it is finished with. vmas will only
+ * remain valid while mmap_sem is held.
+ *
+ * Must be called with mmap_sem held for read or write.
+ *
+ * __get_user_pages walks a process's page tables and takes a reference to
+ * each struct page that each user address corresponds to at a given
+ * instant. That is, it takes the page that would be accessed if a user
+ * thread accesses the given user virtual address at that instant.
+ *
+ * This does not guarantee that the page exists in the user mappings when
+ * __get_user_pages returns, and there may even be a completely different
+ * page there in some cases (eg. if mmapped pagecache has been invalidated
+ * and subsequently re faulted). However it does guarantee that the page
+ * won't be freed completely. And mostly callers simply care that the page
+ * contains data that was valid *at some point in time*. Typically, an IO
+ * or similar operation cannot guarantee anything stronger anyway because
+ * locks can't be held over the syscall boundary.
+ *
+ * If @gup_flags & FOLL_WRITE == 0, the page must not be written to. If
+ * the page is written to, set_page_dirty (or set_page_dirty_lock, as
+ * appropriate) must be called after the page is finished with, and
+ * before put_page is called.
+ *
+ * If @nonblocking != NULL, __get_user_pages will not wait for disk IO
+ * or mmap_sem contention, and if waiting is needed to pin all pages,
+ * *@nonblocking will be set to 0.
+ *
+ * In most cases, get_user_pages or get_user_pages_fast should be used
+ * instead of __get_user_pages. __get_user_pages should be used only if
+ * you need some special @gup_flags.
+ */
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, unsigned int gup_flags,
 		     struct page **pages, struct vm_area_struct **vmas,
@@ -1578,6 +1627,7 @@ int __get_user_pages(struct task_struct
 	} while (nr_pages);
 	return i;
 }
+EXPORT_SYMBOL(__get_user_pages);
 
 /**
  * get_user_pages() - pin user pages in memory
