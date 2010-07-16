Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab0GQBrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709Ab0GQBra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:47:30 -0400
Date: Fri, 16 Jul 2010 20:48:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 6/6] kvm, faster and simpler version of
 get_user_page_and_protection()
Message-ID: <20100716234843.GC8946@amt.cnet>
References: <4C3FC03A.9040504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FC03A.9040504@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:13:14AM +0800, Lai Jiangshan wrote:
> 
> a light weight version of get_user_page_and_protection()
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index a34c785..d0e4f2f 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -618,6 +618,8 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
>         memcpy(dst, src, count * sizeof(pgd_t));
>  }
>  
> +extern
> +struct page *get_user_page_and_protection(unsigned long addr, int *writable);
>  
>  #include <asm-generic/pgtable.h>
>  #endif	/* __ASSEMBLY__ */
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 6382140..de44847 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1832,23 +1832,6 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>  	}
>  }
>  
> -/* get a current mapped page fast, and test whether the page is writable. */
> -static struct page *get_user_page_and_protection(unsigned long addr,
> -	int *writable)
> -{
> -	struct page *page[1];
> -
> -	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> -		*writable = 1;
> -		return page[0];
> -	}
> -	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> -		*writable = 0;
> -		return page[0];
> -	}
> -	return NULL;
> -}
> -
>  static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
>  		int write_fault, int *host_writable)
>  {
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index a4ce19f..34b05c7 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -275,7 +275,6 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  
>  	return nr;
>  }
> -EXPORT_SYMBOL_GPL(__get_user_pages_fast);
>  
>  /**
>   * get_user_pages_fast() - pin user pages in memory
> @@ -375,3 +374,83 @@ slow_irqon:
>  		return ret;
>  	}
>  }
> +
> +/*
> + * get a current mapped page fast, and test whether the page is writable.
> + * equivalent version(but slower):
> + * {
> + *	struct page *page[1];
> + *
> + *	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> + *		*writable = 1;
> + *		return page[0];
> + *	}
> + *	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> + *		*writable = 0;
> + *		return page[0];
> + *	}
> + *	return NULL;
> + * }
> + */
> +struct page *get_user_page_and_protection(unsigned long addr, int *writable)
> +{
> +	unsigned long flags;
> +	struct mm_struct *mm = current->mm;
> +	pgd_t *pgdp;
> +	pud_t *pudp;
> +	pmd_t *pmdp;
> +	pte_t pte, *ptep;
> +
> +	unsigned long mask = _PAGE_PRESENT | _PAGE_USER;
> +	unsigned long offset = 0;
> +	struct page *head, *page = NULL;
> +
> +	addr &= PAGE_MASK;
> +
> +	local_irq_save(flags);
> +	pgdp = pgd_offset(mm, addr);
> +	if (!pgd_present(*pgdp))
> +		goto out;

Better introduce __get_user_pages_ptes_fast, and share code with 
__get_user_pages_fast (except _ptes_fast copies the pte values to
pte_t array).
