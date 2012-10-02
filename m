Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2JBPTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:19:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:27377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2JBPS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:18:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="229573160"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 02/10] thp: zap_huge_pmd(): zap huge zero pmd
Date: Tue,  2 Oct 2012 18:19:24 +0300
Message-Id: <1349191172-28855-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We don't have a real page to zap in huge zero page case. Let's just
clear pmd and remove it from tlb.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 50c44e9..140d858 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1072,16 +1072,23 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct page *page;
 		pgtable_t pgtable;
 		pgtable = get_pmd_huge_pte(tlb->mm);
-		page = pmd_page(*pmd);
-		pmd_clear(pmd);
-		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-		page_remove_rmap(page);
-		VM_BUG_ON(page_mapcount(page) < 0);
-		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-		VM_BUG_ON(!PageHead(page));
-		tlb->mm->nr_ptes--;
-		spin_unlock(&tlb->mm->page_table_lock);
-		tlb_remove_page(tlb, page);
+		if (is_huge_zero_pmd(*pmd)) {
+			pmd_clear(pmd);
+			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+			tlb->mm->nr_ptes--;
+			spin_unlock(&tlb->mm->page_table_lock);
+		} else {
+			page = pmd_page(*pmd);
+			pmd_clear(pmd);
+			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+			page_remove_rmap(page);
+			VM_BUG_ON(page_mapcount(page) < 0);
+			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+			VM_BUG_ON(!PageHead(page));
+			tlb->mm->nr_ptes--;
+			spin_unlock(&tlb->mm->page_table_lock);
+			tlb_remove_page(tlb, page);
+		}
 		pte_free(tlb->mm, pgtable);
 		ret = 1;
 	}
-- 
1.7.7.6

