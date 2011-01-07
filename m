Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1AGWOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:14:55 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:33528 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1AGWOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PfzzpnY9KUvcvUN1V+42d7M+SoPwBFfx5kTTEFOx2Nx5sn8b7+Sp7pycAQPgjJOOXJ
         a5/AfmhKX013yROqTpZHG6CUbOFdIPmkOhF3c8k4EDtzAe29ModWwxUtLB2K4/CRVuEU
         5U6S/DbDqFtzSkDdcYkdXfsYAgesJCQR29fq4=
Date: Fri, 7 Jan 2011 17:14:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [GIT PULL] percpu changes for 2.6.38
Message-ID: <20110107221448.GA9884@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following git branch to receive
percpu memory allocator changes for 2.6.38.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.38

The branch contains 32 commits, most of which are Christoph Lameter's
patches to add and apply more this_cpu_*() operations.  add, sub, dec,
inc_return and cmpxhg have been added and applied to various parts.

Currently, only x86 implements optimized operations and, like other
x86 optimized this_cpu_*() operations, they generate segment prefixed
instructions directly instead of going through explicit address
offsetting.  The resulting code is slightly more efficient and, more
importantly, atomic on the local CPU as the operations become a single
instruction which makes preemption and local irq flipping unnecessary.

One operation, cmpxchg_double, didn't make it in this merge window.
Used with other operations, memory allocation hot path can be made
significantly more efficient.

New operations are added in separate this_cpu_ops branch which got
merged into for-2.6.38 which then added patches to use the new
operations.  The reason for the separation was to allow slab and other
parts of the kernel to pull in only the new operations to implement
but it didn't happen in the timeframe for this merge window.

Pulling this branch into the current master (01539ba2) causes three
conflicts under arch/x86.  This is because merging percpu into x86
seemed to make the dependency a bit too hairy causing changes applying
this_cpu_*() ops to arch/x86 code conflict with other x86 changes.
The conflicts can be resolved as follows.

1. arch/x86/kernel/apic/nmi.c

  The file is removed from x86 but modified in percpu.  It can simply be
  removed.

2. arch/x86/kernel/apic/x2apic_uv_x.c

  Assignment operand changed.

		else if (!strcmp(oem_table_id, "UVH")) {
<<<<<<< HEAD
			__this_cpu_write(x2apic_extra_bits,
				nodeid << (uvh_apicid.s.pnode_shift - 1));
=======
			__get_cpu_var(x2apic_extra_bits) =
				pnodeid << uvh_apicid.s.pnode_shift;
>>>>>>> 01539ba2a706ab7d35fc0667dff919ade7f87d63
			uv_system_type = UV_NON_UNIQUE_APIC;

  RESOLUTION

		else if (!strcmp(oem_table_id, "UVH")) {
			__this_cpu_write(x2apic_extra_bits,
					 pnodeid << uvh_apicid.s.pnode_shift);
			uv_system_type = UV_NON_UNIQUE_APIC;

3. arch/x86/kernel/process.c

  Context conflict.

		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
<<<<<<< HEAD
		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
=======
		trace_cpu_idle(1, smp_processor_id());
		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
>>>>>>> 01539ba2a706ab7d35fc0667dff919ade7f87d63
			clflush((void *)&current_thread_info()->flags);

  RESOLUTION

		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
		trace_cpu_idle(1, smp_processor_id());
		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
			clflush((void *)&current_thread_info()->flags);


Christoph Lameter (24):
      percpucounter: Optimize __percpu_counter_add a bit through the use of this_cpu() options.
      vmstat: Optimize zone counter modifications through the use of this cpu operations
      drivers: Replace __get_cpu_var with __this_cpu_read if not used for an address.
      kprobes: Use this_cpu_ops
      fakekey: Simplify speakup_fake_key_pressed through this_cpu_ops
      fs: Use this_cpu_xx operations in buffer.c
      xen: Use this_cpu_ops
      core: Replace __get_cpu_var with __this_cpu_read if not used for an address.
      percpu: Generic support for this_cpu_add, sub, dec, inc_return
      x86: Support for this_cpu_add, sub, dec, inc_return
      vmstat: Use this_cpu_inc_return for vm statistics
      highmem: Use this_cpu_xx_return() operations
      fs: Use this_cpu_inc_return in buffer.c
      random: Use this_cpu_inc_return
      taskstats: Use this_cpu_ops
      xen: Use this_cpu_inc_return
      connector: Use this_cpu operations
      percpu: Generic this_cpu_cmpxchg() and this_cpu_xchg support
      x86: this_cpu_cmpxchg and this_cpu_xchg operations
      cpuops: Use cmpxchg for xchg to avoid lock semantics
      irq_work: Use per cpu atomics instead of regular atomics
      vmstat: User per cpu atomics to avoid interrupt disable / enable
      x86: udelay: Use this_cpu_read to avoid address calculation
      gameport: use this_cpu_read instead of lookup

Jesper Juhl (1):
      percpu: zero memory more efficiently in mm/percpu.c::pcpu_mem_alloc()

Tejun Heo (7):
      MAINTAINERS: Add percpu allocator entry
      Merge branch 'this_cpu_ops' into for-2.6.38
      percpu,x86: relocate this_cpu_add_return() and friends
      Merge branch 'this_cpu_ops' into for-2.6.38
      x86: Use this_cpu_ops to optimize code
      x86: Replace uses of current_cpu_data with this_cpu ops
      x86: Use this_cpu_inc_return for nmi counter

 MAINTAINERS                               |   10 ++
 arch/x86/Kconfig.cpu                      |    3 +
 arch/x86/include/asm/debugreg.h           |    2 +-
 arch/x86/include/asm/percpu.h             |  158 ++++++++++++++++++++++-
 arch/x86/include/asm/processor.h          |    3 +-
 arch/x86/kernel/apic/apic.c               |    2 +-
 arch/x86/kernel/apic/io_apic.c            |    4 +-
 arch/x86/kernel/apic/nmi.c                |   27 ++--
 arch/x86/kernel/apic/x2apic_uv_x.c        |    8 +-
 arch/x86/kernel/cpu/amd.c                 |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |   20 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |    2 +-
 arch/x86/kernel/cpu/perf_event.c          |   27 ++---
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 +-
 arch/x86/kernel/ftrace.c                  |    6 +-
 arch/x86/kernel/hw_breakpoint.c           |   12 +-
 arch/x86/kernel/irq.c                     |    6 +-
 arch/x86/kernel/irq_32.c                  |    4 +-
 arch/x86/kernel/kprobes.c                 |   14 +-
 arch/x86/kernel/process.c                 |    4 +-
 arch/x86/kernel/smpboot.c                 |   14 +-
 arch/x86/kernel/tsc.c                     |    2 +-
 arch/x86/kvm/x86.c                        |    8 +-
 arch/x86/lib/delay.c                      |    2 +-
 arch/x86/oprofile/nmi_int.c               |    2 +-
 arch/x86/oprofile/op_model_ppro.c         |    8 +-
 arch/x86/xen/enlighten.c                  |    4 +-
 arch/x86/xen/multicalls.h                 |    2 +-
 arch/x86/xen/spinlock.c                   |    8 +-
 arch/x86/xen/time.c                       |    8 +-
 drivers/acpi/processor_idle.c             |    6 +-
 drivers/char/random.c                     |    2 +-
 drivers/connector/cn_proc.c               |    5 +-
 drivers/cpuidle/cpuidle.c                 |    2 +-
 drivers/input/gameport/gameport.c         |    2 +-
 drivers/s390/cio/cio.c                    |    2 +-
 drivers/staging/lirc/lirc_serial.c        |    4 +-
 drivers/staging/speakup/fakekey.c         |   11 +-
 drivers/xen/events.c                      |   10 +-
 fs/buffer.c                               |   37 +++---
 include/asm-generic/irq_regs.h            |    8 +-
 include/linux/elevator.h                  |   12 +--
 include/linux/highmem.h                   |   13 +-
 include/linux/kernel_stat.h               |    2 +-
 include/linux/kprobes.h                   |    4 +-
 include/linux/percpu.h                    |  205 ++++++++++++++++++++++++++++-
 kernel/exit.c                             |    2 +-
 kernel/fork.c                             |    2 +-
 kernel/hrtimer.c                          |    2 +-
 kernel/irq_work.c                         |   18 ++--
 kernel/kprobes.c                          |    8 +-
 kernel/printk.c                           |    4 +-
 kernel/rcutree.c                          |    4 +-
 kernel/softirq.c                          |   42 +++---
 kernel/taskstats.c                        |    5 +-
 kernel/time/tick-common.c                 |    2 +-
 kernel/time/tick-oneshot.c                |    4 +-
 kernel/watchdog.c                         |   36 +++---
 lib/percpu_counter.c                      |    8 +-
 mm/percpu.c                               |    8 +-
 mm/slab.c                                 |    6 +-
 mm/vmstat.c                               |  149 ++++++++++++++++-----
 64 files changed, 718 insertions(+), 291 deletions(-)
