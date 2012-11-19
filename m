Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2KSFnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:43:00 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40499 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2KSF2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:28:47 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 00/58] Eliminate GCC -Wmissing-prototypes warnings from allnoconfig
Date: Sun, 18 Nov 2012 21:27:39 -0800
Message-Id: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[In addition to the patch mails sent as replies to this email, I've made this
series available for pulling as a signed tag from:

  git://git.kernel.org/pub/scm/linux/kernel/git/josh/linux tags/Wmissing-prototypes-allnoconfig

for you to fetch changes up to 4cb5b6cf8a272557cbd1c88a56cf40355a7a69f1:

  sched: Move stubs for CONFIG_RT_GROUP_SCHED=n to sched.h (2012-11-08 09:38:06 -0800)

I started this series from v3.7-rc3, but I've confirmed that it merges into
v3.7-rc6 and still builds.]

GCC (with -Wmissing-prototypes) and Sparse (with -Wdecl, on by default)
warn about non-static function definitions without previous prototypes.
The two most common fixes for this warning represent useful code
improvements:

- Marking internal file-local functions static, which allows
  cross-function optimizations and dead code detection.

- Including the header files that prototype non-internal functions,
  which ensures that the prototype matches the definition, and gets
  defined under all the same circumstances (such as preprocessor
  symbols).

To observe these warnings, apply the following Makefile patch (not
included in this series to avoid introducing a large number of new,
unfixed warnings):

--- a/Makefile
+++ b/Makefile
@@ -369,7 +369,8 @@ LINUXINCLUDE    := \
 
 KBUILD_CPPFLAGS := -D__KERNEL__
 
-KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
+KBUILD_CFLAGS   := -Wall -Wundef -Wmissing-prototypes -Wstrict-prototypes \
+		   -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \

This patch series eliminates all such warnings from a "make allnoconfig"
kernel.  I started with allnoconfig to create the smallest possible
warning-free baseline; allnoconfig also triggered various edge cases for
stub functions or different preprocessor conditionals around definitions
and header prototypes, which would not appear in a defconfig or
allyesconfig build.

In addition to the above two types of fixes (marking internal functions
static and including headers for non-internal functions), these patches
also:

- Fix some ifdef logic to avoid defining unused and un-prototyped
  functions
- Drop some completely unused functions
- Drop __weak from one function (hw_breakpoint_weight) and make it
  static instead, because no architecture actually overrides that
  function anymore.
- In a few cases, add a dummy prototype immediately before a function to
  suppress the warning; those cases typically involved a function called
  from only one other file and referenced via an explict extern
  prototype, which shouldn't necessarily go in a header file or
  encourage more widespread use.  For instance, this occurred with
  functions called from init/main.c.

I've CCed appropriate maintainers for each individual patch, but I
really hope this series can just go in as a single pull rather than
filtering in through several dozen different trees.

Josh Triplett (58):
  pty: Mark pty_resize static
  drivers/tty/vt/vt_ioctl.c: Include <linux/suspend.h> for pm_set_vt_switch
  sched: Mark scale_rt_power static
  x86: apic: Mark enable_IR static
  x86: Only define default_init_apic_ldr for 32-bit
  trace: Mark tracing_dentry_percpu static
  lib/iommu-helper.c: Include <linux/iommu-helper.h> for function prototypes
  tty: Mark tty_del_file and __tty_hangup static
  fs/locks.c: Mark generic_add_lease and generic_delete_lease static
  swiotlb: Prototype swiotlb_late_init_with_default_size in swiotlb.h
  tty: Mark sysfs_attr_ns static
  linux/irq_work.h: Add prototype for arch_irq_work_raise
  RCU: Make rcu_is_cpu_rrupt_from_idle helper functions static
  x86: Mark EVT_TO_HPET_DEV static
  kernel/time/timekeeping.c: Include tick-internal.h for do_timer prototype
  drivers/base/core.c: Mark to_root_device static
  arch/x86/kernel/cpu/perf_event_intel_uncore.c: Mark internal functions static
  mm: bootmem: Declare internal ___alloc_bootmem_node function static
  block: Mark __blkdev_issue_zeroout static
  kernel/events/hw_breakpoint.c: Make hw_breakpoint_weight static
  kernel/events/core.c: Mark internal function static
  arch/x86/kernel/cpu/common.c: Mark cpu_detect_tlb static
  mm: Avoid defining set_iounmap_nonlazy on non-x86
  mm: include/linux/huge_mm.h: Declare is_vma_temporary_stack unconditionally
  mm: include/linux/huge_mm.h: Declare handle_pte_fault unconditionally
  mm/internal.h: Declare vma_address unconditionally
  x86: apic: Make apic_flat_64.c include asm/apic_flat_64.h for flat_init_apic_ldr prototype
  x86: io_apic: Don't define acpi_get_override_irq if CONFIG_ACPI=n
  mm: Make copy_pte_range static
  block: Eliminate unused function kblockd_schedule_delayed_work
  perf: cgroup: Drop unused perf_cgroup_switch stub
  kernel/resource.c: Include linux/mm.h for page_is_ram prototype
  kernel/resource.c: Make internal function reallocate_resource static
  kbuild: kernel/bounds.c: Add prototype for dummy function foo
  x86: arch/x86/kernel/asm-offsets.c: Add prototype for dummy function common
  kernel/fork.c: Add prototype for __weak stub of arch_release_thread_info
  kernel/fork.c: Add prototype for fork_init
  block: Mark internal function blk_drain_queue static
  kernel/events/core.c: Add prototype for __weak stub of arch_perf_update_userpage
  panic: Add prototype for __weak stub of panic_smp_self_stop
  init/calibrate.c: Add prototype for __weak stub of calibrate_delay_is_known
  kernel/events/hw_breakpoint.c: Add prototype for __weak stub of arch_unregister_hw_breakpoint
  mm: Mark fallback version of __early_pfn_to_nid static
  mm: Only define is_pageblock_removable_nolock when needed
  x86: Fix prototype for renamed function smp_threshold_interrupt
  x86: arch/x86/kernel/irqinit.c: Add prototype for init_IRQ
  x86: arch/x86/kernel/process.c: Include asm/switch_to.h for __switch_to_xtra prototype
  x86: arch/x86/kernel/time.c: Include asm/setup.h for setup_default_timer_irq prototype
  x86: init: Mark internal functions iommu_init_noop and iommu_shutdown_noop static
  x86: arch/x86/kernel/irq_work.c: Add prototype for smp_irq_work_interrupt
  x86: perf: Add prototype for arch_perf_update_userpage
  x86: vdso: Add prototypes for __vdso_* functions
  linux/syscalls.h: Add prototypes for sys_rt_sigaction and sys_rt_sigsuspend
  linux/syscalls.h: Include asm/syscalls.h for additional prototypes
  sched: Add prototype for sched_set_stop_task
  sched: Only define init_cfs_bandwidth stub when CONFIG_FAIR_GROUP_SCHED=y
  sched: Move stubs for CONFIG_FAIR_GROUP_SCHED=n to sched.h
  sched: Move stubs for CONFIG_RT_GROUP_SCHED=n to sched.h

 arch/ia64/hp/common/sba_iommu.c               |    3 +--
 arch/x86/include/asm/traps.h                  |    2 +-
 arch/x86/kernel/apic/apic.c                   |    4 +++-
 arch/x86/kernel/apic/apic_flat_64.c           |    1 +
 arch/x86/kernel/apic/io_apic.c                |    2 ++
 arch/x86/kernel/asm-offsets.c                 |    2 ++
 arch/x86/kernel/cpu/common.c                  |    2 +-
 arch/x86/kernel/cpu/perf_event.c              |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    8 ++++----
 arch/x86/kernel/hpet.c                        |    2 +-
 arch/x86/kernel/irq_work.c                    |    2 ++
 arch/x86/kernel/irqinit.c                     |    1 +
 arch/x86/kernel/process.c                     |    1 +
 arch/x86/kernel/time.c                        |    1 +
 arch/x86/kernel/x86_init.c                    |    4 ++--
 arch/x86/pci/sta2x11-fixup.c                  |    2 +-
 arch/x86/vdso/vclock_gettime.c                |    3 +++
 arch/x86/vdso/vgetcpu.c                       |    2 ++
 block/blk-core.c                              |    9 +--------
 block/blk-lib.c                               |    2 +-
 drivers/base/core.c                           |    2 +-
 drivers/tty/pty.c                             |    2 +-
 drivers/tty/tty_io.c                          |    4 ++--
 drivers/tty/vt/vt_ioctl.c                     |    1 +
 fs/locks.c                                    |    4 ++--
 fs/sysfs/file.c                               |    4 ++--
 include/linux/huge_mm.h                       |   15 ++++++---------
 include/linux/irq_work.h                      |    2 ++
 include/linux/swiotlb.h                       |    1 +
 include/linux/syscalls.h                      |    4 ++++
 init/calibrate.c                              |    1 +
 kernel/bounds.c                               |    2 ++
 kernel/events/core.c                          |   13 +++++--------
 kernel/events/hw_breakpoint.c                 |    3 ++-
 kernel/fork.c                                 |    4 ++++
 kernel/panic.c                                |    1 +
 kernel/rcutiny.c                              |    2 +-
 kernel/rcutree.c                              |    2 +-
 kernel/resource.c                             |    3 ++-
 kernel/sched/core.c                           |    2 ++
 kernel/sched/fair.c                           |   16 ++--------------
 kernel/sched/rt.c                             |    7 -------
 kernel/sched/sched.h                          |   24 ++++++++++++++++++++++++
 kernel/time/timekeeping.c                     |    1 +
 kernel/trace/trace.c                          |    2 +-
 lib/iommu-helper.c                            |    1 +
 mm/bootmem.c                                  |    8 +++++---
 mm/internal.h                                 |    2 --
 mm/memory.c                                   |    7 ++++---
 mm/nobootmem.c                                |    8 +++++---
 mm/page_alloc.c                               |    4 +++-
 mm/vmalloc.c                                  |    3 +++
 52 files changed, 125 insertions(+), 85 deletions(-)

-- 
1.7.10.4

