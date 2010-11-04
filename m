Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0KDXWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:22:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41110 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0KDXV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:21:59 -0400
Date: Thu, 4 Nov 2010 16:21:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: fweisbec@gmail.com, mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com
Cc: tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: dyntick-hpc and RCU
Message-ID: <20101104232148.GA28037@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Just wanted some written record of our discussion this Wednesday.
I don't have an email address for Jim Houston, and I am not sure I have
all of the attendees, but here goes anyway.  Please don't hesitate to
reply with any corrections!

The goal is to be able to turn of scheduling-clock interrupts for
long-running user-mode execution when there is but one runnable task
on a given CPU, but while still allowing RCU to function correctly.
In particular, we need to minimize (or better, eliminate) any source
of interruption to such a CPU.  We discussed these approaches, along
with their advantages and disadvantages:

1.	If a user task is executing in dyntick-hpc mode, inform RCU
	of all kernel/user transitions, calling rcu_enter_nohz()
	on each transition to user-mode execution and calling
	rcu_exit_nohz() on each transition to kernel-mode execution.

	+	Transitions due to interrupts and NMIs are already
		handled by the existing dyntick-idle code.

	+	RCU works without changes.

	-	-Every- exception path must be located and instrumented.

	-	Every system call must be instrumented.

	-	The system-call return fastpath is disabled by this
		approach, increasing the overhead of system calls.

	--	The scheduling-clock timer must be restarted on each
		transition to kernel-mode execution.  This is thought
		to be difficult on some of the exception code paths,
		and has high overhead regardless.

2.	Like #1 above, but instead of starting up the scheduling-clock
	timer on the CPU transitioning into the kernel, instead wake
	up a kthread that IPIs this CPU.  This has roughly the same
	advantages and disadvantages as #1 above, but substitutes
	a less-ugly kthread-wakeup operation in place of starting
	the scheduling-clock timer.

	There are a number of variations on this approach, but the
	rest of them are infeasible due to the fact that irq-disable
	and preempt-disable code sections are implicit read-side
	critical sections for RCU-sched.

3.	Substitute an RCU implementation similar to Jim Houston's
	real-time RCU implementation used by Concurrent.  (Jim posted
	this in 2004: http://lkml.org/lkml/2004/8/30/87 against
	2.6.1.1-mm4.)  In this implementation, the RCU grace periods
	are driven out of rcu_read_unlock(), so that there is no
	dependency on the scheduler-clock interrupt.

	+	Allows dyntick-hpc to simply require this alternative
		RCU implementation, without the need to interact
		with it.

	0	This implementation disables preemption across
		RCU read-side critical sections, which might be
		unacceptable for some users.  Or it might be OK,
		we were unable to determine this.

	0	This implementation increases the overhead of
		rcu_read_lock() and rcu_read_unlock().  However,
		this is probably acceptable, especially given that
		the workloads in question execute almost entirely
		in user space.

	---	Implicit RCU-sched and RCU-bh read-side critical
		sections would need to be explicitly marked with
		rcu_read_lock_sched() and rcu_read_lock_bh(),
		respectively.  Implicit critical sections include
		disabled preemption, disabled interrupts, hardirq
		handlers, and NMI handlers.  This change would
		require a large, intrusive, high-regression-risk patch.
		In addition, the hardirq-handler portion has been proposed
		and rejected in the past.

4.	Substitute an RCU implementation based on one of the
	user-level RCU implementations.  This has roughly the same
	advantages and disadvantages as does #3 above.

5.	Don't tell RCU about dyntick-hpc mode, but instead make RCU
	push processing through via some processor that is kept out
	of dyntick-hpc mode.  This requires that the rcutree RCU
	priority boosting be pushed further along so that RCU grace period
	and callback processing is done in kthread context, permitting
	remote forcing of grace periods.  The RCU_JIFFIES_TILL_FORCE_QS
	macro is promoted to a config variable, retaining its value
	of 3 in absence of dyntick-hpc, but getting value of HZ
	(or thereabouts) for dyntick-hpc builds.  In dyntick-hpc
	builds, force_quiescent_state() would push grace periods
	for CPUs lacking a scheduling-clock interrupt.

	+	Relatively small changes to RCU, some of which is
		coming with RCU priority boosting anyway.

	+	No need to inform RCU of user/kernel transitions.

	+	No need to turn scheduling-clock interrupts on
		at each user/kernel transition.

	-	Some IPIs to dyntick-hpc CPUs remain, but these
		are down in the every-second-or-so frequency,
		so hopefully are not a real problem.

6.	Your idea here!

The general consensus at the end of the meeting was that #5 was most
likely to work out the best.

							Thanx, Paul

PS.  If anyone knows Jim Houston's email address, please feel free
     to forward to him.
