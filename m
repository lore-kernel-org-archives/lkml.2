Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1HXWbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:31:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33398 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HXWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:31:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/5] xen-swiotlb: Retry up three times to allocate Xen-SWIOTLB
Date: Wed, 24 Aug 2011 18:31:33 -0400
Message-Id: <1314225096-4861-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E557BD4.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can fail seting up Xen-SWIOTLB if:
 - The host does not have enough contiguous DMA32 memory available
   (can happen on a machine that has fragmented memory from starting,
   stopping many guests).
 - Not enough low memory (almost never happens).

We retry allocating and exchanging the swath of contiguous memory
up to three times. Each time we decrease the amount we need  - the
minimum being of 2MB.

If we completly fail, we will print the reason for failure on the Xen
console on top of doing it to earlyprintk=xen console.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 6e8c15a..d45cbac 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -38,6 +38,7 @@
 #include <xen/swiotlb-xen.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+#include <xen/hvc-console.h>
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -146,8 +147,10 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 void __init xen_swiotlb_init(int verbose)
 {
 	unsigned long bytes;
-	int rc;
+	int rc = -ENOMEM;
 	unsigned long nr_tbl;
+	char *m = NULL;
+	unsigned int repeat = 3;
 
 	nr_tbl = swioltb_nr_tbl();
 	if (nr_tbl)
@@ -156,16 +159,17 @@ void __init xen_swiotlb_init(int verbose)
 		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
 		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
 	}
-
+retry:
 	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 
 	/*
 	 * Get IO TLB memory from any location.
 	 */
 	xen_io_tlb_start = alloc_bootmem(bytes);
-	if (!xen_io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
-
+	if (!xen_io_tlb_start) {
+		m = "Cannot allocate Xen-SWIOTLB buffer!\n";
+		goto error;
+	}
 	xen_io_tlb_end = xen_io_tlb_start + bytes;
 	/*
 	 * And replace that memory with pages under 4GB.
@@ -173,17 +177,28 @@ void __init xen_swiotlb_init(int verbose)
 	rc = xen_swiotlb_fixup(xen_io_tlb_start,
 			       bytes,
 			       xen_io_tlb_nslabs);
-	if (rc)
+	if (rc) {
+		free_bootmem(__pa(xen_io_tlb_start), bytes);
+		m = "Failed to get contiguous memory for DMA from Xen!\n"\
+		    "You either: don't have the permissions, do not have"\
+		    " enough free memory under 4GB, or the hypervisor memory"\
+		    "is too fragmented!";
 		goto error;
-
+	}
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
 	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
 
 	return;
 error:
-	panic("DMA(%d): Failed to exchange pages allocated for DMA with Xen! "\
-	      "We either don't have the permission or you do not have enough"\
-	      "free memory under 4GB!\n", rc);
+	if (repeat--) {
+		xen_io_tlb_nslabs = max(1024UL, /* Min is 2MB */
+					(xen_io_tlb_nslabs >> 1));
+		printk(KERN_INFO "Xen-SWIOTLB: Lowering to %luMB\n",
+		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
+		goto retry;
+	}
+	xen_raw_printk("%s (rc:%d)", rc, m);
+	panic("%s (rc:%d)", rc, m);
 }
 
 void *
-- 
1.7.4.1

