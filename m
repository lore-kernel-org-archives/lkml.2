Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3AHCQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:16:39 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43233 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3AHCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:16:22 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ANNOUNCE] 3.8-rc2-nohz2
Date: Tue,  8 Jan 2013 03:08:00 +0100
Message-Id: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is a new version of the full dynticks patchset based on 3.8-rc2.
It addresses most feedbacks I got on the previous release (see the list of changes
below).

Thanks you for your reviews, they are really useful!

This version is pullable at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	3.8-rc2-nohz2

For the details on how to use it, check this link:
https://lwn.net/Articles/530345/ on the section "How to use".

Changes since 3.8-rc1-nohz1:

* Let the user choose between CONFIG_VIRT_CPU_ACCOUNTING_NATIVE and
CONFIG_VIRT_CPU_ACCOUNTING_GEN if both are available (thanks Li Zhong).
[patch 03/33]

* Move code that export context tracking state to its own commit to
make the review easier (thanks Paul Gortmaker) [patch 02/33]

* Rename vtime_accounting() to vtime_accounting_enabled() (thanks
Paul Gortmaker) [patch 04/33]

* Fix vtime_enter_user / vtime_user_enter confusion. (thanks Li Zhong)
[patch 03/33]

* Fix grammar, spelling and foggy explanations. (thanks Paul Gortmaker)
[patch 04/33]

* Fix "hook" based naming (thanks Ingo Molnar) [patch 01/33]

* Fix is_nocb_cpu() orphan declaration (thanks Namhyung Kim) [patch 22/33]

* Add full dynticks runqueue clock debugging [patch 29-30/33]

* Fix missing rq clock update in update_cpu_load_nohz(), thanks to the
debugging code on the previous patch. [patch 32/33] That's not yet a full
solution for the nohz rt power scale though.

* Partly handle update_cpu_load_active() [patch 33/33] (we still have to handle
calc_load_account_active)


TODO list has slightly reduced and also slightly grown :)

- Handle calc_load_account_active().

- Handle sched_class->task_tick()

- Handle rt power scaling

- Make sure rcu_nocbs mask matches full_nohz's.

- Get the nohz printk patchset merged.

- Posix cpu timers enqueued while tick is off. Probably no big deal but
I need to look into that.

- Several trivial stuffs: perf_event_task_tick(), profile_tick(),
sched_clock_tick(), etc...

Enjoy!

---
Frederic Weisbecker (41):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work
      Merge branch 'nohz/printk-v8' into 3.8-rc2-nohz2-base
      context_tracking: Add comments on interface and internals
      context_tracking: Export context state for generic vtime
      cputime: Generic on-demand virtual cputime accounting
      cputime: Allow dynamic switch between tick/virtual based cputime accounting
      cputime: Use accessors to read task cputime stats
      cputime: Safely read cputime of full dynticks CPUs
      nohz: Basic full dynticks interface
      nohz: Assign timekeeping duty to a non-full-nohz CPU
      nohz: Trace timekeeping update
      nohz: Wake up full dynticks CPUs when a timer gets enqueued
      rcu: Restart the tick on non-responding full dynticks CPUs
      sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
      sched: Update rq clock on nohz CPU before migrating tasks
      sched: Update rq clock on nohz CPU before setting fair group shares
      sched: Update rq clock on tickless CPUs before calling check_preempt_curr()
      sched: Update rq clock earlier in unthrottle_cfs_rq
      sched: Update clock of nohz busiest rq before balancing
      sched: Update rq clock before idle balancing
      sched: Update nohz rq clock before searching busiest group on load balancing
      nohz: Move nohz load balancer selection into idle logic
      nohz: Full dynticks mode
      nohz: Only stop the tick on RCU nocb CPUs
      nohz: Don't turn off the tick if rcu needs it
      nohz: Don't stop the tick if posix cpu timers are running
      nohz: Add some tracing
      rcu: Don't keep the tick for RCU while in userspace
      profiling: Remove unused timer hook
      timer: Don't run non-pinned timer to full dynticks CPUs
      sched: Use an accessor to read rq clock
      sched: Debug nohz rq clock
      sched: Remove broken check for skip clock update
      sched: Update rq clock before rt sched average scale
      sched: Disable lb_bias feature for full dynticks

Steven Rostedt (2):
      irq_work: Flush work on CPU_DYING
      irq_work: Warn if there's still work on cpu_down

 arch/alpha/Kconfig                     |    1 -
 arch/alpha/kernel/osf_sys.c            |    6 +-
 arch/arm/Kconfig                       |    1 -
 arch/arm64/Kconfig                     |    1 -
 arch/blackfin/Kconfig                  |    1 -
 arch/frv/Kconfig                       |    1 -
 arch/hexagon/Kconfig                   |    1 -
 arch/ia64/include/asm/cputime.h        |    6 +-
 arch/ia64/include/asm/thread_info.h    |    4 +-
 arch/ia64/include/asm/xen/minstate.h   |    2 +-
 arch/ia64/kernel/asm-offsets.c         |    2 +-
 arch/ia64/kernel/entry.S               |   16 +-
 arch/ia64/kernel/fsys.S                |    4 +-
 arch/ia64/kernel/head.S                |    4 +-
 arch/ia64/kernel/ivt.S                 |    8 +-
 arch/ia64/kernel/minstate.h            |    2 +-
 arch/ia64/kernel/time.c                |    4 +-
 arch/mips/Kconfig                      |    1 -
 arch/parisc/Kconfig                    |    1 -
 arch/powerpc/Kconfig                   |    1 -
 arch/powerpc/include/asm/cputime.h     |    6 +-
 arch/powerpc/include/asm/lppaca.h      |    2 +-
 arch/powerpc/include/asm/ppc_asm.h     |    4 +-
 arch/powerpc/kernel/entry_64.S         |    4 +-
 arch/powerpc/kernel/time.c             |    4 +-
 arch/powerpc/platforms/pseries/dtl.c   |    6 +-
 arch/powerpc/platforms/pseries/setup.c |    6 +-
 arch/s390/Kconfig                      |    1 -
 arch/s390/kernel/vtime.c               |    6 +-
 arch/sh/Kconfig                        |    1 -
 arch/sparc/Kconfig                     |    1 -
 arch/x86/Kconfig                       |    1 -
 arch/x86/kernel/apm_32.c               |   11 +-
 drivers/isdn/mISDN/stack.c             |    7 +-
 drivers/staging/iio/trigger/Kconfig    |    1 -
 fs/binfmt_elf.c                        |    8 +-
 fs/binfmt_elf_fdpic.c                  |    7 +-
 include/asm-generic/cputime.h          |    1 +
 include/linux/context_tracking.h       |   28 ++++
 include/linux/hardirq.h                |    4 +-
 include/linux/init_task.h              |   11 ++
 include/linux/irq_work.h               |   20 +++
 include/linux/kernel_stat.h            |    2 +-
 include/linux/posix-timers.h           |    1 +
 include/linux/printk.h                 |    3 -
 include/linux/profile.h                |   13 --
 include/linux/rcupdate.h               |    8 +
 include/linux/sched.h                  |   48 +++++++-
 include/linux/tick.h                   |   26 ++++-
 include/linux/vtime.h                  |   51 +++++---
 init/Kconfig                           |   20 ++-
 kernel/acct.c                          |    6 +-
 kernel/context_tracking.c              |   91 ++++++++++----
 kernel/cpu.c                           |    4 +-
 kernel/delayacct.c                     |    7 +-
 kernel/exit.c                          |    6 +-
 kernel/fork.c                          |    8 +-
 kernel/hrtimer.c                       |    3 +-
 kernel/irq_work.c                      |  131 ++++++++++++++-----
 kernel/posix-cpu-timers.c              |   39 +++++-
 kernel/printk.c                        |   36 +++---
 kernel/profile.c                       |   24 ----
 kernel/rcutree.c                       |   19 ++-
 kernel/rcutree.h                       |    1 -
 kernel/rcutree_plugin.h                |   13 +--
 kernel/sched/core.c                    |  104 ++++++++++++++--
 kernel/sched/cputime.c                 |  222 +++++++++++++++++++++++++++-----
 kernel/sched/fair.c                    |   96 ++++++++++----
 kernel/sched/features.h                |    3 +
 kernel/sched/rt.c                      |    8 +-
 kernel/sched/sched.h                   |   50 +++++++
 kernel/sched/stats.h                   |    8 +-
 kernel/sched/stop_task.c               |    8 +-
 kernel/signal.c                        |   12 +-
 kernel/softirq.c                       |   11 +-
 kernel/time/Kconfig                    |    9 ++
 kernel/time/tick-broadcast.c           |    3 +-
 kernel/time/tick-common.c              |    5 +-
 kernel/time/tick-sched.c               |  144 ++++++++++++++++++---
 kernel/timer.c                         |    6 +-
 kernel/tsacct.c                        |   19 ++-
 81 files changed, 1117 insertions(+), 358 deletions(-)
