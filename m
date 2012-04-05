Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2DEXHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:07:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39241 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2DEXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:07:04 -0400
Date: Thu, 5 Apr 2012 16:06:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
Message-ID: <20120405230654.GB19607@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <4F67474A.20707@linux.vnet.ibm.com>
 <20120405173918.GC8194@linux.vnet.ibm.com>
 <20120405175549.GA9127@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405175549.GA9127@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040523-3270-0000-0000-0000055C308C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is my attempt at a summary of the discussion.

Srivatsa, I left out the preempt_disable() pieces, but would be happy
to add them in when you let me know what you are thinking to do for
de-stop_machine()ing CPU hotplug.

							Thanx, Paul

------------------------------------------------------------------------

CPU-hotplug work breakout:

1.	Read and understand the current generic code.
	Srivatsa Bhat has done this, as have Paul E. McKenney and
	Peter Zijlstra to a lesser extent.

2.	Read and understand the architecture-specific code, looking
	for opportunities to consolidate additional function into
	core code.

	a.	Carry out any indicated consolidation.

	b.	Convert all architectures to make use of the
		consolidated implementation.

	Not started.  Low priority from a big.LITTLE perspective.

3.	Address the current kthread creation/teardown/migration
	performance issues.  (More details below.)

	Highest priority from a big.LITTLE perspective.

4.	Wean CPU-hotplug offlining from stop_machine().
	(More details below.)

	Moderate priority from a big.LITTLE perspective.


ADDRESSING KTHREAD CREATION/TEARDOWN/MIGRATION PERFORMANCE ISSUES

1.	Evaluate approaches.  Approaches currently under
	consideration include:

	a.	Park the kthreads rather than tearing them down or
		migrating them.  RCU currently takes this sort of
		approach.  Note that RCU currently relies on both
		preempt_disable() and local_bh_disable() blocking the
		current CPU from going offline.

	b.	Allow in-kernel kthreads to avoid the delay
		required to work around a bug in old versions of
		bash.  (This bug is a failure to expect receiving
		a SIGCHILD signal corresponding to a child
		created by a fork() system call that has not yet
		returned.)

		This might be implemented using an additional
		CLONE_ flag.  This should allow kthreads to
		be created and torn down much more quickly.

	c.	Have some other TBD way to "freeze" a kthread.
		(As in "your clever idea here".)

2.	Implement the chosen approach or approaches.  (Different
	kernel subsystems might have different constraints, possibly
	requiring different kthread handling.)


WEAN CPU-HOTPLUG OFFLINING FROM stop_machine()


1.	CPU_DYING notifier fixes needed as of 3.2:

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
	*	rcu_cpu_notify():  This one needs adjustment as noted
		above, but nothing major.  Patch has been posted,
		probably needs a bit of debugging.
	o	migration_call():  I defer to Peter on this one.
		It looks to me like it is written to handle other
		CPUs, but...
	*	workqueue_cpu_callback(): Might need help, does a
		non-atomic OR.
	o	kvm_cpu_hotplug(): Uses a global spinlock, so should
		be OK as-is.

2.	Evaluate designs for stop_machine()-free CPU hotplug.
	Implement the chosen design.  An outline for a particular
	design is shown below, but the actual design might be
	quite different.

3.	Fix issues with CPU Hotplug callback registration. Currently
	there is no totally-race-free way to register callbacks and do
	setup for already online cpus.

	Srivatsa had posted an incomplete patchset some time ago
	regarding this, which gives an idea of the direction he had
	in mind.
	http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826

4.	There is a mismatch between the code and the documentation around
	the difference between [un/register]_hotcpu_notifier and
	[un/register]_cpu_notifier. And I remember seeing several places
	in the code that uses them inconsistently. Not terribly important,
	but good to fix it up while we are at it.

5.	There was another thread where stuff related to CPU hotplug had
	been discussed. It had exposed some new challenges to CPU hotplug,
	if we were to support asynchronous smp booting.

	http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48535
	http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48542
	http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253241
	http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253267

6.	If preempt_disable() no longer blocks CPU offlining, then
	uses of preempt_disable() in the kernel need to be inspected
	to see which are relying on blocking offlining, and any
	identified will need adjustment.


DRAFT REQUIREMENTS FOR stop_machine()-FREE CPU HOTPLUG

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

n-1.	CPU-hotplug operations should be reasonably fast.  A few
	milliseconds is OK, multiple seconds not so much.

n.	(Your additional constraints here.)


STRAWMAN DESIGN FOR stop_machine()-FREE CPU HOTPLUG

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

