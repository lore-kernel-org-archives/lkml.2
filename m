Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2JDAib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:38:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:54165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab2JDAia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,530,1344236400"; 
   d="scan'208";a="201305146"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [RFC PATCH 1/7] swiotlb: Instead of tracking the end of the swiotlb
	region just calculate it
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, x86@kernel.org
Date: Wed, 03 Oct 2012 17:38:47 -0700
Message-ID: <20121004003847.5016.50978.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of swiotlb we already have the start of the region and the number
of slabs that give us the region size.  Instead of having to call
virt_to_phys on two pointers we can just take advantage of the fact that the
region is linear and just compute the end based on the start plus the size.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 lib/swiotlb.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f114bf6..5cc4d4e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,11 +57,11 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+static char *io_tlb_start;
 
 /*
- * The number of IO TLB blocks (in groups of 64) between io_tlb_start and
- * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
+ * The number of IO TLB blocks (in groups of 64).
+ * This is command line adjustable via setup_io_tlb_npages.
  */
 static unsigned long io_tlb_nslabs;
 
@@ -128,11 +128,11 @@ void swiotlb_print_info(void)
 	phys_addr_t pstart, pend;
 
 	pstart = virt_to_phys(io_tlb_start);
-	pend = virt_to_phys(io_tlb_end);
+	pend = pstart + bytes;
 
 	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
 	       (unsigned long long)pstart, (unsigned long long)pend - 1,
-	       bytes >> 20, io_tlb_start, io_tlb_end - 1);
+	       bytes >> 20, io_tlb_start, io_tlb_start + bytes - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -143,12 +143,10 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 
 	io_tlb_nslabs = nslabs;
 	io_tlb_start = tlb;
-	io_tlb_end = io_tlb_start + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
 	 */
 	io_tlb_list = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
 	for (i = 0; i < io_tlb_nslabs; i++)
@@ -254,14 +252,12 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 
 	io_tlb_nslabs = nslabs;
 	io_tlb_start = tlb;
-	io_tlb_end = io_tlb_start + bytes;
 
 	memset(io_tlb_start, 0, bytes);
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
 	                              get_order(io_tlb_nslabs * sizeof(int)));
@@ -304,7 +300,6 @@ cleanup3:
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
-	io_tlb_end = NULL;
 	io_tlb_start = NULL;
 	io_tlb_nslabs = 0;
 	return -ENOMEM;
@@ -339,8 +334,10 @@ void __init swiotlb_free(void)
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
-		paddr < virt_to_phys(io_tlb_end);
+	phys_addr_t swiotlb_start = virt_to_phys(io_tlb_start);
+
+	return paddr >= swiotlb_start &&
+		paddr < (swiotlb_start + (io_tlb_nslabs << IO_TLB_SHIFT));
 }
 
 /*
@@ -938,6 +935,8 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	return swiotlb_virt_to_bus(hwdev, io_tlb_start + bytes - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);

