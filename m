Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1CMF4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 00:56:39 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:50922 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1CMF4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 00:56:38 -0500
Date: Sat, 12 Mar 2011 21:56:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: JRCU Theory of Operation
Message-ID: <20110313055627.GW2234@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
 <20110310003419.GE2196@linux.vnet.ibm.com>
 <20110310195045.GA22146@tsunami.ccur.com>
 <20110312143629.GT2234@linux.vnet.ibm.com>
 <20110313004336.GA14518@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110313004336.GA14518@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 07:43:36PM -0500, Joe Korty wrote:
> On Sat, Mar 12, 2011 at 09:36:29AM -0500, Paul E. McKenney wrote:
> > On Thu, Mar 10, 2011 at 02:50:45PM -0500, Joe Korty wrote:
> >>
> >> A longer answer, on a slighly expanded topic, goes as follows.  The heart
> >> of jrcu is in this (slighly edited) line,
> >>
> >>   rcu_data[cpu].wait = preempt_count_cpu(cpu) > idle_cpu(cpu);
> > 
> > So, if we are idle, then the preemption count must be 2 or greater
> > to make the current grace period wait on a CPU.  But if we are not
> > idle, then the preemption count need only be 1 or greater to make
> > the current grace period wait on a CPU.
> > 
> > But why do should an idle CPU block the current RCU grace period
> > in any case?  The idle loop is defined to be a quiescent state
> > for rcu_sched.  (Not that permitting RCU read-side critical sections
> > in the idle loop would be a bad thing, as long as the associated
> > pitfalls were all properly avoided.)
> 
> Amazingly enough, the base preemption level for idle is '1', not '0'.
> This suprised me deeply, but on reflection it made sense.  When idle
> needs to be preempted, there is no need to actually preempt it .. one
> just kick starts it and it will go execute the schedule for you.

Ah, got it, thank you!

> >> Here, the garbage collector is making an attempt to deduce, at the
> >> start of the current batch, whether or not some cpu is executing code
> >> in a quiescent region.  If it is, then that cpu's wait state can be set
> >> to zero right away -- we don't have to wait for that cpu to execute a
> >> quiescent point tap later on to discover that fact.  This nicely covers
> >> the user app and idle cpu situations discussed above.
> >>
> >> Now, we all know that fetching the preempt_count of some process running on
> >> another cpu is guaranteed to return a stale (obsolete) value, and may even
> >> be dangerous (pointers are being followed after all).  Putting aside the
> >> question of safety, for now, leaves us with a trio of questions: are there
> >> times when this inherently unstable value is in fact stable and useful?
> >> When it is not stable, is that fact relevant or irrelevant to the correct
> >> operation of jrcu? And finally, does the fact that we cannot tell when
> >> it is stable and when it is not, also relevant?
> > 
> > And there is also the ordering of the preempt_disable() and the accesses
> > within the critical section...  Just because you recently saw a quiescent
> > state doesn't mean that the preceding critical section has completed --
> > even x86 is happy to spill stores out of a critical section ended by
> > preempt_enable.  If one of those stores is to an RCU protected
> > data structure, you might end up freeing the structure before the
> > store completed.
> > 
> > Or is the idea that you would wait 50 milliseconds after detecting
> > the quiescent state before invoking the corresponding RCU callbacks?
> 
> Yep.  

OK.

> > I am missing how ->which switching is safe, given the possibility of
> > access from other CPUs.
> 
> JRCU allows writes to continue through the old '->which'
> value for a period of time.  All it requires is that
> within 50 msecs that the writes have ceased and that
> the writing cpu has executed a smp_wmb() and the effects
> of the smp_wmb() have propagated throughout the system.
> 
> Even though I keep saying 50msecs for everything, I
> suspect that the Q switching meets all the above quiescent
> requirements in a few tens of microseconds.  Thus even
> a 1 msec JRCU sampling period is expected to be safe,
> at least in regard to Q switching.

I would feel better about this is the CPU vendors were willing to give
an upper bound...

							Thanx, Paul
