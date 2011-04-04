Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1DDATr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 20:19:47 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:42330 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab1DDATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 20:19:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkEAJwNmU15LK5JgWdsb2JhbAClYBUBARYmJYh5tnQNhV4E
Date: Mon, 4 Apr 2011 10:19:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Message-ID: <20110404001936.GL6957@dastard>
References: <20110401221921.A890.A69D9226@jp.fujitsu.com>
 <20110402011040.GG6957@dastard>
 <20110403183229.AE4C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403183229.AE4C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 06:32:16PM +0900, KOSAKI Motohiro wrote:
> > On Fri, Apr 01, 2011 at 10:17:56PM +0900, KOSAKI Motohiro wrote:
> > > > > But, I agree that now we have to concern slightly large VM change parhaps
> > > > > (or parhaps not). Ok, it's good opportunity to fill out some thing.
> > > > > Historically, Linux MM has "free memory are waste memory" policy, and It
> > > > > worked completely fine. But now we have a few exceptions.
> > > > >
> > > > > 1) RT, embedded and finance systems. They really hope to avoid reclaim
> > > > >    latency (ie avoid foreground reclaim completely) and they can accept
> > > > >    to make slightly much free pages before memory shortage.
> > > > 
> > > > In general we need a mechanism to ensure we can avoid reclaim during
> > > > critical sections of application. So some way to give some hints to the
> > > > machine to free up lots of memory (/proc/sys/vm/dropcaches is far too
> > > > drastic) may be useful.
> > > 
> > > Exactly.
> > > I've heard multiple times this request from finance people. And I've also 
> > > heared the same request from bullet train control software people recently.
> > 
[...]
> > Fundamentally, if you just switch off memory reclaim to avoid the
> > latencies involved with direct memory reclaim, then all you'll get
> > instead is ENOMEM because there's no memory available and none will be
> > reclaimed. That's even more fatal for the system than doing reclaim.
> 
> You have two level oversight.
> 
> Firstly, *ALL* RT application need to cooperate applications, kernel, 
> and other various system level daemons. That's no specific issue of 
> this topic. OK, *IF* RT application run egoistic, a system may hang 
> up easily even routh mere simple busy loop, yes. But, Who want to do so?

Sure - that's RT-101. I think I have a good understanding of these
principles after spending 7 years of my life working on wide-area
distributed real-time control systems (think city-scale water and
electricity supply).

> Secondly, You misparsed "avoid direct reclaim" paragraph. We don't talk
> about "avoid direct reclaim even if system memory is no enough", We talk
> about "avoid direct reclaim by preparing before". 

I don't think I misparsed it. I am addressing the "avoid direct
reclaim by preparing before" principle directly. The problem with it
is that just enalrging the free memory pool doesn't guarantee future
allocation success when there are other concurrent allocations
occurring. IOWs, if you don't _reserve_ the free memory for the
critical area in advance then there is no guarantee it will be
available when needed by the critical section.

A simple example: the radix tree node preallocation code to
guarantee inserts succeed while holding a spinlock. If just relying
on free memory was sufficient, then GFP_ATOMIC allocations are all
that is necessary. However, even that isn't sufficient as even the
GFP_ATOMIC reserved pool can be exhausted by other concurrent
GFP_ATOMIC allocations. Hence preallocation is required before
entering the critical section to guarantee success in all cases.

And to state the obvious: doing allocation before the critical
section will trigger reclaim if necessary so there is no need to
have the application trigger reclaim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
