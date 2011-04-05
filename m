Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1DEXRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:17:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41748 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DEXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Jx2VktY5K5hSeAwxWi/UCw3nudc3m/FVXop8nuGm9gvzrEknZd1hJs2BQR8FvVSOB+
         83RSQyCr5J9Rh9Cth9W5/GSZzL8dQvx3wmh7GPtq8PplPDfxMrBZEdWh6UOEMLBWd74Q
         SJujOKBFJyEdNAwuFt6hF4k9pq9+fKGwjm49U=
Date: Tue, 5 Apr 2011 16:17:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/mm] x86-64, NUMA: Simplify hotadd memory handling
Message-ID: <20110405231718.GB21169@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only special handling NUMA needs to do for hotadd memory is
determining the node for the hotadd memory given the address of it and
there's nothing specific to specific config method used.

srat_64.c does somewhat elaborate error checking on
ACPI_SRAT_MEM_HOT_PLUGGABLE regions, remembers them and implements
memory_add_physaddr_to_nid() which determines the node for given
hotadd address.

This is almost completely redundant.  All the information is already
available to the generic NUMA code which already performs all the
sanity checking and merging.  All that's necessary is not using
__initdata from numa_meminfo and providing a function which uses it to
map address to node.

Drop the specific implementation from srat_64.c and add generic
memory_add_physaddr_to_nid() in numa_64.c, which is enabled if
CONFIG_MEMORY_HOTPLUG is set.  Other than dropping the code, srat_64.c
doesn't need any change as it already calls numa_add_memblk() for hot
pluggable regions which is enough.

While at it, change CONFIG_MEMORY_HOTPLUG_SPARSE in srat_64.c to
CONFIG_MEMORY_HOTPLUG, for NUMA on x86-64, the two are always the
same.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/init_64.c |    8 -----
 arch/x86/mm/numa_64.c |   22 +++++++++++++-
 arch/x86/mm/srat_64.c |   78 --------------------------------------------------
 3 files changed, 22 insertions(+), 86 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7942335..0404bb3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -679,14 +679,6 @@ int arch_add_memory(int nid, u64 start, u64 size)
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-#if !defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA)
-int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 static struct kcore_list kcore_vsyscall;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 13f5b06..c4eecc2 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -28,7 +28,12 @@ EXPORT_SYMBOL(node_data);
 
 nodemask_t numa_nodes_parsed __initdata;
 
-static struct numa_meminfo numa_meminfo __initdata;
+static struct numa_meminfo numa_meminfo
+#ifndef CONFIG_MEMORY_HOTPLUG
+__initdata
+#endif
+;
+
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
@@ -540,3 +545,18 @@ int __cpuinit numa_cpu_node(int cpu)
 		return __apicid_to_node[apicid];
 	return NUMA_NO_NODE;
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int memory_add_physaddr_to_nid(u64 start)
+{
+	struct numa_meminfo *mi = &numa_meminfo;
+	int nid = mi->blk[0].nid;
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].start <= start && mi->blk[i].end > start)
+			nid = mi->blk[i].nid;
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 8e9d339..9994d2c 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -26,8 +26,6 @@
 
 int acpi_numa __initdata;
 
-static struct bootnode nodes_add[MAX_NUMNODES];
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -37,7 +35,6 @@ static __init void bad_srat(void)
 {
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	memset(nodes_add, 0, sizeof(nodes_add));
 }
 
 static __init inline int srat_disabled(void)
@@ -131,67 +128,11 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 static inline int save_add_info(void) {return 1;}
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
-/*
- * Update nodes_add[]
- * This code supports one contiguous hot add area per node
- */
-static void __init
-update_nodes_add(int node, unsigned long start, unsigned long end)
-{
-	unsigned long s_pfn = start >> PAGE_SHIFT;
-	unsigned long e_pfn = end >> PAGE_SHIFT;
-	int changed = 0;
-	struct bootnode *nd = &nodes_add[node];
-
-	/* I had some trouble with strange memory hotadd regions breaking
-	   the boot. Be very strict here and reject anything unexpected.
-	   If you want working memory hotadd write correct SRATs.
-
-	   The node size check is a basic sanity check to guard against
-	   mistakes */
-	if ((signed long)(end - start) < NODE_MIN_SIZE) {
-		printk(KERN_ERR "SRAT: Hotplug area too small\n");
-		return;
-	}
-
-	/* This check might be a bit too strict, but I'm keeping it for now. */
-	if (absent_pages_in_range(s_pfn, e_pfn) != e_pfn - s_pfn) {
-		printk(KERN_ERR
-			"SRAT: Hotplug area %lu -> %lu has existing memory\n",
-			s_pfn, e_pfn);
-		return;
-	}
-
-	/* Looks good */
-
-	if (nd->start == nd->end) {
-		nd->start = start;
-		nd->end = end;
-		changed = 1;
-	} else {
-		if (nd->start == end) {
-			nd->start = start;
-			changed = 1;
-		}
-		if (nd->end == start) {
-			nd->end = end;
-			changed = 1;
-		}
-		if (!changed)
-			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
-	}
-
-	if (changed) {
-		node_set(node, numa_nodes_parsed);
-		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
-				 nd->start, nd->end);
-	}
-}
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 void __init
@@ -228,9 +169,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
-
-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
-		update_nodes_add(node, start, end);
 }
 
 void __init acpi_numa_arch_fixup(void) {}
@@ -244,17 +182,3 @@ int __init x86_acpi_numa_init(void)
 		return ret;
 	return srat_disabled() ? -EINVAL : 0;
 }
-
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
-int memory_add_physaddr_to_nid(u64 start)
-{
-	int i, ret = 0;
-
-	for_each_node(i)
-		if (nodes_add[i].start <= start && nodes_add[i].end > start)
-			ret = i;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
