Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1GZPjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:39:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab1GZPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:08 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH 16/23] sparc: Use HAVE_MEMBLOCK_NODE_MAP
Date: Tue, 26 Jul 2011 17:35:27 +0200
Message-Id: <1311694534-5161-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
David, memblock now can carry node information itself without relying
on early_node_map[], which makes operations which make use of both
information much saner and generally makes NUMA memory init simpler.

Boot-tested 64bit [!]SMP [!]NUMA on my non-NUMA u60.  Compile tested
32bit [!]SMP.

The patches implementing HAVE_MEMBLOCK_NODE_MAP is currently in
tip:x86/memblock branch on which this patch is based on.

Thanks.

 arch/sparc/Kconfig      |    3 +++
 arch/sparc/mm/init_64.c |   24 ++++--------------------
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 253986b..9ae3b19 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -356,6 +356,9 @@ config NODES_SPAN_OTHER_NODES
 config ARCH_POPULATES_NODE_MAP
 	def_bool y if SPARC64
 
+config HAVE_MEMBLOCK_NODE_MAP
+	def_bool y if SPARC64
+
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y if SPARC64
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index ae9bab4..3985d3b 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -811,7 +811,7 @@ static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 #endif
 
 /* This must be invoked after performing all of the necessary
- * add_active_range() calls for 'nid'.  We need to be able to get
+ * memblock_set_node() calls for 'nid'.  We need to be able to get
  * correct data from get_pfn_range_for_nid().
  */
 static void __init allocate_node_data(int nid)
@@ -982,14 +982,11 @@ static void __init add_node_ranges(void)
 
 			this_end = memblock_nid_range(start, end, &nid);
 
-			numadbg("Adding active range nid[%d] "
+			numadbg("Setting memblock NUMA node nid[%d] "
 				"start[%lx] end[%lx]\n",
 				nid, start, this_end);
 
-			add_active_range(nid,
-					 start >> PAGE_SHIFT,
-					 this_end >> PAGE_SHIFT);
-
+			memblock_set_node(start, this_end - start, nid);
 			start = this_end;
 		}
 	}
@@ -1277,7 +1274,6 @@ static void __init bootmem_init_nonnuma(void)
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1287,20 +1283,8 @@ static void __init bootmem_init_nonnuma(void)
 	       (top_of_ram - total_ram) >> 20);
 
 	init_node_masks_nonnuma();
-
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-
-		if (!reg->size)
-			continue;
-
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-		add_active_range(0, start_pfn, end_pfn);
-	}
-
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 	allocate_node_data(0);
-
 	node_set_online(0);
 }
 
-- 
1.7.6

