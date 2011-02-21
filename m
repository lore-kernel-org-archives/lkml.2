Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1BURjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:39:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44359 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1BURi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:38:58 -0500
Message-ID: <4D62A2A4.7060701@kernel.org>
Date: Mon, 21 Feb 2011 09:36:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 4/4] x86, numa: seperate alloc_numa_distance from numa_reset_distance.
References: <4D5EC05A.60103@kernel.org> <4D5EC19A.9030808@kernel.org> <20110221104803.GK31267@htj.dyndns.org>
In-Reply-To: <20110221104803.GK31267@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D62A31B.00B6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 02:48 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 18, 2011 at 10:59:38AM -0800, Yinghai Lu wrote:
>> +	if (!numa_distance)
>> +		alloc_numa_distance();
>> +
>> +	if (!numa_distance_cnt)
>> +		return;
> 
> Can you at least make alloc_numa_distance() return -ENOMEM on failure
> instead of checking the numa_distance_cnt implicitly in the caller?

please check

[PATCH -v2] x86, numa: seperate alloc_numa_distance from numa_reset_distance.

alloc code is much bigger the setting self.

 make the code some readable.

-v2: let alloc_numa_distance to return -ENOMEM on failing path, requested by tj.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>

---
 arch/x86/mm/numa_64.c |   76 ++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -375,6 +375,45 @@ static void __init numa_reset_distance(v
 	numa_distance = NULL;
 }
 
+static int __init alloc_numa_distance(void)
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
+	phys = memblock_find_in_range(0,
+				      (u64)max_pfn_mapped << PAGE_SHIFT,
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
 /*
  * Set the distance between node @from to @to to @distance.  If distance
  * table doesn't exist, one which is large enough to accomodate all the
@@ -382,41 +421,8 @@ static void __init numa_reset_distance(v
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
+	if (!numa_distance && alloc_numa_distance())
+		return;
 
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
 		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
