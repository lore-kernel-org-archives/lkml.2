Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2GSOmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:42:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab2GSOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:42:15 -0400
Date: Thu, 19 Jul 2012 16:42:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kenneth W Chen <kenneth.w.chen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: hugetlbfs: Close race during teardown of
 hugetlbfs shared page tables
Message-ID: <20120719144213.GJ2864@tiehlicka.suse.cz>
References: <20120718104220.GR9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718104220.GR9222@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[/me puts the patch destroyer glasses on]

On Wed 18-07-12 11:43:09, Mel Gorman wrote:
[...]
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index f6679a7..0524556 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -68,14 +68,37 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
>  	struct vm_area_struct *svma;
>  	unsigned long saddr;
>  	pte_t *spte = NULL;
> +	spinlock_t *spage_table_lock = NULL;
> +	struct rw_semaphore *smmap_sem = NULL;
>  
>  	if (!vma_shareable(vma, addr))
>  		return;
>  
> +retry:
>  	mutex_lock(&mapping->i_mmap_mutex);
>  	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
>  		if (svma == vma)
>  			continue;
> +		if (svma->vm_mm == vma->vm_mm)
> +			continue;
> +
> +		/*
> +		 * The target mm could be in the process of tearing down
> +		 * its page tables and the i_mmap_mutex on its own is
> +		 * not sufficient. To prevent races against teardown and
> +		 * pagetable updates, we acquire the mmap_sem and pagetable
> +		 * lock of the remote address space. down_read_trylock()
> +		 * is necessary as the other process could also be trying
> +		 * to share pagetables with the current mm.
> +		 */
> +		if (!down_read_trylock(&svma->vm_mm->mmap_sem)) {
> +			mutex_unlock(&mapping->i_mmap_mutex);
> +			goto retry;
> +		}
> +

I am afraid this can easily cause a dead lock. Consider
fork
  dup_mmap
    down_write(&oldmm->mmap_sem)
    copy_page_range
      copy_hugetlb_page_range
        huge_pte_alloc

svma could belong to oldmm and then we would loop for ever. 
svma->vm_mm == vma->vm_mm doesn't help because vma is child's one and mm
differ in that case. I am wondering you didn't hit this while testing.
It would suggest that the ptes are not populated yet because we didn't
let parent play and then other children could place its vma in the list
before parent?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
