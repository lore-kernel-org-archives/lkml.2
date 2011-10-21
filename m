Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1JUMWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:22:21 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:22445
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab1JUMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:22:17 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LTF10Z-02-1UF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        <akpm@linux-foundation.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] mmu_notifier: Call invalidate_range_free_pages() notifier
Date: Fri, 21 Oct 2011 14:21:48 +0200
Message-ID: <1319199708-17777-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
References: <1319199708-17777-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary calls to the new notifier.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 mm/hugetlb.c |    1 +
 mm/memory.c  |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dae27ba..d08998d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2278,6 +2278,7 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 	}
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
+	mmu_notifier_invalidate_range_free_pages(mm);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	list_for_each_entry_safe(page, tmp, &page_list, lru) {
 		page_remove_rmap(page);
diff --git a/mm/memory.c b/mm/memory.c
index b31f9e0..a5cc335 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1207,6 +1207,7 @@ again:
 	 * and page-free while holding it.
 	 */
 	if (force_flush) {
+		mmu_notifier_invalidate_range_free_pages(mm);
 		force_flush = 0;
 		tlb_flush_mmu(tlb);
 		if (addr != end)
@@ -1359,6 +1360,16 @@ unsigned long unmap_vmas(struct mmu_gather *tlb,
 		}
 	}
 
+	/*
+	 * In theory it would be sufficient to do the final flush for the last
+	 * bunch of pages queued by mmu_gather in mn_invalidate_range_end().
+	 * But that would break the API definition because in the _end notifier
+	 * the called subsystem has to assume that the pages are alread freed.
+	 * So call mn_invalidate_range_free_pages() explicitly here for the
+	 * final bunch of pages.
+	 */
+	mmu_notifier_invalidate_range_free_pages(mm);
+
 	mmu_notifier_invalidate_range_end(mm, start_addr, end_addr);
 	return start;	/* which is now the end (or restart) address */
 }
-- 
1.7.5.4


