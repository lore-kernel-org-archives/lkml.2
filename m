Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2FVVGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:06:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60616 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2FVVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:06:43 -0400
Date: Fri, 22 Jun 2012 14:06:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] mm, thp: print useful information when mmap_sem is
 unlocked in zap_pmd_range
In-Reply-To: <alpine.DEB.2.00.1206110214150.6843@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1206221405430.20954@chino.kir.corp.google.com>
References: <20120606165330.GA27744@redhat.com> <alpine.DEB.2.00.1206091904030.7832@chino.kir.corp.google.com> <alpine.DEB.2.00.1206110214150.6843@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, David Rientjes wrote:

> diff --git a/mm/memory.c b/mm/memory.c
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1225,7 +1225,15 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  		next = pmd_addr_end(addr, end);
>  		if (pmd_trans_huge(*pmd)) {
>  			if (next - addr != HPAGE_PMD_SIZE) {
> -				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
> +#ifdef CONFIG_DEBUG_VM
> +				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
> +					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
> +						__func__, addr, end,
> +						vma->vm_start,
> +						vma->vm_end);
> +					BUG();
> +				}
> +#endif
>  				split_huge_page_pmd(vma->vm_mm, pmd);
>  			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
>  				goto next;

This patch is now in Linus' tree so if you are able to hit this issue and 
capture it again, we should be able to get much more useful information.
