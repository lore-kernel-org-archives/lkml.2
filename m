Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1BHDPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:15:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57041 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1BHDPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:15:08 -0500
Message-ID: <4D50B4B5.4050505@kernel.org>
Date: Mon, 07 Feb 2011 19:12:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org>
In-Reply-To: <4D506A85.9030802@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D50B52C.00A0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 01:56 PM, Jeremy Fitzhardinge wrote:
> On 02/07/2011 11:00 AM, Yinghai Lu wrote:
>> On 02/07/2011 10:58 AM, Stefano Stabellini wrote:
>>> On Mon, 7 Feb 2011, Yinghai Lu wrote:
>>>> On 02/07/2011 08:50 AM, Stefano Stabellini wrote:
>>>>> On Sun, 6 Feb 2011, Yinghai Lu wrote:
>>>>>> On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
>>>>>>> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>>>>>>>> why not just move calling cleanup_highmap down?
>>>>>>>>
>>>>>>>> something like attached patch.
>>>>>>> This patch looks very clean and looks on the surface of it like it is
>>>>>>> removing some ugly ad hoc code, but (as always) it needs a description
>>>>>>> about the problem it solves and why it is correct.
>>>>>> Sure.
>>>>>>
>>>>>>
>>>>>> Jeremy and xen guys, can you please check if it works well with xen ?
>>>>>>
>>>>> Actually this patch makes things worse on xen, because before
>>>>> cleanup_highmap() wasn't called at all on xen (on purpose) and now it
>>>>> is, fully destroying all the mappings we have at _end.
>>>>>
>>>>> Can we add a check on memblock reserved regions in cleanup_highmap()?
>>>>> Otherwise could we avoid calling cleanup_highmap() at all on xen?
>>>> why DO xen need over-mapped kernel initial mapping?
>>>>
>>>> what is in that range after _end to 512M?
>>> The mfn list that is the list of machine frame numbers assigned to this
>>> domain; it is used across the kernel to convert pfns into mfns.
>>> It passed to us at that address by the domain builder.
>> is it possible for you to pass physical address, and then map it in kernel?
> 
> That is possible in principle, but very difficult in practice.
> 
> What's wrong with honouring reserved memory ranges under all circumstances?

why punishing native path with those checking?

please check if

+	 * max_pfn_mapped is set to KERNEL_IMAGE_SIZE >> PAGE_SHIFT in
+	 *   head64.c::x86_start_kernel(), aka native path
+	 */
+	if (max_pfn_mapped != (KERNEL_IMAGE_SIZE >> PAGE_SHIFT))
+		return;

could be used to skip clear highmap for xen path?

Thanks

Yinghai



[PATCH -v2] x86: Cleanup highmap after brk is concluded

Now cleanup_high actually is two steps. one is early in head64.c.
and it only clear above _end. later will try to clean from _brk_end to _end.
it will need to double check if those boundary are PMD_SIZE aligned...

Also init_memory_mapping() are called several times for numa or memory hotplug.
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
 arch/x86/mm/init_64.c             |   20 +++++++++++++++-----
 5 files changed, 22 insertions(+), 28 deletions(-)

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
@@ -297,12 +297,22 @@ void __init init_extra_mapping_uc(unsign
  * rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
-void __init cleanup_highmap(void)
+void __init cleanup_highmap(unsigned long end)
 {
-	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
-	pmd_t *pmd = level2_kernel_pgt;
-	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
+	unsigned long vaddr;
+	pmd_t *pmd, *last_pmd;
+
+	/*
+	 * max_pfn_mapped is set to KERNEL_IMAGE_SIZE >> PAGE_SHIFT in
+	 *   head64.c::x86_start_kernel(), aka native path
+	 */
+	if (max_pfn_mapped != (KERNEL_IMAGE_SIZE >> PAGE_SHIFT))
+		return;
+
+	vaddr = __START_KERNEL_map;
+	pmd = level2_kernel_pgt;
+	last_pmd = pmd + PTRS_PER_PMD;
+	end = roundup(end, PMD_SIZE) - 1;
 
 	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
