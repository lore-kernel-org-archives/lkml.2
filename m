Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224Ab0HFFW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:22:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57842 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 09/43] memblock/sh: Use new accessors
Date: Fri,  6 Aug 2010 15:14:50 +1000
Message-Id: <1281071724-28740-10-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/sh/mm/init.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index d0e2491..b977475 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -200,7 +200,6 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	unsigned long total_pages, paddr;
 	unsigned long end_pfn;
 	struct pglist_data *p;
-	int i;
 
 	p = NODE_DATA(nid);
 
@@ -226,11 +225,12 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	 * reservations in other nodes.
 	 */
 	if (nid == 0) {
+		struct memblock_region *reg;
+
 		/* Reserve the sections we're already using. */
-		for (i = 0; i < memblock.reserved.cnt; i++)
-			reserve_bootmem(memblock.reserved.region[i].base,
-					memblock_size_bytes(&memblock.reserved, i),
-					BOOTMEM_DEFAULT);
+		for_each_memblock(reserved, reg) {
+			reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
+		}
 	}
 
 	sparse_memory_present_with_active_regions(nid);
@@ -238,13 +238,14 @@ static void __init bootmem_init_one_node(unsigned int nid)
 
 static void __init do_init_bootmem(void)
 {
+	struct memblock_region *reg;
 	int i;
 
 	/* Add active regions with valid PFNs. */
-	for (i = 0; i < memblock.memory.cnt; i++) {
+	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 		__add_active_range(0, start_pfn, end_pfn);
 	}
 
-- 
1.7.0.4

