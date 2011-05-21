Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1EUUj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 16:39:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38847 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab1EUUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 16:39:26 -0400
Date: Sat, 21 May 2011 13:39:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/next] fixes and breakup of
 memory-barrier-decrease patch
Message-ID: <20110521203922.GI2271@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110521140613.GA13062@linux.vnet.ibm.com>
 <20110521142844.GA29813@elte.hu>
 <20110521190830.GH2271@linux.vnet.ibm.com>
 <20110521191418.GA30688@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521191418.GA30688@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 09:14:18PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sat, May 21, 2011 at 04:28:44PM +0200, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Hello, Ingo,
> > > > 
> > > > This pull requests covers some RCU bug fixes and one patch rework.
> > > > 
> > > > The first group breaks up the infamous now-reverted (but ultimately
> > > > vindicated) "Decrease memory-barrier usage based on semi-formal proof"
> > > > commit into five commits.  These five commits immediately follow the
> > > > revert, and the diff across all six of these commits is empty, so that
> > > > the effect of the five commits is to revert the revert.
> > > 
> > > But ... the regression that was observed with that commit needs to be fixed 
> > > first, or not? In what way was the barrier commit vindicated?
> > 
> > From what I can see, the hang was fixed by Frederic's patch at 
> > https://lkml.org/lkml/2011/5/19/753.  I was interpreting that as vindication, 
> > perhaps ill-advisedly.
> 
> I mean, without Frederic's patch we are getting very long hangs due to the 
> barrier patch, right?

Yes.  The reason we are seeing these hangs is that HARDIRQ_ENTER()
invoked irq_enter(), which calls rcu_irq_enter() but that the matching
HARDIRQ_EXIT() invoked __irq_exit(), which does not call rcu_irq_exit().
This resulted in calls to rcu_irq_enter() that were not balanced by
matching calls to rcu_irq_exit().  Therefore, after these tests completed,
RCU's dyntick-idle nesting count was a large number, which caused RCU
to conclude that the affected CPU was not in dyntick-idle mode when in
fact it was.

RCU would therefore incorrectly wait for this dyntick-idle CPU.

With Frederic's patch, these tests don't ever call either rcu_irq_enter()
or rcu_irq_exit(), which works because the CPU running the test is
already marked as not being in dyntick-idle mode.

So, with Frederic's patch, the rcu_irq_enter() and rcu_irq_exit() calls
are balanced and things work.

The reason that the imbalance was not noticed before the barrier patch
was applied is that the old implementation of rcu_enter_nohz() ignored
the nesting depth.  This could still result in delays, but much shorter
ones.  Whenever there was a delay, RCU would IPI the CPU with the
unbalanced nesting level, which would eventually result in rcu_enter_nohz()
being called, which in turn would force RCU to see that the CPU was in
dyntick-idle mode.

Hmmm...  I should add this line of reasoning to one of the commit logs,
shouldn't I?  (Added it.  Which of course invalidates my pull request.)

> Even if the barrier patch is not to blame - somehow it still managed to produce 
> these hangs - and we do not understand it yet.

>From Yinghai's message https://lkml.org/lkml/2011/5/12/465, I believe
that the residual delay he is seeing is not due to the barrier patch,
but rather due to a26ac2455 (move TREE_RCU from softirq to kthrea).

More on this below.

> > Yinghai said that he was still seeing a delay, adn that he was seeing it even 
> > with the "Decrease memory-barrier usage based on semi-formal proof" reverted: 
> > https://lkml.org/lkml/2011/5/20/427.  This hang seems to happen when he uses 
> > gcc 4.5.0, but not when using gcc 4.5.1, assuming I understood his sequence 
> > of emails.  So I was interpreting that as meaning that the delay was unlikely 
> > to be caused by that commit, probably by one of the later commits.
> > 
> > I clearly need to figure out what is causing this delay.  I asked Yinghai to 
> > apply c7a378603 (Remove waitqueue usage for cpu, node, and boost kthreads) 
> > from Peter Zijlstra because the long delays that Yinghai is seeing (93 
> > seconds for memory_dev_init() rather than 3 or 4 seconds) might be due to my 
> > less-efficient method of awakening the RCU kthreads, so that Peter's 
> > approache might help.
> > 
> > If that doesn't speed things up for Yinghai, then I will work out some 
> > tracing to help localize the slowdown that he is seeing.
> > 
> > Of course, if you would rather that I get to the bottom of this before 
> > pulling, fair enough!
> 
> We should fix the delay regression i suspect - do we have to revert more stuff 
> perhaps?
> 
> Would it be possible to figure out what caused that other delay for Yinghai?

Earlier, Yinghai reported that reverting a26ac2455ffc (move TREE_RCU
from softirq to kthread) and everything after it made what appears to be
the same sort of delay go away (https://lkml.org/lkml/2011/5/12/465).
This commit replaced raise_softirq() with wait queues, flags, and
wake_up().  Later, Yinghai said that the delay shows up in kernels
built using opensuse 11.3, but not in kernels build using fedora 14
(https://lkml.org/lkml/2011/5/20/469).  Still later, he said that opensuse
11.3 has gcc 4.5.0 and fedora 14 has gcc 4.5.1.

Differences in compilers usually don't produce 20-to-1 latency differences
without something amplifying them.  In this case, that something
is likely to be the wait/wakeup coordination.  Peter's recent patch
(https://lkml.org/lkml/2011/5/19/133) to fix some CPU-hotplug-related
issues in the scheduler (https://lkml.org/lkml/2011/5/13/22) changed
RCU's kthread wait/wakeup coordination.

So I asked that Yinghai try c7a3786030 (Remove waitqueue usage for cpu,
node, and boost kthreads) from Peter currently queued on -rcu.

If that doesn't help, I will probably provide Yinghai some tracing
patches.

							Thanx, Paul
