Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0DMBZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:25:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:40643 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab0DMBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:25:05 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100408192722.901224587@chello.nl>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 11:23:37 +1000
Message-ID: <1271121817.13059.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 21:17 +0200, Peter Zijlstra wrote:

 .../...

>  static inline void arch_leave_lazy_mmu_mode(void)
>  {
> -	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
> +	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
> +
> +	if (batch->active) {
> +		if (batch->index)
> +			__flush_tlb_pending(batch);
> +		batch->active = 0;
> +	}

Can index be > 0 if active == 0 ? I though not, which means you don't
need to add a test on active, do you ?

I'm also pondering whether we should just stick something in the
task/thread struct and avoid that whole per-cpu manipulation including
the stuff in process.c in fact.

Heh, maybe it's time to introduce thread vars ? :-)
 
> -	if (batch->index)
> -		__flush_tlb_pending(batch);
> -	batch->active = 0;
> +	put_cpu_var(ppc64_tlb_batch);
>  }
>  
>  #define arch_flush_lazy_mmu_mode()      do {} while (0)
> Index: linux-2.6/arch/powerpc/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/process.c
> +++ linux-2.6/arch/powerpc/kernel/process.c
> @@ -389,6 +389,9 @@ struct task_struct *__switch_to(struct t
>  	struct thread_struct *new_thread, *old_thread;
>  	unsigned long flags;
>  	struct task_struct *last;
> +#ifdef CONFIG_PPC64
> +	struct ppc64_tlb_batch *batch;
> +#endif

>  #ifdef CONFIG_SMP
>  	/* avoid complexity of lazy save/restore of fpu
> @@ -479,6 +482,14 @@ struct task_struct *__switch_to(struct t
>  		old_thread->accum_tb += (current_tb - start_tb);
>  		new_thread->start_tb = current_tb;
>  	}
> +
> +	batch = &__get_cpu_var(ppc64_tlb_batch);
> +	if (batch->active) {
> +		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU);
> +		if (batch->index)
> +			__flush_tlb_pending(batch);
> +		batch->active = 0;
> +	}
>  #endif

Use ti->local_flags so you can do it non-atomically, which is a lot
cheaper.

>  	local_irq_save(flags);
> @@ -495,6 +506,13 @@ struct task_struct *__switch_to(struct t
>  	hard_irq_disable();
>  	last = _switch(old_thread, new_thread);
>  
> +#ifdef CONFIG_PPC64
> +	if (test_and_clear_ti_thread_flag(task_thread_info(new), TIF_LAZY_MMU)) {
> +		batch = &__get_cpu_var(ppc64_tlb_batch);
> +		batch->active = 1;
> +	}
> +#endif
> +
>  	local_irq_restore(flags);
>  
>  	return last;
> Index: linux-2.6/arch/powerpc/mm/pgtable.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/pgtable.c
> +++ linux-2.6/arch/powerpc/mm/pgtable.c
> @@ -33,8 +33,6 @@
>  
>  #include "mmu_decl.h"
>  
> -DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> -
>  #ifdef CONFIG_SMP
>  
>  /*
> @@ -43,7 +41,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
>   * freeing a page table page that is being walked without locks
>   */
>  
> -static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
>  static unsigned long pte_freelist_forced_free;
>  
>  struct pte_freelist_batch
> @@ -98,12 +95,30 @@ static void pte_free_submit(struct pte_f
>  
>  void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
>  {
> -	/* This is safe since tlb_gather_mmu has disabled preemption */
> -	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
> +	struct pte_freelist_batch **batchp = &tlb->arch.batch;
>  	unsigned long pgf;
>  
> -	if (atomic_read(&tlb->mm->mm_users) < 2 ||
> -	    cpumask_equal(mm_cpumask(tlb->mm), cpumask_of(smp_processor_id()))){
> +	/*
> +	 * A comment here about on why we have RCU freed page tables might be
> +	 * interesting, also explaining why we don't need any sort of grace
> +	 * period for mm_users == 1, and have some home brewn smp_call_func()
> +	 * for single frees.

iirc, we are synchronizing with CPUs walking page tables in their hash
or TLB miss code, which is lockless. The mm_users test is a -little- bit
dubious indeed. It may have to be mm_users < 2 && mm ==
current->active_mm, ie, we know for sure nobody else is currently
walking those page tables ... 

Tho even than is fishy nowadays. We -can- walk page tables on behave of
another process. In fact, we do it in the Cell SPU code for faulting
page table entries as a result of SPEs taking faults for example. So I'm
starting to suspect that this mm_users optimisation is bogus.

We -do- want to optimize out the case where there is no user left
though, ie, the MM is dead. IE. The typical exit case.

> +	 *
> +	 * The only lockless page table walker I know of is gup_fast() which
> +	 * relies on irq_disable(). So my guess is that mm_users == 1 means
> +	 * that there cannot be another thread and so precludes gup_fast()
> +	 * concurrency.

Which is fishy as I said above.

> +	 * If there are, but we fail to batch, we need to IPI (all?) CPUs so as
> +	 * to serialize against the IRQ disable. In case we do batch, the RCU
> +	 * grace period is at least long enough to cover IRQ disabled sections
> +	 * (XXX assumption, not strictly true).

Yeah well ... I'm not that familiar with RCU anymore. Back when I wrote
that, iirc, I would more or less be safe against a CPU that doesn't
schedule, but things may have well changed.

We are trying to be safe against another CPU walking page tables in the
asm lockless hash miss or TLB miss code. Note that sparc64 has a similar
issue. This is highly optimized asm code that -cannot- call into things
like rcu_read_lock().

> +	 * All this results in us doing our own free batching and not using
> +	 * the generic mmu_gather batches (XXX fix that somehow?).
> +	 */

When this was written, generic batch only dealt with the actual pages,
not the page tables, and as you may have noticed, our page tables on
powerpc aren't struct page*, they come from dedicated slab caches and
are of variable sizes.

Cheers,
Ben.

> +	if (atomic_read(&tlb->mm->mm_users) < 2) {
>  		pgtable_free(table, shift);
>  		return;
>  	}
> @@ -125,10 +140,9 @@ void pgtable_free_tlb(struct mmu_gather 
>  	}
>  }
>  
> -void pte_free_finish(void)
> +void pte_free_finish(struct mmu_gather *tlb)
>  {
> -	/* This is safe since tlb_gather_mmu has disabled preemption */
> -	struct pte_freelist_batch **batchp = &__get_cpu_var(pte_freelist_cur);
> +	struct pte_freelist_batch **batchp = &tlb->arch.batch;
>  
>  	if (*batchp == NULL)
>  		return;
> Index: linux-2.6/arch/powerpc/mm/tlb_hash64.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/tlb_hash64.c
> +++ linux-2.6/arch/powerpc/mm/tlb_hash64.c
> @@ -38,13 +38,11 @@ DEFINE_PER_CPU(struct ppc64_tlb_batch, p
>   * neesd to be flushed. This function will either perform the flush
>   * immediately or will batch it up if the current CPU has an active
>   * batch on it.
> - *
> - * Must be called from within some kind of spinlock/non-preempt region...
>   */
>  void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
>  		     pte_t *ptep, unsigned long pte, int huge)
>  {
> -	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
> +	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
>  	unsigned long vsid, vaddr;
>  	unsigned int psize;
>  	int ssize;
> @@ -99,6 +97,7 @@ void hpte_need_flush(struct mm_struct *m
>  	 */
>  	if (!batch->active) {
>  		flush_hash_page(vaddr, rpte, psize, ssize, 0);
> +		put_cpu_var(ppc64_tlb_batch);
>  		return;
>  	}
>  
> @@ -127,6 +126,7 @@ void hpte_need_flush(struct mm_struct *m
>  	batch->index = ++i;
>  	if (i >= PPC64_TLB_BATCH_NR)
>  		__flush_tlb_pending(batch);
> +	put_cpu_var(ppc64_tlb_batch);
>  }
>  
>  /*
> @@ -155,7 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>  
>  void tlb_flush(struct mmu_gather *tlb)
>  {
> -	struct ppc64_tlb_batch *tlbbatch = &__get_cpu_var(ppc64_tlb_batch);
> +	struct ppc64_tlb_batch *tlbbatch = &get_cpu_var(ppc64_tlb_batch);
>  
>  	/* If there's a TLB batch pending, then we must flush it because the
>  	 * pages are going to be freed and we really don't want to have a CPU
> @@ -164,8 +164,10 @@ void tlb_flush(struct mmu_gather *tlb)
>  	if (tlbbatch->index)
>  		__flush_tlb_pending(tlbbatch);
>  
> +	put_cpu_var(ppc64_tlb_batch);
> +
>  	/* Push out batch of freed page tables */
> -	pte_free_finish();
> +	pte_free_finish(tlb);
>  }
>  
>  /**
> Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
> +++ linux-2.6/arch/powerpc/include/asm/thread_info.h
> @@ -111,6 +111,7 @@ static inline struct thread_info *curren
>  #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
>  #define TIF_FREEZE		14	/* Freezing for suspend */
>  #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
> +#define TIF_LAZY_MMU		16	/* tlb_batch is active */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -128,6 +129,7 @@ static inline struct thread_info *curren
>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
>  #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
> +#define _TIF_LAZY_MMU		(1<<TIF_LAZY_MMU)
>  #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
>  
>  #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
> Index: linux-2.6/arch/powerpc/include/asm/pgalloc.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/pgalloc.h
> +++ linux-2.6/arch/powerpc/include/asm/pgalloc.h
> @@ -32,13 +32,13 @@ static inline void pte_free(struct mm_st
>  
>  #ifdef CONFIG_SMP
>  extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift);
> -extern void pte_free_finish(void);
> +extern void pte_free_finish(struct mmu_gather *tlb);
>  #else /* CONFIG_SMP */
>  static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
>  {
>  	pgtable_free(table, shift);
>  }
> -static inline void pte_free_finish(void) { }
> +static inline void pte_free_finish(struct mmu_gather *tlb) { }
>  #endif /* !CONFIG_SMP */
>  
>  static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
> Index: linux-2.6/arch/powerpc/mm/tlb_hash32.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/tlb_hash32.c
> +++ linux-2.6/arch/powerpc/mm/tlb_hash32.c
> @@ -73,7 +73,7 @@ void tlb_flush(struct mmu_gather *tlb)
>  	}
>  
>  	/* Push out batch of freed page tables */
> -	pte_free_finish();
> +	pte_free_finish(tlb);
>  }
>  
>  /*
> Index: linux-2.6/arch/powerpc/mm/tlb_nohash.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/tlb_nohash.c
> +++ linux-2.6/arch/powerpc/mm/tlb_nohash.c
> @@ -298,7 +298,7 @@ void tlb_flush(struct mmu_gather *tlb)
>  	flush_tlb_mm(tlb->mm);
>  
>  	/* Push out batch of freed page tables */
> -	pte_free_finish();
> +	pte_free_finish(tlb);
>  }
>  
>  /*
> 


