Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab1CRWSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:18:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab1CRWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nx8QYTk1Zb9jmwnUA0qr12f65o0gQl4yMtOD5rDhnw0ddT0acUUAXKWEO7LpmLpUL7
         PEMh1C1PxlGK4ErnPEIw==
Date: Fri, 18 Mar 2011 15:17:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prasad Joshi <prasadjoshi124@gmail.com>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 03/22] mm, x86: add gfp flags variant of pud,
 pmd, and pte allocations
In-Reply-To: <20110318194740.GD4746@prasad-kvm>
Message-ID: <alpine.DEB.2.00.1103181514340.30968@chino.kir.corp.google.com>
References: <20110318194135.GA4746@prasad-kvm> <20110318194341.GB4746@prasad-kvm> <20110318194600.GC4746@prasad-kvm> <20110318194740.GD4746@prasad-kvm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, Prasad Joshi wrote:

> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
> index b4389a4..db83bd4 100644
> --- a/arch/x86/include/asm/pgalloc.h
> +++ b/arch/x86/include/asm/pgalloc.h
> @@ -34,6 +34,7 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
>  extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
>  
>  extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
> +extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
>  extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
>  
>  /* Should really implement gc for free page table pages. This could be
> @@ -78,9 +79,15 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
>  #define pmd_pgtable(pmd) pmd_page(pmd)
>  
>  #if PAGETABLE_LEVELS > 2
> +static inline pmd_t *
> +__pmd_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
> +{
> +	return (pmd_t *)get_zeroed_page(gfp_mask);
> +}

There should be no break between the function type and its name.

> +
>  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
>  {
> -	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
> +	return __pmd_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
>  }
>  
>  static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
> @@ -114,9 +121,15 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
>  	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
>  }
>  
> +static inline pud_t *
> +__pud_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
> +{
> +	return (pud_t *)get_zeroed_page(gfp_mask);
> +}
> +
>  static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
>  {
> -	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
> +	return __pud_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
>  }
>  
>  static inline void pud_free(struct mm_struct *mm, pud_t *pud)
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 0113d19..f5205b3 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -15,9 +15,15 @@
>  
>  gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;
>  
> +pte_t *
> +__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
> +{
> +	return (pte_t *)__get_free_page(gfp_mask | __GFP_NOTRACK | __GFP_ZERO);
> +}
> +
>  pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
>  {
> -	return (pte_t *)__get_free_page(PGALLOC_GFP);
> +	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);

PGALLOC_GFP represents the gfp flags intended for the allocators in this 
file, there's no need to replace its use with GFP_KERNEL | __GFP_REPEAT, 
we don't care that __pte_alloc_one_kernel() ORs this with __GFP_NOTRACK 
and __GFP_ZERO.

>  }
>  
>  pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
