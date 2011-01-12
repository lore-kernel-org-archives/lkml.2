Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1ALJ2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:28:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56820 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1ALJ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:28:35 -0500
Date: Wed, 12 Jan 2011 09:28:12 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        hughd@google.com
Subject: Re: +
	mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclai
	m-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compacti
	on-fix.patch added to -mm tree
Message-ID: <20110112092812.GH11932@csn.ul.ie>
References: <201101112046.p0BKk2Js005902@imap1.linux-foundation.org> <alpine.DEB.2.00.1101111341590.7551@chino.kir.corp.google.com> <20110111135547.ce6c273c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110111135547.ce6c273c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:55:47PM -0800, Andrew Morton wrote:
> On Tue, 11 Jan 2011 13:43:06 -0800 (PST)
> David Rientjes <rientjes@google.com> wrote:
> 
> > On Tue, 11 Jan 2011, akpm@linux-foundation.org wrote:
> > 
> > > diff -puN mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix mm/page_alloc.c
> > > --- a/mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix
> > > +++ a/mm/page_alloc.c
> > > @@ -1815,15 +1815,15 @@ __alloc_pages_direct_compact(gfp_t gfp_m
> > >  	int migratetype, unsigned long *did_some_progress)
> > >  {
> > >  	struct page *page;
> > > -	struct task_struct *p = current;
> > > +	struct task_struct *tsk = current;
> > >  
> > >  	if (!order || compaction_deferred(preferred_zone))
> > >  		return NULL;
> > >  
> > > -	p->flags |= PF_MEMALLOC;
> > > +	tsk->flags |= PF_MEMALLOC;
> > >  	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
> > >  								nodemask);
> > > -	p->flags &= ~PF_MEMALLOC;
> > > +	tsk->flags &= ~PF_MEMALLOC;
> > >  	if (*did_some_progress != COMPACT_SKIPPED) {
> > >  
> > >  		/* Page migration frees to the PCP lists but we want merging */
> > 
> > This could be done for all of the page allocator functions in 
> > mm/page_alloc.c, I think it would be inconsistent and slightly harder to 
> > read if it were done in only one.
> 
> Using "p" for any identifier which has less-than-teeny scope is plain
> dumb.  It's meaningless and useless.
> 
> Anyway...
> 
> 
> Subject: mm/page_alloc.c: don't cache `current' in a local
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> It's old-fashioned and unneeded.
> 
> akpm:/usr/src/25> size mm/page_alloc.o
>    text    data     bss     dec     hex filename
>   39884 1241317   18808 1300009  13d629 mm/page_alloc.o (before)
>   39838 1241317   18808 1299963  13d5fb mm/page_alloc.o (after)
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks spot on. The slight text saving is a bonus and I imagine there are
small savings on stack usage as well.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
