Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1BVNhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:37:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1BVNhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:37:33 -0500
Date: Tue, 22 Feb 2011 14:35:20 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
Message-ID: <20110222133520.GS13092@random.random>
References: <20110222015338.309727CA@kernel>
 <20110222015343.41586948@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222015343.41586948@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 05:53:43PM -0800, Dave Hansen wrote:
> @@ -385,8 +387,25 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	pte_t *pte;
>  	spinlock_t *ptl;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> -
> +	spin_lock(&walk->mm->page_table_lock);
> +	if (pmd_trans_huge(*pmd)) {
> +		if (pmd_trans_splitting(*pmd)) {
> +			spin_unlock(&walk->mm->page_table_lock);
> +			wait_split_huge_page(vma->anon_vma, pmd);
> +		} else {
> +			smaps_pte_entry(*(pte_t *)pmd, addr,
> +					HPAGE_PMD_SIZE, walk);
> +			spin_unlock(&walk->mm->page_table_lock);
> +			return 0;
> +		}
> +	} else {
> +		spin_unlock(&walk->mm->page_table_lock);
> +	}
> +	/*
> +	 * The mmap_sem held all the way back in m_start() is what
> +	 * keeps khugepaged out of here and from collapsing things
> +	 * in here.
> +	 */

This time the locking is right and HPAGE_PMD_SIZE is used instead of
HPAGE_SIZE, thanks! I think all 5 patches can go in -mm and upstream
anytime (not mandatory for 2.6.38 but definitely we want this for
2.6.39).

BTW, Andi in his NUMA THP improvement series added a THP_SPLIT vmstat
per-cpu counter so that part removed from his series, is taken care by
him.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
