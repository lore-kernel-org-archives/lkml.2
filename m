Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0FVTrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51801 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab0FVTrA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:47:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 13/19] swiotlb-xen: Remove io_tlb_overflow usage.
Date: Tue, 22 Jun 2010 15:42:46 -0400
Message-Id: <1277235772-26757-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C2112CD.00FC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are sheding the usage of the overflow buffer and returning
the value of zero (DMA_ERROR_CODE), following the lead of the
Intel and AMD IOMMU code.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index d457f7e..e0f944e 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -50,8 +50,6 @@ void
 xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			   int nelems, enum dma_data_direction dir,
 			   struct dma_attrs *attrs);
-#define swiotlb_full(dev, size, dir, panic)
-#define io_tlb_overflow_buffer DMA_ERROR_CODE
 
 static dma_addr_t xen_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
@@ -209,10 +207,8 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
 	map = xen_map_single(dev, phys, size, dir);
-	if (!map) {
-		swiotlb_full(dev, size, dir, 1);
-		map = io_tlb_overflow_buffer;
-	}
+	if (!map)
+		return DMA_ERROR_CODE;
 
 	dev_addr = xen_virt_to_bus(dev, map);
 
@@ -353,11 +349,10 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
-				swiotlb_full(hwdev, sg->length, dir, 0);
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 							   attrs);
 				sgl[0].dma_length = 0;
-				return 0;
+				return DMA_ERROR_CODE;
 			}
 			sg->dma_address = xen_virt_to_bus(hwdev, map);
 		} else
@@ -443,7 +438,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_sync_sg_for_device);
 int
 xen_swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == xen_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return !dma_addr;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_dma_mapping_error);
 
-- 
1.7.0.1

