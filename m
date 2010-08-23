Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0HWAnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:43:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:57276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0HWAnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,254,1280732400"; 
   d="scan'208";a="547671244"
Date: Mon, 23 Aug 2010 08:43:28 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch]x86: avoid unnecessary tlb flush
Message-ID: <20100823004328.GA9766@sli10-desk.sh.intel.com>
References: <1281065308.29094.5.camel@sli10-desk.sh.intel.com>
 <20100805221913.4da0f8be.akpm@linux-foundation.org>
 <1281660475.21194.1.camel@sli10-desk.sh.intel.com>
 <alpine.DEB.1.00.1008131222110.26182@tigran.mtv.corp.google.com>
 <4C65B449.4010905@zytor.com>
 <1281740437.2704.65.camel@sbsiddha-MOBL3.sc.intel.com>
 <20100816011655.GA362@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816011655.GA362@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:16:55AM +0800, Shaohua Li wrote:
> On Sat, Aug 14, 2010 at 07:00:37AM +0800, Siddha, Suresh B wrote:
> > On Fri, 2010-08-13 at 14:08 -0700, H. Peter Anvin wrote:
> > > On 08/13/2010 12:29 PM, Hugh Dickins wrote:
> > > > 
> > > > Just added Andrea to the Cc list: he did that TLB flush in 1a44e149,
> > > > I'd feel more comfortable noop-ing it on x86 if you've convinced him.
> > > > 
> > > > Hugh
> > > 
> > > Andrea is probably on his way back from LinuxCon, but looking at the
> > > original patch it might be something that non-x86 architectures need,
> > > but which can be optimized specifically on x86, since x86 has explicit
> > > "no flush needed when going to more permissive" semantics.
> > 
> > Yes. I don't see a problem with the proposed patch. This is the case of
> > parallel thread execution getting spurious write protection faults for
> > the same page for which the pte entry is already up to date and the
> > fault has already flushed the existing spurious TLB entry in the case of
> > x86.
> > 
> > I prefer a better name for the new flush_tlb_nonprotect_page() to
> > reflect the above. something like tlb_fix_spurious_fault() or something?
> this name is better.
Hi Andrea,
can you look at this patch?

Thanks,
Shaohua
 
> In x86, access and dirty bits are set automatically by CPU when CPU accesses
> memory. When we go into the code path of below flush_tlb_fix_spurious_fault(),
> we already set dirty bit for pte and don't need flush tlb. This might mean
> tlb entry in some CPUs hasn't dirty bit set, but this doesn't matter. When
> the CPUs do page write, they will automatically check the bit and no software
> involved. 
> 
> On the other hand, flush tlb in below position is harmful. Test creates CPU
> number of threads, each thread writes to a same but random address in same vma
> range and we measure the total time. Under a 4 socket system, original time is
> 1.96s, while with the patch, the time is 0.8s. Under a 2 socket system, there is
> 20% time cut too. perf shows a lot of time are taking to send ipi/handle ipi for
> tlb flush.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> ---
>  arch/x86/include/asm/pgtable.h |    2 ++
>  include/asm-generic/pgtable.h  |    4 ++++
>  mm/memory.c                    |    2 +-
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/include/asm/pgtable.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/pgtable.h	2010-08-16 09:00:02.000000000 +0800
> +++ linux/arch/x86/include/asm/pgtable.h	2010-08-16 09:03:41.000000000 +0800
> @@ -603,6 +603,8 @@ static inline void ptep_set_wrprotect(st
>  	pte_update(mm, addr, ptep);
>  }
>  
> +#define flush_tlb_fix_spurious_fault(vma, address)
> +
>  /*
>   * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
>   *
> Index: linux/include/asm-generic/pgtable.h
> ===================================================================
> --- linux.orig/include/asm-generic/pgtable.h	2010-08-16 09:00:02.000000000 +0800
> +++ linux/include/asm-generic/pgtable.h	2010-08-16 09:03:41.000000000 +0800
> @@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
>  #define move_pte(pte, prot, old_addr, new_addr)	(pte)
>  #endif
>  
> +#ifndef flush_tlb_fix_spurious_fault
> +#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
> +#endif
> +
>  #ifndef pgprot_noncached
>  #define pgprot_noncached(prot)	(prot)
>  #endif
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c	2010-08-16 09:03:08.000000000 +0800
> +++ linux/mm/memory.c	2010-08-16 09:03:41.000000000 +0800
> @@ -3140,7 +3140,7 @@ static inline int handle_pte_fault(struc
>  		 * with threads.
>  		 */
>  		if (flags & FAULT_FLAG_WRITE)
> -			flush_tlb_page(vma, address);
> +			flush_tlb_fix_spurious_fault(vma, address);
>  	}
>  unlock:
>  	pte_unmap_unlock(pte, ptl);
