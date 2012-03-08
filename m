Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2CHDMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:12:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47163 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2CHDMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:12:34 -0500
Date: Thu, 8 Mar 2012 04:12:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Tommaso Cucinotta <cucinotta@sssup.it>, Avi Kivity <avi@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Geoff Levand <geoff@infradead.org>, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [ANNOUNCE] Nohz cpusets (adaptive tickless kernel)
 v2-pre-20120308
Message-ID: <20120308031220.GB7976@somewhere.redhat.com>
References: <20120308025738.GA7976@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308025738.GA7976@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 03:57:40AM +0100, Frederic Weisbecker wrote:
> Hi everyone,
> 
> Reminder of what it's all about: https://lkml.org/lkml/2011/8/15/245
> 
> The whole patchset has moved forward enough that it's now time
> to release a new iteration of it. I plan to post all the patches
> soon to LKML but before that I would like to rebase against 3.3[-rc >= 6]
> and clean up a few little things, especially revisit some changelogs.
> 
> So before that to happen, I still wanted to do a release in order
> to keep everyone in touch with latest changes.
> 
> Latest changes can be found at:
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	nohz/cpuset-v2-pre-20120308
> 
> There is still a lot to do, but I'm glad we made some progresses with
> more idle/adaptive tickless code unification, namespace cleanups,
> RCU fixes, and various bugfixes here and there, etc...
> 
> Changes since v1 (https://lkml.org/lkml/2011/8/15/245):
> 
> - Rebase against latest Paul McKenney's rcu/core branch for v3.3-rc1
> 
> - Adapt against latest rcu changes: introduce new APIs
>   rcu_user_enter(), rcu_user_exit(), rcu_user_enter_irq()
>   and rcu_user_exit_irq()
> 
> - Handle RCU idle mode with do_notify_resume() path
> 
> - Fix deadlock after double rq lock on schedule:
> 	schedule() -> rq_lock -> next is idle task ->
> 	tick_nohz_restart_sched_tick() -> wake up softirq ->
> 	rq lock
> 
> - Fix lockup while issuing flush times IPI on exit path:
> 
> 	CPU 0				CPU 1
> 
> 	read_lock(tasklist_lock)
> 					write_lock_irq(tasklist_lock)
> 	smp_call_function(CPU 1)
> 	* deadlock *
> 
> - Many namespace renames (cpuset_* to tick_nohz_*) and code migration
> from sched.c to tick-sched.c
> 
> - Seperate code that determine if we can stop the idle tick and don't
> use it for adaptive tickless mode.
> 
> - Fix adaptive tickless mode set on idle incidentally. TIF_NOHZ was
> then missing on the following task that ran tickless, issuing some
> illegal uses of RCU
> 
> - Restart the tick anytime more than one task is on the runqueue. We were previously
> only covering wake ups, now we also handle migration and any other source of task enqueuing
> 
> - Handle use of RCU in schedule() when called right before resuming userspace
> (new schedule_user() API)
> 
> - Take the decision to stop the tick from irq exit instead of the middle of the timer
> interrupt. This gives more opportunity to stop it and is one step more to unify idle
> and adaptive tickless.
> 
> - Unify tickless idle and tickless user/system CPU time accounting infrastructures.
> 
> - If the tick is stopped adaptively and we are going to schedule the idle
> task, don't restart the tick.
> 
> - Remove task_nohz_mode per cpu var and use ts->tick_stopped instead. This
> leads to more unification between idle tickless and adaptive tickless.
> 
> Have fun!


Frederic Weisbecker (34):
      nohz: Drop useless call in tick_nohz_start_idle()
      nohz: Drop useless ts->inidle checks on idle exit
      nohz: Separate idle sleeping time accounting from nohz switching
      nohz: Move idle ticks stats tracking out of nohz handlers
      nohz: Rename ts->idle_tick to ts->last_tick
      nohz: Move nohz load balancer selection into idle logic
      nohz: Move ts->idle_calls into strict idle logic
      nohz: Move next idle expiring time record into idle logic area
      cpuset: Set up interface for nohz flag
      nohz: Try not to give the timekeeping duty to a cpuset nohz cpu
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
      x86: Exception hooks for nohz cpusets
      x86: Add adaptive tickless hooks on do_notify_resume()
      nohz: Don't restart the tick before scheduling to idle
      rcu: New rcu_user_enter() and rcu_user_exit() APIs
      rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
      rcu: Switch to extended quiescent state in userspace from nohz cpuset
      nohz: Exit RCU idle mode when we schedule before resuming userspace
      nohz/cpuset: Disable under some configs

---
 arch/Kconfig                       |    3 +
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/entry_arch.h  |    3 +
 arch/x86/include/asm/hw_irq.h      |    7 +
 arch/x86/include/asm/irq_vectors.h |    2 +
 arch/x86/include/asm/smp.h         |   11 +
 arch/x86/include/asm/thread_info.h |   10 +-
 arch/x86/kernel/entry_64.S         |   14 +-
 arch/x86/kernel/irqinit.c          |    4 +
 arch/x86/kernel/ptrace.c           |   10 +
 arch/x86/kernel/signal.c           |    3 +
 arch/x86/kernel/smp.c              |   26 ++
 arch/x86/kernel/traps.c            |   22 +-
 arch/x86/mm/fault.c                |   13 +-
 fs/proc/array.c                    |    2 +
 include/linux/cpuset.h             |   26 ++
 include/linux/kernel_stat.h        |    2 +
 include/linux/posix-timers.h       |    1 +
 include/linux/rcupdate.h           |    8 +
 include/linux/sched.h              |   10 +-
 include/linux/tick.h               |   76 ++++--
 init/Kconfig                       |    8 +
 kernel/cpuset.c                    |  105 +++++++
 kernel/exit.c                      |    8 +
 kernel/posix-cpu-timers.c          |   12 +
 kernel/printk.c                    |   15 +-
 kernel/rcutree.c                   |  156 ++++++++---
 kernel/sched.c                     |   98 +++++++-
 kernel/softirq.c                   |    5 +-
 kernel/sys.c                       |    6 +
 kernel/time/tick-sched.c           |  534 ++++++++++++++++++++++++++++--------
 kernel/time/timer_list.c           |    7 +-
 kernel/timer.c                     |    2 +-
 33 files changed, 1018 insertions(+), 192 deletions(-)

