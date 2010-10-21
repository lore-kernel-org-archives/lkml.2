Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0JUVHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:07:09 -0400
Received: from claw.goop.org ([74.207.240.146]:58485 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab0JUVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:07:08 -0400
Message-ID: <4CC0AB73.8060609@goop.org>
Date: Thu, 21 Oct 2010 14:06:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
References: <4CB76E8B.2090309@goop.org>
In-Reply-To: <4CB76E8B.2090309@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Ping?  Have you had any thoughts about possible x86-64 problems with this?

Thanks,
    J

On 10/14/2010 01:56 PM, Jeremy Fitzhardinge wrote:
>
> Take mm->page_table_lock while syncing the vmalloc region.  This prevents
> a race with the Xen pagetable pin/unpin code, which expects that the
> page_table_lock is already held.  If this race occurs, then Xen can see
> an inconsistent page type (a page can either be read/write or a pagetable
> page, and pin/unpin converts it between them), which will cause either
> the pin or the set_p[gm]d to fail; either will crash the kernel.
>
> vmalloc_sync_all() should be called rarely, so this extra use of
> page_table_lock should not interfere with its normal users.
>
> The mm pointer is stashed in the pgd page's index field, as that won't
> be otherwise used for pgd pages.
>
> Bug reported by Ian Campbell <ian.cambell@eu.citrix.com>
> Derived from a patch by Jan Beulich <jbeulich@novell.com>
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index a34c785..422b363 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -28,6 +28,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>  extern spinlock_t pgd_lock;
>  extern struct list_head pgd_list;
>  
> +extern struct mm_struct *pgd_page_get_mm(struct page *page);
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #else  /* !CONFIG_PARAVIRT */
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 4c4508e..b7f9ae1 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -229,7 +229,16 @@ void vmalloc_sync_all(void)
>  
>  		spin_lock_irqsave(&pgd_lock, flags);
>  		list_for_each_entry(page, &pgd_list, lru) {
> -			if (!vmalloc_sync_one(page_address(page), address))
> +			spinlock_t *pgt_lock;
> +			int ret;
> +
> +			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
> +
> +			spin_lock(pgt_lock);
> +			ret = vmalloc_sync_one(page_address(page), address);
> +			spin_unlock(pgt_lock);
> +
> +			if (!ret)
>  				break;
>  		}
>  		spin_unlock_irqrestore(&pgd_lock, flags);
> @@ -341,11 +350,19 @@ void vmalloc_sync_all(void)
>  		spin_lock_irqsave(&pgd_lock, flags);
>  		list_for_each_entry(page, &pgd_list, lru) {
>  			pgd_t *pgd;
> +			spinlock_t *pgt_lock;
> +
>  			pgd = (pgd_t *)page_address(page) + pgd_index(address);
> +
> +			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
> +			spin_lock(pgt_lock);
> +
>  			if (pgd_none(*pgd))
>  				set_pgd(pgd, *pgd_ref);
>  			else
>  				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
> +
> +			spin_unlock(pgt_lock);
>  		}
>  		spin_unlock_irqrestore(&pgd_lock, flags);
>  	}
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 5c4ee42..c70e57d 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -87,7 +87,19 @@ static inline void pgd_list_del(pgd_t *pgd)
>  #define UNSHARED_PTRS_PER_PGD				\
>  	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
>  
> -static void pgd_ctor(pgd_t *pgd)
> +
> +static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
> +{
> +	BUILD_BUG_ON(sizeof(virt_to_page(pgd)->index) < sizeof(mm));
> +	virt_to_page(pgd)->index = (pgoff_t)mm;
> +}
> +
> +struct mm_struct *pgd_page_get_mm(struct page *page)
> +{
> +	return (struct mm_struct *)page->index;
> +}
> +
> +static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
>  {
>  	/* If the pgd points to a shared pagetable level (either the
>  	   ptes in non-PAE, or shared PMD in PAE), then just copy the
> @@ -105,8 +117,10 @@ static void pgd_ctor(pgd_t *pgd)
>  	}
>  
>  	/* list required to sync kernel mapping updates */
> -	if (!SHARED_KERNEL_PMD)
> +	if (!SHARED_KERNEL_PMD) {
> +		pgd_set_mm(pgd, mm);
>  		pgd_list_add(pgd);
> +	}
>  }
>  
>  static void pgd_dtor(pgd_t *pgd)
> @@ -272,7 +286,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>  	 */
>  	spin_lock_irqsave(&pgd_lock, flags);
>  
> -	pgd_ctor(pgd);
> +	pgd_ctor(mm, pgd);
>  	pgd_prepopulate_pmd(mm, pgd, pmds);
>  
>  	spin_unlock_irqrestore(&pgd_lock, flags);
>
>

