Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0GFWrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:47:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32490 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab0GFWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:44:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 22/49] memblock: Add "start" argument to memblock_find_base()
Date: Tue,  6 Jul 2010 15:39:15 -0700
Message-Id: <1278455982-24621-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C33B1AC.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

To constraint the search of a region between two boundaries,
which will be used by the new NUMA aware allocator among others.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 8659e00..bb382f2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -117,19 +117,18 @@ static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t en
 	return MEMBLOCK_ERROR;
 }
 
-static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align,
+					phys_addr_t start, phys_addr_t end)
 {
 	long i;
-	phys_addr_t base = 0;
-	phys_addr_t res_base;
 
 	BUG_ON(0 == size);
 
 	size = memblock_align_up(size, align);
 
 	/* Pump up max_addr */
-	if (max_addr == MEMBLOCK_ALLOC_ACCESSIBLE)
-		max_addr = memblock.current_limit;
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
 
 	/* We do a top-down search, this tends to limit memory
 	 * fragmentation by keeping early boot allocs near the
@@ -138,13 +137,19 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
 	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
 		phys_addr_t memblockbase = memblock.memory.regions[i].base;
 		phys_addr_t memblocksize = memblock.memory.regions[i].size;
+		phys_addr_t bottom, top, found;
 
 		if (memblocksize < size)
 			continue;
-		base = min(memblockbase + memblocksize, max_addr);
-		res_base = memblock_find_region(memblockbase, base, size, align);
-		if (res_base != MEMBLOCK_ERROR)
-			return res_base;
+		if ((memblockbase + memblocksize) <= start)
+			break;
+		bottom = max(memblockbase, start);
+		top = min(memblockbase + memblocksize, end);
+		if (bottom >= top)
+			continue;
+		found = memblock_find_region(bottom, top, size, align);
+		if (found != MEMBLOCK_ERROR)
+			return found;
 	}
 	return 0;
 }
@@ -204,7 +209,7 @@ static int memblock_double_array(struct memblock_type *type)
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array == NULL ? MEMBLOCK_ERROR : __pa(new_array);
 	} else
-		addr = memblock_find_base(new_size, sizeof(phys_addr_t), MEMBLOCK_ALLOC_ACCESSIBLE);
+		addr = memblock_find_base(new_size, sizeof(phys_addr_t), 0, MEMBLOCK_ALLOC_ACCESSIBLE);
 	if (addr == MEMBLOCK_ERROR) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
@@ -409,7 +414,7 @@ long __init memblock_reserve(phys_addr_t base, phys_addr_t size)
 
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
-	phys_addr_t found = memblock_find_base(size, align, max_addr);
+	phys_addr_t found = memblock_find_base(size, align, 0, max_addr);
 
 	if (found != MEMBLOCK_ERROR &&
 	    memblock_add_region(&memblock.reserved, found, size) >= 0)
-- 
1.6.4.2

