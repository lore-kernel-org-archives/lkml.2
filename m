Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1CJTwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:52:40 -0500
Received: from flusers.ccur.com ([173.221.59.2]:36723 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753125Ab1CJTwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:52:38 -0500
Date: Thu, 10 Mar 2011 14:50:45 -0500
From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
        "houston.jim@comcast.net" <houston.jim@comcast.net>, corbet@lwn.net
Subject: JRCU Theory of Operation
Message-ID: <20110310195045.GA22146@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
 <20110310003419.GE2196@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310003419.GE2196@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 07:34:19PM -0500, Paul E. McKenney wrote:
> On Wed, Mar 09, 2011 at 05:15:17PM -0500, Joe Korty wrote:
>> jrcu: tap into rcu_read_unlock().
>> 
>> All places where rcu_read_unlock() is the final lock in
>> a set of nested rcu locks are known rcu quiescent points.
>> This patch recognizes that subset of those which also make
>> the task preemptable.  The others are left unrecognized.
>> 
>> Not fundamentally needed, accelerates rcu batching.
> 
> Wouldn't you need to hook rcu_read_lock() as well, at least in
> the CONFIG_PREEMPT_RCU case?  Otherwise, the RCU read-side critical
> section's accesses could leak out, possibly causing an RCU read-side
> critical section that looked like it started after a given grace period
> (thus not blocking that grace period) actually have accesses that precede
> the grace period?  If this situation could arise, the grace period could
> end too soon, resulting in memory corruption.
> 
> Or am I missing something here?
> 
> 							Thanx, Paul




Hi Paul,
The short answer is, jrcu tolerates data leaks (but not
pointer leaks) in certain critical variables, up to the
length of one RCU_HZ sampling period (50 milliseconds).
That is, changes being made to these variables on one cpu
must be 'seeable' on other cpus within the 50 msec window.
Jrcu uses memory barriers for this purpose, but perhaps
not yet in every place such are actually needed.

  An aside: AFAICT, cpu hardware makes an active effort to
  push out store buffers to cache, where they can be snooped.
  Cpus just don't leave writes indefinately in store buffers
  for no reason. If, however, one believes (or knows) that
  there are modes where a cpu can hold store buffers out
  of cache indefinately, say over 50 msecs, then I need
  to scatter a few more more memory barriers (like those
  currently under CONFIG_RCU_PARANOID) around the kernel.
  One (maybe the only) place that would need this is in
  add_preempt_count().

The above variables being sampled by the rcu garbage
collector are either stable (unchanging) or unstable.
When stable, jrcu by definition makes correct decisions.
When unstable, it doesn't make any difference what jrcu
decides -- instability means that within the last 50 msecs
there was one or more quiescent periods, therefore, jrcu
can either end or not end the current batch one RCU_HZ period
from now. No matter what it does, it will be correct.


A longer answer, on a slighly expanded topic, goes as follows.  The heart
of jrcu is in this (slighly edited) line,

  rcu_data[cpu].wait = preempt_count_cpu(cpu) > idle_cpu(cpu);

This is in the garbage collector, at the point where it is initializing
the state of all cpus as part of setting up a new 'current batch'.
Let us first consider the consequences of a simplification of the above,

  rcu_data[cpu].wait = 1;

A value of '1' means that that cpu has not yet consented to end-of-batch.
A value of '0' means that this cpu has no objection to the current batch
ending.  The current batch actually ends only when the garbage collector
wakes up and notices that all the wait states are zero.  It does this
at a RCU_HZ==20 (50 msec) rate.

In this simplified scenario, each cpu has an obligation to zero its wait
state at at least some of the places where it knows it has no objection
to the current batch ending (quiescent point taps).  One such point is
in context switch, another possible point for a tap is all the places
where preempt_count() goes to zero.

The problem with the above "initialize all wait states to 1" scenario, is
that every cpu must then pass through some tapped quiescent point before
the garbage collector will ever consider the current batch to have ended.
This does not work well for completely idle cpus or for cpus spending 100%
of their time in user space, as these are in a quiescent region that will
never execute a tap.  Hence we now get to a more involved simplification
of the original expression,

  rcu_data[cpu].wait = preempt_count_cpu(cpu) > 0;

Here, the garbage collector is making an attempt to deduce, at the
start of the current batch, whether or not some cpu is executing code
in a quiescent region.  If it is, then that cpu's wait state can be set
to zero right away -- we don't have to wait for that cpu to execute a
quiescent point tap later on to discover that fact.  This nicely covers
the user app and idle cpu situations discussed above.

Now, we all know that fetching the preempt_count of some process running on
another cpu is guaranteed to return a stale (obsolete) value, and may even
be dangerous (pointers are being followed after all).  Putting aside the
question of safety, for now, leaves us with a trio of questions: are there
times when this inherently unstable value is in fact stable and useful?
When it is not stable, is that fact relevant or irrelevant to the correct
operation of jrcu? And finally, does the fact that we cannot tell when
it is stable and when it is not, also relevant?

First, we know the preempt_count_cpu() > 0 expression will gradually
become stable during certain critical times: when an application stays
constantly in user space, and when a cpu stays idle, doing no interrupt or
softirq processing.  In these cases the stable value converged to will be
'0' (0 == cpu is in a quiescent state).

We also know that the preempt_count_cpu() > 0 expression will gradually
get stable whenever a cpu stays in an rcu-protected region for some
long period of time.  In this case the expression converges on '1' (1 ==
cpu is executing code in an rcu-protected region).

For both of the above cases, jrcu requires that the value being fetched by
preempt_count_cpu() actually to have been that cpu's preempt_count sometime
within the last 50 msecs.  Thus, within 50 msecs of a cpu getting a stable
preempt count, preempt_count_cpu() will start returning that same value
to the garbage collector, which will then start making correct decisions
for as long as the returned value remains stable.

Next we come to the situation where preempt_count_cpu() is unstable.  It may
be unstable because its value is constantly transitioning between a zero
and nonzero state (we don't care about transitions between various nonzero
states), or it may be unstable because of context switch.  It doesn't
matter which, all that really counts is that the instability means that the
remote cpu is making transitions between rcu protected and rqu quiescent
states, and that it has done this in the recent past .. 'recent' meaning,
the time it takes for writes on the remote cpu to become 'seeable' on
the cpu with the garbage collector (which jrcu requires to be < 50msecs).

What really counts here is that instability means there was a recent
quiescent state which in turn means that we can set the cpu wait state
to either '1' (wait for a quiescent point tap) or '0' (tap not needed,
a quiescent state has already happened), and all will work correctly.

A final issue is the stability of the remote thread_info pointer that
preempt_count_cpu() uses.  First off, if this pointer is not stable that
means that the cpu has recently gone through a task switch which means it
doesn't matter what the cpu wait state is set to, as context switches by
definition are quiescent points.  But, we would also like to make sure
that the pointer actually points to valid memory, specifically to the
thread_info structure actually associated with a task recently executed
(within 50 msecs) on the remote cpu.  There is only one way for such a
pointer to become invalid: between the time it was fetched and when it
is dereference to get the remote preempt_count, the remote task switched
away and executed the overhead of performing a task exit, including doing
the final kfree of the task's thread_info structure.  That is a pretty
heavyweight execution sequence.  In terms of races, the preempt_count_cpu()
code will win out over context_switch + task exit every time, _if_ 1) it is
always invoked under raw_local_irq_disable, and 2) a write memory barrier
is added everywhere in the kernel this pointer is changed, and 3) a read
memory barrier exists just before everywhere preempt_count_cpu is executed.

In the original expression,

  rcu_data[cpu].wait = preempt_count_cpu(cpu) > idle_cpu(cpu);

The 'idle_cpu' part is needed only because preempt_count() == 1 is the
default state of the idle task.  Without it jrcu will never see idle cpus as
being in a quiescent state.  The same rules about stability and instability
for preempt_count_cpu() also apply to idle_cpu().  However, idle_cpu()
follows no pointer so that complication thankfully does not apply to it.

I am sure there are other interesting details, but my mind is burned out
now from putting this together, and I can't think of them.

Regards,
Joe
