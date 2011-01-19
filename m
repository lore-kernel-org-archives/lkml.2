Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1ASXBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:01:12 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40729 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753850Ab1ASXBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:01:10 -0500
Message-Id: <20110119230106.817577441@gulag1.americas.sgi.com>
References: <20110119230106.341785959@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 19 Jan 2011 17:01:09 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 3/6] x86: Minimize initial Bootmem messages
Content-Disposition: inline; filename=minimize-bootmem-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of Bootmem setup information is repeated for
every node.  Minimize the output by showing early reservations
only once unless it changes for a specific node, and condense
the first three lines into one line.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/e820.c |   31 ++++++++++++++++++++++---------
 arch/x86/mm/numa_64.c  |   12 +++---------
 2 files changed, 25 insertions(+), 18 deletions(-)

--- linux-2.6.32.orig/arch/x86/kernel/e820.c
+++ linux-2.6.32/arch/x86/kernel/e820.c
@@ -922,29 +922,42 @@ void __init free_early(u64 start, u64 en
 
 void __init early_res_to_bootmem(u64 start, u64 end)
 {
-	int i, count;
+	int i, count, same = 1;
 	u64 final_start, final_end;
+	static struct early_res pres[MAX_EARLY_RES];
 
 	count  = 0;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++)
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		/* remove redundant messages */
+		if (pres[i].start != early_res[i].start ||
+		    pres[i].end != early_res[i].end) {
+			pres[i].start = early_res[i].start;
+			pres[i].end = early_res[i].end;
+			same =  0;
+		}
 		count++;
+	}
+	if (same) {
+		pr_cont("ER:%d %llx+%llx\n", count, start, end-start);
+		return;
+	}
+
+	pr_info("Early Reservations: %d [%llx+%llx]\n",
+		count, start, end-start);
 
-	printk(KERN_INFO "(%d early reservations) ==> bootmem [%010llx - %010llx]\n",
-			 count, start, end);
 	for (i = 0; i < count; i++) {
 		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
+		pr_info("  #%d [%010llx - %010llx] %16s", i,
 			r->start, r->end, r->name);
 		final_start = max(start, r->start);
 		final_end = min(end, r->end);
 		if (final_start >= final_end) {
-			printk(KERN_CONT "\n");
+			pr_cont("\n");
 			continue;
 		}
-		printk(KERN_CONT " ==> [%010llx - %010llx]\n",
-			final_start, final_end);
+		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
 		reserve_bootmem_generic(final_start, final_end - final_start,
-				BOOTMEM_DEFAULT);
+			BOOTMEM_DEFAULT);
 	}
 }
 
--- linux-2.6.32.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.32/arch/x86/mm/numa_64.c
@@ -201,9 +201,6 @@ setup_node_bootmem(int nodeid, unsigned
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
-	       start, end);
-
 	start_pfn = start >> PAGE_SHIFT;
 	last_pfn = end >> PAGE_SHIFT;
 
@@ -219,8 +216,6 @@ setup_node_bootmem(int nodeid, unsigned
 	if (node_data[nodeid] == (void *)cache_alias_offset)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
-	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
-		nodedata_phys + pgdat_size - 1);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
 	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
@@ -258,12 +253,11 @@ setup_node_bootmem(int nodeid, unsigned
 					 bootmap_start >> PAGE_SHIFT,
 					 start_pfn, last_pfn);
 
-	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
-		 bootmap_start, bootmap_start + bootmap_size - 1,
-		 bootmap_pages);
-
 	free_bootmem_with_active_regions(nodeid, end);
 
+	pr_info("Bootmem Node %d: data %lx map %lx+%lx pgs %lx ",
+		nodeid, start, bootmap_start, bootmap_size, bootmap_pages);
+
 	/*
 	 * convert early reserve to bootmem reserve earlier
 	 * otherwise early_node_mem could use early reserved mem

-- 
