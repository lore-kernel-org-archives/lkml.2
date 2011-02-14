Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1BNNwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:52:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1BNNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EscxI2X2rQYf9dxszSicScMuyb5HfTItGUPZjKakNBXg+Hhp/0mEUApdc2qHDBU8Ak
         /wf+k5Bei7oKUllcrxczxeH3EVX4xrLgcSOnDx6OMyjNNfjkU3JnQpdaPvnY+M7tLHkt
         0MGDQ+OcEzqr6aavlB7r70thMVIekIHH+goMc=
Date: Mon, 14 Feb 2011 14:51:52 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Subject: [PATCH UPDATED 06/26] x86, NUMA: Move *_numa_init() invocations
 into initmem_init()
Message-ID: <20110214135152.GK18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297530663-26234-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for these to live in setup_arch().  Move them inside
initmem_init().

* x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ankita Garg <ankita@in.ibm.com>
---
Updated to convert 32bit initmem_init() too.  Both parameters weren't
being used in 32bit versions.  git tree updated accordingly.

Thanks.

 arch/x86/include/asm/page_types.h |    2 +-
 arch/x86/kernel/setup.c           |   16 +---------------
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/numa_32.c             |    2 +-
 arch/x86/mm/numa_64.c             |   16 +++++++++++++++-
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 95892a1..c157986 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -48,7 +48,7 @@ extern unsigned long max_pfn_mapped;
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-extern void initmem_init(int acpi, int k8);
+extern void initmem_init(void);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f69d838..9907b45 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -704,8 +704,6 @@ static u64 __init get_max_mapped(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	int acpi = 0;
-	int amd = 0;
 	unsigned long flags;
 
 #ifdef CONFIG_X86_32
@@ -984,19 +982,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
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
-	initmem_init(acpi, amd);
+	initmem_init();
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 16adb66..5d43fa5 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -644,7 +644,7 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init initmem_init(int acpi, int k8)
+void __init initmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 26e4e73..2f333d4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -612,7 +612,7 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(int acpi, int k8)
+void __init initmem_init(void)
 {
 	memblock_x86_register_active_regions(0, 0, max_pfn);
 }
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3249b37..bde3906 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -352,7 +352,7 @@ static void init_remap_allocator(int nid)
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-void __init initmem_init(int acpi, int k8)
+void __init initmem_init(void)
 {
 	int nid;
 	long kva_target_pfn;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 85561d1..4105728 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/sched.h>
+#include <linux/acpi.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -578,10 +579,23 @@ static int __init numa_emulation(unsigned long start_pfn,
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(int acpi, int amd)
+void __init initmem_init(void)
 {
+	int acpi = 0, amd = 0;
 	int i;
 
+#ifdef CONFIG_ACPI_NUMA
+	/*
+	 * Parse SRAT to discover nodes.
+	 */
+	acpi = !x86_acpi_numa_init();
+#endif
+
+#ifdef CONFIG_AMD_NUMA
+	if (!acpi)
+		amd = !amd_numa_init();
+#endif
+
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 
-- 
1.7.1

