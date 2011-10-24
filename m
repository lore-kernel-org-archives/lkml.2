Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1JXMgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:36:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43520 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab1JXMgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:36:48 -0400
Date: Mon, 24 Oct 2011 05:35:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/55] Preview of RCU changes for 3.2
Message-ID: <20111024123526.GG2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <20111017020613.GJ19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017020613.GJ19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-3534-0000-0000-000000DB971C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 07:06:13PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:15AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This patchset adds RCU event tracing, improved diagnostics and
> > documentation, and fixes a number of bugs, including several from an
> > ongoing top-to-bottom inspection of RCU.  The patches are as follows:
> > 
> > 1.	Place per-CPU kthreads' stack and task struct on the corresponding
> > 	node on NUMA systems (courtesy of Eric Dumazet).
> > 2.	Avoid unnecessary self-wakeups for per-CPU kthreads
> > 	(courtesy of Shaohua Li).
> > 3,6,10,12,25,28,33.
> > 	Documentations updates (some courtesy Wanlong Gao).
> > 4.	Add replacement checks for blocking within an RCU read-side
> > 	critical section.
> > 5.	Header-file untangling part 1 of N: move rcu_head to types.h.
> > 7.	Fix mismatched variable declaration (courtesy of Andi Kleen).
> > 8.	Abstract out common grace-period-primitive code.
> > 9.	Update rcutorture to test newish RCU API members.
> > 11.	Drive RCU algorithm selection directly from SMP and PREEMPT.
> > 13.	Make rcu_torture_boost() wait for callbacks before telling
> > 	debug-objects that they are done.
> > 14-17,20,22.
> > 	Add event tracing for RCU.
> > 18.	Update comments to reflect kthreads being used only when
> > 	RCU priority boosting is enabled.
> > 19.	Move RCU_BOOSt data declarations to alow compiler to detect
> > 	mismatches.
> > 20.	Make TINY_RCU use softirqs for RCU_BOOST=n.
> > 23.	Simplify quiescent-state accounting.
> > 24.	Stop passing rcu_read_lock_held() to rcu_dereference_protected()
> > 	(courtesy of Michal Hocko).
> > 26.	Remove unused and redundant RCU API members.
> > 27.	Allow rcutorture's stat_interval parameter to be changed at runtime
> > 	to make it easier to test RCU in guest OSes.
> > 28.	Removed unused nohz_cpu_mask (courtesy of Alex Shi).
> > 30.	Eliminate in_irq() checks in rcu_enter_nohz().
> > 31.	Fix rcu_implicit_dynticks_qs() local-variable size mismatches.
> > 32.	Make rcu_assign_pointer() unconditionally emit memory barrier
> > 	to silence new gcc warnings (courtesy of Eric Dumazet).
> > 34.	Move __rcu_read_lock()'s barrier within if-statement.
> > 35.	Dump local stack for CPU stall warnings if cannot dump all stacks.
> > 36.	Prevent early-boot set_need_resched() from __rcu_pending().
> > 37.	Simplify unboosting checks.
> > 38.	Prohibit RCU grace periods during early boot.
> > 39.	Suppress NMI backtraces when CPU stall ends before dump.
> > 40.	Avoid just-online CPU needlessly rescheding itself.
> > 41.	Permit rt_mutex_unlock() with irqs disabled.
> > 42-43.	Prevent end-of-test rcutorture hangs.
> > 44.	Wire up RCU_BOOST_PRIO, use conventional kthread naming scheme
> > 	(courtesy of Mike Galbraith).
> > 45.	Check for entering dyntick-idle in RCU read-side critical section.
> > 46.	Adjust RCU_FAST_NO_HZ to avoid false quiescent states.
> > 47.	Avoid concurrent end of old GP with start of new GP.
> > 48.	Strengthen powerpc value-returning atomic memory ordering.
> > 49-51.	Detect illegal RCU use from dyntick-idle mode (courtesy of
> > 	Frederic Weisbecker).
> > 52.	Remove an unnecessary layer of abstraction from PROVE_RCU checking.
> > 53.	Detect illegal SRCU use from dyntick-idle mode.
> > 54.	Make SRCU use common lockdep-splat code.
> > 55.	Placeholder patch that disables illegal tracing from dyntick-idle
> > 	mode (illegal because tracing uses RCU).
> 
> I responded to a few of the patches with comments and potential issues.
> I also don't consider myself qualified to review patch 48/55, "powerpc:
> strengthen value-returning-atomics memory barriers".  For the rest:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you very much for your review and comments!!!

							Thanx, Paul

