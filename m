Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0HRDt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:49:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0HRDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AWDZuHK2cJJ0Y8kbK7rfCffivywtCpIlJHOP95WSnS4digIbUxzuW+P/pwcuxPNPKS
         iksIHCwSXln5/ETreScQ2tHgP7xVjyA3clyeYwZnWgLC/GtoaKB54h6ZdMsKLMHkFicU
         lqZk1lOS53hzIthDGwFn0l8gaRJPijji1hjL0=
Date: Wed, 18 Aug 2010 05:49:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 5/6 v4] perf: Fix race in callchains
Message-ID: <20100818034943.GB24748@nowhere>
References: <1281991715-10367-6-git-send-regression-fweisbec@gmail.com> <1282008846-11833-1-git-send-regression-fweisbec@gmail.com> <20100817045331.GE24726@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817045331.GE24726@drongo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 02:53:31PM +1000, Paul Mackerras wrote:
> On Tue, Aug 17, 2010 at 03:34:06AM +0200, Frederic Weisbecker wrote:
> 
> > Now that software events don't have interrupt disabled anymore in
> > the event path, callchains can nest on any context. So seperating
> > nmi and others contexts in two buffers has become racy.
> > 
> > Fix this by providing one buffer per nesting level. Given the size
> > of the callchain entries (2040 bytes * 4), we now need to allocate
> > them dynamically.
> > 
> > v2: Fixed put_callchain_entry call after recursion.
> >     Fix the type of the recursion, it must be an array.
> > 
> > v3: Use a manual pr cpu allocation (temporary solution until NMIs
> >     can safely access vmalloc'ed memory).
> 
> It would be nice to make these allocations node-local.


You're right, I'll use kmalloc_node then.

 
> Also, I see that we're allocating 4 buffers per cpu on powerpc when we
> strictly only need 3, but I don't suppose that really matters.


Yeah, we are allocating a similar per-context bunch of buffers for trace
events and also for software events.

If we had a way to know if an arch has nmis, we could manage that.
Whenever this is about simulated or really unmaskable, we don't care,
we just need to know if events can nest on traditional irq disabled
sections.

How do you deal with that in PPC? Is the event delayed to when irqs are
restored?

