Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1HHMaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:30:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38529 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1HHMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:30:44 -0400
Date: Mon, 8 Aug 2011 14:30:39 +0200
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, sparclinux@vger.kernel.org
Subject: [PATCH UPDATED 16/23] sparc: Use HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20110808123039.GL23937@htj.dyndns.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
 <1311694534-5161-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311694534-5161-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

-v2: Use select in Kconfig instead as suggested by Sam Ravnborg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: sparclinux@vger.kernel.org
---
Acked-by added and select used in Kconfig instead.

Thanks.

 arch/sparc/Kconfig      |    1 +
 arch/sparc/mm/init_64.c |   24 ++++--------------------
 2 files changed, 5 insertions(+), 20 deletions(-)

Index: work/arch/sparc/Kconfig
===================================================================
--- work.orig/arch/sparc/Kconfig
+++ work/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
Index: work/arch/sparc/mm/init_64.c
===================================================================
--- work.orig/arch/sparc/mm/init_64.c
+++ work/arch/sparc/mm/init_64.c
@@ -811,7 +811,7 @@ static u64 memblock_nid_range(u64 start,
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
@@ -1277,7 +1274,6 @@ static void __init bootmem_init_nonnuma(
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1287,20 +1283,8 @@ static void __init bootmem_init_nonnuma(
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
 
