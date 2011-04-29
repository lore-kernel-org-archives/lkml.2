Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab1D2PeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:34:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166Ab1D2P2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=G/KfHEWAP2dDcHpfIxpWTAzg5gJprepZKJGNp84ShIEoRnm7u1iwmqTiB1lYZkKQWF
         beXGF4uNV1V3m5hTsaRLBwCjDGZT+N52j3xUidaPMT+toa2R9Z4RSTJHXATy3oLQwlda
         K89L0ySEKuqGzuj+LJdzw5iZV2PCxgFk8JG5s=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/25] x86-64, NUMA: trivial cleanups for setup_node_bootmem()
Date: Fri, 29 Apr 2011 17:28:21 +0200
Message-Id: <1304090924-8197-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following trivial changes in preparation for further updates.

* nodeid -> nid, nid -> tnid
* use nd_ prefix for nodedata related variables
* remove start/end_pfn and use start/end directly

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_64.c |   52 +++++++++++++++++++++---------------------------
 1 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index c4eecc2..5e0dfc5 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -128,14 +128,11 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 
 /* Initialize bootmem allocator for a node */
 void __init
-setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
+setup_node_bootmem(int nid, unsigned long start, unsigned long end)
 {
-	unsigned long start_pfn, last_pfn, nodedata_phys;
-	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	int nid;
-
-	if (!end)
-		return;
+	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	unsigned long nd_pa;
+	int tnid;
 
 	/*
 	 * Don't confuse VM with a node that doesn't have the
@@ -146,30 +143,27 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n", nodeid,
-	       start, end);
-
-	start_pfn = start >> PAGE_SHIFT;
-	last_pfn = end >> PAGE_SHIFT;
+	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n",
+	       nid, start, end);
 
-	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
-					   SMP_CACHE_BYTES);
-	if (node_data[nodeid] == NULL)
+	node_data[nid] = early_node_mem(nid, start, end, nd_size,
+					SMP_CACHE_BYTES);
+	if (node_data[nid] == NULL)
 		return;
-	nodedata_phys = __pa(node_data[nodeid]);
-	memblock_x86_reserve_range(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
-	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
-		nodedata_phys + pgdat_size - 1);
-	nid = early_pfn_to_nid(nodedata_phys >> PAGE_SHIFT);
-	if (nid != nodeid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
-
-	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->node_id = nodeid;
-	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
-	NODE_DATA(nodeid)->node_spanned_pages = last_pfn - start_pfn;
-
-	node_set_online(nodeid);
+	nd_pa = __pa(node_data[nid]);
+	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
+	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n",
+	       nd_pa, nd_pa + nd_size - 1);
+	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
+	if (tnid != nid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
+
+	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+	NODE_DATA(nid)->node_id = nid;
+	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
+	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
+
+	node_set_online(nid);
 }
 
 /**
-- 
1.7.1

