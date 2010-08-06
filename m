Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357Ab0HFFVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:21:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41683 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab0HFFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:35 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 23/43] memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
Date: Fri,  6 Aug 2010 15:15:04 +1000
Message-Id: <1281071724-28740-24-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for having resizable arrays.

Note that we still allocate one more than needed, this is unchanged from
the previous implementation.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    7 ++++---
 mm/memblock.c            |   10 +++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index c9c7b0f..150be93 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -18,7 +18,7 @@
 
 #include <asm/memblock.h>
 
-#define MAX_MEMBLOCK_REGIONS 128
+#define INIT_MEMBLOCK_REGIONS 128
 
 struct memblock_region {
 	phys_addr_t base;
@@ -26,8 +26,9 @@ struct memblock_region {
 };
 
 struct memblock_type {
-	unsigned long cnt;
-	struct memblock_region regions[MAX_MEMBLOCK_REGIONS+1];
+	unsigned long cnt;	/* number of regions */
+	unsigned long max;	/* size of the allocated array */
+	struct memblock_region *regions;
 };
 
 struct memblock {
diff --git a/mm/memblock.c b/mm/memblock.c
index 5ae413e..3c47450 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -18,6 +18,8 @@
 struct memblock memblock;
 
 static int memblock_debug;
+static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
+static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 
 static int __init early_memblock(char *p)
 {
@@ -104,6 +106,12 @@ static void memblock_coalesce_regions(struct memblock_type *type,
 
 void __init memblock_init(void)
 {
+	/* Hookup the initial arrays */
+	memblock.memory.regions	= memblock_memory_init_regions;
+	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
+	memblock.reserved.regions	= memblock_reserved_init_regions;
+	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
+
 	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
 	 * This simplifies the memblock_add() code below...
 	 */
@@ -169,7 +177,7 @@ static long memblock_add_region(struct memblock_type *type, phys_addr_t base, ph
 
 	if (coalesced)
 		return coalesced;
-	if (type->cnt >= MAX_MEMBLOCK_REGIONS)
+	if (type->cnt >= type->max)
 		return -1;
 
 	/* Couldn't coalesce the MEMBLOCK, so add it to the sorted table. */
-- 
1.7.0.4

