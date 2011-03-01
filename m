Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1CAWUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:20:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54298 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1CAWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:20:06 -0500
Message-ID: <4D6D70E1.40808@kernel.org>
Date: Tue, 01 Mar 2011 14:19:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm]
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D6D70FE.00DA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 09:18 AM, David Rientjes wrote:
> On Thu, 24 Feb 2011, Yinghai Lu wrote:
> 
>> DavidR reported that x86/mm broke his numa emulation with 128M etc.
>>
>> So wonder if that would hold you to push whole tip/x86/mm to Linus for .39
>> or need to rebase it while taking the tip/x86/numa-emulation-unify out.
>>
> 
> Ok, so 1f565a896ee1 (x86-64, NUMA: Fix size of numa_distance array) fixes 
> the boot failure when using numa=fake, but there's still another issue 
> that was introduced with regard to emulated distances between fake nodes 
> sitting hardware using a SLIT.
> 
> This is important because we want to ensure that the physical topoloy of 
> the machine is still represented in an emulated environment to 
> appropriately describe the expected latencies between the nodes.  It also 
> allows users who are using numa=fake purely as a debugging tool to test 
> more interesting configurations and benchmark memory accesses between 
> emulated nodes as though they were real.
> 
> For example, on my four-node system with a custom SLIT, this is the 
> distance when booting without numa=fake:
> 
> 	$ cat /sys/devices/system/node/node*/distance 
> 	10 20 20 30
> 	20 10 20 20
> 	20 20 10 20
> 	30 20 20 10
> 
> These physical nodes are all symmetric in size.
> 
> With numa=fake=16, we expect to see the fake nodes interleaved (as the 
> default) over the set of physical nodes.  This would suggest distance 
> files for these nodes to be:
> 
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 
> (And that is what we see with 2.6.37.)
> 
> However, x86/mm describes these distances differently:
> 
> 	node0/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node1/distance:10 10 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node2/distance:10 20 10 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node3/distance:10 20 20 10 10 20 20 20 10 20 20 20 10 20 20 20
> 	node4/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node5/distance:10 20 20 20 10 10 20 20 10 20 20 20 10 20 20 20
> 	node6/distance:10 20 20 20 10 20 10 20 10 20 20 20 10 20 20 20
> 	node7/distance:10 20 20 20 10 20 20 10 10 20 20 20 10 20 20 20
> 	node8/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node9/distance:10 20 20 20 10 20 20 20 10 10 20 20 10 20 20 20
> 	node10/distance:10 20 20 20 10 20 20 20 10 20 10 20 10 20 20 20
> 	node11/distance:10 20 20 20 10 20 20 20 10 20 20 10 10 20 20 20
> 	node12/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node13/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 10 20 20
> 	node14/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 10 20
> 	node15/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 10
> 
> It looks as though the emulation changes sitting in x86/mm have dropped 
> the SLIT and are merely describing the emulated nodes as either having 
> physical affinity or not.

please check:

[PATCH] x86, numa, emu: Fix slit ignoring.

David Reported that after numa_emu clean up, SLIT does not honor anymore.

after looking at the code, it seems the cleanup does have several problems:
1. need to reserve temp numa dist.
	We only can use find_...without_reserve tricks when we are done with
	 the old one before get another new one.
2. during copying should only copy with NEW numa_dist_cnt size.
	so need to call numa_alloc_dist at first before copy.
3. phys_dist whould numa_dist_cnt square size
4. numa_reset_distance should free numa_dist_cnt square size

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa_64.c        |    6 ++---
 arch/x86/mm/numa_emulation.c |   50 ++++++++++++++++++++++++++++++-------------
 arch/x86/mm/numa_internal.h  |    1 
 3 files changed, 40 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -393,7 +393,7 @@ void __init numa_reset_distance(void)
 	size_t size;
 
 	if (numa_distance_cnt) {
-		size = numa_distance_cnt * sizeof(numa_distance[0]);
+		size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
 		memblock_x86_free_range(__pa(numa_distance),
 					__pa(numa_distance) + size);
 		numa_distance_cnt = 0;
@@ -401,7 +401,7 @@ void __init numa_reset_distance(void)
 	numa_distance = NULL;
 }
 
-static int __init numa_alloc_distance(void)
+int __init numa_alloc_distance(void)
 {
 	nodemask_t nodes_parsed;
 	size_t size;
@@ -437,7 +437,7 @@ static int __init numa_alloc_distance(vo
 				LOCAL_DISTANCE : REMOTE_DISTANCE;
 	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
 
-	return 0;
+	return cnt;
 }
 
 /**
Index: linux-2.6/arch/x86/mm/numa_emulation.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_emulation.c
+++ linux-2.6/arch/x86/mm/numa_emulation.c
@@ -300,7 +300,9 @@ void __init numa_emulation(struct numa_m
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
+	int phys_size = 0;
 	int i, j, ret;
+	int new_nr;
 
 	if (!emu_cmdline)
 		goto no_emu;
@@ -341,16 +343,17 @@ void __init numa_emulation(struct numa_m
 	 * reserve it.
 	 */
 	if (numa_dist_cnt) {
-		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
 		u64 phys;
 
+		phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 		phys = memblock_find_in_range(0,
 					      (u64)max_pfn_mapped << PAGE_SHIFT,
-					      size, PAGE_SIZE);
+					      phys_size, PAGE_SIZE);
 		if (phys == MEMBLOCK_ERROR) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
+		memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
@@ -383,21 +386,40 @@ void __init numa_emulation(struct numa_m
 
 	/* transform distance table */
 	numa_reset_distance();
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		for (j = 0; j < MAX_NUMNODES; j++) {
-			int physi = emu_nid_to_phys[i];
-			int physj = emu_nid_to_phys[j];
-			int dist;
-
-			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
-				dist = physi == physj ?
-					LOCAL_DISTANCE : REMOTE_DISTANCE;
-			else
+	/* allocate numa_distance at first, it will set new numa_dist_cnt */
+	new_nr = numa_alloc_distance();
+	if (new_nr < 0)
+		goto free_temp_phys;
+
+	/*
+	 * only set it when we have old phys_dist,
+	 * numa_alloc_distance already set default values
+	 */
+	if (phys_dist)
+		for (i = 0; i < new_nr; i++) {
+			for (j = 0; j < new_nr; j++) {
+				int physi = emu_nid_to_phys[i];
+				int physj = emu_nid_to_phys[j];
+				int dist;
+
+				/* really need this check ? */
+				if (physi >= numa_dist_cnt ||
+				    physj >= numa_dist_cnt)
+					continue;
+
 				dist = phys_dist[physi * numa_dist_cnt + physj];
 
-			numa_set_distance(i, j, dist);
+				numa_set_distance(i, j, dist);
+			}
 		}
-	}
+
+free_temp_phys:
+
+	/* Free the temp storage for phys */
+	if (phys_dist)
+		memblock_x86_free_range(__pa(phys_dist),
+					__pa(phys_dist) + phys_size);
+
 	return;
 
 no_emu:
Index: linux-2.6/arch/x86/mm/numa_internal.h
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_internal.h
+++ linux-2.6/arch/x86/mm/numa_internal.h
@@ -18,6 +18,7 @@ struct numa_meminfo {
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
 void __init numa_reset_distance(void);
+int numa_alloc_distance(void);
 
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
