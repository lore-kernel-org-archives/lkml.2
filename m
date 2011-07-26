Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1GZPhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:37:22 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:56152 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1GZPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:35:47 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/23] memblock: Make memblock_{add|remove|free|reserve}() return int and update prototypes
Date: Tue, 26 Jul 2011 17:35:13 +0200
Message-Id: <1311694534-5161-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_{add|remove|free|reserve}() return either 0 or -errno but had
long as return type.  Chage it to int.  Also, drop 'extern' from all
prototypes in memblock.h - they are unnecessary and used
inconsistently (especially if mm.h is included in the picture).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |   62 ++++++++++++++++++++-------------------------
 mm/memblock.c            |   18 ++++++------
 2 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 9074631..51abc82 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,15 +52,15 @@ phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-extern void memblock_init(void);
-extern void memblock_analyze(void);
-extern long memblock_add(phys_addr_t base, phys_addr_t size);
-extern long memblock_remove(phys_addr_t base, phys_addr_t size);
-extern long memblock_free(phys_addr_t base, phys_addr_t size);
-extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_init(void);
+void memblock_analyze(void);
+int memblock_add(phys_addr_t base, phys_addr_t size);
+int memblock_remove(phys_addr_t base, phys_addr_t size);
+int memblock_free(phys_addr_t base, phys_addr_t size);
+int memblock_reserve(phys_addr_t base, phys_addr_t size);
 
-extern void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
-				  phys_addr_t *out_end, int *out_nid);
+void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
+			   phys_addr_t *out_end, int *out_nid);
 
 /**
  * for_each_free_mem_range - iterate through free memblock areas
@@ -80,7 +80,7 @@ extern void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
 	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid))
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-extern int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
+int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
 static inline void memblock_set_region_node(struct memblock_region *r, int nid)
 {
@@ -105,36 +105,30 @@ static inline int memblock_get_region_node(const struct memblock_region *r)
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
-extern phys_addr_t memblock_find_in_range_node(phys_addr_t start,
-					       phys_addr_t end,
-					       phys_addr_t size,
-					       phys_addr_t align, int nid);
-extern phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
-					int nid);
-extern phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
-					    int nid);
+phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
+				phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
 
-extern phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
+phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
-extern phys_addr_t memblock_alloc_base(phys_addr_t size,
-					 phys_addr_t align,
-					 phys_addr_t max_addr);
-extern phys_addr_t __memblock_alloc_base(phys_addr_t size,
-					   phys_addr_t align,
-					   phys_addr_t max_addr);
-extern phys_addr_t memblock_phys_mem_size(void);
-extern phys_addr_t memblock_end_of_DRAM(void);
-extern void memblock_enforce_memory_limit(phys_addr_t memory_limit);
-extern int memblock_is_memory(phys_addr_t addr);
-extern int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-extern int memblock_is_reserved(phys_addr_t addr);
-extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
-
-extern void memblock_dump_all(void);
+phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
+				phys_addr_t max_addr);
+phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
+				  phys_addr_t max_addr);
+phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_end_of_DRAM(void);
+void memblock_enforce_memory_limit(phys_addr_t memory_limit);
+int memblock_is_memory(phys_addr_t addr);
+int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
+int memblock_is_reserved(phys_addr_t addr);
+int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
+
+void memblock_dump_all(void);
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
@@ -142,7 +136,7 @@ extern void memblock_dump_all(void);
  *                         accessible during boot
  * @limit: New limit value (physical address)
  */
-extern void memblock_set_current_limit(phys_addr_t limit);
+void memblock_set_current_limit(phys_addr_t limit);
 
 
 /*
diff --git a/mm/memblock.c b/mm/memblock.c
index 5ecacc1..82dd165 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -176,7 +176,7 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
 }
 
 /* Defined below but needed now */
-static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size);
+static int memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size);
 
 static int __init_memblock memblock_double_array(struct memblock_type *type)
 {
@@ -316,8 +316,8 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-static long __init_memblock memblock_add_region(struct memblock_type *type,
-						phys_addr_t base, phys_addr_t size)
+static int __init_memblock memblock_add_region(struct memblock_type *type,
+					       phys_addr_t base, phys_addr_t size)
 {
 	bool insert = false;
 	phys_addr_t obase = base, end = base + size;
@@ -387,13 +387,13 @@ repeat:
 	}
 }
 
-long __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
 	return memblock_add_region(&memblock.memory, base, size);
 }
 
-static long __init_memblock __memblock_remove(struct memblock_type *type,
-					      phys_addr_t base, phys_addr_t size)
+static int __init_memblock __memblock_remove(struct memblock_type *type,
+					     phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t end = base + size;
 	int i;
@@ -443,12 +443,12 @@ static long __init_memblock __memblock_remove(struct memblock_type *type,
 	return 0;
 }
 
-long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 {
 	return __memblock_remove(&memblock.memory, base, size);
 }
 
-long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
 		     (unsigned long long)base,
@@ -458,7 +458,7 @@ long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
-long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
-- 
1.7.6

