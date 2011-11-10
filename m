Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab1KJAxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:53:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933479Ab1KJAxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:53:12 -0500
Date: Thu, 10 Nov 2011 00:53:07 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111110005307.GC3083@suse.de>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111109180646.GM5075@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 07:06:46PM +0100, Andrea Arcangeli wrote:
> On Wed, Nov 09, 2011 at 05:52:01PM +0000, Mel Gorman wrote:
> > -#define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
> > -	alloc_pages(gfp_mask, order)
> > +#define alloc_pages_vma(gfp_mask, order, vma, addr, node, drop_mmapsem)	\
> > +	({ 								\
> > +		if (drop_mmapsem)					\
> > +			up_read(&vma->vm_mm->mmap_sem);			\
> > +		alloc_pages(gfp_mask, order);				\
> > +	})
> 
> I wouldn't change alloc_pages_vma. I think it's better to add and have
> that called only by khugepaged:
> 
> alloc_pages_vma_up_read(gfp_mask, order, vma, addr, node)
> {
> 	__alloc_pages_vma(gfp_mask, order, vma, addr, node, true);
> }
> 
> alloc_pages_vma(gfp_mask, order, vma, addr, node)
> {
> 	__alloc_pages_vma(gfp_mask, order, vma, addr, node, false);
> }
> 

Yeah it would. I thought that myself after adjusting the
alloc_pages_vma() function but hadn't gone back to it. The "bodge" was
only written earlier.

> I wonder if a change like this would be enough?
> 
>        sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
> 

Sure it does and in fact this is patch 1 of 2 and it reduced all the
THP related stalls for me. The number of THPs were reduced though
because khugepaged was no longer using sync compaction hence patch
2 which altered alloc_pages_vma. This was testing on CONFIG_NUMA so
testing for PF_KTHREAD would be insufficient as khugepaged would call
sync compaction with the mmap_sem held causing indirect stalls.

> But even if hidden in a new function, the main downside overall is the
> fact we'll pass one more var through the stack of fast paths.
> 

Unfortunate but the alternative is not allowing khugepaged to use sync
compaction. Are you ok with that? The number of THPs in use was reduced
but it also was during a somewhat unrealistic stress test so it might
not matter.

> Johannes I recall you reported this too and Mel suggested the above
> change, did it help in the end?
> 
> Your change in khugepaged context makes perfect sense anyway, just we
> should be sure it's really needed before adding more variables in fast
> path I think.

It's not really needed to avoid stalls - just !(gfp_mask &
__GFP_NO_KSWAPD) is enough for that. It's only needed if we want
khugepaged to continue using sync compaction without stalling processes
due to holding mmap_sem.

-- 
Mel Gorman
SUSE Labs
