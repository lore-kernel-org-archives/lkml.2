Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0HWTvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:51:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab0HWTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:51:47 -0400
Date: Mon, 23 Aug 2010 12:51:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Message-Id: <20100823125100.75a9de56.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 12:35:22 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 23 Aug 2010, Andrew Morton wrote:
> 
> > > diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> > > --- a/drivers/md/dm-region-hash.c
> > > +++ b/drivers/md/dm-region-hash.c
> > > @@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
> > >  	struct dm_region *reg, *nreg;
> > >  
> > >  	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
> > > -	if (unlikely(!nreg))
> > > -		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> > > +	if (unlikely(!nreg)) {
> > > +		/* FIXME: this may potentially loop forever */
> > > +		do {
> > > +			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
> > > +		} while (!nreg);
> > > +	}
> > >  
> > >  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
> > >  		      DM_RH_CLEAN : DM_RH_NOSYNC;
> > 
> > erm.
> > 
> > The reason for adding GFP_NOFAIL in the first place was my observation
> > that the kernel contained lots of open-coded retry-for-ever loops.
> > 
> > All of these are wrong, bad, buggy and mustfix.  So we consolidated the
> > wrongbadbuggymustfix concept into the core MM so that miscreants could
> > be easily identified and hopefully fixed.
> > 
> 
> That consolidation would have been unnecessary, then, since all 
> allocations with order < PAGE_ALLOC_COSTLY_ORDER automatically loop 
> indefinitely in the page allocator.

The difference is that an order-0 !__GFP_NOFAIL allocation attempt can
fail due to oom-killing.  Unless someone broke that.

>  struct dm_region allocations would 
> already do that.
> 
> So this retry loop doesn't actually do anything that the page allocator 
> already doesn't, with or without __GFP_NOFAIL.  The difference here is 
> that
> 
>  - it doesn't depend on the page allocator's implementation, which may
>    change over time, and
> 
>  - it adds documentation so that the subsystems doing these loops can
>    (hopefully) fix these problems later, although their appear to be
>    geniune cases where little other options are available.
> 
> > I think that simply undoing that change is a bad idea - it allows the
> > wrongbadbuggymustfix code to hide from view.
> > 
> 
> It removes several branches from the page allocator.

None on the fast path.

> > The correct way to remove __GFP_NOFAIL is to fix the
> > wrongbadbuggymustfix code properly.
> > 
> 
> If the prerequisite for removing __GFP_NOFAIL is that nobody must ever 
> loop indefinitely looking for memory or smaller order allocations don't 
> implicitly retry, then there's little chance it'll ever get removed since 
> they've existed for years without anybody cleaning them up.

The JBD one is hard - I haven't looked at the others.

We should fix them.
