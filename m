Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2EDSzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:55:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20984 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2EDSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:55:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] bootmem/sparsemem: Have a new __alloc_bootmem_node_high
Date: Fri,  4 May 2012 14:49:42 -0400
Message-Id: <1336157382-14548-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1336157382-14548-1-git-send-email-konrad.wilk@oracle.com>
References: <1336157382-14548-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

called "__alloc_bootmem_node_high_caller" which will allow to pass
the IP of the caller. The particular user is sparse vmemmap:

 memblock_reserve: [0x0000003fafb000-0x0000003fefb000] (4096kB) sparse_init+0x25/0x272
 memblock_reserve: [0x0000003fafaf00-0x0000003fafafd8] (0kB) sparse_early_usemaps_alloc_node+0x34/0x7d
 memblock_reserve: [0x0000003f6faf00-0x0000003fafaf00] (4096kB) sparse_init+0x104/0x272
-memblock_reserve: [0x0000003e400000-0x0000003f600000] (18432kB) sparse_mem_maps_populate_node+0x46/0x138
-memblock_reserve: [0x0000003f6f9000-0x0000003f6fa000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f8000-0x0000003f6f9000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f7000-0x0000003f6f8000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f6000-0x0000003f6f7000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f5000-0x0000003f6f6000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f4000-0x0000003f6f5000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f3000-0x0000003f6f4000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f2000-0x0000003f6f3000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f1000-0x0000003f6f2000] (4kB) vmemmap_alloc_block+0xde/0xe3
-memblock_reserve: [0x0000003f6f0000-0x0000003f6f1000] (4kB) vmemmap_alloc_block+0xde/0xe3
-   memblock_free: [0x0000003f3c0000-0x0000003f600000] (2304kB) sparse_mem_maps_populate_node+0x113/0x138
+memblock_reserve: [0x0000003e400000-0x0000003f600000] (18432kB) sparse_mem_maps_populate_node+0x0/0x13f
+memblock_reserve: [0x0000003f6f9000-0x0000003f6fa000] (4kB) vmemmap_pgd_populate+0x2b/0x82
+memblock_reserve: [0x0000003f6f8000-0x0000003f6f9000] (4kB) vmemmap_pud_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f7000-0x0000003f6f8000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f6000-0x0000003f6f7000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f5000-0x0000003f6f6000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f4000-0x0000003f6f5000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f3000-0x0000003f6f4000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f2000-0x0000003f6f3000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f1000-0x0000003f6f2000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+memblock_reserve: [0x0000003f6f0000-0x0000003f6f1000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
+   memblock_free: [0x0000003f3c0000-0x0000003f600000] (2304kB) sparse_mem_maps_populate_node+0x11a/0x13f
    memblock_free: [0x0000003f6faf00-0x0000003fafaf00] (4096kB) sparse_init+0x24e/0x272
    memblock_free: [0x0000003fafb000-0x0000003fefb000] (4096kB) sparse_init+0x263/0x272

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/bootmem.h |    5 +++++
 mm/bootmem.c            |    7 ++++++-
 mm/nobootmem.c          |    6 ++++++
 mm/sparse-vmemmap.c     |    9 +++++----
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 66d3e95..4c4ed3b 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -87,6 +87,11 @@ void *__alloc_bootmem_node_high(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+void *__alloc_bootmem_node_high_caller(pg_data_t *pgdat,
+				       unsigned long size,
+				       unsigned long align,
+				       unsigned long goal,
+				       void *caller);
 extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 0131170..89c792b 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -753,7 +753,12 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 	return __alloc_bootmem_node(pgdat, size, align, goal);
 
 }
-
+void * __init __alloc_bootmem_node_high_caller(pg_data_t *pgdat, unsigned long size,
+					       unsigned long align, unsigned long goal,
+					       void *caller)
+{
+	return __alloc_bootmem_node_high(pgdat, size, align, goal);
+}
 #ifdef CONFIG_SPARSEMEM
 /**
  * alloc_bootmem_section - allocate boot memory from a specific section
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index fe9b251..0acc38e 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -326,6 +326,12 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 {
 	return ____alloc_bootmem_node(pgdat, size, align, goal, (void *)_RET_IP_);
 }
+void * __init __alloc_bootmem_node_high_caller(pg_data_t *pgdat, unsigned long size,
+					       unsigned long align, unsigned long goal,
+					       void *caller)
+{
+	return ____alloc_bootmem_node(pgdat, size, align, goal, caller);
+}
 
 #ifdef CONFIG_SPARSEMEM
 /**
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 1b7e22a..00e3b2a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -38,9 +38,10 @@
 static void * __init_refok __earlyonly_bootmem_alloc(int node,
 				unsigned long size,
 				unsigned long align,
-				unsigned long goal)
+				unsigned long goal,
+				void *caller)
 {
-	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
+	return __alloc_bootmem_node_high_caller(NODE_DATA(node), size, align, goal, caller);
 }
 
 static void *vmemmap_buf;
@@ -63,7 +64,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		return NULL;
 	} else
 		return __earlyonly_bootmem_alloc(node, size, size,
-				__pa(MAX_DMA_ADDRESS));
+				__pa(MAX_DMA_ADDRESS), (void *)_RET_IP_);
 }
 
 /* need to make sure size is all the same during early stage */
@@ -195,7 +196,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 
 	size = ALIGN(size, PMD_SIZE);
 	vmemmap_buf_start = __earlyonly_bootmem_alloc(nodeid, size * map_count,
-			 PMD_SIZE, __pa(MAX_DMA_ADDRESS));
+			 PMD_SIZE, __pa(MAX_DMA_ADDRESS), (void *)_THIS_IP_);
 
 	if (vmemmap_buf_start) {
 		vmemmap_buf = vmemmap_buf_start;
-- 
1.7.7.5

