Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BGXyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:54:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54105 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1BGXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:54:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/11] memblock: Move __alloc_memory_core_early() to nobootmem.c
Date: Mon,  7 Feb 2011 15:17:12 -0800
Message-Id: <1297120632-24933-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D5085FC.00B1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove #ifdef in mm/page_alloc.c

and change that function to static

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/mm.h |    2 --
 mm/nobootmem.c     |   25 +++++++++++++++++++++++++
 mm/page_alloc.c    |   28 ----------------------------
 3 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f6385fc..679300c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1309,8 +1309,6 @@ int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit);
-void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
-				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 6a018e4..e2bdb07 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -40,6 +40,31 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
+static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	void *ptr;
+	u64 addr;
+
+	if (limit > memblock.current_limit)
+		limit = memblock.current_limit;
+
+	addr = find_memory_core_early(nid, size, align, goal, limit);
+
+	if (addr == MEMBLOCK_ERROR)
+		return NULL;
+
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
+	/*
+	 * The min_count is set to 0 so that bootmem allocated blocks
+	 * are never reported as leaks.
+	 */
+	kmemleak_alloc(ptr, size, 0, 0);
+	return ptr;
+}
+
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a243a7f..6035136 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3780,34 +3780,6 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	void *ptr;
-	u64 addr;
-
-	if (limit > memblock.current_limit)
-		limit = memblock.current_limit;
-
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
-	if (addr == MEMBLOCK_ERROR)
-		return NULL;
-
-	ptr = phys_to_virt(addr);
-	memset(ptr, 0, size);
-	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
-	/*
-	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks.
-	 */
-	kmemleak_alloc(ptr, size, 0, 0);
-	return ptr;
-}
-#endif
-
-
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
-- 
1.7.1

