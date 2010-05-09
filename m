Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0EIOAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:00:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:55284 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0EIOAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:00:51 -0400
Date: Sun, 9 May 2010 22:41:15 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 2/6] swiotlb: swiotlb_tbl_map_single: abstract out
 swiotlb_virt_to_bus calls out.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100509223623X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 09 May 2010 22:41:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Apr 2010 16:29:26 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> We want to move that function out of swiotlb_tbl_map_single so that the caller
> of this function does the virt->phys->bus address translation.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  lib/swiotlb.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)

It would be better to do something like that instead of spreading
swiotlb_virt_to_bus()?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swiotlb: add swiotlb_tlb_map_single library function

swiotlb_tlb_map_single() takes the dma address of iotlb instead of
using swiotlb_virt_to_bus().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a37ee04..58f489a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -373,25 +373,22 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 	}
 }
 
-/*
- * Allocates bounce buffer and returns its kernel virtual address.
- */
-static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+void *swiotlb_tlb_map_single(struct device *hwdev, u64 tlb_dma_addr,
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
+	tlb_dma_addr &= mask;
+
+	offset_slots = ALIGN(tlb_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
  	 * Carefully handle integer overflow which can occur when mask == ~0UL.
@@ -480,6 +477,18 @@ found:
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
+	return swiotlb_tlb_map_single(hwdev, start_dma_addr, phys, size, dir);
+}
+
+/*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-- 
1.6.5

