Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2CZVIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:08:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55165 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2CZVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:08:29 -0400
Date: Mon, 26 Mar 2012 14:08:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmap.c: find_vma: replace if(mm) check with
 BUG_ON(!mm)
In-Reply-To: <1332777965-2534-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.LSU.2.00.1203261346360.3443@eggly.anvils>
References: <1332777965-2534-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012, Kautuk Consul wrote:
> find_vma is called from kernel code where it is absolutely
> sure that the mm_struct arg being passed to it is non-NULL.
> 
> Convert the if check to a BUG_ON.
> This will also serve the purpose of mandating that the execution
> context(user-mode/kernel-mode) be known before find_vma is called.
> 
> Also fixed 2 checkpatch.pl errors in this function for the rb_node
> and vma_tmp local variables.
> 
> I have tested this patch on my x86 PC and there are no BUG_ON crashes
> due to this in the course of normal desktop execution.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

That seems very reasonable: perhaps there was a reason for checking
find_vma()'s mm way back in the distant past, but I cannot see it now.
But please make two small changes noted below before resubmitting.

Since we ask for mm->mmap_sem to be held before calling find_vma(),
it's hard to reach here with NULL mm.  There are a few strange places
in arch and drivers/media/video which appear to be taking risks by
not holding mmap_sem, but only one of them looks like it _might_ be
endangered by your change.

Ralf, that octeon_flush_cache_sigtramp() in arch/mips/mm/c-octeon.c:
is there ever a danger that it can be called with NULL current->mm?  Is
current->mm set to &init_mm in the initial call from octeon_cache_init()?

> ---
>  mm/mmap.c |   52 ++++++++++++++++++++++++++--------------------------
>  1 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index a7bf6a3..7589965 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1589,33 +1589,33 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>  {
>  	struct vm_area_struct *vma = NULL;

Please remove the " = NULL": vma is immediately set to mm->mmap_cache.

>  
> -	if (mm) {
> -		/* Check the cache first. */
> -		/* (Cache hit rate is typically around 35%.) */
> -		vma = mm->mmap_cache;
> -		if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
> -			struct rb_node * rb_node;
> -
> -			rb_node = mm->mm_rb.rb_node;
> -			vma = NULL;
> -
> -			while (rb_node) {
> -				struct vm_area_struct * vma_tmp;
> -
> -				vma_tmp = rb_entry(rb_node,
> -						struct vm_area_struct, vm_rb);
> -
> -				if (vma_tmp->vm_end > addr) {
> -					vma = vma_tmp;
> -					if (vma_tmp->vm_start <= addr)
> -						break;
> -					rb_node = rb_node->rb_left;
> -				} else
> -					rb_node = rb_node->rb_right;
> -			}
> -			if (vma)
> -				mm->mmap_cache = vma;
> +	BUG_ON(!mm);

And please remove the BUG_ON(!mm): it's a waste of space and time,
it gives very little value over the easily recognizable oops we
shall get from "vma = mm->mmap_cache" with NULL mm.

Thanks,
Hugh

> +
> +	/* Check the cache first. */
> +	/* (Cache hit rate is typically around 35%.) */
> +	vma = mm->mmap_cache;
> +	if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
> +		struct rb_node *rb_node;
> +
> +		rb_node = mm->mm_rb.rb_node;
> +		vma = NULL;
> +
> +		while (rb_node) {
> +			struct vm_area_struct *vma_tmp;
> +
> +			vma_tmp = rb_entry(rb_node,
> +					struct vm_area_struct, vm_rb);
> +
> +			if (vma_tmp->vm_end > addr) {
> +				vma = vma_tmp;
> +				if (vma_tmp->vm_start <= addr)
> +					break;
> +				rb_node = rb_node->rb_left;
> +			} else
> +				rb_node = rb_node->rb_right;
>  		}
> +		if (vma)
> +			mm->mmap_cache = vma;
>  	}
>  	return vma;
>  }
> -- 
> 1.7.5.4
