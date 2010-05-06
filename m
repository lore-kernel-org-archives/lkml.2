Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab0EFQDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:03:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258Ab0EFQDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:03:04 -0400
Date: Thu, 6 May 2010 08:59:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
In-Reply-To: <1273159987-10167-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005060840360.901@i5.linux-foundation.org>
References: <1273159987-10167-1-git-send-email-mel@csn.ul.ie> <1273159987-10167-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 May 2010, Mel Gorman wrote:
> +		anon_vma = anon_vma_lock_root(anon_vma);
>  		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
>  			vma = vmac->vma;
> +
> +			locked_vma = NULL;
> +			if (anon_vma != vma->anon_vma) {
> +				locked_vma = vma->anon_vma;
> +				spin_lock_nested(&locked_vma->lock, SINGLE_DEPTH_NESTING);
> +			}
> +
>  			if (rmap_item->address < vma->vm_start ||
>  			    rmap_item->address >= vma->vm_end)
> +				goto next_vma;
> +
>  			/*
>  			 * Initially we examine only the vma which covers this
>  			 * rmap_item; but later, if there is still work to do,
> @@ -1684,9 +1693,14 @@ again:
>  			 * were forked from the original since ksmd passed.
>  			 */
>  			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
> +				goto next_vma;
>  
>  			ret = rmap_one(page, vma, rmap_item->address, arg);
> +
> +next_vma:
> +			if (locked_vma)
> +				spin_unlock(&locked_vma->lock);
> +
>  			if (ret != SWAP_AGAIN) {
>  				spin_unlock(&anon_vma->lock);
>  				goto out;

[ Removed '-' lines to show the actual end result ]

That loop is f*cked up.

In the "goto next_vma" case, it will then test the 'ret' from the 
_previous_ iteration after having unlocked the anon_vma. Which may not 
even exist, if this is the first one.

Yes, yes, 'ret' is initialized to SWAP_AGAIN, so it will work, but it's 
still screwed up. It's just _waiting_ for bugs to be introduced.

Just make the "goto out" case unlock thngs properly. Have a real exclusive 
error return case that does

		/* normal return */
		return SWAP_AGAIN;

	out:
		if (locked_anon_vma)
			spin_unlock(&locked_anon_vma->lock);
		spin_unlock(&anon_vma->lock);
		return ret;

rather than that horrible crud in the loop itself.

Also, wouldn't it be nicer to make the whole "locked_vma" be something you 
do at the head of the loop, so that you can use "continue" instead of 
"goto next_vma". And then you can do it like this:

	locked_anon_vma = lock_nested_anon_vma(locked_anon_vma, vma->anon_vma, anon_vma);

where we have

   static struct anon_vma *lock_nested_anon_vma(struct anon_vma_struct anon_vma *prev,
	 struct anon_vma *next, struct anon_vma *root)
   {
	if (prev)
		spin_unlock(&prev->lock);
	if (next == root)
		return NULL;
	spin_lock_nested(&next->lock, SINGLE_DEPTH_NESTING);
	return next;
   }

isn't that _much_ nicer? You get to split the locking off into a function 
of its own, and you unlock the old one before you (potentially) lock the 
new one, _and_ you can just use "continue" to go to the next iteration.

Yes, yes, it means that after the loop you have to unlock that 
'locked_anon_vma', but you have to do that for the early exit case 
_anyway_, so that won't look all that odd. It will certainly look less odd 
than using a status variable from the previous iteration and depending on 
it having a special value.

		Linus
