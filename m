Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2K1VzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:55:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37085 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2K1Vst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 20/46] x86, mm: Break down init_all_memory_mapping
Date: Wed, 28 Nov 2012 13:47:31 -0800
Message-Id: <1354139277-17376-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will replace that with top-down page table initialization.
New API need to take range: init_range_memory_mapping()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e212ae2..b6a0d25 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -398,40 +398,30 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  * Depending on the alignment of E820 ranges, this may possibly result in using
  * smaller size (i.e. 4K instead of 2M or 1G) page tables.
  */
-static void __init init_all_memory_mapping(void)
+static void __init init_range_memory_mapping(unsigned long range_start,
+					   unsigned long range_end)
 {
 	unsigned long start_pfn, end_pfn;
 	int i;
 
-	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
-
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		u64 start = (u64)start_pfn << PAGE_SHIFT;
 		u64 end = (u64)end_pfn << PAGE_SHIFT;
 
-		if (end <= ISA_END_ADDRESS)
+		if (end <= range_start)
 			continue;
 
-		if (start < ISA_END_ADDRESS)
-			start = ISA_END_ADDRESS;
-#ifdef CONFIG_X86_32
-		/* on 32 bit, we only map up to max_low_pfn */
-		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+		if (start < range_start)
+			start = range_start;
+
+		if (start >= range_end)
 			continue;
 
-		if ((end >> PAGE_SHIFT) > max_low_pfn)
-			end = max_low_pfn << PAGE_SHIFT;
-#endif
-		init_memory_mapping(start, end);
-	}
+		if (end > range_end)
+			end = range_end;
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
+		init_memory_mapping(start, end);
 	}
-#endif
 }
 
 void __init init_mem_mapping(void)
@@ -461,8 +451,15 @@ void __init init_mem_mapping(void)
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 
 	max_pfn_mapped = 0; /* will get exact value next */
-	init_all_memory_mapping();
-
+	/* the ISA range is always mapped regardless of memory holes */
+	init_memory_mapping(0, ISA_END_ADDRESS);
+	init_range_memory_mapping(ISA_END_ADDRESS, end);
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
-- 
1.7.7

