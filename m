Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2KGPBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:01:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:35374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab2KGPAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:00:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="243663135"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v5 08/11] thp: setup huge zero page on non-write page fault
Date: Wed,  7 Nov 2012 17:01:00 +0200
Message-Id: <1352300463-12627-9-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

All code paths seems covered. Now we can map huge zero page on read page
fault.

We setup it in do_huge_pmd_anonymous_page() if area around fault address
is suitable for THP and we've got read page fault.

If we fail to setup huge zero page (ENOMEM) we fallback to
handle_pte_fault() as we normally do in THP.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f36bc7d..41f05f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -726,6 +726,16 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
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

