Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2GZUwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:52:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27044 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2GZUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:52:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/swiotlb: If iommu=soft was not passed in on > 4GB, don't turn it on.
Date: Thu, 26 Jul 2012 16:43:26 -0400
Message-Id: <1343335407-5465-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
References: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we boot a 64-bit guest with more than 4GB memory, the SWIOTLB
gets turned on:
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xfb43d000-0xff43cfff] (64MB) mapped at [ffff8800fb43d000-ffff8800ff43cfff]

which is OK if we had PCI devices, but not if we did not. In a PV
guest the SWIOTLB ends up asking the hypervisor for precious lowmem
memory - and 64MB of it per guest. On a 32GB machine, this limits the
amount of guests that are 4GB to start due to lowmem exhaustion.

What we do is detect whether the user supplied e820_hole=1
parameter, which is used to construct an E820 that is similar to
the machine  - so that the PCI regions do not overlap with RAM regions.
We check for that by looking at the E820 and seeing if it diverges
from the standard - and if so (and if iommu=soft was not turned on),
we disable the check pci_swiotlb_detect_4gb code.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 967633a..56f373e 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -8,6 +8,10 @@
 #include <xen/xen.h>
 #include <asm/iommu_table.h>
 
+#include <asm/e820.h>
+#include <asm/dma.h>
+#include <asm/iommu.h>
+
 int xen_swiotlb __read_mostly;
 
 static struct dma_map_ops xen_swiotlb_dma_ops = {
@@ -24,7 +28,19 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.unmap_page = xen_swiotlb_unmap_page,
 	.dma_supported = xen_swiotlb_dma_supported,
 };
+bool __init e820_has_acpi(void)
+{
+	int i;
 
+	/* Check if the user supplied the e820_hole parameter
+	 * which would create a machine looking E820 region. */
+	for (i = 0; i < e820.nr_map; i++) {
+		if ((e820.map[i].type == E820_ACPI) ||
+		    (e820.map[i].type == E820_NVS))
+			return true;
+	}
+	return false;
+}
 /*
  * pci_xen_swiotlb_detect - set xen_swiotlb to 1 if necessary
  *
@@ -33,7 +49,17 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
  */
 int __init pci_xen_swiotlb_detect(void)
 {
+#ifdef CONFIG_X86_64
 
+	/* Having more than 4GB triggers the native SWIOTLB to activate.
+	 * The way to turn it off is to set no_iommu. */
+	printk(KERN_INFO "swiotlb: %d\n", swiotlb);
+	if (xen_pv_domain() && !swiotlb && max_pfn > MAX_DMA32_PFN) {
+		/* Normal PV guests only have E820_RSV and E820_RAM regions */
+		if (!e820_has_acpi())
+			no_iommu = 1;
+	}
+#endif
 	/* If running as PV guest, either iommu=soft, or swiotlb=force will
 	 * activate this IOMMU. If running as PV privileged, activate it
 	 * irregardless.
-- 
1.7.7.6

