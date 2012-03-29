Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2C2KCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:02:48 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:63416 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab2C2KCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:02:41 -0400
Date: Thu, 29 Mar 2012 19:02:52 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] linux: ARM: memmap: Revise freeing unused memmap entries for SPARSEMEM
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120329190113.3891.38390934@jp.panasonic.com>
References: <20120329190113.3891.38390934@jp.panasonic.com>
Message-Id: <20120329190252.3895.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPARSEMEM code allocates memmap entries for each present section.
Though free_unused_memmap() try to free unused memmap entries,
there remains some unused memmap entries which can be freed potentially,
since free_unused_memmap() does not take it into account that
there might exist unused memory regions on the top of each section.

Let's consider the following memory configuration:

    |<------section0------->|<---------hole-------->|<------section1------>|
    +---+-----+---+-----+---+-----------------------+---+--------------+---+
    |   |bank0|   |bank1|   |                       |   |     bank2    |   |
    +---+-----+---+-----+---+-----------------------+---+--------------+---+
    |<->|     |<->|     |<->|                       |<->|              |<->|
     F0        F1        F2                          F3                 F4

F0-F4 is the unused memory regions and their corresponding memmap entries
can be freed. However, free_unused_memmap() only frees the entries for
F1/F2/F4, and does not free the entries for F0/F3.

This patch revises free_unused_memmap() so that all unused memmap entries
are freed. I divide free_unused_memmap() into FLATMEM version and
SPARSEMEM version, and introduce a for loop by section for SPARSEMEM version.

Also, this patch fixes "start_pg = pfn_to_page(start_pfn - 1) + 1" line
in free_memmap(). This line was changed by the past commit
"3257f43d9296ed7adcc84e48f6ddf5313cf29266".
But this change should be reverted now, because I think it was a workaround
for the present free_unused_memmap() code.
Let's consider again the memory configuration above. Without reverted the line,
pfn_to_page() returns a wrong value when freeing F0/F3.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
---
 arch/arm/mm/init.c |   81 +++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 245a55a..634486b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -444,10 +444,15 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 	struct page *start_pg, *end_pg;
 	unsigned long pg, pgend;
 
+	printk(KERN_INFO
+		"Freeing memmap entries: %4ld KB (PFN 0x%05lx-0x%05lx)\n",
+		((end_pfn - start_pfn) * sizeof(struct page) / 1024),
+		start_pfn, end_pfn);
+
 	/*
 	 * Convert start_pfn/end_pfn to a struct page pointer.
 	 */
-	start_pg = pfn_to_page(start_pfn - 1) + 1;
+	start_pg = pfn_to_page(start_pfn);
 	end_pg = pfn_to_page(end_pfn - 1) + 1;
 
 	/*
@@ -468,6 +473,63 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 /*
  * The mem_map array can get very big.  Free the unused area of the memory map.
  */
+#ifdef CONFIG_SPARSEMEM
+static void __init free_unused_memmap(struct meminfo *mi)
+{
+	unsigned long pnum;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		unsigned long sec_start = section_nr_to_pfn(pnum);
+		unsigned long sec_end = sec_start + (1UL << PFN_SECTION_SHIFT);
+		unsigned long free_start, free_end;
+		unsigned int i;
+
+		if (!valid_section_nr(pnum))
+			continue;
+
+		free_start = sec_start;
+
+		/*
+		 * This relies on each bank being in address order.
+		 * The banks are sorted previously in bootmem_init().
+		 */
+		for_each_bank(i, mi) {
+			struct membank *bank = &mi->bank[i];
+			unsigned long bank_start = bank_pfn_start(bank);
+			unsigned long bank_end = bank_pfn_end(bank);
+
+			/*
+			 * If this bank is out of range for this section,
+			 * skip it.
+			 */
+			if (sec_end <= bank_start || bank_end <= sec_start)
+				continue;
+
+			/*
+			 * Align down here since the VM subsystem insists that
+			 * the memmap entries are valid from the bank start
+			 * aligned to MAX_ORDER_NR_PAGES.
+			 */
+			free_end = round_down(bank_start, MAX_ORDER_NR_PAGES);
+
+			if (free_start < free_end)
+				free_memmap(free_start, free_end);
+
+			/*
+			 * Align up here since the VM subsystem insists that
+			 * the memmap entries are valid from the bank end
+			 * aligned to MAX_ORDER_NR_PAGES.
+			 */
+			free_start = ALIGN(bank_end, MAX_ORDER_NR_PAGES);
+		}
+
+		free_end = sec_end;
+
+		if (free_start < free_end)
+			free_memmap(free_start, free_end);
+	}
+}
+#else /* CONFIG_SPARSEMEM */
 static void __init free_unused_memmap(struct meminfo *mi)
 {
 	unsigned long bank_start, prev_bank_end = 0;
@@ -482,21 +544,13 @@ static void __init free_unused_memmap(struct meminfo *mi)
 
 		bank_start = bank_pfn_start(bank);
 
-#ifdef CONFIG_SPARSEMEM
-		/*
-		 * Take care not to free memmap entries that don't exist
-		 * due to SPARSEMEM sections which aren't present.
-		 */
-		bank_start = min(bank_start,
-				 ALIGN(prev_bank_end, PAGES_PER_SECTION));
-#else
 		/*
 		 * Align down here since the VM subsystem insists that the
 		 * memmap entries are valid from the bank start aligned to
 		 * MAX_ORDER_NR_PAGES.
 		 */
 		bank_start = round_down(bank_start, MAX_ORDER_NR_PAGES);
-#endif
+
 		/*
 		 * If we had a previous bank, and there is a space
 		 * between the current bank and the previous, free it.
@@ -511,13 +565,8 @@ static void __init free_unused_memmap(struct meminfo *mi)
 		 */
 		prev_bank_end = ALIGN(bank_pfn_end(bank), MAX_ORDER_NR_PAGES);
 	}
-
-#ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_bank_end, PAGES_PER_SECTION))
-		free_memmap(prev_bank_end,
-			    ALIGN(prev_bank_end, PAGES_PER_SECTION));
-#endif
 }
+#endif /* CONFIG_SPARSEMEM */
 
 static void __init free_highpages(void)
 {
-- 
1.7.4.1


