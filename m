Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0FVTs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:48:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51725 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0FVTqr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Subject: [PATCH] Xen-SWIOTBL v0.8.3 used for Xen PCI pass through for PV guests.
Date: Tue, 22 Jun 2010 15:42:33 -0400
Message-Id: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C2112D1.022F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These nineteen patches lay the groundwork for Xen Paravirtualized (PV)
domains to access PCI pass-through devices. These patches utilize the
SWIOTLB library modifications (http://lkml.org/lkml/2010/6/4/272).

The end user of this is the Xen PCI frontend and Xen PCI [1] which
require a DMA API "backend" that understands Xen's MMU. This allows the
PV domains to use PCI devices.

This patch-set is split in two groups. The first alter the Xen components,
while the second introduces the SWIOTLB-Xen.

The Xen components patches consist of:

 [PATCH 01/19] xen: use _PAGE_IOMAP in ioremap to do machine mappings
 [PATCH 02/19] xen: Allow unprivileged Xen domains to create iomap pages
 [PATCH 03/19] xen: Rename the balloon lock
 [PATCH 04/19] xen: Add xen_create_contiguous_region

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

The SWIOTLB-Xen adds a library that is only used if the machine is detected
to be running under Xen. It utilizes the SWIOTLB library bookkeeping functions
(swiotlb_tbl_*) and only deals with the virtual to [physical, bus] (and vice-versa)
address translations.

The diffstat:

 arch/x86/include/asm/xen/page.h        |    8 +-
 arch/x86/include/asm/xen/swiotlb-xen.h |   14 +
 arch/x86/kernel/pci-dma.c              |    7 +-
 arch/x86/xen/Kconfig                   |    4 +
 arch/x86/xen/Makefile                  |    1 +
 arch/x86/xen/enlighten.c               |    4 +
 arch/x86/xen/mmu.c                     |  291 ++++++++++++++++++-
 arch/x86/xen/pci-swiotlb-xen.c         |   58 ++++
 drivers/xen/balloon.c                  |   15 +-
 include/linux/swiotlb-xen.h            |   65 ++++
 include/xen/interface/memory.h         |   50 +++
 include/xen/xen-ops.h                  |    6 +
 lib/Makefile                           |    1 +
 lib/swiotlb-xen.c                      |  515 ++++++++++++++++++++++++++++++++
 14 files changed, 1018 insertions(+), 21 deletions(-)


[1]: The Xen PCI and Xen PCI fronted patches, which have not yet been
posted are available at git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
under the branch devel/xen-pcifront-0.2. A merge of all required branches
is under 'devel/merge.2.6.35-rc3'. Or 'devel/merge.2.6.34'. I will post them quite soon.
