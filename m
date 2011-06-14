Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1FNM4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:56:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57963 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1FNM4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:56:21 -0400
Date: Tue, 14 Jun 2011 05:56:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, "Shi, Alex" <alex.shi@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: rcu: performance regression
Message-ID: <20110614125612.GE2264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308029185.15392.147.camel@sli10-conroe>
 <20110614081315.GE29900@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614081315.GE29900@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 10:13:15AM +0200, Ingo Molnar wrote:
> 
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
> > introduced performance regression. In our AIM7 test, this commit caused
> > about 40% regression.
> 
> Sigh, this commit is somewhat of a train-wreck.
> 
> > The commit runs rcu callbacks in a kthread instead of softirq. We 
> > observed high rate of context switch which is caused by this. Out 
> > test system has 64 CPUs and HZ is 1000, so we saw more than 64k 
> > context switch per second which is caused by the rcu thread.
> >
> > I also did trace and found when rcy thread is woken up, most time 
> > the thread doesn't handle any callbacks actually, it just 
> > initializes new gp or end one gp or similar.
> >
> > From my understanding, the purpose to make rcu runs in kthread is 
> > to speed up rcu callbacks run (with help of rtmutex PI), not for 
> > end gp and so on, which runs pretty fast actually and doesn't need 
> > boost. To verify my findings, I had below debug patch applied. It 
> > still handles rcu callbacks in kthread if there is any pending 
> > callbacks, but other things are still running in softirq. this 
> > completely solved our regression. I thought this can still boost 
> > callbacks run. but I'm not expert in the area, so please help.
> > 
> > Thanks,
> > Shaohua
> > ---
> >  Documentation/filesystems/proc.txt  |    1 +
> >  include/linux/interrupt.h           |    1 +
> >  include/trace/events/irq.h          |    3 ++-
> >  kernel/rcutree.c                    |   23 +++++++++++++++++++----
> >  kernel/rcutree.h                    |    1 +
> >  kernel/rcutree_plugin.h             |    9 +++++++++
> >  kernel/softirq.c                    |    2 +-
> >  tools/perf/util/trace-event-parse.c |    1 +
> >  8 files changed, 35 insertions(+), 6 deletions(-)
> 
> Paul? Unless this patch is the obviously correct solution everyone 
> wants to have, the other obviously correct solution is to do the 
> revert ...

I will look Shaohua's patch over.  Of course, given that mid-90s
could do well in excess of 100,000 context switches per second
per CPU, I am having a hard time seeing how 1,000 context switches
per second per CPU is by itself resulting in a 40% regression.

Nevertheless, fewer context switches per second should speed things
up, and so again, I will look at Shaohua's patch.

							Thanx, Paul
