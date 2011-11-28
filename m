Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1K1Tcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:32:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61090 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1K1Tcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:32:46 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH 16/23] sparc: Use HAVE_MEMBLOCK_NODE_MAP
Date: Mon, 28 Nov 2011 11:31:18 -0800
Message-Id: <1322508685-32532-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
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
 arch/sparc/Kconfig      |    1 +
 arch/sparc/mm/init_64.c |   24 ++++--------------------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index f92602e..91a6d1e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -43,6 +43,7 @@ config SPARC64
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 29723a2..b3f5e7d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -816,7 +816,7 @@ static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 #endif
 
 /* This must be invoked after performing all of the necessary
- * add_active_range() calls for 'nid'.  We need to be able to get
+ * memblock_set_node() calls for 'nid'.  We need to be able to get
  * correct data from get_pfn_range_for_nid().
  */
 static void __init allocate_node_data(int nid)
@@ -987,14 +987,11 @@ static void __init add_node_ranges(void)
 
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
@@ -1282,7 +1279,6 @@ static void __init bootmem_init_nonnuma(void)
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1292,20 +1288,8 @@ static void __init bootmem_init_nonnuma(void)
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
1.7.3.1

