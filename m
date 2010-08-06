Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386Ab0HFFV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:21:58 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59775 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933763Ab0HFFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:35 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 10/43] memblock/sparc: Use new accessors
Date: Fri,  6 Aug 2010 15:14:51 +1000
Message-Id: <1281071724-28740-11-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/sparc/mm/init_64.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 16d8bee..dd68025 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -972,13 +972,13 @@ int of_node_to_nid(struct device_node *dp)
 
 static void __init add_node_ranges(void)
 {
-	int i;
+	struct memblock_region *reg;
 
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long size = memblock_size_bytes(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		unsigned long size = reg->size;
 		unsigned long start, end;
 
-		start = memblock.memory.regions[i].base;
+		start = reg->base;
 		end = start + size;
 		while (start < end) {
 			unsigned long this_end;
@@ -1281,7 +1281,7 @@ static void __init bootmem_init_nonnuma(void)
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	unsigned int i;
+	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1292,15 +1292,14 @@ static void __init bootmem_init_nonnuma(void)
 
 	init_node_masks_nonnuma();
 
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long size = memblock_size_bytes(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
 
-		if (!size)
+		if (!reg->size)
 			continue;
 
-		start_pfn = memblock.memory.regions[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -1334,17 +1333,12 @@ static void __init reserve_range_in_node(int nid, unsigned long start,
 
 static void __init trim_reserved_in_node(int nid)
 {
-	int i;
+	struct memblock_region *reg;
 
 	numadbg("  trim_reserved_in_node(%d)\n", nid);
 
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		unsigned long start = memblock.reserved.regions[i].base;
-		unsigned long size = memblock_size_bytes(&memblock.reserved, i);
-		unsigned long end = start + size;
-
-		reserve_range_in_node(nid, start, end);
-	}
+	for_each_memblock(reserved, reg)
+		reserve_range_in_node(nid, reg->base, reg->base + reg->size);
 }
 
 static void __init bootmem_init_one_node(int nid)
-- 
1.7.0.4

