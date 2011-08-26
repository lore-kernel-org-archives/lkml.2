Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1HZSpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:45:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27945 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1HZSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:44:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        joe@perches.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] xen-swiotlb: When doing coherent alloc/dealloc check before swizzling the MFNs.
Date: Fri, 26 Aug 2011 14:44:30 -0400
Message-Id: <1314384270-19850-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
References: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4E57E99D.015F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The process to swizzle a Machine Frame Number (MFN) is not always
necessary. Especially if we know that we actually do not have to do it.
In this patch we check the MFN against the device's coherent
DMA mask and if the requested page(s) are contingous. If it all checks
out we will just return the bus addr without doing the memory
swizzle.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 0408f32..c984768 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -209,6 +209,8 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	int order = get_order(size);
 	u64 dma_mask = DMA_BIT_MASK(32);
 	unsigned long vstart;
+	phys_addr_t phys;
+	dma_addr_t dev_addr;
 
 	/*
 	* Ignore region specifiers - the kernel's ideas of
@@ -224,18 +226,26 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	vstart = __get_free_pages(flags, order);
 	ret = (void *)vstart;
 
+	if (!ret)
+		return ret;
+
 	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
+		dma_mask = hwdev->coherent_dma_mask;
 
-	if (ret) {
+	phys = virt_to_phys(ret);
+	dev_addr = xen_phys_to_bus(phys);
+	if (((dev_addr + size - 1 <= dma_mask)) &&
+	    !range_straddles_page_boundary(phys, size))
+		*dma_handle = dev_addr;
+	else {
 		if (xen_create_contiguous_region(vstart, order,
 						 fls64(dma_mask)) != 0) {
 			free_pages(vstart, order);
 			return NULL;
 		}
-		memset(ret, 0, size);
 		*dma_handle = virt_to_machine(ret).maddr;
 	}
+	memset(ret, 0, size);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_alloc_coherent);
@@ -245,11 +255,21 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 			  dma_addr_t dev_addr)
 {
 	int order = get_order(size);
+	phys_addr_t phys;
+	u64 dma_mask = DMA_BIT_MASK(32);
 
 	if (dma_release_from_coherent(hwdev, order, vaddr))
 		return;
 
-	xen_destroy_contiguous_region((unsigned long)vaddr, order);
+	if (hwdev && hwdev->coherent_dma_mask)
+		dma_mask = hwdev->coherent_dma_mask;
+
+	phys = virt_to_phys(vaddr);
+
+	if (((dev_addr + size - 1 > dma_mask)) ||
+	    range_straddles_page_boundary(phys, size))
+		xen_destroy_contiguous_region((unsigned long)vaddr, order);
+
 	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
-- 
1.7.4.1

