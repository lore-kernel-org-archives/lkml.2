Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2BPEMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:12:37 -0500
Received: from ozlabs.org ([203.10.76.45]:52256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2BPEMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:12:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@tglx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
Subject: cpumask: reduce cpumask allocation size for CONFIG_CPUMASK_OFFSTACK.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 16 Feb 2012 14:41:55 +1030
Message-ID: <87d39fbeno.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've had these sitting in my queue for almost 3 years, but since Thomas
and Linus converted mm_struct to a cpumask_var_t, it's gotten easier.
Refreshed them on top of -tip.

The aim is to allow 'struct cpumask' to be undefined (but declared) if
CONFIG_CPUMASK_OFFSTACK is set.  This avoids assignment, pass-by-value,
etc, so we can finally safely allocate nr_cpu_ids bits instead of
NR_CPUS.

The last holdout is 'struct task_struct', and we use a similar
alloc-at-end style to mm_struct.

Of course, more testing is needed...
Thanks,
Rusty.

The following changes since commit 6541f3667d5aa8996c8a22e8c878a59564d9590d:

  Merge branch 'linus' (2012-02-14 16:01:39 +0100)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git cpumask-tip-wip

Rusty Russell (8):
      cpumask: prepare for reduced cpumask_allocation.
      cpumask: make task_struct.cpus_allowed a cpumask_var_t
      cpumask: select disabling obsolete cpumask functions on x86
      cpumask: fix lg_lock/br_lock.
      cpumask: get rid of cpumask_t.
      irq: remove sizeof(struct cpumask)
      cpumask: remove struct cpumask definition when CONFIG_CPUMASK_OFFSTACK=y
      cpumask: reduce cpumask_size

 arch/arm/mach-integrator/cpu.c               |    4 +-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 +-
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/salinfo.c                   |    2 +-
 arch/ia64/kernel/topology.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 +-
 arch/mips/include/asm/system.h               |    3 +-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 +++---
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 drivers/acpi/processor_throttling.c          |    4 +-
 drivers/firmware/dcdbas.c                    |    2 +-
 fs/file_table.c                              |    2 +-
 fs/namespace.c                               |    4 ++-
 fs/proc/array.c                              |    4 +-
 include/linux/cpumask.h                      |   25 ++++++++++++++++-----
 include/linux/init_task.h                    |    9 +++++++-
 include/linux/interrupt.h                    |    2 +-
 include/linux/lglock.h                       |   23 +++++++++++--------
 include/linux/mm_types.h                     |   23 +++++++++++++++++--
 include/linux/sched.h                        |    6 ++--
 kernel/cpuset.c                              |    4 +-
 kernel/fork.c                                |   30 ++++++++++++++++---------
 kernel/irq/irqdesc.c                         |    2 +-
 kernel/rcutree_plugin.h                      |    4 +-
 kernel/sched/core.c                          |    6 ++--
 kernel/sched/cpupri.c                        |    4 +-
 kernel/trace/trace_workqueue.c               |    6 ++--
 kernel/workqueue.c                           |    2 +-
 lib/Kconfig                                  |    8 +++++-
 lib/cpu_rmap.c                               |    2 +-
 lib/cpumask.c                                |    2 +
 33 files changed, 132 insertions(+), 75 deletions(-)

commit 5fadb164e2a9e8d58e0662d803d7e43992c80a7c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:11 2012 +1030

    cpumask: prepare for reduced cpumask_allocation.
    
    Thomas and Linus already made CONFIG_CPUMASK_OFFSTACK use a cpumask
    at the end of struct mm_struct, this just changes it into a bitmap
    and allocates it using cpumask_size().
    
    This means it will shrink when cpumask_size() is changed to reflect
    nr_cpu_ids not NR_CPUS.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 include/linux/mm_types.h |   21 +++++++++++++++++++--
 kernel/fork.c            |   13 +++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

commit 3b40c642842881e71c70fd1496a406b53bcee62b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:20 2012 +1030

    cpumask: make task_struct.cpus_allowed a cpumask_var_t
    
    This turns it into a pointer for everyone.  No change for those
    already using the tsk_cpus_allowed() accessor; I've enhanced some of
    the sched/ code to use that.  For others, I just changed them
    directly.
    
    For CONFIG_CPUMASK_OFFSTACK=y, we now allocate it off the end; it
    would be better to avoid the indirection and use a dangling bitmap,
    but I didn't want to alter the layout of task_struct and risk breaking
    carefully balanced caches.
    
    Even better would be to point to the fixed "one cpu" and "all cpus"
    masks where possible, and make a copy when setting it to something
    else.  But you'd have to track down those naughty places which frob it
    directly...
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 arch/arm/mach-integrator/cpu.c               |    4 ++--
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 ++--
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/salinfo.c                   |    2 +-
 arch/ia64/kernel/topology.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 +-
 arch/mips/include/asm/system.h               |    3 ++-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 ++++----
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 drivers/acpi/processor_throttling.c          |    4 ++--
 drivers/firmware/dcdbas.c                    |    2 +-
 fs/proc/array.c                              |    4 ++--
 include/linux/init_task.h                    |    9 ++++++++-
 include/linux/sched.h                        |    4 ++--
 kernel/cpuset.c                              |    4 ++--
 kernel/fork.c                                |   17 ++++++++++++++++-
 kernel/rcutree_plugin.h                      |    4 ++--
 kernel/sched/core.c                          |    6 +++---
 kernel/sched/cpupri.c                        |    4 ++--
 kernel/trace/trace_workqueue.c               |    6 +++---
 kernel/workqueue.c                           |    2 +-
 23 files changed, 61 insertions(+), 38 deletions(-)

commit 68f666acb7b838675fdf9488cb22f016c8d9922c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:29 2012 +1030

    cpumask: select disabling obsolete cpumask functions on x86
    
    It currently depends on CONFIG_BROKEN; change to be set by
    CONFIG_CPUMASK_OFFSTACK now it all compiles.
    
    We also complete it: the header shouldn't refer to the deprected
    CPU_MASK_LAST_WORD, and the deprecated implementations are removed.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 include/linux/cpumask.h |    4 ++--
 include/linux/sched.h   |    2 +-
 lib/Kconfig             |    8 ++++++--
 lib/cpumask.c           |    2 ++
 4 files changed, 11 insertions(+), 5 deletions(-)

commit 2d7109dfd6789444c49099574de603cc3bd089a1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:39 2012 +1030

    cpumask: fix lg_lock/br_lock.
    
    Use a cpumask_var_t instead of cpumask_t.  We're doing plenty of
    allocations here anyway, so it's not really an issue, and it sets a
    good example.
    
    (cpumask_t is obsolescent, as are the cpus_* functions).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 fs/file_table.c        |    2 +-
 fs/namespace.c         |    4 +++-
 include/linux/lglock.h |   23 +++++++++++++----------
 3 files changed, 17 insertions(+), 12 deletions(-)

commit f35bdd306dc92e247e9cc398e783be15417538e6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:47 2012 +1030

    cpumask: get rid of cpumask_t.
    
    Very shortly, struct cpumask will be declared but undefined for
    CONFIG_CPUMASK_OFFSTACK, so use 'struct cpumask' rather than
    the obsolescent 'cpumask_t'.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/interrupt.h |    2 +-
 include/linux/mm_types.h  |    2 +-
 lib/cpu_rmap.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

commit 41fa3963db50afaf7156901adf726ab2d054229a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:26:55 2012 +1030

    irq: remove sizeof(struct cpumask)
    
    Very shortly, struct cpumask will be declared but undefined for
    CONFIG_CPUMASK_OFFSTACK, so sizeof() won't compile.  This is a Good
    Thing, since we want to use cpumask_size() here anyway.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/irq/irqdesc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 365e3e26f8bf81a5abde817a00a0e6d442c53fe1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:27:03 2012 +1030

    cpumask: remove struct cpumask definition when CONFIG_CPUMASK_OFFSTACK=y
    
    We're about to change CONFIG_CPUMASK_OFFSTACK so it only allocate
    nr_cpu_ids bits for all cpumasks.  We need to make sure that when
    CONFIG_CPUMASK_OFFSTACK is set:
    
    1) Noone uses the old bitmap ops, which use NR_CPUS bits (use cpumask_*)
    2) Noone uses assignment of struct cpumask (use cpumask_copy)
    3) Noone passes a struct cpumask (pass a pointer)
    4) Noone declares them on the stack (use cpumask_var_t)
    
    So we finally remove the definition of struct cpumask when
    CONFIG_CPUMASK_OFFSTACK=y.  This means that these usages will hit a compile
    error the moment that config option is turned on.
    
    Note that it also means you can't declare a static cpumask.  You
    should avoid this anyway (use cpumask_var_t), but there's a
    deliberately-ugly workaround for special cases, using DECLARE_BITMAP()
    and to_cpumask().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 include/linux/cpumask.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

commit 07ad9d8d49dd9c0c8c962a7bdae502c7ef168add
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Feb 16 14:27:10 2012 +1030

    cpumask: reduce cpumask_size
    
    Now we're sure noone is using old cpumask operators, nor *cpumask, we can
    allocate less bits safely.  This reduces the memory usage of off-stack
    cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
    cpus.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 include/linux/cpumask.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)
