Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FKGl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:41:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:46404 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab0FKGlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:41:25 -0400
Subject: Re: [PATCH 3/5] Removing dead CONFIG_SMP_750
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
In-Reply-To: <20100610122311.GA3885@stud.informatik.uni-erlangen.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
	 <8bf8cfaf47590e1a85f9510bb546ca35e3458bf8.1275925219.git.siccegge@cs.fau.de>
	 <20100609123557.GJ7801@zod.rchland.ibm.com>
	 <1276150461.1962.42.camel@pasglop>
	 <20100610122311.GA3885@stud.informatik.uni-erlangen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 16:41:04 +1000
Message-ID: <1276238464.1962.112.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 14:23 +0200, Christoph Egger wrote:
> On Thu, Jun 10, 2010 at 04:14:21PM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2010-06-09 at 08:35 -0400, Josh Boyer wrote:
> > > On Wed, Jun 09, 2010 at 12:00:21PM +0200, Christoph Egger wrote:
> > > >CONFIG_SMP_750 doesn't exist in Kconfig, therefore removing all
> > > >references for it from the source code.
> > > 
> > > Yeah, we don't support SMP on 750 at the moment.  This code was carried over
> > > from the arch/ppc days, and that code was present pre-git.  I think we can
> > > drop it, but I'll leave that up to Ben.  Maybe he has crazy plans for a 750 SMP
> > > board.
> > 
> > Nope :-) Though it would be nice to also remove the call sites too and
> > thus remove the macro entirely.
> 
> SOmething like below?

Excellent. Thanks. I'll add that to the batch I'm preparing for Linus.

Cheers,
Ben.

> -----
> From: Christoph Egger <siccegge@cs.fau.de>
> Subject: [PATCH 3/5] Removing dead CONFIG_SMP_750
> 
> CONFIG_SMP_750 doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> 
> diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
> index 8aaa8b7..09c7820 100644
> --- a/arch/powerpc/mm/tlb_hash32.c
> +++ b/arch/powerpc/mm/tlb_hash32.c
> @@ -94,11 +94,6 @@ void tlb_flush(struct mmu_gather *tlb)
>   * the cache operations on the bus.  Hence we need to use an IPI
>   * to get the other CPU(s) to invalidate their TLBs.
>   */
> -#ifdef CONFIG_SMP_750
> -#define FINISH_FLUSH   smp_send_tlb_invalidate(0)
> -#else
> -#define FINISH_FLUSH   do { } while (0)
> -#endif
>  
>  static void flush_range(struct mm_struct *mm, unsigned long start,
>                         unsigned long end)
> @@ -138,7 +133,6 @@ static void flush_range(struct mm_struct *mm, unsigned long start,
>  void flush_tlb_kernel_range(unsigned long start, unsigned long end)
>  {
>         flush_range(&init_mm, start, end);
> -       FINISH_FLUSH;
>  }
>  EXPORT_SYMBOL(flush_tlb_kernel_range);
>  
> @@ -162,7 +156,6 @@ void flush_tlb_mm(struct mm_struct *mm)
>          */
>         for (mp = mm->mmap; mp != NULL; mp = mp->vm_next)
>                 flush_range(mp->vm_mm, mp->vm_start, mp->vm_end);
> -       FINISH_FLUSH;
>  }
>  EXPORT_SYMBOL(flush_tlb_mm);
>  
> @@ -179,7 +172,6 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
>         pmd = pmd_offset(pud_offset(pgd_offset(mm, vmaddr), vmaddr), vmaddr);
>         if (!pmd_none(*pmd))
>                 flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
> -       FINISH_FLUSH;
>  }
>  EXPORT_SYMBOL(flush_tlb_page);
>  
> @@ -192,6 +184,5 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
>                      unsigned long end)
>  {
>         flush_range(vma->vm_mm, start, end);
> -       FINISH_FLUSH;
>  }
>  EXPORT_SYMBOL(flush_tlb_range);


