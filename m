Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030364Ab2CNMbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:31:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48834 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912Ab2CNMbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <1331676929-25774-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20120313144501.d031f25d.kamezawa.hiroyu@jp.fujitsu.com>
	<1331676929-25774-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Wed, 14 Mar 2012 20:31:43 +0800
Message-ID: <CAJd=RBBjX2nL3UXoHZox3oU6Ve0xSawLNdXCawbdLaPpE8tQ1w@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] memcg: clean up existing move charge code
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 6:15 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> From c9bdd8f19040f3cea1c7d36e98b03ee13c1b8505 Mon Sep 17 00:00:00 2001
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Tue, 13 Mar 2012 15:21:47 -0400
> Subject: [PATCH 1/3] memcg: clean up existing move charge code
>
> We'll introduce the thp variant of move charge code in later patches,
> but before doing that let's start with refactoring existing code.
> Here we replace lengthy function name is_target_pte_for_mc() with
> shorter one in order to avoid ugly line breaks.
> And for better readability, we explicitly use MC_TARGET_* instead of
> simply using integers.
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.futjisu.com>

Acked-by: Hillf Danton <dhillf@gmail.com>

> ---
>  mm/memcontrol.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a288855..508a7ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5069,7 +5069,7 @@ one_by_one:
>  }
>
>  /**
> - * is_target_pte_for_mc - check a pte whether it is valid for move charge
> + * get_mctgt_type - get target type of moving charge
>  * @vma: the vma the pte to be checked belongs
>  * @addr: the address corresponding to the pte to be checked
>  * @ptent: the pte to be checked
> @@ -5092,7 +5092,7 @@ union mc_target {
>  };
>
>  enum mc_target_type {
> -       MC_TARGET_NONE, /* not used */
> +       MC_TARGET_NONE = 0,
>        MC_TARGET_PAGE,
>        MC_TARGET_SWAP,
>  };
> @@ -5173,12 +5173,12 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
>        return page;
>  }
>
> -static int is_target_pte_for_mc(struct vm_area_struct *vma,
> +static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>                unsigned long addr, pte_t ptent, union mc_target *target)
>  {
>        struct page *page = NULL;
>        struct page_cgroup *pc;
> -       int ret = 0;
> +       enum mc_target_type ret = MC_TARGET_NONE;
>        swp_entry_t ent = { .val = 0 };
>
>        if (pte_present(ptent))
> @@ -5189,7 +5189,7 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
>                page = mc_handle_file_pte(vma, addr, ptent, &ent);
>
>        if (!page && !ent.val)
> -               return 0;
> +               return ret;
>        if (page) {
>                pc = lookup_page_cgroup(page);
>                /*
> @@ -5227,7 +5227,7 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
>
>        pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>        for (; addr != end; pte++, addr += PAGE_SIZE)
> -               if (is_target_pte_for_mc(vma, addr, *pte, NULL))
> +               if (get_mctgt_type(vma, addr, *pte, NULL))
>                        mc.precharge++; /* increment precharge temporarily */
>        pte_unmap_unlock(pte - 1, ptl);
>        cond_resched();
> @@ -5397,8 +5397,7 @@ retry:
>                if (!mc.precharge)
>                        break;
>
> -               type = is_target_pte_for_mc(vma, addr, ptent, &target);
> -               switch (type) {
> +               switch (get_mctgt_type(vma, addr, ptent, &target)) {
>                case MC_TARGET_PAGE:
>                        page = target.page;
>                        if (isolate_lru_page(page))
> @@ -5411,7 +5410,7 @@ retry:
>                                mc.moved_charge++;
>                        }
>                        putback_lru_page(page);
> -put:                   /* is_target_pte_for_mc() gets the page */
> +put:                   /* get_mctgt_type() gets the page */
>                        put_page(page);
>                        break;
>                case MC_TARGET_SWAP:
> --
> 1.7.7.6
>
