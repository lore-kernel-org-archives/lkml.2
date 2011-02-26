Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab1BZDIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 22:08:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31388 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1BZDIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:08:47 -0500
Message-ID: <4D686E37.6080702@kernel.org>
Date: Fri, 25 Feb 2011 19:06:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86, mm:  Introduce global page_size_mask
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org> <4D657359.5060901@kernel.org> <20110223210326.GB27738@atj.dyndns.org> <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com> <20110224091557.GD7840@htj.dyndns.org> <4D674A33.8000809@kernel.org> <20110225100336.GA26608@elte.hu>
In-Reply-To: <20110225100336.GA26608@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D686EA9.00FC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add probe_page_size_mask() to detect if need to use 1G or 2M.
and store them in page_size_mask.

Only probe them at first init_memory_mapping calling.
second and later init_memory_mapping() calling does not need probe again.
also we don't need to pass use_gbpages around.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signe-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pgtable.h |    1 
 arch/x86/mm/init.c             |   70 +++++++++++++++++++++--------------------
 2 files changed, 37 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h
+++ linux-2.6/arch/x86/include/asm/pgtable.h
@@ -597,6 +597,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
+extern int page_size_mask;
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -30,8 +30,9 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+int page_size_mask = -1;
+
+static void __init find_early_table_space(unsigned long end)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -39,7 +40,7 @@ static void __init find_early_table_spac
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
-	if (use_gbpages) {
+	if (page_size_mask & (1 << PG_LEVEL_1G)) {
 		unsigned long extra;
 
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
@@ -49,7 +50,7 @@ static void __init find_early_table_spac
 
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
-	if (use_pse) {
+	if (page_size_mask & (1 << PG_LEVEL_2M)) {
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
@@ -81,6 +82,35 @@ static void __init find_early_table_spac
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
+static void probe_page_size_mask(void)
+{
+	if (page_size_mask != -1)
+		return;
+
+	page_size_mask = 0;
+#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	if (direct_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (cpu_has_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+}
+
 struct map_range {
 	unsigned long start;
 	unsigned long end;
@@ -117,43 +147,15 @@ static int __meminit save_mr(struct map_
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long ret = 0;
 	unsigned long pos;
-
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
+	probe_page_size_mask();
 
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
@@ -258,7 +260,7 @@ unsigned long __init_refok init_memory_m
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(end);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
