Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1KAN7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:59:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44940 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1KAN7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:59:03 -0400
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 7/7] x86, mm: Unify zone_sizes_init()
Date: Tue,  1 Nov 2011 15:58:22 +0200
Message-Id: <1320155902-10424-7-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that zone_sizes_init() is identical on 32-bit and 64-bit, move the code to
arch/x86/mm/init.c and use it for both architectures.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/init.h |    2 ++
 arch/x86/mm/init.c          |   23 +++++++++++++++++++++++
 arch/x86/mm/init_32.c       |   19 -------------------
 arch/x86/mm/init_64.c       |   19 -------------------
 4 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 8dbe353..adcc0ae 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -5,6 +5,8 @@
 extern void __init early_ioremap_page_table_range_init(void);
 #endif
 
+extern void __init zone_sizes_init(void);
+
 extern unsigned long __init
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 87488b9..2426b60 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -3,6 +3,7 @@
 #include <linux/ioport.h>
 #include <linux/swap.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>	/* for max_low_pfn */
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -15,6 +16,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/proto.h>
+#include <asm/dma.h>		/* for MAX_DMA_PFN */
 
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
@@ -392,3 +394,24 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	free_init_pages("initrd memory", start, PAGE_ALIGN(end));
 }
 #endif
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
+#endif
+	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
+#endif
+
+	free_area_init_nodes(max_zone_pfns);
+}
+
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 27455b9..3bebaed 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -674,25 +674,6 @@ void __init initmem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static void __init zone_sizes_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
-#ifdef CONFIG_ZONE_DMA32
-        max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-#endif
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
-#endif
-
-	free_area_init_nodes(max_zone_pfns);
-}
-
 void __init setup_bootmem_allocator(void)
 {
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 06c4360..6fcce7d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -612,25 +612,6 @@ void __init initmem_init(void)
 }
 #endif
 
-static void __init zone_sizes_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-#endif
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
-#endif
-
-	free_area_init_nodes(max_zone_pfns);
-}
-
 void __init paging_init(void)
 {
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
-- 
1.7.6.4

