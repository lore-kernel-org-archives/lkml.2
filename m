Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2LEVr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2LEVr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:47:56 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 2/3] HWPOISON, hugetlbfs: fix "bad pmd" warning in unmapping hwpoisoned hugepage
Date: Wed,  5 Dec 2012 16:47:37 -0500
Message-Id: <1354744058-26373-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process which used a hwpoisoned hugepage tries to exit() or
munmap(), the kernel can print out "bad pmd" message because page
table walker in free_pgtables() encounters 'hwpoisoned entry' on pmd.

This is because currently we fail to clear the hwpoisoned entry in
__unmap_hugepage_range(), so this patch simply does it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git v3.7-rc8.orig/mm/hugetlb.c v3.7-rc8/mm/hugetlb.c
index e61a749..fe7c2a7 100644
--- v3.7-rc8.orig/mm/hugetlb.c
+++ v3.7-rc8/mm/hugetlb.c
@@ -2387,8 +2387,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		/*
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+			pte_clear(mm, address, ptep);
 			continue;
+		}
 
 		page = pte_page(pte);
 		/*
-- 
1.7.11.7

