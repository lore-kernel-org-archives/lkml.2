Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2BJXFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:05:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2BJWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:42 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.899105629@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [patch 66/86] mm: fix UP THP spin_is_locked BUGs
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit b9980cdcf2524c5fe15d8cbae9c97b3ed6385563 upstream.

Fix CONFIG_TRANSPARENT_HUGEPAGE=y CONFIG_SMP=n CONFIG_DEBUG_VM=y
CONFIG_DEBUG_SPINLOCK=n kernel: spin_is_locked() is then always false,
and so triggers some BUGs in Transparent HugePage codepaths.

asm-generic/bug.h mentions this problem, and provides a WARN_ON_SMP(x);
but being too lazy to add VM_BUG_ON_SMP, BUG_ON_SMP, WARN_ON_SMP_ONCE,
VM_WARN_ON_SMP_ONCE, just test NR_CPUS != 1 in the existing VM_BUG_ONs.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    4 ++--
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2064,7 +2064,7 @@ static void collect_mm_slot(struct mm_sl
 {
 	struct mm_struct *mm = mm_slot->mm;
 
-	VM_BUG_ON(!spin_is_locked(&khugepaged_mm_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
@@ -2094,7 +2094,7 @@ static unsigned int khugepaged_scan_mm_s
 	int progress = 0;
 
 	VM_BUG_ON(!pages);
-	VM_BUG_ON(!spin_is_locked(&khugepaged_mm_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
 
 	if (khugepaged_scan.mm_slot)
 		mm_slot = khugepaged_scan.mm_slot;
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -667,7 +667,7 @@ void lru_add_page_tail(struct zone* zone
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(!spin_is_locked(&zone->lru_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
 
 	SetPageLRU(page_tail);
 


