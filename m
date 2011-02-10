Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1BJSIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab1BJSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:08:19 -0500
Date: Thu, 10 Feb 2011 19:08:02 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
Message-ID: <20110210180801.GA3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
 <20110209195411.816D55A7@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209195411.816D55A7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:54:11AM -0800, Dave Hansen wrote:
> @@ -385,8 +387,16 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	pte_t *pte;
>  	spinlock_t *ptl;
>  
> -	split_huge_page_pmd(walk->mm, pmd);
> -
> +	if (pmd_trans_huge(*pmd)) {
> +		if (pmd_trans_splitting(*pmd)) {
> +			spin_unlock(&walk->mm->page_table_lock);
> +			wait_split_huge_page(vma->anon_vma, pmd);
> +			spin_lock(&walk->mm->page_table_lock);

the locking looks wrong, who is taking the &walk->mm->page_table_lock,
and isn't this going to deadlock on the pte_offset_map_lock for
NR_CPUS < 4, and where is it released? This spin_lock don't seem
necessary to me.

The right locking would be:

 spin_lock(&walk->mm->page_table_lock);
 if (pmd_trans_huge(*pmd)) {
   if (pmd_trans_splitting(*pmd)) {
    spin_unlock(&walk->mm->page_table_lock);
    wait_split_huge_page(vma->anon_vma, pmd);
   } else {
    smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
    spin_unlock(&walk->mm->page_table_lock);
    return 0;
  }

I think it worked because you never run into a pmd_trans_splitting pmd
yet, and you were running smaps_pte_entry lockless which could race
against split_huge_page (but it normally doesn't).

> +		} else {
> +			smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> +			return 0;
> +		}
> +	}
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE)
>  		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
> _
> 
