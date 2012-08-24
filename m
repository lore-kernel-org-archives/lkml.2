Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab2HXOeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:34:13 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54726 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2HXOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:34:11 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/5] mm/memblock: truncate memblock if necessary
Date: Fri, 24 Aug 2012 22:33:36 +0800
Message-Id: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12082414-0260-0000-0000-000001BD4DD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <shangw@linux.vnet.ibm.com>

While enforcing memory limit on current memblock layout, it is
possible that we don't have to change the current memblock layout.
For example, the enforced limited size is bigger than the maximal
address of memory regions. Also, we don't have to change the memory
layout while the enforced limited size is more than the accumulative
size of all memory regions.

The patch checks them and won't change current memblock layout for
those cases, thus to reduce some overhead.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memblock.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 4d9393c..c1fbb12 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -844,14 +844,14 @@ void __init memblock_enforce_memory_limit(phys_addr_t limit)
 	unsigned long i;
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 
-	if (!limit)
+	if (!limit || limit >= memblock_end_of_DRAM())
 		return;
 
 	/* find out max address */
 	for (i = 0; i < memblock.memory.cnt; i++) {
 		struct memblock_region *r = &memblock.memory.regions[i];
 
-		if (limit <= r->size) {
+		if (limit < r->size) {
 			max_addr = r->base + limit;
 			break;
 		}
@@ -859,8 +859,12 @@ void __init memblock_enforce_memory_limit(phys_addr_t limit)
 	}
 
 	/* truncate both memory and reserved regions */
-	__memblock_remove(&memblock.memory, max_addr, (phys_addr_t)ULLONG_MAX);
-	__memblock_remove(&memblock.reserved, max_addr, (phys_addr_t)ULLONG_MAX);
+	if (max_addr < (phys_addr_t)ULLONG_MAX) {
+		__memblock_remove(&memblock.memory, max_addr,
+						(phys_addr_t)ULLONG_MAX);
+		__memblock_remove(&memblock.reserved, max_addr,
+						(phys_addr_t)ULLONG_MAX);
+	}
 }
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
-- 
1.7.5.4

