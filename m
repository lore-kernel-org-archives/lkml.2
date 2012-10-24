Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303Ab2JXVtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:49:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269Ab2JXVts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:49:48 -0400
Date: Wed, 24 Oct 2012 14:49:27 -0700
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-844ab6f993b1d32eb40512503d35ff6ad0c57030@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        trini@ti.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, trini@ti.com,
        hpa@linux.intel.com
In-Reply-To: <20121024195311.GB11779@jshin-Toonie>
References: <20121024195311.GB11779@jshin-Toonie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm:
  Find_early_table_space based on ranges that are actually being mapped
Git-Commit-ID: 844ab6f993b1d32eb40512503d35ff6ad0c57030
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 14:49:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  844ab6f993b1d32eb40512503d35ff6ad0c57030
Gitweb:     http://git.kernel.org/tip/844ab6f993b1d32eb40512503d35ff6ad0c57030
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Wed, 24 Oct 2012 14:24:44 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 24 Oct 2012 13:37:04 -0700

x86, mm: Find_early_table_space based on ranges that are actually being mapped

Current logic finds enough space for direct mapping page tables from 0
to end. Instead, we only need to find enough space to cover mr[0].start
to mr[nr_range].end -- the range that is actually being mapped by
init_memory_mapping()

This is needed after 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a, to address
the panic reported here:

  https://lkml.org/lkml/2012/10/20/160
  https://lkml.org/lkml/2012/10/21/157

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/20121024195311.GB11779@jshin-Toonie
Tested-by: Tom Rini <trini@ti.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |   70 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8653b3a..bc287d6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -29,36 +29,54 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+/*
+ * First calculate space needed for kernel direct mapping page tables to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
 
-	if (use_gbpages) {
-		unsigned long extra;
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
 
-	if (use_pse) {
-		unsigned long extra;
-
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
 #endif
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			/* The first 2/4M doesn't use large pages. */
+			if (mr[i].start < PMD_SIZE)
+				extra += range;
+
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
 
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
@@ -76,7 +94,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
@@ -85,12 +103,6 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_reserve(start, end - start);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -263,7 +275,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
