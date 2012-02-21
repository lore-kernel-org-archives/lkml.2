Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2BURZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:25:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57204 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2BURZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:25:36 -0500
Date: Tue, 21 Feb 2012 09:24:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
Message-ID: <20120221172442.GG2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120213020951.GA12138@linux.vnet.ibm.com>
 <4F41F315.1040900@cn.fujitsu.com>
 <20120220174418.GI2470@linux.vnet.ibm.com>
 <4F42EF53.6060400@cn.fujitsu.com>
 <20120221015037.GE2384@linux.vnet.ibm.com>
 <4F435966.9020106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F435966.9020106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-7408-0000-0000-000002D8727F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 04:44:22PM +0800, Lai Jiangshan wrote:
> On 02/21/2012 09:50 AM, Paul E. McKenney wrote:
> > On Tue, Feb 21, 2012 at 09:11:47AM +0800, Lai Jiangshan wrote:
> >> On 02/21/2012 01:44 AM, Paul E. McKenney wrote:
> >>
> >>>
> >>>> My conclusion, we can just remove the check-and-return path to reduce
> >>>> the complexity since we will introduce call_srcu().
> >>>
> >>> If I actually submit the above upstream, that would be quite reasonable.
> >>> My thought is that patch remains RFC and the upstream version has
> >>> call_srcu().
> >>
> >> Does the work of call_srcu() is started or drafted?
> > 
> > I do have a draft design, and am currently beating it into shape.
> > No actual code yet, though.  The general idea at the moment is as follows:
> 
> If you don't mind, I will implement it.(it requires your new version of SRCU implementation)

I would very much welcome a patch from you for call_srcu()!

I have an rcu/srcu branch for this purpose at:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

> > o	The state machine must be preemptible.	I recently received
> > 	a bug report about 200-microsecond latency spikes on a system
> > 	with more than a thousand CPUs, so the summation of the per-CPU
> > 	counters and subsequent recheck cannot be in a preempt-disable
> > 	region.  I am therefore currently thinking in terms of a kthread.
> 
> sure.
> 
> Addition:
> 	Srcu callbacks must run on process context and sleepable,
> 	(and therefore they finish orderless). We can't change
> 	the current rcu-callback, we must design a new for srcu.
> 	These do not introduce any complexity, we reuse the workqueue.
> 	All ready srcu-callback will be delivered to workqueue.
> 	so state-machine-thread only to do counter summation
> 	and checking and delivering.
> 
> 	workqueue do all the complexity for us, it will auto
> 	alloc threads when needed(when the callback is sleep, or
> 	there are too much ready callbacks).
> 
> 	struct srcu_head is a little bigger than struct rcu_head, 
> 	it contain a union for struct work_struct.
> 
> 	(synchronize_srcu()'s callbacks are special handled)

Full separation of counter summation etc. from callback invocation sounds
very good.  There does need to be something like an srcu_barrier(), so the
SRCU callbacks posted by a given CPU do need to be invoked in the order
that they were posted (unless you have some other trick in mind, in which
case please let us all know what it is).  Given the need to keep things
in order, I do not believe that we can allow the SRCU callbacks to sleep.
Note that there is no need for srcu_barrier() to wait on the expedited
SRCU callbacks -- there should not be an call_srcu_expedited(), so the
only way for the callbacks to appear is synchronize_srcu_expedited(),
which does not return until after its callback has been invoked.
This means that expedited SRCU callbacks need not be ordered -- in fact,
the expedited path need not use callbacks at all, if that works better.
(I was thinking in terms of expedited callbacks for SRCU because that
makes the state machine simpler.)

That said, the idea of invoking them from a workqueue seems reasonable,
for example, you can do local_disable_bh() around each invocation.  Doing
this also gives us the flexibility to move SRCU callback invocation into
softirq if that proves necessary for whatever reason.  (Yes, I do still
well remember the 3.0 fun and excitement with RCU and kthreads!)

But I have to ask...  Why does SRCU need more space than RCU?  Can't
the selection of workqueue be implicit based on which CPU the callback
is queued on?

> > o	At the moment, having a per-srcu_struct kthread seems excessive.
> > 	I am planning on a single kthread to do the counter summation
> > 	and checking.  Further parallelism might be useful in the future,
> > 	but I would want to see someone run into problems before adding
> > 	more complexity.
> 
> Simple is important, I vote for a single kthread to do the counter summation
> and checking, and left the convenient that we can introduce parallelism
> thread easy.

Very good!

> > o	There needs to be a linked list of srcu_struct structures so
> > 	that they can be traversed by the state-machine kthread.
> > 
> > o	If there are expedited SRCU callbacks anywhere, the kthread
> > 	would scan through the list of srcu_struct structures quickly
> > 	(perhaps pausing a few microseconds between).  If there are no
> > 	expedited SRCU callbacks, the kthread would wait a jiffy or so
> > 	between scans.
> 
> Sure
> But I think generic expedited SRCU callbacks are make no sense,
> we could just allow expedited SRCU callbacks for synchronize_srcu_expedited()
> only.

Agreed -- We don't have call_rcu_expedited(), so we should definitely
not provide call_srcu_expedited().

> > o	If a given srcu_struct structure has been scanned too many times
> > 	(say, more than ten times) while waiting for the counters to go
> > 	to zero, it loses expeditedness.  It makes no sense for the kthread
> > 	to go CPU-bound just because some SRCU reader somewhere is blocked
> > 	in its SRCU read-side critical section.
> > 
> > o	Expedited SRCU callbacks cannot be delayed by normal SRCU
> > 	callbacks, but neither can expedited callbacks be allowed to
> > 	starve normal callbacks.  I am thinking in terms of invoking these
> > 	from softirq context, with a pair of multi-tailed callback queues
> > 	per CPU, stored in the same structure as the per-CPU counters.
> 
> My Addition design, callbacks are not running in softirq context.
> And state-machine-thread is not delay by any normal callbacks.
> 
> But all synchronize_srcu()'s callback are done in state-machine-thread
> (it is just a wake up), not in workqueue.

So the idea is that the function pointer is a task_struct pointer in this
case, and that you check for a text address to decide which?  In any case,
a per-callback wake up should be OK.

> Since we allow expedited SRCU callbacks for synchronize_srcu_expedited() only,
> Expedited SRCU callbacks will not be delayed by normal srcu callbacks.

OK, good.

> I don't think we need to use per CPU callback queues, since SRCU callbacks
> are rare(compared to rcu callbacks)

Indeed, everything currently in the kernel would turn into a wakeup.  ;-)

> > o	There are enough srcu_struct structures in the Linux that
> > 	it does not make sense to force softirq to dig through them all
> > 	any time any one of them has callbacks ready to invoke.  One way
> > 	to deal with this is to have a per-CPU set of linked lists of
> > 	of srcu_struct_array structures, so that the kthread enqueues
> > 	a given structure when it transitions to having callbacks ready
> > 	to invoke, and softirq dequeues it.  This can be done locklessly
> > 	given that there is only one producer and one consumer.
> > 
> > o	We can no longer use the trick of pushing callbacks to another
> > 	CPU from the CPU_DYING notifier because it is likely that CPU
> > 	hotplug will stop using stop_cpus().  I am therefore thinking
> > 	in terms of a set of orphanages (two for normal, two more for
> > 	expedited -- one set of each for callbacks ready to invoke,
> > 	the other for still-waiting callbacks).
> 
> no such issues in srcu.c if we use workqueue.

OK, sounds good.

> > o	There will need to be an srcu_barrier() that can be called
> > 	before cleanup_srcu_struct().  Otherwise, someone will end up
> > 	freeing up an srcu_struct that still has callbacks outstanding.
> 
> Sure.
> 
> when use workqueue, the delivering is ordered.
> 
> srcu_barrier()
> {
> 	synchronzie_srcu();
> 	flush_workqueue();
> }

Would this handle the case where the SRCU kthread migrated from one CPU
to another?  My guess is that you would need to flush all the workqueues
that might have ever had SRCU-related work pending on them.

> > But what did you have in mind?
> 
> I agree most of your design, but my relaxing the ability for callbacks and
> using workqueue ideas make things simpler.

Your approach looks good in general.  My main concerns are:

1.	We should prohibit sleeping in SRCU callback functions, at least
	for the near future -- just in case something forces us to move
	to softirq.

2.	If SRCU callbacks can use rcu_head, that would be good -- I don't
	yet see why any additional space is needed.

							Thanx, Paul

> Thanks,
> Lai
> 
> > 
> >>>> This new srcu is very great, especially the SRCU_USAGE_COUNT for every
> >>>> lock/unlock witch forces any increment/decrement pair changes the counter
> >>>> for me.
> >>>
> >>> Glad you like it!  ;-)
> >>>
> >>> And thank you for your review and feedback!
> >>
> >> Could you add my Reviewed-by when this patch is last submitted?
> >>
> >>
> >> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Will do, thank you!
> > 
> > 							Thanx, Paul
> > 
> > 
> 

