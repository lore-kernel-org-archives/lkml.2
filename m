Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2JORTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:19:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:28323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2JORTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:19:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,588,1344236400"; 
   d="scan'208";a="227132503"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 1/7] swiotlb: Make io_tlb_end a physical address instead of
	a virtual one
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Mon, 15 Oct 2012 10:19:22 -0700
Message-ID: <20121015171922.25171.60722.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
References: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change replaces all references to the virtual address for io_tlb_end
with references to the physical address io_tlb_end.  The main advantage of
replacing the virtual address with a physical address is that we can avoid
having to do multiple translations from the virtual address to the physical
one needed for testing an existing DMA address.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 lib/swiotlb.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f114bf6..c0cbfa1 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,7 +57,8 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+static char *io_tlb_start;
+static phys_addr_t io_tlb_end;
 
 /*
  * The number of IO TLB blocks (in groups of 64) between io_tlb_start and
@@ -125,14 +126,16 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 void swiotlb_print_info(void)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-	phys_addr_t pstart, pend;
+	phys_addr_t pstart;
+	unsigned char *vend;
 
 	pstart = virt_to_phys(io_tlb_start);
-	pend = virt_to_phys(io_tlb_end);
+	vend = phys_to_virt(io_tlb_end);
 
 	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
-	       (unsigned long long)pstart, (unsigned long long)pend - 1,
-	       bytes >> 20, io_tlb_start, io_tlb_end - 1);
+	       (unsigned long long)pstart,
+	       (unsigned long long)io_tlb_end,
+	       bytes >> 20, io_tlb_start, vend - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -143,7 +146,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 
 	io_tlb_nslabs = nslabs;
 	io_tlb_start = tlb;
-	io_tlb_end = io_tlb_start + bytes;
+	io_tlb_end = __pa(io_tlb_start) + bytes;
 
 	/*
 	 * Allocate and initialize the free list array.  This array is used
@@ -254,7 +257,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 
 	io_tlb_nslabs = nslabs;
 	io_tlb_start = tlb;
-	io_tlb_end = io_tlb_start + bytes;
+	io_tlb_end = virt_to_phys(io_tlb_start) + bytes;
 
 	memset(io_tlb_start, 0, bytes);
 
@@ -304,7 +307,7 @@ cleanup3:
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
-	io_tlb_end = NULL;
+	io_tlb_end = 0;
 	io_tlb_start = NULL;
 	io_tlb_nslabs = 0;
 	return -ENOMEM;
@@ -339,8 +342,7 @@ void __init swiotlb_free(void)
 
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) &&
-		paddr < virt_to_phys(io_tlb_end);
+	return paddr >= virt_to_phys(io_tlb_start) && paddr < io_tlb_end;
 }
 
 /*
@@ -938,6 +940,6 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	return phys_to_dma(hwdev, io_tlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);

