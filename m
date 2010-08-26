Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0HZR71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:59:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0HZR7U (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 26 Aug 2010 13:59:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] Modularize IOMMUs detection/init for X86
Date: Thu, 26 Aug 2010 13:57:55 -0400
Message-Id: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per our discussion at: http://lkml.org/lkml/2010/8/2/282
I've implemented an RFC set of patches to address the problem.

This patch set adds a mechanism to "modularize" the IOMMUs we have
on X86. Currently the count of IOMMUs is up to six and they have a complex
relationship that requires careful execution order. 'pci_iommu_alloc'
does that today, but most folks are unhappy with how it does it.
This patch set addresses this and also paves a mechanism to jettison
unused IOMMUs during run-time.

The first solution that comes to mind is to convert wholesale
the IOMMU detection routines to be called during initcall
time frame. Unfortunately that misses the dependency relationship
that some of the IOMMUs have (for example: for AMD-Vi IOMMU to work,
GART detection MUST run first, and before all of that SWIOTLB MUST run).

The second solution would be to introduce a registration call wherein
the IOMMU would provide its detection/init routines and as well on what
MUST run before it. That would work, except that the 'pci_iommu_alloc'
which would run through this list, is called during mem_init. This means we
don't have any memory allocator, and it is so early that we haven't yet
started running through the initcall_t list.

This solution borrows concepts from the 2nd idea and from how
MODULE_INIT works. A macro is provided that each IOMMU uses to define
it's detect function and early_init (before the memory allocate is
active), and as well what other IOMMU MUST run before us.  Since most IOMMUs
depend on having SWIOTLB run first ("pci_swiotlb_detect") a convenience macro
to depends on that is also provided.

This macro is similar in design to MODULE_PARAM macro wherein
we setup a .iommu_table section in which we populate it with the values
that match a struct iommu_table_entry. During bootup we will sort
through the array so that the IOMMUs that MUST run before us are first
elements in the array. And then we just iterate through them calling the
detection routine and if appropriate, the init routines.

Testing:
I've done testing on machines with Intel VT-d, SWIOTLB, and GART for regressions.
I sadly don't have machines with the Calgary nor the AMD-Vi chipsets.

Enhancements:

Jeremy suggested that we could get rid of the macro and instead provide
an registration API, such as:

static void __init_early register_my_iommu() {

	register_iommu(&my_iommu_details);
}

where the __init_early would put the address of the function in an
-1 level of .initcall list. This -1 level of init that would run
right before the pci_iommu_alloc is called (or perhaps during earlier
setup).  The register_iommu would have a static list allocated, and the
structure passed in would have a 'list_head' value that we would use to
stitch the structs together. Then the 'sort_iommu' function would take care of
sorting the elements in order of dependency.

This patchset is also available on git:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/iommu-0.2

 arch/x86/include/asm/amd_iommu.h   |    4 +-
 arch/x86/include/asm/calgary.h     |    4 +-
 arch/x86/include/asm/gart.h        |    5 +-
 arch/x86/include/asm/iommu_table.h |  101 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/swiotlb.h     |   13 ++++-
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/amd_iommu_init.c   |   16 ++++--
 arch/x86/kernel/aperture_64.c      |   11 +++--
 arch/x86/kernel/pci-calgary_64.c   |   18 ++++---
 arch/x86/kernel/pci-dma.c          |   44 ++++++++--------
 arch/x86/kernel/pci-gart_64.c      |    2 +
 arch/x86/kernel/pci-iommu_table.c  |   90 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-swiotlb.c      |   45 +++++++++++++---
 arch/x86/kernel/vmlinux.lds.S      |    7 +++
 arch/x86/xen/pci-swiotlb-xen.c     |    5 ++
 drivers/pci/dmar.c                 |    6 ++-
 include/linux/dmar.h               |    6 +-
 17 files changed, 321 insertions(+), 57 deletions(-)
