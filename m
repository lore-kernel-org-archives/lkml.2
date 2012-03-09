Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2CIBSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:18:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33028 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2CIBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:18:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:16:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] memcg: avoid THP split in task migration
Message-Id: <20120309101658.8b36ce4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1330719189-20047-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1330719189-20047-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1330719189-20047-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Mar 2012 15:13:09 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently we can't do task migration among memory cgroups without THP split,
> which means processes heavily using THP experience large overhead in task
> migration. This patch introduce the code for moving charge of THP and makes
> THP more valuable.
> 
> Changes from v2:
> - add move_anon() and mapcount check
> 
> Changes from v1:
> - rename is_target_huge_pmd_for_mc() to is_target_thp_for_mc()
> - remove pmd_present() check (it's buggy when pmd_trans_huge(pmd) is true)
> - is_target_thp_for_mc() calls get_page() only when checks are passed
> - unlock page table lock if !mc.precharge
> - compare return value of is_target_thp_for_mc() explicitly to MC_TARGET_TYPE
> - clean up &walk->mm->page_table_lock to &vma->vm_mm->page_table_lock
> - add comment about why race with split_huge_page() does not happen
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Hillf Danton <dhillf@gmail.com>

I write this after reading Andrew's one.


> ---
>  mm/memcontrol.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 83 insertions(+), 6 deletions(-)
> 
> diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
> index c83aeb5..b6d1bab 100644
> --- linux-next-20120228.orig/mm/memcontrol.c
> +++ linux-next-20120228/mm/memcontrol.c
> @@ -5211,6 +5211,41 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +/*
> + * We don't consider swapping or file mapped pages because THP does not
> + * support them for now.
> + * Caller should make sure that pmd_trans_huge(pmd) is true.
> + */
> +static int is_target_thp_for_mc(struct vm_area_struct *vma,
> +		unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +	struct page *page = NULL;
> +	struct page_cgroup *pc;
> +	int ret = 0;

As Andrew pointed out, I agree MC_TARGET_NONE will be better.
Maybe other part should be rewritten.

> +
> +	page = pmd_page(pmd);
> +	VM_BUG_ON(!page || !PageHead(page));
> +	if (!move_anon() || page_mapcount(page) != 1)
> +		return 0;

Could you add this ?
==
static bool move_check_shared_map(struct page *page)
{
  /*
   * Handling of shared pages between processes is a big trouble in memcg.
   * Now, we never move shared-mapped pages between memcg at 'task' moving because
   * we have no hint which task the page is really belongs to. For example, 
   * When a task does "fork()-> move to the child other group -> exec()", the charges
   * should be stay in the original cgroup. 
   * So, check mapcount to determine we can move or not.
   */
   return page_mapcount(page) != 1;
}
==
We may be able to support madvise(MOVE_MEMCG) or fadvise(MOVE_MEMCG), if necessary.



> +	pc = lookup_page_cgroup(page);
> +	if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
> +		ret = MC_TARGET_PAGE;
> +		if (target) {
> +			get_page(page);
> +			target->page = page;

Here, get_page() is used rather than get_page_unless_zero() because of
__pmd_trans_huge_lock() is held ?



> +		}
> +	}
> +	return ret;
> +}
> +#else
> +static inline int is_target_thp_for_mc(struct vm_area_struct *vma,
> +		unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>  					unsigned long addr, unsigned long end,
>  					struct mm_walk *walk)
> @@ -5219,7 +5254,14 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>  	pte_t *pte;
>  	spinlock_t *ptl;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> +	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +		if (is_target_thp_for_mc(vma, addr, *pmd, NULL)
> +		    == MC_TARGET_PAGE)
> +			mc.precharge += HPAGE_PMD_NR;
> +		spin_unlock(&vma->vm_mm->page_table_lock);
> +		cond_resched();
> +		return 0;
> +	}

Maybe hard to read ;) I think is_target_thp_for_mc includes too much '_'
and short words...

Hmm, how about renaming "is_target_thp_for_mc"  as "pmd_move_target()" or some.
(Ah yes, other handler's name should be fixed, too.)

>  
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE)
> @@ -5378,16 +5420,51 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  	struct vm_area_struct *vma = walk->private;
>  	pte_t *pte;
>  	spinlock_t *ptl;
> +	int type;
> +	union mc_target target;
> +	struct page *page;
> +	struct page_cgroup *pc;
> +
> +	/*
> +	 * We don't take compound_lock() here but no race with splitting thp
> +	 * happens because:
> +	 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
> +	 *    under splitting, which means there's no concurrent thp split,
> +	 *  - if another thread runs into split_huge_page() just after we
> +	 *    entered this if-block, the thread must wait for page table lock
> +	 *    to be unlocked in __split_huge_page_splitting(), where the main
> +	 *    part of thp split is not executed yet.
> +	 */

ok.


> +	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +		if (!mc.precharge) {
> +			spin_unlock(&vma->vm_mm->page_table_lock);
> +			cond_resched();

Hm. Original code calls cond_resched() after 'scanning' the full pmd, 1024 entries.
With THP, it just handles 1 entry. cond_resched() will not be required.

> +			return 0;
> +		}
> +		type = is_target_thp_for_mc(vma, addr, *pmd, &target);
> +		if (type == MC_TARGET_PAGE) {
> +			page = target.page;
> +			if (!isolate_lru_page(page)) {
> +				pc = lookup_page_cgroup(page);
> +				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
> +							     pc, mc.from, mc.to,
> +							     false)) {
> +					mc.precharge -= HPAGE_PMD_NR;
> +					mc.moved_charge += HPAGE_PMD_NR;
> +				}
> +				putback_lru_page(page);
> +			}
> +			put_page(page);
> +		}
> +		spin_unlock(&vma->vm_mm->page_table_lock);
> +		cond_resched();

ditto.


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


Thank you for your efforts!

-Kame

