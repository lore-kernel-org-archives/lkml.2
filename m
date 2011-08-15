Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1HOPwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:52:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38331 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1HOPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:52:40 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
Date: Mon, 15 Aug 2011 17:51:57 +0200
Message-Id: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's still in draft stage. It's far from covering everything
the periodic timer does but it has made some progress since last
posting. So I think it's time now for another early release.

= What's that? = 

On the mainline kernel we have a feature (CONFIG_NO_HZ) that is
able to turn off the periodic scheduler tick when the CPU has
nothing to do, namely when it's running the idle task.

The scheduler tick handles many things like RCU and scheduler
internal state, jiffies accouting, wall time accounting, load
accounting, cputime accounting, timer wheel, posix cpu timers,
etc...

However by the time we run idle and the CPU is going to sleep,
none of these things are useful for the CPU. We can then shut it
down.

The benefit of this is for energy saving purposes. We avoid
to wake up the CPU needlessly with these useless interrupts.

What this patchset do is to extend that feature to non idle
cases, implementing some new kind of "adaptive nohz". But the
purpose is different and the implementation too.

= How does that work =

It tries to handle all the things that the timer tick usually
handle but using different tricks. Sometimes we can't really
afford to avoid the periodic tick, but sometimes we can and if
we do, we need to take some special care.

- We can't shutdown the tick if we have more than one task
running, due to the need for the tick for preemption. But I believe
that one day we can avoid the periodic tick for that and rather
anticipate when the scheduler really needs the tick.

- We can't shutdown the tick if RCU needs to complete a grace
period from the current CPU, or if it has callbacks to handle.

- We can't shutdown the tick if we have a posix cpu timer queued. Similarly
to the preemption case, we should be able to anticipate that with a
precise timer and avoid a periodic check based on HZ.

- Restart the tick when more than one non-idle task are in the runqueue.

- We need to handle process accounting, RCU, rq clock, task tick, etc...

And that patchset for now only handles a part of the whole needs.

= What's the interface =

We use the cpuset interface by adding a nohz flag to it.
As long as a CPU is part of a nohz cpuset, then this CPU will
try to enter into adaptive nohz mode when it can, even if it is part
of another cpuset that is not nohz.

= Why do we need that? =

There are at least two potential users of this feature:

* High performance computing: To optimize the throughput, some
workloads involve running one task per CPU that mostly run in
userspace. These tasks don't want and don't need to suffer from the
overhead of the timer interrupt. It consumes CPU time and it trashes
the CPU cache.

* Real time: Minimizing timer interrupts means less interrupts and thus
less critical sections that usually induce latency.

= What's missing? =

Many things like handling of perf events, irq work, sched clock tick,
runqueue clock, sched_class::task_tick(), rq clock, cpu load, ...

The handling of cputimes is also incomplete as there are other places
that use the utime/stime. Process time accounting is globally incomplete.

But anyway the thing is moving forward. An early posting was just very
needed at that step.

For those who want to play:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	nohz/cpuset-v1

Frederic Weisbecker (32):
  nohz: Drop useless call in tick_nohz_start_idle()
  nohz: Drop ts->idle_active
  nohz: Drop useless ts->inidle check before rearming the tick
  nohz: Separate idle sleeping time accounting from nohz switching
  nohz: Move rcu dynticks idle mode handling to idle enter/exit APIs
  nohz: Move idle ticks stats tracking out of nohz handlers
  nohz: Rename ts->idle_tick to ts->last_tick
  nohz: Move nohz load balancer selection into idle logic
  nohz: Move ts->idle_calls into strict idle logic
  nohz: Move next idle expiring time record into idle logic area
  cpuset: Set up interface for nohz flag
  nohz: Try not to give the timekeeping duty to a cpuset nohz cpu
  nohz: Adaptive tick stop and restart on nohz cpuset
  nohz/cpuset: Don't turn off the tick if rcu needs it
  nohz/cpuset: Restart tick when switching to idle task
  nohz/cpuset: Wake up adaptive nohz CPU when a timer gets enqueued
  x86: New cpuset nohz irq vector
  nohz/cpuset: Don't stop the tick if posix cpu timers are running
  nohz/cpuset: Restart tick when nohz flag is cleared on cpuset
  nohz/cpuset: Restart the tick if printk needs it
  rcu: Restart the tick on non-responding adaptive nohz CPUs
  rcu: Restart tick if we enqueue a callback in a nohz/cpuset CPU
  nohz/cpuset: Account user and system times in adaptive nohz mode
  nohz/cpuset: Handle kernel entry/exit to account cputime
  nohz/cpuset: New API to flush cputimes on nohz cpusets
  nohz/cpuset: Flush cputime on threads in nohz cpusets when waiting leader
  nohz/cpuset: Flush cputimes on procfs stat file read
  nohz/cpuset: Flush cputimes for getrusage() and times() syscalls
  x86: Syscall hooks for nohz cpusets
  x86: Exception hooks for nohz cpusets
  rcu: Switch to extended quiescent state in userspace from nohz cpuset
  nohz/cpuset: Disable under some configs

 arch/Kconfig                           |    3 +
 arch/arm/kernel/process.c              |    4 +-
 arch/avr32/kernel/process.c            |    4 +-
 arch/blackfin/kernel/process.c         |    4 +-
 arch/microblaze/kernel/process.c       |    4 +-
 arch/mips/kernel/process.c             |    4 +-
 arch/powerpc/kernel/idle.c             |    4 +-
 arch/powerpc/platforms/iseries/setup.c |    8 +-
 arch/s390/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                  |    4 +-
 arch/sparc/kernel/process_64.c         |    4 +-
 arch/tile/kernel/process.c             |    4 +-
 arch/um/kernel/process.c               |    4 +-
 arch/unicore32/kernel/process.c        |    4 +-
 arch/x86/Kconfig                       |    1 +
 arch/x86/include/asm/entry_arch.h      |    3 +
 arch/x86/include/asm/hw_irq.h          |    6 +
 arch/x86/include/asm/irq_vectors.h     |    2 +
 arch/x86/include/asm/smp.h             |   11 +
 arch/x86/include/asm/thread_info.h     |   10 +-
 arch/x86/kernel/entry_64.S             |    4 +
 arch/x86/kernel/irqinit.c              |    4 +
 arch/x86/kernel/process_32.c           |    4 +-
 arch/x86/kernel/process_64.c           |    5 +-
 arch/x86/kernel/ptrace.c               |   10 +
 arch/x86/kernel/smp.c                  |   26 ++
 arch/x86/kernel/traps.c                |   22 +-
 arch/x86/mm/fault.c                    |   13 +-
 fs/proc/array.c                        |    2 +
 include/linux/cpuset.h                 |   29 ++
 include/linux/kernel_stat.h            |    2 +
 include/linux/posix-timers.h           |    1 +
 include/linux/rcupdate.h               |    1 +
 include/linux/sched.h                  |   10 +-
 include/linux/tick.h                   |   50 +++-
 init/Kconfig                           |    8 +
 kernel/cpuset.c                        |  105 +++++++
 kernel/exit.c                          |    2 +
 kernel/posix-cpu-timers.c              |   12 +
 kernel/printk.c                        |   17 +-
 kernel/rcutree.c                       |   28 ++-
 kernel/sched.c                         |  132 +++++++++-
 kernel/softirq.c                       |    6 +-
 kernel/sys.c                           |    6 +
 kernel/time/tick-sched.c               |  479 ++++++++++++++++++++++++--------
 kernel/time/timer_list.c               |    4 +-
 kernel/timer.c                         |    8 +-
 47 files changed, 897 insertions(+), 185 deletions(-)

-- 
1.7.5.4

