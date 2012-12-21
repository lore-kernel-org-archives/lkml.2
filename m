Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab2LUFUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:20:40 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61034 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2LUFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
From: Hakan Akkan <hakanakkan@gmail.com>
Date: Thu, 20 Dec 2012 22:20:13 -0700
Message-ID: <CABVzNXqn1+RAGP5O9g327p274QyHpSqr53ETU4CvOF30Pi2wYA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.7-nohz1
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 20, 2012 at 11:32 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> Hi,
>
> So this is a new version of the nohz cpusets based on 3.7, except it's not using
> cpusets anymore and I actually based it on the middle of the 3.8 merge window
> in order to get latest upstream full dynticks preparatory work: cputime cleanups,
> RCU user mode, context tracking subsystem, nohz code consolidation, ...
>
> So the big changes since the last nohz cpuset release are:
>
> * printk now uses irq work so it doesn't rely on the tick anymore (provided
> your arch implements irq work with IPIs or alike). This chunk has been proposed
> for the 3.8 merge window: https://lkml.org/lkml/2012/12/17/177
> May be Linus will pull, may be not. We'll see. In any case I've included it in this tree
> but I'm not reposting this part of the patchset to avoid spamming you.
>
> * cputime doesn't rely on IPIs anymore. Now the reader does a special computation to
> remotely get the tickless cputime.
>
> * No more cpusets interface. Paul McKenney suggested me to start with a boot time
> kernel parameter to define the full dynticks cpumask. And he was totally right, it
> makes the code much more simple. That's a good way to start and to make the mainlining
> easier. We can still add a runtime configuration later if necessary.

It would be nice to have the runtime configuration ability. A percpu control
file such as /sys/devices/system/cpu/cpuX/isol could configure that cpu with
different levels of isolation. Users could echo bitmasks where each bit is
associated with a level of isolation. echo 0 disables all isolation.
Bit 1 disables
RCU callbacks on that CPU, bit 2 isolates the CPU from the general scheduler
just like isolcpus boot argument does, bit 3 pushes all irqs away, bit 4 turns
off the ticks etc.

I always hoped that someone will make isolcpus a runtime option so I guess
it is time to get my hands dirty. Any pointers for this?

>
> * Now there is always a CPU handling the timekeeping. This can be further optimized
> and more power-friendly, I really did something simple-stupid. I guess we'll try to get
> that into a better shape with Hakan. But at least the timekeeping now works.

Will look into it.

>
> * It uses the new RCU callbacks offlining feature. This way a full dynticks CPU doesn't
> need to keep the tick to handle local callbacks. This is still very experimental though.
>
> * No more specific IPI vector for full dynticks. We just use the scheduler ipi.
>
> The branch is:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         3.7-nohz1
>
> There is still quite some work to do.
>
> == How to use? ==
>
> Select:
>         CONFIG_NO_HZ
>         CONFIG_RCU_USER_QS
>         CONFIG_VIRT_CPU_ACCOUNTING_GEN
>         CONFIG_RCU_NOCB_CPU
>         CONFIG_NO_HZ_FULL
>
> You always need at least one timekeeping CPU.
>
> Let's imagine you have 4 CPUs. We keep the CPU 0 to offline RCU callbacks there and to
> handle the timekeeping. We set the rest as full dynticks. So you need the following kernel
> parameters:
>
>         rcu_nocbs=1-3 full_nohz=1-3
>
> (Note rcu_nocbs value must always be the same as full_nohz).
>
> Now if you want proper isolation you need to:
>
> * Migrate your processes adequately
> * Migrate your irqs to CPU 0
> * Migrate the RCU nocb threads to CPU 0. Example with the above configuration:
>
>         for p in $(ps -o pid= -C rcuo1,rcuo2,rcuo3)
>         do
>                 taskset -cp 0 $p
>         done
>
> Then run what you want on the full dynticks CPUs. For best results, run 1 task
> per CPU, mostly in userspace and mostly CPU bound (otherwise more IO = more kernel
> mode execution = more chances to get IPIs, tick restarted, workqueues, kthreads, etc...)
>
> This page contains a good reminder for those interested in CPU isolation: https://github.com/gby/linux/wiki
>
> But keep in mind that my tree is not yet ready for serious production.
>
> Happy Christmas, new year or whatever end of the world.
> ---
>
> Frederic Weisbecker (32):
>       irq_work: Fix racy IRQ_WORK_BUSY flag setting
>       irq_work: Fix racy check on work pending flag
>       irq_work: Remove CONFIG_HAVE_IRQ_WORK
>       nohz: Add API to check tick state
>       irq_work: Don't stop the tick with pending works
>       irq_work: Make self-IPIs optable
>       printk: Wake up klogd using irq_work
>       Merge branch 'nohz/printk-v8' into 3.7-nohz1-stage
>       context_tracking: Add comments on interface and internals
>       cputime: Generic on-demand virtual cputime accounting
>       cputime: Allow dynamic switch between tick/virtual based cputime accounting
>       cputime: Use accessors to read task cputime stats
>       cputime: Safely read cputime of full dynticks CPUs
>       nohz: Basic full dynticks interface
>       nohz: Assign timekeeping duty to a non-full-nohz CPU
>       nohz: Trace timekeeping update
>       nohz: Wake up full dynticks CPUs when a timer gets enqueued
>       rcu: Restart the tick on non-responding full dynticks CPUs
>       sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
>       sched: Update rq clock on nohz CPU before migrating tasks
>       sched: Update rq clock on nohz CPU before setting fair group shares
>       sched: Update rq clock on tickless CPUs before calling check_preempt_curr()
>       sched: Update rq clock earlier in unthrottle_cfs_rq
>       sched: Update clock of nohz busiest rq before balancing
>       sched: Update rq clock before idle balancing
>       sched: Update nohz rq clock before searching busiest group on load balancing
>       nohz: Move nohz load balancer selection into idle logic
>       nohz: Full dynticks mode
>       nohz: Only stop the tick on RCU nocb CPUs
>       nohz: Don't turn off the tick if rcu needs it
>       nohz: Don't stop the tick if posix cpu timers are running
>       nohz: Add some tracing
>
> Steven Rostedt (2):
>       irq_work: Flush work on CPU_DYING
>       irq_work: Warn if there's still work on cpu_down
>
>  arch/alpha/Kconfig                  |    1 -
>  arch/alpha/kernel/osf_sys.c         |    6 +-
>  arch/arm/Kconfig                    |    1 -
>  arch/arm64/Kconfig                  |    1 -
>  arch/blackfin/Kconfig               |    1 -
>  arch/frv/Kconfig                    |    1 -
>  arch/hexagon/Kconfig                |    1 -
>  arch/mips/Kconfig                   |    1 -
>  arch/parisc/Kconfig                 |    1 -
>  arch/powerpc/Kconfig                |    1 -
>  arch/s390/Kconfig                   |    1 -
>  arch/s390/kernel/vtime.c            |    4 +-
>  arch/sh/Kconfig                     |    1 -
>  arch/sparc/Kconfig                  |    1 -
>  arch/x86/Kconfig                    |    1 -
>  arch/x86/kernel/apm_32.c            |   11 +-
>  drivers/isdn/mISDN/stack.c          |    7 +-
>  drivers/staging/iio/trigger/Kconfig |    1 -
>  fs/binfmt_elf.c                     |    8 +-
>  fs/binfmt_elf_fdpic.c               |    7 +-
>  include/asm-generic/cputime.h       |    1 +
>  include/linux/context_tracking.h    |   28 +++++
>  include/linux/hardirq.h             |    4 +-
>  include/linux/init_task.h           |    9 ++
>  include/linux/irq_work.h            |   20 +++
>  include/linux/kernel_stat.h         |    2 +-
>  include/linux/posix-timers.h        |    1 +
>  include/linux/printk.h              |    3 -
>  include/linux/rcupdate.h            |    8 ++
>  include/linux/sched.h               |   48 +++++++-
>  include/linux/tick.h                |   26 ++++-
>  include/linux/vtime.h               |   47 +++++---
>  init/Kconfig                        |   22 +++-
>  kernel/acct.c                       |    6 +-
>  kernel/context_tracking.c           |   91 +++++++++++----
>  kernel/cpu.c                        |    4 +-
>  kernel/delayacct.c                  |    7 +-
>  kernel/exit.c                       |    6 +-
>  kernel/fork.c                       |    8 +-
>  kernel/irq_work.c                   |  131 ++++++++++++++++-----
>  kernel/posix-cpu-timers.c           |   39 +++++-
>  kernel/printk.c                     |   36 +++---
>  kernel/rcutree.c                    |   19 +++-
>  kernel/rcutree_plugin.h             |   13 +--
>  kernel/sched/core.c                 |   69 +++++++++++-
>  kernel/sched/cputime.c              |  222 ++++++++++++++++++++++++++++++-----
>  kernel/sched/fair.c                 |   42 +++++++-
>  kernel/sched/sched.h                |   15 +++
>  kernel/signal.c                     |   12 ++-
>  kernel/softirq.c                    |   11 +-
>  kernel/time/Kconfig                 |    9 ++
>  kernel/time/tick-broadcast.c        |    3 +-
>  kernel/time/tick-common.c           |    5 +-
>  kernel/time/tick-sched.c            |  142 ++++++++++++++++++++---
>  kernel/timer.c                      |    3 +-
>  kernel/tsacct.c                     |   19 ++-
>  56 files changed, 955 insertions(+), 233 deletions(-)
