Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab1BAKLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:11:15 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57371 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1BAKLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:11:14 -0500
Date: Tue, 1 Feb 2011 11:11:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
Message-ID: <20110201101111.GK19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003403.736A24DF@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201003403.736A24DF@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:34:03PM -0800, Dave Hansen wrote:
> 
> This adds code to explicitly detect  and handle
> pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
> in to the smap_pte_entry() function instead of PAGE_SIZE.
> 
> This means that using /proc/$pid/smaps now will no longer
> cause THPs to be broken down in to small pages.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/proc/task_mmu.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff -puN fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds fs/proc/task_mmu.c
> --- linux-2.6.git/fs/proc/task_mmu.c~teach-smaps_pte_range-about-thp-pmds	2011-01-31 15:10:55.387856566 -0800
> +++ linux-2.6.git-dave/fs/proc/task_mmu.c	2011-01-31 15:25:12.231239775 -0800
> @@ -1,5 +1,6 @@
>  #include <linux/mm.h>
>  #include <linux/hugetlb.h>
> +#include <linux/huge_mm.h>
>  #include <linux/mount.h>
>  #include <linux/seq_file.h>
>  #include <linux/highmem.h>
> @@ -385,6 +386,17 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	pte_t *pte;
>  	spinlock_t *ptl;
>  
> +	if (pmd_trans_huge(*pmd)) {
> +		if (pmd_trans_splitting(*pmd)) {
> +			spin_unlock(&walk->mm->page_table_lock);
> +			wait_split_huge_page(vma->anon_vma, pmd);
> +			spin_lock(&walk->mm->page_table_lock);
> +			goto normal_ptes;
> +		}
> +		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> +		return 0;
> +	}
> +normal_ptes:
>  	split_huge_page_pmd(walk->mm, pmd);

This line can go away now...?

Looks good to me, otherwise.
