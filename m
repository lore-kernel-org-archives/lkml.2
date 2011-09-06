Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab1IGGZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50070 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1IGGVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:03 -0400
Date: Tue, 6 Sep 2011 11:00:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/55] Preview of RCU changes for 3.2
Message-ID: <20110906180015.GA2560@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset adds RCU event tracing, improved diagnostics and
documentation, and fixes a number of bugs, including several from an
ongoing top-to-bottom inspection of RCU.  The patches are as follows:

1.	Place per-CPU kthreads' stack and task struct on the corresponding
	node on NUMA systems (courtesy of Eric Dumazet).
2.	Avoid unnecessary self-wakeups for per-CPU kthreads
	(courtesy of Shaohua Li).
3,6,10,12,25,28,33.
	Documentations updates (some courtesy Wanlong Gao).
4.	Add replacement checks for blocking within an RCU read-side
	critical section.
5.	Header-file untangling part 1 of N: move rcu_head to types.h.
7.	Fix mismatched variable declaration (courtesy of Andi Kleen).
8.	Abstract out common grace-period-primitive code.
9.	Update rcutorture to test newish RCU API members.
11.	Drive RCU algorithm selection directly from SMP and PREEMPT.
13.	Make rcu_torture_boost() wait for callbacks before telling
	debug-objects that they are done.
14-17,20,22.
	Add event tracing for RCU.
18.	Update comments to reflect kthreads being used only when
	RCU priority boosting is enabled.
19.	Move RCU_BOOSt data declarations to alow compiler to detect
	mismatches.
20.	Make TINY_RCU use softirqs for RCU_BOOST=n.
23.	Simplify quiescent-state accounting.
24.	Stop passing rcu_read_lock_held() to rcu_dereference_protected()
	(courtesy of Michal Hocko).
26.	Remove unused and redundant RCU API members.
27.	Allow rcutorture's stat_interval parameter to be changed at runtime
	to make it easier to test RCU in guest OSes.
28.	Removed unused nohz_cpu_mask (courtesy of Alex Shi).
30.	Eliminate in_irq() checks in rcu_enter_nohz().
31.	Fix rcu_implicit_dynticks_qs() local-variable size mismatches.
32.	Make rcu_assign_pointer() unconditionally emit memory barrier
	to silence new gcc warnings (courtesy of Eric Dumazet).
34.	Move __rcu_read_lock()'s barrier within if-statement.
35.	Dump local stack for CPU stall warnings if cannot dump all stacks.
36.	Prevent early-boot set_need_resched() from __rcu_pending().
37.	Simplify unboosting checks.
38.	Prohibit RCU grace periods during early boot.
39.	Suppress NMI backtraces when CPU stall ends before dump.
40.	Avoid just-online CPU needlessly rescheding itself.
41.	Permit rt_mutex_unlock() with irqs disabled.
42-43.	Prevent end-of-test rcutorture hangs.
44.	Wire up RCU_BOOST_PRIO, use conventional kthread naming scheme
	(courtesy of Mike Galbraith).
45.	Check for entering dyntick-idle in RCU read-side critical section.
46.	Adjust RCU_FAST_NO_HZ to avoid false quiescent states.
47.	Avoid concurrent end of old GP with start of new GP.
48.	Strengthen powerpc value-returning atomic memory ordering.
49-51.	Detect illegal RCU use from dyntick-idle mode (courtesy of
	Frederic Weisbecker).
52.	Remove an unnecessary layer of abstraction from PROVE_RCU checking.
53.	Detect illegal SRCU use from dyntick-idle mode.
54.	Make SRCU use common lockdep-splat code.
55.	Placeholder patch that disables illegal tracing from dyntick-idle
	mode (illegal because tracing uses RCU).

For a testing-only version of this patchset from git, please see the
following subject-to-rebase (and subject-to-Hera-availability) branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

------------------------------------------------------------------------

 Documentation/RCU/NMI-RCU.txt           |    4 
 Documentation/RCU/lockdep.txt           |   24 +
 Documentation/RCU/torture.txt           |    3 
 Documentation/RCU/trace.txt             |   34 +-
 b/Documentation/RCU/NMI-RCU.txt         |    2 
 b/Documentation/RCU/lockdep-splat.txt   |  110 +++++++
 b/Documentation/RCU/lockdep.txt         |   10 
 b/Documentation/RCU/torture.txt         |  134 +++++++--
 b/Documentation/RCU/trace.txt           |    4 
 b/arch/powerpc/include/asm/synch.h      |    6 
 b/arch/powerpc/platforms/pseries/lpar.c |    6 
 b/include/linux/lockdep.h               |    2 
 b/include/linux/rcupdate.h              |   28 +
 b/include/linux/rcutiny.h               |   16 +
 b/include/linux/rcutree.h               |    2 
 b/include/linux/sched.h                 |    1 
 b/include/linux/srcu.h                  |   25 +
 b/include/linux/types.h                 |   10 
 b/include/trace/events/rcu.h            |   98 ++++++
 b/init/Kconfig                          |    6 
 b/kernel/lockdep.c                      |   84 +++--
 b/kernel/pid.c                          |    4 
 b/kernel/rcu.h                          |   79 +++++
 b/kernel/rcupdate.c                     |   21 +
 b/kernel/rcutiny.c                      |   28 -
 b/kernel/rcutiny_plugin.h               |   14 
 b/kernel/rcutorture.c                   |    5 
 b/kernel/rcutree.c                      |   22 -
 b/kernel/rcutree.h                      |    7 
 b/kernel/rcutree_plugin.h               |    5 
 b/kernel/rcutree_trace.c                |    2 
 b/kernel/rtmutex.c                      |    8 
 b/kernel/sched.c                        |    2 
 b/kernel/time/tick-sched.c              |    6 
 include/linux/rcupdate.h                |  420 ++++++++++++++---------------
 include/linux/rcutiny.h                 |    4 
 include/linux/sched.h                   |    3 
 include/linux/srcu.h                    |    5 
 include/trace/events/rcu.h              |  449 ++++++++++++++++++++++++++++----
 kernel/lockdep.c                        |   20 +
 kernel/rcu.h                            |   16 -
 kernel/rcupdate.c                       |   22 +
 kernel/rcutiny.c                        |  139 +++------
 kernel/rcutiny_plugin.h                 |  120 ++++++--
 kernel/rcutorture.c                     |   72 ++---
 kernel/rcutree.c                        |  313 +++++++++++++++-------
 kernel/rcutree.h                        |   10 
 kernel/rcutree_plugin.h                 |  150 +++++-----
 kernel/rcutree_trace.c                  |   13 
 kernel/sched.c                          |   11 
 50 files changed, 1761 insertions(+), 818 deletions(-)
