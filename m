Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0GFWpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:45:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32629 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab0GFWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:44:34 -0400
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
Subject: [PATCH 21/49] memblock: Add arch function to control coalescing of memblock memory regions
Date: Tue,  6 Jul 2010 15:39:14 -0700
Message-Id: <1278455982-24621-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C33B1A8.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Some archs such as ARM want to avoid coalescing accross things such
as the lowmem/highmem boundary or similar. This provides the option
to control it via an arch callback for which a weak default is provided
which always allows coalescing.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |   19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b839053..15da7d9 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -70,6 +70,8 @@ extern void memblock_dump_all(void);
 
 /* Provided by the architecture */
 extern phys_addr_t memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid);
+extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+				   phys_addr_t addr2, phys_addr_t size2);
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
diff --git a/mm/memblock.c b/mm/memblock.c
index 82be663..8659e00 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -241,6 +241,12 @@ static int memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
+extern int __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+					  phys_addr_t addr2, phys_addr_t size2)
+{
+	return 1;
+}
+
 static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size)
 {
 	unsigned long coalesced = 0;
@@ -262,6 +268,10 @@ static long memblock_add_region(struct memblock_type *type, phys_addr_t base, ph
 			return 0;
 
 		adjacent = memblock_addrs_adjacent(base, size, rgnbase, rgnsize);
+		/* Check if arch allows coalescing */
+		if (adjacent != 0 && type == &memblock.memory &&
+		    !memblock_memory_can_coalesce(base, size, rgnbase, rgnsize))
+			break;
 		if (adjacent > 0) {
 			type->regions[i].base -= size;
 			type->regions[i].size += size;
@@ -274,7 +284,14 @@ static long memblock_add_region(struct memblock_type *type, phys_addr_t base, ph
 		}
 	}
 
-	if ((i < type->cnt - 1) && memblock_regions_adjacent(type, i, i+1)) {
+	/* If we plugged a hole, we may want to also coalesce with the
+	 * next region
+	 */
+	if ((i < type->cnt - 1) && memblock_regions_adjacent(type, i, i+1) &&
+	    ((type != &memblock.memory || memblock_memory_can_coalesce(type->regions[i].base,
+							     type->regions[i].size,
+							     type->regions[i+1].base,
+							     type->regions[i+1].size)))) {
 		memblock_coalesce_regions(type, i, i+1);
 		coalesced++;
 	}
-- 
1.6.4.2

