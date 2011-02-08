Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1BHUX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:23:59 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:25680 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1BHUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:23:58 -0500
X-IronPort-AV: E=Sophos;i="4.60,443,1291593600"; 
   d="scan'208";a="4224114"
Date: Tue, 8 Feb 2011 20:26:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@Oracle.Com>,
        Yinghai Lu <yinghai@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D51985B.7080003@goop.org>
Message-ID: <alpine.DEB.2.00.1102081936480.7277@kaball-desktop>
References: <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org>
 <4D50B4B5.4050505@kernel.org> <4D50CCFA.1040004@goop.org> <AANLkTi=koyyz8h1A3qWbp2F+N3kA46rJfHPSPN+Ms8hm@mail.gmail.com> <20110208145551.GA4606@dumpdata.com> <4D51985B.7080003@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Jeremy Fitzhardinge wrote:
> On 02/08/2011 06:55 AM, Konrad Rzeszutek Wilk wrote:
> >>>> could be used to skip clear highmap for xen path?
> >>> Seems pretty ad-hoc.
> >>>
> >> then what is size for mfn-list after _end...
> > 8 bytes * nr_pages. For 4GB, 2048 pages. For 32GB, 8192 pages. For 128GB,
> > 32768 pages, and so on.
> >> could be copied or move to BRK.
> > The _brk size is determined during build-time. We don't know what the
> > memory size will be during bootup time and would have to select the
> > highest values (128MB) which is quite a large amount to be reserved
> > in _brk area.
> 
> If the brk is guaranteed to be the last thing in the kernel, we could
> remove the static allocation of brk space, and just make it dynamic, and
> then use the dynamic end-of-brk instead of _end.
> 
> That would require mapping the brk space at runtime, which would require
> a (conservative) runtime estimate of how much space we would end up
> needing, I guess by adding together the static allocations and then
> adding any dynamic ones we need.
> 
> For Xen, specifically, we could just extend brk to include all the stuff
> the domain builder sticks after the kernel, so it would both be brk
> allocated and left in-situ.

A simpler alternative would be to set max_pfn_mapped = __pa(mfn_list) on
xen, after all the mappings after _end are special mappings without a
corresponding pfn. It shouldn't have any undesired side effects because
max_pfn_mapped is updated soon after cleanup_highmap() anyway
in arch/x86/kernel/setup.c:setup_arch.
Then we use vaddr + (max_pfn_mapped << PAGE_SHIFT) as the memory limit
in cleanup_highmap.
The following patch is a proof of concept but it boots successfully on
xen and on native:


diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 2d2673c..5655c22 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -77,9 +77,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..f03e6e0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -297,6 +297,9 @@ static void __init init_gbpages(void)
 static inline void init_gbpages(void)
 {
 }
+static void __init cleanup_highmap(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -922,6 +925,9 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	reserve_brk();
 
+	/* Cleanup the over mapped high alias after _brk_end*/
+	cleanup_highmap();
+
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 947f42a..f13ff3a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -279,25 +279,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
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
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..a8d08c2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -51,6 +51,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
@@ -293,18 +294,18 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
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
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..73a21db 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1653,9 +1653,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1713,6 +1710,8 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	pud_t *l3;
 	pmd_t *l2;
 
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+
 	/* Zap identity mapping */
 	init_level4_pgt[0] = __pgd(0);
 
