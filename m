Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab1BPM12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:27:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab1BPMV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=al81MemWc1nOcq3ORUkh6+16gf9Q7BLjiWRgE81mYITCs9WLQVNrD5QdWT6ub833dJ
         I6sMQqkqqukaRMqG9SOn1yHmYRt7DHQoYlLfeQ9kGs+132I+FRLLoJQpu5G4wdXDmuQU
         zWxGWvwN4/pn3zaGMtZU7CjSutmM6TVGgMs9o=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/33] x86-64, NUMA: Restructure initmem_init()
Date: Wed, 16 Feb 2011 13:20:41 +0100
Message-Id: <1297858867-25981-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize initmem_init() such that,

* Different NUMA init methods are iterated in a consistent way.

* Each iteration re-initializes all the parameters and different
  method can be tried after a failure.

* Dummy init is handled the same as other methods.

Apart from how retry after failure, this patch doesn't change the
behavior.  The call sequences are kept equivalent across the
conversion.

After the change, bad_srat() doesn't need to clear apic to node
mapping or worry about numa_off.  Simplified accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   94 ++++++++++++++++++++++++++----------------------
 arch/x86/mm/srat_64.c |    4 +--
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 656b0cf..c984e34 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -580,65 +580,73 @@ static int __init numa_emulation(unsigned long start_pfn,
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(void)
+static int dummy_numa_init(void)
 {
-	int acpi = 0, amd = 0;
-	int i;
-
-#ifdef CONFIG_ACPI_NUMA
-	/*
-	 * Parse SRAT to discover nodes.
-	 */
-	acpi = !x86_acpi_numa_init();
-#endif
-
-#ifdef CONFIG_AMD_NUMA
-	if (!acpi)
-		amd = !amd_numa_init();
-#endif
-
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-
-#ifdef CONFIG_NUMA_EMU
-	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
-	if (cmdline && !numa_emulation(0, max_pfn, acpi, amd))
-		return;
-	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
-
-#ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && acpi && !acpi_scan_nodes())
-		return;
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
+	return 0;
+}
 
-#ifdef CONFIG_AMD_NUMA
-	if (!numa_off && amd && !amd_scan_nodes())
-		return;
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
+static int dummy_scan_nodes(void)
+{
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-
 	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
 	       0LU, max_pfn << PAGE_SHIFT);
+
 	/* setup dummy node covering all memory */
 	memnode_shift = 63;
 	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		set_apicid_to_node(i, NUMA_NO_NODE);
 	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
 	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
 	numa_init_array();
+
+	return 0;
+}
+
+void __init initmem_init(void)
+{
+	int (*numa_init[])(void) = { [2] = dummy_numa_init };
+	int (*scan_nodes[])(void) = { [2] = dummy_scan_nodes };
+	int i, j;
+
+	if (!numa_off) {
+#ifdef CONFIG_ACPI_NUMA
+		numa_init[0] = x86_acpi_numa_init;
+		scan_nodes[0] = acpi_scan_nodes;
+#endif
+#ifdef CONFIG_AMD_NUMA
+		numa_init[1] = amd_numa_init;
+		scan_nodes[1] = amd_scan_nodes;
+#endif
+	}
+
+	for (i = 0; i < ARRAY_SIZE(numa_init); i++) {
+		if (!numa_init[i])
+			continue;
+
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			set_apicid_to_node(j, NUMA_NO_NODE);
+
+		nodes_clear(node_possible_map);
+		nodes_clear(node_online_map);
+
+		if (numa_init[i]() < 0)
+			continue;
+#ifdef CONFIG_NUMA_EMU
+		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
+		if (cmdline && !numa_emulation(0, max_pfn, i == 0, i == 1))
+			return;
+		setup_physnodes(0, max_pfn << PAGE_SHIFT, i == 0, i == 1);
+		nodes_clear(node_possible_map);
+		nodes_clear(node_online_map);
+#endif
+		if (!scan_nodes[i]())
+			return;
+	}
+	BUG();
 }
 
 unsigned long __init numa_free_all_bootmem(void)
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 56b9263..597e011 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -78,8 +78,6 @@ static __init void bad_srat(void)
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		set_apicid_to_node(i, NUMA_NO_NODE);
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		nodes[i].start = nodes[i].end = 0;
 		nodes_add[i].start = nodes_add[i].end = 0;
@@ -89,7 +87,7 @@ static __init void bad_srat(void)
 
 static __init inline int srat_disabled(void)
 {
-	return numa_off || acpi_numa < 0;
+	return acpi_numa < 0;
 }
 
 /* Callback for SLIT parsing */
-- 
1.7.1

