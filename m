Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0CSPew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:34:52 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:41535 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0CSPeu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 11:34:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] swiotlb: Make swiotlb bookkeeping functions visible in the header file.
Date: Fri, 19 Mar 2010 11:04:21 -0400
Message-Id: <1269011062-25915-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269011062-25915-4-git-send-email-konrad.wilk@oracle.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-2-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-4-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BA3995C.015C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put the init, free, and functions dealing with the operations on the
SWIOTLB buffer at the top of the header. Also we export some of the variables
that are used by the dma_ops functions.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   33 +++++++++++++++++++++++++++++++++
 lib/swiotlb.c           |   28 ++++++++++------------------
 2 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..8550d6b 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,6 +24,39 @@ extern int swiotlb_force;
 
 extern void swiotlb_init(int verbose);
 
+/* Internal book-keeping functions. Must be linked against the library
+ * to take advantage of them.*/
+#ifdef CONFIG_SWIOTLB
+/*
+ * Enumeration for sync targets
+ */
+enum dma_sync_target {
+	SYNC_FOR_CPU = 0,
+	SYNC_FOR_DEVICE = 1,
+};
+extern char *swiotlb_bk_start;
+extern char *swiotlb_bk_end;
+extern unsigned long swiotlb_bk_nslabs;
+extern void *swiotlb_bk_overflow_buffer;
+extern unsigned long swiotlb_bk_overflow;
+extern int is_swiotlb_buffer(phys_addr_t paddr);
+extern void *swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
+			    unsigned long start_dma_addr, size_t size, int dir);
+
+extern void swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+			     int dir);
+
+extern void swiotlb_bk_sync_single(struct device *hwdev, char *dma_addr, size_t size,
+			   int dir, int target);
+
+/* Accessory functions. */
+extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir);
+extern void swiotlb_full(struct device *dev, size_t size, int dir, int do_panic);
+
+#endif
+
+/* swiotlb.c: dma_ops functions. */
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 3926c14..b3eef1c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -49,14 +49,6 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
-/*
- * Enumeration for sync targets
- */
-enum dma_sync_target {
-	SYNC_FOR_CPU = 0,
-	SYNC_FOR_DEVICE = 1,
-};
-
 int swiotlb_force;
 
 /*
@@ -64,18 +56,18 @@ int swiotlb_force;
  * swiotlb_bk_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *swiotlb_bk_start, *swiotlb_bk_end;
+char *swiotlb_bk_start, *swiotlb_bk_end;
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_bk_start and
  * swiotlb_bk_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long swiotlb_bk_nslabs;
+unsigned long swiotlb_bk_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
-static unsigned long swiotlb_bk_overflow = 32*1024;
+unsigned long swiotlb_bk_overflow = 32*1024;
 
 void *swiotlb_bk_overflow_buffer;
 
@@ -315,7 +307,7 @@ void __init swiotlb_free(void)
 	}
 }
 
-static int is_swiotlb_buffer(phys_addr_t paddr)
+int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(swiotlb_bk_start) &&
 		paddr < virt_to_phys(swiotlb_bk_end);
@@ -324,7 +316,7 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			   enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(phys);
@@ -365,7 +357,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
-static void *
+void *
 swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
 		      unsigned long start_dma_addr, size_t size, int dir)
 {
@@ -471,7 +463,7 @@ found:
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 			int dir)
 {
@@ -513,9 +505,9 @@ swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	spin_unlock_irqrestore(&swiotlb_bk_lock, flags);
 }
 
-static void
+void
 swiotlb_bk_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    int dir, int target)
+		       int dir, int target)
 {
 	int index = (dma_addr - swiotlb_bk_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = swiotlb_bk_orig_addr[index];
@@ -607,7 +599,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
-static void
+void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 {
 	/*
-- 
1.6.2.5

