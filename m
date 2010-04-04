Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0DDX0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:26:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0DDX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:26:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BGqHIll9/n5Ko34dAEWAdtipzf49zHgemPiEesAD9bRw0KC3JJzvjrR2L4UtDImfq
	3YFxVEJwbguqapSGA5fug==
Date: Sun, 4 Apr 2010 16:26:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Oleg Nesterov <oleg@redhat.com>, anfei <anfei.zhou@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
In-Reply-To: <20100402101711.GC12886@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1004041616280.7198@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100402101711.GC12886@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010, Mel Gorman wrote:

> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1610,13 +1610,21 @@ try_next_zone:
> >  }
> >  
> >  static inline int
> > -should_alloc_retry(gfp_t gfp_mask, unsigned int order,
> > +should_alloc_retry(struct task_struct *p, gfp_t gfp_mask, unsigned int order,
> >  				unsigned long pages_reclaimed)
> >  {
> >  	/* Do not loop if specifically requested */
> >  	if (gfp_mask & __GFP_NORETRY)
> >  		return 0;
> >  
> > +	/* Loop if specifically requested */
> > +	if (gfp_mask & __GFP_NOFAIL)
> > +		return 1;
> > +
> 
> Meh, you could have preserved the comment but no biggie.
> 

I'll remember to preserve it when it's proposed.

> > +	/* Task is killed, fail the allocation if possible */
> > +	if (fatal_signal_pending(p))
> > +		return 0;
> > +
> 
> Seems reasonable. This will be checked on every major loop in the
> allocator slow patch.
> 
> >  	/*
> >  	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
> >  	 * means __GFP_NOFAIL, but that may not be true in other
> > @@ -1635,13 +1643,6 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
> >  	if (gfp_mask & __GFP_REPEAT && pages_reclaimed < (1 << order))
> >  		return 1;
> >  
> > -	/*
> > -	 * Don't let big-order allocations loop unless the caller
> > -	 * explicitly requests that.
> > -	 */
> > -	if (gfp_mask & __GFP_NOFAIL)
> > -		return 1;
> > -
> >  	return 0;
> >  }
> >  
> > @@ -1798,6 +1799,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> >  		if (!in_interrupt() &&
> >  		    ((p->flags & PF_MEMALLOC) ||
> > +		     (fatal_signal_pending(p) && (gfp_mask & __GFP_NOFAIL)) ||
> 
> This is a lot less clear. GFP_NOFAIL is rare so this is basically saying
> that all threads with a fatal signal pending can ignore watermarks. This
> is dangerous because if 1000 threads get killed, there is a possibility
> of deadlocking the system.
> 

I don't quite understand the comment, this is only for __GFP_NOFAIL 
allocations, which you say are rare, so a large number of threads won't be 
doing this simultaneously.

> Why not obey the watermarks and just not retry the loop later and fail
> the allocation?
> 

The above check for (fatal_signal_pending(p) && (gfp_mask & __GFP_NOFAIL)) 
essentially oom kills p without invoking the oom killer before direct 
reclaim is invoked.  We know it has a pending SIGKILL and wants to exit, 
so we allow it to allocate beyond the min watermark to avoid costly 
reclaim or needlessly killing another task.

> >  		     unlikely(test_thread_flag(TIF_MEMDIE))))
> >  			alloc_flags |= ALLOC_NO_WATERMARKS;
> >  	}
> > @@ -1812,6 +1814,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >  	int migratetype)
> >  {
> >  	const gfp_t wait = gfp_mask & __GFP_WAIT;
> > +	const gfp_t nofail = gfp_mask & __GFP_NOFAIL;
> >  	struct page *page = NULL;
> >  	int alloc_flags;
> >  	unsigned long pages_reclaimed = 0;
> > @@ -1876,7 +1879,7 @@ rebalance:
> >  		goto nopage;
> >  
> >  	/* Avoid allocations with no watermarks from looping endlessly */
> > -	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
> > +	if (test_thread_flag(TIF_MEMDIE) && !nofail)
> >  		goto nopage;
> >  
> >  	/* Try direct reclaim and then allocating */
> > @@ -1888,6 +1891,10 @@ rebalance:
> >  	if (page)
> >  		goto got_pg;
> >  
> > +	/* Task is killed, fail the allocation if possible */
> > +	if (fatal_signal_pending(p) && !nofail)
> > +		goto nopage;
> > +
> 
> Again, I would expect this to be caught by should_alloc_retry().
> 

It is, but only after the oom killer is called.  We don't want to 
needlessly kill another task here when p has already been killed but may 
not be PF_EXITING yet.
