Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410Ab0HFFYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:24:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33758 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 12/43] memblock/arm: Use new accessors
Date: Fri,  6 Aug 2010 15:14:53 +1000
Message-Id: <1281071724-28740-13-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/mm/init.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index e739223..8504906 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -150,6 +150,7 @@ static void __init find_limits(struct meminfo *mi,
 static void __init arm_bootmem_init(struct meminfo *mi,
 	unsigned long start_pfn, unsigned long end_pfn)
 {
+	struct memblock_region *reg;
 	unsigned int boot_pages;
 	phys_addr_t bitmap;
 	pg_data_t *pgdat;
@@ -180,13 +181,13 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	/*
 	 * Reserve the memblock reserved regions in bootmem.
 	 */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		phys_addr_t start = memblock_start_pfn(&memblock.reserved, i);
-		if (start >= start_pfn &&
-		    memblock_end_pfn(&memblock.reserved, i) <= end_pfn)
+	for_each_memblock(reserved, reg) {
+		phys_addr_t start = memblock_region_base_pfn(reg);
+		phys_addr_t end = memblock_region_end_pfn(reg);
+		if (start >= start_pfn && end <= end_pfn)
 			reserve_bootmem_node(pgdat, __pfn_to_phys(start),
-				memblock_size_bytes(&memblock.reserved, i),
-				BOOTMEM_DEFAULT);
+					     (end - start) << PAGE_SHIFT,
+					     BOOTMEM_DEFAULT);
 	}
 }
 
@@ -247,10 +248,12 @@ static void arm_memory_present(void)
 #else
 static void arm_memory_present(void)
 {
+	struct memblock_region *reg;
 	int i;
-	for (i = 0; i < memblock.memory.cnt; i++)
-		memory_present(0, memblock_start_pfn(&memblock.memory, i),
-				  memblock_end_pfn(&memblock.memory, i));
+
+	for_each_memblock(memory, reg) {
+		memory_present(0, memblock_region_base_pfn(reg),
+			       memblock_region_end_pfn(reg));
 }
 #endif
 
-- 
1.7.0.4

