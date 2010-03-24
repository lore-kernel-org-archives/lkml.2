Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0CXGBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:01:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39315 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0CXGBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:01:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Mar 2010 14:57:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Matt Mackall <mpm@selenic.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm] [BUGFIX] pagemap: fix pfn calculation for
 hugepage
Message-Id: <20100324145725.360bd13b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100324054227.GB9336@spritzerA.linux.bs1.fc.nec.co.jp>
References: <20100324054227.GB9336@spritzerA.linux.bs1.fc.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 14:42:27 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> When we look into pagemap using page-types with option -p, the value
> of pfn for hugepages looks wrong (see below.)
> This is because pte was evaluated only once for one vma
> although it should be updated for each hugepage. This patch fixes it.
> 
>   $ page-types -p 3277 -Nl -b huge
>   voffset   offset  len     flags
>   7f21e8a00 11e400  1       ___U___________H_G________________
>   7f21e8a01 11e401  1ff     ________________TG________________
>                ^^^
>   7f21e8c00 11e400  1       ___U___________H_G________________
>   7f21e8c01 11e401  1ff     ________________TG________________
>                ^^^
> 
> One hugepage contains 1 head page and 511 tail pages in x86_64 and
> each two lines represent each hugepage. Voffset and offset mean
> virtual address and physical address in the page unit, respectively.
> The different hugepages should not have the same offset value.
> 
> With this patch applied:
> 
>   $ page-types -p 3386 -Nl -b huge
>   voffset   offset   len    flags
>   7fec7a600 112c00   1      ___UD__________H_G________________
>   7fec7a601 112c01   1ff    ________________TG________________
>                ^^^
>   7fec7a800 113200   1      ___UD__________H_G________________
>   7fec7a801 113201   1ff    ________________TG________________
>                ^^^
>                OK
> 
> Changelog:
>  - add hugetlb entry walker in mm/pagewalk.c
>    (the idea based on Kamezawa-san's patch)
> 
Seems good.

More info.
 - This patch modifies walk_page_range()'s hugepage walker.
   But the change only affects pagemap_read(), it's only caller of hugepage callback.

 - Before patch, hugetlb_entry() callback is called once per pgd. Then,
   hugtlb_entry() has to walk pgd's contents by itself. 
   This caused BUG.

 - After patch, hugetlb_entry() callback is called once per hugepte entry.
   Then, callback will be much simpler.


> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/task_mmu.c |   27 +++++++--------------------
>  include/linux/mm.h |    4 ++--
>  mm/pagewalk.c      |   47 +++++++++++++++++++++++++++++++++++++----------
>  3 files changed, 46 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2a3ef17..9635f0b 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -662,31 +662,18 @@ static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
>  	return pme;
>  }
>  
> -static int pagemap_hugetlb_range(pte_t *pte, unsigned long addr,
> -				 unsigned long end, struct mm_walk *walk)
> +/* This function walks within one hugetlb entry in the single call */
> +static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
> +				 unsigned long addr, unsigned long end,
> +				 struct mm_walk *walk)
>  {
> -	struct vm_area_struct *vma;
>  	struct pagemapread *pm = walk->private;
> -	struct hstate *hs = NULL;
>  	int err = 0;
> +	u64 pfn;
>  
> -	vma = find_vma(walk->mm, addr);
> -	if (vma)
> -		hs = hstate_vma(vma);
>  	for (; addr != end; addr += PAGE_SIZE) {
> -		u64 pfn = PM_NOT_PRESENT;
> -
> -		if (vma && (addr >= vma->vm_end)) {
> -			vma = find_vma(walk->mm, addr);
> -			if (vma)
> -				hs = hstate_vma(vma);
> -		}
> -
> -		if (vma && (vma->vm_start <= addr) && is_vm_hugetlb_page(vma)) {
> -			/* calculate pfn of the "raw" page in the hugepage. */
> -			int offset = (addr & ~huge_page_mask(hs)) >> PAGE_SHIFT;
> -			pfn = huge_pte_to_pagemap_entry(*pte, offset);
> -		}
> +		int offset = (addr & ~hmask) >> PAGE_SHIFT;
> +		pfn = huge_pte_to_pagemap_entry(*pte, offset);
>  		err = add_to_pagemap(addr, pfn, pm);
>  		if (err)
>  			return err;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3899395..24f198e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -783,8 +783,8 @@ struct mm_walk {
>  	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
>  	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
>  	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
> -	int (*hugetlb_entry)(pte_t *, unsigned long, unsigned long,
> -			     struct mm_walk *);
> +	int (*hugetlb_entry)(pte_t *, unsigned long,
> +			     unsigned long, unsigned long, struct mm_walk *);
>  	struct mm_struct *mm;
>  	void *private;
>  };
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 7b47a57..f77a568 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -80,6 +80,37 @@ static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> +				       unsigned long end)
> +{
> +	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> +	return boundary < end ? boundary : end;
> +}
> +
> +static int walk_hugetlb_range(struct vm_area_struct *vma,
> +			      unsigned long addr, unsigned long end,
> +			      struct mm_walk *walk)
> +{
> +	struct hstate *h = hstate_vma(vma);
> +	unsigned long next;
> +	unsigned long hmask = huge_page_mask(h);
> +	pte_t *pte;
> +	int err = 0;
> +
> +	do {
> +		next = hugetlb_entry_end(h, addr, end);
> +		pte = huge_pte_offset(walk->mm, addr & hmask);
> +		if (pte && walk->hugetlb_entry)
> +			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
> +		if (err)
> +			return err;
> +	} while (addr = next, addr != end);
> +
> +	return err;
> +}
nitpick.

seems nicer than mine but "return 0" is ok if you add "return err" in the loop.

Thanks,
-Kame

