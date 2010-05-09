Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0EIOAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:00:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:55281 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab0EIOAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:00:44 -0400
Date: Sun, 9 May 2010 22:41:25 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 3/6] swiotlb: Make exportable bookkeeping functions and
 variables have same prefix.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100509224021S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 09 May 2010 22:41:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Apr 2010 16:29:27 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> We prefix pertient book keeping functions and variables with the
> 'swiotlb_tbl' prefix.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  lib/swiotlb.c |  149 +++++++++++++++++++++++++++++---------------------------
>  1 files changed, 77 insertions(+), 72 deletions(-)

Can we create the swiotlb initialization function instead of lots of
renaming and exporting iotlb values?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] swiotlb: add the swiotlb initialization function
with iotlb memory

This enables the caller to initialize swiotlb with its own iotlb
memory.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   48 +++++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..17b5298 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,6 +23,7 @@ extern int swiotlb_force;
 #define IO_TLB_SHIFT 11
 
 extern void swiotlb_init(int verbose);
+extern void swiotlb_init_with_tlb(char *tlb, unsigned long nslabs, int verbose);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5fddf72..a37ee04 100644
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
+void __init swiotlb_init_with_tlb(char *tlb, unsigned long nslabs, int verbose)
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
+	swiotlb_init_with_tlb(io_tlb_start, io_tlb_nslabs, verbose);
+}
+
 void __init
 swiotlb_init(int verbose)
 {
-- 
1.6.5

