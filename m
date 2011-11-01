Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1KAQAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:00:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37322 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab1KAQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:00:23 -0400
Date: Tue, 1 Nov 2011 09:00:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111101160014.GH2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101070720.GA22936@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110116-7182-0000-0000-0000001A2A33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 03:07:21PM +0800, Wu Fengguang wrote:
> On Tue, Nov 01, 2011 at 08:34:34AM +0800, Paul E. McKenney wrote:
> > On Mon, Oct 31, 2011 at 11:44:42AM -0400, Steven Rostedt wrote:
> > > On Mon, 2011-10-31 at 05:19 -0700, Paul E. McKenney wrote:
> > > > On Mon, Oct 31, 2011 at 07:41:42PM +0800, Wu Fengguang wrote:
> > > > > On Mon, Oct 31, 2011 at 06:43:25PM +0800, Wu Fengguang wrote:
> > > > > > On Mon, Oct 31, 2011 at 05:51:52PM +0800, Paul E. McKenney wrote:
> > > > > > > On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> > > > > > > > Hi Paul,
> > > > > > > >
> > > > > > > > I got two warnings in rcutree.c. The last working kernels are
> > > > > > > > linux-next 20111014 and linux v3.1.
> > > > > > > 
> > > > > > > Interesting.  Could you please enable RCU event tracing at boot?
> > > > > > 
> > > > > > Sorry I cannot...possibly due to another ftrace bug.
> > > > > > 
> > > > > > > The RCU event tracing is at tracing/events/rcu/enable relative to
> > > > > > > the debugfs mount point at runtime, if that helps.
> > > > > > 
> > > > > > It's exactly that linux next 20111025 (comparing to 20111014) no
> > > > > > longer produces all the trace events that made me looking into the
> > > > > > dmesg and find the warning from RCU (rather than the expected warning
> > > > > > from ftrace).
> > > > > > 
> > > > > > The trace output is now:
> > > > > > 
> > > > > >         # tracer: nop
> > > > > >         #
> > > > > >         # WARNING: FUNCTION TRACING IS CORRUPTED
> > > > > >         #          MAY BE MISSING FUNCTION EVENTS
> > > > > >         #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > > > >         #              | |       |          |         |
> > > > > > (nothing more)
> > > > > 
> > > > > I checked the other test box and got the same warnings. Below is the
> > > > > full dmesg.
> > > > > 
> > > > > No single trace output again..
> > > > 
> > > > Hmmm...  I wonder if it is too early during boot for tracing to work
> > > > correctly.
> > > > 
> > > > Gah!  I have rcu/next set ahead to commits that are not supposed to go
> > > > upstream yet.  I reset it back to match the stuff that is targeted for
> > > > the current merge window.  Still need to find the bug, of course.
> > > > 
> > > > Anyone have any idea why the kworker thread might be trying to enter
> > > > the idle loop?  The idle_cpu(smp_processor_id()) call believes that
> > > > this is not the idle task.  Or does x86 allow non-idle tasks to enter
> > > > the idle loop?  Or to be migrated off-CPU?
> > > 
> > > 
> > > It's not. Carsten Emde noticed what looked like a bug in ftrace last
> > > week at LinuxCon, and looking deeper at it, I found that the swapper
> > > task for all but CPU0 is named kworker.  That's because kworker creates
> > > the idle task for all other CPUs besides CPU 0 and the idle task takes
> > > on kworker name.
> > > 
> > > Carsten posted a patch last week too:
> > > 
> > > https://lkml.org/lkml/2011/10/26/313
> > > 
> > > I'm glad that this bug shows up outside of just ftrace :)
> > 
> > That makes one of us.  ;-)
> > 
> > Fengguang, does Carsten's patch help?
> 
> Nope unfortunately. Here is the new dmesg:

Hmmmm...  Please see below for a diagnostic patch that prints out who
the kernel believes the idle thread is.  Could you please give this
a go?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Add more information to the wrong-idle-task complaint

The current code just complains if the current task is not the idle task.
This commit therefore adds printing of the identity of the idle task.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e0df33f..f4e7bc3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -66,10 +66,14 @@ static void rcu_idle_enter_common(long long oldval)
 	}
 	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
 					    oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
@@ -116,10 +120,14 @@ static void rcu_idle_exit_common(long long oldval)
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
 			  oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cc04876..2a8d9a6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -356,10 +356,14 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		trace_rcu_dyntick("Error on entry: not idle task",
 				   oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -445,10 +449,14 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		trace_rcu_dyntick("Error on exit: not idle task",
 				  oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 }
 

