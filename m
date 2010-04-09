Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0DII6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:58:10 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:46295 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0DII6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:58:05 -0400
Date: Fri, 9 Apr 2010 10:58:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
Message-ID: <20100409105800.0d0f93ac@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100408191737.296180458@chello.nl>
References: <20100408191737.296180458@chello.nl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, 08 Apr 2010 21:17:37 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The side-effects are that we can finally make mmu_gather preemptible, something
> which lots of people have wanted to do for a long time.

Yes, that is a good thing. With the preemptible mmu_gather s390 will
use less IDTEs (that is the instruction that flushes all TLBs for a
given address space) on a full flush. Good :-)

> This patch-set seems to build and boot on my x86_64 machines and even builds a
> kernel. I've also attempted powerpc and sparc, which I've compile tested with
> their respective defconfigs, remaining are (afaikt the rest uses the generic
> tlb bits):
> 
>  - s390
>  - ia64
>  - arm
>  - superh
>  - um
> 
> From those, s390 and ia64 look 'interesting', arm and superh seem very similar
> and should be relatively easy (-rt has a patchlet for arm iirc).

To get the 'interesting' TLB flushing on s390 working again you need
this patch:

--
[PATCH] s390: preemptible mmu_gather

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Adapt the stand-alone s390 mmu_gather implementation to the new
preemptible mmu_gather interface.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/tlb.h |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -28,45 +28,51 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-#ifndef CONFIG_SMP
-#define TLB_NR_PTRS	1
-#else
-#define TLB_NR_PTRS	508
-#endif
-
 struct mmu_gather {
 	struct mm_struct *mm;
 	unsigned int fullmm;
 	unsigned int nr_ptes;
 	unsigned int nr_pxds;
-	void *array[TLB_NR_PTRS];
+	unsigned int max;
+	void **array;
+	void *local[8];
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
-static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
-						unsigned int full_mm_flush)
+static inline void __tlb_alloc_pages(struct mmu_gather *tlb)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+	unsigned long addr = __get_free_pages(GFP_ATOMIC, 0);
+
+	if (addr) {
+		tlb->array = (void *) addr;
+		tlb->max = PAGE_SIZE / sizeof(void *);
+	}
+}
 
+static inline void tlb_gather_mmu(struct mmu_gather *tlb,
+				  struct mm_struct *mm,
+				  unsigned int full_mm_flush)
+{
 	tlb->mm = mm;
+	tlb->max = ARRAY_SIZE(tlb->local);
+	tlb->array = tlb->local;
 	tlb->fullmm = full_mm_flush || (num_online_cpus() == 1) ||
 		(atomic_read(&mm->mm_users) <= 1 && mm == current->active_mm);
-	tlb->nr_ptes = 0;
-	tlb->nr_pxds = TLB_NR_PTRS;
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
-	return tlb;
+	else
+		__tlb_alloc_pages(tlb);
+	tlb->nr_ptes = 0;
+	tlb->nr_pxds = tlb->max;
 }
 
 static inline void tlb_flush_mmu(struct mmu_gather *tlb,
 				 unsigned long start, unsigned long end)
 {
-	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < TLB_NR_PTRS))
+	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < tlb->max))
 		__tlb_flush_mm(tlb->mm);
 	while (tlb->nr_ptes > 0)
 		pte_free(tlb->mm, tlb->array[--tlb->nr_ptes]);
-	while (tlb->nr_pxds < TLB_NR_PTRS)
+	while (tlb->nr_pxds < tlb->max)
 		/* pgd_free frees the pointer as region or segment table */
 		pgd_free(tlb->mm, tlb->array[tlb->nr_pxds++]);
 }
@@ -79,7 +85,8 @@ static inline void tlb_finish_mmu(struct
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	put_cpu_var(mmu_gathers);
+	if (tlb->array != tlb->local)
+		free_pages((unsigned long) tlb->array, 0);
 }
 
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

