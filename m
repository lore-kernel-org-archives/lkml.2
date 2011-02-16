Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab1BPMYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:24:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab1BPMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ved6J5NFvrIlLE/9v3DXoeirZ07YexAV79SvVNytlpQKG7Ldr0dWQYqcNjgjfUWXRP
         uWDJR75lpDU18RfQSpALrh37of9m9d8Gj7xGOuUsH2+zmj0gdMCc+e/9ZlOIhAW03WfL
         qv+BW7Zxsi3ooXukNLuvcIcqQn7CB4sLlcwUc=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/33] x86-64, NUMA: Implement generic node distance handling
Date: Wed, 16 Feb 2011 13:21:00 +0100
Message-Id: <1297858867-25981-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Node distance either used direct node comparison, ACPI PXM comparison
or ACPI SLIT table lookup.  This patch implements generic node
distance handling.  NUMA init methods can call numa_set_distance() to
set distance between nodes and the common __node_distance()
implementation will report the set distance.

Due to the way NUMA emulation is implemented, the generic node
distance handling is used only when emulation is not used.  Later
patches will update NUMA emulation to use the generic distance
mechanism.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h     |    1 +
 arch/x86/include/asm/numa_64.h  |    1 +
 arch/x86/include/asm/topology.h |    2 +-
 arch/x86/mm/numa_64.c           |   95 +++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/srat_64.c           |   27 +++++-------
 5 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index cfa3d5c..9c9fe1b 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -190,6 +190,7 @@ extern int x86_acpi_numa_init(void);
 #ifdef CONFIG_NUMA_EMU
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
+extern int acpi_emu_node_distance(int a, int b);
 #endif
 #endif /* CONFIG_ACPI_NUMA */
 
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 04e74d8..972af9d 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -29,6 +29,7 @@ extern nodemask_t numa_nodes_parsed __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern void __init numa_set_distance(int from, int to, int distance);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b101c17..910a708 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -138,7 +138,7 @@ extern unsigned long node_remap_size[];
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64_ACPI_NUMA
+#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8b1f178..a3621f2 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -45,6 +45,13 @@ static unsigned long __initdata nodemap_size;
 
 static struct numa_meminfo numa_meminfo __initdata;
 
+static int numa_distance_cnt;
+static u8 *numa_distance;
+
+#ifdef CONFIG_NUMA_EMU
+static bool numa_emu_dist;
+#endif
+
 /*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
@@ -357,6 +364,92 @@ static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
 }
 
 /*
+ * Reset distance table.  The current table is freed.  The next
+ * numa_set_distance() call will create a new one.
+ */
+static void __init numa_reset_distance(void)
+{
+	size_t size;
+
+	size = numa_distance_cnt * sizeof(numa_distance[0]);
+	memblock_x86_free_range(__pa(numa_distance),
+				__pa(numa_distance) + size);
+	numa_distance = NULL;
+	numa_distance_cnt = 0;
+}
+
+/*
+ * Set the distance between node @from to @to to @distance.  If distance
+ * table doesn't exist, one which is large enough to accomodate all the
+ * currently known nodes will be created.
+ */
+void __init numa_set_distance(int from, int to, int distance)
+{
+	if (!numa_distance) {
+		nodemask_t nodes_parsed;
+		size_t size;
+		int i, j, cnt = 0;
+		u64 phys;
+
+		/* size the new table and allocate it */
+		nodes_parsed = numa_nodes_parsed;
+		numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
+
+		for_each_node_mask(i, nodes_parsed)
+			cnt = i;
+		size = ++cnt * sizeof(numa_distance[0]);
+
+		phys = memblock_find_in_range(0,
+					      (u64)max_pfn_mapped << PAGE_SHIFT,
+					      size, PAGE_SIZE);
+		if (phys == MEMBLOCK_ERROR) {
+			pr_warning("NUMA: Warning: can't allocate distance table!\n");
+			/* don't retry until explicitly reset */
+			numa_distance = (void *)1LU;
+			return;
+		}
+		memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+
+		numa_distance = __va(phys);
+		numa_distance_cnt = cnt;
+
+		/* fill with the default distances */
+		for (i = 0; i < cnt; i++)
+			for (j = 0; j < cnt; j++)
+				numa_distance[i * cnt + j] = i == j ?
+					LOCAL_DISTANCE : REMOTE_DISTANCE;
+		printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+	}
+
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+			    from, to, distance);
+		return;
+	}
+
+	if ((u8)distance != distance ||
+	    (from == to && distance != LOCAL_DISTANCE)) {
+		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
+			     from, to, distance);
+		return;
+	}
+
+	numa_distance[from * numa_distance_cnt + to] = distance;
+}
+
+int __node_distance(int from, int to)
+{
+#if defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA_EMU)
+	if (numa_emu_dist)
+		return acpi_emu_node_distance(from, to);
+#endif
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+	return numa_distance[from * numa_distance_cnt + to];
+}
+EXPORT_SYMBOL(__node_distance);
+
+/*
  * Sanity check to catch more bad NUMA configurations (they are amazingly
  * common).  Make sure the nodes cover all memory.
  */
@@ -826,6 +919,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	setup_physnodes(addr, max_addr);
 	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
+	numa_emu_dist = true;
 	return 0;
 }
 #endif /* CONFIG_NUMA_EMU */
@@ -869,6 +963,7 @@ void __init initmem_init(void)
 		nodes_clear(node_online_map);
 		memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 		remove_all_active_ranges();
+		numa_reset_distance();
 
 		if (numa_init[i]() < 0)
 			continue;
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 4f8e6cd..d2f53f3 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -50,9 +50,16 @@ static __init inline int srat_disabled(void)
 /* Callback for SLIT parsing */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
+	int i, j;
 	unsigned length;
 	unsigned long phys;
 
+	for (i = 0; i < slit->locality_count; i++)
+		for (j = 0; j < slit->locality_count; j++)
+			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+				slit->entry[slit->locality_count * i + j]);
+
+	/* acpi_slit is used only by emulation */
 	length = slit->header.length;
 	phys = memblock_find_in_range(0, max_pfn_mapped<<PAGE_SHIFT, length,
 		 PAGE_SIZE);
@@ -313,29 +320,17 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 			node_set(i, numa_nodes_parsed);
 }
 
-static int null_slit_node_compare(int a, int b)
-{
-	return node_to_pxm(a) == node_to_pxm(b);
-}
-#else
-static int null_slit_node_compare(int a, int b)
-{
-	return a == b;
-}
-#endif /* CONFIG_NUMA_EMU */
-
-int __node_distance(int a, int b)
+int acpi_emu_node_distance(int a, int b)
 {
 	int index;
 
 	if (!acpi_slit)
-		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
-						      REMOTE_DISTANCE;
+		return node_to_pxm(a) == node_to_pxm(b) ?
+			LOCAL_DISTANCE : REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
-
-EXPORT_SYMBOL(__node_distance);
+#endif /* CONFIG_NUMA_EMU */
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
 int memory_add_physaddr_to_nid(u64 start)
-- 
1.7.1

