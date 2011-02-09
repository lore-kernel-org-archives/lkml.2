Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab1BIFjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:39:07 -0500
Received: from ozlabs.org ([203.10.76.45]:43971 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1BIFjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:39:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PULL] cpumask offstack finalization
Date: Wed, 9 Feb 2011 16:08:59 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102091608.59448.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

   A few more obsolete uses of cpumask has crept into the tree; all easily
fixed.  This is rebased onto your -tip tree and re-tested; it finally means
that we can detect obsolescent (and hence dangerous) cpumask usage when 
CONFIG_CPUMASK_OFFSTACK=y.  It finally reduces the actual allocation of
cpumask_var_t to the number of cpus we actually have.

I assume you want these via your tree: they definitely need testing across
architectures, though the transforms are mechanical.

Thanks!
Rusty.

The following changes since commit 25ca954821a28c2648feeb166bcea0488ee0c202:

  Merge branch 'core/urgent' (2011-02-08 16:18:50 +0100)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86.git cpumask

Rusty Russell (9):
      cpumask: remove obsolete cpu operation in x86/kernel/apb_timer.c
      cpumask: update obsolescent use of cpumask_t in include/linux/interrupt.h
      cpumask: update obsolescent use of cpu_isset in net/core/net-sysfs.c
      cpumask: update obsolescent use of cpumask_t in drivers/crypto/n2_core.c
      cpumask: truncate mm_struct.cpu_vm_mask for CONFIG_CPUMASK_OFFSTACK
      cpumask: make task_struct.cpus_allowed a cpumask_var_t
      cpumask: select disabling obsolete cpumask functions on x86
      cpumask: remove struct cpumask definition when CONFIG_CPUMASK_OFFSTACK=y
      cpumask: reduce cpumask_size

 arch/arm/mach-integrator/cpu.c               |    4 ++--
 arch/blackfin/kernel/process.c               |    3 ++-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 ++--
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/salinfo.c                   |    2 +-
 arch/ia64/kernel/topology.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 +-
 arch/mips/include/asm/system.h               |    3 ++-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 ++++----
 arch/powerpc/kernel/smp.c                    |    2 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 +-
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/sparc/kernel/sysfs.c                    |    2 +-
 arch/sparc/kernel/us2e_cpufreq.c             |    4 ++--
 arch/sparc/kernel/us3_cpufreq.c              |    4 ++--
 arch/x86/kernel/apb_timer.c                  |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 arch/x86/kernel/tboot.c                      |    2 +-
 drivers/acpi/processor_throttling.c          |    4 ++--
 drivers/crypto/n2_core.c                     |    6 +++---
 drivers/firmware/dcdbas.c                    |    2 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    6 +++---
 drivers/infiniband/hw/qib/qib_file_ops.c     |    6 +++---
 fs/proc/array.c                              |    4 ++--
 include/linux/cpumask.h                      |   25 +++++++++++++++++++------
 include/linux/cpuset.h                       |    2 +-
 include/linux/init_task.h                    |    9 ++++++++-
 include/linux/interrupt.h                    |    3 ++-
 include/linux/mm_types.h                     |   21 ++++++++++++++++++---
 include/linux/sched.h                        |    6 +++---
 kernel/cpuset.c                              |    8 ++++----
 kernel/fork.c                                |   23 +++++++++++++++++++----
 kernel/kthread.c                             |    2 +-
 kernel/sched.c                               |   18 +++++++++---------
 kernel/sched_cpupri.c                        |    4 ++--
 kernel/sched_fair.c                          |   12 ++++++------
 kernel/sched_rt.c                            |    6 +++---
 kernel/trace/trace_workqueue.c               |    6 +++---
 kernel/workqueue.c                           |    2 +-
 lib/Kconfig                                  |    8 ++++++--
 lib/cpumask.c                                |    2 ++
 lib/smp_processor_id.c                       |    2 +-
 mm/init-mm.c                                 |    2 +-
 net/core/net-sysfs.c                         |    2 +-
 45 files changed, 152 insertions(+), 93 deletions(-)

commit 248c3f52bec0473e5cc1be1c0888dc1a071e8019
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 11:59:52 2011 +1030

    cpumask: remove obsolete cpu operation in x86/kernel/apb_timer.c
    
    first_cpu -> cpumask_first
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/x86/kernel/apb_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 0574017fe487e189512a4a295671f3f2ec492443
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 15:49:05 2011 +1030

    cpumask: update obsolescent use of cpumask_t in include/linux/interrupt.h
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/interrupt.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

commit d1314fe9407523fc4f0a943612e7c1bb50c2fb8d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 15:49:35 2011 +1030

    cpumask: update obsolescent use of cpu_isset in net/core/net-sysfs.c
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 net/core/net-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit a35b7541e121159caabe962bbe6f01488cef5485
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 15:50:40 2011 +1030

    cpumask: update obsolescent use of cpumask_t in drivers/crypto/n2_core.c
    
    These days we use struct cpumask, and cpumask_* instead of the obsolescent
    cpu_*/cpus_* functions.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/crypto/n2_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

commit baece92fc28acf8e2e44dc6e942c656df12150c9
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 11:59:51 2011 +1030

    cpumask: truncate mm_struct.cpu_vm_mask for CONFIG_CPUMASK_OFFSTACK
    
    Turns cpu_vm_mask into a bitmap, and truncate it to cpumask_size(): if
    CONFIG_CPUMASK_OFFSTACK is set, this will reflect nr_cpu_ids not NR_CPUS.
    
    I do this rather than the classic [0] dangling array trick, because of
    init_mm, which is static and widely referenced.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: anton@samba.org
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Mike Travis <travis@sgi.com>

 arch/x86/kernel/tboot.c  |    2 +-
 include/linux/mm_types.h |   21 ++++++++++++++++++---
 kernel/fork.c            |    6 +++---
 mm/init-mm.c             |    2 +-
 4 files changed, 23 insertions(+), 8 deletions(-)

commit ae0849f28dba2ca41ca8d6631f5dcf9a81875eea
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 13:32:37 2011 +1030

    cpumask: make task_struct.cpus_allowed a cpumask_var_t
    
    This turns it into a pointer for everyone.  Rather than churn everyone
    via the tsk_cpus_allowed() wrapper, we change them directly.  If there
    are any users in the meantime they can use the wrapper.
    
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
 arch/blackfin/kernel/process.c               |    3 ++-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 ++--
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/salinfo.c                   |    2 +-
 arch/ia64/kernel/topology.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 +-
 arch/mips/include/asm/system.h               |    3 ++-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 ++++----
 arch/powerpc/kernel/smp.c                    |    2 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 +-
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/sparc/kernel/sysfs.c                    |    2 +-
 arch/sparc/kernel/us2e_cpufreq.c             |    4 ++--
 arch/sparc/kernel/us3_cpufreq.c              |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 drivers/acpi/processor_throttling.c          |    4 ++--
 drivers/firmware/dcdbas.c                    |    2 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    6 +++---
 drivers/infiniband/hw/qib/qib_file_ops.c     |    6 +++---
 fs/proc/array.c                              |    4 ++--
 include/linux/cpuset.h                       |    2 +-
 include/linux/init_task.h                    |    9 ++++++++-
 include/linux/sched.h                        |    4 ++--
 kernel/cpuset.c                              |    8 ++++----
 kernel/fork.c                                |   17 ++++++++++++++++-
 kernel/kthread.c                             |    2 +-
 kernel/sched.c                               |   18 +++++++++---------
 kernel/sched_cpupri.c                        |    4 ++--
 kernel/sched_fair.c                          |   12 ++++++------
 kernel/sched_rt.c                            |    6 +++---
 kernel/trace/trace_workqueue.c               |    6 +++---
 kernel/workqueue.c                           |    2 +-
 lib/smp_processor_id.c                       |    2 +-
 35 files changed, 94 insertions(+), 70 deletions(-)

commit 1602bf3ac37e66f5ad7022de4dcde317db964e32
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 11:59:49 2011 +1030

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

commit d2594c0ef22017f2fbf6eacd21aa74590982e36f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 11:59:49 2011 +1030

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

commit 5a9c141a738da5bf0cdbab099ed62155fd47fb67
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Feb 9 11:59:48 2011 +1030

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
