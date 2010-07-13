Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0GMHWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:22:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28642 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0GMHQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:16:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/50] memblock: split memblock_find_base() out of __memblock_alloc_base()
Date: Tue, 13 Jul 2010 00:10:14 -0700
Message-Id: <1279005044-24777-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C3C1299.011D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This will be used by the array resize code and might prove useful
to some arch code as well at which point it can be made non-static.

Also add comment as to why aligning size is important

[ Yinghai Lu ]: it should return MEMBLOCK_ERROR when it fail to find a range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   58 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 1283893..17403e6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -345,12 +345,15 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 
 	BUG_ON(0 == size);
 
+	/* We align the size to limit fragmentation. Without this, a lot of
+	 * small allocs quickly eat up the whole reserve array on sparc
+	 */
+	size = memblock_align_up(size, align);
+
 	/* We do a bottom-up search for a region with the right
 	 * nid since that's easier considering how memblock_nid_range()
 	 * works
 	 */
-	size = memblock_align_up(size, align);
-
 	for (i = 0; i < mem->cnt; i++) {
 		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
 					       size, align, nid);
@@ -366,20 +369,7 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
-phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
-{
-	phys_addr_t alloc;
-
-	alloc = __memblock_alloc_base(size, align, max_addr);
-
-	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
-		      (unsigned long long) size, (unsigned long long) max_addr);
-
-	return alloc;
-}
-
-phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
 	long i;
 	phys_addr_t base = 0;
@@ -387,8 +377,6 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 
 	BUG_ON(0 == size);
 
-	size = memblock_align_up(size, align);
-
 	/* Pump up max_addr */
 	if (max_addr == MEMBLOCK_ALLOC_ACCESSIBLE)
 		max_addr = memblock.current_limit;
@@ -405,13 +393,43 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 			continue;
 		base = min(memblockbase + memblocksize, max_addr);
 		res_base = memblock_find_region(memblockbase, base, size, align);
-		if (res_base != MEMBLOCK_ERROR &&
-		    memblock_add_region(&memblock.reserved, res_base, size) >= 0)
+		if (res_base != MEMBLOCK_ERROR)
 			return res_base;
 	}
+	return MEMBLOCK_ERROR;
+}
+
+phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+{	
+	phys_addr_t found;
+
+	/* We align the size to limit fragmentation. Without this, a lot of
+	 * small allocs quickly eat up the whole reserve array on sparc
+	 */
+	size = memblock_align_up(size, align);
+
+	found = memblock_find_base(size, align, max_addr);
+	if (found != MEMBLOCK_ERROR &&
+	    memblock_add_region(&memblock.reserved, found, size) >= 0)
+		return found;
+
 	return 0;
 }
 
+phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+{
+	phys_addr_t alloc;
+
+	alloc = __memblock_alloc_base(size, align, max_addr);
+
+	if (alloc == 0)
+		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
+		      (unsigned long long) size, (unsigned long long) max_addr);
+
+	return alloc;
+}
+
+
 /* You must call memblock_analyze() before this. */
 phys_addr_t __init memblock_phys_mem_size(void)
 {
-- 
1.6.4.2

