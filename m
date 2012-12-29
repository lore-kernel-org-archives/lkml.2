Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2L2QnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:43:17 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46596 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2L2QnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:14 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [ANNOUNCE] 3.8-rc1-nohz1
Date: Sat, 29 Dec 2012 17:42:39 +0100
Message-Id: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So after I released 3.7-nohz1, I shut down the light then sat down
in front of an empty wall in my flat and waited in the darkness with
a black tea for december 21th's apocalypse.

But then after a few days, I've been thinking I should have taken a
second cup of tea with me.

So I eventually got up and turned the light on. Then I booted my
computer and started working on that new release of the full dynticks
patchset.

Branch can found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	3.8-rc1-nohz1

Changes since 3.7-nohz1 include:

- Many build errors fixed (thanks to Steven Rostedt, Wu Fenguang,
Li Zhong, Namhyung Kim, sorry if I'm missing somebody in the list)

- Rebase against 3.8-rc1

- Fix copy-paste that resulted in accounting utime into stime.

- Don't hold up the tick for RCU when we are in userspace

- Handle non-pinned timers

- Remove unused tick hooks

I'm certainly forgetting something...

Anyway, so on the TODO list now:

* Make sure rcu_nocbs mask matches full_nohz's.

* Get the nohz printk patchset merged.  Unfortunately Linus ignored my
pull request for the 3.8 merge window and he did not respond to Steve's
reminders about it. Let's hope we'll have more chances on the next merge
window...

* Handle update_cpu_load_active(). I had a quick look and it shouldn't
be hard to deal with. It appears that all we need to do is to catch
up with an update from target_load() and source_load().

* Handle sched_class->task_tick(). May be a bit trickier but this shouldn't
be that hard either.

* Posix cpu timers enqueued while tick is off. Probably no big deal but
I need to look into that.

* Several trivial stuffs: perf_event_task_tick(), profile_tick(),
sched_clock_tick(), etc...

About mainlining stuff, I'll likely work on getting the nohz cputime
accounting patches into a better shape and try to get these merged for
the next merge window.

There are a few comments I haven't responded on the last release, I'm
not ignoring them. Of course I plan to answer you but for now I'm just
a bit backlogged due to holidays.

Happy new year!

---
Frederic Weisbecker (35):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work
      Merge branch 'nohz/printk-v8' into 3.8-rc1-nohz1
      context_tracking: Add comments on interface and internals
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

Steven Rostedt (2):
      irq_work: Flush work on CPU_DYING
      irq_work: Warn if there's still work on cpu_down

 arch/alpha/Kconfig                  |    1 -
 arch/alpha/kernel/osf_sys.c         |    6 +-
 arch/arm/Kconfig                    |    1 -
 arch/arm64/Kconfig                  |    1 -
 arch/blackfin/Kconfig               |    1 -
 arch/frv/Kconfig                    |    1 -
 arch/hexagon/Kconfig                |    1 -
 arch/mips/Kconfig                   |    1 -
 arch/parisc/Kconfig                 |    1 -
 arch/powerpc/Kconfig                |    1 -
 arch/s390/Kconfig                   |    1 -
 arch/s390/kernel/vtime.c            |    4 +-
 arch/sh/Kconfig                     |    1 -
 arch/sparc/Kconfig                  |    1 -
 arch/x86/Kconfig                    |    1 -
 arch/x86/kernel/apm_32.c            |   11 +-
 drivers/isdn/mISDN/stack.c          |    7 +-
 drivers/staging/iio/trigger/Kconfig |    1 -
 fs/binfmt_elf.c                     |    8 +-
 fs/binfmt_elf_fdpic.c               |    7 +-
 include/asm-generic/cputime.h       |    1 +
 include/linux/context_tracking.h    |   28 +++++
 include/linux/hardirq.h             |    4 +-
 include/linux/init_task.h           |    9 ++
 include/linux/irq_work.h            |   20 +++
 include/linux/kernel_stat.h         |    2 +-
 include/linux/posix-timers.h        |    1 +
 include/linux/printk.h              |    3 -
 include/linux/profile.h             |   13 --
 include/linux/rcupdate.h            |    8 ++
 include/linux/sched.h               |   48 +++++++-
 include/linux/tick.h                |   26 ++++-
 include/linux/vtime.h               |   47 +++++---
 init/Kconfig                        |   22 +++-
 kernel/acct.c                       |    6 +-
 kernel/context_tracking.c           |   91 +++++++++++----
 kernel/cpu.c                        |    4 +-
 kernel/delayacct.c                  |    7 +-
 kernel/exit.c                       |    6 +-
 kernel/fork.c                       |    8 +-
 kernel/irq_work.c                   |  131 ++++++++++++++++-----
 kernel/posix-cpu-timers.c           |   39 +++++-
 kernel/printk.c                     |   36 +++---
 kernel/profile.c                    |   24 ----
 kernel/rcutree.c                    |   19 +++-
 kernel/rcutree_plugin.h             |   13 +--
 kernel/sched/core.c                 |   69 +++++++++++-
 kernel/sched/cputime.c              |  222 ++++++++++++++++++++++++++++++-----
 kernel/sched/fair.c                 |   41 ++++++-
 kernel/sched/sched.h                |   15 +++
 kernel/signal.c                     |   12 ++-
 kernel/softirq.c                    |   11 +-
 kernel/time/Kconfig                 |    9 ++
 kernel/time/tick-broadcast.c        |    3 +-
 kernel/time/tick-common.c           |    5 +-
 kernel/time/tick-sched.c            |  142 ++++++++++++++++++++---
 kernel/timer.c                      |    3 +-
 kernel/tsacct.c                     |   19 ++-
 58 files changed, 954 insertions(+), 270 deletions(-)
