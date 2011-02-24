Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1BXVMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:12:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:52221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab1BXVMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:12:20 -0500
Subject: Re: PowerPC BUG: using smp_processor_id() in preemptible code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
References: <alpine.LSU.2.00.1012291413360.22939@sister.anvils>
	 <1293705910.17779.60.camel@pasglop>
	 <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:12:02 +1100
Message-ID: <1298581922.8833.486.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 12:47 -0800, Hugh Dickins wrote:

> Reading back, I see Jeremy suggested moving vb_free()'s call to
> vunmap_page_range() back inside vb->lock: it certainly was his moving
> the call out from under that lock that brought the issue to my notice;
> but it looked as if there were other paths which would give preemptible
> PowerPC the same issue, just paths I happen not to go down myself. I'm
> not sure, I didn't take the time to follow it up properly, expecting
> further insight to arrive shortly from Ben!

Yeah, sorry, I've been too over extended lately...

> And, as threatened, Jeremy has further vmalloc changes queued up in
> mmotm, which certainly make the patch below inadequate, and I imagine
> the vunmap_page_range() movement too.  I'm currently (well, I think most
> recent mmotm doesn't even boot on my ppc) having to disable preemption
> in the kernel case of apply_to_pte_range().
> 
> What would be better for 2.6.38 and 2.6.37-stable?  Moving that call to
> vunmap_page_range back under vb->lock, or the partial-Peter-patch below?
> And then what should be done for 2.6.39?

Patch is fine. I should send it to Linus. It's not like we have a batch
on the vmalloc space anyways since it doesnt do the arch_lazy_mmu stuff,
so it's really about protecting the per-cpu variable.

Cheers,
Ben.

> --- 2.6.38-rc5/arch/powerpc/mm/tlb_hash64.c	2010-02-24 10:52:17.000000000 -0800
> +++ linux/arch/powerpc/mm/tlb_hash64.c	2011-02-15 23:27:21.000000000 -0800
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


