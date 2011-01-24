Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1AXR4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:17 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50760 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab1AXR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:15 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/19] ARM: Add support for the Large Physical Address Extensions
Date: Mon, 24 Jan 2011 17:55:42 +0000
Message-Id: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
X-OriginalArrivalTime: 24 Jan 2011 17:56:09.0944 (UTC) FILETIME=[FB648D80:01CBBBEF]
X-MC-Unique: 111012417561301901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OHuXLN031549

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

- Rebased on 2.6.38-rc1. This kernel includes Russell's refactoring of
  the page table maintenance.
- PTE_PFN_MASK renamed to PHYS_MASK and some of the functions using this
  macro have been unified between classic and LPAE page table format.
- Fixes for modules/pkmap page table entries - the corresponding PMD is
  preallocated in pgd_alloc() and cleaned-up in pgd_free().
- Identity mapping support following mainline changes.


Catalin Marinas (14):
  ARM: Make the argument to virt_to_phys() "const volatile"
  ARM: LPAE: Fix early_pte_alloc() assumption about the Linux PTE
  ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
  ARM: LPAE: Factor out 2-level page table definitions into separate
    files
  ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
  ARM: LPAE: Use a mask for physical addresses in page table entries
  ARM: LPAE: Introduce the 3-level page table format definitions
  ARM: LPAE: Page table maintenance for the 3-level format
  ARM: LPAE: MMU setup for the 3-level page table format
  ARM: LPAE: Add fault handling support
  ARM: LPAE: Add context switching support
  ARM: LPAE: Add identity mapping support for the 3-level page table
    format
  ARM: LPAE: Add SMP support for the 3-level page table format
  ARM: LPAE: Add the Kconfig entries

Will Deacon (5):
  ARM: LPAE: use long long format when printing physical addresses and
    ptes
  ARM: LPAE: use phys_addr_t instead of unsigned long for physical
    addresses
  ARM: LPAE: Use generic dma_addr_t type definition
  ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
  ARM: LPAE: add support for ATAG_MEM64

 arch/arm/Kconfig                            |    2 +-
 arch/arm/include/asm/cpu-multi32.h          |    8 +
 arch/arm/include/asm/cpu-single.h           |    4 +
 arch/arm/include/asm/memory.h               |   17 +-
 arch/arm/include/asm/outercache.h           |   14 +-
 arch/arm/include/asm/page.h                 |   44 +-----
 arch/arm/include/asm/pgalloc.h              |   28 ++++-
 arch/arm/include/asm/pgtable-2level-hwdef.h |   93 ++++++++++++
 arch/arm/include/asm/pgtable-2level-types.h |   67 +++++++++
 arch/arm/include/asm/pgtable-2level.h       |  148 +++++++++++++++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   81 ++++++++++
 arch/arm/include/asm/pgtable-3level-types.h |   68 +++++++++
 arch/arm/include/asm/pgtable-3level.h       |  106 ++++++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |   81 +----------
 arch/arm/include/asm/pgtable.h              |  211 +++++++++------------------
 arch/arm/include/asm/proc-fns.h             |   13 ++
 arch/arm/include/asm/setup.h                |   12 ++-
 arch/arm/include/asm/tlbflush.h             |    4 +-
 arch/arm/include/asm/types.h                |   20 +---
 arch/arm/kernel/compat.c                    |    4 +-
 arch/arm/kernel/head.S                      |  125 +++++++++++-----
 arch/arm/kernel/module.c                    |    2 +-
 arch/arm/kernel/setup.c                     |   19 ++-
 arch/arm/kernel/traps.c                     |    6 +-
 arch/arm/mm/Kconfig                         |   13 ++
 arch/arm/mm/alignment.c                     |    8 +-
 arch/arm/mm/context.c                       |   18 ++-
 arch/arm/mm/dma-mapping.c                   |    6 +-
 arch/arm/mm/fault.c                         |   90 +++++++++++-
 arch/arm/mm/idmap.c                         |   39 ++++--
 arch/arm/mm/init.c                          |    6 +-
 arch/arm/mm/ioremap.c                       |    8 +-
 arch/arm/mm/mm.h                            |    4 +-
 arch/arm/mm/mmu.c                           |   88 ++++++++----
 arch/arm/mm/pgd.c                           |   64 ++++++--
 arch/arm/mm/proc-macros.S                   |    5 +-
 arch/arm/mm/proc-v7.S                       |  120 ++++++++++++++--
 37 files changed, 1212 insertions(+), 434 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-2level.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h


