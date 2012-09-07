Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2IGQ1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:27:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34127 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2IGQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:51 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 00/31] AArch64 Linux kernel port
Date: Fri,  7 Sep 2012 17:26:35 +0100
Message-Id: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 07 Sep 2012 16:27:47.0363 (UTC) FILETIME=[B75AE730:01CD8D15]
X-MC-Unique: 112090717274904301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GSGFw008333

This is the 3rd version of patches implementing Linux kernel support for
the 64-bit ARM architecture. Most of the review comments for the
previous release have been implemented. There are a few left (like
generic timer dts specification) but the main goal was to freeze the
user ABI.

The Linux kernel patches are available on this tree:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream

Main changes since the previous version:
- ptrace interface now using regsets for TLS and hardware debug
  registers.
- sys_personality fixes. PER_LINUX is the default for all tasks (32 or
  64-bit) and there is no compat_sys_personality defined.
- Kconfig clean-up (unused symbols, AARCH32_EMULATION removed in favour
  of COMPAT).
- Clean-up of the __cpuc_* function prefixes.
- CPU information table implemented in C rather than assembly.
- __bad_* function calls replaced with BUILD_BUG.
- Inline get_user/put_user (code cleaner, slightly bigger kernel Image).
- DMA API implementation simplified, defaulting to swiotlb. It will be
  extended as hardware becomes available.
- Arch-specific code in the generic timer patch moved to arch/arm64/.
- Comment fixes and clarifications.


Background to the 64-bit ARM architecture:

ARM introduced AArch64 as part of the ARMv8 architecture and consists of
a substantially revised exception model (with 4 exception levels: EL0 -
user, EL1 - kernel, EL2 - hypervisor, EL3 - secure monitor), new A64
instruction set based on larger register file, new FP/SIMD instructions.
The new ABI is LP64 and takes advantage of the larger register file. It
also mandates FP.

AArch64 documentation currently available (publicly, though
click-through agreement required):

- Instruction Set Overview:
http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html

- ABI (PCS, ELF, DWARF, C++):
http://infocenter.arm.com/help/topic/com.arm.doc.ihi0059a/index.html


Regards,

Catalin


Catalin Marinas (23):
  arm64: Assembly macros and definitions
  arm64: Kernel booting and initialisation
  arm64: Exception handling
  arm64: MMU definitions
  arm64: MMU initialisation
  arm64: MMU fault handling and page table management
  arm64: Process management
  arm64: CPU support
  arm64: Cache maintenance routines
  arm64: TLB maintenance functionality
  arm64: Atomic operations
  arm64: Device specific operations
  arm64: DMA mapping API
  arm64: SMP support
  arm64: ELF definitions
  arm64: System calls handling
  arm64: Signal handling support
  arm64: User access library functions
  arm64: Floating point and SIMD
  arm64: Add support for /proc/sys/debug/exception-trace
  arm64: Miscellaneous header files
  arm64: Build infrastructure
  arm64: MAINTAINERS update

Marc Zyngier (3):
  arm64: IRQ handling
  arm64: Miscellaneous library functions
  arm64: Generic timers support

Will Deacon (5):
  arm64: VDSO support
  arm64: 32-bit (compat) applications support
  arm64: Debugging support
  arm64: Performance counters support
  arm64: Loadable modules

 Documentation/arm64/booting.txt               |  152 +++
 Documentation/arm64/memory.txt                |   69 ++
 MAINTAINERS                                   |    6 +
 arch/arm64/Kconfig                            |  222 ++++
 arch/arm64/Kconfig.debug                      |   27 +
 arch/arm64/Makefile                           |   71 ++
 arch/arm64/boot/.gitignore                    |    2 +
 arch/arm64/boot/Makefile                      |   36 +
 arch/arm64/boot/install.sh                    |   46 +
 arch/arm64/configs/defconfig                  |   85 ++
 arch/arm64/include/asm/Kbuild                 |   51 +
 arch/arm64/include/asm/arm_generic.h          |  100 ++
 arch/arm64/include/asm/asm-offsets.h          |    1 +
 arch/arm64/include/asm/assembler.h            |  109 ++
 arch/arm64/include/asm/atomic.h               |  305 ++++++
 arch/arm64/include/asm/auxvec.h               |   22 +
 arch/arm64/include/asm/barrier.h              |   52 +
 arch/arm64/include/asm/bitops.h               |   74 ++
 arch/arm64/include/asm/bitsperlong.h          |   23 +
 arch/arm64/include/asm/byteorder.h            |   21 +
 arch/arm64/include/asm/cache.h                |   32 +
 arch/arm64/include/asm/cacheflush.h           |  168 +++
 arch/arm64/include/asm/cachetype.h            |   48 +
 arch/arm64/include/asm/cmpxchg.h              |  173 ++++
 arch/arm64/include/asm/compat.h               |  242 +++++
 arch/arm64/include/asm/compiler.h             |   30 +
 arch/arm64/include/asm/cputable.h             |   30 +
 arch/arm64/include/asm/cputype.h              |   49 +
 arch/arm64/include/asm/debug-monitors.h       |   88 ++
 arch/arm64/include/asm/device.h               |   26 +
 arch/arm64/include/asm/dma-mapping.h          |  124 +++
 arch/arm64/include/asm/elf.h                  |  179 ++++
 arch/arm64/include/asm/exception.h            |   23 +
 arch/arm64/include/asm/exec.h                 |   23 +
 arch/arm64/include/asm/fb.h                   |   34 +
 arch/arm64/include/asm/fcntl.h                |   29 +
 arch/arm64/include/asm/fpsimd.h               |   64 ++
 arch/arm64/include/asm/futex.h                |  136 +++
 arch/arm64/include/asm/hardirq.h              |   52 +
 arch/arm64/include/asm/hw_breakpoint.h        |  137 +++
 arch/arm64/include/asm/hwcap.h                |   53 +
 arch/arm64/include/asm/io.h                   |  263 +++++
 arch/arm64/include/asm/irq.h                  |    8 +
 arch/arm64/include/asm/irqflags.h             |   91 ++
 arch/arm64/include/asm/memblock.h             |   21 +
 arch/arm64/include/asm/memory.h               |  144 +++
 arch/arm64/include/asm/mmu.h                  |   27 +
 arch/arm64/include/asm/mmu_context.h          |  152 +++
 arch/arm64/include/asm/module.h               |   23 +
 arch/arm64/include/asm/page.h                 |   67 ++
 arch/arm64/include/asm/param.h                |   23 +
 arch/arm64/include/asm/perf_event.h           |   22 +
 arch/arm64/include/asm/pgalloc.h              |  113 ++
 arch/arm64/include/asm/pgtable-2level-hwdef.h |   43 +
 arch/arm64/include/asm/pgtable-2level-types.h |   60 ++
 arch/arm64/include/asm/pgtable-3level-hwdef.h |   50 +
 arch/arm64/include/asm/pgtable-3level-types.h |   66 ++
 arch/arm64/include/asm/pgtable-hwdef.h        |   94 ++
 arch/arm64/include/asm/pgtable.h              |  328 ++++++
 arch/arm64/include/asm/pmu.h                  |   82 ++
 arch/arm64/include/asm/proc-fns.h             |   51 +
 arch/arm64/include/asm/processor.h            |  175 ++++
 arch/arm64/include/asm/prom.h                 |    1 +
 arch/arm64/include/asm/ptrace.h               |  212 ++++
 arch/arm64/include/asm/setup.h                |   26 +
 arch/arm64/include/asm/shmparam.h             |   28 +
 arch/arm64/include/asm/sigcontext.h           |   69 ++
 arch/arm64/include/asm/siginfo.h              |   23 +
 arch/arm64/include/asm/signal.h               |   24 +
 arch/arm64/include/asm/signal32.h             |   53 +
 arch/arm64/include/asm/smp.h                  |   69 ++
 arch/arm64/include/asm/sparsemem.h            |   24 +
 arch/arm64/include/asm/spinlock.h             |  202 ++++
 arch/arm64/include/asm/spinlock_types.h       |   38 +
 arch/arm64/include/asm/stacktrace.h           |   29 +
 arch/arm64/include/asm/stat.h                 |   62 ++
 arch/arm64/include/asm/statfs.h               |   23 +
 arch/arm64/include/asm/syscall.h              |  101 ++
 arch/arm64/include/asm/syscalls.h             |   40 +
 arch/arm64/include/asm/system_misc.h          |   54 +
 arch/arm64/include/asm/thread_info.h          |  127 +++
 arch/arm64/include/asm/timex.h                |   29 +
 arch/arm64/include/asm/tlb.h                  |  190 ++++
 arch/arm64/include/asm/tlbflush.h             |  122 +++
 arch/arm64/include/asm/traps.h                |   30 +
 arch/arm64/include/asm/uaccess.h              |  297 ++++++
 arch/arm64/include/asm/ucontext.h             |   30 +
 arch/arm64/include/asm/unistd.h               |   27 +
 arch/arm64/include/asm/unistd32.h             |  758 ++++++++++++++
 arch/arm64/include/asm/vdso.h                 |   41 +
 arch/arm64/include/asm/vdso_datapage.h        |   43 +
 arch/arm64/kernel/.gitignore                  |    1 +
 arch/arm64/kernel/Makefile                    |   27 +
 arch/arm64/kernel/arm64ksyms.c                |   46 +
 arch/arm64/kernel/asm-offsets.c               |  108 ++
 arch/arm64/kernel/cputable.c                  |   33 +
 arch/arm64/kernel/debug-monitors.c            |  288 ++++++
 arch/arm64/kernel/entry-fpsimd.S              |   80 ++
 arch/arm64/kernel/entry.S                     |  695 +++++++++++++
 arch/arm64/kernel/fpsimd.c                    |  106 ++
 arch/arm64/kernel/head.S                      |  510 +++++++++
 arch/arm64/kernel/hw_breakpoint.c             |  880 ++++++++++++++++
 arch/arm64/kernel/io.c                        |   64 ++
 arch/arm64/kernel/irq.c                       |   84 ++
 arch/arm64/kernel/kuser32.S                   |   77 ++
 arch/arm64/kernel/module.c                    |  456 ++++++++
 arch/arm64/kernel/perf_event.c                | 1368 +++++++++++++++++++++++++
 arch/arm64/kernel/process.c                   |  412 ++++++++
 arch/arm64/kernel/ptrace.c                    | 1126 ++++++++++++++++++++
 arch/arm64/kernel/setup.c                     |  351 +++++++
 arch/arm64/kernel/signal.c                    |  437 ++++++++
 arch/arm64/kernel/signal32.c                  |  876 ++++++++++++++++
 arch/arm64/kernel/smp.c                       |  469 +++++++++
 arch/arm64/kernel/stacktrace.c                |  127 +++
 arch/arm64/kernel/sys.c                       |  138 +++
 arch/arm64/kernel/sys32.S                     |  282 +++++
 arch/arm64/kernel/sys_compat.c                |  164 +++
 arch/arm64/kernel/time.c                      |   65 ++
 arch/arm64/kernel/traps.c                     |  348 +++++++
 arch/arm64/kernel/vdso.c                      |  261 +++++
 arch/arm64/kernel/vdso/.gitignore             |    2 +
 arch/arm64/kernel/vdso/Makefile               |   63 ++
 arch/arm64/kernel/vdso/gen_vdso_offsets.sh    |   15 +
 arch/arm64/kernel/vdso/gettimeofday.S         |  242 +++++
 arch/arm64/kernel/vdso/note.S                 |   28 +
 arch/arm64/kernel/vdso/sigreturn.S            |   37 +
 arch/arm64/kernel/vdso/vdso.S                 |   33 +
 arch/arm64/kernel/vdso/vdso.lds.S             |  100 ++
 arch/arm64/kernel/vmlinux.lds.S               |  126 +++
 arch/arm64/lib/Makefile                       |    4 +
 arch/arm64/lib/bitops.c                       |   25 +
 arch/arm64/lib/clear_page.S                   |   39 +
 arch/arm64/lib/clear_user.S                   |   58 ++
 arch/arm64/lib/copy_from_user.S               |   66 ++
 arch/arm64/lib/copy_in_user.S                 |   63 ++
 arch/arm64/lib/copy_page.S                    |   46 +
 arch/arm64/lib/copy_to_user.S                 |   61 ++
 arch/arm64/lib/delay.c                        |   55 +
 arch/arm64/lib/strncpy_from_user.S            |   50 +
 arch/arm64/lib/strnlen_user.S                 |   47 +
 arch/arm64/mm/Makefile                        |    4 +
 arch/arm64/mm/cache.S                         |  251 +++++
 arch/arm64/mm/context.c                       |  159 +++
 arch/arm64/mm/copypage.c                      |   34 +
 arch/arm64/mm/dma-mapping.c                   |   79 ++
 arch/arm64/mm/extable.c                       |   17 +
 arch/arm64/mm/fault.c                         |  534 ++++++++++
 arch/arm64/mm/flush.c                         |  138 +++
 arch/arm64/mm/init.c                          |  416 ++++++++
 arch/arm64/mm/ioremap.c                       |   84 ++
 arch/arm64/mm/mm.h                            |    2 +
 arch/arm64/mm/mmap.c                          |  144 +++
 arch/arm64/mm/mmu.c                           |  395 +++++++
 arch/arm64/mm/pgd.c                           |   54 +
 arch/arm64/mm/proc-macros.S                   |   55 +
 arch/arm64/mm/proc.S                          |  181 ++++
 arch/arm64/mm/tlb.S                           |   71 ++
 drivers/clocksource/Kconfig                   |    5 +
 drivers/clocksource/Makefile                  |    1 +
 drivers/clocksource/arm_generic.c             |  232 +++++
 include/clocksource/arm_generic.h             |   21 +
 include/linux/elf.h                           |    3 +
 init/Kconfig                                  |    3 +-
 kernel/sysctl.c                               |    2 +-
 lib/Kconfig.debug                             |    6 +-
 tools/perf/perf.h                             |    6 +

