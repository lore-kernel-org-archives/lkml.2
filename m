Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2CBMWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:22:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41035 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2CBMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:22:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.179.102 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330648313-32593-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1330648313-32593-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1330648313-32593-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 2 Mar 2012 20:22:29 +0800
Message-ID: <CAJd=RBD46TioS0n7k6nZRG7p8+hiJkUddayr8=0sCxKq8Qct1Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] memcg: avoid THP split in task migration
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q22CMeoa017303

On Fri, Mar 2, 2012 at 8:31 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> Currently we can't do task migration among memory cgroups without THP split,
> which means processes heavily using THP experience large overhead in task
> migration. This patch introduce the code for moving charge of THP and makes
> THP more valuable.
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
> Cc: Hillf Danton <dhillf@gmail.com>
> ---
>  mm/memcontrol.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 81 insertions(+), 6 deletions(-)
>
> diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
> index c83aeb5..d45b21c 100644
> --- linux-next-20120228.orig/mm/memcontrol.c
> +++ linux-next-20120228/mm/memcontrol.c
> @@ -5211,6 +5211,39 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
>        return ret;
>  }
>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +/*
> + * We don't consider swapping or file mapped pages because THP does not
> + * support them for now.
> + * Caller should make sure that pmd_trans_huge(pmd) is true.
> + */
> +static int is_target_thp_for_mc(struct vm_area_struct *vma,
> +               unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +       struct page *page = NULL;
> +       struct page_cgroup *pc;
> +       int ret = 0;
> +

Need to check move_anon() ?

Other than that,
Acked-by: Hillf Danton <dhillf@gmail.com>

> +       page = pmd_page(pmd);
> +       VM_BUG_ON(!page || !PageHead(page));
> +       pc = lookup_page_cgroup(page);
> +       if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
> +               ret = MC_TARGET_PAGE;
> +               if (target) {
> +                       get_page(page);
> +                       target->page = page;
> +               }
> +       }
> +       return ret;
> +}
> +#else
> +static inline int is_target_thp_for_mc(struct vm_area_struct *vma,
> +               unsigned long addr, pmd_t pmd, union mc_target *target)
> +{
> +       return 0;
> +}
> +#endif
> +
>  static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>                                        unsigned long addr, unsigned long end,
>                                        struct mm_walk *walk)
> @@ -5219,7 +5252,14 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>        pte_t *pte;
>        spinlock_t *ptl;
>
> -       split_huge_page_pmd(walk->mm, pmd);
> +       if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +               if (is_target_thp_for_mc(vma, addr, *pmd, NULL)
> +                   == MC_TARGET_PAGE)
> +                       mc.precharge += HPAGE_PMD_NR;
> +               spin_unlock(&vma->vm_mm->page_table_lock);
> +               cond_resched();
> +               return 0;
> +       }
>
>        pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>        for (; addr != end; pte++, addr += PAGE_SIZE)
> @@ -5378,16 +5418,51 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>        struct vm_area_struct *vma = walk->private;
>        pte_t *pte;
>        spinlock_t *ptl;
> +       int type;
> +       union mc_target target;
> +       struct page *page;
> +       struct page_cgroup *pc;
> +
> +       /*
> +        * We don't take compound_lock() here but no race with splitting thp
> +        * happens because:
> +        *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
> +        *    under splitting, which means there's no concurrent thp split,
> +        *  - if another thread runs into split_huge_page() just after we
> +        *    entered this if-block, the thread must wait for page table lock
> +        *    to be unlocked in __split_huge_page_splitting(), where the main
> +        *    part of thp split is not executed yet.
> +        */
> +       if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +               if (!mc.precharge) {
> +                       spin_unlock(&vma->vm_mm->page_table_lock);
> +                       cond_resched();
> +                       return 0;
> +               }
> +               type = is_target_thp_for_mc(vma, addr, *pmd, &target);
> +               if (type == MC_TARGET_PAGE) {
> +                       page = target.page;
> +                       if (!isolate_lru_page(page)) {
> +                               pc = lookup_page_cgroup(page);
> +                               if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
> +                                                            pc, mc.from, mc.to,
> +                                                            false)) {
> +                                       mc.precharge -= HPAGE_PMD_NR;
> +                                       mc.moved_charge += HPAGE_PMD_NR;
> +                               }
> +                               putback_lru_page(page);
> +                       }
> +                       put_page(page);
> +               }
> +               spin_unlock(&vma->vm_mm->page_table_lock);
> +               cond_resched();
> +               return 0;
> +       }
>
> -       split_huge_page_pmd(walk->mm, pmd);
>  retry:
>        pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>        for (; addr != end; addr += PAGE_SIZE) {
>                pte_t ptent = *(pte++);
> -               union mc_target target;
> -               int type;
> -               struct page *page;
> -               struct page_cgroup *pc;
>                swp_entry_t ent;
>
>                if (!mc.precharge)
> --
> 1.7.7.6
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
