Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2C2Mto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:49:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19625 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab2C2Mtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:49:36 -0400
Date: Thu, 29 Mar 2012 14:46:54 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping framework updates for 3.4 (2nd try)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1333025214-10199-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask again for pulling the dma-mapping framework updates for v3.4.

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

with the top-most commit 64d70fe5d3640e1a89790ed21120921278f8cb86

  common: DMA-mapping: add NON-CONSISTENT attribute

from the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-linus

This is an updated version of the patches which have been earlier rejected,
see the following thread:

https://lkml.org/lkml/2012/3/20/29

I hope I've fixed the issues pointed there:
- collected a few more acks from arch maintainers,
- resolved signed-off-by weirdness,
- removed dependences between the patches.

Short summary for the whole series:

A few limitations have been identified in the current dma-mapping design and 
its implementations for various architectures. There exist more than one function
for allocating and freeing the buffers: currently these 3 are used dma_{alloc,
free}_coherent, dma_{alloc,free}_writecombine, dma_{alloc,free}_noncoherent.

For most of the systems these calls are almost equivalent and can be interchanged.
For others, especially the truly non-coherent ones (like ARM), the difference can
be easily noticed in overall driver performance. Sadly not all architectures 
provide implementations for all of them, so the drivers might need to be adapted 
and cannot be easily shared between different architectures. The provided patches
unify all these functions and hide the differences under the already existing
dma attributes concept. The thread with more references is available here: 
http://www.spinics.net/lists/linux-sh/msg09777.html

These patches are also a prerequisite for unifying DMA-mapping implementation
on ARM architecture with the common one provided by dma_map_ops structure and 
extending it with IOMMU support. More information is available in the following 
thread: http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819

More works on dma-mapping framework are planned, especially in the area of buffer
sharing and managing the shared mappings (together with the recently introduced 
dma_buf interface: commit d15bd7ee445d0702ad801fdaece348fdb79e6581 "dma-buf: 
Introduce dma buffer sharing mechanism").

The patches in the current set introduce a new alloc/free methods (with
support for memory attributes) in dma_map_ops structure, which will
later replace dma_alloc_coherent and dma_alloc_writecombine functions.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Andrzej Pietrasiewicz (8):
      X86 & IA64: adapt for dma_map_ops changes
      MIPS: adapt for dma_map_ops changes
      PowerPC: adapt for dma_map_ops changes
      SPARC: adapt for dma_map_ops changes
      Alpha: adapt for dma_map_ops changes
      SH: adapt for dma_map_ops changes
      Microblaze: adapt for dma_map_ops changes
      Unicore32: adapt for dma_map_ops changes

Marek Szyprowski (6):
      common: dma-mapping: introduce generic alloc() and free() methods
      Hexagon: adapt for dma_map_ops changes
      common: dma-mapping: remove old alloc_coherent and free_coherent methods
      common: dma-mapping: introduce mmap method
      common: DMA-mapping: add WRITE_COMBINE attribute
      common: DMA-mapping: add NON-CONSISTENT attribute

 Documentation/DMA-attributes.txt          |   18 ++++++++++++++++++
 arch/alpha/include/asm/dma-mapping.h      |   18 ++++++++++++------
 arch/alpha/kernel/pci-noop.c              |   10 ++++++----
 arch/alpha/kernel/pci_iommu.c             |   10 ++++++----
 arch/hexagon/include/asm/dma-mapping.h    |   18 ++++++++++++------
 arch/hexagon/kernel/dma.c                 |    9 +++++----
 arch/ia64/hp/common/sba_iommu.c           |   11 ++++++-----
 arch/ia64/include/asm/dma-mapping.h       |   18 ++++++++++++------
 arch/ia64/kernel/pci-swiotlb.c            |   14 +++++++++++---
 arch/ia64/sn/pci/pci_dma.c                |    9 +++++----
 arch/microblaze/include/asm/dma-mapping.h |   18 ++++++++++++------
 arch/microblaze/kernel/dma.c              |   10 ++++++----
 arch/mips/cavium-octeon/dma-octeon.c      |   12 ++++++------
 arch/mips/include/asm/dma-mapping.h       |   18 ++++++++++++------
 arch/mips/mm/dma-default.c                |    8 ++++----
 arch/powerpc/include/asm/dma-mapping.h    |   24 ++++++++++++++++--------
 arch/powerpc/kernel/dma-iommu.c           |   10 ++++++----
 arch/powerpc/kernel/dma-swiotlb.c         |    4 ++--
 arch/powerpc/kernel/dma.c                 |   10 ++++++----
 arch/powerpc/kernel/ibmebus.c             |   10 ++++++----
 arch/powerpc/kernel/vio.c                 |   14 ++++++++------
 arch/powerpc/platforms/cell/iommu.c       |   16 +++++++++-------
 arch/powerpc/platforms/ps3/system-bus.c   |   13 +++++++------
 arch/sh/include/asm/dma-mapping.h         |   28 ++++++++++++++++++----------
 arch/sh/kernel/dma-nommu.c                |    4 ++--
 arch/sh/mm/consistent.c                   |    6 ++++--
 arch/sparc/include/asm/dma-mapping.h      |   18 ++++++++++++------
 arch/sparc/kernel/iommu.c                 |   10 ++++++----
 arch/sparc/kernel/ioport.c                |   18 ++++++++++--------
 arch/sparc/kernel/pci_sun4v.c             |    9 +++++----
 arch/unicore32/include/asm/dma-mapping.h  |   18 ++++++++++++------
 arch/unicore32/mm/dma-swiotlb.c           |   18 ++++++++++++++++--
 arch/x86/include/asm/dma-mapping.h        |   26 ++++++++++++++++----------
 arch/x86/kernel/amd_gart_64.c             |   11 ++++++-----
 arch/x86/kernel/pci-calgary_64.c          |    9 +++++----
 arch/x86/kernel/pci-dma.c                 |    3 ++-
 arch/x86/kernel/pci-nommu.c               |    6 +++---
 arch/x86/kernel/pci-swiotlb.c             |   17 +++++++++++++----
 arch/x86/xen/pci-swiotlb-xen.c            |    4 ++--
 drivers/iommu/amd_iommu.c                 |   10 ++++++----
 drivers/iommu/intel-iommu.c               |    9 +++++----
 drivers/xen/swiotlb-xen.c                 |    5 +++--
 include/linux/dma-attrs.h                 |    2 ++
 include/linux/dma-mapping.h               |   13 +++++++++----
 include/xen/swiotlb-xen.h                 |    6 ++++--
 45 files changed, 354 insertions(+), 198 deletions(-)
