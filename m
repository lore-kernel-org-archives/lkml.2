Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0E2Ddv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:33:51 -0400
Received: from king.tilera.com ([72.1.168.226]:16053 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0E2Ddq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:33:46 -0400
Message-Id: <201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:20:03 -0400
Subject: [PATCH 0/8] revised patch for arch/tile/ support
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:33:45.0827 (UTC) FILETIME=[BE5AE330:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 20 I wrote:
> At Tilera we have been running Linux 2.6.26 on our architecture for a
> while and distributing the sources to our customers.  We just sync'ed up
> our sources to 2.6.34 and would like to return it to the community more
> widely, so I'm hoping to take advantage of the merge window for 2.6.35
> to integrate support for our architecture.

Thanks to some much-appreciated volunteer work reviewing that initial
patch, I now have a revised set of patches which I would like to offer
for submission to the mainline.

The largest chunk of work has been adopting the "generic" syscall ABI in
asm-generic.  It required some work extending it to a new architecture,
particularly to support both 32- and 64-bit chips, and to support a
32-bit compat layer on the 64-bit architecture.  Many thanks to Arnd
Bergmann for working with me on this.

In addition, I have wised up and removed most of the driver material
from this patch.  They are not immediately essential for booting up
Tilera Linux, and I will plan to feed the drivers back over time after
this initial baseline patch has been accepted.

The patches are in eight commits, the first being the changes to the
"generic" ABI.  The remaining seven patches are the tile architecture
code, broken up into somewhat digestible chunks.

Many thanks to the folks who took the time to review parts of
the initial diffs:

  Arnd Bergmann <arnd@arndb.de>
  Barry Song <21cnbao@gmail.com>
  Sam Ravnborg <sam@ravnborg.org>
  Thomas Gleixner <tglx@linutronix.de>
  Marc Gauthier <marc@tensilica.com>
  Jamie Lokier <jamie@shareable.org>
  and Linus for reviewing my one-line lowmem_page_address() patch :-)

(Sorry for the double-posting to linux-arch and Linus; I included
the Cc's but dropped the "To" when I ran git format-patch the first time.)

Chris Metcalf (8):
  Fix up the "generic" unistd.h ABI to be more useful.
  arch/tile: infrastructure and configuration-related files.
  arch/tile: header files for the Tile architecture.
  arch/tile: core kernel/ code.
  arch/tile: the kernel/tile-desc_32.c file.
  arch/tile: the mm/ directory.
  arch/tile: lib/ directory.
  arch/tile: hypervisor console driver.

 MAINTAINERS                                 |    6 +
 arch/tile/Kbuild                            |    3 +
 arch/tile/Kconfig                           |  360 +
 arch/tile/Kconfig.debug                     |   43 +
 arch/tile/Makefile                          |   52 +
 arch/tile/configs/tile_defconfig            | 1289 +++
 arch/tile/include/arch/abi.h                |   93 +
 arch/tile/include/arch/chip.h               |   23 +
 arch/tile/include/arch/chip_tile64.h        |  252 +
 arch/tile/include/arch/chip_tilepro.h       |  252 +
 arch/tile/include/arch/interrupts.h         |   19 +
 arch/tile/include/arch/interrupts_32.h      |  304 +
 arch/tile/include/arch/sim_def.h            |  512 +
 arch/tile/include/arch/spr_def.h            |   19 +
 arch/tile/include/arch/spr_def_32.h         |  162 +
 arch/tile/include/asm/Kbuild                |    3 +
 arch/tile/include/asm/asm-offsets.h         |    1 +
 arch/tile/include/asm/atomic.h              |  159 +
 arch/tile/include/asm/atomic_32.h           |  353 +
 arch/tile/include/asm/auxvec.h              |   20 +
 arch/tile/include/asm/backtrace.h           |  193 +
 arch/tile/include/asm/bitops.h              |  126 +
 arch/tile/include/asm/bitops_32.h           |  132 +
 arch/tile/include/asm/bitsperlong.h         |   26 +
 arch/tile/include/asm/bug.h                 |    1 +
 arch/tile/include/asm/bugs.h                |    1 +
 arch/tile/include/asm/byteorder.h           |    1 +
 arch/tile/include/asm/cache.h               |   50 +
 arch/tile/include/asm/cacheflush.h          |  145 +
 arch/tile/include/asm/checksum.h            |   24 +
 arch/tile/include/asm/compat.h              |  308 +
 arch/tile/include/asm/cputime.h             |    1 +
 arch/tile/include/asm/current.h             |   31 +
 arch/tile/include/asm/delay.h               |   34 +
 arch/tile/include/asm/device.h              |    1 +
 arch/tile/include/asm/div64.h               |    1 +
 arch/tile/include/asm/dma-mapping.h         |  106 +
 arch/tile/include/asm/dma.h                 |   25 +
 arch/tile/include/asm/elf.h                 |  169 +
 arch/tile/include/asm/emergency-restart.h   |    1 +
 arch/tile/include/asm/errno.h               |    1 +
 arch/tile/include/asm/fcntl.h               |    1 +
 arch/tile/include/asm/fixmap.h              |  124 +
 arch/tile/include/asm/ftrace.h              |   20 +
 arch/tile/include/asm/futex.h               |  136 +
 arch/tile/include/asm/hardirq.h             |   47 +
 arch/tile/include/asm/highmem.h             |   73 +
 arch/tile/include/asm/homecache.h           |  125 +
 arch/tile/include/asm/hugetlb.h             |  109 +
 arch/tile/include/asm/hv_driver.h           |   60 +
 arch/tile/include/asm/hw_irq.h              |   18 +
 arch/tile/include/asm/ide.h                 |   25 +
 arch/tile/include/asm/io.h                  |  220 +
 arch/tile/include/asm/ioctl.h               |    1 +
 arch/tile/include/asm/ioctls.h              |    1 +
 arch/tile/include/asm/ipc.h                 |    1 +
 arch/tile/include/asm/ipcbuf.h              |    1 +
 arch/tile/include/asm/irq.h                 |   37 +
 arch/tile/include/asm/irq_regs.h            |    1 +
 arch/tile/include/asm/irqflags.h            |  267 +
 arch/tile/include/asm/kdebug.h              |    1 +
 arch/tile/include/asm/kexec.h               |   53 +
 arch/tile/include/asm/kmap_types.h          |   43 +
 arch/tile/include/asm/linkage.h             |   51 +
 arch/tile/include/asm/local.h               |    1 +
 arch/tile/include/asm/memprof.h             |   33 +
 arch/tile/include/asm/mman.h                |   40 +
 arch/tile/include/asm/mmu.h                 |   31 +
 arch/tile/include/asm/mmu_context.h         |  131 +
 arch/tile/include/asm/mmzone.h              |   81 +
 arch/tile/include/asm/module.h              |    1 +
 arch/tile/include/asm/msgbuf.h              |    1 +
 arch/tile/include/asm/mutex.h               |    1 +
 arch/tile/include/asm/opcode-tile.h         |   30 +
 arch/tile/include/asm/opcode-tile_32.h      | 1597 ++++
 arch/tile/include/asm/opcode-tile_64.h      | 1597 ++++
 arch/tile/include/asm/opcode_constants.h    |   26 +
 arch/tile/include/asm/opcode_constants_32.h |  480 +
 arch/tile/include/asm/opcode_constants_64.h |  480 +
 arch/tile/include/asm/page.h                |  334 +
 arch/tile/include/asm/param.h               |    1 +
 arch/tile/include/asm/pci-bridge.h          |  117 +
 arch/tile/include/asm/pci.h                 |  128 +
 arch/tile/include/asm/percpu.h              |   24 +
 arch/tile/include/asm/pgalloc.h             |  119 +
 arch/tile/include/asm/pgtable.h             |  475 +
 arch/tile/include/asm/pgtable_32.h          |  117 +
 arch/tile/include/asm/poll.h                |    1 +
 arch/tile/include/asm/posix_types.h         |    1 +
 arch/tile/include/asm/processor.h           |  339 +
 arch/tile/include/asm/ptrace.h              |  163 +
 arch/tile/include/asm/resource.h            |    1 +
 arch/tile/include/asm/scatterlist.h         |    1 +
 arch/tile/include/asm/sections.h            |   37 +
 arch/tile/include/asm/sembuf.h              |    1 +
 arch/tile/include/asm/setup.h               |   32 +
 arch/tile/include/asm/shmbuf.h              |    1 +
 arch/tile/include/asm/shmparam.h            |    1 +
 arch/tile/include/asm/sigcontext.h          |   27 +
 arch/tile/include/asm/sigframe.h            |   33 +
 arch/tile/include/asm/siginfo.h             |   30 +
 arch/tile/include/asm/signal.h              |   31 +
 arch/tile/include/asm/smp.h                 |  126 +
 arch/tile/include/asm/socket.h              |    1 +
 arch/tile/include/asm/sockios.h             |    1 +
 arch/tile/include/asm/spinlock.h            |   24 +
 arch/tile/include/asm/spinlock_32.h         |  200 +
 arch/tile/include/asm/spinlock_types.h      |   60 +
 arch/tile/include/asm/stack.h               |   68 +
 arch/tile/include/asm/stat.h                |    1 +
 arch/tile/include/asm/statfs.h              |    1 +
 arch/tile/include/asm/string.h              |   32 +
 arch/tile/include/asm/swab.h                |   29 +
 arch/tile/include/asm/syscall.h             |   79 +
 arch/tile/include/asm/syscalls.h            |   60 +
 arch/tile/include/asm/system.h              |  220 +
 arch/tile/include/asm/termbits.h            |    1 +
 arch/tile/include/asm/termios.h             |    1 +
 arch/tile/include/asm/thread_info.h         |  165 +
 arch/tile/include/asm/timex.h               |   47 +
 arch/tile/include/asm/tlb.h                 |   25 +
 arch/tile/include/asm/tlbflush.h            |  128 +
 arch/tile/include/asm/topology.h            |   85 +
 arch/tile/include/asm/traps.h               |   36 +
 arch/tile/include/asm/types.h               |    1 +
 arch/tile/include/asm/uaccess.h             |  578 ++
 arch/tile/include/asm/ucontext.h            |    1 +
 arch/tile/include/asm/unaligned.h           |   24 +
 arch/tile/include/asm/unistd.h              |   47 +
 arch/tile/include/asm/user.h                |   21 +
 arch/tile/include/asm/xor.h                 |    1 +
 arch/tile/include/hv/drv_pcie_rc_intf.h     |   38 +
 arch/tile/include/hv/hypervisor.h           | 2366 +++++
 arch/tile/include/hv/syscall_public.h       |   42 +
 arch/tile/kernel/Makefile                   |   16 +
 arch/tile/kernel/asm-offsets.c              |   76 +
 arch/tile/kernel/backtrace.c                |  634 ++
 arch/tile/kernel/compat.c                   |  183 +
 arch/tile/kernel/compat_signal.c            |  433 +
 arch/tile/kernel/early_printk.c             |  109 +
 arch/tile/kernel/entry.S                    |  141 +
 arch/tile/kernel/head_32.S                  |  180 +
 arch/tile/kernel/hvglue.lds                 |   56 +
 arch/tile/kernel/init_task.c                |   59 +
 arch/tile/kernel/intvec_32.S                | 2006 ++++
 arch/tile/kernel/irq.c                      |  227 +
 arch/tile/kernel/machine_kexec.c            |  291 +
 arch/tile/kernel/messaging.c                |  115 +
 arch/tile/kernel/module.c                   |  257 +
 arch/tile/kernel/pci-dma.c                  |  231 +
 arch/tile/kernel/proc.c                     |   91 +
 arch/tile/kernel/process.c                  |  647 ++
 arch/tile/kernel/ptrace.c                   |  203 +
 arch/tile/kernel/reboot.c                   |   52 +
 arch/tile/kernel/regs_32.S                  |  145 +
 arch/tile/kernel/relocate_kernel.S          |  280 +
 arch/tile/kernel/setup.c                    | 1497 +++
 arch/tile/kernel/signal.c                   |  359 +
 arch/tile/kernel/single_step.c              |  656 ++
 arch/tile/kernel/smp.c                      |  202 +
 arch/tile/kernel/smpboot.c                  |  293 +
 arch/tile/kernel/stack.c                    |  485 +
 arch/tile/kernel/sys.c                      |  122 +
 arch/tile/kernel/tile-desc_32.c             |13826 +++++++++++++++++++++++++++
 arch/tile/kernel/time.c                     |  220 +
 arch/tile/kernel/tlb.c                      |   97 +
 arch/tile/kernel/traps.c                    |  237 +
 arch/tile/kernel/vmlinux.lds.S              |   98 +
 arch/tile/lib/Makefile                      |   16 +
 arch/tile/lib/__invalidate_icache.S         |  106 +
 arch/tile/lib/atomic_32.c                   |  347 +
 arch/tile/lib/atomic_asm_32.S               |  197 +
 arch/tile/lib/checksum.c                    |  102 +
 arch/tile/lib/cpumask.c                     |   51 +
 arch/tile/lib/delay.c                       |   34 +
 arch/tile/lib/exports.c                     |   78 +
 arch/tile/lib/mb_incoherent.S               |   34 +
 arch/tile/lib/memchr_32.c                   |   68 +
 arch/tile/lib/memcpy_32.S                   |  628 ++
 arch/tile/lib/memcpy_tile64.c               |  271 +
 arch/tile/lib/memmove_32.c                  |   63 +
 arch/tile/lib/memset_32.c                   |  274 +
 arch/tile/lib/spinlock_32.c                 |  221 +
 arch/tile/lib/spinlock_common.h             |   64 +
 arch/tile/lib/strchr_32.c                   |   66 +
 arch/tile/lib/strlen_32.c                   |   36 +
 arch/tile/lib/uaccess.c                     |   31 +
 arch/tile/lib/usercopy_32.S                 |  223 +
 arch/tile/mm/Makefile                       |    9 +
 arch/tile/mm/elf.c                          |  164 +
 arch/tile/mm/extable.c                      |   30 +
 arch/tile/mm/fault.c                        |  905 ++
 arch/tile/mm/highmem.c                      |  328 +
 arch/tile/mm/homecache.c                    |  445 +
 arch/tile/mm/hugetlbpage.c                  |  343 +
 arch/tile/mm/init.c                         | 1082 +++
 arch/tile/mm/migrate.h                      |   50 +
 arch/tile/mm/migrate_32.S                   |  211 +
 arch/tile/mm/mmap.c                         |   75 +
 arch/tile/mm/pgtable.c                      |  566 ++
 drivers/char/Makefile                       |    1 +
 drivers/char/hvc_tile.c                     |   67 +
 include/asm-generic/unistd.h                |   26 +-
 include/linux/syscalls.h                    |    4 +
 204 files changed, 49504 insertions(+), 6 deletions(-)
 create mode 100644 arch/tile/Kbuild
 create mode 100644 arch/tile/Kconfig
 create mode 100644 arch/tile/Kconfig.debug
 create mode 100644 arch/tile/Makefile
 create mode 100644 arch/tile/configs/tile_defconfig
 create mode 100644 arch/tile/include/arch/abi.h
 create mode 100644 arch/tile/include/arch/chip.h
 create mode 100644 arch/tile/include/arch/chip_tile64.h
 create mode 100644 arch/tile/include/arch/chip_tilepro.h
 create mode 100644 arch/tile/include/arch/interrupts.h
 create mode 100644 arch/tile/include/arch/interrupts_32.h
 create mode 100644 arch/tile/include/arch/sim_def.h
 create mode 100644 arch/tile/include/arch/spr_def.h
 create mode 100644 arch/tile/include/arch/spr_def_32.h
 create mode 100644 arch/tile/include/asm/Kbuild
 create mode 100644 arch/tile/include/asm/asm-offsets.h
 create mode 100644 arch/tile/include/asm/atomic.h
 create mode 100644 arch/tile/include/asm/atomic_32.h
 create mode 100644 arch/tile/include/asm/auxvec.h
 create mode 100644 arch/tile/include/asm/backtrace.h
 create mode 100644 arch/tile/include/asm/bitops.h
 create mode 100644 arch/tile/include/asm/bitops_32.h
 create mode 100644 arch/tile/include/asm/bitsperlong.h
 create mode 100644 arch/tile/include/asm/bug.h
 create mode 100644 arch/tile/include/asm/bugs.h
 create mode 100644 arch/tile/include/asm/byteorder.h
 create mode 100644 arch/tile/include/asm/cache.h
 create mode 100644 arch/tile/include/asm/cacheflush.h
 create mode 100644 arch/tile/include/asm/checksum.h
 create mode 100644 arch/tile/include/asm/compat.h
 create mode 100644 arch/tile/include/asm/cputime.h
 create mode 100644 arch/tile/include/asm/current.h
 create mode 100644 arch/tile/include/asm/delay.h
 create mode 100644 arch/tile/include/asm/device.h
 create mode 100644 arch/tile/include/asm/div64.h
 create mode 100644 arch/tile/include/asm/dma-mapping.h
 create mode 100644 arch/tile/include/asm/dma.h
 create mode 100644 arch/tile/include/asm/elf.h
 create mode 100644 arch/tile/include/asm/emergency-restart.h
 create mode 100644 arch/tile/include/asm/errno.h
 create mode 100644 arch/tile/include/asm/fcntl.h
 create mode 100644 arch/tile/include/asm/fixmap.h
 create mode 100644 arch/tile/include/asm/ftrace.h
 create mode 100644 arch/tile/include/asm/futex.h
 create mode 100644 arch/tile/include/asm/hardirq.h
 create mode 100644 arch/tile/include/asm/highmem.h
 create mode 100644 arch/tile/include/asm/homecache.h
 create mode 100644 arch/tile/include/asm/hugetlb.h
 create mode 100644 arch/tile/include/asm/hv_driver.h
 create mode 100644 arch/tile/include/asm/hw_irq.h
 create mode 100644 arch/tile/include/asm/ide.h
 create mode 100644 arch/tile/include/asm/io.h
 create mode 100644 arch/tile/include/asm/ioctl.h
 create mode 100644 arch/tile/include/asm/ioctls.h
 create mode 100644 arch/tile/include/asm/ipc.h
 create mode 100644 arch/tile/include/asm/ipcbuf.h
 create mode 100644 arch/tile/include/asm/irq.h
 create mode 100644 arch/tile/include/asm/irq_regs.h
 create mode 100644 arch/tile/include/asm/irqflags.h
 create mode 100644 arch/tile/include/asm/kdebug.h
 create mode 100644 arch/tile/include/asm/kexec.h
 create mode 100644 arch/tile/include/asm/kmap_types.h
 create mode 100644 arch/tile/include/asm/linkage.h
 create mode 100644 arch/tile/include/asm/local.h
 create mode 100644 arch/tile/include/asm/memprof.h
 create mode 100644 arch/tile/include/asm/mman.h
 create mode 100644 arch/tile/include/asm/mmu.h
 create mode 100644 arch/tile/include/asm/mmu_context.h
 create mode 100644 arch/tile/include/asm/mmzone.h
 create mode 100644 arch/tile/include/asm/module.h
 create mode 100644 arch/tile/include/asm/msgbuf.h
 create mode 100644 arch/tile/include/asm/mutex.h
 create mode 100644 arch/tile/include/asm/opcode-tile.h
 create mode 100644 arch/tile/include/asm/opcode-tile_32.h
 create mode 100644 arch/tile/include/asm/opcode-tile_64.h
 create mode 100644 arch/tile/include/asm/opcode_constants.h
 create mode 100644 arch/tile/include/asm/opcode_constants_32.h
 create mode 100644 arch/tile/include/asm/opcode_constants_64.h
 create mode 100644 arch/tile/include/asm/page.h
 create mode 100644 arch/tile/include/asm/param.h
 create mode 100644 arch/tile/include/asm/pci-bridge.h
 create mode 100644 arch/tile/include/asm/pci.h
 create mode 100644 arch/tile/include/asm/percpu.h
 create mode 100644 arch/tile/include/asm/pgalloc.h
 create mode 100644 arch/tile/include/asm/pgtable.h
 create mode 100644 arch/tile/include/asm/pgtable_32.h
 create mode 100644 arch/tile/include/asm/poll.h
 create mode 100644 arch/tile/include/asm/posix_types.h
 create mode 100644 arch/tile/include/asm/processor.h
 create mode 100644 arch/tile/include/asm/ptrace.h
 create mode 100644 arch/tile/include/asm/resource.h
 create mode 100644 arch/tile/include/asm/scatterlist.h
 create mode 100644 arch/tile/include/asm/sections.h
 create mode 100644 arch/tile/include/asm/sembuf.h
 create mode 100644 arch/tile/include/asm/setup.h
 create mode 100644 arch/tile/include/asm/shmbuf.h
 create mode 100644 arch/tile/include/asm/shmparam.h
 create mode 100644 arch/tile/include/asm/sigcontext.h
 create mode 100644 arch/tile/include/asm/sigframe.h
 create mode 100644 arch/tile/include/asm/siginfo.h
 create mode 100644 arch/tile/include/asm/signal.h
 create mode 100644 arch/tile/include/asm/smp.h
 create mode 100644 arch/tile/include/asm/socket.h
 create mode 100644 arch/tile/include/asm/sockios.h
 create mode 100644 arch/tile/include/asm/spinlock.h
 create mode 100644 arch/tile/include/asm/spinlock_32.h
 create mode 100644 arch/tile/include/asm/spinlock_types.h
 create mode 100644 arch/tile/include/asm/stack.h
 create mode 100644 arch/tile/include/asm/stat.h
 create mode 100644 arch/tile/include/asm/statfs.h
 create mode 100644 arch/tile/include/asm/string.h
 create mode 100644 arch/tile/include/asm/swab.h
 create mode 100644 arch/tile/include/asm/syscall.h
 create mode 100644 arch/tile/include/asm/syscalls.h
 create mode 100644 arch/tile/include/asm/system.h
 create mode 100644 arch/tile/include/asm/termbits.h
 create mode 100644 arch/tile/include/asm/termios.h
 create mode 100644 arch/tile/include/asm/thread_info.h
 create mode 100644 arch/tile/include/asm/timex.h
 create mode 100644 arch/tile/include/asm/tlb.h
 create mode 100644 arch/tile/include/asm/tlbflush.h
 create mode 100644 arch/tile/include/asm/topology.h
 create mode 100644 arch/tile/include/asm/traps.h
 create mode 100644 arch/tile/include/asm/types.h
 create mode 100644 arch/tile/include/asm/uaccess.h
 create mode 100644 arch/tile/include/asm/ucontext.h
 create mode 100644 arch/tile/include/asm/unaligned.h
 create mode 100644 arch/tile/include/asm/unistd.h
 create mode 100644 arch/tile/include/asm/user.h
 create mode 100644 arch/tile/include/asm/xor.h
 create mode 100644 arch/tile/include/hv/drv_pcie_rc_intf.h
 create mode 100644 arch/tile/include/hv/hypervisor.h
 create mode 100644 arch/tile/include/hv/syscall_public.h
 create mode 100644 arch/tile/kernel/Makefile
 create mode 100644 arch/tile/kernel/asm-offsets.c
 create mode 100644 arch/tile/kernel/backtrace.c
 create mode 100644 arch/tile/kernel/compat.c
 create mode 100644 arch/tile/kernel/compat_signal.c
 create mode 100644 arch/tile/kernel/early_printk.c
 create mode 100644 arch/tile/kernel/entry.S
 create mode 100644 arch/tile/kernel/head_32.S
 create mode 100644 arch/tile/kernel/hvglue.lds
 create mode 100644 arch/tile/kernel/init_task.c
 create mode 100644 arch/tile/kernel/intvec_32.S
 create mode 100644 arch/tile/kernel/irq.c
 create mode 100644 arch/tile/kernel/machine_kexec.c
 create mode 100644 arch/tile/kernel/messaging.c
 create mode 100644 arch/tile/kernel/module.c
 create mode 100644 arch/tile/kernel/pci-dma.c
 create mode 100644 arch/tile/kernel/proc.c
 create mode 100644 arch/tile/kernel/process.c
 create mode 100644 arch/tile/kernel/ptrace.c
 create mode 100644 arch/tile/kernel/reboot.c
 create mode 100644 arch/tile/kernel/regs_32.S
 create mode 100644 arch/tile/kernel/relocate_kernel.S
 create mode 100644 arch/tile/kernel/setup.c
 create mode 100644 arch/tile/kernel/signal.c
 create mode 100644 arch/tile/kernel/single_step.c
 create mode 100644 arch/tile/kernel/smp.c
 create mode 100644 arch/tile/kernel/smpboot.c
 create mode 100644 arch/tile/kernel/stack.c
 create mode 100644 arch/tile/kernel/sys.c
 create mode 100644 arch/tile/kernel/tile-desc_32.c
 create mode 100644 arch/tile/kernel/time.c
 create mode 100644 arch/tile/kernel/tlb.c
 create mode 100644 arch/tile/kernel/traps.c
 create mode 100644 arch/tile/kernel/vmlinux.lds.S
 create mode 100644 arch/tile/lib/Makefile
 create mode 100644 arch/tile/lib/__invalidate_icache.S
 create mode 100644 arch/tile/lib/atomic_32.c
 create mode 100644 arch/tile/lib/atomic_asm_32.S
 create mode 100644 arch/tile/lib/checksum.c
 create mode 100644 arch/tile/lib/cpumask.c
 create mode 100644 arch/tile/lib/delay.c
 create mode 100644 arch/tile/lib/exports.c
 create mode 100644 arch/tile/lib/mb_incoherent.S
 create mode 100644 arch/tile/lib/memchr_32.c
 create mode 100644 arch/tile/lib/memcpy_32.S
 create mode 100644 arch/tile/lib/memcpy_tile64.c
 create mode 100644 arch/tile/lib/memmove_32.c
 create mode 100644 arch/tile/lib/memset_32.c
 create mode 100644 arch/tile/lib/spinlock_32.c
 create mode 100644 arch/tile/lib/spinlock_common.h
 create mode 100644 arch/tile/lib/strchr_32.c
 create mode 100644 arch/tile/lib/strlen_32.c
 create mode 100644 arch/tile/lib/uaccess.c
 create mode 100644 arch/tile/lib/usercopy_32.S
 create mode 100644 arch/tile/mm/Makefile
 create mode 100644 arch/tile/mm/elf.c
 create mode 100644 arch/tile/mm/extable.c
 create mode 100644 arch/tile/mm/fault.c
 create mode 100644 arch/tile/mm/highmem.c
 create mode 100644 arch/tile/mm/homecache.c
 create mode 100644 arch/tile/mm/hugetlbpage.c
 create mode 100644 arch/tile/mm/init.c
 create mode 100644 arch/tile/mm/migrate.h
 create mode 100644 arch/tile/mm/migrate_32.S
 create mode 100644 arch/tile/mm/mmap.c
 create mode 100644 arch/tile/mm/pgtable.c
 create mode 100644 drivers/char/hvc_tile.c

