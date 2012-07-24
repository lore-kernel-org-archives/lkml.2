Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2GXBKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:10:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45824 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab2GXBKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:03 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [RFC 00/23] Introducing the TI Keystone platform
Date: Mon, 23 Jul 2012 21:09:02 -0400
Message-ID: <1343092165-9470-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI's scalable KeyStone II architecture includes support for both TMS320C66x
floating point DSPs and ARM Cortex-A15 clusters, for a mixture of up to 32
cores per SoC.  The solution is optimized around a high performance chip
interconnect and a rich set of on chip peripherals.  Please refer [1] for
initial technical documentation on these devices.

This patch series provides a basic Linux port for these devices, including
support for SMP, and LPAE boot.  A majority of the patches in this series are
related to LPAE functionality, imposed by the device architecture which has
system memory mapped at an address above the 4G 32-bit addressable limit.

This patch series is based on the v3.5 kernel with the smp_ops patch set
applied on top.  This series is being posted to elicit early feedback, and so
that some of these fixes may get incorporated early on into the kernel code.

  [1] - http://www.ti.com/product/tms320tci6636


Cyril Chemparathy (17):
  ARM: LPAE: use signed arithmetic for mask definitions
  ARM: LPAE: use phys_addr_t on virt <--> phys conversion
  ARM: LPAE: use phys_addr_t for membank size
  ARM: LPAE: use 64-bit pgd physical address in switch_mm()
  ARM: LPAE: use 64-bit accessors for TTBR registers
  ARM: mm: use physical addresses in highmem sanity checks
  ARM: mm: cleanup checks for membank overlap with vmalloc area
  ARM: mm: clean up membank size limit checks
  ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
  ARM: LPAE: factor out T1SZ and TTBR1 computations
  ARM: LPAE: allow proc override of TTB setup
  ARM: LPAE: accomodate >32-bit addresses for page table base
  ARM: add machine desc hook for early memory/paging initialization
  drivers: cma: fix addressing on PAE machines
  ARM: keystone: introducing TI Keystone platform
  ARM: keystone: enable SMP on Keystone machines
  ARM: keystone: add switch over to high physical address range

Vitaly Andrianov (6):
  ARM: LPAE: disable phys-to-virt patching on PAE systems
  ARM: LPAE: use phys_addr_t in alloc_init_pud()
  ARM: LPAE: use phys_addr_t in free_memmap()
  ARM: LPAE: use phys_addr_t for initrd location and size
  ARM: add virt_to_idmap for interconnect aliasing
  mm: bootmem: use phys_addr_t for physical addresses

 arch/arm/Kconfig                                  |   20 +++
 arch/arm/Makefile                                 |    1 +
 arch/arm/boot/dts/keystone-sim.dts                |   77 +++++++++
 arch/arm/configs/keystone_defconfig               |   23 +++
 arch/arm/include/asm/cache.h                      |    9 ++
 arch/arm/include/asm/mach/arch.h                  |    1 +
 arch/arm/include/asm/memory.h                     |   28 +++-
 arch/arm/include/asm/page.h                       |    7 +-
 arch/arm/include/asm/pgtable-3level-hwdef.h       |   10 ++
 arch/arm/include/asm/pgtable-3level.h             |    6 +-
 arch/arm/include/asm/proc-fns.h                   |   28 +++-
 arch/arm/include/asm/setup.h                      |    4 +-
 arch/arm/kernel/head.S                            |   18 ++-
 arch/arm/kernel/setup.c                           |    3 +
 arch/arm/kernel/smp.c                             |   11 +-
 arch/arm/mach-keystone/Makefile                   |    2 +
 arch/arm/mach-keystone/Makefile.boot              |    1 +
 arch/arm/mach-keystone/include/mach/debug-macro.S |   44 +++++
 arch/arm/mach-keystone/include/mach/entry-macro.S |   20 +++
 arch/arm/mach-keystone/include/mach/io.h          |   22 +++
 arch/arm/mach-keystone/include/mach/memory.h      |   51 ++++++
 arch/arm/mach-keystone/include/mach/system.h      |   30 ++++
 arch/arm/mach-keystone/include/mach/timex.h       |   21 +++
 arch/arm/mach-keystone/include/mach/uncompress.h  |   24 +++
 arch/arm/mach-keystone/include/mach/vmalloc.h     |   21 +++
 arch/arm/mach-keystone/keystone.c                 |  178 +++++++++++++++++++++
 arch/arm/mach-keystone/platsmp.c                  |   94 +++++++++++
 arch/arm/mm/context.c                             |   13 +-
 arch/arm/mm/idmap.c                               |    4 +-
 arch/arm/mm/init.c                                |   20 +--
 arch/arm/mm/mmu.c                                 |   49 ++----
 arch/arm/mm/proc-arm1026.S                        |    3 +
 arch/arm/mm/proc-mohawk.S                         |    3 +
 arch/arm/mm/proc-v6.S                             |    6 +-
 arch/arm/mm/proc-v7-2level.S                      |    7 +-
 arch/arm/mm/proc-v7-3level.S                      |   29 ++--
 arch/arm/mm/proc-v7.S                             |    2 +
 arch/arm/mm/proc-xsc3.S                           |    3 +
 drivers/base/dma-contiguous.c                     |    4 +-
 include/linux/bootmem.h                           |   30 ++--
 mm/bootmem.c                                      |   59 +++----
 41 files changed, 840 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm/boot/dts/keystone-sim.dts
 create mode 100644 arch/arm/configs/keystone_defconfig
 create mode 100644 arch/arm/mach-keystone/Makefile
 create mode 100644 arch/arm/mach-keystone/Makefile.boot
 create mode 100644 arch/arm/mach-keystone/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-keystone/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-keystone/include/mach/io.h
 create mode 100644 arch/arm/mach-keystone/include/mach/memory.h
 create mode 100644 arch/arm/mach-keystone/include/mach/system.h
 create mode 100644 arch/arm/mach-keystone/include/mach/timex.h
 create mode 100644 arch/arm/mach-keystone/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-keystone/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-keystone/keystone.c
 create mode 100644 arch/arm/mach-keystone/platsmp.c

-- 
1.7.9.5

