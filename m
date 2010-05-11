Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0EKPlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:41:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58251 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab0EKPlF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:41:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org
Subject: [PATCH 1/6] swiotlb: add swiotlb_tbl_map_single library function
Date: Tue, 11 May 2010 11:39:08 -0400
Message-Id: <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BE97A82.0139:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

swiotlb_tbl_map_single() takes the dma address of iotlb instead of
using swiotlb_virt_to_bus().

[v2: changed swiotlb_tlb to swiotlb_tbl]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5fddf72..cb83d54 100644
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
+void *swiotlb_tbl_map_single(struct device *hwdev, u64 tbl_dma_addr,
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
+	u64 start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
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

