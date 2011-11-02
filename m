Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1KBUbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35241 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1KBUbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:24 -0400
Date: Wed, 2 Nov 2011 13:30:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH RFC tip/core/rcu 0/28] Preview of RCU changes for 3.3
Message-ID: <20111102203017.GA3830@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110220-5806-0000-0000-000000F808F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset permits idle tasks to use RCU read-side critical sections,
although they are still prohibited between tick_nohz_idle_exit_norcu()
and tick_nohz_idle_exit_norcu(); makes synchronize_sched_expedited()
better able to share work among concurrent callers, allows ftrace_dump()
to be invoked from modules, dumps tracing upon detection of an rcutorture
failure, detects illegal use of RCU read-side critical sections from
extended quiescent states, legitimizes the pre-existin use of RCU in the
idle notifiers, fixes a memory-barrier botch, introduces an SRCU-like bulk
reference count, improve dynticks entry/exit tracing, further improves
RCU's ability to allow a given CPU to enter dyntick-idle mode quickly,
fixes idle-task checks, updates documentation, and additional fixes
from a still-ongoing top-to-bottom inspection of RCU.  The patches are
as follows:

1.	Strengthen memory barriers used in PowerPC value-returning
	atomics and locking primitives.  It is likely that this
	commit will be superseded by something from the powerpc
	maintainers.  The need for this strengthening was validated
	by tooling from Peter Sewell's group at the University of
	Cambridge.
2.	Rename ->signaled to ->fqs_state to clarify the code.
3.	Fix a race that could permit RCU-preempt expedited grace
	periods to complete too soon.
4.	Improve synchronize_sched_expedited()'s ability to share work
	among concurrent callers.
5.	Document the troubleshooting of lockdep lock-class leaks.
6.	Explicitly track idleness, which is a step towards permitting
	the idle tasks to contain RCU read-side critical sections
	(but only outside the body of the idle loop).
7,8.	Add an EXPORT_SYMBOL_GPL() for ftrace_dump() so that
	rcutorture can dump the trace buffer upon detection of
	an error, and then make rcutorture do the dumping.
9.	Document a failing scheduling-clock tick as yet another
	possible cause of RCU CPU stall warnings.
10.	Disable preemption in rcu_is_cpu_idle() in order to prevent
	spurious lockdep-RCU splats.
11.	Remove a useless self-awaken when setting up expedited grace
	periods, courtesy of Thomas Gleixner and the -rt effort.
12-17.	Make lockdep-RCU warn when RCU read-side primitives are
	invoked from an idle RCU extended quiescent state, mostly
	courtesy of Frederic Weisbecker.
18-23.	Separate out the scheduler-clock tick's idea of dyntick
	idle from RCU's notion of an idle extended quiescent state, mostly
	courtesy of Frederic Weisbecker.  These commits are needed for
	Frederic's work to suppress the scheduler-clock tick when there
	is but one runnable task on a given CPU.
24.	Introduce a bulk reference count, which is related to SRCU,
	but which allows a reference to be acquired in an irq handler
	and released by the task that was interrupted.
25-26.	Improve dyntick-idle tracing and diagnostics.
27.	Allow CPUs with pending RCU callbacks to enter dyntick-idle
	mode.  Beware this commit, as it compiled and passed rcutorture
	on the first try, which historically has indicated the presence
	of subtle and highly destructive bugs.
28.	Fix RCU's determination of whether or not it is running in the
	context of an idle task.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

							Thanx, Paul

------------------------------------------------------------------------

 arch/arm/kernel/process.c                  |    4 
 arch/avr32/kernel/process.c                |    4 
 arch/blackfin/kernel/process.c             |    4 
 arch/microblaze/kernel/process.c           |    4 
 arch/mips/kernel/process.c                 |    4 
 arch/openrisc/kernel/idle.c                |    4 
 arch/powerpc/kernel/idle.c                 |   20 +
 arch/powerpc/platforms/iseries/setup.c     |    8 
 arch/s390/kernel/process.c                 |    4 
 arch/sh/kernel/idle.c                      |    4 
 arch/sparc/kernel/process_64.c             |    4 
 arch/tile/kernel/process.c                 |    4 
 arch/um/kernel/process.c                   |    4 
 arch/unicore32/kernel/process.c            |    4 
 arch/x86/kernel/process_32.c               |    4 
 arch/x86/kernel/process_64.c               |   14 -
 b/Documentation/RCU/stallwarn.txt          |    5 
 b/Documentation/RCU/trace.txt              |    4 
 b/Documentation/lockdep-design.txt         |   61 +++++
 b/arch/arm/kernel/process.c                |    4 
 b/arch/avr32/kernel/process.c              |    4 
 b/arch/blackfin/kernel/process.c           |    4 
 b/arch/microblaze/kernel/process.c         |    4 
 b/arch/mips/kernel/process.c               |    4 
 b/arch/openrisc/kernel/idle.c              |    4 
 b/arch/powerpc/include/asm/synch.h         |    6 
 b/arch/powerpc/kernel/idle.c               |    4 
 b/arch/powerpc/platforms/iseries/setup.c   |    8 
 b/arch/powerpc/platforms/pseries/lpar.c    |    4 
 b/arch/s390/kernel/process.c               |    4 
 b/arch/sh/kernel/idle.c                    |    4 
 b/arch/sparc/kernel/process_64.c           |    4 
 b/arch/tile/kernel/process.c               |    4 
 b/arch/um/kernel/process.c                 |    4 
 b/arch/unicore32/kernel/process.c          |    4 
 b/arch/x86/kernel/apic/apic.c              |    6 
 b/arch/x86/kernel/apic/io_apic.c           |    2 
 b/arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 
 b/arch/x86/kernel/cpu/mcheck/threshold.c   |    2 
 b/arch/x86/kernel/irq.c                    |    6 
 b/arch/x86/kernel/process_32.c             |    4 
 b/arch/x86/kernel/process_64.c             |    4 
 b/include/linux/hardirq.h                  |   21 --
 b/include/linux/rcupdate.h                 |   21 --
 b/include/linux/srcu.h                     |   36 ++-
 b/include/linux/tick.h                     |   11 -
 b/include/trace/events/rcu.h               |   10 
 b/kernel/lockdep.c                         |   22 ++
 b/kernel/rcu.h                             |    7 
 b/kernel/rcupdate.c                        |   10 
 b/kernel/rcutiny.c                         |  124 ++++++++++--
 b/kernel/rcutorture.c                      |   18 +
 b/kernel/rcutree.c                         |   16 -
 b/kernel/rcutree.h                         |    4 
 b/kernel/rcutree_plugin.h                  |    7 
 b/kernel/rcutree_trace.c                   |    2 
 b/kernel/softirq.c                         |    2 
 b/kernel/srcu.c                            |    3 
 b/kernel/time/tick-sched.c                 |    6 
 b/kernel/trace/trace.c                     |    1 
 include/linux/rcupdate.h                   |  139 ++++++++-----
 include/linux/srcu.h                       |   55 +++++
 include/linux/tick.h                       |   59 ++++-
 include/trace/events/rcu.h                 |   41 +++
 kernel/rcupdate.c                          |    2 
 kernel/rcutiny.c                           |   45 ++--
 kernel/rcutree.c                           |  298 ++++++++++++++++++++---------
 kernel/rcutree.h                           |   22 --
 kernel/rcutree_plugin.h                    |  175 +++++++++++++----
 kernel/rcutree_trace.c                     |   10 
 kernel/softirq.c                           |    2 
 kernel/time/tick-sched.c                   |  118 ++++++-----
 72 files changed, 1080 insertions(+), 467 deletions(-)

