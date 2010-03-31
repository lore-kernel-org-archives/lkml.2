Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0CaPa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:30:56 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40247 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0CaPaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:30:55 -0400
Date: Wed, 31 Mar 2010 08:30:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: only raise softirq when need
Message-ID: <20100331153037.GD2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB1CE6B.6030207@cn.fujitsu.com>
 <20100330163036.GC2513@linux.vnet.ibm.com>
 <4BB2AF2F.6030406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB2AF2F.6030406@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:10:55AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Tue, Mar 30, 2010 at 06:11:55PM +0800, Lai Jiangshan wrote:
> >> I found something RCU_SOFTIRQ are called without do any thing.
> >> (use function_graph to find it:
> >>  1)               |  rcu_process_callbacks() {
> >>  1)               |    __rcu_process_callbacks() {
> >>  1)   0.634 us    |      rcu_process_gp_end();
> >>  1)   0.487 us    |      check_for_new_grace_period();
> >>  1)   2.672 us    |    }
> >>  1)               |    __rcu_process_callbacks() {
> >>  1)   0.633 us    |      rcu_process_gp_end();
> >>  1)   0.491 us    |      check_for_new_grace_period();
> >>  1)   2.672 us    |    }
> >> )
> >>
> >> This patch make RCU_SOFTIRQ raised when need.
> > 
> > So this seems to have two effects:
> > 
> > 1.	Avoid checking for a quiescent state if RCU doesn't need one
> > 	from this CPU.
> > 
> > 2.	Avoid RCU_SOFTIRQ if RCU did need a quiescent state from
> > 	this CPU, and if rcu_check_callbacks() saw a quiescent state.
> 
> This RCU_SOFTIRQ is not avoided.
> 
> +	if (rdp->qs_pending && rdp->passed_quiesc) {
> +		rdp->n_rp_report_qs++;
>  		return 1;
>  	}
> 
> Old: raise RCU_SOFTIRQ when rdp->qs_pending is not zero
> New: raise RCU_SOFTIRQ when rdp->qs_pending && rdp->passed_quiesc
> 
> So the different effects only happen when this state:
> rdp->qs_pending == 1 && rdp->passed_quiesc == 0,
> But this state will be changed after next rcu_sched_qs() or families.
> So it will not hang up.

You are quite correct.  I clearly need to give myself a day to think
about patches to RCU functionality before replying.  On the other hand,
I might have been just as confused after thinking on it, so airing my
confusion immediately might well have been the optimal approach.  ;-)

So this patch looks like it would work, so the next question is how much
it helps and/or hurts.

> > Except that if rcu_check_callbacks() did see a quiescent state, then we
> > -need- RCU_SOFTIRQ to propagate this up the tree.  So I don't see how
> > this patch helps, and unless I am missing something, it can result in
> > grace-period hangs.  (This CPU is the last one to pass through a
> > quiescent state, and this call to rcu_check_callbacks() finds one,
> > and we fail to report it up the tree.)
> > 
> > Please note that there are other possible causes for empty calls to
> > rcu_process_callbacks():
> > 
> > 1.	RCU needs a call to force_quiescent_state(), but some other
> > 	CPU beats us to it.  We raise RCU_SOFTIRQ, but by the time
> > 	we get there, our work is done.
> > 
> > 2.	RCU needs to check for CPU stalls, but some other CPU beats
> > 	us to it.
> > 
> > 3.	RCU is idle, and this CPU needs another grace period, but
> > 	some other CPU starts up a new grace period before our
> > 	softirq gets started.
> 
> These may happen, but I have not seen any empty call after patch applied.

Before the patch, what fraction of the calls were empty calls?

> > So I do not believe that this patch is worthwhile even if it does turn
> > out to be safe.
> 
> I accept that this patch is not worthwhile.
> 
> Raising empty call is harmless, and it is a chance
> to progress RCU or detect problems.

If you say "this patch has not been yet proven to be worthwhile" instead
of "this patch is not worthwhile", I will agree with you.  Here is a
quick rundown of my thoughts on it, which cannot be considered to be
fully formed:

1.	It cannot improve real-time scheduling latency, since there
	can be RCU_SOFTIRQ actions that really do something.  This
	patch therefore does not improve the worst-case code path
	(though it might -- or might not -- help the average path).

2.	It seems to increase path length a bit, but I doubt that this
	is measurable, so not a valid objection.

3.	It -might- improve throughput, but this would need to be
	proven.  This is the motivation for my question about the
	fraction of empty calls above.

	Kernels that force all softirqs to execute in process
	context (e.g., CONFIG_PREEMPT_RT) are the most likely to
	see benefit from this patch, as a pair of context switches
	are saved in that case.  Of course, CONFIG_PREEMPT_RT is
	more about scheduling latency than maximum throughput.

4.	It does complicate the code a bit, but could be refactored
	to reduce the complication.  (I haven't thought this through,
	but my guess is that the initial check should be factored
	across the "if" statement.)

All that aside, I don't believe the priority of this patch is particularly
high, although it did do a good job of showing that your understanding
of the treercu implementation is increasing.  Which is a very good thing!

Just out of curiosity, what is your test procedure?

							Thanx, Paul
