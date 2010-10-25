Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0JYI7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:59:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46301 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab0JYI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:59:44 -0400
Subject: [RFC PATCH 00/18] ARM: Add support for the Large Physical Address
 Extensions
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 09:59:33 +0100
Message-ID: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 08:59:33.0864 (UTC) FILETIME=[F1715E80:01CB7422]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches adds support for the Large Physical Extensions on
the ARM architecture (available with the Cortex-A15 processor). LPAE
comes with a 3-level page table format (compared to 2-level for the
classic one), allowing up to 40-bit physical address space.

These patches split the arch/arm/ page table definitions into
corresponding 2-level and 3-level files and ensure that the common code
works with both variants.  They also fix assumptions regarding the size
of the physical address.  The outer cache support is currently
restricted to 32-bit physical addresses.

The LPAE page table format uses the simplified permission model (as
described in the ARM ARM) and domains are no longer available (requiring
an additional patch which is already in RMK's patch system).

The ARM LPAE documentation is available from (free registration needed):

http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html

The full set of patches (kernel fixes, LPAE and support for an emulated
Versatile Express with Cortex-A15 tile) is available on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae

Any comments are welcome. Thanks.


Catalin Marinas (11):
      ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
      ARM: LPAE: Factor out 2-level page table definitions into separate files
      ARM: LPAE: Do not assume Linux PTEs are always at PTRS_PER_PTE offset
      ARM: LPAE: Introduce L_PTE_NOEXEC and L_PTE_NOWRITE
      ARM: LPAE: Introduce the 3-level page table format definitions
      ARM: LPAE: Page table maintenance for the 3-level format
      ARM: LPAE: MMU setup for the 3-level page table format
      ARM: LPAE: Add fault handling support
      ARM: LPAE: Add context switching support
      ARM: LPAE: Add SMP support for the 3-level page table format
      ARM: LPAE: Add the Kconfig entries

Will Deacon (7):
      ARM: LPAE: use u32 instead of unsigned long for 32-bit ptes
      ARM: LPAE: use phys_addr_t instead of unsigned long for physical addresses
      ARM: LPAE: ensure dma_addr_t is the same size as phys_addr_t
      ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
      ARM: LPAE: use phys_addr_t for physical start address in early_mem
      ARM: LPAE: add support for ATAG_MEM64
      ARM: LPAE: define printk format for physical addresses and page table entries


 arch/arm/include/asm/cpu-multi32.h          |    8 +
 arch/arm/include/asm/cpu-single.h           |    4 
 arch/arm/include/asm/memory.h               |   17 +-
 arch/arm/include/asm/outercache.h           |   14 +
 arch/arm/include/asm/page-nommu.h           |    8 -
 arch/arm/include/asm/page.h                 |   42 ----
 arch/arm/include/asm/pgalloc.h              |   34 +++
 arch/arm/include/asm/pgtable-2level-hwdef.h |   91 +++++++++
 arch/arm/include/asm/pgtable-2level-types.h |   64 ++++++
 arch/arm/include/asm/pgtable-2level.h       |  150 +++++++++++++++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   78 ++++++++
 arch/arm/include/asm/pgtable-3level-types.h |   55 ++++++
 arch/arm/include/asm/pgtable-3level.h       |  113 +++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |   81 +-------
 arch/arm/include/asm/pgtable.h              |  267 +++++++++++----------------
 arch/arm/include/asm/proc-fns.h             |   13 +
 arch/arm/include/asm/setup.h                |   12 +
 arch/arm/include/asm/types.h                |   25 +--
 arch/arm/kernel/compat.c                    |    4 
 arch/arm/kernel/head.S                      |   87 +++++++--
 arch/arm/kernel/module.c                    |    2 
 arch/arm/kernel/setup.c                     |   19 ++
 arch/arm/kernel/smp.c                       |   36 +++-
 arch/arm/mm/Kconfig                         |   10 +
 arch/arm/mm/alignment.c                     |    8 +
 arch/arm/mm/context.c                       |   18 ++
 arch/arm/mm/dma-mapping.c                   |    6 -
 arch/arm/mm/fault.c                         |   88 ++++++++-
 arch/arm/mm/init.c                          |    9 +
 arch/arm/mm/ioremap.c                       |    8 +
 arch/arm/mm/mm.h                            |    8 -
 arch/arm/mm/mmu.c                           |   94 ++++++----
 arch/arm/mm/pgd.c                           |   18 +-
 arch/arm/mm/proc-macros.S                   |    5 -
 arch/arm/mm/proc-v7.S                       |  102 ++++++++++
 35 files changed, 1193 insertions(+), 405 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-2level.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h

-- 
Catalin
