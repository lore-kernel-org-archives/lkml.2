Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2HPQEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:04:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30694 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2HPQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:04:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/5] xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
Date: Thu, 16 Aug 2012 11:54:45 -0400
Message-Id: <1345132488-27323-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com>
References: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a PV guest is booted the native SWIOTLB should not be
turned on. It does not help us (we don't have any PCI devices)
and it eats 64MB of good memory. In the case of PV guests
with PCI devices we need the Xen-SWIOTLB one.

[v1: Rewrite comment per Stefano's suggestion]
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index b6a5340..1c17227 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -8,6 +8,11 @@
 #include <xen/xen.h>
 #include <asm/iommu_table.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/iommu.h>
+#include <asm/dma.h>
+#endif
+
 int xen_swiotlb __read_mostly;
 
 static struct dma_map_ops xen_swiotlb_dma_ops = {
@@ -49,6 +54,15 @@ int __init pci_xen_swiotlb_detect(void)
 	 * the 'swiotlb' flag is the only one turning it on. */
 	swiotlb = 0;
 
+#ifdef CONFIG_X86_64
+	/* pci_swiotlb_detect_4gb turns on native SWIOTLB if no_iommu == 0
+	 * (so no iommu=X command line over-writes).
+	 * Considering that PV guests do not want the *native SWIOTLB* but
+	 * only Xen SWIOTLB it is not useful to us so set no_iommu=1 here.
+	 */
+	if (max_pfn > MAX_DMA32_PFN)
+		no_iommu = 1;
+#endif
 	return xen_swiotlb;
 }
 
-- 
1.7.7.6

