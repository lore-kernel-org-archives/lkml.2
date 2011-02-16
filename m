Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1BPMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:23:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab1BPMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:22:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=blXr6i+dhzkvr2SWi8kaRcUOfuhd2n3Nd0K4s5pqxi2245fbBmvfN8WEaeIXxBGmOK
         5QovhsrjF1Qgu4bHlkEMq8qills7VBVvBsqUxbx4Y52wU0bpJ7LkrxNLe8vRVTsn21Bw
         CD8FaHAyj09drpvg956BP3TjIbcmui3YPpF/A=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/33] x86-64, NUMA: Unify emulated distance mapping
Date: Wed, 16 Feb 2011 13:21:07 +0100
Message-Id: <1297858867-25981-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA emulation needs to update node distance information.  It did it
by remapping apicid to PXM mapping, even when amdtopology is being
used.  There is no reason to go through such convolution.  The generic
code has all the information necessary to transform the distance table
to the emulated nid space.

Implement generic distance table transformation in numa_emulation()
and drop private implementations in srat_64 and amdtopology_64.  This
makes find_node_by_addr() and fake_physnodes() and related functions
unnecessary, drop them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h    |    6 --
 arch/x86/include/asm/amd_nb.h  |    4 --
 arch/x86/include/asm/numa_64.h |    1 -
 arch/x86/mm/amdtopology_64.c   |   38 ---------------
 arch/x86/mm/numa_64.c          |  102 ++++++++++++++++------------------------
 arch/x86/mm/srat_64.c          |   65 -------------------------
 6 files changed, 40 insertions(+), 176 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 9c9fe1b..a37da6d 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -186,12 +186,6 @@ struct bootnode;
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
-
-#ifdef CONFIG_NUMA_EMU
-extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
-				   int num_nodes);
-extern int acpi_emu_node_distance(int a, int b);
-#endif
 #endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 384d118..e264ae5 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -20,10 +20,6 @@ extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, int);
 
-#ifdef CONFIG_NUMA_EMU
-extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
-#endif
-
 struct amd_northbridge {
 	struct pci_dev *misc;
 	struct pci_dev *link;
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 972af9d..fc71c68 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -35,7 +35,6 @@ extern void __init numa_set_distance(int from, int to, int distance);
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 void numa_emu_cmdline(char *);
-int __init find_node_by_addr(unsigned long addr);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index f37ea2f..0919c26 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -194,41 +194,3 @@ int __init amd_numa_init(void)
 
 	return 0;
 }
-
-#ifdef CONFIG_NUMA_EMU
-/*
- * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
- * setup to represent the physical topology but reflect the emulated
- * environment.  For each emulated node, the real node which it appears on is
- * found and a fake pxm to nid mapping is created which mirrors the actual
- * locality.  node_distance() then represents the correct distances between
- * emulated nodes by using the fake acpi mappings to pxms.
- */
-void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
-{
-	unsigned int bits;
-	unsigned int cores;
-	unsigned int apicid_base = 0;
-	int i;
-
-	bits = boot_cpu_data.x86_coreid_bits;
-	cores = 1 << bits;
-	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0)
-		apicid_base = boot_cpu_physical_apicid;
-
-	for (i = 0; i < nr_nodes; i++) {
-		int index;
-		int nid;
-
-		nid = find_node_by_addr(nodes[i].start);
-		if (nid == NUMA_NO_NODE)
-			continue;
-
-		index = nodeids[nid] << bits;
-#ifdef CONFIG_ACPI_NUMA
-		__acpi_map_pxm_to_node(nid, i);
-#endif
-	}
-}
-#endif /* CONFIG_NUMA_EMU */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 288086c..d52edcc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -48,10 +48,6 @@ static struct numa_meminfo numa_meminfo __initdata;
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
-#ifdef CONFIG_NUMA_EMU
-static bool numa_emu_dist;
-#endif
-
 /*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
@@ -443,10 +439,6 @@ void __init numa_set_distance(int from, int to, int distance)
 
 int __node_distance(int from, int to)
 {
-#if defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA_EMU)
-	if (numa_emu_dist)
-		return acpi_emu_node_distance(from, to);
-#endif
 	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
 		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	return numa_distance[from * numa_distance_cnt + to];
@@ -559,56 +551,6 @@ static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
 	return -ENOENT;
 }
 
-int __init find_node_by_addr(unsigned long addr)
-{
-	const struct numa_meminfo *mi = &numa_meminfo;
-	int i;
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		/*
-		 * Find the real node that this emulated node appears on.  For
-		 * the sake of simplicity, we only use a real node's starting
-		 * address to determine which emulated node it appears on.
-		 */
-		if (addr >= mi->blk[i].start && addr < mi->blk[i].end)
-			return mi->blk[i].nid;
-	}
-	return NUMA_NO_NODE;
-}
-
-static void __init fake_physnodes(int acpi, int amd,
-				  const struct numa_meminfo *ei)
-{
-	static struct bootnode nodes[MAX_NUMNODES] __initdata;
-	int i, nr_nodes = 0;
-
-	for (i = 0; i < ei->nr_blks; i++) {
-		int nid = ei->blk[i].nid;
-
-		if (nodes[nid].start == nodes[nid].end) {
-			nodes[nid].start = ei->blk[i].start;
-			nodes[nid].end = ei->blk[i].end;
-			nr_nodes++;
-		} else {
-			nodes[nid].start = min(ei->blk[i].start, nodes[nid].start);
-			nodes[nid].end = max(ei->blk[i].end, nodes[nid].end);
-		}
-	}
-
-	BUG_ON(acpi && amd);
-#ifdef CONFIG_ACPI_NUMA
-	if (acpi)
-		acpi_fake_nodes(nodes, nr_nodes);
-#endif
-#ifdef CONFIG_AMD_NUMA
-	if (amd)
-		amd_fake_nodes(nodes, nr_nodes);
-#endif
-	if (!acpi && !amd)
-		for (i = 0; i < nr_cpu_ids; i++)
-			numa_set_node(i, 0);
-}
-
 /*
  * Sets up nid to range from @start to @end.  The return value is -errno if
  * something went wrong, 0 otherwise.
@@ -853,11 +795,13 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static bool __init numa_emulation(int acpi, int amd)
+static bool __init numa_emulation(void)
 {
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
+	int phys_dist_cnt = numa_distance_cnt;
+	u8 *phys_dist = NULL;
 	int i, j, ret;
 
 	memset(&ei, 0, sizeof(ei));
@@ -891,6 +835,25 @@ static bool __init numa_emulation(int acpi, int amd)
 		return false;
 	}
 
+	/*
+	 * Copy the original distance table.  It's temporary so no need to
+	 * reserve it.
+	 */
+	if (phys_dist_cnt) {
+		size_t size = phys_dist_cnt * sizeof(numa_distance[0]);
+		u64 phys;
+
+		phys = memblock_find_in_range(0,
+					      (u64)max_pfn_mapped << PAGE_SHIFT,
+					      size, PAGE_SIZE);
+		if (phys == MEMBLOCK_ERROR) {
+			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
+			return false;
+		}
+		phys_dist = __va(phys);
+		memcpy(phys_dist, numa_distance, size);
+	}
+
 	/* commit */
 	numa_meminfo = ei;
 
@@ -913,8 +876,23 @@ static bool __init numa_emulation(int acpi, int amd)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = 0;
 
-	fake_physnodes(acpi, amd, &ei);
-	numa_emu_dist = true;
+	/* transform distance table */
+	numa_reset_distance();
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		for (j = 0; j < MAX_NUMNODES; j++) {
+			int physi = emu_nid_to_phys[i];
+			int physj = emu_nid_to_phys[j];
+			int dist;
+
+			if (physi >= phys_dist_cnt || physj >= phys_dist_cnt)
+				dist = physi == physj ?
+					LOCAL_DISTANCE : REMOTE_DISTANCE;
+			else
+				dist = phys_dist[physi * phys_dist_cnt + physj];
+
+			numa_set_distance(i, j, dist);
+		}
+	}
 	return true;
 }
 #endif /* CONFIG_NUMA_EMU */
@@ -970,7 +948,7 @@ void __init initmem_init(void)
 		 * If requested, try emulation.  If emulation is not used,
 		 * build identity emu_nid_to_phys[] for numa_add_cpu()
 		 */
-		if (!emu_cmdline || !numa_emulation(i == 0, i == 1))
+		if (!emu_cmdline || !numa_emulation())
 			for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
 				emu_nid_to_phys[j] = j;
 #endif
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d4fbfea..8e9d339 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -26,8 +26,6 @@
 
 int acpi_numa __initdata;
 
-static struct acpi_table_slit *acpi_slit;
-
 static struct bootnode nodes_add[MAX_NUMNODES];
 
 static __init int setup_node(int pxm)
@@ -51,25 +49,11 @@ static __init inline int srat_disabled(void)
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
 	int i, j;
-	unsigned length;
-	unsigned long phys;
 
 	for (i = 0; i < slit->locality_count; i++)
 		for (j = 0; j < slit->locality_count; j++)
 			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
 				slit->entry[slit->locality_count * i + j]);
-
-	/* acpi_slit is used only by emulation */
-	length = slit->header.length;
-	phys = memblock_find_in_range(0, max_pfn_mapped<<PAGE_SHIFT, length,
-		 PAGE_SIZE);
-
-	if (phys == MEMBLOCK_ERROR)
-		panic(" Can not save slit!\n");
-
-	acpi_slit = __va(phys);
-	memcpy(acpi_slit, slit, length);
-	memblock_x86_reserve_range(phys, phys + length, "ACPI SLIT");
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
@@ -261,55 +245,6 @@ int __init x86_acpi_numa_init(void)
 	return srat_disabled() ? -EINVAL : 0;
 }
 
-#ifdef CONFIG_NUMA_EMU
-static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
-	[0 ... MAX_NUMNODES-1] = PXM_INVAL
-};
-
-/*
- * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
- * mappings that respect the real ACPI topology but reflect our emulated
- * environment.  For each emulated node, we find which real node it appears on
- * and create PXM to NID mappings for those fake nodes which mirror that
- * locality.  SLIT will now represent the correct distances between emulated
- * nodes as a result of the real topology.
- */
-void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
-{
-	int i;
-
-	for (i = 0; i < num_nodes; i++) {
-		int nid, pxm;
-
-		nid = find_node_by_addr(fake_nodes[i].start);
-		if (nid == NUMA_NO_NODE)
-			continue;
-		pxm = node_to_pxm(nid);
-		if (pxm == PXM_INVAL)
-			continue;
-		fake_node_to_pxm_map[i] = pxm;
-	}
-
-	for (i = 0; i < num_nodes; i++)
-		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-
-	for (i = 0; i < num_nodes; i++)
-		if (fake_nodes[i].start != fake_nodes[i].end)
-			node_set(i, numa_nodes_parsed);
-}
-
-int acpi_emu_node_distance(int a, int b)
-{
-	int index;
-
-	if (!acpi_slit)
-		return node_to_pxm(a) == node_to_pxm(b) ?
-			LOCAL_DISTANCE : REMOTE_DISTANCE;
-	index = acpi_slit->locality_count * node_to_pxm(a);
-	return acpi_slit->entry[index + node_to_pxm(b)];
-}
-#endif /* CONFIG_NUMA_EMU */
-
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
 int memory_add_physaddr_to_nid(u64 start)
 {
-- 
1.7.1

