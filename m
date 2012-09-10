Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2IJT7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:59:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17195 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2IJT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/10] xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
Date: Mon, 10 Sep 2012 15:45:59 -0400
Message-Id: <1347306367-28669-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

