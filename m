Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab1D2Pd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:33:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab1D2P27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Sq/AyZpAxGNJzdssV/ud8oBoa3poiH0OOg/JI2TpmzN22nQL1ac1Qg1G0FFfx33E2R
         eO0ZVPxNAcjF1eMt/vkH2NUIyS9MuUOsdzbJjeMXfs56kVSv+vSaMaJ5U4UQDMt/6nho
         hExClZ+hPg+BkebF+p5NJUJY7P/AS65ybGmug=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/25] x86, NUMA: Unify 32/64bit numa_cpu_node() implementation
Date: Fri, 29 Apr 2011 17:28:24 +0200
Message-Id: <1304090924-8197-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the only meaningful user of apic->x86_32_numa_cpu_node() is
NUMAQ which returns valid mapping only after CPU is initialized during
SMP bringup; thus, the previous patch to set apicid -> node in
setup_local_APIC() makes __apicid_to_node[] always contain the correct
mapping whether custom apic->x86_32_numa_cpu_node() is used or not.

So, there is no reason to keep separate 32bit implementation.  We can
always consult __apicid_to_node[].  Move 64bit implementation from
numa_64.c to numa.c and remove 32bit implementation from numa_32.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numa.h    |   10 ++++++++++
 arch/x86/include/asm/numa_32.h |    6 ------
 arch/x86/include/asm/numa_64.h |    3 ---
 arch/x86/mm/numa.c             |    9 +++++++++
 arch/x86/mm/numa_32.c          |    5 -----
 arch/x86/mm/numa_64.c          |    9 ---------
 6 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 3d4dab4..b2bd5e6 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_NUMA_H
 #define _ASM_X86_NUMA_H
 
+#include <linux/nodemask.h>
+
 #include <asm/topology.h>
 #include <asm/apicdef.h>
 
@@ -22,10 +24,18 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 {
 	__apicid_to_node[apicid] = node;
 }
+
+extern int __cpuinit numa_cpu_node(int cpu);
+
 #else	/* CONFIG_NUMA */
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
 }
+
+static inline int numa_cpu_node(int cpu)
+{
+	return NUMA_NO_NODE;
+}
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index c6beed1..242522f 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -5,12 +5,6 @@ extern int numa_off;
 
 extern int pxm_to_nid(int pxm);
 
-#ifdef CONFIG_NUMA
-extern int __cpuinit numa_cpu_node(int cpu);
-#else	/* CONFIG_NUMA */
-static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-#endif	/* CONFIG_NUMA */
-
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
 #else
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 344eb17..12461eb 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -26,7 +26,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 extern nodemask_t numa_nodes_parsed __initdata;
 
-extern int __cpuinit numa_cpu_node(int cpu);
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 extern void __init numa_set_distance(int from, int to, int distance);
 
@@ -35,8 +34,6 @@ extern void __init numa_set_distance(int from, int to, int distance);
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
-#else
-static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 #endif
 
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 9559d36..08530e3 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -32,6 +32,15 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
+int __cpuinit numa_cpu_node(int cpu)
+{
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
+}
+
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index c757c0a..e0d9716 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -107,11 +107,6 @@ extern unsigned long highend_pfn, highstart_pfn;
 static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
-int __cpuinit numa_cpu_node(int cpu)
-{
-	return apic->x86_32_numa_cpu_node(cpu);
-}
-
 /*
  * FLAT - support for basic PC memory model with discontig enabled, essentially
  *        a single node with all available processors in it with a flat
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 59d8a1c..3598fbf 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -512,15 +512,6 @@ unsigned long __init numa_free_all_bootmem(void)
 	return pages;
 }
 
-int __cpuinit numa_cpu_node(int cpu)
-{
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-
-	if (apicid != BAD_APICID)
-		return __apicid_to_node[apicid];
-	return NUMA_NO_NODE;
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 int memory_add_physaddr_to_nid(u64 start)
 {
-- 
1.7.1

