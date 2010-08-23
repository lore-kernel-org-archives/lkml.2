Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0HWTfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:35:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0HWTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:35:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Z6HWAosM0exXtd//yrkKX3wFpoUT/kVGDx9a6Mahb2eCO74WEZ3QknEVS9bZjZjhz
	jNTTehcXnZLdKj3E2pG/g==
Date: Mon, 23 Aug 2010 12:35:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
In-Reply-To: <20100823122606.47524cef.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Andrew Morton wrote:

> > diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> > --- a/drivers/md/dm-region-hash.c
> > +++ b/drivers/md/dm-region-hash.c
> > @@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
> >  	struct dm_region *reg, *nreg;
> >  
> >  	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
> > -	if (unlikely(!nreg))
> > -		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> > +	if (unlikely(!nreg)) {
> > +		/* FIXME: this may potentially loop forever */
> > +		do {
> > +			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
> > +		} while (!nreg);
> > +	}
> >  
> >  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
> >  		      DM_RH_CLEAN : DM_RH_NOSYNC;
> 
> erm.
> 
> The reason for adding GFP_NOFAIL in the first place was my observation
> that the kernel contained lots of open-coded retry-for-ever loops.
> 
> All of these are wrong, bad, buggy and mustfix.  So we consolidated the
> wrongbadbuggymustfix concept into the core MM so that miscreants could
> be easily identified and hopefully fixed.
> 

That consolidation would have been unnecessary, then, since all 
allocations with order < PAGE_ALLOC_COSTLY_ORDER automatically loop 
indefinitely in the page allocator.  struct dm_region allocations would 
already do that.

So this retry loop doesn't actually do anything that the page allocator 
already doesn't, with or without __GFP_NOFAIL.  The difference here is 
that

 - it doesn't depend on the page allocator's implementation, which may
   change over time, and

 - it adds documentation so that the subsystems doing these loops can
   (hopefully) fix these problems later, although their appear to be
   geniune cases where little other options are available.

> I think that simply undoing that change is a bad idea - it allows the
> wrongbadbuggymustfix code to hide from view.
> 

It removes several branches from the page allocator.

> The correct way to remove __GFP_NOFAIL is to fix the
> wrongbadbuggymustfix code properly.
> 

If the prerequisite for removing __GFP_NOFAIL is that nobody must ever 
loop indefinitely looking for memory or smaller order allocations don't 
implicitly retry, then there's little chance it'll ever get removed since 
they've existed for years without anybody cleaning them up.
