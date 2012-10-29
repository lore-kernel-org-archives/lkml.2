Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938Ab2J2Uun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:50:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2J2Uit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:49 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mRXL3JhMAdAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LF9jnDiwqlsA:10 a=Uk4be4KysGXkHD8-eFwA:9 a=CSGEBdpmH2IA:10 a=Y0gVc743pn8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029202711.062749374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago Frederic posted a series of patches to get an idea on
how to implement nohz cpusets. Where you can add a task to a cpuset
and mark the set to be 'nohz'. When the task runs on a CPU and is
the only task scheduled (nr_running == 1), the tick will stop.
The idea is to give the task the least amount of kernel interference
as possible. If the task doesn't do any system calls (and possibly
even if it does), no timer interrupt will bother it. By using
isocpus and nohz cpuset, a task would be able to achieve true cpu
isolation.

This has been long asked for by those in the RT community. If a task
requires uninterruptible CPU time, this would be able to give a task
that, even without the full PREEMPT-RT patch set.

This patch set is not for inclusion. It is just to get the topic
at the forefront again. The design requires more work and more
discussion.

I ported Frederic's work to v3.7-rc3 and I'm posting it here so that
people can comment on it. I just did the minimal to get it to compile
and boot. I haven't done any real tests with it yet. I may have screwed
some things up during the port, but that's OK, because the patch set
will most likely require a rewrite anyway.

Please have a look, and lets get this out the door.

-- Steve


Frederic Weisbecker (31):
      nohz: Move nohz load balancer selection into idle logic
      cpuset: Set up interface for nohz flag
      nohz: Try not to give the timekeeping duty to an adaptive tickless cpu
      x86: New cpuset nohz irq vector
      nohz: Adaptive tick stop and restart on nohz cpuset
      nohz/cpuset: Don't turn off the tick if rcu needs it
      nohz/cpuset: Wake up adaptive nohz CPU when a timer gets enqueued
      nohz/cpuset: Don't stop the tick if posix cpu timers are running
      nohz/cpuset: Restart tick when nohz flag is cleared on cpuset
      nohz/cpuset: Restart the tick if printk needs it
      rcu: Restart the tick on non-responding adaptive nohz CPUs
      rcu: Restart tick if we enqueue a callback in a nohz/cpuset CPU
      nohz: Generalize tickless cpu time accounting
      nohz/cpuset: Account user and system times in adaptive nohz mode
      nohz/cpuset: New API to flush cputimes on nohz cpusets
      nohz/cpuset: Flush cputime on threads in nohz cpusets when waiting leader
      nohz/cpuset: Flush cputimes on procfs stat file read
      nohz/cpuset: Flush cputimes for getrusage() and times() syscalls
      x86: Syscall hooks for nohz cpusets
      nohz: Don't restart the tick before scheduling to idle
      sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
      sched: Update rq clock on nohz CPU before migrating tasks
      sched: Update rq clock on nohz CPU before setting fair group shares
      sched: Update rq clock on tickless CPUs before calling check_preempt_curr()
      sched: Update rq clock earlier in unthrottle_cfs_rq
      sched: Update clock of nohz busiest rq before balancing
      sched: Update rq clock before idle balancing
      sched: Update nohz rq clock before searching busiest group on load balancing
      rcu: Switch to extended quiescent state in userspace from nohz cpuset
      nohz/cpuset: Disable under some configs
      nohz, not for merge: Add tickless tracing

Hakan Akkan (1):
      nohz/cpuset: enable addition&removal of cpus while in adaptive nohz mode

----
 arch/Kconfig                       |    3 +
 arch/x86/include/asm/entry_arch.h  |    3 +
 arch/x86/include/asm/hw_irq.h      |    7 +
 arch/x86/include/asm/irq_vectors.h |    2 +
 arch/x86/include/asm/smp.h         |   11 +-
 arch/x86/kernel/entry_64.S         |    4 +
 arch/x86/kernel/irqinit.c          |    4 +
 arch/x86/kernel/ptrace.c           |   11 +
 arch/x86/kernel/smp.c              |   28 +++
 fs/proc/array.c                    |    2 +
 include/linux/cpuset.h             |   35 ++++
 include/linux/kernel_stat.h        |    2 +
 include/linux/posix-timers.h       |    1 +
 include/linux/rcupdate.h           |    1 +
 include/linux/sched.h              |   10 +-
 include/linux/tick.h               |   72 +++++--
 init/Kconfig                       |    8 +
 kernel/cpuset.c                    |  144 ++++++++++++-
 kernel/exit.c                      |    8 +
 kernel/posix-cpu-timers.c          |   12 ++
 kernel/printk.c                    |   15 +-
 kernel/rcutree.c                   |   28 ++-
 kernel/sched/core.c                |   82 +++++++-
 kernel/sched/cputime.c             |   22 ++
 kernel/sched/fair.c                |   41 +++-
 kernel/sched/sched.h               |   18 ++
 kernel/softirq.c                   |    6 +-
 kernel/sys.c                       |    6 +
 kernel/time/tick-sched.c           |  398 ++++++++++++++++++++++++++++++++----
 kernel/time/timer_list.c           |    3 +-
 kernel/timer.c                     |    2 +-
 31 files changed, 912 insertions(+), 77 deletions(-)
