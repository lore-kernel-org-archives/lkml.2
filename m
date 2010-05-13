Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0EMH6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:58:42 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64691 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab0EMH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:57:27 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: n-horiguchi@ah.jp.nec.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 6/7] HWPOISON, hugetlb: detect hwpoison in hugetlb code
Date: Thu, 13 May 2010 16:55:25 +0900
Message-Id: <1273737326-21211-7-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to block access to hwpoisoned hugepage and
also enables to block unmapping for it.

Dependency:
  "HWPOISON, hugetlb: enable error handling path for hugepage"

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/hugetlb.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git v2.6.34-rc7/mm/hugetlb.c v2.6.34-rc7/mm/hugetlb.c
index 3c1232f..8bddaf0 100644
--- v2.6.34-rc7/mm/hugetlb.c
+++ v2.6.34-rc7/mm/hugetlb.c
@@ -19,6 +19,8 @@
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/rmap.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -2138,6 +2140,19 @@ nomem:
 	return -ENOMEM;
 }
 
+static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+{
+	swp_entry_t swp;
+
+	if (huge_pte_none(pte) || pte_present(pte))
+		return 0;
+	swp = pte_to_swp_entry(pte);
+	if (non_swap_entry(swp) && is_hwpoison_entry(swp)) {
+		return 1;
+	} else
+		return 0;
+}
+
 void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, struct page *ref_page)
 {
@@ -2196,6 +2211,12 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 		if (huge_pte_none(pte))
 			continue;
 
+		/*
+		 * HWPoisoned hugepage is already unmapped and dropped reference
+		 */
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+			continue;
+
 		page = pte_page(pte);
 		if (pte_dirty(pte))
 			set_page_dirty(page);
@@ -2488,6 +2509,18 @@ retry:
 	}
 
 	/*
+	 * Since memory error handler replaces pte into hwpoison swap entry
+	 * at the time of error handling, a process which reserved but not have
+	 * the mapping to the error hugepage does not have hwpoison swap entry.
+	 * So we need to block accesses from such a process by checking
+	 * PG_hwpoison bit here.
+	 */
+	if (unlikely(PageHWPoison(page))) {
+		ret = VM_FAULT_HWPOISON;
+		goto backout_unlocked;
+	}
+
+	/*
 	 * If we are going to COW a private mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that
 	 * any allocations necessary to record that reservation occur outside
@@ -2547,6 +2580,13 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
+	ptep = huge_pte_offset(mm, address);
+	if (ptep) {
+		entry = huge_ptep_get(ptep);
+		if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
+			return VM_FAULT_HWPOISON;
+	}
+
 	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
 	if (!ptep)
 		return VM_FAULT_OOM;
-- 
1.7.0

