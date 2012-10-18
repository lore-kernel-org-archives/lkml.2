Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2JRUNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:13:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2JRUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:13:52 -0400
Date: Thu, 18 Oct 2012 13:13:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bob Liu <lliubbo@gmail.com>
cc: akpm@linux-foundation.org, aarcange@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, hughd@google.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH 1/4] thp: clean up __collapse_huge_page_isolate
In-Reply-To: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
Message-ID: <alpine.DEB.2.00.1210181311390.26994@chino.kir.corp.google.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Bob Liu wrote:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a863af2..462d6ea 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1700,64 +1700,49 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte)
>  	}
>  }
>  
> -static void release_all_pte_pages(pte_t *pte)
> -{
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR);
> -}
> -
>  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  					unsigned long address,
>  					pte_t *pte)
>  {
>  	struct page *page;
>  	pte_t *_pte;
> -	int referenced = 0, isolated = 0, none = 0;
> +	int referenced = 0, isolated = 1, none = 0;
>  	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
>  	     _pte++, address += PAGE_SIZE) {
>  		pte_t pteval = *_pte;
>  		if (pte_none(pteval)) {
>  			if (++none <= khugepaged_max_ptes_none)
>  				continue;
> -			else {
> -				release_pte_pages(pte, _pte);
> +			else
>  				goto out;
> -			}
>  		}
> -		if (!pte_present(pteval) || !pte_write(pteval)) {
> -			release_pte_pages(pte, _pte);
> +		if (!pte_present(pteval) || !pte_write(pteval))
>  			goto out;
> -		}
>  		page = vm_normal_page(vma, address, pteval);
> -		if (unlikely(!page)) {
> -			release_pte_pages(pte, _pte);
> +		if (unlikely(!page))
>  			goto out;
> -		}
> +
>  		VM_BUG_ON(PageCompound(page));
>  		BUG_ON(!PageAnon(page));
>  		VM_BUG_ON(!PageSwapBacked(page));
>  
>  		/* cannot use mapcount: can't collapse if there's a gup pin */
> -		if (page_count(page) != 1) {
> -			release_pte_pages(pte, _pte);
> +		if (page_count(page) != 1)
>  			goto out;
> -		}
>  		/*
>  		 * We can do it before isolate_lru_page because the
>  		 * page can't be freed from under us. NOTE: PG_lock
>  		 * is needed to serialize against split_huge_page
>  		 * when invoked from the VM.
>  		 */
> -		if (!trylock_page(page)) {
> -			release_pte_pages(pte, _pte);
> +		if (!trylock_page(page))
>  			goto out;
> -		}
>  		/*
>  		 * Isolate the page to avoid collapsing an hugepage
>  		 * currently in use by the VM.
>  		 */
>  		if (isolate_lru_page(page)) {
>  			unlock_page(page);
> -			release_pte_pages(pte, _pte);
>  			goto out;
>  		}
>  		/* 0 stands for page_is_file_cache(page) == false */
> @@ -1770,11 +1755,11 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		    mmu_notifier_test_young(vma->vm_mm, address))
>  			referenced = 1;
>  	}
> -	if (unlikely(!referenced))
> -		release_all_pte_pages(pte);
> -	else
> -		isolated = 1;
> +	if (unlikely(!referenced)) {
>  out:

Labels inside of conditionals are never good if they can be avoided and in 
this case you can avoid it by doing

		if (likely(referenced))
			return 1;
	out:
		...

> +		release_pte_pages(pte, _pte);
> +		isolated = 0;
> +	}
>  	return isolated;
>  }
>  
