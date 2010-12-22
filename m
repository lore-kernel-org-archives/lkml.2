Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0LVCws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 21:52:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:52614 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0LVCwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 21:52:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,210,1291622400"; 
   d="scan'208";a="639093797"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 1/3] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
Date: Wed, 22 Dec 2010 10:51:55 +0800
Message-Id: <1292986317-2805-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
References: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make __get_user_pages return -EHWPOISON for HWPOISON page only if
FOLL_HWPOISON is specified.  With this patch, the interested callers
can distinguish HWPOISON page from general FAULT page, while other
callers will still get -EFAULT for pages, so the user space interface
need not to be changed.

get_user_pages_hwpoison is added as a variant of get_user_pages that
can return -EHWPOISON for HWPOISON page.

This feature is needed by KVM, where UCR MCE should be relayed to
guest for HWPOISON page, while instruction emulation and MMIO will be
tried for general FAULT page.

The idea comes from Andrew Morton.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/errno.h |    2 +
 include/linux/mm.h          |    5 ++++
 mm/memory.c                 |   53 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 57 insertions(+), 3 deletions(-)

--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -108,4 +108,6 @@
 
 #define ERFKILL		132	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	133	/* Memory page has hardware error */
+
 #endif
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -860,6 +860,10 @@ int get_user_pages(struct task_struct *t
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long start, int nr_pages, int write,
+			    int force, struct page **pages,
+			    struct vm_area_struct **vmas);
 struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
@@ -1415,6 +1419,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_HWPOISON	0x20	/* check page is hwpoisoned */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1449,9 +1449,16 @@ int __get_user_pages(struct task_struct
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
 						return i ? i : -ENOMEM;
-					if (ret &
-					    (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE|
-					     VM_FAULT_SIGBUS))
+					if (ret & (VM_FAULT_HWPOISON |
+						   VM_FAULT_HWPOISON_LARGE)) {
+						if (i)
+							return i;
+						else if (gup_flags & FOLL_HWPOISON)
+							return -EHWPOISON;
+						else
+							return -EFAULT;
+					}
+					if (ret & VM_FAULT_SIGBUS)
 						return i ? i : -EFAULT;
 					BUG();
 				}
@@ -1564,6 +1571,46 @@ int get_user_pages(struct task_struct *t
 EXPORT_SYMBOL(get_user_pages);
 
 /**
+ * get_user_pages_hwpoison() - pin user pages in memory, return hwpoison status
+ * @tsk:	task_struct of target task
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to by the caller
+ * @force:	whether to force write access even if user mapping is
+ *		readonly. This will result in the page being COWed even
+ *		in MAP_SHARED mappings. You do not want this.
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ *
+ * Returns number of pages pinned.
+ *
+ * If the page table or memory page is hwpoisoned, return -EHWPOISON.
+ *
+ * Otherwise, same as get_user_pages.
+ */
+int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long start, int nr_pages, int write,
+			    int force, struct page **pages,
+			    struct vm_area_struct **vmas)
+{
+	int flags = FOLL_TOUCH | FOLL_HWPOISON;
+
+	if (pages)
+		flags |= FOLL_GET;
+	if (write)
+		flags |= FOLL_WRITE;
+	if (force)
+		flags |= FOLL_FORCE;
+
+	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
+}
+EXPORT_SYMBOL(get_user_pages_hwpoison);
+
+/**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
  *
