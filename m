Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab1D2P3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab1D2P3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fExORzjqWDJro3xre9kWI6r+jBMdKxtxxJ0Rq1nN6/6gh++eWLFMUs77g7u7F3wbpy
         rncCx7qFyh7amhsPDqL9nuWcwbYpu7Urvqn1wycJh9bOPJ+JwHUGHx0Mk3jpO1gFpOqY
         /MoJxznke/P+CVNiVIdMTz5F0ZNUGdJvVgx2M=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/25] x86-32, NUMA: Update numaq to use new NUMA init protocol
Date: Fri, 29 Apr 2011 17:28:34 +0200
Message-Id: <1304090924-8197-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update numaq such that it calls numa_add_memblk() and sets
numa_nodes_parsed instead of directly diddling with NUMA states.  The
original get_memcfg_numaq() is renamed to numaq_numa_init() and new
get_memcfg_numaq() is created in numa_32.c.

The shim numa_add_memblk() implementation handles node_start/end_pfn[]
and node_set_online() for nodes with memory.  The new
get_memcfg_numaq() exactly the same with get_memcfg_from_srat() other
than calling the numaq init function.  Things get_memcfgs_numaq() do
are not strictly necessary for numaq but added for consistency and to
help unifying NUMA init handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numaq.h    |    7 +------
 arch/x86/kernel/apic/numaq_32.c |   28 ++++++++++------------------
 arch/x86/mm/numa_32.c           |   23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/numaq.h b/arch/x86/include/asm/numaq.h
index 37c5165..c3b3c32 100644
--- a/arch/x86/include/asm/numaq.h
+++ b/arch/x86/include/asm/numaq.h
@@ -29,7 +29,7 @@
 #ifdef CONFIG_X86_NUMAQ
 
 extern int found_numaq;
-extern int get_memcfg_numaq(void);
+extern int numaq_numa_init(void);
 extern int pci_numaq_init(void);
 
 extern void *xquad_portio;
@@ -166,11 +166,6 @@ struct sys_cfg_data {
 
 void numaq_tsc_disable(void);
 
-#else
-static inline int get_memcfg_numaq(void)
-{
-	return 0;
-}
 #endif /* CONFIG_X86_NUMAQ */
 #endif /* _ASM_X86_NUMAQ_H */
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 41b8b29..30f1331 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -48,8 +48,6 @@
 #include <asm/e820.h>
 #include <asm/ipi.h>
 
-#define	MB_TO_PAGES(addr)		((addr) << (20 - PAGE_SHIFT))
-
 int found_numaq;
 
 /*
@@ -79,25 +77,20 @@ int					quad_local_to_mp_bus_id[NR_CPUS/4][4];
 static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 {
 	struct eachquadmem *eq = scd->eq + node;
+	u64 start = (u64)(eq->hi_shrd_mem_start - eq->priv_mem_size) << 20;
+	u64 end = (u64)(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size) << 20;
+	int ret;
 
-	node_set_online(node);
-
-	/* Convert to pages */
-	node_start_pfn[node] =
-		 MB_TO_PAGES(eq->hi_shrd_mem_start - eq->priv_mem_size);
-
-	node_end_pfn[node] =
-		 MB_TO_PAGES(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size);
-
-	memblock_x86_register_active_regions(node, node_start_pfn[node],
-						node_end_pfn[node]);
+	node_set(node, numa_nodes_parsed);
+	ret = numa_add_memblk(node, start, end);
+	BUG_ON(ret < 0);
 }
 
 /*
  * Function: smp_dump_qct()
  *
  * Description: gets memory layout from the quad config table.  This
- * function also updates node_online_map with the nodes (quads) present.
+ * function also updates numa_nodes_parsed with the nodes (quads) present.
  */
 static void __init smp_dump_qct(void)
 {
@@ -106,7 +99,6 @@ static void __init smp_dump_qct(void)
 
 	scd = (void *)__va(SYS_CFG_DATA_PRIV_ADDR);
 
-	nodes_clear(node_online_map);
 	for_each_node(node) {
 		if (scd->quads_present31_0 & (1 << node))
 			numaq_register_node(node, scd);
@@ -276,14 +268,14 @@ static __init void early_check_numaq(void)
 	}
 }
 
-int __init get_memcfg_numaq(void)
+int __init numaq_numa_init(void)
 {
 	early_check_numaq();
 	if (!found_numaq)
-		return 0;
+		return -ENOENT;
 	smp_dump_qct();
 
-	return 1;
+	return 0;
 }
 
 #define NUMAQ_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 8641239..14135e5 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -332,6 +332,29 @@ static __init void init_alloc_remap(int nid)
 	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
 }
 
+static int get_memcfg_numaq(void)
+{
+#ifdef CONFIG_X86_NUMAQ
+	int nid;
+
+	if (numa_off)
+		return 0;
+
+	if (numaq_numa_init() < 0) {
+		nodes_clear(numa_nodes_parsed);
+		remove_all_active_ranges();
+		return 0;
+	}
+
+	for_each_node_mask(nid, numa_nodes_parsed)
+		node_set_online(nid);
+	sort_node_map();
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 static int get_memcfg_from_srat(void)
 {
 #ifdef CONFIG_ACPI_NUMA
-- 
1.7.1

