Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2HNRxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:53:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54911 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2HNRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:53:04 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 00/31] AArch64 Linux kernel port
Date: Tue, 14 Aug 2012 18:52:01 +0100
Message-Id: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 14 Aug 2012 17:54:45.0291 (UTC) FILETIME=[E39187B0:01CD7A45]
X-MC-Unique: 112081418530207801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q7EI3RT0017430

This is the 2nd version of the set of patches implementing Linux kernel
support for the 64-bit ARM architecture (AArch64). Thanks to all who
provided feedback on the previous version.

The Linux kernel patches are available on this tree:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream

The "master" branch in the above repository tracks the development
history.

Main changes from the previous version (for the full log see the
"master" branch above):

- Kernel port directory and related functions renamed to "arm64".
  "uname -m" reports "aarch64" as per the official name.
- NO_BOOTMEM enabled.
- "mem=" is now used for limiting the amount of memory rather than
  specifying the memory banks (already done via FDT).
- struct mem_type removed as static definitions are enough for
  ioremap().
- Support for ZONE_DMA32.
- Replaced "user_debug" with "/proc/sys/debug/exception-trace".
- Added a generic defconfig file.
- More clean-up (comments, code) and bug-fixes.

The generic patches were dropped from this series as they have been pushed
separately (and most of them already merged into mainline).


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

 Documentation/arm64/booting.txt               |  141 +++
 Documentation/arm64/memory.txt                |   69 ++
 MAINTAINERS                                   |    6 +
 arch/arm64/Kconfig                            |  261 +++++
 arch/arm64/Kconfig.debug                      |   27 +
 arch/arm64/Makefile                           |   71 ++
 arch/arm64/boot/.gitignore                    |    2 +
 arch/arm64/boot/Makefile                      |   38 +
 arch/arm64/boot/install.sh                    |   52 +
 arch/arm64/configs/generic_defconfig          |   85 ++
 arch/arm64/include/asm/Kbuild                 |   51 +
 arch/arm64/include/asm/asm-offsets.h          |    1 +
 arch/arm64/include/asm/assembler.h            |  109 ++
 arch/arm64/include/asm/atomic.h               |  306 ++++++
 arch/arm64/include/asm/auxvec.h               |   22 +
 arch/arm64/include/asm/barrier.h              |   52 +
 arch/arm64/include/asm/bitops.h               |   74 ++
 arch/arm64/include/asm/bitsperlong.h          |   23 +
 arch/arm64/include/asm/byteorder.h            |   21 +
 arch/arm64/include/asm/cache.h                |   32 +
 arch/arm64/include/asm/cacheflush.h           |  209 ++++
 arch/arm64/include/asm/cachetype.h            |   48 +
 arch/arm64/include/asm/cmpxchg.h              |  180 ++++
 arch/arm64/include/asm/compat.h               |  232 +++++
 arch/arm64/include/asm/compiler.h             |   30 +
 arch/arm64/include/asm/cputype.h              |   49 +
 arch/arm64/include/asm/debug-monitors.h       |   88 ++
 arch/arm64/include/asm/device.h               |   26 +
 arch/arm64/include/asm/dma-mapping.h          |  124 +++
 arch/arm64/include/asm/elf.h                  |  176 ++++
 arch/arm64/include/asm/exception.h            |   23 +
 arch/arm64/include/asm/exec.h                 |   23 +
 arch/arm64/include/asm/fb.h                   |   34 +
 arch/arm64/include/asm/fcntl.h                |   29 +
 arch/arm64/include/asm/fpsimd.h               |   64 ++
 arch/arm64/include/asm/futex.h                |  134 +++
 arch/arm64/include/asm/hardirq.h              |   52 +
 arch/arm64/include/asm/hw_breakpoint.h        |  137 +++
 arch/arm64/include/asm/hwcap.h                |   57 +
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
 arch/arm64/include/asm/processor.h            |  174 ++++
 arch/arm64/include/asm/procinfo.h             |   44 +
 arch/arm64/include/asm/prom.h                 |    1 +
 arch/arm64/include/asm/ptrace.h               |  206 ++++
 arch/arm64/include/asm/setup.h                |   26 +
 arch/arm64/include/asm/shmparam.h             |   28 +
 arch/arm64/include/asm/sigcontext.h           |   69 ++
 arch/arm64/include/asm/siginfo.h              |   23 +
 arch/arm64/include/asm/signal.h               |   24 +
 arch/arm64/include/asm/signal32.h             |   54 +
 arch/arm64/include/asm/smp.h                  |   69 ++
 arch/arm64/include/asm/sparsemem.h            |   24 +
 arch/arm64/include/asm/spinlock.h             |  199 ++++
 arch/arm64/include/asm/spinlock_types.h       |   38 +
 arch/arm64/include/asm/stacktrace.h           |   29 +
 arch/arm64/include/asm/stat.h                 |   63 ++
 arch/arm64/include/asm/statfs.h               |   23 +
 arch/arm64/include/asm/syscall.h              |  101 ++
 arch/arm64/include/asm/syscalls.h             |   40 +
 arch/arm64/include/asm/system_misc.h          |   54 +
 arch/arm64/include/asm/thread_info.h          |  124 +++
 arch/arm64/include/asm/timex.h                |   32 +
 arch/arm64/include/asm/tlb.h                  |  190 ++++
 arch/arm64/include/asm/tlbflush.h             |  123 +++
 arch/arm64/include/asm/traps.h                |   30 +
 arch/arm64/include/asm/uaccess.h              |  377 +++++++
 arch/arm64/include/asm/ucontext.h             |   30 +
 arch/arm64/include/asm/unistd.h               |   27 +
 arch/arm64/include/asm/unistd32.h             |  758 ++++++++++++++
 arch/arm64/include/asm/vdso.h                 |   41 +
 arch/arm64/include/asm/vdso_datapage.h        |   43 +
 arch/arm64/kernel/.gitignore                  |    1 +
 arch/arm64/kernel/Makefile                    |   27 +
 arch/arm64/kernel/arm64ksyms.c                |   55 +
 arch/arm64/kernel/asm-offsets.c               |  108 ++
 arch/arm64/kernel/debug-monitors.c            |  288 ++++++
 arch/arm64/kernel/elf.c                       |   41 +
 arch/arm64/kernel/entry-fpsimd.S              |   80 ++
 arch/arm64/kernel/entry.S                     |  695 +++++++++++++
 arch/arm64/kernel/fpsimd.c                    |  106 ++
 arch/arm64/kernel/head.S                      |  521 ++++++++++
 arch/arm64/kernel/hw_breakpoint.c             |  880 ++++++++++++++++
 arch/arm64/kernel/io.c                        |   64 ++
 arch/arm64/kernel/irq.c                       |   84 ++
 arch/arm64/kernel/kuser32.S                   |   77 ++
 arch/arm64/kernel/module.c                    |  456 ++++++++
 arch/arm64/kernel/perf_event.c                | 1368 +++++++++++++++++++++++++
 arch/arm64/kernel/process.c                   |  416 ++++++++
 arch/arm64/kernel/ptrace.c                    |  834 +++++++++++++++
 arch/arm64/kernel/setup.c                     |  357 +++++++
 arch/arm64/kernel/signal.c                    |  436 ++++++++
 arch/arm64/kernel/signal32.c                  |  876 ++++++++++++++++
 arch/arm64/kernel/smp.c                       |  469 +++++++++
 arch/arm64/kernel/stacktrace.c                |  127 +++
 arch/arm64/kernel/sys.c                       |  138 +++
 arch/arm64/kernel/sys32.S                     |  283 +++++
 arch/arm64/kernel/sys_compat.c                |  177 ++++
 arch/arm64/kernel/time.c                      |   65 ++
 arch/arm64/kernel/traps.c                     |  357 +++++++
 arch/arm64/kernel/vdso.c                      |  261 +++++
 arch/arm64/kernel/vdso/.gitignore             |    2 +
 arch/arm64/kernel/vdso/Makefile               |   63 ++
 arch/arm64/kernel/vdso/gen_vdso_offsets.sh    |   15 +
 arch/arm64/kernel/vdso/gettimeofday.S         |  242 +++++
 arch/arm64/kernel/vdso/note.S                 |   28 +
 arch/arm64/kernel/vdso/sigreturn.S            |   37 +
 arch/arm64/kernel/vdso/vdso.S                 |   33 +
 arch/arm64/kernel/vdso/vdso.lds.S             |  100 ++
 arch/arm64/kernel/vmlinux.lds.S               |  146 +++
 arch/arm64/lib/Makefile                       |    5 +
 arch/arm64/lib/bitops.c                       |   25 +
 arch/arm64/lib/clear_page.S                   |   39 +
 arch/arm64/lib/clear_user.S                   |   58 ++
 arch/arm64/lib/copy_from_user.S               |   66 ++
 arch/arm64/lib/copy_in_user.S                 |   63 ++
 arch/arm64/lib/copy_page.S                    |   46 +
 arch/arm64/lib/copy_to_user.S                 |   61 ++
 arch/arm64/lib/delay.c                        |   55 +
 arch/arm64/lib/getuser.S                      |   75 ++
 arch/arm64/lib/putuser.S                      |   73 ++
 arch/arm64/lib/strncpy_from_user.S            |   50 +
 arch/arm64/lib/strnlen_user.S                 |   47 +
 arch/arm64/mm/Kconfig                         |    5 +
 arch/arm64/mm/Makefile                        |    6 +
 arch/arm64/mm/cache.S                         |  279 +++++
 arch/arm64/mm/context.c                       |  159 +++
 arch/arm64/mm/copypage.c                      |   34 +
 arch/arm64/mm/dma-mapping.c                   |  208 ++++
 arch/arm64/mm/extable.c                       |   17 +
 arch/arm64/mm/fault.c                         |  534 ++++++++++
 arch/arm64/mm/flush.c                         |  132 +++
 arch/arm64/mm/init.c                          |  416 ++++++++
 arch/arm64/mm/ioremap.c                       |   84 ++
 arch/arm64/mm/mm.h                            |    2 +
 arch/arm64/mm/mmap.c                          |  144 +++
 arch/arm64/mm/mmu.c                           |  395 +++++++
 arch/arm64/mm/pgd.c                           |   49 +
 arch/arm64/mm/proc-macros.S                   |   55 +
 arch/arm64/mm/proc-syms.c                     |   31 +
 arch/arm64/mm/proc.S                          |  193 ++++
 arch/arm64/mm/tlb.S                           |   71 ++
 drivers/clocksource/Kconfig                   |    5 +
 drivers/clocksource/Makefile                  |    1 +
 drivers/clocksource/arm_generic.c             |  309 ++++++
 include/clocksource/arm_generic.h             |   21 +
 init/Kconfig                                  |    3 +-
 kernel/sysctl.c                               |    2 +-
 lib/Kconfig.debug                             |    6 +-
 tools/perf/perf.h                             |    6 +
 168 files changed, 22089 insertions(+), 4 deletions(-)

