Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3AJPci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:32:38 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52711 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3AJPcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:33 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 00/44] Meta Linux Kernel Port
Date: Thu, 10 Jan 2013 15:30:28 +0000
Message-ID: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds core architecture support to Linux for Imagination's
Meta ATP (Meta 1) and HTP (Meta 2) processor cores. Most of the feedback
from the RFC and v2 patchsets has now been addressed. All further
feedback is most welcome.

The patches are based on next-20130110, and can also be found in the
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
v3 (tag: metag-core-v3):

changes since v2
* tree:
  * rebased on linux-next and related changes
  * integrated generic kernel_thread/kernel_execve into patches
* signals:
  * replace do_notify_resume with do_work_pending containing signal
    handling loop (Al Viro)
  * handlerless local syscall restart (Al Viro)
  * fix rt_sigreturn's do_sigaltstack handling (Al Viro)
  * explicitly detect rt_sigreturn and treat as non-syscall for purposes
    of syscall restart (Al Viro)
  * refactor syscall restart code based on arm
  * use generic sigaltstack
* irq handling:
  * move irq drivers into drivers/irqchip/ (Arnd)
  * switch to sparse irq (Arnd)
  * allow per machine override of nr_irqs
  * switch root TBI, internal, and external interrupt drivers to linear
    irqdomain
  * implement masking in internal interrupt driver
* system calls:
  * remove magic pt_regs 7th syscall argument (Al Viro)
  * use generic sys_clone (Al Viro)
  * fix use of 0 for invalid syscall number (use -1 instead)
* documentation
  * added Documentation/kernel-ABI.txt describing various ABIs (Al Viro)
* tbx:
  * move tbx/tbicache.c to mm/cache.c and refactor / clean up (Joe
    Perches)
  * clean up tbx/tbistring.c
  * rename asm/lock.h->asm/global_lock.h, remove dependence on tbx
  * update all lock users to use asm/global_lock.h rather than tbx
    macros
  * add and use __core_reg_[gs]et macros to replace TBI_[GS]ETREG
  * make use of compiler builtins for cache/tlb handling instructions
    rather than tbx macros
* tty/metag_da:
  * mostly rewritten to address Alan Cox' feedback
  * use del_timer_sync() where appropriate (Alan Cox)
  * convert to use tty_port helpers (Alan Cox)
  * fix tty kref safety (Alan Cox)
  * implement proper output buffering (Alan Cox)
  * fix init error handling
  * implement hangup (Alan Cox)
  * omit specific baud rate (Alan Cox)
* boot:
  * switch to generic CMDLINE Kconfig symbols (Sam Ravnborg)
* alignment patches
  * removed taskstats changes (see "netlink: align attributes on
    64-bits" patches)
  * rework CONFIG_HAVE_64BIT_ALIGNED_ACCESS patch for clarity

feedback not addressed:
* proper inversion of Kconfig dependency lists (Greg, Arnd)
  I'll do this as a separate patch set as arch/metag doesn't directly
  depend on it.


v2 (tag: metag-core-v2):

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
  asm-generic/io.h: check CONFIG_VIRT_TO_BUS
  asm-generic/unistd.h: handle symbol prefixes in cond_syscall
  Revert some of "binfmt_elf: cleanups"
  Add HAVE_64BIT_ALIGNED_ACCESS
  trace/ring_buffer: handle 64bit aligned structs
  metag: Add MAINTAINERS entry
  metag: Headers for core arch constants
  metag: Header for core memory mapped registers
  metag: Boot
  metag: TBX header
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
  metag: Internal and external irqchips
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
  Kconfig.debug: add METAG to dependency lists
  metag: Build infrastructure
  metag: Perf
  metag: ftrace support
  scripts/checkstack.pl: Add metag support
  metag: OProfile
  metag: Add JTAG Debug Adapter (DA) support
  tty/metag_da: Add metag DA TTY driver
  fs: imgdafs: Add IMG DAFS filesystem for metag

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/metag/meta-intc.txt        |   82 ++
 Documentation/kernel-parameters.txt                |    4 +
 Documentation/metag/00-INDEX                       |    4 +
 Documentation/metag/kernel-ABI.txt                 |  256 ++++
 MAINTAINERS                                        |    9 +
 arch/Kconfig                                       |   16 +
 arch/metag/Kconfig                                 |  294 ++++
 arch/metag/Kconfig.debug                           |   40 +
 arch/metag/Kconfig.soc                             |   55 +
 arch/metag/Makefile                                |   89 ++
 arch/metag/boot/.gitignore                         |    4 +
 arch/metag/boot/Makefile                           |   68 +
 arch/metag/boot/dtb/Makefile                       |   17 +
 arch/metag/boot/dts/skeleton.dts                   |   10 +
 arch/metag/boot/dts/skeleton.dtsi                  |   14 +
 arch/metag/configs/meta1_defconfig                 |   40 +
 arch/metag/configs/meta2_defconfig                 |   41 +
 arch/metag/configs/meta2_smp_defconfig             |   42 +
 arch/metag/include/asm/Kbuild                      |   54 +
 arch/metag/include/asm/atomic.h                    |   53 +
 arch/metag/include/asm/atomic_lnkget.h             |  234 ++++
 arch/metag/include/asm/atomic_lock1.h              |  160 +++
 arch/metag/include/asm/barrier.h                   |   85 ++
 arch/metag/include/asm/bitops.h                    |  132 ++
 arch/metag/include/asm/bug.h                       |   12 +
 arch/metag/include/asm/cache.h                     |   23 +
 arch/metag/include/asm/cacheflush.h                |  250 ++++
 arch/metag/include/asm/cachepart.h                 |   42 +
 arch/metag/include/asm/checksum.h                  |   92 ++
 arch/metag/include/asm/clock.h                     |   51 +
 arch/metag/include/asm/cmpxchg.h                   |   65 +
 arch/metag/include/asm/cmpxchg_irq.h               |   42 +
 arch/metag/include/asm/cmpxchg_lnkget.h            |   86 ++
 arch/metag/include/asm/cmpxchg_lock1.h             |   48 +
 arch/metag/include/asm/core_reg.h                  |   28 +
 arch/metag/include/asm/cpu.h                       |   14 +
 arch/metag/include/asm/da.h                        |   43 +
 arch/metag/include/asm/delay.h                     |   29 +
 arch/metag/include/asm/div64.h                     |   12 +
 arch/metag/include/asm/dma-mapping.h               |  183 +++
 arch/metag/include/asm/elf.h                       |  128 ++
 arch/metag/include/asm/fixmap.h                    |   99 ++
 arch/metag/include/asm/ftrace.h                    |   23 +
 arch/metag/include/asm/global_lock.h               |  100 ++
 arch/metag/include/asm/gpio.h                      |    4 +
 arch/metag/include/asm/highmem.h                   |   62 +
 arch/metag/include/asm/hugetlb.h                   |   86 ++
 arch/metag/include/asm/hwthread.h                  |   40 +
 arch/metag/include/asm/io.h                        |  165 +++
 arch/metag/include/asm/irq.h                       |   32 +
 arch/metag/include/asm/irqflags.h                  |   97 ++
 arch/metag/include/asm/l2cache.h                   |  258 ++++
 arch/metag/include/asm/linkage.h                   |    7 +
 arch/metag/include/asm/mach/arch.h                 |   86 ++
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
 arch/metag/include/asm/processor.h                 |  202 +++
 arch/metag/include/asm/prom.h                      |   23 +
 arch/metag/include/asm/ptrace.h                    |   60 +
 arch/metag/include/asm/setup.h                     |    8 +
 arch/metag/include/asm/smp.h                       |   31 +
 arch/metag/include/asm/sparsemem.h                 |   13 +
 arch/metag/include/asm/spinlock.h                  |   22 +
 arch/metag/include/asm/spinlock_lnkget.h           |  249 ++++
 arch/metag/include/asm/spinlock_lock1.h            |  184 +++
 arch/metag/include/asm/spinlock_types.h            |   20 +
 arch/metag/include/asm/stacktrace.h                |   20 +
 arch/metag/include/asm/string.h                    |   13 +
 arch/metag/include/asm/switch.h                    |   22 +
 arch/metag/include/asm/syscall.h                   |  104 ++
 arch/metag/include/asm/syscalls.h                  |   39 +
 arch/metag/include/asm/tbx.h                       | 1425 ++++++++++++++++++++
 arch/metag/include/asm/tcm.h                       |   30 +
 arch/metag/include/asm/thread_info.h               |  155 +++
 arch/metag/include/asm/tlb.h                       |   36 +
 arch/metag/include/asm/tlbflush.h                  |   77 ++
 arch/metag/include/asm/topology.h                  |   53 +
 arch/metag/include/asm/traps.h                     |   47 +
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
 arch/metag/kernel/Makefile                         |   39 +
 arch/metag/kernel/asm-offsets.c                    |   14 +
 arch/metag/kernel/cachepart.c                      |  124 ++
 arch/metag/kernel/clock.c                          |   53 +
 arch/metag/kernel/core_reg.c                       |  117 ++
 arch/metag/kernel/da.c                             |   23 +
 arch/metag/kernel/devtree.c                        |  100 ++
 arch/metag/kernel/dma.c                            |  507 +++++++
 arch/metag/kernel/ftrace.c                         |  127 ++
 arch/metag/kernel/ftrace_stub.S                    |   76 ++
 arch/metag/kernel/head.S                           |   57 +
 arch/metag/kernel/irq.c                            |  322 +++++
 arch/metag/kernel/kick.c                           |   94 ++
 arch/metag/kernel/machines.c                       |   20 +
 arch/metag/kernel/metag_ksyms.c                    |   80 ++
 arch/metag/kernel/module.c                         |  284 ++++
 arch/metag/kernel/perf/Makefile                    |    3 +
 arch/metag/kernel/perf/perf_event.c                |  867 ++++++++++++
 arch/metag/kernel/perf/perf_event.h                |  106 ++
 arch/metag/kernel/perf_callchain.c                 |   96 ++
 arch/metag/kernel/process.c                        |  422 ++++++
 arch/metag/kernel/ptrace.c                         |  380 ++++++
 arch/metag/kernel/setup.c                          |  571 ++++++++
 arch/metag/kernel/signal.c                         |  344 +++++
 arch/metag/kernel/smp.c                            |  582 ++++++++
 arch/metag/kernel/stacktrace.c                     |  187 +++
 arch/metag/kernel/sys_metag.c                      |  181 +++
 arch/metag/kernel/tbiunexp.S                       |   22 +
 arch/metag/kernel/tcm.c                            |  151 +++
 arch/metag/kernel/time.c                           |  163 +++
 arch/metag/kernel/topology.c                       |   77 ++
 arch/metag/kernel/traps.c                          |  983 ++++++++++++++
 arch/metag/kernel/user_gateway.S                   |   97 ++
 arch/metag/kernel/vmlinux.lds.S                    |   71 +
 arch/metag/lib/Makefile                            |   22 +
 arch/metag/lib/ashldi3.S                           |   33 +
 arch/metag/lib/ashrdi3.S                           |   33 +
 arch/metag/lib/checksum.c                          |  168 +++
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
 arch/metag/mm/Makefile                             |   19 +
 arch/metag/mm/cache.c                              |  441 ++++++
 arch/metag/mm/extable.c                            |   15 +
 arch/metag/mm/fault.c                              |  239 ++++
 arch/metag/mm/highmem.c                            |  133 ++
 arch/metag/mm/hugetlbpage.c                        |  291 ++++
 arch/metag/mm/init.c                               |  448 ++++++
 arch/metag/mm/ioremap.c                            |   89 ++
 arch/metag/mm/l2cache.c                            |  192 +++
 arch/metag/mm/maccess.c                            |   68 +
 arch/metag/mm/mmu-meta1.c                          |  157 +++
 arch/metag/mm/mmu-meta2.c                          |  207 +++
 arch/metag/mm/numa.c                               |   81 ++
 arch/metag/oprofile/Makefile                       |   16 +
 arch/metag/oprofile/backtrace.c                    |  134 ++
 arch/metag/oprofile/backtrace.h                    |    6 +
 arch/metag/oprofile/op_model_meta12.c              |  242 ++++
 arch/metag/tbx/Makefile                            |   21 +
 arch/metag/tbx/tbicore.S                           |  136 ++
 arch/metag/tbx/tbictx.S                            |  366 +++++
 arch/metag/tbx/tbictxfpu.S                         |  190 +++
 arch/metag/tbx/tbidefr.S                           |  175 +++
 arch/metag/tbx/tbidspram.S                         |  161 +++
 arch/metag/tbx/tbilogf.S                           |   48 +
 arch/metag/tbx/tbipcx.S                            |  451 +++++++
 arch/metag/tbx/tbiroot.S                           |   87 ++
 arch/metag/tbx/tbisoft.S                           |  237 ++++
 arch/metag/tbx/tbistring.c                         |  114 ++
 arch/metag/tbx/tbitimer.S                          |  207 +++
 drivers/irqchip/Makefile                           |    2 +
 drivers/irqchip/irq-meta-ext.c                     |  868 ++++++++++++
 drivers/irqchip/irq-meta.c                         |  343 +++++
 drivers/tty/Kconfig                                |   13 +
 drivers/tty/Makefile                               |    1 +
 drivers/tty/metag_da.c                             |  696 ++++++++++
 fs/Kconfig                                         |    1 +
 fs/Makefile                                        |    1 +
 fs/binfmt_elf.c                                    |    4 +
 fs/imgdafs/Kconfig                                 |    6 +
 fs/imgdafs/Makefile                                |    7 +
 fs/imgdafs/imgdafs.h                               |   80 ++
 fs/imgdafs/inode.c                                 |  840 ++++++++++++
 include/asm-generic/io.h                           |    2 +
 include/asm-generic/unistd.h                       |    9 +-
 include/linux/irqchip/meta-ext.h                   |   33 +
 include/linux/irqchip/meta.h                       |   24 +
 include/linux/mm.h                                 |    2 +
 include/uapi/linux/elf.h                           |    2 +
 kernel/trace/ring_buffer.c                         |    6 +-
 lib/Kconfig.debug                                  |    4 +-
 scripts/checkstack.pl                              |    8 +-
 scripts/recordmcount.c                             |   13 +
 207 files changed, 28732 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt
 create mode 100644 Documentation/metag/00-INDEX
 create mode 100644 Documentation/metag/kernel-ABI.txt
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
 create mode 100644 arch/metag/include/asm/global_lock.h
 create mode 100644 arch/metag/include/asm/gpio.h
 create mode 100644 arch/metag/include/asm/highmem.h
 create mode 100644 arch/metag/include/asm/hugetlb.h
 create mode 100644 arch/metag/include/asm/hwthread.h
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/include/asm/l2cache.h
 create mode 100644 arch/metag/include/asm/linkage.h
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
 create mode 100644 arch/metag/mm/cache.c
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
 create mode 100644 drivers/irqchip/irq-meta-ext.c
 create mode 100644 drivers/irqchip/irq-meta.c
 create mode 100644 drivers/tty/metag_da.c
 create mode 100644 fs/imgdafs/Kconfig
 create mode 100644 fs/imgdafs/Makefile
 create mode 100644 fs/imgdafs/imgdafs.h
 create mode 100644 fs/imgdafs/inode.c
 create mode 100644 include/linux/irqchip/meta-ext.h
 create mode 100644 include/linux/irqchip/meta.h

-- 
1.7.7.6


