Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2KVUoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:44:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2KVS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:45 -0500
Date: Wed, 21 Nov 2012 17:40:31 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-2086fe1159a9a75233b533986ccfcbd192bd9372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-4-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-4-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Move down find_early_table_space()
Git-Commit-ID: 2086fe1159a9a75233b533986ccfcbd192bd9372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:40:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2086fe1159a9a75233b533986ccfcbd192bd9372
Gitweb:     http://git.kernel.org/tip/2086fe1159a9a75233b533986ccfcbd192bd9372
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:40 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:02 -0800

x86, mm: Move down find_early_table_space()

It will need to call split_mem_range().
Move it down after that to avoid extra declaration.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-4-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 117 +++++++++++++++++++++++++++--------------------------
 1 file changed, 59 insertions(+), 58 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6368b86..701abbc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -36,64 +36,6 @@ struct map_range {
 };
 
 static int page_size_mask;
-/*
- * First calculate space needed for kernel direct mapping page tables to cover
- * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
- * pages. Then find enough contiguous space for those page tables.
- */
-static void __init find_early_table_space(struct map_range *mr, int nr_range)
-{
-	int i;
-	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
-	unsigned long start = 0, good_end;
-	phys_addr_t base;
-
-	for (i = 0; i < nr_range; i++) {
-		unsigned long range, extra;
-
-		range = mr[i].end - mr[i].start;
-		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
-
-		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
-			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
-			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-		} else {
-			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
-		}
-
-		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
-			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-			extra += PMD_SIZE;
-#endif
-			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		} else {
-			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		}
-	}
-
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
-	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
-
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
-	good_end = max_pfn_mapped << PAGE_SHIFT;
-
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
-	if (!base)
-		panic("Cannot find space for the kernel page tables");
-
-	pgt_buf_start = base >> PAGE_SHIFT;
-	pgt_buf_end = pgt_buf_start;
-	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
-
-	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
-		(pgt_buf_top << PAGE_SHIFT) - 1);
-}
 
 void probe_page_size_mask(void)
 {
@@ -250,6 +192,65 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 }
 
 /*
+ * First calculate space needed for kernel direct mapping page tables to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
+{
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
+	phys_addr_t base;
+
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
+
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
+
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
+
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+			extra += PMD_SIZE;
+#endif
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
+
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+	good_end = max_pfn_mapped << PAGE_SHIFT;
+
+	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	if (!base)
+		panic("Cannot find space for the kernel page tables");
+
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
+}
+
+/*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
