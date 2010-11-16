Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0KPPvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:51:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53441 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab0KPPvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:51:09 -0500
Date: Tue, 16 Nov 2010 07:51:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101116155104.GB2497@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116135230.GA5362@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:52:34PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 15, 2010 at 05:28:46PM -0800, Paul E. McKenney wrote:
> > My concern is not the tick -- it is really easy to work around lack of a
> > tick from an RCU viewpoint.  In fact, this happens automatically given the
> > current implementations!  If there is a callback anywhere in the system,
> > then RCU will prevent the corresponding CPU from entering dyntick-idle
> > mode, and that CPU's clock will drive the rest of RCU as needed via
> > force_quiescent_state().
> 
> Now, I'm confused, I thought a CPU entering idle nohz had nothing to do
> if it has no local callbacks, and rcu_enter_nohz already deals with
> everything.
> 
> There is certainly tons of subtle things in RCU anyway :)

Well, I wasn't being all that clear above, apologies!!!

If a given CPU hasn't responded to the current RCU grace period,
perhaps due to being in a longer-than-average irq handler, then it
doesn't necessarily need its own scheduler tick enabled.  If there is a
callback anywhere else in the system, then there is some other CPU with
its scheduler tick enabled.  That other CPU can drive the slow-to-respond
CPU through the grace-period process.

The current RCU code should work in the common case.  There are probably
a few bugs, but I will make you a deal.  You find them, I will fix them.
Particularly if you are willing to test the  fixes.

> > The force_quiescent_state() workings would
> > want to be slightly different for dyntick-hpc, but not significantly so
> > (especially once I get TREE_RCU moved to kthreads).
> > 
> > My concern is rather all the implicit RCU-sched read-side critical
> > sections, particularly those that arch-specific code is creating.
> > And it recently occurred to me that there are necessarily more implicit
> > irq/preempt disables than there are exception entries.
> 
> Doh! You're right, I don't know why I thought that adaptive tick would
> solve the implicit rcu sched/bh cases, my vision took a shortcut.

Yeah, and I was clearly suffering from a bit of sleep deprivation when
we discussed this in Boston.  :-/

> > So would you be OK with telling RCU about kernel entries/exits, but
> > simply not enabling the tick?
> 
> Let's try that.

Cool!!!

> > The irq and NMI kernel entries/exits are
> > already covered, of course.
> 
> Yep.
> 
> > This seems to me to work out as follows:
> > 
> > 1.	If there are no RCU callbacks anywhere in the system, RCU
> > 	is quiescent and does not cause any IPIs or interrupts of
> > 	any kind.  For HPC workloads, this should be the common case.
> 
> Right.
> 
> > 2.	If there is an RCU callback, then one CPU keeps a tick going
> > 	and drives RCU core processing on all CPUs.  (This probably
> > 	works with RCU as is, but somewhat painfully.)  This results
> > 	in some IPIs, but only to those CPUs that remain running in
> > 	the kernel for extended time periods.  Appropriate adjustment
> > 	of RCU_JIFFIES_TILL_FORCE_QS, possibly promoted to be a
> > 	kernel configuration parameter, should make such IPIs
> > 	-extremely- rare.  After all, how many kernel code paths
> > 	are going to consume (say) 10 jiffies of CPU time?  (Keep
> > 	in mind that if the system call blocks, the CPU will enter
> > 	dyntick-idle mode, and RCU will still recognize it as an
> > 	innocent bystander without needing to IPI it.)
> 
> Makes all sense. Also there may be periods when these "isolated" CPUs
> will restart the tick, like when there is more than one task running
> on that CPU, in which case we can of course fall back to usual
> grace periods processing.

Yep!

> > 3.	The implicit RCU-sched read-side critical sections just work
> > 	as they do today.
> > 
> > Or am I missing some other problems with this approach?
> 
> No, looks good, now I'm going to implement/test a draft of these ideas.
> 
> Thanks a lot!

Very cool, and thank you!!!  I am sure that you will not be shy about
letting me know of any RCU problems that you might encounter.  ;-)

							Thanx, Paul
