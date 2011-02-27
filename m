Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1B0VWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:22:01 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:51666 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1B0VVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:21:49 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 2/2] head_32.S: Update the comments for the initial kernel mapping(KERNEL_IMAGE_SIZE no longer used)
Date: Sun, 27 Feb 2011 23:21:38 +0200
Message-Id: <1298841698-31823-3-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sun, 27 Feb 2011 23:21:48 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the comments regarding the initial kernel mapping in head_32.S and 
cleanup the code(KERNEL_IMAGE_SIZE no longer used).

Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
---
 arch/x86/kernel/head_32.S |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 187aa63..77990a5 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -39,42 +39,32 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory in addition to the memory covered up to
- * and including _end we need mapped initially.
- * We need:
- *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
- *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
- *
- * Modulo rounding, each megabyte assigned here requires a kilobyte of
- * memory, which is currently unreclaimed.
- *
- * This should be a multiple of a page.
- *
- * KERNEL_IMAGE_SIZE should be greater than pa(_end)
- * and small than max_low_pfn, otherwise will waste some page table entries
+ * Worst-case size of the kernel mapping we need to make:
+ * a relocatable kernel can live anywhere in lowmem, so we need to be able
+ * to map all of lowmem.
  */
 
-#if PTRS_PER_PMD > 1
-#define PAGE_TABLE_SIZE(pages) (((pages) / PTRS_PER_PMD) + PTRS_PER_PGD)
-#else
-#define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
-#endif
-
 /* Number of possible pages in the lowmem region */
 LOWMEM_PAGES = (((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT)
-	
-/* Enough space to fit pagetables for the low memory linear map */
-MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
 
 /*
- * Worst-case size of the kernel mapping we need to make:
- * a relocatable kernel can live anywhere in lowmem, so we need to be able
- * to map all of lowmem.
+ * This is the size of the pagetable(in pages) we need for the kernel mapping.
+ * We need:
+ *     LOWMEM_PAGES / 1024 pages (worst case, non PAE)
+ *     LOWMEM_PAGES / 512 + 4 pages (worst casem, PAE)
  */
-KERNEL_PAGES = LOWMEM_PAGES
 
-INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE
+#if PTRS_PER_PMD > 1
+#define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PMD) + PTRS_PER_PGD
+#else
+#define PAGE_TABLE_SIZE(pages) (pages) / PTRS_PER_PGD
+#endif
+
+INIT_MAP_SIZE = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
 RESERVE_BRK(pagetables, INIT_MAP_SIZE)
+	
+/* Map enough space after _end for the lowmem linear map */
+MAPPING_BEYOND_END = INIT_MAP_SIZE
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
-- 
1.7.4.1

