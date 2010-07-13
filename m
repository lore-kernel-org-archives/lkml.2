Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0GMHPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:15:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26086 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0GMHPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:15:36 -0400
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
Subject: [PATCH 07/50] memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
Date: Tue, 13 Jul 2010 00:10:01 -0700
Message-Id: <1279005044-24777-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C3C1271.01EB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/sparc/mm/init_64.c  |   16 ++++++----------
 include/linux/memblock.h |    7 +++++--
 mm/memblock.c            |   13 ++++++++-----
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index dd68025..0883113 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -785,8 +785,7 @@ static int find_node(unsigned long addr)
 	return -1;
 }
 
-static unsigned long long nid_range(unsigned long long start,
-				    unsigned long long end, int *nid)
+u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = find_node(start);
 	start += PAGE_SIZE;
@@ -804,8 +803,7 @@ static unsigned long long nid_range(unsigned long long start,
 	return start;
 }
 #else
-static unsigned long long nid_range(unsigned long long start,
-				    unsigned long long end, int *nid)
+u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = 0;
 	return end;
@@ -822,8 +820,7 @@ static void __init allocate_node_data(int nid)
 	struct pglist_data *p;
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	paddr = memblock_alloc_nid(sizeof(struct pglist_data),
-			      SMP_CACHE_BYTES, nid, nid_range);
+	paddr = memblock_alloc_nid(sizeof(struct pglist_data), SMP_CACHE_BYTES, nid);
 	if (!paddr) {
 		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
 		prom_halt();
@@ -843,8 +840,7 @@ static void __init allocate_node_data(int nid)
 	if (p->node_spanned_pages) {
 		num_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-		paddr = memblock_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid,
-				      nid_range);
+		paddr = memblock_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid);
 		if (!paddr) {
 			prom_printf("Cannot allocate bootmap for nid[%d]\n",
 				  nid);
@@ -984,7 +980,7 @@ static void __init add_node_ranges(void)
 			unsigned long this_end;
 			int nid;
 
-			this_end = nid_range(start, end, &nid);
+			this_end = memblock_nid_range(start, end, &nid);
 
 			numadbg("Adding active range nid[%d] "
 				"start[%lx] end[%lx]\n",
@@ -1317,7 +1313,7 @@ static void __init reserve_range_in_node(int nid, unsigned long start,
 		unsigned long this_end;
 		int n;
 
-		this_end = nid_range(start, end, &n);
+		this_end = memblock_nid_range(start, end, &n);
 		if (n == nid) {
 			numadbg("      MATCH reserving range [%lx:%lx]\n",
 				start, this_end);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d948857..3e4a52f 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -46,8 +46,7 @@ extern long memblock_add(u64 base, u64 size);
 extern long memblock_remove(u64 base, u64 size);
 extern long __init memblock_free(u64 base, u64 size);
 extern long __init memblock_reserve(u64 base, u64 size);
-extern u64 __init memblock_alloc_nid(u64 size, u64 align, int nid,
-				u64 (*nid_range)(u64, u64, int *));
+extern u64 __init memblock_alloc_nid(u64 size, u64 align, int nid);
 extern u64 __init memblock_alloc(u64 size, u64 align);
 extern u64 __init memblock_alloc_base(u64 size,
 		u64, u64 max_addr);
@@ -61,6 +60,10 @@ extern int memblock_is_region_reserved(u64 base, u64 size);
 
 extern void memblock_dump_all(void);
 
+/* Provided by the architecture */
+extern u64 memblock_nid_range(u64 start, u64 end, int *nid);
+
+
 /*
  * pfn conversion functions
  *
diff --git a/mm/memblock.c b/mm/memblock.c
index 5df1400..83643f3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -319,7 +319,6 @@ static u64 __init memblock_alloc_nid_unreserved(u64 start, u64 end,
 }
 
 static u64 __init memblock_alloc_nid_region(struct memblock_region *mp,
-				       u64 (*nid_range)(u64, u64, int *),
 				       u64 size, u64 align, int nid)
 {
 	u64 start, end;
@@ -332,7 +331,7 @@ static u64 __init memblock_alloc_nid_region(struct memblock_region *mp,
 		u64 this_end;
 		int this_nid;
 
-		this_end = nid_range(start, end, &this_nid);
+		this_end = memblock_nid_range(start, end, &this_nid);
 		if (this_nid == nid) {
 			u64 ret = memblock_alloc_nid_unreserved(start, this_end,
 							   size, align);
@@ -345,8 +344,7 @@ static u64 __init memblock_alloc_nid_region(struct memblock_region *mp,
 	return ~(u64)0;
 }
 
-u64 __init memblock_alloc_nid(u64 size, u64 align, int nid,
-			 u64 (*nid_range)(u64 start, u64 end, int *nid))
+u64 __init memblock_alloc_nid(u64 size, u64 align, int nid)
 {
 	struct memblock_type *mem = &memblock.memory;
 	int i;
@@ -357,7 +355,6 @@ u64 __init memblock_alloc_nid(u64 size, u64 align, int nid,
 
 	for (i = 0; i < mem->cnt; i++) {
 		u64 ret = memblock_alloc_nid_region(&mem->regions[i],
-					       nid_range,
 					       size, align, nid);
 		if (ret != ~(u64)0)
 			return ret;
@@ -505,3 +502,9 @@ int memblock_is_region_reserved(u64 base, u64 size)
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
+u64 __weak memblock_nid_range(u64 start, u64 end, int *nid)
+{
+	*nid = 0;
+
+	return end;
+}
-- 
1.6.4.2

