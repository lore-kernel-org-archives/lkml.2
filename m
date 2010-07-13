Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0GMHOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:14:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0GMHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:14:00 -0400
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
Subject: [PATCH 08/50] memblock: Factor the lowest level alloc function
Date: Tue, 13 Jul 2010 00:10:02 -0700
Message-Id: <1279005044-24777-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C3C1221.02B5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   59 ++++++++++++++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 83643f3..9b71de0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -294,8 +294,8 @@ static u64 memblock_align_up(u64 addr, u64 size)
 	return (addr + (size - 1)) & ~(size - 1);
 }
 
-static u64 __init memblock_alloc_nid_unreserved(u64 start, u64 end,
-					   u64 size, u64 align)
+static u64 __init memblock_alloc_region(u64 start, u64 end,
+				   u64 size, u64 align)
 {
 	u64 base, res_base;
 	long j;
@@ -318,6 +318,13 @@ static u64 __init memblock_alloc_nid_unreserved(u64 start, u64 end,
 	return ~(u64)0;
 }
 
+u64 __weak __init memblock_nid_range(u64 start, u64 end, int *nid)
+{
+	*nid = 0;
+
+	return end;
+}
+
 static u64 __init memblock_alloc_nid_region(struct memblock_region *mp,
 				       u64 size, u64 align, int nid)
 {
@@ -333,8 +340,7 @@ static u64 __init memblock_alloc_nid_region(struct memblock_region *mp,
 
 		this_end = memblock_nid_range(start, end, &this_nid);
 		if (this_nid == nid) {
-			u64 ret = memblock_alloc_nid_unreserved(start, this_end,
-							   size, align);
+			u64 ret = memblock_alloc_region(start, this_end, size, align);
 			if (ret != ~(u64)0)
 				return ret;
 		}
@@ -351,6 +357,10 @@ u64 __init memblock_alloc_nid(u64 size, u64 align, int nid)
 
 	BUG_ON(0 == size);
 
+	/* We do a bottom-up search for a region with the right
+	 * nid since that's easier considering how memblock_nid_range()
+	 * works
+	 */
 	size = memblock_align_up(size, align);
 
 	for (i = 0; i < mem->cnt; i++) {
@@ -383,7 +393,7 @@ u64 __init memblock_alloc_base(u64 size, u64 align, u64 max_addr)
 
 u64 __init __memblock_alloc_base(u64 size, u64 align, u64 max_addr)
 {
-	long i, j;
+	long i;
 	u64 base = 0;
 	u64 res_base;
 
@@ -396,33 +406,24 @@ u64 __init __memblock_alloc_base(u64 size, u64 align, u64 max_addr)
 	if (max_addr == MEMBLOCK_ALLOC_ANYWHERE)
 		max_addr = MEMBLOCK_REAL_LIMIT;
 
+	/* Pump up max_addr */
+	if (max_addr == MEMBLOCK_ALLOC_ANYWHERE)
+		max_addr = ~(u64)0;
+
+	/* We do a top-down search, this tends to limit memory
+	 * fragmentation by keeping early boot allocs near the
+	 * top of memory
+	 */
 	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
 		u64 memblockbase = memblock.memory.regions[i].base;
 		u64 memblocksize = memblock.memory.regions[i].size;
 
 		if (memblocksize < size)
 			continue;
-		if (max_addr == MEMBLOCK_ALLOC_ANYWHERE)
-			base = memblock_align_down(memblockbase + memblocksize - size, align);
-		else if (memblockbase < max_addr) {
-			base = min(memblockbase + memblocksize, max_addr);
-			base = memblock_align_down(base - size, align);
-		} else
-			continue;
-
-		while (base && memblockbase <= base) {
-			j = memblock_overlaps_region(&memblock.reserved, base, size);
-			if (j < 0) {
-				/* this area isn't reserved, take it */
-				if (memblock_add_region(&memblock.reserved, base, size) < 0)
-					return 0;
-				return base;
-			}
-			res_base = memblock.reserved.regions[j].base;
-			if (res_base < size)
-				break;
-			base = memblock_align_down(res_base - size, align);
-		}
+		base = min(memblockbase + memblocksize, max_addr);
+		res_base = memblock_alloc_region(memblockbase, base, size, align);
+		if (res_base != ~(u64)0)
+			return res_base;
 	}
 	return 0;
 }
@@ -502,9 +503,3 @@ int memblock_is_region_reserved(u64 base, u64 size)
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
-u64 __weak memblock_nid_range(u64 start, u64 end, int *nid)
-{
-	*nid = 0;
-
-	return end;
-}
-- 
1.6.4.2

