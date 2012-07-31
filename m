Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2GaXGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:06:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41483 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab2GaXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:06:03 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH 00/22] Introducing the TI Keystone platform
Date: Tue, 31 Jul 2012 19:04:36 -0400
Message-ID: <1343775898-28345-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a follow on to the RFC series posted earlier (archived at [1]).
The major change introduced here is the modification to the kernel patching
mechanism for phys_to_virt/virt_to_phys, in order to support LPAE platforms
that require late patching.  In addition to these changes, we've updated the
series based on feedback from the earlier posting.

Most of the patches in this series are fixes and extensions to LPAE support on
ARM. The last three patches in this series are specific to the TI Keystone
platform, and are being provided here for the sake of completeness.  These
three patches are dependent on the smpops patch set (see [2]), and are not
ready to be merged in as yet.

[1] - https://lkml.org/lkml/2012/7/23/460
[2] - http://permalink.gmane.org/gmane.linux.ports.arm.kernel/171540

Cyril Chemparathy (18):
  ARM: add mechanism for late code patching
  ARM: use late patch framework for phys-virt patching
  ARM: LPAE: use phys_addr_t on virt <--> phys conversion
  ARM: LPAE: support 64-bit virt/phys patching
  ARM: LPAE: use signed arithmetic for mask definitions
  ARM: LPAE: use 64-bit pgd physical address in switch_mm()
  ARM: LPAE: use 64-bit accessors for TTBR registers
  ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
  ARM: LPAE: factor out T1SZ and TTBR1 computations
  ARM: LPAE: allow proc override of TTB setup
  ARM: LPAE: accomodate >32-bit addresses for page table base
  ARM: mm: use physical addresses in highmem sanity checks
  ARM: mm: cleanup checks for membank overlap with vmalloc area
  ARM: mm: clean up membank size limit checks
  ARM: recreate kernel mappings in early_paging_init()
  ARM: keystone: introducing TI Keystone platform
  ARM: keystone: enable SMP on Keystone machines
  ARM: keystone: add switch over to high physical address range

Vitaly Andrianov (4):
  ARM: LPAE: use phys_addr_t in alloc_init_pud()
  ARM: LPAE: use phys_addr_t in free_memmap()
  ARM: LPAE: use phys_addr_t for initrd location and size
  ARM: add virt_to_idmap for interconnect aliasing

 arch/arm/Kconfig                                  |   20 +++
 arch/arm/Makefile                                 |    1 +
 arch/arm/boot/dts/keystone-sim.dts                |   77 +++++++++
 arch/arm/configs/keystone_defconfig               |   23 +++
 arch/arm/include/asm/cache.h                      |    9 +
 arch/arm/include/asm/mach/arch.h                  |    1 +
 arch/arm/include/asm/memory.h                     |   68 +++++---
 arch/arm/include/asm/page.h                       |    2 +-
 arch/arm/include/asm/patch.h                      |  123 +++++++++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h       |   10 ++
 arch/arm/include/asm/pgtable-3level.h             |    6 +-
 arch/arm/include/asm/proc-fns.h                   |   28 ++-
 arch/arm/kernel/head.S                            |  119 +++----------
 arch/arm/kernel/module.c                          |    7 +-
 arch/arm/kernel/setup.c                           |  192 +++++++++++++++++++++
 arch/arm/kernel/smp.c                             |   11 +-
 arch/arm/kernel/vmlinux.lds.S                     |   13 +-
 arch/arm/mach-keystone/Makefile                   |    2 +
 arch/arm/mach-keystone/Makefile.boot              |    1 +
 arch/arm/mach-keystone/include/mach/debug-macro.S |   44 +++++
 arch/arm/mach-keystone/include/mach/memory.h      |   47 +++++
 arch/arm/mach-keystone/include/mach/timex.h       |   21 +++
 arch/arm/mach-keystone/include/mach/uncompress.h  |   24 +++
 arch/arm/mach-keystone/keystone.c                 |  122 +++++++++++++
 arch/arm/mach-keystone/keystone.h                 |   23 +++
 arch/arm/mach-keystone/platsmp.c                  |   88 ++++++++++
 arch/arm/mm/context.c                             |   13 +-
 arch/arm/mm/idmap.c                               |    4 +-
 arch/arm/mm/init.c                                |   20 +--
 arch/arm/mm/mmu.c                                 |  106 ++++++++----
 arch/arm/mm/proc-arm1026.S                        |    3 +
 arch/arm/mm/proc-mohawk.S                         |    3 +
 arch/arm/mm/proc-v6.S                             |    6 +-
 arch/arm/mm/proc-v7-2level.S                      |    7 +-
 arch/arm/mm/proc-v7-3level.S                      |   29 ++--
 arch/arm/mm/proc-v7.S                             |    2 +
 arch/arm/mm/proc-xsc3.S                           |    3 +
 37 files changed, 1065 insertions(+), 213 deletions(-)
 create mode 100644 arch/arm/boot/dts/keystone-sim.dts
 create mode 100644 arch/arm/configs/keystone_defconfig
 create mode 100644 arch/arm/include/asm/patch.h
 create mode 100644 arch/arm/mach-keystone/Makefile
 create mode 100644 arch/arm/mach-keystone/Makefile.boot
 create mode 100644 arch/arm/mach-keystone/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-keystone/include/mach/memory.h
 create mode 100644 arch/arm/mach-keystone/include/mach/timex.h
 create mode 100644 arch/arm/mach-keystone/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-keystone/keystone.c
 create mode 100644 arch/arm/mach-keystone/keystone.h
 create mode 100644 arch/arm/mach-keystone/platsmp.c

-- 
1.7.9.5

