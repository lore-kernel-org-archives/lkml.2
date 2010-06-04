Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0FDRz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:55:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0FDRz0 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 13:55:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com
Subject: [PATCH 1/5] swiotlb: add swiotlb_tbl_map_single library function
Date: Fri,  4 Jun 2010 13:52:31 -0400
Message-Id: <1275673955-30267-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4C093DD0.00EC:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

swiotlb_tbl_map_single() takes the DMA address of iotlb instead of
using swiotlb_virt_to_bus().

[v2: changed swiotlb_tlb to swiotlb_tbl]
[v3: changed u64 to dma_addr_t]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Albert Herranz <albert_herranz@yahoo.es>
---
 lib/swiotlb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a009055..783aff0 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -361,25 +361,22 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 	}
 }
 
-/*
- * Allocates bounce buffer and returns its kernel virtual address.
- */
-static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
+			     phys_addr_t phys, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
 	unsigned int nslots, stride, index, wrap;
 	int i;
-	unsigned long start_dma_addr;
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
 
-	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	tbl_dma_addr &= mask;
+
+	offset_slots = ALIGN(tbl_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
  	 * Carefully handle integer overflow which can occur when mask == ~0UL.
@@ -468,6 +465,18 @@ found:
 }
 
 /*
+ * Allocates bounce buffer and returns its kernel virtual address.
+ */
+
+static void *
+map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+{
+	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+
+	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
+}
+
+/*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-- 
1.6.2.5

