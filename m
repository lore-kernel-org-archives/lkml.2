Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1EYUgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:36:50 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:15393 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1EYUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:36:49 -0400
Message-ID: <4DDD685C.9080100@tilera.com>
Date: Wed, 25 May 2011 16:36:44 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch/tile updates for v2.6.40
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 2.6.40 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

The most interesting part of this batch is that it includes initial
support for the new 64-bit Tilera architecture (TILE-Gx), which was
previously only "accidentally" present in various places in arch/tile.
It also changes the preferred 32-bit architecture name to "tilepro"
(though "tile" will still build the 32-bit kernel).

It also includes some fixes related to being able to build the kernel
either with 4KB or 64KB page size, depending on the target use; and, it
adds support for the tile hypervisor RTC driver.

The platform-independent changes relate to the asm-generic syscall ABI,
for audit and for 64-bit "compat" mode.

All the changes are in linux-next and have been sent to LKML plus
any other relevant lists.  (Some other changes, for some /proc and
/sys hooks, and for an SPI ROM driver, are still being discussed on LKML,
and I may ask you to pull them later in the merge window.)

Chris Metcalf (22):
      arch/tile: refactor backtracing code
      arch/tile: support TIF_NOTIFY_RESUME
      arch/tile: improve support for PCI hotplug
      arch/tile: allow nonatomic stores to interoperate with fast atomic syscalls
      arch/tile: disable SD_WAKE_AFFINE flag on CPU/NODE scheduling domain
      arch/tile: properly flush the I$ when unloading kernel modules
      arch/tile: tolerate disabling CONFIG_BLK_DEV_INITRD
      arch/tile: disable GX prefetcher during cache flush
      arch/tile: various header improvements for building drivers
      arch/tile: kernel-related cleanups from removing static page size
      arch/tile: clarify flush_buffer()/finv_buffer() function names
      audit: support the "standard" <asm-generic/unistd.h>
      arch/tile: update defconfig file to something more useful
      compat: fixes to allow working with tile arch
      arch/tile: finish enabling support for TILE-Gx 64-bit chip
      tile: add an RTC driver for the Tilera hypervisor
      include/linux/compat.h: coding-style fixes
      arch/tile: use better definitions of xchg() and cmpxchg()
      arch/tile: support signal "exception-trace" hook
      arch/tile: allocate PCI IRQs later in boot
      arch/tile: cleanups for tilegx compat mode
      arch/tile: prefer "tilepro" as the name of the 32-bit architecture

James Hogan (1):
      tile,mn10300: add device parameter to dma_cache_sync()

KOSAKI Motohiro (1):
      tile: replace mm->cpu_vm_mask with mm_cpumask()

Oleg Nesterov (1):
      tile: do_hardwall_trap: do not play with task->sighand

Stephen Rothwell (1):
      compat: include aio_abi.h for aio_context_t

 Makefile                                       |    8 +
 arch/tile/Kconfig                              |    8 +
 arch/tile/configs/tile_defconfig               |   71 -
 arch/tile/configs/tilegx_defconfig             | 1833 ++++++++++++++++++++
 arch/tile/configs/tilepro_defconfig            | 1163 +++++++++++++
 arch/tile/include/arch/chip_tilegx.h           |  258 +++
 arch/tile/include/arch/icache.h                |   11 +-
 arch/tile/include/arch/interrupts_64.h         |  276 +++
 arch/tile/include/arch/spr_def.h               |   13 +-
 arch/tile/include/arch/spr_def_64.h            |  173 ++
 arch/tile/include/asm/atomic.h                 |   49 +-
 arch/tile/include/asm/atomic_32.h              |   10 -
 arch/tile/include/asm/atomic_64.h              |  156 ++
 arch/tile/include/asm/backtrace.h              |   82 +-
 arch/tile/include/asm/bitops.h                 |    1 +
 arch/tile/include/asm/bitops_32.h              |    1 -
 arch/tile/include/asm/bitops_64.h              |  105 ++
 arch/tile/include/asm/cacheflush.h             |   18 +-
 arch/tile/include/asm/compat.h                 |    4 +-
 arch/tile/include/asm/dma-mapping.h            |    3 +-
 arch/tile/include/asm/fb.h                     |    1 +
 arch/tile/include/asm/io.h                     |   18 +
 arch/tile/include/asm/irq.h                    |    2 +
 arch/tile/include/asm/mmu_context.h            |    4 +-
 arch/tile/include/asm/opcode-tile_32.h         |    7 +
 arch/tile/include/asm/opcode-tile_64.h         | 1500 +++++++----------
 arch/tile/include/asm/opcode_constants_64.h    | 1043 +++++++-----
 arch/tile/include/asm/page.h                   |   18 +-
 arch/tile/include/asm/parport.h                |    1 +
 arch/tile/include/asm/pci.h                    |    3 +-
 arch/tile/include/asm/pgtable_64.h             |  175 ++
 arch/tile/include/asm/processor.h              |    9 +-
 arch/tile/include/asm/serial.h                 |    1 +
 arch/tile/include/asm/signal.h                 |    4 +
 arch/tile/include/asm/spinlock_64.h            |  161 ++
 arch/tile/include/asm/stat.h                   |    2 +-
 arch/tile/include/asm/swab.h                   |    6 -
 arch/tile/include/asm/thread_info.h            |    5 +-
 arch/tile/include/asm/topology.h               |   75 +-
 arch/tile/include/asm/traps.h                  |    4 +
 arch/tile/include/asm/unistd.h                 |    2 +-
 arch/tile/include/{hv/pagesize.h => asm/vga.h} |   35 +-
 arch/tile/include/hv/hypervisor.h              |   12 +-
 arch/tile/kernel/backtrace.c                   |  103 +-
 arch/tile/kernel/compat.c                      |   13 +-
 arch/tile/kernel/compat_signal.c               |    4 +-
 arch/tile/kernel/futex_64.S                    |   55 +
 arch/tile/kernel/hardwall.c                    |    6 +-
 arch/tile/kernel/head_64.S                     |  269 +++
 arch/tile/kernel/intvec_32.S                   |  175 +--
 arch/tile/kernel/intvec_64.S                   | 1231 +++++++++++++
 arch/tile/kernel/module.c                      |    8 +-
 arch/tile/kernel/pci-dma.c                     |    2 +-
 arch/tile/kernel/pci.c                         |  206 ++-
 arch/tile/kernel/process.c                     |   52 +-
 arch/tile/kernel/regs_64.S                     |  145 ++
 arch/tile/kernel/setup.c                       |    6 +
 arch/tile/kernel/signal.c                      |  128 ++-
 arch/tile/kernel/single_step.c                 |   12 +
 arch/tile/kernel/stack.c                       |   14 +-
 arch/tile/kernel/sys.c                         |    9 -
 arch/tile/kernel/tile-desc_32.c                |   11 +-
 arch/tile/kernel/tile-desc_64.c                | 2200 ++++++++++++++++++++++++
 arch/tile/kernel/time.c                        |    2 +
 arch/tile/kernel/tlb.c                         |   12 +-
 arch/tile/kernel/traps.c                       |    1 +
 arch/tile/lib/atomic_asm_32.S                  |    2 +-
 arch/tile/lib/cacheflush.c                     |   18 +
 arch/tile/lib/memchr_64.c                      |   71 +
 arch/tile/lib/memcpy_64.c                      |  220 +++
 arch/tile/lib/memcpy_user_64.c                 |   86 +
 arch/tile/lib/memset_64.c                      |  145 ++
 arch/tile/lib/spinlock_64.c                    |  104 ++
 arch/tile/lib/strchr_64.c                      |   67 +
 arch/tile/lib/strlen_64.c                      |   38 +
 arch/tile/lib/usercopy_64.S                    |  196 +++
 arch/tile/mm/fault.c                           |   30 +-
 arch/tile/mm/migrate_64.S                      |  187 ++
 drivers/input/input-compat.h                   |    2 +-
 drivers/net/tile/tilepro.c                     |    8 +-
 drivers/rtc/Kconfig                            |    7 +
 drivers/rtc/Makefile                           |    1 +
 drivers/rtc/rtc-tile.c                         |  162 ++
 include/asm-generic/audit_change_attr.h        |    4 +
 include/asm-generic/audit_dir_write.h          |   14 +
 include/asm-generic/audit_read.h               |    5 +
 include/asm-generic/audit_write.h              |    2 +
 include/asm-generic/unistd.h                   |  221 ++--
 include/linux/compat.h                         |  236 +++-
 kernel/compat.c                                |    8 +
 kernel/sysctl.c                                |    2 +-
 lib/audit.c                                    |    2 +
 92 files changed, 11799 insertions(+), 2034 deletions(-)
 delete mode 100644 arch/tile/configs/tile_defconfig
 create mode 100644 arch/tile/configs/tilegx_defconfig
 create mode 100644 arch/tile/configs/tilepro_defconfig
 create mode 100644 arch/tile/include/arch/chip_tilegx.h
 create mode 100644 arch/tile/include/arch/interrupts_64.h
 create mode 100644 arch/tile/include/arch/spr_def_64.h
 create mode 100644 arch/tile/include/asm/atomic_64.h
 create mode 100644 arch/tile/include/asm/bitops_64.h
 create mode 100644 arch/tile/include/asm/fb.h
 create mode 100644 arch/tile/include/asm/parport.h
 create mode 100644 arch/tile/include/asm/pgtable_64.h
 create mode 100644 arch/tile/include/asm/serial.h
 create mode 100644 arch/tile/include/asm/spinlock_64.h
 rename arch/tile/include/{hv/pagesize.h => asm/vga.h} (52%)
 create mode 100644 arch/tile/kernel/futex_64.S
 create mode 100644 arch/tile/kernel/head_64.S
 create mode 100644 arch/tile/kernel/intvec_64.S
 create mode 100644 arch/tile/kernel/regs_64.S
 create mode 100644 arch/tile/kernel/tile-desc_64.c
 create mode 100644 arch/tile/lib/memchr_64.c
 create mode 100644 arch/tile/lib/memcpy_64.c
 create mode 100644 arch/tile/lib/memcpy_user_64.c
 create mode 100644 arch/tile/lib/memset_64.c
 create mode 100644 arch/tile/lib/spinlock_64.c
 create mode 100644 arch/tile/lib/strchr_64.c
 create mode 100644 arch/tile/lib/strlen_64.c
 create mode 100644 arch/tile/lib/usercopy_64.S
 create mode 100644 arch/tile/mm/migrate_64.S
 create mode 100644 drivers/rtc/rtc-tile.c

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


