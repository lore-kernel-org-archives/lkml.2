Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0CXKiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:38:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27108 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0CXKiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:38:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/8] x86: add find_e820_area_node
Date: Wed, 24 Mar 2010 03:34:15 -0700
Message-Id: <1269426861-20903-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
References: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BA9EB0C.00DF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@@kernel.org>

David Miller pointed out that early_res have problem to find node data on correct node
when we have
node0: [0, 2g), [4g, 6g), [10g, 14g)
node1: [6g, 10g), [14g, 18g)
the cross node case

the problem is there for x86 bits even before we are using early_res for bootmem replacement.
after early_res for bootmem replacement, alloc_bootmem_node still can get range on correct node

this patch is fixing problem before bootmem or early_res replacement for bootmem.

now only user is for x86 64bit numa to find node data.

the point is use early_node_map with find_e820_area_node()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |   15 +++++++++++++++
 arch/x86/mm/numa_64.c       |    4 ++--
 include/linux/mm.h          |    2 ++
 mm/page_alloc.c             |   37 +++++++++++++++++++++++--------------
 5 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index ec8a52d..41553af 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -116,6 +116,7 @@ extern unsigned long end_user_pfn;
 
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
+u64 find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 #include <linux/early_res.h>
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 740b440..05ee724 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -787,6 +787,21 @@ u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
 	return -1ULL;
 }
 
+u64 __init find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	/*
+	 * need to call this function after e820_register_active_regions
+	 * so early_node_map[] is set
+	 */
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != -1ULL)
+		return addr;
+
+	/* fallback, should already have start end in the node range */
+	return find_e820_area(start, end, size, align);
+}
+
 /*
  * pre allocated 4k and reserved it in e820
  */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8948f47..ffc5ad5 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -174,7 +174,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
 	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	mem = find_e820_area(start, end, size, align);
+	mem = find_e820_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
@@ -184,7 +184,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
 	else
 		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = find_e820_area(start, end, size, align);
+	mem = find_e820_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e70f21b..5c2d17e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1160,6 +1160,8 @@ extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit);
 void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
 				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d03c946..eef3757 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3408,12 +3408,11 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+#ifdef CONFIG_HAVE_EARLY_RES
+u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
 	int i;
-	void *ptr;
 
 	/* need to go over early_node_map to find out good range for node */
 	for_each_active_range_index_in_nid(i, nid) {
@@ -3430,20 +3429,30 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 		if (addr == -1ULL)
 			continue;
 
-#if 0
-		printk(KERN_DEBUG "alloc (nid=%d %llx - %llx) (%llx - %llx) %llx %llx => %llx\n",
-				nid,
-				ei_start, ei_last, goal, limit, size,
-				align, addr);
+		return addr;
+	}
+
+	return -1ULL;
+}
 #endif
 
-		ptr = phys_to_virt(addr);
-		memset(ptr, 0, size);
-		reserve_early_without_check(addr, addr + size, "BOOTMEM");
-		return ptr;
-	}
+#ifdef CONFIG_NO_BOOTMEM
+void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	void *ptr;
 
-	return NULL;
+	u64 addr;
+
+	addr = find_memory_core_early(nid, size, align, goal, limit);
+
+	if (addr == -1ULL)
+		return NULL;
+
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	reserve_early_without_check(addr, addr + size, "BOOTMEM");
+	return ptr;
 }
 #endif
 
-- 
1.6.4.2

