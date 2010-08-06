Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab0HFFSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:18:35 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33773 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933785Ab0HFFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:36 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 22/43] memblock: Remove memblock_type.size and add memblock.memory_size instead
Date: Fri,  6 Aug 2010 15:15:03 +1000
Message-Id: <1281071724-28740-23-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, both the "memory" and "reserved" memblock_type structures have
a "size" member. It represents the calculated memory size in the former
case and is unused in the latter.

This moves it out to the main memblock structure instead

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/mm/mem.c    |    2 +-
 include/linux/memblock.h |    2 +-
 mm/memblock.c            |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 52df542..f661f6c 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -301,7 +301,7 @@ void __init mem_init(void)
 		swiotlb_init(1);
 #endif
 
-	num_physpages = memblock.memory.size >> PAGE_SHIFT;
+	num_physpages = memblock_phys_mem_size() >> PAGE_SHIFT;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 0fe6dd5..c9c7b0f 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -27,12 +27,12 @@ struct memblock_region {
 
 struct memblock_type {
 	unsigned long cnt;
-	phys_addr_t size;
 	struct memblock_region regions[MAX_MEMBLOCK_REGIONS+1];
 };
 
 struct memblock {
 	phys_addr_t current_limit;
+	phys_addr_t memory_size;	/* Updated by memblock_analyze() */
 	struct memblock_type memory;
 	struct memblock_type reserved;
 };
diff --git a/mm/memblock.c b/mm/memblock.c
index 81da635..5ae413e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -49,7 +49,7 @@ void memblock_dump_all(void)
 		return;
 
 	pr_info("MEMBLOCK configuration:\n");
-	pr_info(" memory.size = 0x%llx\n", (unsigned long long)memblock.memory.size);
+	pr_info(" memory size = 0x%llx\n", (unsigned long long)memblock.memory_size);
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
@@ -123,10 +123,10 @@ void __init memblock_analyze(void)
 {
 	int i;
 
-	memblock.memory.size = 0;
+	memblock.memory_size = 0;
 
 	for (i = 0; i < memblock.memory.cnt; i++)
-		memblock.memory.size += memblock.memory.regions[i].size;
+		memblock.memory_size += memblock.memory.regions[i].size;
 }
 
 static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
@@ -423,7 +423,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 /* You must call memblock_analyze() before this. */
 phys_addr_t __init memblock_phys_mem_size(void)
 {
-	return memblock.memory.size;
+	return memblock.memory_size;
 }
 
 phys_addr_t memblock_end_of_DRAM(void)
-- 
1.7.0.4

