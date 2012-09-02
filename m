Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2IBHtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:49:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40961 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2IBHr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:47:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 03/13] x86, mm: Moving init_memory_mapping calling
Date: Sun,  2 Sep 2012 00:46:49 -0700
Message-Id: <1346572019-15806-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from setup.c to mm/init.c

So could update all related calling together later

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h    |    1 -
 arch/x86/include/asm/pgtable.h |    2 +-
 arch/x86/kernel/setup.c        |   13 +------------
 arch/x86/mm/init.c             |   19 ++++++++++++++++++-
 4 files changed, 20 insertions(+), 15 deletions(-)

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
index e47e4db..ae2cabb 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -597,7 +597,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
-void probe_page_size_mask(void);
+void init_mem_mapping(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d6e8c03..c30c78c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -912,20 +912,9 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
-	probe_page_size_mask();
 
-	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
+	init_mem_mapping();
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 7d05e28..15a6a38 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -92,7 +92,7 @@ static void __init find_early_table_space(struct map_range *mr,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
-void probe_page_size_mask(void)
+static void __init probe_page_size_mask(void)
 {
 #if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
 	/*
@@ -312,6 +312,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
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

