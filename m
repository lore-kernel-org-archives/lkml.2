Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab0HFFRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:17:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52906 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802Ab0HFFPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:37 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 34/43] memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
Date: Fri,  6 Aug 2010 15:15:15 +1000
Message-Id: <1281071724-28740-35-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former is now strict, it will fail if it cannot honor the allocation
within the node, while the later implements the previous semantic which
falls back to allocating anywhere.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/sparc/mm/init_64.c  |    4 ++--
 include/linux/memblock.h |    6 +++++-
 mm/memblock.c            |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 0883113..dc584d2 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -820,7 +820,7 @@ static void __init allocate_node_data(int nid)
 	struct pglist_data *p;
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	paddr = memblock_alloc_nid(sizeof(struct pglist_data), SMP_CACHE_BYTES, nid);
+	paddr = memblock_alloc_try_nid(sizeof(struct pglist_data), SMP_CACHE_BYTES, nid);
 	if (!paddr) {
 		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
 		prom_halt();
@@ -840,7 +840,7 @@ static void __init allocate_node_data(int nid)
 	if (p->node_spanned_pages) {
 		num_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-		paddr = memblock_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid);
+		paddr = memblock_alloc_try_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid);
 		if (!paddr) {
 			prom_printf("Cannot allocate bootmap for nid[%d]\n",
 				  nid);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 82b0302..c8da03e 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -50,7 +50,11 @@ extern long __init memblock_reserve(phys_addr_t base, phys_addr_t size);
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
-extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
+extern phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
+					int nid);
+extern phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
+					    int nid);
+
 extern phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
diff --git a/mm/memblock.c b/mm/memblock.c
index af7e4d9..1802d97 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -537,9 +537,23 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 			return ret;
 	}
 
+	return 0;
+}
+
+phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
+{
+	phys_addr_t res = memblock_alloc_nid(size, align, nid);
+
+	if (res)
+		return res;
 	return memblock_alloc(size, align);
 }
 
+
+/*
+ * Remaining API functions
+ */
+
 /* You must call memblock_analyze() before this. */
 phys_addr_t __init memblock_phys_mem_size(void)
 {
-- 
1.7.0.4

