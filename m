Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1CGRtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:49:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:56370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab1CGRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:17 -0500
Message-Id: <20110307172206.831489809@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:13:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][PATCH 05/15] mm, tile: Change flush_tlb_range() VM_HUGETLB semantics
References: <20110307171350.989666626@chello.nl>
Content-Disposition: inline; filename=tile-flush_tlb_range-hugetlb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we're going to provide a fake VMA covering a large range, we
need to change the VM_HUGETLB semantic to mean _also_ wipe HPAGE TLBs.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/tile/kernel/tlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/tile/kernel/tlb.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/tlb.c
+++ linux-2.6/arch/tile/kernel/tlb.c
@@ -67,11 +67,14 @@ EXPORT_SYMBOL(flush_tlb_page);
 void flush_tlb_range(const struct vm_area_struct *vma,
 		     unsigned long start, unsigned long end)
 {
-	unsigned long size = hv_page_size(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-	flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start, size,
-		     &mm->cpu_vm_mask, NULL, 0);
+	flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start,
+			PAGE_SIZE, &mm->cpu_vm_mask, NULL, 0);
+	if (vma->vm_flags & VM_HUGETLB) {
+		flush_remote(0, 0, &mm->cpu_vm_mask, start, end - start,
+				HPAGE_SIZE, &mm->cpu_vm_mask, NULL, 0);
+	}
 }
 
 void flush_tlb_all(void)


