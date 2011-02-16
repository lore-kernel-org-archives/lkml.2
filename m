Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1BPRgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:36:40 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:4394 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1BPRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:36:37 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291593600"; 
   d="scan'208";a="4363142"
Date: Wed, 16 Feb 2011 17:36:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D598A3A.9080802@zytor.com>
Message-ID: <alpine.DEB.2.00.1102161719450.2826@kaball-desktop>
References: <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org> <4D50B4B5.4050505@kernel.org> <4D519AAA.8070309@zytor.com> <4D547962.8040403@goop.org> <4D547B74.1030302@kernel.org>
 <4D54844B.4010007@zytor.com> <4D5488D5.2020607@kernel.org> <20110214162602.GB11290@dumpdata.com> <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com> <4D598A3A.9080802@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, H. Peter Anvin wrote:
> On 02/14/2011 09:55 AM, Yinghai Lu wrote:
> > 
> > Assume, we can update vmlinux.lds.S to make _end to be 2M aligned as
> > Stefano suggested?
> > 
> 
> I am concerned about this.  This feels like papering over a bug.
> 

I think the current memblock implementation assumes that the memory that
has been marked as reserved can still be safely removed from the initial
pagetable mappings.
This assumption is clear considering that we are marking the ramdisk as
reserved in x86_64_start_reservations but we are clearing the mappings
for it in cleanup_highmap.
I am not sure if this assumption is correct in the general case, but it
is not correct in our particular scenario.

If the assumption is not correct, then fixing it will also fix our
problem.
If the assumption is correct then we'll have to find another way, and I
think that the appended patch is probably the best way to do it.
The basic ideas behind the patch are:

- we want to move cleanup_highmap() to setup_arch, like Yinghai Lu
suggested;

- we want to honor max_pfn_mapped in cleanup_highmap;

- on xen we set max_pfn_mapped to the last pfn that is safe to remove
from the initial mappings.


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
 
