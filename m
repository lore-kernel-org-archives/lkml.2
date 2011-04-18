Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1DRUZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:25:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19916 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1DRUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=o+NwF8uQ5heMdZLUG3yPOIdJ2VEaWqneRIUIOZJfJT4YoDjZQ0A5u3KLUaV1y5mTIN
         L9TAbpWcOXFkEELuyxWw==
Date: Mon, 18 Apr 2011 13:25:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <1303139455.9615.2533.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel> <alpine.DEB.2.00.1104161653220.14788@chino.kir.corp.google.com> <1303139455.9615.2533.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, Dave Hansen wrote:

> > > +void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
> > > +{
> > > +	va_list args;
> > > +	unsigned int filter = SHOW_MEM_FILTER_NODES;
> > > +	const gfp_t wait = gfp_mask & __GFP_WAIT;
> > > +
> > 
> > "wait" is unnecessary.  You didn't do "const gfp_t nowarn = gfp_mask & 
> > __GFP_NOWARN;" for the same reason.
> 
> This line is just a copy from the __alloc_pages_slowpath() one.  I guess
> we only use it once, so I've got no problem killing it.
> 
> > > +	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
> > > +		return;
> > > +
> > > +	/*
> > > +	 * This documents exceptions given to allocations in certain
> > > +	 * contexts that are allowed to allocate outside current's set
> > > +	 * of allowed nodes.
> > > +	 */
> > > +	if (!(gfp_mask & __GFP_NOMEMALLOC))
> > > +		if (test_thread_flag(TIF_MEMDIE) ||
> > > +		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
> > > +			filter &= ~SHOW_MEM_FILTER_NODES;
> > > +	if (in_interrupt() || !wait)
> > > +		filter &= ~SHOW_MEM_FILTER_NODES;
> > > +
> > > +	if (fmt) {
> > > +		printk(KERN_WARNING);
> > > +		va_start(args, fmt);
> > > +		vprintk(fmt, args);
> > > +		va_end(args);
> > > +	}
> > > +
> > > +	printk(KERN_WARNING "%s: page allocation failure: order:%d, mode:0x%x\n",
> > > +			current->comm, order, gfp_mask);
> > 
> > pr_warning()?
> 
> OK, I'll change it back.
> 
> > current->comm should always be printed with get_task_comm() to avoid 
> > racing with /proc/pid/comm.  Since this function can be called potentially 
> > deep in the stack, you may need to serialize this with a 
> > statically-allocated buffer.
> 
> This code was already in page_alloc.c.  I'm simply breaking it out here
> trying to keep the changes down to what is needed minimally to move the
> code.  Correcting this preexisting problem sounds like a great follow-on
> patch.
> 

It shouldn't be a follow-on patch since you're introducing a new feature 
here (vmalloc allocation failure warnings) and what I'm identifying is a 
race in the access to current->comm.  A bug fix for a race should always 
preceed a feature that touches the same code.

There's two options to fixing the race:

 - provide a statically-allocated buffer to use for get_task_comm() and 
   copy current->comm over before printing it, or

 - take task_lock(current) to protect against /proc/pid/comm.

The latter probably isn't safe because we could potentially already be 
holding task_lock(current) during a GFP_ATOMIC page allocation.
