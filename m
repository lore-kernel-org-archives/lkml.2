Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0FVTsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:48:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51783 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0FVTq5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/19] swiotlb-xen: Early skeleton code and explanation.
Date: Tue, 22 Jun 2010 15:42:38 -0400
Message-Id: <1277235772-26757-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4C2112CB.0127:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in base code for address translation routines.

This patchset:

PV guests under Xen are running in an non-contiguous memory architecture.

When PCI pass-through is utilized, this necessitates an IOMMU for
translating bus (DMA) to virtual and vice-versa and also providing a
mechanism to have contiguous pages for device drivers operations (say DMA
operations).

Specifically, under Xen the Linux idea of pages is an illusion. It
assumes that pages start at zero and go up to the available memory. To
help with that, the Linux Xen MMU provides a lookup mechanism to
translate the page frame numbers (PFN) to machine frame numbers (MFN)
and vice-versa. The MFN are the "real" frame numbers. Furthermore
memory is not contiguous. Xen hypervisor stitches memory for guests
from different pools, which means there is no guarantee that PFN==MFN
and PFN+1==MFN+1. Lastly with Xen 4.0, pages (in debug mode) are
allocated in descending order (high to low), meaning the guest might
never get any MFN's under the 4GB mark.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    4 ++
 lib/Makefile         |    1 +
 lib/swiotlb-xen.c    |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 lib/swiotlb-xen.c

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index b83e119..faed31d 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -36,3 +36,7 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config SWIOTLB_XEN
+	def_bool y
+	depends on XEN && SWIOTLB
diff --git a/lib/Makefile b/lib/Makefile
index 0d40152..c25f6bf 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
+obj-$(CONFIG_SWIOTLB_XEN) += swiotlb-xen.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
new file mode 100644
index 0000000..11207e0
--- /dev/null
+++ b/lib/swiotlb-xen.c
@@ -0,0 +1,118 @@
+/*
+ *  Copyright 2010
+ *  by Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *
+ * This code provides a IOMMU for Xen PV guests with PCI passthrough.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * PV guests under Xen are running in an non-contiguous memory architecture.
+ *
+ * When PCI pass-through is utilized, this necessitates an IOMMU for
+ * translating bus (DMA) to virtual and vice-versa and also providing a
+ * mechanism to have contiguous pages for device drivers operations (say DMA
+ * operations).
+ *
+ * Specifically, under Xen the Linux idea of pages is an illusion. It
+ * assumes that pages start at zero and go up to the available memory. To
+ * help with that, the Linux Xen MMU provides a lookup mechanism to
+ * translate the page frame numbers (PFN) to machine frame numbers (MFN)
+ * and vice-versa. The MFN are the "real" frame numbers. Furthermore
+ * memory is not contiguous. Xen hypervisor stitches memory for guests
+ * from different pools, which means there is no guarantee that PFN==MFN
+ * and PFN+1==MFN+1. Lastly with Xen 4.0, pages (in debug mode) are
+ * allocated in descending order (high to low), meaning the guest might
+ * never get any MFN's under the 4GB mark.
+ *
+ */
+
+#include <linux/dma-mapping.h>
+#include <xen/page.h>
+
+/*
+ * Used to do a quick range check in swiotlb_tbl_unmap_single and
+ * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
+ * API.
+ */
+
+static char *xen_io_tlb_start, *xen_io_tlb_end;
+
+static dma_addr_t xen_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+{
+	return phys_to_machine(XPADDR(paddr)).maddr;;
+}
+
+static phys_addr_t xen_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
+{
+	return machine_to_phys(XMADDR(baddr)).paddr;
+}
+
+static dma_addr_t xen_virt_to_bus(struct device *hwdev,
+				  void *address)
+{
+	return xen_phys_to_bus(hwdev, virt_to_phys(address));
+}
+
+static int check_pages_physically_contiguous(unsigned long pfn,
+					     unsigned int offset,
+					     size_t length)
+{
+	unsigned long next_mfn;
+	int i;
+	int nr_pages;
+
+	next_mfn = pfn_to_mfn(pfn);
+	nr_pages = (offset + length + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (pfn_to_mfn(++pfn) != ++next_mfn)
+			return 0;
+	}
+	return 1;
+}
+
+static int range_straddles_page_boundary(phys_addr_t p, size_t size)
+{
+	unsigned long pfn = PFN_DOWN(p);
+	unsigned int offset = p & ~PAGE_MASK;
+
+	if (offset + size <= PAGE_SIZE)
+		return 0;
+	if (check_pages_physically_contiguous(pfn, offset, size))
+		return 0;
+	return 1;
+}
+
+static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
+{
+	unsigned long mfn = PFN_DOWN(dma_addr);
+	unsigned long pfn = mfn_to_local_pfn(mfn);
+	phys_addr_t paddr;
+
+	/* If the address is outside our domain, it CAN
+	 * have the same virtual address as another address
+	 * in our domain. Therefore _only_ check address within our domain.
+	 */
+	if (pfn_valid(pfn)) {
+		paddr = PFN_PHYS(pfn);
+		return paddr >= virt_to_phys(xen_io_tlb_start) &&
+		       paddr < virt_to_phys(xen_io_tlb_end);
+	}
+	return 0;
+}
+
+static void *
+xen_map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+	       enum dma_data_direction dir)
+{
+	u64 start_dma_addr = xen_virt_to_bus(hwdev, xen_io_tlb_start);
+
+	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
+}
-- 
1.7.0.1

