Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1FUUhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:37:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:39427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab1FUUhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:37:20 -0400
Date: Tue, 21 Jun 2011 20:37:07 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-8e7f9f8d40764a04454726c071ce5eac850ce219@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Calculate precisely the memory needed by init_memory_mapping
Git-Commit-ID: 8e7f9f8d40764a04454726c071ce5eac850ce219
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 20:37:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e7f9f8d40764a04454726c071ce5eac850ce219
Gitweb:     http://git.kernel.org/tip/8e7f9f8d40764a04454726c071ce5eac850ce219
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Tue, 7 Jun 2011 19:13:27 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Jun 2011 13:06:24 -0700

x86, mm: Calculate precisely the memory needed by init_memory_mapping

- take into account the size of the initial pagetable;

- remove the extra PMD_SIZE added when use_pse, because the previously
  allocated PMDs are always 2M aligned;

- remove the extra page added on x86_32 for the fixmap because is not
  needed: we allocate all possible PMDs statically in init_32.S and
  the pte entry is already allocated by early_ioremap_init.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Link: http://lkml.kernel.org/r/1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3032644..0cfe8d4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,22 +28,52 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+static void __init find_early_table_space(unsigned long start,
+		unsigned long end, int use_pse, int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	unsigned long pmds = 0, ptes = 0, tables = 0, good_end = end,
+				  pud_mapped = 0, pmd_mapped = 0, size = end - start;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	pud_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
+			(PUD_SIZE * PTRS_PER_PUD));
+	pud_mapped *= (PUD_SIZE * PTRS_PER_PUD);
+	pmd_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
+			(PMD_SIZE * PTRS_PER_PMD));
+	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
+
+	if (start < PFN_PHYS(max_pfn_mapped)) {
+		if (PFN_PHYS(max_pfn_mapped) < end)
+			size -= PFN_PHYS(max_pfn_mapped) - start;
+		else
+			size = 0;
+	}
+
+#ifndef __PAGETABLE_PUD_FOLDED
+	if (end > pud_mapped) {
+		unsigned long puds;
+		if (start < pud_mapped)
+			puds = (end - pud_mapped + PUD_SIZE - 1) >> PUD_SHIFT;
+		else
+			puds = (end - start + PUD_SIZE - 1) >> PUD_SHIFT;
+		tables += roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	}
+#endif
 
 	if (use_gbpages) {
 		unsigned long extra;
 
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	}
+#ifndef __PAGETABLE_PMD_FOLDED
+	else if (end > pmd_mapped) {
+		if (start < pmd_mapped)
+			pmds = (end - pmd_mapped + PMD_SIZE - 1) >> PMD_SHIFT;
+		else
+			pmds = (end - start + PMD_SIZE - 1) >> PMD_SHIFT;
+	}
+#endif
 
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
@@ -51,23 +81,20 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
-#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+	if (!tables)
+		return;
 
+#ifdef CONFIG_X86_32
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
 
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	base = memblock_find_in_range(0x00, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
@@ -261,7 +288,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(start, end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
@@ -275,6 +302,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
+	if (pgt_buf_end != pgt_buf_top)
+		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
+				" pages\n", pgt_buf_top - pgt_buf_end);
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
