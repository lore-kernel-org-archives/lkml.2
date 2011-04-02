Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1DBBKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:10:46 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33924 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab1DBBKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:10:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQEADF1lk15LK5JgWdsb2JhbAClYRUBARYmJcBwDYVeBA
Date: Sat, 2 Apr 2011 12:10:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Message-ID: <20110402011040.GG6957@dastard>
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1103311451530.28364@router.home>
 <20110401221921.A890.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401221921.A890.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 10:17:56PM +0900, KOSAKI Motohiro wrote:
> > > But, I agree that now we have to concern slightly large VM change parhaps
> > > (or parhaps not). Ok, it's good opportunity to fill out some thing.
> > > Historically, Linux MM has "free memory are waste memory" policy, and It
> > > worked completely fine. But now we have a few exceptions.
> > >
> > > 1) RT, embedded and finance systems. They really hope to avoid reclaim
> > >    latency (ie avoid foreground reclaim completely) and they can accept
> > >    to make slightly much free pages before memory shortage.
> > 
> > In general we need a mechanism to ensure we can avoid reclaim during
> > critical sections of application. So some way to give some hints to the
> > machine to free up lots of memory (/proc/sys/vm/dropcaches is far too
> > drastic) may be useful.
> 
> Exactly.
> I've heard multiple times this request from finance people. And I've also 
> heared the same request from bullet train control software people recently.

Well, that's enough to make me avoid Japanese trains in future. If
your critical control system has problems with memory reclaim
interfering with it's operation, then you are doing something
very, very wrong.

If you have a need to avoid memory allocation latency during
specific critical sections then the critical section needs to:

	a) have all it's memory preallocated and mlock()d in advance

	b) avoid doing anything that requires memory to be
	   allocated.

These are basic design rules for time-sensitive applications.

Fundamentally, if you just switch off memory reclaim to avoid the
latencies involved with direct memory reclaim, then all you'll get
instead is ENOMEM because there's no memory available and none will be
reclaimed. That's even more fatal for the system than doing reclaim.

IMO, you should tell the people requesting stuff like this to
architect their critical sections according to best practices.
Hacking the VM to try to work around badly designed applications is
a sure recipe for disaster...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
