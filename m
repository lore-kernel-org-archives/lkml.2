Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab1D2Pb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:31:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab1D2P30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kjylQTw9DsLJDPTfU7ih9ggY1WO/brjB7p5IYp2vJ8yLfGtnJBsDIiPKuheDvQtioF
         7iLUgJhUrPSg8OUSft8Ok6pj6wgWvR5D6zy0f75woQvxsQUhcutn/MX6A3U0HYygtQT9
         KBeWCeNGLdd+MMZXEuXM1nPUZEIu8a9Cq3wNQ=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/25] x86-32, NUMA: Add @start and @end to init_alloc_remap()
Date: Fri, 29 Apr 2011 17:28:38 +0200
Message-Id: <1304090924-8197-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of dereferencing node_start/end_pfn[] directly, make
init_alloc_remap() take @start and @end and let the caller be
responsible for making sure the range is sane.  This is to prepare for
use from unified NUMA init code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 975a76f..9008632 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -265,8 +265,10 @@ void resume_map_numa_kva(pgd_t *pgd_base)
  * opportunistically and the callers will fall back to other memory
  * allocation mechanisms on failure.
  */
-static __init void init_alloc_remap(int nid)
+static __init void init_alloc_remap(int nid, u64 start, u64 end)
 {
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = end >> PAGE_SHIFT;
 	unsigned long size, pfn;
 	u64 node_pa, remap_pa;
 	void *remap_va;
@@ -276,24 +278,15 @@ static __init void init_alloc_remap(int nid)
 	 * memory could be added but not currently present.
 	 */
 	printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
-	       nid, node_start_pfn[nid], node_end_pfn[nid]);
-	if (node_start_pfn[nid] > max_pfn)
-		return;
-	if (!node_end_pfn[nid])
-		return;
-	if (node_end_pfn[nid] > max_pfn)
-		node_end_pfn[nid] = max_pfn;
+	       nid, start_pfn, end_pfn);
 
 	/* calculate the necessary space aligned to large page size */
-	size = node_memmap_size_bytes(nid, node_start_pfn[nid],
-				      min(node_end_pfn[nid], max_pfn));
+	size = node_memmap_size_bytes(nid, start_pfn, end_pfn);
 	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
 	size = ALIGN(size, LARGE_PAGE_BYTES);
 
 	/* allocate node memory and the lowmem remap area */
-	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
-					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
-					 size, LARGE_PAGE_BYTES);
+	node_pa = memblock_find_in_range(start, end, size, LARGE_PAGE_BYTES);
 	if (node_pa == MEMBLOCK_ERROR) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
 			   size, nid);
@@ -391,8 +384,14 @@ void __init initmem_init(void)
 	get_memcfg_numa();
 	numa_init_array();
 
-	for_each_online_node(nid)
-		init_alloc_remap(nid);
+	for_each_online_node(nid) {
+		u64 start = (u64)node_start_pfn[nid] << PAGE_SHIFT;
+		u64 end = min((u64)node_end_pfn[nid] << PAGE_SHIFT,
+			      (u64)max_pfn << PAGE_SHIFT);
+
+		if (start < end)
+			init_alloc_remap(nid, start, end);
+	}
 
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
-- 
1.7.1

