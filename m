Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab1BPMVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab1BPMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=oFsM0KpQKw7o6yV5ef/MK+flC1oh7843X/vRv6vlWpJBzQGe7Nj3SPYD/4d+NQkKWw
         B7m4rAsdB1GSAhoDVq3SqukCwIcnR6tePXugmPfWdBB5ovJu36VzwCar/Q7aKS/+fBiu
         nPPB22wKfSegPxpdt+qnF4yQudjuT1IfSeN9k=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/33] x86, NUMA: Drop @start/last_pfn from initmem_init()
Date: Wed, 16 Feb 2011 13:20:37 +0100
Message-Id: <1297858867-25981-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initmem_init() extensively accesses and modifies global data
structures and the parameters aren't even followed depending on which
path is being used.  Drop @start/last_pfn and let it deal with
@max_pfn directly.  This is in preparation for further NUMA init
cleanups.

- v2: x86-32 initmem_init() weren't updated breaking 32bit builds.
  Fixed.  Found by Yinghai.

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
 arch/x86/mm/init_32.c             |    3 +--
 arch/x86/mm/init_64.c             |    5 ++---
 arch/x86/mm/numa_32.c             |    3 +--
 arch/x86/mm/numa_64.c             |   21 ++++++++-------------
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 731d211..eb9ed00 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -56,8 +56,7 @@ extern unsigned long init_memory_mapping(unsigned long start,
 
 void init_memory_mapping_high(void);
 
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8);
+extern void initmem_init(int acpi, int k8);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ac909ba..756d640 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1003,7 +1003,7 @@ void __init setup_arch(char **cmdline_p)
 		amd = !amd_numa_init(0, max_pfn);
 #endif
 
-	initmem_init(0, max_pfn, acpi, amd);
+	initmem_init(acpi, amd);
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c821074..16adb66 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -644,8 +644,7 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(int acpi, int k8)
 {
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 194f273..04cc027 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -603,10 +603,9 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(int acpi, int k8)
 {
-	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
 }
 #endif
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 505bb04..3249b37 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -352,8 +352,7 @@ static void init_remap_allocator(int nid)
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(int acpi, int k8)
 {
 	int nid;
 	long kva_target_pfn;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index b7d78d7..d7e4aaf 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -579,8 +579,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
-				int acpi, int amd)
+void __init initmem_init(int acpi, int amd)
 {
 	int i;
 
@@ -588,19 +587,16 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
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
@@ -616,8 +612,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
 
 	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       start_pfn << PAGE_SHIFT,
-	       last_pfn << PAGE_SHIFT);
+	       0LU, max_pfn << PAGE_SHIFT);
 	/* setup dummy node covering all memory */
 	memnode_shift = 63;
 	memnodemap = memnode.embedded_map;
@@ -626,9 +621,9 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	node_set(0, node_possible_map);
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
-	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
-	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
 	numa_init_array();
 }
 
-- 
1.7.1

