Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2GQUOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:14:03 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16300 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GQUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:14:00 -0400
Message-ID: <1342556035.2539.35.camel@lorien2>
Subject: [PATCH] swiotlb: Disable swiotlb overflow support when CONFIG_ISA
 is disabled
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, bhelgaas@google.com, amwang@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, rob@landley.net
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        shuahkhan@gmail.com
Date: Tue, 17 Jul 2012 14:13:55 -0600
In-Reply-To: <1342549647.2539.29.camel@lorien2>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
	 <1341939307.2502.34.camel@lorien2>
	 <20120710173211.GB6868@phenom.dumpdata.com>
	 <1342109870.2576.23.camel@lorien2>
	 <20120716144536.GA552@phenom.dumpdata.com>
	 <1342453700.2949.6.camel@lorien2>
	 <20120716160119.GE13540@phenom.dumpdata.com>
	 <1342549647.2539.29.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable iotlb overflow support when CONFIG_ISA is disabled. Add deprecation
notice warning message and deprecation schedule documentation. This is the
first step towards removing overflow support, to be consistent with other
iommu implementations and return DMA_ERROR_CODE. This disabling step is for
finding drivers that don't call dma_mapping_error to check for errors returned
by the mapping interface. Once drivers are fixed overflow support can be
removed.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/feature-removal-schedule.txt |   22 ++++++--
 lib/swiotlb.c                              |   79 +++++++++++++++++++++-------
 2 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5979c3e..ce6c0ae 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -35,7 +35,7 @@ What:	x86_32 "no-hlt" cmdline param
 When:	2012
 Why:	remove a branch from idle path, simplify code used by everybody.
 	This option disabled the use of HLT in idle and machine_halt()
-	for hardware that was flakey 15-years ago.  Today we have
+	for hardware that was flaky 15-years ago.  Today we have
 	"idle=poll" that removed HLT from idle, and so if such a machine
 	is still running the upstream kernel, "idle=poll" is likely sufficient.
 Who:	Len Brown <len.brown@intel.com>
@@ -160,7 +160,7 @@ Files:	arch/*/kernel/*_ksyms.c
 Check:	kernel_thread
 Why:	kernel_thread is a low-level implementation detail.  Drivers should
         use the <linux/kthread.h> API instead which shields them from
-	implementation details and provides a higherlevel interface that
+	implementation details and provides a higher level interface that
 	prevents bugs and code duplication
 Who:	Christoph Hellwig <hch@lst.de>
 
@@ -236,7 +236,7 @@ Who:	David Brownell <dbrownell@users.sourceforge.net>
 
 What:	b43 support for firmware revision < 410
 When:	The schedule was July 2008, but it was decided that we are going to keep the
-        code as long as there are no major maintanance headaches.
+        code as long as there are no major maintenance headaches.
 	So it _could_ be removed _any_ time now, if it conflicts with something new.
 Why:	The support code for the old firmware hurts code readability/maintainability
 	and slightly hurts runtime performance. Bugfixes for the old firmware
@@ -608,3 +608,19 @@ When:	June 2013
 Why:	Unsupported/unmaintained/unused since 2.6
 
 ----------------------------
+
+What:	SWIOTLB overflow buffer support.
+When:	3.8
+Why:	Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
+	(a value of zero) to make it consistent with iommu implementation
+	on Intel, AMD, and swiotlb-xen. In 3.6, Disable iotlb overflow
+	support when CONFIG_ISA is disabled with the intent to find drivers
+	that don't call dma_mapping_error to check for errors returned by the
+	mapping interface. Once drivers are fixed overflow support can be
+	removed.
+	If you see any problems related to disabling SWIOTLB overflow buffer,
+	please report to us!
+	E-mail us at: linux-kernel@vger.kernel.org
+Who:	Shuah Khan <shuah.khan@hp.com> <shuahkhan@gmail.com>
+
+----------------------------
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 45bc1f8..0123bb8 100644
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
@@ -68,7 +71,11 @@ static unsigned long io_tlb_nslabs;
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
+#if defined(CONFIG_ISA)
 static unsigned long io_tlb_overflow = 32*1024;
+#else
+static unsigned long io_tlb_overflow;
+#endif
 
 static void *io_tlb_overflow_buffer;
 
@@ -92,6 +99,24 @@ static DEFINE_SPINLOCK(io_tlb_lock);
 
 static int late_alloc;
 
+static void swiotlb_print_overflow_deprecation_notice(void)
+{
+	if (io_tlb_overflow) {
+		pr_warn("SWIOTLB overflow buffer will be deprecated.\n"
+			"  If you have a driver that depends on this feature\n"
+			"  please Email us at: linux-kernel@vger.kernel.org,\n"
+			"  Shuah Khan (shuahkhan@gmail.com), and\n"
+			"  Konrad Wilk (konrad.wilk@oracle.com)\n");
+	} else {
+		pr_warn("SWIOTLB overflow buffer is disabled and will be\n"
+			"  deprecated. Please report problems related to\n"
+			"  disabling overflow buffer to\n"
+			"  linux-kernel@vger.kernel.org,\n"
+			"  Shuah Khan (shuahkhan@gmail.com), and\n"
+			"  Konrad Wilk (konrad.wilk@oracle.com)\n");
+	}
+}
+
 static int __init
 setup_io_tlb_npages(char *str)
 {
@@ -108,7 +133,6 @@ setup_io_tlb_npages(char *str)
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-/* make io_tlb_overflow tunable too? */
 
 unsigned long swiotlb_nr_tbl(void)
 {
@@ -156,12 +180,18 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
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
+	swiotlb_print_overflow_deprecation_notice();
+
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -264,14 +294,17 @@ swiotlb_late_init_with_default_size(size_t default_size)
 
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
 
+	swiotlb_print_overflow_deprecation_notice();
 	swiotlb_print_info();
 
 	late_alloc = 1;
@@ -297,12 +330,13 @@ cleanup1:
 
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
@@ -310,8 +344,9 @@ void __init swiotlb_free(void)
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
@@ -681,6 +716,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	map = map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		map = io_tlb_overflow_buffer;
 	}
 
@@ -691,6 +728,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
 		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
 	}
 
@@ -910,6 +949,8 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
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



