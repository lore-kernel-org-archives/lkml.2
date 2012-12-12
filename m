Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2LLRGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:06:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2LLRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:06:12 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] mm: introduce numa_zero_pfn
Date: Thu, 13 Dec 2012 02:03:39 +0900
Message-Id: <1355331819-8728-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use just *one* zero page regardless of user process' node.
When user process read zero page, at first, cpu should load this
to cpu cache. If node of cpu is not same as node of zero page, loading
takes long time. If we make zero pages for each nodes and use them
adequetly, we can reduce this overhead.

This patch implement basic infrastructure for numa_zero_pfn.
It is default disabled, because it doesn't provide page coloring and
some architecture use page coloring for zero page.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..de0ab65 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -412,3 +412,8 @@ config FRONTSWAP
 	  and swap data is stored as normal on the matching swap device.
 
 	  If unsure, say Y to enable frontswap.
+
+config NUMA_ZERO_PFN
+	bool "Enable NUMA-aware zero page handling"
+	depends on NUMA
+	default n
diff --git a/mm/memory.c b/mm/memory.c
index 221fc9f..e7d3969 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -112,12 +112,43 @@ __setup("norandmaps", disable_randmaps);
 unsigned long zero_pfn __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
 
+#ifdef CONFIG_NUMA_ZERO_PFN
+unsigned long node_to_zero_pfn[MAX_NUMNODES] __read_mostly;
+
+/* Should be called after zero_pfn initialization */
+static void __init init_numa_zero_pfn(void)
+{
+	unsigned int node;
+
+	if (nr_node_ids == 1)
+		return;
+
+	for_each_node_state(node, N_POSSIBLE) {
+		node_to_zero_pfn[node] = zero_pfn;
+	}
+
+	for_each_node_state(node, N_HIGH_MEMORY) {
+		struct page *page;
+		page = alloc_pages_exact_node(node,
+				GFP_HIGHUSER | __GFP_ZERO, 0);
+		if (!page)
+			continue;
+
+		node_to_zero_pfn[node] = page_to_pfn(page);
+	}
+}
+#else
+static inline void __init init_numa_zero_pfn(void) {}
+#endif
+
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
 static int __init init_zero_pfn(void)
 {
 	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	init_numa_zero_pfn();
+
 	return 0;
 }
 core_initcall(init_zero_pfn);
@@ -717,6 +748,24 @@ static inline bool is_cow_mapping(vm_flags_t flags)
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+#ifdef CONFIG_NUMA_ZERO_PFN
+static inline int is_numa_zero_pfn(unsigned long pfn)
+{
+	return zero_pfn == pfn || node_to_zero_pfn[pfn_to_nid(pfn)] == pfn;
+}
+
+static inline unsigned long my_numa_zero_pfn(unsigned long addr)
+{
+	if (nr_node_ids == 1)
+		return zero_pfn;
+
+	return node_to_zero_pfn[numa_node_id()];
+}
+
+#define is_zero_pfn is_numa_zero_pfn
+#define my_zero_pfn my_numa_zero_pfn
+#endif /* CONFIG_NUMA_ZERO_PFN */
+
 #ifndef is_zero_pfn
 static inline int is_zero_pfn(unsigned long pfn)
 {
-- 
1.7.9.5

