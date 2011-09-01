Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1IAGyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:54:37 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57321 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab1IAGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:54:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUEAO0oX055LIxDgWdsb2JhbABCqFMVAQEWJiWBQAEBBAE6HCMFCwgDGC4UJQMhE4dyuEEOhk0Em2OIXg
Date: Thu, 1 Sep 2011 16:54:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901065415.GP32358@dastard>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
 <m2pqjlo6e5.fsf@firstfloor.org>
 <20110901041848.GO32358@dastard>
 <20110901043947.GB7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901043947.GB7761@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 06:39:47AM +0200, Andi Kleen wrote:
> > Allocations are already serialised by a single resource - the AGF
> > lock - so whether they block on the workqueue queue or on the AGF
> > lock is irrelevant to scheduling. And a single thread can only have
> 
> It's not about blocking, but about who gets the work accounted
> when it is done.

Don't trim the context away and respond with a completely different
argument that is irrelevant to the original context!  Accounting who
did the work is irrelevant to the discussion context of the fairness
of queuing and dispatching synchronous allocations via a FIFO wq
implementation....

> > If we get lots of allocations queued on the one per-CPU wq, they
> > will have all had to come from different contexts. In which case,
> > FIFO processing of the work queued up is *exactly* the fairness we
> > want, because that is exactly what doing them from process context
> > would end up with.
> 
> You want the work accounted to the originator so that it can be
> slowed down when it does too much (e.g. hit its cgroups or CFQ limits)

So fix the workqueue infrastructure to track it properly. Don't keep
bringing this up as a reason for saying moving work to workqueues is
bad.

> Networking learned these lessons a long time ago, it's much 
> better for overload behavior when as much as possible is done in
> process context.

Apples to oranges - there's orders of magnitude of difference in the
number of operations that the different stacks do. Allocation in XFS
when it does not block can still take milliseconds of CPU time; in
comparison, the networking stack is expected to process thousands of
packets in that same time frame.  IOWs, the scale of processing per
item of work is -vastly- different - that's why working in process
context matters a great deal to the networking stack but not to
allocation in XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
