Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1CMBZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 20:25:52 -0500
Received: from flusers.ccur.com ([173.221.59.2]:31038 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756311Ab1CMBZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 20:25:51 -0500
Date: Sat, 12 Mar 2011 20:25:04 -0500
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
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110313012504.GB14518@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110312143653.GA22072@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312143653.GA22072@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 09:36:53AM -0500, Paul E. McKenney wrote:
> Hello, Joe,
> 
> My biggest question is "what does JRCU do that Frederic's patchset
> does not do?"  I am not seeing it at the moment.  Given that Frederic's
> patchset integrates into RCU, thus providing the full RCU API, I really
> need a good answer to consider JRCU.

Well, it's tiny, it's fast, and it does exactly one thing
and does that really well.  If a user doesn't need that
one thing they shouldn't use JRCU.  But mostly it is an
exciting thought-experiment on another interesting way to
do RCU.  Who knows, maybe it may end up being better than
for what it was aimed at.

> For one, what sort of validation have you done?
> 
>                                                         Thanx, Paul

Not much, I'm writing the code and sending it out for
comment.  And it is currently missing many of the tweaks
needed to make it a production RCU.



>> +struct rcu_data {
>> +     u8 wait;                /* goes false when this cpu consents to
>> +                              * the retirement of the current batch */
>> +     u8 which;               /* selects the current callback list */
>> +     struct rcu_list cblist[2]; /* current & previous callback lists */
>> +} ____cacheline_aligned_in_smp;
>> +
>> +static struct rcu_data rcu_data[NR_CPUS];
> 
> Why not DEFINE_PER_CPU(struct rcu_data, rcu_data)?

All part of being lockless.  I didn't want to have to tie
into cpu onlining and offlining and wanted to eliminate
sprinking special tests and/or online locks throughout
the code.  Also, note the single for_each_present_cpu(cpu)
statement in JRCU .. this loops over all offline cpus and
gradually expires any residuals they have left behind.


>> +/*
>> + * Return our CPU id or zero if we are too early in the boot process to
>> + * know what that is.  For RCU to work correctly, a cpu named '0' must
>> + * eventually be present (but need not ever be online).
>> + */
>> +static inline int rcu_cpu(void)
>> +{
>> +     return current_thread_info()->cpu;
> 
> OK, I'll bite...  Why not smp_processor_id()?

Until recently, it was :) but it was a multiline thing,
with 'if' stmts and such, to handle early boot conditions
when smp_processor_id() isn't valid.

JRCU, perhaps quixotically,  tries to do something
meaningful all the way back to the first microsecond of
existance, when the CPU is switched from 16 to 32 bit mode.
In that early epoch, things like 'cpus' and 'interrupts'
and 'tasks' don't quite yet exist in the form we are used
to for them.

> And what to do about the architectures that put the CPU number somewhere
> else?

I confess I keep forgetting to look at that other 21 or
so other architectures, I had thought they all had ->cpu.
I look into it and, at least for those, reintroduce the
old smp_processor_id() expression.


>> +void rcu_barrier(void)
>> +{
>> +     struct rcu_synchronize rcu;
>> +
>> +     if (!rcu_scheduler_active)
>> +             return;
>> +
>> +     init_completion(&rcu.completion);
>> +     call_rcu(&rcu.head, wakeme_after_rcu);
>> +     wait_for_completion(&rcu.completion);
>> +     atomic_inc(&rcu_stats.nbarriers);
>> +
>> +}
>> +EXPORT_SYMBOL_GPL(rcu_barrier);
> 
> The rcu_barrier() function must wait on all RCU callbacks, regardless of
> which CPU they are queued on.  This is important when unloading modules
> that use call_rcu().  In contrast, the above looks to me like it waits
> only on the current CPU's callbacks.

Oops.  I'll come up with an alternate mechanism.  Thanks for finding this.


> So, what am I missing?

Nothing.  You were right :)



>> +     /*
>> +      * Swap current and previous lists.  Other cpus must not see this
>> +      * out-of-order w.r.t. the just-completed plist init, hence the above
>> +      * smp_wmb().
>> +      */
>> +     rd->which++;
> 
> You do seem to have interrupts disabled when sampling ->which, but
> this is not safe for cross-CPU accesses to ->which, right?  The other
> CPU might queue onto the wrong element.  This would mean that you
> would not be guaranteed a full 50ms delay from quiescent state to
> corresponding RCU callback invocation.
> 
> Or am I missing something subtle here?


JRCU expects updates to the old queue to continue for a
while, it only requires that they end and a trailing wmb
be fully executed before the next sampling period ends.


>> +     /*
>> +      * End the current RCU batch and start a new one.
>> +      */
>> +     for_each_present_cpu(cpu) {
>> +             rd = &rcu_data[cpu];
> 
> And here we get the cross-CPU accesses that I was worried about above.


Yep.  This is one of the trio of reasons why JRCU is for
small SMP systems.  It's the tradeoff I made to move the
entire RCU load off onto one CPU.  If that is not important
(and it won't be to any but to specialized systems), one
is expected to use RCU_TREE.

The other two of the trio of reasons: doing kfree's on the
'wrong' cpu puts the freed buffer in the 'wrong' per-cpu
free queue, and putting all the load on one cpu means
that cpu could hit 100% cpu utilization just doing rcu
callbacks, for systems with thousands of cpus and have
the io fabrics necessary to keep those cpus busy.

Regards,
Joe
