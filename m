Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1CCB25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:28:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39886 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1CCB24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:28:56 -0500
Message-ID: <4D6EEEC0.3040001@kernel.org>
Date: Wed, 02 Mar 2011 17:28:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86, numa, emu: only transform numa_distance if SLIT
 is there
References: <4D6EEDF2.6090201@kernel.org>
In-Reply-To: <4D6EEDF2.6090201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D6EEECB.00C0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


during copying should only copy with NEW numa_dist_cnt size.
need to call numa_alloc_dist() at first,  and it will set default values.

So we will not need to go over the big matrix without meaning.

Need to make numa_alloc_distance to return new numa_dist_cnt

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa_64.c        |    4 +--
 arch/x86/mm/numa_emulation.c |   45 ++++++++++++++++++++++++++-----------------
 arch/x86/mm/numa_internal.h  |    1 
 3 files changed, 31 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -399,7 +399,7 @@ void __init numa_reset_distance(void)
 	numa_distance = NULL;	/* enable table creation */
 }
 
-static int __init numa_alloc_distance(void)
+int __init numa_alloc_distance(void)
 {
 	nodemask_t nodes_parsed;
 	size_t size;
@@ -435,7 +435,7 @@ static int __init numa_alloc_distance(vo
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
@@ -301,7 +301,7 @@ void __init numa_emulation(struct numa_m
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
 	size_t phys_size = 0;
-	int i, j, ret;
+	int i, j, ret, new_nr;
 
 	if (!emu_cmdline)
 		goto no_emu;
@@ -380,28 +380,39 @@ void __init numa_emulation(struct numa_m
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = 0;
 
+	/* Transform distance table */
+	numa_reset_distance();
 	/*
-	 * Transform distance table.  numa_set_distance() ignores all
-	 * out-of-bound distances.  Just call it for every possible node
-	 * combination.
+	 * allocate numa_distance at first,
+	 *  it will set new numa_dist_cnt and default values
 	 */
-	numa_reset_distance();
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
+	new_nr = numa_alloc_distance();
+	if (new_nr < 0)
+		goto free_temp_phys;
+
+	/*
+	 * only set it when we have old phys_dist,
+	 * numa_alloc_distance() already set default values
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
 
+free_temp_phys:
 	/* free the copied physical distance table */
 	if (phys_dist)
 		memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
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
