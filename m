Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab1BPM1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:27:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064Ab1BPMVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=i2gWhqHsPep/gwbTsNlAQgchU1LJPyLk8P1Z4XD7ge94Zeb30lvXqiyC3YyChxgPFE
         lJA3+EPkO+4xee4fNMhJqDOgtvmEJjPqr2NdBnH4ZNCP2NsvBXTwYdY7vk5LvVFMSBPA
         SwxMj6CTrGPM5yIjmHo5DYhToyLQGVcWIme2Q=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/33] x86, NUMA: Move *_numa_init() invocations into initmem_init()
Date: Wed, 16 Feb 2011 13:20:40 +0100
Message-Id: <1297858867-25981-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for these to live in setup_arch().  Move them inside
initmem_init().

- v2: x86-32 initmem_init() weren't updated breaking 32bit builds.
  Fixed.  Found by Ankita.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h |    2 +-
 arch/x86/kernel/setup.c           |   16 +---------------
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/numa_32.c             |    2 +-
 arch/x86/mm/numa_64.c             |   16 +++++++++++++++-
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index eb9ed00..97e6007 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -56,7 +56,7 @@ extern unsigned long init_memory_mapping(unsigned long start,
 
 void init_memory_mapping_high(void);
 
-extern void initmem_init(int acpi, int k8);
+extern void initmem_init(void);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c9a139c..46e684f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -719,8 +719,6 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
-	int acpi = 0;
-	int amd = 0;
 	unsigned long flags;
 
 #ifdef CONFIG_X86_32
@@ -991,19 +989,7 @@ void __init setup_arch(char **cmdline_p)
 
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
index 04cc027..4f1f461 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -603,7 +603,7 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(int acpi, int k8)
+void __init initmem_init(void)
 {
 	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
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
index a083f51..656b0cf 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/sched.h>
+#include <linux/acpi.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -579,10 +580,23 @@ static int __init numa_emulation(unsigned long start_pfn,
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

