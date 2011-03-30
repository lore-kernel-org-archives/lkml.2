Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243Ab1C3VWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:22:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:23860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964902Ab1C3VJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903736521"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: yinghai@kernel.org, stefano.stabellini@eu.citrix.com, ak@linux.intel.com,
        hpa@zytor.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [225/275] x86: Cleanup highmap after brk is concluded
Message-Id: <20110330210750.9B0D63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Yinghai Lu <yinghai@kernel.org>

commit e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e upstream.

Now cleanup_highmap actually is in two steps: one is early in head64.c
and only clears above _end; a second one is in init_memory_mapping() and
tries to clean from _brk_end to _end.
It should check if those boundaries are PMD_SIZE aligned but currently
does not.
Also init_memory_mapping() is called several times for numa or memory
hotplug, so we really should not handle initial kernel mappings there.

This patch moves cleanup_highmap() down after _brk_end is settled so
we can do everything in one step.
Also we honor max_pfn_mapped in the implementation of cleanup_highmap.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |    5 +++++
 arch/x86/mm/init.c       |   19 -------------------
 arch/x86/mm/init_64.c    |   11 ++++++-----
 4 files changed, 11 insertions(+), 27 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/head64.c	2011-03-29 22:50:26.228587294 -0700
+++ linux-2.6.35.y/arch/x86/kernel/head64.c	2011-03-29 23:03:02.918225501 -0700
@@ -76,9 +76,6 @@
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
Index: linux-2.6.35.y/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/setup.c	2011-03-29 22:50:26.228587294 -0700
+++ linux-2.6.35.y/arch/x86/kernel/setup.c	2011-03-29 23:03:02.918225501 -0700
@@ -296,6 +296,9 @@
 static inline void init_gbpages(void)
 {
 }
+static void __init cleanup_highmap(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -926,6 +929,8 @@
 
 	reserve_brk();
 
+	cleanup_highmap();
+
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
Index: linux-2.6.35.y/arch/x86/mm/init.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/mm/init.c	2011-03-29 22:50:26.228587294 -0700
+++ linux-2.6.35.y/arch/x86/mm/init.c	2011-03-29 23:03:02.920225449 -0700
@@ -277,25 +277,6 @@
 	load_cr3(swapper_pg_dir);
 #endif
 
-#ifdef CONFIG_X86_64
-	if (!after_bootmem && !start) {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		mmu_cr4_features = read_cr4();
-
-		/*
-		 * _brk_end cannot change anymore, but it and _end may be
-		 * located on different 2M pages. cleanup_highmap(), however,
-		 * can only consider _end when it runs, so destroy any
-		 * mappings beyond _brk_end here.
-		 */
-		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
-	}
-#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && e820_table_end > e820_table_start)
Index: linux-2.6.35.y/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/mm/init_64.c	2011-03-29 22:50:26.228587294 -0700
+++ linux-2.6.35.y/arch/x86/mm/init_64.c	2011-03-29 23:03:02.921225423 -0700
@@ -50,6 +50,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 #include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
@@ -258,18 +259,18 @@
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
- * We limit the mappings to the region from _text to _end.  _end is
- * rounded up to the 2MB boundary. This catches the invalid pmds as
+ * We limit the mappings to the region from _text to _brk_end.  _brk_end
+ * is rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
+	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
-	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
-	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
+	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
