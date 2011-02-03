Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1BCVCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:02:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab1BCVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:02:40 -0500
Date: Thu, 3 Feb 2011 13:01:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rohit Seth <rohit.seth@intel.com>
Subject: Re: [PATCH] Huge TLB: Potential NULL deref in
 arch/x86/mm/hugetlbpage.c:huge_pmd_share()
Message-Id: <20110203130150.7031c61f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1102032142580.15101@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102032142580.15101@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 21:50:04 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> In arch/x86/mm/hugetlbpage.c:huge_pmd_share() we call find_vma(mm, addr) 
> and then subsequently dereference the pointer returned without checking if 
> it was NULL. I can't find anything that guarantees that find_vma() will 
> never return NULL in this case, so I believe there's a genuine bug. 
> However, I'd greatly appreciate it if someone would take the time to 
> double check me.
> This patch implements what I believe to be the correct handling of a NULL 
> return from find_vma(). Please consider for inclusion.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  hugetlbpage.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 069ce7c..0ebd3d0 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -61,14 +61,19 @@ static int vma_shareable(struct vm_area_struct *vma, unsigned long addr)
>  static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
>  {
>  	struct vm_area_struct *vma = find_vma(mm, addr);
> -	struct address_space *mapping = vma->vm_file->f_mapping;
> -	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
> -			vma->vm_pgoff;
> +	struct address_space *mapping;
> +	pgoff_t idx;
>  	struct prio_tree_iter iter;
>  	struct vm_area_struct *svma;
>  	unsigned long saddr;
>  	pte_t *spte = NULL;
>  
> +	if (!vma)
> +		return;
> +
> +	mapping = vma->vm_file->f_mapping;
> +	idx = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> +
>  	if (!vma_shareable(vma, addr))
>  		return;

mmap_sem is held and the caller (copy_hugetlb_page_range) knows that
the virtual address at `addr' is within a vma.  So it's a "can't happen".

The code's all undocumented and you got fooled.  Cause, effect.
