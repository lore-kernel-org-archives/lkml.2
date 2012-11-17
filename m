Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2KQDkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:40:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27309 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2KQDkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 04/46] x86, mm: Move init_memory_mapping calling out of setup.c
Date: Fri, 16 Nov 2012 19:38:41 -0800
Message-Id: <1353123563-3103-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now init_memory_mapping is called two times, later will be called for every
ram ranges.

Could put all related init_mem calling together and out of setup.c.

Actually, it reverts commit 1bbbbe7
    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
will address that later with complete solution include handling hole under 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/init.h    |    1 -
 arch/x86/include/asm/pgtable.h |    2 +-
 arch/x86/kernel/setup.c        |   27 +--------------------------
 arch/x86/mm/init.c             |   19 ++++++++++++++++++-
 4 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index adcc0ae..4f13998 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -12,7 +12,6 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask);
 
-
 extern unsigned long __initdata pgt_buf_start;
 extern unsigned long __meminitdata pgt_buf_end;
 extern unsigned long __meminitdata pgt_buf_top;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 98ac76d..dd1a888 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -602,7 +602,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
-void probe_page_size_mask(void);
+void init_mem_mapping(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 01fb5f9..23b079f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,34 +913,9 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
-	probe_page_size_mask();
 
-	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
+	init_mem_mapping();
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		int i;
-		unsigned long start, end;
-		unsigned long start_pfn, end_pfn;
-
-		for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
-							 NULL) {
-
-			end = PFN_PHYS(end_pfn);
-			if (end <= (1UL<<32))
-				continue;
-
-			start = PFN_PHYS(start_pfn);
-			max_pfn_mapped = init_memory_mapping(
-						max((1UL<<32), start), end);
-		}
-
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 701abbc..9e17f9e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -37,7 +37,7 @@ struct map_range {
 
 static int page_size_mask;
 
-void probe_page_size_mask(void)
+static void __init probe_page_size_mask(void)
 {
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
 	/*
@@ -315,6 +315,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	return ret >> PAGE_SHIFT;
 }
 
+void __init init_mem_mapping(void)
+{
+	probe_page_size_mask();
+
+	/* max_pfn_mapped is updated here */
+	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	max_pfn_mapped = max_low_pfn_mapped;
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
+}
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
-- 
1.7.7

