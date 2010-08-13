Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122Ab0HMT31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:29:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43965 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762066Ab0HMT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:29:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=w+us0aWi2i83xzUZ4aaNVBcugeDugLPgPNjfSnxOx0H0yqm9fETfaYo5GQr5sjUlD
	hRqIldQKzgdZHgHqaH8Ow==
Date: Fri, 13 Aug 2010 12:29:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [patch]x86: avoid unnecessary tlb flush
In-Reply-To: <1281660475.21194.1.camel@sli10-desk.sh.intel.com>
Message-ID: <alpine.DEB.1.00.1008131222110.26182@tigran.mtv.corp.google.com>
References: <1281065308.29094.5.camel@sli10-desk.sh.intel.com> <20100805221913.4da0f8be.akpm@linux-foundation.org> <1281660475.21194.1.camel@sli10-desk.sh.intel.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010, Shaohua Li wrote:
> 
> In x86, access and dirty bits are set automatically by CPU when CPU accesses
> memory. When we go into the code path of below flush_tlb_nonprotect_page(),
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
> 
> ---
>  arch/x86/include/asm/pgtable.h |    2 ++
>  include/asm-generic/pgtable.h  |    4 ++++
>  mm/memory.c                    |    2 +-
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/include/asm/pgtable.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/pgtable.h	2010-08-13 08:23:13.000000000 +0800
> +++ linux/arch/x86/include/asm/pgtable.h	2010-08-13 08:24:53.000000000 +0800
> @@ -603,6 +603,8 @@ static inline void ptep_set_wrprotect(st
>  	pte_update(mm, addr, ptep);
>  }
>  
> +#define flush_tlb_nonprotect_page(vma, address)
> +
>  /*
>   * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
>   *
> Index: linux/include/asm-generic/pgtable.h
> ===================================================================
> --- linux.orig/include/asm-generic/pgtable.h	2010-08-13 08:23:13.000000000 +0800
> +++ linux/include/asm-generic/pgtable.h	2010-08-13 08:24:53.000000000 +0800
> @@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(st
>  #define move_pte(pte, prot, old_addr, new_addr)	(pte)
>  #endif
>  
> +#ifndef flush_tlb_nonprotect_page
> +#define flush_tlb_nonprotect_page(vma, address) flush_tlb_page(vma, address)
> +#endif
> +
>  #ifndef pgprot_noncached
>  #define pgprot_noncached(prot)	(prot)
>  #endif
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c	2010-08-13 08:23:13.000000000 +0800
> +++ linux/mm/memory.c	2010-08-13 08:24:53.000000000 +0800
> @@ -3116,7 +3116,7 @@ static inline int handle_pte_fault(struc
>  		 * with threads.
>  		 */
>  		if (flags & FAULT_FLAG_WRITE)
> -			flush_tlb_page(vma, address);
> +			flush_tlb_nonprotect_page(vma, address);
>  	}
>  unlock:
>  	pte_unmap_unlock(pte, ptl);

Just added Andrea to the Cc list: he did that TLB flush in 1a44e149,
I'd feel more comfortable noop-ing it on x86 if you've convinced him.

Hugh
