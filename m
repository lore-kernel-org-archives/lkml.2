Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2GaOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:09:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32416 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2GaOJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:09:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        JBeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] swiotlb: add the late swiotlb initialization function with iotlb memory
Date: Tue, 31 Jul 2012 10:00:21 -0400
Message-Id: <1343743223-30092-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
References: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the caller to initialize swiotlb with its own iotlb
memory late in the bootup.

See git commit eb605a5754d050a25a9f00d718fb173f24c486ef
"swiotlb: add swiotlb_tbl_map_single library function" which will
explain the full details of what it can be used for.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   31 +++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

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
index 45bc1f8..5d33651 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
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

