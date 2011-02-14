Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1BNNvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:51:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1BNNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XhKT9r8WgCW/tL+doGL4/URFnW2eX1Tzt/9zBNFr5zduTUc453Opd0fT087OHhoGun
         Zn3DEUI9O3H4ZnCb8DXr+YE0tQVMTRe678Njpel/xtMv/6xGlhBxqVblBetYIkWLUWrH
         TrpgOdMcQzExrW1gTUq2jvD8C90PXIfy1HmQk=
Date: Mon, 14 Feb 2011 14:50:52 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Subject: [PATCH UPDATED 03/26] x86, NUMA: Drop @start/last_pfn from
 initmem_init() initmem_init()
Message-ID: <20110214135052.GJ18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297530663-26234-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initmem_init() extensively accesses and modifies global data
structures and the parameters aren't even followed depending on which
path is being used.  Drop @start/last_pfn and let it deal with
@max_pfn directly.  This is in preparation for further NUMA init
cleanups.

* x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
Updated to convert 32bit initmem_init()'s which didn't use the two
parameters at all.  git tree updated accordingly.

Thanks.

 arch/x86/include/asm/page_types.h |    3 +--
 arch/x86/kernel/setup.c           |    2 +-
 arch/x86/mm/init_32.c             |    3 +--
 arch/x86/mm/init_64.c             |    5 ++---
 arch/x86/mm/numa_32.c             |    3 +--
 arch/x86/mm/numa_64.c             |   21 ++++++++-------------
 6 files changed, 14 insertions(+), 23 deletions(-)

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

