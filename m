Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0DOKV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:21:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55519 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0DOKVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:21:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415085420.GT2493@dastard>
References: <20100415152816.D18C.A69D9226@jp.fujitsu.com> <20100415085420.GT2493@dastard>
Message-Id: <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 19:21:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 03:35:14PM +0900, KOSAKI Motohiro wrote:
> > > On Thu, Apr 15, 2010 at 01:09:01PM +0900, KOSAKI Motohiro wrote:
> > > > Hi
> > > > 
> > > > > How about this? For now, we stop direct reclaim from doing writeback
> > > > > only on order zero allocations, but allow it for higher order
> > > > > allocations. That will prevent the majority of situations where
> > > > > direct reclaim blows the stack and interferes with background
> > > > > writeout, but won't cause lumpy reclaim to change behaviour.
> > > > > This reduces the scope of impact and hence testing and validation
> > > > > the needs to be done.
> > > > 
> > > > Tend to agree. but I would proposed slightly different algorithm for
> > > > avoind incorrect oom.
> > > > 
> > > > for high order allocation
> > > > 	allow to use lumpy reclaim and pageout() for both kswapd and direct reclaim
> > > 
> > > SO same as current.
> > 
> > Yes. as same as you propsed.
> > 
> > > 
> > > > for low order allocation
> > > > 	- kswapd:          always delegate io to flusher thread
> > > > 	- direct reclaim:  delegate io to flusher thread only if vm pressure is low
> > > 
> > > IMO, this really doesn't fix either of the problems - the bad IO
> > > patterns nor the stack usage. All it will take is a bit more memory
> > > pressure to trigger stack and IO problems, and the user reporting the
> > > problems is generating an awful lot of memory pressure...
> > 
> > This patch doesn't care stack usage. because
> >   - again, I think all stack eater shold be diet.
> 
> Agreed (again), but we've already come to the conclusion that a
> stack diet is not enough.

ok.


> >   - under allowing lumpy reclaim world, only deny low order reclaim
> >     doesn't solve anything.
> 
> Yes, I suggested it *as a first step*, not as the end goal. Your
> patches don't reach the first step which is fixing the reported
> stack problem for order-0 allocations...

I have some diet patch as another patches. I'll post todays diet patch
by another mail. I didn't hope mixing perfectly unrelated patches.


> > Please don't forget priority=0 recliam failure incvoke OOM-killer.
> > I don't imagine anyone want it.
> 
> Given that I haven't been able to trigger OOM without writeback from
> direct reclaim so far (*) I'm not finding any evidence that it is a
> problem or that there are regressions.  I want to be able to say
> that this change has no known regressions. I want to find the
> regression and  work to fix them, but without test cases there's no
> way I can do this.
> 
> This is what I'm getting frustrated about - I want to fix this
> problem once and for all, but I can't find out what I need to do to
> robustly test such a change so we can have a high degree of
> confidence that it doesn't introduce major regressions. Can anyone
> help here?
> 
> (*) except in one case I've already described where it mananged to
> allocate enough huge pages to starve the system of order zero pages,
> which is what I asked it to do.

Agreed. I'm sorry that thing. Probably nobody in the world have
enough VM test case even though include no linux people. Modern general
purpose OS are used really really various purpose and various machine.
So, I haven't seen perfectly zero regression VM change. I'm getting 
the same frustration anytime. 

Because, Many VM mess is for avoiding extream starvation case. but If
it can be reproduced easily, it's VM bug ;)



> > And, Which IO workload trigger <6 priority vmscan?
> 
> You're asking me? I've been asking you for workloads that wind up
> reclaim priority.... :/

??? Do I misunderstand your last mail?
You wrote

> IMO, this really doesn't fix either of the problems - the bad IO
> patterns nor the stack usage. All it will take is a bit more memory
> pressure to trigger stack and IO problems, and the user reporting the
> problems is generating an awful lot of memory pressure...

and, I ask which is "the bad IO patterns". if it's not your intention,
What do you talked about io pattern?

If my understand is correct, you asked me about vmscan hurt case,
and I asked you your the bad IO pattern. 

now guessing, your intention was "bad IO patterns", not "the IO patterns"??



> All I can say is that the most common trigger I see for OOM is
> copying a large file on a busy system that is running off a single
> spindle.  When that happens on my laptop I walk away and get a cup
> of coffee when that happens and when I come back I pick up all the
> broken bits the OOM killer left behind.....

As far as I understand, you are talking about no specific general thing.
then, I also talking general one. In general, I think slow down is
better than OOM-killer. So, even though we need more and more improvement,
we always care about avoiding incorrect oom. iow, I'd prefer step by
step development.




