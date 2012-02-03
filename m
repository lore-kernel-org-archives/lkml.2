Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2BCRme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:42:34 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41018 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab2BCRm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:42:29 -0500
Date: Fri, 3 Feb 2012 09:32:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120203173235.GA4642@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120130205304.0e10b05e@infradead.org>
 <20120131124341.GC4408@elte.hu>
 <1328014076.2446.210.camel@twins>
 <20120131125331.GE4408@elte.hu>
 <1328014916.2446.217.camel@twins>
 <20120202003357.GP2382@linux.vnet.ibm.com>
 <4F2A4361.2020404@linux.vnet.ibm.com>
 <20120202152334.GA2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202152334.GA2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020317-5806-0000-0000-00001207D93A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 07:23:34AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 02, 2012 at 01:33:45PM +0530, Srivatsa S. Bhat wrote:
> > On 02/02/2012 06:03 AM, Paul E. McKenney wrote:
> > > On Tue, Jan 31, 2012 at 02:01:56PM +0100, Peter Zijlstra wrote:

[ . . . ]

> > >> Also related:
> > >>
> > >>  - figure out why cpu_down needs kstopmachine, I'm not sure it does..
> > >>    we should be able to tear down a cpu using synchronize_sched() and a
> > >>    single stop_one_cpu(). (someday when there's time I might actually
> > >>    try to implement this).
> > > 
> > > Currently, a number of the CPU_DYING notifiers assume that they are
> > > running in stop-machine context, including those of RCU.
> > > 
> > > However, this is not an inherent property of RCU -- DYNIX/ptx's
> > > CPU-offline process did not stop the whole machine, after all, and RCU
> > > (we called it rclock, but whatever) was happy with this arrangement.
> > > In fact, if the outgoing CPU could be made to stop in that context
> > > instead of returning to the scheduler and the idle loop, it would make
> > > my life a bit easier.
> > > 
> > > My question is why aren't the notifiers executed in the opposite
> > > order going down and coming up, with the coming-up order matching the
> > > boot order?  Also, why can't the CPU's exit from this world be driven
> > > out of the idle loop?  That way, the CPU wouldn't mark itself offline
> > > (thus in theory to be ignored by CPU), and then immediately dive into
> > > the scheduler and who knows what all else, using RCU all the time.  ;-)
> > > 
> > > (RCU handles this by keeping a separate set of books for online CPUs.
> > > It considers a CPU online at CPU_UP_PREPARE time, and doesn't consider
> > > it offline until CPU_DEAD time.  To handle the grace periods between,
> > > force_quiescent_state() allows the grace period to run a few jiffies
> > > before checking cpu_online_map, which allows a given CPU to safely use
> > > RCU for at least one jiffy before marking itself online and for at least
> > > one jiffy after marking itself offline.)
> > > 
> > > Yet another question is about races between CPU-hotplug events and
> > > registering/unregistering cpu notifiers.  I don't believe that the
> > > current code does what you would like in all cases.
> > 
> > I beg to differ here. There is no race between CPU-hotplug and registering
> > or unregistering of cpu notifiers. The pair cpu_maps_update_begin() and
> > cpu_maps_update_done() is supposed to take care of that right?
> 
> Yes, the integrity of the list itself is guaranteed.
> 
> Unless I am missing something, cpu_maps_update_begin() does not cover
> invocation of all of the notifiers (and for good reason).  One way to
> handle this is to register your notifier early at boot time, so that
> it cannot race with a group of notifications (which is what RCU does).
> If your code is in a module and needs to track the currently online
> CPUs, you might be in for a surprise.  ;-)

And never mind -- I was confused...  Miscounting underscores yet again.
Please accept my apologies for my confusion.

Starting from the top, what does CPU hotplug need to do?

1.	preempt_disable() or something similarly lightweight and
	unconditional must block removal of any CPU that was
	in cpu_online_map at the start of the "critical section".
	(I will identify these as hotplug read-side critical sections.)

	I don't believe that there is any prohibition against a CPU
	appearing suddenly, but some auditing would be required to
	confirm this.  But see below.

2.	A subsystem not involved in the CPU-hotplug process must be able
	to test if a CPU is online and be guaranteed that this test
	remains valid (the CPU remains fully functional) for the duration
	of the hotplug read-side critical section.

3.	If a subsystem needs to operate on all currently online CPUs,
	then it must participate in the CPU-hotplug process.  My
	belief is that if some code needs to test whether a CPU is
	present, and needs an "offline" indication to persist, then
	that code's subsystem must participate in CPU-hotplug operations.

4.	There must be a way to register/unregister for CPU-hotplug events.
	This is currently cpu_notifier(), register_cpu_notifier(),
	and unregister_cpu_notifier().

n-1.	CPU-hotplug operations should be reasonably fast.  Tens of
	milliseconds is OK, multiple seconds not so much.

n.	(Your additional constraints here.)

How to do this?  Here is one possible approach, probably full of holes:

a.	Maintain the cpu_online_map, as currently, but the meaning
	of a set bit is that the CPU is fully functional.  If there
	is any service that the CPU no longer offers, its bit is
	cleared.

b.	Continue to use preempt_enable()/preempt_disable() to mark
	hotplug read-side critical sections.

c.	Instead of using __stop_machine(), use a per-CPU variable that
	is checked in the idle loop.  Possibly another TIF_ bit.

d.	The CPU notifiers are like today, except that CPU_DYING() is
	invoked by the CPU after it sees that its per-CPU variable
	telling it to go offline.  As today, the CPU_DYING notifiers
	are invoked with interrupts disabled, but other CPUs are still
	running.  Of course, the CPU_DYING notifiers need to be audited
	and repaired.  There are fewer than 20 of them, so not so bad.
	RCU's is an easy fix:  Just re-introduce locking and the global
	RCU callback orphanage.  My guesses for the others at the end.

e.	Getting rid of __stop_machine() means that the final step of the
	CPU going offline will no longer be seen as atomic by other CPUs.
	This will require more careful tracking of dependencies among
	different subsystems.  The required tracking can be reduced
	by invoking notifiers in registration order for CPU-online
	operations and invoking them in the reverse of registration
	order for CPU-offline operations.

	For example, the scheduler uses RCU.  If notifiers are invoked in
	the same order for all CPU-hotplug operations, then on CPU-offline
	operations, during the time between when RCU's notifier is invoked
	and when the scheduler's notifier is invoked, the scheduler must
	deal with a CPU on which RCU isn't working.  (RCU currently
	works around this by allowing a one-jiffy time period after
	notification when it still pays attention to the CPU.)

	In contrast, if notifiers are invoked in reverse-registration
	order for CPU-offline operations, then any time the scheduler
	sees a CPU as online, RCU also is treating it as online.

f.	There will be some circular dependencies.  For example, the
	scheduler uses RCU, but in some configurations, RCU also uses
	kthreads.  These dependencies must be handled on a case-by-case
	basis.	For example, the scheduler could invoke an RCU API
	to tell RCU when to shut down its per-CPU kthreads and when
	to start them up.  Or RCU could deal with its kthreads in the
	CPU_DOWN_PREPARE and CPU_ONLINE notifiers.  Either way, RCU
	needs to correctly handle the interval when it cannot use
	kthreads on a given CPU that it is still handling, for example,
	by switching to running the RCU core code in softirq context.

g.	Most subsystems participating in CPU-hotplug operations will need
	to keep their own copy of CPU online/offline state.  For example,
	RCU uses the ->qsmaskinit fields in the rcu_node structure for
	this purpose.

h.	So CPU-offline handling looks something like the following:

	i.	Acquire the hotplug mutex.
	
	ii.	Invoke the CPU_DOWN_PREPARE notifiers.  If there
		are objections, invoke the CPU_DOWN_FAILED notifiers
		and return an error.

	iii.	Clear the CPU's bit in cpu_online_map.
	
	iv.	Invoke synchronize_sched() to ensure that all future hotplug
		read-side critical sections ignore the outgoing CPU.

	v.	Set a per-CPU variable telling the CPU to take itself
		offline.  There would need to be something here to
		help the CPU get to idle quickly, possibly requiring
		another round of notifiers.  CPU_DOWN?

	vi.	When the dying CPU gets to the idle loop, it invokes the
		CPU_DYING notifiers and updates its per-CPU variable to
		indicate that it is ready to die.  It then spins in a
		tight loop (or does some other architecture-specified
		operation to wait to be turned off).

		Note that there is no need for RCU to guess how long the
		CPU might be executing RCU read-side critical sections.

	vii.	When the task doing the offline operation sees the
		updated per-CPU variable, it calls __cpu_die().

	viii.	The CPU_DEAD notifiers are invoked.

	ix.	Theeck_for_tasks() function is invoked.

	x.	Release the hotplug mutex.

	xi.	Invoke the CPU_POST_DEAD notifiers.

i.	I do not believe that the CPU-offline handling needs to change
	much.


CPU_DYING notifiers as of 3.2:

o	vfp_hotplug():  I believe that this works as-is.
o	s390_nohz_notify():  I believe that this works as-is.
o	x86_pmu_notifier():  I believe that this works as-is.
o	perf_ibs_cpu_notifier():  I don't know enough about
	APIC to say.
o	tboot_cpu_callback():  I believe that this works as-is,
	but this one returns NOTIFY_BAD to a CPU_DYING notifier,
	which is badness.  But it looks like that case is a
	"cannot happen" case.  Still needs to be fixed.
o	clockevents_notify():  This one acquires a global lock,
	so it should be safe as-is.
o	console_cpu_notify():  This one takes the same action
	for CPU_ONLINE, CPU_DEAD, CPU_DOWN_FAILED, and
	CPU_UP_CANCELLED that it does for CPU_DYING, so it
	should be OK.
o	rcu_cpu_notify():  This one needs adjustment as noted
	above, but nothing major.
o	migration_call():  I defer to Peter on this one.
	It looks to me like it is written to handle other
	CPUs, but...
o	workqueue_cpu_callback(): Might need help, does a
	non-atomic OR.
o	kvm_cpu_hotplug(): Uses a global spinlock, so should
	be OK as-is.

Thoughts?

							Thanx, Paul

