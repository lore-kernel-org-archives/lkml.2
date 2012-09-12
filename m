Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab2ILPkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:40:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab2ILPkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:40:39 -0400
Date: Wed, 12 Sep 2012 17:40:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 2/3] mm: thp: Fix the update_mmu_cache() last argument
 passing in mm/huge_memory.c
Message-ID: <20120912154037.GU21579@dhcp22.suse.cz>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
 <1347382036-18455-3-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347382036-18455-3-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-09-12 17:47:15, Will Deacon wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> The update_mmu_cache() takes a pointer (to pte_t by default) as the last
> argument but the huge_memory.c passes a pmd_t value. The patch changes
> the argument to the pmd_t * pointer.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steve Capper <steve.capper@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  mm/huge_memory.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 57c4b93..4aa6d02 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -934,7 +934,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		entry = pmd_mkyoung(orig_pmd);
>  		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
>  		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
> -			update_mmu_cache(vma, address, entry);
> +			update_mmu_cache(vma, address, pmd);

I am not sure but shouldn't we use the new entry rather than the given
pmd?

>  		ret |= VM_FAULT_WRITE;
>  		goto out_unlock;
>  	}
> @@ -986,7 +986,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		pmdp_clear_flush_notify(vma, haddr, pmd);
>  		page_add_new_anon_rmap(new_page, vma, haddr);
>  		set_pmd_at(mm, haddr, pmd, entry);
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, pmd);
>  		page_remove_rmap(page);
>  		put_page(page);
>  		ret |= VM_FAULT_WRITE;
> @@ -1989,7 +1989,7 @@ static void collapse_huge_page(struct mm_struct *mm,
>  	BUG_ON(!pmd_none(*pmd));
>  	page_add_new_anon_rmap(new_page, vma, address);
>  	set_pmd_at(mm, address, pmd, _pmd);
> -	update_mmu_cache(vma, address, _pmd);
> +	update_mmu_cache(vma, address, pmd);
>  	prepare_pmd_huge_pte(pgtable, mm);
>  	spin_unlock(&mm->page_table_lock);
>  
> -- 
> 1.7.4.1
> 

-- 
Michal Hocko
SUSE Labs
