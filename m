Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966137Ab2B2Aa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:30:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48179 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965834Ab2B2Aa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:30:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 09:28:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: avoid THP split in task migration
Message-Id: <20120229092859.a0411859.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1330463552-18473-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1330463552-18473-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 16:12:32 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently we can't do task migration among memory cgroups without THP split,
> which means processes heavily using THP experience large overhead in task
> migration. This patch introduce the code for moving charge of THP and makes
> THP more valuable.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Hillf Danton <dhillf@gmail.com>


Thank you! 

A comment below.

> ---
>  mm/memcontrol.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 70 insertions(+), 6 deletions(-)
> 
> diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
> index c83aeb5..e97c041 100644
> --- linux-next-20120228.orig/mm/memcontrol.c
> +++ linux-next-20120228/mm/memcontrol.c
> @@ -5211,6 +5211,42 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +/*
> + * We don't consider swapping or file mapped pages because THP does not
> + * support them for now.
> + */
> +static int is_target_huge_pmd_for_mc(struct vm_area_struct *vma,
> +		unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +	struct page *page = NULL;
> +	struct page_cgroup *pc;
> +	int ret = 0;
> +
> +	if (pmd_present(pmd))
> +		page = pmd_page(pmd);
> +	if (!page)
> +		return 0;
> +	VM_BUG_ON(!PageHead(page));
> +	get_page(page);
> +	pc = lookup_page_cgroup(page);
> +	if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
> +		ret = MC_TARGET_PAGE;
> +		if (target)
> +			target->page = page;
> +	}
> +	if (!ret || !target)
> +		put_page(page);
> +	return ret;
> +}
> +#else
> +static inline int is_target_huge_pmd_for_mc(struct vm_area_struct *vma,
> +		unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>  					unsigned long addr, unsigned long end,
>  					struct mm_walk *walk)
> @@ -5219,7 +5255,13 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>  	pte_t *pte;
>  	spinlock_t *ptl;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> +	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +		if (is_target_huge_pmd_for_mc(vma, addr, *pmd, NULL))
> +			mc.precharge += HPAGE_PMD_NR;
> +		spin_unlock(&walk->mm->page_table_lock);
> +		cond_resched();
> +		return 0;
> +	}
>  
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE)
> @@ -5378,16 +5420,38 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  	struct vm_area_struct *vma = walk->private;
>  	pte_t *pte;
>  	spinlock_t *ptl;
> +	int type;
> +	union mc_target target;
> +	struct page *page;
> +	struct page_cgroup *pc;
> +
> +	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +		if (!mc.precharge)
> +			return 0;
> +		type = is_target_huge_pmd_for_mc(vma, addr, *pmd, &target);
> +		if (type == MC_TARGET_PAGE) {
> +			page = target.page;
> +			if (!isolate_lru_page(page)) {
> +				pc = lookup_page_cgroup(page);

Here is a diffuclut point. Please see mem_cgroup_split_huge_fixup(). It splits
updates memcg's status of splitted pages under lru_lock and compound_lock
but not under mm->page_table_lock.

Looking into split_huge_page()

	split_huge_page()  # take anon_vma lock
		__split_huge_page()
			__split_huge_page_refcount() # take lru_lock, compound_lock.
				mem_cgroup_split_huge_fixup()
			__split_huge_page_map() # take page table lock.

I'm not fully sure but IIUC, pmd_trans_huge_lock() just guarantees a huge page "map"
never goes out. To avoid page splitting itself, compound_lock() is required, I think.

So, the lock here should be

	page = target.page;
	isolate_lru_page(page);
	flags = compound_lock_irqsave(page);


> +				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
> +							     pc, mc.from, mc.to,
> +							     false)) {
> +					mc.precharge -= HPAGE_PMD_NR;
> +					mc.moved_charge += HPAGE_PMD_NR;
> +				}

Here is PageTransHuge() is checked in mem_cgroup_move_account() and if !PageTransHuge(),
the function returns -EBUSY.
I'm not sure but....it's not worth to retry (but add a comment as FIXME later!)

	compound_unlock_irqrestore(page);

I may miss something, please check carefully, again.


Thanks,
-Kame
> +				putback_lru_page(page);
> +			}
> +			put_page(page);
> +		}
> +		spin_unlock(&walk->mm->page_table_lock);
> +		cond_resched();
> +		return 0;
> +	}
>  
> -	split_huge_page_pmd(walk->mm, pmd);
>  retry:
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; addr += PAGE_SIZE) {
>  		pte_t ptent = *(pte++);
> -		union mc_target target;
> -		int type;
> -		struct page *page;
> -		struct page_cgroup *pc;
>  		swp_entry_t ent;
>  
>  		if (!mc.precharge)
> -- 
> 1.7.7.6
> 
> 

