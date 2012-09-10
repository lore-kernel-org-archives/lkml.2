Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2IJNN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:13:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:63889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab2IJNNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="143329103"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v2 08/10] thp: setup huge zero page on non-write page fault
Date: Mon, 10 Sep 2012 16:13:31 +0300
Message-Id: <1347282813-21935-9-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

All code paths seems covered. Now we can map huge zero page on read page
fault.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 995894f..c788445 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -750,6 +750,16 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			return VM_FAULT_OOM;
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
+		if (!(flags & FAULT_FLAG_WRITE)) {
+			pgtable_t pgtable;
+			pgtable = pte_alloc_one(mm, haddr);
+			if (unlikely(!pgtable))
+				goto out;
+			spin_lock(&mm->page_table_lock);
+			set_huge_zero_page(pgtable, mm, vma, haddr, pmd);
+			spin_unlock(&mm->page_table_lock);
+			return 0;
+		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
 		if (unlikely(!page)) {
-- 
1.7.7.6

