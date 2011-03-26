Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1CZAGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:06:48 -0400
Received: from kroah.org ([198.145.64.141]:35962 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485Ab1CZAGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:59 2011
Message-Id: <20110326000459.189962134@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:04:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [32/35] x86: Cleanup highmap after brk is concluded
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |    5 +++++
 arch/x86/mm/init.c       |   19 -------------------
 arch/x86/mm/init_64.c    |   11 ++++++-----
 4 files changed, 11 insertions(+), 27 deletions(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -76,9 +76,6 @@ void __init x86_64_start_kernel(char * r
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -295,6 +295,9 @@ static void __init init_gbpages(void)
 static inline void init_gbpages(void)
 {
 }
+static void __init cleanup_highmap(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -895,6 +898,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+	cleanup_highmap();
+
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -283,25 +283,6 @@ unsigned long __init_refok init_memory_m
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
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -49,6 +49,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 #include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
@@ -257,18 +258,18 @@ void __init init_extra_mapping_uc(unsign
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


