Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab1IAESy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 00:18:54 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:48325 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab1IAESx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 00:18:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8CALwFX055LIxDgWdsb2JhbABCqE8VAQEWJiWBQAEBBAE6HCMFCwgDEgYuFCUDDRQTh3K5JQ6GRwSbY4hd
Date: Thu, 1 Sep 2011 14:18:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901041848.GO32358@dastard>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
 <m2pqjlo6e5.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2pqjlo6e5.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:08:50AM -0700, Andi Kleen wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> >
> > I'll get it polished up and send it out for RFC once Dave sends out
> > the updated allocation workqueue patch.  With this he moves all
> > allocator calls in XFS into a workqueue.  My direct I/O patch uses that
> > fact to use that workqueue for the allocator call
> 
> Is that really a good direction? The problem when you push operations
> from multiple threads all into a single resource (per cpu workqueue)
> is that the CPU scheduler loses control over that because they
> are all mixed up.

Allocations are already serialised by a single resource - the AGF
lock - so whether they block on the workqueue queue or on the AGF
lock is irrelevant to scheduling. And a single thread can only have
a single allocation outstanding at a time because the caller has to
block waiting for the allocation to complete before moving on. 

> So if one guy submits a lot and another very little the "a lot" guy
> can overwhelm the queue for the very little guy.

If we get lots of allocations queued on the one per-CPU wq, they
will have all had to come from different contexts. In which case,
FIFO processing of the work queued up is *exactly* the fairness we
want, because that is exactly what doing them from process context
would end up with.

If the allocation work blocks (either on locks or metadata reads),
the workqueue is configured with a deep amount of concurrent
operations per CPU (I think I set it to the maximum of 512 works per
CPU), so other pending allocations from the same per-cpu workqueue
can be run in the mean time.

> We also have similar problems with the IO schedulers, which also
> rely on process context to make fairness decisions. If you remove
> the process context they do badly.

Which, IMO, is a significant failing of the IO scheduler in question
(CFQ) because it'll perform badly the moment your application or
filesytem uses a multithreaded IO architecture.  Filesystem metadata
is a global resource, not a per-process context resource, so IO
scehdulers need to treat it that way.

Indeed, taking the allocation IO out of the process context means
the filesystem operations are not subject to process context based
throttling, which can lead to priority inversion problems when a
low priority process is throttled on a metadata read IO needed to
complete an allocation that a high priority process is waiting on
being completed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
