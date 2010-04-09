Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0DIUgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:36:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0DIUgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:36:33 -0400
Subject: Re: [PATCH 06/13] mm: Preemptible mmu_gather
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409032509.GH5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.858079986@chello.nl>  <20100409032509.GH5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 22:36:24 +0200
Message-ID: <1270845384.20295.3369.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 13:25 +1000, Nick Piggin wrote:
> Have you done some profiling on this? What I would like to see, if
> it's not too much complexity, is to have a small set of pages to
> handle common size frees, and then use them up first by default
> before attempting to allocate more.
> 
> Also, it would be cool to be able to chain allocations to avoid
> TLB flushes even on big frees (overridable by arch of course, in
> case they're doing some non-preeemptible work or you wish to break
> up lock hold times). But that might be just getting over engineered.
> 
Measuring ITLB_FLUSH on Intel nehalem using:

perf stat -a -e r01ae make O=defconfig-build/ -j48 bzImage

-linus      5825850 +- 2545  (100%)
 +patches   5891341 +- 6045  (101%)
 +below     5783991 +- 4725  ( 99%)

(No slab allocations yet)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/tlb.h |  122 ++++++++++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 40 deletions(-)

Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h
+++ linux-2.6/include/asm-generic/tlb.h
@@ -17,16 +17,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
-/*
- * For UP we don't need to worry about TLB flush
- * and page free order so much..
- */
-#ifdef CONFIG_SMP
-  #define tlb_fast_mode(tlb) ((tlb)->nr == ~0U)
-#else
-  #define tlb_fast_mode(tlb) 1
-#endif
-
 #ifdef HAVE_ARCH_RCU_TABLE_FREE
 /*
  * Semi RCU freeing of the page directories.
@@ -70,31 +60,66 @@ extern void tlb_remove_table(struct mmu_
 
 #endif
 
+struct mmu_gather_batch {
+	struct mmu_gather_batch	*next;
+	unsigned int		nr;
+	unsigned int		max;
+	struct page		*pages[0];
+};
+
+#define MAX_GATHER_BATCH	\
+	((PAGE_SIZE - sizeof(struct mmu_gather_batch)) / sizeof(unsigned long))
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
 struct mmu_gather {
 	struct mm_struct	*mm;
-	unsigned int		nr;	/* set to ~0U means fast mode */
-	unsigned int		max;	/* nr < max */
-	unsigned int		need_flush;/* Really unmapped some ptes? */
-	unsigned int		fullmm; /* non-zero means full mm flush */
-	struct page		**pages;
-	struct page		*local[8];
+	unsigned int		need_flush : 1,	/* Did free PTEs */
+				fast_mode  : 1; /* No batching   */
+	unsigned int		fullmm;		/* Flush full mm */
+
+	struct mmu_gather_batch *active;
+	struct mmu_gather_batch	local;
+	struct page		*__pages[8];
 
 #ifdef HAVE_ARCH_RCU_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
 };
 
-static inline void __tlb_alloc_pages(struct mmu_gather *tlb)
+/*
+ * For UP we don't need to worry about TLB flush
+ * and page free order so much..
+ */
+#ifdef CONFIG_SMP
+  #define tlb_fast_mode(tlb) (tlb->fast_mode)
+#else
+  #define tlb_fast_mode(tlb) 1
+#endif
+
+static inline int tlb_next_batch(struct mmu_gather *tlb)
 {
-	unsigned long addr = __get_free_pages(GFP_ATOMIC, 0);
+	struct mmu_gather_batch *batch;
 
-	if (addr) {
-		tlb->pages = (void *)addr;
-		tlb->max = PAGE_SIZE / sizeof(struct page *);
+	batch = tlb->active;
+	if (batch->next) {
+		tlb->active = batch->next;
+		return 1;
 	}
+
+	batch = (void *)__get_free_pages(GFP_ATOMIC, 0);
+	if (!batch)
+		return 0;
+
+	batch->next = NULL;
+	batch->nr   = 0;
+	batch->max  = MAX_GATHER_BATCH;
+
+	tlb->active->next = batch;
+	tlb->active = batch;
+
+	return 1;
 }
 
 /* tlb_gather_mmu
@@ -105,17 +130,16 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 {
 	tlb->mm = mm;
 
-	tlb->max = ARRAY_SIZE(tlb->local);
-	tlb->pages = tlb->local;
-
-	if (num_online_cpus() > 1) {
-		tlb->nr = 0;
-		__tlb_alloc_pages(tlb);
-	} else /* Use fast mode if only one CPU is online */
-		tlb->nr = ~0U;
-
+	tlb->need_flush = 0;
+	if (num_online_cpus() == 1)
+		tlb->fast_mode = 1;
 	tlb->fullmm = full_mm_flush;
 
+	tlb->local.next = NULL;
+	tlb->local.nr   = 0;
+	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
+	tlb->active     = &tlb->local;
+
 #ifdef HAVE_ARCH_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
@@ -124,6 +148,8 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 static inline void
 tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+	struct mmu_gather_batch *batch;
+
 	if (!tlb->need_flush)
 		return;
 	tlb->need_flush = 0;
@@ -131,12 +157,14 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 #ifdef HAVE_ARCH_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
-	if (!tlb_fast_mode(tlb)) {
-		free_pages_and_swap_cache(tlb->pages, tlb->nr);
-		tlb->nr = 0;
-		if (tlb->pages == tlb->local)
-			__tlb_alloc_pages(tlb);
+	if (tlb_fast_mode(tlb))
+		return;
+
+	for (batch = &tlb->local; batch; batch = batch->next) {
+		free_pages_and_swap_cache(batch->pages, batch->nr);
+		batch->nr = 0;
 	}
+	tlb->active = &tlb->local;
 }
 
 /* tlb_finish_mmu
@@ -146,13 +174,18 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+	struct mmu_gather_batch *batch, *next;
+
 	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
-	if (tlb->pages != tlb->local)
-		free_pages((unsigned long)tlb->pages, 0);
+	for (batch = tlb->local.next; batch; batch = next) {
+		next = batch->next;
+		free_pages((unsigned long)batch, 0);
+	}
+	tlb->local.next = NULL;
 }
 
 /* tlb_remove_page
@@ -162,14 +195,23 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
  */
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
+	struct mmu_gather_batch *batch;
+
 	tlb->need_flush = 1;
+
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
 		return;
 	}
-	tlb->pages[tlb->nr++] = page;
-	if (tlb->nr >= tlb->max)
-		tlb_flush_mmu(tlb, 0, 0);
+
+	batch = tlb->active;
+	if (batch->nr == batch->max) {
+		if (!tlb_next_batch(tlb))
+			tlb_flush_mmu(tlb, 0, 0);
+		batch = tlb->active;
+	}
+
+	batch->pages[batch->nr++] = page;
 }
 
 /**


