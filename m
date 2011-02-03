Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1BCVWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:22:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1BCVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=d33NS3WO5Eex9QMCxKcnuFTrJJjTAIrR2xOdJGEdv1MFx7Qapvao4rMGyrmwp+ILSK
         DLCD42Kgh9NfnibRPocw==
Date: Thu, 3 Feb 2011 13:22:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
In-Reply-To: <20110201003403.736A24DF@kernel>
Message-ID: <alpine.DEB.2.00.1102031319070.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel> <20110201003403.736A24DF@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Dave Hansen wrote:

> 
> This adds code to explicitly detect  and handle
> pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
> in to the smap_pte_entry() function instead of PAGE_SIZE.
> 
> This means that using /proc/$pid/smaps now will no longer
> cause THPs to be broken down in to small pages.
> 

Nice!

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

Small nitpick: the label isn't necessary, just use an else-clause on your 
nested conditional.

>  	split_huge_page_pmd(walk->mm, pmd);
>  
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> diff -puN mm/vmscan.c~teach-smaps_pte_range-about-thp-pmds mm/vmscan.c
> diff -puN include/trace/events/vmscan.h~teach-smaps_pte_range-about-thp-pmds include/trace/events/vmscan.h
> diff -puN mm/pagewalk.c~teach-smaps_pte_range-about-thp-pmds mm/pagewalk.c
> diff -puN mm/huge_memory.c~teach-smaps_pte_range-about-thp-pmds mm/huge_memory.c
> diff -puN mm/memory.c~teach-smaps_pte_range-about-thp-pmds mm/memory.c
> diff -puN include/linux/huge_mm.h~teach-smaps_pte_range-about-thp-pmds include/linux/huge_mm.h
> diff -puN mm/internal.h~teach-smaps_pte_range-about-thp-pmds mm/internal.h
> _

What are all these?
