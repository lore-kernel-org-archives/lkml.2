Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1BRTBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:01:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48281 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab1BRTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:01:43 -0500
Message-ID: <4D5EC177.7030101@kernel.org>
Date: Fri, 18 Feb 2011 10:59:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/4] x86, numa: Do not scan two times for setup_node_bootmem()
References: <4D5EC05A.60103@kernel.org>
In-Reply-To: <4D5EC05A.60103@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D5EC1FE.030E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We don't need to scan two times for setup_node_bootmem()
because We are using mapped memblock for node_data finding already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -480,7 +480,7 @@ static bool __init numa_meminfo_cover_me
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	int i, j, nid;
+	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
@@ -507,27 +507,22 @@ static int __init numa_register_memblks(
 	init_memory_mapping_high();
 
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
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 end = 0;
 
-			if (node_online(nid))
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
 				continue;
-
-			for (j = 0; j < mi->nr_blks; j++) {
-				if (nid != mi->blk[j].nid)
-					continue;
-				start = min(mi->blk[j].start, start);
-				end = max(mi->blk[j].end, end);
-			}
-
-			if (start < end)
-				setup_node_bootmem(nid, start, end);
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
 		}
+
+		if (start < end)
+			setup_node_bootmem(nid, start, end);
 	}
 
 	return 0;
