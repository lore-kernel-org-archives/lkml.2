Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2LEQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:13 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51617 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LEQJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:11 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 00/44] Meta Linux Kernel Port
Date: Wed, 5 Dec 2012 16:08:18 +0000
Message-ID: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds core architecture support to Linux for Imagination's
Meta ATP (Meta 1) and HTP (Meta 2) processor cores. Most of the feedback
from the RFC patchset has now been addressed, although a few things
remain to be done and will be addressed in a future version of the
patchset (see below for details). All feedback is most welcome.

The patches are based on v3.7-rc8, and can also be found in the
following git tree:
  git://github.com/jahogan/metag-linux.git metag-core

Meta cores are 32-bit, hardware multithreaded, general purpose, embedded
processors which also feature a DSP instruction set, and can be found in
many digital radios. They are capable of running different operating
systems on different hardware threads, for example a digital radio might
run RTOSes for DAB decoding and audio decoding on 3 hardware threads,
and run Linux on the 4th hardware thread to manage the user interface,
networking etc. HTPs are also capable of running SMP Linux on multiple
hardware threads.

A buildroot tree containing toolchain patches can be found here (use
meta2_defconfig):
  git://github.com/img-meta/metag-buildroot.git metag-core

Freely available instruction set and architecture overview documents can
be found on the following page:
  http://www.imgtec.com/downloads.asp

---
v2:

feedback not addressed in this version (to be addressed in a future
version of the patchset):
* purer use of sparse irqs (Arnd)
* moving irq drivers into drivers/irqchip/ (Arnd)
* proper inversion of Kconfig dependency lists (Greg, Arnd)
* using generic CMDLINE Kconfig symbols (Sam Ravnborg)

other work not included:
* switch to generic kernel_{thread,execve} (will be posted separately to
  aid review)

changes based on rfc-v1 review feedback:
* moved build infrastructure patch later (Sam Ravnborg)
* various build system cleanups (Sam Ravnborg)
* split generic build changes out of main build patch (Sam Ravnborg)
* deprecate powervr DT vendor id (Rob Herring)
* ftrace now uses recordmcount.c (Steven Rostedt)
* fixed imgdafs fserrno problem (Al Viro)
* io.h changes, inline asm, removed casts, added metag_in/out (Arnd)
* remove bus_to_virt (Arnd)
* use asm-generic/syscalls.h (Arnd)
* remove superfluous metag_spinlock system call (Arnd)
* renamed packed 64bit arg syscall wrappers (Arnd)

other changes:
* rebased on v3.7-rc8
  * changes based on v3.6..v3.7-rc8 patches
  * uapi disintegration (thanks to David Howells for the assistance)
* add cmpdi2/ucmpdi2 intrinsics and clean up lib Makefile
* fix numa build
* split memory management patch into 6 separate patches to make them
  more manageable and stop them bouncing:
  * cache/tlb handling
  * memory management
  * memory handling
  * huge tlb
  * highmem
  * tcm
* split architecture definitions out of TBX into asm/metag_*.h
* merged remaining TBX header files into a single asm/tbx.h
* split TBX patch into 2 separate patches to stop them bouncing
* merge various similar Kconfig changes in generic code
* dropped sysfs drivers from this patchset (we normally have them turned
  off anyway so they're not a priority)
* renamed dafs to imgdafs
* implemented perf events
* rewrote ptrace to use nicely abstracted regsets
* removed non-standard hw_breakpoints/ptrace API
* use ptrace abstracted context structs in sigcontext
* update DA TTY to be more thread safe and use tty_ports
* switch to generic sys_execve

James Hogan (44):
  asm-generic/io.h: remove asm/cacheflush.h include
  asm-generic/unistd.h: handle symbol prefixes in cond_syscall
  Add CONFIG_HAVE_64BIT_ALIGNED_STRUCT for taskstats
  trace/ring_buffer: handle 64bit aligned structs
  Revert some of "binfmt_elf: cleanups"
  of/vendor-prefixes: add Imagination Technologies
  metag: Add MAINTAINERS entry
  metag: Headers for core arch constants
  metag: Header for core memory mapped registers
  metag: Boot
  metag; TBX header
  metag: TBX source
  metag: Cache/TLB handling
  metag: Memory management
  metag: Memory handling
  metag: Huge TLB
  metag: Highmem support
  metag: TCM support
  metag: Signal handling
  metag: Device tree
  metag: ptrace
  metag: Time keeping
  metag: Traps
  metag: IRQ handling
  metag: System Calls
  metag: Scheduling/Process management
  metag: Module support
  metag: Atomics, locks and bitops
  metag: Basic documentation
  metag: SMP support
  metag: DMA
  metag: Optimised library functions
  metag: Stack unwinding
  metag: Various other headers
  mm: define VM_GROWSUP for CONFIG_METAG
  Add metag to various Kconfig dependency lists
  metag: Build infrastructure
  metag: Perf
  metag: ftrace support
  scripts/checkstack.pl: Add metag support
  metag: OProfile
  metag: Add JTAG Debug Adapter (DA) support
  tty/metag_da: Add metag DA TTY driver
  fs: imgdafs: Add IMG DAFS filesystem for metag

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/metag/meta-intc.txt        |   92 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +-
 Documentation/kernel-parameters.txt                |    4 +
 Documentation/metag/00-INDEX                       |    2 +
 MAINTAINERS                                        |   10 +
 arch/Kconfig                                       |   16 +
 arch/metag/Kconfig                                 |  318 +++++
 arch/metag/Kconfig.debug                           |   40 +
 arch/metag/Kconfig.soc                             |   55 +
 arch/metag/Makefile                                |   89 ++
 arch/metag/boot/.gitignore                         |    4 +
 arch/metag/boot/Makefile                           |   68 +
 arch/metag/boot/dtb/Makefile                       |   17 +
 arch/metag/boot/dts/skeleton.dts                   |   10 +
 arch/metag/boot/dts/skeleton.dtsi                  |   14 +
 arch/metag/configs/meta1_defconfig                 |   42 +
 arch/metag/configs/meta2_defconfig                 |   43 +
 arch/metag/configs/meta2_smp_defconfig             |   44 +
 arch/metag/include/asm/Kbuild                      |   53 +
 arch/metag/include/asm/atomic.h                    |   53 +
 arch/metag/include/asm/atomic_lnkget.h             |  245 ++++
 arch/metag/include/asm/atomic_lock1.h              |  160 +++
 arch/metag/include/asm/barrier.h                   |   85 ++
 arch/metag/include/asm/bitops.h                    |  132 ++
 arch/metag/include/asm/bug.h                       |   12 +
 arch/metag/include/asm/cache.h                     |   23 +
 arch/metag/include/asm/cacheflush.h                |  228 ++++
 arch/metag/include/asm/cachepart.h                 |   42 +
 arch/metag/include/asm/checksum.h                  |   92 ++
 arch/metag/include/asm/clock.h                     |   51 +
 arch/metag/include/asm/cmpxchg.h                   |   65 +
 arch/metag/include/asm/cmpxchg_irq.h               |   42 +
 arch/metag/include/asm/cmpxchg_lnkget.h            |   86 ++
 arch/metag/include/asm/cmpxchg_lock1.h             |   48 +
 arch/metag/include/asm/core_reg.h                  |    7 +
 arch/metag/include/asm/cpu.h                       |   14 +
 arch/metag/include/asm/da.h                        |   43 +
 arch/metag/include/asm/delay.h                     |   29 +
 arch/metag/include/asm/div64.h                     |   12 +
 arch/metag/include/asm/dma-mapping.h               |  183 +++
 arch/metag/include/asm/elf.h                       |  128 ++
 arch/metag/include/asm/fixmap.h                    |   99 ++
 arch/metag/include/asm/ftrace.h                    |   23 +
 arch/metag/include/asm/gpio.h                      |    4 +
 arch/metag/include/asm/highmem.h                   |   62 +
 arch/metag/include/asm/hugetlb.h                   |   86 ++
 arch/metag/include/asm/hwthread.h                  |   40 +
 arch/metag/include/asm/io.h                        |  165 +++
 arch/metag/include/asm/irq.h                       |   79 ++
 arch/metag/include/asm/irq_external.h              |   33 +
 arch/metag/include/asm/irq_internal.h              |   16 +
 arch/metag/include/asm/irqflags.h                  |   97 ++
 arch/metag/include/asm/l2cache.h                   |  258 ++++
 arch/metag/include/asm/linkage.h                   |    7 +
 arch/metag/include/asm/lock.h                      |   14 +
 arch/metag/include/asm/mach/arch.h                 |   81 ++
 arch/metag/include/asm/metag_isa.h                 |   81 ++
 arch/metag/include/asm/metag_mem.h                 | 1106 +++++++++++++++
 arch/metag/include/asm/metag_regs.h                | 1180 ++++++++++++++++
 arch/metag/include/asm/mman.h                      |   11 +
 arch/metag/include/asm/mmu.h                       |   77 ++
 arch/metag/include/asm/mmu_context.h               |  113 ++
 arch/metag/include/asm/mmzone.h                    |   42 +
 arch/metag/include/asm/module.h                    |   37 +
 arch/metag/include/asm/page.h                      |  128 ++
 arch/metag/include/asm/perf_event.h                |    4 +
 arch/metag/include/asm/pgalloc.h                   |   79 ++
 arch/metag/include/asm/pgtable.h                   |  370 +++++
 arch/metag/include/asm/processor.h                 |  204 +++
 arch/metag/include/asm/prom.h                      |   23 +
 arch/metag/include/asm/ptrace.h                    |   60 +
 arch/metag/include/asm/setup.h                     |    8 +
 arch/metag/include/asm/smp.h                       |   31 +
 arch/metag/include/asm/sparsemem.h                 |   13 +
 arch/metag/include/asm/spinlock.h                  |   22 +
 arch/metag/include/asm/spinlock_lnkget.h           |  261 ++++
 arch/metag/include/asm/spinlock_lock1.h            |  184 +++
 arch/metag/include/asm/spinlock_types.h            |   20 +
 arch/metag/include/asm/stacktrace.h                |   20 +
 arch/metag/include/asm/string.h                    |   13 +
 arch/metag/include/asm/switch.h                    |   22 +
 arch/metag/include/asm/syscall.h                   |  104 ++
 arch/metag/include/asm/syscalls.h                  |   62 +
 arch/metag/include/asm/tbx.h                       | 1437 ++++++++++++++++++++
 arch/metag/include/asm/tcm.h                       |   30 +
 arch/metag/include/asm/thread_info.h               |  155 +++
 arch/metag/include/asm/tlb.h                       |   36 +
 arch/metag/include/asm/tlbflush.h                  |   77 ++
 arch/metag/include/asm/topology.h                  |   53 +
 arch/metag/include/asm/traps.h                     |   43 +
 arch/metag/include/asm/uaccess.h                   |  241 ++++
 arch/metag/include/asm/unistd.h                    |   12 +
 arch/metag/include/asm/user_gateway.h              |   44 +
 arch/metag/include/uapi/asm/Kbuild                 |   13 +
 arch/metag/include/uapi/asm/byteorder.h            |    1 +
 arch/metag/include/uapi/asm/ptrace.h               |  113 ++
 arch/metag/include/uapi/asm/resource.h             |    7 +
 arch/metag/include/uapi/asm/sigcontext.h           |   31 +
 arch/metag/include/uapi/asm/siginfo.h              |    8 +
 arch/metag/include/uapi/asm/swab.h                 |   26 +
 arch/metag/include/uapi/asm/unistd.h               |   21 +
 arch/metag/kernel/.gitignore                       |    1 +
 arch/metag/kernel/Makefile                         |   41 +
 arch/metag/kernel/asm-offsets.c                    |   14 +
 arch/metag/kernel/cachepart.c                      |  124 ++
 arch/metag/kernel/clock.c                          |   53 +
 arch/metag/kernel/core_reg.c                       |  117 ++
 arch/metag/kernel/da.c                             |   23 +
 arch/metag/kernel/devtree.c                        |  100 ++
 arch/metag/kernel/dma.c                            |  507 +++++++
 arch/metag/kernel/ftrace.c                         |  127 ++
 arch/metag/kernel/ftrace_stub.S                    |   76 +
 arch/metag/kernel/head.S                           |   57 +
 arch/metag/kernel/irq.c                            |  277 ++++
 arch/metag/kernel/irq_external.c                   |  886 ++++++++++++
 arch/metag/kernel/irq_internal.c                   |  237 ++++
 arch/metag/kernel/kick.c                           |   94 ++
 arch/metag/kernel/machines.c                       |   21 +
 arch/metag/kernel/metag_ksyms.c                    |   79 ++
 arch/metag/kernel/module.c                         |  284 ++++
 arch/metag/kernel/perf/Makefile                    |    3 +
 arch/metag/kernel/perf/perf_event.c                |  859 ++++++++++++
 arch/metag/kernel/perf/perf_event.h                |  106 ++
 arch/metag/kernel/perf_callchain.c                 |   96 ++
 arch/metag/kernel/process.c                        |  453 ++++++
 arch/metag/kernel/ptrace.c                         |  380 ++++++
 arch/metag/kernel/setup.c                          |  585 ++++++++
 arch/metag/kernel/signal.c                         |  345 +++++
 arch/metag/kernel/smp.c                            |  582 ++++++++
 arch/metag/kernel/stacktrace.c                     |  187 +++
 arch/metag/kernel/sys_metag.c                      |  198 +++
 arch/metag/kernel/tbiunexp.S                       |   22 +
 arch/metag/kernel/tcm.c                            |  151 ++
 arch/metag/kernel/time.c                           |  163 +++
 arch/metag/kernel/topology.c                       |   77 ++
 arch/metag/kernel/traps.c                          |  964 +++++++++++++
 arch/metag/kernel/user_gateway.S                   |   97 ++
 arch/metag/kernel/vmlinux.lds.S                    |   71 +
 arch/metag/lib/Makefile                            |   22 +
 arch/metag/lib/ashldi3.S                           |   33 +
 arch/metag/lib/ashrdi3.S                           |   33 +
 arch/metag/lib/checksum.c                          |  169 +++
 arch/metag/lib/clear_page.S                        |   17 +
 arch/metag/lib/cmpdi2.S                            |   32 +
 arch/metag/lib/copy_page.S                         |   20 +
 arch/metag/lib/delay.c                             |   55 +
 arch/metag/lib/div64.S                             |  108 ++
 arch/metag/lib/divsi3.S                            |  100 ++
 arch/metag/lib/ip_fast_csum.S                      |   32 +
 arch/metag/lib/lshrdi3.S                           |   33 +
 arch/metag/lib/memcpy.S                            |  185 +++
 arch/metag/lib/memmove.S                           |  345 +++++
 arch/metag/lib/memset.S                            |   86 ++
 arch/metag/lib/modsi3.S                            |   38 +
 arch/metag/lib/muldi3.S                            |   44 +
 arch/metag/lib/ucmpdi2.S                           |   27 +
 arch/metag/lib/usercopy.c                          | 1341 ++++++++++++++++++
 arch/metag/mm/Kconfig                              |  153 +++
 arch/metag/mm/Makefile                             |   18 +
 arch/metag/mm/extable.c                            |   15 +
 arch/metag/mm/fault.c                              |  239 ++++
 arch/metag/mm/highmem.c                            |  133 ++
 arch/metag/mm/hugetlbpage.c                        |  291 ++++
 arch/metag/mm/init.c                               |  448 ++++++
 arch/metag/mm/ioremap.c                            |   89 ++
 arch/metag/mm/l2cache.c                            |  192 +++
 arch/metag/mm/maccess.c                            |   68 +
 arch/metag/mm/mmu-meta1.c                          |  157 +++
 arch/metag/mm/mmu-meta2.c                          |  208 +++
 arch/metag/mm/numa.c                               |   81 ++
 arch/metag/oprofile/Makefile                       |   16 +
 arch/metag/oprofile/backtrace.c                    |  134 ++
 arch/metag/oprofile/backtrace.h                    |    6 +
 arch/metag/oprofile/op_model_meta12.c              |  242 ++++
 arch/metag/tbx/Makefile                            |   22 +
 arch/metag/tbx/tbicache.c                          |  462 +++++++
 arch/metag/tbx/tbicore.S                           |  136 ++
 arch/metag/tbx/tbictx.S                            |  366 +++++
 arch/metag/tbx/tbictxfpu.S                         |  190 +++
 arch/metag/tbx/tbidefr.S                           |  175 +++
 arch/metag/tbx/tbidspram.S                         |  161 +++
 arch/metag/tbx/tbilogf.S                           |   48 +
 arch/metag/tbx/tbipcx.S                            |  451 ++++++
 arch/metag/tbx/tbiroot.S                           |   87 ++
 arch/metag/tbx/tbisoft.S                           |  237 ++++
 arch/metag/tbx/tbistring.c                         |  145 ++
 arch/metag/tbx/tbitimer.S                          |  207 +++
 arch/openrisc/include/asm/io.h                     |    1 +
 drivers/char/Kconfig                               |    5 +-
 drivers/input/serio/Kconfig                        |    2 +-
 drivers/parport/Kconfig                            |    3 +-
 drivers/tty/Kconfig                                |   13 +
 drivers/tty/Makefile                               |    1 +
 drivers/tty/metag_da.c                             |  523 +++++++
 drivers/video/console/Kconfig                      |    2 +-
 fs/Kconfig                                         |    1 +
 fs/Makefile                                        |    1 +
 fs/binfmt_elf.c                                    |    4 +
 fs/imgdafs/Kconfig                                 |    6 +
 fs/imgdafs/Makefile                                |    7 +
 fs/imgdafs/imgdafs.h                               |   80 ++
 fs/imgdafs/inode.c                                 |  840 ++++++++++++
 include/asm-generic/io.h                           |    1 -
 include/asm-generic/unistd.h                       |    9 +-
 include/linux/mm.h                                 |    2 +
 include/uapi/linux/elf.h                           |    2 +
 kernel/taskstats.c                                 |    3 +-
 kernel/trace/ring_buffer.c                         |    7 +-
 lib/Kconfig.debug                                  |    4 +-
 scripts/checkstack.pl                              |    8 +-
 scripts/recordmcount.c                             |   13 +
 212 files changed, 28270 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt
 create mode 100644 Documentation/metag/00-INDEX
 create mode 100644 arch/metag/Kconfig
 create mode 100644 arch/metag/Kconfig.debug
 create mode 100644 arch/metag/Kconfig.soc
 create mode 100644 arch/metag/Makefile
 create mode 100644 arch/metag/boot/.gitignore
 create mode 100644 arch/metag/boot/Makefile
 create mode 100644 arch/metag/boot/dtb/Makefile
 create mode 100644 arch/metag/boot/dts/skeleton.dts
 create mode 100644 arch/metag/boot/dts/skeleton.dtsi
 create mode 100644 arch/metag/configs/meta1_defconfig
 create mode 100644 arch/metag/configs/meta2_defconfig
 create mode 100644 arch/metag/configs/meta2_smp_defconfig
 create mode 100644 arch/metag/include/asm/Kbuild
 create mode 100644 arch/metag/include/asm/atomic.h
 create mode 100644 arch/metag/include/asm/atomic_lnkget.h
 create mode 100644 arch/metag/include/asm/atomic_lock1.h
 create mode 100644 arch/metag/include/asm/barrier.h
 create mode 100644 arch/metag/include/asm/bitops.h
 create mode 100644 arch/metag/include/asm/bug.h
 create mode 100644 arch/metag/include/asm/cache.h
 create mode 100644 arch/metag/include/asm/cacheflush.h
 create mode 100644 arch/metag/include/asm/cachepart.h
 create mode 100644 arch/metag/include/asm/checksum.h
 create mode 100644 arch/metag/include/asm/clock.h
 create mode 100644 arch/metag/include/asm/cmpxchg.h
 create mode 100644 arch/metag/include/asm/cmpxchg_irq.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lnkget.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lock1.h
 create mode 100644 arch/metag/include/asm/core_reg.h
 create mode 100644 arch/metag/include/asm/cpu.h
 create mode 100644 arch/metag/include/asm/da.h
 create mode 100644 arch/metag/include/asm/delay.h
 create mode 100644 arch/metag/include/asm/div64.h
 create mode 100644 arch/metag/include/asm/dma-mapping.h
 create mode 100644 arch/metag/include/asm/elf.h
 create mode 100644 arch/metag/include/asm/fixmap.h
 create mode 100644 arch/metag/include/asm/ftrace.h
 create mode 100644 arch/metag/include/asm/gpio.h
 create mode 100644 arch/metag/include/asm/highmem.h
 create mode 100644 arch/metag/include/asm/hugetlb.h
 create mode 100644 arch/metag/include/asm/hwthread.h
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irq_external.h
 create mode 100644 arch/metag/include/asm/irq_internal.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/include/asm/l2cache.h
 create mode 100644 arch/metag/include/asm/linkage.h
 create mode 100644 arch/metag/include/asm/lock.h
 create mode 100644 arch/metag/include/asm/mach/arch.h
 create mode 100644 arch/metag/include/asm/metag_isa.h
 create mode 100644 arch/metag/include/asm/metag_mem.h
 create mode 100644 arch/metag/include/asm/metag_regs.h
 create mode 100644 arch/metag/include/asm/mman.h
 create mode 100644 arch/metag/include/asm/mmu.h
 create mode 100644 arch/metag/include/asm/mmu_context.h
 create mode 100644 arch/metag/include/asm/mmzone.h
 create mode 100644 arch/metag/include/asm/module.h
 create mode 100644 arch/metag/include/asm/page.h
 create mode 100644 arch/metag/include/asm/perf_event.h
 create mode 100644 arch/metag/include/asm/pgalloc.h
 create mode 100644 arch/metag/include/asm/pgtable.h
 create mode 100644 arch/metag/include/asm/processor.h
 create mode 100644 arch/metag/include/asm/prom.h
 create mode 100644 arch/metag/include/asm/ptrace.h
 create mode 100644 arch/metag/include/asm/setup.h
 create mode 100644 arch/metag/include/asm/smp.h
 create mode 100644 arch/metag/include/asm/sparsemem.h
 create mode 100644 arch/metag/include/asm/spinlock.h
 create mode 100644 arch/metag/include/asm/spinlock_lnkget.h
 create mode 100644 arch/metag/include/asm/spinlock_lock1.h
 create mode 100644 arch/metag/include/asm/spinlock_types.h
 create mode 100644 arch/metag/include/asm/stacktrace.h
 create mode 100644 arch/metag/include/asm/string.h
 create mode 100644 arch/metag/include/asm/switch.h
 create mode 100644 arch/metag/include/asm/syscall.h
 create mode 100644 arch/metag/include/asm/syscalls.h
 create mode 100644 arch/metag/include/asm/tbx.h
 create mode 100644 arch/metag/include/asm/tcm.h
 create mode 100644 arch/metag/include/asm/thread_info.h
 create mode 100644 arch/metag/include/asm/tlb.h
 create mode 100644 arch/metag/include/asm/tlbflush.h
 create mode 100644 arch/metag/include/asm/topology.h
 create mode 100644 arch/metag/include/asm/traps.h
 create mode 100644 arch/metag/include/asm/uaccess.h
 create mode 100644 arch/metag/include/asm/unistd.h
 create mode 100644 arch/metag/include/asm/user_gateway.h
 create mode 100644 arch/metag/include/uapi/asm/Kbuild
 create mode 100644 arch/metag/include/uapi/asm/byteorder.h
 create mode 100644 arch/metag/include/uapi/asm/ptrace.h
 create mode 100644 arch/metag/include/uapi/asm/resource.h
 create mode 100644 arch/metag/include/uapi/asm/sigcontext.h
 create mode 100644 arch/metag/include/uapi/asm/siginfo.h
 create mode 100644 arch/metag/include/uapi/asm/swab.h
 create mode 100644 arch/metag/include/uapi/asm/unistd.h
 create mode 100644 arch/metag/kernel/.gitignore
 create mode 100644 arch/metag/kernel/Makefile
 create mode 100644 arch/metag/kernel/asm-offsets.c
 create mode 100644 arch/metag/kernel/cachepart.c
 create mode 100644 arch/metag/kernel/clock.c
 create mode 100644 arch/metag/kernel/core_reg.c
 create mode 100644 arch/metag/kernel/da.c
 create mode 100644 arch/metag/kernel/devtree.c
 create mode 100644 arch/metag/kernel/dma.c
 create mode 100644 arch/metag/kernel/ftrace.c
 create mode 100644 arch/metag/kernel/ftrace_stub.S
 create mode 100644 arch/metag/kernel/head.S
 create mode 100644 arch/metag/kernel/irq.c
 create mode 100644 arch/metag/kernel/irq_external.c
 create mode 100644 arch/metag/kernel/irq_internal.c
 create mode 100644 arch/metag/kernel/kick.c
 create mode 100644 arch/metag/kernel/machines.c
 create mode 100644 arch/metag/kernel/metag_ksyms.c
 create mode 100644 arch/metag/kernel/module.c
 create mode 100644 arch/metag/kernel/perf/Makefile
 create mode 100644 arch/metag/kernel/perf/perf_event.c
 create mode 100644 arch/metag/kernel/perf/perf_event.h
 create mode 100644 arch/metag/kernel/perf_callchain.c
 create mode 100644 arch/metag/kernel/process.c
 create mode 100644 arch/metag/kernel/ptrace.c
 create mode 100644 arch/metag/kernel/setup.c
 create mode 100644 arch/metag/kernel/signal.c
 create mode 100644 arch/metag/kernel/smp.c
 create mode 100644 arch/metag/kernel/stacktrace.c
 create mode 100644 arch/metag/kernel/sys_metag.c
 create mode 100644 arch/metag/kernel/tbiunexp.S
 create mode 100644 arch/metag/kernel/tcm.c
 create mode 100644 arch/metag/kernel/time.c
 create mode 100644 arch/metag/kernel/topology.c
 create mode 100644 arch/metag/kernel/traps.c
 create mode 100644 arch/metag/kernel/user_gateway.S
 create mode 100644 arch/metag/kernel/vmlinux.lds.S
 create mode 100644 arch/metag/lib/Makefile
 create mode 100644 arch/metag/lib/ashldi3.S
 create mode 100644 arch/metag/lib/ashrdi3.S
 create mode 100644 arch/metag/lib/checksum.c
 create mode 100644 arch/metag/lib/clear_page.S
 create mode 100644 arch/metag/lib/cmpdi2.S
 create mode 100644 arch/metag/lib/copy_page.S
 create mode 100644 arch/metag/lib/delay.c
 create mode 100644 arch/metag/lib/div64.S
 create mode 100644 arch/metag/lib/divsi3.S
 create mode 100644 arch/metag/lib/ip_fast_csum.S
 create mode 100644 arch/metag/lib/lshrdi3.S
 create mode 100644 arch/metag/lib/memcpy.S
 create mode 100644 arch/metag/lib/memmove.S
 create mode 100644 arch/metag/lib/memset.S
 create mode 100644 arch/metag/lib/modsi3.S
 create mode 100644 arch/metag/lib/muldi3.S
 create mode 100644 arch/metag/lib/ucmpdi2.S
 create mode 100644 arch/metag/lib/usercopy.c
 create mode 100644 arch/metag/mm/Kconfig
 create mode 100644 arch/metag/mm/Makefile
 create mode 100644 arch/metag/mm/extable.c
 create mode 100644 arch/metag/mm/fault.c
 create mode 100644 arch/metag/mm/highmem.c
 create mode 100644 arch/metag/mm/hugetlbpage.c
 create mode 100644 arch/metag/mm/init.c
 create mode 100644 arch/metag/mm/ioremap.c
 create mode 100644 arch/metag/mm/l2cache.c
 create mode 100644 arch/metag/mm/maccess.c
 create mode 100644 arch/metag/mm/mmu-meta1.c
 create mode 100644 arch/metag/mm/mmu-meta2.c
 create mode 100644 arch/metag/mm/numa.c
 create mode 100644 arch/metag/oprofile/Makefile
 create mode 100644 arch/metag/oprofile/backtrace.c
 create mode 100644 arch/metag/oprofile/backtrace.h
 create mode 100644 arch/metag/oprofile/op_model_meta12.c
 create mode 100644 arch/metag/tbx/Makefile
 create mode 100644 arch/metag/tbx/tbicache.c
 create mode 100644 arch/metag/tbx/tbicore.S
 create mode 100644 arch/metag/tbx/tbictx.S
 create mode 100644 arch/metag/tbx/tbictxfpu.S
 create mode 100644 arch/metag/tbx/tbidefr.S
 create mode 100644 arch/metag/tbx/tbidspram.S
 create mode 100644 arch/metag/tbx/tbilogf.S
 create mode 100644 arch/metag/tbx/tbipcx.S
 create mode 100644 arch/metag/tbx/tbiroot.S
 create mode 100644 arch/metag/tbx/tbisoft.S
 create mode 100644 arch/metag/tbx/tbistring.c
 create mode 100644 arch/metag/tbx/tbitimer.S
 create mode 100644 drivers/tty/metag_da.c
 create mode 100644 fs/imgdafs/Kconfig
 create mode 100644 fs/imgdafs/Makefile
 create mode 100644 fs/imgdafs/imgdafs.h
 create mode 100644 fs/imgdafs/inode.c

-- 
1.7.7.6


