Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2GaOKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:10:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47354 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2GaOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:10:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        JBeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/5] xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
Date: Tue, 31 Jul 2012 10:00:20 -0400
Message-Id: <1343743223-30092-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
References: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a PV guest is booted the native SWIOTLB should not be
turned on. It does not help us (we don't have any PCI devices)
and it eats 64MB of good memory. In the case of PV guests
with PCI devices we need the Xen-SWIOTLB one.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index b6a5340..0d5a214 100644
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
@@ -49,6 +54,13 @@ int __init pci_xen_swiotlb_detect(void)
 	 * the 'swiotlb' flag is the only one turning it on. */
 	swiotlb = 0;
 
+#ifdef CONFIG_X86_64
+	/* pci_swiotlb_detect_4gb turns native SWIOTLB if no_iommu == 0
+	 * (so no iommu=X command line over-writes). So disable the native
+	 * SWIOTLB. */
+	if (max_pfn > MAX_DMA32_PFN)
+		no_iommu = 1;
+#endif
 	return xen_swiotlb;
 }
 
-- 
1.7.7.6

