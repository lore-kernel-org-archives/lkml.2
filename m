Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1AUGdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:33:21 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53073 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1AUGdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:33:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <tatsu@ab.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH 1/7] hugetlb: check swap entry in follow_hugetlb_page()
Date: Fri, 21 Jan 2011 15:28:54 +0900
Message-Id: <1295591340-1862-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM host calls follow_hugetlb_page() in HVA-PFN translation
(through get_user_pages(),) so we need to have it handle swap
entry to detect HWPOISONed or migrating hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/hugetlb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git v2.6.38-rc1/mm/hugetlb.c v2.6.38-rc1/mm/hugetlb.c
index bb0b7c1..97c7471 100644
--- v2.6.38-rc1/mm/hugetlb.c
+++ v2.6.38-rc1/mm/hugetlb.c
@@ -2731,6 +2731,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
 		int absent;
+		int swap;
 		struct page *page;
 
 		/*
@@ -2740,6 +2741,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
 		absent = !pte || huge_pte_none(huge_ptep_get(pte));
+		swap = !absent && !pte_present(*pte);
 
 		/*
 		 * When coredumping, it suits get_dump_page if we just return
@@ -2754,7 +2756,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			break;
 		}
 
-		if (absent ||
+		if (absent || swap ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
-- 
1.7.3.4

