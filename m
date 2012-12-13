Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2LMWEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:04:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50531 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2LMWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Yinghai Lu <yinghai@kerne.org>
Subject: [PATCH v6 23/27] x86: Don't panic if can not alloc buffer for swiotlb
Date: Thu, 13 Dec 2012 14:02:17 -0800
Message-Id: <1355436141-8668-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normal boot path on system with iommu support:
swiotlb buffer will be allocated early at first and then try to initialize
iommu, if iommu for intel or amd could setup properly, swiotlb buffer
will be freed.

The early allocating is with bootmem, and could panic when we try to use
kdump with buffer above 4G only.

Replace the panic with WARN, and the kernel can go on without swiotlb,
and could iommu later.

Signed-off-by: Yinghai Lu <yinghai@kerne.org>
---
 arch/x86/kernel/pci-swiotlb.c |    5 ++++-
 include/linux/swiotlb.h       |    2 +-
 lib/swiotlb.c                 |   17 +++++++++++------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 6c483ba..6f93eb7 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -91,7 +91,10 @@ IOMMU_INIT(pci_swiotlb_detect_4gb,
 void __init pci_swiotlb_init(void)
 {
 	if (swiotlb) {
-		swiotlb_init(0);
+		if (swiotlb_init(0)) {
+			swiotlb = 0;
+			return;
+		}
 		dma_ops = &swiotlb_dma_ops;
 	}
 }
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8d08b3e..f7535d1 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -22,7 +22,7 @@ extern int swiotlb_force;
  */
 #define IO_TLB_SHIFT 11
 
-extern void swiotlb_init(int verbose);
+int swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 extern unsigned long swiotlb_nr_tbl(void);
 extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f114bf6..6b99ea7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -170,7 +170,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
-static void __init
+static int __init
 swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long bytes;
@@ -185,17 +185,22 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
-	if (!io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
+	io_tlb_start = alloc_bootmem_low_pages_nopanic(PAGE_ALIGN(bytes));
+	if (!io_tlb_start) {
+		WARN(1, "Cannot allocate SWIOTLB buffer");
+		return -1;
+	}
 
 	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
+
+	return 0;
 }
 
-void __init
+int __init
 swiotlb_init(int verbose)
 {
-	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
+	/* default to 64MB */
+	return swiotlb_init_with_default_size(64 * (1<<20), verbose);
 }
 
 /*
-- 
1.7.10.4

