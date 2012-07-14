Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2GNNlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:41:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61538 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2GNNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:41:15 -0400
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] x86/mm: Simplify memory mapping PFN calculation
Date: Sat, 14 Jul 2012 16:41:05 +0300
Message-Id: <1342273267-2108-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two new helper functions, addr_to_pmd_pfn() and
addr_to_pud_pfn(), to simplify init_memory_mapping() code flow.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..9eb53c2 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -117,6 +117,16 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+static unsigned long addr_to_pmd_pfn(unsigned long addr)
+{
+	return (addr >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+}
+
+static unsigned long addr_to_pud_pfn(unsigned long addr)
+{
+	return (addr >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -180,11 +190,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (pos == 0)
 		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
 	else
-		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-				 << (PMD_SHIFT - PAGE_SHIFT);
+		end_pfn = addr_to_pmd_pfn(pos + (PMD_SIZE - 1));
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
-			<< (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = addr_to_pmd_pfn(pos + (PMD_SIZE - 1));
 #endif
 	if (end_pfn > (end >> PAGE_SHIFT))
 		end_pfn = end >> PAGE_SHIFT;
@@ -194,15 +202,13 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	}
 
 	/* big page (2M) range */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = addr_to_pmd_pfn(pos + (PMD_SIZE - 1));
 #ifdef CONFIG_X86_32
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = addr_to_pmd_pfn(end);
 #else /* CONFIG_X86_64 */
-	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+	end_pfn = addr_to_pud_pfn(pos + (PUD_SIZE - 1));
+	if (end_pfn > addr_to_pmd_pfn(end))
+		end_pfn = addr_to_pmd_pfn(end);
 #endif
 
 	if (start_pfn < end_pfn) {
@@ -213,9 +219,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 #ifdef CONFIG_X86_64
 	/* big page (1G) range */
-	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
-			 << (PUD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	start_pfn = addr_to_pud_pfn(pos + (PUD_SIZE - 1));
+	end_pfn = addr_to_pud_pfn(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
@@ -224,9 +229,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
-			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	start_pfn = addr_to_pmd_pfn(pos + (PMD_SIZE - 1));
+	end_pfn = addr_to_pmd_pfn(end);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
-- 
1.7.7.6

