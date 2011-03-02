Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1CBSGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:06:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:35095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab1CBSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:05:59 -0500
Message-Id: <20110302180258.879537727@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:59:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
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
Subject: [RFC][PATCH 1/6] mm: Optimize fullmm TLB flushing
References: <20110302175928.022902359@chello.nl>
Content-Disposition: inline; filename=mmu_gather_fullmm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This originated from s390 which does something similar and would allow
s390 to use the generic TLB flushing code.

The idea is to flush the mm wide cache and tlb a priory and not bother
with multiple flushes if the batching isn't large enough.

This can be safely done since there cannot be any concurrency on this
mm, its either after the process died (exit) or in the middle of
execve where the thread switched to the new mm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/tlb.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h
+++ linux-2.6/include/asm-generic/tlb.h
@@ -149,6 +149,11 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
+
+	if (fullmm) {
+		flush_cache_mm(mm);
+		flush_tlb_mm(mm);
+	}
 }
 
 static inline void
@@ -156,13 +161,15 @@ tlb_flush_mmu(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
 
-	if (!tlb->need_flush)
-		return;
-	tlb->need_flush = 0;
-	tlb_flush(tlb);
+	if (!tlb->fullmm && tlb->need_flush) {
+		tlb->need_flush = 0;
+		tlb_flush(tlb);
+	}
+
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
+
 	if (tlb_fast_mode(tlb))
 		return;
 


