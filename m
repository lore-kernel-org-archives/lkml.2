Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2DIQqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:46:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44301 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2DIQqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:46:47 -0400
Date: Mon, 9 Apr 2012 09:46:28 -0700
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
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        nikunj@linux.vnet.ibm.com
Subject: Re: CPU Hotplug rework
Message-ID: <20120409164628.GA2430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <4F67474A.20707@linux.vnet.ibm.com>
 <20120405173918.GC8194@linux.vnet.ibm.com>
 <20120405175549.GA9127@linux.vnet.ibm.com>
 <20120405230654.GB19607@linux.vnet.ibm.com>
 <4F7F4EF0.70305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7F4EF0.70305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040916-7182-0000-0000-00000136FF42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 01:45:44AM +0530, Srivatsa S. Bhat wrote:
> On 04/06/2012 04:36 AM, Paul E. McKenney wrote:
> 
> > Hello,
> > 
> > Here is my attempt at a summary of the discussion.
> > 
> 
> 
> Thanks for the summary, it is really helpful :-)
> 
> > Srivatsa, I left out the preempt_disable() pieces, but would be happy
> > to add them in when you let me know what you are thinking to do for
> > de-stop_machine()ing CPU hotplug.
> >
> 
> 
> Ok..
> 
> 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > CPU-hotplug work breakout:
> > 
> > 1.	Read and understand the current generic code.
> > 	Srivatsa Bhat has done this, as have Paul E. McKenney and
> > 	Peter Zijlstra to a lesser extent.
> 
> 
> 	"lesser extent"?? Hell no! :-) ;-)

Certainly to a lesser extent on my part, but yes, I should not speak
for Peter.

> > 2.	Read and understand the architecture-specific code, looking
> > 	for opportunities to consolidate additional function into
> > 	core code.
> > 
> > 	a.	Carry out any indicated consolidation.
> > 
> > 	b.	Convert all architectures to make use of the
> > 		consolidated implementation.
> > 
> > 	Not started.  Low priority from a big.LITTLE perspective.
> 
> 
> Recently this unexpectedly assumed high priority due to some scheduler
> changes and things got fixed up temporarily. And in that context,
> Peter Zijlstra gave some more technical pointers on what is wrong and needs
> to be done right. Link: https://lkml.org/lkml/2012/3/22/149
> 
> Nikunj (in CC) has offered to work with me on this consolidation.

Very cool!  I have added the following:

------------------------------------------------------------------------

CONSOLIDATE ARCHITECTURE-SPECIFIC CPU-HOTPLUG CODE

1.	Ensure that all CPU_STARTING notifiers complete before the
	incoming CPU is marked online (the blackfin architecture
	fails to do this).

2.	Ensure that interrupts are disabled throughout the CPU_STARTING
	notifiers.  Currently, blackfin, cris, m32r, mips, sh, sparc64,
	um, and x86 fail to do this properly.

3.	Ensure that all architectures that use CONFIG_USE_GENERIC_SMP_HELPERS
	hold ipi_call_lock() over the entire CPU-online process.  Currently,
	alpha, arm, m32r, mips, sh, and sparc32 seem to fail to do this
	properly.

4.	Additional memory barriers are likely to be needed, for example,
	an smp_wmb() after setting cpu_active and an smp_rmb() in
	select_fallback_rq() before reading cpu_active.

Srivatsa Bhat (srivatsa.bhat@linux.vnet.ibm.com) and Nikunj A Dadhania
(nikunj@linux.vnet.ibm.com) are taking on this work.

------------------------------------------------------------------------

Please let me know if adjustments are needed.

> > 3.	Address the current kthread creation/teardown/migration
> > 	performance issues.  (More details below.)
> > 
> > 	Highest priority from a big.LITTLE perspective.
> > 
> > 4.	Wean CPU-hotplug offlining from stop_machine().
> > 	(More details below.)
> > 
> > 	Moderate priority from a big.LITTLE perspective.
> > 
> > 
> > ADDRESSING KTHREAD CREATION/TEARDOWN/MIGRATION PERFORMANCE ISSUES
> > 
> > 1.	Evaluate approaches.  Approaches currently under
> > 	consideration include:
> > 
> > 	a.	Park the kthreads rather than tearing them down or
> > 		migrating them.  RCU currently takes this sort of
> > 		approach.  Note that RCU currently relies on both
> > 		preempt_disable() and local_bh_disable() blocking the
> > 		current CPU from going offline.
> > 
> > 	b.	Allow in-kernel kthreads to avoid the delay
> > 		required to work around a bug in old versions of
> > 		bash.  (This bug is a failure to expect receiving
> > 		a SIGCHILD signal corresponding to a child
> > 		created by a fork() system call that has not yet
> > 		returned.)
> > 
> > 		This might be implemented using an additional
> > 		CLONE_ flag.  This should allow kthreads to
> > 		be created and torn down much more quickly.
> > 
> > 	c.	Have some other TBD way to "freeze" a kthread.
> > 		(As in "your clever idea here".)
> > 
> > 2.	Implement the chosen approach or approaches.  (Different
> > 	kernel subsystems might have different constraints, possibly
> > 	requiring different kthread handling.)
> > 
> > 
> > WEAN CPU-HOTPLUG OFFLINING FROM stop_machine()
> > 
> > 
> > 1.	CPU_DYING notifier fixes needed as of 3.2:
> > 
> > 	o	vfp_hotplug():  I believe that this works as-is.
> > 	o	s390_nohz_notify():  I believe that this works as-is.
> > 	o	x86_pmu_notifier():  I believe that this works as-is.
> > 	o	perf_ibs_cpu_notifier():  I don't know enough about
> > 		APIC to say.
> > 	o	tboot_cpu_callback():  I believe that this works as-is,
> > 		but this one returns NOTIFY_BAD to a CPU_DYING notifier,
> > 		which is badness.  But it looks like that case is a
> > 		"cannot happen" case.  Still needs to be fixed.
> > 	o	clockevents_notify():  This one acquires a global lock,
> > 		so it should be safe as-is.
> > 	o	console_cpu_notify():  This one takes the same action
> > 		for CPU_ONLINE, CPU_DEAD, CPU_DOWN_FAILED, and
> > 		CPU_UP_CANCELLED that it does for CPU_DYING, so it
> > 		should be OK.
> > 	*	rcu_cpu_notify():  This one needs adjustment as noted
> > 		above, but nothing major.  Patch has been posted,
> > 		probably needs a bit of debugging.
> > 	o	migration_call():  I defer to Peter on this one.
> > 		It looks to me like it is written to handle other
> > 		CPUs, but...
> > 	*	workqueue_cpu_callback(): Might need help, does a
> > 		non-atomic OR.
> > 	o	kvm_cpu_hotplug(): Uses a global spinlock, so should
> > 		be OK as-is.
> > 
> > 2.	Evaluate designs for stop_machine()-free CPU hotplug.
> > 	Implement the chosen design.  An outline for a particular
> > 	design is shown below, but the actual design might be
> > 	quite different.
> > 
> > 3.	Fix issues with CPU Hotplug callback registration. Currently
> > 	there is no totally-race-free way to register callbacks and do
> > 	setup for already online cpus.
> > 
> > 	Srivatsa had posted an incomplete patchset some time ago
> > 	regarding this, which gives an idea of the direction he had
> > 	in mind.
> > 	http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826
> 
> Gah, this has been "incomplete" for quite some time now.. I'll try to speed up
> things a bit :-)

Sounds good to me!  ;-)

							Thanx, Paul

