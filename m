Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2CPTBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:01:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:20115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab2CPTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118439714"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, aarcange@redhat.com
Subject: [PATCH 06/11] huge-memory: Use lockdep_assert_held
Date: Fri, 16 Mar 2012 12:00:59 -0700
Message-Id: <1331924464-18023-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use lockdep_assert_held to check for locks instead of an opencoded
variant.

Cc: aarcange@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/huge_memory.c |    4 ++--
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 91d3efb..28669c6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2083,7 +2083,7 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
 {
 	struct mm_struct *mm = mm_slot->mm;
 
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
+	lockdep_assert_held(&khugepaged_mm_lock);
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
@@ -2113,7 +2113,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 	int progress = 0;
 
 	VM_BUG_ON(!pages);
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
+	lockdep_assert_held(&khugepaged_mm_lock);
 
 	if (khugepaged_scan.mm_slot)
 		mm_slot = khugepaged_scan.mm_slot;
diff --git a/mm/swap.c b/mm/swap.c
index fff1ff7..811e615 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -659,7 +659,7 @@ void lru_add_page_tail(struct zone* zone,
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
+	lockdep_assert_held(&zone->lru_lock);
 
 	SetPageLRU(page_tail);
 
-- 
1.7.7.6

