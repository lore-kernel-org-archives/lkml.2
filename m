Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1BLRMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:12:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1BLRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nAnkB1Olfv5G1m9omxIv6AxF9HJLMz5z8zMCqRZwzIvOqK3kU1iskscHV/3ZXQYYAL
         Gon+ijVZdYkRpFeg0EEmNiieD5jD1A+s9R951Yywi2cxCpr+9YkjB6/vmfSzSOjsO3Sl
         n9VmF7Ab0RpH+G6eyXYybd5UQSDUUtm0klZLA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/26] x86-64, NUMA: Move *_numa_init() invocations into initmem_init()
Date: Sat, 12 Feb 2011 18:10:43 +0100
Message-Id: <1297530663-26234-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for these to live in setup_arch().  Move them inside
initmem_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
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
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/numa_64.c             |   16 +++++++++++++++-
 4 files changed, 18 insertions(+), 18 deletions(-)

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

