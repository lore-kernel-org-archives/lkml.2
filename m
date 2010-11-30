Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0K3Iqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:46:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:50859 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab0K3IpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:45:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,279,1288594800"; 
   d="scan'208";a="578932991"
X-Mailbox-Line: From shaohui.zheng@intel.com Tue Nov 30 15:14:36 2010
Message-Id: <20101130071436.836186525@intel.com>
References: <20101130071324.908098411@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 30 Nov 2010 15:13:26 +0800
From: shaohui.zheng@intel.com
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Haicheng Li <haicheng.li@intel.com>
Subject: [2/8, v6] NUMA Hotplug Emulator: Add numa=possible option
Content-Disposition: inline; filename=002-add-node-possible-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  David Rientjes <rientjes@google.com>

Adds a numa=possible=<N> command line option to set an additional N nodes
as being possible for memory hotplug.  This set of possible nodes
controls nr_node_ids and the sizes of several dynamically allocated node
arrays.

This allows memory hotplug to create new nodes for newly added memory
rather than binding it to existing nodes.

The first use-case for this will be node hotplug emulation which will use
these possible nodes to create new nodes to test the memory hotplug
callbacks and surrounding memory hotplug code.

CC: Shaohui Zheng <shaohui.zheng@intel.com>
CC: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86/x86_64/boot-options.txt |    4 ++++
 arch/x86/mm/numa_64.c                     |   18 +++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -174,6 +174,10 @@ NUMA
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
 
+  numa=possible=<N>
+		Sets an additional N nodes as being possible for memory
+		hotplug.
+
 ACPI
 
   acpi=off	Don't enable ACPI
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -33,6 +33,7 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
+static unsigned long __initdata numa_possible_nodes;
 
 /*
  * Map cpu index to node index
@@ -611,7 +612,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -619,14 +620,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 #ifdef CONFIG_ACPI_NUMA
 	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 						  last_pfn << PAGE_SHIFT))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && k8 && !k8_scan_nodes())
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -646,6 +647,15 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 		numa_set_node(i, 0);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+out: __maybe_unused
+	for (i = 0; i < numa_possible_nodes; i++) {
+		int nid;
+
+		nid = first_unset_node(node_possible_map);
+		if (nid == MAX_NUMNODES)
+			break;
+		node_set(nid, node_possible_map);
+	}
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -675,6 +685,8 @@ static __init int numa_setup(char *opt)
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
 #endif
+	if (!strncmp(opt, "possible=", 9))
+		numa_possible_nodes = simple_strtoul(opt + 9, NULL, 0);
 	return 0;
 }
 early_param("numa", numa_setup);

-- 
Thanks & Regards,
Shaohui


