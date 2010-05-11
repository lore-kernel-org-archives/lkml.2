Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab0EKTlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:41:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42119 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0EKTlV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 15:41:21 -0400
Date: Tue, 11 May 2010 15:39:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: Ian.Campbell@eu.citrix.com, jeremy@goop.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
	in the header file.
Message-ID: <20100511193918.GA4166@phenom.dumpdata.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com> <4BE9A1C0.3090505@yahoo.es> <20100511184657.GA23464@phenom.dumpdata.com> <4BE9A989.5020808@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE9A989.5020808@yahoo.es>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BE9B2B5.0120:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:01:29PM +0200, Albert Herranz wrote:
> Konrad Rzeszutek Wilk wrote:
> >>> +extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
> >>> +				    u64 tbl_dma_addr, size_t size,
> >>> +				    enum dma_data_direction dir);
> >>> +
> >> The phys and tbl_dma_addr arguments in the function prototype are swapped compared to the function definition in patch 1/6.
> > 
> > Duh! Thanks for spotting that. Here is a repost of this patch (I've 
> > updated the git tree with the one below):
> > 
> 
> Thanks. That was fast :)
> 
> One more thing. Shouldn't be more appropriate to make tbl_dma_addr a dma_addr_t instead of a u64?
> For example, in my case I'm currently using the swiotlb code to overcome some DMA limitations in a 32-bit PowerPC platform.
> In this scenario the dma_addr_t type is defined either as a u64 for 64-bit PowerPC or as a u32 for 32-bit PowerPC.

Good point.

So these two patches (one to replace the PATCH 1/6 and the other to
replace this one), would work then:

I've put the whole tree at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.1

>From 17ef8495231cef0529a2d9763bc7ce73e8860da2 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 10 May 2010 15:14:54 -0400
Subject: [PATCH 1/6] swiotlb: add swiotlb_tbl_map_single library function

swiotlb_tbl_map_single() takes the dma address of iotlb instead of
using swiotlb_virt_to_bus().

[v2: changed swiotlb_tlb to swiotlb_tbl]
[v3: changed u64 to dma_addr_t]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5fddf72..78320d7 100644
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



and:


>From baddb085f29785b3029ec83244b2eda7d23a9d3b Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 10 May 2010 16:20:57 -0400
Subject: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible in the header file.

We put the functions dealing with the operations on
the SWIOTLB buffer in the header and make those functions non-static.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   22 ++++++++++++++++++++++
 lib/swiotlb.c           |   28 ++++++++++++----------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index f3fc331..c40bb2a 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -25,6 +25,28 @@ extern int swiotlb_force;
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 
+/*
+ * Enumeration for sync targets
+ */
+enum dma_sync_target {
+	SYNC_FOR_CPU = 0,
+	SYNC_FOR_DEVICE = 1,
+};
+extern void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
+				    phys_addr_t phys, size_t size,
+				    enum dma_data_direction dir);
+
+extern void swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr,
+				     size_t size, enum dma_data_direction dir);
+
+extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
+				    size_t size, enum dma_data_direction dir,
+				    enum dma_sync_target target);
+
+/* Accessory functions. */
+extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7eed4c9..7b4a41a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -50,14 +50,6 @@
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
@@ -335,8 +327,8 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
-			   enum dma_data_direction dir)
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+		    enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(phys);
 
@@ -493,7 +485,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir)
 {
@@ -534,9 +526,10 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-static void
+void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    enum dma_data_direction dir, int target)
+			enum dma_data_direction dir,
+			enum dma_sync_target target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -748,7 +741,8 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, enum dma_data_direction dir, int target)
+		    size_t size, enum dma_data_direction dir,
+		    enum dma_sync_target target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -788,7 +782,8 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  enum dma_data_direction dir, int target)
+			  enum dma_data_direction dir,
+			  enum dma_sync_target target)
 {
 	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
@@ -908,7 +903,8 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
  */
 static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
-		int nelems, enum dma_data_direction dir, int target)
+		int nelems, enum dma_data_direction dir,
+		enum dma_sync_target target)
 {
 	struct scatterlist *sg;
 	int i;
-- 
1.6.2.5

> 
> Cheers,
> Albert
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
