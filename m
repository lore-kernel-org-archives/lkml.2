Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0FVTp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:45:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49182 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0FVTp0 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:45:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 17/19] swiotlb-xen: Coalesce usage of xen_swiotlb_map.
Date: Tue, 22 Jun 2010 15:42:50 -0400
Message-Id: <1277235772-26757-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C211285.0154:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use the 'struct device' anymore, and the xen_swiotlb_map ended
up just passing on the values and recomputing the same value
(start_dma_addr) every time - so now we do it only once.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 12e9dcd..b15f85c 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -46,6 +46,11 @@
 
 static char *xen_io_tlb_start, *xen_io_tlb_end;
 static unsigned long xen_io_tlb_nslabs;
+/*
+ * Quick lookup value of the bus address of the IOTLB.
+ */
+
+u64 start_dma_addr;
 
 static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
@@ -110,15 +115,6 @@ static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
 	return 0;
 }
 
-static void *
-xen_map_single(struct device *hwdev, phys_addr_t phys, size_t size,
-	       enum dma_data_direction dir)
-{
-	u64 start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
-
-	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
-}
-
 static int max_dma_bits = 32;
 
 static int
@@ -174,6 +170,7 @@ void __init xen_swiotlb_init(int verbose)
 	if (rc)
 		goto error;
 
+	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
 	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
 
 	return;
@@ -266,7 +263,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = xen_map_single(dev, phys, size, dir);
+	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
 	if (!map)
 		return DMA_ERROR_CODE;
 
@@ -404,8 +401,10 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
 		    range_straddles_page_boundary(paddr, sg->length)) {
-			void *map = xen_map_single(hwdev, sg_phys(sg),
-						   sg->length, dir);
+			void *map = swiotlb_tbl_map_single(hwdev,
+							   start_dma_addr,
+							   sg_phys(sg),
+							   sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
-- 
1.7.0.1

