Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2JBPUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:20:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:27377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab2JBPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:19:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="229573193"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 09/10] thp: lazy huge zero page allocation
Date: Tue,  2 Oct 2012 18:19:31 +0300
Message-Id: <1349191172-28855-10-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Instead of allocating huge zero page on hugepage_init() we can postpone it
until first huge zero page map. It saves memory if THP is not in use.

cmpxchg() is used to avoid race on huge_zero_pfn initialization.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a5b9282..3fdf1b4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -168,22 +168,24 @@ out:
 	return err;
 }
 
-static int init_huge_zero_page(void)
+static int init_huge_zero_pfn(void)
 {
 	struct page *hpage;
+	unsigned long pfn;
 
 	hpage = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!hpage)
 		return -ENOMEM;
-
-	huge_zero_pfn = page_to_pfn(hpage);
+	pfn = page_to_pfn(hpage);
+	if (cmpxchg(&huge_zero_pfn, 0, pfn))
+		__free_page(hpage);
 	return 0;
 }
 
 static inline bool is_huge_zero_pfn(unsigned long pfn)
 {
-	return pfn == huge_zero_pfn;
+	return huge_zero_pfn && pfn == huge_zero_pfn;
 }
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
@@ -574,10 +576,6 @@ static int __init hugepage_init(void)
 	if (err)
 		return err;
 
-	err = init_huge_zero_page();
-	if (err)
-		goto out;
-
 	err = khugepaged_slab_init();
 	if (err)
 		goto out;
@@ -602,8 +600,6 @@ static int __init hugepage_init(void)
 
 	return 0;
 out:
-	if (huge_zero_pfn)
-		__free_page(pfn_to_page(huge_zero_pfn));
 	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
@@ -753,6 +749,10 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			return VM_FAULT_OOM;
 		if (!(flags & FAULT_FLAG_WRITE)) {
 			pgtable_t pgtable;
+			if (unlikely(!huge_zero_pfn && init_huge_zero_pfn())) {
+				count_vm_event(THP_FAULT_FALLBACK);
+				goto out;
+			}
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				goto out;
-- 
1.7.7.6

