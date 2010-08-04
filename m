Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0HDSbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:31:40 -0400
Received: from claw.goop.org ([74.207.240.146]:59398 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0HDSbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:31:39 -0400
Message-ID: <4C59B205.5020505@goop.org>
Date: Wed, 04 Aug 2010 11:31:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave McCracken <dcm@mccr.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/hugetlb: use set_pmd for huge pte operations
References: <4C4DE5BF.1030603@goop.org>
In-Reply-To: <4C4DE5BF.1030603@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 12:45 PM, Jeremy Fitzhardinge wrote:

Ping?  I was about to send this to Linus, but I realized that I hadn't 
got any x86 acks on it.  Any comments/complaints?

Thanks,
     J

>
> On x86, a huge pte is logically a pte, but structurally a pmd.  Among
> other issues, pmds and ptes overload some flags for multiple uses (PAT
> vs PSE), so it is necessary to know which structural level a pagetable
> entry is in order interpret it properly.
>
> When huge pages are used within a paravirtualized system, it is therefore
> appropriate to use the pmd set of function to operate on them, so that
> the hypervisor can correctly validate the update.
>
> [ Add fix for 32-bit non-PAE with two-level pagetable - Jeremy ]
>
> Signed-off-by: Dave McCracken<dave.mccracken@oracle.com>
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>
> diff --git a/arch/x86/include/asm/hugetlb.h 
> b/arch/x86/include/asm/hugetlb.h
> index 439a9ac..bf88684 100644
> --- a/arch/x86/include/asm/hugetlb.h
> +++ b/arch/x86/include/asm/hugetlb.h
> @@ -36,16 +36,28 @@ static inline void hugetlb_free_pgd_range(struct 
> mmu_gather *tlb,
>      free_pgd_range(tlb, addr, end, floor, ceiling);
>  }
>
> +static inline pte_t huge_ptep_get(pte_t *ptep)
> +{
> +    return *ptep;
> +}
> +
>  static inline void set_huge_pte_at(struct mm_struct *mm, unsigned 
> long addr,
>                     pte_t *ptep, pte_t pte)
>  {
> -    set_pte_at(mm, addr, ptep, pte);
> +#if PAGETABLE_LEVELS>= 3
> +    set_pmd((pmd_t *)ptep, native_make_pmd(native_pte_val(pte)));
> +#else
> +    set_pgd((pgd_t *)ptep, native_make_pgd(native_pte_val(pte)));
> +#endif
>  }
>
>  static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
>                          unsigned long addr, pte_t *ptep)
>  {
> -    return ptep_get_and_clear(mm, addr, ptep);
> +    pte_t pte = huge_ptep_get(ptep);
> +
> +    set_huge_pte_at(mm, addr, ptep, __pte(0));
> +    return pte;
>  }
>
>  static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
> @@ -66,19 +78,25 @@ static inline pte_t huge_pte_wrprotect(pte_t pte)
>  static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
>                         unsigned long addr, pte_t *ptep)
>  {
> -    ptep_set_wrprotect(mm, addr, ptep);
> +    pte_t pte = huge_ptep_get(ptep);
> +
> +    pte = pte_wrprotect(pte);
> +    set_huge_pte_at(mm, addr, ptep, pte);
>  }
>
>  static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
>                           unsigned long addr, pte_t *ptep,
>                           pte_t pte, int dirty)
>  {
> -    return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
> -}
> +    pte_t oldpte = huge_ptep_get(ptep);
> +    int changed = !pte_same(oldpte, pte);
>
> -static inline pte_t huge_ptep_get(pte_t *ptep)
> -{
> -    return *ptep;
> +    if (changed&&  dirty) {
> +        set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
> +        flush_tlb_page(vma, addr);
> +    }
> +
> +    return changed;
>  }
>
>  static inline int arch_prepare_hugepage(struct page *page)
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

