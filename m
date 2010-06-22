Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0FVTsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:48:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51780 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab0FVTq4 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 14/19] swiotlb-xen: Add 'xen_swiotlb_init' function.
Date: Tue, 22 Jun 2010 15:42:47 -0400
Message-Id: <1277235772-26757-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C2112CB.0121:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the alloc_bootmem to allocate any memory (even
past the 4GB) and then follow it with a xen kernel
to replace the memory pointed by the virtual address with memory
that is under the 4GB mark.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index e0f944e..3c5bfde 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -33,10 +33,10 @@
  *
  */
 
+#include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
-
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -44,6 +44,7 @@
  */
 
 static char *xen_io_tlb_start, *xen_io_tlb_end;
+static unsigned long xen_io_tlb_nslabs;
 
 /* Temporary scaffolding. Will be removed later. */
 void
@@ -124,6 +125,70 @@ xen_map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 	return swiotlb_tbl_map_single(hwdev, start_dma_addr, phys, size, dir);
 }
 
+static int max_dma_bits = 32;
+
+static int
+xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+{
+	int i, rc;
+	int dma_bits;
+
+	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
+
+	i = 0;
+	do {
+		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
+
+		do {
+			rc = xen_create_contiguous_region(
+				(unsigned long)buf + (i << IO_TLB_SHIFT),
+				get_order(slabs << IO_TLB_SHIFT),
+				dma_bits);
+		} while (rc && dma_bits++ < max_dma_bits);
+		if (rc)
+			return rc;
+
+		i += slabs;
+	} while (i < nslabs);
+	return 0;
+}
+
+void __init xen_swiotlb_init(int verbose)
+{
+	unsigned long bytes;
+	int rc;
+
+	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
+	xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
+
+	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
+
+	/*
+	 * Get IO TLB memory from any location.
+	 */
+	xen_io_tlb_start = alloc_bootmem(bytes);
+	if (!xen_io_tlb_start)
+		panic("Cannot allocate SWIOTLB buffer");
+
+	xen_io_tlb_end = xen_io_tlb_start + bytes;
+	/*
+	 * And replace that memory with pages under 4GB.
+	 */
+	rc = xen_swiotlb_fixup(xen_io_tlb_start,
+			       bytes,
+			       xen_io_tlb_nslabs);
+	if (rc)
+		goto error;
+
+	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
+
+	return;
+error:
+	panic("DMA(%d): Failed to exchange pages allocated for DMA with Xen! "\
+	      "We either don't have the permission or you do not have enough"\
+	      "free memory under 4GB!\n", rc);
+}
+
 void *
 xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags)
@@ -177,6 +242,7 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
 
+
 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.  The
  * physical address to use is returned.
-- 
1.7.0.1

