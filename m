Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0FVTqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51688 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0FVTqm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 16/19] swiotlb-xen: Removing the 'struct device' in the address translation routines.
Date: Tue, 22 Jun 2010 15:42:49 -0400
Message-Id: <1277235772-26757-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C2112C7.0139:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use it at all.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 6bba1a5..12e9dcd 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -47,20 +47,19 @@
 static char *xen_io_tlb_start, *xen_io_tlb_end;
 static unsigned long xen_io_tlb_nslabs;
 
-static dma_addr_t xen_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
 	return phys_to_machine(XPADDR(paddr)).maddr;;
 }
 
-static phys_addr_t xen_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
+static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 {
 	return machine_to_phys(XMADDR(baddr)).paddr;
 }
 
-static dma_addr_t xen_virt_to_bus(struct device *hwdev,
-				  void *address)
+static dma_addr_t xen_virt_to_bus(void *address)
 {
-	return xen_phys_to_bus(hwdev, virt_to_phys(address));
+	return xen_phys_to_bus(virt_to_phys(address));
 }
 
 static int check_pages_physically_contiguous(unsigned long pfn,
@@ -115,7 +114,7 @@ static void *
 xen_map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 	       enum dma_data_direction dir)
 {
-	u64 start_dma_addr = xen_virt_to_bus(hwdev, xen_io_tlb_start);
+	u64 start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
 
 	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
 }
@@ -251,7 +250,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = xen_phys_to_bus(dev, phys);
+	dma_addr_t dev_addr = xen_phys_to_bus(phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -271,7 +270,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	if (!map)
 		return DMA_ERROR_CODE;
 
-	dev_addr = xen_virt_to_bus(dev, map);
+	dev_addr = xen_virt_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -294,7 +293,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
 static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			     size_t size, enum dma_data_direction dir)
 {
-	phys_addr_t paddr = xen_bus_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -339,7 +338,7 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
 			enum dma_sync_target target)
 {
-	phys_addr_t paddr = xen_bus_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -400,7 +399,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = xen_phys_to_bus(hwdev, paddr);
+		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
@@ -415,7 +414,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				sgl[0].dma_length = 0;
 				return DMA_ERROR_CODE;
 			}
-			sg->dma_address = xen_virt_to_bus(hwdev, map);
+			sg->dma_address = xen_virt_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -512,6 +511,6 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_dma_mapping_error);
 int
 xen_swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return xen_virt_to_bus(hwdev, xen_io_tlb_end - 1) <= mask;
+	return xen_virt_to_bus(xen_io_tlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_dma_supported);
-- 
1.7.0.1

