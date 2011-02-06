Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1BFTZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:25:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44972 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1BFTZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:25:21 -0500
Message-ID: <4D4EF553.6000000@kernel.org>
Date: Sun, 06 Feb 2011 11:24:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>	<4D4A3782.3050702@zytor.com>	<alpine.DEB.2.00.1102031114030.7277@kaball-desktop>	<4D4ADFAD.7060507@zytor.com>	<alpine.DEB.2.00.1102041130060.7277@kaball-desktop>	<4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com>
In-Reply-To: <4D4E4E0D.2080806@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D4EF593.00A6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>> why not just move calling cleanup_highmap down?
>>
>> something like attached patch.
> 
> This patch looks very clean and looks on the surface of it like it is
> removing some ugly ad hoc code, but (as always) it needs a description
> about the problem it solves and why it is correct.

Sure.


Jeremy and xen guys, can you please check if it works well with xen ?

Thanks


[PATCH] x86: Cleanup highmap after brk is concluded

now cleanup_high actually two step. one is early in head64.c.
and it only clear above _end. later will try to clean from _brk_end to _end.
it will need to double check if those boundary are PMD_SIZE aligned...

Also init_memory_mapping() is called several times for numa or memory hotplug.
and it deals real memory mapping instead of initial kernel mapping.
We really should not handle initial kernel mapping there.

We can move cleanup_highmap() calling down after _brk_end is settled and pass
_brk_end with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pgtable_64.h |    2 +-
 arch/x86/kernel/head64.c          |    3 ---
 arch/x86/kernel/setup.c           |    6 ++++++
 arch/x86/mm/init.c                |   19 -------------------
 arch/x86/mm/init_64.c             |    5 +++--
 5 files changed, 10 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_64.h
+++ linux-2.6/arch/x86/include/asm/pgtable_64.h
@@ -165,7 +165,7 @@ static inline int pgd_large(pgd_t pgd) {
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
 extern int kern_addr_valid(unsigned long addr);
-extern void cleanup_highmap(void);
+extern void cleanup_highmap(unsigned long end);
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -77,9 +77,6 @@ void __init x86_64_start_kernel(char * r
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -297,6 +297,9 @@ static void __init init_gbpages(void)
 static inline void init_gbpages(void)
 {
 }
+static void __init cleanup_highmap(unsigned long end)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -922,6 +925,9 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	reserve_brk();
 
+	/* Cleanup the over mapped high alias after _brk_end*/
+	cleanup_highmap(_brk_end);
+
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -279,25 +279,6 @@ unsigned long __init_refok init_memory_m
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
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -297,13 +297,14 @@ void __init init_extra_mapping_uc(unsign
  * rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
-void __init cleanup_highmap(void)
+void __init cleanup_highmap(unsigned long end)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
+	end = roundup(end, PMD_SIZE) - 1;
+
 	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
