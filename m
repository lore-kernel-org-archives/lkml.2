Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356Ab0HFFXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:23:51 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41667 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH 08/43] memblock/microblaze: Use new accessors
Date: Fri,  6 Aug 2010 15:14:49 +1000
Message-Id: <1281071724-28740-9-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Michal Simek <monstr@monstr.eu>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/mm/init.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index afd6494..32a702b 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -70,16 +70,16 @@ static void __init paging_init(void)
 
 void __init setup_memory(void)
 {
-	int i;
 	unsigned long map_size;
+	struct memblock_region *reg;
+
 #ifndef CONFIG_MMU
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		memory_start = (u32) memblock.memory.regions[i].base;
-		memory_end = (u32) memblock.memory.regions[i].base
-				+ (u32) memblock.memory.region[i].size;
+	for_each_memblock(memory, reg) {
+		memory_start = (u32)reg->base;
+		memory_end = (u32) reg->base + reg->size;
 		if ((memory_start <= (u32)_text) &&
 					((u32)_text <= memory_end)) {
 			memory_size = memory_end - memory_start;
@@ -147,12 +147,10 @@ void __init setup_memory(void)
 	free_bootmem(memory_start, memory_size);
 
 	/* reserve allocate blocks */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
-			(u32) memblock.reserved.region[i].base,
-			(u32) memblock_size_bytes(&memblock.reserved, i));
-		reserve_bootmem(memblock.reserved.region[i].base,
-			memblock_size_bytes(&memblock.reserved, i) - 1, BOOTMEM_DEFAULT);
+	for_each_memblock(reserved, reg) {
+		pr_debug("reserved - 0x%08x-0x%08x\n",
+			 (u32) reg->base, (u32) reg->size);
+		reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
 	}
 #ifdef CONFIG_MMU
 	init_bootmem_done = 1;
-- 
1.7.0.4

