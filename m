Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0DGHBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:01:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49229 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab0DGHBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:01:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
In-Reply-To: <20100406195459.554265e7@annuminas.surriel.com>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com>
Message-Id: <20100407151357.FB7E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  7 Apr 2010 16:00:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When a new VMA has a mergeable anon_vma with a neighboring VMA,
> make sure all of the neighbor's old anon_vma structs are also
> linked in.
> 
> This is necessary because at some point the VMAs could get merged,
> and we want to ensure no anon_vma structs get freed prematurely,
> while the system still has anonymous pages that belong to those
> structs.

Ahhhh, I'm shame myself. sure, neighbor vma might have lots avc ;-)
few comments are blow.

> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> --- 
>  include/linux/mm.h |    2 +-
>  mm/mmap.c          |    6 +++---
>  mm/rmap.c          |   20 +++++++++++++-------
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e70f21b..90ac50e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1228,7 +1228,7 @@ extern struct vm_area_struct *vma_merge(struct mm_struct *,
>  	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
>  	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
>  	struct mempolicy *);
> -extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
> +extern struct vm_area_struct *find_mergeable_anon_vma(struct vm_area_struct *);
>  extern int split_vma(struct mm_struct *,
>  	struct vm_area_struct *, unsigned long addr, int new_below);
>  extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 75557c6..bf0600c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -832,7 +832,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>   * anon_vmas being allocated, preventing vma merge in subsequent
>   * mprotect.
>   */
> -struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
> +struct vm_area_struct *find_mergeable_anon_vma(struct vm_area_struct *vma)
>  {
>  	struct vm_area_struct *near;
>  	unsigned long vm_flags;
> @@ -855,7 +855,7 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
>  			can_vma_merge_before(near, vm_flags,
>  				NULL, vma->vm_file, vma->vm_pgoff +
>  				((vma->vm_end - vma->vm_start) >> PAGE_SHIFT)))
> -		return near->anon_vma;
> +		return near;
>  try_prev:
>  	/*
>  	 * It is potentially slow to have to call find_vma_prev here.
> @@ -875,7 +875,7 @@ try_prev:
>    			mpol_equal(vma_policy(near), vma_policy(vma)) &&
>  			can_vma_merge_after(near, vm_flags,
>  				NULL, vma->vm_file, vma->vm_pgoff))
> -		return near->anon_vma;
> +		return near;
>  none:
>  	/*
>  	 * There's no absolute need to look only at touching neighbours:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index eaa7a09..60616db 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -119,20 +119,26 @@ int anon_vma_prepare(struct vm_area_struct *vma)
>  	might_sleep();
>  	if (unlikely(!anon_vma)) {
>  		struct mm_struct *mm = vma->vm_mm;
> +		struct vm_area_struct *merge_vma;
>  		struct anon_vma *allocated;
>  
> +		merge_vma = find_mergeable_anon_vma(vma);
> +		if (merge_vma) {
> +			if (anon_vma_clone(vma, merge_vma))
> +				goto out_enomem;
> +			return 0;
> +		}
> +

Hmm.. probably I'm moron.
I'm also confusing this locking rule as same as linus said.

after this patch, new locking order are

	down_read(mmap_sem)
		anon_vma_clone(vma, merge_vma)
			list_add(&avc->same_vma, &vma->anon_vma_chain);
			spin_lock(&anon_vma->lock);
			list_add_tail(&avc->same_anon_vma, &anon_vma->head);
			spin_unlock(&anon_vma->lock);
		spin_lock(&anon_vma->lock);
		spin_lock(&mm->page_table_lock);

So, Why mmap_sem read lock can protect vma->anon_vma_chain?
An another threads seems to be able to change avc list concurrentlly and freely.

plus, Why don't we need "vma->anon_vma = merge_vma->anon_vma" assignment?
if vma->anon_vma keep NULL, I think anon_vma_prepare() call anon_vma_clone() 
multiple times.


>  		avc = anon_vma_chain_alloc();
>  		if (!avc)
>  			goto out_enomem;
>  
> -		anon_vma = find_mergeable_anon_vma(vma);
>  		allocated = NULL;
> -		if (!anon_vma) {
> -			anon_vma = anon_vma_alloc();
> -			if (unlikely(!anon_vma))
> -				goto out_enomem_free_avc;
> -			allocated = anon_vma;
> -		}
> +		anon_vma = anon_vma_alloc();
> +		if (unlikely(!anon_vma))
> +			goto out_enomem_free_avc;
> +		allocated = anon_vma;
> +
>  		spin_lock(&anon_vma->lock);
>  
>  		/* page_table_lock to protect against threads */



