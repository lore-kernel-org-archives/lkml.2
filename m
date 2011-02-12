Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1BLRMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:12:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1BLRLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wibYkTQ4h0oXmjOUNx6K9GYzoQcwy+47atQjSwQNd2hzsXKV/ugPbjuHur8HzB5whn
         kRLGNtgfa7z7sRljOcmlIv93P3zbz2VSMSrLqVQKwP3BxgUnFSCAPE1bNFRdaWSQeof0
         u2k9ZV5oEo/Nz3TIJEm6iyjtTweWod4O/AsAU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/26] x86-64, NUMA: Drop @start/last_pfn from initmem_init()
Date: Sat, 12 Feb 2011 18:10:40 +0100
Message-Id: <1297530663-26234-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initmem_init() extensively accesses and modifies global data
structures and the parameters aren't even followed depending on which
path is being used.  Drop @start/last_pfn and let it deal with
@max_pfn directly.  This is in preparation for further NUMA init
cleanups.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h |    3 +--
 arch/x86/kernel/setup.c           |    2 +-
 arch/x86/mm/init_64.c             |    5 ++---
 arch/x86/mm/numa_64.c             |   21 ++++++++-------------
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 1df6621..95892a1 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -48,8 +48,7 @@ extern unsigned long max_pfn_mapped;
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8);
+extern void initmem_init(int acpi, int k8);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1202341..c50ba3d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -996,7 +996,7 @@ void __init setup_arch(char **cmdline_p)
 		amd = !amd_numa_init(0, max_pfn);
 #endif
 
-	initmem_init(0, max_pfn, acpi, amd);
+	initmem_init(acpi, amd);
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..26e4e73 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -612,10 +612,9 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(int acpi, int k8)
 {
-	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
 }
 #endif
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index ea5dd48..f534feb 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -578,8 +578,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
-				int acpi, int amd)
+void __init initmem_init(int acpi, int amd)
 {
 	int i;
 
@@ -587,19 +586,16 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
-	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
-			acpi, amd);
-	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
+	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
+	if (cmdline && !numa_emulation(0, max_pfn, acpi, amd))
 		return;
-	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
-			acpi, amd);
+	setup_physnodes(0, max_pfn << PAGE_SHIFT, acpi, amd);
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
-						  last_pfn << PAGE_SHIFT))
+	if (!numa_off && acpi && !acpi_scan_nodes(0, max_pfn << PAGE_SHIFT))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
@@ -615,8 +611,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
 
 	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       start_pfn << PAGE_SHIFT,
-	       last_pfn << PAGE_SHIFT);
+	       0LU, max_pfn << PAGE_SHIFT);
 	/* setup dummy node covering all memory */
 	memnode_shift = 63;
 	memnodemap = memnode.embedded_map;
@@ -625,8 +620,8 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	node_set(0, node_possible_map);
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
-	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
-	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
+	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
 	numa_init_array();
 }
 
-- 
1.7.1

