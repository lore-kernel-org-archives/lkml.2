Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0KLSBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50887 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab0KLSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:00:58 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/20] ARM: Add support for the Large Physical Address Extensions
Date: Fri, 12 Nov 2010 18:00:20 +0000
Message-Id: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
X-OriginalArrivalTime: 12 Nov 2010 18:00:48.0016 (UTC) FILETIME=[88FB3900:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches adds support for the Large Physical Extensions on
the ARM architecture (available with the Cortex-A15 processor). LPAE
comes with a 3-level page table format (compared to 2-level for the
classic one), allowing up to 40-bit physical address space.

The ARM LPAE documentation is available from (free registration needed):

http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html

The full set of patches (kernel fixes, LPAE and support for an emulated
Versatile Express with Cortex-A15 tile) is available on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae

Changelog:

- Upgraded to latest mainline kernel (2.6.37-rc1) solving several conflicts.
- Enable CONFIG_ARCH_DMA_ADDR_T_64BIT for future compatibility with the unified
  dma_addr_t patch.
- PHYS_ADDR_FMT printk format changed to be ANSI C compliant.
- Alignment fault now uses SIGBUS instead of SIGILL.
- arch/arm/kernel/head.S modified to use SECTION_SHIFT and reduce the amount of
  #ifdef's.
- setup_mm_for_reboot() modified for LPAE.
- identity_mapping_add/del() modified for LPAE.
- Removed FIRST_USER_PGD_NR definition as the place where it was used have been
  modified.

Any comments are welcome. Thanks.


Catalin Marinas (13):
  ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
  ARM: LPAE: Factor out 2-level page table definitions into separate
    files
  ARM: LPAE: Do not assume Linux PTEs are always at PTRS_PER_PTE offset
  ARM: LPAE: Introduce L_PTE_NOEXEC and L_PTE_NOWRITE
  ARM: LPAE: Introduce the 3-level page table format definitions
  ARM: LPAE: Page table maintenance for the 3-level format
  ARM: LPAE: MMU setup for the 3-level page table format
  ARM: LPAE: Change setup_mm_for_reboot() to work with LPAE
  ARM: LPAE: Remove the FIRST_USER_PGD_NR and USER_PTRS_PER_PGD
    definitions
  ARM: LPAE: Add fault handling support
  ARM: LPAE: Add context switching support
  ARM: LPAE: Add SMP support for the 3-level page table format
  ARM: LPAE: Add the Kconfig entries

Will Deacon (7):
  ARM: LPAE: use u32 instead of unsigned long for 32-bit ptes
  ARM: LPAE: use phys_addr_t instead of unsigned long for physical
    addresses
  ARM: LPAE: Use generic dma_addr_t type definition
  ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
  ARM: LPAE: use phys_addr_t for physical start address in early_mem
  ARM: LPAE: add support for ATAG_MEM64
  ARM: LPAE: define printk format for physical addresses and page table
    entries

 arch/arm/Kconfig                            |    2 +-
 arch/arm/include/asm/cpu-multi32.h          |    8 +
 arch/arm/include/asm/cpu-single.h           |    4 +
 arch/arm/include/asm/memory.h               |   17 +-
 arch/arm/include/asm/outercache.h           |   14 +-
 arch/arm/include/asm/page-nommu.h           |    8 +-
 arch/arm/include/asm/page.h                 |   42 +----
 arch/arm/include/asm/pgalloc.h              |   34 +++-
 arch/arm/include/asm/pgtable-2level-hwdef.h |   91 +++++++++
 arch/arm/include/asm/pgtable-2level-types.h |   64 +++++++
 arch/arm/include/asm/pgtable-2level.h       |  147 +++++++++++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   78 ++++++++
 arch/arm/include/asm/pgtable-3level-types.h |   55 ++++++
 arch/arm/include/asm/pgtable-3level.h       |  110 +++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |   81 +--------
 arch/arm/include/asm/pgtable.h              |  267 +++++++++++----------------
 arch/arm/include/asm/proc-fns.h             |   13 ++
 arch/arm/include/asm/setup.h                |   12 +-
 arch/arm/include/asm/types.h                |   24 +--
 arch/arm/kernel/compat.c                    |    4 +-
 arch/arm/kernel/head.S                      |  106 ++++++++----
 arch/arm/kernel/module.c                    |    2 +-
 arch/arm/kernel/setup.c                     |   19 ++-
 arch/arm/kernel/smp.c                       |   43 ++++-
 arch/arm/mm/Kconfig                         |   13 ++
 arch/arm/mm/alignment.c                     |    8 +-
 arch/arm/mm/context.c                       |   18 ++-
 arch/arm/mm/dma-mapping.c                   |    6 +-
 arch/arm/mm/fault.c                         |   88 +++++++++-
 arch/arm/mm/init.c                          |    6 +-
 arch/arm/mm/ioremap.c                       |    8 +-
 arch/arm/mm/mm.h                            |    8 +-
 arch/arm/mm/mmu.c                           |   99 +++++++---
 arch/arm/mm/pgd.c                           |   20 ++-
 arch/arm/mm/proc-macros.S                   |    5 +-
 arch/arm/mm/proc-v7.S                       |  115 +++++++++++-
 36 files changed, 1213 insertions(+), 426 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-2level.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h

