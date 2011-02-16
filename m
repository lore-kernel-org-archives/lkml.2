Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1BPU7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:59:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34494 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1BPU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:59:45 -0500
Message-ID: <4D5C3A81.4070408@kernel.org>
Date: Wed, 16 Feb 2011 12:58:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, numa: refactoring numa_register_memblks
References: <4D5C3A0F.3080107@kernel.org>
In-Reply-To: <4D5C3A0F.3080107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D5C3AAE.016E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't hide init_memory_mapping and setup_bootmem into that __register__ function

those are really work.

Also We don't need to scan two times for setup_node_bootmem() becase we
are using mapped memblock for node_data already.

let num_register_memblks only take care of register them into early_node_map[]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -491,7 +491,7 @@ static bool __init numa_meminfo_cover_me
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	int i, j, nid;
+	int i;
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
@@ -515,33 +515,34 @@ static int __init numa_register_memblks(
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	init_memory_mapping_high();
+	return 0;
+}
+
+static void __init setup_numa_bootmem(struct numa_meminfo *mi)
+{
+	int i, nid;
 
 	/*
-	 * Finally register nodes.  Do it twice in case setup_node_bootmem
-	 * missed one due to missing bootmem.
+	 * Do not do that twice, not needed!
+	 *   We are using mapped memblock directly for node data
 	 */
-	for (i = 0; i < 2; i++) {
-		for_each_node_mask(nid, node_possible_map) {
-			u64 start = (u64)max_pfn << PAGE_SHIFT;
-			u64 end = 0;
-
-			if (node_online(nid))
-				continue;
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 end = 0;
 
-			for (j = 0; j < mi->nr_blks; j++) {
-				if (nid != mi->blk[j].nid)
-					continue;
-				start = min(mi->blk[j].start, start);
-				end = max(mi->blk[j].end, end);
-			}
+		if (node_online(nid))
+			continue;
 
-			if (start < end)
-				setup_node_bootmem(nid, start, end);
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
+				continue;
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
 		}
-	}
 
-	return 0;
+		if (start < end)
+			setup_node_bootmem(nid, start, end);
+	}
 }
 
 #ifdef CONFIG_NUMA_EMU
@@ -968,6 +969,10 @@ void __init initmem_init(void)
 		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
 
+		init_memory_mapping_high();
+
+		setup_numa_bootmem(&numa_meminfo);
+
 		for (j = 0; j < nr_cpu_ids; j++) {
 			int nid = early_cpu_to_node(j);
 
