Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1EJAUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:20:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1EJAUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:20:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 2/8] mm: use walk_page_range() instead of custom page table walking code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110509193650.GA2865@wicker.gateway.2wire.net>
References: <20110509164034.164C.A69D9226@jp.fujitsu.com> <20110509193650.GA2865@wicker.gateway.2wire.net>
Message-Id: <20110510092219.168E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 10 May 2011 09:20:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, May 09, 2011 at 04:38:49PM +0900, KOSAKI Motohiro wrote:
> > Hello,
> > 
> > sorry for the long delay.
> 
> Please, no apologies.  Thank you for the review!
> 
> > > In the specific case of show_numa_map(), the custom page table walking
> > > logic implemented in mempolicy.c does not provide any special service
> > > beyond that provided by walk_page_range().
> > > 
> > > Also, converting show_numa_map() to use the generic routine decouples
> > > the function from mempolicy.c, allowing it to be moved out of the mm
> > > subsystem and into fs/proc.
> > > 
> > > Signed-off-by: Stephen Wilson <wilsons@start.ca>
> > > ---
> > >  mm/mempolicy.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++-------
> > >  1 files changed, 46 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 5bfb03e..dfe27e3 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -2568,6 +2568,22 @@ static void gather_stats(struct page *page, void *private, int pte_dirty)
> > >  	md->node[page_to_nid(page)]++;
> > >  }
> > >  
> > > +static int gather_pte_stats(pte_t *pte, unsigned long addr,
> > > +		unsigned long pte_size, struct mm_walk *walk)
> > > +{
> > > +	struct page *page;
> > > +
> > > +	if (pte_none(*pte))
> > > +		return 0;
> > > +
> > > +	page = pte_page(*pte);
> > > +	if (!page)
> > > +		return 0;
> > 
> > original check_pte_range() has following logic.
> > 
> >         orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> >         do {
> >                 struct page *page;
> >                 int nid;
> > 
> >                 if (!pte_present(*pte))
> >                         continue;
> >                 page = vm_normal_page(vma, addr, *pte);
> >                 if (!page)
> >                         continue;
> >                 /*
> >                  * vm_normal_page() filters out zero pages, but there might
> >                  * still be PageReserved pages to skip, perhaps in a VDSO.
> >                  * And we cannot move PageKsm pages sensibly or safely yet.
> >                  */
> >                 if (PageReserved(page) || PageKsm(page))
> >                         continue;
> >                 gather_stats(page, private, pte_dirty(*pte));
> > 
> > Why did you drop a lot of check? Is it safe?
> 
> I must have been confused.  For one, walk_page_range() does not even
> lock the pmd entry when iterating over the pte's.  I completely
> overlooked that fact and so with that, the series is totally broken.
> 
> I am currently testing a slightly reworked set based on the following
> variation.  When finished I will send v2 of the series which will
> address all issues raised so far.
> 
> Thanks again for the review!
> 
> 
> 
> From 013a1e0fc96f8370339209f16d81df4ded40dbf2 Mon Sep 17 00:00:00 2001
> From: Stephen Wilson <wilsons@start.ca>
> Date: Mon, 9 May 2011 14:39:27 -0400
> Subject: [PATCH] mm: use walk_page_range() instead of custom page table
>  walking code
> 
> Converting show_numa_map() to use the generic routine decouples
> the function from mempolicy.c, allowing it to be moved out of the mm
> subsystem and into fs/proc.
> 
> Also, include KSM pages in /proc/pid/numa_maps statistics.  The pagewalk
> logic implemented by check_pte_range() failed to account for such pages
> as they were not applicable to the page migration case.

Seems very reasonable change.

> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  mm/mempolicy.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 5bfb03e..945e85d 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2531,6 +2531,7 @@ int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
>  }
>  
>  struct numa_maps {
> +	struct vm_area_struct *vma;
>  	unsigned long pages;
>  	unsigned long anon;
>  	unsigned long active;
> @@ -2568,6 +2569,41 @@ static void gather_stats(struct page *page, void *private, int pte_dirty)
>  	md->node[page_to_nid(page)]++;
>  }
>  
> +static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
> +		unsigned long end, struct mm_walk *walk)
> +{
> +	struct numa_maps *md;
> +	spinlock_t *ptl;
> +	pte_t *orig_pte;
> +	pte_t *pte;
> +
> +	md = walk->private;
> +	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	do {
> +		struct page *page;
> +		int nid;
> +
> +		if (!pte_present(*pte))
> +			continue;
> +
> +		page = vm_normal_page(md->vma, addr, *pte);
> +		if (!page)
> +			continue;
> +
> +		if (PageReserved(page))
> +			continue;
> +
> +		nid = page_to_nid(page);
> +		if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
> +			continue;
> +
> +		gather_stats(page, md, pte_dirty(*pte));
> +
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	pte_unmap_unlock(orig_pte, ptl);
> +	return 0;
> +}


Looks completely good.
	Reviewed-by KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thank you for great work!



