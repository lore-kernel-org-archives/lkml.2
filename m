Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1BVKYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:24:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59568 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1BVKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AunR+WV6Uro8Uakwi+pwYJDI/EOJa9Ax785zCiZv+YBhWmsaDkFDXV9j1JfTwtRYT/
         NHvIZIHoXCggjIjqDlDph0t551khC848BY9lfiNnlTAjk//kumi4jV5tT0UUIB2Li/dy
         iwbZimgnDpWCzpgcrAuzyZLDm1mEraXZ4+qvY=
Date: Tue, 22 Feb 2011 11:23:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86-64, NUMA: Seperate out numa_alloc_distance() from
 numa_set_distance()
Message-ID: <20110222102357.GW31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC19A.9030808@kernel.org>
 <20110221104803.GK31267@htj.dyndns.org>
 <4D62A2A4.7060701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62A2A4.7060701@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alloc code is much bigger the distance setting.  Separate it out into
numa_alloc_distance() for readability.

-v2: Let alloc_numa_distance to return -ENOMEM on failing path,
     requested by tj.

-tj: Description update.  Minor tweaks including function name,
     location and return value check.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to x86-numa with minor tweaks.  Thanks.

 arch/x86/mm/numa_64.c |   75 ++++++++++++++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 848381b..cccc01d 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -401,6 +401,44 @@ void __init numa_reset_distance(void)
 	numa_distance = NULL;
 }
 
+static int __init numa_alloc_distance(void)
+{
+	nodemask_t nodes_parsed;
+	size_t size;
+	int i, j, cnt = 0;
+	u64 phys;
+
+	/* size the new table and allocate it */
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
+
+	for_each_node_mask(i, nodes_parsed)
+		cnt = i;
+	size = ++cnt * sizeof(numa_distance[0]);
+
+	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
+				      size, PAGE_SIZE);
+	if (phys == MEMBLOCK_ERROR) {
+		pr_warning("NUMA: Warning: can't allocate distance table!\n");
+		/* don't retry until explicitly reset */
+		numa_distance = (void *)1LU;
+		return -ENOMEM;
+	}
+	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+
+	numa_distance = __va(phys);
+	numa_distance_cnt = cnt;
+
+	/* fill with the default distances */
+	for (i = 0; i < cnt; i++)
+		for (j = 0; j < cnt; j++)
+			numa_distance[i * cnt + j] = i == j ?
+				LOCAL_DISTANCE : REMOTE_DISTANCE;
+	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+
+	return 0;
+}
+
 /**
  * numa_set_distance - Set NUMA distance from one NUMA to another
  * @from: the 'from' node to set distance
@@ -413,41 +451,8 @@ void __init numa_reset_distance(void)
  */
 void __init numa_set_distance(int from, int to, int distance)
 {
-	if (!numa_distance) {
-		nodemask_t nodes_parsed;
-		size_t size;
-		int i, j, cnt = 0;
-		u64 phys;
-
-		/* size the new table and allocate it */
-		nodes_parsed = numa_nodes_parsed;
-		numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
-
-		for_each_node_mask(i, nodes_parsed)
-			cnt = i;
-		size = ++cnt * sizeof(numa_distance[0]);
-
-		phys = memblock_find_in_range(0,
-					      (u64)max_pfn_mapped << PAGE_SHIFT,
-					      size, PAGE_SIZE);
-		if (phys == MEMBLOCK_ERROR) {
-			pr_warning("NUMA: Warning: can't allocate distance table!\n");
-			/* don't retry until explicitly reset */
-			numa_distance = (void *)1LU;
-			return;
-		}
-		memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
-
-		numa_distance = __va(phys);
-		numa_distance_cnt = cnt;
-
-		/* fill with the default distances */
-		for (i = 0; i < cnt; i++)
-			for (j = 0; j < cnt; j++)
-				numa_distance[i * cnt + j] = i == j ?
-					LOCAL_DISTANCE : REMOTE_DISTANCE;
-		printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
-	}
+	if (!numa_distance && numa_alloc_distance() < 0)
+		return;
 
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
 		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
-- 
1.7.1

