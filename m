Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1BXVGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:06:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BXVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:06:43 -0500
Subject: Re: PowerPC BUG: using smp_processor_id() in preemptible code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
References: <alpine.LSU.2.00.1012291413360.22939@sister.anvils>
	 <1293705910.17779.60.camel@pasglop>
	 <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 22:07:55 +0100
Message-ID: <1298581675.5226.840.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 12:47 -0800, Hugh Dickins wrote:

Lovely problem :-), benh mentioned it on IRC, but I never got around to
finding the email thread, thanks for the CC.

> What would be better for 2.6.38 and 2.6.37-stable?  Moving that call to
> vunmap_page_range back under vb->lock, or the partial-Peter-patch below?
> And then what should be done for 2.6.39?

I think you'll also need the arch/powerpc/kernel/process.c changes that
cause context switches to flush the tlb_batch queues.

> --- 2.6.38-rc5/arch/powerpc/mm/tlb_hash64.c     2010-02-24 10:52:17.000000000 -0800
> +++ linux/arch/powerpc/mm/tlb_hash64.c  2011-02-15 23:27:21.000000000 -0800
> @@ -38,13 +38,11 @@ DEFINE_PER_CPU(struct ppc64_tlb_batch, p
>   * neesd to be flushed. This function will either perform the flush
>   * immediately or will batch it up if the current CPU has an active
>   * batch on it.
> - *
> - * Must be called from within some kind of spinlock/non-preempt region...
>   */
>  void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
>                      pte_t *ptep, unsigned long pte, int huge)
>  {
> -       struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
> +       struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
>         unsigned long vsid, vaddr;
>         unsigned int psize;
>         int ssize;
> @@ -99,6 +97,7 @@ void hpte_need_flush(struct mm_struct *m
>          */
>         if (!batch->active) {
>                 flush_hash_page(vaddr, rpte, psize, ssize, 0);
> +               put_cpu_var(ppc64_tlb_batch);
>                 return;
>         }
>  
> @@ -127,6 +126,7 @@ void hpte_need_flush(struct mm_struct *m
>         batch->index = ++i;
>         if (i >= PPC64_TLB_BATCH_NR)
>                 __flush_tlb_pending(batch);
> +       put_cpu_var(ppc64_tlb_batch);
>  }
>  
>  /* 

