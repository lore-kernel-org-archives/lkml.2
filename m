Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2JBPVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:21:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:26688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab2JBPS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:18:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="199642353"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 03/10] thp: copy_huge_pmd(): copy huge zero page
Date: Tue,  2 Oct 2012 18:19:25 +0300
Message-Id: <1349191172-28855-4-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

It's easy to copy huge zero page. Just set destination pmd to huge zero
page.

It's safe to copy huge zero page since we have none yet :-p

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 140d858..c8b157d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -726,6 +726,18 @@ static inline struct page *alloc_hugepage(int defrag)
 }
 #endif
 
+static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd)
+{
+	pmd_t entry;
+	entry = pfn_pmd(huge_zero_pfn, vma->vm_page_prot);
+	entry = pmd_wrprotect(entry);
+	entry = pmd_mkhuge(entry);
+	set_pmd_at(mm, haddr, pmd, entry);
+	prepare_pmd_huge_pte(pgtable, mm);
+	mm->nr_ptes++;
+}
+
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       unsigned int flags)
@@ -803,6 +815,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
+	if (is_huge_zero_pmd(pmd)) {
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
+		ret = 0;
+		goto out_unlock;
+	}
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(&src_mm->page_table_lock);
-- 
1.7.7.6

