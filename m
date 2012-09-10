Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2IJT5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:57:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30377 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab2IJT5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:57:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/10] swiotlb: add the late swiotlb initialization function with iotlb memory
Date: Mon, 10 Sep 2012 15:46:00 -0400
Message-Id: <1347306367-28669-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the caller to initialize swiotlb with its own iotlb
memory late in the bootup.

See git commit eb605a5754d050a25a9f00d718fb173f24c486ef
"swiotlb: add swiotlb_tbl_map_single library function" which will
explain the full details of what it can be used for.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
[v1: Fold in smatch warning]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   33 ++++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e872526..8d08b3e 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -25,6 +25,7 @@ extern int swiotlb_force;
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 extern unsigned long swiotlb_nr_tbl(void);
+extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
 
 /*
  * Enumeration for sync targets
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 45bc1f8..f114bf6 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -170,7 +170,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
-void __init
+static void __init
 swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long bytes;
@@ -206,8 +206,9 @@ swiotlb_init(int verbose)
 int
 swiotlb_late_init_with_default_size(size_t default_size)
 {
-	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
+	unsigned long bytes, req_nslabs = io_tlb_nslabs;
 	unsigned int order;
+	int rc = 0;
 
 	if (!io_tlb_nslabs) {
 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
@@ -229,16 +230,32 @@ swiotlb_late_init_with_default_size(size_t default_size)
 		order--;
 	}
 
-	if (!io_tlb_start)
-		goto cleanup1;
-
+	if (!io_tlb_start) {
+		io_tlb_nslabs = req_nslabs;
+		return -ENOMEM;
+	}
 	if (order != get_order(bytes)) {
 		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
 		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
-		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	}
+	rc = swiotlb_late_init_with_tbl(io_tlb_start, io_tlb_nslabs);
+	if (rc)
+		free_pages((unsigned long)io_tlb_start, order);
+	return rc;
+}
+
+int
+swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
+{
+	unsigned long i, bytes;
+
+	bytes = nslabs << IO_TLB_SHIFT;
+
+	io_tlb_nslabs = nslabs;
+	io_tlb_start = tlb;
 	io_tlb_end = io_tlb_start + bytes;
+
 	memset(io_tlb_start, 0, bytes);
 
 	/*
@@ -288,10 +305,8 @@ cleanup3:
 	io_tlb_list = NULL;
 cleanup2:
 	io_tlb_end = NULL;
-	free_pages((unsigned long)io_tlb_start, order);
 	io_tlb_start = NULL;
-cleanup1:
-	io_tlb_nslabs = req_nslabs;
+	io_tlb_nslabs = 0;
 	return -ENOMEM;
 }
 
-- 
1.7.7.6

