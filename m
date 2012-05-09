Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2EIGNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:13:11 -0400
Received: from ozlabs.org ([203.10.76.45]:60415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2EIGNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:13:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Ingo Molnar" <mingo@redhat.com>, x86@kernel.org
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: anton@samba.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 09 May 2012 15:40:07 +0930
Message-ID: <87ipg5c2bk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        I finally rebased this on top of your tip tree, and tested it
locally.  Some more old-style cpumask usages have crept in, but it's a
fairly simple series.

The final result is that if you enable CONFIG_CPUMASK_OFFSTACK, then
'struct cpumask' becomes an undefined type.  You can't accidentally take
the size of it, assign it, or pass it by value.  And thus it's safe for
us to make it smaller if nr_cpu_ids < NR_CPUS, as the final patch does.

It unfortunately requires the lglock cleanup patch, which Al already has
queued, so I've included it here.

Cheers,
Rusty.

The following changes since commit 76b12156b42f876ae399dd9db1cbef27c24a4899:

  Merge branch 'x86/apic' (2012-05-07 19:21:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/cpumask.git master

for you to fetch changes up to 45e788415aced8d518817d6be968ab4a132724ed:

  cpumask: reduce cpumask_size (2012-05-09 15:02:15 +0930)

----------------------------------------------------------------
Rusty Russell (9):
      lglock: remove online variants of lock
      page_alloc: use cpumask_var_t.
      cpumask: prepare for reduced cpumask_allocation.
      cpumask: make task_struct.cpus_allowed a cpumask_var_t
      cpumask: select disabling obsolete cpumask functions on x86
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
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 ++--
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 drivers/acpi/processor_throttling.c          |    4 +-
 drivers/firmware/dcdbas.c                    |    2 +-
 fs/proc/array.c                              |    4 +-
 include/linux/cpumask.h                      |   25 ++++++++---
 include/linux/init_task.h                    |    9 +++-
 include/linux/interrupt.h                    |    2 +-
 include/linux/lglock.h                       |   58 +-------------------------
 include/linux/mm_types.h                     |   25 +++++++++--
 include/linux/sched.h                        |    6 +--
 kernel/cpuset.c                              |    2 +-
 kernel/fork.c                                |   31 +++++++++-----
 kernel/irq/irqdesc.c                         |    2 +-
 kernel/rcutree_plugin.h                      |    4 +-
 kernel/sched/core.c                          |    6 +--
 kernel/sched/cpupri.c                        |    4 +-
 kernel/trace/trace_workqueue.c               |    6 +--
 kernel/workqueue.c                           |    2 +-
 lib/Kconfig                                  |    8 +++-
 lib/cpu_rmap.c                               |    2 +-
 lib/cpumask.c                                |    2 +
 mm/page_alloc.c                              |   17 ++++----
 31 files changed, 124 insertions(+), 127 deletions(-)


commit a9e14f56ae7519d3c98651c927be53d094a3841a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:55:15 2012 +0930

    lglock: remove online variants of lock
    
    Optimizing the slow paths adds a lot of complexity.  If you need to
    grab every lock often, you have other problems.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Nick Piggin <npiggin@kernel.dk>

commit fab26054c0500d426cf1bc2ce227a6a428dc815e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:55:15 2012 +0930

    page_alloc: use cpumask_var_t.
    
    The BSS trick works, but it still wastes space.  Especially since there's
    a nice fallback in the case where we fail to allocate a temporary cpumask.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 0196da928b332fba819877f5ab7aa02d8cd78e9b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:56:15 2012 +0930

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

commit 5583b004a294063cbb03e586680de91f316955b8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:57:15 2012 +0930

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

commit c04a0a0d6ec248a533401f284ef2173c706a8e94
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:58:15 2012 +0930

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

commit d690ee2ccc74e2cb936ddb47322617a544417d6a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 14:59:15 2012 +0930

    cpumask: get rid of cpumask_t.
    
    Very shortly, struct cpumask will be declared but undefined for
    CONFIG_CPUMASK_OFFSTACK, so use 'struct cpumask' rather than
    the obsolescent 'cpumask_t'.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 124e4f2c2b72117c303a86691881f3abd952b31c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 15:00:15 2012 +0930

    irq: remove sizeof(struct cpumask)
    
    Very shortly, struct cpumask will be declared but undefined for
    CONFIG_CPUMASK_OFFSTACK, so sizeof() won't compile.  This is a Good
    Thing, since we want to use cpumask_size() here anyway.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 898eb73305e2277be91b931c5a75484f8c87ae36
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 15:01:15 2012 +0930

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

commit 45e788415aced8d518817d6be968ab4a132724ed
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 9 15:02:15 2012 +0930

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
