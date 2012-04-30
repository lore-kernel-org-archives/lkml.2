Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2EAABY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:01:24 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55516 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2EAABW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:01:22 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2012 20:01:11 EDT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 00/41] Nohz cpusets v3 (adaptive tickless kernel)
Date: Tue,  1 May 2012 01:54:34 +0200
Message-Id: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A summary of what this is about can be found here:
 https://lkml.org/lkml/2011/8/15/245

Changes since v2:

	* Correctly handle update of the cpuset mask when the nohz
	flag is set (courtesy of Hakan Akkan)

	* Handle rq clock. This introduces a new update_nohz_rq_clock()
	helper that sites which make use of rq->clock can call if they want to
	ensure the rq clock doesn't have a stale value due to the targeted CPU
	beeing tickless. If it's tickless, it's not maintaining the rq clock
	by calling scheduler_tick()->update_rq_clock() periodically.
	I think I've added this manual call to every callsites that needed it.
	I may have missed some though, or we may forget to handle tickless
	CPUs in future code. So I think we need to add some automated debug checks
	to catch that.

	* Fix a warning reported by Gilad Ben Yossef: we flush the time on
	pre-schedule and then the tick is restarted from an IPI before we do
	it manually on post-schedule. From there we try to flush the time
	again but ts->jiffies_saved_whence is set to SAVED_NONE because
	we already flushed the time. This was triggering a spurious warning.

Still a lot to do. I'm now maintaining the TODO list there:
 https://github.com/fweisbec/linux-dynticks/wiki/TODO

The git branch can be fetched from:
                                                                                                                                                                                                                   
 git://github.com/fweisbec/linux-dynticks.git
	nohz/cpuset-v3

  
Frederic Weisbecker (40):
  nohz: Separate idle sleeping time accounting from nohz logic
  nohz: Make nohz API agnostic against idle ticks cputime accounting
  nohz: Rename ts->idle_tick to ts->last_tick
  nohz: Move nohz load balancer selection into idle logic
  nohz: Move ts->idle_calls incrementation into strict idle logic
  nohz: Move next idle expiry time record into idle logic area
  cpuset: Set up interface for nohz flag
  nohz: Try not to give the timekeeping duty to an adaptive tickless
    cpu
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
  nohz/cpuset: Flush cputime on threads in nohz cpusets when waiting
    leader
  nohz/cpuset: Flush cputimes on procfs stat file read
  nohz/cpuset: Flush cputimes for getrusage() and times() syscalls
  x86: Syscall hooks for nohz cpusets
  x86: Exception hooks for nohz cpusets
  x86: Add adaptive tickless hooks on do_notify_resume()
  nohz: Don't restart the tick before scheduling to idle
  sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
  sched: Update rq clock on nohz CPU before migrating tasks
  sched: Update rq clock on nohz CPU before setting fair group shares
  sched: Update rq clock on tickless CPUs before calling
    check_preempt_curr()
  sched: Update rq clock earlier in unthrottle_cfs_rq
  sched: Update clock of nohz busiest rq before balancing
  sched: Update rq clock before idle balancing
  sched: Update nohz rq clock before searching busiest group on load
    balancing
  rcu: New rcu_user_enter() and rcu_user_exit() APIs
  rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
  rcu: Switch to extended quiescent state in userspace from nohz cpuset
  nohz: Exit RCU idle mode when we schedule before resuming userspace
  nohz/cpuset: Disable under some configs

Hakan Akkan (1):
  nohz/cpuset: enable addition&removal of cpus while in adaptive nohz
    mode

 arch/Kconfig                       |    3 +
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/entry_arch.h  |    3 +
 arch/x86/include/asm/hw_irq.h      |    7 +
 arch/x86/include/asm/irq_vectors.h |    2 +
 arch/x86/include/asm/smp.h         |   11 +
 arch/x86/include/asm/thread_info.h |   10 +-
 arch/x86/kernel/entry_64.S         |   12 +-
 arch/x86/kernel/irqinit.c          |    4 +
 arch/x86/kernel/ptrace.c           |   10 +
 arch/x86/kernel/signal.c           |    3 +
 arch/x86/kernel/smp.c              |   26 ++
 arch/x86/kernel/traps.c            |   20 +-
 arch/x86/mm/fault.c                |   13 +-
 fs/proc/array.c                    |    2 +
 include/linux/cpuset.h             |   29 ++
 include/linux/kernel_stat.h        |    2 +
 include/linux/posix-timers.h       |    1 +
 include/linux/rcupdate.h           |    8 +
 include/linux/sched.h              |   10 +-
 include/linux/tick.h               |   75 ++++--
 init/Kconfig                       |    8 +
 kernel/cpuset.c                    |  141 +++++++++-
 kernel/exit.c                      |    8 +
 kernel/posix-cpu-timers.c          |   12 +
 kernel/printk.c                    |   15 +-
 kernel/rcutree.c                   |  150 ++++++++--
 kernel/sched/core.c                |  112 ++++++++-
 kernel/sched/fair.c                |   39 +++-
 kernel/sched/sched.h               |   29 ++
 kernel/softirq.c                   |    6 +-
 kernel/sys.c                       |    6 +
 kernel/time/tick-sched.c           |  542 +++++++++++++++++++++++++++++-------
 kernel/time/timer_list.c           |    7 +-
 kernel/timer.c                     |    2 +-
 35 files changed, 1148 insertions(+), 181 deletions(-)

-- 
1.7.5.4

