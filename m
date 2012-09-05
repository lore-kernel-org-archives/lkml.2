Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2IEFrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:47:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20544 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab2IEFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:47:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 12/14] x86/mm: calculate_table_space_size based on memory ranges that are being mapped
Date: Tue,  4 Sep 2012 22:46:29 -0700
Message-Id: <1346823991-22911-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.shin@amd.com>

Current logic finds enough space for direct mapping page tables from 0
to end. Instead, we only need to find enough space to cover mr[0].start
to mr[nr_range].end -- the range that is actually being mapped by
init_memory_mapping()

This patch also reportedly fixes suspend/resume issue reported in:

https://lkml.org/lkml/2012/8/11/83

-v2: update with calculate_table_space_size()
     clear max_pfn_mapped before init_all_memory_mapping to get right value
					  -Yinghai Lu

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |   51 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 47b6e41..852023f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -191,39 +191,48 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-static unsigned long __init calculate_table_space_size(unsigned long begin,
+static unsigned long __init calculate_table_space_size(unsigned long start,
 					  unsigned long end)
 {
-	unsigned long puds, pmds, ptes, tables;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range, i;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	pr_info("calculate_table_space_size: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
 
-	if (page_size_mask & (1 << PG_LEVEL_1G)) {
-		unsigned long extra;
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+	nr_range = split_mem_range(mr, nr_range, start, end);
 
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
 
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
-	if (page_size_mask & (1 << PG_LEVEL_2M)) {
-		unsigned long extra;
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
 
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
 #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (begin < PMD_SIZE)
-			extra += (PMD_SIZE - begin) >> PAGE_SHIFT;
+			/* The first 2/4M doesn't use large pages. */
+			if (mr[i].start < PMD_SIZE)
+				extra += PMD_SIZE - mr[i].start;
 
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	}
 
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
-- 
1.7.7

