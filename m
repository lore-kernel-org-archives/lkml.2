Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2LEQSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:18:36 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab2LEQJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:33 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 18/44] metag: TCM support
Date: Wed, 5 Dec 2012 16:08:36 +0000
Message-ID: <1354723742-6195-19-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some TCM support

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/mmzone.h    |   42 ++++++++++
 arch/metag/include/asm/sparsemem.h |   13 +++
 arch/metag/include/asm/tcm.h       |   30 +++++++
 arch/metag/kernel/tcm.c            |  151 ++++++++++++++++++++++++++++++++++++
 arch/metag/mm/numa.c               |   81 +++++++++++++++++++
 5 files changed, 317 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/mmzone.h
 create mode 100644 arch/metag/include/asm/sparsemem.h
 create mode 100644 arch/metag/include/asm/tcm.h
 create mode 100644 arch/metag/kernel/tcm.c
 create mode 100644 arch/metag/mm/numa.c

diff --git a/arch/metag/include/asm/mmzone.h b/arch/metag/include/asm/mmzone.h
new file mode 100644
index 0000000..9c88a9c
--- /dev/null
+++ b/arch/metag/include/asm/mmzone.h
@@ -0,0 +1,42 @@
+#ifndef __ASM_METAG_MMZONE_H
+#define __ASM_METAG_MMZONE_H
+
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+#include <linux/numa.h>
+
+extern struct pglist_data *node_data[];
+#define NODE_DATA(nid)		(node_data[nid])
+
+static inline int pfn_to_nid(unsigned long pfn)
+{
+	int nid;
+
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		if (pfn >= node_start_pfn(nid) && pfn <= node_end_pfn(nid))
+			break;
+
+	return nid;
+}
+
+static inline struct pglist_data *pfn_to_pgdat(unsigned long pfn)
+{
+	return NODE_DATA(pfn_to_nid(pfn));
+}
+
+/* arch/metag/mm/numa.c */
+void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end);
+#else
+static inline void
+setup_bootmem_node(int nid, unsigned long start, unsigned long end)
+{
+}
+#endif /* CONFIG_NEED_MULTIPLE_NODES */
+
+#ifdef CONFIG_NUMA
+/* SoC specific mem init */
+void __init soc_mem_setup(void);
+#else
+static inline void __init soc_mem_setup(void) {};
+#endif
+
+#endif /* __ASM_METAG_MMZONE_H */
diff --git a/arch/metag/include/asm/sparsemem.h b/arch/metag/include/asm/sparsemem.h
new file mode 100644
index 0000000..03fe255
--- /dev/null
+++ b/arch/metag/include/asm/sparsemem.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_METAG_SPARSEMEM_H
+#define __ASM_METAG_SPARSEMEM_H
+
+/*
+ * SECTION_SIZE_BITS		2^N: how big each section will be
+ * MAX_PHYSADDR_BITS		2^N: how much physical address space we have
+ * MAX_PHYSMEM_BITS		2^N: how much memory we can have in that space
+ */
+#define SECTION_SIZE_BITS	26
+#define MAX_PHYSADDR_BITS	32
+#define MAX_PHYSMEM_BITS	32
+
+#endif /* __ASM_METAG_SPARSEMEM_H */
diff --git a/arch/metag/include/asm/tcm.h b/arch/metag/include/asm/tcm.h
new file mode 100644
index 0000000..7711c31
--- /dev/null
+++ b/arch/metag/include/asm/tcm.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_TCM_H__
+#define __ASM_TCM_H__
+
+#include <linux/ioport.h>
+#include <linux/list.h>
+
+struct tcm_allocation {
+	struct list_head list;
+	unsigned int tag;
+	unsigned long addr;
+	unsigned long size;
+};
+
+/*
+ * TCM memory region descriptor.
+ */
+struct tcm_region {
+	unsigned int tag;
+	struct resource res;
+};
+
+#define TCM_INVALID_TAG	0xffffffff
+
+unsigned long tcm_alloc(unsigned int tag, size_t len);
+void tcm_free(unsigned int tag, unsigned long addr, size_t len);
+unsigned int tcm_lookup_tag(unsigned long p);
+
+int tcm_add_region(struct tcm_region *reg);
+
+#endif
diff --git a/arch/metag/kernel/tcm.c b/arch/metag/kernel/tcm.c
new file mode 100644
index 0000000..5d102b3
--- /dev/null
+++ b/arch/metag/kernel/tcm.c
@@ -0,0 +1,151 @@
+/*
+ * Copyright (C) 2010 Imagination Technologies Ltd.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/stddef.h>
+#include <linux/genalloc.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <asm/page.h>
+#include <asm/tcm.h>
+
+struct tcm_pool {
+	struct list_head list;
+	unsigned int tag;
+	unsigned long start;
+	unsigned long end;
+	struct gen_pool *pool;
+};
+
+static LIST_HEAD(pool_list);
+
+static struct tcm_pool *find_pool(unsigned int tag)
+{
+	struct list_head *lh;
+	struct tcm_pool *pool;
+
+	list_for_each(lh, &pool_list) {
+		pool = list_entry(lh, struct tcm_pool, list);
+		if (pool->tag == tag)
+			return pool;
+	}
+
+	return NULL;
+}
+
+/**
+ * tcm_alloc - allocate memory from a TCM pool
+ * @tag: tag of the pool to allocate memory from
+ * @len: number of bytes to be allocated
+ *
+ * Allocate the requested number of bytes from the pool matching
+ * the specified tag. Returns the address of the allocated memory
+ * or zero on failure.
+ */
+unsigned long tcm_alloc(unsigned int tag, size_t len)
+{
+	unsigned long vaddr;
+	struct tcm_pool *pool;
+
+	pool = find_pool(tag);
+	if (!pool)
+		return 0;
+
+	vaddr = gen_pool_alloc(pool->pool, len);
+	if (!vaddr)
+		return 0;
+
+	return vaddr;
+}
+
+/**
+ * tcm_free - free a block of memory to a TCM pool
+ * @tag: tag of the pool to free memory to
+ * @addr: address of the memory to be freed
+ * @len: number of bytes to be freed
+ *
+ * Free the requested number of bytes at a specific address to the
+ * pool matching the specified tag.
+ */
+void tcm_free(unsigned int tag, unsigned long addr, size_t len)
+{
+	struct tcm_pool *pool;
+
+	pool = find_pool(tag);
+	if (!pool)
+		return;
+	gen_pool_free(pool->pool, addr, len);
+}
+
+/**
+ * tcm_lookup_tag - find the tag matching an address
+ * @p: memory address to lookup the tag for
+ *
+ * Find the tag of the tcm memory region that contains the
+ * specified address. Returns %TCM_INVALID_TAG if no such
+ * memory region could be found.
+ */
+unsigned int tcm_lookup_tag(unsigned long p)
+{
+	struct list_head *lh;
+	struct tcm_pool *pool;
+	unsigned long addr = (unsigned long) p;
+
+	list_for_each(lh, &pool_list) {
+		pool = list_entry(lh, struct tcm_pool, list);
+		if (addr >= pool->start && addr < pool->end)
+			return pool->tag;
+	}
+
+	return TCM_INVALID_TAG;
+}
+
+/**
+ * tcm_add_region - add a memory region to TCM pool list
+ * @reg: descriptor of region to be added
+ *
+ * Add a region of memory to the TCM pool list. Returns 0 on success.
+ */
+int __init tcm_add_region(struct tcm_region *reg)
+{
+	struct tcm_pool *pool;
+
+	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool) {
+		pr_err("Failed to alloc memory for TCM pool!\n");
+		return -ENOMEM;
+	}
+
+	pool->tag = reg->tag;
+	pool->start = reg->res.start;
+	pool->end = reg->res.end;
+
+	/*
+	 * 2^3 = 8 bytes granularity to allow for 64bit access alignment.
+	 * -1 = NUMA node specifier.
+	 */
+	pool->pool = gen_pool_create(3, -1);
+
+	if (!pool->pool) {
+		pr_err("Failed to create TCM pool!\n");
+		kfree(pool);
+		return -ENOMEM;
+	}
+
+	if (gen_pool_add(pool->pool, reg->res.start,
+			 reg->res.end - reg->res.start + 1, -1)) {
+		pr_err("Failed to add memory to TCM pool!\n");
+		return -ENOMEM;
+	}
+	pr_info("Added %s TCM pool (%08x bytes @ %08x)\n",
+		reg->res.name, reg->res.end - reg->res.start + 1,
+		reg->res.start);
+
+	list_add_tail(&pool->list, &pool_list);
+
+	return 0;
+}
diff --git a/arch/metag/mm/numa.c b/arch/metag/mm/numa.c
new file mode 100644
index 0000000..9ae578c
--- /dev/null
+++ b/arch/metag/mm/numa.c
@@ -0,0 +1,81 @@
+/*
+ *  Multiple memory node support for Meta machines
+ *
+ *  Copyright (C) 2007  Paul Mundt
+ *  Copyright (C) 2010  Imagination Technologies Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/export.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/numa.h>
+#include <linux/pfn.h>
+#include <asm/sections.h>
+
+struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL_GPL(node_data);
+
+extern char _heap_start[];
+
+/*
+ * On Meta machines the conventional approach is to stash system RAM
+ * in node 0, and other memory blocks in to node 1 and up, ordered by
+ * latency. Each node's pgdat is node-local at the beginning of the node,
+ * immediately followed by the node mem map.
+ */
+void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
+{
+	unsigned long bootmap_pages, bootmem_paddr;
+	unsigned long start_pfn, end_pfn;
+	unsigned long pgdat_paddr;
+
+	/* Don't allow bogus node assignment */
+	BUG_ON(nid > MAX_NUMNODES || nid <= 0);
+
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = end >> PAGE_SHIFT;
+
+	memblock_add(start, end - start);
+
+	memblock_set_node(PFN_PHYS(start_pfn),
+			  PFN_PHYS(end_pfn - start_pfn), nid);
+
+	/* Node-local pgdat */
+	pgdat_paddr = memblock_alloc_base(sizeof(struct pglist_data),
+					  SMP_CACHE_BYTES, end);
+	NODE_DATA(nid) = __va(pgdat_paddr);
+	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+
+	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+	NODE_DATA(nid)->node_start_pfn = start_pfn;
+	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
+
+	/* Node-local bootmap */
+	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
+	bootmem_paddr = memblock_alloc_base(bootmap_pages << PAGE_SHIFT,
+					    PAGE_SIZE, end);
+	init_bootmem_node(NODE_DATA(nid), bootmem_paddr >> PAGE_SHIFT,
+			  start_pfn, end_pfn);
+
+	free_bootmem_with_active_regions(nid, end_pfn);
+
+	/* Reserve the pgdat and bootmap space with the bootmem allocator */
+	reserve_bootmem_node(NODE_DATA(nid), pgdat_paddr & PAGE_MASK,
+			     sizeof(struct pglist_data), BOOTMEM_DEFAULT);
+	reserve_bootmem_node(NODE_DATA(nid), bootmem_paddr,
+			     bootmap_pages << PAGE_SHIFT, BOOTMEM_DEFAULT);
+
+	/* It's up */
+	node_set_online(nid);
+
+	/* Kick sparsemem */
+	sparse_memory_present_with_active_regions(nid);
+}
+
+void __init __weak soc_mem_setup(void)
+{
+}
-- 
1.7.7.6


