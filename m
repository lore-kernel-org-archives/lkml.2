Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2HIVX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:23:29 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:36001
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab2HIVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:23:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8IBEX-02-FMJ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/5] x86: find_early_table_space based on memory ranges that are being mapped
Date: Thu, 9 Aug 2012 16:23:06 -0500
Message-ID: <1344547389-4599-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current logic finds enough space to cover number of tables from 0 to end.
Instead, we only need to find enough space to cover from mr[0].start to
mr[nr_range].end.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/mm/init.c |   57 +++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..d4e01a7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,40 +35,43 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
-static void __init find_early_table_space(struct map_range *mr, unsigned long end,
-					  int use_pse, int use_gbpages)
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (use_gbpages) {
-		unsigned long extra;
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
 
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
-	if (use_pse) {
-		unsigned long extra;
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
 
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
 #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
-
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
@@ -86,7 +89,7 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
@@ -267,7 +270,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-- 
1.7.9.5


