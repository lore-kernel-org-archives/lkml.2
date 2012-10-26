Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2JZNDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:03:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:28594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab2JZNDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:03:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="238756763"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: linux-mm@kvack.org
Cc: Will Deacon <will.deacon@arm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] numa, mm: consolidate error path in do_huge_pmd_numa_page()
Date: Fri, 26 Oct 2012 15:54:35 +0300
Message-Id: <1351256077-1594-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Let's move all error path code to the end if the function. It makes code
more straight-forward.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9bb2c23..95ec485 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -759,30 +759,14 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto unlock;
 
 	page = pmd_page(entry);
-	if (page) {
-		VM_BUG_ON(!PageCompound(page) || !PageHead(page));
-
-		get_page(page);
-		node = mpol_misplaced(page, vma, haddr);
-		if (node != -1)
-			goto migrate;
-	}
-
-fixup:
-	/* change back to regular protection */
-	entry = pmd_modify(entry, vma->vm_page_prot);
-	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
-
-unlock:
-	spin_unlock(&mm->page_table_lock);
-	if (page) {
-		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
-		put_page(page);
-	}
-	return;
+	if (!page)
+		goto fixup;
+	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
 
-migrate:
+	get_page(page);
+	node = mpol_misplaced(page, vma, haddr);
+	if (node == -1)
+		goto fixup;
 	spin_unlock(&mm->page_table_lock);
 
 	lock_page(page);
@@ -871,7 +855,19 @@ alloc_fail:
 		page = NULL;
 		goto unlock;
 	}
-	goto fixup;
+fixup:
+	/* change back to regular protection */
+	entry = pmd_modify(entry, vma->vm_page_prot);
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, address, entry);
+
+unlock:
+	spin_unlock(&mm->page_table_lock);
+	if (page) {
+		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
+		put_page(page);
+	}
+	return;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-- 
1.7.10.4

