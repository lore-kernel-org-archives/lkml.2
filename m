Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1K1TcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:32:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1K1TcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:32:16 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/23] memblock: Reimplement memblock_enforce_memory_limit() using __memblock_remove()
Date: Mon, 28 Nov 2011 11:31:12 -0800
Message-Id: <1322508685-32532-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent updates, the basic memblock operations are robust enough
that there's no reason for memblock_enfore_memory_limit() to directly
manipulate memblock region arrays.  Reimplement it using
__memblock_remove().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |   42 +++++++++++++-----------------------------
 1 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 945dc31..b44875f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -804,44 +804,28 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 }
 
 /* You must call memblock_analyze() after this. */
-void __init memblock_enforce_memory_limit(phys_addr_t memory_limit)
+void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
 	unsigned long i;
-	phys_addr_t limit;
-	struct memblock_region *p;
+	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 
-	if (!memory_limit)
+	if (!limit)
 		return;
 
-	/* Truncate the memblock regions to satisfy the memory limit. */
-	limit = memory_limit;
+	/* find out max address */
 	for (i = 0; i < memblock.memory.cnt; i++) {
-		if (limit > memblock.memory.regions[i].size) {
-			limit -= memblock.memory.regions[i].size;
-			continue;
-		}
-
-		memblock.memory.regions[i].size = limit;
-		memblock.memory.cnt = i + 1;
-		break;
-	}
-
-	memory_limit = memblock_end_of_DRAM();
+		struct memblock_region *r = &memblock.memory.regions[i];
 
-	/* And truncate any reserves above the limit also. */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		p = &memblock.reserved.regions[i];
-
-		if (p->base > memory_limit)
-			p->size = 0;
-		else if ((p->base + p->size) > memory_limit)
-			p->size = memory_limit - p->base;
-
-		if (p->size == 0) {
-			memblock_remove_region(&memblock.reserved, i);
-			i--;
+		if (limit <= r->size) {
+			max_addr = r->base + limit;
+			break;
 		}
+		limit -= r->size;
 	}
+
+	/* truncate both memory and reserved regions */
+	__memblock_remove(&memblock.memory, max_addr, (phys_addr_t)ULLONG_MAX);
+	__memblock_remove(&memblock.reserved, max_addr, (phys_addr_t)ULLONG_MAX);
 }
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
-- 
1.7.3.1

