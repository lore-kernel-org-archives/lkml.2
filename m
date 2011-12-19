Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LSSsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:48:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61764 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1LSSsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:48:20 -0500
Date: Mon, 19 Dec 2011 10:48:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/3] pagemap: avoid splitting thp when reading
 /proc/pid/pagemap
In-Reply-To: <1324319919-31720-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1112191044300.19949@chino.kir.corp.google.com>
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Naoya Horiguchi wrote:

> diff --git 3.2-rc5.orig/fs/proc/task_mmu.c 3.2-rc5/fs/proc/task_mmu.c
> index e418c5a..90c4b7a 100644
> --- 3.2-rc5.orig/fs/proc/task_mmu.c
> +++ 3.2-rc5/fs/proc/task_mmu.c
> @@ -600,6 +600,9 @@ struct pagemapread {
>  	u64 *buffer;
>  };
>  
> +#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
> +#define PAGEMAP_WALK_MASK	(PMD_MASK)
> +
>  #define PM_ENTRY_BYTES      sizeof(u64)
>  #define PM_STATUS_BITS      3
>  #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
> @@ -658,6 +661,22 @@ static u64 pte_to_pagemap_entry(pte_t pte)
>  	return pme;
>  }
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static u64 thp_pte_to_pagemap_entry(pte_t pte, int offset)
> +{
> +	u64 pme = 0;
> +	if (pte_present(pte))
> +		pme = PM_PFRAME(pte_pfn(pte) + offset)
> +			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
> +	return pme;
> +}
> +#else
> +static inline u64 thp_pte_to_pagemap_entry(pte_t pte, int offset)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			     struct mm_walk *walk)
>  {
> @@ -666,10 +685,33 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	int err = 0;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> -
>  	/* find the first VMA at or above 'addr' */
>  	vma = find_vma(walk->mm, addr);
> +
> +	spin_lock(&walk->mm->page_table_lock);

pagemap_pte_range() could potentially be called a _lot_, so I'd recommend 
optimizing this by checking for pmd_trans_huge() prior to taking 
page_table_lock and then rechecking after grabbing it with likely().

> +	if (pmd_trans_huge(*pmd)) {
> +		if (pmd_trans_splitting(*pmd)) {
> +			spin_unlock(&walk->mm->page_table_lock);
> +			wait_split_huge_page(vma->anon_vma, pmd);
> +		} else {
> +			u64 pfn = PM_NOT_PRESENT;

This doesn't need to be initialized and it would probably be better to 
declare "pfn" at the top-level of this function since it's later used for 
the non-thp case.

> +
> +			for (; addr != end; addr += PAGE_SIZE) {
> +				int offset = (addr & ~PAGEMAP_WALK_MASK)
> +					>> PAGE_SHIFT;
> +				pfn = thp_pte_to_pagemap_entry(*(pte_t *)pmd,
> +							       offset);
> +				err = add_to_pagemap(addr, pfn, pm);
> +				if (err)
> +					break;
> +			}
> +			spin_unlock(&walk->mm->page_table_lock);
> +			return err;
> +		}
> +	} else {
> +		spin_unlock(&walk->mm->page_table_lock);
> +	}
> +
>  	for (; addr != end; addr += PAGE_SIZE) {
>  		u64 pfn = PM_NOT_PRESENT;
>  
> @@ -754,8 +796,6 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
>   * determine which areas of memory are actually mapped and llseek to
>   * skip over unmapped regions.
>   */
> -#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
> -#define PAGEMAP_WALK_MASK	(PMD_MASK)
>  static ssize_t pagemap_read(struct file *file, char __user *buf,
>  			    size_t count, loff_t *ppos)
>  {
