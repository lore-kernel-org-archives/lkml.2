Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967340Ab0GTAE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:04:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64407 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966913Ab0GSX6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:55 -0400
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
Subject: [PATCH 16/49] memblock: Make memblock_find_region() out of memblock_alloc_region()
Date: Mon, 19 Jul 2010 16:56:25 -0700
Message-Id: <1279583818-14249-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E68D.0042,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This function will be used to locate a free area to put the new memblock
arrays when attempting to resize them. memblock_alloc_region() is gone,
the two callsites now call memblock_add_region().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 21ba089..eae3dc0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -309,8 +309,8 @@ static phys_addr_t memblock_align_up(phys_addr_t addr, phys_addr_t size)
 	return (addr + (size - 1)) & ~(size - 1);
 }
 
-static phys_addr_t __init memblock_alloc_region(phys_addr_t start, phys_addr_t end,
-					   phys_addr_t size, phys_addr_t align)
+static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t end,
+					  phys_addr_t size, phys_addr_t align)
 {
 	phys_addr_t base, res_base;
 	long j;
@@ -318,12 +318,8 @@ static phys_addr_t __init memblock_alloc_region(phys_addr_t start, phys_addr_t e
 	base = memblock_align_down((end - size), align);
 	while (start <= base) {
 		j = memblock_overlaps_region(&memblock.reserved, base, size);
-		if (j < 0) {
-			/* this area isn't reserved, take it */
-			if (memblock_add_region(&memblock.reserved, base, size) < 0)
-				base = ~(phys_addr_t)0;
+		if (j < 0)
 			return base;
-		}
 		res_base = memblock.reserved.regions[j].base;
 		if (res_base < size)
 			break;
@@ -356,8 +352,9 @@ static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
 
 		this_end = memblock_nid_range(start, end, &this_nid);
 		if (this_nid == nid) {
-			phys_addr_t ret = memblock_alloc_region(start, this_end, size, align);
-			if (ret != ~(phys_addr_t)0)
+			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
+			if (ret != ~(phys_addr_t)0 &&
+			    memblock_add_region(&memblock.reserved, ret, size) >= 0)
 				return ret;
 		}
 		start = this_end;
@@ -432,8 +429,9 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 		if (memblocksize < size)
 			continue;
 		base = min(memblockbase + memblocksize, max_addr);
-		res_base = memblock_alloc_region(memblockbase, base, size, align);
-		if (res_base != ~(phys_addr_t)0)
+		res_base = memblock_find_region(memblockbase, base, size, align);
+		if (res_base != ~(phys_addr_t)0 &&
+		    memblock_add_region(&memblock.reserved, res_base, size) >= 0)
 			return res_base;
 	}
 	return 0;
-- 
1.6.4.2

