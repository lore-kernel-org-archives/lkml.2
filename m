Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2EVHkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:40:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35818 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2EVHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:40:34 -0400
Date: Tue, 22 May 2012 09:40:17 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] CMA and ARM DMA-mapping updates for v3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1337672417-10065-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.10
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling Contiguous Memory Allocator (CMA) and
ARM DMA-mapping framework updates for v3.5.

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

with the top-most commit 0f51596bd39a5c928307ffcffc9ba07f90f42a8b

  Merge branch 'for-next-arm-dma' into for-linus

are available in the git repository at:
  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-linus


These patches contains 2 major updates for DMA mapping subsystem (mainly
for ARM architecture). First one is Contiguous Memory Allocator (CMA)
which makes it possible for device drivers to allocate big contiguous
chunks of memory after the system has booted. 

The main difference from the similar frameworks is the fact that CMA
allows to transparently reuse memory region reserved for the big chunk
allocation as a system memory, so no memory is wasted when no big chunk
is allocated. Once the alloc request is issued, the framework migrates
system pages to create a space for the required big chunk of physically
contiguous memory.

For more information one can refer to nice LWN articles:
'A reworked contiguous memory allocator': http://lwn.net/Articles/447405/
'CMA and ARM': http://lwn.net/Articles/450286/
'A deep dive into CMA': http://lwn.net/Articles/486301/
and the following thread with the patches and links to all previous versions:
https://lkml.org/lkml/2012/4/3/204

The main client for this new framework is ARM DMA-mapping subsystem.

The second part provides a complete redesign in ARM DMA-mapping
subsystem. The core implementation has been changed to use common struct
dma_map_ops based infrastructure with the recent updates for new dma
attributes merged in v3.4-rc2. This allows to use more than one
implementation of dma-mapping calls and change/select them on the struct
device basis. The first client of this new infractructure is dmabounce
implementation which has been completely cut out of the core, common
code.

The last patch of this redesign update introduces a new, experimental
implementation of dma-mapping calls on top of generic IOMMU framework.
This lets ARM sub-platform to transparently use IOMMU for DMA-mapping
calls if one provides required IOMMU hardware.

For more information please refer to the following thread:
http://www.spinics.net/lists/arm-kernel/msg175729.html

The last patch merges changes from both updates and provides a
resolution for the conflicts which cannot be avoided when patches have
been applied on the same files (mainly arch/arm/mm/dma-mapping.c).

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (17):
      common: add dma_mmap_from_coherent() function
      ARM: dma-mapping: use dma_mmap_from_coherent()
      ARM: dma-mapping: use pr_* instread of printk
      ARM: dma-mapping: introduce DMA_ERROR_CODE constant
      ARM: dma-mapping: remove offset parameter to prepare for generic dma_ops
      ARM: dma-mapping: use asm-generic/dma-mapping-common.h
      ARM: dma-mapping: implement dma sg methods on top of any generic dma ops
      ARM: dma-mapping: move all dma bounce code to separate dma ops structure
      ARM: dma-mapping: remove redundant code and do the cleanup
      ARM: dma-mapping: use alloc, mmap, free from dma_ops
      ARM: dma-mapping: add support for IOMMU mapper
      mm: extract reclaim code from __alloc_pages_direct_reclaim()
      mm: trigger page reclaim in alloc_contig_range() to stabilise watermarks
      drivers: add Contiguous Memory Allocator
      X86: integrate CMA with DMA-mapping subsystem
      ARM: integrate CMA with DMA-mapping subsystem
      Merge branch 'for-next-arm-dma' into for-linus

Mel Gorman (1):
      mm: Serialize access to min_free_kbytes

Michal Nazarewicz (9):
      mm: page_alloc: remove trailing whitespace
      mm: compaction: introduce isolate_migratepages_range()
      mm: compaction: introduce map_pages()
      mm: compaction: introduce isolate_freepages_range()
      mm: compaction: export some of the functions
      mm: page_alloc: introduce alloc_contig_range()
      mm: page_alloc: change fallbacks array handling
      mm: mmzone: MIGRATE_CMA migration type added
      mm: page_isolation: MIGRATE_CMA isolation functions added

Minchan Kim (1):
      cma: fix migration mode

Vitaly Andrianov (1):
      ARM: dma-mapping: use PMD size for section unmap

 Documentation/kernel-parameters.txt   |    9 +
 arch/Kconfig                          |    3 +
 arch/arm/Kconfig                      |   11 +
 arch/arm/common/dmabounce.c           |   84 ++-
 arch/arm/include/asm/device.h         |    4 +
 arch/arm/include/asm/dma-contiguous.h |   15 +
 arch/arm/include/asm/dma-iommu.h      |   34 +
 arch/arm/include/asm/dma-mapping.h    |  407 +++--------
 arch/arm/include/asm/mach/map.h       |    1 +
 arch/arm/kernel/setup.c               |    9 +-
 arch/arm/mm/dma-mapping.c             | 1348 ++++++++++++++++++++++++++++-----
 arch/arm/mm/init.c                    |   23 +-
 arch/arm/mm/mm.h                      |    3 +
 arch/arm/mm/mmu.c                     |   31 +-
 arch/arm/mm/vmregion.h                |    2 +-
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/dma-contiguous.h |   13 +
 arch/x86/include/asm/dma-mapping.h    |    5 +
 arch/x86/kernel/pci-dma.c             |   18 +-
 arch/x86/kernel/pci-nommu.c           |    8 +-
 arch/x86/kernel/setup.c               |    2 +
 drivers/base/Kconfig                  |   89 +++
 drivers/base/Makefile                 |    1 +
 drivers/base/dma-coherent.c           |   42 +
 drivers/base/dma-contiguous.c         |  401 ++++++++++
 include/asm-generic/dma-coherent.h    |    4 +-
 include/asm-generic/dma-contiguous.h  |   28 +
 include/linux/device.h                |    4 +
 include/linux/dma-contiguous.h        |  110 +++
 include/linux/gfp.h                   |   12 +
 include/linux/mmzone.h                |   47 +-
 include/linux/page-isolation.h        |   18 +-
 mm/Kconfig                            |    2 +-
 mm/Makefile                           |    3 +-
 mm/compaction.c                       |  418 +++++++----
 mm/internal.h                         |   33 +
 mm/memory-failure.c                   |    2 +-
 mm/memory_hotplug.c                   |    6 +-
 mm/page_alloc.c                       |  409 +++++++++--
 mm/page_isolation.c                   |   15 +-
 mm/vmstat.c                           |    3 +
 41 files changed, 2898 insertions(+), 780 deletions(-)
 create mode 100644 arch/arm/include/asm/dma-contiguous.h
 create mode 100644 arch/arm/include/asm/dma-iommu.h
 create mode 100644 arch/x86/include/asm/dma-contiguous.h
 create mode 100644 drivers/base/dma-contiguous.c
 create mode 100644 include/asm-generic/dma-contiguous.h
 create mode 100644 include/linux/dma-contiguous.h
