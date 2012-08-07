Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2HGCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:09:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63669 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2HGCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:09:23 -0400
Date: Mon, 6 Aug 2012 19:08:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Hillf Danton <dhillf@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch] mmap: permute find_vma with find_vma_prev
In-Reply-To: <CAJd=RBB2Hsqnn58idvs5azMonRhk0A6EOKZ=tTskRngGk=XCOw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1208061831490.1509@eggly.anvils>
References: <CAJd=RBB2Hsqnn58idvs5azMonRhk0A6EOKZ=tTskRngGk=XCOw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Hillf Danton wrote:

> Both find_vma and find_vma_prev have code for walking rb tree, and we can
> walk less.
> 
> To cut the walk in find_vma_prev off, find_vma is changed to take care of
> vm_prev while walking rb tree, and we end up wrapping find_vma_prev with
> find_vma.

No thank you.

Please take a look at what uses find_vma_prev() and what uses find_vma()
nowadays - since Linus added vma->vm_prev, and Kosaki-san and Mikulas
Patocka rewrote find_vma_prev() to use find_vma().

Almost nothing uses find_vma_prev(): parisc (stack grows upwards) and
ia64 (register backing store grows upwards) have particular need for it
(when they want to know the vm_prev of top of memory).  madvise and tile
are still using it, but I expect should just be converted to find_vma().

And rarely is its prev search actually required.  Whereas there are lots
of users of find_vma(), who want it to be as quick as possible: it should
not be burdened with almost-never-needed extras.

When he has a moment, Kosaki-san intends to remove find_vma_prev()
altogether, replacing it by find_last_vma() for parisc and ia64.

> 
> btw, what happened to LKML?

I don't know what you're referring to: what happened to LKML?

Hugh

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/mmap.c	Fri Aug  3 07:38:10 2012
> +++ b/mm/mmap.c	Mon Aug  6 20:10:18 2012
> @@ -1602,11 +1602,18 @@ get_unmapped_area(struct file *file, uns
> 
>  EXPORT_SYMBOL(get_unmapped_area);
> 
> -/* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
> -struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
> +/*
> + * Look up the first VMA which satisfies  addr < vm_end,  NULL if none.
> + * Also return a pointer to the previous VMA.
> + */
> +struct vm_area_struct *
> +find_vma_prev(struct mm_struct *mm, unsigned long addr,
> +			struct vm_area_struct **pprev)
>  {
>  	struct vm_area_struct *vma = NULL;
> 
> +	*pprev = NULL; /* Should be removed with WARN_ON_ONCE(!mm) */
> +
>  	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
>  		return NULL;
> 
> @@ -1630,39 +1637,29 @@ struct vm_area_struct *find_vma(struct m
>  				if (vma_tmp->vm_start <= addr)
>  					break;
>  				rb_node = rb_node->rb_left;
> -			} else
> +			} else {
>  				rb_node = rb_node->rb_right;
> +				*pprev = vma_tmp;
> +			}
>  		}
> -		if (vma)
> +		if (vma) {
>  			mm->mmap_cache = vma;
> +			/* remove false positive produced while walking rb tree */
> +			*pprev = vma->vm_prev;
> +		}
> +	} else {
> +		*pprev = vma->vm_prev;
>  	}
>  	return vma;
>  }
> 
> -EXPORT_SYMBOL(find_vma);
> -
> -/*
> - * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
> - */
> -struct vm_area_struct *
> -find_vma_prev(struct mm_struct *mm, unsigned long addr,
> -			struct vm_area_struct **pprev)
> +struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
>  {
> -	struct vm_area_struct *vma;
> +	struct vm_area_struct *prev;
> 
> -	vma = find_vma(mm, addr);
> -	if (vma) {
> -		*pprev = vma->vm_prev;
> -	} else {
> -		struct rb_node *rb_node = mm->mm_rb.rb_node;
> -		*pprev = NULL;
> -		while (rb_node) {
> -			*pprev = rb_entry(rb_node, struct vm_area_struct, vm_rb);
> -			rb_node = rb_node->rb_right;
> -		}
> -	}
> -	return vma;
> +	return find_vma_prev(mm, addr, &prev);
>  }
> +EXPORT_SYMBOL(find_vma);
> 
>  /*
>   * Verify that the stack growth is acceptable and
> --
