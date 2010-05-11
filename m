Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0EKPlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:41:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58448 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0EKPlL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:41:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org
Subject: [PATCH 2/6] swiotlb: add the swiotlb initialization function with iotlb memory
Date: Tue, 11 May 2010 11:39:09 -0400
Message-Id: <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BE97A89.018A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This enables the caller to initialize swiotlb with its own iotlb
memory.

[v2: changed ..with_tlb to ..with_tbl]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   48 +++++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..ab005a5 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,6 +23,7 @@ extern int swiotlb_force;
 #define IO_TLB_SHIFT 11
 
 extern void swiotlb_init(int verbose);
+extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index cb83d54..843aa54 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -140,28 +140,14 @@ void swiotlb_print_info(void)
 	       (unsigned long long)pend);
 }
 
-/*
- * Statically reserve bounce buffer space and initialize bounce buffer data
- * structures for the software IO TLB used to implement the DMA API.
- */
-void __init
-swiotlb_init_with_default_size(size_t default_size, int verbose)
+void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 {
 	unsigned long i, bytes;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
-	}
+	bytes = nslabs << IO_TLB_SHIFT;
 
-	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-
-	/*
-	 * Get IO TLB memory from the low pages
-	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
+	io_tlb_nslabs = nslabs;
+	io_tlb_start = tlb;
 	io_tlb_end = io_tlb_start + bytes;
 
 	/*
@@ -185,6 +171,32 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 		swiotlb_print_info();
 }
 
+/*
+ * Statically reserve bounce buffer space and initialize bounce buffer data
+ * structures for the software IO TLB used to implement the DMA API.
+ */
+void __init
+swiotlb_init_with_default_size(size_t default_size, int verbose)
+{
+	unsigned long bytes;
+
+	if (!io_tlb_nslabs) {
+		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
+		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	}
+
+	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	/*
+	 * Get IO TLB memory from the low pages
+	 */
+	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	if (!io_tlb_start)
+		panic("Cannot allocate SWIOTLB buffer");
+
+	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
+}
+
 void __init
 swiotlb_init(int verbose)
 {
-- 
1.6.2.5

