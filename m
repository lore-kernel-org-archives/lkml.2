Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030713Ab2GLQR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:17:58 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28640 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030670Ab2GLQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:17:57 -0400
Message-ID: <1342109870.2576.23.camel@lorien2>
Subject: [PATCH RFC] swiotlb: Disable swiotlb overflow support when
 CONFIG_ISA is enabled
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, shuahkhan@gmail.com
Date: Thu, 12 Jul 2012 10:17:50 -0600
In-Reply-To: <20120710173211.GB6868@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
	 <1341939307.2502.34.camel@lorien2>
	 <20120710173211.GB6868@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable iotlb overflow support when CONFIG_ISA is enabled. This is the
first step towards removing overflow support, to be consistent with other
iommu implementations and return DMA_ERROR_CODE. This disabling step is
for finding drivers that don't call dma_mapping_error to check for errors
returned by the mapping interface. Once drivers are fixed overflow support
can be removed.

Tested on x86 with io_tlb_overflow = 32*1024 and io_tlb_overflow = 0.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 lib/swiotlb.c |   65 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 45bc1f8..f7d285c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -15,6 +15,9 @@
  * 05/09/10 linville	Add support for syncing ranges, support syncing for
  *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
  * 08/12/11 beckyb	Add highmem support
+ * 07/2012  shuahkhan	Disable iotlb overflow support when CONFIG_ISA
+ *			is enabled. Remove it for all configs when drivers
+ *			that don't check for mapping errors are fixed.
  */
 
 #include <linux/cache.h>
@@ -68,7 +71,19 @@ static unsigned long io_tlb_nslabs;
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
+#if defined(CONFIG_ISA)
+/*
+ * Disable iotlb overflow support when CONFIG_ISA is enabled. This is the
+ * first step towards removing overflow support, to be consistent with other
+ * iommu implementations and return DMA_ERROR_CODE. This disabling step is
+ * for finding drivers that don't call dma_mapping_error to check for errors
+ * returned by the mapping interface. Once drivers are fixed overflow support
+ * can be removed.
+*/
+static unsigned long io_tlb_overflow;
+#else
 static unsigned long io_tlb_overflow = 32*1024;
+#endif
 
 static void *io_tlb_overflow_buffer;
 
@@ -156,12 +171,16 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 	io_tlb_index = 0;
 	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+	if (io_tlb_overflow) {
+		/*
+		 * Get the overflow emergency buffer
+		 */
+		io_tlb_overflow_buffer = alloc_bootmem_low_pages(
+						PAGE_ALIGN(io_tlb_overflow));
+		if (!io_tlb_overflow_buffer)
+			panic("Cannot allocate SWIOTLB overflow buffer!\n");
+	}
+
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -264,13 +283,15 @@ swiotlb_late_init_with_default_size(size_t default_size)
 
 	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		goto cleanup4;
+	if (io_tlb_overflow) {
+		/*
+		 * Get the overflow emergency buffer
+		 */
+		io_tlb_overflow_buffer = (void *)
+			__get_free_pages(GFP_DMA, get_order(io_tlb_overflow));
+		if (!io_tlb_overflow_buffer)
+			goto cleanup4;
+	}
 
 	swiotlb_print_info();
 
@@ -297,12 +318,13 @@ cleanup1:
 
 void __init swiotlb_free(void)
 {
-	if (!io_tlb_overflow_buffer)
+	if (!io_tlb_orig_addr)
 		return;
 
 	if (late_alloc) {
-		free_pages((unsigned long)io_tlb_overflow_buffer,
-			   get_order(io_tlb_overflow));
+		if (io_tlb_overflow_buffer)
+			free_pages((unsigned long)io_tlb_overflow_buffer,
+				   get_order(io_tlb_overflow));
 		free_pages((unsigned long)io_tlb_orig_addr,
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
@@ -310,8 +332,9 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)io_tlb_start,
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
-		free_bootmem_late(__pa(io_tlb_overflow_buffer),
-				  PAGE_ALIGN(io_tlb_overflow));
+		if (io_tlb_overflow_buffer)
+			free_bootmem_late(__pa(io_tlb_overflow_buffer),
+					  PAGE_ALIGN(io_tlb_overflow));
 		free_bootmem_late(__pa(io_tlb_orig_addr),
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
@@ -681,6 +704,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	map = map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		map = io_tlb_overflow_buffer;
 	}
 
@@ -691,6 +716,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
 		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
 	}
 
@@ -910,6 +937,8 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
+	if (!io_tlb_overflow)
+		return DMA_ERROR_CODE;
 	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
-- 
1.7.9.5



