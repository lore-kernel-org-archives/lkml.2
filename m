Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0GFWnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:43:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31724 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab0GFWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:43:41 -0400
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
Subject: [PATCH 13/49] memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
Date: Tue,  6 Jul 2010 15:39:06 -0700
Message-Id: <1278455982-24621-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C33B171.001C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This is in preparation for having resizable arrays.

Note that we still allocate one more than needed, this is unchanged from
the previous implementation.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    7 ++++---
 mm/memblock.c            |   10 +++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e849d31..b839053 100644
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
index 78c2394..e1c5ce3 100644
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
1.6.4.2

