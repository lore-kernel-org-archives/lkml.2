Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0G0RUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:20:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35310 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0G0RUG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Jul 2010 13:20:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, alex.williamson@redhat.com
Subject: [PATCH] Xen-SWIOTLB v0.8.6 used for Xen PCI pass through for PV guests.
Date: Tue, 27 Jul 2010 12:59:53 -0400
Message-Id: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C4F1532.014E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since last posting [v0.8.3 (http://lkml.org/lkml/2010/6/22/310)]:
 - Coalesced the Xen-SWIOTLB set of patches in one patch.
 - Moved the swiotlb-xen.c to drivers/xen.
 - Added Ack's, Cc's, as appropriate.

This patchset:

These nine patches lay the groundwork for Xen Paravirtualized (PV)
domains to access PCI pass-through devices (with and without an hardware
IOMMU) These patches utilize the SWIOTLB library modifications
(http://lkml.org/lkml/2010/6/4/272).

The end user of this are:
 - The Xen PCI frontend and Xen PCI [1] which require a DMA API "backend"
   that understands Xen's MMU. This allows the PV domains to use PCI devices.
   The use case is for machines with and without hardware IOMMU. Without an
   hardware IOMMU you have a potential security hole wherin a guest domain
   can use the hardware to map pages outside its memory range and slurp
   pages up. As such, this is more restricted to a Priviliged PV domain,
   aka - device driver domain (similar to Qubes but a poor-man mechanism [2]).
 - Xen PV domain 0 support. Without this domain 0 is incapable of using any
   PCI devices.

This patch-set is split in two groups. The first alter the Xen components,
while the second introduces the SWIOTLB-Xen.

The Xen components patches consist of:

      xen: Allow unprivileged Xen domains to create iomap pages
      xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      xen: use _PAGE_IOMAP in ioremap to do machine mappings
      vmap: add flag to allow lazy unmap to be disabled at runtime
      xen/mmu: inhibit vmap aliases rather than trying to clear them out

which alter the Xen MMU, which by default utilizes a layer of indirection
wherein the PFN is translated to the Machine Frame Number (MFN) and vice-versa.
This is required to "fool" the guest in thinking its memory starts at PFN 0 and
goes up to the available amount.  While in the background, PFN 0 might as well be
MFN 1048576 (4GB).

For PCI/DMA API calls (ioremap, pci_map_page, etc) having a PFN != MFN is
not too good, so two new mechanisms are introduced:
  a). For PTEs which manipulate the PCI/DMA pages the PFN == MFN. This is done
      via utilizing the _PAGE_IOMAP flag to distinguish the PTE as an IO type.
  b). Allow a mechanism to "swizzle" the MFN's under a PFN to be under a certain
      bus width (say 32). This allows us to provide a mechanism for the
      SWIOTLB Xen to allocate memory for its pool that will be guaranteed to be
      under the 4GB mark.

We also introduce a mechanism to inhibit vmap aliases as we need to clear the
vmap's but might be doing this in atomic state.

The SWIOTLB-Xen adds a library that is only used if the machine is detected
to be running under Xen. It utilizes the SWIOTLB library bookkeeping functions
(swiotlb_tbl_*) and only deals with the virtual to [physical, bus] (and vice-versa)
address translations.

The diffstat:

 arch/x86/include/asm/xen/page.h        |    8 +-
 arch/x86/include/asm/xen/swiotlb-xen.h |   14 +
 arch/x86/kernel/pci-dma.c              |    7 +-
 arch/x86/xen/Makefile                  |    1 +
 arch/x86/xen/enlighten.c               |    4 +
 arch/x86/xen/mmu.c                     |  293 ++++++++++++++++++-
 arch/x86/xen/pci-swiotlb-xen.c         |   58 ++++
 drivers/xen/Kconfig                    |    4 +
 drivers/xen/Makefile                   |    3 +-
 drivers/xen/balloon.c                  |   15 +-
 drivers/xen/swiotlb-xen.c              |  515 ++++++++++++++++++++++++++++++++
 include/linux/vmalloc.h                |    2 +
 include/xen/interface/memory.h         |   50 +++
 include/xen/swiotlb-xen.h              |   65 ++++
 include/xen/xen-ops.h                  |    6 +
 mm/vmalloc.c                           |    4 +
 16 files changed, 1024 insertions(+), 25 deletions(-)

P.S.
The patchset that this depends on (which is in linux-next), is:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git stable/swiotlb-0.8.3
This patcheset (Xen-SWIOTLB) is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/xen-swiotlb-0.8.6
And the customer of this (Xen PCI front):
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pcifront-0.3
The tree with all of this on top of v2.6.35-rc6:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/merge.2.6.35-rc6.t2

