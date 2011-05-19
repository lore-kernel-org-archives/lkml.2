Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab1ESVYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:24:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932665Ab1ESVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:24:33 -0400
Date: Thu, 19 May 2011 14:24:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jia zhang <jia.zhang2008@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] highmem: optimize searching for an empty entry in
 pkmap_count
Message-Id: <20110519142422.f41d9ea9.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimU2X0p=wgFEbwg_J3z3rZXPAGntw@mail.gmail.com>
References: <BANLkTimU2X0p=wgFEbwg_J3z3rZXPAGntw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011 22:50:03 +0800
jia zhang <jia.zhang2008@gmail.com> wrote:

> This patch does 2 things:
> 
> 1. Always use entry zero in the first search round.
> Entry zero of pkmap_count[] is not scanned for a searching empty entry during
> the first search round before flush_all_zero_pkmaps() gets called. This causes
> a leak in the utilization of empty entry. By moving last_pkmap_nr+1 to the end
> of map_new_virtual(), entry zero of pkmap_count[] can be used in first time.
> 
> 2. Optimize searching for an empty entry.
> To find out an empty entry depends on a good result of a linear search for
> pkmap_count[] with last_pkmap_nr as an index. By calling
> flush_all_zero_pkmaps(), more empty entries *may* be freed. Also,
> flush_all_zero_pkmaps() can give a hint of the lowest position of empty entry
> and thus make the search faster. Without this optimization, the search have
> to be continued, even though empty entry is not available at all. In addition,
> this optimization can delay the next moment of calling
> flush_all_zero_pkmaps(), unless no more empty entries are available. It is a
> case of performance improvement.

Well, the code is supposed to speed things up but we have no
measurements to show us how effective it was.  I suspect it will be
unmeasurable, but it's worth trying, please.

> diff --git a/mm/highmem.c b/mm/highmem.c
> index 693394d..0961972 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -94,7 +94,10 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
>  		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
>  #endif
> 
> -static void flush_all_zero_pkmaps(void)
> +/*
> + * Return true if we have at least one usable entry.
> + */
> +static int flush_all_zero_pkmaps(void)
>  {
>  	int i;
>  	int need_flush = 0;
> @@ -129,10 +132,19 @@ static void flush_all_zero_pkmaps(void)
>  			  &pkmap_page_table[i]);
> 
>  		set_page_address(page, NULL);
> -		need_flush = 1;
> +		/*
> +		 * Record the first or lowest usable entry to speed up
> +		 * the searching for an usable entry in map_new_virtual().
> +		 */
> +		if (!need_flush) {
> +			if (i < last_pkmap_nr || pkmap_count[last_pkmap_nr])
> +				last_pkmap_nr = i;
> +			need_flush = 1;
> +		}
>  	}
>  	if (need_flush)
>  		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
> +	return need_flush;
>  }

OK, global variable last_pkmap_nr is a bit of a crock.  We have no
documentation describing its role and we forgot to document that it's
locked by lock_kmap().  Please fix that sort of thing up when working on
the code - try to leave the kernel a better place afterwards :)

What _is_ last_pkmap_nr's role?  "The index at which to start the next
search for a free slot, minus 1", yes?  And you patch retains that, but
takes away the "minus 1", so its name is now wrong - next_pkmap_nr
would be better.  And your change to modify it in
flush_all_zero_pkmaps() as well does remain within the spirit of that,
I guess.

But still, kernel-wide globals like this are ugly and I don't think we
needed to make last_pkmap_nr handling more complex in this manner.  You
could have returned the index-of-lowest-free-slot as a return value
from flush_all_zero_pkmaps() (and documented the return value's
meaning) and the code would have been nicer.  We can then make
last_pkmap_nr (next_pkmap_nr) a static local in map_new_virtual(),
which would improve the code nicely.  That's better than worsening it!

>  /**
> @@ -148,50 +160,50 @@ void kmap_flush_unused(void)
>  static inline unsigned long map_new_virtual(struct page *page)
>  {
>  	unsigned long vaddr;
> -	int count;
> +	int nr;
> 
>  start:
> -	count = LAST_PKMAP;
>  	/* Find an empty entry */
> -	for (;;) {
> -		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
> -		if (!last_pkmap_nr) {
> -			flush_all_zero_pkmaps();
> -			count = LAST_PKMAP;
> -		}
> -		if (!pkmap_count[last_pkmap_nr])
> -			break;	/* Found a usable entry */
> -		if (--count)
> -			continue;
> +	for (nr = last_pkmap_nr; nr < LAST_PKMAP; nr++) {
> +		if (!pkmap_count[nr])
> +			goto found;
> +	}
> +	last_pkmap_nr = nr;
> 
> +	/* Try to get an empty entry to avoid sleep */
> +	if (!flush_all_zero_pkmaps()) {
>  		/*
>  		 * Sleep for somebody else to unmap their entries
>  		 */
> -		{
> -			DECLARE_WAITQUEUE(wait, current);
> -
> -			__set_current_state(TASK_UNINTERRUPTIBLE);
> -			add_wait_queue(&pkmap_map_wait, &wait);
> -			unlock_kmap();
> -			schedule();
> -			remove_wait_queue(&pkmap_map_wait, &wait);
> -			lock_kmap();
> -
> -			/* Somebody else might have mapped it while we slept */
> -			if (page_address(page))
> -				return (unsigned long)page_address(page);
> -
> -			/* Re-start */
> -			goto start;
> -		}
> +		DECLARE_WAITQUEUE(wait, current);
> +
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		add_wait_queue(&pkmap_map_wait, &wait);
> +		unlock_kmap();
> +		schedule();
> +		remove_wait_queue(&pkmap_map_wait, &wait);
> +		lock_kmap();
> +
> +		/* Somebody else might have mapped it while we slept */
> +		if (!page_address(page))
> +			return (unsigned long)page_address(page);
> +
> +		/* Re-start */
> +		goto start;
>  	}
> -	vaddr = PKMAP_ADDR(last_pkmap_nr);
> +	/* Really get it */
> +	nr = last_pkmap_nr;

OK.  I was worried that we might end up with nr==LAST_PKMAP here, but
that can't happen because flush_all_zero_pkmaps() would have returned
zero.  All rather messy.

> +found:
> +	vaddr = PKMAP_ADDR(nr);
>  	set_pte_at(&init_mm, vaddr,
> -		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
> +		   &(pkmap_page_table[nr]), mk_pte(page, kmap_prot));
> 
> -	pkmap_count[last_pkmap_nr] = 1;
> +	pkmap_count[nr] = 1;
>  	set_page_address(page, (void *)vaddr);
> 
> +	last_pkmap_nr = (nr + 1) & LAST_PKMAP_MASK;

The `& LAST_PKMAP_MASK' isn't actually needed, I think.  In fact if we
_remove_ the masking, the code becomes more efficient: the next caller
to map_new_virtual() won't pointlessly walk the entire array.  I think.

And if we do this, it changes the semantics of last_pkmap_nr: it now
has values from 0 to LAST_PKMAP inclusive.  This should be mentioned in
the comment which describes last_pkmap_nr.


>  	return vaddr;
>  }

