Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768824Ab2KOT0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:26:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:5568 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423678Ab2KOTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:25:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,259,1352102400"; 
   d="scan'208";a="168868135"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v6 03/12] thp: copy_huge_pmd(): copy huge zero page
Date: Thu, 15 Nov 2012 21:26:53 +0200
Message-Id: <1353007622-18393-4-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353007622-18393-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1353007622-18393-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

It's easy to copy huge zero page. Just set destination pmd to huge zero
page.

It's safe to copy huge zero page since we have none yet :-p

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fc2cada..183127c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -701,6 +701,18 @@ static inline struct page *alloc_hugepage(int defrag)
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
+	pgtable_trans_huge_deposit(mm, pgtable);
+	mm->nr_ptes++;
+}
+
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       unsigned int flags)
@@ -778,6 +790,16 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
+	/*
+	 * mm->pagetable lock is enough to be sure that huge zero pmd is not
+	 * under splitting since we don't split the page itself, only pmd to
+	 * a page table.
+	 */
+	if (is_huge_zero_pmd(pmd)) {
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
+		ret = 0;
+		goto out_unlock;
+	}
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(&src_mm->page_table_lock);
-- 
1.7.11.7

