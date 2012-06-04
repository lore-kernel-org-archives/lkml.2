Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab2FDM1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:27:55 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43067 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2FDM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:27:54 -0400
Date: Mon, 4 Jun 2012 17:57:45 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604122745.GA25126@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338800454.2448.71.camel@twins>
 <20120604114130.GA3386@linux.vnet.ibm.com>
 <1338810587.28282.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338810587.28282.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060412-8878-0000-0000-000002C50E7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-04 13:49:47]:

> > > OK, so previously we only pulled to ourselves,
> > 
> > That't not entirely true isn't it i.e this_cpu need not equal
> > smp_processor_id even before this change.
> 
> You forgot to finish that, I presume you were thinking of nohz idle
> balancing?

Yes!

> True, but in that case the target was at least idle.

While that is true most of the time, afaics there is nothing preventing a 
idle cpu to wake up and start running a task while somebody else
(ilb_cpu) is doing load balance on its behalf?

> > > now you make cpu x move
> > > from cpu y to cpu z. This changes the dynamic of the load-balancer, not
> > > a single word on that and its impact/ramifications.
> > 
> > The other possibility is for the right sibling cpus to do load balance
> > in the same domain (noting that it needs to pull a task from another
> > sched_group to itself and ignoring balance_cpu). That seemed like a more
> > invasive change than this patch. We'd be happy to try any other approach
> > you have in mind.
> 
> I'm not saying the approach is bad, I'm just saying the patch is bad.
> Mostly because there's a distinct lack of information on things.

The other possibility that was considered was to modify move_tasks() to
move a task to a different env->dst_cpu (as indicated by task's
cpus_allowed mask and the sched_group's cpumask). Since at that point we would
have alread taken two runqueue locks (src_rq and dst_rq), grabbing a third 
runqueue lock (that of the new dst_cpu) would have meant some runqueue 
lock/unlock dance which didn't look pretty either. Moreover we may be 
able to achieve the load balace goal by just ignoring that particular
task and wading thr' the rest of the tasks on the src_cpu.

> There's nothing to indicate you've considered stuff, found this the best
> solution because of other stuff etc... thus I think its the first thing
> that came to mind without due consideration.

We will modify the changelog to indicate all the possibilities
considered and publish the next version. Thanks for your feedback!

- vatsa

