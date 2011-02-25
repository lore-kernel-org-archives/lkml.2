Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1BYK7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:59:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32904 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1BYK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nrBNA8JVsVfKEt1xBZqBC5upgWvvfIYkxfWYy1OgUhe39yt4iRr4c5scaQh/squj9u
         3BqeF6zzAgoD5sCtA4aFzWxTEwyhb1Ulp0FygNR/+ELmghblCUOZt1MQJuFW4RVOsAHL
         NnhYlMPi0DrAs7GHTvikSonU7xPpprOUWyl7o=
Date: Fri, 25 Feb 2011 11:58:46 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Fix size of numa_distance array
Message-ID: <20110225105846.GE24828@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <20110224193211.GC15498@elte.hu>
 <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
 <20110225090301.GB24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225090301.GB24828@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:03:01AM +0100, Tejun Heo wrote:
> > I'm running on a 64GB machine with CONFIG_NODES_SHIFT == 10, so 
> > numa=fake=128M would result in 512 nodes.  That's going to require 2MB for 
> > numa_distance (and that's not __initdata).  Before these changes, we 
> > calculated numa_distance() using pxms without this additional mapping, is 
> > there any way to reduce this?  (Admittedly real NUMA machines with 512 
> > nodes wouldn't mind sacrificing 2MB, but we didn't need this before.)
> 
> We can leave the physical distance table unmodified and map through
> emu_nid_to_phys[] while dereferencing.  It just seemed simpler this
> way.  Does it actually matter?  Anyways, I'll give it a shot.  Do you
> guys actually use 512 nodes?

So, the patch looks like the following and it even reduces LOC but I'm
not sure whether I want to apply this.  Previously, once emluation
step is complete, the rest of the system wouldn't care whether nodes
are being emulated or not.  After this change, although it's still
contained in numa_64.c, we end up with some configurations remapped
and some still using physical nodes.  Unless someone tells me that
2MiB is frigging precious on machines with 512 emulated nodes, I don't
think I'm gonna apply this one.

Thanks.

Index: work/arch/x86/mm/numa_internal.h
===================================================================
--- work.orig/arch/x86/mm/numa_internal.h
+++ work/arch/x86/mm/numa_internal.h
@@ -17,15 +17,24 @@ struct numa_meminfo {
 
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
-void __init numa_reset_distance(void);
 
 #ifdef CONFIG_NUMA_EMU
-void __init numa_emulation(struct numa_meminfo *numa_meminfo,
-			   int numa_dist_cnt);
+extern int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+
+void __init numa_emulation(struct numa_meminfo *numa_meminfo);
+
+static inline int numa_nid_to_phys(int nid)
+{
+	return nid == NUMA_NO_NODE ? nid : emu_nid_to_phys[nid];
+}
 #else
 static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
 				  int numa_dist_cnt)
 { }
+static inline int numa_nid_to_phys(int nid)
+{
+	return nid;
+}
 #endif
 
 #endif	/* __X86_MM_NUMA_INTERNAL_H */
Index: work/arch/x86/mm/numa_emulation.c
===================================================================
--- work.orig/arch/x86/mm/numa_emulation.c
+++ work/arch/x86/mm/numa_emulation.c
@@ -9,7 +9,8 @@
 
 #include "numa_internal.h"
 
-static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+
 static char *emu_cmdline __initdata;
 
 void __init numa_emu_cmdline(char *str)
@@ -270,12 +271,10 @@ static int __init split_nodes_size_inter
 /**
  * numa_emulation - Emulate NUMA nodes
  * @numa_meminfo: NUMA configuration to massage
- * @numa_dist_cnt: The size of the physical NUMA distance table
  *
  * Emulate NUMA nodes according to the numa=fake kernel parameter.
  * @numa_meminfo contains the physical memory configuration and is modified
- * to reflect the emulated configuration on success.  @numa_dist_cnt is
- * used to determine the size of the physical distance table.
+ * to reflect the emulated configuration on success.
  *
  * On success, the following modifications are made.
  *
@@ -284,22 +283,18 @@ static int __init split_nodes_size_inter
  * - __apicid_to_node[] is updated such that APIC IDs are mapped to the
  *   emulated nodes.
  *
- * - NUMA distance table is rebuilt to represent distances between emulated
- *   nodes.  The distances are determined considering how emulated nodes
- *   are mapped to physical nodes and match the actual distances.
- *
  * - emu_nid_to_phys[] reflects how emulated nodes are mapped to physical
- *   nodes.  This is used by numa_add_cpu() and numa_remove_cpu().
+ *   nodes.  This is used by numa_add_cpu(), numa_remove_cpu() and to index
+ *   numa_distance table.
  *
  * If emulation is not enabled or fails, emu_nid_to_phys[] is filled with
  * identity mapping and no other modification is made.
  */
-void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
+void __init numa_emulation(struct numa_meminfo *numa_meminfo)
 {
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
-	u8 *phys_dist = NULL;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -336,29 +331,6 @@ void __init numa_emulation(struct numa_m
 		goto no_emu;
 	}
 
-	/*
-	 * Copy the original distance table.  It's temporary so no need to
-	 * reserve it.
-	 */
-	if (numa_dist_cnt) {
-		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
-		u64 phys;
-
-		phys = memblock_find_in_range(0,
-					      (u64)max_pfn_mapped << PAGE_SHIFT,
-					      size, PAGE_SIZE);
-		if (phys == MEMBLOCK_ERROR) {
-			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
-			goto no_emu;
-		}
-		phys_dist = __va(phys);
-
-		for (i = 0; i < numa_dist_cnt; i++)
-			for (j = 0; j < numa_dist_cnt; j++)
-				phys_dist[i * numa_dist_cnt + j] =
-					node_distance(i, j);
-	}
-
 	/* commit */
 	*numa_meminfo = ei;
 
@@ -381,23 +353,6 @@ void __init numa_emulation(struct numa_m
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = 0;
 
-	/* transform distance table */
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
-				dist = phys_dist[physi * numa_dist_cnt + physj];
-
-			numa_set_distance(i, j, dist);
-		}
-	}
 	return;
 
 no_emu:
Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -35,6 +35,15 @@ static unsigned long __initdata nodemap_
 
 static struct numa_meminfo numa_meminfo __initdata;
 
+/*
+ * Table recording distances between nodes.  The distance from node A to
+ * node B, where both A and B are less than numa_distance_cnt, is stored at
+ * numa_distance[A * numa_distance_cnt + B].
+ *
+ * Note that numa_distance table is always indexed by the physical node IDs
+ * even when NUMA emulation is enabled to simplify implementation and avoid
+ * creating large distance table when there are a lot of emulated nodes.
+ */
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
@@ -388,7 +397,7 @@ static void __init numa_nodemask_from_me
  * The current table is freed.  The next numa_set_distance() call will
  * create a new one.
  */
-void __init numa_reset_distance(void)
+static void __init numa_reset_distance(void)
 {
 	size_t size;
 
@@ -471,10 +480,32 @@ void __init numa_set_distance(int from,
 	numa_distance[from * numa_distance_cnt + to] = distance;
 }
 
+/**
+ * __node_distance - Determine NUMA distance from one node to another
+ * @from: the 'from' node
+ * @to: the 'to' node
+ *
+ * Determine the distance from @from to @to.
+ *
+ * RETURNS:
+ * NUMA distance.
+ */
 int __node_distance(int from, int to)
 {
+	/*
+	 * First, convert the nids to physical as numa_distance is always
+	 * indexed with physical nids.
+	 */
+	from = numa_nid_to_phys(from);
+	to = numa_nid_to_phys(to);
+
+	/*
+	 * If either one is beyond the table dimension, just compare the
+	 * physical nids directly and claim LOCAL if they're the same.
+	 */
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
 		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+
 	return numa_distance[from * numa_distance_cnt + to];
 }
 EXPORT_SYMBOL(__node_distance);
@@ -604,7 +635,7 @@ void __init initmem_init(void)
 		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
 			continue;
 
-		numa_emulation(&numa_meminfo, numa_distance_cnt);
+		numa_emulation(&numa_meminfo);
 
 		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
