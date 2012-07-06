Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298Ab2GFVQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:16:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60820 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab2GFVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:37 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/36] AArch64 Linux kernel port
Date: Fri,  6 Jul 2012 22:05:41 +0100
Message-Id: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 06 Jul 2012 21:07:28.0704 (UTC) FILETIME=[59CA1400:01CD5BBB]
X-MC-Unique: 112070622063402401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LGr3W005501

This set of patches implements the core Linux support for the AArch64
(64-bit ARM) architecture.


ARM introduced AArch64 as part of the ARMv8 architecture and consists of
a substantially revised exception model (with 4 exception levels: EL0 -
user, EL1 - kernel, EL2 - hypervisor, EL3 - secure monitor), new A64
instruction set based on larger register file, new FP/SIMD instructions.
The new ABI is LP64 and takes advantage of the larger register file and
mandates FP.

AArch64 documentation currently available (publicly, though
click-through agreement required):

- Instruction Set Overview:
http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html

- ABI (PCS, ELF, DWARF, C++):
http://infocenter.arm.com/help/topic/com.arm.doc.ihi0059a/index.html


The AArch64 Linux port follows the guidance for new architecture ports
using generic headers (including unistd.h) and as much generic code as
possible (some library functions may be later optimised, based on
benchmarking results).

There is no hardware platform available at this point. From a kernel
perspective, the aim is to minimise (or even completely remove) the
platform code from the architecture specific directory. FDT is currently
mandated and there are ongoing discussions for ACPI support.

In terms of MMU, it currently supports 39-bit address space for user and
kernel (each) with 3-level page table and 4KB pages or 2-level page
table and 64KB pages (see Documentation/aarch64/memory.txt). The virtual
address space can be extended to 48-bit.

Compat (32-bit) user applications (ARM EABI only) are supported with the
4KB page configuration. There is no interworking between AArch32 and
AArch64 code (the architecture requires an exception entry/exit to
change the mode).

Linux Test Project (LTP) and LAMP stack have been used to test and
validate this code against ARM simulation model throughout the
development. Compilation requires a new aarch64-none-linux-gnu-
toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).


These patches are also available on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream


Regards,

Catalin


Catalin Marinas (25):
  atomic64_test: Simplify the #ifdef for atomic64_dec_if_positive()
    test
  fs: Build sys_stat64() and friends if __ARCH_WANT_COMPAT_STAT64
  fdt: Add generic dt_memblock_reserve() function
  AArch64: Assembly macros and definitions
  AArch64: Kernel booting and initialisation
  AArch64: Exception handling
  AArch64: MMU definitions
  AArch64: MMU initialisation
  AArch64: MMU fault handling and page table management
  AArch64: Process management
  AArch64: CPU support
  AArch64: Cache maintenance routines
  AArch64: TLB maintenance functionality
  AArch64: Atomic operations
  AArch64: Device specific operations
  AArch64: DMA mapping API
  AArch64: SMP support
  AArch64: ELF definitions
  AArch64: System calls handling
  AArch64: Signal handling support
  AArch64: User access library functions
  AArch64: Floating point and SIMD
  AArch64: Miscellaneous header files
  AArch64: Build infrastructure
  AArch64: MAINTAINERS update

Marc Zyngier (3):
  AArch64: IRQ handling
  AArch64: Miscellaneous library functions
  AArch64: Generic timers support

Will Deacon (8):
  ipc: Add COMPAT_SHMLBA support
  ipc: allow compat IPC version field parsing if
    !ARCH_WANT_OLD_COMPAT_IPC
  ipc: compat: use signed size_t types for msgsnd and msgrcv
  AArch64: VDSO support
  AArch64: 32-bit (compat) applications support
  AArch64: Debugging support
  AArch64: Performance counters support
  AArch64: Loadable modules

 Documentation/aarch64/booting.txt               |  139 +++
 Documentation/aarch64/memory.txt                |   69 ++
 MAINTAINERS                                     |    6 +
 arch/aarch64/Kconfig                            |  263 +++++
 arch/aarch64/Kconfig.debug                      |   44 +
 arch/aarch64/Makefile                           |   71 ++
 arch/aarch64/boot/.gitignore                    |    2 +
 arch/aarch64/boot/Makefile                      |   38 +
 arch/aarch64/boot/install.sh                    |   52 +
 arch/aarch64/include/asm/Kbuild                 |   50 +
 arch/aarch64/include/asm/asm-offsets.h          |    1 +
 arch/aarch64/include/asm/assembler.h            |  143 +++
 arch/aarch64/include/asm/atomic.h               |  307 +++++
 arch/aarch64/include/asm/auxvec.h               |   23 +
 arch/aarch64/include/asm/barrier.h              |   53 +
 arch/aarch64/include/asm/bitops.h               |   75 ++
 arch/aarch64/include/asm/bitsperlong.h          |   24 +
 arch/aarch64/include/asm/byteorder.h            |   22 +
 arch/aarch64/include/asm/cache.h                |   33 +
 arch/aarch64/include/asm/cacheflush.h           |  210 ++++
 arch/aarch64/include/asm/cachetype.h            |   49 +
 arch/aarch64/include/asm/cmpxchg.h              |  181 +++
 arch/aarch64/include/asm/compat.h               |  233 ++++
 arch/aarch64/include/asm/compiler.h             |   31 +
 arch/aarch64/include/asm/cputype.h              |   50 +
 arch/aarch64/include/asm/debug-monitors.h       |   89 ++
 arch/aarch64/include/asm/device.h               |   27 +
 arch/aarch64/include/asm/dma-mapping.h          |  134 +++
 arch/aarch64/include/asm/elf.h                  |  177 +++
 arch/aarch64/include/asm/exception.h            |   24 +
 arch/aarch64/include/asm/exec.h                 |   24 +
 arch/aarch64/include/asm/fb.h                   |   35 +
 arch/aarch64/include/asm/fcntl.h                |   30 +
 arch/aarch64/include/asm/fpsimd.h               |   65 ++
 arch/aarch64/include/asm/futex.h                |  135 +++
 arch/aarch64/include/asm/hardirq.h              |   53 +
 arch/aarch64/include/asm/hw_breakpoint.h        |  138 +++
 arch/aarch64/include/asm/hwcap.h                |   58 +
 arch/aarch64/include/asm/io.h                   |  260 +++++
 arch/aarch64/include/asm/irq.h                  |    8 +
 arch/aarch64/include/asm/irqflags.h             |   92 ++
 arch/aarch64/include/asm/memblock.h             |   24 +
 arch/aarch64/include/asm/memory.h               |  145 +++
 arch/aarch64/include/asm/mmu.h                  |   28 +
 arch/aarch64/include/asm/mmu_context.h          |  153 +++
 arch/aarch64/include/asm/module.h               |   24 +
 arch/aarch64/include/asm/mutex.h                |  132 +++
 arch/aarch64/include/asm/page.h                 |   68 ++
 arch/aarch64/include/asm/param.h                |   24 +
 arch/aarch64/include/asm/perf_event.h           |   23 +
 arch/aarch64/include/asm/pgalloc.h              |  114 ++
 arch/aarch64/include/asm/pgtable-2level-hwdef.h |   44 +
 arch/aarch64/include/asm/pgtable-2level-types.h |   61 +
 arch/aarch64/include/asm/pgtable-3level-hwdef.h |   51 +
 arch/aarch64/include/asm/pgtable-3level-types.h |   67 ++
 arch/aarch64/include/asm/pgtable-hwdef.h        |   95 ++
 arch/aarch64/include/asm/pgtable.h              |  329 ++++++
 arch/aarch64/include/asm/pmu.h                  |   83 ++
 arch/aarch64/include/asm/proc-fns.h             |   52 +
 arch/aarch64/include/asm/processor.h            |  175 +++
 arch/aarch64/include/asm/procinfo.h             |   45 +
 arch/aarch64/include/asm/prom.h                 |    1 +
 arch/aarch64/include/asm/ptrace.h               |  207 ++++
 arch/aarch64/include/asm/setup.h                |   58 +
 arch/aarch64/include/asm/shmparam.h             |   29 +
 arch/aarch64/include/asm/sigcontext.h           |   70 ++
 arch/aarch64/include/asm/siginfo.h              |   24 +
 arch/aarch64/include/asm/signal.h               |   25 +
 arch/aarch64/include/asm/signal32.h             |   55 +
 arch/aarch64/include/asm/smp.h                  |   70 ++
 arch/aarch64/include/asm/sparsemem.h            |   25 +
 arch/aarch64/include/asm/spinlock.h             |  200 ++++
 arch/aarch64/include/asm/spinlock_types.h       |   39 +
 arch/aarch64/include/asm/stacktrace.h           |   30 +
 arch/aarch64/include/asm/stat.h                 |   64 ++
 arch/aarch64/include/asm/statfs.h               |   24 +
 arch/aarch64/include/asm/syscall.h              |  102 ++
 arch/aarch64/include/asm/syscalls.h             |   41 +
 arch/aarch64/include/asm/system_misc.h          |   59 +
 arch/aarch64/include/asm/thread_info.h          |  125 ++
 arch/aarch64/include/asm/timex.h                |   33 +
 arch/aarch64/include/asm/tlb.h                  |  191 ++++
 arch/aarch64/include/asm/tlbflush.h             |  124 ++
 arch/aarch64/include/asm/traps.h                |   31 +
 arch/aarch64/include/asm/uaccess.h              |  378 +++++++
 arch/aarch64/include/asm/ucontext.h             |   31 +
 arch/aarch64/include/asm/unistd.h               |   28 +
 arch/aarch64/include/asm/unistd32.h             |  759 +++++++++++++
 arch/aarch64/include/asm/vdso.h                 |   42 +
 arch/aarch64/include/asm/vdso_datapage.h        |   44 +
 arch/aarch64/kernel/.gitignore                  |    1 +
 arch/aarch64/kernel/Makefile                    |   27 +
 arch/aarch64/kernel/aarch64ksyms.c              |   56 +
 arch/aarch64/kernel/asm-offsets.c               |  109 ++
 arch/aarch64/kernel/debug-monitors.c            |  289 +++++
 arch/aarch64/kernel/elf.c                       |   42 +
 arch/aarch64/kernel/entry-fpsimd.S              |   81 ++
 arch/aarch64/kernel/entry.S                     |  696 ++++++++++++
 arch/aarch64/kernel/fpsimd.c                    |  107 ++
 arch/aarch64/kernel/head.S                      |  555 +++++++++
 arch/aarch64/kernel/hw_breakpoint.c             |  881 +++++++++++++++
 arch/aarch64/kernel/io.c                        |   65 ++
 arch/aarch64/kernel/irq.c                       |   85 ++
 arch/aarch64/kernel/kuser32.S                   |   78 ++
 arch/aarch64/kernel/module.c                    |  457 ++++++++
 arch/aarch64/kernel/perf_event.c                | 1369 +++++++++++++++++++++++
 arch/aarch64/kernel/process.c                   |  417 +++++++
 arch/aarch64/kernel/ptrace.c                    |  835 ++++++++++++++
 arch/aarch64/kernel/setup.c                     |  419 +++++++
 arch/aarch64/kernel/signal.c                    |  432 +++++++
 arch/aarch64/kernel/signal32.c                  |  868 ++++++++++++++
 arch/aarch64/kernel/smp.c                       |  471 ++++++++
 arch/aarch64/kernel/stacktrace.c                |  128 +++
 arch/aarch64/kernel/sys.c                       |  139 +++
 arch/aarch64/kernel/sys32.S                     |  284 +++++
 arch/aarch64/kernel/sys_compat.c                |  178 +++
 arch/aarch64/kernel/time.c                      |   66 ++
 arch/aarch64/kernel/traps.c                     |  371 ++++++
 arch/aarch64/kernel/vdso.c                      |  262 +++++
 arch/aarch64/kernel/vdso/.gitignore             |    2 +
 arch/aarch64/kernel/vdso/Makefile               |   63 +
 arch/aarch64/kernel/vdso/gen_vdso_offsets.sh    |   15 +
 arch/aarch64/kernel/vdso/gettimeofday.S         |  243 ++++
 arch/aarch64/kernel/vdso/note.S                 |   29 +
 arch/aarch64/kernel/vdso/sigreturn.S            |   38 +
 arch/aarch64/kernel/vdso/vdso.S                 |   34 +
 arch/aarch64/kernel/vdso/vdso.lds.S             |  101 ++
 arch/aarch64/kernel/vmlinux.lds.S               |  146 +++
 arch/aarch64/lib/Makefile                       |    5 +
 arch/aarch64/lib/bitops.c                       |   27 +
 arch/aarch64/lib/clear_page.S                   |   40 +
 arch/aarch64/lib/clear_user.S                   |   59 +
 arch/aarch64/lib/copy_from_user.S               |   67 ++
 arch/aarch64/lib/copy_in_user.S                 |   64 ++
 arch/aarch64/lib/copy_page.S                    |   47 +
 arch/aarch64/lib/copy_to_user.S                 |   62 +
 arch/aarch64/lib/delay.c                        |   56 +
 arch/aarch64/lib/getuser.S                      |   76 ++
 arch/aarch64/lib/putuser.S                      |   74 ++
 arch/aarch64/lib/strncpy_from_user.S            |   51 +
 arch/aarch64/lib/strnlen_user.S                 |   48 +
 arch/aarch64/mm/Kconfig                         |    5 +
 arch/aarch64/mm/Makefile                        |    6 +
 arch/aarch64/mm/cache.S                         |  280 +++++
 arch/aarch64/mm/context.c                       |  160 +++
 arch/aarch64/mm/copypage.c                      |   35 +
 arch/aarch64/mm/dma-mapping.c                   |  209 ++++
 arch/aarch64/mm/extable.c                       |   17 +
 arch/aarch64/mm/fault.c                         |  537 +++++++++
 arch/aarch64/mm/flush.c                         |  133 +++
 arch/aarch64/mm/init.c                          |  575 ++++++++++
 arch/aarch64/mm/ioremap.c                       |  102 ++
 arch/aarch64/mm/mm.h                            |   15 +
 arch/aarch64/mm/mmap.c                          |  145 +++
 arch/aarch64/mm/mmu.c                           |  464 ++++++++
 arch/aarch64/mm/pgd.c                           |   50 +
 arch/aarch64/mm/proc-macros.S                   |   56 +
 arch/aarch64/mm/proc-syms.c                     |   32 +
 arch/aarch64/mm/proc.S                          |  194 ++++
 arch/aarch64/mm/tlb.S                           |   72 ++
 arch/arm/include/asm/atomic.h                   |    1 +
 arch/mips/include/asm/atomic.h                  |    1 +
 arch/powerpc/include/asm/atomic.h               |    1 +
 arch/s390/include/asm/atomic.h                  |    1 +
 arch/sparc/kernel/sys_sparc_64.c                |    2 +-
 arch/x86/include/asm/atomic64_32.h              |    1 +
 arch/x86/include/asm/atomic64_64.h              |    1 +
 arch/xtensa/kernel/syscall.c                    |    2 +-
 drivers/clocksource/Kconfig                     |    5 +
 drivers/clocksource/Makefile                    |    3 +-
 drivers/clocksource/arm_generic.c               |  310 +++++
 drivers/of/fdt.c                                |   28 +
 fs/stat.c                                       |    4 +-
 include/clocksource/arm_generic.h               |   22 +
 include/linux/compat.h                          |    5 +-
 include/linux/of_fdt.h                          |    1 +
 include/linux/shm.h                             |    6 +-
 init/Kconfig                                    |    3 +-
 ipc/compat.c                                    |   18 +-
 ipc/shm.c                                       |    9 +-
 ipc/syscall.c                                   |    2 +-
 lib/Kconfig.debug                               |    6 +-
 lib/atomic64_test.c                             |    3 +-
 tools/perf/perf.h                               |    6 +
 184 files changed, 22781 insertions(+), 26 deletions(-)

