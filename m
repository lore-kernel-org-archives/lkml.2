Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1DHUnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:43:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35092 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab1DHUni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:43:38 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1104081333260.12689@chino.kir.corp.google.com>
References: <20110408202253.6D6D231C@kernel>
	 <alpine.DEB.2.00.1104081333260.12689@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 08 Apr 2011 13:43:33 -0700
Message-ID: <1302295413.7286.1133.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 13:37 -0700, David Rientjes wrote:
> > +static DEFINE_RATELIMIT_STATE(nopage_rs,
> > +		DEFAULT_RATELIMIT_INTERVAL,
> > +		DEFAULT_RATELIMIT_BURST);
> > +
> > +void nopage_warning(gfp_t gfp_mask, int order, const char *fmt, ...)
> 
> I suggest a different name for this, something like warn_alloc_failure() 
> or such.

That works for me.

> I guess this isn't general enough where it could be used in the oom killer 
> as well?

Nope, don't think so.  I took a look at it, but it isn't horribly close
to this.

> > +{
> > +	va_list args;
> > +	int r;
> > +	unsigned int filter = SHOW_MEM_FILTER_NODES;
> > +	const gfp_t wait = gfp_mask & __GFP_WAIT;
> > +
> > +	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
> > +		return;
> > +
> > +	/*
> > +	 * This documents exceptions given to allocations in certain
> > +	 * contexts that are allowed to allocate outside current's set
> > +	 * of allowed nodes.
> > +	 */
> > +	if (!(gfp_mask & __GFP_NOMEMALLOC))
> > +		if (test_thread_flag(TIF_MEMDIE) ||
> > +		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
> > +			filter &= ~SHOW_MEM_FILTER_NODES;
> > +	if (in_interrupt() || !wait)
> > +		filter &= ~SHOW_MEM_FILTER_NODES;
> > +
> > +	if (fmt) {
> > +		printk(KERN_WARNING);
> > +		va_start(args, fmt);
> > +		r = vprintk(fmt, args);
> > +		va_end(args);
> > +	}
> > +
> > +	printk(KERN_WARNING);
> > +	printk("%s: page allocation failure: order:%d, mode:0x%x\n",
> > +			current->comm, order, gfp_mask);
> 
> This shouldn't be here, it should have been printed already.

The "page allocation failure" might have been, if it was specified (it
isn't from the allocator), but order and mode haven't been.  My thought
here is that _all_ allocator failures will want to output mode and gfp,
so it might as well be common code instead of making everybody specify
it.

-- Dave

